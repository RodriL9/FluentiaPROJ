import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { getStoredUser, setStoredUser, updateUserLanguages } from '../api/auth';

const LANGUAGE_OPTIONS = [
  { code: 'en', label: 'English', flag: '🇺🇸' },
  { code: 'es', label: 'Spanish', flag: '🇪🇸' },
];

export default function OnboardingLanguagesPage() {
  const navigate = useNavigate();
  const stored = getStoredUser();
  const [nativeLanguage, setNativeLanguage] = useState(stored?.nativeLanguage || 'en');
  const [learningLanguage, setLearningLanguage] = useState(stored?.learningLanguage || 'es');
  const [step, setStep] = useState(1);
  const [error, setError] = useState('');
  const [submitting, setSubmitting] = useState(false);

  useEffect(() => {
    if (!stored) {
      navigate('/login', { replace: true });
    }
  }, [stored, navigate]);

  if (!stored) {
    return null;
  }

  const handleNextFromNative = (e) => {
    e.preventDefault();
    setError('');
    if (!nativeLanguage) {
      setError('Please pick your native language.');
      return;
    }
    setStep(2);
  };

  const handleSaveLanguages = async (e) => {
    e.preventDefault();
    setError('');
    if (!learningLanguage) {
      setError('Please pick the language you want to learn.');
      return;
    }
    if (nativeLanguage === learningLanguage) {
      setError('Native and learning language should be different.');
      return;
    }
    setSubmitting(true);
    try {
      const updated = await updateUserLanguages(stored.id, { nativeLanguage, learningLanguage });
      setStoredUser({ ...stored, ...updated });
      navigate('/onboarding/placement', { replace: true });
    } catch (err) {
      setError(err.message || 'Could not save languages. Please try again.');
    } finally {
      setSubmitting(false);
    }
  };

  const currentTitle = step === 1 ? 'What language do you speak?' : 'What language do you want to learn?';
  const currentSub =
    step === 1
      ? 'Choose your native language so we can adapt explanations.'
      : 'Pick the language you want Fluentia to help you learn.';

  return (
    <div className="fl-auth-page">
      <div className="fl-auth-card">
        <h1 className="fl-auth-title">{currentTitle}</h1>
        <p className="fl-auth-sub">{currentSub}</p>

        {error ? (
          <p className="fl-auth-error" role="alert">
            {error}
          </p>
        ) : null}

        {step === 1 ? (
          <form onSubmit={handleNextFromNative}>
            <div className="fl-field">
              <div className="fl-language-grid">
                {LANGUAGE_OPTIONS.map((opt) => (
                  <button
                    key={opt.code}
                    type="button"
                    className={`fl-language-pill${nativeLanguage === opt.code ? ' fl-language-pill-active' : ''}`}
                    onClick={() => setNativeLanguage(opt.code)}
                  >
                    <span className="fl-language-flag" aria-hidden>
                      {opt.flag}
                    </span>
                    <span>{opt.label}</span>
                  </button>
                ))}
              </div>
            </div>
            <button type="submit" className="fl-btn fl-btn-primary fl-btn-block">
              Continue
            </button>
          </form>
        ) : (
          <form onSubmit={handleSaveLanguages}>
            <div className="fl-field">
              <div className="fl-language-grid">
                {LANGUAGE_OPTIONS.map((opt) => (
                  <button
                    key={opt.code}
                    type="button"
                    className={`fl-language-pill${learningLanguage === opt.code ? ' fl-language-pill-active' : ''}`}
                    onClick={() => setLearningLanguage(opt.code)}
                  >
                    <span className="fl-language-flag" aria-hidden>
                      {opt.flag}
                    </span>
                    <span>{opt.label}</span>
                  </button>
                ))}
              </div>
            </div>
            <button type="submit" className="fl-btn fl-btn-primary fl-btn-block" disabled={submitting}>
              {submitting ? 'Saving…' : 'Continue'}
            </button>
          </form>
        )}
      </div>
    </div>
  );
}


