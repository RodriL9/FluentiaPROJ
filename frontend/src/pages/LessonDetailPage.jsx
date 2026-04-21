import { useEffect, useState, useCallback } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { getStoredUser } from '../api/auth';
import { fetchLessonContent, startLesson, submitLessonTest } from '../api/lessons';

const C = {
  bg: '#0f0f14', surface: '#1a1a24', card: '#22222f',
  border: '#2e2e3f', accent: '#7c6af7', accentLight: '#a899ff',
  green: '#4ade80', yellow: '#fbbf24', red: '#f87171',
  text: '#f0eeff', muted: '#8b8aaa', dim: '#3d3d55',
};

const EMOJI_MAP = { boy: '👦', girl: '👧', man: '👨', woman: '👩', child: '👶', house: '🏠', home: '🏠', water: '💧', book: '📚', car: '🚗', dog: '🐕', cat: '🐈', sun: '☀️', apple: '🍎', bread: '🍞', table: '🪑', milk: '🥛', phone: '📱', food: '🍽️', tree: '🌳', fish: '🐟' };
function getEmoji(keyword) { if (!keyword) return '📷'; const k = keyword.toLowerCase(); for (const [key, val] of Object.entries(EMOJI_MAP)) { if (k.includes(key)) return val; } return '📷'; }

const card = { background: C.card, borderRadius: 16, border: `1px solid ${C.border}`, padding: 24 };
const btn = (variant = 'primary') => ({ padding: '10px 20px', borderRadius: 10, border: 'none', cursor: 'pointer', fontFamily: 'inherit', fontWeight: 600, fontSize: 14, transition: 'all 0.15s', background: variant === 'primary' ? C.accent : 'transparent', color: variant === 'primary' ? '#fff' : C.muted, ...(variant !== 'primary' ? { border: `1px solid ${C.border}` } : {}) });

function shuffle(arr) { return [...arr].sort(() => Math.random() - 0.5); }

// ── Mix & Match mini game ─────────────────────────────────────────────────────
function MixMatchRound({ pairs, onComplete }) {
  const [leftOrder] = useState(() => shuffle(pairs.map(p => p.id)));
  const [rightOrder] = useState(() => shuffle(pairs.map(p => p.id)));
  const [matched, setMatched] = useState({});
  const [pick, setPick] = useState(null);
  const [wrongIds, setWrongIds] = useState([]);
  const [feedback, setFeedback] = useState(null);

  const allMatched = Object.keys(matched).length === pairs.length;

  const handleTap = (side, id) => {
    if (matched[id]) return;
    if (!pick) { setPick({ side, id }); return; }
    if (pick.side === side) { setPick({ side, id }); return; }
    if (pick.id === id) {
      setMatched(m => ({ ...m, [id]: true }));
      setFeedback({ kind: 'correct', text: 'Nice match! ✓' });
      setTimeout(() => setFeedback(null), 1500);
      setPick(null);
    } else {
      setWrongIds([pick.id, id]);
      setFeedback({ kind: 'wrong', text: 'Not a pair — try again' });
      setTimeout(() => { setWrongIds([]); setFeedback(null); }, 600);
      setPick(null);
    }
  };

  const cardBtn = (id, side) => {
    const p = pairs.find(x => x.id === id);
    const isMatched = matched[id];
    const isSelected = pick?.id === id && pick?.side === side;
    const isWrong = wrongIds.includes(id);
    return (
      <button key={`${side}-${id}`} onClick={() => handleTap(side, id)} disabled={isMatched}
        style={{ padding: '12px 16px', borderRadius: 12, fontFamily: 'inherit', fontSize: 14, fontWeight: 600, cursor: isMatched ? 'default' : 'pointer', transition: 'all 0.15s', border: `2px solid ${isMatched ? C.green : isWrong ? C.red : isSelected ? C.accent : C.border}`, background: isMatched ? `${C.green}22` : isWrong ? `${C.red}22` : isSelected ? `${C.accent}22` : C.surface, color: isMatched ? C.green : C.text, opacity: isMatched ? 0.7 : 1 }}>
        {side === 'left' ? p?.word : p?.translation}
      </button>
    );
  };

  return (
    <div style={{ ...card, marginTop: 24 }}>
      <h3 style={{ color: C.text, margin: '0 0 6px' }}>🔀 Mix & Match Round</h3>
      <p style={{ color: C.muted, fontSize: 13, marginBottom: 20 }}>Tap a word then tap its translation to match them.</p>
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12 }}>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
          <div style={{ fontSize: 11, fontWeight: 700, color: C.muted, textTransform: 'uppercase', letterSpacing: '0.06em', marginBottom: 4 }}>Words</div>
          {leftOrder.map(id => cardBtn(id, 'left'))}
        </div>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
          <div style={{ fontSize: 11, fontWeight: 700, color: C.muted, textTransform: 'uppercase', letterSpacing: '0.06em', marginBottom: 4 }}>Translations</div>
          {rightOrder.map(id => cardBtn(id, 'right'))}
        </div>
      </div>
      {feedback && (
        <div style={{ marginTop: 16, padding: '10px 16px', borderRadius: 10, background: feedback.kind === 'correct' ? `${C.green}22` : `${C.red}22`, color: feedback.kind === 'correct' ? C.green : C.red, fontWeight: 600, fontSize: 14, textAlign: 'center' }}>
          {feedback.text}
        </div>
      )}
      {allMatched && (
        <div style={{ marginTop: 20, textAlign: 'center' }}>
          <div style={{ color: C.green, fontWeight: 700, fontSize: 16, marginBottom: 12 }}>🎉 All matched!</div>
          <button onClick={onComplete} style={btn()}>Submit Test ✓</button>
        </div>
      )}
    </div>
  );
}

// ── Knowledge Test ────────────────────────────────────────────────────────────
function KnowledgeTest({ lessonNumber, content, lessonTitle, user, onComplete, onRetake }) {
  const [questions, setQuestions] = useState([]);
  const [mixPairs, setMixPairs] = useState([]);
  const [current, setCurrent] = useState(0);
  const [answers, setAnswers] = useState([]);
  const [phase, setPhase] = useState('questions'); // 'questions' | 'mixmatch'
  const [submitted, setSubmitted] = useState(false);
  const [result, setResult] = useState(null);
  const [submitting, setSubmitting] = useState(false);

  useEffect(() => {
    function gen(n, items) {
      if (!items || !items.length) return [];
      const pool = shuffle(items).slice(0, 10);
      return pool.map((item) => {
        if (n === 1) { const right = item.phonetic_es; const wrongs = items.filter(x => x.id !== item.id).sort(() => Math.random() - 0.5).slice(0, 3).map(x => x.phonetic_es); return { prompt: `How is "${item.letter}" pronounced?`, options: shuffle([right, ...wrongs]), correct: right, label: item.letter, section: 'vocabulary' }; }
        if (n === 2) { const right = item.translation; const wrongs = items.filter(x => x.id !== item.id).sort(() => Math.random() - 0.5).slice(0, 3).map(x => x.translation); return { prompt: `What does "${item.word}" mean?`, options: shuffle([right, ...wrongs]), correct: right, label: item.word, section: 'vocabulary' }; }
        if (n === 3) { const right = item.english; const wrongs = items.filter(x => x.id !== item.id).sort(() => Math.random() - 0.5).slice(0, 3).map(x => x.english); return { prompt: `What does "${item.spanish}" mean?`, options: shuffle([right, ...wrongs]), correct: right, label: item.spanish, section: 'grammar' }; }
        if (n === 4) { const right = item.translation; const wrongs = items.filter(x => x.id !== item.id).sort(() => Math.random() - 0.5).slice(0, 3).map(x => x.translation); return { prompt: `What does "${item.phrase}" mean?`, options: shuffle([right, ...wrongs]), correct: right, label: item.phrase, section: 'listening' }; }
        const right = item.english; const wrongs = items.filter(x => x.id !== item.id && x.content_type === item.content_type).sort(() => Math.random() - 0.5).slice(0, 3).map(x => x.english);
        return { prompt: `What does "${item.spanish}" mean?`, options: shuffle([right, ...wrongs.slice(0, 3)]), correct: right, label: item.spanish, section: 'vocabulary' };
      }).filter(Boolean);
    }

    // Generate mix & match pairs from content
    function genPairs(n, items) {
      if (!items || items.length < 3) return [];
      const pool = shuffle(items).slice(0, 5);
      return pool.map((item, i) => {
        if (n === 1) return { id: String(item.id || i), word: item.letter, translation: item.phonetic_es };
        if (n === 2) return { id: String(item.id || i), word: item.word, translation: item.translation };
        if (n === 3) return { id: String(item.id || i), word: item.spanish, translation: item.english };
        if (n === 4) return { id: String(item.id || i), word: item.phrase, translation: item.translation };
        return { id: String(item.id || i), word: item.spanish, translation: item.english };
      }).filter(p => p.word && p.translation);
    }

    const qs = gen(lessonNumber, content);
    setQuestions(qs);
    setAnswers(new Array(qs.length).fill(null));
    setMixPairs(genPairs(lessonNumber, content));
  }, [lessonNumber, content]);

  const handleSubmit = async () => {
    setSubmitting(true);
    try {
      const correct = questions.filter((q, i) => answers[i] === q.correct).length;
      const wrongAnswers = questions.map((q, i) => answers[i] !== q.correct ? { section: q.section, label: q.label, language: user.learningLanguage || 'es' } : null).filter(Boolean);
      const res = await submitLessonTest(lessonNumber, { userId: user.id, correct, total: questions.length, wrongAnswers });
      setResult({ ...res, correct, total: questions.length });
      setSubmitted(true);
      onComplete(res);
    } catch (e) { alert('Could not submit: ' + e.message); }
    finally { setSubmitting(false); }
  };

  if (!questions.length) return <p style={{ color: C.muted }}>Generating questions...</p>;

  // Result screen
  if (submitted && result) {
    return (
      <div style={{ ...card, textAlign: 'center', padding: 40 }}>
        <div style={{ fontSize: 48, marginBottom: 16 }}>{result.passed ? '🎉' : '😔'}</div>
        <h2 style={{ color: C.text, fontSize: 24, fontWeight: 800 }}>{result.passed ? 'You Passed!' : 'Not quite — try again'}</h2>
        <p style={{ color: C.muted, fontSize: 16 }}>{result.correct}/{result.total} correct ({Math.round(result.scorePct)}%)</p>
        {result.passed && result.xpEarned > 0 && (
          <div style={{ marginTop: 16, padding: '12px 24px', borderRadius: 12, background: `${C.green}22`, border: `1px solid ${C.green}44`, display: 'inline-block', color: C.green, fontWeight: 700, fontSize: 18 }}>
            +{result.xpEarned} XP earned! 🏆
          </div>
        )}
        {result.passed && result.xpEarned === 0 && (
          <div style={{ color: C.muted, marginTop: 16, fontSize: 14 }}>You already completed this lesson — no additional XP awarded.</div>
        )}
        {!result.passed && <p style={{ color: C.muted }}>You need 70% to pass.</p>}
        <button onClick={onRetake} style={{ background: 'transparent', border: `1px solid ${C.border}`, borderRadius: 10, padding: '8px 16px', color: C.muted, cursor: 'pointer', fontFamily: 'inherit', fontSize: 13, marginTop: 16 }}>
          Retake test
        </button>
        <div style={{ marginTop: 24, display: 'grid', gap: 8, textAlign: 'left' }}>
          {questions.map((q, i) => {
            const ok = answers[i] === q.correct;
            return (
              <div key={i} style={{ display: 'flex', alignItems: 'center', gap: 10, padding: '8px 12px', borderRadius: 10, background: ok ? `${C.green}11` : `${C.red}11`, border: `1px solid ${ok ? C.green : C.red}33` }}>
                <span style={{ color: ok ? C.green : C.red, fontWeight: 700 }}>{ok ? '✓' : '✗'}</span>
                <span style={{ color: C.muted, fontSize: 13, flex: 1 }}>{q.prompt}</span>
                {!ok && <span style={{ color: C.green, fontSize: 13 }}>→ {q.correct}</span>}
              </div>
            );
          })}
        </div>
      </div>
    );
  }

  // Mix & match phase
  if (phase === 'mixmatch') {
    return (
      <div>
        <div style={{ ...card, background: `${C.accent}11`, border: `1px solid ${C.accent}33`, marginBottom: 16, textAlign: 'center' }}>
          <p style={{ color: C.accentLight, fontWeight: 600, margin: 0 }}>
            Multiple choice done! Now complete the Mix & Match round to submit your test.
          </p>
        </div>
        {mixPairs.length >= 3
          ? <MixMatchRound pairs={mixPairs} onComplete={handleSubmit} />
          : <div style={{ textAlign: 'center', marginTop: 20 }}>
              <button onClick={handleSubmit} disabled={submitting} style={btn()}>
                {submitting ? 'Submitting...' : 'Submit Test ✓'}
              </button>
            </div>
        }
      </div>
    );
  }

  // Multiple choice phase
  const q = questions[current];
  return (
    <div style={card}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 16 }}>
        <h3 style={{ color: C.text, margin: 0 }}>📝 Knowledge Test — {lessonTitle}</h3>
        <span style={{ color: C.muted, fontSize: 13 }}>{current + 1}/{questions.length}</span>
      </div>
      <div style={{ height: 6, borderRadius: 99, background: C.dim, marginBottom: 24 }}>
        <div style={{ width: `${((current + 1) / questions.length) * 100}%`, height: '100%', borderRadius: 99, background: `linear-gradient(90deg, ${C.accent}, ${C.accentLight})` }} />
      </div>
      <p style={{ color: C.text, fontSize: 16, fontWeight: 600, marginBottom: 16 }}>{q.prompt}</p>
      <div style={{ display: 'grid', gap: 10, marginBottom: 24 }}>
        {q.options.map(opt => (
          <button key={opt} onClick={() => { const a = [...answers]; a[current] = opt; setAnswers(a); }}
            style={{ padding: '14px 20px', borderRadius: 12, border: `2px solid ${answers[current] === opt ? C.accent : C.border}`, background: answers[current] === opt ? `${C.accent}22` : C.surface, color: C.text, fontSize: 14, fontWeight: answers[current] === opt ? 600 : 400, cursor: 'pointer', textAlign: 'left', fontFamily: 'inherit', transition: 'all 0.15s' }}>
            {opt}
          </button>
        ))}
      </div>
      <div style={{ display: 'flex', justifyContent: 'space-between' }}>
        <button onClick={() => setCurrent(c => c - 1)} disabled={current === 0} style={{ ...btn('ghost'), opacity: current === 0 ? 0.3 : 1 }}>← Back</button>
        {current < questions.length - 1
          ? <button onClick={() => setCurrent(c => c + 1)} disabled={!answers[current]} style={{ ...btn(), opacity: !answers[current] ? 0.4 : 1 }}>Next →</button>
          : <button onClick={() => setPhase('mixmatch')} disabled={answers.some(a => a === null)} style={{ ...btn(), opacity: answers.some(a => a === null) ? 0.4 : 1 }}>
              Next: Mix & Match →
            </button>
        }
      </div>
    </div>
  );
}

// ── Main LessonDetailPage ─────────────────────────────────────────────────────
export default function LessonDetailPage({ lessonNumber: propNumber }) {
  const { lessonNumber: paramNumber } = useParams();
  const navigate = useNavigate();
  const user = getStoredUser();
  const n = parseInt(propNumber || paramNumber);
  const [lessonData, setLessonData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [idx, setIdx] = useState(0);
  const [tab, setTab] = useState('content');
  const [testResult, setTestResult] = useState(null);
  const [testKey, setTestKey] = useState(0);
  const [phraseFilter, setPhraseFilter] = useState('ALL');
  const [flipped, setFlipped] = useState(false);
  const [xp, setXp] = useState(0);
  const [streak, setStreak] = useState(0);
  const [alreadyPassed, setAlreadyPassed] = useState(false);

  useEffect(() => {
    if (!user?.id || !n) return;
    setLoading(true);
    Promise.all([fetchLessonContent(n, user.id), startLesson(n, user.id)])
      .then(([data]) => setLessonData(data))
      .catch(e => setError(e.message))
      .finally(() => setLoading(false));

    fetch(`/api/lesson-catalog?userId=${encodeURIComponent(user.id)}`)
      .then(r => r.ok ? r.json() : [])
      .then(lessons => {
        const thisLesson = lessons.find(l => l.lesson_number === n);
        if (thisLesson?.passed) setAlreadyPassed(true);
      })
      .catch(() => {});
  }, [n, user?.id]);

  const speak = useCallback((text, fallback) => {
    if (!window.speechSynthesis) return;
    window.speechSynthesis.cancel();
    const utt = new SpeechSynthesisUtterance(String(fallback || text || ''));
    utt.lang = (user?.learningLanguage || 'es') === 'es' ? 'es-ES' : 'en-US';
    utt.rate = 0.9;
    window.speechSynthesis.speak(utt);
  }, [user?.learningLanguage]);

  const content = lessonData?.content || [];
  const filteredContent = n === 4 ? (phraseFilter === 'ALL' ? content : content.filter(i => i.topic_tag === phraseFilter)) : content;
  const total = filteredContent.length;

  if (loading) return <div style={{ color: C.text }}><p style={{ color: C.muted }}>Loading lesson...</p></div>;
  if (error) return <div style={{ color: C.text }}><p style={{ color: C.red }}>{error}</p></div>;

  const { title, level } = lessonData || {};
  const item = filteredContent[idx];

  const renderContent = () => {
    if (!item) return null;
    if (n === 1) return (
      <div style={{ ...card, position: 'relative', minHeight: 220, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center' }}>
        <button onClick={() => speak(item.letter)} style={{ position: 'absolute', top: 16, right: 16, background: 'transparent', border: `1px solid ${C.border}`, borderRadius: 8, padding: '6px 10px', fontSize: 18, cursor: 'pointer', color: C.muted }}>🔊</button>
        <div style={{ fontSize: 96, fontWeight: 900, color: C.accentLight, lineHeight: 1 }}>{item.letter}</div>
        <div style={{ fontSize: 22, color: C.muted, marginTop: 8 }}>({item.phonetic_es})</div>
        {item.phonetic_en && !item.phonetic_en.includes('n/a') && <div style={{ fontSize: 14, color: C.dim, marginTop: 4 }}>English: {item.phonetic_en}</div>}
        <button onClick={() => setIdx(i => Math.min(i + 1, total - 1))} disabled={idx >= total - 1} style={{ ...btn(), position: 'absolute', bottom: 16, right: 16, opacity: idx >= total - 1 ? 0.4 : 1 }}>next →</button>
      </div>
    );
    if (n === 2) return (
      <div style={{ ...card, display: 'flex', alignItems: 'center', gap: 32, position: 'relative', minHeight: 200 }}>
        <button onClick={() => speak(item.word, item.audio_text)} style={{ position: 'absolute', top: 16, right: 16, background: 'transparent', border: `1px solid ${C.border}`, borderRadius: 8, padding: '6px 10px', fontSize: 18, cursor: 'pointer', color: C.muted }}>🔊</button>
        <div style={{ fontSize: 72, background: C.dim, borderRadius: 16, padding: 16, flexShrink: 0 }}>{getEmoji(item.image_keyword || item.word)}</div>
        <div>
          <div style={{ fontSize: 52, fontWeight: 900, color: C.text }}>{item.word}</div>
          <div style={{ fontSize: 18, color: C.muted, marginTop: 4 }}>({item.translation})</div>
          <div style={{ display: 'flex', gap: 8, marginTop: 12, flexWrap: 'wrap' }}>
            {item.gender && <span style={{ padding: '4px 12px', borderRadius: 20, fontSize: 12, fontWeight: 600, background: item.gender === 'masculine' ? `${C.accentLight}22` : '#f472b622', color: item.gender === 'masculine' ? C.accentLight : '#f472b6', border: `1px solid ${item.gender === 'masculine' ? C.accentLight : '#f472b6'}44` }}>{item.gender === 'masculine' ? 'masculine (el)' : 'feminine (la)'}</span>}
            {item.part_of_speech && <span style={{ padding: '4px 12px', borderRadius: 20, fontSize: 12, fontWeight: 600, background: `${C.yellow}22`, color: C.yellow, border: `1px solid ${C.yellow}44` }}>{item.part_of_speech}</span>}
          </div>
        </div>
        <button onClick={() => setIdx(i => Math.min(i + 1, total - 1))} disabled={idx >= total - 1} style={{ ...btn(), position: 'absolute', bottom: 16, right: 16, opacity: idx >= total - 1 ? 0.4 : 1 }}>next →</button>
      </div>
    );
    if (n === 3) {
      const words = Array.isArray(item.words) ? item.words : [];
      return (
        <div style={{ ...card, position: 'relative' }}>
          <button onClick={() => speak(item.spanish)} style={{ position: 'absolute', top: 16, right: 16, background: 'transparent', border: `1px solid ${C.border}`, borderRadius: 8, padding: '6px 10px', fontSize: 18, cursor: 'pointer', color: C.muted }}>🔊</button>
          <div style={{ fontSize: 36, fontWeight: 800, textAlign: 'center', marginBottom: 24, color: C.text }}>{item.spanish}</div>
          {words.length > 0 && (
            <div style={{ display: 'grid', gridTemplateColumns: `repeat(${words.length}, 1fr)`, gap: 2, marginBottom: 20 }}>
              {words.map(w => <div key={w.id + 'w'} style={{ background: C.accent, borderRadius: '8px 8px 0 0', padding: '10px 8px', textAlign: 'center', fontSize: 16, fontWeight: 800, color: '#fff' }}>{w.word}</div>)}
              {words.map(w => <div key={w.id + 'r'} style={{ background: C.dim, padding: '8px 6px', textAlign: 'center', fontSize: 12, fontWeight: 700, color: C.accentLight }}>{w.grammar_role}</div>)}
              {words.map(w => <div key={w.id + 't'} style={{ background: C.surface, padding: '8px 6px', textAlign: 'center', fontSize: 13, color: C.text }}>{w.translation}</div>)}
              {words.map(w => <div key={w.id + 'n'} style={{ background: C.card, borderRadius: '0 0 8px 8px', padding: '8px 6px', textAlign: 'center', fontSize: 11, color: C.muted, fontStyle: 'italic' }}>{w.grammar_note}</div>)}
            </div>
          )}
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <button onClick={() => setFlipped(f => !f)} style={{ ...btn('ghost'), fontSize: 13 }}>{flipped ? '🇪🇸 Show Spanish' : `🔄 Flip — ${item.english}`}</button>
            <button onClick={() => { setIdx(i => Math.min(i + 1, total - 1)); setFlipped(false); }} disabled={idx >= total - 1} style={{ ...btn(), opacity: idx >= total - 1 ? 0.4 : 1 }}>next →</button>
          </div>
        </div>
      );
    }
    if (n === 4) {
      const topics = ['ALL', ...new Set(content.map(i => i.topic_tag).filter(Boolean))];
      const wordParts = item.phrase.replace(/[¿?¡!]/g, '').trim().split(' ');
      const transParts = item.translation.split(' ');
      return (
        <div>
          <div style={{ display: 'flex', gap: 8, marginBottom: 16, flexWrap: 'wrap' }}>
            {topics.slice(0, 5).map(t => <button key={t} onClick={() => { setPhraseFilter(t); setIdx(0); }} style={{ padding: '6px 14px', borderRadius: 20, border: 'none', cursor: 'pointer', fontFamily: 'inherit', fontSize: 12, fontWeight: 600, background: phraseFilter === t ? C.accent : C.dim, color: phraseFilter === t ? '#fff' : C.muted }}>{t === 'ALL' ? 'All' : t.replace(/_ES|_EN/, '').replace(/_/g, ' ')}</button>)}
          </div>
          <div style={{ ...card, position: 'relative', minHeight: 200 }}>
            <button onClick={() => speak(item.phrase, item.audio_text)} style={{ position: 'absolute', top: 16, right: 16, background: 'transparent', border: `1px solid ${C.border}`, borderRadius: 8, padding: '6px 10px', fontSize: 18, cursor: 'pointer', color: C.muted }}>🔊</button>
            <div style={{ display: 'flex', alignItems: 'center', gap: 20, marginBottom: 20 }}>
              <div style={{ fontSize: 48, background: C.dim, borderRadius: 16, padding: 12 }}>💬</div>
              <div>
                {item.context && <div style={{ fontSize: 11, color: C.accent, fontWeight: 700, marginBottom: 4, textTransform: 'uppercase', letterSpacing: '0.06em' }}>{item.context}</div>}
                <div style={{ fontSize: 28, fontWeight: 800, color: C.text }}>{item.phrase}</div>
                <div style={{ fontSize: 16, color: C.muted, marginTop: 6 }}>{item.translation}</div>
              </div>
            </div>
            <div style={{ borderTop: `1px solid ${C.border}`, paddingTop: 16 }}>
              <div style={{ fontSize: 12, color: C.muted, marginBottom: 10 }}>Word breakdown</div>
              <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
                {wordParts.map((w, i) => <div key={i} style={{ background: C.dim, borderRadius: 10, padding: '8px 14px', textAlign: 'center' }}><div style={{ fontSize: 15, fontWeight: 700, color: C.accentLight }}>{w}</div><div style={{ fontSize: 11, color: C.muted, marginTop: 2 }}>{transParts[i] ?? '—'}</div></div>)}
              </div>
            </div>
            <button onClick={() => setIdx(i => Math.min(i + 1, total - 1))} disabled={idx >= total - 1} style={{ ...btn(), position: 'absolute', bottom: 16, right: 16, opacity: idx >= total - 1 ? 0.4 : 1 }}>next →</button>
          </div>
        </div>
      );
    }
    return (
      <div style={{ ...card, position: 'relative', minHeight: 180, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center' }}>
        <button onClick={() => speak(item.spanish)} style={{ position: 'absolute', top: 16, right: 16, background: 'transparent', border: `1px solid ${C.border}`, borderRadius: 8, padding: '6px 10px', fontSize: 18, cursor: 'pointer', color: C.muted }}>🔊</button>
        {item.content_type && <div style={{ fontSize: 11, color: C.accent, fontWeight: 700, textTransform: 'uppercase', letterSpacing: '0.06em', marginBottom: 8 }}>{item.content_type === 'number' ? 'Number' : item.category || 'Expression'}</div>}
        {item.numeral && <div style={{ fontSize: 22, color: C.yellow, fontWeight: 700, marginBottom: 4 }}>{item.numeral}</div>}
        <div style={{ fontSize: 52, fontWeight: 900, color: C.text }}>{item.spanish}</div>
        <div style={{ fontSize: 20, color: C.muted, marginTop: 8 }}>({item.english})</div>
        {item.category && !item.content_type && <div style={{ fontSize: 13, color: C.dim, marginTop: 6 }}>{item.category}</div>}
        <div style={{ display: 'flex', gap: 8, marginTop: 20 }}>
          <button onClick={() => setIdx(i => Math.max(0, i - 1))} disabled={idx === 0} style={{ ...btn('ghost'), opacity: idx === 0 ? 0.3 : 1 }}>← Prev</button>
          <button onClick={() => setIdx(i => Math.min(i + 1, total - 1))} disabled={idx >= total - 1} style={{ ...btn(), opacity: idx >= total - 1 ? 0.4 : 1 }}>next →</button>
        </div>
      </div>
    );
  };

  return (
    <div style={{ fontFamily: "'DM Sans', sans-serif", color: C.text }}>
      <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;600;700;800;900&display=swap" rel="stylesheet" />
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 4 }}>
        <div>
          <h1 style={{ fontSize: 28, fontWeight: 800, margin: 0, letterSpacing: '-0.5px' }}>Lesson {n} — {title}</h1>
          <div style={{ fontSize: 12, color: C.green, fontWeight: 700, marginTop: 4, textTransform: 'uppercase', letterSpacing: '0.06em' }}>{level}</div>
        </div>
        {tab === 'content' && <div style={{ fontSize: 14, color: C.muted, fontWeight: 600 }}>{idx + 1}/{total}</div>}
      </div>
      <button onClick={() => navigate('/dashboard/lessons')} style={{ ...btn('ghost'), marginBottom: 20, marginTop: 8, fontSize: 13 }}>← Back to Lessons</button>
      <div style={{ display: 'flex', gap: 8, marginBottom: 20 }}>
        <button onClick={() => setTab('content')} style={{ ...btn(tab === 'content' ? 'primary' : 'ghost'), fontSize: 13 }}>📖 Lesson Content</button>
        {(idx >= total - 1 || alreadyPassed) && (
          <button onClick={() => setTab('test')} style={{ ...btn(tab === 'test' ? 'primary' : 'ghost'), fontSize: 13 }}>
            📝 Knowledge Test {(testResult?.passed || alreadyPassed) ? '✓' : ''}
          </button>
        )}
      </div>
      {tab === 'content' && (
        <>
          {renderContent()}
          {idx >= total - 1 && (
            <div style={{ ...card, marginTop: 20, display: 'flex', alignItems: 'center', justifyContent: 'space-between', background: `${C.accent}18`, border: `1px solid ${C.accent}55` }}>
              <div>
                <div style={{ fontSize: 15, fontWeight: 700 }}>📝 {title} Knowledge Test</div>
                <div style={{ fontSize: 12, color: C.muted, marginTop: 4 }}>7/10 to pass • +100 XP • includes Mix & Match</div>
              </div>
              <button onClick={() => setTab('test')} style={btn()}>Begin</button>
            </div>
          )}
        </>
      )}
      {tab === 'test' && (
        <KnowledgeTest
          key={testKey}
          lessonNumber={n}
          content={content}
          lessonTitle={title}
          user={user}
          onComplete={res => { setTestResult(res); if (res.passed && res.xpEarned > 0) setXp(v => v + res.xpEarned); }}
          onRetake={() => { setTestKey(k => k + 1); setTestResult(null); }}
        />
      )}
    </div>
  );
}