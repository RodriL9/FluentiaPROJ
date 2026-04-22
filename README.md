# Fluentia Project

Fluentia is a full-stack language-learning platform with:

- user authentication (email/password + Google sign-in),
- onboarding (language choice, placement assessment, topic selection),
- core lessons and topic-based lessons,
- practice analytics (XP, streaks, weak spots, achievements),
- subscriptions/account management,
- AI conversation tutor with voice input/output.

This README is written for project submission so instructors can quickly understand the architecture, APIs, and how the system works end-to-end.

## 1) Tech Stack

### Frontend
- `React 18`
- `React Router`
- `Vite`
- Browser APIs:
  - **Web Speech API** (`speechSynthesis`, `SpeechRecognition`/`webkitSpeechRecognition`) for pronunciation and AI voice conversation

### Backend
- `Java 21`
- `Spring Boot 3`
- `Spring Web`, `Spring Data JPA`, `JdbcTemplate`
- `PostgreSQL`

### External Integrations
- **OpenAI Chat Completions API** (`gpt-4o-mini`) for AI tutor responses
- **Google OAuth / Google Identity** for sign-in with Google
- **Gmail API** for verification and reset-password emails

## 2) Repository Structure

```
FluentiaPROJ/
  backend/    # Spring Boot API + DB logic
  frontend/   # React application
```

### Important frontend files
- `frontend/src/App.jsx` - top-level routes
- `frontend/src/pages/DashboardPage.jsx` - main authenticated app shell and dashboards
- `frontend/src/pages/OnboardingLanguagesPage.jsx`
- `frontend/src/pages/OnboardingPlacementPage.jsx`
- `frontend/src/pages/OnboardingTopicPage.jsx`
- `frontend/src/pages/LessonDetailPage.jsx`
- `frontend/src/pages/TopicLessonPage.jsx`
- `frontend/src/pages/TopicsPage.jsx`
- `frontend/src/api/auth.js`
- `frontend/src/api/lessons.js`
- `frontend/src/utils/speech.js`

### Important backend files
- `backend/src/main/java/com/fluentia/FluentiaBackendApplication.java`
- `backend/src/main/java/com/fluentia/controllers/*.java` (REST endpoints)
- `backend/src/main/java/com/fluentia/services/AuthService.java`
- `backend/src/main/java/com/fluentia/services/PlacementService.java`
- `backend/src/main/java/com/fluentia/services/GmailMailService.java`

## 3) High-Level Architecture

1. User interacts with React frontend.
2. Frontend calls backend endpoints under `/api/*`.
3. Backend processes requests with Spring controllers/services and reads/writes PostgreSQL.
4. For AI tutor requests, backend calls OpenAI API and returns generated feedback.
5. For auth email verification/reset, backend sends messages through Gmail API.

In local development, Vite proxies `/api` requests to `http://localhost:8080` via `frontend/vite.config.js`.

## 4) Main Product Flows

### A) Authentication and account lifecycle
- Register/login via email/password
- Optional Google sign-in
- Email verification flow
- Forgot/reset password
- Account deletion with password confirmation

### B) Onboarding
1. Select native + learning language
2. Placement assessment
3. Topic selection
4. Enter dashboard

### C) Learning content
- Core lesson catalog (7 structured lessons)
- Topic-based lesson tracks (filtered by user topics + level)
- Lecture tabs (embedded videos)
- Exercise interaction (audio, selection, free text, speaking/listening patterns)

### D) Analytics and progression
- XP and streak updates
- Weak spot tracking (`user_trouble_items`)
- Skills updates (`user_skills`)
- Achievements and summaries

### E) AI Tutor
- Conversation modes:
  - `spanish_only`
  - `tutor` (corrective mode)
- Voice input + TTS output on frontend
- OpenAI response generation and safety filtering on backend

## 5) APIs Used

## External APIs and platform services

1. **OpenAI API**
   - Used from Programming WWW course
   - Used in: `DataApiController` (`/ai/conversation/feedback`)
   - Purpose: generate tutor responses and language coaching feedback

2. **Google OAuth (Identity)**
   - Frontend redirect flow to Google auth endpoint
   - Backend verifies ID token (`GoogleIdTokenVerificationService`)
   - Purpose: sign in / sign up with Google account

3. **Gmail API**
   - Used in `GmailMailService`
   - Purpose: send verification email + password reset email

4. **Browser Web Speech API**
   - TTS for fluent pronunciation and AI replies
   - Speech recognition for mic-based AI conversation mode

## Backend REST API inventory (grouped)

> Note: frontend calls these with `/api/...` paths. Controllers are mapped without `/api` in code and are typically served under an `/api` context path in deployment/dev config.

### Auth (`AuthController`)
- `GET /api/auth/public-config`
- `POST /api/auth/register`
- `POST /api/auth/login`
- `POST /api/auth/google`
- `GET /api/auth/verify-email`
- `POST /api/auth/forgot-password`
- `POST /api/auth/reset-password`
- `POST /api/auth/delete-account`
- `POST /api/auth/verify-password`

### User settings (`UserController`)
- `PATCH /api/users/{id}/languages`
- `PATCH /api/users/{id}/topic`
- `PATCH /api/users/{id}/level`

### Placement (`PlacementController`)
- `GET /api/placement/questions`
- `POST /api/placement/submit`

### Core lesson catalog (`LessonCatalogController`)
- `GET /api/lesson-catalog`
- `GET /api/lesson-catalog/{lessonNumber}/content`
- `POST /api/lesson-catalog/{lessonNumber}/start`
- `POST /api/lesson-catalog/{lessonNumber}/submit`

### Topic lessons (`TopicLessonsController`)
- `GET /api/topic-lessons`
- `GET /api/topic-lessons/{lessonId}`
- `POST /api/topic-lessons/{lessonId}/complete`

### User summary and topic management (`UserSummaryController`)
- `GET /api/me/summary`
- `POST /api/me/topics/add`
- `POST /api/me/topics/remove`

### General learning/data APIs (`DataApiController`)
- `GET /api/health`
- `GET /api/content-overview`
- `GET /api/dashboard`
- `GET /api/sections`
- `GET /api/sections/{sectionId}`
- `GET /api/units/{unitId}`
- `GET /api/lessons/{lessonId}`
- `GET /api/lessons/{lessonId}/exercises`
- `GET /api/topics`
- `GET /api/topics/me`
- `GET /api/topics/{topicId}/content`
- `GET /api/vocabulary`
- `GET /api/vocabulary/review`
- `GET /api/vocabulary/memory`
- `GET /api/vocabulary/exercises`
- `GET /api/review`
- `GET /api/review/due`
- `GET /api/review/sessions`
- `GET /api/my-mistakes`
- `GET /api/lesson-queue`
- `GET /api/grammar`
- `GET /api/grammar/rules`
- `GET /api/grammar/rules/{id}`
- `GET /api/conjugations/verbs`
- `GET /api/reading`
- `GET /api/reading/passages`
- `GET /api/reading/passages/{id}`
- `GET /api/phrases`
- `GET /api/cultural-notes`
- `GET /api/ai/templates`
- `GET /api/ai/templates/{id}`
- `GET /api/me/quests`
- `GET /api/me/xp-history`
- `GET /api/me/level-history`
- `GET /api/me/activity`
- `GET /api/me/speaking-attempts`
- `GET /api/skills/me`
- `GET /api/skills/breakdown-reports`
- `GET /api/skills/breakdown-live`
- `GET /api/skills/lesson-plan`
- `POST /api/practice/attempt`
- `GET /api/practice/troubles`
- `GET /api/achievements/me`
- `GET /api/notifications`
- `GET /api/leaderboard`
- `GET /api/preferences`
- `GET /api/accessibility`
- `GET /api/subscriptions/me`
- `GET /api/subscriptions/history`
- `POST /api/subscriptions/subscribe`
- `PATCH /api/subscriptions/manage`
- `PATCH /api/subscriptions/cancel`
- `POST /api/ai/conversation/feedback`

## 6) Environment Variables / Configuration

Example file: `backend/.env.exampleOnly`

### Database
- `SPRING_DATASOURCE_URL`
- `SPRING_DATASOURCE_USERNAME`
- `SPRING_DATASOURCE_PASSWORD`

### Public URLs
- `APP_PUBLIC_URL`
- `APP_PUBLIC_API_BASE_URL`

### Google sign-in / Gmail
- `GOOGLE_WEB_CLIENT_ID` (or `GOOGLE_CLIENT_ID`)
- `GMAIL_OAUTH_CLIENT_ID`
- `GMAIL_OAUTH_CLIENT_SECRET`
- `GMAIL_OAUTH_REFRESH_TOKEN`
- `GMAIL_FROM_EMAIL`

### Optional local convenience
- `SKIP_EMAIL_VERIFICATION=true|false`

### OpenAI
- `OPENAI_API_KEY` (or `OPENAI_KEY`)

## 7) Local Run Instructions

## Prerequisites
- Node.js 18+
- Java 21
- Maven installed (`mvn`)
- PostgreSQL running with expected schema/data

## Backend
From `backend/`:

```bash
mvn spring-boot:run
```

Default local backend host is expected at `http://localhost:8080`.

## Frontend
From `frontend/`:

```bash
npm install
npm run dev
```

Frontend runs on `http://localhost:5173`.

## API docs (if enabled by springdoc)
- Swagger UI is typically available at:
  - `http://localhost:8080/swagger-ui/index.html`

## 8) Data and Progress Logic Summary

- Placement test assigns `BEGINNER`, `INTERMEDIATE`, `UPPER_INTERMEDIATE`, or `ADVANCED`.
- Core lesson completion updates:
  - lesson progress
  - XP history
  - streak
  - skill stats
  - unlock logic for next lesson
- Topic lesson completion also updates XP + streak + trouble tracking.
- Practice attempts update user skill scores and weak-spot records.
- Achievements are computed/upserted from XP, streak, lesson completion, and activity counters.

## 9) Voice + AI Notes

- Pronunciation utility (`frontend/src/utils/speech.js`) chooses best available browser voice for fluent output.
- AI conversation endpoint supports mode switching:
  - `spanish_only`: target-language conversation only
  - `tutor`: explain in native language and provide target-language phrases/corrections
- Backend includes safety keyword screening for inappropriate content in AI prompts.

