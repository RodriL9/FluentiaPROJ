import { useEffect, useMemo, useRef, useState } from 'react';
import { Link, useLocation, useNavigate } from 'react-router-dom';
import { getNextOnboardingRoute, getStoredUser } from '../api/auth';
import '../styles/mix-match-module.css';

const nav = [
  { section: 'Profile', items: [{ to: '/dashboard', label: 'Overview', icon: '🏠', matchExact: true }] },
  {
    section: 'Your learning',
    items: [
      { to: '/dashboard/topics', label: 'Topics', icon: '📚' },
      { to: '/dashboard/vocabulary', label: 'Vocabulary', icon: '🧩' },
      { to: '/dashboard/grammar', label: 'Grammar', icon: '📚' },
      { to: '/dashboard/listening', label: 'Listening', icon: '🎧' },
      { to: '/dashboard/conversation', label: 'Conversation', icon: '💬' },
      { to: '/dashboard/writing', label: 'Writing', icon: '✍️' },
      { to: '/dashboard/ai-conversation', label: 'AI Conversation', icon: '🤖' },
      { to: '/dashboard/weak-spots', label: 'Weak spots', icon: '📍' },
    ],
  },
  {
    section: 'Practice modules',
    items: [{ to: '/dashboard/mix-match', label: 'Mix & match', icon: '🔗' }],
  },
  {
    section: 'Account & System',
    items: [
      { to: '/dashboard/achievements', label: 'Achievement badges', icon: '🏆' },
      { to: '/dashboard/subscription', label: 'Subscription', icon: '🧾' },
      { to: '/dashboard/reminders', label: 'Daily reminders', icon: '⏰' },
      { to: '/dashboard/level-adjustments', label: 'Level adjustments', icon: '🎯' },
      { to: '/dashboard/retake-placement', label: 'Retake placement', icon: '📝' },
    ],
  },
];

function navItemActive(pathname, item) {
  if (item.matchExact) return pathname === item.to || pathname === `${item.to}/`;
  return pathname === item.to || pathname.startsWith(`${item.to}/`);
}

function formatLevel(value) {
  return String(value || '')
    .toLowerCase()
    .replaceAll('_', ' ')
    .replace(/\b\w/g, (m) => m.toUpperCase());
}

function formatLanguage(code) {
  const map = { es: 'Spanish', en: 'English', fr: 'French', pt: 'Portuguese', it: 'Italian', de: 'German' };
  return map[String(code || '').toLowerCase()] || String(code || '').toUpperCase();
}

function parseTopicsCsv(csv) {
  return String(csv || '')
    .split(',')
    .map((s) => s.trim())
    .filter(Boolean);
}

function formatTopicLabel(raw) {
  return String(raw || '')
    .replaceAll('_', ' ')
    .toLowerCase()
    .replace(/\b\w/g, (m) => m.toUpperCase());
}

/** Show API values in the UI without underscores; keeps longer phrases readable. */
function choiceDisplayText(raw) {
  return String(raw ?? '').replaceAll('_', ' ').trim();
}

function stripUnderscoresOnly(raw) {
  return String(raw ?? '').replaceAll('_', ' ');
}

function troubleItemSummary(t) {
  if (t.detail_word) return `${choiceDisplayText(t.detail_word)} → ${choiceDisplayText(t.detail_translation || '')}`;
  if (t.detail_phrase) return `${choiceDisplayText(t.detail_phrase)} → ${choiceDisplayText(t.detail_phrase_translation || '')}`;
  if (t.detail_grammar_title) return stripUnderscoresOnly(t.detail_grammar_title);
  if (t.detail_template_title) return stripUnderscoresOnly(t.detail_template_title);
  if (t.detail_reading_title) return stripUnderscoresOnly(t.detail_reading_title);
  if (t.label_snapshot) return stripUnderscoresOnly(t.label_snapshot);
  if (t.topic_tag) return formatTopicLabel(t.topic_tag);
  return 'Practice item';
}

function topicIconFromCatalog(catalog, code) {
  const row = (catalog || []).find((t) => (t.code || '').toUpperCase() === String(code || '').toUpperCase());
  const icon = row?.icon != null ? String(row.icon).trim() : '';
  return icon || '📚';
}

function tutorWelcomeMessage(learningLanguage) {
  const lang = String(learningLanguage || 'es').toLowerCase();
  if (lang.startsWith('en')) {
    return "Hi! I'm your English tutor—ask me anything you want to learn.";
  }
  return "Hi! I'm your Spanish tutor—ask me anything you want to learn.";
}

function parseThresholdLevels(thresholds) {
  if (!thresholds) return [];
  try {
    const raw = typeof thresholds === 'string' ? JSON.parse(thresholds) : thresholds;
    const levels = Array.isArray(raw?.levels) ? raw.levels : [];
    return levels.map((v) => Number(v)).filter((v) => Number.isFinite(v) && v > 0);
  } catch {
    return [];
  }
}

function jsonPreview(item) {
  return JSON.stringify(item, null, 2);
}

function truncateText(value, max = 180) {
  const s = String(value || '').trim();
  if (s.length <= max) return s;
  return `${s.slice(0, max)}...`;
}

function shuffleArray(arr) {
  const a = [...arr];
  for (let i = a.length - 1; i > 0; i -= 1) {
    const j = Math.floor(Math.random() * (i + 1));
    [a[i], a[j]] = [a[j], a[i]];
  }
  return a;
}

/** One vocabulary entry for mix & match: `word` (L2) ↔ `translation` (same row from /api/vocabulary). */
function vocabularyMixMatchFields(row) {
  if (!row || typeof row !== 'object') return null;
  const word = String(row.word ?? '').trim();
  const translation = String(row.translation ?? '').trim();
  if (!word || !translation) return null;
  return {
    contentId: row.id != null ? row.id : null,
    word: row.word,
    translation: row.translation,
    topic_tag: row.topic_tag ?? row.topicTag ?? '',
  };
}

function pickDistractor(items, currentValue, field) {
  const vals = (items || [])
    .map((x) => String(x?.[field] || '').trim())
    .filter((x) => x && x !== String(currentValue || '').trim());
  if (!vals.length) return 'Not sure';
  return vals[Math.floor(Math.random() * vals.length)];
}

function levelRank(raw) {
  const v = String(raw || '').toUpperCase();
  if (v.includes('BEGINNER')) return 1;
  if (v.includes('ELEMENTARY')) return 2;
  if (v.includes('INTERMEDIATE') && !v.includes('UPPER')) return 3;
  if (v.includes('UPPER_INTERMEDIATE')) return 4;
  if (v.includes('ADVANCED')) return 5;
  return 3;
}

export default function DashboardPage() {
  const navigate = useNavigate();
  const { pathname } = useLocation();
  const user = useMemo(() => getStoredUser(), [pathname]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [skillLive, setSkillLive] = useState(null);
  const [items, setItems] = useState([]);
  const [topicsData, setTopicsData] = useState([]);
  const [topicsCatalog, setTopicsCatalog] = useState([]);
  const [xp, setXp] = useState(0);
  const [streak, setStreak] = useState(1);
  const [completedKeys, setCompletedKeys] = useState({});
  const [sectionProgress, setSectionProgress] = useState({
    vocabulary: 0,
    grammar: 0,
    listening: 0,
    conversation: 0,
    writing: 0,
    topics: 0,
    mixMatch: 0,
  });
  const [activeTopicCode, setActiveTopicCode] = useState('');
  const [activeTopicView, setActiveTopicView] = useState('vocabulary');
  const [flashcardIndex, setFlashcardIndex] = useState(0);
  const [flippedCards, setFlippedCards] = useState({});
  const [checkFeedback, setCheckFeedback] = useState({});
  const [sectionChecks, setSectionChecks] = useState({
    vocabulary: { total: 0, correct: 0, finished: false },
    grammar: { total: 0, correct: 0, finished: false },
    listening: { total: 0, correct: 0, finished: false },
    conversation: { total: 0, correct: 0, finished: false },
    writing: { total: 0, correct: 0, finished: false },
  });
  const [sectionQuiz, setSectionQuiz] = useState({
    section: '',
    index: 0,
    correct: 0,
    questions: [],
    done: false,
  });
  const [quizDifficulty, setQuizDifficulty] = useState('');
  const [aiInput, setAiInput] = useState('');
  const [aiFeedback, setAiFeedback] = useState(null);
  const [chatMessages, setChatMessages] = useState(() => [
    { role: 'assistant', content: tutorWelcomeMessage(getStoredUser()?.learningLanguage) },
  ]);
  const [chatScrollEl, setChatScrollEl] = useState(null);
  const [mixMatchRound, setMixMatchRound] = useState(0);
  const [mixMatchState, setMixMatchState] = useState(null);
  const [mixMatchFeedback, setMixMatchFeedback] = useState(null);
  const [mixMatchWrongIds, setMixMatchWrongIds] = useState(null);
  const mixMatchItemsRef = useRef(null);
  const mixMatchPoolRef = useRef([]);

  const sendAiMessage = async () => {
    const userMessage = aiInput.trim();
    if (!userMessage) return;
    setChatMessages((prev) => [...prev, { role: 'user', content: userMessage }]);
    const res = await fetch('/api/ai/conversation/feedback', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        userId: user?.id,
        language: user?.learningLanguage || 'es',
        userMessage,
      }),
    });
    if (!res.ok) {
      setChatMessages((prev) => [
        ...prev,
        { role: 'assistant', content: 'I could not respond right now. Please try again.' },
      ]);
      return;
    }
    const data = await res.json();
    setAiFeedback(data);
    setChatMessages((prev) => [...prev, { role: 'assistant', content: data.assistantReply || '' }]);
    setAiInput('');
    recordPracticeAttempt({
      section: 'conversation',
      correct: true,
      source: 'ai_conversation_practice',
      topicTag: '',
    });
  };

  useEffect(() => {
    const next = getNextOnboardingRoute(user);
    if (next !== '/dashboard') {
      navigate(next, { replace: true });
    }
  }, [navigate, user]);

  useEffect(() => {
    if (!user?.id) return;
    const language = encodeURIComponent(user.learningLanguage || 'es');
    let cancelled = false;
    fetch(`/api/topics?language=${language}`)
      .then((res) => (res.ok ? res.json() : []))
      .then((data) => {
        if (!cancelled) setTopicsCatalog(Array.isArray(data) ? data : []);
      })
      .catch(() => {
        if (!cancelled) setTopicsCatalog([]);
      });
    return () => {
      cancelled = true;
    };
  }, [user?.id, user?.learningLanguage]);

  useEffect(() => {
    if (!user?.id) return;
    const language = encodeURIComponent(user.learningLanguage || 'es');
    fetch(`/api/skills/breakdown-live?userId=${encodeURIComponent(user.id)}&language=${language}`)
      .then((res) => (res.ok ? res.json() : null))
      .then((data) => {
        if (data) setSkillLive(data);
      })
      .catch(() => {
        // Keep dashboard resilient if this widget fails.
      });
  }, [user]);
  const displayName = user?.fullName || user?.username || 'Learner';
  const initials = displayName
    .split(' ')
    .map((w) => w[0])
    .join('')
    .slice(0, 2)
    .toUpperCase();
  const selectedTopics = useMemo(() => parseTopicsCsv(user?.learningGoals), [user?.learningGoals]);
  const levelLabel = formatLevel(user?.assignedLevel || 'BEGINNER');
  const languageLabel = formatLanguage(user?.learningLanguage || 'es');
  const activeTopic = useMemo(
    () => topicsData.find((t) => t.code === activeTopicCode) || null,
    [topicsData, activeTopicCode],
  );
  const activeWords = activeTopic?.vocabulary || [];
  const activePhrases = activeTopic?.phrases || [];
  const activeUnits = activeTopic?.units || [];
  const levelGoalXp = (String(user?.assignedLevel || 'BEGINNER').toUpperCase() === 'BEGINNER' ? 120 : 200);
  const xpPct = Math.min(100, Math.round((xp / levelGoalXp) * 100));

  const sectionKeyFromPath = (p) =>
    ({
      '/dashboard/vocabulary': 'vocabulary',
      '/dashboard/grammar': 'grammar',
      '/dashboard/listening': 'listening',
      '/dashboard/conversation': 'conversation',
      '/dashboard/writing': 'writing',
      '/dashboard/mix-match': 'mixMatch',
      '/dashboard/topics': 'topics',
    })[p] || null;

  const award = (amount, sectionKey, completionKey) => {
    if (completionKey && completedKeys[completionKey]) return;
    setXp((v) => v + amount);
    if (completionKey) {
      setCompletedKeys((prev) => ({ ...prev, [completionKey]: true }));
    }
    if (sectionKey) {
      setSectionProgress((prev) => ({
        ...prev,
        [sectionKey]: Math.min(100, (prev[sectionKey] || 0) + Math.max(6, Math.round(amount / 2))),
      }));
    }
  };

  const recordPracticeAttempt = async ({
    section,
    correct = true,
    source = '',
    topicTag = '',
    contentId = null,
    contentKind = '',
    labelSnapshot = '',
  }) => {
    if (!user?.id) return;
    try {
      const body = {
        userId: user.id,
        language: user.learningLanguage || 'es',
        section,
        correct,
        source,
        topicTag,
      };
      if (contentId) body.contentId = contentId;
      if (contentKind) body.contentKind = contentKind;
      if (labelSnapshot) body.labelSnapshot = labelSnapshot;
      const res = await fetch('/api/practice/attempt', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(body),
      });
      if (!res.ok) return;
      const data = await res.json();
      setSkillLive((prev) => ({
        ...(prev || {}),
        skills: data.skills || prev?.skills,
        lessonMix: data.lessonMix || prev?.lessonMix,
        milestone: data.milestone || prev?.milestone,
      }));
    } catch {
      // Keep UX responsive even if tracking call fails.
    }
  };

  const submitKnowledgeCheck = ({
    section,
    key,
    correct,
    source,
    topicTag = '',
    contentId = null,
    contentKind = '',
    labelSnapshot = '',
  }) => {
    setCheckFeedback((prev) => ({ ...prev, [key]: correct ? 'correct' : 'wrong' }));
    setSectionChecks((prev) => ({
      ...prev,
      [section]: {
        ...prev[section],
        total: (prev[section]?.total || 0) + 1,
        correct: (prev[section]?.correct || 0) + (correct ? 1 : 0),
      },
    }));
    award(correct ? 8 : 2, section, `check-${key}-${correct ? 'c' : 'w'}`);
    recordPracticeAttempt({
      section,
      correct,
      source,
      topicTag,
      contentId,
      contentKind,
      labelSnapshot,
    });
  };

  const finishSectionCheckpoint = (section) => {
    const stats = sectionChecks[section] || { total: 0, correct: 0 };
    const pct = stats.total > 0 ? Math.round((stats.correct / stats.total) * 100) : 0;
    const passed = pct >= 70;
    if (passed) {
      award(25, section, `section-pass-${section}`);
      recordPracticeAttempt({ section, correct: true, source: 'section_checkpoint_pass' });
    } else {
      recordPracticeAttempt({ section, correct: false, source: 'section_checkpoint_fail' });
    }
    setSectionChecks((prev) => ({ ...prev, [section]: { ...prev[section], finished: true } }));
  };

  const getSectionScore = (section) => {
    const s = skillLive?.skills || {};
    if (section === 'vocabulary') return Number(s.vocabulary_score ?? 50);
    if (section === 'grammar') return Number(s.grammar_score ?? 50);
    if (section === 'listening') return Number(s.listening_score ?? 50);
    if (section === 'writing') return Number(s.writing_score ?? 50);
    if (section === 'conversation') return Number(s.speaking_score ?? 50);
    return 50;
  };

  const adaptiveQuestionsForSection = (section, sourceItems) => {
    const rows = Array.isArray(sourceItems) ? sourceItems : [];
    const score = getSectionScore(section);
    let band = 'medium';
    if (score < 60) band = 'easy';
    else if (score >= 80) band = 'hard';

    const filtered = rows.filter((row) => {
      const rank = levelRank(row?.level);
      const freq = Number(row?.frequency_rank ?? 9999);
      if (band === 'easy') {
        if (section === 'vocabulary') return rank <= 2 || freq <= 250;
        return rank <= 2;
      }
      if (band === 'hard') {
        if (section === 'vocabulary') return rank >= 3 || freq >= 300;
        return rank >= 3;
      }
      return rank >= 2 && rank <= 4;
    });

    const pool = (filtered.length >= 5 ? filtered : rows).slice(0, 20);
    return { band, pool };
  };

  const startSectionQuiz = (section, sourceItems) => {
    const { band, pool } = adaptiveQuestionsForSection(section, sourceItems);
    const pick = pool.slice(0, Math.min(5, pool.length));
    const questions = pick.map((row, idx) => {
      if (section === 'vocabulary') {
        const right = String(row.translation || '');
        const wrong = pickDistractor(pool, right, 'translation');
        return {
          prompt: `What is "${choiceDisplayText(row.word)}"?`,
          options: [right, wrong].sort(() => Math.random() - 0.5),
          correct: right,
          topicTag: row.topic_tag || '',
          source: `vocabulary_section_quiz_q${idx + 1}`,
          contentId: row.id,
          contentKind: 'VOCABULARY',
          labelSnapshot: row.word || '',
        };
      }
      if (section === 'grammar') {
        const right = String(row.category || 'Grammar');
        const wrong = right === 'Grammar' ? 'Vocabulary' : 'Grammar';
        return {
          prompt: `This rule belongs to which area? (${stripUnderscoresOnly(row.title) || formatTopicLabel(row.code || 'rule')})`,
          options: [right, wrong].sort(() => Math.random() - 0.5),
          correct: right,
          topicTag: '',
          source: `grammar_section_quiz_q${idx + 1}`,
          contentId: row.id,
          contentKind: 'GRAMMAR',
          labelSnapshot: row.title || row.code || '',
        };
      }
      if (section === 'listening') {
        const right = String(row.translation || '');
        const wrong = pickDistractor(pool, right, 'translation');
        return {
          prompt: `What does "${choiceDisplayText(row.phrase)}" mean?`,
          options: [right, wrong].sort(() => Math.random() - 0.5),
          correct: right,
          topicTag: row.topic_tag || '',
          source: `listening_section_quiz_q${idx + 1}`,
          contentId: row.id,
          contentKind: 'PHRASE',
          labelSnapshot: row.phrase || '',
        };
      }
      if (section === 'conversation') {
        const right = String(row.topic_tag || 'General');
        const wrong = right === 'General' ? 'Travel' : 'General';
        return {
          prompt: `Main theme of this conversation: "${stripUnderscoresOnly(row.title) || formatTopicLabel('template')}"`,
          options: [right, wrong].sort(() => Math.random() - 0.5),
          correct: right,
          topicTag: row.topic_tag || '',
          source: `conversation_section_quiz_q${idx + 1}`,
          contentId: row.id,
          contentKind: 'TEMPLATE',
          labelSnapshot: row.title || '',
        };
      }
      const right = formatLevel(row.level || levelLabel);
      const wrong = right === 'Beginner' ? 'Advanced' : 'Beginner';
      return {
        prompt: `Level of passage "${stripUnderscoresOnly(row.title) || formatTopicLabel('passage')}"?`,
        options: [right, wrong].sort(() => Math.random() - 0.5),
        correct: right,
        topicTag: row.topic_tag || '',
        source: `writing_section_quiz_q${idx + 1}`,
        contentId: row.id,
        contentKind: 'READING',
        labelSnapshot: row.title || '',
      };
    });
    setSectionQuiz({
      section,
      index: 0,
      correct: 0,
      questions,
      done: false,
    });
    setQuizDifficulty(band);
  };

  const answerSectionQuiz = (picked) => {
    const q = sectionQuiz.questions[sectionQuiz.index];
    if (!q) return;
    const correct = picked === q.correct;
    recordPracticeAttempt({
      section: sectionQuiz.section,
      correct,
      source: q.source,
      topicTag: q.topicTag || '',
      contentId: q.contentId || null,
      contentKind: q.contentKind || '',
      labelSnapshot: q.labelSnapshot || '',
    });
    const nextIndex = sectionQuiz.index + 1;
    const nextCorrect = sectionQuiz.correct + (correct ? 1 : 0);
    if (nextIndex >= sectionQuiz.questions.length) {
      const pct = sectionQuiz.questions.length
        ? Math.round((nextCorrect / sectionQuiz.questions.length) * 100)
        : 0;
      const passed = pct >= 70;
      if (passed) {
        award(35, sectionQuiz.section, `section-quiz-pass-${sectionQuiz.section}`);
      }
      setSectionQuiz((prev) => ({
        ...prev,
        index: nextIndex,
        correct: nextCorrect,
        done: true,
      }));
      setSectionChecks((prev) => ({
        ...prev,
        [sectionQuiz.section]: {
          ...prev[sectionQuiz.section],
          total: (prev[sectionQuiz.section]?.total || 0) + sectionQuiz.questions.length,
          correct: (prev[sectionQuiz.section]?.correct || 0) + nextCorrect,
          finished: true,
        },
      }));
      return;
    }
    setSectionQuiz((prev) => ({
      ...prev,
      index: nextIndex,
      correct: nextCorrect,
    }));
  };

  useEffect(() => {
    if (!user) return;
    const path = pathname.replace(/\/+$/, '');
    const simple = {
      '/dashboard/vocabulary': '/api/vocabulary',
      '/dashboard/mix-match': '/api/vocabulary',
      '/dashboard/grammar': '/api/grammar',
      '/dashboard/listening': '/api/phrases',
      '/dashboard/conversation': '/api/ai/templates',
      '/dashboard/writing': '/api/reading',
      '/dashboard/achievements': '/api/achievements/me',
      '/dashboard/subscription': '/api/subscriptions/me',
      '/dashboard/reminders': '/api/notifications',
      '/dashboard/level-adjustments': '/api/me/level-history',
      '/dashboard/weak-spots': '/api/practice/troubles',
    };
    const endpoint = simple[path];
    if (!endpoint) {
      setItems([]);
      setTopicsData([]);
      setError('');
      setLoading(false);
      return;
    }
    let cancelled = false;
    setLoading(true);
    setError('');
    const language = encodeURIComponent(user.learningLanguage || 'es');
    const vocabUrl = (applyTopicFilter) =>
      `${endpoint}?language=${language}&userId=${encodeURIComponent(user.id)}&applyTopicFilter=${applyTopicFilter}`;
    const primaryUrl =
      path === '/dashboard/vocabulary'
        ? vocabUrl(false)
        : path === '/dashboard/mix-match'
          ? vocabUrl(true)
          : `${endpoint}?userId=${encodeURIComponent(user.id)}&language=${language}`;
    const supportsLanguageFallback = [
      '/dashboard/vocabulary',
      '/dashboard/mix-match',
      '/dashboard/grammar',
      '/dashboard/listening',
      '/dashboard/conversation',
      '/dashboard/writing',
    ].includes(path);
    fetch(primaryUrl)
      .then(async (res) => {
        if (!res.ok) throw new Error((await res.text()) || 'Failed loading data');
        return res.json();
      })
      .then((data) => {
        if (cancelled) return;
        let rows = Array.isArray(data) ? data : [];
        if (rows.length > 0) {
          setItems(rows);
          return;
        }
        if (path === '/dashboard/mix-match') {
          // Widen to full vocabulary list (same words/translations fields), then language-only.
          return fetch(vocabUrl(false))
            .then(async (res) => {
              if (!res.ok) throw new Error((await res.text()) || 'Failed loading data');
              return res.json();
            })
            .then((data2) => {
              if (cancelled) return;
              rows = Array.isArray(data2) ? data2 : [];
              if (rows.length > 0) {
                setItems(rows);
                return;
              }
              if (!supportsLanguageFallback) {
                setItems(rows);
                return;
              }
              return fetch(`${endpoint}?language=${language}`)
                .then(async (res) => {
                  if (!res.ok) throw new Error((await res.text()) || 'Failed loading data');
                  return res.json();
                })
                .then((fallbackData) => {
                  if (cancelled) return;
                  setItems(Array.isArray(fallbackData) ? fallbackData : []);
                });
            });
        }
        if (!supportsLanguageFallback) {
          setItems(rows);
          return;
        }
        // Fallback only for learning-content endpoints.
        return fetch(`${endpoint}?language=${language}`)
          .then(async (res) => {
            if (!res.ok) throw new Error((await res.text()) || 'Failed loading data');
            return res.json();
          })
          .then((fallbackData) => {
            if (cancelled) return;
            setItems(Array.isArray(fallbackData) ? fallbackData : []);
          });
      })
      .catch((err) => {
        if (!cancelled) setError(err.message || 'Could not load data.');
      })
      .finally(() => {
        if (!cancelled) setLoading(false);
      });
    return () => {
      cancelled = true;
    };
  }, [pathname, user]);

  useEffect(() => {
    if (!user || pathname.replace(/\/+$/, '') !== '/dashboard/topics') return;
    let cancelled = false;
    setLoading(true);
    setError('');
    const lang = encodeURIComponent(user.learningLanguage || 'es');
    (async () => {
      try {
        const topicRes = await fetch(`/api/topics?language=${lang}`);
        if (!topicRes.ok) throw new Error('Could not load topics.');
        const allTopics = await topicRes.json();
        const list = Array.isArray(allTopics) ? allTopics : [];

        const rows = await Promise.all(
          selectedTopics.map(async (code) => {
            const topic = list.find((t) => (t.code || '').toUpperCase() === code.toUpperCase());
            const iconFallback = topicIconFromCatalog(list, code);
            if (!topic?.id) {
              return {
                code,
                icon: iconFallback,
                title: formatTopicLabel(code),
                vocabulary: [],
                phrases: [],
                units: [],
              };
            }
            const contentRes = await fetch(`/api/topics/${topic.id}/content`);
            if (!contentRes.ok) throw new Error('Could not load topic content.');
            const content = await contentRes.json();
            const iconRaw = topic.icon != null ? String(topic.icon).trim() : '';
            return {
              code,
              icon: iconRaw || iconFallback,
              title: formatTopicLabel(topic.name || topic.code || code),
              vocabulary: Array.isArray(content.vocabulary) ? content.vocabulary : [],
              phrases: Array.isArray(content.phrases) ? content.phrases : [],
              units: Array.isArray(content.units) ? content.units : [],
            };
          }),
        );
        if (cancelled) return;
        setTopicsData(rows);
        const firstCode = rows?.[0]?.code || '';
        setActiveTopicCode((prev) => (prev && rows.some((r) => r.code === prev) ? prev : firstCode));
        setActiveTopicView('vocabulary');
        setFlashcardIndex(0);
        setFlippedCards({});
      } catch (err) {
        if (!cancelled) setError(err.message || 'Could not load topic data.');
      } finally {
        if (!cancelled) setLoading(false);
      }
    })();
    return () => {
      cancelled = true;
    };
  }, [pathname, selectedTopics, user]);

  const speakWord = (word, fallbackAudioText) => {
    if (typeof window === 'undefined' || !window.speechSynthesis) return;
    const spoken = String(fallbackAudioText || word || '').trim();
    if (!spoken) return;
    window.speechSynthesis.cancel();
    const utter = new SpeechSynthesisUtterance(spoken);
    utter.lang = String(user?.learningLanguage || 'es').toLowerCase() === 'es' ? 'es-ES' : 'en-US';
    utter.rate = 0.95;
    window.speechSynthesis.speak(utter);
  };

  const path = pathname.replace(/\/+$/, '');
  const pageTitle = {
    '/dashboard/vocabulary': 'Vocabulary',
    '/dashboard/grammar': 'Grammar',
    '/dashboard/listening': 'Listening',
    '/dashboard/conversation': 'Conversation',
    '/dashboard/writing': 'Writing',
    '/dashboard/ai-conversation': 'AI Conversation',
    '/dashboard/achievements': 'Achievement Badges',
    '/dashboard/subscription': 'Subscription Management',
    '/dashboard/reminders': 'Daily Reminders',
    '/dashboard/level-adjustments': 'User Level Adjustments',
    '/dashboard/retake-placement': 'Retake Placement Test',
    '/dashboard/topics': 'Your Topics',
    '/dashboard/weak-spots': 'Weak spots — need more practice',
    '/dashboard/mix-match': 'Mix & match',
  }[path];

  const mixMatchProgressPct = useMemo(() => {
    if (!mixMatchState?.pairs?.length || mixMatchState.tooFew) return 0;
    const n = mixMatchState.pairs.length;
    const d = Object.keys(mixMatchState.matched || {}).length;
    return Math.min(100, Math.round((d / n) * 100));
  }, [mixMatchState]);

  useEffect(() => {
    if (!chatScrollEl) return;
    chatScrollEl.scrollTop = chatScrollEl.scrollHeight;
  }, [chatMessages, chatScrollEl]);

  useEffect(() => {
    if (path !== '/dashboard/mix-match') {
      setMixMatchState(null);
      return;
    }
    const normalized = (items || []).map(vocabularyMixMatchFields).filter(Boolean);
    const cap = 5;
    if (normalized.length < 3) {
      mixMatchPoolRef.current = [];
      mixMatchItemsRef.current = null;
      setMixMatchState({
        pairs: [],
        leftOrder: [],
        rightOrder: [],
        matched: {},
        pick: null,
        tooFew: true,
      });
      return;
    }

    if (mixMatchItemsRef.current !== items) {
      mixMatchItemsRef.current = items;
      mixMatchPoolRef.current = shuffleArray(normalized);
    }

    let pool = mixMatchPoolRef.current;
    if (pool.length !== normalized.length) {
      mixMatchPoolRef.current = shuffleArray(normalized);
      pool = mixMatchPoolRef.current;
    }

    const chunkCount = Math.max(1, Math.ceil(pool.length / cap));
    const chunkIdx = mixMatchRound % chunkCount;
    if (chunkIdx === 0 && mixMatchRound > 0) {
      mixMatchPoolRef.current = shuffleArray(normalized);
      pool = mixMatchPoolRef.current;
    }
    const start = chunkIdx * cap;
    let picked = pool.slice(start, Math.min(start + cap, pool.length));

    if (picked.length < 3) {
      mixMatchPoolRef.current = shuffleArray(normalized);
      pool = mixMatchPoolRef.current;
      picked = pool.slice(0, Math.min(cap, pool.length));
    }

    const pairs = picked.map((w) => ({
      id: String(w.contentId != null ? w.contentId : `${w.word}-${w.topic_tag || 'x'}`),
      contentId: w.contentId ?? null,
      word: w.word,
      translation: w.translation,
      topic_tag: w.topic_tag || '',
    }));
    const ids = pairs.map((p) => p.id);
    setMixMatchState({
      pairs,
      leftOrder: shuffleArray(ids),
      rightOrder: shuffleArray(ids),
      matched: {},
      pick: null,
      tooFew: false,
    });
  }, [path, items, mixMatchRound]);

  useEffect(() => {
    setMixMatchFeedback(null);
    setMixMatchWrongIds(null);
  }, [mixMatchRound, path]);

  useEffect(() => {
    if (!mixMatchState || mixMatchState.tooFew || !mixMatchState.pairs?.length) return;
    const n = mixMatchState.pairs.length;
    const done = Object.keys(mixMatchState.matched || {}).length;
    if (done !== n) return;
    award(20, 'mixMatch', `mix-match-round-done-${mixMatchRound}`);
  }, [mixMatchState, mixMatchRound]);

  const handleMixMatchTap = (side, vocabId) => {
    setMixMatchState((prev) => {
      if (!prev || prev.tooFew || !prev.pairs?.length) return prev;
      if (prev.matched[vocabId]) return prev;
      if (!prev.pick) {
        return { ...prev, pick: { side, vocabId } };
      }
      if (prev.pick.side === side) {
        return { ...prev, pick: { side, vocabId } };
      }
      const a = prev.pick.vocabId;
      const b = vocabId;
      const pairA = prev.pairs.find((p) => p.id === a);
      if (a === b) {
        queueMicrotask(() => {
          award(8, 'mixMatch', null);
          recordPracticeAttempt({
            section: 'vocabulary',
            correct: true,
            source: 'mix_match_pair',
            topicTag: pairA?.topic_tag || '',
            contentId: pairA?.contentId ?? null,
            contentKind: 'VOCABULARY',
            labelSnapshot: String(pairA?.word || ''),
          });
          setMixMatchFeedback({ kind: 'correct', text: 'Nice match!' });
          window.setTimeout(() => setMixMatchFeedback(null), 2000);
        });
        return {
          ...prev,
          matched: { ...prev.matched, [a]: true },
          pick: null,
        };
      }
      const firstPair = prev.pairs.find((p) => p.id === a);
      queueMicrotask(() => {
        award(2, 'mixMatch', null);
        recordPracticeAttempt({
          section: 'vocabulary',
          correct: false,
          source: 'mix_match_mismatch',
          topicTag: firstPair?.topic_tag || '',
          contentId: firstPair?.contentId ?? null,
          contentKind: 'VOCABULARY',
          labelSnapshot: String(firstPair?.word || ''),
        });
        setMixMatchWrongIds([a, b]);
        setMixMatchFeedback({ kind: 'wrong', text: 'Not a pair — try again.' });
        window.setTimeout(() => setMixMatchWrongIds(null), 550);
        window.setTimeout(() => setMixMatchFeedback(null), 2400);
      });
      return { ...prev, pick: null };
    });
  };

  return (
    <div className="fl-dash">
      <aside className="fl-dash-sidebar">
        {nav.map((group) => (
          <div key={group.section}>
            <div className="fl-dash-nav-section">{group.section}</div>
            {group.items.map((item) => (
              <Link
                key={item.to}
                to={item.to}
                className={`fl-dash-nav-item${navItemActive(pathname, item) ? ' fl-active' : ''}`}
              >
                <span aria-hidden>{item.icon}</span>
                {item.label}
              </Link>
            ))}
          </div>
        ))}
        <div className="fl-dash-logout-wrap">
          <Link to="/" className="fl-dash-logout">
            <span aria-hidden>←</span>
            Log out
          </Link>
        </div>
      </aside>

      <main className="fl-dash-main">
        <header className="fl-dash-header">
          <div className="fl-dash-greet">
            <div className="fl-dash-greet-top">
              <div className="fl-avatar" aria-hidden>
                {initials}
              </div>
              <div className="fl-dash-greet-text">
                <h1>Welcome back, {displayName}!</h1>
                <div className="fl-dash-greet-row">
                  <span className="fl-badge fl-badge-beginner">{levelLabel}</span>
                  <span className="fl-badge fl-badge-lang">{languageLabel}</span>
                  <span className="fl-badge fl-badge-lang">XP {xp}</span>
                  <span className="fl-badge fl-badge-lang">Streak {streak}🔥</span>
                </div>
              </div>
            </div>
          </div>
        </header>

        {path !== '/dashboard/mix-match' ? (
          <div className="fl-continue-card" style={{ marginBottom: '0.9rem' }}>
            <div style={{ width: '100%' }}>
              <h3 style={{ margin: 0 }}>Daily Mission</h3>
              <p style={{ marginTop: '0.35rem' }}>
                Earn {levelGoalXp} XP today to lock your {levelLabel} momentum.
              </p>
              <div
                style={{
                  marginTop: '0.55rem',
                  width: '100%',
                  height: '10px',
                  borderRadius: '999px',
                  background: 'rgba(99,102,241,0.15)',
                  overflow: 'hidden',
                }}
              >
                <div
                  style={{
                    width: `${xpPct}%`,
                    height: '100%',
                    background: 'linear-gradient(90deg,#6366f1,#22c55e)',
                  }}
                />
              </div>
              <p className="fl-auth-sub" style={{ marginTop: '0.45rem' }}>
                {xp}/{levelGoalXp} XP
              </p>
            </div>
          </div>
        ) : null}

        {path === '/dashboard' && skillLive?.skills ? (
          <div className="fl-continue-card" style={{ marginBottom: '0.9rem' }}>
            <div style={{ width: '100%' }}>
              <h3 style={{ margin: 0 }}>Skill Breakdown</h3>
              <p className="fl-auth-sub" style={{ marginTop: '0.35rem' }}>
                Personalized lesson split based on weak areas.
              </p>
              <div style={{ marginTop: '0.55rem', display: 'grid', gap: '0.45rem' }}>
                <div>Vocabulary: {skillLive.skills.vocabulary_score ?? 50}</div>
                <div>Grammar: {skillLive.skills.grammar_score ?? 50}</div>
                <div>Listening: {skillLive.skills.listening_score ?? 50}</div>
                <div>Writing: {skillLive.skills.writing_score ?? 50}</div>
                <div>Speaking: {skillLive.skills.speaking_score ?? 50}</div>
              </div>
              {skillLive.lessonMix ? (
                <p style={{ marginTop: '0.6rem' }}>
                  Plan: Vocab {skillLive.lessonMix.vocabulary}% · Grammar {skillLive.lessonMix.grammar}% · Listening{' '}
                  {skillLive.lessonMix.listening}% · Writing {skillLive.lessonMix.writing}% · Conversation{' '}
                  {skillLive.lessonMix.conversation}% · Review {skillLive.lessonMix.review}%
                </p>
              ) : null}
            </div>
          </div>
        ) : null}

        {path === '/dashboard' ? (
          <>
            <h2 className="fl-section-title">Your chosen topics</h2>
            <div className="fl-pill-row">
              {selectedTopics.map((code) => (
                <span key={code} className="fl-pill">
                  <span aria-hidden>{topicIconFromCatalog(topicsCatalog, code)}</span>{' '}
                  {formatTopicLabel(code)}
                </span>
              ))}
            </div>

            <h2 className="fl-section-title">Choose what to study</h2>
            <div className="fl-browse-grid">
              <Link to="/dashboard/vocabulary" className="fl-browse-tile">
                <span>🧩</span>
                <span>Vocabulary</span>
                <span className="fl-auth-sub">{sectionProgress.vocabulary}%</span>
              </Link>
              <Link to="/dashboard/grammar" className="fl-browse-tile">
                <span>📚</span>
                <span>Grammar</span>
                <span className="fl-auth-sub">{sectionProgress.grammar}%</span>
              </Link>
              <Link to="/dashboard/listening" className="fl-browse-tile">
                <span>🎧</span>
                <span>Listening</span>
                <span className="fl-auth-sub">{sectionProgress.listening}%</span>
              </Link>
              <Link to="/dashboard/conversation" className="fl-browse-tile">
                <span>💬</span>
                <span>Conversation</span>
                <span className="fl-auth-sub">{sectionProgress.conversation}%</span>
              </Link>
              <Link to="/dashboard/writing" className="fl-browse-tile">
                <span>✍️</span>
                <span>Writing</span>
                <span className="fl-auth-sub">{sectionProgress.writing}%</span>
              </Link>
              <Link to="/dashboard/topics" className="fl-browse-tile">
                <span>{selectedTopics.length ? topicIconFromCatalog(topicsCatalog, selectedTopics[0]) : '📚'}</span>
                <span>Topics</span>
                <span className="fl-auth-sub">{sectionProgress.topics}%</span>
              </Link>
              <Link to="/dashboard/mix-match" className="fl-browse-tile">
                <span>🔗</span>
                <span>Mix & match</span>
                <span className="fl-auth-sub">{sectionProgress.mixMatch}%</span>
              </Link>
            </div>
          </>
        ) : (
          <>
            {path !== '/dashboard/mix-match' ? (
              <>
                <h2 className="fl-section-title">{pageTitle || 'Data'}</h2>
                <p className="fl-auth-sub" style={{ marginBottom: '0.75rem' }}>
                  Showing data for {languageLabel} at {levelLabel}.
                </p>
              </>
            ) : null}
            {error ? <p className="fl-auth-error">{error}</p> : null}
            {loading && path !== '/dashboard/mix-match' ? <p className="fl-auth-sub">Loading…</p> : null}
            {path === '/dashboard/topics' && !loading ? (
              <div style={{ display: 'grid', gap: '0.9rem' }}>
                <div className="fl-topic-grid">
                  {topicsData.map((t) => {
                    const active = activeTopicCode === t.code;
                    return (
                      <button
                        key={t.code}
                        type="button"
                        className={`fl-topic-card${active ? ' fl-topic-card-active' : ''}`}
                        onClick={() => {
                          setActiveTopicCode(t.code);
                          setActiveTopicView('vocabulary');
                          setFlashcardIndex(0);
                          setFlippedCards({});
                        }}
                      >
                        <div style={{ fontSize: '1.75rem', lineHeight: 1, marginBottom: '0.35rem' }} aria-hidden>
                          {t.icon || topicIconFromCatalog(topicsCatalog, t.code)}
                        </div>
                        <div className="fl-topic-card-title">{t.title}</div>
                        <div className="fl-topic-card-sub">{t.vocabulary.length} words</div>
                      </button>
                    );
                  })}
                </div>

                {activeTopic ? (
                  <div className="fl-continue-card">
                    <div style={{ width: '100%' }}>
                      <h3 style={{ display: 'flex', alignItems: 'center', gap: '0.45rem', flexWrap: 'wrap' }}>
                        <span aria-hidden style={{ fontSize: '1.6rem', lineHeight: 1 }}>
                          {activeTopic.icon || topicIconFromCatalog(topicsCatalog, activeTopic.code)}
                        </span>
                        <span>{activeTopic.title}</span>
                      </h3>
                      <div style={{ display: 'flex', gap: '0.5rem', flexWrap: 'wrap', marginTop: '0.45rem' }}>
                        <button
                          type="button"
                          className={`fl-btn ${activeTopicView === 'vocabulary' ? 'fl-btn-primary' : 'fl-btn-outline'}`}
                          onClick={() => {
                            setActiveTopicView('vocabulary');
                            setFlashcardIndex(0);
                            setFlippedCards({});
                          }}
                        >
                          Vocabulary
                        </button>
                        <button
                          type="button"
                          className={`fl-btn ${activeTopicView === 'phrases' ? 'fl-btn-primary' : 'fl-btn-outline'}`}
                          onClick={() => {
                            setActiveTopicView('phrases');
                            setFlashcardIndex(0);
                            setFlippedCards({});
                          }}
                        >
                          Phrases
                        </button>
                        <button
                          type="button"
                          className={`fl-btn ${activeTopicView === 'units' ? 'fl-btn-primary' : 'fl-btn-outline'}`}
                          onClick={() => setActiveTopicView('units')}
                        >
                          Units
                        </button>
                      </div>
                      {activeTopicView === 'vocabulary' ? (
                        <>
                          {(() => {
                            const current = activeWords[flashcardIndex] || {};
                            const cardKey = current.id || `${activeTopic.code}-${flashcardIndex}`;
                            const flipped = Boolean(flippedCards[cardKey]);
                            return (
                              <>
                                <button
                                  type="button"
                                  onClick={() => setFlippedCards((prev) => ({ ...prev, [cardKey]: !flipped }))}
                                  style={{
                                    marginTop: '0.5rem',
                                    width: '100%',
                                    minHeight: '220px',
                                    borderRadius: '16px',
                                    border: '1px solid var(--fl-border)',
                                    background: flipped ? 'rgba(99, 102, 241, 0.08)' : 'var(--fl-surface-soft)',
                                    padding: '1.25rem',
                                    textAlign: 'center',
                                  }}
                                >
                                  {!flipped ? (
                                    <>
                                      <div style={{ fontSize: '2rem', fontWeight: 800 }}>{choiceDisplayText(current.word)}</div>
                                      <div style={{ marginTop: '0.4rem', color: 'var(--fl-text-muted)' }}>
                                        {stripUnderscoresOnly(current.phonetic_guide) || 'Tap to flip'}
                                      </div>
                                    </>
                                  ) : (
                                    <>
                                      <div style={{ fontSize: '1.8rem', fontWeight: 800 }}>
                                        {choiceDisplayText(current.translation)}
                                      </div>
                                      <div style={{ marginTop: '0.6rem' }}>
                                        {stripUnderscoresOnly(current.example_sentence) || 'No example sentence.'}
                                      </div>
                                    </>
                                  )}
                                </button>
                                <div style={{ marginTop: '0.7rem', display: 'flex', gap: '0.5rem', alignItems: 'center' }}>
                                  <button
                                    type="button"
                                    className="fl-btn fl-btn-outline"
                                    onClick={() =>
                                      setFlashcardIndex((i) => (i <= 0 ? activeWords.length - 1 : i - 1))
                                    }
                                  >
                                    ← Prev
                                  </button>
                                  <button
                                    type="button"
                                    className="fl-btn fl-btn-outline"
                                  onClick={() => {
                                    speakWord(current.word, current.audio_text);
                                    award(2, 'topics');
                                      recordPracticeAttempt({
                                        section: 'vocabulary',
                                        correct: true,
                                        source: 'topic_flashcard_pronounce',
                                        topicTag: activeTopic?.code || '',
                                        contentId: current.id || null,
                                        contentKind: 'VOCABULARY',
                                        labelSnapshot: current.word || '',
                                      });
                                  }}
                                  >
                                    🔊 Pronounce
                                  </button>
                                <button
                                  type="button"
                                  className="fl-btn fl-btn-primary"
                                  onClick={() => {
                                    award(12, 'topics', `topic-word-${cardKey}`);
                                    recordPracticeAttempt({
                                      section: 'vocabulary',
                                      correct: true,
                                      source: 'topic_flashcard_mastery',
                                      topicTag: activeTopic?.code || '',
                                      contentId: current.id || null,
                                      contentKind: 'VOCABULARY',
                                      labelSnapshot: current.word || '',
                                    });
                                  }}
                                >
                                  +12 XP Learned
                                </button>
                                  <button
                                    type="button"
                                    className="fl-btn fl-btn-outline"
                                    onClick={() =>
                                      setFlashcardIndex((i) => (i >= activeWords.length - 1 ? 0 : i + 1))
                                    }
                                  >
                                    Next →
                                  </button>
                                  <span className="fl-auth-sub" style={{ marginLeft: 'auto' }}>
                                    Card {flashcardIndex + 1} / {activeWords.length}
                                  </span>
                                </div>
                              </>
                            );
                          })()}
                        </>
                      ) : null}
                      {activeTopicView === 'phrases' ? (
                        activePhrases.length === 0 ? (
                          <p style={{ marginTop: '0.75rem' }}>No phrases found for this topic.</p>
                        ) : (
                          (() => {
                            const current = activePhrases[flashcardIndex] || {};
                            const cardKey = current.id || `${activeTopic.code}-phrase-${flashcardIndex}`;
                            const flipped = Boolean(flippedCards[cardKey]);
                            return (
                              <>
                                <button
                                  type="button"
                                  onClick={() => setFlippedCards((prev) => ({ ...prev, [cardKey]: !flipped }))}
                                  style={{
                                    marginTop: '0.5rem',
                                    width: '100%',
                                    minHeight: '220px',
                                    borderRadius: '16px',
                                    border: '1px solid var(--fl-border)',
                                    background: flipped ? 'rgba(16, 185, 129, 0.08)' : 'var(--fl-surface-soft)',
                                    padding: '1.25rem',
                                    textAlign: 'center',
                                  }}
                                >
                                  {!flipped ? (
                                    <>
                                      <div style={{ fontSize: '1.6rem', fontWeight: 800 }}>{choiceDisplayText(current.phrase)}</div>
                                      <div style={{ marginTop: '0.4rem', color: 'var(--fl-text-muted)' }}>
                                        Tap to flip
                                      </div>
                                    </>
                                  ) : (
                                    <>
                                      <div style={{ fontSize: '1.3rem', fontWeight: 700 }}>
                                        {choiceDisplayText(current.translation)}
                                      </div>
                                      <div style={{ marginTop: '0.6rem' }}>
                                        {stripUnderscoresOnly(current.context) || 'No context provided.'}
                                      </div>
                                    </>
                                  )}
                                </button>
                                <div style={{ marginTop: '0.7rem', display: 'flex', gap: '0.5rem', alignItems: 'center' }}>
                                  <button
                                    type="button"
                                    className="fl-btn fl-btn-outline"
                                    onClick={() =>
                                      setFlashcardIndex((i) => (i <= 0 ? activePhrases.length - 1 : i - 1))
                                    }
                                  >
                                    ← Prev
                                  </button>
                                  <button
                                    type="button"
                                    className="fl-btn fl-btn-outline"
                                    onClick={() => {
                                      speakWord(current.phrase, current.audio_text);
                                      award(2, 'topics');
                                      recordPracticeAttempt({
                                        section: 'listening',
                                        correct: true,
                                        source: 'topic_phrase_pronounce',
                                        topicTag: activeTopic?.code || '',
                                        contentId: current.id || null,
                                        contentKind: 'PHRASE',
                                        labelSnapshot: current.phrase || '',
                                      });
                                    }}
                                  >
                                    🔊 Pronounce
                                  </button>
                                  <button
                                    type="button"
                                    className="fl-btn fl-btn-primary"
                                    onClick={() => {
                                      award(12, 'topics', `topic-phrase-${cardKey}`);
                                      recordPracticeAttempt({
                                        section: 'listening',
                                        correct: true,
                                        source: 'topic_phrase_mastery',
                                        topicTag: activeTopic?.code || '',
                                        contentId: current.id || null,
                                        contentKind: 'PHRASE',
                                        labelSnapshot: current.phrase || '',
                                      });
                                    }}
                                  >
                                    +12 XP Learned
                                  </button>
                                  <button
                                    type="button"
                                    className="fl-btn fl-btn-outline"
                                    onClick={() =>
                                      setFlashcardIndex((i) => (i >= activePhrases.length - 1 ? 0 : i + 1))
                                    }
                                  >
                                    Next →
                                  </button>
                                  <span className="fl-auth-sub" style={{ marginLeft: 'auto' }}>
                                    Card {flashcardIndex + 1} / {activePhrases.length}
                                  </span>
                                </div>
                              </>
                            );
                          })()
                        )
                      ) : null}
                      {activeTopicView === 'units' ? (
                        activeUnits.length === 0 ? (
                          <p style={{ marginTop: '0.75rem' }}>No units found for this topic.</p>
                        ) : (
                          <div style={{ marginTop: '0.75rem', display: 'grid', gap: '0.65rem' }}>
                            {activeUnits.map((u) => (
                              <div
                                key={u.id || `${u.title}-${u.display_order}`}
                                style={{
                                  border: '1px solid var(--fl-border)',
                                  borderRadius: '12px',
                                  padding: '0.8rem 0.9rem',
                                  background: 'var(--fl-surface-soft)',
                                }}
                              >
                                <div style={{ fontWeight: 700 }}>{stripUnderscoresOnly(u.title) || 'Untitled Unit'}</div>
                                <div className="fl-auth-sub" style={{ marginTop: '0.2rem' }}>
                                  {stripUnderscoresOnly(u.description) || 'No description'}
                                </div>
                              </div>
                            ))}
                          </div>
                        )
                      ) : null}
                    </div>
                  </div>
                ) : null}
              </div>
            ) : null}
            {path !== '/dashboard/topics' && !loading ? (
              <>
                {path === '/dashboard/vocabulary' ? (
                  <div style={{ display: 'grid', gap: '0.75rem' }}>
                    <p className="fl-auth-sub">{items.length} words</p>
                    {items.map((w) => (
                      <div key={w.id || `${w.word}-${w.topic_tag}`} className="fl-continue-card">
                        <div style={{ width: '100%' }}>
                          <div style={{ display: 'flex', justifyContent: 'space-between', gap: '0.75rem', alignItems: 'center' }}>
                            <h3 style={{ margin: 0 }}>{choiceDisplayText(w.word)}</h3>
                            <button type="button" className="fl-btn fl-btn-outline" onClick={() => speakWord(w.word, w.audio_text)}>
                              🔊
                            </button>
                          </div>
                          <p style={{ marginTop: '0.35rem' }}>{choiceDisplayText(w.translation)}</p>
                          <p className="fl-auth-sub" style={{ marginTop: '0.25rem' }}>
                            {formatTopicLabel(w.topic_tag || 'general')} · {formatLevel(w.level || levelLabel)}
                          </p>
                          <p style={{ marginTop: '0.45rem' }}>
                            {truncateText(stripUnderscoresOnly(w.example_sentence), 160)}
                          </p>
                          <div style={{ marginTop: '0.55rem' }}>
                            <button
                              type="button"
                              className="fl-btn fl-btn-primary"
                              onClick={() => {
                                award(10, 'vocabulary', `vocab-${w.id || `${w.word}-${w.topic_tag}`}`);
                                recordPracticeAttempt({
                                  section: 'vocabulary',
                                  correct: true,
                                  source: 'vocabulary_mark_learned',
                                  topicTag: w.topic_tag || '',
                                  contentId: w.id || null,
                                  contentKind: 'VOCABULARY',
                                  labelSnapshot: w.word || '',
                                });
                              }}
                            >
                              Mark learned (+10 XP)
                            </button>
                          </div>
                          <div style={{ marginTop: '0.55rem' }}>
                            <p className="fl-auth-sub" style={{ marginBottom: '0.35rem' }}>
                              Quick check: What is "{choiceDisplayText(w.word)}"?
                            </p>
                            {(() => {
                              const right = String(w.translation || '');
                              const wrong = pickDistractor(items, right, 'translation');
                              const options = [right, wrong].sort(() => Math.random() - 0.5);
                              const key = `vocab-${w.id || w.word}`;
                              return (
                                <div style={{ display: 'flex', gap: '0.5rem', flexWrap: 'wrap' }}>
                                  {options.map((opt) => (
                                    <button
                                      key={`${key}-${opt}`}
                                      type="button"
                                      className="fl-btn fl-btn-outline"
                                      onClick={() =>
                                        submitKnowledgeCheck({
                                          section: 'vocabulary',
                                          key,
                                          correct: opt === right,
                                          source: 'vocabulary_quick_check',
                                          topicTag: w.topic_tag || '',
                                          contentId: w.id || null,
                                          contentKind: 'VOCABULARY',
                                          labelSnapshot: w.word || '',
                                        })
                                      }
                                    >
                                      {choiceDisplayText(opt)}
                                    </button>
                                  ))}
                                  {checkFeedback[key] ? (
                                    <span className={checkFeedback[key] === 'correct' ? 'fl-auth-info' : 'fl-auth-error'}>
                                      {checkFeedback[key] === 'correct' ? 'Correct' : 'Try again'}
                                    </span>
                                  ) : null}
                                </div>
                              );
                            })()}
                          </div>
                        </div>
                      </div>
                    ))}
                    <div className="fl-continue-card">
                      <div>
                        <h3>Section checkpoint</h3>
                        <p>
                          Score: {sectionChecks.vocabulary.correct}/{sectionChecks.vocabulary.total}{' '}
                          ({sectionChecks.vocabulary.total ? Math.round((sectionChecks.vocabulary.correct / sectionChecks.vocabulary.total) * 100) : 0}%)
                        </p>
                        {sectionQuiz.section === 'vocabulary' && sectionQuiz.questions.length > 0 ? (
                          !sectionQuiz.done ? (
                            <div>
                              <p style={{ marginTop: '0.5rem' }}>
                                Q{sectionQuiz.index + 1}/{sectionQuiz.questions.length}: {sectionQuiz.questions[sectionQuiz.index]?.prompt}
                              </p>
                              <p className="fl-auth-sub" style={{ marginTop: '0.2rem' }}>
                                Adaptive difficulty: {quizDifficulty ? quizDifficulty[0].toUpperCase() + quizDifficulty.slice(1) : 'Medium'}
                              </p>
                              <div style={{ display: 'flex', gap: '0.5rem', flexWrap: 'wrap' }}>
                                {(sectionQuiz.questions[sectionQuiz.index]?.options || []).map((opt) => (
                                  <button key={opt} type="button" className="fl-btn fl-btn-outline" onClick={() => answerSectionQuiz(opt)}>
                                    {choiceDisplayText(opt)}
                                  </button>
                                ))}
                              </div>
                            </div>
                          ) : (
                            <p className="fl-auth-info" style={{ marginTop: '0.5rem' }}>
                              Quiz complete: {sectionQuiz.correct}/{sectionQuiz.questions.length} (
                              {sectionQuiz.questions.length ? Math.round((sectionQuiz.correct / sectionQuiz.questions.length) * 100) : 0}%)
                            </p>
                          )
                        ) : (
                          <button type="button" className="fl-btn fl-btn-primary" onClick={() => startSectionQuiz('vocabulary', items)}>
                            Start 5-question quiz
                          </button>
                        )}
                      </div>
                    </div>
                  </div>
                ) : null}

                {path === '/dashboard/mix-match' ? (
                  <div className="fl-mix-lesson">
                    <div className="lesson-card" id="card-match">
                      <div className="top-bar top-bar-progress-only">
                        <div className="progress-wrap">
                          <span className="progress-label">0%</span>
                          <div className="progress-track">
                            <div
                              className="progress-fill"
                              id="match-progress"
                              style={{ width: `${mixMatchProgressPct}%` }}
                            />
                          </div>
                          <span className="progress-label">100%</span>
                        </div>
                      </div>

                      <div className="lesson-body">
                        {mixMatchState?.tooFew ? (
                          <p className="mm-empty">
                            You need at least three vocabulary words with translations. Add content or check the
                            Vocabulary section — data comes from the same list.
                          </p>
                        ) : loading || !mixMatchState?.pairs?.length ? (
                          <p className="mm-loading">Loading pairs…</p>
                        ) : (
                          <>
                            <div className="topic-tag">
                              {(() => {
                                const tag = mixMatchState.pairs[0]?.topic_tag || '';
                                const icon = tag
                                  ? topicIconFromCatalog(topicsCatalog, tag)
                                  : selectedTopics.length
                                    ? topicIconFromCatalog(topicsCatalog, selectedTopics[0])
                                    : '📚';
                                const label = tag
                                  ? formatTopicLabel(tag)
                                  : selectedTopics.length
                                    ? formatTopicLabel(selectedTopics[0])
                                    : 'Your vocabulary';
                                return (
                                  <>
                                    <span aria-hidden>{icon}</span> {label}
                                  </>
                                );
                              })()}
                            </div>
                            <div className="activity-type">Mix &amp; Match the vocabulary</div>

                            <div className="score-chip" id="match-score">
                              <svg width="13" height="13" viewBox="0 0 13 13" fill="none" aria-hidden>
                                <path
                                  d="M6.5 1L8.1 4.6l3.9.4-2.8 2.6.8 3.8L6.5 9.4l-3.5 2 .8-3.8L1 5l3.9-.4L6.5 1z"
                                  fill="currentColor"
                                />
                              </svg>
                              {Object.keys(mixMatchState.matched).length} / {mixMatchState.pairs.length} pairs matched
                            </div>
                            <p className="mm-hint">
                              Tap a word, then tap its translation. Pairs use your {languageLabel} vocabulary list.
                            </p>

                            <p className="row-label">Words</p>
                            <div
                              className="match-grid"
                              id="words-row"
                              style={{
                                gridTemplateColumns: `repeat(${mixMatchState.pairs.length}, minmax(0, 1fr))`,
                              }}
                            >
                              {mixMatchState.leftOrder.map((id) => {
                                const p = mixMatchState.pairs.find((x) => x.id === id);
                                if (!p) return null;
                                const matched = !!mixMatchState.matched[id];
                                const picked =
                                  mixMatchState.pick?.vocabId === id && mixMatchState.pick?.side === 'left';
                                const wrongFlash = mixMatchWrongIds?.includes(id);
                                return (
                                  <button
                                    key={`L-${id}`}
                                    type="button"
                                    disabled={matched}
                                    className={`match-card${matched ? ' matched' : ''}${picked ? ' selected' : ''}${
                                      wrongFlash ? ' wrong' : ''
                                    }`}
                                    onClick={() => handleMixMatchTap('left', id)}
                                  >
                                    {choiceDisplayText(p.word)}
                                  </button>
                                );
                              })}
                            </div>

                            <p className="row-label">Translations</p>
                            <div
                              className="match-grid"
                              id="trans-row"
                              style={{
                                gridTemplateColumns: `repeat(${mixMatchState.pairs.length}, minmax(0, 1fr))`,
                              }}
                            >
                              {mixMatchState.rightOrder.map((id) => {
                                const p = mixMatchState.pairs.find((x) => x.id === id);
                                if (!p) return null;
                                const matched = !!mixMatchState.matched[id];
                                const picked =
                                  mixMatchState.pick?.vocabId === id && mixMatchState.pick?.side === 'right';
                                const wrongFlash = mixMatchWrongIds?.includes(id);
                                return (
                                  <button
                                    key={`R-${id}`}
                                    type="button"
                                    disabled={matched}
                                    className={`match-card${matched ? ' matched' : ''}${picked ? ' selected' : ''}${
                                      wrongFlash ? ' wrong' : ''
                                    }`}
                                    onClick={() => handleMixMatchTap('right', id)}
                                  >
                                    {choiceDisplayText(p.translation)}
                                  </button>
                                );
                              })}
                            </div>

                            {mixMatchFeedback ? (
                              <div
                                className={`feedback show${mixMatchFeedback.kind === 'correct' ? ' correct-fb' : ' wrong-fb'}`}
                                id="match-feedback"
                                role="status"
                              >
                                {mixMatchFeedback.text}
                              </div>
                            ) : null}

                            <div className="mm-footer-actions">
                              <button
                                type="button"
                                className="btn-continue"
                                id="match-btn"
                                disabled={
                                  Object.keys(mixMatchState.matched).length !== mixMatchState.pairs.length
                                }
                                title={
                                  Object.keys(mixMatchState.matched).length === mixMatchState.pairs.length
                                    ? 'Shuffle a new set of words'
                                    : 'Finish all pairs to start the next round with this button'
                                }
                                onClick={() => setMixMatchRound((r) => r + 1)}
                              >
                                {Object.keys(mixMatchState.matched).length === mixMatchState.pairs.length
                                  ? 'New round'
                                  : 'Check matches'}
                              </button>
                              <button
                                type="button"
                                className="mm-text-btn"
                                onClick={() => setMixMatchRound((r) => r + 1)}
                              >
                                Shuffle · new round now
                              </button>
                            </div>
                          </>
                        )}
                      </div>
                    </div>
                  </div>
                ) : null}

                {path === '/dashboard/grammar' ? (
                  <div style={{ display: 'grid', gap: '0.75rem' }}>
                    <p className="fl-auth-sub">{items.length} grammar rules</p>
                    {items.map((g) => (
                      <div key={g.id || g.code || g.title} className="fl-continue-card">
                        <div style={{ width: '100%' }}>
                          <h3 style={{ margin: 0 }}>
                            {stripUnderscoresOnly(g.title) || formatTopicLabel(g.code || 'grammar')}
                          </h3>
                          <p className="fl-auth-sub" style={{ marginTop: '0.35rem' }}>
                            {formatTopicLabel(g.category || 'grammar')} · {formatLevel(g.level || levelLabel)}
                          </p>
                          <p style={{ marginTop: '0.5rem' }}>{truncateText(stripUnderscoresOnly(g.explanation), 260)}</p>
                          {g.examples ? (
                            <p style={{ marginTop: '0.4rem' }}>
                              <strong>Example:</strong> {truncateText(stripUnderscoresOnly(g.examples), 180)}
                            </p>
                          ) : null}
                          <div style={{ marginTop: '0.55rem' }}>
                            <button
                              type="button"
                              className="fl-btn fl-btn-primary"
                              onClick={() => {
                                award(12, 'grammar', `grammar-${g.id || g.code || g.title}`);
                                recordPracticeAttempt({
                                  section: 'grammar',
                                  correct: true,
                                  source: 'grammar_understood',
                                  topicTag: '',
                                  contentId: g.id || null,
                                  contentKind: 'GRAMMAR',
                                  labelSnapshot: g.title || g.code || '',
                                });
                              }}
                            >
                              I understand this (+12 XP)
                            </button>
                          </div>
                          <div style={{ marginTop: '0.55rem' }}>
                            {(() => {
                              const key = `grammar-${g.id || g.code || g.title}`;
                              const right = g.category || 'Grammar';
                              const wrong = right === 'Grammar' ? 'Vocabulary' : 'Grammar';
                              return (
                                <>
                                  <p className="fl-auth-sub" style={{ marginBottom: '0.35rem' }}>
                                    Quick check: This rule belongs to which area?
                                  </p>
                                  <button
                                    type="button"
                                    className="fl-btn fl-btn-outline"
                                    onClick={() =>
                                      submitKnowledgeCheck({
                                        section: 'grammar',
                                        key,
                                        correct: true,
                                        source: 'grammar_quick_check',
                                        contentId: g.id || null,
                                        contentKind: 'GRAMMAR',
                                        labelSnapshot: g.title || g.code || '',
                                      })
                                    }
                                  >
                                    {formatTopicLabel(right)}
                                  </button>{' '}
                                  <button
                                    type="button"
                                    className="fl-btn fl-btn-outline"
                                    onClick={() =>
                                      submitKnowledgeCheck({
                                        section: 'grammar',
                                        key,
                                        correct: false,
                                        source: 'grammar_quick_check',
                                        contentId: g.id || null,
                                        contentKind: 'GRAMMAR',
                                        labelSnapshot: g.title || g.code || '',
                                      })
                                    }
                                  >
                                    {formatTopicLabel(wrong)}
                                  </button>
                                  {checkFeedback[key] ? (
                                    <span className={checkFeedback[key] === 'correct' ? 'fl-auth-info' : 'fl-auth-error'}>
                                      {checkFeedback[key] === 'correct' ? 'Correct' : 'Try again'}
                                    </span>
                                  ) : null}
                                </>
                              );
                            })()}
                          </div>
                        </div>
                      </div>
                    ))}
                    <div className="fl-continue-card">
                      <div>
                        <h3>Section checkpoint</h3>
                        <p>
                          Score: {sectionChecks.grammar.correct}/{sectionChecks.grammar.total}{' '}
                          ({sectionChecks.grammar.total ? Math.round((sectionChecks.grammar.correct / sectionChecks.grammar.total) * 100) : 0}%)
                        </p>
                        {sectionQuiz.section === 'grammar' && sectionQuiz.questions.length > 0 ? (
                          !sectionQuiz.done ? (
                            <div>
                              <p style={{ marginTop: '0.5rem' }}>
                                Q{sectionQuiz.index + 1}/{sectionQuiz.questions.length}: {sectionQuiz.questions[sectionQuiz.index]?.prompt}
                              </p>
                              <p className="fl-auth-sub" style={{ marginTop: '0.2rem' }}>
                                Adaptive difficulty: {quizDifficulty ? quizDifficulty[0].toUpperCase() + quizDifficulty.slice(1) : 'Medium'}
                              </p>
                              <div style={{ display: 'flex', gap: '0.5rem', flexWrap: 'wrap' }}>
                                {(sectionQuiz.questions[sectionQuiz.index]?.options || []).map((opt) => (
                                  <button key={opt} type="button" className="fl-btn fl-btn-outline" onClick={() => answerSectionQuiz(opt)}>
                                    {formatTopicLabel(opt)}
                                  </button>
                                ))}
                              </div>
                            </div>
                          ) : (
                            <p className="fl-auth-info" style={{ marginTop: '0.5rem' }}>
                              Quiz complete: {sectionQuiz.correct}/{sectionQuiz.questions.length} (
                              {sectionQuiz.questions.length ? Math.round((sectionQuiz.correct / sectionQuiz.questions.length) * 100) : 0}%)
                            </p>
                          )
                        ) : (
                          <button type="button" className="fl-btn fl-btn-primary" onClick={() => startSectionQuiz('grammar', items)}>
                            Start 5-question quiz
                          </button>
                        )}
                      </div>
                    </div>
                  </div>
                ) : null}

                {path === '/dashboard/listening' ? (
                  <div style={{ display: 'grid', gap: '0.75rem' }}>
                    <p className="fl-auth-sub">{items.length} listening phrases</p>
                    {items.map((p) => (
                      <div key={p.id || p.phrase} className="fl-continue-card">
                        <div style={{ width: '100%' }}>
                          <div style={{ display: 'flex', justifyContent: 'space-between', gap: '0.75rem', alignItems: 'center' }}>
                            <h3 style={{ margin: 0 }}>{choiceDisplayText(p.phrase)}</h3>
                            <button type="button" className="fl-btn fl-btn-outline" onClick={() => speakWord(p.phrase, p.audio_text)}>
                              🔊
                            </button>
                          </div>
                          <p style={{ marginTop: '0.35rem' }}>{choiceDisplayText(p.translation)}</p>
                          <p className="fl-auth-sub" style={{ marginTop: '0.25rem' }}>
                            {formatTopicLabel(p.topic_tag || 'general')} · {formatLevel(p.level || levelLabel)}
                          </p>
                          {p.context ? (
                            <p style={{ marginTop: '0.45rem' }}>{truncateText(stripUnderscoresOnly(p.context), 160)}</p>
                          ) : null}
                          <div style={{ marginTop: '0.55rem' }}>
                            <button
                              type="button"
                              className="fl-btn fl-btn-primary"
                              onClick={() => {
                                award(10, 'listening', `listen-${p.id || p.phrase}`);
                                recordPracticeAttempt({
                                  section: 'listening',
                                  correct: true,
                                  source: 'listening_heard_clearly',
                                  topicTag: p.topic_tag || '',
                                  contentId: p.id || null,
                                  contentKind: 'PHRASE',
                                  labelSnapshot: p.phrase || '',
                                });
                              }}
                            >
                              Heard clearly (+10 XP)
                            </button>
                          </div>
                          <div style={{ marginTop: '0.55rem' }}>
                            {(() => {
                              const key = `listen-${p.id || p.phrase}`;
                              const right = p.translation || '';
                              const wrong = pickDistractor(items, right, 'translation');
                              const options = [right, wrong].sort(() => Math.random() - 0.5);
                              return (
                                <>
                                  <p className="fl-auth-sub" style={{ marginBottom: '0.35rem' }}>
                                    Quick check: What did you hear?
                                  </p>
                                  {options.map((opt) => (
                                    <button
                                      key={`${key}-${opt}`}
                                      type="button"
                                      className="fl-btn fl-btn-outline"
                                      onClick={() =>
                                        submitKnowledgeCheck({
                                          section: 'listening',
                                          key,
                                          correct: opt === right,
                                          source: 'listening_quick_check',
                                          topicTag: p.topic_tag || '',
                                          contentId: p.id || null,
                                          contentKind: 'PHRASE',
                                          labelSnapshot: p.phrase || '',
                                        })
                                      }
                                    >
                                      {choiceDisplayText(opt)}
                                    </button>
                                  ))}
                                  {checkFeedback[key] ? (
                                    <span className={checkFeedback[key] === 'correct' ? 'fl-auth-info' : 'fl-auth-error'}>
                                      {checkFeedback[key] === 'correct' ? 'Correct' : 'Try again'}
                                    </span>
                                  ) : null}
                                </>
                              );
                            })()}
                          </div>
                        </div>
                      </div>
                    ))}
                    <div className="fl-continue-card">
                      <div>
                        <h3>Section checkpoint</h3>
                        <p>
                          Score: {sectionChecks.listening.correct}/{sectionChecks.listening.total}{' '}
                          ({sectionChecks.listening.total ? Math.round((sectionChecks.listening.correct / sectionChecks.listening.total) * 100) : 0}%)
                        </p>
                        {sectionQuiz.section === 'listening' && sectionQuiz.questions.length > 0 ? (
                          !sectionQuiz.done ? (
                            <div>
                              <p style={{ marginTop: '0.5rem' }}>
                                Q{sectionQuiz.index + 1}/{sectionQuiz.questions.length}: {sectionQuiz.questions[sectionQuiz.index]?.prompt}
                              </p>
                              <p className="fl-auth-sub" style={{ marginTop: '0.2rem' }}>
                                Adaptive difficulty: {quizDifficulty ? quizDifficulty[0].toUpperCase() + quizDifficulty.slice(1) : 'Medium'}
                              </p>
                              <div style={{ display: 'flex', gap: '0.5rem', flexWrap: 'wrap' }}>
                                {(sectionQuiz.questions[sectionQuiz.index]?.options || []).map((opt) => (
                                  <button key={opt} type="button" className="fl-btn fl-btn-outline" onClick={() => answerSectionQuiz(opt)}>
                                    {choiceDisplayText(opt)}
                                  </button>
                                ))}
                              </div>
                            </div>
                          ) : (
                            <p className="fl-auth-info" style={{ marginTop: '0.5rem' }}>
                              Quiz complete: {sectionQuiz.correct}/{sectionQuiz.questions.length} (
                              {sectionQuiz.questions.length ? Math.round((sectionQuiz.correct / sectionQuiz.questions.length) * 100) : 0}%)
                            </p>
                          )
                        ) : (
                          <button type="button" className="fl-btn fl-btn-primary" onClick={() => startSectionQuiz('listening', items)}>
                            Start 5-question quiz
                          </button>
                        )}
                      </div>
                    </div>
                  </div>
                ) : null}

                {path === '/dashboard/conversation' ? (
                  <div style={{ display: 'grid', gap: '0.75rem' }}>
                    <p className="fl-auth-sub">{items.length} conversation templates</p>
                    {items.map((c) => (
                      <div key={c.id || c.title} className="fl-continue-card">
                        <div style={{ width: '100%' }}>
                          <h3 style={{ margin: 0 }}>
                            {stripUnderscoresOnly(c.title) || formatTopicLabel('conversation template')}
                          </h3>
                          <p className="fl-auth-sub" style={{ marginTop: '0.35rem' }}>
                            {formatTopicLabel(c.topic_tag || 'general')} · {formatLevel(c.level || levelLabel)}
                          </p>
                          <p style={{ marginTop: '0.45rem' }}>
                            <strong>Scenario:</strong> {truncateText(stripUnderscoresOnly(c.scenario), 180)}
                          </p>
                          <p style={{ marginTop: '0.3rem' }}>
                            <strong>Opening:</strong> {truncateText(stripUnderscoresOnly(c.opening_prompt), 180)}
                          </p>
                          {c.min_exchanges ? <p className="fl-auth-sub" style={{ marginTop: '0.4rem' }}>Min exchanges: {c.min_exchanges}</p> : null}
                          <div style={{ marginTop: '0.55rem' }}>
                            <button
                              type="button"
                              className="fl-btn fl-btn-primary"
                              onClick={() => {
                                award(14, 'conversation', `conv-${c.id || c.title}`);
                                recordPracticeAttempt({
                                  section: 'conversation',
                                  correct: true,
                                  source: 'conversation_completed',
                                  topicTag: c.topic_tag || '',
                                  contentId: c.id || null,
                                  contentKind: 'TEMPLATE',
                                  labelSnapshot: c.title || '',
                                });
                              }}
                            >
                              Completed dialogue (+14 XP)
                            </button>
                          </div>
                          <div style={{ marginTop: '0.55rem' }}>
                            {(() => {
                              const key = `conv-${c.id || c.title}`;
                              const right = c.topic_tag || 'General';
                              const wrong = right === 'General' ? 'Travel' : 'General';
                              return (
                                <>
                                  <p className="fl-auth-sub" style={{ marginBottom: '0.35rem' }}>
                                    Quick check: This conversation is mostly about...
                                  </p>
                                  <button
                                    type="button"
                                    className="fl-btn fl-btn-outline"
                                    onClick={() =>
                                      submitKnowledgeCheck({
                                        section: 'conversation',
                                        key,
                                        correct: true,
                                        source: 'conversation_quick_check',
                                        topicTag: c.topic_tag || '',
                                        contentId: c.id || null,
                                        contentKind: 'TEMPLATE',
                                        labelSnapshot: c.title || '',
                                      })
                                    }
                                  >
                                    {formatTopicLabel(right)}
                                  </button>{' '}
                                  <button
                                    type="button"
                                    className="fl-btn fl-btn-outline"
                                    onClick={() =>
                                      submitKnowledgeCheck({
                                        section: 'conversation',
                                        key,
                                        correct: false,
                                        source: 'conversation_quick_check',
                                        topicTag: c.topic_tag || '',
                                        contentId: c.id || null,
                                        contentKind: 'TEMPLATE',
                                        labelSnapshot: c.title || '',
                                      })
                                    }
                                  >
                                    {formatTopicLabel(wrong)}
                                  </button>
                                  {checkFeedback[key] ? (
                                    <span className={checkFeedback[key] === 'correct' ? 'fl-auth-info' : 'fl-auth-error'}>
                                      {checkFeedback[key] === 'correct' ? 'Correct' : 'Try again'}
                                    </span>
                                  ) : null}
                                </>
                              );
                            })()}
                          </div>
                        </div>
                      </div>
                    ))}
                    <div className="fl-continue-card">
                      <div>
                        <h3>Section checkpoint</h3>
                        <p>
                          Score: {sectionChecks.conversation.correct}/{sectionChecks.conversation.total}{' '}
                          (
                          {sectionChecks.conversation.total
                            ? Math.round((sectionChecks.conversation.correct / sectionChecks.conversation.total) * 100)
                            : 0}
                          %)
                        </p>
                        {sectionQuiz.section === 'conversation' && sectionQuiz.questions.length > 0 ? (
                          !sectionQuiz.done ? (
                            <div>
                              <p style={{ marginTop: '0.5rem' }}>
                                Q{sectionQuiz.index + 1}/{sectionQuiz.questions.length}: {sectionQuiz.questions[sectionQuiz.index]?.prompt}
                              </p>
                              <p className="fl-auth-sub" style={{ marginTop: '0.2rem' }}>
                                Adaptive difficulty: {quizDifficulty ? quizDifficulty[0].toUpperCase() + quizDifficulty.slice(1) : 'Medium'}
                              </p>
                              <div style={{ display: 'flex', gap: '0.5rem', flexWrap: 'wrap' }}>
                                {(sectionQuiz.questions[sectionQuiz.index]?.options || []).map((opt) => (
                                  <button key={opt} type="button" className="fl-btn fl-btn-outline" onClick={() => answerSectionQuiz(opt)}>
                                    {formatTopicLabel(opt)}
                                  </button>
                                ))}
                              </div>
                            </div>
                          ) : (
                            <p className="fl-auth-info" style={{ marginTop: '0.5rem' }}>
                              Quiz complete: {sectionQuiz.correct}/{sectionQuiz.questions.length} (
                              {sectionQuiz.questions.length ? Math.round((sectionQuiz.correct / sectionQuiz.questions.length) * 100) : 0}%)
                            </p>
                          )
                        ) : (
                          <button type="button" className="fl-btn fl-btn-primary" onClick={() => startSectionQuiz('conversation', items)}>
                            Start 5-question quiz
                          </button>
                        )}
                      </div>
                    </div>
                  </div>
                ) : null}

                {path === '/dashboard/writing' ? (
                  <div style={{ display: 'grid', gap: '0.75rem' }}>
                    <p className="fl-auth-sub">{items.length} writing passages</p>
                    {items.map((r) => (
                      <div key={r.id || r.title} className="fl-continue-card">
                        <div style={{ width: '100%' }}>
                          <h3 style={{ margin: 0 }}>
                            {stripUnderscoresOnly(r.title) || formatTopicLabel('untitled passage')}
                          </h3>
                          <p className="fl-auth-sub" style={{ marginTop: '0.35rem' }}>
                            {formatTopicLabel(r.topic_tag || 'general')} · {formatLevel(r.level || levelLabel)}
                          </p>
                          <p style={{ marginTop: '0.45rem' }}>{truncateText(stripUnderscoresOnly(r.body), 260)}</p>
                          {r.translation ? (
                            <p style={{ marginTop: '0.4rem' }}>
                              <strong>Translation:</strong> {truncateText(stripUnderscoresOnly(r.translation), 180)}
                            </p>
                          ) : null}
                          <div style={{ marginTop: '0.55rem' }}>
                            <button
                              type="button"
                              className="fl-btn fl-btn-primary"
                              onClick={() => {
                                award(14, 'writing', `writing-${r.id || r.title}`);
                                recordPracticeAttempt({
                                  section: 'writing',
                                  correct: true,
                                  source: 'writing_completed',
                                  topicTag: r.topic_tag || '',
                                  contentId: r.id || null,
                                  contentKind: 'READING',
                                  labelSnapshot: r.title || '',
                                });
                              }}
                            >
                              Wrote response (+14 XP)
                            </button>
                          </div>
                          <div style={{ marginTop: '0.55rem' }}>
                            {(() => {
                              const key = `writing-${r.id || r.title}`;
                              const right = formatLevel(r.level || levelLabel);
                              const wrong = right === 'Beginner' ? 'Advanced' : 'Beginner';
                              return (
                                <>
                                  <p className="fl-auth-sub" style={{ marginBottom: '0.35rem' }}>
                                    Quick check: This passage is closest to which level?
                                  </p>
                                  <button
                                    type="button"
                                    className="fl-btn fl-btn-outline"
                                    onClick={() =>
                                      submitKnowledgeCheck({
                                        section: 'writing',
                                        key,
                                        correct: true,
                                        source: 'writing_quick_check',
                                        topicTag: r.topic_tag || '',
                                        contentId: r.id || null,
                                        contentKind: 'READING',
                                        labelSnapshot: r.title || '',
                                      })
                                    }
                                  >
                                    {right}
                                  </button>{' '}
                                  <button
                                    type="button"
                                    className="fl-btn fl-btn-outline"
                                    onClick={() =>
                                      submitKnowledgeCheck({
                                        section: 'writing',
                                        key,
                                        correct: false,
                                        source: 'writing_quick_check',
                                        topicTag: r.topic_tag || '',
                                        contentId: r.id || null,
                                        contentKind: 'READING',
                                        labelSnapshot: r.title || '',
                                      })
                                    }
                                  >
                                    {wrong}
                                  </button>
                                  {checkFeedback[key] ? (
                                    <span className={checkFeedback[key] === 'correct' ? 'fl-auth-info' : 'fl-auth-error'}>
                                      {checkFeedback[key] === 'correct' ? 'Correct' : 'Try again'}
                                    </span>
                                  ) : null}
                                </>
                              );
                            })()}
                          </div>
                        </div>
                      </div>
                    ))}
                    <div className="fl-continue-card">
                      <div>
                        <h3>Section checkpoint</h3>
                        <p>
                          Score: {sectionChecks.writing.correct}/{sectionChecks.writing.total}{' '}
                          ({sectionChecks.writing.total ? Math.round((sectionChecks.writing.correct / sectionChecks.writing.total) * 100) : 0}%)
                        </p>
                        {sectionQuiz.section === 'writing' && sectionQuiz.questions.length > 0 ? (
                          !sectionQuiz.done ? (
                            <div>
                              <p style={{ marginTop: '0.5rem' }}>
                                Q{sectionQuiz.index + 1}/{sectionQuiz.questions.length}: {sectionQuiz.questions[sectionQuiz.index]?.prompt}
                              </p>
                              <p className="fl-auth-sub" style={{ marginTop: '0.2rem' }}>
                                Adaptive difficulty: {quizDifficulty ? quizDifficulty[0].toUpperCase() + quizDifficulty.slice(1) : 'Medium'}
                              </p>
                              <div style={{ display: 'flex', gap: '0.5rem', flexWrap: 'wrap' }}>
                                {(sectionQuiz.questions[sectionQuiz.index]?.options || []).map((opt) => (
                                  <button key={opt} type="button" className="fl-btn fl-btn-outline" onClick={() => answerSectionQuiz(opt)}>
                                    {choiceDisplayText(opt)}
                                  </button>
                                ))}
                              </div>
                            </div>
                          ) : (
                            <p className="fl-auth-info" style={{ marginTop: '0.5rem' }}>
                              Quiz complete: {sectionQuiz.correct}/{sectionQuiz.questions.length} (
                              {sectionQuiz.questions.length ? Math.round((sectionQuiz.correct / sectionQuiz.questions.length) * 100) : 0}%)
                            </p>
                          )
                        ) : (
                          <button type="button" className="fl-btn fl-btn-primary" onClick={() => startSectionQuiz('writing', items)}>
                            Start 5-question quiz
                          </button>
                        )}
                      </div>
                    </div>
                  </div>
                ) : null}

                {path === '/dashboard/ai-conversation' ? (
                  <div className="fl-continue-card">
                    <div style={{ width: '100%', maxWidth: '28rem', margin: '0 auto' }}>
                      <h3>AI Tutor Chat</h3>
                      <div
                        ref={setChatScrollEl}
                        style={{
                          marginTop: '0.6rem',
                          border: '1px solid var(--fl-border)',
                          borderRadius: '12px',
                          padding: '0.75rem',
                          background: 'var(--fl-surface-soft)',
                          display: 'flex',
                          flexDirection: 'column',
                          justifyContent: 'flex-end',
                          gap: '0.5rem',
                          height: '420px',
                          overflowY: 'auto',
                        }}
                      >
                        {chatMessages.map((m, idx) => (
                          <div
                            key={`${m.role}-${idx}`}
                            style={{
                              width: '100%',
                              display: 'flex',
                              justifyContent: m.role === 'user' ? 'flex-end' : 'flex-start',
                            }}
                          >
                            <div
                              style={{
                                maxWidth: '88%',
                                padding: '0.5rem 0.65rem',
                                borderRadius: '10px',
                                background: m.role === 'user' ? 'rgba(99,102,241,0.12)' : 'white',
                                border: '1px solid var(--fl-border)',
                              }}
                            >
                              <strong style={{ fontSize: '0.78rem' }}>{m.role === 'user' ? 'You' : 'Tutor'}</strong>
                              <div style={{ marginTop: '0.18rem', whiteSpace: 'pre-wrap' }}>{m.content}</div>
                            </div>
                          </div>
                        ))}
                      </div>
                      <textarea
                        value={aiInput}
                        onChange={(e) => setAiInput(e.target.value)}
                        onKeyDown={(e) => {
                          if (e.key === 'Enter' && !e.shiftKey) {
                            e.preventDefault();
                            sendAiMessage();
                          }
                        }}
                        className="fl-placement-input"
                        rows={3}
                        style={{ marginTop: '0.6rem' }}
                      />
                      <div style={{ marginTop: '0.4rem' }}>
                        <p className="fl-auth-sub">Press Enter to send. Press Shift+Enter for a new line.</p>
                      </div>
                      {aiFeedback ? (
                        <div style={{ marginTop: '0.7rem' }}>
                          <p><strong>Grammar:</strong> {aiFeedback.grammarScore} - {aiFeedback.grammarFeedback}</p>
                          <p><strong>Pronunciation:</strong> {aiFeedback.pronunciationScore} - {aiFeedback.pronunciationFeedback}</p>
                        </div>
                      ) : null}
                    </div>
                  </div>
                ) : null}

                {path === '/dashboard/subscription' ? (
                  <div style={{ display: 'grid', gap: '0.75rem' }}>
                    <div className="fl-continue-card">
                      <div style={{ width: '100%' }}>
                        <h3>Choose your plan</h3>
                        <p className="fl-auth-sub">Current subscription and available plans.</p>
                        <div style={{ marginTop: '0.7rem', display: 'grid', gap: '0.65rem' }}>
                          <div style={{ border: '1px solid var(--fl-border)', borderRadius: '12px', padding: '0.75rem' }}>
                            <strong>Free</strong>
                            <div className="fl-auth-sub" style={{ marginTop: '0.2rem' }}>
                              Core lessons, basic tracking, limited AI conversation.
                            </div>
                            <button
                              type="button"
                              className="fl-btn fl-btn-outline"
                              style={{ marginTop: '0.55rem' }}
                              onClick={async () => {
                                await fetch('/api/subscriptions/cancel', {
                                  method: 'PATCH',
                                  headers: { 'Content-Type': 'application/json' },
                                  body: JSON.stringify({ userId: user?.id, cancelReason: 'Downgrade to free' }),
                                });
                                navigate('/dashboard/subscription', { replace: true });
                              }}
                            >
                              Use Free
                            </button>
                          </div>
                          <div style={{ border: '1px solid var(--fl-border)', borderRadius: '12px', padding: '0.75rem', background: 'rgba(99,102,241,0.06)' }}>
                            <strong>Premium Monthly - $19.99</strong>
                            <div className="fl-auth-sub" style={{ marginTop: '0.2rem' }}>
                              Full AI conversation feedback, advanced analytics, faster progression tools, premium challenge paths.
                            </div>
                            <button
                              type="button"
                              className="fl-btn fl-btn-primary"
                              style={{ marginTop: '0.55rem' }}
                              onClick={async () => {
                                await fetch('/api/subscriptions/subscribe', {
                                  method: 'POST',
                                  headers: { 'Content-Type': 'application/json' },
                                  body: JSON.stringify({ userId: user?.id, plan: 'PREMIUM_MONTHLY', autoRenew: true }),
                                });
                                navigate('/dashboard/subscription', { replace: true });
                              }}
                            >
                              Subscribe Monthly
                            </button>
                          </div>
                          <div style={{ border: '1px solid var(--fl-border)', borderRadius: '12px', padding: '0.75rem' }}>
                            <strong>Premium Yearly - $199.99</strong>
                            <div className="fl-auth-sub" style={{ marginTop: '0.2rem' }}>
                              Everything in Monthly plus annual savings and priority feature access.
                            </div>
                            <button
                              type="button"
                              className="fl-btn fl-btn-outline"
                              style={{ marginTop: '0.55rem' }}
                              onClick={async () => {
                                await fetch('/api/subscriptions/subscribe', {
                                  method: 'POST',
                                  headers: { 'Content-Type': 'application/json' },
                                  body: JSON.stringify({ userId: user?.id, plan: 'PREMIUM_YEARLY', autoRenew: true }),
                                });
                                navigate('/dashboard/subscription', { replace: true });
                              }}
                            >
                              Subscribe Yearly
                            </button>
                          </div>
                        </div>
                        <div style={{ display: 'flex', gap: '0.5rem', flexWrap: 'wrap', marginTop: '0.55rem' }}>
                          <button
                            type="button"
                            className="fl-btn fl-btn-outline"
                            onClick={async () => {
                              await fetch('/api/subscriptions/manage', {
                                method: 'PATCH',
                                headers: { 'Content-Type': 'application/json' },
                                body: JSON.stringify({ userId: user?.id, autoRenew: true }),
                              });
                              navigate('/dashboard/subscription', { replace: true });
                            }}
                          >
                            Manage Subscription
                          </button>
                          <button
                            type="button"
                            className="fl-btn fl-btn-outline"
                            onClick={async () => {
                              await fetch('/api/subscriptions/cancel', {
                                method: 'PATCH',
                                headers: { 'Content-Type': 'application/json' },
                                body: JSON.stringify({ userId: user?.id, cancelReason: 'User cancelled from dashboard' }),
                              });
                              navigate('/dashboard/subscription', { replace: true });
                            }}
                          >
                            Cancel Subscription
                          </button>
                        </div>
                      </div>
                    </div>
                    <div style={{ display: 'grid', gap: '0.75rem' }}>
                      <h3>Current plan</h3>
                      {(() => {
                        const sub = (items || [])[0];
                        const isActivePaid = sub && String(sub.status || '').toUpperCase() === 'ACTIVE';
                        if (!isActivePaid) {
                          return (
                            <div className="fl-continue-card">
                              <div>
                                <h3>Free</h3>
                                <p>Status: ACTIVE</p>
                                <p className="fl-auth-sub">You are on the free plan.</p>
                              </div>
                            </div>
                          );
                        }
                        return (
                          <div className="fl-continue-card">
                            <div>
                              <h3>{formatTopicLabel(sub.plan || 'plan')}</h3>
                              <p>Status: {formatTopicLabel(sub.status || '')}</p>
                              <p className="fl-auth-sub">Auto renew: {String(sub.auto_renew)}</p>
                            </div>
                          </div>
                        );
                      })()}
                    </div>
                  </div>
                ) : null}

                {path === '/dashboard/weak-spots' ? (
                  <div style={{ display: 'grid', gap: '0.75rem' }}>
                    <p className="fl-auth-sub">
                      These are words, rules, phrases, dialogues, and readings you have missed in practice. Each entry
                      disappears after you answer that same item correctly again.
                    </p>
                    {(items || []).length === 0 ? (
                      <div className="fl-continue-card">
                        <p style={{ margin: 0 }}>
                          Nothing flagged yet. As you use vocabulary, grammar, listening, conversation, and writing
                          practice, wrong answers show up here automatically.
                        </p>
                      </div>
                    ) : (
                      (items || []).map((t) => (
                        <div key={t.id} className="fl-continue-card">
                          <div
                            style={{
                              display: 'flex',
                              justifyContent: 'space-between',
                              gap: '0.75rem',
                              flexWrap: 'wrap',
                              alignItems: 'flex-start',
                            }}
                          >
                            <div>
                              <h3 style={{ margin: 0 }}>{troubleItemSummary(t)}</h3>
                              <p className="fl-auth-sub" style={{ marginTop: '0.35rem' }}>
                                {formatTopicLabel(t.section || '')} ·{' '}
                                {formatTopicLabel(t.reference_type || '')}
                                {t.topic_tag ? ` · ${formatTopicLabel(t.topic_tag)}` : ''}
                              </p>
                              <p className="fl-auth-sub" style={{ marginTop: '0.2rem' }}>
                                Recorded misses: <strong>{t.wrong_count}</strong>
                              </p>
                            </div>
                            <p className="fl-auth-sub" style={{ margin: 0, textAlign: 'right' }}>
                              Last wrong:{' '}
                              {t.last_wrong_at
                                ? new Date(t.last_wrong_at).toLocaleString(undefined, {
                                    dateStyle: 'medium',
                                    timeStyle: 'short',
                                  })
                                : '—'}
                            </p>
                          </div>
                        </div>
                      ))
                    )}
                  </div>
                ) : null}

                {path === '/dashboard/retake-placement' ? (
                  <div className="fl-retake-placement">
                    <h3 className="fl-retake-placement-title">Retake placement test</h3>
                    <p className="fl-auth-sub fl-retake-placement-copy">
                      Retake the assessment to recalculate your level. When you finish, you’ll return here with your
                      updated level — no need to pick topics again.
                    </p>
                    <button
                      type="button"
                      className="fl-btn fl-btn-primary"
                      onClick={() => navigate('/onboarding/placement?retake=1')}
                    >
                      Retake placement now
                    </button>
                  </div>
                ) : null}

                {path === '/dashboard/achievements' ? (
                  <div style={{ display: 'grid', gap: '0.75rem' }}>
                    <p className="fl-auth-sub">
                      {(items || []).filter((it) => Number(it.current_level || 0) > 0).length} unlocked of {items.length} total
                    </p>
                    {(items || []).map((it) => {
                      const thresholds = parseThresholdLevels(it.thresholds);
                      const currentLevel = Number(it.current_level || 0);
                      const maxLevel = Number(it.max_level || thresholds.length || 1);
                      const unlocked = currentLevel > 0;
                      const cappedLevel = Math.min(currentLevel, maxLevel);
                      const nextTarget = thresholds[cappedLevel] || null;
                      const progress = Number(it.progress || 0);
                      const progressPct = nextTarget ? Math.max(0, Math.min(100, Math.round((progress / nextTarget) * 100))) : 100;
                      return (
                        <div key={it.achievement_id || it.code || it.name} className="fl-continue-card">
                          <div style={{ width: '100%' }}>
                            <div style={{ display: 'flex', justifyContent: 'space-between', gap: '0.75rem', alignItems: 'center' }}>
                              <h3 style={{ margin: 0 }}>
                                {it.icon ? `${it.icon} ` : ''}
                                {stripUnderscoresOnly(it.name) || formatTopicLabel(it.code || 'achievement')}
                              </h3>
                              <span className={`fl-badge ${unlocked ? 'fl-badge-lang' : 'fl-badge-beginner'}`}>
                                {unlocked ? 'Unlocked' : 'Locked'}
                              </span>
                            </div>
                            <p className="fl-auth-sub" style={{ marginTop: '0.35rem' }}>
                              {stripUnderscoresOnly(
                                it.description || 'Complete related learning milestones to unlock this badge.',
                              )}
                            </p>
                            <p className="fl-auth-sub" style={{ marginTop: '0.35rem' }}>
                              Code: {it.code ? formatTopicLabel(it.code) : 'N/A'} · Level {cappedLevel}/{maxLevel} · XP reward:{' '}
                              {Number(it.xp_reward || 0)}
                            </p>
                            {nextTarget ? (
                              <>
                                <div
                                  style={{
                                    marginTop: '0.45rem',
                                    width: '100%',
                                    height: '8px',
                                    borderRadius: '999px',
                                    background: 'rgba(99,102,241,0.15)',
                                    overflow: 'hidden',
                                  }}
                                >
                                  <div
                                    style={{
                                      width: `${progressPct}%`,
                                      height: '100%',
                                      background: unlocked ? 'linear-gradient(90deg,#22c55e,#16a34a)' : 'linear-gradient(90deg,#6366f1,#22c55e)',
                                    }}
                                  />
                                </div>
                                <p className="fl-auth-sub" style={{ marginTop: '0.35rem' }}>
                                  Progress: {progress}/{nextTarget}
                                </p>
                              </>
                            ) : (
                              <p className="fl-auth-sub" style={{ marginTop: '0.35rem' }}>
                                Max level reached.
                              </p>
                            )}
                          </div>
                        </div>
                      );
                    })}
                  </div>
                ) : null}

                {['/dashboard/reminders', '/dashboard/level-adjustments'].includes(path) ? (
                  <div style={{ display: 'grid', gap: '0.75rem' }}>
                    {(items || []).map((it) => (
                      <div key={it.id || `${it.code || it.type || it.title}-${it.sent_at || it.unlocked_at || ''}`} className="fl-continue-card">
                        <div>
                          <h3>
                            {stripUnderscoresOnly(it.title || it.name) ||
                              formatTopicLabel(it.code || it.type || 'record')}
                          </h3>
                          <pre style={{ whiteSpace: 'pre-wrap', marginTop: '0.4rem', fontSize: '0.8rem' }}>
                            {jsonPreview(it)}
                          </pre>
                        </div>
                      </div>
                    ))}
                  </div>
                ) : null}

                {['/dashboard/vocabulary', '/dashboard/grammar', '/dashboard/listening', '/dashboard/conversation', '/dashboard/writing', '/dashboard/achievements', '/dashboard/payments', '/dashboard/reminders', '/dashboard/level-adjustments'].includes(path) &&
                items.length === 0 ? (
                  <div className="fl-continue-card">
                    <div>
                      <h3>No records found</h3>
                      <p>Try another language or add data to this table.</p>
                    </div>
                  </div>
                ) : null}
              </>
            ) : null}
          </>
        )}
      </main>
    </div>
  );
}
