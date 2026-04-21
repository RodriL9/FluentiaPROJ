// frontend/src/api/lessons.js
// All API calls related to lessons, progress, and practice

async function parseError(res) {
  try {
    const data = await res.json();
    if (data && typeof data.message === 'string') return data.message;
  } catch { /* ignore */ }
  return res.statusText || 'Request failed';
}

// ── Core 7 Lessons ────────────────────────────────────────────────────────────

export async function fetchLessonCatalog(userId) {
  const res = await fetch(`/api/lesson-catalog?userId=${encodeURIComponent(userId)}`);
  if (!res.ok) throw new Error(await parseError(res));
  return res.json();
}

export async function fetchLessonContent(lessonNumber, userId) {
  const res = await fetch(
    `/api/lesson-catalog/${lessonNumber}/content?userId=${encodeURIComponent(userId)}`
  );
  if (!res.ok) throw new Error(await parseError(res));
  return res.json();
}

export async function startLesson(lessonNumber, userId) {
  const res = await fetch(`/api/lesson-catalog/${lessonNumber}/start`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ userId }),
  });
  if (!res.ok) throw new Error(await parseError(res));
  return res.json();
}

export async function submitLessonTest(lessonNumber, { userId, correct, total, wrongAnswers = [] }) {
  const res = await fetch(`/api/lesson-catalog/${lessonNumber}/submit`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ userId, correct, total, wrongAnswers }),
  });
  if (!res.ok) throw new Error(await parseError(res));
  return res.json();
}

// ── Topic Lessons ─────────────────────────────────────────────────────────────

export async function fetchTopicLessons(userId) {
  const res = await fetch(`/api/topic-lessons?userId=${encodeURIComponent(userId)}`);
  if (!res.ok) throw new Error(await parseError(res));
  return res.json();
}

export async function fetchTopicLessonDetail(lessonId, userId) {
  const res = await fetch(
    `/api/topic-lessons/${lessonId}?userId=${encodeURIComponent(userId)}`
  );
  if (!res.ok) throw new Error(await parseError(res));
  return res.json();
}

export async function completeTopicLesson(lessonId, { userId, exercisesCorrect, exercisesTotal, timeSpentSeconds, wrongAnswers = [] }) {
  const res = await fetch(`/api/topic-lessons/${lessonId}/complete`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ userId, exercisesCorrect, exercisesTotal, timeSpentSeconds, wrongAnswers }),
  });
  if (!res.ok) throw new Error(await parseError(res));
  return res.json();
}

// ── User Summary & Practice ───────────────────────────────────────────────────

export async function fetchUserSummary(userId) {
  const res = await fetch(`/api/me/summary?userId=${encodeURIComponent(userId)}`);
  if (!res.ok) throw new Error(await parseError(res));
  return res.json();
}

export async function fetchWeakSpots(userId, language = 'es') {
  const res = await fetch(
    `/api/practice/troubles?userId=${encodeURIComponent(userId)}&language=${language}`
  );
  if (!res.ok) throw new Error(await parseError(res));
  return res.json();
}

export async function recordPracticeAttempt({ userId, language, section, correct, labelSnapshot = '', source = '' }) {
  try {
    const res = await fetch('/api/practice/attempt', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ userId, language, section, correct, labelSnapshot, source }),
    });
    if (!res.ok) return null;
    return res.json();
  } catch {
    return null; // Never break UI for tracking calls
  }
}

// ── Topics Content ────────────────────────────────────────────────────────────

export async function fetchTopics(language) {
  const res = await fetch(`/api/topics?language=${encodeURIComponent(language)}`);
  if (!res.ok) throw new Error(await parseError(res));
  return res.json();
}

export async function fetchTopicContent(topicId) {
  const res = await fetch(`/api/topics/${topicId}/content`);
  if (!res.ok) throw new Error(await parseError(res));
  return res.json();
} 