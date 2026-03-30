import { useEffect, useMemo, useState } from 'react';
import { Link, useNavigate, useSearchParams } from 'react-router-dom';
import { fetchPlacementQuestions, getStoredUser, setStoredUser, submitPlacementTest } from '../api/auth';
import '../styles/placement-assessment.css';

function extractChoices(options) {
  if (!options) return [];
  const raw = options.choices || options.word_bank || [];
  if (!Array.isArray(raw)) return [];
  return raw.map((entry) => {
    if (typeof entry === 'string') {
      return { value: entry, label: formatChoiceLabel(entry) };
    }
    const value = entry.value || entry.label || '';
    const label = entry.label || entry.value || '';
    return { value, label: formatChoiceLabel(label) };
  });
}

function splitAudioAnswer(answer) {
  return String(answer || '')
    .trim()
    .split(/\s+/)
    .filter(Boolean);
}

function formatLevelLabel(level) {
  return String(level || '')
    .toLowerCase()
    .replaceAll('_', ' ')
    .replace(/\b\w/g, (m) => m.toUpperCase());
}

function formatChoiceLabel(raw) {
  return String(raw || '')
    .replaceAll('_', ' ')
    .toLowerCase()
    .replace(/\b\w/g, (m) => m.toUpperCase());
}

function stripUnderscoresOnly(raw) {
  return String(raw ?? '').replaceAll('_', ' ');
}

/** Split prompt so fill-in blanks (2+ underscores) keep visible width/spacing; single _ → space between words. */
function placementPromptSegments(raw) {
  const s = String(raw ?? '');
  const segments = [];
  let i = 0;
  let key = 0;
  while (i < s.length) {
    if (s[i] === '_') {
      let j = i;
      while (j < s.length && s[j] === '_') j += 1;
      const run = j - i;
      if (run >= 2) {
        segments.push({ type: 'blank', count: run, key: `b-${key++}` });
      } else {
        segments.push({ type: 'text', text: ' ', key: `s-${key++}` });
      }
      i = j;
    } else {
      let j = i;
      while (j < s.length && s[j] !== '_') j += 1;
      segments.push({ type: 'text', text: s.slice(i, j), key: `t-${key++}` });
      i = j;
    }
  }
  return segments;
}

function PlacementPrompt({ raw }) {
  const segs = placementPromptSegments(raw);
  return (
    <>
      {segs.map((seg) =>
        seg.type === 'blank' ? (
          <span className="pa-prompt-blank" key={seg.key} aria-hidden="true">
            {'_'.repeat(seg.count)}
          </span>
        ) : (
          <span key={seg.key}>{seg.text}</span>
        ),
      )}
    </>
  );
}

function questionTypePill(q) {
  if (!q) return { className: 'pa-type-pill mc', label: 'Question' };
  if (q.questionType === 'AUDIO_TAP') return { className: 'pa-type-pill tf', label: 'Listening' };
  const ch = extractChoices(q.options);
  if (ch.length === 0) return { className: 'pa-type-pill sa', label: 'Written response' };
  if (ch.length === 2) return { className: 'pa-type-pill tf', label: 'Either / or' };
  return { className: 'pa-type-pill mc', label: 'Multiple choice' };
}

function levelBadgeClass(level) {
  const u = String(level || '').toUpperCase();
  if (u.includes('ADVANCED')) return 'pa-level-badge pa-level-adv';
  if (u.includes('UPPER_INTERMEDIATE')) return 'pa-level-badge pa-level-upper';
  if (u.includes('INTERMEDIATE')) return 'pa-level-badge pa-level-int';
  return 'pa-level-badge pa-level-fnd';
}

const ChevronRight = () => (
  <svg width="16" height="16" viewBox="0 0 16 16" fill="none" aria-hidden>
    <path
      d="M3 8h10M9 4l4 4-4 4"
      stroke="currentColor"
      strokeWidth="1.5"
      strokeLinecap="round"
      strokeLinejoin="round"
    />
  </svg>
);

const ChevronLeft = () => (
  <svg width="16" height="16" viewBox="0 0 16 16" fill="none" aria-hidden>
    <path
      d="M13 8H3M7 12l-4-4 4-4"
      stroke="currentColor"
      strokeWidth="1.5"
      strokeLinecap="round"
      strokeLinejoin="round"
    />
  </svg>
);

export default function OnboardingPlacementPage() {
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const isRetake = searchParams.get('retake') === '1';
  const stored = getStoredUser();
  const [loading, setLoading] = useState(true);
  const [questions, setQuestions] = useState([]);
  const [answers, setAnswers] = useState({});
  const [currentIndex, setCurrentIndex] = useState(0);
  const [error, setError] = useState('');
  const [submitting, setSubmitting] = useState(false);
  const [result, setResult] = useState(null);
  const [assessmentStarted, setAssessmentStarted] = useState(false);

  const language = stored?.learningLanguage || 'es';
  const unanswered = useMemo(
    () => questions.filter((q) => !(answers[q.id] && String(answers[q.id]).trim())).length,
    [questions, answers],
  );
  const current = questions[currentIndex] || null;

  const formatCount = useMemo(() => {
    const types = new Set((questions || []).map((q) => q.questionType || 'CHOICE'));
    return types.size;
  }, [questions]);

  const estMinutes = useMemo(() => Math.max(1, Math.round((questions.length || 10) * 0.5)), [questions.length]);

  useEffect(() => {
    if (!stored) {
      navigate('/login', { replace: true });
      return;
    }
    let cancelled = false;
    (async () => {
      try {
        const data = await fetchPlacementQuestions(language);
        if (!cancelled) setQuestions(data.questions || []);
      } catch (err) {
        if (!cancelled) setError(err.message || 'Could not load placement questions.');
      } finally {
        if (!cancelled) setLoading(false);
      }
    })();
    return () => {
      cancelled = true;
    };
  }, [stored, navigate, language]);

  if (!stored) return null;

  const speakQuestionAudio = () => {
    if (!current || typeof window === 'undefined' || !window.speechSynthesis) return;
    const options = current.options || {};
    const text = options.audio_text || current.prompt || '';
    if (!text) return;
    window.speechSynthesis.cancel();
    const utter = new SpeechSynthesisUtterance(String(text));
    utter.lang = language === 'es' ? 'es-ES' : 'en-US';
    utter.rate = 0.95;
    window.speechSynthesis.speak(utter);
  };

  const goNext = () => {
    setError('');
    if (!current) return;
    const answer = String(answers[current.id] || '').trim();
    if (!answer) {
      setError('Please answer this question before continuing.');
      return;
    }
    setCurrentIndex((i) => Math.min(i + 1, questions.length - 1));
  };

  const goBack = () => {
    setError('');
    setCurrentIndex((i) => Math.max(i - 1, 0));
  };

  const submitNow = async (e) => {
    e.preventDefault();
    setError('');
    if (unanswered > 0) {
      setError(`Please answer all questions (${unanswered} left).`);
      return;
    }
    setSubmitting(true);
    try {
      const payload = {
        userId: stored.id,
        language,
        durationSeconds: 0,
        answers: questions.map((q) => ({ questionId: q.id, answer: String(answers[q.id] || '').trim() })),
      };
      const scored = await submitPlacementTest(payload);
      setStoredUser({ ...stored, assignedLevel: scored.assignedLevel });
      setResult(scored);
    } catch (err) {
      setError(err.message || 'Could not submit placement test.');
    } finally {
      setSubmitting(false);
    }
  };

  const handleEnterKey = (e) => {
    if (e.key !== 'Enter') return;
    if (loading || submitting || result) return;
    const tag = (e.target?.tagName || '').toLowerCase();
    if (tag === 'button') return;
    if (!assessmentStarted) return;
    e.preventDefault();
    if (!current) return;
    const hasAnswer = String(answers[current.id] || '').trim().length > 0;
    if (!hasAnswer) {
      setError('Please answer this question before continuing.');
      return;
    }
    if (currentIndex < questions.length - 1) {
      goNext();
    } else {
      submitNow(e);
    }
  };

  const pill = current ? questionTypePill(current) : { className: 'pa-type-pill mc', label: '' };

  return (
    <div className="fl-placement-page">
      <div className="pa-page">
        <header className="pa-navbar">
          <nav className="pa-navbar-actions">
            <Link to={isRetake ? '/dashboard' : '/'} className="pa-nav-button">
              {isRetake ? 'Dashboard' : 'Home'}
            </Link>
          </nav>
        </header>

        {error ? (
          <p className="fl-auth-error" style={{ maxWidth: 780, margin: '0 auto 1rem', width: '100%' }} role="alert">
            {error}
          </p>
        ) : null}

        {loading ? (
          <div className="pa-loading-block">Loading your assessment…</div>
        ) : result ? (
          <section className="pa-results-screen" aria-label="Results">
            <div className="pa-results-wrapper">
              <div className="pa-results-hero">
                <div>
                  <div className="pa-results-tag">Placement complete</div>
                  <h1 className="pa-results-title">{isRetake ? 'Level updated' : 'Measure your true level'}</h1>
                  <p className="pa-results-subtitle">
                    {isRetake
                      ? 'Here’s how you did. Your assigned level has been saved to your profile — head back to the dashboard to keep learning.'
                      : 'Here’s how you did on this run. Your level is saved — continue when you’re ready to pick topics.'}
                  </p>
                </div>
                <div className="pa-score-box">
                  <div className="pa-score-pct">{Math.round(result.percentageScore)}%</div>
                  <div className="pa-score-label">Score</div>
                  <div className={levelBadgeClass(result.assignedLevel)}>{formatLevelLabel(result.assignedLevel)}</div>
                </div>
              </div>

              <p
                className="pa-results-subtitle"
                style={{ marginBottom: '1.5rem', maxWidth: 'none' }}
              >
                {result.score} / {result.totalQuestions} points — You scored {result.percentageScore}% on the test.
              </p>

              {isRetake ? (
                <div className="pa-next-steps">
                  <h3>All set</h3>
                  <p>
                    Your new level reflects this score. Topic choices and progress stay as they are — you can change
                    topics anytime from your dashboard.
                  </p>
                </div>
              ) : (
                <div className="pa-next-steps">
                  <h3>Next step</h3>
                  <p>Choose the topics you care about so lessons and vocabulary stay relevant to your goals.</p>
                </div>
              )}

              <button
                type="button"
                className="pa-btn-continue"
                onClick={() =>
                  navigate(isRetake ? '/dashboard' : '/onboarding/topic', { replace: true })
                }
              >
                {isRetake ? 'Back to dashboard' : 'Continue to topic selection'}
                <ChevronRight />
              </button>
            </div>
          </section>
        ) : !assessmentStarted ? (
          <section className="pa-intro" aria-label="Introduction">
            <div className="pa-hero-tag">Language proficiency</div>
            <h1 className="pa-hero-title">
              Measure your
              <br />
              <em>true level</em>
            </h1>
            <p className="pa-hero-body">
              {isRetake
                ? 'Retake the placement to update your level. Your answers are scored and your profile level is replaced with the result of this run.'
                : 'A short placement across listening, reading, and production. Answer at your pace — we use it only to set your starting level.'}
            </p>
            <div className="pa-hero-meta">
              <div className="pa-meta-item">
                <span className="pa-meta-value">{questions.length || '—'}</span>
                <span className="pa-meta-label">Questions</span>
              </div>
              <div className="pa-meta-divider" aria-hidden />
              <div className="pa-meta-item">
                <span className="pa-meta-value">~ {estMinutes}</span>
                <span className="pa-meta-label">Minutes</span>
              </div>
              <div className="pa-meta-divider" aria-hidden />
              <div className="pa-meta-item">
                <span className="pa-meta-value">{formatCount}</span>
                <span className="pa-meta-label">Formats</span>
              </div>
            </div>
            <button
              type="button"
              className="pa-btn-start"
              disabled={!questions.length}
              onClick={() => {
                setAssessmentStarted(true);
                setError('');
              }}
            >
              <span>Begin assessment</span>
              <ChevronRight />
            </button>
          </section>
        ) : (
          <section className="pa-question-screen" aria-label="Questions">
            <div className="pa-progress-wrapper">
              <div className="pa-progress-steps">
                {questions.map((q, i) => (
                  <div
                    key={q.id}
                    className={`pa-step-pip${i < currentIndex ? ' done' : ''}${i === currentIndex ? ' active' : ''}`}
                    aria-hidden
                  />
                ))}
              </div>
              <div className="pa-progress-text">
                {currentIndex + 1} / {questions.length}
              </div>
            </div>

            <form onSubmit={submitNow} onKeyDown={handleEnterKey}>
              {current ? (
                <div className="pa-q-wrapper" key={current.id}>
                  <div className="pa-q-header">
                    <div className="pa-q-index">{currentIndex + 1}</div>
                    <span className={pill.className}>{pill.label}</span>
                  </div>
                  <div className="pa-q-text">
                    <PlacementPrompt raw={current.prompt} />
                  </div>

                  {current.questionType === 'AUDIO_TAP' ? (
                    <button type="button" className="pa-mini-btn pa-audio-play" onClick={speakQuestionAudio}>
                      Play audio
                    </button>
                  ) : null}

                  {(() => {
                    const choices = extractChoices(current.options);
                    const isAudioTap = current.questionType === 'AUDIO_TAP';
                    const isFreeText = choices.length === 0 && !isAudioTap;
                    const currentTokens = splitAudioAnswer(answers[current.id] || '');

                    const addAudioToken = (token) => {
                      const next = [...currentTokens, token];
                      setAnswers((prev) => ({ ...prev, [current.id]: next.join(' ') }));
                    };
                    const undoAudioToken = () => {
                      const next = currentTokens.slice(0, -1);
                      setAnswers((prev) => ({ ...prev, [current.id]: next.join(' ') }));
                    };
                    const clearAudioTokens = () => {
                      setAnswers((prev) => ({ ...prev, [current.id]: '' }));
                    };

                    if (isAudioTap) {
                      const wordBank = Array.isArray(current.options?.word_bank) ? current.options.word_bank : [];
                      return (
                        <>
                          <p className="pa-sa-hint" style={{ marginBottom: '0.75rem' }}>
                            Tap the words in order:
                          </p>
                          <div className="pa-answer-line">{currentTokens.length ? currentTokens.join(' ') : '—'}</div>
                          <div className="pa-word-bank">
                            {wordBank.map((word, idx) => (
                              <button
                                key={`${current.id}-wb-${idx}-${word}`}
                                type="button"
                                className="pa-word-chip"
                                onClick={() => addAudioToken(word)}
                              >
                                {stripUnderscoresOnly(word)}
                              </button>
                            ))}
                          </div>
                          <div className="pa-audio-actions">
                            <button
                              type="button"
                              className="pa-mini-btn"
                              onClick={undoAudioToken}
                              disabled={!currentTokens.length}
                            >
                              Undo
                            </button>
                            <button
                              type="button"
                              className="pa-mini-btn"
                              onClick={clearAudioTokens}
                              disabled={!currentTokens.length}
                            >
                              Clear
                            </button>
                          </div>
                        </>
                      );
                    }

                    if (isFreeText) {
                      return (
                        <>
                          <input
                            type="text"
                            className="pa-sa-area"
                            style={{ minHeight: '52px' }}
                            value={answers[current.id] || ''}
                            onChange={(ev) => setAnswers((prev) => ({ ...prev, [current.id]: ev.target.value }))}
                            placeholder="Type your answer"
                          />
                          <p className="pa-sa-hint">Press Enter on the last question to submit.</p>
                        </>
                      );
                    }

                    return (
                      <div className="pa-options-grid">
                        {choices.map((c, idx) => {
                          const letter = String.fromCharCode(65 + idx);
                          const selected = answers[current.id] === c.value;
                          return (
                            <button
                              key={`${current.id}-${c.value}`}
                              type="button"
                              className={`pa-option-card${selected ? ' selected' : ''}`}
                              onClick={() => setAnswers((prev) => ({ ...prev, [current.id]: c.value }))}
                            >
                              <span className="pa-option-letter">{letter}</span>
                              <span className="pa-option-text">{c.label}</span>
                            </button>
                          );
                        })}
                      </div>
                    );
                  })()}
                </div>
              ) : null}

              <div className="pa-nav-row">
                <button type="button" className="pa-btn-back" onClick={goBack} disabled={currentIndex === 0}>
                  <ChevronLeft />
                  Back
                </button>
                {currentIndex < questions.length - 1 ? (
                  <button type="button" className="pa-btn-next" onClick={goNext}>
                    Next
                    <ChevronRight />
                  </button>
                ) : (
                  <button type="submit" className="pa-btn-next" disabled={submitting}>
                    {submitting ? 'Scoring…' : 'See my score'}
                    <ChevronRight />
                  </button>
                )}
              </div>
            </form>
          </section>
        )}
      </div>
    </div>
  );
}
