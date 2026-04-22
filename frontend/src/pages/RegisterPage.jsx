import { useEffect, useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { getNextOnboardingRoute, registerAccount, setStoredUser } from '../api/auth';
import GoogleSignInButton from '../components/GoogleSignInButton';

export default function RegisterPage() {
  const navigate = useNavigate();
  const [error, setError] = useState('');
  const [submitting, setSubmitting] = useState(false);

  useEffect(() => {
    document.body.classList.add('fl-auth-light-body');
    return () => {
      document.body.classList.remove('fl-auth-light-body');
    };
  }, []);

  return (
    <div className="fl-auth-page fl-register-page">
      <div className="fl-auth-card">
        <h1 className="fl-auth-title">Create an account</h1>
        <p className="fl-auth-sub">Start your language learning journey today</p>

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
            const fullName = form.fullName.value.trim();
            const username = form.username.value.trim();
            const email = form.email.value.trim();
            const password = form.password.value;
            const confirm = form.confirm.value;
            if (password !== confirm) {
              setError('Passwords do not match.');
              return;
            }
            setSubmitting(true);
            try {
              const data = await registerAccount({ fullName, username, email, password });
              if (data.emailVerified) {
                setStoredUser({
                  ...data,
                  emailVerified: true,
                });
                navigate(getNextOnboardingRoute(data), { replace: true });
              } else {
                navigate('/login?checkEmail=1', { replace: true });
              }
            } catch (err) {
              setError(err.message || 'Could not create account.');
            } finally {
              setSubmitting(false);
            }
          }}
        >
          <div className="fl-field">
            <label htmlFor="fullName">Full Name</label>
            <input id="fullName" name="fullName" type="text" autoComplete="name" placeholder="Your name" />
          </div>
          <div className="fl-field">
            <label htmlFor="username">Username</label>
            <input id="username" name="username" type="text" autoComplete="username" placeholder="Choose a username" />
          </div>
          <div className="fl-field">
            <label htmlFor="email">Email</label>
            <input id="email" name="email" type="email" autoComplete="email" placeholder="you@example.com" />
          </div>
          <div className="fl-field">
            <label htmlFor="password">Password</label>
            <input id="password" name="password" type="password" autoComplete="new-password" placeholder="••••••••" />
          </div>
          <div className="fl-field">
            <label htmlFor="confirm">Confirm Password</label>
            <input
              id="confirm"
              name="confirm"
              type="password"
              autoComplete="new-password"
              placeholder="••••••••"
            />
          </div>
          <button type="submit" className="fl-btn fl-btn-primary fl-btn-block" disabled={submitting}>
            {submitting ? 'Creating…' : 'Create Account'}
          </button>
        </form>

        <div className="fl-auth-oauth-stack">
          <div className="fl-auth-divider">or</div>
          <GoogleSignInButton mode="signup" disabled={submitting} />
        </div>

        <p className="fl-auth-footer">
          Already have an account? <Link to="/login">Sign in</Link>
        </p>
      </div>
    </div>
  );
}
