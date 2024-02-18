import L from 'leaflet';
import icon from '../../../assets/react.svg';

const MarkerIcon = new L.Icon({
  iconUrl: icon,
  iconRetinaUrl: icon,
  iconAnchor: null,
  popupAnchor: [0, -15],
  shadowUrl: null,
  shadowSize: null,
  shadowAnchor: null,
  iconSize: new L.Point(30, 30),
  className: 'leaflet-div-icon',
});

export { MarkerIcon };
