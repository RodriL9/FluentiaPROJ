import { useNavigate } from 'react-router-dom';

const C = {
  bg: '#0f0f14', card: '#22222f', border: '#2e2e3f',
  accent: '#7c6af7', accentLight: '#a899ff',
  green: '#4ade80', text: '#f0eeff', muted: '#8b8aaa',
};

export default function ExercisesPage() {
  const navigate = useNavigate();

  return (
    <div style={{ fontFamily: "'DM Sans', sans-serif", color: C.text }}>
      <h1 style={{ fontSize: 28, fontWeight: 800, marginBottom: 4, letterSpacing: '-0.5px' }}>
        Practice Exercises
      </h1>
      <p style={{ color: C.muted, marginBottom: 24 }}>
        Choose an exercise to practice your Spanish.
      </p>

      <div style={{ display: 'flex', gap: 16 }}>
        {/* Mix and Match */}
        <button
         onClick={() => navigate('/dashboard/mix-match')}
          style={{
            flex: 1, padding: 24, borderRadius: 16, border: `1px solid ${C.accent}55`,
            background: `${C.accent}18`, cursor: 'pointer', textAlign: 'center',
            fontFamily: 'inherit', color: C.text,
          }}
        >
          <div style={{ fontSize: 28, marginBottom: 8 }}>🔀</div>
          <div style={{ fontSize: 16, fontWeight: 700 }}>Mix and Match</div>
          <div style={{ fontSize: 13, color: C.muted, marginTop: 6 }}>
            Match Spanish words to their English translations
          </div>
        </button>

        {/* Sound with Text */}
        <button
          onClick={() => navigate('/dashboard/exercises/sound-text')}
          style={{
            flex: 1, padding: 24, borderRadius: 16, border: `1px solid ${C.green}33`,
            background: `${C.green}11`, cursor: 'pointer', textAlign: 'center',
            fontFamily: 'inherit', color: C.text,
          }}
        >
          <div style={{ fontSize: 28, marginBottom: 8 }}>🔊</div>
          <div style={{ fontSize: 16, fontWeight: 700 }}>Sound with Text</div>
          <div style={{ fontSize: 13, color: C.muted, marginTop: 6 }}>
            Listen and match the audio to the correct word
          </div>
        </button>
      </div>
    </div>
  );
}