import { useEffect, useState } from 'react';
import axios from 'axios';
import { NODEJS_ENDPOINT } from '../api/endpoints';
import { Card, CardContent } from '@/components/ui/card';
import { DataGrid } from '@mui/x-data-grid';
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogTrigger,
} from '@/components/ui/alert-dialog';
import { Button } from '@/components/ui/button';
import {
  Paper,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
} from '@mui/material';
import { toast } from 'sonner';
import { ScrollArea } from '@/components/ui/scroll-area';

function Orders() {
  const [orders, setOrders] = useState([]);
  const [alertOpen, setAlertOpen] = useState(false);
  const [currentOrder, setCurrentOrder] = useState(null);
  const [refetch, setRefetch] = useState(0);
  const columns = [
    {
      field: 'orderStatus',
      headerName: 'Order status',
      flex: 1,
      valueGetter: (params) => {
        switch (params.row.orderStatus) {
          case 'placed':
            return 'Ordered';
          case 'preparing':
            return 'Preparing';
          case 'picked':
            return 'Picked';
        }
      },
    },
    {
      field: 'amount',
      headerName: 'Amount',
      flex: 1,
      valueGetter: (params) => `₹${params.row.amount}`,
    },
    {
      field: 'paymentMode',
      headerName: 'Payment mode',
      flex: 1,
      valueGetter: (params) =>
        params.row.paymentMode === 'cod' ? 'Cash on delivery' : 'Prepaid',
    },
    {
      field: 'placedTime',
      headerName: 'Placed time',
      flex: 1,
      valueGetter: (params) =>
        `${new Date(params.row.placedTime).toLocaleTimeString()}`,
    },
    {
      field: 'scheduledTime',
      headerName: 'Scheduled time',
      flex: 1,
      valueGetter: (params) =>
        `${new Date(
          params.row.scheduledTime?.[0] || new Date()
        ).toLocaleTimeString()} - ${new Date(
          params.row.scheduledTime?.[1] || new Date()
        ).toLocaleTimeString()}`,
    },
  ];
  useEffect(() => {
    const truckId = localStorage.getItem('id');
    axios
      .get(NODEJS_ENDPOINT + 'order/getorderbytruck' + '?truckId=' + truckId)
      .then((data) => {
        const fetchedOrders = data.data.data.map((item, index) => ({
          ...item,
          id: item._id,
        }));
        // console.log(new Date(fetchedOrders[0].placedTime).toLocaleTimeString());
        console.log(fetchedOrders);
        setOrders(fetchedOrders);
      });
  }, [refetch]);
  return (
    <div className="hidden flex-col md:flex">
      <div className="flex-1 space-y-4 p-8 pt-6">
        <div className="flex items-center justify-between space-y-2">
          <h2 className="text-3xl font-bold tracking-tight">Orders</h2>
        </div>
        <Card>
          <CardContent className="py-4 flex justify-center">
            <DataGrid
              className="w-3/4"
              rows={orders}
              columns={columns}
              initialState={{
                pagination: {
                  paginationModel: { page: 0, pageSize: 10 },
                },
              }}
              onRowClick={(e) => {
                console.log(e.row);
                setCurrentOrder(e.row);
                setAlertOpen(true);
              }}
              pageSizeOptions={[10, 20]}
              // checkboxSelection
            />
          </CardContent>
          <div className="sjkdhf">
            <CustomAlert
              alertOpen={alertOpen}
              setAlertOpen={setAlertOpen}
              currentOrder={currentOrder}
              setRefetch={setRefetch}
            />
          </div>
        </Card>
      </div>
    </div>
  );
}

function CustomAlert({ alertOpen, setAlertOpen, currentOrder, setRefetch }) {
  return (
    <AlertDialog open={alertOpen} onOpenChange={setAlertOpen}>
      <AlertDialogContent>
        <AlertDialogHeader>
          <AlertDialogTitle>Order details</AlertDialogTitle>
          <AlertDialogDescription>
            <Card className="border-0">
              <TableContainer className="w-full" component={Paper}>
                <TableHead
                  style={{ width: '100%', display: 'inline-block' }}
                  className="bg-slate-200"
                >
                  <TableRow style={{ width: '100%', display: 'flex' }}>
                    <TableCell
                      style={{
                        flex: 1,
                        display: 'flex',
                        fontWeight: 700,
                      }}
                    >
                      Item
                    </TableCell>
                    <TableCell
                      style={{
                        flex: 1,
                        display: 'flex',
                        fontWeight: 700,
                      }}
                    >
                      Quantity
                    </TableCell>
                  </TableRow>
                </TableHead>
                <TableBody style={{ width: '100%', display: 'inline-block' }}>
                  {currentOrder?.items?.map((item, index) => {
                    return (
                      <TableRow
                        style={{ width: '100%', display: 'flex' }}
                        key={index}
                      >
                        <TableCell style={{ flex: 1, display: 'flex' }}>
                          {item.name}
                        </TableCell>
                        <TableCell style={{ flex: 1, display: 'flex' }}>
                          {item.quantity}
                        </TableCell>
                      </TableRow>
                    );
                  })}
                  <TableRow
                    style={{
                      width: '100%',
                      display: 'flex',
                    }}
                    className="border-t-2 border-t-slate-400/50"
                  >
                    <TableCell style={{ flex: 1, display: 'flex' }}>
                      Total amount
                    </TableCell>
                    <TableCell style={{ flex: 1, display: 'flex' }}>
                      ₹{currentOrder?.amount}
                    </TableCell>
                  </TableRow>
                  <TableRow style={{ width: '100%', display: 'flex' }}>
                    <TableCell style={{ flex: 1, display: 'flex' }}>
                      Payment status
                    </TableCell>
                    <TableCell style={{ flex: 1, display: 'flex' }}>
                      {currentOrder?.paymentMode === 'cod'
                        ? 'Cash on delivery'
                        : 'Prepaid'}
                    </TableCell>
                  </TableRow>
                  <TableRow style={{ width: '100%', display: 'flex' }}>
                    <TableCell style={{ flex: 1, display: 'flex' }}>
                      Scheduled Pickup
                    </TableCell>
                    <TableCell style={{ flex: 1, display: 'flex' }}>
                      {`${new Date(
                        currentOrder?.scheduledTime?.[0] || new Date()
                      ).toLocaleTimeString()} - ${new Date(
                        currentOrder?.scheduledTime?.[1] || new Date()
                      ).toLocaleTimeString()}`}
                    </TableCell>
                  </TableRow>
                </TableBody>
              </TableContainer>
            </Card>
          </AlertDialogDescription>
        </AlertDialogHeader>
        <AlertDialogFooter className="flex justify-between">
          <AlertDialogCancel className="flex-1">Close</AlertDialogCancel>
          {currentOrder?.orderStatus != 'picked' && (
            <AlertDialogAction
              onClick={async (e) => {
                e.preventDefault();
                const updatedOrder = {
                  _id: currentOrder._id,
                  orderStatus: 'picked',
                  // pickupTime: new Date(),
                };

                console.log(updatedOrder);
                console.log('sending post');
                const data = await axios.post(
                  NODEJS_ENDPOINT + 'order/updateorder',
                  updatedOrder
                );
                console.log(data);
                console.log('sent post');
                setRefetch((state) => state + 1);
                setAlertOpen(false);
                toast('Order Delivered', {
                  description: 'Order was marked as picked successfully!',
                  action: { label: 'Close', onClick: () => null },
                });
              }}
              className="flex-1"
            >
              Mark as Picked
            </AlertDialogAction>
          )}
        </AlertDialogFooter>
      </AlertDialogContent>
    </AlertDialog>
  );
}

export default Orders;
