import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";

export function BasketAnalysis({children}) {
  let rating = children;
  console.log(rating);
  
  return (
    <div className="space-y-8">
      {rating["basket_analysis"].splice(0,6)?.map((data)=>{
        return (
          <div className="flex">
          <div className="ml-4">
            <p className="text-xl font-large leading-none">{data}</p>
          </div>
        </div>
        );
      })}
    </div>
  );
}
