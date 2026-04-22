import { useEffect } from 'react';
import { Link } from 'react-router-dom';

const features = [
  {
    icon: '⏱️',
    title: '5-Minute Lessons',
    desc: 'Short sessions that fit into a busy day without guilt.',
    bg: 'rgba(139, 92, 246, 0.15)',
  },
  {
    icon: '⚡',
    title: 'Smart Learning',
    desc: 'AI-powered practice that adapts to your level.',
    bg: 'rgba(234, 179, 8, 0.2)',
  },
  {
    icon: '👥',
    title: 'Real Conversations',
    desc: 'Practice scenarios you will actually use in real life.',
    bg: 'rgba(59, 130, 246, 0.15)',
  },
  {
    icon: '📚',
    title: 'Track Progress',
    desc: 'See streaks, XP, and skills improve over time.',
    bg: 'rgba(236, 72, 153, 0.15)',
  },
];

export default function LandingPage() {
  useEffect(() => {
    document.body.classList.add('fl-landing-body');
    return () => {
      document.body.classList.remove('fl-landing-body');
    };
  }, []);

  return (
    <div className="fl-landing">
      <section className="fl-hero">
        <h1>
          <span className="fl-gradient-text">Learn Languages</span>
        </h1>
        <h2>Even When Life Gets Busy</h2>
        <p>
          Fluentia is designed for busy adults who want to master a new language. Smart, bite-sized lessons
          that fit your schedule. No pressure, just progress.
        </p>
        <div className="fl-hero-cta-row">
          <Link to="/register">
            <button type="button" className="fl-btn fl-btn-primary" style={{ padding: '0.95rem 2rem', fontSize: '1rem' }}>
              Get Started Free
            </button>
          </Link>
          <Link to="/login">
            <button type="button" className="fl-btn fl-btn-ghost-nav" style={{ padding: '0.95rem 1.75rem', fontSize: '1rem' }}>
              Log In
            </button>
          </Link>
        </div>
      </section>

      <section className="fl-features">
        {features.map((f) => (
          <article key={f.title} className="fl-feature-card">
            <div className="fl-feature-icon" style={{ background: f.bg }}>
              {f.icon}
            </div>
            <h3>{f.title}</h3>
            <p>{f.desc}</p>
          </article>
        ))}
      </section>
    </div>
  );
}
