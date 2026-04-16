import { Routes, Route, Navigate } from 'react-router-dom';
import AppLayout from './layouts/AppLayout';
import LandingPage from './pages/LandingPage';
import LoginPage from './pages/LoginPage';
import RegisterPage from './pages/RegisterPage';
import ForgotPasswordPage from './pages/ForgotPasswordPage';
import ResetPasswordPage from './pages/ResetPasswordPage';
import DashboardPage from './pages/DashboardPage';
import GoogleCallbackPage from './pages/GoogleCallbackPage';
import OnboardingLanguagesPage from './pages/OnboardingLanguagesPage';
import OnboardingPlacementPage from './pages/OnboardingPlacementPage';
import OnboardingTopicPage from './pages/OnboardingTopicPage';

export default function App() {
  return (
    <Routes>
      <Route element={<AppLayout />}>
        <Route path="/" element={<LandingPage />} />
        <Route path="/login" element={<LoginPage />} />
        <Route path="/register" element={<RegisterPage />} />
        <Route path="/forgot-password" element={<ForgotPasswordPage />} />
        <Route path="/reset-password" element={<ResetPasswordPage />} />
        <Route path="/google-callback" element={<GoogleCallbackPage />} />
        <Route path="/onboarding/languages" element={<OnboardingLanguagesPage />} />
        <Route path="/onboarding/placement" element={<OnboardingPlacementPage />} />
        <Route path="/onboarding/topic" element={<OnboardingTopicPage />} />
        <Route path="/dashboard/*" element={<DashboardPage />} />
        <Route path="*" element={<Navigate to="/" replace />} />
      </Route>
    </Routes>
  );
}
