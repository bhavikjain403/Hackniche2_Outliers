import { Navigate } from 'react-router-dom';

function ProtectedRoute({ children }) {
  const isUserLoggedIn = localStorage.getItem('token');
  //   return (
  if (isUserLoggedIn) {
    return children;
  } else {
    return <Navigate to={'/'} />;
  }
  //   )
}

export default ProtectedRoute;
