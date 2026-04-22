import { useNavigate } from 'react-router-dom';

const C = {
  bg: '#eef6f3', card: '#f8fffc', border: '#d8ece6',
  accent: '#3b82f6', accentLight: '#22c1c3',
  green: '#22c55e', text: '#0f172a', muted: '#64748b',
};

export default function ExercisesPage() {
  const navigate = useNavigate();
  const exercises = [
    {
      id: 'mix-match',
      title: 'Mix and Match',
      description: 'Match Spanish words to their English translations.',
      icon: '🔀',
      status: 'Open',
      route: '/dashboard/mix-match',
      cta: 'Start exercise',
      score: 100,
    },
    {
      id: 'sound-text',
      title: 'Sound with Text',
      description: 'Listen and match audio to the correct word.',
      icon: '🔊',
      status: 'Open',
      route: '/dashboard/lessons/4',
      cta: 'Start exercise',
      score: 100,
    },
  ];

  return (
    <div style={{ fontFamily: "'DM Sans', sans-serif", color: C.text }}>
      <div
        style={{
          background: 'linear-gradient(90deg, #3b82f6 0%, #22c1c3 100%)',
          border: `1px solid ${C.border}`,
          borderRadius: 18,
          padding: 16,
        }}
      >
        <div style={{ marginBottom: 12 }}>
          <p style={{ margin: 0, color: '#d9d2ff', fontSize: 18, fontWeight: 700 }}>Keep it going</p>
          <h1 style={{ margin: 0, fontSize: 46, lineHeight: 1.05, letterSpacing: '-0.5px', fontWeight: 800, color: '#ffffff' }}>Your Exercises</h1>
        </div>

        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, minmax(0, 1fr))', gap: 10 }}>
          {exercises.map((exercise) => (
            <article
              key={exercise.id}
              style={{
                background: '#f8f7ff',
                border: '1px solid #dbd6ff',
                borderRadius: 14,
                padding: 8,
                display: 'grid',
                gap: 6,
              }}
            >
              <div style={{ display: 'flex', alignItems: 'center', gap: 8, color: '#201a53' }}>
                <span>{exercise.icon}</span>
                <strong style={{ fontSize: 19 }}>{exercise.title}</strong>
              </div>

              <p style={{ margin: 0, fontSize: 15, color: '#4d4688', minHeight: 34 }}>
                {exercise.description}
              </p>

              <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                <div style={{ height: 8, borderRadius: 999, background: '#ddd9f7', flex: 1 }}>
                  <div style={{ width: `${exercise.score}%`, height: '100%', borderRadius: 999, background: 'linear-gradient(90deg, #7c6af7, #a899ff)' }} />
                </div>
                <strong style={{ color: '#4f478f', fontSize: 14 }}>{exercise.score}%</strong>
              </div>

              <button
                onClick={() => navigate(exercise.route)}
                style={{
                  width: '100%',
                  border: 'none',
                  borderRadius: 999,
                  height: 32,
                  fontFamily: 'inherit',
                  fontWeight: 700,
                  fontSize: 13,
                  cursor: 'pointer',
                  background: 'linear-gradient(90deg, #3b82f6 0%, #22c1c3 100%)',
                  color: '#ffffff',
                }}
              >
                {exercise.cta}
              </button>
            </article>
          ))}
        </div>

        <div style={{ marginTop: 14, border: '1px solid #3f3480', borderRadius: 12, padding: 10, background: 'rgba(19, 13, 54, 0.45)' }}>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, minmax(0, 1fr))', gap: 12 }}>
            <div>
              <div style={{ color: '#d7d1fa', fontWeight: 700, marginBottom: 4, fontSize: 20 }}>Exercises available</div>
              <div style={{ height: 8, borderRadius: 999, background: '#d9d5f7' }}>
                <div style={{ width: '100%', height: '100%', borderRadius: 999, background: 'linear-gradient(90deg, #7c6af7, #9e8fff)' }} />
              </div>
              <div style={{ marginTop: 5, color: '#ffffff', fontWeight: 700, fontSize: 29 }}>{exercises.length}/{exercises.length}</div>
            </div>
            <div>
              <div style={{ color: '#d7d1fa', fontWeight: 700, marginBottom: 4, fontSize: 20 }}>Active right now</div>
              <div style={{ height: 8, borderRadius: 999, background: '#d9d5f7' }}>
                <div style={{ width: `${Math.round((exercises.filter(e => e.status === 'Open').length / exercises.length) * 100)}%`, height: '100%', borderRadius: 999, background: 'linear-gradient(90deg, #34d399, #22c55e)' }} />
              </div>
              <div style={{ marginTop: 5, color: '#ffffff', fontWeight: 700, fontSize: 29 }}>{exercises.filter(e => e.status === 'Open').length}/{exercises.length}</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}