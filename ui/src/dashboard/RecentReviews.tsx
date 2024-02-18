import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { Table, TableBody, TableCell, TableRow } from '@mui/material';

export function RecentReviews({ children }) {
  let rating = children;
  console.log(rating);

  return (
    <div className="space-y-8">
      <Table>
        {/* <TableBody> */}
        <TableRow className="flex flex-col">
          {rating?.['reviews']?.splice(0, 6)?.map((data) => {
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
