import { useEffect, useState } from 'react';
import { Link, useNavigate, useSearchParams } from 'react-router-dom';
import GoogleSignInButton from '../components/GoogleSignInButton';
import { getNextOnboardingRoute, loginAccount, setStoredUser } from '../api/auth';

export default function LoginPage() {
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const [error, setError] = useState('');
  const [info, setInfo] = useState('');
  const [submitting, setSubmitting] = useState(false);

  useEffect(() => {
    if (searchParams.get('verified') === '1') {
      setInfo('Your email is verified. You can sign in below.');
    } else if (searchParams.get('verified') === '0') {
      setError('That verification link is invalid or has expired.');
    } else if (searchParams.get('checkEmail') === '1') {
      setInfo('Check your inbox for a verification link. After verifying, sign in here.');
    } else if (searchParams.get('passwordReset') === '1') {
      setInfo('Your password has been updated. You can sign in now.');
    } else if (searchParams.get('accountDeleted') === '1') {
      setInfo('Your account has been deleted.');
    } else if (searchParams.get('googleError') === '1') {
      setError('Google sign-in failed or was cancelled. You can try again or use email and password.');
    }
  }, [searchParams]);

  return (
    <div className="fl-auth-page">
      <div className="fl-auth-card">
        <h1 className="fl-auth-title">Welcome back</h1>
        <p className="fl-auth-sub">Sign in to continue your learning journey</p>

        {info ? (
          <p className="fl-auth-info" role="status">
            {info}
          </p>
        ) : null}
        {error ? (
          <p className="fl-auth-error" role="alert">
            {error}
          </p>
        ) : null}

        <form
          onSubmit={async (e) => {
            e.preventDefault();
            setError('');
            const form = e.target;
            const email = form.email.value.trim();
            const password = form.password.value;
            setSubmitting(true);
            try {
              const user = await loginAccount({ email, password });
              setStoredUser(user);
              navigate(getNextOnboardingRoute(user), { replace: true });
            } catch (err) {
              setError(err.message || 'Could not sign in.');
            } finally {
              setSubmitting(false);
            }
          }}
        >
          <div className="fl-field">
            <label htmlFor="email">Email</label>
            <input id="email" name="email" type="email" autoComplete="email" placeholder="name@example.com" />
          </div>
          <div className="fl-field">
            <label htmlFor="password">Password</label>
            <input
              id="password"
              name="password"
              type="password"
              autoComplete="current-password"
              placeholder="Enter your password"
            />
          </div>
          <div className="fl-row-between">
            <Link to="/forgot-password" className="fl-link-small">
              Forgot password?
            </Link>
          </div>
          <button type="submit" className="fl-btn fl-btn-primary fl-btn-block" disabled={submitting}>
            {submitting ? 'Signing in…' : 'Sign In'}
          </button>
        </form>

        <div className="fl-auth-oauth-stack">
          <div className="fl-auth-divider">or</div>
          <GoogleSignInButton mode="signin" disabled={submitting} />
        </div>

        <p className="fl-auth-footer">
          Don&apos;t have an account? <Link to="/register">Sign up</Link>
        </p>
      </div>
    </div>
  );
}
