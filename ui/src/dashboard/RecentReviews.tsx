import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";

export function RecentReviews({children}) {
  let rating = children;
  console.log(rating);
  
  return (
    <div className="space-y-8">
      {rating["reviews"].splice(0,6)?.map((data)=>{
        return (
          <div className="flex items-center">
          <div className="ml-4 space-y-1">
            <p className="text-xl font-large leading-none">{data}</p>
          </div>
        </div>
        );
      })}
    </div>
  );
}
