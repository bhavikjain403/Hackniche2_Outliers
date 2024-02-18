import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from '@/components/ui/card';
import {
  MapContainer,
  TileLayer,
  Marker,
  useMapEvent,
  Popup,
} from 'react-leaflet';
import 'leaflet/dist/leaflet.css';
import {
  Dispatch,
  SetStateAction,
  SyntheticEvent,
  useEffect,
  useMemo,
  useRef,
  useState,
} from 'react';
import LoaderSpinner from '@/components/ui/LoaderSpinner';
import { XCircle } from 'lucide-react';
import { Button } from '@/components/ui/button';
import Slider from '@mui/material/Slider';
import { NODEJS_ENDPOINT } from '@/api/endpoints';
import axios from 'axios';
import { toast } from 'sonner';
import { minutesToTime } from '@/lib/utils';

type marker = {
  coordinate: number[];
  startTime: Date;
  endTime: Date;
};

function RouteSelector() {
  const [position, setPosition] = useState([0, 0]);
  const [markers, setMarkers] = useState<marker[]>([]);

  function addMarker(e: SyntheticEvent) {
    console.log(e);
    setMarkers((state) => [
      ...state,
      { coordinate: [e.latlng.lat, e.latlng.lng], startTime: 0, endTime: 1440 },
    ]);
    console.log(markers);
  }

  /* get geolocation */
  useEffect(() => {
    /* TODO: only for debug */
    setPosition([19.1074064, 72.8372358]);
    return;
    if ('geolocation' in navigator && !position[0]) {
      navigator.geolocation.getCurrentPosition(function (position) {
        console.log('location is', position.coords);
        setPosition([position.coords.latitude, position.coords.longitude]);
      });
    } else {
      console.log('Geolocation is not available in your browser.');
    }
  }, []);
  return (
    <div className="flex-col flex">
      <div className="flex-1 space-y-4 p-8 pt-6">
        <div className="flex items-center justify-between space-y-2">
          <h2 className="text-3xl font-bold tracking-tight">Route</h2>
        </div>
        <Card className="w-full">
          <CardHeader>
            <CardTitle>Adjust Route</CardTitle>
            <CardDescription>Manage your food truck's route</CardDescription>
          </CardHeader>
          <CardContent className="h-[70vh] p-2">
            {position[0] ? (
              <MapContainer
                className="h-full overflow-hidden"
                center={position}
                zoom={30}
                scrollWheelZoom={true}
                onClick={(e: SyntheticEvent) => addMarker(e)}
              >
                <MapChildren
                  markers={markers}
                  setMarkers={setMarkers}
                  addMarker={addMarker}
                />
              </MapContainer>
            ) : (
              <LoaderSpinner />
            )}
          </CardContent>
        </Card>
        <Card>
          <CardHeader>
            <CardTitle>Adjust Schedule</CardTitle>
            <CardDescription>Manage your food truck's schedule</CardDescription>
          </CardHeader>
          <CardContent className="space-y-8">
            {markers.map((_, index) => {
              return (
                <CustomSlider
                  setMarkers={setMarkers}
                  index={index}
                  key={index}
                />
              );
            })}
          </CardContent>
          <div className="px-6 mb-4 flex w-full justify-start gap-4 items-center h-full">
            <Button
              className="flex-1"
              onClick={() => {
                const truckId = localStorage.getItem('id');
                console.log(markers);
                const requestBody = { truckId, routeMarker: markers };
                axios
                  .post(NODEJS_ENDPOINT + 'admin/addroutemarker', requestBody)
                  .then(() =>
                    toast('Route added', {
                      description: 'Route and schedule was added successfully!',
                      action: { label: 'Close', onClick: () => null },
                    })
                  );
              }}
            >
              Save Route
            </Button>
            <Button
              variant={'outline'}
              className="flex-1 border-slate-600/20 border-2"
              onClick={() => setMarkers([])}
            >
              Reset Route
            </Button>
          </div>
        </Card>
      </div>
    </div>
  );
}
function MapChildren({
  markers,
  setMarkers,
  addMarker,
}: {
  markers: marker[];
  setMarkers: Dispatch<SetStateAction<marker[]>>;
  addMarker: (e: SyntheticEvent) => void;
}) {
  useMapEvent('click', addMarker);

  return (
    <>
      <TileLayer
        attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
      />
      {markers.map((item: marker, index: number) => {
        return (
          <CustomMarker
            position={item.coordinate}
            index={index}
            key={index}
            setPosition={setMarkers}
          />
        );
      })}
    </>
  );
}

function CustomMarker({
  position,
  index,
  setPosition,
}: {
  position: number[];
  index: number;
  setPosition: Dispatch<SetStateAction<marker[]>>;
}) {
  const markerRef = useRef(null);
  const eventHandlers = useMemo(
    () => ({
      dragend() {
        const marker = markerRef.current;
        if (marker != null) {
          const latlng = marker.getLatLng();
          setPosition((state) => [
            ...state.slice(0, index),
            { ...state[index], coordinate: [latlng.lat, latlng.lng] },
            ...state.slice(index + 1),
          ]);
        }
      },
    }),
    []
  );
  return (
    <Marker
      draggable
      eventHandlers={eventHandlers}
      ref={markerRef}
      position={position}
      // icon={MarkerIcon}
    >
      <Popup>
        {/* <Input type="number" className="border-slate-300 border-2" />{' '}
          <CheckCircle2Icon size={60} className="stroke-green-600" /> */}
        <div className="flex items-center gap-2">
          <p className="text-xl" style={{ margin: 0 }}>
            Marker {index + 1}
          </p>
          <XCircle
            size={30}
            className="stroke-red-600"
            onClick={(e) => {
              e.stopPropagation();
              setPosition((state) => [
                ...state.slice(0, index),
                ...state.slice(index + 1),
              ]);
            }}
          />
        </div>
        {/* </div> */}
      </Popup>
    </Marker>
  );
}

function CustomSlider({ index, setMarkers }) {
  const [value, setValue] = useState([0, 1440]);
  const minDistance = 15;

  const handleChange = (event, newValue, activeThumb) => {
    if (!Array.isArray(newValue)) {
      return;
    }

    if (activeThumb === 0) {
      setMarkers((state) => [
        ...state.slice(0, index),
        {
          ...state[index],
          startTime: Math.min(newValue[0], value[1] - minDistance),
          endTime: value[1],
        },
        ...state.slice(index + 1),
      ]);
      setValue([Math.min(newValue[0], value[1] - minDistance), value[1]]);
    } else {
      setMarkers((state) => [
        ...state.slice(0, index),
        {
          ...state[index],
          startTime: value[0],
          endTime: Math.max(newValue[1], value[0] + minDistance),
        },
        ...state.slice(index + 1),
      ]);
      setValue([value[0], Math.max(newValue[1], value[0] + minDistance)]);
    }
  };
  return (
    <div className="w-full flex flex-col">
      <h1>Marker {index + 1}</h1>
      <Slider
        value={value}
        onChange={handleChange}
        valueLabelDisplay="auto"
        valueLabelFormat={(e) => minutesToTime(e)}
        max={1440}
        step={15}
        disableSwap
      />
    </div>
  );
}

export default RouteSelector;
