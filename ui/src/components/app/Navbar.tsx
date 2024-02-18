import { MainNav } from '@/dashboard/MainNav';
import TeamSwitcher from '@/dashboard/TeamSwitcher';
import { Search } from '@/dashboard/search';
import { UserNav } from '@/dashboard/userNav';
import { Button } from '@/components/ui/button';
import { useNavigate } from 'react-router-dom';

function Navbar() {
  const navigate = useNavigate();
  return (
    <div className="border-b">
      <div className="flex h-16 items-center px-4">
        <TeamSwitcher />
        <MainNav className="mx-6" />
        <div className="ml-auto flex items-center space-x-4">
          {/* <Search />
          <UserNav /> */}
          <Button
            onClick={() => {
              localStorage.clear();
              navigate('');
            }}
          >
            Logout
          </Button>
        </div>
      </div>
    </div>
  );
}

export default Navbar;
