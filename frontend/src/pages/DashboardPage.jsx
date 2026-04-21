import { useEffect, useMemo, useRef, useState } from 'react';
import { Link, useLocation, useNavigate } from 'react-router-dom';
import { clearStoredUser, deleteMyAccount, getNextOnboardingRoute, getStoredUser, verifyAccountPassword } from '../api/auth';
import LessonsPage from './LessonsPage';
import LessonDetailPage from './LessonDetailPage';
import ExercisesPage from './ExercisesPage';
import TopicsPage from './TopicsPage';
import '../styles/mix-match-module.css';

const C = { bg: '#0f0f14', surface: '#1a1a24', card: '#22222f', border: '#2e2e3f', accent: '#7c6af7', accentLight: '#a899ff', accentGlow: 'rgba(124,106,247,0.18)', green: '#4ade80', yellow: '#fbbf24', red: '#f87171', text: '#f0eeff', muted: '#8b8aaa', dim: '#3d3d55' };

const NAV = [
  { section: 'Profile', items: [{ to: '/dashboard', label: '🏠 Home', exact: true }] },
  { section: 'Your Learning', items: [{ to: '/dashboard/lessons', label: '📖 Lessons' }, { to: '/dashboard/topics', label: '🗂️ Topics' }, { to: '/dashboard/exercises', label: '🏋️ Exercises' }, { to: '/dashboard/ai-conversation', label: '🤖 AI Conversation' }, { to: '/dashboard/weak-spots', label: '📍 Weak Spots' }] },
  { section: 'Account', items: [{ to: '/dashboard/achievements', label: '🏆 Achievements' }, { to: '/dashboard/subscription', label: '💳 Subscription' }, { to: '/dashboard/retake-placement', label: '🎚️ Level Adjust' }] },
];

const isActive = (pathname, item) => item.exact ? pathname === item.to || pathname === item.to + '/' : pathname === item.to || pathname.startsWith(item.to + '/');
const fmtLevel = v => String(v || '').toLowerCase().replace(/_/g, ' ').replace(/\b\w/g, m => m.toUpperCase());
const fmtTopic = raw => String(raw || '').replace(/_ES|_EN/, '').replace(/_/g, ' ').toLowerCase().replace(/\b\w/g, m => m.toUpperCase());
const parseCsv = csv => String(csv || '').split(',').map(s => s.trim()).filter(Boolean);
const display = raw => String(raw ?? '').replace(/_/g, ' ').trim();
const stripU = raw => String(raw ?? '').replace(/_/g, ' ');
const truncate = (v, max = 200) => { const s = String(v || '').trim(); return s.length <= max ? s : s.slice(0, max) + '...'; };
const topicIcon = (catalog, code) => { const r = (catalog || []).find(t => (t.code || '').toUpperCase() === String(code || '').toUpperCase()); return r?.icon?.trim() || '📚'; };
function shuffle(arr) { const a = [...arr]; for (let i = a.length - 1; i > 0; i--) { const j = Math.floor(Math.random() * (i + 1)); [a[i], a[j]] = [a[j], a[i]]; } return a; }
function pickD(items, cur, field) { const vals = (items || []).map(x => String(x?.[field] || '').trim()).filter(x => x && x !== String(cur || '').trim()); return vals.length ? vals[Math.floor(Math.random() * vals.length)] : 'Not sure'; }
function mmFields(row) { if (!row) return null; const w = String(row.word ?? '').trim(), t = String(row.translation ?? '').trim(); if (!w || !t) return null; return { contentId: row.id ?? null, word: row.word, translation: row.translation, topic_tag: row.topic_tag ?? '' }; }
function parseThresholds(t) { if (!t) return []; try { const r = typeof t === 'string' ? JSON.parse(t) : t; return (Array.isArray(r?.levels) ? r.levels : []).map(Number).filter(v => Number.isFinite(v) && v > 0); } catch { return []; } }

const cardS = { background: C.card, borderRadius: 16, border: `1px solid ${C.border}`, padding: 24 };
const btnS = (v = 'primary') => ({ padding: v === 'sm' ? '8px 16px' : '12px 24px', borderRadius: 10, border: 'none', cursor: 'pointer', fontFamily: 'inherit', fontWeight: 600, fontSize: v === 'sm' ? 13 : 14, transition: 'all 0.15s', background: v === 'primary' ? C.accent : v === 'ghost' ? 'transparent' : C.card, color: v === 'primary' ? '#fff' : v === 'ghost' ? C.muted : C.text, ...(v === 'ghost' ? { border: `1px solid ${C.border}` } : {}) });
const badgeS = (color = C.accent) => ({ padding: '4px 12px', borderRadius: 20, fontSize: 12, fontWeight: 600, background: `${color}22`, color, border: `1px solid ${color}44`, display: 'inline-block' });

function TopStats({ level, xp, streak }) {
  return (
    <div style={{ display: 'flex', gap: 8, marginBottom: 8, flexWrap: 'wrap' }}>
      <span style={badgeS(C.accentLight)}>{fmtLevel(level) || 'Beginner'}</span>
      <span style={badgeS(C.yellow)}>XP: {xp}</span>
      <span style={badgeS(C.green)}>🔥 {streak} days</span>
    </div>
  );
}

function ProgressBar({ val = 0, total = 100 }) {
  const pct = total > 0 ? Math.min(100, Math.round((val / total) * 100)) : 0;
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
      <div style={{ flex: 1, height: 8, borderRadius: 99, background: C.dim }}>
        <div style={{ width: `${pct}%`, height: '100%', borderRadius: 99, background: `linear-gradient(90deg, ${C.accent}, ${C.accentLight})` }} />
      </div>
      <span style={{ fontSize: 12, color: C.muted }}>{val}/{total}</span>
    </div>
  );
}

export default function DashboardPage() {
  const navigate = useNavigate();
  const { pathname } = useLocation();
  const user = useMemo(() => getStoredUser(), [pathname]);
  const path = pathname.replace(/\/+$/, '');

  const [xp, setXp] = useState(0);
  const [streak, setStreak] = useState(0);
  const [items, setItems] = useState([]);
  const [topicsData, setTopicsData] = useState([]);
  const [topicsCatalog, setTopicsCatalog] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [activeTopicCode, setActiveTopicCode] = useState('');
  const [activeTopicView, setActiveTopicView] = useState('vocabulary');
  const [flashcardIndex, setFlashcardIndex] = useState(0);
  const [flippedCards, setFlippedCards] = useState({});
  const [sectionQuiz, setSectionQuiz] = useState({ section: '', index: 0, correct: 0, questions: [], done: false });
  const [checkFeedback, setCheckFeedback] = useState({});
  const [aiInput, setAiInput] = useState('');
  const [chatMessages, setChatMessages] = useState([{ role: 'assistant', content: "Hi! I'm your Spanish tutor — ask me anything." }]);
  const [chatScrollEl, setChatScrollEl] = useState(null);
  const [mixMatchRound, setMixMatchRound] = useState(0);
  const [mixMatchState, setMixMatchState] = useState(null);
  const [mixMatchFeedback, setMixMatchFeedback] = useState(null);
  const [mixMatchWrongIds, setMixMatchWrongIds] = useState(null);
  const [showDeleteFlow, setShowDeleteFlow] = useState(false);
  const [deletePasswordVerified, setDeletePasswordVerified] = useState(false);
  const [deletePassword, setDeletePassword] = useState('');
  const [deleteError, setDeleteError] = useState('');
  const [deleteInfo, setDeleteInfo] = useState('');
  const [verifyDeleteSubmitting, setVerifyDeleteSubmitting] = useState(false);
  const [deleteSubmitting, setDeleteSubmitting] = useState(false);
  const [retakeConfirm, setRetakeConfirm] = useState(false);
  const mixMatchItemsRef = useRef(null);
  const mixMatchPoolRef = useRef([]);

  const selectedTopics = useMemo(() => parseCsv(user?.learningGoals), [user?.learningGoals]);
  const activeTopic = useMemo(() => topicsData.find(t => t.code === activeTopicCode) || null, [topicsData, activeTopicCode]);
  const [currentLesson, setCurrentLesson] = useState(null);

  useEffect(() => { const next = getNextOnboardingRoute(user); if (next !== '/dashboard') navigate(next, { replace: true }); }, [navigate, user]);

 useEffect(() => {
  if (!user?.id) return;
  fetch(`/api/me/summary?userId=${encodeURIComponent(user.id)}`).then(r => r.ok ? r.json() : null).then(d => { if (d) { setXp(Number(d.xp || 0)); setStreak(Number(d.streak_count || 0)); } }).catch(() => {});

  fetch(`/api/lesson-catalog?userId=${encodeURIComponent(user.id)}`)
    .then(r => r.ok ? r.json() : [])
    .then(lessons => {
      const inProgress = lessons.find(l => l.status === 'IN_PROGRESS');
      const available = lessons.find(l => l.status === 'AVAILABLE');
      setCurrentLesson(inProgress || available || null);
    })
    .catch(() => {});
}, [user?.id, pathname]);

  useEffect(() => {
    if (!user?.id) return;
    fetch(`/api/topics?language=${encodeURIComponent(user.learningLanguage || 'es')}`).then(r => r.ok ? r.json() : []).then(d => setTopicsCatalog(Array.isArray(d) ? d : [])).catch(() => {});
  }, [user?.id, user?.learningLanguage]);

  useEffect(() => {
    if (!user) return;
    const endpoints = { '/dashboard/mix-match': '/api/vocabulary', '/dashboard/achievements': '/api/achievements/me', '/dashboard/subscription': '/api/subscriptions/me', '/dashboard/weak-spots': '/api/practice/troubles' };
    const endpoint = endpoints[path];
    if (!endpoint && path !== '/dashboard/topics') { setItems([]); setLoading(false); return; }
    if (path === '/dashboard/topics') return;
    let cancelled = false;
    setLoading(true); setError('');
    const lang = encodeURIComponent(user.learningLanguage || 'es');
    const url = path === '/dashboard/mix-match' ? `${endpoint}?language=${lang}&userId=${encodeURIComponent(user.id)}&applyTopicFilter=true` : `${endpoint}?userId=${encodeURIComponent(user.id)}&language=${lang}`;
    fetch(url).then(r => r.ok ? r.json() : []).then(d => { if (!cancelled) setItems(Array.isArray(d) ? d : []); }).catch(e => { if (!cancelled) setError(e.message); }).finally(() => { if (!cancelled) setLoading(false); });
    return () => { cancelled = true; };
  }, [pathname, user]);

  useEffect(() => {
    if (!user || path !== '/dashboard/topics') return;
    let cancelled = false; setLoading(true);
    const lang = encodeURIComponent(user.learningLanguage || 'es');
    (async () => {
      try {
        const allTopics = await fetch(`/api/topics?language=${lang}`).then(r => r.json());
        const list = Array.isArray(allTopics) ? allTopics : [];
        const rows = await Promise.all(selectedTopics.map(async code => {
          const topic = list.find(t => (t.code || '').toUpperCase() === code.toUpperCase());
          if (!topic?.id) return { code, icon: topicIcon(list, code), title: fmtTopic(code), vocabulary: [], phrases: [], units: [] };
          const content = await fetch(`/api/topics/${topic.id}/content`).then(r => r.json());
          return { code, icon: String(topic.icon || '').trim() || topicIcon(list, code), title: fmtTopic(topic.name || topic.code || code), vocabulary: Array.isArray(content.vocabulary) ? content.vocabulary : [], phrases: Array.isArray(content.phrases) ? content.phrases : [], units: Array.isArray(content.units) ? content.units : [] };
        }));
        if (!cancelled) { setTopicsData(rows); setActiveTopicCode(prev => prev && rows.some(r => r.code === prev) ? prev : rows[0]?.code || ''); setFlashcardIndex(0); setFlippedCards({}); }
      } catch (e) { if (!cancelled) setError(e.message); }
      finally { if (!cancelled) setLoading(false); }
    })();
    return () => { cancelled = true; };
  }, [pathname, selectedTopics, user]);

  useEffect(() => {
    if (path !== '/dashboard/mix-match') { setMixMatchState(null); return; }
    const normalized = (items || []).map(mmFields).filter(Boolean);
    const cap = 5;
    if (normalized.length < 3) { setMixMatchState({ pairs: [], leftOrder: [], rightOrder: [], matched: {}, pick: null, tooFew: true }); return; }
    if (mixMatchItemsRef.current !== items) { mixMatchItemsRef.current = items; mixMatchPoolRef.current = shuffle(normalized); }
    let pool = mixMatchPoolRef.current;
    const chunkCount = Math.max(1, Math.ceil(pool.length / cap));
    const chunkIdx = mixMatchRound % chunkCount;
    if (chunkIdx === 0 && mixMatchRound > 0) { mixMatchPoolRef.current = shuffle(normalized); pool = mixMatchPoolRef.current; }
    let picked = pool.slice(chunkIdx * cap, Math.min((chunkIdx + 1) * cap, pool.length));
    if (picked.length < 3) { mixMatchPoolRef.current = shuffle(normalized); pool = mixMatchPoolRef.current; picked = pool.slice(0, Math.min(cap, pool.length)); }
    const pairs = picked.map(w => ({ id: String(w.contentId ?? `${w.word}-${w.topic_tag || 'x'}`), contentId: w.contentId ?? null, word: w.word, translation: w.translation, topic_tag: w.topic_tag || '' }));
    const ids = pairs.map(p => p.id);
    setMixMatchState({ pairs, leftOrder: shuffle(ids), rightOrder: shuffle(ids), matched: {}, pick: null, tooFew: false });
  }, [path, items, mixMatchRound]);

  useEffect(() => { setMixMatchFeedback(null); setMixMatchWrongIds(null); }, [mixMatchRound, path]);
  useEffect(() => { if (chatScrollEl) chatScrollEl.scrollTop = chatScrollEl.scrollHeight; }, [chatMessages, chatScrollEl]);

  const mmProgressPct = useMemo(() => { if (!mixMatchState?.pairs?.length || mixMatchState.tooFew) return 0; return Math.min(100, Math.round((Object.keys(mixMatchState.matched || {}).length / mixMatchState.pairs.length) * 100)); }, [mixMatchState]);

  const handleMixMatchTap = (side, vocabId) => {
    setMixMatchState(prev => {
      if (!prev || prev.tooFew || !prev.pairs?.length || prev.matched[vocabId]) return prev;
      if (!prev.pick) return { ...prev, pick: { side, vocabId } };
      if (prev.pick.side === side) return { ...prev, pick: { side, vocabId } };
      const a = prev.pick.vocabId, b = vocabId;
      if (a === b) { queueMicrotask(() => { setMixMatchFeedback({ kind: 'correct', text: 'Nice match!' }); window.setTimeout(() => setMixMatchFeedback(null), 2000); }); return { ...prev, matched: { ...prev.matched, [a]: true }, pick: null }; }
      queueMicrotask(() => { setMixMatchWrongIds([a, b]); setMixMatchFeedback({ kind: 'wrong', text: 'Not a pair — try again.' }); window.setTimeout(() => setMixMatchWrongIds(null), 550); window.setTimeout(() => setMixMatchFeedback(null), 2400); });
      return { ...prev, pick: null };
    });
  };

  const speakWord = (word, fallback) => { if (!window.speechSynthesis) return; window.speechSynthesis.cancel(); const utt = new SpeechSynthesisUtterance(String(fallback || word || '')); utt.lang = String(user?.learningLanguage || 'es').toLowerCase() === 'es' ? 'es-ES' : 'en-US'; utt.rate = 0.95; window.speechSynthesis.speak(utt); };

  const sendAiMessage = async () => {
    const msg = aiInput.trim(); if (!msg) return;
    setChatMessages(prev => [...prev, { role: 'user', content: msg }]); setAiInput('');
    try { const res = await fetch('/api/ai/conversation/feedback', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ userId: user?.id, language: user?.learningLanguage || 'es', userMessage: msg }) }); const data = res.ok ? await res.json() : null; setChatMessages(prev => [...prev, { role: 'assistant', content: data?.assistantReply || 'I could not respond right now.' }]); }
    catch { setChatMessages(prev => [...prev, { role: 'assistant', content: 'I could not respond right now.' }]); }
  };

  const startQuiz = (section, sourceItems) => {
    const pool = (sourceItems || []).slice(0, 20);
    const pick = pool.slice(0, Math.min(5, pool.length));
    const questions = pick.map((row) => {
      if (section === 'vocabulary') { const right = String(row.translation || ''); return { prompt: `What does "${display(row.word)}" mean?`, options: [right, pickD(pool, right, 'translation')].sort(() => Math.random() - 0.5), correct: right }; }
      if (section === 'listening') { const right = String(row.translation || ''); return { prompt: `What does "${display(row.phrase)}" mean?`, options: [right, pickD(pool, right, 'translation')].sort(() => Math.random() - 0.5), correct: right }; }
      const right = String(row.category || 'Grammar'); return { prompt: `"${stripU(row.title || row.code || 'rule')}" belongs to?`, options: [right, right === 'Grammar' ? 'Vocabulary' : 'Grammar'].sort(() => Math.random() - 0.5), correct: right };
    });
    setSectionQuiz({ section, index: 0, correct: 0, questions, done: false });
  };

  const answerQuiz = (picked) => {
    const q = sectionQuiz.questions[sectionQuiz.index]; if (!q) return;
    const correct = picked === q.correct;
    const nextIndex = sectionQuiz.index + 1;
    const nextCorrect = sectionQuiz.correct + (correct ? 1 : 0);
    if (nextIndex >= sectionQuiz.questions.length) { setSectionQuiz(prev => ({ ...prev, index: nextIndex, correct: nextCorrect, done: true })); return; }
    setSectionQuiz(prev => ({ ...prev, index: nextIndex, correct: nextCorrect }));
  };

  const recordAttempt = async ({ section, correct, source, labelSnapshot = '' }) => {
    if (!user?.id) return;
    try { await fetch('/api/practice/attempt', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ userId: user.id, language: user.learningLanguage || 'es', section, correct, source, labelSnapshot }) }); } catch {}
  };

  return (
    <>
      <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;600;700;800&display=swap" rel="stylesheet" />
      <div style={{ display: 'flex', height: '100vh', fontFamily: "'DM Sans', sans-serif", background: C.bg, color: C.text, overflow: 'hidden' }}>

        {/* Sidebar */}
        <div style={{ width: 220, background: C.surface, borderRight: `1px solid ${C.border}`, display: 'flex', flexDirection: 'column', padding: '16px 0', gap: 2, flexShrink: 0, height: '100vh', overflowY: 'auto' }}>
          {NAV.map(group => (
            <div key={group.section}>
              <div style={{ fontSize: 10, fontWeight: 700, color: C.muted, padding: '14px 24px 4px', textTransform: 'uppercase', letterSpacing: '0.08em' }}>{group.section}</div>
              {group.items.map(item => (
                <Link key={item.to} to={item.to} style={{ textDecoration: 'none' }}>
                  <button style={{ display: 'flex', alignItems: 'center', gap: 10, padding: '10px 24px', cursor: 'pointer', border: 'none', width: '100%', background: isActive(pathname, item) ? C.accentGlow : 'transparent', color: isActive(pathname, item) ? C.accentLight : C.muted, borderLeft: isActive(pathname, item) ? `3px solid ${C.accent}` : '3px solid transparent', fontSize: 18, fontWeight: isActive(pathname, item) ? 600 : 400, transition: 'all 0.15s', textAlign: 'left', fontFamily: 'inherit' }}>{item.label}</button>
                </Link>
              ))}
            </div>
          ))}
          <div style={{padding: '8px 0' }}>
            <button onClick={() => { clearStoredUser(); navigate('/login'); }} style={{ display: 'flex', alignItems: 'center', gap: 10, padding: '10px 24px', background: 'transparent', border: 'none', color: C.red, cursor: 'pointer', fontSize: 14, width: '100%', fontFamily: 'inherit' }}>🚪 Log out</button>
          </div>
        </div>

        {/* Main */}
        <div style={{ flex: 1, overflowY: 'auto', padding: 32, background: C.bg }}>

          {/* HOME */}
          {path === '/dashboard' && (
            <div>
              <h1 style={{ fontSize: 40, fontWeight: 800, marginBottom: 4, letterSpacing: '-0.5px' }}>Welcome back, {user?.username}! 👋</h1>
              <TopStats level={user?.assignedLevel} xp={xp} streak={streak} />
              <div style={{ display: 'flex', gap: 12, marginBottom: 20 }}>
<div style={{ ...cardS, flex: 1, background: `${C.accent}18`, border: `1px solid ${C.accent}44` }}><div style={{ fontSize: 16, color: C.muted }}>XP to next language level</div><div style={{ fontSize: 22, fontWeight: 700, color: C.accentLight, marginTop: 4 }}>{(() => { const next = [10000, 25000, 50000].find(l => l > xp) || 50000; return `${(next - xp).toLocaleString()} XP`; })()}</div></div>                <div style={{ ...cardS, flex: 1, background: `${C.yellow}18`, border: `1px solid ${C.yellow}44` }}><div style={{ fontSize: 16, color: C.muted }}>XP to next lesson</div><div style={{ fontSize: 22, fontWeight: 700, color: C.yellow, marginTop: 4 }}>Keep going! 🔥</div></div>
              </div>
             <div style={{ ...cardS, marginBottom: 20 }}>
  <div style={{ fontSize: 13, color: C.muted, marginBottom: 8 }}>Start where you last left off</div>
  <div style={{ fontSize: 15, fontWeight: 600, marginBottom: 10 }}>
    {currentLesson
      ? `Lesson ${currentLesson.lesson_number} — ${currentLesson.title}`
      : `Core Lessons — ${fmtLevel(user?.assignedLevel || 'BEGINNER')}`}
  </div>
  <ProgressBar val={currentLesson ? Math.round(currentLesson.score_percentage || 0) : 0} total={100} />
  <Link to="/dashboard/lessons"><button style={{ ...btnS(), marginTop: 14 }}>Continue Lesson →</button></Link>
</div>
              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 16, marginBottom: 20 }}>
                {[{ label: '📖 Lessons', to: '/dashboard/lessons' }, { label: '🗂️ Your Topics', to: '/dashboard/topics' }, { label: '🔀 Mix & Match', to: '/dashboard/mix-match' }].map(({ label, to }) => (
                  <Link key={to} to={to} style={{ textDecoration: 'none' }}><div style={{ ...cardS, cursor: 'pointer', fontSize: 15, fontWeight: 600, padding: 20, textAlign: 'center', color: C.text }}>{label}</div></Link>
                ))}
              </div>
              <div style={{ ...cardS, marginBottom: 16, background: `${C.red}11`, border: `1px solid ${C.red}33` }}>
                <div style={{ fontSize: 13, fontWeight: 700, color: C.red, marginBottom: 6 }}>⚠️ Weak Spots</div>
                <div style={{ fontSize: 14, color: C.muted }}>Check your weak spots section to see what needs more practice.</div>
              </div>
              <div style={cardS}>
                <div style={{ fontSize: 13, fontWeight: 700, color: C.muted, marginBottom: 10 }}>Your Topics</div>
                <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>{selectedTopics.map(code => (<span key={code} style={badgeS(C.accent)}>{topicIcon(topicsCatalog, code)} {fmtTopic(code)}</span>))}</div>
              </div>
            </div>
          )}

          {/* NON-HOME */}
          {path !== '/dashboard' && (
            <div>
              <TopStats level={user?.assignedLevel} xp={xp} streak={streak} />
              {error && <p style={{ color: C.red, marginBottom: 12 }}>{error}</p>}
              {loading && path !== '/dashboard/mix-match' && <p style={{ color: C.muted }}>Loading…</p>}

              {/* LESSONS GRID */}
{path === '/dashboard/lessons' && (
  <LessonsPage />
)}

{/* LESSON DETAIL */}
{path.startsWith('/dashboard/lessons/') && (
  <LessonDetailPage lessonNumber={path.split('/').pop()} />
)}


              {/* TOPICS */}
              {path === '/dashboard/topics' && <TopicsPage />}

              {path === '/dashboard/exercises' && <ExercisesPage />}
{/* AI CONVERSATION */}
{path === '/dashboard/ai-conversation' && (
  <div>
    <h1 style={{ fontSize: 28, fontWeight: 800, marginBottom: 20, letterSpacing: '-0.5px' }}>AI Conversation</h1>
    <div style={{ display: 'flex', flexDirection: 'column', gap: 16, maxWidth: 600 }}>
      <div style={{ ...cardS, display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
        <div><div style={{ fontSize: 16, fontWeight: 700, marginBottom: 4 }}>🎙️ Speak with AI Tutor</div><div style={{ fontSize: 13, color: C.muted }}>Have a live voice conversation in Spanish. AI listens and responds.</div></div>
        <button style={btnS()}>Begin</button>
      </div>
      <div style={{ ...cardS, display: 'flex', flexDirection: 'column', height: 420 }}>
        <div style={{ fontSize: 16, fontWeight: 700, marginBottom: 12 }}>💬 Text AI Tutor</div>
        <div ref={setChatScrollEl} style={{ flex: 1, overflowY: 'auto', display: 'flex', flexDirection: 'column', gap: 10, paddingBottom: 10 }}>
          {chatMessages.map((m, i) => (
            <div key={i} style={{ alignSelf: m.role === 'user' ? 'flex-end' : 'flex-start', background: m.role === 'user' ? C.accent : C.dim, color: '#fff', padding: '10px 14px', borderRadius: 12, maxWidth: '80%', fontSize: 14 }}>{m.content}</div>
          ))}
        </div>
        <div style={{ display: 'flex', gap: 8, borderTop: `1px solid ${C.border}`, paddingTop: 12 }}>
          <input value={aiInput} onChange={e => setAiInput(e.target.value)} onKeyDown={e => { if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); sendAiMessage(); } }} placeholder="Type in Spanish or English..." style={{ flex: 1, background: C.dim, border: 'none', borderRadius: 10, padding: '10px 14px', color: C.text, fontSize: 14, fontFamily: 'inherit', outline: 'none' }} />
          <button style={btnS()} onClick={sendAiMessage}>Send</button>
        </div>
      </div>
    </div>
  </div>
)}

              {/* MIX & MATCH */}
              {path === '/dashboard/mix-match' && (
                <div className="fl-mix-lesson">
                  <div className="lesson-card" id="card-match">
                    <div className="top-bar top-bar-progress-only"><div className="progress-wrap"><span className="progress-label">0%</span><div className="progress-track"><div className="progress-fill" style={{ width: `${mmProgressPct}%` }} /></div><span className="progress-label">100%</span></div></div>
                    <div className="lesson-body">
                      {mixMatchState?.tooFew ? <p className="mm-empty">You need at least 3 vocabulary words.</p> : loading || !mixMatchState?.pairs?.length ? <p className="mm-loading">Loading pairs…</p> : (
                        <>
                          <div className="activity-type">Mix &amp; Match the vocabulary</div>
                          <div className="score-chip">{Object.keys(mixMatchState.matched).length} / {mixMatchState.pairs.length} pairs matched</div>
                          <p className="mm-hint">Tap a word, then tap its translation.</p>
                          <p className="row-label">Words</p>
                          <div className="match-grid" style={{ gridTemplateColumns: `repeat(${mixMatchState.pairs.length}, minmax(0, 1fr))` }}>
                            {mixMatchState.leftOrder.map(id => { const p = mixMatchState.pairs.find(x => x.id === id); if (!p) return null; return (<button key={`L-${id}`} type="button" disabled={!!mixMatchState.matched[id]} className={`match-card${mixMatchState.matched[id] ? ' matched' : ''}${mixMatchState.pick?.vocabId === id && mixMatchState.pick?.side === 'left' ? ' selected' : ''}${mixMatchWrongIds?.includes(id) ? ' wrong' : ''}`} onClick={() => handleMixMatchTap('left', id)}>{display(p.word)}</button>); })}
                          </div>
                          <p className="row-label">Translations</p>
                          <div className="match-grid" style={{ gridTemplateColumns: `repeat(${mixMatchState.pairs.length}, minmax(0, 1fr))` }}>
                            {mixMatchState.rightOrder.map(id => { const p = mixMatchState.pairs.find(x => x.id === id); if (!p) return null; return (<button key={`R-${id}`} type="button" disabled={!!mixMatchState.matched[id]} className={`match-card${mixMatchState.matched[id] ? ' matched' : ''}${mixMatchState.pick?.vocabId === id && mixMatchState.pick?.side === 'right' ? ' selected' : ''}${mixMatchWrongIds?.includes(id) ? ' wrong' : ''}`} onClick={() => handleMixMatchTap('right', id)}>{display(p.translation)}</button>); })}
                          </div>
                          {mixMatchFeedback && <div className={`feedback show${mixMatchFeedback.kind === 'correct' ? ' correct-fb' : ' wrong-fb'}`} role="status">{mixMatchFeedback.text}</div>}
                          <div className="mm-footer-actions">
                            <button className="btn-continue" disabled={Object.keys(mixMatchState.matched).length !== mixMatchState.pairs.length} onClick={() => setMixMatchRound(r => r + 1)}>{Object.keys(mixMatchState.matched).length === mixMatchState.pairs.length ? 'New round' : 'Check matches'}</button>
                            <button className="mm-text-btn" onClick={() => setMixMatchRound(r => r + 1)}>Shuffle · new round now</button>
                          </div>
                        </>
                      )}
                    </div>
                  </div>
                </div>
              )}

              {/* WEAK SPOTS */}
              {path === '/dashboard/weak-spots' && !loading && (
                <div>
                  <h1 style={{ fontSize: 28, fontWeight: 800, marginBottom: 4, letterSpacing: '-0.5px' }}>Weak Spots</h1>
                  <p style={{ color: C.muted, marginBottom: 20 }}>Items you've answered incorrectly — ordered by most missed.</p>
                  {items.length === 0 ? <div style={{ ...cardS, color: C.muted }}>No weak spots yet. Keep practicing!</div> : (
                    <div style={{ display: 'grid', gap: 12 }}>
                      {items.map(t => (<div key={t.id} style={cardS}><div style={{ display: 'flex', justifyContent: 'space-between', gap: 12 }}><div><h3 style={{ color: C.text, margin: 0 }}>{stripU(t.label_snapshot) || 'Practice item'}</h3><p style={{ color: C.muted, fontSize: 13, margin: '4px 0' }}>{fmtTopic(t.section || '')} {t.topic_tag ? `· ${fmtTopic(t.topic_tag)}` : ''}</p><p style={{ color: C.red, fontSize: 13 }}>Missed {t.wrong_count} times</p></div><p style={{ color: C.muted, fontSize: 12, whiteSpace: 'nowrap' }}>{t.last_wrong_at ? new Date(t.last_wrong_at).toLocaleDateString() : '—'}</p></div></div>))}
                    </div>
                  )}
                </div>
              )}

              {/* ACHIEVEMENTS */}
              {path === '/dashboard/achievements' && !loading && (
                <div>
                  <h1 style={{ fontSize: 28, fontWeight: 800, marginBottom: 20, letterSpacing: '-0.5px' }}>Achievements</h1>
                  <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 16 }}>
                    {(items || []).map(it => {
                      const thresholds = parseThresholds(it.thresholds);
                      const currentLevel = Number(it.current_level || 0);
                      const unlocked = currentLevel > 0;
                      const nextTarget = thresholds[currentLevel] || null;
                      const progress = Number(it.progress || 0);
                      const pct = nextTarget ? Math.min(100, Math.round((progress / nextTarget) * 100)) : 100;
                      return (<div key={it.achievement_id || it.code} style={{ ...cardS, textAlign: 'center', padding: 18, opacity: unlocked ? 1 : 0.45, border: unlocked ? `1px solid ${C.accent}55` : `1px solid ${C.border}`, position: 'relative' }}><div style={{ fontSize: 28, marginBottom: 6 }}>{it.icon || '🏆'}</div><div style={{ fontSize: 14, fontWeight: 700, color: C.text }}>{stripU(it.name)}</div><div style={{ fontSize: 12, color: C.muted, marginTop: 4 }}>{stripU(it.description || '')}</div>{nextTarget && <div style={{ marginTop: 8, height: 6, borderRadius: 99, background: C.dim }}><div style={{ width: `${pct}%`, height: '100%', borderRadius: 99, background: unlocked ? C.green : C.accent }} /></div>}{unlocked && <div style={{ position: 'absolute', top: 10, right: 10, color: C.green, fontSize: 14 }}>✓</div>}</div>);
                    })}
                  </div>
                </div>
              )}

              {/* SUBSCRIPTION */}
              {path === '/dashboard/subscription' && !loading && (
                <div>
                  <h1 style={{ fontSize: 28, fontWeight: 800, marginBottom: 20, letterSpacing: '-0.5px' }}>Subscription</h1>
                  <div style={{ ...cardS, marginBottom: 20, background: `${C.green}11`, border: `1px solid ${C.green}33` }}><div style={{ fontSize: 13, color: C.muted }}>Active Subscription</div><div style={{ fontSize: 20, fontWeight: 700, color: C.green, marginTop: 4 }}>{(() => { const sub = (items || [])[0]; return sub?.status === 'ACTIVE' ? fmtTopic(sub.plan) : 'Free Plan'; })()}</div></div>
                  <div style={{ fontSize: 13, color: C.muted, marginBottom: 14 }}>Upgrade your plan</div>
                  <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
                    {[{ id: 'PLUS', label: 'Plus', price: '$9.99/mo', features: ['All lessons', 'AI Text Tutor', 'Scenarios', 'Achievements'] }, { id: 'PREMIUM_MONTHLY', label: 'Premium', price: '$19.99/mo', features: ['Everything in Plus', 'AI Voice Tutor', 'Weak Spot Analysis', 'Priority support'] }].map(plan => (
                      <div key={plan.id} style={{ ...cardS, border: `1px solid ${C.border}` }}>
                        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                          <div><div style={{ fontSize: 16, fontWeight: 700, color: C.text }}>{plan.label}</div><div style={{ display: 'flex', gap: 8, flexWrap: 'wrap', marginTop: 8 }}>{plan.features.map(f => <span key={f} style={{ fontSize: 12, color: C.muted }}>✓ {f}</span>)}</div></div>
                          <div style={{ textAlign: 'right' }}><div style={{ fontSize: 20, fontWeight: 800, color: C.accentLight }}>{plan.price}</div><button style={{ ...btnS(), marginTop: 8, padding: '8px 16px', fontSize: 12 }} onClick={async () => { await fetch('/api/subscriptions/subscribe', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ userId: user?.id, plan: plan.id, autoRenew: true }) }); }}>Upgrade</button></div>
                        </div>
                      </div>
                    ))}
                  </div>
                  <div style={{ ...cardS, marginTop: 24, border: `1px solid ${C.red}44`, background: `${C.red}08` }}>
                    <h3 style={{ color: C.red, margin: 0 }}>Delete account</h3>
                    <p style={{ color: C.muted, fontSize: 13, marginTop: 4 }}>Permanently deletes your account and all data.</p>
                    {!showDeleteFlow ? (<button style={{ ...btnS('ghost'), marginTop: 10, color: C.red, border: `1px solid ${C.red}44` }} onClick={() => { setShowDeleteFlow(true); setDeleteError(''); setDeleteInfo(''); setDeletePassword(''); setDeletePasswordVerified(false); }}>Delete account</button>) : (
                      <form onSubmit={async e => {
                        e.preventDefault(); setDeleteError(''); setDeleteInfo('');
                        if (!deletePassword.trim()) { setDeleteError('Enter your password.'); return; }
                        if (!deletePasswordVerified) { setVerifyDeleteSubmitting(true); try { await verifyAccountPassword({ userId: user?.id, password: deletePassword }); setDeletePasswordVerified(true); setDeleteInfo('Password verified. Confirm deletion below.'); } catch (err) { setDeleteError(err.message || 'Could not verify.'); } finally { setVerifyDeleteSubmitting(false); } return; }
                        setDeleteSubmitting(true); try { await deleteMyAccount({ userId: user?.id, password: deletePassword }); clearStoredUser(); navigate('/login?accountDeleted=1', { replace: true }); } catch (err) { setDeleteError(err.message || 'Could not delete.'); } finally { setDeleteSubmitting(false); }
                      }} style={{ marginTop: 12, display: 'grid', gap: 10 }}>
                        {deleteInfo && <p style={{ color: C.green, fontSize: 13 }}>{deleteInfo}</p>}
                        {deleteError && <p style={{ color: C.red, fontSize: 13 }}>{deleteError}</p>}
                        <input type="password" value={deletePassword} onChange={e => { setDeletePassword(e.target.value); setDeletePasswordVerified(false); setDeleteInfo(''); }} placeholder="Enter your password" style={{ background: C.dim, border: 'none', borderRadius: 10, padding: '10px 14px', color: C.text, fontFamily: 'inherit', fontSize: 14, outline: 'none' }} />
                        <div style={{ display: 'flex', gap: 8 }}>
                          {!deletePasswordVerified ? <button type="submit" style={{ ...btnS('ghost'), color: C.red, border: `1px solid ${C.red}44` }} disabled={verifyDeleteSubmitting}>{verifyDeleteSubmitting ? 'Verifying…' : 'Verify password'}</button> : <button type="submit" style={{ ...btnS('ghost'), color: C.red, border: `1px solid ${C.red}44` }} disabled={deleteSubmitting}>{deleteSubmitting ? 'Deleting…' : 'Confirm delete'}</button>}
                          <button type="button" style={btnS('ghost')} onClick={() => { setShowDeleteFlow(false); setDeletePassword(''); setDeleteError(''); setDeleteInfo(''); }}>Cancel</button>
                        </div>
                      </form>
                    )}
                  </div>
                </div>
              )}

              {/* LEVEL ADJUST */}
              {path === '/dashboard/retake-placement' && (
                <div>
                  <h1 style={{ fontSize: 28, fontWeight: 800, marginBottom: 20, letterSpacing: '-0.5px' }}>Level Adjustment</h1>
                  <div style={cardS}>
                    <div style={{ fontSize: 14, color: C.muted, marginBottom: 8 }}>Your current level</div>
                    <div style={{ fontSize: 20, fontWeight: 700, color: C.accentLight, marginBottom: 16 }}>{fmtLevel(user?.assignedLevel || 'BEGINNER')}</div>
                    <div style={{ display: 'flex', gap: 12, alignItems: 'flex-start' }}>
                      <div style={{ flex: 1 }}><div style={{ fontSize: 13, fontWeight: 600, marginBottom: 6 }}>Placement Exam</div><div style={{ fontSize: 12, color: C.muted }}>Take a test to determine your current Spanish level and adjust your lesson content accordingly.</div></div>
                      <button onClick={() => setRetakeConfirm(true)} style={btnS()}>Retake</button>
                    </div>
                  </div>
                  {retakeConfirm && (
                    <div style={{ ...cardS, marginTop: 16, background: `${C.yellow}11`, border: `1px solid ${C.yellow}44` }}>
                      <div style={{ fontSize: 14, fontWeight: 700, color: C.yellow, marginBottom: 8 }}>⚠️ Caution</div>
                      <div style={{ fontSize: 14, color: C.muted, marginBottom: 14 }}>Retaking the Placement Test and being assigned a new level will change your content level as well. Your progress will be adjusted.</div>
                      <div style={{ display: 'flex', gap: 10 }}>
                        <button style={btnS()} onClick={() => { setRetakeConfirm(false); navigate('/onboarding/placement?retake=1'); }}>Confirm & Retake</button>
                        <button style={btnS('ghost')} onClick={() => setRetakeConfirm(false)}>Cancel</button>
                      </div>
                    </div>
                  )}
                </div>
              )}

            </div>
          )}
        </div>
      </div>
    </>
  );
}