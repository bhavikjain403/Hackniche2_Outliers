import { Route, Routes } from 'react-router-dom';
import AuthenticationPage from './pages/AuthenticationPage';
import Dashboard from './pages/Dashboard';
import Navbar from './components/app/Navbar';
import RouteSelector from './pages/RouteSelector';
import Menu from './pages/Menu';

function App() {
  return (
    <div className="font-poppins">
      <Navbar />
      <Routes>
        <Route path="/" element={<AuthenticationPage />} />
        <Route path="/dashboard" element={<Dashboard />} />
        <Route path="/map" element={<RouteSelector />} />
        <Route path="/menu" element={<Menu />} />
      </Routes>
    </div>
  );
}

export default App;
