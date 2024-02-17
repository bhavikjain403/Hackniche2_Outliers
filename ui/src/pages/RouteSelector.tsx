import { Card, CardContent } from "@/components/ui/card";
import { MapContainer, TileLayer, Marker, Popup } from "react-leaflet";
import "leaflet/dist/leaflet.css";
import { useEffect, useState } from "react";
import LoaderSpinner from "@/components/ui/LoaderSpinner";
function RouteSelector() {
  const [position, setPosition] = useState([0, 0]);

  useEffect(() => {
    if ("geolocation" in navigator && !position[0]) {
      navigator.geolocation.getCurrentPosition(function (position) {
        console.log("location is", position.coords);
        setPosition([position.coords.latitude, position.coords.longitude]);
      });
    } else {
      console.log("Geolocation is not available in your browser.");
    }
  }, []);
  return (
    <div className="hidden flex-col md:flex">
      <div className="flex-1 space-y-4 p-8 pt-6">
        <div className="flex items-center justify-between space-y-2">
          <h2 className="text-3xl font-bold tracking-tight">Route</h2>
        </div>
        <Card className="w-full h-[70vh]">
          <CardContent className="h-full p-2 overflow-hidden">
            {position[0] ? (
              <MapContainer
                className="h-full"
                center={position}
                zoom={30}
                scrollWheelZoom={true}>
                <TileLayer
                  attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
                  url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                />
                <Marker position={position}>
                  <Popup>
                    <div>hi this is a marker</div>
                  </Popup>
                </Marker>
              </MapContainer>
            ) : (
              <LoaderSpinner />
            )}
          </CardContent>
        </Card>
      </div>
    </div>
  );
}

export default RouteSelector;
