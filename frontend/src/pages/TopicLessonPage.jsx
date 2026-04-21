import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { getStoredUser } from '../api/auth';

const C = {
  bg: '#0f0f14', surface: '#1a1a24', card: '#22222f',
  border: '#2e2e3f', accent: '#7c6af7', accentLight: '#a899ff',
  green: '#4ade80', yellow: '#fbbf24', red: '#f87171',
  text: '#f0eeff', muted: '#8b8aaa', dim: '#3d3d55',
};

const card = { background: C.card, borderRadius: 16, border: `1px solid ${C.border}`, padding: 24 };
const btn = (v = 'primary') => ({
  padding: '10px 20px', borderRadius: 10, border: 'none', cursor: 'pointer',
  fontFamily: 'inherit', fontWeight: 600, fontSize: 14, transition: 'all 0.15s',
  background: v === 'primary' ? C.accent : 'transparent',
  color: v === 'primary' ? '#fff' : C.muted,
  ...(v !== 'primary' ? { border: `1px solid ${C.border}` } : {}),
});

function shuffle(arr) { return [...arr].sort(() => Math.random() - 0.5); }

function parseOptions(options) {
  if (!options) return null;
  try { return typeof options === 'string' ? JSON.parse(options) : options; } catch { return null; }
}

// ── Exercise renderers ────────────────────────────────────────────────────────

function ImagePick({ exercise, onAnswer }) {
  const [selected, setSelected] = useState(null);
  const [submitted, setSubmitted] = useState(false);
  const opts = parseOptions(exercise.options);
  const choices = opts?.choices || [];

  const submit = (val) => {
    if (submitted) return;
    setSelected(val);
    setSubmitted(true);
    setTimeout(() => onAnswer(val === exercise.correct_answer, val), 900);
  };

  return (
    <div style={card}>
      <p style={{ color: C.text, fontSize: 16, fontWeight: 600, marginBottom: 20 }}>{exercise.prompt}</p>
      <div style={{ display: 'flex', gap: 12, flexWrap: 'wrap', justifyContent: 'center' }}>
        {choices.map(c => {
          const isCorrect = c.value === exercise.correct_answer;
          const isSelected = selected === c.value;
          return (
            <button key={c.value} onClick={() => submit(c.value)} disabled={submitted}
              style={{ padding: '20px 24px', borderRadius: 14, border: `2px solid ${submitted ? (isCorrect ? C.green : isSelected ? C.red : C.border) : C.border}`, background: submitted ? (isCorrect ? `${C.green}22` : isSelected ? `${C.red}22` : C.surface) : C.surface, cursor: submitted ? 'default' : 'pointer', fontFamily: 'inherit', fontSize: 15, fontWeight: 600, color: C.text, minWidth: 120, textAlign: 'center' }}>
              <div style={{ fontSize: 28, marginBottom: 6 }}>{c.label.split(' ')[0]}</div>
              <div>{c.label.split(' ').slice(1).join(' ')}</div>
            </button>
          );
        })}
      </div>
      {submitted && (
        <div style={{ marginTop: 16, textAlign: 'center', color: selected === exercise.correct_answer ? C.green : C.red, fontWeight: 700 }}>
          {selected === exercise.correct_answer ? '✓ Correct!' : `✗ Correct answer: ${exercise.correct_answer}`}
        </div>
      )}
    </div>
  );
}

function FillBlank({ exercise, onAnswer }) {
  const [selected, setSelected] = useState(null);
  const [submitted, setSubmitted] = useState(false);
  const opts = parseOptions(exercise.options);
  const choices = opts?.choices || [];

  const submit = (val) => {
    if (submitted) return;
    setSelected(val);
    setSubmitted(true);
    setTimeout(() => onAnswer(val === exercise.correct_answer, val), 900);
  };

  return (
    <div style={card}>
      <p style={{ color: C.text, fontSize: 16, fontWeight: 600, marginBottom: 20 }}>{exercise.prompt}</p>
      <div style={{ display: 'grid', gap: 10 }}>
        {choices.map(c => {
          const isCorrect = c === exercise.correct_answer;
          const isSelected = selected === c;
          return (
            <button key={c} onClick={() => submit(c)} disabled={submitted}
              style={{ padding: '14px 20px', borderRadius: 12, border: `2px solid ${submitted ? (isCorrect ? C.green : isSelected ? C.red : C.border) : isSelected ? C.accent : C.border}`, background: submitted ? (isCorrect ? `${C.green}22` : isSelected ? `${C.red}22` : C.surface) : isSelected ? `${C.accent}22` : C.surface, cursor: submitted ? 'default' : 'pointer', fontFamily: 'inherit', fontSize: 14, fontWeight: 500, color: C.text, textAlign: 'left' }}>
              {c}
            </button>
          );
        })}
      </div>
      {submitted && (
        <div style={{ marginTop: 12, color: selected === exercise.correct_answer ? C.green : C.red, fontWeight: 700 }}>
          {selected === exercise.correct_answer ? '✓ Correct!' : `✗ Correct answer: ${exercise.correct_answer}`}
        </div>
      )}
    </div>
  );
}

function WordBank({ exercise, onAnswer }) {
  const opts = parseOptions(exercise.options);
  const wordBank = shuffle(opts?.word_bank || []);
  const [selected, setSelected] = useState([]);
  const [submitted, setSubmitted] = useState(false);

  const tap = (word, fromSelected) => {
    if (submitted) return;
    if (fromSelected) setSelected(prev => prev.filter((_, i) => i !== prev.lastIndexOf(word)));
    else setSelected(prev => [...prev, word]);
  };

  const submit = () => {
    if (submitted || !selected.length) return;
    setSubmitted(true);
    const answer = selected.join(' ');
    const correct = answer.trim().toLowerCase() === exercise.correct_answer.trim().toLowerCase();
    setTimeout(() => onAnswer(correct, answer), 900);
  };

  const remaining = wordBank.filter(w => {
    const usedCount = selected.filter(s => s === w).length;
    const bankCount = wordBank.filter(b => b === w).length;
    return usedCount < bankCount;
  });

  return (
    <div style={card}>
      <p style={{ color: C.text, fontSize: 16, fontWeight: 600, marginBottom: 20 }}>{exercise.prompt}</p>
      <div style={{ minHeight: 52, background: C.surface, borderRadius: 12, border: `1px solid ${C.border}`, padding: '10px 14px', marginBottom: 16, display: 'flex', flexWrap: 'wrap', gap: 8, alignItems: 'center' }}>
        {selected.length === 0 && <span style={{ color: C.muted, fontSize: 13 }}>Tap words below to build your answer</span>}
        {selected.map((w, i) => (
          <button key={i} onClick={() => tap(w, true)} disabled={submitted}
            style={{ padding: '6px 12px', borderRadius: 8, border: `1px solid ${C.accent}`, background: `${C.accent}22`, color: C.accentLight, fontSize: 13, fontWeight: 600, cursor: 'pointer', fontFamily: 'inherit' }}>
            {w}
          </button>
        ))}
      </div>
      <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8, marginBottom: 16 }}>
        {remaining.map((w, i) => (
          <button key={i} onClick={() => tap(w, false)} disabled={submitted}
            style={{ padding: '6px 12px', borderRadius: 8, border: `1px solid ${C.border}`, background: C.dim, color: C.text, fontSize: 13, fontWeight: 500, cursor: 'pointer', fontFamily: 'inherit' }}>
            {w}
          </button>
        ))}
      </div>
      {!submitted && (
        <button onClick={submit} disabled={!selected.length} style={{ ...btn(), opacity: !selected.length ? 0.4 : 1 }}>Check Answer</button>
      )}
      {submitted && (
        <div style={{ color: selected.join(' ').trim().toLowerCase() === exercise.correct_answer.trim().toLowerCase() ? C.green : C.red, fontWeight: 700, marginTop: 8 }}>
          {selected.join(' ').trim().toLowerCase() === exercise.correct_answer.trim().toLowerCase() ? '✓ Correct!' : `✗ Correct: ${exercise.correct_answer}`}
        </div>
      )}
    </div>
  );
}

function FreeWrite({ exercise, onAnswer }) {
  const [value, setValue] = useState('');
  const [submitted, setSubmitted] = useState(false);
  const [correct, setCorrect] = useState(false);

  const submit = () => {
    if (submitted || !value.trim()) return;
    const isCorrect = value.trim().toLowerCase() === exercise.correct_answer.trim().toLowerCase();
    setCorrect(isCorrect);
    setSubmitted(true);
    setTimeout(() => onAnswer(isCorrect, value), 900);
  };

  return (
    <div style={card}>
      <p style={{ color: C.text, fontSize: 16, fontWeight: 600, marginBottom: 20 }}>{exercise.prompt}</p>
      <input value={value} onChange={e => setValue(e.target.value)} onKeyDown={e => e.key === 'Enter' && submit()} disabled={submitted}
        placeholder="Type your answer..." style={{ width: '100%', background: C.surface, border: `1px solid ${submitted ? (correct ? C.green : C.red) : C.border}`, borderRadius: 10, padding: '12px 16px', color: C.text, fontSize: 14, fontFamily: 'inherit', outline: 'none', boxSizing: 'border-box', marginBottom: 12 }} />
      {!submitted && <button onClick={submit} disabled={!value.trim()} style={{ ...btn(), opacity: !value.trim() ? 0.4 : 1 }}>Check</button>}
      {submitted && (
        <div style={{ color: correct ? C.green : C.red, fontWeight: 700 }}>
          {correct ? '✓ Correct!' : `✗ Correct answer: ${exercise.correct_answer}`}
        </div>
      )}
      {exercise.hint && !submitted && <p style={{ color: C.muted, fontSize: 12, marginTop: 8 }}>Hint: {exercise.hint}</p>}
    </div>
  );
}

function AudioTap({ exercise, onAnswer }) {
  const opts = parseOptions(exercise.options);
  const wordBank = shuffle(opts?.word_bank || []);
  const [selected, setSelected] = useState([]);
  const [submitted, setSubmitted] = useState(false);
  const [played, setPlayed] = useState(false);

  const speak = () => {
    if (!window.speechSynthesis) return;
    window.speechSynthesis.cancel();
    const utt = new SpeechSynthesisUtterance(exercise.correct_answer);
    utt.lang = 'es-ES'; utt.rate = 0.85;
    window.speechSynthesis.speak(utt);
    setPlayed(true);
  };

  const tap = (word) => {
    if (submitted) return;
    setSelected(prev => [...prev, word]);
  };

  const submit = () => {
    if (submitted || !selected.length) return;
    setSubmitted(true);
    const answer = selected.join(' ');
    const correct = answer.trim().toLowerCase() === exercise.correct_answer.trim().toLowerCase();
    setTimeout(() => onAnswer(correct, answer), 900);
  };

  return (
    <div style={card}>
      <p style={{ color: C.text, fontSize: 16, fontWeight: 600, marginBottom: 16 }}>{exercise.prompt}</p>
      <button onClick={speak} style={{ ...btn('ghost'), marginBottom: 20, fontSize: 15 }}>🔊 Play Audio {played ? '(again)' : ''}</button>
      <div style={{ minHeight: 52, background: C.surface, borderRadius: 12, border: `1px solid ${C.border}`, padding: '10px 14px', marginBottom: 16, display: 'flex', flexWrap: 'wrap', gap: 8 }}>
        {selected.length === 0 && <span style={{ color: C.muted, fontSize: 13 }}>Tap words in the correct order</span>}
        {selected.map((w, i) => <span key={i} style={{ padding: '4px 10px', borderRadius: 8, background: `${C.accent}22`, color: C.accentLight, fontSize: 13, fontWeight: 600 }}>{w}</span>)}
      </div>
      <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8, marginBottom: 16 }}>
        {wordBank.map((w, i) => (
          <button key={i} onClick={() => tap(w)} disabled={submitted}
            style={{ padding: '6px 12px', borderRadius: 8, border: `1px solid ${C.border}`, background: C.dim, color: C.text, fontSize: 13, cursor: 'pointer', fontFamily: 'inherit' }}>
            {w}
          </button>
        ))}
      </div>
      {!submitted && <button onClick={submit} disabled={!selected.length} style={{ ...btn(), opacity: !selected.length ? 0.4 : 1 }}>Check</button>}
      {submitted && (
        <div style={{ color: selected.join(' ').trim().toLowerCase() === exercise.correct_answer.trim().toLowerCase() ? C.green : C.red, fontWeight: 700 }}>
          {selected.join(' ').trim().toLowerCase() === exercise.correct_answer.trim().toLowerCase() ? '✓ Correct!' : `✗ Correct: ${exercise.correct_answer}`}
        </div>
      )}
    </div>
  );
}

function ReadingComprehension({ exercise, onAnswer }) {
  const opts = parseOptions(exercise.options);
  const choices = opts?.choices || [];
  const [selected, setSelected] = useState(null);
  const [submitted, setSubmitted] = useState(false);

  const submit = (val) => {
    if (submitted) return;
    setSelected(val);
    setSubmitted(true);
    setTimeout(() => onAnswer(val === exercise.correct_answer, val), 900);
  };

  return (
    <div style={card}>
      <p style={{ color: C.text, fontSize: 15, marginBottom: 16, lineHeight: 1.6 }}>{exercise.prompt}</p>
      <div style={{ display: 'grid', gap: 10 }}>
        {choices.map(c => {
          const isCorrect = c === exercise.correct_answer;
          const isSelected = selected === c;
          return (
            <button key={c} onClick={() => submit(c)} disabled={submitted}
              style={{ padding: '12px 16px', borderRadius: 12, border: `2px solid ${submitted ? (isCorrect ? C.green : isSelected ? C.red : C.border) : C.border}`, background: submitted ? (isCorrect ? `${C.green}22` : isSelected ? `${C.red}22` : C.surface) : C.surface, cursor: 'pointer', fontFamily: 'inherit', fontSize: 14, color: C.text, textAlign: 'left' }}>
              {c}
            </button>
          );
        })}
      </div>
      {submitted && (
        <div style={{ marginTop: 12, color: selected === exercise.correct_answer ? C.green : C.red, fontWeight: 700 }}>
          {selected === exercise.correct_answer ? '✓ Correct!' : `✗ Correct: ${exercise.correct_answer}`}
        </div>
      )}
    </div>
  );
}

function Speaking({ exercise, onAnswer }) {
  const [listening, setListening] = useState(false);
  const [done, setDone] = useState(false);

  const speak = () => {
    if (!window.speechSynthesis) return;
    window.speechSynthesis.cancel();
    const utt = new SpeechSynthesisUtterance(exercise.correct_answer);
    utt.lang = 'es-ES'; utt.rate = 0.85;
    window.speechSynthesis.speak(utt);
  };

  const markDone = () => {
    setDone(true);
    onAnswer(true, exercise.correct_answer);
  };

  return (
    <div style={{ ...card, textAlign: 'center' }}>
      <p style={{ color: C.muted, fontSize: 13, marginBottom: 8 }}>Say this out loud:</p>
      <div style={{ fontSize: 24, fontWeight: 800, color: C.text, marginBottom: 20 }}>{exercise.correct_answer}</div>
      <p style={{ color: C.muted, fontSize: 13, marginBottom: 16 }}>{exercise.prompt}</p>
      <div style={{ display: 'flex', gap: 12, justifyContent: 'center' }}>
        <button onClick={speak} style={btn('ghost')}>🔊 Hear it</button>
        {!done && <button onClick={markDone} style={btn()}>✓ I said it</button>}
        {done && <div style={{ color: C.green, fontWeight: 700 }}>✓ Great job!</div>}
      </div>
    </div>
  );
}

// ── Knowledge Test ────────────────────────────────────────────────────────────
function KnowledgeTest({ exercises, lessonTitle, onComplete, onRetake }) {
  const questions = exercises.slice(0, 5).map(ex => ({
    prompt: ex.prompt,
    correct: ex.correct_answer,
    options: (() => {
      const opts = parseOptions(ex.options);
      if (opts?.choices && Array.isArray(opts.choices)) {
        return shuffle(opts.choices.map(c => typeof c === 'string' ? c : c.value || c.label)).slice(0, 4);
      }
      return shuffle([ex.correct_answer, 'Not sure', 'I don\'t know', 'None of the above']);
    })(),
  }));

  const [current, setCurrent] = useState(0);
  const [answers, setAnswers] = useState(new Array(questions.length).fill(null));
  const [submitted, setSubmitted] = useState(false);

  const submit = () => {
    setSubmitted(true);
    const correct = questions.filter((q, i) => answers[i]?.toLowerCase() === q.correct?.toLowerCase()).length;
    const passed = (correct / questions.length) >= 0.7;
    onComplete({ passed, correct, total: questions.length });
  };

  if (submitted) {
    const correct = questions.filter((q, i) => answers[i]?.toLowerCase() === q.correct?.toLowerCase()).length;
    const passed = (correct / questions.length) >= 0.7;
    return (
      <div style={{ ...card, textAlign: 'center', padding: 40 }}>
        <div style={{ fontSize: 48, marginBottom: 16 }}>{passed ? '🎉' : '😔'}</div>
        <h2 style={{ color: C.text, fontSize: 24, fontWeight: 800 }}>{passed ? 'You Passed!' : 'Not quite — try again'}</h2>
        <p style={{ color: C.muted }}>{correct}/{questions.length} correct</p>
        {!passed && <p style={{ color: C.muted }}>You need 70% to pass.</p>}
        <button onClick={onRetake} style={{ ...btn('ghost'), marginTop: 16 }}>Retake</button>
      </div>
    );
  }

  const q = questions[current];
  return (
    <div style={card}>
      <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 16 }}>
        <h3 style={{ color: C.text, margin: 0 }}>📝 Knowledge Test — {lessonTitle}</h3>
        <span style={{ color: C.muted, fontSize: 13 }}>{current + 1}/{questions.length}</span>
      </div>
      <div style={{ height: 6, borderRadius: 99, background: C.dim, marginBottom: 20 }}>
        <div style={{ width: `${((current + 1) / questions.length) * 100}%`, height: '100%', borderRadius: 99, background: `linear-gradient(90deg, ${C.accent}, ${C.accentLight})` }} />
      </div>
      <p style={{ color: C.text, fontSize: 15, fontWeight: 600, marginBottom: 16 }}>{q.prompt}</p>
      <div style={{ display: 'grid', gap: 10, marginBottom: 20 }}>
        {q.options.map(opt => (
          <button key={opt} onClick={() => { const a = [...answers]; a[current] = opt; setAnswers(a); }}
            style={{ padding: '12px 16px', borderRadius: 12, border: `2px solid ${answers[current] === opt ? C.accent : C.border}`, background: answers[current] === opt ? `${C.accent}22` : C.surface, color: C.text, fontSize: 14, cursor: 'pointer', textAlign: 'left', fontFamily: 'inherit', fontWeight: answers[current] === opt ? 600 : 400 }}>
            {opt}
          </button>
        ))}
      </div>
      <div style={{ display: 'flex', justifyContent: 'space-between' }}>
        <button onClick={() => setCurrent(c => c - 1)} disabled={current === 0} style={{ ...btn('ghost'), opacity: current === 0 ? 0.3 : 1 }}>← Back</button>
        {current < questions.length - 1
          ? <button onClick={() => setCurrent(c => c + 1)} disabled={!answers[current]} style={{ ...btn(), opacity: !answers[current] ? 0.4 : 1 }}>Next →</button>
          : <button onClick={submit} disabled={answers.some(a => a === null)} style={{ ...btn(), opacity: answers.some(a => a === null) ? 0.4 : 1 }}>Submit ✓</button>
        }
      </div>
    </div>
  );
}

// ── Main TopicLessonPage ──────────────────────────────────────────────────────
export default function TopicLessonPage({ lessonId, lessonTitle, onBack }) {
  const user = getStoredUser();
  const [exercises, setExercises] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [current, setCurrent] = useState(0);
  const [results, setResults] = useState([]);
  const [tab, setTab] = useState('content');
  const [testKey, setTestKey] = useState(0);
  const [testResult, setTestResult] = useState(null);

  useEffect(() => {
    if (!lessonId) return;
    setLoading(true);
    fetch(`/api/lessons/${lessonId}/exercises`)
      .then(r => r.ok ? r.json() : [])
      .then(data => setExercises(Array.isArray(data) ? data : []))
      .catch(e => setError(e.message))
      .finally(() => setLoading(false));
  }, [lessonId]);

  const handleAnswer = (correct, answer) => {
    setResults(prev => [...prev, { correct, answer, exerciseId: exercises[current]?.id }]);
    setTimeout(() => {
      if (current < exercises.length - 1) {
        setCurrent(c => c + 1);
      }
    }, 600);
  };

  const renderExercise = (ex) => {
    const props = { exercise: ex, onAnswer: handleAnswer };
    switch (ex.exercise_type) {
      case 'IMAGE_PICK': return <ImagePick {...props} />;
      case 'FILL_BLANK': return <FillBlank {...props} />;
      case 'WORD_BANK': return <WordBank {...props} />;
      case 'FREE_WRITE': return <FreeWrite {...props} />;
      case 'AUDIO_TAP': return <AudioTap {...props} />;
      case 'READING_COMPREHENSION': return <ReadingComprehension {...props} />;
      case 'SPEAKING': return <Speaking {...props} />;
      default: return <p style={{ color: C.muted }}>Unknown exercise type: {ex.exercise_type}</p>;
    }
  };

  const atEnd = current >= exercises.length - 1 && results.length >= exercises.length - 1;

  if (loading) return <p style={{ color: C.muted }}>Loading lesson...</p>;
  if (error) return <p style={{ color: C.red }}>{error}</p>;
  if (!exercises.length) return <p style={{ color: C.muted }}>No exercises found for this lesson.</p>;

  return (
    <div style={{ fontFamily: "'DM Sans', sans-serif", color: C.text }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 4 }}>
        <h2 style={{ fontSize: 22, fontWeight: 800, margin: 0 }}>{lessonTitle}</h2>
        {tab === 'content' && <span style={{ color: C.muted, fontSize: 13 }}>{current + 1}/{exercises.length}</span>}
      </div>
      <button onClick={onBack} style={{ ...btn('ghost'), fontSize: 13, marginBottom: 16, marginTop: 4 }}>← Back to Topics</button>

      {/* Tabs */}
      <div style={{ display: 'flex', gap: 8, marginBottom: 20 }}>
        <button onClick={() => setTab('content')} style={{ ...btn(tab === 'content' ? 'primary' : 'ghost'), fontSize: 13 }}>📖 Lesson</button>
        {(atEnd || testResult) && (
          <button onClick={() => setTab('test')} style={{ ...btn(tab === 'test' ? 'primary' : 'ghost'), fontSize: 13 }}>
            📝 Knowledge Test {testResult?.passed ? '✓' : ''}
          </button>
        )}
      </div>

      {/* Progress bar */}
      {tab === 'content' && (
        <div style={{ height: 6, borderRadius: 99, background: C.dim, marginBottom: 20 }}>
          <div style={{ width: `${((current + 1) / exercises.length) * 100}%`, height: '100%', borderRadius: 99, background: `linear-gradient(90deg, ${C.accent}, ${C.accentLight})`, transition: 'width 0.3s' }} />
        </div>
      )}

      {tab === 'content' && renderExercise(exercises[current])}

      {tab === 'content' && atEnd && (
        <div style={{ ...card, marginTop: 20, display: 'flex', alignItems: 'center', justifyContent: 'space-between', background: `${C.accent}18`, border: `1px solid ${C.accent}55` }}>
          <div>
            <div style={{ fontSize: 15, fontWeight: 700 }}>📝 {lessonTitle} Knowledge Test</div>
            <div style={{ fontSize: 12, color: C.muted, marginTop: 4 }}>7/10 to pass</div>
          </div>
          <button onClick={() => setTab('test')} style={btn()}>Begin</button>
        </div>
      )}

      {tab === 'test' && (
        <KnowledgeTest
          key={testKey}
          exercises={exercises}
          lessonTitle={lessonTitle}
          onComplete={res => setTestResult(res)}
          onRetake={() => { setTestKey(k => k + 1); setTestResult(null); }}
        />
      )}
    </div>
  );
}