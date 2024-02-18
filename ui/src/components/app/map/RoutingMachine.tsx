import L from 'leaflet';
import { createControlComponent } from '@react-leaflet/core';
import 'leaflet-routing-machine';

const createRoutineMachineLayer = () => {
  //   console.log(l1);
  const instance = L.Routing.control({
    waypoints: [
      L.latLng(19.1074064, 72.8372358),
      L.latLng(19.084763184155772, 72.8346433638216),
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
  });

  return instance;
};

const RoutingMachine = createControlComponent(createRoutineMachineLayer);

export default RoutingMachine;
