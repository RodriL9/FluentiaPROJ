import { useEffect, useMemo, useRef, useState } from 'react';
import { Link, useLocation, useNavigate } from 'react-router-dom';
import { clearStoredUser, deleteMyAccount, getNextOnboardingRoute, getStoredUser, verifyAccountPassword } from '../api/auth';
import { speakFluent } from '../utils/speech';
import LessonsPage from './LessonsPage';
import LessonDetailPage from './LessonDetailPage';
import ExercisesPage from './ExercisesPage';
import TopicsPage from './TopicsPage';
import '../styles/mix-match-module.css';

const C = { bg: '#eef6f3', surface: '#f8fffc', card: '#f8fffc', border: '#bfdbfe', accent: '#3b82f6', accentLight: '#22c1c3', accentGlow: 'rgba(59,130,246,0.16)', green: '#22c55e', yellow: '#f59e0b', red: '#ef4444', text: '#0f172a', muted: '#64748b', dim: '#d9e8e4' };

const NAV = [
  { section: '', items: [{ to: '/dashboard', label: '🏠 Dashboard', exact: true }] },
  { section: 'Your Learning', items: [{ to: '/dashboard/lessons', label: '📖 Lessons' }, { to: '/dashboard/topics', label: '🗂️ Topics' }, { to: '/dashboard/exercises', label: '🏋️ Exercises' }, { to: '/dashboard/ai-conversation', label: '🤖 AI Conversation' }, { to: '/dashboard/weak-spots', label: '📍 Weak Spots' }] },
  { section: 'Account', items: [{ to: '/dashboard/account', label: '👤 Account' }, { to: '/dashboard/achievements', label: '🏆 Achievements' }, { to: '/dashboard/subscription', label: '💳 Subscription' }, { to: '/dashboard/retake-placement', label: '🎚️ Level Adjust' }] },
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
function weakSpotRoute(item) {
  const maybeLessonNumber = Number(item?.source_lesson_number);
  if (Number.isInteger(maybeLessonNumber) && maybeLessonNumber >= 1 && maybeLessonNumber <= 7) {
    return `/dashboard/lessons/${maybeLessonNumber}`;
  }

  const refType = String(item?.reference_type || '').toUpperCase();
  const section = String(item?.section || '').toLowerCase();

  if (refType === 'TEMPLATE' || section === 'conversation' || section === 'speaking') return '/dashboard/ai-conversation';
  if (refType === 'TOPIC') return '/dashboard/topics';

  // Fallback mapping to core lessons when precise lesson metadata is missing.
  if (refType === 'VOCABULARY' || section === 'vocabulary') return '/dashboard/lessons/2';
  if (refType === 'PHRASE' || section === 'listening') return '/dashboard/lessons/4';
  if (refType === 'GRAMMAR' || section === 'grammar') return '/dashboard/lessons/3';
  if (refType === 'READING' || section === 'writing') return '/dashboard/lessons/7';

  if (item?.topic_tag) return '/dashboard/topics';
  return '/dashboard/lessons';
}
function weakSpotTarget(item) {
  const route = weakSpotRoute(item);
  const lessonMatch = route.match(/^\/dashboard\/lessons\/(\d+)$/);
  if (lessonMatch) return { route, label: `Open Lesson ${lessonMatch[1]}` };
  if (route === '/dashboard/ai-conversation') return { route, label: 'Open AI Conversation' };
  if (route === '/dashboard/topics') return { route, label: 'Open Topics' };
  if (route === '/dashboard/lessons') return { route, label: 'Open Lessons' };
  return { route, label: 'Go to source' };
}
function mixMatchPairFromLessonRow(lessonNumber, row, index) {
  const lesson = Number(lessonNumber);
  const baseId = String(row?.id || `${lesson}-${index}`);
  if (lesson === 1) {
    const word = String(row?.letter || '').trim();
    const translation = String(row?.phonetic_es || '').trim();
    if (!word || !translation) return null;
    return { id: `${lesson}-${baseId}`, word, translation, topic_tag: row?.topic_tag || `lesson_${lesson}` };
  }
  if (lesson === 2) {
    const word = String(row?.word || '').trim();
    const translation = String(row?.translation || '').trim();
    if (!word || !translation) return null;
    return { id: `${lesson}-${baseId}`, word, translation, topic_tag: row?.topic_tag || `lesson_${lesson}` };
  }
  if (lesson === 3) {
    const word = String(row?.spanish || '').trim();
    const translation = String(row?.english || '').trim();
    if (!word || !translation) return null;
    return { id: `${lesson}-${baseId}`, word, translation, topic_tag: row?.topic_tag || `lesson_${lesson}` };
  }
  if (lesson === 4) {
    const word = String(row?.phrase || '').trim();
    const translation = String(row?.translation || '').trim();
    if (!word || !translation) return null;
    return { id: `${lesson}-${baseId}`, word, translation, topic_tag: row?.topic_tag || `lesson_${lesson}` };
  }
  const word = String(row?.spanish || row?.word || row?.phrase || '').trim();
  const translation = String(row?.english || row?.translation || '').trim();
  if (!word || !translation) return null;
  return { id: `${lesson}-${baseId}`, word, translation, topic_tag: row?.topic_tag || `lesson_${lesson}` };
}
function weakSpotPeriod(itemDate) {
  if (!itemDate) return 'Older';
  const date = new Date(itemDate);
  if (Number.isNaN(date.getTime())) return 'Older';

  const now = new Date();
  const startOfThisWeek = new Date(now);
  const weekday = startOfThisWeek.getDay();
  const mondayOffset = weekday === 0 ? -6 : 1 - weekday;
  startOfThisWeek.setDate(startOfThisWeek.getDate() + mondayOffset);
  startOfThisWeek.setHours(0, 0, 0, 0);

  const startOfLastWeek = new Date(startOfThisWeek);
  startOfLastWeek.setDate(startOfLastWeek.getDate() - 7);

  const startOfThisMonth = new Date(now.getFullYear(), now.getMonth(), 1);
  const startOfLastMonth = new Date(now.getFullYear(), now.getMonth() - 1, 1);

  if (date >= startOfThisWeek) return 'This Week';
  if (date >= startOfLastWeek && date < startOfThisWeek) return 'Last Week';
  if (date >= startOfLastMonth && date < startOfThisMonth) return 'Last Month';
  return 'Older';
}
function buildMiniCalendar(streakDays) {
  const now = new Date();
  const year = now.getFullYear();
  const month = now.getMonth();
  const firstDay = new Date(year, month, 1);
  const daysInMonth = new Date(year, month + 1, 0).getDate();
  const startPadding = firstDay.getDay();
  const today = now.getDate();

  const streakSet = new Set();
  for (let i = 0; i < Number(streakDays || 0); i += 1) {
    const d = today - i;
    if (d > 0) streakSet.add(d);
  }

  const cells = [];
  for (let i = 0; i < startPadding; i += 1) cells.push({ day: '', streak: false });
  for (let day = 1; day <= daysInMonth; day += 1) cells.push({ day, streak: streakSet.has(day) });
  while (cells.length % 7 !== 0) cells.push({ day: '', streak: false });

  return {
    monthLabel: now.toLocaleString('en-US', { month: 'long', year: 'numeric' }),
    cells,
  };
}

const cardS = { background: '#f4f8ff', borderRadius: 16, border: `1px solid ${C.border}`, padding: 24 };
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
  const [aiChatMessages, setAiChatMessages] = useState([{ role: 'assistant', content: "Hi! I'm your AI language tutor — ask me anything." }]);
  const [aiChatScrollEl, setAiChatScrollEl] = useState(null);
  const [chatOpen, setChatOpen] = useState(false);
  const [botInput, setBotInput] = useState('');
  const [botMessages, setBotMessages] = useState([{ role: 'assistant', content: "Hi, I'm Florencia, your Spanish tutor chatbot. Ask me anything you want to learn in Spanish." }]);
  const [botChatScrollEl, setBotChatScrollEl] = useState(null);
  const [aiConversationMode, setAiConversationMode] = useState('tutor');
  const [aiVoiceListening, setAiVoiceListening] = useState(false);
  const [aiVoiceInterim, setAiVoiceInterim] = useState('');
  const [aiVoiceError, setAiVoiceError] = useState('');
  const [aiAutoListen, setAiAutoListen] = useState(true);
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
  const [lessonCatalog, setLessonCatalog] = useState([]);
  const [homeWeakSpots, setHomeWeakSpots] = useState([]);
  const [paymentMethod, setPaymentMethod] = useState({ holder: '', cardNumber: '', expiry: '', cvc: '' });
  const [paymentMethodError, setPaymentMethodError] = useState('');
  const [paymentMethodInfo, setPaymentMethodInfo] = useState('');
  const mixMatchItemsRef = useRef(null);
  const mixMatchPoolRef = useRef([]);
  const aiRecognitionRef = useRef(null);
  const aiChatEndRef = useRef(null);
  const botChatEndRef = useRef(null);

  const selectedTopics = useMemo(() => parseCsv(user?.learningGoals), [user?.learningGoals]);
  const activeTopic = useMemo(() => topicsData.find(t => t.code === activeTopicCode) || null, [topicsData, activeTopicCode]);
  const [currentLesson, setCurrentLesson] = useState(null);
  const completedLessons = useMemo(() => lessonCatalog.filter(l => l.status === 'COMPLETED').length, [lessonCatalog]);
  const miniCalendar = useMemo(() => buildMiniCalendar(streak), [streak]);

  useEffect(() => {
    document.body.classList.add('fl-dashboard-light-body');
    return () => {
      document.body.classList.remove('fl-dashboard-light-body');
    };
  }, []);

  useEffect(() => { const next = getNextOnboardingRoute(user); if (next !== '/dashboard') navigate(next, { replace: true }); }, [navigate, user]);

 useEffect(() => {
  if (!user?.id) return;
  fetch(`/api/me/summary?userId=${encodeURIComponent(user.id)}`).then(r => r.ok ? r.json() : null).then(d => { if (d) { setXp(Number(d.xp || 0)); setStreak(Number(d.streak_count || 0)); } }).catch(() => {});

  fetch(`/api/lesson-catalog?userId=${encodeURIComponent(user.id)}`)
    .then(r => r.ok ? r.json() : [])
    .then(lessons => {
      const rows = Array.isArray(lessons) ? lessons : [];
      setLessonCatalog(rows);
      const inProgress = rows.find(l => l.status === 'IN_PROGRESS');
      const available = rows.find(l => l.status === 'AVAILABLE');
      setCurrentLesson(inProgress || available || null);
    })
    .catch(() => {});
}, [user?.id, pathname]);

  useEffect(() => {
    if (!user?.id || path !== '/dashboard') return;
    let cancelled = false;
    const lang = encodeURIComponent(user.learningLanguage || 'es');
    fetch(`/api/practice/troubles?userId=${encodeURIComponent(user.id)}&language=${lang}`)
      .then(r => r.ok ? r.json() : [])
      .then(rows => { if (!cancelled) setHomeWeakSpots(Array.isArray(rows) ? rows.slice(0, 3) : []); })
      .catch(() => { if (!cancelled) setHomeWeakSpots([]); });
    return () => { cancelled = true; };
  }, [user?.id, user?.learningLanguage, path]);

  useEffect(() => {
    if (!user?.id) return;
    fetch(`/api/topics?language=${encodeURIComponent(user.learningLanguage || 'es')}`).then(r => r.ok ? r.json() : []).then(d => setTopicsCatalog(Array.isArray(d) ? d : [])).catch(() => {});
  }, [user?.id, user?.learningLanguage]);

  useEffect(() => {
    if (!user) return;
    const endpoints = { '/dashboard/achievements': '/api/achievements/me', '/dashboard/subscription': '/api/subscriptions/me', '/dashboard/weak-spots': '/api/practice/troubles' };
    const endpoint = endpoints[path];
    if (path === '/dashboard/mix-match') {
      let cancelled = false;
      setLoading(true); setError('');
      (async () => {
        try {
          const lessons = await fetch(`/api/lesson-catalog?userId=${encodeURIComponent(user.id)}`).then(r => r.ok ? r.json() : []);
          const unlocked = (Array.isArray(lessons) ? lessons : []).filter((l) => String(l?.status || '').toUpperCase() !== 'LOCKED');
          const sourceLessons = unlocked.length ? unlocked : (Array.isArray(lessons) ? lessons : []);
          const lessonRows = await Promise.all(
            sourceLessons.map(async (lesson) => {
              const n = Number(lesson?.lesson_number);
              if (!Number.isFinite(n)) return [];
              const payload = await fetch(`/api/lesson-catalog/${n}/content?userId=${encodeURIComponent(user.id)}`).then(r => r.ok ? r.json() : null);
              const content = Array.isArray(payload?.content) ? payload.content : [];
              return content.map((row, idx) => mixMatchPairFromLessonRow(n, row, idx)).filter(Boolean);
            })
          );
          const merged = lessonRows.flat();
          if (!cancelled) {
            if (merged.length >= 3) {
              setItems(merged);
            } else {
              const lang = encodeURIComponent(user.learningLanguage || 'es');
              const fallback = await fetch(`/api/vocabulary?language=${lang}&userId=${encodeURIComponent(user.id)}&applyTopicFilter=true`).then(r => r.ok ? r.json() : []);
              if (!cancelled) setItems(Array.isArray(fallback) ? fallback : []);
            }
          }
        } catch (e) {
          if (!cancelled) setError(e.message);
        } finally {
          if (!cancelled) setLoading(false);
        }
      })();
      return () => { cancelled = true; };
    }
    if (!endpoint && path !== '/dashboard/topics') { setItems([]); setLoading(false); return; }
    if (path === '/dashboard/topics') return;
    let cancelled = false;
    setLoading(true); setError('');
    const lang = encodeURIComponent(user.learningLanguage || 'es');
    const url = `${endpoint}?userId=${encodeURIComponent(user.id)}&language=${lang}`;
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
  useEffect(() => {
    if (!aiChatScrollEl) return;
    const scrollToBottom = () => {
      aiChatScrollEl.scrollTop = aiChatScrollEl.scrollHeight;
      aiChatEndRef.current?.scrollIntoView({ block: 'end' });
    };
    scrollToBottom();
    const raf = window.requestAnimationFrame(scrollToBottom);
    const t1 = window.setTimeout(scrollToBottom, 40);
    const t2 = window.setTimeout(scrollToBottom, 140);
    return () => {
      window.cancelAnimationFrame(raf);
      window.clearTimeout(t1);
      window.clearTimeout(t2);
    };
  }, [aiChatMessages, aiVoiceInterim, aiVoiceListening, aiChatScrollEl, path]);
  useEffect(() => {
    if (!botChatScrollEl || !chatOpen) return;
    const scrollToBottom = () => {
      botChatScrollEl.scrollTop = botChatScrollEl.scrollHeight;
      botChatEndRef.current?.scrollIntoView({ block: 'end' });
    };
    scrollToBottom();
    const raf = window.requestAnimationFrame(scrollToBottom);
    return () => window.cancelAnimationFrame(raf);
  }, [botMessages, botChatScrollEl, chatOpen]);
  useEffect(() => {
    if (path === '/dashboard/ai-conversation') return;
    if (aiRecognitionRef.current) aiRecognitionRef.current.stop();
    setAiVoiceListening(false);
    setAiVoiceInterim('');
  }, [path]);
  useEffect(() => {
    const hardStopMic = () => {
      if (aiRecognitionRef.current) {
        try { aiRecognitionRef.current.stop(); } catch {}
        aiRecognitionRef.current = null;
      }
      if (typeof window !== 'undefined' && window.speechSynthesis) {
        window.speechSynthesis.cancel();
      }
      setAiVoiceListening(false);
      setAiVoiceInterim('');
    };
    const onVisibilityChange = () => {
      if (document.visibilityState !== 'visible') hardStopMic();
    };
    window.addEventListener('beforeunload', hardStopMic);
    window.addEventListener('pagehide', hardStopMic);
    document.addEventListener('visibilitychange', onVisibilityChange);
    return () => {
      window.removeEventListener('beforeunload', hardStopMic);
      window.removeEventListener('pagehide', hardStopMic);
      document.removeEventListener('visibilitychange', onVisibilityChange);
    };
  }, []);
  useEffect(() => () => { if (aiRecognitionRef.current) aiRecognitionRef.current.stop(); }, []);

  const mmProgressPct = useMemo(() => { if (!mixMatchState?.pairs?.length || mixMatchState.tooFew) return 0; return Math.min(100, Math.round((Object.keys(mixMatchState.matched || {}).length / mixMatchState.pairs.length) * 100)); }, [mixMatchState]);
  const weakSpotGroups = useMemo(() => {
    const grouped = { 'This Week': [], 'Last Week': [], 'Last Month': [] };
    (items || []).forEach((item) => {
      const period = weakSpotPeriod(item?.last_wrong_at);
      if (grouped[period]) grouped[period].push(item);
    });
    return grouped;
  }, [items]);

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

  const speakWord = (word, fallback) => { speakFluent(String(fallback || word || ''), { language: user?.learningLanguage || 'es', rate: 0.9 }); };

  const startAiVoiceListening = () => {
    if (!aiVoiceSupported) {
      setAiVoiceError('Your browser does not support microphone speech recognition.');
      return false;
    }
    if (aiRecognitionRef.current) {
      try { aiRecognitionRef.current.stop(); } catch {}
      aiRecognitionRef.current = null;
      setAiVoiceListening(false);
    }
    const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
    const recognition = new SpeechRecognition();
    aiRecognitionRef.current = recognition;
    const tutorSpeechLanguage = user?.nativeLanguage || (String(user?.learningLanguage || 'es').toLowerCase() === 'es' ? 'en' : 'es');
    const recognitionLanguage = aiConversationMode === 'tutor' ? tutorSpeechLanguage : (user?.learningLanguage || 'es');
    recognition.lang = String(recognitionLanguage).toLowerCase() === 'es' ? 'es-ES' : 'en-US';
    recognition.interimResults = true;
    recognition.maxAlternatives = 1;
    recognition.continuous = false;
    let finalTranscript = '';
    setAiVoiceError('');
    setAiVoiceInterim('');
    setAiVoiceListening(true);
    recognition.onresult = (event) => {
      let interim = '';
      for (let i = event.resultIndex; i < event.results.length; i += 1) {
        const transcript = String(event.results[i][0]?.transcript || '').trim();
        if (!transcript) continue;
        if (event.results[i].isFinal) finalTranscript = `${finalTranscript} ${transcript}`.trim();
        else interim = `${interim} ${transcript}`.trim();
      }
      setAiVoiceInterim(interim || finalTranscript);
    };
    recognition.onstart = () => {
      setAiVoiceListening(true);
      setAiVoiceError('');
    };
    recognition.onerror = (event) => {
      if (event?.error === 'not-allowed') setAiVoiceError('Microphone permission denied. Please allow microphone access.');
      else if (event?.error === 'no-speech') setAiVoiceError('No speech detected. Try again and speak clearly.');
      else setAiVoiceError('Could not use microphone right now.');
    };
    recognition.onend = () => {
      setAiVoiceListening(false);
      setAiVoiceInterim('');
      aiRecognitionRef.current = null;
      if (finalTranscript) {
        setAiInput(finalTranscript);
        sendAiMessage(finalTranscript, { speakReply: true });
      }
    };
    recognition.start();
    return true;
  };
  const sendAiMessage = async (messageOverride = '', options = {}) => {
    const msg = String(messageOverride || aiInput).trim();
    if (!msg) return;
    const shouldSpeakReply = options.speakReply ?? path === '/dashboard/ai-conversation';
    setAiVoiceError('');
    setAiChatMessages(prev => [...prev, { role: 'user', content: msg }]);
    if (!messageOverride) setAiInput('');
    try {
      const res = await fetch('/api/ai/conversation/feedback', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          userId: user?.id,
          language: user?.learningLanguage || 'es',
          userMessage: msg,
          mode: aiConversationMode,
        }),
      });
      const data = res.ok ? await res.json() : null;
      const reply = data?.assistantReply || 'I could not respond right now.';
      setAiChatMessages(prev => [...prev, { role: 'assistant', content: reply }]);
      if (shouldSpeakReply) {
        const tutorSpeechLanguage = user?.nativeLanguage || (String(user?.learningLanguage || 'es').toLowerCase() === 'es' ? 'en' : 'es');
        const targetSpeechLanguage = user?.learningLanguage || 'es';
        if (aiConversationMode === 'tutor') {
          const parts = String(reply).split(/(".*?"|“.*?”)/g).filter(Boolean);
          let firstChunk = true;
          for (const chunk of parts) {
            const raw = String(chunk || '').trim();
            if (!raw) continue;
            const isQuoted = /^(".*"|“.*”)$/.test(raw);
            const spoken = raw.replace(/^["“]|["”]$/g, '').trim();
            if (!spoken) continue;
            await speakFluent(spoken, {
              language: isQuoted ? targetSpeechLanguage : tutorSpeechLanguage,
              rate: isQuoted ? 0.9 : 0.92,
              cancelOngoing: firstChunk,
            });
            firstChunk = false;
          }
        } else {
          await speakFluent(reply, { language: targetSpeechLanguage, rate: 0.92 });
        }
        if ((options.autoListenAfterReply ?? (aiAutoListen && path === '/dashboard/ai-conversation')) && !aiVoiceListening) {
          startAiVoiceListening();
        }
      }
    } catch {
      setAiChatMessages(prev => [...prev, { role: 'assistant', content: 'I could not respond right now.' }]);
    }
  };
  const sendBotMessage = async () => {
    const msg = String(botInput || '').trim();
    if (!msg) return;
    setBotMessages(prev => [...prev, { role: 'user', content: msg }]);
    setBotInput('');
    try {
      const res = await fetch('/api/ai/conversation/feedback', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          userId: user?.id,
          language: user?.learningLanguage || 'es',
          userMessage: msg,
          mode: 'tutor',
        }),
      });
      const data = res.ok ? await res.json() : null;
      const reply = data?.assistantReply || 'I could not respond right now.';
      setBotMessages(prev => [...prev, { role: 'assistant', content: reply }]);
    } catch {
      setBotMessages(prev => [...prev, { role: 'assistant', content: 'I could not respond right now.' }]);
    }
  };
  const aiVoiceSupported = useMemo(
    () => typeof window !== 'undefined' && (!!window.SpeechRecognition || !!window.webkitSpeechRecognition),
    []
  );
  const stopAiConversation = () => {
    if (aiRecognitionRef.current) {
      try { aiRecognitionRef.current.stop(); } catch {}
    }
    if (typeof window !== 'undefined' && window.speechSynthesis) {
      window.speechSynthesis.cancel();
    }
    setAiAutoListen(false);
    setAiVoiceListening(false);
    setAiVoiceInterim('');
    setAiVoiceError('');
  };
  const resetAiConversation = () => {
    stopAiConversation();
    setAiInput('');
    setAiChatMessages([{ role: 'assistant', content: "Hi! I'm your AI language tutor — ask me anything." }]);
  };
  const toggleAiVoiceListening = () => {
    if (aiRecognitionRef.current) {
      try { aiRecognitionRef.current.stop(); } catch {}
      aiRecognitionRef.current = null;
      setAiVoiceListening(false);
      setAiVoiceInterim('');
      return;
    }
    startAiVoiceListening();
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
              {group.section ? (
                <div style={{ fontSize: 10, fontWeight: 700, color: C.muted, padding: '14px 24px 4px', textTransform: 'uppercase', letterSpacing: '0.08em' }}>{group.section}</div>
              ) : null}
              {group.items.map(item => (
                <Link key={item.to} to={item.to} style={{ textDecoration: 'none' }}>
                  <button style={{ display: 'flex', alignItems: 'center', gap: 10, padding: '10px 14px', margin: '4px 12px', cursor: 'pointer', width: 'calc(100% - 24px)', background: isActive(pathname, item) ? '#e6efff' : '#f4f8ff', color: isActive(pathname, item) ? C.accent : C.muted, border: `1px solid ${isActive(pathname, item) ? '#93c5fd' : '#bfdbfe'}`, borderRadius: 12, fontSize: 18, fontWeight: isActive(pathname, item) ? 700 : 500, transition: 'all 0.15s', textAlign: 'left', fontFamily: 'inherit' }}>{item.label}</button>
                </Link>
              ))}
            </div>
          ))}
          <div style={{ padding: '8px 0', marginTop: 'auto', marginBottom: 44 }}>
            <button onClick={() => { clearStoredUser(); navigate('/login'); }} style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 10, padding: '10px 14px', margin: '4px 12px', background: '#ef4444', border: '1px solid #dc2626', borderRadius: 12, color: '#ffffff', cursor: 'pointer', fontSize: 18, width: 'calc(100% - 24px)', fontFamily: 'inherit', fontWeight: 700 }}>🚪 Log out</button>
          </div>
        </div>

        {/* Main */}
        <div style={{ flex: 1, overflowY: 'auto', padding: 32, background: C.bg }}>

          {/* HOME */}
          {path === '/dashboard' && (
            <div>
              <div style={{ display: 'grid', gridTemplateColumns: 'minmax(0, 2.2fr) minmax(260px, 1fr)', gap: 18 }}>
                <div style={{ display: 'grid', gap: 14 }}>
                  <div style={{ ...cardS, padding: 20 }}>
                    <h1 style={{ fontSize: 44, fontWeight: 800, margin: 0, letterSpacing: '-0.7px' }}>Welcome Back, {user?.username || 'Learner'}!</h1>
                    <p style={{ color: C.muted, margin: '6px 0 14px', fontSize: 15 }}>Keep your {fmtTopic(user?.learningLanguage || 'Spanish')} path active with focused daily practice.</p>
                    <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, minmax(0, 1fr))', gap: 10 }}>
                      <div style={{ ...cardS, padding: 14, background: `${C.accent}14`, border: `1px solid ${C.accent}44` }}>
                        <div style={{ fontSize: 13, color: C.muted }}>XP to next language level</div>
                        <div style={{ fontSize: 36, fontWeight: 800, color: C.accentLight, marginTop: 2 }}>
                          {(() => {
                            const next = [1000, 3000, 7000, 15000, 30000, 50000].find(level => level > xp) || 50000;
                            return `${(next - xp).toLocaleString()} XP`;
                          })()}
                        </div>
                      </div>
                      <div style={{ ...cardS, padding: 14, background: `${C.yellow}12`, border: `1px solid ${C.yellow}44` }}>
                        <div style={{ fontSize: 13, color: C.muted }}>XP to next module</div>
                        <div style={{ fontSize: 36, fontWeight: 800, color: C.yellow, marginTop: 2 }}>
                          {Math.max(0, 100 - Math.round(currentLesson?.score_percentage || 0))} XP
                        </div>
                      </div>
                    </div>
                  </div>

                  <div style={{ ...cardS, padding: 16 }}>
                    <div style={{ fontSize: 13, color: C.muted, marginBottom: 8 }}>Start where you last left off</div>
                    <div style={{ height: 126, borderRadius: 12, border: `1px solid ${C.border}`, background: 'linear-gradient(135deg, rgba(124,106,247,0.16), rgba(124,106,247,0.02))', marginBottom: 12, display: 'flex', alignItems: 'center', justifyContent: 'center', color: C.muted }}>
                      {currentLesson ? `Lesson ${currentLesson.lesson_number}: ${currentLesson.title}` : 'Travel Dialogues'}
                    </div>
                    <div style={{ fontSize: 34, fontWeight: 800, marginBottom: 8 }}>{currentLesson ? `${currentLesson.title}` : 'Travel Dialogues: Airport Check-in'}</div>
                    <ProgressBar val={currentLesson ? Math.round(currentLesson.score_percentage || 0) : 0} total={100} />
                    <Link to="/dashboard/lessons"><button style={{ ...btnS(), marginTop: 12 }}>Resume lesson</button></Link>
                  </div>

                  <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, minmax(0, 1fr))', gap: 10 }}>
                    {[{ label: 'Modules', to: '/dashboard/lessons' }, { label: 'Your Topics', to: '/dashboard/topics' }, { label: 'Vocabulary', to: '/dashboard/mix-match' }].map(({ label, to }) => (
                      <Link key={to} to={to} style={{ textDecoration: 'none' }}>
                        <div style={{ ...cardS, padding: 12, textAlign: 'center', fontSize: 15, fontWeight: 700 }}>{label}</div>
                      </Link>
                    ))}
                  </div>

                  <div style={{ ...cardS, padding: 14, background: `${C.red}0d`, border: `1px solid ${C.red}33` }}>
                    <div style={{ fontSize: 28, fontWeight: 800, color: C.red, marginBottom: 6 }}>Weak spots</div>
                    <div style={{ fontSize: 22, color: C.text }}>
                      {homeWeakSpots.length > 0
                        ? homeWeakSpots.map(item => truncate(stripU(item.label_snapshot || item.section || 'Practice item'), 80)).join(', ')
                        : 'No weak spots yet. Keep practicing to maintain your streak.'}
                    </div>
                  </div>

                  <div style={cardS}>
                    <div style={{ fontSize: 30, fontWeight: 800, marginBottom: 10 }}>Recent activity</div>
                    <div style={{ display: 'grid', gap: 10 }}>
                      <div style={{ padding: 12, border: `1px solid ${C.border}`, borderRadius: 12, background: C.surface }}>Completed lessons: <strong>{completedLessons}</strong></div>
                      <div style={{ padding: 12, border: `1px solid ${C.border}`, borderRadius: 12, background: C.surface }}>Topics selected: <strong>{selectedTopics.length}</strong></div>
                      <div style={{ padding: 12, border: `1px solid ${C.border}`, borderRadius: 12, background: C.surface }}>Current streak: <strong>{streak} days</strong></div>
                    </div>
                  </div>
                </div>

                <div style={{ ...cardS, padding: 16, alignSelf: 'start' }}>
                  <h2 style={{ fontSize: 38, fontWeight: 800, margin: 0 }}>Progress</h2>
                  <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, minmax(0, 1fr))', gap: 8, marginTop: 10 }}>
                    <div style={{ ...cardS, padding: 10 }}>
                      <div style={{ color: C.yellow, marginBottom: 2 }}>🔥</div>
                      <div style={{ fontSize: 28, fontWeight: 800 }}>{streak} days</div>
                      <div style={{ color: C.muted, fontSize: 12 }}>Longest streak</div>
                    </div>
                    <div style={{ ...cardS, padding: 10 }}>
                      <div style={{ color: '#fde047', marginBottom: 2 }}>⭐</div>
                      <div style={{ fontSize: 28, fontWeight: 800 }}>{xp} XP</div>
                      <div style={{ color: C.muted, fontSize: 12 }}>Total XP</div>
                    </div>
                    <div style={{ ...cardS, padding: 10 }}>
                      <div style={{ color: '#93c5fd', marginBottom: 2 }}>📖</div>
                      <div style={{ fontSize: 28, fontWeight: 800 }}>{selectedTopics.length}</div>
                      <div style={{ color: C.muted, fontSize: 12 }}>Topics</div>
                    </div>
                    <div style={{ ...cardS, padding: 10 }}>
                      <div style={{ color: '#c4b5fd', marginBottom: 2 }}>🎓</div>
                      <div style={{ fontSize: 28, fontWeight: 800 }}>{completedLessons}</div>
                      <div style={{ color: C.muted, fontSize: 12 }}>Completed lessons</div>
                    </div>
                  </div>

                  <h3 style={{ fontSize: 34, margin: '16px 0 8px' }}>Streak - calendar</h3>
                  <div style={{ ...cardS, padding: 10 }}>
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 8 }}>
                      <span style={{ color: C.muted }}>‹</span>
                      <strong style={{ fontSize: 14 }}>{miniCalendar.monthLabel}</strong>
                      <span style={{ color: C.muted }}>›</span>
                    </div>
                    <div style={{ display: 'grid', gridTemplateColumns: 'repeat(7, minmax(0, 1fr))', gap: 4, fontSize: 11, color: C.muted, marginBottom: 4 }}>
                      {['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'].map(d => <span key={d} style={{ textAlign: 'center' }}>{d}</span>)}
                    </div>
                    <div style={{ display: 'grid', gridTemplateColumns: 'repeat(7, minmax(0, 1fr))', gap: 4 }}>
                      {miniCalendar.cells.map((cell, idx) => (
                        <div key={`${cell.day}-${idx}`} style={{ minHeight: 24, borderRadius: 6, border: `1px solid ${C.border}`, display: 'grid', placeItems: 'center', fontSize: 12, color: cell.day ? C.text : C.dim, background: cell.streak ? `${C.yellow}22` : 'transparent' }}>
                          {cell.day ? (cell.streak ? '🔥' : cell.day) : ''}
                        </div>
                      ))}
                    </div>
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* NON-HOME */}
          {path !== '/dashboard' && (
            <div>
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
              {(path === '/dashboard/topics' || path.startsWith('/dashboard/topics/')) && (
                <TopicsPage selectedTopicCode={path.startsWith('/dashboard/topics/') ? decodeURIComponent(path.replace('/dashboard/topics/', '')) : ''} />
              )}

              {path === '/dashboard/exercises' && <ExercisesPage />}
{/* AI CONVERSATION */}
{path === '/dashboard/ai-conversation' && (
  <div>
    <h1 style={{ fontSize: 28, fontWeight: 800, marginBottom: 20, letterSpacing: '-0.5px' }}>AI Conversation</h1>
    <div style={{ display: 'flex', flexDirection: 'column', gap: 16, maxWidth: 760 }}>
      <div style={{ ...cardS, display: 'grid', gap: 12 }}>
        <div>
          <div style={{ fontSize: 16, fontWeight: 700, marginBottom: 4 }}>🎙️ Speak with AI</div>
          <div style={{ fontSize: 13, color: C.muted }}>Choose conversation mode, talk with your mic, and get spoken replies.</div>
        </div>
        <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
          <button type="button" onClick={() => setAiConversationMode('spanish_only')} style={{ ...btnS(aiConversationMode === 'spanish_only' ? 'primary' : 'ghost'), fontSize: 12 }}>
            Spanish-only conversation
          </button>
          <button type="button" onClick={() => setAiConversationMode('tutor')} style={{ ...btnS(aiConversationMode === 'tutor' ? 'primary' : 'ghost'), fontSize: 12 }}>
            Tutor mode (correct me)
          </button>
          <button type="button" onClick={toggleAiVoiceListening} style={{ ...btnS(aiVoiceListening ? 'ghost' : 'primary'), fontSize: 12 }}>
            {aiVoiceListening ? 'Stop listening' : 'Start mic'}
          </button>
          <button type="button" onClick={() => setAiAutoListen(v => !v)} style={{ ...btnS(aiAutoListen ? 'primary' : 'ghost'), fontSize: 12 }}>
            {aiAutoListen ? 'Auto listen: ON' : 'Auto listen: OFF'}
          </button>
          <button
            type="button"
            onClick={stopAiConversation}
            style={{ ...btnS('ghost'), fontSize: 12, color: C.red, border: `1px solid ${C.red}55`, background: '#fff5f5' }}
          >
            Stop conversation
          </button>
          <button
            type="button"
            onClick={resetAiConversation}
            style={{ ...btnS('ghost'), fontSize: 12, color: C.text, border: `1px solid ${C.border}`, background: '#ffffff' }}
          >
            Reset conversation
          </button>
        </div>
        {aiVoiceInterim ? <div style={{ fontSize: 12, color: C.muted }}>Listening: "{aiVoiceInterim}"</div> : null}
        {aiVoiceError ? <div style={{ fontSize: 12, color: C.red }}>{aiVoiceError}</div> : null}
        {!aiVoiceSupported ? <div style={{ fontSize: 12, color: C.muted }}>Mic input is not supported in this browser. You can still type below.</div> : null}
      </div>
      <div style={{ ...cardS, padding: 14, display: 'grid', gap: 10 }}>
        <div ref={setAiChatScrollEl} style={{ maxHeight: 360, overflowY: 'auto', display: 'flex', flexDirection: 'column', gap: 10, paddingRight: 4 }}>
          {aiChatMessages.map((m, i) => (
            <div key={i} style={{ alignSelf: m.role === 'user' ? 'flex-end' : 'flex-start', background: m.role === 'user' ? C.accent : '#e2e8f0', color: m.role === 'user' ? '#fff' : C.text, padding: '10px 12px', borderRadius: 12, maxWidth: '82%', fontSize: 13.5 }}>
              {m.content}
            </div>
          ))}
          <div ref={aiChatEndRef} />
        </div>
        <div style={{ fontSize: 12, color: C.muted }}>
          Voice-only mode in this page. Use <strong style={{ color: C.text }}>Start mic</strong> above to speak.
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
                <div style={{ background: 'linear-gradient(90deg, #3b82f6 0%, #22c1c3 100%)', border: `1px solid ${C.border}`, borderRadius: 18, padding: 16 }}>
                  <p style={{ margin: 0, color: '#d9d2ff', fontSize: 18, fontWeight: 700 }}>Keep it going</p>
                  <h1 style={{ margin: '0 0 10px', fontSize: 46, lineHeight: 1.05, letterSpacing: '-0.5px', fontWeight: 800, color: '#ffffff' }}>Your Weak Spots</h1>
                  <p style={{ color: 'rgba(255,255,255,0.9)', marginBottom: 14, fontSize: 14 }}>Items answered incorrectly, organized by time period.</p>

                  {items.length === 0 ? (
                    <div style={{ background: '#f8f7ff', border: '1px solid #dbd6ff', borderRadius: 14, padding: 12, color: '#4d4688' }}>
                      No weak spots yet. Keep practicing!
                    </div>
                  ) : (
                    <div style={{ display: 'grid', gap: 12 }}>
                      {['This Week', 'Last Week', 'Last Month'].map((period) => (
                        <section key={period} style={{ background: 'rgba(248,247,255,0.16)', border: '1px solid rgba(248,247,255,0.32)', borderRadius: 14, padding: 10 }}>
                          <h2 style={{ margin: '0 0 8px', fontSize: 18, fontWeight: 800, color: '#ffffff' }}>{period}</h2>
                          {weakSpotGroups[period].length === 0 ? (
                            <div style={{ background: '#f8f7ff', border: '1px solid #dbd6ff', borderRadius: 12, padding: 10, color: '#4d4688', fontSize: 13 }}>
                              No weak spots in this period.
                            </div>
                          ) : (
                            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, minmax(0, 1fr))', gap: 10 }}>
                              {weakSpotGroups[period].map((t) => (
                                (() => {
                                  const target = weakSpotTarget(t);
                                  return (
                                    <article key={t.id} style={{ background: '#f8f7ff', border: '1px solid #dbd6ff', borderRadius: 14, padding: 10, display: 'grid', gap: 8 }}>
                                      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 10 }}>
                                        <strong style={{ color: '#201a53', fontSize: 18 }}>Weak item</strong>
                                        <span style={{ fontSize: 11, fontWeight: 700, color: '#534b92', background: '#e9e5ff', borderRadius: 999, padding: '3px 8px' }}>
                                          Missed {t.wrong_count}x
                                        </span>
                                      </div>
                                      <p style={{ margin: 0, fontSize: 15, color: '#4d4688', minHeight: 34 }}>
                                        {stripU(t.label_snapshot) || 'Practice item'}
                                      </p>
                                      <div style={{ fontSize: 12, color: '#64748b' }}>
                                        {fmtTopic(t.section || '')} {t.topic_tag ? `· ${fmtTopic(t.topic_tag)}` : ''}
                                      </div>
                                      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 8 }}>
                                        <span style={{ fontSize: 12, color: '#64748b' }}>
                                          Last wrong: {t.last_wrong_at ? new Date(t.last_wrong_at).toLocaleDateString() : '—'}
                                        </span>
                                        <button type="button" onClick={() => navigate(target.route)} style={{ border: 'none', borderRadius: 999, height: 30, padding: '0 12px', fontFamily: 'inherit', fontWeight: 700, fontSize: 12, cursor: 'pointer', background: 'linear-gradient(90deg, #3b82f6 0%, #22c1c3 100%)', color: '#fff' }}>
                                          {target.label}
                                        </button>
                                      </div>
                                    </article>
                                  );
                                })()
                              ))}
                            </div>
                          )}
                        </section>
                      ))}
                    </div>
                  )}
                </div>
              )}

              {/* ACHIEVEMENTS */}
              {path === '/dashboard/achievements' && !loading && (
                <div style={{ background: 'linear-gradient(90deg, #3b82f6 0%, #22c1c3 100%)', border: `1px solid ${C.border}`, borderRadius: 18, padding: 16 }}>
                  <p style={{ margin: 0, color: '#d9d2ff', fontSize: 18, fontWeight: 700 }}>Keep it going</p>
                  <h1 style={{ margin: '0 0 10px', fontSize: 46, lineHeight: 1.05, letterSpacing: '-0.5px', fontWeight: 800, color: '#ffffff' }}>Your Achievements</h1>
                  <p style={{ color: 'rgba(255,255,255,0.9)', marginBottom: 14, fontSize: 16 }}>Track your unlocked badges and progress toward the next milestone.</p>

                  <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, minmax(0, 1fr))', gap: 10 }}>
                    {(items || []).map((it) => {
                      const thresholds = parseThresholds(it.thresholds);
                      const currentLevel = Number(it.current_level || 0);
                      const unlocked = currentLevel > 0;
                      const nextTarget = thresholds[currentLevel] || null;
                      const progress = Number(it.progress || 0);
                      const pct = nextTarget ? Math.min(100, Math.round((progress / nextTarget) * 100)) : unlocked ? 100 : 0;

                      return (
                        <article
                          key={it.achievement_id || it.code}
                          style={{
                            background: '#f8f7ff',
                            border: '1px solid #dbd6ff',
                            borderRadius: 14,
                            padding: 8,
                            display: 'grid',
                            gap: 6,
                            opacity: unlocked ? 1 : 0.92,
                          }}
                        >
                          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 8, color: '#201a53' }}>
                            <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                              <span style={{ fontSize: 22 }}>{it.icon || '🏆'}</span>
                              <strong style={{ fontSize: 20 }}>{stripU(it.name) || 'Achievement'}</strong>
                            </div>
                            {unlocked ? (
                              <span style={{ fontSize: 12, fontWeight: 700, color: '#166534', background: '#dcfce7', borderRadius: 999, padding: '3px 8px' }}>
                                Unlocked
                              </span>
                            ) : null}
                          </div>

                          <p style={{ margin: 0, fontSize: 16, color: '#4d4688', minHeight: 36 }}>
                            {stripU(it.description || 'Keep practicing to unlock this achievement.')}
                          </p>

                          <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                            <div style={{ height: 8, borderRadius: 999, background: '#ddd9f7', flex: 1 }}>
                              <div style={{ width: `${pct}%`, height: '100%', borderRadius: 999, background: unlocked ? 'linear-gradient(90deg, #34d399, #22c55e)' : 'linear-gradient(90deg, #7c6af7, #a899ff)' }} />
                            </div>
                            <strong style={{ color: '#4f478f', fontSize: 16 }}>{pct}%</strong>
                          </div>

                          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', gap: 8, fontSize: 14, color: '#64748b' }}>
                            <span>Level {currentLevel || 0}</span>
                            <span>{nextTarget ? `${progress}/${nextTarget}` : unlocked ? 'Complete' : 'In progress'}</span>
                          </div>
                        </article>
                      );
                    })}
                  </div>

                  <div style={{ marginTop: 14, border: '1px solid #3f3480', borderRadius: 12, padding: 10, background: 'rgba(19, 13, 54, 0.45)' }}>
                    <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, minmax(0, 1fr))', gap: 12 }}>
                      <div>
                        <div style={{ color: '#d7d1fa', fontWeight: 700, marginBottom: 4, fontSize: 20 }}>Unlocked achievements</div>
                        <div style={{ height: 8, borderRadius: 999, background: '#d9d5f7' }}>
                          <div style={{ width: `${items.length ? Math.round((items.filter((x) => Number(x.current_level || 0) > 0).length / items.length) * 100) : 0}%`, height: '100%', borderRadius: 999, background: 'linear-gradient(90deg, #34d399, #22c55e)' }} />
                        </div>
                        <div style={{ marginTop: 5, color: '#ffffff', fontWeight: 700, fontSize: 29 }}>
                          {items.filter((x) => Number(x.current_level || 0) > 0).length}/{items.length}
                        </div>
                      </div>
                      <div>
                        <div style={{ color: '#d7d1fa', fontWeight: 700, marginBottom: 4, fontSize: 20 }}>Total tracked</div>
                        <div style={{ height: 8, borderRadius: 999, background: '#d9d5f7' }}>
                          <div style={{ width: '100%', height: '100%', borderRadius: 999, background: 'linear-gradient(90deg, #7c6af7, #9e8fff)' }} />
                        </div>
                        <div style={{ marginTop: 5, color: '#ffffff', fontWeight: 700, fontSize: 29 }}>{items.length}</div>
                      </div>
                    </div>
                  </div>
                </div>
              )}

              {/* SUBSCRIPTION */}
              {path === '/dashboard/subscription' && !loading && (
                <div>
                  <h1 style={{ fontSize: 28, fontWeight: 800, marginBottom: 20, letterSpacing: '-0.5px' }}>Subscription</h1>
                  <div style={{ ...cardS, marginBottom: 20, background: `${C.green}11`, border: `1px solid ${C.green}33` }}><div style={{ fontSize: 15, color: C.muted }}>Active Subscription</div><div style={{ fontSize: 22, fontWeight: 700, color: C.green, marginTop: 4 }}>{(() => { const sub = (items || [])[0]; return sub?.status === 'ACTIVE' ? fmtTopic(sub.plan) : 'Free Plan'; })()}</div></div>
                  <div style={{ ...cardS, marginBottom: 20 }}>
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', gap: 12, marginBottom: 10 }}>
                      <div>
                        <h3 style={{ margin: 0, color: C.text, fontSize: 20 }}>Payment Method</h3>
                        <div style={{ fontSize: 14, color: C.muted, marginTop: 4 }}>Add or update your card for subscription billing.</div>
                      </div>
                    </div>
                    {paymentMethodInfo ? <div style={{ marginBottom: 10, fontSize: 14, color: C.green }}>{paymentMethodInfo}</div> : null}
                    {paymentMethodError ? <div style={{ marginBottom: 10, fontSize: 14, color: C.red }}>{paymentMethodError}</div> : null}
                    <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, minmax(0, 1fr))', gap: 10 }}>
                      <input
                        value={paymentMethod.holder}
                        onChange={(e) => { setPaymentMethod((p) => ({ ...p, holder: e.target.value })); setPaymentMethodError(''); setPaymentMethodInfo(''); }}
                        placeholder="Cardholder name"
                        style={{ background: '#f1f5f9', border: `1px solid ${C.border}`, borderRadius: 10, padding: '10px 14px', color: C.text, fontFamily: 'inherit', fontSize: 15, outline: 'none' }}
                      />
                      <input
                        value={paymentMethod.cardNumber}
                        onChange={(e) => { const clean = e.target.value.replace(/\D/g, '').slice(0, 16); const chunks = clean.match(/.{1,4}/g) || []; setPaymentMethod((p) => ({ ...p, cardNumber: chunks.join(' ') })); setPaymentMethodError(''); setPaymentMethodInfo(''); }}
                        placeholder="Card number"
                        style={{ background: '#f1f5f9', border: `1px solid ${C.border}`, borderRadius: 10, padding: '10px 14px', color: C.text, fontFamily: 'inherit', fontSize: 15, outline: 'none' }}
                      />
                      <input
                        value={paymentMethod.expiry}
                        onChange={(e) => { const clean = e.target.value.replace(/\D/g, '').slice(0, 4); const next = clean.length >= 3 ? `${clean.slice(0, 2)}/${clean.slice(2)}` : clean; setPaymentMethod((p) => ({ ...p, expiry: next })); setPaymentMethodError(''); setPaymentMethodInfo(''); }}
                        placeholder="MM/YY"
                        style={{ background: '#f1f5f9', border: `1px solid ${C.border}`, borderRadius: 10, padding: '10px 14px', color: C.text, fontFamily: 'inherit', fontSize: 15, outline: 'none' }}
                      />
                      <input
                        value={paymentMethod.cvc}
                        onChange={(e) => { const clean = e.target.value.replace(/\D/g, '').slice(0, 4); setPaymentMethod((p) => ({ ...p, cvc: clean })); setPaymentMethodError(''); setPaymentMethodInfo(''); }}
                        placeholder="CVC"
                        style={{ background: '#f1f5f9', border: `1px solid ${C.border}`, borderRadius: 10, padding: '10px 14px', color: C.text, fontFamily: 'inherit', fontSize: 15, outline: 'none' }}
                      />
                    </div>
                    <div style={{ marginTop: 10, display: 'flex', justifyContent: 'space-between', alignItems: 'center', gap: 12 }}>
                      <span style={{ fontSize: 14, color: C.muted }}>
                        {paymentMethod.cardNumber.replace(/\s/g, '').length >= 12 ? `Card ending in ${paymentMethod.cardNumber.replace(/\s/g, '').slice(-4)}` : 'No saved card yet'}
                      </span>
                      <button
                        type="button"
                        style={{ ...btnS(), padding: '8px 16px', fontSize: 14 }}
                        onClick={() => {
                          const cardDigits = paymentMethod.cardNumber.replace(/\s/g, '');
                          if (!paymentMethod.holder.trim() || cardDigits.length < 12 || !/^\d{2}\/\d{2}$/.test(paymentMethod.expiry) || paymentMethod.cvc.length < 3) {
                            setPaymentMethodError('Please enter a valid cardholder, card number, expiry, and CVC.');
                            setPaymentMethodInfo('');
                            return;
                          }
                          setPaymentMethodError('');
                          setPaymentMethodInfo(`Payment method saved •••• ${cardDigits.slice(-4)}`);
                        }}
                      >
                        Save payment method
                      </button>
                    </div>
                  </div>
                  <div style={{ fontSize: 15, color: C.muted, marginBottom: 14 }}>Upgrade your plan</div>
                  <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
                    {[{ id: 'PLUS', label: 'Plus', price: '$9.99/mo', features: ['All lessons', 'AI Text Tutor', 'Scenarios', 'Achievements'] }, { id: 'PREMIUM_MONTHLY', label: 'Premium', price: '$19.99/mo', features: ['Everything in Plus', 'AI Voice Tutor', 'Weak Spot Analysis', 'Priority support'] }].map(plan => (
                      <div key={plan.id} style={{ ...cardS, border: `1px solid ${C.border}` }}>
                        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                          <div><div style={{ fontSize: 18, fontWeight: 700, color: C.text }}>{plan.label}</div><div style={{ display: 'flex', gap: 8, flexWrap: 'wrap', marginTop: 8 }}>{plan.features.map(f => <span key={f} style={{ fontSize: 14, color: C.muted }}>✓ {f}</span>)}</div></div>
                          <div style={{ textAlign: 'right' }}><div style={{ fontSize: 22, fontWeight: 800, color: C.accentLight }}>{plan.price}</div><button style={{ ...btnS(), marginTop: 8, padding: '8px 16px', fontSize: 14 }} onClick={async () => { await fetch('/api/subscriptions/subscribe', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ userId: user?.id, plan: plan.id, autoRenew: true }) }); }}>Upgrade</button></div>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {/* ACCOUNT */}
              {path === '/dashboard/account' && (
                <div>
                  <h1 style={{ fontSize: 28, fontWeight: 800, marginBottom: 20, letterSpacing: '-0.5px' }}>Account</h1>
                  <div style={{ ...cardS }}>
                    <p style={{ color: C.muted, fontSize: 15, marginTop: 0 }}>View your account details and manage account actions.</p>
                    <div style={{ display: 'grid', gridTemplateColumns: '160px 1fr', rowGap: 8, columnGap: 10, marginTop: 12, fontSize: 16 }}>
                      <div style={{ color: C.muted }}>Name</div>
                      <div style={{ color: C.text, fontWeight: 600 }}>{user?.fullName || user?.username || '—'}</div>
                      <div style={{ color: C.muted }}>Email</div>
                      <div style={{ color: C.text, fontWeight: 600 }}>{user?.email || '—'}</div>
                    </div>

                    <div style={{ marginTop: 16, border: `1px solid ${C.red}44`, borderRadius: 12, background: `${C.red}08`, padding: 12 }}>
                      <h4 style={{ color: C.red, margin: 0, fontSize: 18 }}>Delete account</h4>
                      <p style={{ color: C.muted, fontSize: 15, marginTop: 4 }}>Permanently deletes your account and all data.</p>
                      {!showDeleteFlow ? (<button style={{ ...btnS('ghost'), marginTop: 10, color: C.red, border: `1px solid ${C.red}44` }} onClick={() => { setShowDeleteFlow(true); setDeleteError(''); setDeleteInfo(''); setDeletePassword(''); setDeletePasswordVerified(false); }}>Delete account</button>) : (
                        <form onSubmit={async e => {
                          e.preventDefault(); setDeleteError(''); setDeleteInfo('');
                          if (!deletePassword.trim()) { setDeleteError('Enter your password.'); return; }
                          if (!deletePasswordVerified) { setVerifyDeleteSubmitting(true); try { await verifyAccountPassword({ userId: user?.id, password: deletePassword }); setDeletePasswordVerified(true); setDeleteInfo('Password verified. Confirm deletion below.'); } catch (err) { setDeleteError(err.message || 'Could not verify.'); } finally { setVerifyDeleteSubmitting(false); } return; }
                          setDeleteSubmitting(true); try { await deleteMyAccount({ userId: user?.id, password: deletePassword }); clearStoredUser(); navigate('/login?accountDeleted=1', { replace: true }); } catch (err) { setDeleteError(err.message || 'Could not delete.'); } finally { setDeleteSubmitting(false); }
                        }} style={{ marginTop: 12, display: 'grid', gap: 10 }}>
                          {deleteInfo && <p style={{ color: C.green, fontSize: 15 }}>{deleteInfo}</p>}
                          {deleteError && <p style={{ color: C.red, fontSize: 15 }}>{deleteError}</p>}
                          <input type="password" value={deletePassword} onChange={e => { setDeletePassword(e.target.value); setDeletePasswordVerified(false); setDeleteInfo(''); }} placeholder="Enter your password" style={{ background: '#f1f5f9', border: `1px solid ${C.border}`, borderRadius: 10, padding: '10px 14px', color: C.text, fontFamily: 'inherit', fontSize: 15, outline: 'none' }} />
                          <div style={{ display: 'flex', gap: 8 }}>
                            {!deletePasswordVerified ? <button type="submit" style={{ ...btnS('ghost'), color: C.red, border: `1px solid ${C.red}44` }} disabled={verifyDeleteSubmitting}>{verifyDeleteSubmitting ? 'Verifying…' : 'Verify password'}</button> : <button type="submit" style={{ ...btnS('ghost'), color: C.red, border: `1px solid ${C.red}44` }} disabled={deleteSubmitting}>{deleteSubmitting ? 'Deleting…' : 'Confirm delete'}</button>}
                            <button type="button" style={btnS('ghost')} onClick={() => { setShowDeleteFlow(false); setDeletePassword(''); setDeleteError(''); setDeleteInfo(''); }}>Cancel</button>
                          </div>
                        </form>
                      )}
                    </div>
                  </div>
                </div>
              )}

              {/* LEVEL ADJUST */}
              {path === '/dashboard/retake-placement' && (
                <div>
                  <h1 style={{ fontSize: 28, fontWeight: 800, marginBottom: 20, letterSpacing: '-0.5px' }}>Level Adjustment</h1>
                  <div style={cardS}>
                    <div style={{ fontSize: 16, color: C.muted, marginBottom: 8 }}>Your current level</div>
                    <div style={{ fontSize: 24, fontWeight: 700, color: C.accentLight, marginBottom: 16 }}>{fmtLevel(user?.assignedLevel || 'BEGINNER')}</div>
                    <div style={{ display: 'flex', gap: 12, alignItems: 'flex-start' }}>
                      <div style={{ flex: 1 }}><div style={{ fontSize: 15, fontWeight: 600, marginBottom: 6 }}>Placement Exam</div><div style={{ fontSize: 14, color: C.muted }}>Take a test to determine your current Spanish level and adjust your lesson content accordingly.</div></div>
                      <button onClick={() => setRetakeConfirm(true)} style={btnS()}>Retake</button>
                    </div>
                  </div>
                  {retakeConfirm && (
                    <div style={{ ...cardS, marginTop: 16, background: `${C.yellow}11`, border: `1px solid ${C.yellow}44` }}>
                      <div style={{ fontSize: 16, fontWeight: 700, color: C.yellow, marginBottom: 8 }}>⚠️ Caution</div>
                      <div style={{ fontSize: 15, color: C.muted, marginBottom: 14 }}>Retaking the Placement Test and being assigned a new level will change your content level as well. Your progress will be adjusted.</div>
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
      <div style={{ position: 'fixed', right: 22, bottom: 22, zIndex: 1200 }}>
        {chatOpen ? (
          <div style={{ width: 340, height: 460, background: C.card, border: `1px solid ${C.border}`, borderRadius: 16, boxShadow: '0 18px 38px rgba(15, 23, 42, 0.22)', display: 'flex', flexDirection: 'column', overflow: 'hidden' }}>
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '10px 12px', borderBottom: `1px solid ${C.border}`, background: '#f4fbf8' }}>
              <div
                style={{
                  fontSize: 14,
                  fontWeight: 700,
                  background: 'linear-gradient(90deg, #8b5cf6, #3b82f6)',
                  WebkitBackgroundClip: 'text',
                  backgroundClip: 'text',
                  color: 'transparent',
                }}
              >
                💬 Florencia
              </div>
              <button type="button" onClick={() => setChatOpen(false)} style={{ border: 'none', background: 'transparent', color: C.muted, cursor: 'pointer', fontSize: 18, lineHeight: 1 }}>×</button>
            </div>
            <div ref={setBotChatScrollEl} style={{ flex: 1, overflowY: 'auto', display: 'flex', flexDirection: 'column', gap: 10, padding: 12 }}>
              {botMessages.map((m, i) => (
                <div key={i} style={{ alignSelf: m.role === 'user' ? 'flex-end' : 'flex-start', background: m.role === 'user' ? C.accent : '#e2e8f0', color: m.role === 'user' ? '#fff' : C.text, padding: '10px 12px', borderRadius: 12, maxWidth: '82%', fontSize: 13.5 }}>{m.content}</div>
              ))}
              <div ref={botChatEndRef} />
            </div>
            <div style={{ display: 'flex', gap: 8, borderTop: `1px solid ${C.border}`, padding: 10 }}>
              <input value={botInput} onChange={e => setBotInput(e.target.value)} onKeyDown={e => { if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); sendBotMessage(); } }} placeholder="Type your message..." style={{ flex: 1, background: '#f1f5f9', border: `1px solid ${C.border}`, borderRadius: 10, padding: '10px 12px', color: C.text, fontSize: 14, fontFamily: 'inherit', outline: 'none' }} />
              <button style={{ ...btnS(), padding: '10px 12px', fontSize: 13 }} onClick={sendBotMessage}>Send</button>
            </div>
          </div>
        ) : (
          <button type="button" onClick={() => setChatOpen(true)} style={{ border: 'none', borderRadius: 999, width: 58, height: 58, cursor: 'pointer', background: 'linear-gradient(90deg, #8b5cf6 0%, #3b82f6 100%)', color: '#fff', fontSize: 26, boxShadow: '0 12px 24px rgba(124,58,237,0.3)' }} title="Open Florencia chat" aria-label="Open Florencia chat">
            🤖
          </button>
        )}
      </div>
    </>
  );
}