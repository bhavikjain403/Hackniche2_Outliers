import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";

export function RecentSales({children}) {
  let sales = children;
  console.log(sales);
  
  return (
    <div className="space-y-8">
      {sales["Top Cuisines"]?.map((data)=>{
        return (
          <div className="flex items-center">
          <div className="ml-4 space-y-1">
            <p className="text-xl font-large leading-none">{data[0]}</p>
          </div>
          <div className="ml-auto text-xl font-large">{data[1]}</div>
        </div>
        );
      })}
    </div>
  );
}
