import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { requestPasswordReset } from '../api/auth';

export default function ForgotPasswordPage() {
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState('');
  const [info, setInfo] = useState('');

  useEffect(() => {
    document.body.classList.add('fl-auth-light-body');
    return () => {
      document.body.classList.remove('fl-auth-light-body');
    };
  }, []);

  return (
    <div className="fl-auth-page fl-forgot-page">
      <div className="fl-auth-card">
        <h1 className="fl-auth-title">Reset your password</h1>
        <p className="fl-auth-sub">
          Enter the email associated with your account and we&apos;ll send you a link to reset your password.
        </p>
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
            setInfo('');
            const form = e.target;
            const email = form.email.value.trim();
            setSubmitting(true);
            try {
              await requestPasswordReset(email);
              setInfo('If this email exists in our system, you will receive reset instructions shortly.');
              form.reset();
            } catch (err) {
              setError(err.message || 'Could not send reset email.');
            } finally {
              setSubmitting(false);
            }
          }}
        >
          <div className="fl-field">
            <label htmlFor="email">Email</label>
            <input id="email" name="email" type="email" autoComplete="email" placeholder="you@example.com" />
          </div>
          <button type="submit" className="fl-btn fl-btn-primary fl-btn-block" disabled={submitting}>
            {submitting ? 'Sending…' : 'Send reset link'}
          </button>
        </form>

        <p className="fl-auth-footer">
          <Link to="/login">Back to sign in</Link>
        </p>
      </div>
    </div>
  );
}
