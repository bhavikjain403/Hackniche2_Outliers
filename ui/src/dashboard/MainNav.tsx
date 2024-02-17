import { cn } from '@/lib/utils';
import { Link } from 'react-router-dom';

export function MainNav({
  className,
  ...props
}: React.HTMLAttributes<HTMLElement>) {
  return (
    <nav
      className={cn('flex items-center space-x-4 lg:space-x-6', className)}
      {...props}
    >
      <Link
        to="/dashboard"
        className="text-sm font-medium transition-colors hover:text-primary"
      >
        Overview
      </Link>
      <Link
        to="/map"
        /* TODO: add muted background to text when not active */
        className="text-sm font-medium transition-colors hover:text-primary"
      >
        Route
      </Link>
      <Link
        to="/menu"
        /* TODO: add muted background to text when not active */
        className="text-sm font-medium transition-colors hover:text-primary"
      >
        Menu
      </Link>
    </nav>
  );
}
