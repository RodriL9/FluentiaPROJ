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
      .then((rows) => setLessons(Array.isArray(rows) ? rows : []))
      .catch(e => setError(e.message))
      .finally(() => setLoading(false));
  }, [user?.id]);

  const completedCount = lessons.filter((lesson) => lesson.status === 'COMPLETED' || lesson.passed).length;
  const unlockedCount = lessons.filter((lesson) => lesson.status !== 'LOCKED').length;

  const statusMeta = (lesson) => {
    const status = String(lesson.status || '').toUpperCase();
    if (status === 'LOCKED') return { label: 'Locked', emoji: '🔒', tone: C.muted, button: 'Locked', disabled: true };
    if (status === 'IN_PROGRESS') return { label: 'Open', emoji: '▶', tone: C.accentLight, button: 'Resume lesson', disabled: false };
    if (status === 'COMPLETED' || lesson.passed) return { label: 'Completed', emoji: '✓', tone: C.green, button: 'Review lesson', disabled: false };
    return { label: 'Open', emoji: '📘', tone: C.accentLight, button: 'Start lesson', disabled: false };
  };

  return (
    <div style={{ fontFamily: "'DM Sans', sans-serif", color: C.text }}>
      <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;600;700;800&display=swap" rel="stylesheet" />

      {loading && <p style={{ color: C.muted }}>Loading...</p>}
      {error && <p style={{ color: '#f87171' }}>{error}</p>}

      {!loading && !error && (
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
            <h1 style={{ margin: 0, fontSize: 46, lineHeight: 1.05, letterSpacing: '-0.5px', fontWeight: 800 }}>Your Lessons</h1>
          </div>

          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, minmax(0, 1fr))', gap: 10 }}>
            {lessons.map(lesson => {
              const meta = statusMeta(lesson);
              const n = lesson.lesson_number;
              const isCompleted = String(lesson.status || '').toUpperCase() === 'COMPLETED' || lesson.passed;
              const pct = Math.min(100, Math.max(0, Math.round(Number(lesson.score_percentage || (lesson.passed ? 100 : 0)))));
              return (
                <article
                  key={n}
                  style={{
                    background: '#f8f7ff',
                    border: '1px solid #dbd6ff',
                    borderRadius: 14,
                    padding: 8,
                    display: 'grid',
                    gap: 6,
                  }}
                >
                  <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 8, color: '#201a53' }}>
                    <strong style={{ fontSize: 19 }}>Lesson {n}</strong>
                    {isCompleted ? (
                      <span style={{ fontSize: 11, fontWeight: 700, color: '#534b92', background: '#e9e5ff', borderRadius: 999, padding: '3px 8px' }}>
                        Completed
                      </span>
                    ) : null}
                  </div>

                  <p style={{ margin: 0, fontSize: 15, color: '#4d4688', minHeight: 34 }}>
                    {lesson.title || 'Untitled lesson'}
                  </p>

                  <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                    <div style={{ height: 8, borderRadius: 999, background: '#ddd9f7', flex: 1 }}>
                      <div style={{ width: `${pct}%`, height: '100%', borderRadius: 999, background: 'linear-gradient(90deg, #7c6af7, #a899ff)' }} />
                    </div>
                    <strong style={{ color: '#4f478f', fontSize: 14 }}>{pct}%</strong>
                  </div>

                  <button
                    onClick={() => { if (!meta.disabled) navigate(`/dashboard/lessons/${n}`); }}
                    disabled={meta.disabled}
                    style={{
                      width: '100%',
                      border: 'none',
                      borderRadius: 999,
                      height: 32,
                      fontFamily: 'inherit',
                      fontWeight: 700,
                      fontSize: 13,
                      cursor: meta.disabled ? 'not-allowed' : 'pointer',
                      background: meta.disabled ? '#d6d3e9' : 'linear-gradient(90deg, #3b82f6 0%, #22c1c3 100%)',
                      color: meta.disabled ? '#686380' : '#ffffff',
                      opacity: meta.disabled ? 0.85 : 1,
                    }}
                  >
                    {meta.button}
                  </button>
                </article>
              );
            })}
          </div>

          <div style={{ marginTop: 14, border: '1px solid #3f3480', borderRadius: 12, padding: 10, background: 'rgba(19, 13, 54, 0.45)' }}>
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, minmax(0, 1fr))', gap: 12 }}>
              <div>
                <div style={{ color: '#d7d1fa', fontWeight: 700, marginBottom: 4, fontSize: 20 }}>Completed lessons</div>
                <div style={{ height: 8, borderRadius: 999, background: '#d9d5f7' }}>
                  <div style={{ width: `${lessons.length ? Math.round((completedCount / lessons.length) * 100) : 0}%`, height: '100%', borderRadius: 999, background: 'linear-gradient(90deg, #7c6af7, #9e8fff)' }} />
                </div>
                <div style={{ marginTop: 5, color: '#ffffff', fontWeight: 700, fontSize: 29 }}>{completedCount}/{lessons.length}</div>
              </div>
              <div>
                <div style={{ color: '#d7d1fa', fontWeight: 700, marginBottom: 4, fontSize: 20 }}>Unlocked lessons</div>
                <div style={{ height: 8, borderRadius: 999, background: '#d9d5f7' }}>
                  <div style={{ width: `${lessons.length ? Math.round((unlockedCount / lessons.length) * 100) : 0}%`, height: '100%', borderRadius: 999, background: 'linear-gradient(90deg, #34d399, #22c55e)' }} />
                </div>
                <div style={{ marginTop: 5, color: '#ffffff', fontWeight: 700, fontSize: 29 }}>{unlockedCount}/{lessons.length}</div>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}