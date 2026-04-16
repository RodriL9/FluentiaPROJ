import { useMemo, useState } from 'react';
import { Link, useNavigate, useSearchParams } from 'react-router-dom';
import { resetPassword } from '../api/auth';

export default function ResetPasswordPage() {
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const token = useMemo(() => (searchParams.get('token') || '').trim(), [searchParams]);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState('');

  return (
    <div className="fl-auth-page">
      <div className="fl-auth-card">
        <h1 className="fl-auth-title">Choose a new password</h1>
        <p className="fl-auth-sub">Enter a new password for your account.</p>
        {error ? (
          <p className="fl-auth-error" role="alert">
            {error}
          </p>
        ) : null}

        {!token ? (
          <p className="fl-auth-error" role="alert">
            Missing reset token. Open the password reset link from your email.
          </p>
        ) : (
          <form
            onSubmit={async (e) => {
              e.preventDefault();
              setError('');
              const form = e.target;
              const password = form.password.value;
              const confirm = form.confirm.value;
              if (password !== confirm) {
                setError('Passwords do not match.');
                return;
              }
              setSubmitting(true);
              try {
                await resetPassword({ token, password });
                navigate('/login?passwordReset=1', { replace: true });
              } catch (err) {
                setError(err.message || 'Could not reset password.');
              } finally {
                setSubmitting(false);
              }
            }}
          >
            <div className="fl-field">
              <label htmlFor="password">New Password</label>
              <input
                id="password"
                name="password"
                type="password"
                autoComplete="new-password"
                placeholder="••••••••"
              />
            </div>
            <div className="fl-field">
              <label htmlFor="confirm">Confirm New Password</label>
              <input
                id="confirm"
                name="confirm"
                type="password"
                autoComplete="new-password"
                placeholder="••••••••"
              />
            </div>
            <button type="submit" className="fl-btn fl-btn-primary fl-btn-block" disabled={submitting}>
              {submitting ? 'Updating…' : 'Update Password'}
            </button>
          </form>
        )}

        <p className="fl-auth-footer">
          <Link to="/login">Back to sign in</Link>
        </p>
      </div>
    </div>
  );
}
