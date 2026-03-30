import { fetchPublicAuthConfig } from '../api/auth';

/**
 * Google OAuth 2.0 via full-page redirect.
 * - Click stays in the SAME tab.
 * - Browser goes to accounts.google.com, then returns to /google-callback with an ID token.
 * - /google-callback page finishes login by calling /api/auth/google.
 */
export default function GoogleSignInButton({ mode = 'signin', disabled = false }) {
  const label = mode === 'signup' ? 'Sign up with Google' : 'Sign in with Google';

  const handleClick = async () => {
    if (disabled) return;

    // Prefer backend config so you only need GOOGLE_CLIENT_ID / GOOGLE_WEB_CLIENT_ID in backend/.env
    let clientId = '';
    try {
      const cfg = await fetchPublicAuthConfig();
      if (cfg && typeof cfg.googleWebClientId === 'string') {
        clientId = cfg.googleWebClientId.trim();
      }
    } catch {
      clientId = '';
    }

    if (!clientId) {
      // eslint-disable-next-line no-alert
      alert('Google sign-in is not configured. Set GOOGLE_CLIENT_ID or GOOGLE_WEB_CLIENT_ID in backend/.env and restart the API.');
      return;
    }

    const redirectUri = `${window.location.origin}/google-callback`;
    const nonce = Math.random().toString(36).slice(2);
    const state = Math.random().toString(36).slice(2);

    // Store nonce/state so callback page can validate if desired
    try {
      sessionStorage.setItem('fl_google_nonce', nonce);
      sessionStorage.setItem('fl_google_state', state);
    } catch {
      // ignore
    }

    const params = new URLSearchParams({
      client_id: clientId,
      redirect_uri: redirectUri,
      response_type: 'id_token',
      scope: 'openid email profile',
      nonce,
      state,
      prompt: 'select_account',
    });

    const url = `https://accounts.google.com/o/oauth2/v2/auth?${params.toString()}`;
    window.location.assign(url);
  };

  return (
    <div className="fl-auth-google-slot">
      <button
        type="button"
        className="fl-btn fl-btn-outline fl-btn-block"
        disabled={disabled}
        onClick={handleClick}
      >
        {label}
      </button>
    </div>
  );
}

