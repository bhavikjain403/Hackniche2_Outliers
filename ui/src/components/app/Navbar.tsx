import { MainNav } from "@/dashboard/MainNav";
import TeamSwitcher from "@/dashboard/TeamSwitcher";
import { Search } from "@/dashboard/search";
import { UserNav } from "@/dashboard/userNav";

function Navbar() {
  return (
    <div className="border-b">
      <div className="flex h-16 items-center px-4">
        <TeamSwitcher />
        <MainNav className="mx-6" />
        <div className="ml-auto flex items-center space-x-4">
          <Search />
          <UserNav />
        </div>
      </div>
    </div>
  );
}

export default Navbar;
