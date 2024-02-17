import { NODEJS_ENDPOINT } from '@/api/endpoints';
import axios from 'axios';
import { useEffect } from 'react';

function UpdateLocation() {
  useEffect(() => {
    const truckId = localStorage.getItem('id');
    axios
      .get(NODEJS_ENDPOINT + 'admin/gettruckfromid?id=' + truckId)
      .then((data) => console.log(data.data.data));
  }, []);

  return (
    <div className="hidden flex-col md:flex">
      <div className="flex-1 space-y-4 p-8 pt-6">
        <div className="flex items-center justify-between space-y-2">
          <h2 className="text-3xl font-bold tracking-tight">Live Update</h2>
        </div>
      </div>
    </div>
  );
}

export default UpdateLocation;
