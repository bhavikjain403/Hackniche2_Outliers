import { Card, CardContent } from '@/components/ui/card';
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
import { MarkerIcon } from '@/components/app/map/MarkerIcon';
import { Input } from '@/components/ui/input';
import { Check, CheckCircle2Icon, XCircle } from 'lucide-react';
import { Button } from '@/components/ui/button';
function RouteSelector() {
  const [position, setPosition] = useState([0, 0]);
  const [markers, setMarkers] = useState<number[][]>([]);

  function addMarker(e: SyntheticEvent) {
    console.log(e);
    setMarkers((state) => [...state, [e.latlng.lat, e.latlng.lng]]);
    console.log(markers);
  }

  useEffect(() => {
    console.log('markers:', markers);
  }, [markers]);

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
        <Card className="w-full h-[70vh]">
          <CardContent className="h-full p-2">
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
          <CardContent className="border-2 rounded-md mt-4 h-14 px-2 py-0">
            <div className="flex w-full justify-start gap-2 items-center h-full">
              <Button>Save Route</Button>
              <Button
                variant={'outline'}
                className="border-slate-600/20 border-2"
              >
                Reset Route
              </Button>
            </div>
          </CardContent>
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
  markers: number[][];
  setMarkers: Dispatch<SetStateAction<number[][]>>;
  addMarker: (e: SyntheticEvent) => void;
}) {
  useMapEvent('click', addMarker);

  return (
    <>
      <TileLayer
        attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
      />
      {markers.map((item: number[], index: number) => {
        return (
          <CustomMarker
            position={item}
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
  setPosition: Dispatch<SetStateAction<number[][]>>;
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
            [latlng.lat, latlng.lng],
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
      icon={MarkerIcon}
    >
      <Popup>
        {/* <Input type="number" className="border-slate-300 border-2" />{' '}
          <CheckCircle2Icon size={60} className="stroke-green-600" /> */}
        <XCircle
          size={40}
          className="stroke-red-600"
          onClick={(e) => {
            e.stopPropagation();
            setPosition((state) => [
              ...state.slice(0, index),
              ...state.slice(index + 1),
            ]);
          }}
        />
        {/* </div> */}
      </Popup>
    </Marker>
  );
}

export default RouteSelector;
