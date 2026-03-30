import { Link } from 'react-router-dom';

export default function ForgotPasswordPage() {
  return (
    <div className="fl-auth-page">
      <div className="fl-auth-card">
        <h1 className="fl-auth-title">Reset your password</h1>
        <p className="fl-auth-sub">
          Enter the email associated with your account and we&apos;ll send you a link to reset your password.
        </p>

        <form
          onSubmit={(e) => {
            e.preventDefault();
            alert('If this email exists in our system, you will receive reset instructions. (Demo — wire to backend later.)');
          }}
        >
          <div className="fl-field">
            <label htmlFor="email">Email</label>
            <input id="email" name="email" type="email" autoComplete="email" placeholder="you@example.com" />
          </div>
          <button type="submit" className="fl-btn fl-btn-primary fl-btn-block">
            Send reset link
          </button>
        </form>

        <p className="fl-auth-footer">
          <Link to="/login">Back to sign in</Link>
        </p>
      </div>
    </div>
  );
}
