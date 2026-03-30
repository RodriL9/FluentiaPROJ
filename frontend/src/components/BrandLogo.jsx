import { Link } from 'react-router-dom';

const sizes = {
  default: { emoji: '1.35rem', text: '1.15rem', gap: '0.5rem' },
  large: { emoji: '1.75rem', text: '1.5rem', gap: '0.55rem' },
  /** Global fixed top bar (AppLayout) */
  header: { emoji: '1.9rem', text: '1.6rem', gap: '0.55rem' },
  /** Landing page top-left brand */
  hero: { emoji: '2.35rem', text: '2rem', gap: '0.65rem' },
};

export default function BrandLogo({ to = '/', size = 'default' }) {
  const s = sizes[size] || sizes.default;
  return (
    <Link
      to={to}
      style={{ display: 'inline-flex', alignItems: 'center', gap: s.gap, textDecoration: 'none' }}
    >
      <span style={{ fontSize: s.emoji, lineHeight: 1 }} aria-hidden>
        📖
      </span>
      <span
        style={{
          fontWeight: 800,
          fontSize: s.text,
          letterSpacing: '-0.02em',
          background: 'linear-gradient(90deg, #8b5cf6, #3b82f6)',
          WebkitBackgroundClip: 'text',
          backgroundClip: 'text',
          color: 'transparent',
        }}
      >
        Fluentia
      </span>
    </Link>
  );
}
