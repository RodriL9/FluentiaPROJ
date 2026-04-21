import { useEffect, useState } from 'react';
import { getStoredUser } from '../api/auth';
import TopicLessonPage from './TopicLessonPage';

const C = {
  bg: '#0f0f14', card: '#22222f', border: '#2e2e3f',
  accent: '#7c6af7', accentLight: '#a899ff',
  green: '#4ade80', yellow: '#fbbf24',
  text: '#f0eeff', muted: '#8b8aaa', surface: '#1a1a24', dim: '#3d3d55',
};

const ALL_TOPICS = [
  { code: 'CONVERSATION_ES', name: 'Everyday Conversation', icon: '💬', count: 35 },
  { code: 'TRAVEL_ES', name: 'Travel & Tourism', icon: '✈️', count: 20 },
  { code: 'BUSINESS_ES', name: 'Business & Professional', icon: '💼', count: 15 },
  { code: 'WRITING_ES', name: 'Writing Skills', icon: '✍️', count: 10 },
  { code: 'FOOD_ES', name: 'Food & Culture', icon: '🍽️', count: 10 },
  { code: 'HEALTH_ES', name: 'Health & Emergencies', icon: '🏥', count: 5 },
  { code: 'GRAMMAR_ES', name: 'Grammar Foundations', icon: '📝', count: 5 },
];

const btnS = (v = 'primary') => ({
  padding: v === 'sm' ? '6px 14px' : '10px 20px', borderRadius: 10, border: 'none',
  cursor: 'pointer', fontFamily: 'inherit', fontWeight: 600,
  fontSize: v === 'sm' ? 12 : 14, transition: 'all 0.15s',
  background: v === 'primary' ? C.accent : v === 'ghost' ? 'transparent' : C.card,
  color: v === 'primary' ? '#fff' : v === 'ghost' ? C.muted : C.text,
  ...(v === 'ghost' ? { border: `1px solid ${C.border}` } : {}),
});

function speakWord(word, lang) {
  if (!window.speechSynthesis) return;
  window.speechSynthesis.cancel();
  const utt = new SpeechSynthesisUtterance(String(word || ''));
  utt.lang = lang === 'es' ? 'es-ES' : 'en-US';
  utt.rate = 0.9;
  window.speechSynthesis.speak(utt);
}

export default function TopicsPage() {
  const user = getStoredUser();
  const [userTopics, setUserTopics] = useState([]);
  const [topicData, setTopicData] = useState({});
  const [topicLessons, setTopicLessons] = useState({});
  const [expandedTopic, setExpandedTopic] = useState(null);
  const [activeView, setActiveView] = useState({});
  const [flashcardIndex, setFlashcardIndex] = useState({});
  const [flippedCards, setFlippedCards] = useState({});
  const [addingTopic, setAddingTopic] = useState(null);
  const [loading, setLoading] = useState(true);
  const [activeLessonId, setActiveLessonId] = useState(null);
const [activeLessonTitle, setActiveLessonTitle] = useState('');

  useEffect(() => {
    if (!user?.id) return;
    const topics = String(user.learningGoals || '').split(',').map(s => s.trim()).filter(Boolean);
    setUserTopics(topics);
    setLoading(false);
  }, [user?.id]);

  const loadTopicContent = async (topicCode) => {
    if (topicData[topicCode]) return;
    try {
      const res = await fetch(`/api/topics?language=${encodeURIComponent(user.learningLanguage || 'es')}`);
      const allTopics = await res.json();
      const topic = allTopics.find(t => t.code === topicCode);
      if (!topic?.id) return;

      const contentRes = await fetch(`/api/topics/${topic.id}/content`);
      const content = await contentRes.json();

      // Load lessons from units
      const units = Array.isArray(content.units) ? content.units : [];
      const lessonList = [];
      for (const unit of units) {
        const lRes = await fetch(`/api/units/${unit.id}`);
        if (lRes.ok) {
          const lData = await lRes.json();
          (lData.lessons || []).forEach(l => lessonList.push({ ...l, unitTitle: unit.title }));
        }
      }

      setTopicData(prev => ({
        ...prev,
        [topicCode]: {
          vocabulary: Array.isArray(content.vocabulary) ? content.vocabulary : [],
          phrases: Array.isArray(content.phrases) ? content.phrases : [],
        }
      }));
      setTopicLessons(prev => ({ ...prev, [topicCode]: lessonList }));
    } catch {}
  };

  const handleExpandTopic = (code) => {
    if (expandedTopic === code) {
      setExpandedTopic(null);
    } else {
      setExpandedTopic(code);
      loadTopicContent(code);
      if (!activeView[code]) setActiveView(prev => ({ ...prev, [code]: 'lessons' }));
    }
  };

const handleAddTopic = async (topicCode) => {
  setAddingTopic(topicCode);
  try {
    const res = await fetch('/api/me/topics/add', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ userId: user.id, topicCode }),
    });
    const data = res.ok ? await res.json() : null;
    if (data?.ok) {
      setUserTopics(prev => [...prev, topicCode]);
      // Update session storage so it persists on navigation
      const stored = JSON.parse(sessionStorage.getItem('fluentiaUser') || '{}');
      stored.learningGoals = data.learning_goals;
      sessionStorage.setItem('fluentiaUser', JSON.stringify(stored));
    }
  } catch {}
  finally { setAddingTopic(null); }
};

  const myTopics = ALL_TOPICS.filter(t => userTopics.includes(t.code));
  const otherTopics = ALL_TOPICS.filter(t => !userTopics.includes(t.code));

  const getFlashcardIndex = (code) => flashcardIndex[code] || 0;
  const setFCI = (code, val) => setFlashcardIndex(prev => ({ ...prev, [code]: val }));
  const isFlipped = (key) => Boolean(flippedCards[key]);
  const toggleFlip = (key) => setFlippedCards(prev => ({ ...prev, [key]: !prev[key] }));

  return (
    
    <div style={{ fontFamily: "'DM Sans', sans-serif", color: C.text }}>
      <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;600;700;800&display=swap" rel="stylesheet" />
      <h1 style={{ fontSize: 28, fontWeight: 800, margin: '0 0 4px', letterSpacing: '-0.5px' }}>Topics</h1>
      <p style={{ color: C.muted, marginBottom: 24, fontSize: 14 }}>Your chosen topics and their lessons.</p>

      {/* ── YOUR TOPICS ── */}
      {myTopics.length > 0 && (
        <div style={{ marginBottom: 32 }}>
          <div style={{ fontSize: 13, fontWeight: 700, color: C.muted, textTransform: 'uppercase', letterSpacing: '0.08em', marginBottom: 12 }}>
            Your Topics
          </div>
          <div style={{ display: 'grid', gap: 12 }}>
            {myTopics.map(topic => {
              const isExpanded = expandedTopic === topic.code;
              const view = activeView[topic.code] || 'lessons';
              const data = topicData[topic.code];
              const lessons = topicLessons[topic.code];
              const fci = getFlashcardIndex(topic.code);

              if (activeLessonId) {
  return <TopicLessonPage lessonId={activeLessonId} lessonTitle={activeLessonTitle} onBack={() => setActiveLessonId(null)} />;
}

              return (
                <div key={topic.code} style={{ border: `1px solid ${isExpanded ? C.accent : C.border}`, borderRadius: 16, overflow: 'hidden', background: C.card }}>
                  {/* Header */}
                  <button onClick={() => handleExpandTopic(topic.code)}
                    style={{ width: '100%', display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '16px 20px', background: isExpanded ? `${C.accent}12` : 'transparent', border: 'none', cursor: 'pointer', color: C.text, fontFamily: 'inherit' }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
                      <span style={{ fontSize: 24 }}>{topic.icon}</span>
                      <div style={{ textAlign: 'left' }}>
                        <div style={{ fontWeight: 700, fontSize: 16 }}>{topic.name}</div>
                        <div style={{ fontSize: 12, color: C.muted }}>{topic.count} lessons</div>
                      </div>
                    </div>
                    <span style={{ color: C.muted, fontSize: 18 }}>{isExpanded ? '▲' : '▼'}</span>
                  </button>

                  {/* Expanded content */}
                  {isExpanded && (
                    <div style={{ borderTop: `1px solid ${C.border}`, padding: 20 }}>
                      {/* View tabs */}
                      <div style={{ display: 'flex', gap: 8, marginBottom: 16 }}>
                        {['lessons', 'vocabulary', 'phrases'].map(v => (
                          <button key={v} onClick={() => setActiveView(prev => ({ ...prev, [topic.code]: v }))}
                            style={{ ...btnS(view === v ? 'primary' : 'ghost'), fontSize: 13, padding: '6px 16px' }}>
                            {v.charAt(0).toUpperCase() + v.slice(1)}
                          </button>
                        ))}
                      </div>

                      {/* LESSONS VIEW */}
                      {view === 'lessons' && (
                        <div style={{ display: 'grid', gap: 8 }}>
                          {!lessons ? (
                            <p style={{ color: C.muted, fontSize: 13 }}>Loading lessons...</p>
                          ) : lessons.length === 0 ? (
                            <p style={{ color: C.muted, fontSize: 13 }}>No lessons found.</p>
                          ) : (
                            lessons.map(lesson => (
                              <div key={lesson.id} style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '12px 16px', background: C.surface, borderRadius: 12, border: `1px solid ${C.border}` }}>
                                <div>
                                  <div style={{ fontWeight: 600, fontSize: 14, color: C.text }}>{lesson.title}</div>
                                  <div style={{ fontSize: 12, color: C.muted, marginTop: 2 }}>{lesson.lesson_type} · {lesson.estimated_minutes} min · +{lesson.xp_reward} XP</div>
                                </div>
<button onClick={() => { setActiveLessonId(lesson.id); setActiveLessonTitle(lesson.title); }} style={{ ...btnS(), fontSize: 12, padding: '6px 14px' }}>Start →</button>                              </div>
                            ))
                          )}
                        </div>
                      )}

                      {/* VOCABULARY VIEW */}
                      {view === 'vocabulary' && (() => {
                        if (!data) return <p style={{ color: C.muted, fontSize: 13 }}>Loading...</p>;
                        const words = data.vocabulary;
                        if (!words.length) return <p style={{ color: C.muted }}>No vocabulary for this topic.</p>;
                        const cur = words[fci] || {};
                        const cardKey = `${topic.code}-vocab-${fci}`;
                        const flipped = isFlipped(cardKey);
                        return (
                          <>
                            <button onClick={() => toggleFlip(cardKey)}
                              style={{ width: '100%', minHeight: 160, borderRadius: 14, border: `1px solid ${C.border}`, background: flipped ? `${C.accent}18` : C.surface, padding: 24, textAlign: 'center', cursor: 'pointer', color: C.text, fontFamily: 'inherit' }}>
                              {!flipped
                                ? <><div style={{ fontSize: '2rem', fontWeight: 800 }}>{cur.word}</div><div style={{ color: C.muted, marginTop: 8, fontSize: 13 }}>Tap to flip</div></>
                                : <><div style={{ fontSize: '1.8rem', fontWeight: 800 }}>{cur.translation}</div><div style={{ color: C.muted, marginTop: 8, fontSize: 13 }}>{cur.example_sentence || ''}</div></>
                              }
                            </button>
                            <div style={{ display: 'flex', gap: 8, marginTop: 12, alignItems: 'center' }}>
                              <button style={btnS('ghost')} onClick={() => setFCI(topic.code, Math.max(0, fci - 1))}>← Prev</button>
                              <button style={{ ...btnS('ghost'), padding: '8px 12px' }} onClick={() => speakWord(cur.word, user.learningLanguage)}>🔊</button>
                              <button style={btnS('ghost')} onClick={() => setFCI(topic.code, Math.min(words.length - 1, fci + 1))}>Next →</button>
                              <span style={{ marginLeft: 'auto', color: C.muted, fontSize: 13 }}>{fci + 1}/{words.length}</span>
                            </div>
                          </>
                        );
                      })()}

                      {/* PHRASES VIEW */}
                      {view === 'phrases' && (() => {
                        if (!data) return <p style={{ color: C.muted, fontSize: 13 }}>Loading...</p>;
                        const phrases = data.phrases;
                        if (!phrases.length) return <p style={{ color: C.muted }}>No phrases for this topic.</p>;
                        const cur = phrases[fci] || {};
                        const cardKey = `${topic.code}-phrase-${fci}`;
                        const flipped = isFlipped(cardKey);
                        return (
                          <>
                            <button onClick={() => toggleFlip(cardKey)}
                              style={{ width: '100%', minHeight: 160, borderRadius: 14, border: `1px solid ${C.border}`, background: flipped ? `${C.green}18` : C.surface, padding: 24, textAlign: 'center', cursor: 'pointer', color: C.text, fontFamily: 'inherit' }}>
                              {!flipped
                                ? <div style={{ fontSize: '1.5rem', fontWeight: 800 }}>{cur.phrase}</div>
                                : <><div style={{ fontSize: '1.3rem', fontWeight: 700 }}>{cur.translation}</div><div style={{ color: C.muted, marginTop: 8, fontSize: 13 }}>{cur.context || ''}</div></>
                              }
                            </button>
                            <div style={{ display: 'flex', gap: 8, marginTop: 12, alignItems: 'center' }}>
                              <button style={btnS('ghost')} onClick={() => setFCI(topic.code, Math.max(0, fci - 1))}>← Prev</button>
                              <button style={{ ...btnS('ghost'), padding: '8px 12px' }} onClick={() => speakWord(cur.phrase, user.learningLanguage)}>🔊</button>
                              <button style={btnS('ghost')} onClick={() => setFCI(topic.code, Math.min(phrases.length - 1, fci + 1))}>Next →</button>
                              <span style={{ marginLeft: 'auto', color: C.muted, fontSize: 13 }}>{fci + 1}/{phrases.length}</span>
                            </div>
                          </>
                        );
                      })()}
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        </div>
      )}

      {/* ── EXPLORE MORE TOPICS ── */}
      {otherTopics.length > 0 && (
        <div>
          <div style={{ fontSize: 13, fontWeight: 700, color: C.muted, textTransform: 'uppercase', letterSpacing: '0.08em', marginBottom: 12 }}>
            Explore More Topics
          </div>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: 12 }}>
            {otherTopics.map(topic => (
              <div key={topic.code} style={{ background: C.card, borderRadius: 14, border: `1px solid ${C.border}`, padding: '16px 18px', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                  <span style={{ fontSize: 22 }}>{topic.icon}</span>
                  <div>
                    <div style={{ fontWeight: 700, fontSize: 14, color: C.text }}>{topic.name}</div>
                    <div style={{ fontSize: 12, color: C.muted }}>{topic.count} lessons</div>
                  </div>
                </div>
                <button onClick={() => handleAddTopic(topic.code)} disabled={addingTopic === topic.code}
                  style={{ background: `${C.accent}22`, border: `1px solid ${C.accent}44`, borderRadius: 8, padding: '6px 14px', color: C.accentLight, fontSize: 12, fontWeight: 600, cursor: 'pointer', fontFamily: 'inherit', whiteSpace: 'nowrap' }}>
                  {addingTopic === topic.code ? 'Adding...' : '+ Add'}
                </button>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}