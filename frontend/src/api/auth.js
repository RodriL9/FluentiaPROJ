const USER_KEY = 'fluentiaUser';

export function getStoredUser() {
  try {
    const raw = sessionStorage.getItem(USER_KEY);
    if (!raw) return null;
    return JSON.parse(raw);
  } catch {
    return null;
  }
}

export function setStoredUser(user) {
  sessionStorage.setItem(USER_KEY, JSON.stringify(user));
}

export function clearStoredUser() {
  sessionStorage.removeItem(USER_KEY);
}

export function topicSelectionComplete(learningGoals) {
  if (!learningGoals || !String(learningGoals).trim()) return false;
  const parts = String(learningGoals)
    .split(',')
    .map((s) => s.trim())
    .filter(Boolean);
  return parts.length >= 2;
}

export function getNextOnboardingRoute(user) {
  if (!user) return '/login';
  if (!user.nativeLanguage || !user.learningLanguage || user.nativeLanguage === user.learningLanguage) {
    return '/onboarding/languages';
  }
  if (!user.assignedLevel) return '/onboarding/placement';
  if (!topicSelectionComplete(user.learningGoals)) return '/onboarding/topic';
  return '/dashboard';
}

async function parseError(res) {
  try {
    const data = await res.json();
    if (data && typeof data.message === 'string') return data.message;
  } catch {
    /* ignore */
  }
  return res.statusText || 'Request failed';
}

export async function fetchPublicAuthConfig() {
  const res = await fetch('/api/auth/public-config');
  if (!res.ok) return { googleWebClientId: '' };
  return res.json();
}

export async function registerAccount({ fullName, username, email, password }) {
  const res = await fetch('/api/auth/register', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ fullName, username, email, password }),
  });
  if (!res.ok) throw new Error(await parseError(res));
  return res.json();
}

export async function loginAccount({ email, password }) {
  const res = await fetch('/api/auth/login', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email, password }),
  });
  if (!res.ok) throw new Error(await parseError(res));
  return res.json();
}

export async function loginWithGoogle(idToken) {
  const res = await fetch('/api/auth/google', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ idToken }),
  });
  if (!res.ok) throw new Error(await parseError(res));
  return res.json();
}

export async function requestPasswordReset(email) {
  const res = await fetch('/api/auth/forgot-password', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email }),
  });
  if (!res.ok) throw new Error(await parseError(res));
}

export async function resetPassword({ token, password }) {
  const res = await fetch('/api/auth/reset-password', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ token, password }),
  });
  if (!res.ok) throw new Error(await parseError(res));
}

export async function deleteMyAccount({ userId, password }) {
  const res = await fetch('/api/auth/delete-account', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ userId, password }),
  });
  if (!res.ok) throw new Error(await parseError(res));
}

export async function verifyAccountPassword({ userId, password }) {
  const res = await fetch('/api/auth/verify-password', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ userId, password }),
  });
  if (!res.ok) throw new Error(await parseError(res));
}

export async function updateUserLanguages(userId, { nativeLanguage, learningLanguage }) {
  const res = await fetch(`/api/users/${userId}/languages`, {
    method: 'PATCH',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ nativeLanguage, learningLanguage }),
  });
  if (!res.ok) throw new Error(await parseError(res));
  return res.json();
}

export async function fetchPlacementQuestions(language) {
  const q = new URLSearchParams({ language }).toString();
  const res = await fetch(`/api/placement/questions?${q}`);
  if (!res.ok) throw new Error(await parseError(res));
  return res.json();
}

export async function submitPlacementTest(payload) {
  const res = await fetch('/api/placement/submit', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  });
  if (!res.ok) throw new Error(await parseError(res));
  return res.json();
}

export async function fetchTopics(language) {
  const q = new URLSearchParams({ language }).toString();
  const res = await fetch(`/api/topics?${q}`);
  if (!res.ok) throw new Error(await parseError(res));
  return res.json();
}

export async function updateUserTopics(userId, topics) {
  const res = await fetch(`/api/users/${userId}/topic`, {
    method: 'PATCH',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ topics }),
  });
  if (!res.ok) throw new Error(await parseError(res));
  return res.json();
}
