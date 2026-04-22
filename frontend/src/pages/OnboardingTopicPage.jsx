import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { fetchTopics, getStoredUser, setStoredUser, updateUserTopics } from '../api/auth';

function formatTopicLabel(raw) {
  return String(raw || '')
    .replaceAll('_', ' ')
    .toLowerCase()
    .replace(/\b\w/g, (m) => m.toUpperCase());
}

function stripUnderscores(raw) {
  return String(raw ?? '').replaceAll('_', ' ');
}

function fallbackTopicIcon(codeOrName) {
  const key = String(codeOrName || '').toLowerCase();
  if (key.includes('travel')) return '✈️';
  if (key.includes('business') || key.includes('work')) return '💼';
  if (key.includes('conversation')) return '🗣️';
  if (key.includes('grammar')) return '📚';
  if (key.includes('listening')) return '🎧';
  if (key.includes('writing')) return '✍️';
  if (key.includes('health')) return '🏥';
  if (key.includes('food')) return '🍽️';
  return '📌';
}

export default function OnboardingTopicPage() {
  const navigate = useNavigate();
  const stored = getStoredUser();
  const [topics, setTopics] = useState([]);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(true);
  const initialTopics =
    stored?.learningGoals
      ? String(stored.learningGoals)
          .split(',')
          .map((s) => s.trim())
          .filter(Boolean)
      : [];
  const [selectedTopics, setSelectedTopics] = useState(initialTopics);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    document.body.classList.add('fl-auth-light-body');
    return () => {
      document.body.classList.remove('fl-auth-light-body');
    };
  }, []);

  useEffect(() => {
    if (!stored) {
      navigate('/login', { replace: true });
      return;
    }
    let cancelled = false;
    (async () => {
      try {
        const data = await fetchTopics(stored.learningLanguage || 'es');
        if (!cancelled) setTopics(Array.isArray(data) ? data : []);
      } catch (err) {
        if (!cancelled) setError(err.message || 'Could not load topics.');
      } finally {
        if (!cancelled) setLoading(false);
      }
    })();
    return () => {
      cancelled = true;
    };
  }, [stored, navigate]);

  if (!stored) return null;

  return (
    <div className="fl-auth-page fl-login-page">
      <div className="fl-auth-card" style={{ maxWidth: '760px' }}>
        <h1 className="fl-auth-title">Choose your topics</h1>
        <p className="fl-auth-sub">
          Select at least two topics you want to focus on. Tap a card again to deselect.
        </p>

        {error ? (
          <p className="fl-auth-error" role="alert">
            {error}
          </p>
        ) : null}

        {loading ? (
          <p className="fl-auth-sub">Loading topics…</p>
        ) : topics.length === 0 ? (
          <p className="fl-auth-sub">No topics are available yet for this language. Please try another language.</p>
        ) : topics.length === 1 ? (
          <p className="fl-auth-error" role="alert">
            At least two topics are required. Add another topic for this language in your database, then refresh this
            page.
          </p>
        ) : (
          <form
            onSubmit={async (e) => {
              e.preventDefault();
              setError('');
              if (selectedTopics.length < 2) {
                setError('Please choose at least two topics to continue.');
                return;
              }
              setSaving(true);
              try {
                const updated = await updateUserTopics(stored.id, selectedTopics);
                setStoredUser({ ...stored, ...updated });
                navigate('/dashboard', { replace: true });
              } catch (err) {
                setError(err.message || 'Could not save topics.');
              } finally {
                setSaving(false);
              }
            }}
          >
            <div className="fl-topic-grid">
              {topics.map((t) => {
                const topicValue = t.code || t.name || t.id;
                const title = formatTopicLabel(t.name || t.code || t.id);
                const subtitle = stripUnderscores(t.description || '');
                const icon = t.icon || fallbackTopicIcon(t.code || t.name);
                const active = selectedTopics.includes(topicValue);
                return (
                  <button
                    key={t.id || topicValue}
                    type="button"
                    className={`fl-topic-card${active ? ' fl-topic-card-active' : ''}`}
                    onClick={() => {
                      setSelectedTopics((prev) =>
                        prev.includes(topicValue)
                          ? prev.filter((x) => x !== topicValue)
                          : [...prev, topicValue],
                      );
                    }}
                  >
                    <div className="fl-topic-card-icon" aria-hidden>
                      {icon}
                    </div>
                    <div className="fl-topic-card-title">{title}</div>
                    {subtitle ? <div className="fl-topic-card-sub">{subtitle}</div> : null}
                  </button>
                );
              })}
            </div>

            <p className="fl-auth-sub" style={{ marginTop: '0.5rem' }}>
              Selected: {selectedTopics.length} / at least 2
            </p>
            <button type="submit" className="fl-btn fl-btn-primary fl-btn-block" disabled={saving}>
              {saving ? 'Saving topics…' : 'Continue to dashboard'}
            </button>
          </form>
        )}
      </div>
    </div>
  );
}

