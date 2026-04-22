import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { getStoredUser } from '../api/auth';
import TopicLessonPage from './TopicLessonPage';
import { speakFluent } from '../utils/speech';

const C = {
  bg: '#eef6f3', card: '#f8fffc', border: '#d8ece6',
  accent: '#3b82f6', accentLight: '#22c1c3',
  green: '#22c55e', yellow: '#f59e0b',
  text: '#0f172a', muted: '#64748b', surface: '#f1f5f9', dim: '#d9e8e4',
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
const TOPIC_LECTURE_EMBEDS = {
  CONVERSATION_ES: '',
  TRAVEL_ES: 'https://www.youtube.com/embed/ldcTmCedw98?si=94LhJE5Rr28e3BWq',
  BUSINESS_ES: 'https://www.youtube.com/embed/Z-eq6FqOhgM?si=mlverL4dOfJ-jbnw',
  WRITING_ES: '',
  FOOD_ES: '',
  HEALTH_ES: '',
  GRAMMAR_ES: '',
};

const btnS = (v = 'primary') => ({
  padding: v === 'sm' ? '6px 14px' : '10px 20px', borderRadius: 10, border: 'none',
  cursor: 'pointer', fontFamily: 'inherit', fontWeight: 600,
  fontSize: v === 'sm' ? 12 : 14, transition: 'all 0.15s',
  background: v === 'primary' ? 'linear-gradient(90deg, #3b82f6 0%, #22c1c3 100%)' : v === 'ghost' ? 'transparent' : C.card,
  color: v === 'primary' ? '#fff' : v === 'ghost' ? C.muted : C.text,
  ...(v === 'ghost' ? { border: `1px solid ${C.border}` } : {}),
});

function speakWord(word, lang) {
  speakFluent(String(word || ''), { language: lang || 'es', rate: 0.9 });
}

function lessonTypeIcon(type) {
  const t = String(type || '').toUpperCase();
  if (t.includes('GRAMMAR')) return '🧩';
  if (t.includes('LISTEN')) return '🎧';
  if (t.includes('READ')) return '📖';
  if (t.includes('SPEAK')) return '🗣️';
  if (t.includes('WRITE')) return '✍️';
  if (t.includes('REVIEW')) return '✅';
  return '📘';
}

export default function TopicsPage({ selectedTopicCode = '' }) {
  const navigate = useNavigate();
  const user = getStoredUser();
  const [userTopics, setUserTopics] = useState([]);
  const [topicData, setTopicData] = useState({});
  const [topicLessons, setTopicLessons] = useState({});
  const [activeView, setActiveView] = useState({});
  const [flashcardIndex, setFlashcardIndex] = useState({});
  const [flippedCards, setFlippedCards] = useState({});
  const [addingTopic, setAddingTopic] = useState(null);
  const [removingTopic, setRemovingTopic] = useState(null);
  const [pendingRemoveTopic, setPendingRemoveTopic] = useState(null);
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

const handleRemoveTopic = async (topicCode) => {
  const topic = ALL_TOPICS.find(t => t.code === topicCode) || { code: topicCode, name: topicCode };
  setPendingRemoveTopic(topic);
};

const confirmRemoveTopic = async () => {
  if (!pendingRemoveTopic) return;
  const topicCode = pendingRemoveTopic.code;
  setRemovingTopic(topicCode);
  try {
    const res = await fetch('/api/me/topics/remove', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ userId: user.id, topicCode }),
    });
    const data = res.ok ? await res.json() : null;
    if (data?.ok) {
      setUserTopics(prev => prev.filter(code => code !== topicCode));
      if (selectedTopicCode === topicCode) navigate('/dashboard/topics');
      const stored = JSON.parse(sessionStorage.getItem('fluentiaUser') || '{}');
      stored.learningGoals = data.learning_goals;
      sessionStorage.setItem('fluentiaUser', JSON.stringify(stored));
    }
  } catch {}
  finally {
    setRemovingTopic(null);
    setPendingRemoveTopic(null);
  }
};

  const myTopics = ALL_TOPICS.filter(t => userTopics.includes(t.code));
  const otherTopics = ALL_TOPICS.filter(t => !userTopics.includes(t.code));

  const getFlashcardIndex = (code) => flashcardIndex[code] || 0;
  const setFCI = (code, val) => setFlashcardIndex(prev => ({ ...prev, [code]: val }));
  const isFlipped = (key) => Boolean(flippedCards[key]);
  const toggleFlip = (key) => setFlippedCards(prev => ({ ...prev, [key]: !prev[key] }));
  const selectedTopic = myTopics.find(t => t.code === selectedTopicCode) || null;
  const selectedView = selectedTopic ? (activeView[selectedTopic.code] || 'lessons') : 'lessons';
  const selectedData = selectedTopic ? topicData[selectedTopic.code] : null;
  const selectedLessons = selectedTopic ? topicLessons[selectedTopic.code] : null;
  const selectedFci = selectedTopic ? getFlashcardIndex(selectedTopic.code) : 0;
  const selectedTopicLectureEmbed = selectedTopic ? (TOPIC_LECTURE_EMBEDS[selectedTopic.code] || '') : '';

  useEffect(() => {
    if (!selectedTopicCode) return;
    loadTopicContent(selectedTopicCode);
    setActiveView(prev => prev[selectedTopicCode] ? prev : ({ ...prev, [selectedTopicCode]: 'lessons' }));
  }, [selectedTopicCode]);

  if (activeLessonId) {
    return <TopicLessonPage lessonId={activeLessonId} lessonTitle={activeLessonTitle} onBack={() => setActiveLessonId(null)} />;
  }

  return (
    <div style={{ fontFamily: "'DM Sans', sans-serif", color: C.text }}>
      <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;600;700;800&display=swap" rel="stylesheet" />
      <div style={{ background: 'linear-gradient(90deg, #3b82f6 0%, #22c1c3 100%)', border: `1px solid ${C.border}`, borderRadius: 18, padding: 16 }}>
        <p style={{ margin: 0, color: '#d9d2ff', fontSize: 18, fontWeight: 700 }}>Keep it going</p>
        <h1 style={{ margin: 0, fontSize: 46, lineHeight: 1.05, letterSpacing: '-0.5px', fontWeight: 800, color: '#ffffff' }}>Your Topics</h1>
        <p style={{ color: 'rgba(255,255,255,0.92)', marginBottom: 16, fontSize: 14 }}>
          {selectedTopic ? `Viewing ${selectedTopic.name}` : 'Pick any topic card to open lessons, vocabulary, and phrases.'}
        </p>

        {!selectedTopic && (
          <>
            {/* ── YOUR TOPICS ── */}
            {myTopics.length > 0 ? (
              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, minmax(0, 1fr))', gap: 10 }}>
                {myTopics.map(topic => {
                  return (
                    <article key={topic.code} style={{ background: '#f8f7ff', border: '1px solid #dbd6ff', borderRadius: 14, padding: 8, display: 'grid', gap: 6 }}>
                      <div style={{ display: 'flex', alignItems: 'center', gap: 8, color: '#201a53' }}>
                        <span>{topic.icon}</span>
                        <strong style={{ fontSize: 19 }}>{topic.name}</strong>
                      </div>

                      <p style={{ margin: 0, fontSize: 15, color: '#4d4688', minHeight: 34 }}>
                        {topic.count} lessons in this topic track.
                      </p>

                      <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                        <div style={{ height: 8, borderRadius: 999, background: '#ddd9f7', flex: 1 }}>
                          <div style={{ width: '100%', height: '100%', borderRadius: 999, background: 'linear-gradient(90deg, #7c6af7, #a899ff)' }} />
                        </div>
                        <strong style={{ color: '#4f478f', fontSize: 14 }}>{topic.count}</strong>
                      </div>

                      <div style={{ display: 'flex', gap: 8 }}>
                        <button
                          onClick={() => navigate(`/dashboard/topics/${encodeURIComponent(topic.code)}`)}
                          style={{
                            flex: 1,
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
                          Open topic
                        </button>
                        <button
                          onClick={() => handleRemoveTopic(topic.code)}
                          disabled={removingTopic === topic.code}
                          style={{
                            border: '1px solid #fca5a5',
                            borderRadius: 999,
                            height: 32,
                            padding: '0 12px',
                            fontFamily: 'inherit',
                            fontWeight: 700,
                            fontSize: 12,
                            cursor: 'pointer',
                            background: '#fff1f2',
                            color: '#dc2626',
                            whiteSpace: 'nowrap',
                          }}
                        >
                          {removingTopic === topic.code ? 'Removing...' : 'Remove'}
                        </button>
                      </div>
                    </article>
                  );
                })}
              </div>
            ) : (
              <div style={{ ...btnS('ghost'), textAlign: 'center', width: '100%', background: 'rgba(255,255,255,0.32)', color: '#ffffff' }}>No topics selected yet.</div>
            )}
          </>
        )}

        {/* Expanded topic details */}
        {selectedTopic && (
          <div style={{ marginTop: 6, border: '1px solid #3f3480', borderRadius: 12, padding: 12, background: 'rgba(19, 13, 54, 0.45)' }}>
            <div style={{ marginBottom: 10 }}>
              <button onClick={() => navigate('/dashboard/topics')} style={{ ...btnS('ghost'), fontSize: 12, padding: '6px 12px', color: '#dce6ff', borderColor: '#6d64a8' }}>
                ← Back to all topics
              </button>
            </div>
            <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 10 }}>
              <span style={{ fontSize: 22 }}>{selectedTopic.icon}</span>
              <strong style={{ color: '#ffffff', fontSize: 22 }}>{selectedTopic.name}</strong>
            </div>
            <div style={{ display: 'flex', gap: 8, marginBottom: 16 }}>
              {['lessons', 'vocabulary', 'phrases', 'lecture'].map(v => (
                <button key={v} onClick={() => setActiveView(prev => ({ ...prev, [selectedTopic.code]: v }))}
                  style={{
                    ...btnS(selectedView === v ? 'primary' : 'ghost'),
                    fontSize: 13,
                    padding: '6px 16px',
                    color: selectedView === v ? '#fff' : '#0f172a',
                    background: selectedView === v ? 'linear-gradient(90deg, #3b82f6 0%, #22c1c3 100%)' : 'rgba(255,255,255,0.92)',
                    border: selectedView === v ? 'none' : '1px solid #d8ece6',
                  }}>
                  {v.charAt(0).toUpperCase() + v.slice(1)}
                </button>
              ))}
            </div>

            {/* LESSONS VIEW */}
            {selectedView === 'lessons' && (
              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, minmax(0, 1fr))', gap: 10 }}>
                {!selectedLessons ? (
                  <p style={{ color: '#e2e8f0', fontSize: 13, gridColumn: '1 / -1' }}>Loading lessons...</p>
                ) : selectedLessons.length === 0 ? (
                  <p style={{ color: '#e2e8f0', fontSize: 13, gridColumn: '1 / -1' }}>No lessons found.</p>
                ) : (
                  selectedLessons.map(lesson => (
                    <article
                      key={lesson.id}
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
                        <strong style={{ fontSize: 19, display: 'flex', alignItems: 'center', gap: 8 }}>
                          <span>{lessonTypeIcon(lesson.lesson_type)}</span>
                          <span>{lesson.title || 'Topic Lesson'}</span>
                        </strong>
                      </div>
                      <p style={{ margin: 0, fontSize: 14, color: '#4d4688', minHeight: 32 }}>
                        {lesson.unitTitle || 'Topic lesson'} · {lesson.lesson_type || 'Practice'}
                      </p>
                      <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                        <div style={{ height: 8, borderRadius: 999, background: '#ddd9f7', flex: 1 }}>
                          <div style={{ width: `${Math.min(100, Math.max(0, Number(lesson.score_percentage || 0)))}%`, height: '100%', borderRadius: 999, background: 'linear-gradient(90deg, #7c6af7, #a899ff)' }} />
                        </div>
                        <strong style={{ color: '#4f478f', fontSize: 14 }}>{Math.round(Number(lesson.estimated_minutes || 0))}m</strong>
                      </div>
                      <button
                        onClick={() => { setActiveLessonId(lesson.id); setActiveLessonTitle(lesson.title); }}
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
                        Start lesson
                      </button>
                    </article>
                  ))
                )}
              </div>
            )}

            {/* VOCABULARY VIEW */}
            {selectedView === 'vocabulary' && (() => {
              if (!selectedData) return <p style={{ color: '#e2e8f0', fontSize: 13 }}>Loading...</p>;
              const words = selectedData.vocabulary;
              if (!words.length) return <p style={{ color: '#e2e8f0' }}>No vocabulary for this topic.</p>;
              const cur = words[selectedFci] || {};
              const cardKey = `${selectedTopic.code}-vocab-${selectedFci}`;
              const flipped = isFlipped(cardKey);
              return (
                <>
                  <button onClick={() => toggleFlip(cardKey)}
                    style={{ width: '100%', minHeight: 160, borderRadius: 14, border: '1px solid #d8ece6', background: 'rgba(255,255,255,0.9)', padding: 24, textAlign: 'center', cursor: 'pointer', color: '#1e293b', fontFamily: 'inherit' }}>
                    {!flipped
                      ? <><div style={{ fontSize: '2rem', fontWeight: 800 }}>{cur.word}</div><div style={{ color: '#64748b', marginTop: 8, fontSize: 13 }}>Tap to flip</div></>
                      : <><div style={{ fontSize: '1.8rem', fontWeight: 800 }}>{cur.translation}</div><div style={{ color: '#64748b', marginTop: 8, fontSize: 13 }}>{cur.example_sentence || ''}</div></>
                    }
                  </button>
                  <div style={{ display: 'flex', gap: 8, marginTop: 12, alignItems: 'center' }}>
                    <button style={{ ...btnS('ghost'), background: '#ffffff', color: '#1e293b', border: '1px solid #d8ece6' }} onClick={() => setFCI(selectedTopic.code, Math.max(0, selectedFci - 1))}>← Prev</button>
                    <button style={{ ...btnS('ghost'), padding: '8px 12px', background: '#ffffff', color: '#1e293b', border: '1px solid #d8ece6' }} onClick={() => speakWord(cur.word, user.learningLanguage)}>🔊</button>
                    <button style={{ ...btnS(), padding: '10px 16px' }} onClick={() => setFCI(selectedTopic.code, Math.min(words.length - 1, selectedFci + 1))}>Next →</button>
                    <span style={{ marginLeft: 'auto', color: '#e2e8f0', fontSize: 13 }}>{selectedFci + 1}/{words.length}</span>
                  </div>
                </>
              );
            })()}

            {/* PHRASES VIEW */}
            {selectedView === 'phrases' && (() => {
              if (!selectedData) return <p style={{ color: '#e2e8f0', fontSize: 13 }}>Loading...</p>;
              const phrases = selectedData.phrases;
              if (!phrases.length) return <p style={{ color: '#e2e8f0' }}>No phrases for this topic.</p>;
              const cur = phrases[selectedFci] || {};
              const cardKey = `${selectedTopic.code}-phrase-${selectedFci}`;
              const flipped = isFlipped(cardKey);
              return (
                <>
                  <button onClick={() => toggleFlip(cardKey)}
                    style={{ width: '100%', minHeight: 160, borderRadius: 14, border: '1px solid #d8ece6', background: 'rgba(255,255,255,0.9)', padding: 24, textAlign: 'center', cursor: 'pointer', color: '#1e293b', fontFamily: 'inherit' }}>
                    {!flipped
                      ? <div style={{ fontSize: '1.5rem', fontWeight: 800 }}>{cur.phrase}</div>
                      : <><div style={{ fontSize: '1.3rem', fontWeight: 700 }}>{cur.translation}</div><div style={{ color: '#64748b', marginTop: 8, fontSize: 13 }}>{cur.context || ''}</div></>
                    }
                  </button>
                  <div style={{ display: 'flex', gap: 8, marginTop: 12, alignItems: 'center' }}>
                    <button style={{ ...btnS('ghost'), background: '#ffffff', color: '#1e293b', border: '1px solid #d8ece6' }} onClick={() => setFCI(selectedTopic.code, Math.max(0, selectedFci - 1))}>← Prev</button>
                    <button style={{ ...btnS('ghost'), padding: '8px 12px', background: '#ffffff', color: '#1e293b', border: '1px solid #d8ece6' }} onClick={() => speakWord(cur.phrase, user.learningLanguage)}>🔊</button>
                    <button style={{ ...btnS(), padding: '10px 16px' }} onClick={() => setFCI(selectedTopic.code, Math.min(phrases.length - 1, selectedFci + 1))}>Next →</button>
                    <span style={{ marginLeft: 'auto', color: '#e2e8f0', fontSize: 13 }}>{selectedFci + 1}/{phrases.length}</span>
                  </div>
                </>
              );
            })()}

            {/* LECTURE VIEW */}
            {selectedView === 'lecture' && (
              <div style={{ background: 'rgba(255,255,255,0.92)', border: '1px solid #d8ece6', borderRadius: 14, padding: 12 }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', gap: 12, marginBottom: 10 }}>
                  <h4 style={{ margin: 0, color: '#0f172a', fontSize: 18 }}>Topic Lecture</h4>
                  <span style={{ color: '#64748b', fontSize: 12 }}>{selectedTopic.name}</span>
                </div>
                {selectedTopicLectureEmbed ? (
                  <div style={{ maxWidth: 760, margin: '0 auto', borderRadius: 12, overflow: 'hidden', border: '1px solid #d8ece6', background: '#000' }}>
                    <iframe
                      src={selectedTopicLectureEmbed}
                      title={`${selectedTopic.name} lecture`}
                      style={{ width: '100%', aspectRatio: '16 / 9', border: 'none', display: 'block' }}
                      allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
                      referrerPolicy="strict-origin-when-cross-origin"
                      allowFullScreen
                    />
                  </div>
                ) : (
                  <div style={{ borderRadius: 12, border: '1px dashed #d8ece6', background: '#f8fffc', padding: 14, color: '#64748b', fontSize: 13 }}>
                    Add the embed URL for <strong style={{ color: '#1e293b' }}>{selectedTopic.code}</strong> in <code>TOPIC_LECTURE_EMBEDS</code> inside this file.
                  </div>
                )}
              </div>
            )}
          </div>
        )}

        {/* ── EXPLORE MORE TOPICS ── */}
        {!selectedTopic && otherTopics.length > 0 && (
          <div style={{ marginTop: 14, border: '1px solid #3f3480', borderRadius: 12, padding: 10, background: 'rgba(19, 13, 54, 0.45)' }}>
            <div style={{ color: '#d7d1fa', fontWeight: 700, marginBottom: 10, fontSize: 20 }}>Explore More Topics</div>
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, minmax(0, 1fr))', gap: 10 }}>
              {otherTopics.map(topic => (
                <div key={topic.code} style={{ background: 'rgba(255,255,255,0.88)', borderRadius: 12, border: '1px solid #d8ece6', padding: '12px 14px', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                    <span style={{ fontSize: 22 }}>{topic.icon}</span>
                    <div>
                      <div style={{ fontWeight: 700, fontSize: 14, color: '#1e293b' }}>{topic.name}</div>
                      <div style={{ fontSize: 12, color: '#64748b' }}>{topic.count} lessons</div>
                    </div>
                  </div>
                  <button onClick={() => handleAddTopic(topic.code)} disabled={addingTopic === topic.code}
                    style={{ background: 'linear-gradient(90deg, #3b82f6 0%, #22c1c3 100%)', border: 'none', borderRadius: 999, padding: '6px 12px', color: '#ffffff', fontSize: 12, fontWeight: 700, cursor: 'pointer', fontFamily: 'inherit', whiteSpace: 'nowrap' }}>
                    {addingTopic === topic.code ? 'Adding...' : '+ Add'}
                  </button>
                </div>
              ))}
            </div>
          </div>
        )}
      </div>
      {pendingRemoveTopic && (
        <div style={{ position: 'fixed', inset: 0, background: 'rgba(15, 23, 42, 0.28)', display: 'grid', placeItems: 'center', zIndex: 1300, padding: 16 }}>
          <div style={{ width: '100%', maxWidth: 460, background: '#f8fffc', border: `1px solid ${C.border}`, borderRadius: 16, boxShadow: '0 18px 36px rgba(15, 23, 42, 0.2)', padding: 18 }}>
            <h3 style={{ margin: '0 0 8px', fontSize: 22, color: C.text }}>Remove Topic?</h3>
            <p style={{ margin: '0 0 16px', color: C.muted, fontSize: 14 }}>
              Are you sure you want to remove <strong style={{ color: C.text }}>{pendingRemoveTopic.name}</strong> from your topics?
            </p>
            <div style={{ display: 'flex', justifyContent: 'flex-end', gap: 8 }}>
              <button
                type="button"
                onClick={() => setPendingRemoveTopic(null)}
                style={{ border: `1px solid ${C.border}`, borderRadius: 999, height: 34, padding: '0 14px', fontFamily: 'inherit', fontWeight: 700, fontSize: 13, cursor: 'pointer', background: '#ffffff', color: C.muted }}
              >
                Cancel
              </button>
              <button
                type="button"
                onClick={confirmRemoveTopic}
                disabled={removingTopic === pendingRemoveTopic.code}
                style={{ border: 'none', borderRadius: 999, height: 34, padding: '0 14px', fontFamily: 'inherit', fontWeight: 700, fontSize: 13, cursor: 'pointer', background: '#ef4444', color: '#ffffff' }}
              >
                {removingTopic === pendingRemoveTopic.code ? 'Removing...' : 'Yes, remove'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}