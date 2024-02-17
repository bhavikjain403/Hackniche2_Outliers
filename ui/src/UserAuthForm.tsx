import { cn } from '@/lib/utils';
import { useState } from 'react';
import { Label } from './components/ui/label';
import { Input } from './components/ui/input';
import { Button } from './components/ui/button';
import { Github, Loader2 } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import AuthApi from './api/auth';

interface UserAuthFormProps extends React.HTMLAttributes<HTMLDivElement> {}

export function UserAuthForm({ className, ...props }: UserAuthFormProps) {
  const [isLoading, setIsLoading] = useState<boolean>(false);
  const [formData, setFormData] = useState({
    email: '',
    password: '',
  });
  const [error, setError] = useState('');

  const navigate = useNavigate();

  async function onSubmit(event: React.SyntheticEvent) {
    event.preventDefault();
    setIsLoading(true);

    setTimeout(() => {
      setIsLoading(false);
    }, 3000);
  }

  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value,
    });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    AuthApi.Login(formData)
      .then((response) => {
        if (response.data) {
          setProfile(response);
          navigate('/dashboard');
        } else {
          console.log(response);
          setError(response.data.msg);
        }
      })
      .catch((error) => {
        if (error.response) {
          return setError(error.response.data.msg);
        }
        return setError('There has been an error.');
      });
  };

  const setProfile = (response) => {
    let user = { ...response.data };
    localStorage.setItem('name', user.data.admin.name);
    localStorage.setItem('id', user.data.admin._id);
    localStorage.setItem('token', user.data.token);
    return;
  };

  return (
    <div className={cn('grid gap-6', className)} {...props}>
      <form onSubmit={onSubmit}>
        <div className="grid gap-6">
          <div className="grid gap-2">
            <Label className="sr-only" htmlFor="email">
              Email
            </Label>
            <Input
              id="email"
              placeholder="Email"
              type="email"
              name="email"
              disabled={isLoading}
              onChange={handleChange}
              value={formData?.email}
              required
            />
          </div>
          <div className="grid gap-2">
            <Label className="sr-only" htmlFor="email">
              Email
            </Label>
            <Input
              id="password"
              placeholder="Password"
              type="password"
              name="password"
              disabled={isLoading}
              onChange={handleChange}
              value={formData?.password}
              required
            />
          </div>
          <Button disabled={isLoading} onClick={handleSubmit}>
            {isLoading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
            Sign In
          </Button>
        </div>
      </form>
    </div>
  );
}
