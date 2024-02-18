import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import {
  Paper,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableRow,
} from '@mui/material';

export function BasketAnalysis({ rating }) {
  console.log(rating);

  return (
    <div className="space-y-8">
      <Table>
        {/* <TableBody> */}
        <TableRow>
          {rating?.['basket_analysis']?.splice(0, 6)?.map((data) => {
            return (
              <div className="flex flex-col">
                <div className="ml-4">
                  <TableCell>
                    <p className="text-xl font-large leading-none">{data}</p>
                  </TableCell>
                </div>
              </div>
            );
          })}
        </TableRow>
        {/* </TableBody> */}
      </Table>
    </div>
  );
}
