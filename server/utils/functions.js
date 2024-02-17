const axios = require('axios');

const removeSensitiveData = (data) => {
    data.password = undefined;
    data.tokens = undefined;
    data.createdAt = undefined;
    data.updatedAt = undefined;
    data.__v = undefined;
    data.profilepicture = undefined;
    data.otp = undefined;
    
    return data;
  };

async function getRegion(data) {
  const latitude = data.latitude
  const longitude = data.longitude
  const response = await axios.get(`https://nominatim.openstreetmap.org/reverse?lat=${latitude}&lon=${longitude}&format=json`);
  const city = await response.data.address.city
  return await city
}

module.exports = {removeSensitiveData, getRegion}