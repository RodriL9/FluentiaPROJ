let voicesReadyPromise = null;

function normalizeLanguage(language) {
  const raw = String(language || 'es').toLowerCase().trim();
  if (!raw) return 'es-ES';
  if (raw === 'es') return 'es-ES';
  if (raw === 'en') return 'en-US';
  if (raw.includes('-')) {
    const [base, region] = raw.split('-');
    if (base && region) return `${base.toLowerCase()}-${region.toUpperCase()}`;
  }
  return raw;
}

function voiceQualityScore(voice, targetLang) {
  const lang = String(voice?.lang || '').toLowerCase();
  const name = String(voice?.name || '').toLowerCase();
  const langBase = String(targetLang || '').toLowerCase().split('-')[0];

  let score = 0;
  if (lang === String(targetLang || '').toLowerCase()) score += 120;
  else if (lang.startsWith(`${langBase}-`)) score += 90;
  else if (lang.startsWith(langBase)) score += 60;

  if (name.includes('google')) score += 25;
  if (name.includes('microsoft')) score += 20;
  if (name.includes('natural')) score += 20;
  if (name.includes('neural')) score += 20;
  if (name.includes('enhanced')) score += 16;
  if (name.includes('premium')) score += 16;

  return score;
}

function pickBestVoice(voices, targetLang) {
  if (!Array.isArray(voices) || voices.length === 0) return null;
  const ranked = [...voices]
    .map((voice) => ({ voice, score: voiceQualityScore(voice, targetLang) }))
    .sort((a, b) => b.score - a.score);
  return ranked[0]?.voice || null;
}

async function getVoices() {
  if (typeof window === 'undefined' || !window.speechSynthesis) return [];
  const synth = window.speechSynthesis;
  const now = synth.getVoices();
  if (now.length) return now;

  if (!voicesReadyPromise) {
    voicesReadyPromise = new Promise((resolve) => {
      let done = false;
      const finish = () => {
        if (done) return;
        done = true;
        resolve(synth.getVoices());
      };
      const onChange = () => finish();
      synth.addEventListener('voiceschanged', onChange, { once: true });
      window.setTimeout(() => {
        synth.removeEventListener('voiceschanged', onChange);
        finish();
      }, 1200);
    });
  }

  return voicesReadyPromise;
}

export async function speakFluent(text, options = {}) {
  if (typeof window === 'undefined' || !window.speechSynthesis) return false;
  const phrase = String(text || '').trim();
  if (!phrase) return false;

  const synth = window.speechSynthesis;
  if (options.cancelOngoing !== false) synth.cancel();

  const language = normalizeLanguage(options.language || 'es');
  const utterance = new SpeechSynthesisUtterance(phrase);
  utterance.lang = language;
  utterance.rate = Number.isFinite(options.rate) ? options.rate : (language.startsWith('es') ? 0.9 : 0.95);
  utterance.pitch = Number.isFinite(options.pitch) ? options.pitch : 1;
  utterance.volume = Number.isFinite(options.volume) ? options.volume : 1;

  const voices = await getVoices();
  const bestVoice = pickBestVoice(voices, language);
  if (bestVoice) {
    utterance.voice = bestVoice;
    if (bestVoice.lang) utterance.lang = bestVoice.lang;
  }

  return await new Promise((resolve) => {
    let settled = false;
    const done = (ok) => {
      if (settled) return;
      settled = true;
      resolve(ok);
    };
    const timeoutMs = Math.max(3000, Math.min(22000, phrase.length * 90));
    const timer = window.setTimeout(() => done(true), timeoutMs);
    utterance.onend = () => {
      window.clearTimeout(timer);
      done(true);
    };
    utterance.onerror = () => {
      window.clearTimeout(timer);
      done(false);
    };
    synth.speak(utterance);
  });
}
