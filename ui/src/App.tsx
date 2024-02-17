import { Route, Routes } from "react-router-dom";
import AuthenticationPage from "./pages/AuthenticationPage";
import Dashboard from "./pages/Dashboard";
import Navbar from "./components/app/Navbar";
import RouteSelector from "./pages/RouteSelector";

function App() {
  return (
    <>
      <Navbar />
      <Routes>
        <Route path="/" element={<AuthenticationPage />} />
        <Route path="/dashboard" element={<Dashboard />} />
        <Route path="/map" element={<RouteSelector />} />
      </Routes>
    </>
  );
}

export default App;
