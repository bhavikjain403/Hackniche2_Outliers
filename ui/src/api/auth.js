import axios from "axios";

class AuthApi {
  static Login = (data) => {
    return axios.post(`https://foodtruck-poi9.onrender.com/api/admin/login`, data);
  };

  static Register = (data) => {
    return axios.post(`https://foodtruck-poi9.onrender.com/api/admin/signup`, data);
  };

  static Logout = (data) => {
    return axios.post(`https://foodtruck-poi9.onrender.com/api/admin/logout`, data, { headers: { Authorization: `${data.token}` } });
  };
}

export default AuthApi;
