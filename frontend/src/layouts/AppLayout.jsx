import { Outlet, useLocation } from 'react-router-dom';
import BrandLogo from '../components/BrandLogo';
import { getStoredUser } from '../api/auth';

export default function AppLayout() {
  const stored = getStoredUser();
  const { pathname } = useLocation();
  const logoTo = pathname === '/' ? '/' : (stored ? '/dashboard' : '/');

  return (
    <>
      <header className="fl-app-header">
        <BrandLogo to={logoTo} size="header" />
      </header>
      <div className="fl-app-content">
        <Outlet />
      </div>
    </>
  );
}
