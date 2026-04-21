import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { getStoredUser } from '../api/auth';
import { fetchLessonCatalog } from '../api/lessons';

const C = {
  bg: '#0f0f14', card: '#22222f', border: '#2e2e3f',
  accent: '#7c6af7', accentLight: '#a899ff',
  green: '#4ade80', yellow: '#fbbf24',
  text: '#f0eeff', muted: '#8b8aaa',
};

export default function LessonsPage() {
  const navigate = useNavigate();
  const user = getStoredUser();
  const [lessons, setLessons] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    if (!user?.id) return;
    fetchLessonCatalog(user.id)
      .then(setLessons)
      .catch(e => setError(e.message))
      .finally(() => setLoading(false));
  }, [user?.id]);

  return (
    <div style={{ fontFamily: "'DM Sans', sans-serif", color: C.text }}>
      <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;600;700;800&display=swap" rel="stylesheet" />

      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 20 }}>
        <h1 style={{ fontSize: 28, fontWeight: 800, margin: 0, letterSpacing: '-0.5px' }}>Lessons</h1>
      
      </div>

      {loading && <p style={{ color: C.muted }}>Loading...</p>}
      {error && <p style={{ color: '#f87171' }}>{error}</p>}

      {!loading && !error && (
        <div>
          <div style={{ fontSize: 13, fontWeight: 700, color: C.muted, textTransform: 'uppercase', letterSpacing: '0.08em', marginBottom: 12 }}>
            Core Lessons
          </div>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 16 }}>
            {lessons.map(lesson => {
              const done = lesson.passed;
              const active = lesson.status === 'IN_PROGRESS';
              const locked = lesson.status === 'LOCKED';
              const n = lesson.lesson_number;
              return (
                <button
                  key={n}
                  onClick={() => { if (!locked) navigate(`/dashboard/lessons/${n}`); }}
                  style={{
                    background: active ? `${C.accent}18` : done ? `${C.green}0d` : C.card,
                    border: `1px solid ${active ? C.accent : done ? `${C.green}44` : C.border}`,
                    borderRadius: 16,
                    cursor: locked ? 'not-allowed' : 'pointer',
                    opacity: locked ? 0.45 : 1,
                    textAlign: 'left',
                    padding: '20px 18px',
                    fontFamily: 'inherit',
                    outline: 'none',
                    minHeight: 90,
                    display: 'flex',
                    flexDirection: 'column',
                    justifyContent: 'flex-start',
                    gap: 6,
                  }}
                >
                  <div style={{ fontSize: 11, fontWeight: 600, letterSpacing: '0.04em', color: active ? C.accentLight : done ? C.green : C.muted, marginBottom: 2 }}>
                    {done ? '✓ DONE' : active ? '▶ IN PROGRESS' : locked ? '🔒 LOCKED' : `LESSON ${n}`}
                  </div>
                  <div style={{ fontSize: 15, fontWeight: 700, color: C.text, lineHeight: 1.4 }}>
                    {lesson.title}
                  </div>
                </button>
              );
            })}
          </div>
        </div>
      )}
    </div>
  );
}