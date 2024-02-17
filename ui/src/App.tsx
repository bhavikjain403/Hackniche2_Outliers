import { Route, Routes } from 'react-router-dom';
import AuthenticationPage from './pages/AuthenticationPage';
import Dashboard from './pages/Dashboard';
import Navbar from './components/app/Navbar';
import RouteSelector from './pages/RouteSelector';
import Menu from './pages/Menu';
import ProtectedRoute from './pages/ProtectedRoute';
import Orders from './pages/Orders';

function App() {
  return (
    <div className="font-poppins">
      <Navbar />
      <Routes>
        <Route path="/" element={<AuthenticationPage />} />
        <Route
          path="/dashboard"
          element={
            <ProtectedRoute>
              <Dashboard />
            </ProtectedRoute>
          }
        />
        <Route
          path="/map"
          element={
            <ProtectedRoute>
              <RouteSelector />
            </ProtectedRoute>
          }
        />
        <Route
          path="/menu"
          element={
            <ProtectedRoute>
              <Menu />
            </ProtectedRoute>
          }
        />
        <Route
          path="/orders"
          element={
            <ProtectedRoute>
              <Orders />
            </ProtectedRoute>
          }
        />
      </Routes>
    </div>
  );
}

export default App;
