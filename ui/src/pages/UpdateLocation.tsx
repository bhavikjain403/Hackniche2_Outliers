import { NODEJS_ENDPOINT } from '@/api/endpoints';
import { Button } from '@/components/ui/button';
import { Card, CardContent } from '@/components/ui/card';
import { getRegion, minutesToTime } from '@/lib/utils';
import axios from 'axios';
import { useEffect, useState } from 'react';
import L from 'leaflet';
import { MapContainer, Marker, Popup, TileLayer, useMap } from 'react-leaflet';
import { toast } from 'sonner';
import 'leaflet-routing-machine';

function getLocationString(location) {
  return `${location.neighbourhood}, ${location.road}, ${location.city}, ${location.postcode}, ${location.state}`;
}

function UpdateLocation() {
  const [markerLocations, setMarkerLocations] = useState([]);
  const [routeMarker, setRouteMarker] = useState([]);
  const [travellingTo, setTravellingTo] = useState(null);
  const [currentPosition, setCurrentPosition] = useState([0, 0]);

  useEffect(() => {
    /* TODO: only for debug */
    if (travellingTo) {
      setCurrentPosition([19.1074064, 72.8372358]);
      return;
      if ('geolocation' in navigator && !currentPosition[0]) {
        navigator.geolocation.getCurrentPosition(function (position) {
          console.log('location is', position.coords);
          setCurrentPosition([
            position.coords.latitude,
            position.coords.longitude,
          ]);
        });
      } else {
        console.log('Geolocation is not available in your browser.');
      }
    }
  }, [travellingTo]);

  useEffect(() => {
    const truckId = localStorage.getItem('id');
    axios
      .get(NODEJS_ENDPOINT + 'admin/gettruckfromid?id=' + truckId)
      .then((data) => {
        const routeM = data.data.data.routeMarker;
        setRouteMarker(routeM);
        return routeM;
      })
      .then((data) =>
        Promise.all(
          data.map((item) =>
            getRegion({
              latitude: item.coordinate[0],
              longitude: item.coordinate[1],
            })
          )
        ).then((data) => setMarkerLocations(data))
      );
  }, []);

  return (
    <div className="hidden flex-col md:flex">
      <div className="flex-1 space-y-4 p-8 pt-6">
        <div className="flex items-center justify-between space-y-2">
          <h2 className="text-3xl font-bold tracking-tight">Update Location</h2>
        </div>
        <Card className="grid grid-cols-4 gap-10">
          {markerLocations.map((item, index) => {
            return (
              <MarkerLocationCard
                routeMarker={routeMarker}
                index={index}
                location={item}
                key={index}
                setTravellingTo={setTravellingTo}
                travellingTo={travellingTo}
              />
            );
          })}
        </Card>
        {travellingTo && currentPosition[0] && (
          <Card className="h-96">
            <MapContainer
              className="h-full w-full overflow-hidden"
              // center={L.latLngBounds(
              //   L.latLng(travellingTo.latitude, travellingTo.longitude),
              //   L.latLng(...currentPosition)
              // ).getCenter()}
              zoom={15}
            >
              <MapChildren
                currentPosition={currentPosition}
                travellingTo={travellingTo}
              />
            </MapContainer>
          </Card>
        )}
      </div>
    </div>
  );
}

function MapChildren({ currentPosition, travellingTo }) {
  const map = useMap();

  useEffect(() => {
    if (!map) return;

    const routingControl = L.Routing.control({
      waypoints: [
        L.latLng(...currentPosition),
        L.latLng(travellingTo.latitude, travellingTo.longitude),
      ],
      lineOptions: {
        styles: [{ color: '#6FA1EC', weight: 4 }],
      },
      show: false,
      addWaypoints: false,
      routeWhileDragging: true,
      draggableWaypoints: true,
      fitSelectedRoutes: true,
      showAlternatives: true,
    }).addTo(map);

    return () => map.removeControl(routingControl);
  }, [currentPosition]);
  return (
    <>
      <TileLayer
        attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
      />
      <Marker position={currentPosition}>
        <Popup>Your truck</Popup>
      </Marker>
      <Marker position={[travellingTo.latitude, travellingTo.longitude]}>
        <Popup>Destination</Popup>
      </Marker>
    </>
  );
}

function MarkerLocationCard({
  location,
  index,
  routeMarker,
  setTravellingTo,
  travellingTo,
}) {
  const position = [location.latitude, location.longitude];
  return (
    <Card className="h-96 flex flex-col drop-shadow-lg">
      <MapContainer
        className="h-full overflow-hidden"
        center={position}
        zoom={30}
        scrollWheelZoom={true}
      >
        <TileLayer
          attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
          url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
        />
        <Marker position={position} />
      </MapContainer>
      <CardContent className="p-2 font-semibold text-justify">
        <p className="text-muted-foreground font-medium">Address</p>
        <h1>{getLocationString(location)}</h1>
        <p className="text-muted-foreground font-medium mt-4">Schedule slot</p>
        <h1>
          {minutesToTime(routeMarker[index].startTime)} -{' '}
          {minutesToTime(routeMarker[index].endTime)}
        </h1>
        <div className="w-full flex justify-center my-2">
          {/* TODO: send push notification */}
          {travellingTo ? (
            JSON.stringify(travellingTo) === JSON.stringify(location) ? (
              <Button
                onClick={() => {
                  setTravellingTo(null);
                  toast('Reached', {
                    description: getLocationString(location),
                    action: { label: 'Close', onClick: () => null },
                  });
                  axios
                    .post(NODEJS_ENDPOINT + 'notification/sendNotification', {
                      title: 'We have arrived',
                      body: 'at ' + getLocationString(location),
                    })
                    .then((data) => console.log(data));
                }}
              >
                Reached Location
              </Button>
            ) : (
              <Button disabled>Disabled</Button>
            )
          ) : (
            <Button
              onClick={() => {
                setTravellingTo(location);
                toast('Started travelling to', {
                  description: getLocationString(location),
                  action: { label: 'Close', onClick: () => null },
                });
                axios
                  .post(NODEJS_ENDPOINT + 'notification/sendNotification', {
                    title: 'We are on the move',
                    body: 'Arriving at ' + getLocationString(location),
                  })
                  .then((data) => console.log(data));
              }}
            >
              Travel to Location
            </Button>
          )}
        </div>
      </CardContent>
    </Card>
  );
}

export default UpdateLocation;
