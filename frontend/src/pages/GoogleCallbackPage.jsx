import { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { getNextOnboardingRoute, loginWithGoogle, setStoredUser } from '../api/auth';

export default function GoogleCallbackPage() {
  const navigate = useNavigate();

  useEffect(() => {
    const run = async () => {
      const hash = window.location.hash.startsWith('#') ? window.location.hash.slice(1) : window.location.search.slice(1);
      const params = new URLSearchParams(hash);
      const idToken = params.get('id_token');
      const state = params.get('state');

      const expectedState = sessionStorage.getItem('fl_google_state');
      sessionStorage.removeItem('fl_google_state');

      // Optional CSRF protection: if state doesn't match, bail out
      if (!idToken || (expectedState && expectedState !== state)) {
        navigate('/login?googleError=1', { replace: true });
        return;
      }

      try {
        const user = await loginWithGoogle(idToken);
        setStoredUser(user);
        // Clean hash from URL
        window.history.replaceState({}, document.title, window.location.pathname);
        navigate(getNextOnboardingRoute(user), { replace: true });
      } catch (err) {
        navigate('/login?googleError=1', { replace: true });
      }
    };

    run();
  }, [navigate]);

  return (
    <div className="fl-auth-page">
      <div className="fl-auth-card">
        <h1 className="fl-auth-title">Signing you in…</h1>
        <p className="fl-auth-sub">Completing Google sign-in. This should only take a moment.</p>
      </div>
    </div>
  );
}

