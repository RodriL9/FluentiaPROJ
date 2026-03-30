--
-- PostgreSQL database dump
--

\restrict ROfcAPbPhabZf1schCtPk5vNptBvUHhh7nOk5lYXr4YTf7PnefrDbOhz3nz4lrk

-- Dumped from database version 14.20 (Homebrew)
-- Dumped by pg_dump version 14.20 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: accessibility_preferences; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.accessibility_preferences (
    user_id uuid NOT NULL,
    high_contrast_mode boolean DEFAULT false,
    font_size character varying(10) DEFAULT 'MEDIUM'::character varying,
    reduced_motion boolean DEFAULT false,
    screen_reader_mode boolean DEFAULT false,
    color_blind_mode character varying(20) DEFAULT 'NONE'::character varying,
    audio_descriptions boolean DEFAULT false,
    keyboard_nav_only boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now(),
    CONSTRAINT chk_color_blind CHECK (((color_blind_mode)::text = ANY ((ARRAY['NONE'::character varying, 'DEUTERANOPIA'::character varying, 'PROTANOPIA'::character varying, 'TRITANOPIA'::character varying, 'MONOCHROMACY'::character varying])::text[]))),
    CONSTRAINT chk_font_size CHECK (((font_size)::text = ANY ((ARRAY['SMALL'::character varying, 'MEDIUM'::character varying, 'LARGE'::character varying, 'EXTRA_LARGE'::character varying])::text[])))
);


ALTER TABLE public.accessibility_preferences OWNER TO rodrigo;

--
-- Name: achievements; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.achievements (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    code character varying(50) NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    icon character varying(10),
    max_level integer DEFAULT 3,
    xp_reward integer DEFAULT 0,
    thresholds jsonb
);


ALTER TABLE public.achievements OWNER TO rodrigo;

--
-- Name: admin_level_adjustments; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.admin_level_adjustments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    admin_id uuid,
    learner_id uuid,
    previous_level character varying(30) NOT NULL,
    new_level character varying(30) NOT NULL,
    justification text NOT NULL,
    adjusted_at timestamp without time zone DEFAULT now(),
    CONSTRAINT chk_ala_new CHECK (((new_level)::text = ANY ((ARRAY['BEGINNER'::character varying, 'INTERMEDIATE'::character varying, 'UPPER_INTERMEDIATE'::character varying, 'ADVANCED'::character varying])::text[]))),
    CONSTRAINT chk_ala_prev CHECK (((previous_level)::text = ANY ((ARRAY['BEGINNER'::character varying, 'INTERMEDIATE'::character varying, 'UPPER_INTERMEDIATE'::character varying, 'ADVANCED'::character varying])::text[])))
);


ALTER TABLE public.admin_level_adjustments OWNER TO rodrigo;

--
-- Name: ai_conversation_templates; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.ai_conversation_templates (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    language character varying(5) NOT NULL,
    title character varying(150) NOT NULL,
    scenario text NOT NULL,
    topic_tag character varying(50),
    level character varying(30) DEFAULT 'BEGINNER'::character varying,
    opening_prompt text NOT NULL,
    target_vocabulary uuid[],
    target_grammar_rules uuid[],
    min_exchanges integer DEFAULT 4,
    evaluation_criteria jsonb,
    CONSTRAINT chk_act_lang CHECK (((language)::text = ANY ((ARRAY['en'::character varying, 'es'::character varying])::text[]))),
    CONSTRAINT chk_act_level CHECK (((level)::text = ANY ((ARRAY['BEGINNER'::character varying, 'INTERMEDIATE'::character varying, 'UPPER_INTERMEDIATE'::character varying, 'ADVANCED'::character varying])::text[])))
);


ALTER TABLE public.ai_conversation_templates OWNER TO rodrigo;

--
-- Name: ai_messages; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.ai_messages (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    session_id uuid,
    sender character varying(10) NOT NULL,
    content text NOT NULL,
    grammar_feedback text,
    vocabulary_feedback text,
    pronunciation_tips text,
    sent_at timestamp without time zone DEFAULT now(),
    CONSTRAINT chk_sender CHECK (((sender)::text = ANY ((ARRAY['USER'::character varying, 'AI'::character varying])::text[])))
);


ALTER TABLE public.ai_messages OWNER TO rodrigo;

--
-- Name: ai_sessions; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.ai_sessions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    language character varying(5) NOT NULL,
    topic character varying(100),
    template_id uuid,
    session_status character varying(20) DEFAULT 'ACTIVE'::character varying,
    fallback_used boolean DEFAULT false,
    fallback_reason text,
    error_message text,
    avg_response_ms integer,
    speech_attempts integer DEFAULT 0,
    speech_failures integer DEFAULT 0,
    grammar_score numeric(5,2),
    vocabulary_score numeric(5,2),
    fluency_score numeric(5,2),
    feedback_summary text,
    started_at timestamp without time zone DEFAULT now(),
    ended_at timestamp without time zone,
    total_messages integer DEFAULT 0,
    xp_awarded integer DEFAULT 0,
    CONSTRAINT chk_session_status CHECK (((session_status)::text = ANY ((ARRAY['ACTIVE'::character varying, 'COMPLETED'::character varying, 'ABANDONED'::character varying, 'FAILED'::character varying, 'FALLBACK'::character varying])::text[])))
);


ALTER TABLE public.ai_sessions OWNER TO rodrigo;

--
-- Name: common_mistakes; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.common_mistakes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    mistake_type character varying(30) NOT NULL,
    reference_id uuid NOT NULL,
    mistake_count integer DEFAULT 1 NOT NULL,
    last_made_at timestamp without time zone DEFAULT now(),
    example_wrong text,
    example_correct text,
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT chk_mistake_type CHECK (((mistake_type)::text = ANY ((ARRAY['GRAMMAR_RULE'::character varying, 'VOCABULARY'::character varying, 'CONJUGATION'::character varying])::text[])))
);


ALTER TABLE public.common_mistakes OWNER TO rodrigo;

--
-- Name: conjugations; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.conjugations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    vocabulary_id uuid NOT NULL,
    language character varying(5) NOT NULL,
    tense character varying(30) NOT NULL,
    mood character varying(20) DEFAULT 'INDICATIVE'::character varying NOT NULL,
    person character varying(20) NOT NULL,
    conjugated_form character varying(100) NOT NULL,
    is_irregular boolean DEFAULT false,
    notes text,
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT chk_conj_lang CHECK (((language)::text = ANY ((ARRAY['en'::character varying, 'es'::character varying])::text[]))),
    CONSTRAINT chk_conj_mood CHECK (((mood)::text = ANY ((ARRAY['INDICATIVE'::character varying, 'SUBJUNCTIVE'::character varying, 'IMPERATIVE'::character varying, 'INFINITIVE'::character varying, 'PARTICIPLE'::character varying])::text[]))),
    CONSTRAINT chk_conj_person CHECK (((person)::text = ANY ((ARRAY['YO'::character varying, 'TU'::character varying, 'EL_ELLA'::character varying, 'NOSOTROS'::character varying, 'VOSOTROS'::character varying, 'ELLOS'::character varying, 'I'::character varying, 'YOU'::character varying, 'HE_SHE_IT'::character varying, 'WE'::character varying, 'THEY'::character varying, 'GERUND'::character varying, 'PAST_PARTICIPLE'::character varying])::text[]))),
    CONSTRAINT chk_conj_tense CHECK (((tense)::text = ANY ((ARRAY['PRESENT'::character varying, 'PRETERITE'::character varying, 'IMPERFECT'::character varying, 'FUTURE'::character varying, 'CONDITIONAL'::character varying, 'PRESENT_SUBJUNCTIVE'::character varying, 'IMPERFECT_SUBJUNCTIVE'::character varying, 'PRESENT_PERFECT'::character varying, 'PAST_PERFECT'::character varying, 'FUTURE_PERFECT'::character varying, 'IMPERATIVE'::character varying, 'PROGRESSIVE'::character varying, 'SIMPLE_PAST'::character varying, 'SIMPLE_PRESENT'::character varying, 'SIMPLE_FUTURE'::character varying])::text[])))
);


ALTER TABLE public.conjugations OWNER TO rodrigo;

--
-- Name: content_audit_log; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.content_audit_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    admin_id uuid,
    action character varying(50) NOT NULL,
    target_type character varying(50),
    target_id uuid,
    notes text,
    performed_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.content_audit_log OWNER TO rodrigo;

--
-- Name: cultural_notes; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.cultural_notes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    language character varying(5) NOT NULL,
    title character varying(150) NOT NULL,
    body text NOT NULL,
    level character varying(30) DEFAULT 'BEGINNER'::character varying,
    topic_tag character varying(50),
    related_words jsonb,
    related_word_ids uuid[],
    country_context text[],
    display_order integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT chk_cn_lang CHECK (((language)::text = ANY ((ARRAY['en'::character varying, 'es'::character varying])::text[]))),
    CONSTRAINT chk_cn_level CHECK (((level)::text = ANY ((ARRAY['BEGINNER'::character varying, 'INTERMEDIATE'::character varying, 'UPPER_INTERMEDIATE'::character varying, 'ADVANCED'::character varying])::text[])))
);


ALTER TABLE public.cultural_notes OWNER TO rodrigo;

--
-- Name: dashboard_metrics; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.dashboard_metrics (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    language character varying(5) NOT NULL,
    total_xp integer DEFAULT 0,
    current_streak integer DEFAULT 0,
    longest_streak integer DEFAULT 0,
    lessons_completed integer DEFAULT 0,
    lessons_in_progress integer DEFAULT 0,
    current_level character varying(30),
    xp_to_next_level integer DEFAULT 100,
    xp_in_current_level integer DEFAULT 0,
    weekly_xp integer DEFAULT 0,
    weekly_xp_by_day jsonb DEFAULT '{}'::jsonb,
    skill_vocabulary numeric(5,2) DEFAULT 0,
    skill_grammar numeric(5,2) DEFAULT 0,
    skill_listening numeric(5,2) DEFAULT 0,
    skill_writing numeric(5,2) DEFAULT 0,
    skill_speaking numeric(5,2) DEFAULT 0,
    achievements_count integer DEFAULT 0,
    current_league character varying(30) DEFAULT 'NONE'::character varying,
    league_rank integer,
    ai_sessions_count integer DEFAULT 0,
    last_computed_at timestamp without time zone DEFAULT now(),
    CONSTRAINT chk_dm_lang CHECK (((language)::text = ANY ((ARRAY['en'::character varying, 'es'::character varying])::text[])))
);


ALTER TABLE public.dashboard_metrics OWNER TO rodrigo;

--
-- Name: exercise_distractors; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.exercise_distractors (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    vocabulary_id uuid,
    distractor_type character varying(30) NOT NULL,
    distractor_value text NOT NULL,
    language character varying(5) NOT NULL,
    reason text,
    CONSTRAINT chk_dist_type CHECK (((distractor_type)::text = ANY ((ARRAY['SIMILAR_SOUND'::character varying, 'SAME_TOPIC'::character varying, 'COMMON_MISTAKE'::character varying, 'REGIONAL_VARIANT'::character varying, 'FALSE_FRIEND'::character varying, 'NEAR_SYNONYM'::character varying])::text[])))
);


ALTER TABLE public.exercise_distractors OWNER TO rodrigo;

--
-- Name: exercises; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.exercises (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    lesson_id uuid,
    exercise_type character varying(30) NOT NULL,
    prompt text NOT NULL,
    correct_answer text NOT NULL,
    options jsonb,
    audio_text text,
    hint text,
    display_order integer DEFAULT 0,
    grammar_rule_id uuid,
    vocabulary_ids uuid[],
    skill_tested character varying(20) DEFAULT 'VOCABULARY'::character varying,
    skill character varying(30),
    difficulty character varying(20) DEFAULT 'BEGINNER'::character varying,
    accepted_answers jsonb,
    phonetic_guide character varying(150),
    speech_rate character varying(10) DEFAULT 'NORMAL'::character varying,
    accent character varying(20) DEFAULT 'LATIN_AMERICAN'::character varying,
    distractor_logic character varying(30) DEFAULT 'SAME_TOPIC'::character varying,
    min_similarity_score numeric(3,2) DEFAULT 0.75,
    CONSTRAINT chk_ex_type CHECK (((exercise_type)::text = ANY ((ARRAY['IMAGE_PICK'::character varying, 'WORD_BANK'::character varying, 'AUDIO_TAP'::character varying, 'FILL_BLANK'::character varying, 'FREE_WRITE'::character varying, 'SPEAKING'::character varying, 'READING_COMPREHENSION'::character varying])::text[])))
);


ALTER TABLE public.exercises OWNER TO rodrigo;

--
-- Name: grammar_rules; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.grammar_rules (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    code character varying(60) NOT NULL,
    language character varying(5) NOT NULL,
    title character varying(150) NOT NULL,
    explanation text NOT NULL,
    level character varying(30) DEFAULT 'BEGINNER'::character varying NOT NULL,
    category character varying(40) DEFAULT 'VERBS'::character varying NOT NULL,
    examples jsonb DEFAULT '[]'::jsonb NOT NULL,
    common_mistakes jsonb DEFAULT '[]'::jsonb NOT NULL,
    related_rule_codes text[],
    display_order integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT chk_gr_cat CHECK (((category)::text = ANY ((ARRAY['VERBS'::character varying, 'NOUNS'::character varying, 'ADJECTIVES'::character varying, 'PRONOUNS'::character varying, 'PREPOSITIONS'::character varying, 'CONJUNCTIONS'::character varying, 'ARTICLES'::character varying, 'ADVERBS'::character varying, 'SENTENCE_STRUCTURE'::character varying, 'TENSES'::character varying, 'GENDER_NUMBER'::character varying, 'NEGATION'::character varying, 'QUESTIONS'::character varying, 'MODALS'::character varying])::text[]))),
    CONSTRAINT chk_gr_lang CHECK (((language)::text = ANY ((ARRAY['en'::character varying, 'es'::character varying])::text[]))),
    CONSTRAINT chk_gr_level CHECK (((level)::text = ANY ((ARRAY['BEGINNER'::character varying, 'INTERMEDIATE'::character varying, 'UPPER_INTERMEDIATE'::character varying, 'ADVANCED'::character varying])::text[])))
);


ALTER TABLE public.grammar_rules OWNER TO rodrigo;

--
-- Name: leaderboard_entries; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.leaderboard_entries (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    week_start date NOT NULL,
    xp_earned integer DEFAULT 0,
    league character varying(30) DEFAULT 'BRONZE'::character varying,
    rank integer
);


ALTER TABLE public.leaderboard_entries OWNER TO rodrigo;

--
-- Name: lesson_cultural_notes; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.lesson_cultural_notes (
    lesson_id uuid NOT NULL,
    cultural_note_id uuid NOT NULL,
    show_after_exercise integer DEFAULT 3
);


ALTER TABLE public.lesson_cultural_notes OWNER TO rodrigo;

--
-- Name: lesson_feedback; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.lesson_feedback (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    lesson_id uuid NOT NULL,
    rating integer,
    difficulty_felt character varying(20),
    comment text,
    submitted_at timestamp without time zone DEFAULT now(),
    CONSTRAINT chk_lf_diff_felt CHECK (((difficulty_felt)::text = ANY ((ARRAY['TOO_EASY'::character varying, 'JUST_RIGHT'::character varying, 'TOO_HARD'::character varying])::text[]))),
    CONSTRAINT lesson_feedback_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);


ALTER TABLE public.lesson_feedback OWNER TO rodrigo;

--
-- Name: lesson_navigation_log; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.lesson_navigation_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    lesson_id uuid,
    exercise_id uuid,
    action character varying(20) NOT NULL,
    from_exercise_order integer,
    to_exercise_order integer,
    "timestamp" timestamp without time zone DEFAULT now(),
    CONSTRAINT chk_nav_action CHECK (((action)::text = ANY ((ARRAY['START'::character varying, 'NEXT'::character varying, 'PREVIOUS'::character varying, 'SKIP'::character varying, 'EXIT'::character varying, 'COMPLETE'::character varying, 'RESUME'::character varying])::text[])))
);


ALTER TABLE public.lesson_navigation_log OWNER TO rodrigo;

--
-- Name: lesson_versions; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.lesson_versions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    lesson_id uuid NOT NULL,
    version_number integer NOT NULL,
    changed_by uuid,
    change_summary text,
    snapshot jsonb NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.lesson_versions OWNER TO rodrigo;

--
-- Name: lessons; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.lessons (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    unit_id uuid,
    title character varying(100) NOT NULL,
    lesson_number integer NOT NULL,
    total_lessons_in_unit integer NOT NULL,
    xp_reward integer DEFAULT 10,
    display_order integer DEFAULT 0,
    lesson_type character varying(30) DEFAULT 'VOCABULARY'::character varying,
    grammar_rule_id uuid,
    reading_passage_id uuid,
    estimated_minutes integer DEFAULT 5,
    prerequisite_lesson_id uuid,
    unlock_condition jsonb,
    CONSTRAINT chk_lesson_type CHECK (((lesson_type IS NULL) OR ((lesson_type)::text = ANY ((ARRAY['VOCABULARY'::character varying, 'GRAMMAR'::character varying, 'REVIEW'::character varying, 'CONVERSATION'::character varying, 'PRONUNCIATION'::character varying, 'READING'::character varying, 'WRITING'::character varying, 'CULTURE'::character varying])::text[]))))
);


ALTER TABLE public.lessons OWNER TO rodrigo;

--
-- Name: level_change_history; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.level_change_history (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    changed_by uuid,
    change_type character varying(20) NOT NULL,
    previous_level character varying(30),
    new_level character varying(30) NOT NULL,
    reason text,
    changed_at timestamp without time zone DEFAULT now(),
    CONSTRAINT chk_lch_new_level CHECK (((new_level)::text = ANY ((ARRAY['BEGINNER'::character varying, 'INTERMEDIATE'::character varying, 'UPPER_INTERMEDIATE'::character varying, 'ADVANCED'::character varying])::text[]))),
    CONSTRAINT chk_lch_type CHECK (((change_type)::text = ANY ((ARRAY['PLACEMENT_TEST'::character varying, 'REASSESSMENT'::character varying, 'ADMIN_MANUAL'::character varying, 'SYSTEM_AUTO'::character varying])::text[])))
);


ALTER TABLE public.level_change_history OWNER TO rodrigo;

--
-- Name: milestone_reassessments; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.milestone_reassessments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    language character varying(5) NOT NULL,
    triggered_at timestamp without time zone DEFAULT now(),
    trigger_reason character varying(50) NOT NULL,
    lessons_completed integer NOT NULL,
    previous_level character varying(30) NOT NULL,
    new_level character varying(30),
    skill_snapshot jsonb NOT NULL,
    reassessment_type character varying(30) DEFAULT 'AUTO'::character varying,
    test_id uuid,
    CONSTRAINT chk_mr_lang CHECK (((language)::text = ANY ((ARRAY['en'::character varying, 'es'::character varying])::text[]))),
    CONSTRAINT chk_mr_new CHECK ((((new_level)::text = ANY ((ARRAY['BEGINNER'::character varying, 'INTERMEDIATE'::character varying, 'UPPER_INTERMEDIATE'::character varying, 'ADVANCED'::character varying])::text[])) OR (new_level IS NULL))),
    CONSTRAINT chk_mr_prev CHECK (((previous_level)::text = ANY ((ARRAY['BEGINNER'::character varying, 'INTERMEDIATE'::character varying, 'UPPER_INTERMEDIATE'::character varying, 'ADVANCED'::character varying])::text[]))),
    CONSTRAINT chk_mr_trigger CHECK (((trigger_reason)::text = ANY ((ARRAY['LESSONS_MILESTONE'::character varying, 'XP_MILESTONE'::character varying, 'ADMIN_MANUAL'::character varying, 'USER_REQUESTED'::character varying, 'PERFORMANCE_DROP'::character varying, 'PERFORMANCE_JUMP'::character varying])::text[]))),
    CONSTRAINT chk_mr_type CHECK (((reassessment_type)::text = ANY ((ARRAY['AUTO'::character varying, 'MANUAL'::character varying, 'SCHEDULED'::character varying])::text[])))
);


ALTER TABLE public.milestone_reassessments OWNER TO rodrigo;

--
-- Name: notifications; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.notifications (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    type character varying(50) NOT NULL,
    title character varying(100) NOT NULL,
    body text,
    is_read boolean DEFAULT false,
    scheduled_at timestamp without time zone,
    delivered_at timestamp without time zone,
    delivery_status character varying(20) DEFAULT 'PENDING'::character varying,
    channel character varying(20) DEFAULT 'IN_APP'::character varying,
    retry_count integer DEFAULT 0,
    expires_at timestamp without time zone,
    sent_at timestamp without time zone DEFAULT now(),
    CONSTRAINT chk_delivery_status CHECK (((delivery_status)::text = ANY ((ARRAY['PENDING'::character varying, 'DELIVERED'::character varying, 'FAILED'::character varying, 'CANCELLED'::character varying, 'EXPIRED'::character varying])::text[]))),
    CONSTRAINT chk_notif_channel CHECK (((channel)::text = ANY ((ARRAY['IN_APP'::character varying, 'EMAIL'::character varying, 'PUSH'::character varying, 'SMS'::character varying])::text[]))),
    CONSTRAINT chk_notif_type CHECK (((type)::text = ANY ((ARRAY['STREAK_REMINDER'::character varying, 'ACHIEVEMENT'::character varying, 'QUEST_COMPLETE'::character varying, 'LEVEL_UP'::character varying, 'SUBSCRIPTION'::character varying, 'SYSTEM'::character varying, 'DAILY_REMINDER'::character varying, 'LESSON_REMINDER'::character varying, 'PAYMENT_FAILED'::character varying, 'PAYMENT_SUCCESS'::character varying, 'ACCOUNT_VERIFIED'::character varying, 'PASSWORD_RESET'::character varying, 'MILESTONE_REACHED'::character varying, 'REVIEW_DUE'::character varying])::text[])))
);


ALTER TABLE public.notifications OWNER TO rodrigo;

--
-- Name: payment_transactions; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.payment_transactions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    subscription_id uuid,
    transaction_ref character varying(255),
    gateway character varying(50) NOT NULL,
    amount numeric(10,2) NOT NULL,
    currency character varying(3) DEFAULT 'USD'::character varying,
    status character varying(20) NOT NULL,
    gateway_response jsonb,
    failure_reason text,
    initiated_at timestamp without time zone DEFAULT now(),
    completed_at timestamp without time zone,
    timeout_at timestamp without time zone,
    ip_address character varying(45),
    is_encrypted boolean DEFAULT true,
    CONSTRAINT chk_pt_gateway CHECK (((gateway)::text = ANY ((ARRAY['STRIPE'::character varying, 'PAYPAL'::character varying, 'APPLE_PAY'::character varying, 'GOOGLE_PAY'::character varying])::text[]))),
    CONSTRAINT chk_pt_status CHECK (((status)::text = ANY ((ARRAY['INITIATED'::character varying, 'PROCESSING'::character varying, 'COMPLETED'::character varying, 'FAILED'::character varying, 'TIMED_OUT'::character varying, 'REFUNDED'::character varying, 'CANCELLED'::character varying])::text[])))
);


ALTER TABLE public.payment_transactions OWNER TO rodrigo;

--
-- Name: personalized_lesson_plans; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.personalized_lesson_plans (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    language character varying(5) NOT NULL,
    generated_at timestamp without time zone DEFAULT now(),
    valid_until timestamp without time zone,
    skill_snapshot jsonb NOT NULL,
    lesson_allocation jsonb NOT NULL,
    is_active boolean DEFAULT true
);


ALTER TABLE public.personalized_lesson_plans OWNER TO rodrigo;

--
-- Name: personalized_lesson_queue; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.personalized_lesson_queue (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    plan_id uuid,
    user_id uuid NOT NULL,
    lesson_id uuid NOT NULL,
    reason character varying(50) NOT NULL,
    priority integer DEFAULT 0,
    is_completed boolean DEFAULT false,
    completed_at timestamp without time zone,
    CONSTRAINT chk_plq_reason CHECK (((reason)::text = ANY ((ARRAY['WEAK_GRAMMAR'::character varying, 'WEAK_VOCABULARY'::character varying, 'WEAK_LISTENING'::character varying, 'WEAK_WRITING'::character varying, 'MISTAKE_PATTERN'::character varying, 'SPACED_REPETITION'::character varying, 'LEVEL_PROGRESSION'::character varying, 'USER_SELECTED_TOPIC'::character varying])::text[])))
);


ALTER TABLE public.personalized_lesson_queue OWNER TO rodrigo;

--
-- Name: phrases; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.phrases (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    language character varying(5) NOT NULL,
    phrase text NOT NULL,
    translation text NOT NULL,
    phonetic_guide character varying(200),
    context character varying(50),
    level character varying(30) DEFAULT 'BEGINNER'::character varying,
    topic_tag character varying(50),
    formality character varying(10) DEFAULT 'NEUTRAL'::character varying,
    audio_text text,
    example_dialogue jsonb,
    CONSTRAINT chk_phrase_formality CHECK (((formality)::text = ANY ((ARRAY['FORMAL'::character varying, 'NEUTRAL'::character varying, 'INFORMAL'::character varying, 'SLANG'::character varying])::text[]))),
    CONSTRAINT chk_phrase_lang CHECK (((language)::text = ANY ((ARRAY['en'::character varying, 'es'::character varying])::text[]))),
    CONSTRAINT chk_phrase_level CHECK (((level)::text = ANY ((ARRAY['BEGINNER'::character varying, 'INTERMEDIATE'::character varying, 'UPPER_INTERMEDIATE'::character varying, 'ADVANCED'::character varying])::text[])))
);


ALTER TABLE public.phrases OWNER TO rodrigo;

--
-- Name: placement_answers; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.placement_answers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    test_id uuid,
    question_index integer NOT NULL,
    question_type character varying(30) NOT NULL,
    user_answer text,
    correct_answer text NOT NULL,
    is_correct boolean NOT NULL
);


ALTER TABLE public.placement_answers OWNER TO rodrigo;

--
-- Name: placement_questions; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.placement_questions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    language character varying(5) NOT NULL,
    question_index integer NOT NULL,
    question_type character varying(30) NOT NULL,
    prompt text NOT NULL,
    options jsonb,
    correct_answer text NOT NULL,
    difficulty character varying(20) DEFAULT 'BEGINNER'::character varying,
    skill_tested character varying(30),
    next_question_if_correct integer,
    next_question_if_wrong integer,
    points_value integer DEFAULT 1,
    time_limit_seconds integer DEFAULT 30,
    CONSTRAINT chk_pq_diff CHECK (((difficulty)::text = ANY ((ARRAY['BEGINNER'::character varying, 'INTERMEDIATE'::character varying, 'UPPER_INTERMEDIATE'::character varying, 'ADVANCED'::character varying])::text[]))),
    CONSTRAINT chk_pq_lang CHECK (((language)::text = ANY ((ARRAY['en'::character varying, 'es'::character varying])::text[]))),
    CONSTRAINT chk_pq_type CHECK (((question_type)::text = ANY ((ARRAY['IMAGE_PICK'::character varying, 'GRAMMAR_FILL'::character varying, 'READING'::character varying, 'AUDIO_TAP'::character varying, 'FREE_WRITE'::character varying])::text[])))
);


ALTER TABLE public.placement_questions OWNER TO rodrigo;

--
-- Name: placement_tests; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.placement_tests (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    language character varying(5) NOT NULL,
    score integer NOT NULL,
    total_questions integer DEFAULT 10,
    percentage_score numeric(5,2),
    assigned_level character varying(30) NOT NULL,
    duration_seconds integer,
    was_completed boolean DEFAULT true,
    exit_reason character varying(50),
    difficulty_path jsonb,
    recommended_unit_id uuid,
    taken_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.placement_tests OWNER TO rodrigo;

--
-- Name: quests; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.quests (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    code character varying(50) NOT NULL,
    title character varying(100) NOT NULL,
    icon character varying(10),
    target_value integer NOT NULL,
    xp_reward integer DEFAULT 10
);


ALTER TABLE public.quests OWNER TO rodrigo;

--
-- Name: reading_passages; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.reading_passages (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    language character varying(5) NOT NULL,
    title character varying(150),
    body text NOT NULL,
    translation text,
    level character varying(30) DEFAULT 'BEGINNER'::character varying NOT NULL,
    topic_tag character varying(50),
    word_count integer,
    estimated_minutes integer DEFAULT 2,
    vocabulary_ids uuid[],
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT chk_rp_lang CHECK (((language)::text = ANY ((ARRAY['en'::character varying, 'es'::character varying])::text[]))),
    CONSTRAINT chk_rp_level CHECK (((level)::text = ANY ((ARRAY['BEGINNER'::character varying, 'INTERMEDIATE'::character varying, 'UPPER_INTERMEDIATE'::character varying, 'ADVANCED'::character varying])::text[])))
);


ALTER TABLE public.reading_passages OWNER TO rodrigo;

--
-- Name: reading_questions; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.reading_questions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    passage_id uuid,
    question_text text NOT NULL,
    question_type character varying(20) DEFAULT 'MULTIPLE_CHOICE'::character varying,
    choices jsonb,
    correct_answer text NOT NULL,
    explanation text,
    display_order integer DEFAULT 0,
    CONSTRAINT chk_rq_type CHECK (((question_type)::text = ANY ((ARRAY['MULTIPLE_CHOICE'::character varying, 'TRUE_FALSE'::character varying, 'SHORT_ANSWER'::character varying, 'VOCABULARY_IN_CONTEXT'::character varying])::text[])))
);


ALTER TABLE public.reading_questions OWNER TO rodrigo;

--
-- Name: review_sessions; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.review_sessions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    language character varying(5) NOT NULL,
    session_type character varying(20) DEFAULT 'SPACED_REPETITION'::character varying NOT NULL,
    status character varying(20) DEFAULT 'PENDING'::character varying,
    words_due uuid[],
    rules_due uuid[],
    total_items integer DEFAULT 0,
    items_reviewed integer DEFAULT 0,
    items_correct integer DEFAULT 0,
    xp_awarded integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT now(),
    completed_at timestamp without time zone,
    CONSTRAINT chk_rs_status CHECK (((status)::text = ANY ((ARRAY['PENDING'::character varying, 'IN_PROGRESS'::character varying, 'COMPLETED'::character varying, 'SKIPPED'::character varying])::text[]))),
    CONSTRAINT chk_rs_type CHECK (((session_type)::text = ANY ((ARRAY['SPACED_REPETITION'::character varying, 'MISTAKE_FOCUS'::character varying, 'WEAK_SKILL'::character varying, 'DAILY_REVIEW'::character varying])::text[])))
);


ALTER TABLE public.review_sessions OWNER TO rodrigo;

--
-- Name: sections; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.sections (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title character varying(100) NOT NULL,
    language character varying(5) NOT NULL,
    level character varying(30) NOT NULL,
    display_order integer DEFAULT 0,
    CONSTRAINT chk_sec_lang CHECK (((language)::text = ANY ((ARRAY['en'::character varying, 'es'::character varying])::text[]))),
    CONSTRAINT chk_sec_level CHECK (((level)::text = ANY ((ARRAY['BEGINNER'::character varying, 'INTERMEDIATE'::character varying, 'UPPER_INTERMEDIATE'::character varying, 'ADVANCED'::character varying])::text[])))
);


ALTER TABLE public.sections OWNER TO rodrigo;

--
-- Name: skill_breakdown_reports; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.skill_breakdown_reports (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    language character varying(5) NOT NULL,
    report_date date DEFAULT CURRENT_DATE,
    vocabulary_score numeric(5,2) DEFAULT 0,
    grammar_score numeric(5,2) DEFAULT 0,
    listening_score numeric(5,2) DEFAULT 0,
    writing_score numeric(5,2) DEFAULT 0,
    speaking_score numeric(5,2) DEFAULT 0,
    overall_score numeric(5,2) DEFAULT 0,
    weak_areas text[],
    strong_areas text[],
    recommended_focus text[],
    lessons_this_period integer DEFAULT 0,
    xp_this_period integer DEFAULT 0,
    generated_at timestamp without time zone DEFAULT now(),
    CONSTRAINT chk_sbr_lang CHECK (((language)::text = ANY ((ARRAY['en'::character varying, 'es'::character varying])::text[])))
);


ALTER TABLE public.skill_breakdown_reports OWNER TO rodrigo;

--
-- Name: speaking_attempts; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.speaking_attempts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    exercise_id uuid NOT NULL,
    target_phrase text NOT NULL,
    transcribed_text text,
    similarity_score numeric(4,3),
    phoneme_errors jsonb,
    passed boolean,
    audio_duration_ms integer,
    attempted_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.speaking_attempts OWNER TO rodrigo;

--
-- Name: streak_history; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.streak_history (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    streak_date date NOT NULL,
    was_active boolean DEFAULT true
);


ALTER TABLE public.streak_history OWNER TO rodrigo;

--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.subscriptions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    plan character varying(20) NOT NULL,
    status character varying(20) DEFAULT 'ACTIVE'::character varying,
    started_at timestamp without time zone DEFAULT now(),
    expires_at timestamp without time zone NOT NULL,
    payment_reference character varying(255),
    transaction_id character varying(255),
    payment_gateway character varying(50) DEFAULT 'STRIPE'::character varying,
    payment_method character varying(30),
    payment_status character varying(20) DEFAULT 'COMPLETED'::character varying,
    trial_start_date timestamp without time zone,
    trial_end_date timestamp without time zone,
    auto_renew boolean DEFAULT true,
    cancellation_reason text,
    last_payment_at timestamp without time zone,
    next_billing_date timestamp without time zone,
    amount_paid numeric(10,2),
    currency character varying(3) DEFAULT 'USD'::character varying,
    cancelled_at timestamp without time zone,
    CONSTRAINT chk_payment_gateway CHECK (((payment_gateway)::text = ANY ((ARRAY['STRIPE'::character varying, 'PAYPAL'::character varying, 'APPLE_PAY'::character varying, 'GOOGLE_PAY'::character varying])::text[]))),
    CONSTRAINT chk_payment_status CHECK (((payment_status)::text = ANY ((ARRAY['PENDING'::character varying, 'COMPLETED'::character varying, 'FAILED'::character varying, 'REFUNDED'::character varying, 'TIMED_OUT'::character varying])::text[]))),
    CONSTRAINT chk_plan CHECK (((plan)::text = ANY ((ARRAY['TRIAL'::character varying, 'MONTHLY'::character varying, 'ANNUAL'::character varying])::text[]))),
    CONSTRAINT chk_status CHECK (((status)::text = ANY ((ARRAY['ACTIVE'::character varying, 'CANCELLED'::character varying, 'EXPIRED'::character varying])::text[])))
);


ALTER TABLE public.subscriptions OWNER TO rodrigo;

--
-- Name: system_performance_log; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.system_performance_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    endpoint character varying(200) NOT NULL,
    method character varying(10) NOT NULL,
    response_ms integer NOT NULL,
    status_code integer NOT NULL,
    user_id uuid,
    threshold_ms integer,
    exceeded_threshold boolean DEFAULT false,
    logged_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.system_performance_log OWNER TO rodrigo;

--
-- Name: topics; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.topics (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    code character varying(50) NOT NULL,
    name character varying(100) NOT NULL,
    icon character varying(10),
    description text,
    language character varying(5) NOT NULL,
    display_order integer DEFAULT 0,
    CONSTRAINT chk_topic_lang CHECK (((language)::text = ANY ((ARRAY['en'::character varying, 'es'::character varying])::text[])))
);


ALTER TABLE public.topics OWNER TO rodrigo;

--
-- Name: units; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.units (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    section_id uuid,
    title character varying(100) NOT NULL,
    description text,
    topic_code character varying(50),
    display_order integer DEFAULT 0
);


ALTER TABLE public.units OWNER TO rodrigo;

--
-- Name: user_achievements; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.user_achievements (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    achievement_id uuid,
    current_level integer DEFAULT 0,
    progress integer DEFAULT 0,
    unlocked_at timestamp without time zone
);


ALTER TABLE public.user_achievements OWNER TO rodrigo;

--
-- Name: user_daily_quests; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.user_daily_quests (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    quest_id uuid,
    quest_date date DEFAULT CURRENT_DATE,
    current_value integer DEFAULT 0,
    is_completed boolean DEFAULT false,
    completed_at timestamp without time zone
);


ALTER TABLE public.user_daily_quests OWNER TO rodrigo;

--
-- Name: user_exercise_attempts; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.user_exercise_attempts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    exercise_id uuid,
    user_answer text,
    is_correct boolean NOT NULL,
    attempted_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.user_exercise_attempts OWNER TO rodrigo;

--
-- Name: user_learning_preferences; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.user_learning_preferences (
    user_id uuid NOT NULL,
    daily_goal_xp integer DEFAULT 10,
    session_length_minutes integer DEFAULT 5,
    preferred_exercise_types text[],
    weak_skills_focus boolean DEFAULT true,
    spaced_repetition_on boolean DEFAULT true,
    show_cultural_notes boolean DEFAULT true,
    show_phonetic_guides boolean DEFAULT true,
    accent_preference character varying(20) DEFAULT 'LATIN_AMERICAN'::character varying,
    reminder_time time without time zone,
    updated_at timestamp without time zone DEFAULT now(),
    CONSTRAINT chk_ulp_accent CHECK (((accent_preference)::text = ANY ((ARRAY['LATIN_AMERICAN'::character varying, 'CASTILIAN'::character varying, 'AMERICAN_ENGLISH'::character varying, 'BRITISH_ENGLISH'::character varying])::text[])))
);


ALTER TABLE public.user_learning_preferences OWNER TO rodrigo;

--
-- Name: user_lesson_progress; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.user_lesson_progress (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    lesson_id uuid,
    status character varying(20) DEFAULT 'LOCKED'::character varying,
    exercises_correct integer DEFAULT 0,
    exercises_total integer DEFAULT 0,
    score_percentage numeric(5,2),
    xp_earned integer DEFAULT 0,
    time_spent_seconds integer DEFAULT 0,
    attempts integer DEFAULT 1,
    milestone_reached boolean DEFAULT false,
    next_recommended_lesson_id uuid,
    completed_at timestamp without time zone,
    started_at timestamp without time zone,
    CONSTRAINT chk_prog_status CHECK (((status)::text = ANY ((ARRAY['LOCKED'::character varying, 'AVAILABLE'::character varying, 'IN_PROGRESS'::character varying, 'COMPLETED'::character varying])::text[])))
);


ALTER TABLE public.user_lesson_progress OWNER TO rodrigo;

--
-- Name: user_mistake_patterns; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.user_mistake_patterns (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    language character varying(5) NOT NULL,
    mistake_type character varying(30) NOT NULL,
    grammar_rule_id uuid,
    vocabulary_id uuid,
    mistake_count integer DEFAULT 1,
    resolved_count integer DEFAULT 0,
    last_made_at timestamp without time zone DEFAULT now(),
    last_example_wrong text,
    last_example_correct text,
    scheduled_review boolean DEFAULT false,
    CONSTRAINT chk_ump_mistake_type CHECK (((mistake_type)::text = ANY ((ARRAY['GRAMMAR_RULE'::character varying, 'VOCABULARY'::character varying, 'CONJUGATION'::character varying, 'GENDER_AGREEMENT'::character varying, 'ACCENT_MARK'::character varying, 'WORD_ORDER'::character varying, 'SER_ESTAR'::character varying, 'PARA_POR'::character varying, 'SUBJUNCTIVE'::character varying, 'FALSE_FRIEND'::character varying])::text[])))
);


ALTER TABLE public.user_mistake_patterns OWNER TO rodrigo;

--
-- Name: user_skills; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.user_skills (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    language character varying(5) NOT NULL,
    vocabulary_score numeric(5,2) DEFAULT 0,
    grammar_score numeric(5,2) DEFAULT 0,
    listening_score numeric(5,2) DEFAULT 0,
    writing_score numeric(5,2) DEFAULT 0,
    speaking_score numeric(5,2) DEFAULT 0,
    pronunciation_score numeric(5,2) DEFAULT 0,
    overall_score numeric(5,2) DEFAULT 0,
    lessons_completed integer DEFAULT 0,
    exercises_attempted integer DEFAULT 0,
    exercises_correct integer DEFAULT 0,
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.user_skills OWNER TO rodrigo;

--
-- Name: user_topics; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.user_topics (
    user_id uuid NOT NULL,
    topic_id uuid NOT NULL,
    selected_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.user_topics OWNER TO rodrigo;

--
-- Name: user_word_memory; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.user_word_memory (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    vocabulary_id uuid NOT NULL,
    times_seen integer DEFAULT 0,
    times_correct integer DEFAULT 0,
    times_incorrect integer DEFAULT 0,
    last_seen_at timestamp without time zone,
    next_review_at timestamp without time zone,
    ease_factor numeric(4,2) DEFAULT 2.50,
    interval_days integer DEFAULT 1,
    memory_strength character varying(20) DEFAULT 'UNSEEN'::character varying,
    last_answer text,
    last_was_correct boolean,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    CONSTRAINT chk_memory_strength CHECK (((memory_strength)::text = ANY ((ARRAY['UNSEEN'::character varying, 'LEARNING'::character varying, 'FAMILIAR'::character varying, 'STRONG'::character varying, 'MASTERED'::character varying])::text[])))
);


ALTER TABLE public.user_word_memory OWNER TO rodrigo;

--
-- Name: users; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    full_name character varying(100) NOT NULL,
    email character varying(255) NOT NULL,
    username character varying(50) NOT NULL,
    password_hash character varying(255),
    oauth_provider character varying(20),
    oauth_id character varying(255),
    native_language character varying(5) DEFAULT 'en'::character varying NOT NULL,
    learning_language character varying(5) DEFAULT 'es'::character varying NOT NULL,
    assigned_level character varying(30),
    role character varying(20) DEFAULT 'LEARNER'::character varying NOT NULL,
    is_verified boolean DEFAULT false,
    account_status character varying(20) DEFAULT 'PENDING_VERIFICATION'::character varying,
    email_verification_token character varying(255),
    email_verified_at timestamp without time zone,
    password_reset_token character varying(255),
    password_reset_expires timestamp without time zone,
    is_premium boolean DEFAULT false,
    premium_expires_at timestamp without time zone,
    xp integer DEFAULT 0,
    streak_count integer DEFAULT 0,
    last_active_date date,
    last_login_at timestamp without time zone,
    login_count integer DEFAULT 0,
    learning_goals character varying(255),
    profile_picture_url character varying(500),
    onboarding_completed boolean DEFAULT false,
    is_active boolean DEFAULT true,
    joined_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    CONSTRAINT chk_account_status CHECK (((account_status)::text = ANY ((ARRAY['PENDING_VERIFICATION'::character varying, 'ACTIVE'::character varying, 'SUSPENDED'::character varying, 'DEACTIVATED'::character varying])::text[]))),
    CONSTRAINT chk_learn_lang CHECK (((learning_language)::text = ANY ((ARRAY['en'::character varying, 'es'::character varying])::text[]))),
    CONSTRAINT chk_level CHECK ((((assigned_level)::text = ANY ((ARRAY['BEGINNER'::character varying, 'INTERMEDIATE'::character varying, 'UPPER_INTERMEDIATE'::character varying, 'ADVANCED'::character varying])::text[])) OR (assigned_level IS NULL))),
    CONSTRAINT chk_native_lang CHECK (((native_language)::text = ANY ((ARRAY['en'::character varying, 'es'::character varying])::text[]))),
    CONSTRAINT chk_role CHECK (((role)::text = ANY ((ARRAY['LEARNER'::character varying, 'ADMIN'::character varying, 'CONTENT_CREATOR'::character varying])::text[])))
);


ALTER TABLE public.users OWNER TO rodrigo;

--
-- Name: vocabulary; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.vocabulary (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    word character varying(100) NOT NULL,
    language character varying(5) NOT NULL,
    translation character varying(100) NOT NULL,
    transliteration character varying(100),
    part_of_speech character varying(30),
    topic_tag character varying(50),
    level character varying(30) DEFAULT 'BEGINNER'::character varying NOT NULL,
    example_sentence text,
    example_translation text,
    audio_text text,
    image_keyword character varying(100),
    gender character varying(10),
    plural_form character varying(100),
    conjugation_group character varying(20),
    audio_phonetic character varying(150),
    phonetic_guide character varying(150),
    frequency_rank integer,
    accent character varying(20) DEFAULT 'LATIN_AMERICAN'::character varying,
    regional_variants jsonb,
    tags text[],
    is_irregular boolean DEFAULT false,
    notes text,
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT chk_vocab_lang CHECK (((language)::text = ANY ((ARRAY['en'::character varying, 'es'::character varying])::text[]))),
    CONSTRAINT chk_vocab_level CHECK (((level)::text = ANY ((ARRAY['BEGINNER'::character varying, 'INTERMEDIATE'::character varying, 'UPPER_INTERMEDIATE'::character varying, 'ADVANCED'::character varying])::text[])))
);


ALTER TABLE public.vocabulary OWNER TO rodrigo;

--
-- Name: word_relationships; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.word_relationships (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    word_id_1 uuid NOT NULL,
    word_id_2 uuid NOT NULL,
    relationship character varying(30) NOT NULL,
    notes text,
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT chk_relationship CHECK (((relationship)::text = ANY ((ARRAY['SYNONYM'::character varying, 'ANTONYM'::character varying, 'FAMILY'::character varying, 'COMMONLY_CONFUSED'::character varying, 'REGIONAL_VARIANT'::character varying, 'FORMAL_INFORMAL'::character varying, 'DERIVED_FROM'::character varying])::text[])))
);


ALTER TABLE public.word_relationships OWNER TO rodrigo;

--
-- Name: xp_history; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.xp_history (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    amount integer NOT NULL,
    source character varying(50) NOT NULL,
    earned_at timestamp without time zone DEFAULT now(),
    CONSTRAINT chk_xp_source CHECK (((source)::text = ANY ((ARRAY['LESSON'::character varying, 'AI_SESSION'::character varying, 'PLACEMENT'::character varying, 'QUEST'::character varying, 'ACHIEVEMENT'::character varying, 'BONUS'::character varying])::text[])))
);


ALTER TABLE public.xp_history OWNER TO rodrigo;

--
-- Data for Name: accessibility_preferences; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.accessibility_preferences (user_id, high_contrast_mode, font_size, reduced_motion, screen_reader_mode, color_blind_mode, audio_descriptions, keyboard_nav_only, updated_at) FROM stdin;
\.


--
-- Data for Name: achievements; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.achievements (id, code, name, description, icon, max_level, xp_reward, thresholds) FROM stdin;
257a772e-ee0e-4b09-9ed2-51cc448f9a7b	WILDFIRE	Wildfire	Maintain a daily learning streak.	🔥	3	25	{"levels": [3, 7, 30]}
583bfa50-efea-4039-8f39-5eee31afab06	XP_COLLECTOR	XP Collector	Earn total XP through lessons and practice.	⚡	3	50	{"levels": [100, 500, 1000]}
370a5c48-e461-47db-b0f6-0d7979e2408b	CONVERSATIONALIST	Conversationalist	Complete AI conversation practice sessions.	🗣️	3	50	{"levels": [5, 20, 50]}
ae3f50b2-d8f8-440b-9fb7-10d3e8e55062	BOOKWORM	Bookworm	Complete lessons to build your knowledge.	📚	3	75	{"levels": [10, 50, 100]}
829f6e8b-da9d-4c36-8f2f-6ee8623ccab5	PERFECTIONIST	Perfectionist	Complete lessons with a perfect score.	⭐	3	100	{"levels": [1, 5, 20]}
8f1f409f-5d12-4066-8696-e4c24dbbaba1	EARLY_BIRD	Early Bird	Complete a lesson before 9am.	🌅	1	20	{"levels": [1]}
19c04724-ae3b-46ba-8bca-bbcbeecd1e81	NIGHT_OWL	Night Owl	Complete a lesson after 10pm.	🦉	1	20	{"levels": [1]}
e309f457-1bc9-4fdd-bc94-8520fed7213a	SOCIAL_BUTTERFLY	Social Butterfly	Invite friends to join Fluentia.	🦋	3	30	{"levels": [1, 3, 10]}
8bf8cbba-1534-4e24-aa46-81386789aa2b	POLYGLOT	Polyglot	Study both English and Spanish.	🌍	1	100	{"levels": [1]}
864b8547-2d70-4d94-985a-04797b858dd6	PREMIUM_LEARNER	Premium Learner	Subscribe to Fluentia Premium.	💎	1	50	{"levels": [1]}
8ee4cde7-aacd-47c5-9912-0f9f2cee6bad	PLACEMENT_ACE	Placement Ace	Score 80% or higher on the placement test.	🎯	1	50	{"levels": [1]}
32fa36ae-60c0-42fa-8618-583aff48d7c3	VOCABULARY_MASTER	Vocabulary Master	Reach 80% vocabulary skill score.	📖	3	75	{"levels": [50, 70, 80]}
d930c1a1-657c-4d16-bfde-652248684a99	GRAMMAR_GURU	Grammar Guru	Reach 80% grammar skill score.	✏️	3	75	{"levels": [50, 70, 80]}
45fe8d02-048c-419f-a2fc-6bd83b251f03	LISTENING_PRO	Listening Pro	Reach 80% listening skill score.	🎧	3	75	{"levels": [50, 70, 80]}
bfc983e0-9e0f-420b-8cfd-c68c9ae7db10	WRITER	Writer	Reach 80% writing skill score.	✍️	3	75	{"levels": [50, 70, 80]}
9310f01b-4317-4f14-817b-7950300582bc	UNIT_COMPLETE	Unit Complete	Complete all lessons in a unit.	🏆	3	100	{"levels": [1, 5, 10]}
9be64206-863c-474a-9d4a-5f289451a15f	SPEED_LEARNER	Speed Learner	Complete a lesson in under 3 minutes.	⚡	1	30	{"levels": [1]}
b855afd1-1be8-40e0-bd7c-7848be368c27	COMEBACK_KID	Comeback Kid	Return to learning after missing 3 or more days.	💪	1	25	{"levels": [1]}
\.


--
-- Data for Name: admin_level_adjustments; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.admin_level_adjustments (id, admin_id, learner_id, previous_level, new_level, justification, adjusted_at) FROM stdin;
\.


--
-- Data for Name: ai_conversation_templates; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.ai_conversation_templates (id, language, title, scenario, topic_tag, level, opening_prompt, target_vocabulary, target_grammar_rules, min_exchanges, evaluation_criteria) FROM stdin;
dffd1582-183d-40a2-87e7-3c97f14d5421	es	Ordering at a restaurant	You are a customer at a Spanish restaurant. The AI plays the waiter. Practice ordering food and drinks, asking about the menu, and paying the bill.	FOOD_ES	BEGINNER	¡Buenas tardes! Bienvenido al Restaurante El Rincón. ¿Tiene reservación o prefiere una mesa disponible?	\N	\N	6	{"politeness": true, "task_completion": true, "grammar_accuracy": true, "vocabulary_range": true}
c5b7e5e4-f100-4f88-a112-b2ca78819434	es	Asking for directions in the city	You are a tourist in Mexico City. The AI plays a local resident. Practice asking for and understanding directions to common places.	TRAVEL_ES	BEGINNER	Hola, ¿en qué le puedo ayudar? Parece que está buscando algo.	\N	\N	5	{"comprehension": true, "grammar_accuracy": true, "direction_vocabulary": true}
02a9be1b-9366-4d63-81da-e779607ae5ef	es	Professional introduction at a business meeting	You are attending a business conference in Bogotá. The AI plays a Colombian business professional. Practice introducing yourself, your company, and your role.	BUSINESS_ES	INTERMEDIATE	Buenos días. Me alegra conocerle. Soy Juan Martínez, director de ventas de Innovatech Colombia. ¿Y usted?	\N	\N	8	{"fluency": true, "formal_register": true, "grammar_accuracy": true, "vocabulary_range": true}
ac6c7af3-c1c8-4391-921d-0b3a0ba1c35c	es	Visiting the doctor	You are not feeling well and visit a Spanish-speaking doctor. The AI plays the doctor. Practice describing symptoms and understanding medical instructions.	HEALTH_ES	INTERMEDIATE	Buenos días, pase por favor. Siéntese. ¿Qué le trae por aquí hoy?	\N	\N	6	{"grammar_accuracy": true, "health_vocabulary": true, "symptom_description": true}
08fe3bc3-3226-4085-b7b0-df7cf60f60a7	en	Ordering at a restaurant	You are a customer at an American restaurant. The AI plays the server. Practice ordering food and drinks, asking questions about the menu, and paying.	FOOD_EN	BEGINNER	Hi there! Welcome to The Green Fork. I will be your server today. Can I start you off with something to drink?	\N	\N	6	{"politeness": true, "task_completion": true, "grammar_accuracy": true, "vocabulary_range": true}
d0e16238-b464-42f7-a9ce-fc144ef72480	en	Job interview in English	You are interviewing for a position at an American company. The AI plays the interviewer. Practice answering common interview questions professionally.	BUSINESS_EN	INTERMEDIATE	Good morning! Thank you for coming in today. Please have a seat. So, tell me a little about yourself and your background.	\N	\N	8	{"confidence": true, "formal_register": true, "grammar_accuracy": true, "vocabulary_range": true}
5b90689d-4a52-4b1f-a655-6362ed263649	en	Calling customer service	You need to resolve an issue with a product you bought. The AI plays the customer service representative. Practice explaining a problem and asking for help over the phone.	CONVERSATION_EN	INTERMEDIATE	Thank you for calling SuperMart customer service. My name is Alex. How can I help you today?	\N	\N	6	{"clarity": true, "grammar_accuracy": true, "problem_description": true, "polite_assertiveness": true}
6e3d099b-095c-4e1e-967e-a1c5d04936e5	en	Going to the doctor	You are not feeling well and visit an American doctor. The AI plays the doctor. Practice describing your symptoms in English.	HEALTH_EN	INTERMEDIATE	Good morning! Come on in. So what brings you in to see me today? What seems to be the problem?	\N	\N	6	{"grammar_accuracy": true, "health_vocabulary": true, "symptom_description": true}
8cb9211f-b752-4d5a-84fc-413f79dd167b	es	Ordering at a restaurant	You are at a restaurant in Madrid. Order food and drinks, ask about the menu, and ask for the bill.	FOOD_ES	BEGINNER	Buenas tardes. Soy su camarero. ¿Qué desean tomar?	\N	\N	4	{"fluency": 0.2, "grammar": 0.3, "politeness": 0.2, "vocabulary": 0.3}
d37b4cf6-42ae-443b-b624-1a02edc0d3aa	es	Checking into a hotel	You arrive at a hotel. Check in, give your reservation name, and ask about breakfast and checkout time.	TRAVEL_ES	BEGINNER	Bienvenido al hotel. ¿Tiene una reserva a su nombre?	\N	\N	4	{"fluency": 0.2, "grammar": 0.3, "politeness": 0.2, "vocabulary": 0.3}
81f00eb4-91aa-4b5a-9ec0-9d4f89db5343	es	At the airport	You are at the airport. Check in for your flight, ask about the gate, and confirm your seat.	TRAVEL_ES	INTERMEDIATE	Buenos días. ¿En qué puedo ayudarle? ¿Va a facturar equipaje?	\N	\N	4	{"fluency": 0.2, "grammar": 0.3, "politeness": 0.2, "vocabulary": 0.3}
181cd5c5-8969-4dbf-8cd8-6edc6a749caf	es	At the pharmacy	You need medicine. Describe your symptoms and ask the pharmacist for something for a headache or cold.	HEALTH_ES	BEGINNER	Buenas tardes. ¿Qué necesita?	\N	\N	4	{"clarity": 0.2, "fluency": 0.2, "grammar": 0.3, "vocabulary": 0.3}
9815a98d-5b92-4a44-a7d3-303994a4fab8	es	Job interview	You are in a job interview. Introduce yourself, talk about your experience, and answer questions about your strengths.	BUSINESS_ES	INTERMEDIATE	Bienvenido. Cuéntenos un poco sobre usted y su experiencia.	\N	\N	5	{"fluency": 0.25, "grammar": 0.25, "vocabulary": 0.25, "professionalism": 0.25}
513a2c40-4064-444b-890b-78c53ad7b893	es	Meeting new coworkers	It is your first day. Introduce yourself to colleagues, say what your role is, and ask where things are.	BUSINESS_ES	BEGINNER	Hola, soy María. ¿Eres nuevo en el equipo?	\N	\N	4	{"fluency": 0.2, "grammar": 0.3, "politeness": 0.2, "vocabulary": 0.3}
e7ccbf4c-585e-4087-97b2-fd2d3ec94c64	es	Shopping in a market	You are at a local market. Ask for prices, quantities, and pay. Try to bargain politely.	FOOD_ES	BEGINNER	Buenos días. ¿Qué desea? Tenemos frutas y verduras frescas.	\N	\N	4	{"fluency": 0.2, "grammar": 0.3, "politeness": 0.2, "vocabulary": 0.3}
7b1adb99-2145-493f-8115-9071c70d7a99	es	Asking for directions	You are lost in the city. Ask how to get to the train station or a famous square.	TRAVEL_ES	BEGINNER	Perdón, ¿sabe dónde está la estación de tren?	\N	\N	4	{"clarity": 0.2, "fluency": 0.2, "grammar": 0.3, "vocabulary": 0.3}
ff55abdd-fbca-4c26-89e8-09b0c028b904	en	Ordering at a restaurant	You are at a restaurant. Order food and drinks and ask for the bill.	FOOD_EN	BEGINNER	Good evening. I am your server. What would you like to drink?	\N	\N	4	{"fluency": 0.2, "grammar": 0.3, "politeness": 0.2, "vocabulary": 0.3}
a3dbb7e8-4420-434d-97f9-a0ae71106303	en	Checking into a hotel	You arrive at a hotel. Check in and ask about breakfast and checkout.	TRAVEL_EN	BEGINNER	Welcome to the hotel. Do you have a reservation under your name?	\N	\N	4	{"fluency": 0.2, "grammar": 0.3, "politeness": 0.2, "vocabulary": 0.3}
e6e21b8a-d1f1-49bb-80ca-d66994ccbb11	en	At the airport	You are at the airport. Check in and ask about your gate.	TRAVEL_EN	INTERMEDIATE	Good morning. How can I help you? Are you checking any bags?	\N	\N	4	{"fluency": 0.2, "grammar": 0.3, "politeness": 0.2, "vocabulary": 0.3}
b4f17964-e205-4ebe-b22f-83a7cf1c7cea	en	Job interview	You are in a job interview. Introduce yourself and talk about your experience.	BUSINESS_EN	INTERMEDIATE	Welcome. Tell us a little about yourself and your experience.	\N	\N	5	{"fluency": 0.25, "grammar": 0.25, "vocabulary": 0.25, "professionalism": 0.25}
dbcb4847-6ea6-43d2-818e-fb45debcb223	en	At the pharmacy	You need medicine. Describe your symptoms and ask for something for a headache.	HEALTH_EN	BEGINNER	Good afternoon. What do you need?	\N	\N	4	{"clarity": 0.2, "fluency": 0.2, "grammar": 0.3, "vocabulary": 0.3}
c363c341-e641-4ce2-824b-4686e9b170c0	en	Shopping in a market	You are at a market. Ask for prices and pay.	FOOD_EN	BEGINNER	Good morning. What would you like? We have fresh fruits and vegetables.	\N	\N	4	{"fluency": 0.2, "grammar": 0.3, "politeness": 0.2, "vocabulary": 0.3}
b3ca8f4c-276d-42c8-991e-5ecd3d704949	en	Asking for directions	You are lost. Ask how to get to the train station.	TRAVEL_EN	BEGINNER	Excuse me, do you know where the train station is?	\N	\N	4	{"clarity": 0.2, "fluency": 0.2, "grammar": 0.3, "vocabulary": 0.3}
1e27ecf4-56a6-4853-b8f5-4dea9205f199	es	Ordering at a restaurant	You are at a restaurant in Madrid. Order food and drinks, ask about the menu, and ask for the bill.	FOOD_ES	BEGINNER	Buenas tardes. Soy su camarero. ¿Qué desean tomar?	\N	\N	4	{"fluency": 0.2, "grammar": 0.3, "politeness": 0.2, "vocabulary": 0.3}
0f68901f-f70e-491e-af53-1f85cec202ce	es	Checking into a hotel	You arrive at a hotel. Check in, give your reservation name, and ask about breakfast and checkout time.	TRAVEL_ES	BEGINNER	Bienvenido al hotel. ¿Tiene una reserva a su nombre?	\N	\N	4	{"fluency": 0.2, "grammar": 0.3, "politeness": 0.2, "vocabulary": 0.3}
42482ad8-1c9b-4421-a1ad-a47128883ad5	es	At the airport	You are at the airport. Check in for your flight, ask about the gate, and confirm your seat.	TRAVEL_ES	INTERMEDIATE	Buenos días. ¿En qué puedo ayudarle? ¿Va a facturar equipaje?	\N	\N	4	{"fluency": 0.2, "grammar": 0.3, "politeness": 0.2, "vocabulary": 0.3}
848fe4bb-82ac-4a77-86ce-251ced2864e8	es	At the pharmacy	You need medicine. Describe your symptoms and ask the pharmacist for something for a headache or cold.	HEALTH_ES	BEGINNER	Buenas tardes. ¿Qué necesita?	\N	\N	4	{"clarity": 0.2, "fluency": 0.2, "grammar": 0.3, "vocabulary": 0.3}
546b86ee-5de4-457f-9ced-9ef0d531322d	es	Job interview	You are in a job interview. Introduce yourself, talk about your experience, and answer questions about your strengths.	BUSINESS_ES	INTERMEDIATE	Bienvenido. Cuéntenos un poco sobre usted y su experiencia.	\N	\N	5	{"fluency": 0.25, "grammar": 0.25, "vocabulary": 0.25, "professionalism": 0.25}
5ec3c4a3-3eda-45f4-9b33-d4157e43c843	es	Meeting new coworkers	It is your first day. Introduce yourself to colleagues, say what your role is, and ask where things are.	BUSINESS_ES	BEGINNER	Hola, soy María. ¿Eres nuevo en el equipo?	\N	\N	4	{"fluency": 0.2, "grammar": 0.3, "politeness": 0.2, "vocabulary": 0.3}
ff18175e-de9c-4cfc-8de4-3872179a93b0	es	Shopping in a market	You are at a local market. Ask for prices, quantities, and pay. Try to bargain politely.	FOOD_ES	BEGINNER	Buenos días. ¿Qué desea? Tenemos frutas y verduras frescas.	\N	\N	4	{"fluency": 0.2, "grammar": 0.3, "politeness": 0.2, "vocabulary": 0.3}
a1558043-a419-4379-8bce-07ceefe2161c	es	Asking for directions	You are lost in the city. Ask how to get to the train station or a famous square.	TRAVEL_ES	BEGINNER	Perdón, ¿sabe dónde está la estación de tren?	\N	\N	4	{"clarity": 0.2, "fluency": 0.2, "grammar": 0.3, "vocabulary": 0.3}
eec3d34a-f600-43c3-81e4-2e6fc0beeb1b	en	Ordering at a restaurant	You are at a restaurant. Order food and drinks and ask for the bill.	FOOD_EN	BEGINNER	Good evening. I am your server. What would you like to drink?	\N	\N	4	{"fluency": 0.2, "grammar": 0.3, "politeness": 0.2, "vocabulary": 0.3}
acf9e1ea-02ea-4e4e-a894-7ba37a3bf4eb	en	Checking into a hotel	You arrive at a hotel. Check in and ask about breakfast and checkout.	TRAVEL_EN	BEGINNER	Welcome to the hotel. Do you have a reservation under your name?	\N	\N	4	{"fluency": 0.2, "grammar": 0.3, "politeness": 0.2, "vocabulary": 0.3}
1faf6a93-61b2-47cc-8315-a7a3c5e971d9	en	At the airport	You are at the airport. Check in and ask about your gate.	TRAVEL_EN	INTERMEDIATE	Good morning. How can I help you? Are you checking any bags?	\N	\N	4	{"fluency": 0.2, "grammar": 0.3, "politeness": 0.2, "vocabulary": 0.3}
9f856619-2621-454c-b09d-3042f6ea08dd	en	Job interview	You are in a job interview. Introduce yourself and talk about your experience.	BUSINESS_EN	INTERMEDIATE	Welcome. Tell us a little about yourself and your experience.	\N	\N	5	{"fluency": 0.25, "grammar": 0.25, "vocabulary": 0.25, "professionalism": 0.25}
db077b31-c80d-4900-9511-2d236fcbc67e	en	At the pharmacy	You need medicine. Describe your symptoms and ask for something for a headache.	HEALTH_EN	BEGINNER	Good afternoon. What do you need?	\N	\N	4	{"clarity": 0.2, "fluency": 0.2, "grammar": 0.3, "vocabulary": 0.3}
99f21213-40aa-4d2d-9bcd-c424ac196494	en	Shopping in a market	You are at a market. Ask for prices and pay.	FOOD_EN	BEGINNER	Good morning. What would you like? We have fresh fruits and vegetables.	\N	\N	4	{"fluency": 0.2, "grammar": 0.3, "politeness": 0.2, "vocabulary": 0.3}
94e60978-236b-4bbf-ad11-121a75da78d5	en	Asking for directions	You are lost. Ask how to get to the train station.	TRAVEL_EN	BEGINNER	Excuse me, do you know where the train station is?	\N	\N	4	{"clarity": 0.2, "fluency": 0.2, "grammar": 0.3, "vocabulary": 0.3}
\.


--
-- Data for Name: ai_messages; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.ai_messages (id, session_id, sender, content, grammar_feedback, vocabulary_feedback, pronunciation_tips, sent_at) FROM stdin;
3a3215fa-0f02-4e99-bfb2-2df1231cf643	66b0d1a9-4f11-4932-99af-9cd7b074a61b	AI	Perdón, ¿sabe dónde está la estación de tren?	\N	\N	\N	2026-03-24 16:08:55.062426
fb4c8569-bca9-4250-91e6-52a63b1674b5	66b0d1a9-4f11-4932-99af-9cd7b074a61b	USER	Perdón, ¿sabe dónde está la estación de tren?	\N	\N	\N	2026-03-24 16:09:05.183076
d962cb6a-0d19-424c-a362-0c7f5960a9bc	66b0d1a9-4f11-4932-99af-9cd7b074a61b	AI	¡Muy bien! Esa frase es correcta. Otra forma de decirlo podría ser: "Disculpe, ¿puede decirme dónde está la estación de tren?" ¿Te gustaría aprender más frases útiles?	\N	\N	\N	2026-03-24 16:09:10.753642
063dc5ff-6593-4bd9-b659-cc360a3c0c31	3ce93126-8c72-4878-aef5-e0475e08c2f2	AI	Perdón, ¿sabe dónde está la estación de tren?	\N	\N	\N	2026-03-24 16:09:52.798476
852530cc-e2de-4449-9850-d6dd0c12cb96	3ce93126-8c72-4878-aef5-e0475e08c2f2	USER	hola	\N	\N	\N	2026-03-24 16:09:55.324144
7c766dda-c515-456d-b982-5065ad6e4990	3ce93126-8c72-4878-aef5-e0475e08c2f2	AI	¡Hola! ¿Cómo estás hoy?	\N	\N	\N	2026-03-24 16:09:56.985972
6be8adbb-580b-4e16-ae8e-4b4d81ab9304	3ce93126-8c72-4878-aef5-e0475e08c2f2	USER	bien y vos	\N	\N	\N	2026-03-24 16:10:01.67613
5afcbb5d-8e39-4c1d-88d8-a3cf1d6e4b4d	3ce93126-8c72-4878-aef5-e0475e08c2f2	AI	¡Estoy bien, gracias! ¿Qué te gustaría practicar hoy?	\N	\N	\N	2026-03-24 16:10:02.876068
7e0a5e0c-af96-4114-9714-573003ab717c	3ce93126-8c72-4878-aef5-e0475e08c2f2	USER	verbos	\N	\N	\N	2026-03-24 16:10:15.88251
c30103ee-6902-4caf-b4ca-8bd001e29549	3ce93126-8c72-4878-aef5-e0475e08c2f2	AI	¡Perfecto! ¿Te gustaría practicar los verbos en presente, pasado o futuro?	\N	\N	\N	2026-03-24 16:10:17.635421
1c951146-4e25-48d9-b053-379c9ff2e615	3ce93126-8c72-4878-aef5-e0475e08c2f2	USER	present	\N	\N	\N	2026-03-24 16:10:52.595398
d9817167-b983-4c2d-8fb8-90e20fcbc682	3ce93126-8c72-4878-aef5-e0475e08c2f2	AI	Muy bien. ¿Te gustaría que te diera ejemplos de verbos regulares o irregulares en presente?	\N	\N	\N	2026-03-24 16:10:53.467901
36173db7-1be0-4d18-a2e0-c021aedb7031	3ce93126-8c72-4878-aef5-e0475e08c2f2	USER	i want to talk in english and you tell me how to do it in spanish	\N	\N	\N	2026-03-24 16:11:13.13814
829d11cd-2391-497e-9462-1cd64d94676b	3ce93126-8c72-4878-aef5-e0475e08c2f2	AI	Lo siento, pero solo puedo ayudar con conversaciones en español. ¿Te gustaría seguir practicando en español?	\N	\N	\N	2026-03-24 16:11:14.225558
9c5b9ca8-118f-4c9b-b1c4-d902f8db331b	dc63286e-c194-42af-a1cb-dde32d9b1cce	AI	Perdón, ¿sabe dónde está la estación de tren?	\N	\N	\N	2026-03-30 16:20:34.343404
863bd284-69e1-4c4a-b893-c55fd05ef1c3	dc63286e-c194-42af-a1cb-dde32d9b1cce	USER	no se	\N	\N	\N	2026-03-30 16:20:39.405551
82677d78-6aae-4ed7-8696-8a98855ef16d	dc63286e-c194-42af-a1cb-dde32d9b1cce	AI	No te preocupes. Puedes decir: "No lo sé." ¿Te gustaría aprender algunas frases útiles para preguntar direcciones?	\N	\N	\N	2026-03-30 16:20:41.827689
31f9e6c3-2b82-4d8b-9b60-71bf956808ce	dc63286e-c194-42af-a1cb-dde32d9b1cce	USER	no	\N	\N	\N	2026-03-30 16:20:57.024452
d54d7499-1db0-4107-9643-da6f7d9a5923	dc63286e-c194-42af-a1cb-dde32d9b1cce	AI	Está bien. Si cambias de opinión o tienes otra pregunta, ¡aquí estoy para ayudarte!	\N	\N	\N	2026-03-30 16:20:58.331592
\.


--
-- Data for Name: ai_sessions; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.ai_sessions (id, user_id, language, topic, template_id, session_status, fallback_used, fallback_reason, error_message, avg_response_ms, speech_attempts, speech_failures, grammar_score, vocabulary_score, fluency_score, feedback_summary, started_at, ended_at, total_messages, xp_awarded) FROM stdin;
66b0d1a9-4f11-4932-99af-9cd7b074a61b	cb7b7c8b-987d-4557-b395-d91c017b19ef	es	TRAVEL_ES	7b1adb99-2145-493f-8115-9071c70d7a99	ACTIVE	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-03-24 16:08:55.05156	\N	3	\N
3ce93126-8c72-4878-aef5-e0475e08c2f2	cb7b7c8b-987d-4557-b395-d91c017b19ef	es	TRAVEL_ES	a1558043-a419-4379-8bce-07ceefe2161c	ACTIVE	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-03-24 16:09:52.797124	\N	11	\N
dc63286e-c194-42af-a1cb-dde32d9b1cce	cb7b7c8b-987d-4557-b395-d91c017b19ef	es	TRAVEL_ES	7b1adb99-2145-493f-8115-9071c70d7a99	ACTIVE	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-03-30 16:20:34.33764	\N	5	\N
\.


--
-- Data for Name: common_mistakes; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.common_mistakes (id, user_id, mistake_type, reference_id, mistake_count, last_made_at, example_wrong, example_correct, created_at) FROM stdin;
\.


--
-- Data for Name: conjugations; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.conjugations (id, vocabulary_id, language, tense, mood, person, conjugated_form, is_irregular, notes, created_at) FROM stdin;
550edc49-8214-449f-8568-ae5f679e2fe0	e30aeb37-9314-4a2e-aba4-aa44ad37d2d1	es	PRESENT	INDICATIVE	YO	soy	t	\N	2026-03-14 18:27:35.682131
31867809-70f1-4a9b-b97e-5a7389552c52	e30aeb37-9314-4a2e-aba4-aa44ad37d2d1	es	PRESENT	INDICATIVE	TU	eres	t	\N	2026-03-14 18:27:35.682131
c017ee1c-1036-40b1-9ca6-a7f9dd6ecec7	e30aeb37-9314-4a2e-aba4-aa44ad37d2d1	es	PRESENT	INDICATIVE	EL_ELLA	es	t	\N	2026-03-14 18:27:35.682131
48b58c94-310b-43fc-ab90-fe89315ab51e	e30aeb37-9314-4a2e-aba4-aa44ad37d2d1	es	PRESENT	INDICATIVE	NOSOTROS	somos	t	\N	2026-03-14 18:27:35.682131
1bf17888-e581-4cdd-ae63-497fc11615c2	e30aeb37-9314-4a2e-aba4-aa44ad37d2d1	es	PRESENT	INDICATIVE	VOSOTROS	sois	t	\N	2026-03-14 18:27:35.682131
1bae19de-d16a-4179-86c7-2df4a9692e1c	e30aeb37-9314-4a2e-aba4-aa44ad37d2d1	es	PRESENT	INDICATIVE	ELLOS	son	t	\N	2026-03-14 18:27:35.682131
84941764-3c62-45f2-9c68-64b3298c8bec	bcd1ef20-9b9f-49d1-9066-a65feeb2bbd4	es	PRESENT	INDICATIVE	YO	estoy	t	\N	2026-03-14 18:27:35.682894
666b846e-cbc3-4e0e-97e2-24e968f211c8	bcd1ef20-9b9f-49d1-9066-a65feeb2bbd4	es	PRESENT	INDICATIVE	TU	estás	t	\N	2026-03-14 18:27:35.682894
53b53fe3-b71d-411c-81fd-4be996dc38b9	bcd1ef20-9b9f-49d1-9066-a65feeb2bbd4	es	PRESENT	INDICATIVE	EL_ELLA	está	t	\N	2026-03-14 18:27:35.682894
1ed94aa7-14f8-4219-a93c-35799f7884f2	bcd1ef20-9b9f-49d1-9066-a65feeb2bbd4	es	PRESENT	INDICATIVE	NOSOTROS	estamos	t	\N	2026-03-14 18:27:35.682894
042ce6e6-3313-4a11-8024-39e8b1807072	bcd1ef20-9b9f-49d1-9066-a65feeb2bbd4	es	PRESENT	INDICATIVE	VOSOTROS	estáis	t	\N	2026-03-14 18:27:35.682894
bd5fe480-ce77-461b-b66b-6d53a2f42a37	bcd1ef20-9b9f-49d1-9066-a65feeb2bbd4	es	PRESENT	INDICATIVE	ELLOS	están	t	\N	2026-03-14 18:27:35.682894
967ca63e-c96b-4ad4-992b-34a1c2ca7286	b1e3e497-c5ae-4935-b773-719bfdcfe645	es	PRESENT	INDICATIVE	YO	tengo	t	\N	2026-03-14 18:27:35.683148
4322aa7e-e78c-4faf-bb27-2c0d8584d21b	b1e3e497-c5ae-4935-b773-719bfdcfe645	es	PRESENT	INDICATIVE	TU	tienes	f	\N	2026-03-14 18:27:35.683148
f72d7ddc-1505-4b19-bafc-b31f59abef5f	b1e3e497-c5ae-4935-b773-719bfdcfe645	es	PRESENT	INDICATIVE	EL_ELLA	tiene	f	\N	2026-03-14 18:27:35.683148
79a4e615-af17-4fc9-839c-bc4237f5a91a	b1e3e497-c5ae-4935-b773-719bfdcfe645	es	PRESENT	INDICATIVE	NOSOTROS	tenemos	f	\N	2026-03-14 18:27:35.683148
b03b3c17-4a84-4aa2-b261-f7c42e7510d5	b1e3e497-c5ae-4935-b773-719bfdcfe645	es	PRESENT	INDICATIVE	VOSOTROS	tenéis	f	\N	2026-03-14 18:27:35.683148
ec5f57d6-56d0-4415-8033-72a658ad8b58	b1e3e497-c5ae-4935-b773-719bfdcfe645	es	PRESENT	INDICATIVE	ELLOS	tienen	f	\N	2026-03-14 18:27:35.683148
c6d173aa-daf5-4d11-871a-a17571bbe7f9	6e74b698-6087-46f0-81ff-6fc5b4e126f0	es	PRESENT	INDICATIVE	YO	quiero	t	\N	2026-03-14 18:27:35.683642
4527d82c-ab8b-42ba-8901-08d886f92dec	6e74b698-6087-46f0-81ff-6fc5b4e126f0	es	PRESENT	INDICATIVE	TU	quieres	t	\N	2026-03-14 18:27:35.683642
1ff15994-6ee6-4d3c-b391-caa80024d971	6e74b698-6087-46f0-81ff-6fc5b4e126f0	es	PRESENT	INDICATIVE	EL_ELLA	quiere	t	\N	2026-03-14 18:27:35.683642
82a106b0-3470-474d-a744-3ccae65f3826	6e74b698-6087-46f0-81ff-6fc5b4e126f0	es	PRESENT	INDICATIVE	NOSOTROS	queremos	f	\N	2026-03-14 18:27:35.683642
e338c912-72af-42e2-b5d4-694c6cbbee43	6e74b698-6087-46f0-81ff-6fc5b4e126f0	es	PRESENT	INDICATIVE	VOSOTROS	queréis	f	\N	2026-03-14 18:27:35.683642
d426e475-9efb-43e2-bc95-8c1474dfacd2	6e74b698-6087-46f0-81ff-6fc5b4e126f0	es	PRESENT	INDICATIVE	ELLOS	quieren	t	\N	2026-03-14 18:27:35.683642
22ea5227-7d9e-45ce-a1a2-21fb7a655da3	d29e534f-9333-4299-8529-40d4681acf5a	es	PRESENT	INDICATIVE	YO	hablo	f	\N	2026-03-14 18:27:35.683879
6ac24a48-6be3-4f51-a252-321e3c1aa9d2	d29e534f-9333-4299-8529-40d4681acf5a	es	PRESENT	INDICATIVE	TU	hablas	f	\N	2026-03-14 18:27:35.683879
7ee11213-d4d6-4fa7-bba8-e118e7e65241	d29e534f-9333-4299-8529-40d4681acf5a	es	PRESENT	INDICATIVE	EL_ELLA	habla	f	\N	2026-03-14 18:27:35.683879
8f19ac54-c7d0-4e62-b3cd-b196e0dc979b	d29e534f-9333-4299-8529-40d4681acf5a	es	PRESENT	INDICATIVE	NOSOTROS	hablamos	f	\N	2026-03-14 18:27:35.683879
1ce07b37-92ac-40fa-a5d0-6ef4b64a8032	d29e534f-9333-4299-8529-40d4681acf5a	es	PRESENT	INDICATIVE	VOSOTROS	habláis	f	\N	2026-03-14 18:27:35.683879
f16a6259-c826-4a22-8872-38f0060ca1b3	d29e534f-9333-4299-8529-40d4681acf5a	es	PRESENT	INDICATIVE	ELLOS	hablan	f	\N	2026-03-14 18:27:35.683879
62c74525-02b5-4630-a92b-bf83a4ade6a5	53a3b16a-6fad-45fc-bef4-c39c0a60a1fd	es	PRESENT	INDICATIVE	YO	como	f	\N	2026-03-14 18:27:35.684125
3ed9c1df-0ec7-4fe4-aa45-30de26796287	53a3b16a-6fad-45fc-bef4-c39c0a60a1fd	es	PRESENT	INDICATIVE	TU	comes	f	\N	2026-03-14 18:27:35.684125
1968dab4-93e1-4fb1-820b-fa118bcab491	53a3b16a-6fad-45fc-bef4-c39c0a60a1fd	es	PRESENT	INDICATIVE	EL_ELLA	come	f	\N	2026-03-14 18:27:35.684125
4d299dfd-a518-41d7-b68c-7a1935fcee6f	53a3b16a-6fad-45fc-bef4-c39c0a60a1fd	es	PRESENT	INDICATIVE	NOSOTROS	comemos	f	\N	2026-03-14 18:27:35.684125
0e9cd695-da5c-49bd-ae13-d2fd9e327802	53a3b16a-6fad-45fc-bef4-c39c0a60a1fd	es	PRESENT	INDICATIVE	VOSOTROS	coméis	f	\N	2026-03-14 18:27:35.684125
6cb43df4-1332-4282-a6c5-e091d303ef47	53a3b16a-6fad-45fc-bef4-c39c0a60a1fd	es	PRESENT	INDICATIVE	ELLOS	comen	f	\N	2026-03-14 18:27:35.684125
06630b5b-453b-44a5-9c8b-c6f6650e378e	dfbcc480-2cb4-4378-ab97-434c9519f4dd	es	PRESENT	INDICATIVE	YO	voy	t	\N	2026-03-14 18:27:35.684367
7eb0708f-3867-464a-9682-76e945faf17c	dfbcc480-2cb4-4378-ab97-434c9519f4dd	es	PRESENT	INDICATIVE	TU	vas	t	\N	2026-03-14 18:27:35.684367
48ce1833-716b-4b79-9e11-318e121eb23f	dfbcc480-2cb4-4378-ab97-434c9519f4dd	es	PRESENT	INDICATIVE	EL_ELLA	va	t	\N	2026-03-14 18:27:35.684367
c1f7b2bb-27c4-49a4-ae44-6bb6f7047ba5	dfbcc480-2cb4-4378-ab97-434c9519f4dd	es	PRESENT	INDICATIVE	NOSOTROS	vamos	t	\N	2026-03-14 18:27:35.684367
dd7e0aef-c79e-4ca6-9103-9b12aa2a34a4	dfbcc480-2cb4-4378-ab97-434c9519f4dd	es	PRESENT	INDICATIVE	VOSOTROS	vais	t	\N	2026-03-14 18:27:35.684367
0df54dd1-6818-4ebe-8404-6cb84151523d	dfbcc480-2cb4-4378-ab97-434c9519f4dd	es	PRESENT	INDICATIVE	ELLOS	van	t	\N	2026-03-14 18:27:35.684367
\.


--
-- Data for Name: content_audit_log; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.content_audit_log (id, admin_id, action, target_type, target_id, notes, performed_at) FROM stdin;
\.


--
-- Data for Name: cultural_notes; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.cultural_notes (id, language, title, body, level, topic_tag, related_words, related_word_ids, country_context, display_order, created_at) FROM stdin;
7426f5d2-a635-4232-8482-e00853b0b9d3	es	Regional vocabulary: car	Spanish speakers use different words for "car" depending on their country. In Mexico and most of Latin America you say "carro". In Spain they say "coche". In Argentina and Uruguay they say "auto". All are correct and all Spanish speakers will understand you regardless of which you use.	BEGINNER	CONVERSATION_ES	\N	\N	{MX,ES,AR,UY}	0	2026-03-14 18:27:35.685442
9b18acb6-b4e6-4caf-b006-8265d7d4edbc	es	Formal vs informal: tú vs usted	Spanish has two ways to say "you". Tú is informal — use it with friends, family, and people your age. Usted is formal — use it with strangers, elders, authority figures, and in professional settings. In most of Latin America, usted is used more than in Spain. When in doubt, start with usted and switch to tú when invited.	BEGINNER	CONVERSATION_ES	\N	\N	{MX,CO,ES,AR}	0	2026-03-14 18:27:35.685442
c6441fb9-4d99-4592-8a5c-6b363d2c9c48	es	Meal times in Spanish-speaking countries	Meal times differ significantly from the US. In Spain, lunch (el almuerzo or la comida) is the biggest meal of the day, typically eaten between 2pm and 4pm. Dinner (la cena) is eaten late — often 9pm or 10pm. In Latin America, schedules vary by country but lunch is still the main meal. Do not be surprised if a dinner invitation means arriving at 9pm.	BEGINNER	FOOD_ES	\N	\N	{ES,MX,AR,CO}	0	2026-03-14 18:27:35.685442
34c2b58a-a510-40c6-8fb0-999283c9b9ec	es	Greetings: cheek kisses	In many Spanish-speaking countries, women greet everyone with one cheek kiss (un beso). Men often shake hands with other men but kiss women on the cheek. In Argentina, men also kiss each other on the cheek as a greeting. This varies by country and region — when in doubt, follow the other person's lead.	BEGINNER	CONVERSATION_ES	\N	\N	{ES,AR,MX,CO}	0	2026-03-14 18:27:35.685442
9103de5d-65c3-461e-a47f-f5ee14ca6a77	es	False friends: embarrassed vs embarazada	"Embarazada" does NOT mean embarrassed. It means pregnant. "Estoy embarazada" means "I am pregnant". The correct word for embarrassed is "avergonzado/a" or "apenado/a". This is one of the most famous false friends in Spanish and can lead to very awkward situations.	INTERMEDIATE	GRAMMAR_ES	\N	\N	{ALL}	0	2026-03-14 18:27:35.685442
fbdd8fb5-a1ca-4612-9a80-72722160e756	es	Por favor and gracias — always use them	Saying por favor (please) and gracias (thank you) is considered basic courtesy in all Spanish-speaking cultures. Omitting them, especially in shops and restaurants, can come across as rude. Unlike English where tone can soften a request, Spanish speakers expect the actual words. Always add por favor when making any request.	BEGINNER	CONVERSATION_ES	\N	\N	{ALL}	0	2026-03-14 18:27:35.685442
e8393d57-f6d8-4bda-a8fd-1db8f5563310	es	Ser vs Estar with adjectives — meaning changes	Some adjectives change meaning depending on whether you use ser or estar. "Ser aburrido" means to be a boring person (personality). "Estar aburrido" means to feel bored right now (temporary state). Similarly: "ser listo" = to be clever, "estar listo" = to be ready. "Ser malo" = to be evil/bad, "estar malo" = to be sick.	INTERMEDIATE	GRAMMAR_ES	\N	\N	{ALL}	0	2026-03-14 18:27:35.685442
0a77b5e8-5cf8-4cce-b4fc-833c0bc07aef	en	American vs British English spelling	If you are learning English for the United States, use American spelling. Key differences: color (not colour), center (not centre), organize (not organise), gray (not grey). Most language learning in the Americas uses American English. Ask your teacher or app which variety you need for your goals.	BEGINNER	GRAMMAR_EN	\N	\N	{US,UK}	0	2026-03-14 18:27:35.685442
c76fe975-3aee-4aa6-950f-22cf48ca0d9a	en	Small talk is expected in American culture	In the United States, small talk — brief friendly conversation about topics like weather, sports, or the weekend — is a normal part of social and professional interaction. When someone asks "How are you?", they usually expect a short positive answer like "Great, thanks! How about you?" not a detailed description of your health. This is a cultural greeting ritual, not a medical inquiry.	BEGINNER	CONVERSATION_EN	\N	\N	{US}	0	2026-03-14 18:27:35.685442
efaefd35-cdfb-401b-b2ec-20563a0a4518	en	Please, thank you, and excuse me	American English speakers say please (por favor), thank you (gracias), and excuse me (perdón) very frequently. Saying "excuse me" before asking a stranger for help, and "thank you" after any service, is considered basic politeness. Not saying these words can make you seem rude even if that is not your intention.	BEGINNER	CONVERSATION_EN	\N	\N	{US}	0	2026-03-14 18:27:35.685442
dc66cbe0-37b0-4a09-907f-25225e7ad5a7	en	You all vs y'all vs you guys	English has no formal plural "you" — this is very different from Spanish. In the American South, people say "y'all" for a group. In the Northeast and Midwest, "you guys" is common (used for any gender). In formal writing, always write "you" for both singular and plural. Do not write "y'all" in professional emails.	INTERMEDIATE	GRAMMAR_EN	\N	\N	{US}	0	2026-03-14 18:27:35.685442
bc6adece-7157-4158-8017-43b18fd84f74	es	Restaurant etiquette in Spain	In Spain, lunch is often eaten around 2–3 p.m. and dinner after 9 p.m. It is common to share tapas. Saying "La cuenta, por favor" when you are ready to pay is polite. Tipping is smaller than in the U.S.; rounding up or leaving 5–10% is typical.	BEGINNER	FOOD_ES	\N	\N	{Spain}	0	2026-03-15 04:05:54.047301
5ac020a7-a92f-429f-8cc5-11424d83f983	es	Greetings in Spanish-speaking countries	In many Spanish-speaking countries, people greet with one or two kisses on the cheek (starting with the left), or a handshake in formal settings. "¿Cómo estás?" is used among friends; "¿Cómo está usted?" is more formal.	BEGINNER	CONVERSATION_ES	\N	\N	{Spain,Mexico,Argentina}	0	2026-03-15 04:05:54.047301
c27879b9-d94f-4350-82c3-39ad57642518	es	Business meetings in Latin America	Punctuality can be more flexible than in some cultures; building rapport before getting to business is valued. Use titles (Señor, Señora, Doctor) until invited to use first names. Exchange business cards with both hands.	INTERMEDIATE	BUSINESS_ES	\N	\N	{Mexico,Colombia,Chile}	0	2026-03-15 04:05:54.047301
6698e6ea-5937-445c-99da-aef013f76bf0	en	Tipping in the United States	In the U.S., tipping 15–20% at restaurants is standard. Not tipping or tipping very little is considered rude. Tips are also expected for taxi drivers, hairdressers, and delivery workers.	BEGINNER	FOOD_EN	\N	\N	{"United States"}	0	2026-03-15 04:05:54.047301
427e6631-b3fa-4336-87df-855c30d54156	en	Small talk in English	In English-speaking cultures, small talk about weather, sports, or weekend plans is common before meetings or in social situations. "How are you?" is often a greeting; a short positive answer is expected.	BEGINNER	CONVERSATION_EN	\N	\N	{"United States","United Kingdom"}	0	2026-03-15 04:05:54.047301
e0be2d89-2d6e-47b7-9388-0e56abddc4a8	es	Restaurant etiquette in Spain	In Spain, lunch is often eaten around 2–3 p.m. and dinner after 9 p.m. It is common to share tapas. Saying "La cuenta, por favor" when you are ready to pay is polite. Tipping is smaller than in the U.S.; rounding up or leaving 5–10% is typical.	BEGINNER	FOOD_ES	\N	\N	{Spain}	0	2026-03-15 04:07:30.381515
cfb0317f-d5ce-42ef-a7f1-47caedcf1f8c	es	Greetings in Spanish-speaking countries	In many Spanish-speaking countries, people greet with one or two kisses on the cheek (starting with the left), or a handshake in formal settings. "¿Cómo estás?" is used among friends; "¿Cómo está usted?" is more formal.	BEGINNER	CONVERSATION_ES	\N	\N	{Spain,Mexico,Argentina}	0	2026-03-15 04:07:30.381515
a406242a-bb43-42ca-97d2-0d03d9349d05	es	Business meetings in Latin America	Punctuality can be more flexible than in some cultures; building rapport before getting to business is valued. Use titles (Señor, Señora, Doctor) until invited to use first names. Exchange business cards with both hands.	INTERMEDIATE	BUSINESS_ES	\N	\N	{Mexico,Colombia,Chile}	0	2026-03-15 04:07:30.381515
bc2e0f77-5854-4904-90a5-fd870184e7f8	en	Tipping in the United States	In the U.S., tipping 15–20% at restaurants is standard. Not tipping or tipping very little is considered rude. Tips are also expected for taxi drivers, hairdressers, and delivery workers.	BEGINNER	FOOD_EN	\N	\N	{"United States"}	0	2026-03-15 04:07:30.381515
c85ee620-1ef2-4bd7-bc72-735035569d14	en	Small talk in English	In English-speaking cultures, small talk about weather, sports, or weekend plans is common before meetings or in social situations. "How are you?" is often a greeting; a short positive answer is expected.	BEGINNER	CONVERSATION_EN	\N	\N	{"United States","United Kingdom"}	0	2026-03-15 04:07:30.381515
\.


--
-- Data for Name: dashboard_metrics; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.dashboard_metrics (id, user_id, language, total_xp, current_streak, longest_streak, lessons_completed, lessons_in_progress, current_level, xp_to_next_level, xp_in_current_level, weekly_xp, weekly_xp_by_day, skill_vocabulary, skill_grammar, skill_listening, skill_writing, skill_speaking, achievements_count, current_league, league_rank, ai_sessions_count, last_computed_at) FROM stdin;
\.


--
-- Data for Name: exercise_distractors; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.exercise_distractors (id, vocabulary_id, distractor_type, distractor_value, language, reason) FROM stdin;
\.


--
-- Data for Name: exercises; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.exercises (id, lesson_id, exercise_type, prompt, correct_answer, options, audio_text, hint, display_order, grammar_rule_id, vocabulary_ids, skill_tested, skill, difficulty, accepted_answers, phonetic_guide, speech_rate, accent, distractor_logic, min_similarity_score) FROM stdin;
05e9bdcf-a6f7-4c43-9a97-e7493fa0e0b9	e1000001-0000-0000-0000-000000000001	IMAGE_PICK	Which one of these is "arroz"?	arroz	{"choices": [{"label": "🍞 pan", "value": "pan", "image_keyword": "bread"}, {"label": "🍚 arroz", "value": "arroz", "image_keyword": "rice_bowl"}, {"label": "🥛 leche", "value": "leche", "image_keyword": "milk"}]}	\N	Think about what you eat with meals in Latin America.	1	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
5d4d87b0-0786-4253-a66a-d9d28eac6045	e1000001-0000-0000-0000-000000000001	IMAGE_PICK	Which one of these is "pollo"?	pollo	{"choices": [{"label": "🥗 ensalada", "value": "ensalada", "image_keyword": "salad"}, {"label": "🍲 sopa", "value": "sopa", "image_keyword": "soup"}, {"label": "🍗 pollo", "value": "pollo", "image_keyword": "chicken"}]}	\N	Pollo is a very popular protein in Spanish cuisine.	2	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
ad0c4ada-d93b-44ac-9eae-c719a00e5d97	e1000001-0000-0000-0000-000000000001	WORD_BANK	Translate to Spanish: "I want rice, please."	Quiero arroz, por favor.	{"word_bank": ["Quiero", "arroz,", "por", "favor.", "Tengo", "leche", "sopa", "mucho"]}	\N	Use "quiero" for "I want".	3	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
23505952-1dcd-4161-8d98-7b11aab1ced4	e1000001-0000-0000-0000-000000000001	FILL_BLANK	Complete: "La ___ está fresca." (The salad is fresh.)	ensalada	{"choices": ["ensalada", "pollo", "arroz", "sopa"]}	\N	"Ensalada" is feminine, so it uses "está".	4	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
f1615296-ca33-47ce-9b03-d871c1411995	e1000001-0000-0000-0000-000000000001	FREE_WRITE	Translate to Spanish: "The soup is hot."	La sopa está caliente.	\N	\N	Use "estar" for temporary states like temperature.	5	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
1577238a-640d-4f52-9dc4-96a61911eed1	e1000001-0000-0000-0000-000000000002	IMAGE_PICK	Which one of these is "café"?	café	{"choices": [{"label": "💧 agua", "value": "agua", "image_keyword": "water_bottle"}, {"label": "☕ café", "value": "café", "image_keyword": "coffee_cup"}, {"label": "🧃 jugo", "value": "jugo", "image_keyword": "juice"}]}	\N	Café is one of the most popular drinks in Latin America.	1	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
88956ff8-1997-429b-be36-8c562eb32d8e	e1000001-0000-0000-0000-000000000002	IMAGE_PICK	Which one of these is "agua"?	agua	{"choices": [{"label": "🍵 té", "value": "té", "image_keyword": "tea_cup"}, {"label": "🍺 cerveza", "value": "cerveza", "image_keyword": "beer"}, {"label": "💧 agua", "value": "agua", "image_keyword": "water_bottle"}]}	\N	Agua means water.	2	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
0b29ba25-011e-434f-9b20-bcc58d7053b1	e1000001-0000-0000-0000-000000000002	AUDIO_TAP	Tap the words you hear in the correct order.	Quiero agua, por favor.	{"word_bank": ["Quiero", "agua,", "por", "favor.", "café", "leche", "vino", "jugo"]}	Quiero agua, por favor.	\N	3	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
591501a3-e8ce-4789-a7ea-99ba11aa63c5	e1000001-0000-0000-0000-000000000002	WORD_BANK	Translate to Spanish: "A coffee, please."	Un café, por favor.	{"word_bank": ["Un", "café,", "por", "favor.", "agua", "dos", "leche", "té"]}	\N	Use "un" for masculine nouns.	4	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
984368a3-81cc-464b-b8f6-66a2e3a654b3	e1000001-0000-0000-0000-000000000002	FREE_WRITE	Translate to Spanish: "I would like a tea, please."	Quisiera un té, por favor.	\N	\N	"Quisiera" is a polite way to say "I would like".	5	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
49493fe7-6bfc-4e6b-97ef-dd6c886ac426	e1000001-0000-0000-0000-000000000003	IMAGE_PICK	Which one of these is "restaurante"?	restaurante	{"choices": [{"label": "🏨 hotel", "value": "hotel", "image_keyword": "hotel"}, {"label": "🍽️ restaurante", "value": "restaurante", "image_keyword": "restaurant"}, {"label": "✈️ aeropuerto", "value": "aeropuerto", "image_keyword": "airport"}]}	\N	\N	1	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
cc67c65e-6831-473b-bcab-726c64c6eeb2	e1000001-0000-0000-0000-000000000003	AUDIO_TAP	Tap the words you hear in the correct order.	La cuenta, por favor.	{"word_bank": ["La", "cuenta,", "por", "favor.", "mesa", "comida", "bebida", "menú"]}	La cuenta, por favor.	"La cuenta" means the bill/check.	2	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
3f492448-cc7a-46e4-aedd-5de81a3583ef	e1000001-0000-0000-0000-000000000003	WORD_BANK	Translate: "I would like the chicken and a water, please."	Quisiera el pollo y un agua, por favor.	{"word_bank": ["Quisiera", "el", "pollo", "y", "un", "agua,", "por", "favor.", "quiero", "arroz", "leche"]}	\N	\N	3	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
0148ad94-c3e2-40a0-b4f0-e212d9606b64	e1000001-0000-0000-0000-000000000003	FILL_BLANK	Complete: "¿Me puede traer la ___?" (Can you bring me the menu?)	carta	{"choices": ["carta", "cuenta", "mesa", "silla"]}	\N	"La carta" or "el menú" both mean menu.	4	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
959777a3-4f00-424e-b596-4b0438a191f2	e1000001-0000-0000-0000-000000000003	FREE_WRITE	Translate: "Excuse me, we are ready to order."	Perdón, estamos listos para pedir.	\N	\N	Use "perdón" to politely get attention.	5	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
9c45edb4-66cf-42b4-8e82-624f9480142a	e1000001-0000-0000-0000-000000000004	WORD_BANK	Translate: "The bill, please."	La cuenta, por favor.	{"word_bank": ["La", "cuenta,", "por", "favor.", "carta", "mesa", "agua", "comida"]}	\N	\N	1	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
8f0b4433-7860-453f-8ab1-39399d91d887	e1000001-0000-0000-0000-000000000004	AUDIO_TAP	Tap the words you hear in the correct order.	¿Aceptan tarjeta de crédito?	{"word_bank": ["¿Aceptan", "tarjeta", "de", "crédito?", "efectivo", "pago", "dinero", "banco"]}	¿Aceptan tarjeta de crédito?	"¿Aceptan tarjeta?" means "Do you accept card?"	2	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
5984ebd4-4a2d-4d48-bb10-b2334638e1ec	e1000001-0000-0000-0000-000000000004	FILL_BLANK	Complete: "¿Cuánto ___?" (How much does it cost?)	cuesta	{"choices": ["cuesta", "tiene", "quiere", "puede"]}	\N	"Costar" means to cost. "¿Cuánto cuesta?" = How much does it cost?	3	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
bfb3c775-20cb-4e52-869e-4f828d9acbfc	e1000001-0000-0000-0000-000000000004	WORD_BANK	Translate: "Can we pay separately?"	¿Podemos pagar por separado?	{"word_bank": ["¿Podemos", "pagar", "por", "separado?", "juntos", "cuenta", "efectivo", "tarjeta"]}	\N	\N	4	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
bf13adc0-ae65-49c3-9aa6-d8e1a4301623	e1000001-0000-0000-0000-000000000004	FREE_WRITE	Translate: "Keep the change."	Quédese con el cambio.	\N	\N	"Cambio" means change (money).	5	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
a7ed26bf-669c-4988-9d39-9479874b71ca	e1000002-0000-0000-0000-000000000001	IMAGE_PICK	Which greeting is used in the morning?	buenos días	{"choices": [{"label": "🌙 Buenas noches", "value": "buenas noches", "image_keyword": "night"}, {"label": "☀️ Buenos días", "value": "buenos días", "image_keyword": "morning"}, {"label": "👋 Adiós", "value": "adiós", "image_keyword": "wave"}]}	\N	\N	1	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
fcb313bc-992e-4eda-a1a4-0aa4175dccdd	e1000002-0000-0000-0000-000000000001	AUDIO_TAP	Tap the words you hear in the correct order.	Hola, ¿cómo estás?	{"word_bank": ["Hola,", "¿cómo", "estás?", "adiós", "bien", "mal", "gracias"]}	Hola, ¿cómo estás?	\N	2	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
a92200af-565a-4cba-b3ee-fe8cbc263dbe	e1000002-0000-0000-0000-000000000001	FILL_BLANK	Complete: "___, mucho gusto." (Hello, nice to meet you.)	Hola	{"choices": ["Hola", "Adiós", "Gracias", "Por favor"]}	\N	"Mucho gusto" means "nice to meet you".	3	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
a9725395-ad0d-4873-8f2d-9f870197eacd	e1000002-0000-0000-0000-000000000001	WORD_BANK	Translate: "Good evening, how are you?"	Buenas noches, ¿cómo estás?	{"word_bank": ["Buenas", "noches,", "¿cómo", "estás?", "días", "tardes", "bien", "mal"]}	\N	\N	4	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
ea9bdbef-f2a3-4186-9f7f-c981dd302f79	e1000002-0000-0000-0000-000000000001	FREE_WRITE	Translate: "See you tomorrow!"	¡Hasta mañana!	\N	\N	"Hasta" means "until". "Hasta mañana" = Until tomorrow.	5	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
3ccfd34a-8b3b-4bbd-a595-ff9ad7b0bdcd	e1000002-0000-0000-0000-000000000002	AUDIO_TAP	Tap the words you hear in the correct order.	Me llamo Carlos.	{"word_bank": ["Me", "llamo", "Carlos.", "soy", "tengo", "llamas", "nombre", "es"]}	Me llamo Carlos.	"Me llamo" means my name is.	1	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
efef7888-2b46-4c81-82ce-bd1bf904f995	e1000002-0000-0000-0000-000000000002	FILL_BLANK	Complete: "Yo ___ de México." (I am from Mexico.)	soy	{"choices": ["soy", "estoy", "tengo", "vivo"]}	\N	Use "ser" (soy) for origin and identity.	2	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
cacc10fd-5da6-44c2-bc5c-30da92801088	e1000002-0000-0000-0000-000000000002	WORD_BANK	Translate: "My name is Ana and I am from Spain."	Me llamo Ana y soy de España.	{"word_bank": ["Me", "llamo", "Ana", "y", "soy", "de", "España.", "estoy", "vivo", "tengo"]}	\N	\N	3	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
af4aae2e-e2cc-43af-932f-62d3d5b11c94	e1000002-0000-0000-0000-000000000002	FILL_BLANK	Complete: "Tengo ___ años." (I am 25 years old.)	veinticinco	{"choices": ["veinticinco", "veintiuno", "treinta", "cuarenta"]}	\N	"Tener" is used to express age in Spanish.	4	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
7231c7ef-d4ad-4bb8-bb84-289582fea758	e1000002-0000-0000-0000-000000000002	FREE_WRITE	Translate: "I am a teacher and I live in New York."	Soy maestro/a y vivo en Nueva York.	\N	\N	Remember "soy" for profession, "vivo" for where you live.	5	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
c5ded9bb-eabb-46f8-9280-939b4fee2da4	f1000001-0000-0000-0000-000000000001	IMAGE_PICK	Which one of these is "rice"?	rice	{"choices": [{"label": "🍞 bread", "value": "bread", "image_keyword": "bread"}, {"label": "🍚 rice", "value": "rice", "image_keyword": "rice_bowl"}, {"label": "🥛 milk", "value": "milk", "image_keyword": "milk"}]}	\N	\N	1	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
282ce4a8-a6e1-4953-8f94-fb8b942845ec	f1000001-0000-0000-0000-000000000001	IMAGE_PICK	Which one of these is "chicken"?	chicken	{"choices": [{"label": "🥗 salad", "value": "salad", "image_keyword": "salad"}, {"label": "🍲 soup", "value": "soup", "image_keyword": "soup"}, {"label": "🍗 chicken", "value": "chicken", "image_keyword": "chicken"}]}	\N	\N	2	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
708559b7-8ba0-475e-b6cf-eb4fa065710c	f1000001-0000-0000-0000-000000000001	WORD_BANK	Translate to English: "Quiero arroz, por favor."	I want rice, please.	{"word_bank": ["I", "want", "rice,", "please.", "have", "need", "soup", "bread"]}	\N	"Quiero" means "I want".	3	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
5dc08b77-d680-46d2-8ed4-a995028e8ba1	f1000001-0000-0000-0000-000000000001	FILL_BLANK	Complete: "The ___ is fresh." (La ensalada está fresca.)	salad	{"choices": ["salad", "chicken", "rice", "soup"]}	\N	\N	4	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
a57cf00c-6084-4f76-91c4-020b563336f3	f1000001-0000-0000-0000-000000000001	FREE_WRITE	Translate to English: "La sopa está caliente."	The soup is hot.	\N	\N	Use "is" for describing the current state.	5	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
606d1a53-f14e-484a-a9f6-eb61c6166a66	f1000001-0000-0000-0000-000000000002	IMAGE_PICK	Which one of these is "coffee"?	coffee	{"choices": [{"label": "💧 water", "value": "water", "image_keyword": "water_bottle"}, {"label": "☕ coffee", "value": "coffee", "image_keyword": "coffee_cup"}, {"label": "🧃 juice", "value": "juice", "image_keyword": "juice"}]}	\N	\N	1	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
798fb973-2c14-4ce8-ad18-b8e3f7f4fdbd	f1000001-0000-0000-0000-000000000002	AUDIO_TAP	Tap the words you hear in the correct order.	I would like water, please.	{"word_bank": ["I", "would", "like", "water,", "please.", "coffee", "tea", "milk", "juice"]}	I would like water, please.	"Would like" is a polite way to say "want".	2	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
3b4d617e-4e2b-4622-a4b2-9c1e159a1d93	f1000001-0000-0000-0000-000000000002	WORD_BANK	Translate: "Un café, por favor."	A coffee, please.	{"word_bank": ["A", "coffee,", "please.", "water", "tea", "milk", "one", "juice"]}	\N	\N	3	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
8bbe30d1-3d06-40cb-a844-479226f41fdb	f1000001-0000-0000-0000-000000000002	FILL_BLANK	Complete: "I ___ like a tea, please." (Quisiera un té, por favor.)	would	{"choices": ["would", "will", "can", "should"]}	\N	"I would like" is more polite than "I want".	4	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
02439f33-8e7c-41c2-a696-9d3763db78da	f1000001-0000-0000-0000-000000000002	FREE_WRITE	Translate: "Quisiera un jugo de naranja, por favor."	I would like an orange juice, please.	\N	\N	Remember to use "an" before vowel sounds.	5	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
99a61f32-980b-476b-ae1e-06d00bef0007	f1000002-0000-0000-0000-000000000001	IMAGE_PICK	Which greeting is used in the morning?	good morning	{"choices": [{"label": "🌙 Good night", "value": "good night", "image_keyword": "night"}, {"label": "☀️ Good morning", "value": "good morning", "image_keyword": "morning"}, {"label": "👋 Goodbye", "value": "goodbye", "image_keyword": "wave"}]}	\N	\N	1	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
4d813cd1-33f2-4723-a986-af95cd5a4e5d	f1000002-0000-0000-0000-000000000001	AUDIO_TAP	Tap the words you hear in the correct order.	Hello, how are you?	{"word_bank": ["Hello,", "how", "are", "you?", "goodbye", "fine", "bad", "thanks"]}	Hello, how are you?	\N	2	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
0e239692-66bc-45b1-b397-61d44a40d50e	f1000002-0000-0000-0000-000000000001	FILL_BLANK	Complete: "___, nice to meet you." (Hola, mucho gusto.)	Hello	{"choices": ["Hello", "Goodbye", "Thank you", "Please"]}	\N	\N	3	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
18f714eb-dd59-45a1-9d3f-1b6f6d96055e	f1000002-0000-0000-0000-000000000001	WORD_BANK	Translate: "Buenas noches, ¿cómo estás?"	Good evening, how are you?	{"word_bank": ["Good", "evening,", "how", "are", "you?", "morning", "night", "fine", "doing"]}	\N	\N	4	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
b10ec211-ced9-4972-a904-0e2797162fd9	f1000002-0000-0000-0000-000000000001	FREE_WRITE	Translate: "¡Hasta mañana!"	See you tomorrow!	\N	\N	This is a common informal farewell.	5	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
ab31f991-e2c1-4626-b7f8-554c0435eae5	e1000001-0000-0000-0000-000000000005	IMAGE_PICK	Which one is "postre"?	postre	{"choices": [{"label": "🍰 postre", "value": "postre", "image_keyword": "dessert"}, {"label": "🍵 sopa", "value": "sopa", "image_keyword": "soup"}, {"label": "🥗 ensalada", "value": "ensalada", "image_keyword": "salad"}]}	\N	Postre is dessert.	1	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
a3c672bf-3a55-4d0f-808c-a92a8b5d7312	e1000001-0000-0000-0000-000000000005	WORD_BANK	Translate: "The food was delicious."	La comida estaba deliciosa.	{"word_bank": ["La", "comida", "estaba", "deliciosa.", "El", "muy", "buena", "fue"]}	\N	Use "estar" for past temporary state.	2	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
5024589f-f1fd-47f8-8651-1a8ed35b48c0	e1000001-0000-0000-0000-000000000005	FILL_BLANK	Complete: "Quisiera ___ la cuenta." (I would like the check.)	la cuenta	{"choices": ["la cuenta", "el menú", "una mesa", "agua"]}	\N	"La cuenta" = the bill.	3	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
550984a5-a6ba-450d-8976-f702480c343c	e1000001-0000-0000-0000-000000000005	AUDIO_TAP	Tap the words you hear in order.	La comida estaba muy buena.	{"word_bank": ["La", "comida", "estaba", "muy", "buena.", "mal", "regular", "rica"]}	\N	\N	4	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
47bf0f76-f5b8-454c-83f4-2f933042c777	e1000001-0000-0000-0000-000000000005	FREE_WRITE	Translate to Spanish: "I would like to order the chicken."	Quisiera pedir el pollo.	\N	\N	Quisiera = I would like, pedir = to order.	5	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
b1d9dd9c-f77b-4465-8f59-96cb07332cd9	e1000001-0000-0000-0000-000000000005	WORD_BANK	Translate: "Can I have the bill, please?"	¿Me puede traer la cuenta, por favor?	{"word_bank": ["¿Me", "puede", "traer", "la", "cuenta,", "por", "favor?", "mesa"]}	\N	\N	6	\N	\N	VOCABULARY	\N	INTERMEDIATE	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
731d36a2-1d35-4cac-b3c2-237e1d31938d	e1000001-0000-0000-0000-000000000005	FILL_BLANK	Complete: "El ___ estaba frío." (The drink was cold.)	refresco	{"choices": ["refresco", "plato", "servicio", "postre"]}	\N	Refresco = soft drink.	7	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
9115d7be-d728-4fcc-91e0-3ae2e593ba73	e1000001-0000-0000-0000-000000000005	FREE_WRITE	Translate: "We really liked the service."	Nos gustó mucho el servicio.	\N	\N	Gustar: "nos gustó" = we liked.	8	\N	\N	VOCABULARY	\N	INTERMEDIATE	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
faa727cf-7a3f-4be5-9cf2-1dc878f04322	e1000001-0000-0000-0000-000000000005	SPEAKING	Say in Spanish: "The dessert was excellent."	El postre estaba excelente.	\N	\N	Estar for temporary quality.	9	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
56876294-a02a-4938-a79b-28c9d5eab7b1	e1000001-0000-0000-0000-000000000005	READING_COMPREHENSION	Read: "El restaurante tiene buena reputación. La comida es casera y el precio es razonable." — What is said about the price?	Es razonable.	{"choices": ["Es caro.", "Es razonable.", "Es barato.", "No se menciona."]}	\N	Razonable = reasonable.	10	\N	\N	VOCABULARY	\N	INTERMEDIATE	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
fe3e2163-9f07-4df5-a46d-478b4ce3bcf8	e1000001-0000-0000-0000-000000000001	AUDIO_TAP	Tap the words you hear in order.	Quiero arroz y pollo.	{"word_bank": ["Quiero", "arroz", "y", "pollo.", "ensalada", "sopa", "carne", "pan"]}	\N	\N	6	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
4bbb1d20-1683-4085-a315-e62f7502f345	e1000001-0000-0000-0000-000000000001	SPEAKING	Say in Spanish: "I want water, please."	Quiero agua, por favor.	\N	\N	\N	7	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
8e05b54c-5585-408b-b0d8-6d98e590364a	e1000001-0000-0000-0000-000000000001	READING_COMPREHENSION	Read: "María pide una ensalada y un vaso de agua. El camarero trae la comida." — What does María order to drink?	agua	{"choices": ["vino", "café", "agua", "jugo"]}	\N	\N	8	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
33ca81a9-78ba-4250-8336-72053edfb23d	e1000001-0000-0000-0000-000000000005	IMAGE_PICK	Which one is "postre"?	postre	{"choices": [{"label": "🍰 postre", "value": "postre", "image_keyword": "dessert"}, {"label": "🍵 sopa", "value": "sopa", "image_keyword": "soup"}, {"label": "🥗 ensalada", "value": "ensalada", "image_keyword": "salad"}]}	\N	Postre is dessert.	1	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
78dcd485-999d-4242-a55f-bafbf9ee6c03	e1000001-0000-0000-0000-000000000005	WORD_BANK	Translate: "The food was delicious."	La comida estaba deliciosa.	{"word_bank": ["La", "comida", "estaba", "deliciosa.", "El", "muy", "buena", "fue"]}	\N	Use "estar" for past temporary state.	2	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
85c0e552-2026-4d3a-a2ef-2679c6d39321	e1000001-0000-0000-0000-000000000005	FILL_BLANK	Complete: "Quisiera ___ la cuenta." (I would like the check.)	la cuenta	{"choices": ["la cuenta", "el menú", "una mesa", "agua"]}	\N	"La cuenta" = the bill.	3	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
b59fba30-2f4a-45db-af64-aa8afa3578d6	e1000001-0000-0000-0000-000000000005	AUDIO_TAP	Tap the words you hear in order.	La comida estaba muy buena.	{"word_bank": ["La", "comida", "estaba", "muy", "buena.", "mal", "regular", "rica"]}	\N	\N	4	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
d6074231-fdc6-4e88-ba03-595bdafca80a	e1000001-0000-0000-0000-000000000005	FREE_WRITE	Translate to Spanish: "I would like to order the chicken."	Quisiera pedir el pollo.	\N	\N	Quisiera = I would like, pedir = to order.	5	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
65e825cd-da13-47a3-a6ee-08b0410f1e1c	e1000001-0000-0000-0000-000000000005	WORD_BANK	Translate: "Can I have the bill, please?"	¿Me puede traer la cuenta, por favor?	{"word_bank": ["¿Me", "puede", "traer", "la", "cuenta,", "por", "favor?", "mesa"]}	\N	\N	6	\N	\N	VOCABULARY	\N	INTERMEDIATE	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
6b7647cf-b65f-49c9-baf5-466c5f39e42a	e1000001-0000-0000-0000-000000000005	FILL_BLANK	Complete: "El ___ estaba frío." (The drink was cold.)	refresco	{"choices": ["refresco", "plato", "servicio", "postre"]}	\N	Refresco = soft drink.	7	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
662e5b76-4ca8-4123-8655-a998ddf0c697	e1000001-0000-0000-0000-000000000005	FREE_WRITE	Translate: "We really liked the service."	Nos gustó mucho el servicio.	\N	\N	Gustar: "nos gustó" = we liked.	8	\N	\N	VOCABULARY	\N	INTERMEDIATE	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
b958df96-3c9b-4847-a71a-6eed8d2fff13	e1000001-0000-0000-0000-000000000005	SPEAKING	Say in Spanish: "The dessert was excellent."	El postre estaba excelente.	\N	\N	Estar for temporary quality.	9	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
3d6ef20c-35de-4693-8998-608eb330213d	e1000001-0000-0000-0000-000000000005	READING_COMPREHENSION	Read: "El restaurante tiene buena reputación. La comida es casera y el precio es razonable." — What is said about the price?	Es razonable.	{"choices": ["Es caro.", "Es razonable.", "Es barato.", "No se menciona."]}	\N	Razonable = reasonable.	10	\N	\N	VOCABULARY	\N	INTERMEDIATE	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
1d651a92-b19b-44e9-a3b7-0fa524fc2e40	e1000005-0000-0000-0000-000000000001	IMAGE_PICK	Which is "tomate"?	tomate	{"choices": [{"label": "🍅 tomate", "value": "tomate", "image_keyword": "tomato"}, {"label": "🥔 papa", "value": "papa", "image_keyword": "potato"}, {"label": "🥒 pepino", "value": "pepino", "image_keyword": "cucumber"}]}	\N	\N	1	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
bc023bf1-147d-4015-80ac-c4dd87e906ed	e1000005-0000-0000-0000-000000000001	WORD_BANK	Translate: "How much do the apples cost?"	¿Cuánto cuestan las manzanas?	{"word_bank": ["¿Cuánto", "cuestan", "las", "manzanas?", "cuesta", "el", "qué", "son"]}	\N	Cuestan = they cost (plural).	2	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
087f132d-6c77-4930-a8e5-bca5f5ccb6d7	e1000005-0000-0000-0000-000000000001	FILL_BLANK	Complete: "Dame un ___ de naranjas." (Give me a kilo of oranges.)	kilo	{"choices": ["kilo", "litro", "medio", "docena"]}	\N	\N	3	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
fd2b8af2-f0bd-403a-a96e-0f7807631331	e1000005-0000-0000-0000-000000000001	AUDIO_TAP	Tap the words you hear.	¿Cuánto cuesta el pan?	{"word_bank": ["¿Cuánto", "cuesta", "el", "pan?", "la", "leche", "qué", "cuántos"]}	\N	\N	4	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
e8ebee09-5a3f-4e5a-af43-b0ad979123af	e1000005-0000-0000-0000-000000000001	FREE_WRITE	Translate: "I need two kilos of tomatoes."	Necesito dos kilos de tomates.	\N	\N	\N	5	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
ba916cdd-895c-4da1-a35f-ed0a8b804440	e1000005-0000-0000-0000-000000000001	FILL_BLANK	Complete: "La ___ está fresca." (The lettuce is fresh.)	lechuga	{"choices": ["lechuga", "cebolla", "zanahoria", "fruta"]}	\N	\N	6	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
028b1a53-3ff7-4923-8085-9997a796efc3	e1000005-0000-0000-0000-000000000001	WORD_BANK	Translate: "I will take three avocados."	Llevo tres aguacates.	{"word_bank": ["Llevo", "tres", "aguacates.", "Quiero", "dos", "uno", "tomates", "manzanas"]}	\N	Llevar = to take (when buying).	7	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
3590887a-df90-470c-8cc6-c99b09decfc7	e1000005-0000-0000-0000-000000000001	FREE_WRITE	Translate: "That is too expensive."	Eso es muy caro.	\N	\N	\N	8	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
748d577a-e8c5-4ae1-a1f9-5fbd6ac2011a	e1000005-0000-0000-0000-000000000001	IMAGE_PICK	Which is "cebolla"?	cebolla	{"choices": [{"label": "🧅 cebolla", "value": "cebolla", "image_keyword": "onion"}, {"label": "🥕 zanahoria", "value": "zanahoria", "image_keyword": "carrot"}, {"label": "🥬 lechuga", "value": "lechuga", "image_keyword": "lettuce"}]}	\N	\N	9	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
94fce89a-14b9-4365-9edc-3a11ae7ae52b	e1000005-0000-0000-0000-000000000001	READING_COMPREHENSION	Read: "En el mercado venden frutas y verduras frescas. Los precios son más bajos que en el supermercado." — Where are prices lower?	En el mercado.	{"choices": ["En el supermercado.", "En el mercado.", "En la tienda.", "No se dice."]}	\N	\N	10	\N	\N	VOCABULARY	\N	INTERMEDIATE	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
0b265bdd-a88c-464c-9a50-edfcea794948	e1000001-0000-0000-0000-000000000001	AUDIO_TAP	Tap the words you hear in order.	Quiero arroz y pollo.	{"word_bank": ["Quiero", "arroz", "y", "pollo.", "ensalada", "sopa", "carne", "pan"]}	\N	\N	6	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
4e6db821-3e94-448e-a4a8-e36876c83fc2	e1000001-0000-0000-0000-000000000001	SPEAKING	Say in Spanish: "I want water, please."	Quiero agua, por favor.	\N	\N	\N	7	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
007e4d30-2da6-4c03-bbab-d010af044c9f	e1000001-0000-0000-0000-000000000001	READING_COMPREHENSION	Read: "María pide una ensalada y un vaso de agua. El camarero trae la comida." — What does María order to drink?	agua	{"choices": ["vino", "café", "agua", "jugo"]}	\N	\N	8	\N	\N	VOCABULARY	\N	BEGINNER	\N	\N	NORMAL	LATIN_AMERICAN	SAME_TOPIC	0.75
\.


--
-- Data for Name: grammar_rules; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.grammar_rules (id, code, language, title, explanation, level, category, examples, common_mistakes, related_rule_codes, display_order, created_at) FROM stdin;
c4a579df-cb31-43d2-afec-48140aa6c0f8	SER_VS_ESTAR	es	Ser vs Estar — both mean "to be"	Spanish has two verbs for "to be". SER is used for permanent or inherent characteristics: identity, nationality, profession, physical traits, relationships, time, and origin. ESTAR is used for temporary states: emotions, location, health conditions, and ongoing actions.	BEGINNER	VERBS	[{"note": "Profession = permanent identity → ser", "wrong": "Estoy médico.", "correct": "Soy médico.", "translation": "I am a doctor."}, {"note": "Feeling = temporary state → estar", "wrong": "Soy cansado.", "correct": "Estoy cansado.", "translation": "I am tired."}, {"note": "Inherent color → ser", "wrong": "El libro está rojo.", "correct": "El libro es rojo.", "translation": "The book is red."}, {"note": "Location = temporary → estar", "wrong": "Soy en Madrid.", "correct": "Estoy en Madrid.", "translation": "I am in Madrid."}, {"note": "Telling time → always ser", "wrong": "Están las tres.", "correct": "Son las tres.", "translation": "It is three o clock."}]	["Using estar for professions", "Using ser for emotions", "Using ser for location", "Forgetting estar for health: Estoy enfermo not Soy enfermo"]	\N	0	2026-03-14 18:27:35.681457
35257786-2e14-49ad-b66f-8e596db26cfc	PRESENT_TENSE_AR	es	Present tense — AR verb conjugation	Regular AR verbs follow a predictable pattern in the present tense. Remove the -AR ending and add the correct suffix for each person. This pattern applies to hundreds of common verbs.	BEGINNER	VERBS	[{"el": "habla", "tu": "hablas", "yo": "hablo", "verb": "hablar", "ellos": "hablan", "nosotros": "hablamos", "vosotros": "habláis", "translation": "to speak"}, {"el": "camina", "tu": "caminas", "yo": "camino", "verb": "caminar", "ellos": "caminan", "nosotros": "caminamos", "vosotros": "camináis", "translation": "to walk"}, {"el": "trabaja", "tu": "trabajas", "yo": "trabajo", "verb": "trabajar", "ellos": "trabajan", "nosotros": "trabajamos", "vosotros": "trabajáis", "translation": "to work"}]	["Forgetting accent on nosotros: hablamos not háblamos", "Using hablas for él/ella instead of habla", "Dropping the stem incorrectly"]	\N	0	2026-03-14 18:27:35.681457
feba7d9f-fc66-4334-b459-688c73fc051e	PRESENT_TENSE_ER_IR	es	Present tense — ER and IR verb conjugation	ER and IR verbs share most endings in the present tense. The only differences are in nosotros (-emos vs -imos) and vosotros (-éis vs -ís). Learn both together since they are so similar.	BEGINNER	VERBS	[{"el": "come", "tu": "comes", "yo": "como", "verb": "comer", "ellos": "comen", "nosotros": "comemos", "vosotros": "coméis", "translation": "to eat"}, {"el": "bebe", "tu": "bebes", "yo": "bebo", "verb": "beber", "ellos": "beben", "nosotros": "bebemos", "vosotros": "bebéis", "translation": "to drink"}, {"el": "vive", "tu": "vives", "yo": "vivo", "verb": "vivir", "ellos": "viven", "nosotros": "vivimos", "vosotros": "vivís", "translation": "to live"}, {"el": "escribe", "tu": "escribes", "yo": "escribo", "verb": "escribir", "ellos": "escriben", "nosotros": "escribimos", "vosotros": "escribís", "translation": "to write"}]	["Confusing ER and IR nosotros endings", "Adding -as/-a to ER verbs (hablas pattern)", "Forgetting irregulars: yo form of hacer is hago not haco"]	\N	0	2026-03-14 18:27:35.681457
597457f8-c62a-4ad5-9cc1-b94ae796b399	GENDER_ARTICLES	es	Noun gender and articles (el/la, un/una)	Every Spanish noun has a gender — masculine or feminine. This affects the article used (el/la for definite, un/una for indefinite) and any adjectives that describe the noun. Most nouns ending in -o are masculine, most ending in -a are feminine, but there are important exceptions.	BEGINNER	GENDER_NUMBER	[{"note": "-o ending, masculine", "gender": "masculine", "example": "el libro"}, {"note": "-a ending, feminine", "gender": "feminine", "example": "la mesa"}, {"note": "Exception: -ma ending is usually masculine", "gender": "masculine", "example": "el problema"}, {"note": "Exception: la mano despite -o ending", "gender": "feminine", "example": "la mano"}, {"note": "Some nouns work for both genders", "gender": "both", "example": "un estudiante / una estudiante"}]	["Saying la problema instead of el problema", "Saying el mano instead of la mano", "Forgetting to change article when gender changes meaning: el capital (money) vs la capital (city)"]	\N	0	2026-03-14 18:27:35.681457
df00c045-4e17-4a5d-ab30-29ac9fa53016	ADJECTIVE_AGREEMENT	es	Adjective agreement with nouns	In Spanish, adjectives must agree in gender (masculine/feminine) and number (singular/plural) with the noun they describe. Unlike English where adjectives never change, Spanish adjectives have up to four forms.	BEGINNER	ADJECTIVES	[{"noun": "libro", "forms": {"f_pl": "pequeñas", "f_sg": "pequeña", "m_pl": "pequeños", "m_sg": "pequeño"}, "adj_base": "pequeño"}, {"note": "Grande does not change for gender", "noun": "casa", "forms": {"pl": "grandes", "sg": "grande"}, "adj_base": "grande"}, {"correct": true, "example": "El chico es alto."}, {"correct": true, "example": "La chica es alta."}, {"fix": "alta — must agree with feminine noun", "correct": false, "example": "La chica es alto."}]	["Using masculine form with feminine nouns: la chica es alto", "Forgetting plural: los libros son pequeños not pequeño", "Placing adjective before noun incorrectly for emphasis"]	\N	0	2026-03-14 18:27:35.681457
2ddbd35b-f8be-40fb-a4aa-f49efff166c1	PRETERITE_REGULAR	es	Preterite tense — completed past actions	The preterite (pretérito indefinido) is used for actions completed at a specific time in the past. Think of it as the simple past in English. It answers: what happened? Regular AR verbs add one set of endings, ER/IR verbs share another set.	INTERMEDIATE	TENSES	[{"el": "habló", "tu": "hablaste", "yo": "hablé", "note": "Note accent on yo and él", "verb": "hablar", "ellos": "hablaron", "nosotros": "hablamos"}, {"el": "comió", "tu": "comiste", "yo": "comí", "verb": "comer", "ellos": "comieron", "nosotros": "comimos"}, {"note": "Specific past time = preterite", "example": "Ayer comí una pizza.", "translation": "Yesterday I ate a pizza."}, {"note": "Completed, countable action = preterite", "example": "Ella llamó tres veces.", "translation": "She called three times."}]	["Forgetting accent on yo form: hablé not hable", "Confusing with imperfect for background descriptions", "Using preterite for habitual past: I used to eat = comía not comí"]	\N	0	2026-03-14 18:27:35.681457
0ba0a82e-36b7-4b24-8e0f-a97f63cc2aab	PARA_VS_POR	es	Para vs Por — both can mean "for"	Para and por are both translated as "for" in English but have distinct uses. Para points toward a destination, purpose, deadline, or recipient. Por indicates cause, exchange, duration, means, or on behalf of.	INTERMEDIATE	PREPOSITIONS	[{"rule": "para = recipient", "correct": "Este regalo es para ti.", "translation": "This gift is for you."}, {"rule": "por = cause/reason", "correct": "Gracias por tu ayuda.", "translation": "Thank you for your help."}, {"rule": "para = destination", "correct": "Salgo para Madrid.", "translation": "I am leaving for Madrid."}, {"rule": "por = exchange", "correct": "Lo compré por diez dólares.", "translation": "I bought it for ten dollars."}, {"rule": "para = purpose/goal", "correct": "Estudia para ser médico.", "translation": "He studies to become a doctor."}, {"rule": "por = means of communication", "correct": "Llamé por teléfono.", "translation": "I called by phone."}]	["Using por with deadline: Lo necesito para el lunes not por el lunes", "Using para for duration: Viví allí por dos años not para dos años", "Confusing purpose (para) with cause (por)"]	\N	0	2026-03-14 18:27:35.681457
e766c45f-ae1b-4399-af63-132642177d3a	SUBJUNCTIVE_INTRO	es	Present subjunctive — wishes, doubts, emotions	The subjunctive mood expresses subjectivity: wishes, hopes, doubts, emotions, and recommendations. It almost always appears in a dependent clause introduced by que, following a main clause expressing these concepts. Think: whenever you want someone else to do something, use subjunctive.	UPPER_INTERMEDIATE	TENSES	[{"note": "want + que + subjunctive", "example": "Quiero que estudies.", "translation": "I want you to study."}, {"note": "hope + que + subjunctive", "example": "Espero que llegues pronto.", "translation": "I hope you arrive soon."}, {"note": "impersonal expression + que + subjunctive", "example": "Es importante que comas bien.", "translation": "It is important that you eat well."}, {"note": "doubt + que + subjunctive", "example": "Dudo que sea verdad.", "translation": "I doubt it is true."}]	["Using infinitive instead of subjunctive: Quiero que estudiar (wrong) → Quiero que estudies", "Forgetting que connector", "Using subjunctive when same subject: Quiero estudiar not Quiero que yo estudie"]	\N	0	2026-03-14 18:27:35.681457
269ed4d4-4164-41c7-92e4-01560767093e	SIMPLE_PRESENT_EN	en	Simple present tense — habits and facts	The simple present in English is used for habits, routines, general truths, and permanent states. Add -s or -es to the verb for third person singular (he, she, it). Use do/does for questions and negatives.	BEGINNER	TENSES	[{"note": "No change to verb", "person": "I", "example": "I eat breakfast every day."}, {"note": "Add -s for he/she/it", "person": "she", "example": "She eats breakfast every day."}, {"note": "Add -es after ch, sh, x, o, s", "person": "he", "example": "He watches TV at night."}, {"note": "Use do for questions with I/you/we/they", "example": "Do you speak English?"}, {"note": "Use does for he/she/it questions", "example": "Does she speak English?"}]	["Forgetting -s for he/she/it: She eat instead of She eats", "Using does with I: Does I speak? → Do I speak?", "Doubling verb: She does speaks → She speaks"]	\N	0	2026-03-14 18:27:35.681457
b32d5bde-7186-45cd-87a7-332b6fe35463	ARTICLES_EN	en	Articles — a, an, the	English has three articles. Use a before consonant sounds, an before vowel sounds, and the for specific or previously mentioned nouns. Unlike Spanish, English nouns have no gender, but the difference between a/an and the is critical.	BEGINNER	ARTICLES	[{"note": "First mention, non-specific", "example": "I saw a dog."}, {"note": "Second mention, now specific", "example": "The dog was friendly."}, {"note": "an before vowel sound (a)", "example": "an apple"}, {"note": "a before consonant sound (yu-niversity)", "example": "a university"}, {"note": "an before silent h (silent consonant = vowel sound)", "example": "an hour"}]	["Using a before vowel sounds: a apple → an apple", "Using a/an with specific previously mentioned nouns", "Forgetting the before superlatives: She is best → She is the best"]	\N	0	2026-03-14 18:27:35.681457
16d16a11-533d-47ec-a9a2-9412832665cf	PAST_SIMPLE_EN	en	Simple past tense — completed actions	The simple past describes actions completed at a specific time in the past. Regular verbs add -ed. Irregular verbs must be memorized individually. Use did for questions and negatives with all verbs.	BEGINNER	TENSES	[{"base": "walk", "past": "walked", "example": "I walked to school yesterday."}, {"base": "eat", "note": "Irregular", "past": "ate", "example": "She ate pizza for dinner."}, {"base": "go", "note": "Irregular", "past": "went", "example": "We went to the beach."}, {"note": "did + base form for questions", "example": "Did you eat breakfast?"}, {"note": "did not + base form for negatives", "example": "I did not go."}]	["Using present in past context: Yesterday I go → Yesterday I went", "Using did with past form: Did you went? → Did you go?", "Regularizing irregular verbs: He goed → He went"]	\N	0	2026-03-14 18:27:35.681457
1bb8f300-1e69-49aa-b85e-42e9b1da9a24	MODAL_VERBS_EN	en	Modal verbs — can, could, should, must, will, would	Modal verbs express ability, possibility, permission, obligation, and prediction. They are always followed by the base form of the verb (no -s, no -ing). They do not use do/does for questions — simply invert with the subject.	INTERMEDIATE	MODALS	[{"use": "ability/permission", "modal": "can", "example": "I can swim. Can I leave?"}, {"use": "past ability / polite request", "modal": "could", "example": "I could swim as a child. Could you help me?"}, {"use": "advice/recommendation", "modal": "should", "example": "You should eat more vegetables."}, {"use": "strong obligation", "modal": "must", "example": "You must wear a seatbelt."}, {"use": "polite request / conditional", "modal": "would", "example": "Would you like coffee? I would go if I could."}]	["Adding -s to modal: She cans → She can", "Using to after modal: I can to swim → I can swim", "Using do for modal questions: Do you can? → Can you?"]	\N	0	2026-03-14 18:27:35.681457
b4180603-603f-4eaf-a09d-3ac78bd74d86	IMPERFECT_ES	es	Imperfect tense — ongoing or habitual past	The imperfect (imperfecto) describes ongoing, repeated, or habitual actions in the past, or background/description. It does not focus on the end of the action. Use it for "used to," "was/were -ing," and description.	INTERMEDIATE	TENSES	[{"example": "Cuando era niño, jugaba al fútbol.", "translation": "When I was a child, I used to play soccer."}, {"example": "Ella cocinaba mientras yo leía.", "translation": "She was cooking while I was reading."}]	["Confusing with preterite for single completed actions", "Using imperfect for one-time events"]	\N	0	2026-03-15 04:05:54.045248
8d29a859-bf8d-4f18-bcb9-fc072e414507	CONDITIONAL_ES	es	Conditional tense — would	The conditional (condicional) expresses what would happen under a condition, polite requests, or hypotheticals. Form: infinitive + ía, ías, ía, íamos, íais, ían.	INTERMEDIATE	TENSES	[{"example": "Me gustaría un café.", "translation": "I would like a coffee."}, {"example": "Si tuviera tiempo, viajaría más.", "translation": "If I had time, I would travel more."}]	["Using conditional without condition", "Confusing with future"]	\N	0	2026-03-15 04:05:54.045248
e92d820a-78a3-4e6e-ac26-4ff8b3dce110	PRESENT_PERFECT_ES	es	Present perfect — have done	The present perfect (pretérito perfecto) is formed with haber + past participle. It describes actions that happened in a period that is still ongoing (today, this week) or that have relevance to the present.	INTERMEDIATE	TENSES	[{"example": "He comido ya.", "translation": "I have already eaten."}, {"example": "¿Has estado en España?", "translation": "Have you been to Spain?"}]	["Using preterite for recent past with hoy/esta semana", "Forgetting participle agreement with object"]	\N	0	2026-03-15 04:05:54.045248
9977ab5f-4f8a-4f22-b82c-bbb78b5dca63	DEMONSTRATIVES_ES	es	Demonstratives — this, that, these, those	Spanish has three levels: este/esta (this), ese/esa (that), aquel/aquella (that over there). They agree in gender and number with the noun.	BEGINNER	PRONOUNS	[{"example": "Esta casa es grande.", "translation": "This house is big."}, {"example": "Esos libros son míos.", "translation": "Those books are mine."}]	["Using ese for something close", "Forgetting number agreement"]	\N	0	2026-03-15 04:05:54.045248
b1228089-1100-4d35-81e7-c019a7447397	COMPARATIVES_ES	es	Comparatives — more than, less than, as as	Use más + adjective + que (more than), menos + adjective + que (less than), tan + adjective + como (as as). Irregular: mejor (better), peor (worse), mayor (older), menor (younger).	BEGINNER	ADJECTIVES	[{"example": "Juan es más alto que Pedro.", "translation": "Juan is taller than Pedro."}, {"example": "Soy tan cansado como tú.", "translation": "I am as tired as you."}]	["Using más bueno instead of mejor", "Confusing que and como"]	\N	0	2026-03-15 04:05:54.045248
201fb676-4faf-4b89-8005-abb07e09904e	SIMPLE_FUTURE_EN	en	Simple future — will	Use will + base form for predictions, promises, and spontaneous decisions. Use be going to + base form for plans or evidence-based predictions.	BEGINNER	TENSES	[{"note": "Promise", "example": "I will call you tomorrow."}, {"note": "Plan", "example": "She is going to study medicine."}]	["Using will for planned actions when going to is better", "Forgetting base form after will"]	\N	0	2026-03-15 04:05:54.045248
6b1e47a7-1c3c-46a2-9161-c1a86a316f0f	PRESENT_CONTINUOUS_EN	en	Present continuous — be + -ing	Use am/is/are + -ing for actions happening now or around now, or temporary situations. Do not use for state verbs (know, want, need).	BEGINNER	TENSES	[{"note": "Happening now", "example": "I am studying right now."}, {"note": "Temporary", "example": "She is working in Madrid this month."}]	["Using continuous with state verbs: I am knowing", "Dropping the be verb"]	\N	0	2026-03-15 04:05:54.045248
0a48b018-2bd2-4a47-b945-5c8be538d68b	PRESENT_PERFECT_EN	en	Present perfect — have/has + past participle	Use for actions that happened at an unspecified time, or that started in the past and continue. Use for/since with duration.	INTERMEDIATE	TENSES	[{"note": "Unspecified past", "example": "I have been to Japan."}, {"note": "Duration", "example": "She has lived here for five years."}]	["Using past simple with already/yet/just", "Using have when subject is third person (has)"]	\N	0	2026-03-15 04:05:54.045248
\.


--
-- Data for Name: leaderboard_entries; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.leaderboard_entries (id, user_id, week_start, xp_earned, league, rank) FROM stdin;
\.


--
-- Data for Name: lesson_cultural_notes; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.lesson_cultural_notes (lesson_id, cultural_note_id, show_after_exercise) FROM stdin;
e1000001-0000-0000-0000-000000000003	bc6adece-7157-4158-8017-43b18fd84f74	3
e1000002-0000-0000-0000-000000000001	5ac020a7-a92f-429f-8cc5-11424d83f983	2
\.


--
-- Data for Name: lesson_feedback; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.lesson_feedback (id, user_id, lesson_id, rating, difficulty_felt, comment, submitted_at) FROM stdin;
\.


--
-- Data for Name: lesson_navigation_log; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.lesson_navigation_log (id, user_id, lesson_id, exercise_id, action, from_exercise_order, to_exercise_order, "timestamp") FROM stdin;
90af6ce8-6809-4c6f-87a2-ae2656652ab2	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000002	\N	START	\N	0	2026-03-24 13:19:38.668576
a6f54da0-3c62-4265-ae0c-a58b8cb146d8	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000002	\N	NEXT	0	1	2026-03-24 13:19:40.133217
f0736cae-8836-4e2f-baa6-e106c0010260	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000002	\N	NEXT	1	2	2026-03-24 13:19:40.57182
5d4221e8-7e3a-412b-852d-3bee1bd463c2	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000002	\N	NEXT	2	3	2026-03-24 13:19:41.00813
5c10a7a9-e6d2-4e50-82eb-2cbc00cda668	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000002	\N	NEXT	3	4	2026-03-24 13:19:41.424143
35e86acb-6c33-476c-a21c-7a93964f52d6	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000002	\N	NEXT	4	5	2026-03-24 13:19:41.773085
81671a9a-728a-4912-ad93-5e4e63d8282d	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000002	\N	NEXT	5	6	2026-03-24 13:19:42.200651
7b37eec8-9b5a-41a5-9ce2-c1f1ae42f504	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000002	\N	NEXT	6	7	2026-03-24 13:19:42.532504
514f9311-88fd-4272-98b9-73d1cde03538	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000002	\N	NEXT	7	8	2026-03-24 13:19:42.806519
150cb3b6-e184-49f5-9558-fbe54a92bb90	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000002	\N	NEXT	8	9	2026-03-24 13:19:42.982351
6e1bc8ac-e6fe-4393-b284-84a77ee85cf2	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000002	\N	NEXT	9	10	2026-03-24 13:19:43.157218
7bd6a42d-7fde-44d8-adfc-f77af3a3422f	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000002	\N	NEXT	10	11	2026-03-24 13:19:43.331908
ec42fe1a-88e6-4eaa-b6f9-93e2d7d3bdda	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000002	\N	NEXT	11	12	2026-03-24 13:19:43.506157
b9be50a4-a07f-4320-b351-3939ce4acf5e	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000002	\N	NEXT	12	13	2026-03-24 13:19:43.665718
50488625-ea8e-42cf-858b-d47dc32d6569	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000002	\N	NEXT	13	14	2026-03-24 13:19:43.841772
3ac54edf-5e93-4294-a203-074c6de4f6b2	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000002	\N	NEXT	14	15	2026-03-24 13:19:44.008931
171a89a3-8adf-467a-80e2-640a622011a2	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000002	\N	NEXT	15	16	2026-03-24 13:19:44.188717
9e8e5fdb-54cf-4979-ac45-ad4628f42ef6	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000002	\N	START	\N	0	2026-03-24 13:19:53.246024
9e83968b-3bdf-4f7e-8173-029f32e87a0f	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000001	\N	START	\N	0	2026-03-24 13:27:24.441488
bc734552-2c7a-4ef3-8066-5fcfb47cdcf5	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000001	\N	NEXT	0	1	2026-03-24 13:27:25.858238
0414f46f-9f81-456c-9a2c-2b9060ba3513	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000001	\N	NEXT	1	2	2026-03-24 13:27:26.015458
85d7c6e7-ed0b-4108-a55a-a3985db4df4a	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000001	\N	NEXT	2	3	2026-03-24 13:27:26.157248
e9ba825c-0aef-4273-b19a-40c536397a4d	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000001	\N	NEXT	3	4	2026-03-24 13:27:26.306363
80af550b-df15-4bd4-9dd8-83b2ed876448	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000001	\N	NEXT	4	5	2026-03-24 13:27:26.458315
bc3b0fe4-b047-40db-bbf3-0ae8a2b251b4	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000001	\N	NEXT	5	6	2026-03-24 13:27:26.589476
1e607923-50d8-4798-979b-7c1d13a2168c	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000001	\N	NEXT	6	7	2026-03-24 13:27:26.740931
073ea1c7-8c34-495c-bb2d-abe77ca2f07c	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000001	\N	NEXT	7	8	2026-03-24 13:27:26.887858
4f5ed598-d703-4779-8f6c-906bee219ef5	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000001	\N	NEXT	8	9	2026-03-24 13:27:27.038545
d95666b1-6105-499f-9a44-a9d51eadd2ca	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000001	\N	NEXT	9	10	2026-03-24 13:27:27.166484
78bb3827-edc6-4453-8284-17b0f529416c	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000001	\N	NEXT	10	11	2026-03-24 13:27:27.324328
2f2698f5-f973-433c-884d-aebad0ba8b5a	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000001	\N	NEXT	11	12	2026-03-24 13:27:27.588834
b5b2dcb4-aa43-4d6e-a9ed-4c1604670ae8	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000001	\N	NEXT	12	13	2026-03-24 13:27:27.874034
b6c258cb-a9d4-4003-9274-4e87a2cecd18	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000001	\N	NEXT	13	14	2026-03-24 13:27:28.189802
43548930-a2b3-4035-85cc-1479261991d4	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000001	\N	NEXT	14	15	2026-03-24 13:27:28.485681
a02c2544-f378-4d96-8032-fcb4a7d4d87c	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000001	\N	NEXT	15	16	2026-03-24 13:27:28.698502
5ce7aad8-457b-4c1e-bcb0-69003c2af298	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000001	\N	NEXT	16	17	2026-03-24 13:27:28.957097
f73b02c1-d978-472a-9cf7-ff6b7157e5a8	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000001	\N	NEXT	17	18	2026-03-24 13:27:29.178812
60c7297b-60f5-47fc-8c84-10abc42c5f42	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000001	\N	NEXT	18	19	2026-03-24 13:27:29.365041
6f526e7c-18cc-4870-9022-072b67447b3b	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000001	\N	NEXT	19	20	2026-03-24 13:27:29.56543
9bd24a15-e21c-4185-9b6f-2049ee9f1f28	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000001	\N	NEXT	20	21	2026-03-24 13:27:29.737414
8164ba02-a5c1-4908-9c82-e46490266a1b	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000001	\N	NEXT	21	22	2026-03-24 13:27:29.955587
901c8db0-f827-4e7c-b87a-37918950cb67	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000001	\N	NEXT	22	23	2026-03-24 13:27:30.241122
f651ddf5-dcea-46bc-8e5d-3d63c5000594	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000001	\N	NEXT	23	24	2026-03-24 13:27:30.422802
fa244f9b-40ae-46ab-a0f1-1f7780c2ad3f	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000001	\N	NEXT	24	25	2026-03-24 13:27:30.59026
bc57d344-4fe8-4756-8215-fd7f5ea121c0	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000001	\N	NEXT	25	26	2026-03-24 13:27:30.739837
47550978-a451-4046-afd7-7dade3e1dd1f	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000001	\N	NEXT	26	27	2026-03-24 13:27:30.881946
ea9499a3-2fc8-4efe-98c6-d4a3fa49cdb2	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000001	\N	NEXT	27	28	2026-03-24 13:27:31.050084
61b52ba9-a441-440c-acac-4f92efadf053	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000001	\N	NEXT	28	29	2026-03-24 13:27:31.198405
87b8d930-5398-47b1-9c55-cbd3471b4ffd	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000001	\N	COMPLETE	29	\N	2026-03-24 13:27:31.307398
3412ed92-f481-4a8e-a46c-eaad2a5becb7	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000001	a7ed26bf-669c-4988-9d39-9479874b71ca	NEXT	0	1	2026-03-24 13:27:31.432327
ede55634-edbd-44e9-862e-caf47af44dcb	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000001	a92200af-565a-4cba-b3ee-fe8cbc263dbe	NEXT	2	3	2026-03-24 13:27:34.248346
7971bdd4-c9d7-4d92-aa89-50f420bf9941	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000001	fcb313bc-992e-4eda-a1a4-0aa4175dccdd	NEXT	1	2	2026-03-24 13:27:32.574711
d59563f8-9f11-4220-a367-d40ebd8ce45f	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000001	a9725395-ad0d-4873-8f2d-9f870197eacd	NEXT	3	4	2026-03-24 13:27:49.582005
0c641e66-344e-4891-9624-142ea9dbb4fc	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000004	\N	START	\N	0	2026-03-24 14:55:47.928691
d9a90734-8441-43e8-92c4-e6d9ea53b528	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000005	\N	START	\N	0	2026-03-30 16:07:45.176198
4db572d1-47b2-4aae-8d66-fde1faa10061	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000005	\N	NEXT	0	1	2026-03-30 16:07:46.561048
f28939bc-a600-4ab1-8236-358727ed1892	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000005	\N	NEXT	1	2	2026-03-30 16:07:46.849687
e7726664-121e-4037-b8d4-0461e795a4af	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000005	\N	NEXT	2	3	2026-03-30 16:07:47.118784
0ad7754a-18e6-4377-831c-a7d82669d397	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000005	\N	NEXT	3	4	2026-03-30 16:07:47.31418
\.


--
-- Data for Name: lesson_versions; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.lesson_versions (id, lesson_id, version_number, changed_by, change_summary, snapshot, created_at) FROM stdin;
\.


--
-- Data for Name: lessons; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.lessons (id, unit_id, title, lesson_number, total_lessons_in_unit, xp_reward, display_order, lesson_type, grammar_rule_id, reading_passage_id, estimated_minutes, prerequisite_lesson_id, unlock_condition) FROM stdin;
e1000001-0000-0000-0000-000000000001	c1111111-0000-0000-0000-000000000001	Food vocabulary	1	4	10	1	VOCABULARY	\N	\N	5	\N	\N
e1000001-0000-0000-0000-000000000002	c1111111-0000-0000-0000-000000000001	Drinks vocabulary	2	4	10	2	VOCABULARY	\N	\N	5	\N	\N
e1000001-0000-0000-0000-000000000003	c1111111-0000-0000-0000-000000000001	Ordering at a restaurant	3	4	10	3	VOCABULARY	\N	\N	5	\N	\N
e1000001-0000-0000-0000-000000000004	c1111111-0000-0000-0000-000000000001	Paying the bill	4	4	15	4	VOCABULARY	\N	\N	5	\N	\N
e1000002-0000-0000-0000-000000000001	c1111111-0000-0000-0000-000000000002	Basic greetings	1	4	10	1	VOCABULARY	\N	\N	5	\N	\N
e1000002-0000-0000-0000-000000000002	c1111111-0000-0000-0000-000000000002	Introducing yourself	2	4	10	2	VOCABULARY	\N	\N	5	\N	\N
e1000002-0000-0000-0000-000000000003	c1111111-0000-0000-0000-000000000002	Asking how someone is	3	4	10	3	VOCABULARY	\N	\N	5	\N	\N
e1000002-0000-0000-0000-000000000004	c1111111-0000-0000-0000-000000000002	Formal vs informal speech	4	4	15	4	VOCABULARY	\N	\N	5	\N	\N
e1000003-0000-0000-0000-000000000001	c1111111-0000-0000-0000-000000000003	Physical descriptions	1	4	10	1	VOCABULARY	\N	\N	5	\N	\N
e1000003-0000-0000-0000-000000000002	c1111111-0000-0000-0000-000000000003	Personality adjectives	2	4	10	2	VOCABULARY	\N	\N	5	\N	\N
e1000003-0000-0000-0000-000000000003	c1111111-0000-0000-0000-000000000003	Family members	3	4	10	3	VOCABULARY	\N	\N	5	\N	\N
e1000003-0000-0000-0000-000000000004	c1111111-0000-0000-0000-000000000003	Talking about people	4	4	15	4	VOCABULARY	\N	\N	5	\N	\N
e1000004-0000-0000-0000-000000000001	c1111111-0000-0000-0000-000000000004	Numbers 1-20	1	4	10	1	VOCABULARY	\N	\N	5	\N	\N
e1000004-0000-0000-0000-000000000002	c1111111-0000-0000-0000-000000000004	Numbers 21-100	2	4	10	2	VOCABULARY	\N	\N	5	\N	\N
e1000004-0000-0000-0000-000000000003	c1111111-0000-0000-0000-000000000004	Telling the time	3	4	10	3	VOCABULARY	\N	\N	5	\N	\N
e1000004-0000-0000-0000-000000000004	c1111111-0000-0000-0000-000000000004	Days and months	4	4	15	4	VOCABULARY	\N	\N	5	\N	\N
e1000009-0000-0000-0000-000000000001	c1111111-0000-0000-0000-000000000009	Asking for directions	1	4	15	1	VOCABULARY	\N	\N	5	\N	\N
e1000009-0000-0000-0000-000000000002	c1111111-0000-0000-0000-000000000009	Places in the city	2	4	15	2	VOCABULARY	\N	\N	5	\N	\N
e1000009-0000-0000-0000-000000000003	c1111111-0000-0000-0000-000000000009	Transportation vocabulary	3	4	15	3	VOCABULARY	\N	\N	5	\N	\N
e1000009-0000-0000-0000-000000000004	c1111111-0000-0000-0000-000000000009	Reading a map	4	4	20	4	VOCABULARY	\N	\N	5	\N	\N
e1000013-0000-0000-0000-000000000001	c1111111-0000-0000-0000-000000000013	Professional greetings	1	4	15	1	VOCABULARY	\N	\N	5	\N	\N
e1000013-0000-0000-0000-000000000002	c1111111-0000-0000-0000-000000000013	Job titles and roles	2	4	15	2	VOCABULARY	\N	\N	5	\N	\N
e1000013-0000-0000-0000-000000000003	c1111111-0000-0000-0000-000000000013	Talking about your company	3	4	15	3	VOCABULARY	\N	\N	5	\N	\N
e1000013-0000-0000-0000-000000000004	c1111111-0000-0000-0000-000000000013	Networking conversation	4	4	20	4	VOCABULARY	\N	\N	5	\N	\N
f1000001-0000-0000-0000-000000000001	d2222222-0000-0000-0000-000000000001	Food vocabulary	1	4	10	1	VOCABULARY	\N	\N	5	\N	\N
f1000001-0000-0000-0000-000000000002	d2222222-0000-0000-0000-000000000001	Drinks vocabulary	2	4	10	2	VOCABULARY	\N	\N	5	\N	\N
f1000001-0000-0000-0000-000000000003	d2222222-0000-0000-0000-000000000001	Ordering at a restaurant	3	4	10	3	VOCABULARY	\N	\N	5	\N	\N
f1000001-0000-0000-0000-000000000004	d2222222-0000-0000-0000-000000000001	Paying the bill	4	4	15	4	VOCABULARY	\N	\N	5	\N	\N
f1000002-0000-0000-0000-000000000001	d2222222-0000-0000-0000-000000000002	Basic greetings	1	4	10	1	VOCABULARY	\N	\N	5	\N	\N
f1000002-0000-0000-0000-000000000002	d2222222-0000-0000-0000-000000000002	Introducing yourself	2	4	10	2	VOCABULARY	\N	\N	5	\N	\N
f1000002-0000-0000-0000-000000000003	d2222222-0000-0000-0000-000000000002	Asking how someone is	3	4	10	3	VOCABULARY	\N	\N	5	\N	\N
f1000002-0000-0000-0000-000000000004	d2222222-0000-0000-0000-000000000002	Formal vs informal speech	4	4	15	4	VOCABULARY	\N	\N	5	\N	\N
f1000013-0000-0000-0000-000000000001	d2222222-0000-0000-0000-000000000013	Professional greetings	1	4	15	1	VOCABULARY	\N	\N	5	\N	\N
f1000013-0000-0000-0000-000000000002	d2222222-0000-0000-0000-000000000013	Job titles and roles	2	4	15	2	VOCABULARY	\N	\N	5	\N	\N
f1000013-0000-0000-0000-000000000003	d2222222-0000-0000-0000-000000000013	Talking about your company	3	4	15	3	VOCABULARY	\N	\N	5	\N	\N
f1000013-0000-0000-0000-000000000004	d2222222-0000-0000-0000-000000000013	Networking conversation	4	4	20	4	VOCABULARY	\N	\N	5	\N	\N
e1000001-0000-0000-0000-000000000005	c1111111-0000-0000-0000-000000000001	Restaurant review	5	5	15	5	VOCABULARY	\N	\N	6	\N	\N
e1000002-0000-0000-0000-000000000005	c1111111-0000-0000-0000-000000000002	Saying goodbye	5	5	15	5	CONVERSATION	\N	\N	5	\N	\N
e1000003-0000-0000-0000-000000000005	c1111111-0000-0000-0000-000000000003	Review: describing people	5	5	15	5	REVIEW	\N	\N	5	\N	\N
e1000004-0000-0000-0000-000000000005	c1111111-0000-0000-0000-000000000004	Making appointments	5	5	15	5	CONVERSATION	\N	\N	6	\N	\N
e1000009-0000-0000-0000-000000000005	c1111111-0000-0000-0000-000000000009	Review: directions	5	5	20	5	REVIEW	\N	\N	6	\N	\N
e1000013-0000-0000-0000-000000000005	c1111111-0000-0000-0000-000000000013	Review: business intro	5	5	20	5	REVIEW	\N	\N	5	\N	\N
f1000001-0000-0000-0000-000000000005	d2222222-0000-0000-0000-000000000001	Restaurant review	5	5	15	5	VOCABULARY	\N	\N	6	\N	\N
f1000002-0000-0000-0000-000000000005	d2222222-0000-0000-0000-000000000002	Saying goodbye	5	5	15	5	CONVERSATION	\N	\N	5	\N	\N
f1000013-0000-0000-0000-000000000005	d2222222-0000-0000-0000-000000000013	Review: business intro	5	5	20	5	REVIEW	\N	\N	5	\N	\N
e1000005-0000-0000-0000-000000000001	c1111111-0000-0000-0000-000000000005	Market vocabulary	1	5	12	1	VOCABULARY	\N	\N	5	\N	\N
e1000005-0000-0000-0000-000000000002	c1111111-0000-0000-0000-000000000005	Prices and quantities	2	5	12	2	VOCABULARY	\N	\N	5	\N	\N
e1000005-0000-0000-0000-000000000003	c1111111-0000-0000-0000-000000000005	Bargaining and paying	3	5	12	3	CONVERSATION	\N	\N	6	\N	\N
e1000005-0000-0000-0000-000000000004	c1111111-0000-0000-0000-000000000005	Fruits and vegetables	4	5	12	4	VOCABULARY	\N	\N	5	\N	\N
e1000005-0000-0000-0000-000000000005	c1111111-0000-0000-0000-000000000005	Review: at the market	5	5	15	5	REVIEW	\N	\N	5	\N	\N
e1000006-0000-0000-0000-000000000001	c1111111-0000-0000-0000-000000000006	Family members	1	5	12	1	VOCABULARY	\N	\N	5	\N	\N
e1000006-0000-0000-0000-000000000002	c1111111-0000-0000-0000-000000000006	Rooms and furniture	2	5	12	2	VOCABULARY	\N	\N	5	\N	\N
e1000006-0000-0000-0000-000000000003	c1111111-0000-0000-0000-000000000006	Talking about family	3	5	12	3	CONVERSATION	\N	\N	6	\N	\N
e1000006-0000-0000-0000-000000000004	c1111111-0000-0000-0000-000000000006	Possessives	4	5	12	4	GRAMMAR	\N	\N	6	\N	\N
e1000006-0000-0000-0000-000000000005	c1111111-0000-0000-0000-000000000006	Review: family and home	5	5	15	5	REVIEW	\N	\N	5	\N	\N
e1000007-0000-0000-0000-000000000001	c1111111-0000-0000-0000-000000000007	Morning routine	1	5	12	1	VOCABULARY	\N	\N	5	\N	\N
e1000007-0000-0000-0000-000000000002	c1111111-0000-0000-0000-000000000007	Reflexive verbs	2	5	12	2	GRAMMAR	\N	\N	6	\N	\N
e1000007-0000-0000-0000-000000000003	c1111111-0000-0000-0000-000000000007	Time expressions	3	5	12	3	VOCABULARY	\N	\N	5	\N	\N
e1000007-0000-0000-0000-000000000004	c1111111-0000-0000-0000-000000000007	Describing your day	4	5	12	4	CONVERSATION	\N	\N	6	\N	\N
e1000007-0000-0000-0000-000000000005	c1111111-0000-0000-0000-000000000007	Review: daily routines	5	5	15	5	REVIEW	\N	\N	5	\N	\N
e1000008-0000-0000-0000-000000000001	c1111111-0000-0000-0000-000000000008	Weather vocabulary	1	5	12	1	VOCABULARY	\N	\N	5	\N	\N
e1000008-0000-0000-0000-000000000002	c1111111-0000-0000-0000-000000000008	Seasons and months	2	5	12	2	VOCABULARY	\N	\N	5	\N	\N
e1000008-0000-0000-0000-000000000003	c1111111-0000-0000-0000-000000000008	Talking about weather	3	5	12	3	CONVERSATION	\N	\N	5	\N	\N
e1000008-0000-0000-0000-000000000004	c1111111-0000-0000-0000-000000000008	Hacer and weather	4	5	12	4	GRAMMAR	\N	\N	6	\N	\N
e1000008-0000-0000-0000-000000000005	c1111111-0000-0000-0000-000000000008	Review: weather	5	5	15	5	REVIEW	\N	\N	5	\N	\N
e1000010-0000-0000-0000-000000000001	c1111111-0000-0000-0000-000000000010	Airport vocabulary	1	5	15	1	VOCABULARY	\N	\N	6	\N	\N
e1000010-0000-0000-0000-000000000002	c1111111-0000-0000-0000-000000000010	Check-in and boarding	2	5	15	2	CONVERSATION	\N	\N	6	\N	\N
e1000010-0000-0000-0000-000000000003	c1111111-0000-0000-0000-000000000010	Customs and security	3	5	15	3	CONVERSATION	\N	\N	6	\N	\N
e1000010-0000-0000-0000-000000000004	c1111111-0000-0000-0000-000000000010	Asking for help	4	5	15	4	VOCABULARY	\N	\N	5	\N	\N
e1000010-0000-0000-0000-000000000005	c1111111-0000-0000-0000-000000000010	Review: airport	5	5	20	5	REVIEW	\N	\N	5	\N	\N
e1000011-0000-0000-0000-000000000001	c1111111-0000-0000-0000-000000000011	Hotel vocabulary	1	5	15	1	VOCABULARY	\N	\N	5	\N	\N
e1000011-0000-0000-0000-000000000002	c1111111-0000-0000-0000-000000000011	Checking in	2	5	15	2	CONVERSATION	\N	\N	6	\N	\N
e1000011-0000-0000-0000-000000000003	c1111111-0000-0000-0000-000000000011	Room requests	3	5	15	3	CONVERSATION	\N	\N	5	\N	\N
e1000011-0000-0000-0000-000000000004	c1111111-0000-0000-0000-000000000011	Checking out	4	5	15	4	CONVERSATION	\N	\N	6	\N	\N
e1000011-0000-0000-0000-000000000005	c1111111-0000-0000-0000-000000000011	Review: hotels	5	5	20	5	REVIEW	\N	\N	5	\N	\N
e1000012-0000-0000-0000-000000000001	c1111111-0000-0000-0000-000000000012	Transport vocabulary	1	5	15	1	VOCABULARY	\N	\N	5	\N	\N
e1000012-0000-0000-0000-000000000002	c1111111-0000-0000-0000-000000000012	Taking the bus	2	5	15	2	CONVERSATION	\N	\N	5	\N	\N
e1000012-0000-0000-0000-000000000003	c1111111-0000-0000-0000-000000000012	Taxis and rides	3	5	15	3	CONVERSATION	\N	\N	5	\N	\N
e1000012-0000-0000-0000-000000000004	c1111111-0000-0000-0000-000000000012	Tickets and schedules	4	5	15	4	VOCABULARY	\N	\N	5	\N	\N
e1000012-0000-0000-0000-000000000005	c1111111-0000-0000-0000-000000000012	Review: transportation	5	5	20	5	REVIEW	\N	\N	5	\N	\N
e1000014-0000-0000-0000-000000000001	c1111111-0000-0000-0000-000000000014	Meeting vocabulary	1	5	15	1	VOCABULARY	\N	\N	5	\N	\N
e1000014-0000-0000-0000-000000000002	c1111111-0000-0000-0000-000000000014	Leading a meeting	2	5	15	2	CONVERSATION	\N	\N	6	\N	\N
e1000014-0000-0000-0000-000000000003	c1111111-0000-0000-0000-000000000014	Presenting ideas	3	5	15	3	CONVERSATION	\N	\N	6	\N	\N
e1000014-0000-0000-0000-000000000004	c1111111-0000-0000-0000-000000000014	Q&A and feedback	4	5	15	4	CONVERSATION	\N	\N	5	\N	\N
e1000014-0000-0000-0000-000000000005	c1111111-0000-0000-0000-000000000014	Review: meetings	5	5	20	5	REVIEW	\N	\N	5	\N	\N
e1000015-0000-0000-0000-000000000001	c1111111-0000-0000-0000-000000000015	Email openings	1	5	15	1	WRITING	\N	\N	5	\N	\N
e1000015-0000-0000-0000-000000000002	c1111111-0000-0000-0000-000000000015	Formal language	2	5	15	2	WRITING	\N	\N	6	\N	\N
e1000015-0000-0000-0000-000000000003	c1111111-0000-0000-0000-000000000015	Requests and replies	3	5	15	3	WRITING	\N	\N	6	\N	\N
e1000015-0000-0000-0000-000000000004	c1111111-0000-0000-0000-000000000015	Closing and signing off	4	5	15	4	WRITING	\N	\N	5	\N	\N
e1000015-0000-0000-0000-000000000005	c1111111-0000-0000-0000-000000000015	Review: emails	5	5	20	5	REVIEW	\N	\N	5	\N	\N
e1000016-0000-0000-0000-000000000001	c1111111-0000-0000-0000-000000000016	Body and symptoms	1	5	15	1	VOCABULARY	\N	\N	5	\N	\N
e1000016-0000-0000-0000-000000000002	c1111111-0000-0000-0000-000000000016	At the pharmacy	2	5	15	2	CONVERSATION	\N	\N	5	\N	\N
e1000016-0000-0000-0000-000000000003	c1111111-0000-0000-0000-000000000016	At the doctor	3	5	15	3	CONVERSATION	\N	\N	6	\N	\N
e1000016-0000-0000-0000-000000000004	c1111111-0000-0000-0000-000000000016	Emergency phrases	4	5	15	4	VOCABULARY	\N	\N	5	\N	\N
e1000016-0000-0000-0000-000000000005	c1111111-0000-0000-0000-000000000016	Review: health	5	5	20	5	REVIEW	\N	\N	5	\N	\N
e1000017-0000-0000-0000-000000000001	c1111111-0000-0000-0000-000000000017	Expressing opinions	1	5	20	1	CONVERSATION	\N	\N	6	\N	\N
e1000017-0000-0000-0000-000000000002	c1111111-0000-0000-0000-000000000017	Agreeing and disagreeing	2	5	20	2	CONVERSATION	\N	\N	6	\N	\N
e1000017-0000-0000-0000-000000000003	c1111111-0000-0000-0000-000000000017	Debate phrases	3	5	20	3	VOCABULARY	\N	\N	6	\N	\N
e1000017-0000-0000-0000-000000000004	c1111111-0000-0000-0000-000000000017	Subjunctive in opinions	4	5	20	4	GRAMMAR	\N	\N	7	\N	\N
e1000017-0000-0000-0000-000000000005	c1111111-0000-0000-0000-000000000017	Review: debates	5	5	25	5	REVIEW	\N	\N	6	\N	\N
e1000018-0000-0000-0000-000000000001	c1111111-0000-0000-0000-000000000018	News vocabulary	1	5	20	1	VOCABULARY	\N	\N	6	\N	\N
e1000018-0000-0000-0000-000000000002	c1111111-0000-0000-0000-000000000018	Summarizing news	2	5	20	2	READING	\N	\N	7	\N	\N
e1000018-0000-0000-0000-000000000003	c1111111-0000-0000-0000-000000000018	Discussing current events	3	5	20	3	CONVERSATION	\N	\N	6	\N	\N
e1000018-0000-0000-0000-000000000004	c1111111-0000-0000-0000-000000000018	Fake news and sources	4	5	20	4	VOCABULARY	\N	\N	5	\N	\N
e1000018-0000-0000-0000-000000000005	c1111111-0000-0000-0000-000000000018	Review: media	5	5	25	5	REVIEW	\N	\N	6	\N	\N
e1000019-0000-0000-0000-000000000001	c1111111-0000-0000-0000-000000000019	Negotiation vocabulary	1	5	20	1	VOCABULARY	\N	\N	6	\N	\N
e1000019-0000-0000-0000-000000000002	c1111111-0000-0000-0000-000000000019	Making proposals	2	5	20	2	CONVERSATION	\N	\N	6	\N	\N
e1000019-0000-0000-0000-000000000003	c1111111-0000-0000-0000-000000000019	Counterarguments	3	5	20	3	CONVERSATION	\N	\N	6	\N	\N
e1000019-0000-0000-0000-000000000004	c1111111-0000-0000-0000-000000000019	Closing a deal	4	5	20	4	CONVERSATION	\N	\N	5	\N	\N
e1000019-0000-0000-0000-000000000005	c1111111-0000-0000-0000-000000000019	Review: negotiations	5	5	25	5	REVIEW	\N	\N	6	\N	\N
e1000020-0000-0000-0000-000000000001	c1111111-0000-0000-0000-000000000020	Essay structure	1	5	20	1	WRITING	\N	\N	7	\N	\N
e1000020-0000-0000-0000-000000000002	c1111111-0000-0000-0000-000000000020	Formal connectors	2	5	20	2	GRAMMAR	\N	\N	6	\N	\N
e1000020-0000-0000-0000-000000000003	c1111111-0000-0000-0000-000000000020	Argumentation	3	5	20	3	WRITING	\N	\N	7	\N	\N
e1000020-0000-0000-0000-000000000004	c1111111-0000-0000-0000-000000000020	Reports and summaries	4	5	20	4	WRITING	\N	\N	6	\N	\N
e1000020-0000-0000-0000-000000000005	c1111111-0000-0000-0000-000000000020	Review: formal writing	5	5	25	5	REVIEW	\N	\N	6	\N	\N
f1000003-0000-0000-0000-000000000001	d2222222-0000-0000-0000-000000000003	Physical descriptions	1	5	12	1	VOCABULARY	\N	\N	5	\N	\N
f1000003-0000-0000-0000-000000000002	d2222222-0000-0000-0000-000000000003	Personality adjectives	2	5	12	2	VOCABULARY	\N	\N	5	\N	\N
f1000003-0000-0000-0000-000000000003	d2222222-0000-0000-0000-000000000003	Family members	3	5	12	3	VOCABULARY	\N	\N	5	\N	\N
f1000003-0000-0000-0000-000000000004	d2222222-0000-0000-0000-000000000003	Talking about people	4	5	12	4	CONVERSATION	\N	\N	6	\N	\N
f1000003-0000-0000-0000-000000000005	d2222222-0000-0000-0000-000000000003	Review: describing people	5	5	15	5	REVIEW	\N	\N	5	\N	\N
f1000004-0000-0000-0000-000000000001	d2222222-0000-0000-0000-000000000004	Numbers 1-20	1	5	12	1	VOCABULARY	\N	\N	5	\N	\N
f1000004-0000-0000-0000-000000000002	d2222222-0000-0000-0000-000000000004	Numbers 21-100	2	5	12	2	VOCABULARY	\N	\N	5	\N	\N
f1000004-0000-0000-0000-000000000003	d2222222-0000-0000-0000-000000000004	Telling the time	3	5	12	3	VOCABULARY	\N	\N	5	\N	\N
f1000004-0000-0000-0000-000000000004	d2222222-0000-0000-0000-000000000004	Days and months	4	5	12	4	VOCABULARY	\N	\N	5	\N	\N
f1000004-0000-0000-0000-000000000005	d2222222-0000-0000-0000-000000000004	Making appointments	5	5	15	5	CONVERSATION	\N	\N	6	\N	\N
f1000005-0000-0000-0000-000000000001	d2222222-0000-0000-0000-000000000005	Market vocabulary	1	5	12	1	VOCABULARY	\N	\N	5	\N	\N
f1000005-0000-0000-0000-000000000002	d2222222-0000-0000-0000-000000000005	Prices and quantities	2	5	12	2	VOCABULARY	\N	\N	5	\N	\N
f1000005-0000-0000-0000-000000000003	d2222222-0000-0000-0000-000000000005	Shopping dialogue	3	5	12	3	CONVERSATION	\N	\N	6	\N	\N
f1000005-0000-0000-0000-000000000004	d2222222-0000-0000-0000-000000000005	Fruits and vegetables	4	5	12	4	VOCABULARY	\N	\N	5	\N	\N
f1000005-0000-0000-0000-000000000005	d2222222-0000-0000-0000-000000000005	Review: at the market	5	5	15	5	REVIEW	\N	\N	5	\N	\N
f1000006-0000-0000-0000-000000000001	d2222222-0000-0000-0000-000000000006	Family members	1	5	12	1	VOCABULARY	\N	\N	5	\N	\N
f1000006-0000-0000-0000-000000000002	d2222222-0000-0000-0000-000000000006	Rooms and furniture	2	5	12	2	VOCABULARY	\N	\N	5	\N	\N
f1000006-0000-0000-0000-000000000003	d2222222-0000-0000-0000-000000000006	Talking about family	3	5	12	3	CONVERSATION	\N	\N	6	\N	\N
f1000006-0000-0000-0000-000000000004	d2222222-0000-0000-0000-000000000006	Possessives	4	5	12	4	GRAMMAR	\N	\N	6	\N	\N
f1000006-0000-0000-0000-000000000005	d2222222-0000-0000-0000-000000000006	Review: family and home	5	5	15	5	REVIEW	\N	\N	5	\N	\N
f1000007-0000-0000-0000-000000000001	d2222222-0000-0000-0000-000000000007	Morning routine	1	5	12	1	VOCABULARY	\N	\N	5	\N	\N
f1000007-0000-0000-0000-000000000002	d2222222-0000-0000-0000-000000000007	Daily verbs	2	5	12	2	GRAMMAR	\N	\N	6	\N	\N
f1000007-0000-0000-0000-000000000003	d2222222-0000-0000-0000-000000000007	Time expressions	3	5	12	3	VOCABULARY	\N	\N	5	\N	\N
f1000007-0000-0000-0000-000000000004	d2222222-0000-0000-0000-000000000007	Describing your day	4	5	12	4	CONVERSATION	\N	\N	6	\N	\N
f1000007-0000-0000-0000-000000000005	d2222222-0000-0000-0000-000000000007	Review: daily routines	5	5	15	5	REVIEW	\N	\N	5	\N	\N
f1000008-0000-0000-0000-000000000001	d2222222-0000-0000-0000-000000000008	Weather vocabulary	1	5	12	1	VOCABULARY	\N	\N	5	\N	\N
f1000008-0000-0000-0000-000000000002	d2222222-0000-0000-0000-000000000008	Seasons and months	2	5	12	2	VOCABULARY	\N	\N	5	\N	\N
f1000008-0000-0000-0000-000000000003	d2222222-0000-0000-0000-000000000008	Talking about weather	3	5	12	3	CONVERSATION	\N	\N	5	\N	\N
f1000008-0000-0000-0000-000000000004	d2222222-0000-0000-0000-000000000008	Weather grammar	4	5	12	4	GRAMMAR	\N	\N	6	\N	\N
f1000008-0000-0000-0000-000000000005	d2222222-0000-0000-0000-000000000008	Review: weather	5	5	15	5	REVIEW	\N	\N	5	\N	\N
f1000009-0000-0000-0000-000000000001	d2222222-0000-0000-0000-000000000009	Asking for directions	1	5	15	1	CONVERSATION	\N	\N	6	\N	\N
f1000009-0000-0000-0000-000000000002	d2222222-0000-0000-0000-000000000009	Places in the city	2	5	15	2	VOCABULARY	\N	\N	5	\N	\N
f1000009-0000-0000-0000-000000000003	d2222222-0000-0000-0000-000000000009	Transport vocabulary	3	5	15	3	VOCABULARY	\N	\N	5	\N	\N
f1000009-0000-0000-0000-000000000004	d2222222-0000-0000-0000-000000000009	Reading a map	4	5	15	4	VOCABULARY	\N	\N	5	\N	\N
f1000009-0000-0000-0000-000000000005	d2222222-0000-0000-0000-000000000009	Review: directions	5	5	20	5	REVIEW	\N	\N	5	\N	\N
f1000010-0000-0000-0000-000000000001	d2222222-0000-0000-0000-000000000010	Airport vocabulary	1	5	15	1	VOCABULARY	\N	\N	6	\N	\N
f1000010-0000-0000-0000-000000000002	d2222222-0000-0000-0000-000000000010	Check-in and boarding	2	5	15	2	CONVERSATION	\N	\N	6	\N	\N
f1000010-0000-0000-0000-000000000003	d2222222-0000-0000-0000-000000000010	Customs and security	3	5	15	3	CONVERSATION	\N	\N	6	\N	\N
f1000010-0000-0000-0000-000000000004	d2222222-0000-0000-0000-000000000010	Asking for help	4	5	15	4	VOCABULARY	\N	\N	5	\N	\N
f1000010-0000-0000-0000-000000000005	d2222222-0000-0000-0000-000000000010	Review: airport	5	5	20	5	REVIEW	\N	\N	5	\N	\N
f1000011-0000-0000-0000-000000000001	d2222222-0000-0000-0000-000000000011	Hotel vocabulary	1	5	15	1	VOCABULARY	\N	\N	5	\N	\N
f1000011-0000-0000-0000-000000000002	d2222222-0000-0000-0000-000000000011	Checking in	2	5	15	2	CONVERSATION	\N	\N	6	\N	\N
f1000011-0000-0000-0000-000000000003	d2222222-0000-0000-0000-000000000011	Room requests	3	5	15	3	CONVERSATION	\N	\N	5	\N	\N
f1000011-0000-0000-0000-000000000004	d2222222-0000-0000-0000-000000000011	Checking out	4	5	15	4	CONVERSATION	\N	\N	6	\N	\N
f1000011-0000-0000-0000-000000000005	d2222222-0000-0000-0000-000000000011	Review: hotels	5	5	20	5	REVIEW	\N	\N	5	\N	\N
f1000012-0000-0000-0000-000000000001	d2222222-0000-0000-0000-000000000012	Transport vocabulary	1	5	15	1	VOCABULARY	\N	\N	5	\N	\N
f1000012-0000-0000-0000-000000000002	d2222222-0000-0000-0000-000000000012	Taking the bus	2	5	15	2	CONVERSATION	\N	\N	5	\N	\N
f1000012-0000-0000-0000-000000000003	d2222222-0000-0000-0000-000000000012	Taxis and rides	3	5	15	3	CONVERSATION	\N	\N	5	\N	\N
f1000012-0000-0000-0000-000000000004	d2222222-0000-0000-0000-000000000012	Tickets and schedules	4	5	15	4	VOCABULARY	\N	\N	5	\N	\N
f1000012-0000-0000-0000-000000000005	d2222222-0000-0000-0000-000000000012	Review: transportation	5	5	20	5	REVIEW	\N	\N	5	\N	\N
f1000014-0000-0000-0000-000000000001	d2222222-0000-0000-0000-000000000014	Meeting vocabulary	1	5	15	1	VOCABULARY	\N	\N	5	\N	\N
f1000014-0000-0000-0000-000000000002	d2222222-0000-0000-0000-000000000014	Leading a meeting	2	5	15	2	CONVERSATION	\N	\N	6	\N	\N
f1000014-0000-0000-0000-000000000003	d2222222-0000-0000-0000-000000000014	Presenting ideas	3	5	15	3	CONVERSATION	\N	\N	6	\N	\N
f1000014-0000-0000-0000-000000000004	d2222222-0000-0000-0000-000000000014	Q&A and feedback	4	5	15	4	CONVERSATION	\N	\N	5	\N	\N
f1000014-0000-0000-0000-000000000005	d2222222-0000-0000-0000-000000000014	Review: meetings	5	5	20	5	REVIEW	\N	\N	5	\N	\N
f1000015-0000-0000-0000-000000000001	d2222222-0000-0000-0000-000000000015	Email openings	1	5	15	1	WRITING	\N	\N	5	\N	\N
f1000015-0000-0000-0000-000000000002	d2222222-0000-0000-0000-000000000015	Formal language	2	5	15	2	WRITING	\N	\N	6	\N	\N
f1000015-0000-0000-0000-000000000003	d2222222-0000-0000-0000-000000000015	Requests and replies	3	5	15	3	WRITING	\N	\N	6	\N	\N
f1000015-0000-0000-0000-000000000004	d2222222-0000-0000-0000-000000000015	Closing and signing off	4	5	15	4	WRITING	\N	\N	5	\N	\N
f1000015-0000-0000-0000-000000000005	d2222222-0000-0000-0000-000000000015	Review: emails	5	5	20	5	REVIEW	\N	\N	5	\N	\N
f1000016-0000-0000-0000-000000000001	d2222222-0000-0000-0000-000000000016	Body and symptoms	1	5	15	1	VOCABULARY	\N	\N	5	\N	\N
f1000016-0000-0000-0000-000000000002	d2222222-0000-0000-0000-000000000016	At the pharmacy	2	5	15	2	CONVERSATION	\N	\N	5	\N	\N
f1000016-0000-0000-0000-000000000003	d2222222-0000-0000-0000-000000000016	At the doctor	3	5	15	3	CONVERSATION	\N	\N	6	\N	\N
f1000016-0000-0000-0000-000000000004	d2222222-0000-0000-0000-000000000016	Emergency phrases	4	5	15	4	VOCABULARY	\N	\N	5	\N	\N
f1000016-0000-0000-0000-000000000005	d2222222-0000-0000-0000-000000000016	Review: health	5	5	20	5	REVIEW	\N	\N	5	\N	\N
f1000017-0000-0000-0000-000000000001	d2222222-0000-0000-0000-000000000017	Expressing opinions	1	5	20	1	CONVERSATION	\N	\N	6	\N	\N
f1000017-0000-0000-0000-000000000002	d2222222-0000-0000-0000-000000000017	Agreeing and disagreeing	2	5	20	2	CONVERSATION	\N	\N	6	\N	\N
f1000017-0000-0000-0000-000000000003	d2222222-0000-0000-0000-000000000017	Debate phrases	3	5	20	3	VOCABULARY	\N	\N	6	\N	\N
f1000017-0000-0000-0000-000000000004	d2222222-0000-0000-0000-000000000017	Opinion grammar	4	5	20	4	GRAMMAR	\N	\N	7	\N	\N
f1000017-0000-0000-0000-000000000005	d2222222-0000-0000-0000-000000000017	Review: debates	5	5	25	5	REVIEW	\N	\N	6	\N	\N
f1000018-0000-0000-0000-000000000001	d2222222-0000-0000-0000-000000000018	News vocabulary	1	5	20	1	VOCABULARY	\N	\N	6	\N	\N
f1000018-0000-0000-0000-000000000002	d2222222-0000-0000-0000-000000000018	Summarizing news	2	5	20	2	READING	\N	\N	7	\N	\N
f1000018-0000-0000-0000-000000000003	d2222222-0000-0000-0000-000000000018	Discussing current events	3	5	20	3	CONVERSATION	\N	\N	6	\N	\N
f1000018-0000-0000-0000-000000000004	d2222222-0000-0000-0000-000000000018	Media and sources	4	5	20	4	VOCABULARY	\N	\N	5	\N	\N
f1000018-0000-0000-0000-000000000005	d2222222-0000-0000-0000-000000000018	Review: media	5	5	25	5	REVIEW	\N	\N	6	\N	\N
f1000019-0000-0000-0000-000000000001	d2222222-0000-0000-0000-000000000019	Negotiation vocabulary	1	5	20	1	VOCABULARY	\N	\N	6	\N	\N
f1000019-0000-0000-0000-000000000002	d2222222-0000-0000-0000-000000000019	Making proposals	2	5	20	2	CONVERSATION	\N	\N	6	\N	\N
f1000019-0000-0000-0000-000000000003	d2222222-0000-0000-0000-000000000019	Counterarguments	3	5	20	3	CONVERSATION	\N	\N	6	\N	\N
f1000019-0000-0000-0000-000000000004	d2222222-0000-0000-0000-000000000019	Closing a deal	4	5	20	4	CONVERSATION	\N	\N	5	\N	\N
f1000019-0000-0000-0000-000000000005	d2222222-0000-0000-0000-000000000019	Review: negotiations	5	5	25	5	REVIEW	\N	\N	6	\N	\N
f1000020-0000-0000-0000-000000000001	d2222222-0000-0000-0000-000000000020	Essay structure	1	5	20	1	WRITING	\N	\N	7	\N	\N
f1000020-0000-0000-0000-000000000002	d2222222-0000-0000-0000-000000000020	Formal connectors	2	5	20	2	GRAMMAR	\N	\N	6	\N	\N
f1000020-0000-0000-0000-000000000003	d2222222-0000-0000-0000-000000000020	Argumentation	3	5	20	3	WRITING	\N	\N	7	\N	\N
f1000020-0000-0000-0000-000000000004	d2222222-0000-0000-0000-000000000020	Reports and summaries	4	5	20	4	WRITING	\N	\N	6	\N	\N
f1000020-0000-0000-0000-000000000005	d2222222-0000-0000-0000-000000000020	Review: formal writing	5	5	25	5	REVIEW	\N	\N	6	\N	\N
\.


--
-- Data for Name: level_change_history; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.level_change_history (id, user_id, changed_by, change_type, previous_level, new_level, reason, changed_at) FROM stdin;
\.


--
-- Data for Name: milestone_reassessments; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.milestone_reassessments (id, user_id, language, triggered_at, trigger_reason, lessons_completed, previous_level, new_level, skill_snapshot, reassessment_type, test_id) FROM stdin;
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.notifications (id, user_id, type, title, body, is_read, scheduled_at, delivered_at, delivery_status, channel, retry_count, expires_at, sent_at) FROM stdin;
\.


--
-- Data for Name: payment_transactions; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.payment_transactions (id, user_id, subscription_id, transaction_ref, gateway, amount, currency, status, gateway_response, failure_reason, initiated_at, completed_at, timeout_at, ip_address, is_encrypted) FROM stdin;
\.


--
-- Data for Name: personalized_lesson_plans; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.personalized_lesson_plans (id, user_id, language, generated_at, valid_until, skill_snapshot, lesson_allocation, is_active) FROM stdin;
\.


--
-- Data for Name: personalized_lesson_queue; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.personalized_lesson_queue (id, plan_id, user_id, lesson_id, reason, priority, is_completed, completed_at) FROM stdin;
\.


--
-- Data for Name: phrases; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.phrases (id, language, phrase, translation, phonetic_guide, context, level, topic_tag, formality, audio_text, example_dialogue) FROM stdin;
d6706c6c-5bdb-4f65-a631-04a807b2b2e5	es	¿Dónde está el baño?	Where is the bathroom?	DOHN-deh ehs-TAH el BAH-nyoh	Restaurant, travel	BEGINNER	TRAVEL_ES	NEUTRAL	¿Dónde está el baño?	[{"text": "Perdón, ¿dónde está el baño?", "speaker": "learner"}, {"text": "Al fondo a la derecha.", "speaker": "native"}]
ab3c306f-a5fa-4e46-a99a-4484dc8a7011	es	¿Cuánto cuesta?	How much does it cost?	KWAHN-toh KWEHS-tah	Shopping, market	BEGINNER	TRAVEL_ES	NEUTRAL	¿Cuánto cuesta?	[{"text": "¿Cuánto cuesta esta camisa?", "speaker": "learner"}, {"text": "Cuesta veinte dólares.", "speaker": "native"}]
d95bbce4-1fc5-4d39-beb0-5874fdf770f6	es	No entiendo.	I do not understand.	Noh ehn-TYEHN-doh	Any conversation	BEGINNER	CONVERSATION_ES	NEUTRAL	No entiendo.	[{"text": "Lo siento, no entiendo. ¿Puede repetir?", "speaker": "learner"}, {"text": "Claro, con gusto.", "speaker": "native"}]
bcc04708-e7ea-4fa7-b572-4274981df6d5	es	¿Puede repetir, por favor?	Can you repeat, please?	PWEH-deh reh-peh-TEER, por fah-BOR	Any conversation	BEGINNER	CONVERSATION_ES	FORMAL	¿Puede repetir, por favor?	\N
e9696143-912c-4553-af1a-026a265cea3d	es	Habla más despacio, por favor.	Speak more slowly, please.	AH-blah mahs dehs-PAH-syoh, por fah-BOR	Any conversation	BEGINNER	CONVERSATION_ES	NEUTRAL	Habla más despacio, por favor.	\N
e2e1903b-ce1d-4936-8952-ce8605a8b276	es	¿Habla inglés?	Do you speak English?	AH-blah een-GLEHS	Travel emergency	BEGINNER	TRAVEL_ES	FORMAL	¿Habla inglés?	\N
2a1a3b7a-ba32-4906-a370-867b19a9e65d	es	Estoy perdido/a.	I am lost.	ehs-TOY pehr-DEE-doh	Travel, navigation	BEGINNER	TRAVEL_ES	NEUTRAL	Estoy perdido.	\N
becb4a37-c209-4eba-98b8-8b719b01f7aa	es	La cuenta, por favor.	The bill, please.	Lah KWEHN-tah, por fah-BOR	Restaurant	BEGINNER	FOOD_ES	NEUTRAL	La cuenta, por favor.	[{"text": "Disculpe, la cuenta por favor.", "speaker": "learner"}, {"text": "Enseguida.", "speaker": "native"}]
b2356ac8-4e76-4f0e-970c-a03427f1a294	es	¿Me puede traer...?	Can you bring me...?	Meh PWEH-deh trah-EHR	Restaurant	BEGINNER	FOOD_ES	FORMAL	¿Me puede traer más agua?	\N
8b7df538-0e68-46f1-b5c5-c43ee1916ba0	es	Tengo una reservación.	I have a reservation.	TEHN-goh OO-nah reh-sehr-bah-SYOHN	Hotel, restaurant	BEGINNER	TRAVEL_ES	FORMAL	Tengo una reservación a nombre de García.	\N
b9600f6b-8266-4ef5-a13c-eab5732e09c1	es	¿A qué hora...?	At what time...?	Ah keh OH-rah	Scheduling, transport	BEGINNER	TRAVEL_ES	NEUTRAL	¿A qué hora sale el tren?	\N
b93eafe1-2988-46b8-b027-f6888f64decc	es	Me gustaría...	I would like...	Meh goos-tah-REE-ah	Ordering, requests	BEGINNER	FOOD_ES	FORMAL	Me gustaría el menú del día.	\N
4da80abe-e984-426e-b306-e5f801ec32bc	es	¿Tiene...?	Do you have...?	TYEH-neh	Shopping, restaurant	BEGINNER	FOOD_ES	NEUTRAL	¿Tiene una mesa para dos?	\N
e99a21c6-6d53-4f6d-863b-dba26627c4c8	es	Soy alérgico/a a...	I am allergic to...	Soy ah-LEHR-hee-koh ah	Health, restaurant	INTERMEDIATE	HEALTH_ES	NEUTRAL	Soy alérgico al maní.	\N
6f50d921-dd7e-48fb-858d-32e972519b34	es	Llame a un médico.	Call a doctor.	YAH-meh ah oon MEH-dee-koh	Emergency	INTERMEDIATE	HEALTH_ES	NEUTRAL	Por favor, llame a un médico. Es una emergencia.	\N
16ed4126-dbba-442e-817e-ddf534838643	es	¿Podría hablar con...?	Could I speak with...?	poh-DREE-ah ah-BLAR kon	Business, phone	INTERMEDIATE	BUSINESS_ES	FORMAL	¿Podría hablar con el gerente?	\N
be39ce55-299b-4112-87a1-0ea17fbaff59	es	Estoy de acuerdo.	I agree.	ehs-TOY deh ah-KWEHR-doh	Business, conversation	INTERMEDIATE	BUSINESS_ES	FORMAL	Estoy de acuerdo con su propuesta.	\N
1a4176cf-dac4-4a92-b7be-dfcd17fa5d9f	es	Sin embargo...	However...	seen ehm-BAR-goh	Business, debate	UPPER_INTERMEDIATE	BUSINESS_ES	FORMAL	Es una buena idea; sin embargo, el presupuesto es limitado.	\N
002967be-a337-4636-8ed1-223f61b5793e	en	Where is the bathroom?	¿Dónde está el baño?	WEHR iz thuh BATH-room	Restaurant, travel	BEGINNER	TRAVEL_EN	NEUTRAL	Where is the bathroom?	[{"text": "Excuse me, where is the bathroom?", "speaker": "learner"}, {"text": "Down the hall on the right.", "speaker": "native"}]
dcaa3afd-60ce-45b6-8d66-98aaa1c8869f	en	How much does this cost?	¿Cuánto cuesta esto?	How much duz this kost	Shopping	BEGINNER	TRAVEL_EN	NEUTRAL	How much does this cost?	\N
727774d3-1d7c-4e43-92b6-5bccf43fff66	en	I do not understand.	No entiendo.	I doh not un-der-STAND	Any conversation	BEGINNER	CONVERSATION_EN	NEUTRAL	I do not understand. Could you say that again?	\N
9e36057c-46f9-4fe9-b790-05bd6ee20b27	en	Could you speak more slowly?	¿Puede hablar más despacio?	Kood you speek more SLOH-lee	Any conversation	BEGINNER	CONVERSATION_EN	FORMAL	Could you please speak more slowly?	\N
306aefaf-940a-4017-86bb-06be44db69d4	en	Do you speak Spanish?	¿Habla español?	Doo you speek SPAN-ish	Travel, emergency	BEGINNER	TRAVEL_EN	NEUTRAL	Excuse me, do you speak Spanish?	\N
c3e30411-d8b1-4822-b269-9c712d65e91a	en	I am lost.	Estoy perdido.	I am lost	Travel	BEGINNER	TRAVEL_EN	NEUTRAL	Excuse me, I am lost. Can you help me?	\N
16207308-3c3c-4376-9d20-c0bb7c20a8a8	en	Can I have the check, please?	¿Me puede traer la cuenta?	Kan I hav thuh chek pleez	Restaurant	BEGINNER	FOOD_EN	NEUTRAL	Excuse me, can I have the check, please?	[{"text": "Excuse me, can I have the check please?", "speaker": "learner"}, {"text": "Of course, I will bring it right away.", "speaker": "native"}]
3a99a1a0-f524-49d4-993a-66f55ba83358	en	I would like...	Me gustaría...	I wood like	Ordering, requests	BEGINNER	FOOD_EN	FORMAL	I would like the chicken, please.	\N
98bc9f2f-3310-420c-9661-98b4dabd72bc	en	Do you have...?	¿Tiene...?	Doo you hav	Restaurant, shopping	BEGINNER	FOOD_EN	NEUTRAL	Do you have a table for two?	\N
1ba1dc31-c458-49ff-99c4-4f7b562b9449	en	I am allergic to...	Soy alérgico a...	I am ah-LEHR-jik too	Health, restaurant	INTERMEDIATE	HEALTH_EN	NEUTRAL	I am allergic to peanuts.	\N
8bcfc1ef-b39c-4352-a124-618719a0006e	en	Call an ambulance!	¡Llame a una ambulancia!	Kol an AM-byoo-lans	Emergency	INTERMEDIATE	HEALTH_EN	NEUTRAL	Call an ambulance! This is an emergency.	\N
324e359e-83d9-4054-8401-d186de0b87ee	en	Could I speak with the manager?	¿Podría hablar con el gerente?	Kood I speek with thuh MAN-ih-jer	Business	INTERMEDIATE	BUSINESS_EN	FORMAL	Could I speak with the manager, please?	\N
7351d8c5-b1e3-4839-96bd-d267664820f0	en	I agree with you.	Estoy de acuerdo contigo.	I ah-GREE with you	Business, conversation	INTERMEDIATE	BUSINESS_EN	FORMAL	I completely agree with your proposal.	\N
5171386f-8611-4ff2-8596-4c237d5a9b5c	en	However...	Sin embargo...	How-EV-er	Business, writing	UPPER_INTERMEDIATE	BUSINESS_EN	FORMAL	That is a good point; however, the budget is limited.	\N
08281ea6-2805-4dc1-b612-be1be9ee5757	es	¿Me puede dar la cuenta, por favor?	Can you give me the bill, please?	me PWE-de dar la KWEN-ta por fa-VOR	restaurant	BEGINNER	FOOD_ES	NEUTRAL	\N	\N
5a587cb6-8995-48c2-8297-34a2dd0b6fa5	es	¿Dónde está el baño?	Where is the bathroom?	DON-de es-TA el BA-nyo	general	BEGINNER	CONVERSATION_ES	NEUTRAL	\N	\N
e4dad6ac-1abb-4281-8a59-2844ab61c07a	es	No entiendo. ¿Puede repetir?	I do not understand. Can you repeat?	no en-tien-DO PWE-de re-pe-TIR	general	BEGINNER	CONVERSATION_ES	FORMAL	\N	\N
446f4b89-cb13-4790-8caf-b61b264e1260	es	Mucho gusto en conocerte.	Nice to meet you.	MU-cho GUS-to en co-no-CER-te	introductions	BEGINNER	CONVERSATION_ES	NEUTRAL	\N	\N
8a9479c2-fdec-4f26-ad3e-21800908aeef	es	¿A qué hora abre el banco?	What time does the bank open?	a ke O-ra A-bre el BAN-co	services	INTERMEDIATE	CONVERSATION_ES	NEUTRAL	\N	\N
288b6250-a268-427e-856d-02b98eee0a7b	es	Me gustaría hacer una reserva.	I would like to make a reservation.	me gus-ta-RI-a a-CER u-na re-SER-va	hotel/restaurant	INTERMEDIATE	TRAVEL_ES	FORMAL	\N	\N
d3ce8176-5363-48f9-8c0a-3e345db2435e	es	¿Podría hablar con el gerente?	Could I speak with the manager?	po-DRI-a ha-BLAR con el he-REN-te	business	INTERMEDIATE	BUSINESS_ES	FORMAL	\N	\N
fe9bb3e7-9bc7-4dea-aa95-38b39cbd8355	en	Can I have the bill, please?	¿Me puede dar la cuenta, por favor?	kan ay hav the bil pliz	restaurant	BEGINNER	FOOD_EN	NEUTRAL	\N	\N
7cc67252-b3c0-44e5-825d-f48f2483894c	en	Where is the bathroom?	¿Dónde está el baño?	wer iz the BATH-room	general	BEGINNER	CONVERSATION_EN	NEUTRAL	\N	\N
aff074e8-b3af-42fd-8f14-add4c5aa54d9	en	I do not understand. Can you repeat?	No entiendo. ¿Puede repetir?	ay do not un-der-STAND kan yu ri-PEET	general	BEGINNER	CONVERSATION_EN	NEUTRAL	\N	\N
0402c254-1e45-4d65-90b8-d7aec0ae4e41	en	Nice to meet you.	Mucho gusto en conocerte.	nys tu meet yu	introductions	BEGINNER	CONVERSATION_EN	NEUTRAL	\N	\N
9ad1133c-d980-4977-aa94-ff6433e1c94f	en	What time does the bank open?	¿A qué hora abre el banco?	wot tym duz the bank OH-pun	services	INTERMEDIATE	CONVERSATION_EN	NEUTRAL	\N	\N
ef43616a-45b2-41ad-a574-9688a1909317	en	I would like to make a reservation.	Me gustaría hacer una reserva.	ay wud lyk tu mayk a re-zer-VAY-shun	hotel/restaurant	INTERMEDIATE	TRAVEL_EN	FORMAL	\N	\N
524c8973-ed75-4389-85a9-081c7c318a33	en	Could I speak with the manager?	¿Podría hablar con el gerente?	kud ay speek with the MA-ni-jer	business	INTERMEDIATE	BUSINESS_EN	FORMAL	\N	\N
45aafa4b-4514-4d08-abc5-70b2f473fbb4	es	¿Me puede dar la cuenta, por favor?	Can you give me the bill, please?	me PWE-de dar la KWEN-ta por fa-VOR	restaurant	BEGINNER	FOOD_ES	NEUTRAL	\N	\N
e99fc53f-3b57-4111-830a-a0c715548801	es	¿Dónde está el baño?	Where is the bathroom?	DON-de es-TA el BA-nyo	general	BEGINNER	CONVERSATION_ES	NEUTRAL	\N	\N
e5c2faa3-7a2d-4106-b3af-1cd6ad31da39	es	No entiendo. ¿Puede repetir?	I do not understand. Can you repeat?	no en-tien-DO PWE-de re-pe-TIR	general	BEGINNER	CONVERSATION_ES	FORMAL	\N	\N
4823e08b-3f87-4017-9744-89c53e88a772	es	Mucho gusto en conocerte.	Nice to meet you.	MU-cho GUS-to en co-no-CER-te	introductions	BEGINNER	CONVERSATION_ES	NEUTRAL	\N	\N
c32cd61c-92ef-450f-a382-493bc03b2086	es	¿A qué hora abre el banco?	What time does the bank open?	a ke O-ra A-bre el BAN-co	services	INTERMEDIATE	CONVERSATION_ES	NEUTRAL	\N	\N
35570eb5-7917-46ad-83ea-a40705b67e7b	es	Me gustaría hacer una reserva.	I would like to make a reservation.	me gus-ta-RI-a a-CER u-na re-SER-va	hotel/restaurant	INTERMEDIATE	TRAVEL_ES	FORMAL	\N	\N
5855aeab-f503-4174-98a2-f3416ee9b77d	es	¿Podría hablar con el gerente?	Could I speak with the manager?	po-DRI-a ha-BLAR con el he-REN-te	business	INTERMEDIATE	BUSINESS_ES	FORMAL	\N	\N
e1d846d1-588a-48f6-a332-5859c50bd44b	en	Can I have the bill, please?	¿Me puede dar la cuenta, por favor?	kan ay hav the bil pliz	restaurant	BEGINNER	FOOD_EN	NEUTRAL	\N	\N
d6150fa3-27b3-4bcc-b02e-70116c065174	en	Where is the bathroom?	¿Dónde está el baño?	wer iz the BATH-room	general	BEGINNER	CONVERSATION_EN	NEUTRAL	\N	\N
349d3c88-5a93-46b8-aca5-78b5f55f9145	en	I do not understand. Can you repeat?	No entiendo. ¿Puede repetir?	ay do not un-der-STAND kan yu ri-PEET	general	BEGINNER	CONVERSATION_EN	NEUTRAL	\N	\N
0c023efe-8fc3-42fe-89da-3e967a2abf29	en	Nice to meet you.	Mucho gusto en conocerte.	nys tu meet yu	introductions	BEGINNER	CONVERSATION_EN	NEUTRAL	\N	\N
f7ea69de-1f72-4964-9caf-1f0a10fb82be	en	What time does the bank open?	¿A qué hora abre el banco?	wot tym duz the bank OH-pun	services	INTERMEDIATE	CONVERSATION_EN	NEUTRAL	\N	\N
32bfd028-def8-45ee-9de5-6ed70a2efce3	en	I would like to make a reservation.	Me gustaría hacer una reserva.	ay wud lyk tu mayk a re-zer-VAY-shun	hotel/restaurant	INTERMEDIATE	TRAVEL_EN	FORMAL	\N	\N
38a1858c-751a-4f34-a63b-b7bd12020cd0	en	Could I speak with the manager?	¿Podría hablar con el gerente?	kud ay speek with the MA-ni-jer	business	INTERMEDIATE	BUSINESS_EN	FORMAL	\N	\N
\.


--
-- Data for Name: placement_answers; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.placement_answers (id, test_id, question_index, question_type, user_answer, correct_answer, is_correct) FROM stdin;
a00048b8-3a67-4b14-b2a8-327329823457	f4e8ee57-bf8d-48e6-8593-3bc00c0c0805	1	IMAGE_PICK	agua	agua	t
43f8adce-adfe-4da9-a901-43800ad1e947	f4e8ee57-bf8d-48e6-8593-3bc00c0c0805	2	IMAGE_PICK	pan	pan	t
ce60b348-5876-45fe-b66e-30a2c4be5cec	f4e8ee57-bf8d-48e6-8593-3bc00c0c0805	3	GRAMMAR_FILL	soy	soy	t
deca3031-2372-4b2a-83f5-bebf07abc2cc	f4e8ee57-bf8d-48e6-8593-3bc00c0c0805	4	GRAMMAR_FILL	vive	vive	t
bf5210d3-2389-4245-a5ab-86a23437db52	f4e8ee57-bf8d-48e6-8593-3bc00c0c0805	5	READING	café con leche	café con leche	t
93d33571-7496-4adc-8631-ad800cd7a8ab	f4e8ee57-bf8d-48e6-8593-3bc00c0c0805	6	READING	cerca de la estación	cerca de la estación	t
86cf7bf7-56a0-40a8-ab19-976e83ee8815	f4e8ee57-bf8d-48e6-8593-3bc00c0c0805	7	AUDIO_TAP	Buenos días ¿cómo estás?	Buenos días, ¿cómo estás?	t
7dffaac8-f9b1-4423-ad10-b7bb11a3c437	f4e8ee57-bf8d-48e6-8593-3bc00c0c0805	8	AUDIO_TAP	Me llamo Carlos, mucho gusto.	Me llamo Carlos, mucho gusto.	t
f23fee75-1881-4e78-b788-fce64089b3e7	f4e8ee57-bf8d-48e6-8593-3bc00c0c0805	9	FREE_WRITE	l	Buenos días, quisiera un café, por favor.	f
0a3b9eee-1175-4683-8315-cc30989770d6	f4e8ee57-bf8d-48e6-8593-3bc00c0c0805	10	FREE_WRITE	l	Perdón, ¿dónde está la farmacia más cercana?	f
\.


--
-- Data for Name: placement_questions; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.placement_questions (id, language, question_index, question_type, prompt, options, correct_answer, difficulty, skill_tested, next_question_if_correct, next_question_if_wrong, points_value, time_limit_seconds) FROM stdin;
704dd15f-ab4c-4523-96c2-301308469d8b	es	1	IMAGE_PICK	Which one of these means "water"?	{"choices": [{"label": "☕ café", "value": "café", "image_keyword": "coffee_cup"}, {"label": "💧 agua", "value": "agua", "image_keyword": "water_bottle"}, {"label": "🍎 manzana", "value": "manzana", "image_keyword": "apple"}]}	agua	BEGINNER	VOCABULARY	\N	\N	1	30
15f5e42a-c9e2-47d6-a125-36a3e14e6299	es	2	IMAGE_PICK	Which one of these means "bread"?	{"choices": [{"label": "🥚 huevo", "value": "huevo", "image_keyword": "egg"}, {"label": "🧀 queso", "value": "queso", "image_keyword": "cheese"}, {"label": "🍞 pan", "value": "pan", "image_keyword": "bread"}]}	pan	BEGINNER	VOCABULARY	\N	\N	1	30
9427f93f-ba8f-45a9-9e70-272a36c1fc22	es	3	GRAMMAR_FILL	Complete: "Yo ___ un estudiante."	{"choices": ["soy", "es", "somos", "eres"]}	soy	BEGINNER	GRAMMAR	\N	\N	1	30
3809ca1c-ebdf-4cfe-8bfa-bad6533165fc	es	4	GRAMMAR_FILL	Complete: "Ella ___ en Madrid."	{"choices": ["vives", "vivo", "vive", "vivimos"]}	vive	BEGINNER	GRAMMAR	\N	\N	1	30
daf664c3-4731-4c26-8697-17b173296bc4	es	5	READING	Read: "Ana va al café. Pide un café con leche y una tostada. El desayuno cuesta cinco euros." — What did Ana order to drink?	{"choices": [{"label": "Coffee with milk", "value": "café con leche"}, {"label": "Water", "value": "agua"}, {"label": "Orange juice", "value": "jugo de naranja"}, {"label": "Tea", "value": "té"}], "passage": "Ana va al café. Pide un café con leche y una tostada. El desayuno cuesta cinco euros."}	café con leche	INTERMEDIATE	READING	\N	\N	1	30
a7c63535-06ce-40f4-98ff-4792d77dd9ef	es	6	READING	Read: "El hotel está cerca de la estación de tren. Hay una farmacia al lado. El aeropuerto queda lejos, a veinte minutos en taxi." — Where is the hotel?	{"choices": [{"label": "Near the station", "value": "cerca de la estación"}, {"label": "Near the airport", "value": "cerca del aeropuerto"}, {"label": "Next to the pharmacy", "value": "al lado de la farmacia"}, {"label": "Far from everything", "value": "lejos de todo"}], "passage": "El hotel está cerca de la estación de tren. Hay una farmacia al lado. El aeropuerto queda lejos, a veinte minutos en taxi."}	cerca de la estación	INTERMEDIATE	READING	\N	\N	1	30
3883f080-b962-4d8c-aebb-adc7eb417b19	es	7	AUDIO_TAP	Tap the words you hear in the correct order.	{"word_bank": ["Buenos", "días", "¿cómo", "estás?", "noches", "mal", "hola"], "audio_text": "Buenos días, ¿cómo estás?"}	Buenos días, ¿cómo estás?	INTERMEDIATE	LISTENING	\N	\N	1	30
ee743ff7-9002-4a1c-a634-71f0d6167e82	es	8	AUDIO_TAP	Tap the words you hear in the correct order.	{"word_bank": ["Me", "llamo", "Carlos,", "mucho", "gusto.", "soy", "llamas", "poco"], "audio_text": "Me llamo Carlos, mucho gusto."}	Me llamo Carlos, mucho gusto.	INTERMEDIATE	LISTENING	\N	\N	1	30
d0bfcdd1-607e-4433-a1ca-6b72b95ea353	es	9	FREE_WRITE	Translate to Spanish: "Good morning, I would like a coffee, please."	\N	Buenos días, quisiera un café, por favor.	UPPER_INTERMEDIATE	WRITING	\N	\N	1	30
1ae38c75-227c-4733-8bb2-9de26b453322	es	10	FREE_WRITE	Translate to Spanish: "Excuse me, where is the nearest pharmacy?"	\N	Perdón, ¿dónde está la farmacia más cercana?	UPPER_INTERMEDIATE	WRITING	\N	\N	1	30
7a3b19f7-049b-4233-8ab5-95dbfed43b44	en	1	IMAGE_PICK	Which one of these means "agua"?	{"choices": [{"label": "☕ coffee", "value": "coffee", "image_keyword": "coffee_cup"}, {"label": "💧 water", "value": "water", "image_keyword": "water_bottle"}, {"label": "🍎 apple", "value": "apple", "image_keyword": "apple"}]}	water	BEGINNER	VOCABULARY	\N	\N	1	30
01ccc158-8432-4966-9445-f49ce8809142	en	2	IMAGE_PICK	Which one of these means "pan"?	{"choices": [{"label": "🥚 egg", "value": "egg", "image_keyword": "egg"}, {"label": "🧀 cheese", "value": "cheese", "image_keyword": "cheese"}, {"label": "🍞 bread", "value": "bread", "image_keyword": "bread"}]}	bread	BEGINNER	VOCABULARY	\N	\N	1	30
919f67eb-ebe8-43ab-bd35-63fbd0684627	en	3	GRAMMAR_FILL	Complete: "I ___ a student."	{"choices": ["am", "is", "are", "be"]}	am	BEGINNER	GRAMMAR	\N	\N	1	30
a0222e50-0d1b-4805-b399-08c404a8d04c	en	4	GRAMMAR_FILL	Complete: "She ___ in New York."	{"choices": ["live", "lives", "living", "lived"]}	lives	BEGINNER	GRAMMAR	\N	\N	1	30
3244d446-9a26-422b-a485-816ca0c20876	en	5	READING	Read: "Ana goes to the café. She orders a coffee with milk and toast. Breakfast costs five dollars." — What did Ana order to drink?	{"choices": ["coffee with milk", "water", "orange juice", "tea"], "passage": "Ana goes to the café. She orders a coffee with milk and toast. Breakfast costs five dollars."}	coffee with milk	INTERMEDIATE	READING	\N	\N	1	30
4f4c8d79-6d30-42a2-932c-4f4b8663127f	en	6	READING	Read: "The hotel is close to the train station. There is a pharmacy next door. The airport is far, about twenty minutes by taxi." — Where is the hotel?	{"choices": ["near the station", "near the airport", "next to the pharmacy", "far from everything"], "passage": "The hotel is close to the train station. There is a pharmacy next door. The airport is far, about twenty minutes by taxi."}	near the station	INTERMEDIATE	READING	\N	\N	1	30
065d9bda-eb2f-434b-9dd3-f977c6ee19b3	en	7	AUDIO_TAP	Tap the words you hear in the correct order.	{"word_bank": ["Good", "morning,", "how", "are", "you?", "night", "bad", "hello"], "audio_text": "Good morning, how are you?"}	Good morning, how are you?	INTERMEDIATE	LISTENING	\N	\N	1	30
2906cd24-9ec0-4a39-b7cf-b60e95a34727	en	8	AUDIO_TAP	Tap the words you hear in the correct order.	{"word_bank": ["My", "name", "is", "Maria,", "nice", "to", "meet", "you.", "called", "am"], "audio_text": "My name is Maria, nice to meet you."}	My name is Maria, nice to meet you.	INTERMEDIATE	LISTENING	\N	\N	1	30
79be8e75-5658-4c35-8a97-ab0cd93044ab	en	9	FREE_WRITE	Translate to English: "Buenos días, quisiera un café, por favor."	\N	Good morning, I would like a coffee, please.	UPPER_INTERMEDIATE	WRITING	\N	\N	1	30
9065665b-f5ce-4ed3-9327-4db1ed952233	en	10	FREE_WRITE	Translate to English: "Perdón, ¿dónde está la farmacia más cercana?"	\N	Excuse me, where is the nearest pharmacy?	UPPER_INTERMEDIATE	WRITING	\N	\N	1	30
\.


--
-- Data for Name: placement_tests; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.placement_tests (id, user_id, language, score, total_questions, percentage_score, assigned_level, duration_seconds, was_completed, exit_reason, difficulty_path, recommended_unit_id, taken_at) FROM stdin;
f4e8ee57-bf8d-48e6-8593-3bc00c0c0805	cb7b7c8b-987d-4557-b395-d91c017b19ef	es	8	10	80.00	ADVANCED	79	t	\N	\N	\N	2026-03-24 03:48:24.473402
\.


--
-- Data for Name: quests; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.quests (id, code, title, icon, target_value, xp_reward) FROM stdin;
f04f9980-0282-466d-8c5a-5995460ae2ad	EARN_XP	Earn 10 XP	⚡	10	10
203893c6-713c-47a8-8e74-9353aee05df9	COMPLETE_LESSON	Complete 1 lesson	📚	1	15
c01d5030-6e48-49da-9756-9b5fd025856a	AI_SESSION	Complete 1 AI conversation	🗣️	1	20
164dca5c-6006-432f-b526-92991a208422	PERFECT_LESSON	Get a perfect score on a lesson	⭐	1	25
80f2fbea-0f7d-4446-bab4-696739d47880	STREAK_KEEP	Keep your streak alive	🔥	1	10
49737c1f-1491-4df5-ab15-99291561ece7	EARN_XP_30	Earn 30 XP in one day	⚡	30	25
2c32cb93-a5bb-4014-a3ee-31d2a6996f9d	COMPLETE_3_LESSONS	Complete 3 lessons	📚	3	30
95c15a18-e1ba-4d35-a210-60c6eeaa1d40	VOCABULARY_5	Answer 5 vocabulary exercises	📖	5	15
c17989b2-53d6-44e9-9f44-ed4c6c769587	GRAMMAR_5	Answer 5 grammar exercises	✏️	5	15
89ff3203-1f30-4f7f-bb1e-a5d2409ef994	LISTENING_5	Answer 5 listening exercises	🎧	5	15
\.


--
-- Data for Name: reading_passages; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.reading_passages (id, language, title, body, translation, level, topic_tag, word_count, estimated_minutes, vocabulary_ids, created_at) FROM stdin;
76ee2ffc-dfb9-4088-af6a-edaefcd8c8f3	es	En el café	Ana va al café todas las mañanas. Siempre pide un café con leche y una tostada con mantequilla. El café está cerca de su trabajo. El camarero se llama Carlos y ya conoce el pedido de Ana. "Lo de siempre, Ana?" dice Carlos. "Sí, gracias, Carlos," responde ella con una sonrisa.	Ana goes to the café every morning. She always orders a coffee with milk and buttered toast. The café is close to her workplace. The waiter's name is Carlos and he already knows Ana's order. "The usual, Ana?" says Carlos. "Yes, thank you, Carlos," she replies with a smile.	BEGINNER	FOOD_ES	72	2	\N	2026-03-14 18:27:35.68614
9549fb28-7364-4440-9aa8-611fbb656365	es	Un día en Madrid	Miguel vive en Madrid desde hace cinco años. Trabaja en una empresa de tecnología en el centro de la ciudad. Cada día toma el metro para ir al trabajo. Por la tarde, después del trabajo, le gusta pasear por el Parque del Retiro. Los fines de semana visita museos o sale a cenar con amigos. Miguel dice que Madrid es una ciudad llena de vida.	Miguel has lived in Madrid for five years. He works at a technology company in the city center. Every day he takes the metro to go to work. In the afternoon, after work, he likes to walk through Retiro Park. On weekends he visits museums or goes out to dinner with friends. Miguel says that Madrid is a city full of life.	INTERMEDIATE	CONVERSATION_ES	88	3	\N	2026-03-14 18:27:35.68614
47b38698-11dd-458b-870a-de79a8a47a41	en	At the coffee shop	Maria goes to the coffee shop every morning before work. She always orders a large coffee with milk and a blueberry muffin. The barista knows her name and starts making her coffee when he sees her walk in. "The usual, Maria?" he asks. "Yes, please," she says with a smile. She sits by the window and drinks her coffee while checking her phone.	María va a la cafetería todas las mañanas antes del trabajo. Siempre pide un café grande con leche y un muffin de arándanos.	BEGINNER	FOOD_EN	80	2	\N	2026-03-14 18:27:35.68614
bfd2b2d9-d25c-4bc5-be79-73077c398e4d	en	A job interview	David is preparing for a job interview at a marketing company. He researches the company online and practices answering common interview questions. On the day of the interview, he arrives ten minutes early and introduces himself to the receptionist. The interviewer asks him about his experience and why he wants the job. David answers clearly and confidently. At the end, he asks two questions about the company culture. A week later, he gets a call offering him the position.	David está preparando una entrevista de trabajo en una empresa de marketing.	INTERMEDIATE	BUSINESS_EN	95	3	\N	2026-03-14 18:27:35.68614
a1000001-0000-0000-0000-000000000001	es	Un día en el mercado	Cada sábado, la familia García va al mercado local. La madre compra frutas y verduras frescas. Los niños eligen los plátanos y las naranjas. El padre busca el pan y el queso. Después de comprar, toman un café en la plaza. El mercado cierra al mediodía.	Every Saturday, the García family goes to the local market. The mother buys fresh fruits and vegetables. The children choose the bananas and oranges. The father looks for bread and cheese. After shopping, they have a coffee in the square. The market closes at noon.	INTERMEDIATE	FOOD_ES	58	3	\N	2026-03-15 04:07:30.378639
a1000002-0000-0000-0000-000000000002	en	A day at the market	Every Saturday, the García family goes to the local market. The mother buys fresh fruits and vegetables. The children choose the bananas and oranges. The father looks for bread and cheese. After shopping, they have a coffee in the square. The market closes at noon.	Cada sábado, la familia García va al mercado local. La madre compra frutas y verduras frescas. Los niños eligen los plátanos y las naranjas. El padre busca el pan y el queso. Después de comprar, toman un café en la plaza. El mercado cierra al mediodía.	INTERMEDIATE	FOOD_EN	58	3	\N	2026-03-15 04:07:30.378639
\.


--
-- Data for Name: reading_questions; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.reading_questions (id, passage_id, question_text, question_type, choices, correct_answer, explanation, display_order) FROM stdin;
6bd0dcd8-a04e-4a4a-9c10-41ca19dca6d4	76ee2ffc-dfb9-4088-af6a-edaefcd8c8f3	What does Ana order every morning?	MULTIPLE_CHOICE	["Coffee with milk and toast", "Tea and a croissant", "Orange juice and eggs", "Water and bread"]	Coffee with milk and toast	The passage says: pide un café con leche y una tostada	1
c22077bd-6775-49fa-b6f4-3ecf63c5d90f	76ee2ffc-dfb9-4088-af6a-edaefcd8c8f3	Where is the café located?	MULTIPLE_CHOICE	["Far from her home", "Close to her workplace", "Next to the metro", "In the city center"]	Close to her workplace	El café está cerca de su trabajo = the café is close to her work	2
d3390bf2-877c-4d3e-8682-37a7104c681a	76ee2ffc-dfb9-4088-af6a-edaefcd8c8f3	What does Carlos say to Ana?	MULTIPLE_CHOICE	["Good morning Ana", "The usual Ana?", "What would you like?", "Nice to see you"]	The usual Ana?	Carlos says Lo de siempre, Ana? which means The usual, Ana?	3
b1000001-0000-0000-0000-000000000001	a1000001-0000-0000-0000-000000000001	¿Qué compra la madre?	MULTIPLE_CHOICE	[{"label": "Pan y queso", "value": "pan y queso"}, {"label": "Frutas y verduras", "value": "frutas y verduras"}, {"label": "Café", "value": "café"}]	frutas y verduras	La madre compra frutas y verduras frescas.	1
b1000001-0000-0000-0000-000000000002	a1000002-0000-0000-0000-000000000002	What does the mother buy?	MULTIPLE_CHOICE	[{"label": "Bread and cheese", "value": "bread and cheese"}, {"label": "Fruits and vegetables", "value": "fruits and vegetables"}, {"label": "Coffee", "value": "coffee"}]	fruits and vegetables	The mother buys fresh fruits and vegetables.	1
\.


--
-- Data for Name: review_sessions; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.review_sessions (id, user_id, language, session_type, status, words_due, rules_due, total_items, items_reviewed, items_correct, xp_awarded, created_at, completed_at) FROM stdin;
\.


--
-- Data for Name: sections; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.sections (id, title, language, level, display_order) FROM stdin;
a1111111-0000-0000-0000-000000000001	Section 1 – Foundations	es	BEGINNER	1
a1111111-0000-0000-0000-000000000002	Section 2 – Everyday Life	es	BEGINNER	2
a1111111-0000-0000-0000-000000000003	Section 3 – Getting Around	es	INTERMEDIATE	3
a1111111-0000-0000-0000-000000000004	Section 4 – Work & Professional	es	INTERMEDIATE	4
a1111111-0000-0000-0000-000000000005	Section 5 – Advanced Communication	es	UPPER_INTERMEDIATE	5
b2222222-0000-0000-0000-000000000001	Section 1 – Foundations	en	BEGINNER	1
b2222222-0000-0000-0000-000000000002	Section 2 – Everyday Life	en	BEGINNER	2
b2222222-0000-0000-0000-000000000003	Section 3 – Getting Around	en	INTERMEDIATE	3
b2222222-0000-0000-0000-000000000004	Section 4 – Work & Professional	en	INTERMEDIATE	4
b2222222-0000-0000-0000-000000000005	Section 5 – Advanced Communication	en	UPPER_INTERMEDIATE	5
\.


--
-- Data for Name: skill_breakdown_reports; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.skill_breakdown_reports (id, user_id, language, report_date, vocabulary_score, grammar_score, listening_score, writing_score, speaking_score, overall_score, weak_areas, strong_areas, recommended_focus, lessons_this_period, xp_this_period, generated_at) FROM stdin;
\.


--
-- Data for Name: speaking_attempts; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.speaking_attempts (id, user_id, exercise_id, target_phrase, transcribed_text, similarity_score, phoneme_errors, passed, audio_duration_ms, attempted_at) FROM stdin;
\.


--
-- Data for Name: streak_history; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.streak_history (id, user_id, streak_date, was_active) FROM stdin;
7d03328b-c101-4f33-ae10-4c9f56b1704e	cb7b7c8b-987d-4557-b395-d91c017b19ef	2026-03-24	t
\.


--
-- Data for Name: subscriptions; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.subscriptions (id, user_id, plan, status, started_at, expires_at, payment_reference, transaction_id, payment_gateway, payment_method, payment_status, trial_start_date, trial_end_date, auto_renew, cancellation_reason, last_payment_at, next_billing_date, amount_paid, currency, cancelled_at) FROM stdin;
\.


--
-- Data for Name: system_performance_log; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.system_performance_log (id, endpoint, method, response_ms, status_code, user_id, threshold_ms, exceeded_threshold, logged_at) FROM stdin;
\.


--
-- Data for Name: topics; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.topics (id, code, name, icon, description, language, display_order) FROM stdin;
d9289c75-1f89-448b-b888-cb4d33c88c8e	TRAVEL_ES	Travel & Tourism	✈️	Learn essential travel phrases, directions, and vocabulary for exploring Spanish-speaking countries.	es	1
f6e6f37b-329e-4577-bd46-f138383ddd86	BUSINESS_ES	Business & Professional	💼	Master professional vocabulary, email writing, and workplace conversations in Spanish.	es	2
c07c73d0-3737-4814-9411-ae9d4308915c	CONVERSATION_ES	Everyday Conversation	🗣️	Practice greetings, small talk, and common daily interactions in Spanish.	es	3
7f2c8a1f-1155-4962-adeb-bac8e79b1a45	GRAMMAR_ES	Grammar Foundations	📚	Build a strong foundation in Spanish grammar including verbs, tenses, and sentence structure.	es	4
c57fc01b-2cd9-457d-9967-aa2987cd161f	LISTENING_ES	Listening & Comprehension	🎧	Train your ear with authentic Spanish audio, accents, and listening exercises.	es	5
4a2a7228-42f6-4be9-848d-c58b5eb15e73	WRITING_ES	Writing Skills	✍️	Develop Spanish writing skills from simple sentences to paragraphs and emails.	es	6
9b525e9d-286d-46de-82c0-3a0d0f881b83	HEALTH_ES	Health & Emergencies	🏥	Critical vocabulary for medical situations, emergencies, and health-related conversations.	es	7
2539a7f8-44e1-4262-90bb-d61483084254	FOOD_ES	Food & Culture	🍽️	Explore Spanish cuisine, restaurant vocabulary, and cultural dining experiences.	es	8
67fbc734-ca4f-4c39-9365-6c16e0ad6c8b	TRAVEL_EN	Travel & Tourism	✈️	Learn essential travel phrases, airport vocabulary, and directions in English.	en	1
ca9a97db-1e6d-41f5-a5ae-94917ac543ed	BUSINESS_EN	Business & Professional	💼	Master professional English for meetings, emails, and workplace communication.	en	2
6876b572-a971-46eb-b362-28a4e36c41f1	CONVERSATION_EN	Everyday Conversation	🗣️	Practice greetings, small talk, and common daily interactions in English.	en	3
95eff260-879b-4d51-985b-f728fb2aa8ba	GRAMMAR_EN	Grammar Foundations	📚	Build a strong foundation in English grammar, tenses, and sentence structure.	en	4
870e3835-bec8-4d74-8b64-de0bf11094cf	LISTENING_EN	Listening & Comprehension	🎧	Improve your English listening skills with conversations and audio exercises.	en	5
19a3d0a0-085f-48d0-a651-62ba8f25816b	WRITING_EN	Writing Skills	✍️	Develop English writing from simple sentences to professional communication.	en	6
6fe3ad82-0482-4368-9dd6-0e6ccf2e210a	HEALTH_EN	Health & Emergencies	🏥	Essential English vocabulary for medical situations and emergencies.	en	7
5e0eb1b7-d967-4b8a-8641-52233092090c	FOOD_EN	Food & Culture	🍽️	Learn English vocabulary for restaurants, food, and American culture.	en	8
\.


--
-- Data for Name: units; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.units (id, section_id, title, description, topic_code, display_order) FROM stdin;
c1111111-0000-0000-0000-000000000001	a1111111-0000-0000-0000-000000000001	Order food and drinks	Learn to order food and drinks at restaurants and cafés in Spanish.	FOOD_ES	1
c1111111-0000-0000-0000-000000000002	a1111111-0000-0000-0000-000000000001	Greetings and introductions	Master Spanish greetings, introductions, and basic social interactions.	CONVERSATION_ES	2
c1111111-0000-0000-0000-000000000003	a1111111-0000-0000-0000-000000000001	Describe people	Learn adjectives and vocabulary to describe people and their characteristics.	CONVERSATION_ES	3
c1111111-0000-0000-0000-000000000004	a1111111-0000-0000-0000-000000000001	Numbers and time	Learn Spanish numbers, time, and how to make appointments.	GRAMMAR_ES	4
c1111111-0000-0000-0000-000000000005	a1111111-0000-0000-0000-000000000002	At the market	Shop at markets and stores using Spanish vocabulary for prices and items.	FOOD_ES	1
c1111111-0000-0000-0000-000000000006	a1111111-0000-0000-0000-000000000002	Family and home	Talk about your family, home, and daily routines in Spanish.	CONVERSATION_ES	2
c1111111-0000-0000-0000-000000000007	a1111111-0000-0000-0000-000000000002	Daily routines	Describe your daily schedule and activities in Spanish.	CONVERSATION_ES	3
c1111111-0000-0000-0000-000000000008	a1111111-0000-0000-0000-000000000002	Weather and seasons	Talk about weather, seasons, and climate in Spanish.	CONVERSATION_ES	4
c1111111-0000-0000-0000-000000000009	a1111111-0000-0000-0000-000000000003	Navigate the city	Ask for and give directions in Spanish-speaking cities.	TRAVEL_ES	1
c1111111-0000-0000-0000-000000000010	a1111111-0000-0000-0000-000000000003	At the airport	Handle airport situations: check-in, customs, and finding your way.	TRAVEL_ES	2
c1111111-0000-0000-0000-000000000011	a1111111-0000-0000-0000-000000000003	Hotels and accommodation	Book and navigate hotels and accommodation in Spanish.	TRAVEL_ES	3
c1111111-0000-0000-0000-000000000012	a1111111-0000-0000-0000-000000000003	Transportation	Use public transportation and taxis in Spanish-speaking countries.	TRAVEL_ES	4
c1111111-0000-0000-0000-000000000013	a1111111-0000-0000-0000-000000000004	Business introductions	Introduce yourself professionally and network in Spanish.	BUSINESS_ES	1
c1111111-0000-0000-0000-000000000014	a1111111-0000-0000-0000-000000000004	Meetings and presentations	Participate in meetings and give presentations in Spanish.	BUSINESS_ES	2
c1111111-0000-0000-0000-000000000015	a1111111-0000-0000-0000-000000000004	Emails and writing	Write professional emails and documents in Spanish.	WRITING_ES	3
c1111111-0000-0000-0000-000000000016	a1111111-0000-0000-0000-000000000004	Health and emergencies	Handle health situations and emergencies in Spanish.	HEALTH_ES	4
d2222222-0000-0000-0000-000000000001	b2222222-0000-0000-0000-000000000001	Order food and drinks	Learn to order food and drinks at restaurants and cafés in English.	FOOD_EN	1
d2222222-0000-0000-0000-000000000002	b2222222-0000-0000-0000-000000000001	Greetings and introductions	Master English greetings, introductions, and basic social interactions.	CONVERSATION_EN	2
d2222222-0000-0000-0000-000000000003	b2222222-0000-0000-0000-000000000001	Describe people	Learn adjectives and vocabulary to describe people in English.	CONVERSATION_EN	3
d2222222-0000-0000-0000-000000000004	b2222222-0000-0000-0000-000000000001	Numbers and time	Learn English numbers, time, and how to make appointments.	GRAMMAR_EN	4
d2222222-0000-0000-0000-000000000005	b2222222-0000-0000-0000-000000000002	At the market	Shop at stores using English vocabulary for prices and items.	FOOD_EN	1
d2222222-0000-0000-0000-000000000006	b2222222-0000-0000-0000-000000000002	Family and home	Talk about your family, home, and daily routines in English.	CONVERSATION_EN	2
d2222222-0000-0000-0000-000000000007	b2222222-0000-0000-0000-000000000002	Daily routines	Describe your daily schedule and activities in English.	CONVERSATION_EN	3
d2222222-0000-0000-0000-000000000008	b2222222-0000-0000-0000-000000000002	Weather and seasons	Talk about weather, seasons, and climate in English.	CONVERSATION_EN	4
d2222222-0000-0000-0000-000000000009	b2222222-0000-0000-0000-000000000003	Navigate the city	Ask for and give directions in English.	TRAVEL_EN	1
d2222222-0000-0000-0000-000000000010	b2222222-0000-0000-0000-000000000003	At the airport	Handle airport situations in English.	TRAVEL_EN	2
d2222222-0000-0000-0000-000000000011	b2222222-0000-0000-0000-000000000003	Hotels and accommodation	Book and navigate hotels in English.	TRAVEL_EN	3
d2222222-0000-0000-0000-000000000012	b2222222-0000-0000-0000-000000000003	Transportation	Use public transportation in English.	TRAVEL_EN	4
d2222222-0000-0000-0000-000000000013	b2222222-0000-0000-0000-000000000004	Business introductions	Introduce yourself professionally in English.	BUSINESS_EN	1
d2222222-0000-0000-0000-000000000014	b2222222-0000-0000-0000-000000000004	Meetings and presentations	Participate in meetings and give presentations in English.	BUSINESS_EN	2
d2222222-0000-0000-0000-000000000015	b2222222-0000-0000-0000-000000000004	Emails and writing	Write professional emails in English.	WRITING_EN	3
d2222222-0000-0000-0000-000000000016	b2222222-0000-0000-0000-000000000004	Health and emergencies	Handle health situations and emergencies in English.	HEALTH_EN	4
c1111111-0000-0000-0000-000000000017	a1111111-0000-0000-0000-000000000005	Debates and opinions	Express and defend opinions, agree and disagree politely in Spanish.	CONVERSATION_ES	1
c1111111-0000-0000-0000-000000000018	a1111111-0000-0000-0000-000000000005	News and media	Discuss news, media, and current events in Spanish.	CONVERSATION_ES	2
c1111111-0000-0000-0000-000000000019	a1111111-0000-0000-0000-000000000005	Negotiations and persuasion	Professional negotiation and persuasion in Spanish.	BUSINESS_ES	3
c1111111-0000-0000-0000-000000000020	a1111111-0000-0000-0000-000000000005	Academic and formal writing	Write essays, reports, and formal texts in Spanish.	WRITING_ES	4
d2222222-0000-0000-0000-000000000017	b2222222-0000-0000-0000-000000000005	Debates and opinions	Express and defend opinions in English.	CONVERSATION_EN	1
d2222222-0000-0000-0000-000000000018	b2222222-0000-0000-0000-000000000005	News and media	Discuss news and current events in English.	CONVERSATION_EN	2
d2222222-0000-0000-0000-000000000019	b2222222-0000-0000-0000-000000000005	Negotiations and persuasion	Professional negotiation in English.	BUSINESS_EN	3
d2222222-0000-0000-0000-000000000020	b2222222-0000-0000-0000-000000000005	Academic and formal writing	Write essays and formal texts in English.	WRITING_EN	4
\.


--
-- Data for Name: user_achievements; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.user_achievements (id, user_id, achievement_id, current_level, progress, unlocked_at) FROM stdin;
\.


--
-- Data for Name: user_daily_quests; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.user_daily_quests (id, user_id, quest_id, quest_date, current_value, is_completed, completed_at) FROM stdin;
c7b66a0a-c1ca-49ca-a635-7dfdf23053b9	cb7b7c8b-987d-4557-b395-d91c017b19ef	f04f9980-0282-466d-8c5a-5995460ae2ad	2026-03-23	0	f	\N
19c2060c-6f52-4d5e-a7e5-05cf5c70daa5	cb7b7c8b-987d-4557-b395-d91c017b19ef	203893c6-713c-47a8-8e74-9353aee05df9	2026-03-23	0	f	\N
488da5d3-6211-449d-aba0-dc106e6fceb5	cb7b7c8b-987d-4557-b395-d91c017b19ef	c01d5030-6e48-49da-9756-9b5fd025856a	2026-03-23	0	f	\N
9c9362df-1cf2-482b-b86c-1d3d7774067b	cb7b7c8b-987d-4557-b395-d91c017b19ef	164dca5c-6006-432f-b526-92991a208422	2026-03-23	0	f	\N
8f840546-e3ee-4b51-b5d9-5aeac07af936	cb7b7c8b-987d-4557-b395-d91c017b19ef	80f2fbea-0f7d-4446-bab4-696739d47880	2026-03-23	0	f	\N
dbfc9df7-8ffe-4963-8b65-d405d5eeefe4	cb7b7c8b-987d-4557-b395-d91c017b19ef	49737c1f-1491-4df5-ab15-99291561ece7	2026-03-23	0	f	\N
84892209-136e-4ced-af11-cb67fa219e3b	cb7b7c8b-987d-4557-b395-d91c017b19ef	2c32cb93-a5bb-4014-a3ee-31d2a6996f9d	2026-03-23	0	f	\N
a5a42216-4c0c-4792-9ee0-b4e37d2b0823	cb7b7c8b-987d-4557-b395-d91c017b19ef	95c15a18-e1ba-4d35-a210-60c6eeaa1d40	2026-03-23	0	f	\N
798917ce-2950-459b-acb1-a57684a366d7	cb7b7c8b-987d-4557-b395-d91c017b19ef	c17989b2-53d6-44e9-9f44-ed4c6c769587	2026-03-23	0	f	\N
99e32607-fe7d-43c0-a31b-77b5b25729bb	cb7b7c8b-987d-4557-b395-d91c017b19ef	89ff3203-1f30-4f7f-bb1e-a5d2409ef994	2026-03-23	0	f	\N
295cc41d-b9bb-4fbc-a530-e71cb95b8d9e	cb7b7c8b-987d-4557-b395-d91c017b19ef	c01d5030-6e48-49da-9756-9b5fd025856a	2026-03-24	0	f	\N
b1c31fc7-d2e4-4e88-9fb0-84aad0e7ed6b	cb7b7c8b-987d-4557-b395-d91c017b19ef	164dca5c-6006-432f-b526-92991a208422	2026-03-24	0	f	\N
bc4a25f0-9110-468e-98bf-a4650e0da197	cb7b7c8b-987d-4557-b395-d91c017b19ef	49737c1f-1491-4df5-ab15-99291561ece7	2026-03-24	0	f	\N
7c1324ce-1270-4812-b32f-ed3f8058d589	cb7b7c8b-987d-4557-b395-d91c017b19ef	95c15a18-e1ba-4d35-a210-60c6eeaa1d40	2026-03-24	0	f	\N
f3f2f505-be63-4972-b0a0-4c3cc58a1aa7	cb7b7c8b-987d-4557-b395-d91c017b19ef	c17989b2-53d6-44e9-9f44-ed4c6c769587	2026-03-24	0	f	\N
096b1772-a684-43b7-bc6b-0d5f8c69c6a6	cb7b7c8b-987d-4557-b395-d91c017b19ef	89ff3203-1f30-4f7f-bb1e-a5d2409ef994	2026-03-24	0	f	\N
74e4dcbd-c0b3-480f-815d-1d29f4e934d2	cb7b7c8b-987d-4557-b395-d91c017b19ef	203893c6-713c-47a8-8e74-9353aee05df9	2026-03-24	1	t	2026-03-24 13:27:31.337504
c4cbc106-f2bd-4911-a9d7-89cf5adfa0dc	cb7b7c8b-987d-4557-b395-d91c017b19ef	f04f9980-0282-466d-8c5a-5995460ae2ad	2026-03-24	10	t	2026-03-24 13:27:31.342008
136294ca-2743-4d49-b23a-b97c50e725c4	cb7b7c8b-987d-4557-b395-d91c017b19ef	2c32cb93-a5bb-4014-a3ee-31d2a6996f9d	2026-03-24	1	f	\N
baea908e-f4d3-4d67-ac0b-c114af9afb2d	cb7b7c8b-987d-4557-b395-d91c017b19ef	80f2fbea-0f7d-4446-bab4-696739d47880	2026-03-24	1	t	2026-03-24 13:27:31.344573
\.


--
-- Data for Name: user_exercise_attempts; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.user_exercise_attempts (id, user_id, exercise_id, user_answer, is_correct, attempted_at) FROM stdin;
28396890-e501-434f-b4d2-3f46cc8b55fe	cb7b7c8b-987d-4557-b395-d91c017b19ef	ea9bdbef-f2a3-4186-9f7f-c981dd302f79	Hasta Manana	f	2026-03-24 13:28:10.144856
dbb87924-e928-44b7-9577-9b1c21390471	cb7b7c8b-987d-4557-b395-d91c017b19ef	ea9bdbef-f2a3-4186-9f7f-c981dd302f79	Hasta Manana	f	2026-03-24 13:28:10.453548
2ce38f59-2be7-44ba-9716-6a25f6c4e4f1	cb7b7c8b-987d-4557-b395-d91c017b19ef	ea9bdbef-f2a3-4186-9f7f-c981dd302f79	Hasta manana	f	2026-03-24 13:28:18.378506
fc76622d-8780-4668-944b-16d2c2f16e3e	cb7b7c8b-987d-4557-b395-d91c017b19ef	ea9bdbef-f2a3-4186-9f7f-c981dd302f79	Hasta manana	f	2026-03-24 13:28:18.986596
d5b3e0d6-df30-407e-89e3-9fd66317c2ba	cb7b7c8b-987d-4557-b395-d91c017b19ef	ea9bdbef-f2a3-4186-9f7f-c981dd302f79	Hasta mañana	f	2026-03-24 13:28:27.10506
9b0b74f2-5f3c-4521-9c82-e020cf40ff26	cb7b7c8b-987d-4557-b395-d91c017b19ef	ea9bdbef-f2a3-4186-9f7f-c981dd302f79	Te veo mañana	f	2026-03-24 13:28:36.814896
bfc7b94b-1b8e-418e-8bdc-74eaaf90bcc6	cb7b7c8b-987d-4557-b395-d91c017b19ef	ea9bdbef-f2a3-4186-9f7f-c981dd302f79	nos vemos mañana	f	2026-03-24 13:28:43.107343
\.


--
-- Data for Name: user_learning_preferences; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.user_learning_preferences (user_id, daily_goal_xp, session_length_minutes, preferred_exercise_types, weak_skills_focus, spaced_repetition_on, show_cultural_notes, show_phonetic_guides, accent_preference, reminder_time, updated_at) FROM stdin;
cb7b7c8b-987d-4557-b395-d91c017b19ef	10	5	{IMAGE_PICK,WORD_BANK,FILL_BLANK,AUDIO_TAP,FREE_WRITE}	t	t	t	t	LATIN_AMERICAN	\N	2026-03-14 18:27:35.687442
\.


--
-- Data for Name: user_lesson_progress; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.user_lesson_progress (id, user_id, lesson_id, status, exercises_correct, exercises_total, score_percentage, xp_earned, time_spent_seconds, attempts, milestone_reached, next_recommended_lesson_id, completed_at, started_at) FROM stdin;
e5103232-bd19-4f6c-a65e-b4b477779e2a	cb7b7c8b-987d-4557-b395-d91c017b19ef	e1000002-0000-0000-0000-000000000001	COMPLETED	0	1	0.00	10	60	1	f	\N	2026-03-24 13:27:31.314172	2026-03-24 13:27:31.314175
\.


--
-- Data for Name: user_mistake_patterns; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.user_mistake_patterns (id, user_id, language, mistake_type, grammar_rule_id, vocabulary_id, mistake_count, resolved_count, last_made_at, last_example_wrong, last_example_correct, scheduled_review) FROM stdin;
\.


--
-- Data for Name: user_skills; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.user_skills (id, user_id, language, vocabulary_score, grammar_score, listening_score, writing_score, speaking_score, pronunciation_score, overall_score, lessons_completed, exercises_attempted, exercises_correct, updated_at) FROM stdin;
7b5b3587-d76d-4707-9638-59d08a3e544c	cb7b7c8b-987d-4557-b395-d91c017b19ef	es	\N	\N	\N	\N	\N	\N	\N	1	1	0	2026-03-24 13:27:31.321247
\.


--
-- Data for Name: user_topics; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.user_topics (user_id, topic_id, selected_at) FROM stdin;
cb7b7c8b-987d-4557-b395-d91c017b19ef	c07c73d0-3737-4814-9411-ae9d4308915c	2026-03-24 13:18:32.352158
cb7b7c8b-987d-4557-b395-d91c017b19ef	7f2c8a1f-1155-4962-adeb-bac8e79b1a45	2026-03-24 13:18:32.352158
\.


--
-- Data for Name: user_word_memory; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.user_word_memory (id, user_id, vocabulary_id, times_seen, times_correct, times_incorrect, last_seen_at, next_review_at, ease_factor, interval_days, memory_strength, last_answer, last_was_correct, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.users (id, full_name, email, username, password_hash, oauth_provider, oauth_id, native_language, learning_language, assigned_level, role, is_verified, account_status, email_verification_token, email_verified_at, password_reset_token, password_reset_expires, is_premium, premium_expires_at, xp, streak_count, last_active_date, last_login_at, login_count, learning_goals, profile_picture_url, onboarding_completed, is_active, joined_at, updated_at) FROM stdin;
00e2433e-b2df-4d86-b0e7-75fff3ab48d3	Test User	test@example.com	testuser	$2a$10$VnFHxQBxHtOQY9jnJOWOhuqOLHO87GCgXQF3UDjF67dqyLKWXy8ky	\N	\N	en	es	\N	LEARNER	f	PENDING_VERIFICATION	\N	\N	\N	\N	f	\N	0	0	\N	2026-03-14 23:07:12.239684	3	\N	\N	f	t	2026-03-14 22:47:40.168698	2026-03-14 23:07:12.239692
cb7b7c8b-987d-4557-b395-d91c017b19ef	Fluentia Admin	admin@fluentia.com	fluentia_admin	$2a$10$1vRUwI0srXp9DZgsygzOXurhKPeQG5AXqWgSFhOvMHKpFT.SnIWfu	\N	\N	en	es	ADVANCED	ADMIN	t	PENDING_VERIFICATION	\N	\N	\N	\N	t	\N	45	1	2026-03-24	2026-03-30 16:07:30.763672	9	\N	\N	t	t	2026-03-14 18:27:35.680554	2026-03-30 16:07:30.763675
f69706a5-5e0e-4a2a-9a70-23dfc175499c	Rodrigo	yoyouruguayo@hotmail.com	rod9	$2a$10$.JyI7hBIDVyBokaqUmBN4eGgxxTKO65Ie77b5cwnmDZa4ZwhGgbVO	\N	\N	en	es	\N	LEARNER	t	ACTIVE	\N	2026-03-30 16:53:35.490289	\N	\N	f	\N	0	0	\N	2026-03-30 16:53:46.522547	1	\N	\N	t	t	2026-03-30 16:52:39.497905	2026-03-30 16:53:54.24474
\.


--
-- Data for Name: vocabulary; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.vocabulary (id, word, language, translation, transliteration, part_of_speech, topic_tag, level, example_sentence, example_translation, audio_text, image_keyword, gender, plural_form, conjugation_group, audio_phonetic, phonetic_guide, frequency_rank, accent, regional_variants, tags, is_irregular, notes, created_at) FROM stdin;
373ec324-4c74-480a-859a-4cab1bf941ce	agua	es	water	\N	noun	FOOD_ES	BEGINNER	Quiero agua, por favor.	I want water, please.	agua	water_bottle	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
68be6e3f-02c0-443f-acd4-7beaf5db7235	leche	es	milk	\N	noun	FOOD_ES	BEGINNER	Me gusta la leche fría.	I like cold milk.	leche	milk	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
89f39e10-367a-488e-9d47-2eec59027786	café	es	coffee	\N	noun	FOOD_ES	BEGINNER	El café está caliente.	The coffee is hot.	café	coffee_cup	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
8baee7b2-3afc-4e7d-a61e-ad0fbb00f187	pan	es	bread	\N	noun	FOOD_ES	BEGINNER	El pan está fresco.	The bread is fresh.	pan	bread	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
cacf0fbc-4fcc-4af2-b3f3-a9e5b719df8f	arroz	es	rice	\N	noun	FOOD_ES	BEGINNER	El arroz está listo.	The rice is ready.	arroz	rice_bowl	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
7274a5ba-49d9-4939-b073-2cc6e722a363	pollo	es	chicken	\N	noun	FOOD_ES	BEGINNER	El pollo está delicioso.	The chicken is delicious.	pollo	chicken	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
b34fc942-a428-44b5-8b87-98bec50fb9f2	carne	es	meat/beef	\N	noun	FOOD_ES	BEGINNER	Me gusta la carne asada.	I like grilled meat.	carne	meat	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
64af8df3-3d93-4410-82a8-315ce1790cd0	ensalada	es	salad	\N	noun	FOOD_ES	BEGINNER	La ensalada está fresca.	The salad is fresh.	ensalada	salad	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
1d43709d-0704-4e6f-9907-e17fb51cee60	sopa	es	soup	\N	noun	FOOD_ES	BEGINNER	La sopa está caliente.	The soup is hot.	sopa	soup	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
d29a4384-b091-49e3-87b4-9b5809d4c95e	fruta	es	fruit	\N	noun	FOOD_ES	BEGINNER	La fruta es saludable.	The fruit is healthy.	fruta	fruit	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
7635e185-8a82-4547-9ce7-e3e6b4efbdd3	manzana	es	apple	\N	noun	FOOD_ES	BEGINNER	La manzana es roja.	The apple is red.	manzana	apple	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
1955ed54-5da9-4a79-9e0f-46683186871e	naranja	es	orange	\N	noun	FOOD_ES	BEGINNER	La naranja está dulce.	The orange is sweet.	naranja	orange	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
19046ee8-3966-4d08-b7f7-70812c1a84f5	huevo	es	egg	\N	noun	FOOD_ES	BEGINNER	El huevo está cocido.	The egg is cooked.	huevo	egg	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
f53108f4-c15e-4166-95c7-2e4c73576e5c	queso	es	cheese	\N	noun	FOOD_ES	BEGINNER	El queso es amarillo.	The cheese is yellow.	queso	cheese	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
0a2bcc63-2d6d-4a70-a453-4c54558c030d	jugo	es	juice	\N	noun	FOOD_ES	BEGINNER	El jugo de naranja es rico.	The orange juice is delicious.	jugo	juice	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
01eb10f2-cc80-4b40-b185-ad18abdd3cc3	té	es	tea	\N	noun	FOOD_ES	BEGINNER	El té verde es saludable.	Green tea is healthy.	té	tea_cup	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
68d1eaac-4910-4501-a8af-93906420f928	cerveza	es	beer	\N	noun	FOOD_ES	BEGINNER	Una cerveza fría, por favor.	A cold beer, please.	cerveza	beer	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
9c41bbff-784b-4868-80cd-40180b02654e	vino	es	wine	\N	noun	FOOD_ES	BEGINNER	El vino tinto es delicioso.	The red wine is delicious.	vino	wine	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
774a5d7e-a671-4296-8287-b99f0c780e14	postre	es	dessert	\N	noun	FOOD_ES	BEGINNER	Quiero el postre, por favor.	I want dessert, please.	postre	dessert	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
254fefe5-ef1f-44d9-800f-8ef9b69b85fe	helado	es	ice cream	\N	noun	FOOD_ES	BEGINNER	El helado de chocolate es rico.	Chocolate ice cream is delicious.	helado	ice_cream	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
29029ca4-7979-4489-9e99-2cf682ae98af	hola	es	hello/hi	\N	interjection	CONVERSATION_ES	BEGINNER	Hola, ¿cómo estás?	Hello, how are you?	hola	greeting	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
ae69e806-9df5-4d0b-8b6e-7ad9276945ab	adiós	es	goodbye	\N	interjection	CONVERSATION_ES	BEGINNER	Adiós, hasta luego.	Goodbye, see you later.	adiós	wave	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
5628d973-54ce-4fec-bf15-eff382e2ee8e	buenos días	es	good morning	\N	phrase	CONVERSATION_ES	BEGINNER	Buenos días, señor García.	Good morning, Mr. García.	buenos días	morning	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
90503f4c-c3ae-4f83-a2fd-daafe8a993ff	buenas tardes	es	good afternoon	\N	phrase	CONVERSATION_ES	BEGINNER	Buenas tardes, ¿cómo le va?	Good afternoon, how are you doing?	buenas tardes	afternoon	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
4637a44c-eb47-4504-9674-2c2ca1f2bf1f	buenas noches	es	good night	\N	phrase	CONVERSATION_ES	BEGINNER	Buenas noches, que descanse.	Good night, rest well.	buenas noches	night	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
848d576c-1e80-4757-91c4-f530918f8647	gracias	es	thank you	\N	interjection	CONVERSATION_ES	BEGINNER	Muchas gracias por tu ayuda.	Thank you very much for your help.	gracias	thanks	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
4a823d82-2ecc-4dfd-a63b-9b291bcdf80d	de nada	es	you're welcome	\N	phrase	CONVERSATION_ES	BEGINNER	De nada, con mucho gusto.	You're welcome, with pleasure.	de nada	smile	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
bfa703d3-15ca-4391-ad24-75468e2cbc37	por favor	es	please	\N	adverb	CONVERSATION_ES	BEGINNER	Agua, por favor.	Water, please.	por favor	polite	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
6aaa3dec-e38f-493f-9e31-140fa6664ade	sí	es	yes	\N	adverb	CONVERSATION_ES	BEGINNER	Sí, estoy listo.	Yes, I am ready.	sí	yes	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
13a0dd51-58a9-4d3f-a521-d474396dc7b7	no	es	no	\N	adverb	CONVERSATION_ES	BEGINNER	No, gracias.	No, thank you.	no	no	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
ede6d5f4-2772-4b6d-9090-c46d9cc72a90	perdón	es	excuse me/sorry	\N	interjection	CONVERSATION_ES	BEGINNER	Perdón, ¿puede repetir?	Excuse me, can you repeat?	perdón	sorry	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
c65e818f-268e-48b6-bf9f-91b9e7d51481	me llamo	es	my name is	\N	phrase	CONVERSATION_ES	BEGINNER	Me llamo Carlos.	My name is Carlos.	me llamo	introduction	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
d79b1305-d673-4586-a9c6-1f6299166e3b	mucho gusto	es	nice to meet you	\N	phrase	CONVERSATION_ES	BEGINNER	Mucho gusto en conocerte.	Nice to meet you.	mucho gusto	handshake	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
1706ca35-e4b4-4ec7-bc86-c3dc7f6ddf2d	¿cómo estás?	es	how are you?	\N	phrase	CONVERSATION_ES	BEGINNER	¿Cómo estás hoy?	How are you today?	¿cómo estás?	greeting	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
7df3d936-c898-4ed1-85ee-49cd3e0992f3	bien	es	good/well	\N	adjective	CONVERSATION_ES	BEGINNER	Estoy muy bien, gracias.	I am very well, thank you.	bien	happy	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
8ba563bc-0a3b-4ebc-acd7-944b7f3899c4	mal	es	bad/not well	\N	adjective	CONVERSATION_ES	BEGINNER	Estoy un poco mal hoy.	I am a little unwell today.	mal	sick	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
d185dd75-058a-4521-9bda-60bf8655de9a	más o menos	es	so-so	\N	phrase	CONVERSATION_ES	BEGINNER	Estoy más o menos.	I am so-so.	más o menos	so_so	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
6eed9445-188a-42b9-8070-3747cf68a93e	uno	es	one	\N	number	GRAMMAR_ES	BEGINNER	Tengo un hijo.	I have one son.	uno	number_1	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
6e4e097d-14b7-4f37-a144-2640333f2f96	dos	es	two	\N	number	GRAMMAR_ES	BEGINNER	Tengo dos perros.	I have two dogs.	dos	number_2	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
4a845217-63ef-4f3a-a737-3e09631e58a9	tres	es	three	\N	number	GRAMMAR_ES	BEGINNER	Hay tres personas aquí.	There are three people here.	tres	number_3	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
1e9032d2-1228-4322-9c81-6385cff5109d	cuatro	es	four	\N	number	GRAMMAR_ES	BEGINNER	Son las cuatro.	It is four o'clock.	cuatro	number_4	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
783d1d04-debe-4094-ad76-f6fc37cd520c	cinco	es	five	\N	number	GRAMMAR_ES	BEGINNER	Tengo cinco libros.	I have five books.	cinco	number_5	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
6324f19b-5209-4573-b4be-46ca6088daa1	diez	es	ten	\N	number	GRAMMAR_ES	BEGINNER	Son diez dólares.	It is ten dollars.	diez	number_10	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
8102c7bc-176c-4a7d-8cc8-63bfe5cc440a	veinte	es	twenty	\N	number	GRAMMAR_ES	BEGINNER	Tengo veinte años.	I am twenty years old.	veinte	number_20	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
2a382745-89c0-4b6f-a9de-c8bec975107c	cien	es	one hundred	\N	number	GRAMMAR_ES	BEGINNER	Hay cien estudiantes.	There are one hundred students.	cien	number_100	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
fc2af132-6e75-41b0-8ddd-e4b7b15d2ada	aeropuerto	es	airport	\N	noun	TRAVEL_ES	BEGINNER	El aeropuerto está lejos.	The airport is far.	aeropuerto	airport	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
5a3aaf80-158e-414e-b4eb-902594b00801	hotel	es	hotel	\N	noun	TRAVEL_ES	BEGINNER	El hotel está cerca.	The hotel is nearby.	hotel	hotel	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
0ff60469-f027-4348-97c9-0e836c5af3d7	restaurante	es	restaurant	\N	noun	TRAVEL_ES	BEGINNER	El restaurante es bueno.	The restaurant is good.	restaurante	restaurant	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
552be32b-832a-4079-b9a7-47f0b1d5d9cc	taxi	es	taxi/cab	\N	noun	TRAVEL_ES	BEGINNER	Necesito un taxi.	I need a taxi.	taxi	taxi	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
ba67cafd-4641-4085-9859-6414ded33dcf	tren	es	train	\N	noun	TRAVEL_ES	BEGINNER	El tren llega a las dos.	The train arrives at two.	tren	train	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
289c96bf-c193-4f05-8cb7-f4665b524254	autobús	es	bus	\N	noun	TRAVEL_ES	BEGINNER	El autobús está lleno.	The bus is full.	autobús	bus	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
dc0abf55-9bd7-4483-bd3d-048aa9a89bdc	pasaporte	es	passport	\N	noun	TRAVEL_ES	BEGINNER	Necesito mi pasaporte.	I need my passport.	pasaporte	passport	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
956c6c8d-2d7b-4b05-a75f-a8eaa75c0f10	maleta	es	suitcase	\N	noun	TRAVEL_ES	BEGINNER	Mi maleta es pesada.	My suitcase is heavy.	maleta	suitcase	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
109650e0-e27d-451e-9de2-a37121a47b6e	billete	es	ticket	\N	noun	TRAVEL_ES	BEGINNER	Necesito un billete de ida.	I need a one-way ticket.	billete	ticket	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
3a902892-ea71-4f57-baf9-36d5f753543f	izquierda	es	left	\N	noun	TRAVEL_ES	BEGINNER	Gire a la izquierda.	Turn left.	izquierda	left_arrow	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
ead75fba-93e4-4c88-a7dc-b32ed7b01862	derecha	es	right	\N	noun	TRAVEL_ES	BEGINNER	Gire a la derecha.	Turn right.	derecha	right_arrow	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
30c473a8-5277-405c-b3b3-06c6bc3fd092	recto	es	straight ahead	\N	adverb	TRAVEL_ES	BEGINNER	Siga recto.	Go straight ahead.	recto	straight	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
03ddefc3-7033-42f6-8b40-7c0807e8a832	cerca	es	near/close	\N	adverb	TRAVEL_ES	BEGINNER	El hotel está cerca.	The hotel is close.	cerca	near	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
9a20789e-6b11-4644-bbfa-f0588872eb32	lejos	es	far	\N	adverb	TRAVEL_ES	BEGINNER	El aeropuerto está lejos.	The airport is far.	lejos	far	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
e30aeb37-9314-4a2e-aba4-aa44ad37d2d1	ser	es	to be (permanent)	\N	verb	GRAMMAR_ES	BEGINNER	Soy estudiante.	I am a student.	ser	identity	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
bcd1ef20-9b9f-49d1-9066-a65feeb2bbd4	estar	es	to be (temporary)	\N	verb	GRAMMAR_ES	BEGINNER	Estoy cansado.	I am tired.	estar	state	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
b1e3e497-c5ae-4935-b773-719bfdcfe645	tener	es	to have	\N	verb	GRAMMAR_ES	BEGINNER	Tengo un carro.	I have a car.	tener	have	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
6e74b698-6087-46f0-81ff-6fc5b4e126f0	querer	es	to want	\N	verb	GRAMMAR_ES	BEGINNER	Quiero café.	I want coffee.	querer	want	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
e5fe9372-d39f-4076-9e11-2a6dea2b868d	necesitar	es	to need	\N	verb	GRAMMAR_ES	BEGINNER	Necesito ayuda.	I need help.	necesitar	need	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
d29e534f-9333-4299-8529-40d4681acf5a	hablar	es	to speak/talk	\N	verb	GRAMMAR_ES	BEGINNER	Hablo español un poco.	I speak Spanish a little.	hablar	speaking	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
53a3b16a-6fad-45fc-bef4-c39c0a60a1fd	comer	es	to eat	\N	verb	GRAMMAR_ES	BEGINNER	Como arroz todos los días.	I eat rice every day.	comer	eating	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
fd5f5b4f-0efe-4574-8557-8650f411fad3	beber	es	to drink	\N	verb	GRAMMAR_ES	BEGINNER	Bebo agua.	I drink water.	beber	drinking	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
dfbcc480-2cb4-4378-ab97-434c9519f4dd	ir	es	to go	\N	verb	GRAMMAR_ES	BEGINNER	Voy al trabajo.	I go to work.	ir	going	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
3009a81f-f9d9-47a5-aaae-2f4ea8383672	vivir	es	to live	\N	verb	GRAMMAR_ES	BEGINNER	Vivo en Nueva York.	I live in New York.	vivir	home	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
0ac39b91-813d-469d-a7a1-846b82780ce5	llamarse	es	to be called/named	\N	verb	GRAMMAR_ES	BEGINNER	Me llamo Ana.	My name is Ana.	llamarse	name	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
b8ef52ff-7e40-4770-ac27-513d39027360	entender	es	to understand	\N	verb	GRAMMAR_ES	BEGINNER	No entiendo.	I do not understand.	entender	confused	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
5dc06fc8-2677-48da-bb57-719cb7840ac5	saber	es	to know	\N	verb	GRAMMAR_ES	BEGINNER	No sé la respuesta.	I do not know the answer.	saber	thinking	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
57d66110-d3a8-4155-bae6-24b1996c0607	poder	es	to be able to/can	\N	verb	GRAMMAR_ES	BEGINNER	¿Puedo pagar aquí?	Can I pay here?	poder	ability	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
f613e5ab-8ddb-460f-b0b6-2f34c123f885	pedir	es	to ask for/order	\N	verb	GRAMMAR_ES	BEGINNER	Quiero pedir la cuenta.	I want to ask for the check.	pedir	ordering	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
f44bba8e-3779-4942-ac88-877c954f572f	hombre	es	man	\N	noun	CONVERSATION_ES	BEGINNER	El hombre es alto.	The man is tall.	hombre	man	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
bfe9516e-2f08-4e0f-b09f-0795c606b2de	mujer	es	woman	\N	noun	CONVERSATION_ES	BEGINNER	La mujer es inteligente.	The woman is intelligent.	mujer	woman	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
a4183f51-15be-42e2-b6e1-2e189924afc2	niño	es	boy/child	\N	noun	CONVERSATION_ES	BEGINNER	El niño juega en el parque.	The boy plays in the park.	niño	boy	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
53ace493-3bd6-42c9-a728-e4c86263bd50	niña	es	girl/child	\N	noun	CONVERSATION_ES	BEGINNER	La niña es simpática.	The girl is nice.	niña	girl	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
aa93b66e-d542-4380-bd5e-1a261edf9cbd	familia	es	family	\N	noun	CONVERSATION_ES	BEGINNER	Mi familia es grande.	My family is big.	familia	family	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
7208ee26-dd18-4295-a28d-2e656f1b71c4	madre	es	mother	\N	noun	CONVERSATION_ES	BEGINNER	Mi madre es doctora.	My mother is a doctor.	madre	mother	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
c5766e68-bff4-413a-bba9-afd97cddfe98	padre	es	father	\N	noun	CONVERSATION_ES	BEGINNER	Mi padre trabaja mucho.	My father works a lot.	padre	father	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
0d14df8a-a655-4087-a06e-8651270b3398	amigo	es	friend (m)	\N	noun	CONVERSATION_ES	BEGINNER	Mi amigo se llama Pedro.	My friend's name is Pedro.	amigo	friends	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
106a2837-a4c5-4bfc-bc3a-3bb8620b94c6	amiga	es	friend (f)	\N	noun	CONVERSATION_ES	BEGINNER	Mi amiga es muy lista.	My friend is very smart.	amiga	friends	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
30862388-cc05-497f-9d72-90b7bcf7c20d	reunión	es	meeting	\N	noun	BUSINESS_ES	INTERMEDIATE	La reunión empieza a las nueve.	The meeting starts at nine.	reunión	meeting	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
0c845780-d15e-496c-82e0-61bc4b15f19b	empresa	es	company/firm	\N	noun	BUSINESS_ES	INTERMEDIATE	Trabajo en una empresa grande.	I work in a big company.	empresa	company	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
956930b7-3926-40dd-bb42-f8ba3d878a88	jefe	es	boss/manager	\N	noun	BUSINESS_ES	INTERMEDIATE	Mi jefe es muy exigente.	My boss is very demanding.	jefe	boss	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
eb013e9a-b0e5-4ba3-a6ab-b4548e9616b0	cliente	es	client/customer	\N	noun	BUSINESS_ES	INTERMEDIATE	El cliente siempre tiene razón.	The customer is always right.	cliente	customer	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
681f2ede-b681-4357-a3eb-6d75537cd5a3	contrato	es	contract	\N	noun	BUSINESS_ES	INTERMEDIATE	Firmé el contrato ayer.	I signed the contract yesterday.	contrato	contract	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
5409c65d-6289-44e5-9e0c-c3453277eb39	presentación	es	presentation	\N	noun	BUSINESS_ES	INTERMEDIATE	Mi presentación es mañana.	My presentation is tomorrow.	presentación	presentation	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
0d4d8440-7898-4725-810f-a7da68a3c95b	correo electrónico	es	email	\N	noun	BUSINESS_ES	INTERMEDIATE	Te envío un correo electrónico.	I'll send you an email.	correo electrónico	email	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
dbdcef6b-7c11-4aaa-8d16-4139a4491821	presupuesto	es	budget	\N	noun	BUSINESS_ES	INTERMEDIATE	El presupuesto es limitado.	The budget is limited.	presupuesto	budget	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
a87d96bc-d963-49db-a28c-e556e49014cd	factura	es	invoice	\N	noun	BUSINESS_ES	INTERMEDIATE	Necesito la factura, por favor.	I need the invoice, please.	factura	invoice	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
8db70829-7426-4670-b6f6-91f288e1796a	negocio	es	business/deal	\N	noun	BUSINESS_ES	INTERMEDIATE	El negocio va bien.	The business is going well.	negocio	business	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
8f01a00e-7f90-4279-b94d-5e6950fb908f	doctor	es	doctor	\N	noun	HEALTH_ES	INTERMEDIATE	Necesito ver al doctor.	I need to see the doctor.	doctor	doctor	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
4993b711-eefa-4f92-bda3-c2dbf99e30e0	hospital	es	hospital	\N	noun	HEALTH_ES	INTERMEDIATE	El hospital está a dos cuadras.	The hospital is two blocks away.	hospital	hospital	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
d8d2dd71-c67d-492a-9951-5c2064934448	medicina	es	medicine	\N	noun	HEALTH_ES	INTERMEDIATE	Necesito esta medicina.	I need this medicine.	medicina	medicine	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
f4561431-224b-493c-9e83-cf497c7f9440	dolor	es	pain/ache	\N	noun	HEALTH_ES	INTERMEDIATE	Tengo dolor de cabeza.	I have a headache.	dolor	pain	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
a103efdf-089f-4793-a029-4542997b3f0f	fiebre	es	fever	\N	noun	HEALTH_ES	INTERMEDIATE	Tengo fiebre alta.	I have a high fever.	fiebre	thermometer	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
d45866ad-1656-43f8-9355-0c2d5c1a92ca	alergia	es	allergy	\N	noun	HEALTH_ES	INTERMEDIATE	Tengo alergia al maní.	I am allergic to peanuts.	alergia	allergy	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
dfaf2e54-679e-4351-9ba7-8ddf66da2643	farmacia	es	pharmacy	\N	noun	HEALTH_ES	INTERMEDIATE	La farmacia está abierta.	The pharmacy is open.	farmacia	pharmacy	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
630bda0d-a9fc-41cb-8fb0-0c710340aae0	emergencia	es	emergency	\N	noun	HEALTH_ES	INTERMEDIATE	Es una emergencia médica.	It is a medical emergency.	emergencia	emergency	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
627c3679-8d6e-4df5-a1bc-4bc0baf2110e	sin embargo	es	however/nevertheless	\N	conjunction	GRAMMAR_ES	UPPER_INTERMEDIATE	Es difícil; sin embargo, es posible.	It is difficult; however, it is possible.	sin embargo	contrast	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
7684bcc7-049e-4c7f-83dc-b0a189a68c87	aunque	es	although/even though	\N	conjunction	GRAMMAR_ES	UPPER_INTERMEDIATE	Aunque llueve, salgo.	Although it rains, I go out.	aunque	contrast	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
96e176f7-5f9b-4673-878d-175147a5634e	puesto que	es	since/because	\N	conjunction	GRAMMAR_ES	UPPER_INTERMEDIATE	Puesto que no hay tiempo, apuremos.	Since there is no time, let us hurry.	puesto que	reason	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
3aebab67-e4eb-4ad9-ae7f-e498433ddd67	a pesar de	es	in spite of	\N	phrase	GRAMMAR_ES	UPPER_INTERMEDIATE	A pesar del frío, salimos.	In spite of the cold, we went out.	a pesar de	despite	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
1a5f3738-c365-4cc6-a131-cc0910e17674	por lo tanto	es	therefore/thus	\N	conjunction	GRAMMAR_ES	UPPER_INTERMEDIATE	Estudió mucho; por lo tanto, aprobó.	He studied hard; therefore, he passed.	por lo tanto	result	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
195b316b-c68c-44f6-981b-c86ae204eb61	sostenible	es	sustainable	\N	adjective	BUSINESS_ES	ADVANCED	Necesitamos un modelo sostenible.	We need a sustainable model.	sostenible	sustainability	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
2787f114-73bd-4ba1-8fd0-a43fbb5bc0f1	implementar	es	to implement	\N	verb	BUSINESS_ES	ADVANCED	Vamos a implementar la estrategia.	We are going to implement the strategy.	implementar	implementation	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
f507be1e-20e1-411b-957e-bdccd9a88afa	promover	es	to promote	\N	verb	BUSINESS_ES	ADVANCED	Debemos promover la innovación.	We must promote innovation.	promover	promote	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
e960c344-78eb-438b-acb6-45a1addbf298	perspectiva	es	perspective	\N	noun	BUSINESS_ES	ADVANCED	Desde mi perspectiva, es correcto.	From my perspective, it is correct.	perspectiva	perspective	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
6797d1ff-2ece-452e-aa74-759754df685e	estrategia	es	strategy	\N	noun	BUSINESS_ES	ADVANCED	La estrategia es efectiva.	The strategy is effective.	estrategia	strategy	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207
3313c60e-69bc-4c00-8eab-d56b28cb5b3b	water	en	agua	\N	noun	FOOD_EN	BEGINNER	I drink water every day.	Bebo agua todos los días.	water	water_bottle	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
a488dab9-de0c-4dc9-b685-8de26c530475	milk	en	leche	\N	noun	FOOD_EN	BEGINNER	I like cold milk.	Me gusta la leche fría.	milk	milk	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
036afb91-858c-466b-a8f9-37b19d2e1c91	coffee	en	café	\N	noun	FOOD_EN	BEGINNER	The coffee is hot.	El café está caliente.	coffee	coffee_cup	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
11456d77-9c89-4774-9d0e-47af2570ee49	bread	en	pan	\N	noun	FOOD_EN	BEGINNER	The bread is fresh.	El pan está fresco.	bread	bread	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
0d31acaa-2c45-494b-8672-2df63986fa37	rice	en	arroz	\N	noun	FOOD_EN	BEGINNER	The rice is ready.	El arroz está listo.	rice	rice_bowl	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
b73781fa-986c-4350-bb08-aafe66d4df97	chicken	en	pollo	\N	noun	FOOD_EN	BEGINNER	The chicken is delicious.	El pollo está delicioso.	chicken	chicken	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
028331ed-bf0b-40de-8f20-a1a69205a3c7	salad	en	ensalada	\N	noun	FOOD_EN	BEGINNER	The salad is fresh.	La ensalada está fresca.	salad	salad	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
7e094ead-d51c-4463-90cc-51fe10411ba1	soup	en	sopa	\N	noun	FOOD_EN	BEGINNER	The soup is hot.	La sopa está caliente.	soup	soup	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
ae80dc7f-4815-46c2-aaa8-d14966346fc5	apple	en	manzana	\N	noun	FOOD_EN	BEGINNER	The apple is red.	La manzana es roja.	apple	apple	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
89701679-a464-4dd9-8dd9-0b801e32a3cd	egg	en	huevo	\N	noun	FOOD_EN	BEGINNER	The egg is cooked.	El huevo está cocido.	egg	egg	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
a4ec3055-87ff-4b12-9076-83f76b1dd411	cheese	en	queso	\N	noun	FOOD_EN	BEGINNER	The cheese is yellow.	El queso es amarillo.	cheese	cheese	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
779dda17-5239-4a37-b214-d541e099453c	juice	en	jugo	\N	noun	FOOD_EN	BEGINNER	The orange juice is delicious.	El jugo de naranja es rico.	juice	juice	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
0defe98f-0440-4836-818b-93f1eea8b670	tea	en	té	\N	noun	FOOD_EN	BEGINNER	Green tea is healthy.	El té verde es saludable.	tea	tea_cup	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
dbb0a90c-88bb-45bc-b130-432071be6134	dessert	en	postre	\N	noun	FOOD_EN	BEGINNER	I want dessert, please.	Quiero el postre, por favor.	dessert	dessert	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
5a1a216e-700b-4656-906f-d90daeb638e8	hello	en	hola	\N	interjection	CONVERSATION_EN	BEGINNER	Hello, how are you?	¿Hola, cómo estás?	hello	greeting	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
eabb529d-247f-44c9-ad38-ec2d70ee46fc	goodbye	en	adiós	\N	interjection	CONVERSATION_EN	BEGINNER	Goodbye, see you later.	Adiós, hasta luego.	goodbye	wave	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
dc25e83a-d6ef-49db-b167-64654d4b66a7	good morning	en	buenos días	\N	phrase	CONVERSATION_EN	BEGINNER	Good morning, how are you?	¿Buenos días, cómo estás?	good morning	morning	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
cf6fa3c1-fd6b-44d1-af86-57831d9cdc9c	good night	en	buenas noches	\N	phrase	CONVERSATION_EN	BEGINNER	Good night, sleep well.	Buenas noches, duerme bien.	good night	night	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
2a089b36-b941-4a5d-b47b-9198d15b3b90	thank you	en	gracias	\N	interjection	CONVERSATION_EN	BEGINNER	Thank you very much.	Muchas gracias.	thank you	thanks	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
4cad1d1d-d360-435a-8a6e-c2a3f9180b49	please	en	por favor	\N	adverb	CONVERSATION_EN	BEGINNER	Water, please.	Agua, por favor.	please	polite	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
6f67c24c-a153-4cda-8d27-1c64338d00c6	yes	en	sí	\N	adverb	CONVERSATION_EN	BEGINNER	Yes, I am ready.	Sí, estoy listo.	yes	yes	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
ffeb00f3-90ce-473b-9f04-d97a2b2109ff	no	en	no	\N	adverb	CONVERSATION_EN	BEGINNER	No, thank you.	No, gracias.	no	no	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
f569a6b9-f449-42ab-aeb7-de9210add4c0	sorry	en	lo siento/perdón	\N	interjection	CONVERSATION_EN	BEGINNER	I am sorry for the mistake.	Lo siento por el error.	sorry	sorry	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
54cd585b-86af-43a3-825c-6475fbf4bc40	my name is	en	me llamo	\N	phrase	CONVERSATION_EN	BEGINNER	My name is Maria.	Me llamo María.	my name is	introduction	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
6c9390c1-464b-454c-ac16-2f293ac080e9	nice to meet you	en	mucho gusto	\N	phrase	CONVERSATION_EN	BEGINNER	Nice to meet you, John.	Mucho gusto, John.	nice to meet you	handshake	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
8d97fb96-e907-4e9d-bad6-11c59681f83d	how are you	en	¿cómo estás?	\N	phrase	CONVERSATION_EN	BEGINNER	How are you today?	¿Cómo estás hoy?	how are you	greeting	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
bfbfa263-1140-48e2-8af4-a92ca2b3725c	airport	en	aeropuerto	\N	noun	TRAVEL_EN	BEGINNER	The airport is far.	El aeropuerto está lejos.	airport	airport	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
9e0b8465-e95a-41fd-a885-606599c599ef	hotel	en	hotel	\N	noun	TRAVEL_EN	BEGINNER	The hotel is nearby.	El hotel está cerca.	hotel	hotel	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
09dd3c6b-6813-48eb-b9b4-d57da94ef9b7	restaurant	en	restaurante	\N	noun	TRAVEL_EN	BEGINNER	The restaurant is good.	El restaurante es bueno.	restaurant	restaurant	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
66e5ca9a-6cc3-463f-b1f2-b486f8008b38	taxi	en	taxi	\N	noun	TRAVEL_EN	BEGINNER	I need a taxi.	Necesito un taxi.	taxi	taxi	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
525c84be-9e97-447b-ba0a-816efe8fc8c1	train	en	tren	\N	noun	TRAVEL_EN	BEGINNER	The train arrives at two.	El tren llega a las dos.	train	train	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
a24e8fdb-95c9-4342-a853-86a28006c9d6	bus	en	autobús	\N	noun	TRAVEL_EN	BEGINNER	The bus is full.	El autobús está lleno.	bus	bus	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
0ba9ec08-cf2c-48d1-bb32-77f6197badcd	passport	en	pasaporte	\N	noun	TRAVEL_EN	BEGINNER	I need my passport.	Necesito mi pasaporte.	passport	passport	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
a85f0af3-2d08-403c-a753-b5a455019a46	suitcase	en	maleta	\N	noun	TRAVEL_EN	BEGINNER	My suitcase is heavy.	Mi maleta es pesada.	suitcase	suitcase	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
d22ae59e-d22f-48ac-b67c-5eb7720695c1	ticket	en	billete	\N	noun	TRAVEL_EN	BEGINNER	I need a one-way ticket.	Necesito un billete de ida.	ticket	ticket	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
4fd03f38-cb0b-4a98-85cc-2c323756f554	left	en	izquierda	\N	noun	TRAVEL_EN	BEGINNER	Turn left at the corner.	Gire a la izquierda en la esquina.	left	left_arrow	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
1bc046d5-c4a2-4645-a007-b13035fce72c	right	en	derecha	\N	noun	TRAVEL_EN	BEGINNER	Turn right at the light.	Gire a la derecha en el semáforo.	right	right_arrow	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
d9754ca4-3f6d-4f22-9086-952a629b8fa5	meeting	en	reunión	\N	noun	BUSINESS_EN	INTERMEDIATE	The meeting starts at nine.	La reunión empieza a las nueve.	meeting	meeting	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
2f4cf8cf-2088-4e08-9902-4928c5dc99f1	company	en	empresa	\N	noun	BUSINESS_EN	INTERMEDIATE	I work in a big company.	Trabajo en una empresa grande.	company	company	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
396d579f-967b-4d68-a06d-78720c2192cb	manager	en	gerente	\N	noun	BUSINESS_EN	INTERMEDIATE	My manager is very strict.	Mi gerente es muy estricto.	manager	boss	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
ef2d75e6-c55d-4c71-9e27-02721e4c2320	client	en	cliente	\N	noun	BUSINESS_EN	INTERMEDIATE	The client is satisfied.	El cliente está satisfecho.	client	customer	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
75e57429-4f62-4d2a-b97d-9f98192b57d2	contract	en	contrato	\N	noun	BUSINESS_EN	INTERMEDIATE	I signed the contract.	Firmé el contrato.	contract	contract	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
0aa7cdcb-b524-4d5a-ad29-cc636b6707a2	presentation	en	presentación	\N	noun	BUSINESS_EN	INTERMEDIATE	My presentation is tomorrow.	Mi presentación es mañana.	presentation	presentation	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
80c53484-2e0a-449d-8665-7be4febea7e7	email	en	correo electrónico	\N	noun	BUSINESS_EN	INTERMEDIATE	I will send you an email.	Te enviaré un correo.	email	email	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
2c59c4e3-d0cb-462b-8ca5-b322a8dcfd68	budget	en	presupuesto	\N	noun	BUSINESS_EN	INTERMEDIATE	The budget is limited.	El presupuesto es limitado.	budget	budget	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
3361d16d-4dba-4517-b365-7215ecd3ab07	invoice	en	factura	\N	noun	BUSINESS_EN	INTERMEDIATE	Please send the invoice.	Por favor envíe la factura.	invoice	invoice	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
78d07679-1182-4216-861a-1452d7ad309e	deadline	en	fecha límite	\N	noun	BUSINESS_EN	INTERMEDIATE	The deadline is Friday.	La fecha límite es el viernes.	deadline	calendar	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
99e1b995-a4a7-4da2-92c6-213bdd63ae6e	doctor	en	doctor/médico	\N	noun	HEALTH_EN	INTERMEDIATE	I need to see a doctor.	Necesito ver a un médico.	doctor	doctor	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
6e1ff6d3-4219-443e-b899-a247d918af12	hospital	en	hospital	\N	noun	HEALTH_EN	INTERMEDIATE	The hospital is nearby.	El hospital está cerca.	hospital	hospital	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
0c45d733-6c9a-4afc-9e88-e4d6ec8088f7	medicine	en	medicina	\N	noun	HEALTH_EN	INTERMEDIATE	I need this medicine.	Necesito esta medicina.	medicine	medicine	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
31d428d0-16a8-4b26-8fcc-dbf8517a2b6f	pain	en	dolor	\N	noun	HEALTH_EN	INTERMEDIATE	I have pain in my back.	Tengo dolor en la espalda.	pain	pain	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
bcaeb953-5544-481e-9ed7-7e6ab22b25cb	fever	en	fiebre	\N	noun	HEALTH_EN	INTERMEDIATE	I have a high fever.	Tengo fiebre alta.	fever	thermometer	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
091c4732-4753-4102-a9b9-712497758668	allergy	en	alergia	\N	noun	HEALTH_EN	INTERMEDIATE	I have a peanut allergy.	Tengo alergia al maní.	allergy	allergy	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
7609976d-d02b-4753-b5ad-fd333d13a142	pharmacy	en	farmacia	\N	noun	HEALTH_EN	INTERMEDIATE	Where is the pharmacy?	¿Dónde está la farmacia?	pharmacy	pharmacy	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
bc73ba11-f198-4de9-83f7-91653f3712ac	emergency	en	emergencia	\N	noun	HEALTH_EN	INTERMEDIATE	Call 911, it is an emergency.	Llama al 911, es una emergencia.	emergency	emergency	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.67158
40565b89-e779-48f5-96d0-2e06eb2bcd6c	tomate	es	tomato	\N	noun	FOOD_ES	BEGINNER	Los tomates están maduros.	The tomatoes are ripe.	tomate	\N	\N	\N	\N	\N	to-MA-te	45	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894
5b965d4d-be9d-4681-9501-66e332bc3142	cebolla	es	onion	\N	noun	FOOD_ES	BEGINNER	Necesito una cebolla.	I need an onion.	cebolla	\N	\N	\N	\N	\N	se-BO-ya	52	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894
498a914f-fcbe-43ae-aea6-87727ce45ff0	lechuga	es	lettuce	\N	noun	FOOD_ES	BEGINNER	La lechuga está fresca.	The lettuce is fresh.	lechuga	\N	\N	\N	\N	\N	le-CHU-ga	58	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894
3a866466-1e69-4f7c-9691-afe3dfe6bc42	zanahoria	es	carrot	\N	noun	FOOD_ES	BEGINNER	Las zanahorias son saludables.	Carrots are healthy.	zanahoria	\N	\N	\N	\N	\N	sa-na-O-ria	61	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894
bbdcda40-37c9-4f17-b1c6-7d8db94b077a	papa	es	potato	\N	noun	FOOD_ES	BEGINNER	Me gustan las papas fritas.	I like french fries.	papa	\N	\N	\N	\N	\N	PA-pa	48	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894
a977c182-3ad4-4336-8b35-a187cde05985	aguacate	es	avocado	\N	noun	FOOD_ES	BEGINNER	El aguacate está verde.	The avocado is green.	aguacate	\N	\N	\N	\N	\N	a-gua-CA-te	65	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894
75e8727f-f36e-4276-bb12-281fb1f49133	limón	es	lemon	\N	noun	FOOD_ES	BEGINNER	Quiero un limón.	I want a lemon.	limón	\N	\N	\N	\N	\N	li-MON	55	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894
ff05924c-736d-4859-830b-36fe38233c1b	plátano	es	banana	\N	noun	FOOD_ES	BEGINNER	Los plátanos están dulces.	The bananas are sweet.	plátano	\N	\N	\N	\N	\N	PLA-ta-no	50	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894
8951fbb9-5ee8-4413-97f2-849d59735ac6	uva	es	grape	\N	noun	FOOD_ES	BEGINNER	Las uvas son deliciosas.	Grapes are delicious.	uva	\N	\N	\N	\N	\N	U-va	62	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894
7c5ed7ff-a847-4afe-b401-e47b62f58a3b	fresa	es	strawberry	\N	noun	FOOD_ES	BEGINNER	Me encantan las fresas.	I love strawberries.	fresa	\N	\N	\N	\N	\N	FRE-sa	59	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894
722ebf6a-db03-4027-a926-1362bb857242	equipaje	es	luggage	\N	noun	TRAVEL_ES	BEGINNER	Mi equipaje está en el avión.	My luggage is on the plane.	equipaje	\N	\N	\N	\N	\N	e-ki-PA-he	72	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894
a8ac6f19-0163-4d7d-b727-cc343bf00c59	facturación	es	check-in	\N	noun	TRAVEL_ES	INTERMEDIATE	La facturación cierra en una hora.	Check-in closes in one hour.	facturación	\N	\N	\N	\N	\N	fac-tu-ra-ci-ON	85	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894
e3c84eb7-134e-4511-9d15-d2e48eeb76e7	embarque	es	boarding	\N	noun	TRAVEL_ES	INTERMEDIATE	El embarque empieza a las diez.	Boarding starts at ten.	embarque	\N	\N	\N	\N	\N	em-BAR-ke	88	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894
1d86f93f-3900-4101-bc73-114b614da9d9	reserva	es	reservation	\N	noun	TRAVEL_ES	INTERMEDIATE	Tengo una reserva a nombre de García.	I have a reservation under García.	reserva	\N	\N	\N	\N	\N	re-SER-va	75	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894
6c3262da-a091-4064-8bac-da11f9a742ba	habitación	es	room	\N	noun	TRAVEL_ES	BEGINNER	Quiero una habitación doble.	I want a double room.	habitación	\N	\N	\N	\N	\N	a-bi-ta-ci-ON	68	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894
500a391c-cada-41f3-981f-509b3e20cc9d	recepción	es	reception	\N	noun	TRAVEL_ES	BEGINNER	La recepción está abierta 24 horas.	Reception is open 24 hours.	recepción	\N	\N	\N	\N	\N	re-sep-ci-ON	78	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894
ad6eb35b-4a8e-491a-a9af-12f86aa97c09	proyecto	es	project	\N	noun	BUSINESS_ES	INTERMEDIATE	El proyecto está casi terminado.	The project is almost finished.	proyecto	\N	\N	\N	\N	\N	pro-YEC-to	42	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894
4f86e2a8-2ce8-4879-85f6-3be2b8aba2ad	reunión	es	meeting	\N	noun	BUSINESS_ES	INTERMEDIATE	La reunión es a las tres.	The meeting is at three.	reunión	\N	\N	\N	\N	\N	re-u-NION	35	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894
17ff7458-5aa3-404e-bf3b-021976b0379f	informe	es	report	\N	noun	BUSINESS_ES	INTERMEDIATE	Necesito el informe antes del viernes.	I need the report before Friday.	informe	\N	\N	\N	\N	\N	in-FOR-me	55	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894
ef604988-e4aa-40a0-b6cf-e0c0ac7aad5b	objetivo	es	objective	\N	noun	BUSINESS_ES	INTERMEDIATE	Nuestro objetivo es aumentar ventas.	Our objective is to increase sales.	objetivo	\N	\N	\N	\N	\N	ob-he-TI-vo	48	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894
01e4efda-a5a1-4dae-8aad-57970f00fc8c	enfermera	es	nurse	\N	noun	HEALTH_ES	BEGINNER	La enfermera toma la presión.	The nurse takes the blood pressure.	enfermera	\N	\N	\N	\N	\N	en-fer-ME-ra	70	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894
546b0e70-ad0e-43a7-98fb-05bfb9f5b38d	receta	es	prescription	\N	noun	HEALTH_ES	INTERMEDIATE	Necesito una receta médica.	I need a medical prescription.	receta	\N	\N	\N	\N	\N	re-SE-ta	65	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894
cb760242-a77f-4452-a502-f491dd3b967d	inyección	es	injection	\N	noun	HEALTH_ES	INTERMEDIATE	El doctor me puso una inyección.	The doctor gave me an injection.	inyección	\N	\N	\N	\N	\N	in-yec-ci-ON	82	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894
5ab2e977-8052-49e8-afee-ffd2fed565cb	entender	es	to understand	\N	verb	CONVERSATION_ES	BEGINNER	No entiendo la pregunta.	I do not understand the question.	entender	\N	\N	\N	\N	\N	en-ten-DER	25	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894
1227388e-5eb0-4047-8b7d-70ac73b5336f	preguntar	es	to ask	\N	verb	CONVERSATION_ES	BEGINNER	¿Puedo preguntar algo?	Can I ask something?	preguntar	\N	\N	\N	\N	\N	pregun-TAR	30	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894
d8b874ff-fdca-4c6d-8fe9-bea09e3efb8b	tomato	en	tomate	\N	noun	FOOD_EN	BEGINNER	The tomatoes are ripe.	Los tomates están maduros.	tomato	\N	\N	\N	\N	\N	tuh-MAY-toh	45	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.044507
a10bee88-7d45-476b-8ffa-f3235ea65bff	onion	en	cebolla	\N	noun	FOOD_EN	BEGINNER	I need an onion.	Necesito una cebolla.	onion	\N	\N	\N	\N	\N	UH-nyun	52	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.044507
df906b50-b885-49ec-81a2-f1e265218300	lettuce	en	lechuga	\N	noun	FOOD_EN	BEGINNER	The lettuce is fresh.	La lechuga está fresca.	lettuce	\N	\N	\N	\N	\N	LE-tis	58	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.044507
a89276ab-c4c7-4235-a923-b266d8f8bec1	carrot	en	zanahoria	\N	noun	FOOD_EN	BEGINNER	Carrots are healthy.	Las zanahorias son saludables.	carrot	\N	\N	\N	\N	\N	KA-rut	61	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.044507
00aa5b56-db61-4e67-b532-6c682fd42925	potato	en	papa	\N	noun	FOOD_EN	BEGINNER	I like french fries.	Me gustan las papas fritas.	potato	\N	\N	\N	\N	\N	puh-TAY-toh	48	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.044507
8dc8d21b-39ea-4725-a0b2-c92f60b5d6ab	avocado	en	aguacate	\N	noun	FOOD_EN	BEGINNER	The avocado is green.	El aguacate está verde.	avocado	\N	\N	\N	\N	\N	a-vuh-KAH-doh	65	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.044507
119d0e62-0c66-4215-b1ca-bde3cb43cff7	lemon	en	limón	\N	noun	FOOD_EN	BEGINNER	I want a lemon.	Quiero un limón.	lemon	\N	\N	\N	\N	\N	LE-mun	55	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.044507
17d59671-9bce-4e1b-890c-8ca45d74e958	banana	en	plátano	\N	noun	FOOD_EN	BEGINNER	The bananas are sweet.	Los plátanos están dulces.	banana	\N	\N	\N	\N	\N	buh-NA-nuh	50	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.044507
c6b3909e-9230-4f10-addf-e5b1f8a3db4b	grape	en	uva	\N	noun	FOOD_EN	BEGINNER	Grapes are delicious.	Las uvas son deliciosas.	grape	\N	\N	\N	\N	\N	grayp	62	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.044507
fbefb449-839d-4c68-8557-f1c2c460b7b1	strawberry	en	fresa	\N	noun	FOOD_EN	BEGINNER	I love strawberries.	Me encantan las fresas.	strawberry	\N	\N	\N	\N	\N	STRAW-be-ree	59	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.044507
e7d02778-94f0-4ca6-ba6f-780fa4c5dbe7	luggage	en	equipaje	\N	noun	TRAVEL_EN	BEGINNER	My luggage is on the plane.	Mi equipaje está en el avión.	luggage	\N	\N	\N	\N	\N	LUH-gij	72	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.044507
8a4583cc-8b5d-4ef8-86a5-91cab6ad4912	check-in	en	facturación	\N	noun	TRAVEL_EN	INTERMEDIATE	Check-in closes in one hour.	La facturación cierra en una hora.	check-in	\N	\N	\N	\N	\N	CHEK-in	85	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.044507
de948414-4e0f-4496-9838-11643111c379	boarding	en	embarque	\N	noun	TRAVEL_EN	INTERMEDIATE	Boarding starts at ten.	El embarque empieza a las diez.	boarding	\N	\N	\N	\N	\N	BOR-ding	88	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.044507
421015e2-3399-4f26-9494-8a1bbe6a0a68	reservation	en	reserva	\N	noun	TRAVEL_EN	INTERMEDIATE	I have a reservation under García.	Tengo una reserva a nombre de García.	reservation	\N	\N	\N	\N	\N	re-zer-VAY-shun	75	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.044507
300aeefc-9bb7-460f-bd16-e2410e294946	room	en	habitación	\N	noun	TRAVEL_EN	BEGINNER	I want a double room.	Quiero una habitación doble.	room	\N	\N	\N	\N	\N	room	68	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.044507
a22a201d-f7ae-4a92-9a80-7bac174b4fda	reception	en	recepción	\N	noun	TRAVEL_EN	BEGINNER	Reception is open 24 hours.	La recepción está abierta 24 horas.	reception	\N	\N	\N	\N	\N	ri-SEP-shun	78	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.044507
8c06b2a6-ed8d-4cf8-8967-5194a6f5c479	project	en	proyecto	\N	noun	BUSINESS_EN	INTERMEDIATE	The project is almost finished.	El proyecto está casi terminado.	project	\N	\N	\N	\N	\N	PRO-jekt	42	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.044507
9995202f-7d63-4b17-956a-8c9c90f07a55	meeting	en	reunión	\N	noun	BUSINESS_EN	INTERMEDIATE	The meeting is at three.	La reunión es a las tres.	meeting	\N	\N	\N	\N	\N	MEE-ting	35	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.044507
3d954655-83f3-43d3-83b6-6c30dd872692	report	en	informe	\N	noun	BUSINESS_EN	INTERMEDIATE	I need the report before Friday.	Necesito el informe antes del viernes.	report	\N	\N	\N	\N	\N	ri-PORT	55	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.044507
0bac0644-3132-464f-8952-c9461fc1fdd7	objective	en	objetivo	\N	noun	BUSINESS_EN	INTERMEDIATE	Our objective is to increase sales.	Nuestro objetivo es aumentar ventas.	objective	\N	\N	\N	\N	\N	ub-JEK-tiv	48	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.044507
b3f31e95-340c-4149-b739-67462178f278	nurse	en	enfermera	\N	noun	HEALTH_EN	BEGINNER	The nurse takes the blood pressure.	La enfermera toma la presión.	nurse	\N	\N	\N	\N	\N	nurs	70	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.044507
79388f6d-98d5-4f72-ab01-5610b08c6eef	prescription	en	receta	\N	noun	HEALTH_EN	INTERMEDIATE	I need a medical prescription.	Necesito una receta médica.	prescription	\N	\N	\N	\N	\N	pri-SKRIP-shun	65	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.044507
16c4d3d8-d43d-400c-99fb-1a1a87dd6388	injection	en	inyección	\N	noun	HEALTH_EN	INTERMEDIATE	The doctor gave me an injection.	El doctor me puso una inyección.	injection	\N	\N	\N	\N	\N	in-JEK-shun	82	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.044507
57f5aba7-806a-406b-b377-f2e879de2d1b	understand	en	entender	\N	verb	CONVERSATION_EN	BEGINNER	I do not understand the question.	No entiendo la pregunta.	understand	\N	\N	\N	\N	\N	un-der-STAND	25	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.044507
c25901c3-e6e5-43ef-8015-ba4ec8b82b95	ask	en	preguntar	\N	verb	CONVERSATION_EN	BEGINNER	Can I ask something?	¿Puedo preguntar algo?	ask	\N	\N	\N	\N	\N	ask	30	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.044507
9f8b1be7-c38f-465a-82ad-0909fbb03b4f	tomate	es	tomato	\N	noun	FOOD_ES	BEGINNER	Los tomates están maduros.	The tomatoes are ripe.	tomate	\N	\N	\N	\N	\N	to-MA-te	45	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.376921
e3e766ee-0205-4191-a3ec-4281f7ba89b8	cebolla	es	onion	\N	noun	FOOD_ES	BEGINNER	Necesito una cebolla.	I need an onion.	cebolla	\N	\N	\N	\N	\N	se-BO-ya	52	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.376921
ef3ac348-430d-449f-96fd-00d8957007b5	lechuga	es	lettuce	\N	noun	FOOD_ES	BEGINNER	La lechuga está fresca.	The lettuce is fresh.	lechuga	\N	\N	\N	\N	\N	le-CHU-ga	58	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.376921
91fd74a6-675f-45e3-a2da-9e8a46234fb9	zanahoria	es	carrot	\N	noun	FOOD_ES	BEGINNER	Las zanahorias son saludables.	Carrots are healthy.	zanahoria	\N	\N	\N	\N	\N	sa-na-O-ria	61	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.376921
9abc5912-76a0-4d9b-800d-dac13a3ae14d	papa	es	potato	\N	noun	FOOD_ES	BEGINNER	Me gustan las papas fritas.	I like french fries.	papa	\N	\N	\N	\N	\N	PA-pa	48	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.376921
512d12ad-5ff3-459a-b9ec-370ba127a6c1	aguacate	es	avocado	\N	noun	FOOD_ES	BEGINNER	El aguacate está verde.	The avocado is green.	aguacate	\N	\N	\N	\N	\N	a-gua-CA-te	65	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.376921
bb387f38-846e-4d26-8133-688da98896ef	limón	es	lemon	\N	noun	FOOD_ES	BEGINNER	Quiero un limón.	I want a lemon.	limón	\N	\N	\N	\N	\N	li-MON	55	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.376921
efdabb38-dbd8-4b46-966b-9720d6f33df8	plátano	es	banana	\N	noun	FOOD_ES	BEGINNER	Los plátanos están dulces.	The bananas are sweet.	plátano	\N	\N	\N	\N	\N	PLA-ta-no	50	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.376921
088ae5a0-201e-43bd-bc1e-b8bd527b2499	uva	es	grape	\N	noun	FOOD_ES	BEGINNER	Las uvas son deliciosas.	Grapes are delicious.	uva	\N	\N	\N	\N	\N	U-va	62	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.376921
ac9dd04f-7fea-4765-b502-8fded4229581	fresa	es	strawberry	\N	noun	FOOD_ES	BEGINNER	Me encantan las fresas.	I love strawberries.	fresa	\N	\N	\N	\N	\N	FRE-sa	59	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.376921
e9d0ff40-5d78-4af6-b0cd-d5792a643c5e	equipaje	es	luggage	\N	noun	TRAVEL_ES	BEGINNER	Mi equipaje está en el avión.	My luggage is on the plane.	equipaje	\N	\N	\N	\N	\N	e-ki-PA-he	72	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.376921
ba249049-a197-4656-9a66-87bfc2b8f545	facturación	es	check-in	\N	noun	TRAVEL_ES	INTERMEDIATE	La facturación cierra en una hora.	Check-in closes in one hour.	facturación	\N	\N	\N	\N	\N	fac-tu-ra-ci-ON	85	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.376921
3fc60840-b115-4ffe-b5b3-75c458125e64	embarque	es	boarding	\N	noun	TRAVEL_ES	INTERMEDIATE	El embarque empieza a las diez.	Boarding starts at ten.	embarque	\N	\N	\N	\N	\N	em-BAR-ke	88	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.376921
707c416a-495f-406e-b5a9-269ac26b4c1c	reserva	es	reservation	\N	noun	TRAVEL_ES	INTERMEDIATE	Tengo una reserva a nombre de García.	I have a reservation under García.	reserva	\N	\N	\N	\N	\N	re-SER-va	75	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.376921
2fd66d1e-c802-4dca-ac9a-ee48a15b15fb	habitación	es	room	\N	noun	TRAVEL_ES	BEGINNER	Quiero una habitación doble.	I want a double room.	habitación	\N	\N	\N	\N	\N	a-bi-ta-ci-ON	68	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.376921
72ff99fd-1765-42bc-ba78-ce51bc54d124	recepción	es	reception	\N	noun	TRAVEL_ES	BEGINNER	La recepción está abierta 24 horas.	Reception is open 24 hours.	recepción	\N	\N	\N	\N	\N	re-sep-ci-ON	78	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.376921
f3226338-9017-4440-92d9-2edd53004c0e	proyecto	es	project	\N	noun	BUSINESS_ES	INTERMEDIATE	El proyecto está casi terminado.	The project is almost finished.	proyecto	\N	\N	\N	\N	\N	pro-YEC-to	42	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.376921
7ef686a7-4d44-4ee5-b413-2de4ced8a8a5	reunión	es	meeting	\N	noun	BUSINESS_ES	INTERMEDIATE	La reunión es a las tres.	The meeting is at three.	reunión	\N	\N	\N	\N	\N	re-u-NION	35	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.376921
bccd82d4-ce35-4fb2-acd4-a13db3257ea4	informe	es	report	\N	noun	BUSINESS_ES	INTERMEDIATE	Necesito el informe antes del viernes.	I need the report before Friday.	informe	\N	\N	\N	\N	\N	in-FOR-me	55	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.376921
2cd1c74a-2f6a-461f-91da-87d816189722	objetivo	es	objective	\N	noun	BUSINESS_ES	INTERMEDIATE	Nuestro objetivo es aumentar ventas.	Our objective is to increase sales.	objetivo	\N	\N	\N	\N	\N	ob-he-TI-vo	48	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.376921
4cfd180d-8216-4611-ad17-3b6ea99e3ab0	enfermera	es	nurse	\N	noun	HEALTH_ES	BEGINNER	La enfermera toma la presión.	The nurse takes the blood pressure.	enfermera	\N	\N	\N	\N	\N	en-fer-ME-ra	70	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.376921
3264d888-3360-45b5-a65c-d57cde00738f	receta	es	prescription	\N	noun	HEALTH_ES	INTERMEDIATE	Necesito una receta médica.	I need a medical prescription.	receta	\N	\N	\N	\N	\N	re-SE-ta	65	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.376921
69be2826-1a38-41ca-ba5b-b2c5f98b1a96	inyección	es	injection	\N	noun	HEALTH_ES	INTERMEDIATE	El doctor me puso una inyección.	The doctor gave me an injection.	inyección	\N	\N	\N	\N	\N	in-yec-ci-ON	82	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.376921
c3f64248-1350-497b-b90c-f86f82d79ee1	entender	es	to understand	\N	verb	CONVERSATION_ES	BEGINNER	No entiendo la pregunta.	I do not understand the question.	entender	\N	\N	\N	\N	\N	en-ten-DER	25	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.376921
ab22b0c7-005e-4960-9ea6-f555272fdfd6	preguntar	es	to ask	\N	verb	CONVERSATION_ES	BEGINNER	¿Puedo preguntar algo?	Can I ask something?	preguntar	\N	\N	\N	\N	\N	pregun-TAR	30	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.376921
eaa51c4d-efc5-4b1f-a1d2-1dde9397975f	tomato	en	tomate	\N	noun	FOOD_EN	BEGINNER	The tomatoes are ripe.	Los tomates están maduros.	tomato	\N	\N	\N	\N	\N	tuh-MAY-toh	45	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.377694
e84229f1-1b9d-4c67-a545-ffb8561d45fa	onion	en	cebolla	\N	noun	FOOD_EN	BEGINNER	I need an onion.	Necesito una cebolla.	onion	\N	\N	\N	\N	\N	UH-nyun	52	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.377694
f2397fe5-b92f-4ac9-8484-4ad97c4189e8	lettuce	en	lechuga	\N	noun	FOOD_EN	BEGINNER	The lettuce is fresh.	La lechuga está fresca.	lettuce	\N	\N	\N	\N	\N	LE-tis	58	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.377694
71a65f52-2e0e-4568-a5b4-f292bf2adbb5	carrot	en	zanahoria	\N	noun	FOOD_EN	BEGINNER	Carrots are healthy.	Las zanahorias son saludables.	carrot	\N	\N	\N	\N	\N	KA-rut	61	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.377694
fa493d27-4cd9-4a6e-bf53-c369d0730e36	potato	en	papa	\N	noun	FOOD_EN	BEGINNER	I like french fries.	Me gustan las papas fritas.	potato	\N	\N	\N	\N	\N	puh-TAY-toh	48	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.377694
527d18c2-5149-43c3-86bf-bac5b532d637	avocado	en	aguacate	\N	noun	FOOD_EN	BEGINNER	The avocado is green.	El aguacate está verde.	avocado	\N	\N	\N	\N	\N	a-vuh-KAH-doh	65	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.377694
16e98c17-ff6a-4c1f-be5d-555ee6733df5	lemon	en	limón	\N	noun	FOOD_EN	BEGINNER	I want a lemon.	Quiero un limón.	lemon	\N	\N	\N	\N	\N	LE-mun	55	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.377694
a1e7c0a6-89c4-4f4d-9b69-9ec3c99f17a3	banana	en	plátano	\N	noun	FOOD_EN	BEGINNER	The bananas are sweet.	Los plátanos están dulces.	banana	\N	\N	\N	\N	\N	buh-NA-nuh	50	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.377694
5805dfaa-58ac-4ab6-8f8a-1d53c8edffbf	grape	en	uva	\N	noun	FOOD_EN	BEGINNER	Grapes are delicious.	Las uvas son deliciosas.	grape	\N	\N	\N	\N	\N	grayp	62	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.377694
81f5d641-3b32-4ab8-beed-057fe0f1bf8e	strawberry	en	fresa	\N	noun	FOOD_EN	BEGINNER	I love strawberries.	Me encantan las fresas.	strawberry	\N	\N	\N	\N	\N	STRAW-be-ree	59	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.377694
591e83eb-3197-48af-a7af-39bab740c25c	luggage	en	equipaje	\N	noun	TRAVEL_EN	BEGINNER	My luggage is on the plane.	Mi equipaje está en el avión.	luggage	\N	\N	\N	\N	\N	LUH-gij	72	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.377694
a2e59439-f032-4b5e-90c1-a31049c9c2e8	check-in	en	facturación	\N	noun	TRAVEL_EN	INTERMEDIATE	Check-in closes in one hour.	La facturación cierra en una hora.	check-in	\N	\N	\N	\N	\N	CHEK-in	85	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.377694
f23fe8b5-1930-4ef7-a3c3-46d732a762bd	boarding	en	embarque	\N	noun	TRAVEL_EN	INTERMEDIATE	Boarding starts at ten.	El embarque empieza a las diez.	boarding	\N	\N	\N	\N	\N	BOR-ding	88	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.377694
3a63cbea-3def-4cdd-a35f-8c7d866a032e	reservation	en	reserva	\N	noun	TRAVEL_EN	INTERMEDIATE	I have a reservation under García.	Tengo una reserva a nombre de García.	reservation	\N	\N	\N	\N	\N	re-zer-VAY-shun	75	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.377694
92a95ce7-25fd-46ce-8e25-957fc39fdcdc	room	en	habitación	\N	noun	TRAVEL_EN	BEGINNER	I want a double room.	Quiero una habitación doble.	room	\N	\N	\N	\N	\N	room	68	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.377694
52e0d226-4c85-4595-bf43-5d9468439785	reception	en	recepción	\N	noun	TRAVEL_EN	BEGINNER	Reception is open 24 hours.	La recepción está abierta 24 horas.	reception	\N	\N	\N	\N	\N	ri-SEP-shun	78	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.377694
55a3d476-0434-4695-9d4f-0479b637df12	project	en	proyecto	\N	noun	BUSINESS_EN	INTERMEDIATE	The project is almost finished.	El proyecto está casi terminado.	project	\N	\N	\N	\N	\N	PRO-jekt	42	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.377694
58ff6974-3bc6-4321-883b-eb0cc3ddb397	meeting	en	reunión	\N	noun	BUSINESS_EN	INTERMEDIATE	The meeting is at three.	La reunión es a las tres.	meeting	\N	\N	\N	\N	\N	MEE-ting	35	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.377694
2a5dc182-c36e-4da6-bf33-e8b322f03641	report	en	informe	\N	noun	BUSINESS_EN	INTERMEDIATE	I need the report before Friday.	Necesito el informe antes del viernes.	report	\N	\N	\N	\N	\N	ri-PORT	55	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.377694
72a86ee6-3618-4f83-a5fe-4eaec25113f9	objective	en	objetivo	\N	noun	BUSINESS_EN	INTERMEDIATE	Our objective is to increase sales.	Nuestro objetivo es aumentar ventas.	objective	\N	\N	\N	\N	\N	ub-JEK-tiv	48	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.377694
478693e2-8bb9-491d-b8ab-6aeb5783be8e	nurse	en	enfermera	\N	noun	HEALTH_EN	BEGINNER	The nurse takes the blood pressure.	La enfermera toma la presión.	nurse	\N	\N	\N	\N	\N	nurs	70	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.377694
1959f132-2b91-4197-93c2-d086ddc5a31b	prescription	en	receta	\N	noun	HEALTH_EN	INTERMEDIATE	I need a medical prescription.	Necesito una receta médica.	prescription	\N	\N	\N	\N	\N	pri-SKRIP-shun	65	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.377694
5c52181e-866b-4e14-8a10-294ee218ad3f	injection	en	inyección	\N	noun	HEALTH_EN	INTERMEDIATE	The doctor gave me an injection.	El doctor me puso una inyección.	injection	\N	\N	\N	\N	\N	in-JEK-shun	82	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.377694
6edcc894-9be4-4b8e-a03f-b2372dbb0368	understand	en	entender	\N	verb	CONVERSATION_EN	BEGINNER	I do not understand the question.	No entiendo la pregunta.	understand	\N	\N	\N	\N	\N	un-der-STAND	25	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.377694
2cc44f5e-fd55-45cb-878c-0bbff00e24d9	ask	en	preguntar	\N	verb	CONVERSATION_EN	BEGINNER	Can I ask something?	¿Puedo preguntar algo?	ask	\N	\N	\N	\N	\N	ask	30	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:07:30.377694
\.


--
-- Data for Name: word_relationships; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.word_relationships (id, word_id_1, word_id_2, relationship, notes, created_at) FROM stdin;
\.


--
-- Data for Name: xp_history; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.xp_history (id, user_id, amount, source, earned_at) FROM stdin;
1ebbfa85-1a93-4c50-8d93-88a607ae55c0	cb7b7c8b-987d-4557-b395-d91c017b19ef	10	LESSON	2026-03-24 13:27:31.315601
fd3a60cc-f2bd-4c6a-9c68-6ed6d7dd9fa3	cb7b7c8b-987d-4557-b395-d91c017b19ef	15	QUEST	2026-03-24 13:27:31.339365
f917b440-98a2-43e5-b609-8e4a8fae7923	cb7b7c8b-987d-4557-b395-d91c017b19ef	10	QUEST	2026-03-24 13:27:31.342118
7cd7ca1f-dfe5-4092-b58b-84a897d46626	cb7b7c8b-987d-4557-b395-d91c017b19ef	10	QUEST	2026-03-24 13:27:31.344664
\.


--
-- Name: accessibility_preferences accessibility_preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.accessibility_preferences
    ADD CONSTRAINT accessibility_preferences_pkey PRIMARY KEY (user_id);


--
-- Name: achievements achievements_code_key; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.achievements
    ADD CONSTRAINT achievements_code_key UNIQUE (code);


--
-- Name: achievements achievements_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.achievements
    ADD CONSTRAINT achievements_pkey PRIMARY KEY (id);


--
-- Name: admin_level_adjustments admin_level_adjustments_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.admin_level_adjustments
    ADD CONSTRAINT admin_level_adjustments_pkey PRIMARY KEY (id);


--
-- Name: ai_conversation_templates ai_conversation_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.ai_conversation_templates
    ADD CONSTRAINT ai_conversation_templates_pkey PRIMARY KEY (id);


--
-- Name: ai_messages ai_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.ai_messages
    ADD CONSTRAINT ai_messages_pkey PRIMARY KEY (id);


--
-- Name: ai_sessions ai_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.ai_sessions
    ADD CONSTRAINT ai_sessions_pkey PRIMARY KEY (id);


--
-- Name: common_mistakes common_mistakes_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.common_mistakes
    ADD CONSTRAINT common_mistakes_pkey PRIMARY KEY (id);


--
-- Name: conjugations conjugations_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.conjugations
    ADD CONSTRAINT conjugations_pkey PRIMARY KEY (id);


--
-- Name: conjugations conjugations_vocabulary_id_tense_mood_person_key; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.conjugations
    ADD CONSTRAINT conjugations_vocabulary_id_tense_mood_person_key UNIQUE (vocabulary_id, tense, mood, person);


--
-- Name: content_audit_log content_audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.content_audit_log
    ADD CONSTRAINT content_audit_log_pkey PRIMARY KEY (id);


--
-- Name: cultural_notes cultural_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.cultural_notes
    ADD CONSTRAINT cultural_notes_pkey PRIMARY KEY (id);


--
-- Name: dashboard_metrics dashboard_metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.dashboard_metrics
    ADD CONSTRAINT dashboard_metrics_pkey PRIMARY KEY (id);


--
-- Name: dashboard_metrics dashboard_metrics_user_id_key; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.dashboard_metrics
    ADD CONSTRAINT dashboard_metrics_user_id_key UNIQUE (user_id);


--
-- Name: exercise_distractors exercise_distractors_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.exercise_distractors
    ADD CONSTRAINT exercise_distractors_pkey PRIMARY KEY (id);


--
-- Name: exercises exercises_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.exercises
    ADD CONSTRAINT exercises_pkey PRIMARY KEY (id);


--
-- Name: grammar_rules grammar_rules_code_key; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.grammar_rules
    ADD CONSTRAINT grammar_rules_code_key UNIQUE (code);


--
-- Name: grammar_rules grammar_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.grammar_rules
    ADD CONSTRAINT grammar_rules_pkey PRIMARY KEY (id);


--
-- Name: leaderboard_entries leaderboard_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.leaderboard_entries
    ADD CONSTRAINT leaderboard_entries_pkey PRIMARY KEY (id);


--
-- Name: leaderboard_entries leaderboard_entries_user_id_week_start_key; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.leaderboard_entries
    ADD CONSTRAINT leaderboard_entries_user_id_week_start_key UNIQUE (user_id, week_start);


--
-- Name: lesson_cultural_notes lesson_cultural_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.lesson_cultural_notes
    ADD CONSTRAINT lesson_cultural_notes_pkey PRIMARY KEY (lesson_id, cultural_note_id);


--
-- Name: lesson_feedback lesson_feedback_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.lesson_feedback
    ADD CONSTRAINT lesson_feedback_pkey PRIMARY KEY (id);


--
-- Name: lesson_feedback lesson_feedback_user_id_lesson_id_key; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.lesson_feedback
    ADD CONSTRAINT lesson_feedback_user_id_lesson_id_key UNIQUE (user_id, lesson_id);


--
-- Name: lesson_navigation_log lesson_navigation_log_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.lesson_navigation_log
    ADD CONSTRAINT lesson_navigation_log_pkey PRIMARY KEY (id);


--
-- Name: lesson_versions lesson_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.lesson_versions
    ADD CONSTRAINT lesson_versions_pkey PRIMARY KEY (id);


--
-- Name: lessons lessons_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.lessons
    ADD CONSTRAINT lessons_pkey PRIMARY KEY (id);


--
-- Name: level_change_history level_change_history_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.level_change_history
    ADD CONSTRAINT level_change_history_pkey PRIMARY KEY (id);


--
-- Name: milestone_reassessments milestone_reassessments_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.milestone_reassessments
    ADD CONSTRAINT milestone_reassessments_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: payment_transactions payment_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.payment_transactions
    ADD CONSTRAINT payment_transactions_pkey PRIMARY KEY (id);


--
-- Name: payment_transactions payment_transactions_transaction_ref_key; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.payment_transactions
    ADD CONSTRAINT payment_transactions_transaction_ref_key UNIQUE (transaction_ref);


--
-- Name: personalized_lesson_plans personalized_lesson_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.personalized_lesson_plans
    ADD CONSTRAINT personalized_lesson_plans_pkey PRIMARY KEY (id);


--
-- Name: personalized_lesson_queue personalized_lesson_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.personalized_lesson_queue
    ADD CONSTRAINT personalized_lesson_queue_pkey PRIMARY KEY (id);


--
-- Name: phrases phrases_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.phrases
    ADD CONSTRAINT phrases_pkey PRIMARY KEY (id);


--
-- Name: placement_answers placement_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.placement_answers
    ADD CONSTRAINT placement_answers_pkey PRIMARY KEY (id);


--
-- Name: placement_questions placement_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.placement_questions
    ADD CONSTRAINT placement_questions_pkey PRIMARY KEY (id);


--
-- Name: placement_tests placement_tests_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.placement_tests
    ADD CONSTRAINT placement_tests_pkey PRIMARY KEY (id);


--
-- Name: quests quests_code_key; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.quests
    ADD CONSTRAINT quests_code_key UNIQUE (code);


--
-- Name: quests quests_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.quests
    ADD CONSTRAINT quests_pkey PRIMARY KEY (id);


--
-- Name: reading_passages reading_passages_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.reading_passages
    ADD CONSTRAINT reading_passages_pkey PRIMARY KEY (id);


--
-- Name: reading_questions reading_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.reading_questions
    ADD CONSTRAINT reading_questions_pkey PRIMARY KEY (id);


--
-- Name: review_sessions review_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.review_sessions
    ADD CONSTRAINT review_sessions_pkey PRIMARY KEY (id);


--
-- Name: sections sections_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT sections_pkey PRIMARY KEY (id);


--
-- Name: skill_breakdown_reports skill_breakdown_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.skill_breakdown_reports
    ADD CONSTRAINT skill_breakdown_reports_pkey PRIMARY KEY (id);


--
-- Name: skill_breakdown_reports skill_breakdown_reports_user_id_language_report_date_key; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.skill_breakdown_reports
    ADD CONSTRAINT skill_breakdown_reports_user_id_language_report_date_key UNIQUE (user_id, language, report_date);


--
-- Name: speaking_attempts speaking_attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.speaking_attempts
    ADD CONSTRAINT speaking_attempts_pkey PRIMARY KEY (id);


--
-- Name: streak_history streak_history_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.streak_history
    ADD CONSTRAINT streak_history_pkey PRIMARY KEY (id);


--
-- Name: streak_history streak_history_user_id_streak_date_key; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.streak_history
    ADD CONSTRAINT streak_history_user_id_streak_date_key UNIQUE (user_id, streak_date);


--
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- Name: system_performance_log system_performance_log_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.system_performance_log
    ADD CONSTRAINT system_performance_log_pkey PRIMARY KEY (id);


--
-- Name: topics topics_code_key; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.topics
    ADD CONSTRAINT topics_code_key UNIQUE (code);


--
-- Name: topics topics_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.topics
    ADD CONSTRAINT topics_pkey PRIMARY KEY (id);


--
-- Name: units units_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.units
    ADD CONSTRAINT units_pkey PRIMARY KEY (id);


--
-- Name: user_achievements user_achievements_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.user_achievements
    ADD CONSTRAINT user_achievements_pkey PRIMARY KEY (id);


--
-- Name: user_achievements user_achievements_user_id_achievement_id_key; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.user_achievements
    ADD CONSTRAINT user_achievements_user_id_achievement_id_key UNIQUE (user_id, achievement_id);


--
-- Name: user_daily_quests user_daily_quests_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.user_daily_quests
    ADD CONSTRAINT user_daily_quests_pkey PRIMARY KEY (id);


--
-- Name: user_daily_quests user_daily_quests_user_id_quest_id_quest_date_key; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.user_daily_quests
    ADD CONSTRAINT user_daily_quests_user_id_quest_id_quest_date_key UNIQUE (user_id, quest_id, quest_date);


--
-- Name: user_exercise_attempts user_exercise_attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.user_exercise_attempts
    ADD CONSTRAINT user_exercise_attempts_pkey PRIMARY KEY (id);


--
-- Name: user_learning_preferences user_learning_preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.user_learning_preferences
    ADD CONSTRAINT user_learning_preferences_pkey PRIMARY KEY (user_id);


--
-- Name: user_lesson_progress user_lesson_progress_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.user_lesson_progress
    ADD CONSTRAINT user_lesson_progress_pkey PRIMARY KEY (id);


--
-- Name: user_lesson_progress user_lesson_progress_user_id_lesson_id_key; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.user_lesson_progress
    ADD CONSTRAINT user_lesson_progress_user_id_lesson_id_key UNIQUE (user_id, lesson_id);


--
-- Name: user_mistake_patterns user_mistake_patterns_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.user_mistake_patterns
    ADD CONSTRAINT user_mistake_patterns_pkey PRIMARY KEY (id);


--
-- Name: user_skills user_skills_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.user_skills
    ADD CONSTRAINT user_skills_pkey PRIMARY KEY (id);


--
-- Name: user_skills user_skills_user_id_language_key; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.user_skills
    ADD CONSTRAINT user_skills_user_id_language_key UNIQUE (user_id, language);


--
-- Name: user_topics user_topics_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.user_topics
    ADD CONSTRAINT user_topics_pkey PRIMARY KEY (user_id, topic_id);


--
-- Name: user_word_memory user_word_memory_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.user_word_memory
    ADD CONSTRAINT user_word_memory_pkey PRIMARY KEY (id);


--
-- Name: user_word_memory user_word_memory_user_id_vocabulary_id_key; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.user_word_memory
    ADD CONSTRAINT user_word_memory_user_id_vocabulary_id_key UNIQUE (user_id, vocabulary_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: vocabulary vocabulary_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.vocabulary
    ADD CONSTRAINT vocabulary_pkey PRIMARY KEY (id);


--
-- Name: word_relationships word_relationships_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.word_relationships
    ADD CONSTRAINT word_relationships_pkey PRIMARY KEY (id);


--
-- Name: word_relationships word_relationships_word_id_1_word_id_2_relationship_key; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.word_relationships
    ADD CONSTRAINT word_relationships_word_id_1_word_id_2_relationship_key UNIQUE (word_id_1, word_id_2, relationship);


--
-- Name: xp_history xp_history_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.xp_history
    ADD CONSTRAINT xp_history_pkey PRIMARY KEY (id);


--
-- Name: idx_act_lang; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_act_lang ON public.ai_conversation_templates USING btree (language);


--
-- Name: idx_act_level; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_act_level ON public.ai_conversation_templates USING btree (level);


--
-- Name: idx_act_topic; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_act_topic ON public.ai_conversation_templates USING btree (topic_tag);


--
-- Name: idx_ai_messages_session; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_ai_messages_session ON public.ai_messages USING btree (session_id);


--
-- Name: idx_ai_sessions_status; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_ai_sessions_status ON public.ai_sessions USING btree (user_id, session_status);


--
-- Name: idx_ai_sessions_user; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_ai_sessions_user ON public.ai_sessions USING btree (user_id);


--
-- Name: idx_ala_admin; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_ala_admin ON public.admin_level_adjustments USING btree (admin_id);


--
-- Name: idx_ala_learner; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_ala_learner ON public.admin_level_adjustments USING btree (learner_id);


--
-- Name: idx_cn_topic; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_cn_topic ON public.cultural_notes USING btree (topic_tag);


--
-- Name: idx_common_mistakes_ref; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_common_mistakes_ref ON public.common_mistakes USING btree (reference_id);


--
-- Name: idx_common_mistakes_user; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_common_mistakes_user ON public.common_mistakes USING btree (user_id);


--
-- Name: idx_conj_tense; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_conj_tense ON public.conjugations USING btree (tense);


--
-- Name: idx_conjugations_verb; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_conjugations_verb ON public.conjugations USING btree (vocabulary_id);


--
-- Name: idx_cultural_notes_lang; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_cultural_notes_lang ON public.cultural_notes USING btree (language);


--
-- Name: idx_dist_vocab; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_dist_vocab ON public.exercise_distractors USING btree (vocabulary_id);


--
-- Name: idx_dm_user; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_dm_user ON public.dashboard_metrics USING btree (user_id);


--
-- Name: idx_exercises_grammar; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_exercises_grammar ON public.exercises USING btree (grammar_rule_id);


--
-- Name: idx_exercises_lesson; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_exercises_lesson ON public.exercises USING btree (lesson_id);


--
-- Name: idx_exercises_skill; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_exercises_skill ON public.exercises USING btree (skill_tested);


--
-- Name: idx_exercises_type; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_exercises_type ON public.exercises USING btree (exercise_type);


--
-- Name: idx_grammar_cat; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_grammar_cat ON public.grammar_rules USING btree (category);


--
-- Name: idx_grammar_level; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_grammar_level ON public.grammar_rules USING btree (level);


--
-- Name: idx_grammar_rules_lang; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_grammar_rules_lang ON public.grammar_rules USING btree (language);


--
-- Name: idx_lch_user; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_lch_user ON public.level_change_history USING btree (user_id);


--
-- Name: idx_leaderboard_week; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_leaderboard_week ON public.leaderboard_entries USING btree (week_start);


--
-- Name: idx_lessons_type; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_lessons_type ON public.lessons USING btree (lesson_type);


--
-- Name: idx_lessons_unit; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_lessons_unit ON public.lessons USING btree (unit_id);


--
-- Name: idx_lf_lesson; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_lf_lesson ON public.lesson_feedback USING btree (lesson_id);


--
-- Name: idx_lnl_lesson; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_lnl_lesson ON public.lesson_navigation_log USING btree (lesson_id);


--
-- Name: idx_lnl_user; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_lnl_user ON public.lesson_navigation_log USING btree (user_id);


--
-- Name: idx_lv_lesson; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_lv_lesson ON public.lesson_versions USING btree (lesson_id, version_number DESC);


--
-- Name: idx_mr_user; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_mr_user ON public.milestone_reassessments USING btree (user_id);


--
-- Name: idx_notifications_sched; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_notifications_sched ON public.notifications USING btree (scheduled_at) WHERE ((delivery_status)::text = 'PENDING'::text);


--
-- Name: idx_notifications_user; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_notifications_user ON public.notifications USING btree (user_id, is_read);


--
-- Name: idx_phrase_lang; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_phrase_lang ON public.phrases USING btree (language);


--
-- Name: idx_phrase_level; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_phrase_level ON public.phrases USING btree (level);


--
-- Name: idx_phrase_topic; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_phrase_topic ON public.phrases USING btree (topic_tag);


--
-- Name: idx_placement_completed; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_placement_completed ON public.placement_tests USING btree (user_id, was_completed);


--
-- Name: idx_placement_lang; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_placement_lang ON public.placement_questions USING btree (language);


--
-- Name: idx_placement_user; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_placement_user ON public.placement_tests USING btree (user_id);


--
-- Name: idx_plq_priority; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_plq_priority ON public.personalized_lesson_queue USING btree (plan_id, priority DESC);


--
-- Name: idx_plq_user; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_plq_user ON public.personalized_lesson_queue USING btree (user_id, is_completed);


--
-- Name: idx_progress_completed; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_progress_completed ON public.user_lesson_progress USING btree (user_id, status) WHERE ((status)::text = 'COMPLETED'::text);


--
-- Name: idx_progress_lesson; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_progress_lesson ON public.user_lesson_progress USING btree (lesson_id);


--
-- Name: idx_progress_status; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_progress_status ON public.user_lesson_progress USING btree (status);


--
-- Name: idx_progress_user; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_progress_user ON public.user_lesson_progress USING btree (user_id);


--
-- Name: idx_pt_status; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_pt_status ON public.payment_transactions USING btree (status);


--
-- Name: idx_pt_user; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_pt_user ON public.payment_transactions USING btree (user_id);


--
-- Name: idx_rp_lang; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_rp_lang ON public.reading_passages USING btree (language);


--
-- Name: idx_rp_level; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_rp_level ON public.reading_passages USING btree (level);


--
-- Name: idx_rq_pass; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_rq_pass ON public.reading_questions USING btree (passage_id);


--
-- Name: idx_rs_status; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_rs_status ON public.review_sessions USING btree (user_id, status);


--
-- Name: idx_rs_user; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_rs_user ON public.review_sessions USING btree (user_id);


--
-- Name: idx_sbr_date; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_sbr_date ON public.skill_breakdown_reports USING btree (user_id, report_date DESC);


--
-- Name: idx_sbr_user; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_sbr_user ON public.skill_breakdown_reports USING btree (user_id);


--
-- Name: idx_sections_lang_level; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_sections_lang_level ON public.sections USING btree (language, level);


--
-- Name: idx_skills_user; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_skills_user ON public.user_skills USING btree (user_id);


--
-- Name: idx_speak_ex; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_speak_ex ON public.speaking_attempts USING btree (exercise_id);


--
-- Name: idx_speak_user; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_speak_user ON public.speaking_attempts USING btree (user_id);


--
-- Name: idx_spl_endpoint; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_spl_endpoint ON public.system_performance_log USING btree (endpoint);


--
-- Name: idx_spl_exceeded; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_spl_exceeded ON public.system_performance_log USING btree (exceeded_threshold);


--
-- Name: idx_streak_user_date; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_streak_user_date ON public.streak_history USING btree (user_id, streak_date);


--
-- Name: idx_subscriptions_active; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_subscriptions_active ON public.subscriptions USING btree (user_id, status);


--
-- Name: idx_subscriptions_expiry; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_subscriptions_expiry ON public.subscriptions USING btree (expires_at) WHERE ((status)::text = 'ACTIVE'::text);


--
-- Name: idx_ump_count; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_ump_count ON public.user_mistake_patterns USING btree (user_id, mistake_count DESC);


--
-- Name: idx_ump_grammar; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_ump_grammar ON public.user_mistake_patterns USING btree (grammar_rule_id);


--
-- Name: idx_ump_user; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_ump_user ON public.user_mistake_patterns USING btree (user_id);


--
-- Name: idx_units_section; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_units_section ON public.units USING btree (section_id);


--
-- Name: idx_user_daily_quests_date; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_user_daily_quests_date ON public.user_daily_quests USING btree (user_id, quest_date);


--
-- Name: idx_user_word_memory_next; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_user_word_memory_next ON public.user_word_memory USING btree (user_id, next_review_at);


--
-- Name: idx_user_word_memory_user; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_user_word_memory_user ON public.user_word_memory USING btree (user_id);


--
-- Name: idx_users_active; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_users_active ON public.users USING btree (is_active, account_status);


--
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_users_email ON public.users USING btree (email);


--
-- Name: idx_users_learning_lang; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_users_learning_lang ON public.users USING btree (assigned_level, learning_language);


--
-- Name: idx_users_level; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_users_level ON public.users USING btree (assigned_level);


--
-- Name: idx_users_reset_token; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_users_reset_token ON public.users USING btree (password_reset_token) WHERE (password_reset_token IS NOT NULL);


--
-- Name: idx_users_username; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_users_username ON public.users USING btree (username);


--
-- Name: idx_users_verified; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_users_verified ON public.users USING btree (is_verified);


--
-- Name: idx_users_verify_token; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_users_verify_token ON public.users USING btree (email_verification_token) WHERE (email_verification_token IS NOT NULL);


--
-- Name: idx_uwm_strength; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_uwm_strength ON public.user_word_memory USING btree (user_id, memory_strength);


--
-- Name: idx_uwm_vocab; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_uwm_vocab ON public.user_word_memory USING btree (vocabulary_id);


--
-- Name: idx_vocab_freq; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_vocab_freq ON public.vocabulary USING btree (frequency_rank);


--
-- Name: idx_vocab_irregular; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_vocab_irregular ON public.vocabulary USING btree (is_irregular);


--
-- Name: idx_vocab_language; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_vocab_language ON public.vocabulary USING btree (language);


--
-- Name: idx_vocab_level; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_vocab_level ON public.vocabulary USING btree (level);


--
-- Name: idx_vocab_topic; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_vocab_topic ON public.vocabulary USING btree (topic_tag);


--
-- Name: idx_word_rel_1; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_word_rel_1 ON public.word_relationships USING btree (word_id_1);


--
-- Name: idx_word_rel_2; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_word_rel_2 ON public.word_relationships USING btree (word_id_2);


--
-- Name: idx_xp_history_user; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_xp_history_user ON public.xp_history USING btree (user_id);


--
-- Name: accessibility_preferences accessibility_preferences_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.accessibility_preferences
    ADD CONSTRAINT accessibility_preferences_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: admin_level_adjustments admin_level_adjustments_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.admin_level_adjustments
    ADD CONSTRAINT admin_level_adjustments_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public.users(id);


--
-- Name: admin_level_adjustments admin_level_adjustments_learner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.admin_level_adjustments
    ADD CONSTRAINT admin_level_adjustments_learner_id_fkey FOREIGN KEY (learner_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: ai_messages ai_messages_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.ai_messages
    ADD CONSTRAINT ai_messages_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.ai_sessions(id) ON DELETE CASCADE;


--
-- Name: ai_sessions ai_sessions_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.ai_sessions
    ADD CONSTRAINT ai_sessions_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.ai_conversation_templates(id) ON DELETE SET NULL;


--
-- Name: ai_sessions ai_sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.ai_sessions
    ADD CONSTRAINT ai_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: common_mistakes common_mistakes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.common_mistakes
    ADD CONSTRAINT common_mistakes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: conjugations conjugations_vocabulary_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.conjugations
    ADD CONSTRAINT conjugations_vocabulary_id_fkey FOREIGN KEY (vocabulary_id) REFERENCES public.vocabulary(id) ON DELETE CASCADE;


--
-- Name: content_audit_log content_audit_log_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.content_audit_log
    ADD CONSTRAINT content_audit_log_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public.users(id);


--
-- Name: dashboard_metrics dashboard_metrics_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.dashboard_metrics
    ADD CONSTRAINT dashboard_metrics_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: exercise_distractors exercise_distractors_vocabulary_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.exercise_distractors
    ADD CONSTRAINT exercise_distractors_vocabulary_id_fkey FOREIGN KEY (vocabulary_id) REFERENCES public.vocabulary(id) ON DELETE CASCADE;


--
-- Name: exercises exercises_grammar_rule_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.exercises
    ADD CONSTRAINT exercises_grammar_rule_id_fkey FOREIGN KEY (grammar_rule_id) REFERENCES public.grammar_rules(id) ON DELETE SET NULL;


--
-- Name: exercises exercises_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.exercises
    ADD CONSTRAINT exercises_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lessons(id) ON DELETE CASCADE;


--
-- Name: leaderboard_entries leaderboard_entries_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.leaderboard_entries
    ADD CONSTRAINT leaderboard_entries_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: lesson_cultural_notes lesson_cultural_notes_cultural_note_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.lesson_cultural_notes
    ADD CONSTRAINT lesson_cultural_notes_cultural_note_id_fkey FOREIGN KEY (cultural_note_id) REFERENCES public.cultural_notes(id) ON DELETE CASCADE;


--
-- Name: lesson_cultural_notes lesson_cultural_notes_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.lesson_cultural_notes
    ADD CONSTRAINT lesson_cultural_notes_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lessons(id) ON DELETE CASCADE;


--
-- Name: lesson_feedback lesson_feedback_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.lesson_feedback
    ADD CONSTRAINT lesson_feedback_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lessons(id) ON DELETE CASCADE;


--
-- Name: lesson_feedback lesson_feedback_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.lesson_feedback
    ADD CONSTRAINT lesson_feedback_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: lesson_navigation_log lesson_navigation_log_exercise_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.lesson_navigation_log
    ADD CONSTRAINT lesson_navigation_log_exercise_id_fkey FOREIGN KEY (exercise_id) REFERENCES public.exercises(id) ON DELETE SET NULL;


--
-- Name: lesson_navigation_log lesson_navigation_log_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.lesson_navigation_log
    ADD CONSTRAINT lesson_navigation_log_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lessons(id) ON DELETE CASCADE;


--
-- Name: lesson_navigation_log lesson_navigation_log_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.lesson_navigation_log
    ADD CONSTRAINT lesson_navigation_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: lesson_versions lesson_versions_changed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.lesson_versions
    ADD CONSTRAINT lesson_versions_changed_by_fkey FOREIGN KEY (changed_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: lesson_versions lesson_versions_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.lesson_versions
    ADD CONSTRAINT lesson_versions_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lessons(id) ON DELETE CASCADE;


--
-- Name: lessons lessons_grammar_rule_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.lessons
    ADD CONSTRAINT lessons_grammar_rule_id_fkey FOREIGN KEY (grammar_rule_id) REFERENCES public.grammar_rules(id) ON DELETE SET NULL;


--
-- Name: lessons lessons_prerequisite_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.lessons
    ADD CONSTRAINT lessons_prerequisite_lesson_id_fkey FOREIGN KEY (prerequisite_lesson_id) REFERENCES public.lessons(id) ON DELETE SET NULL;


--
-- Name: lessons lessons_reading_passage_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.lessons
    ADD CONSTRAINT lessons_reading_passage_id_fkey FOREIGN KEY (reading_passage_id) REFERENCES public.reading_passages(id) ON DELETE SET NULL;


--
-- Name: lessons lessons_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.lessons
    ADD CONSTRAINT lessons_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.units(id) ON DELETE CASCADE;


--
-- Name: level_change_history level_change_history_changed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.level_change_history
    ADD CONSTRAINT level_change_history_changed_by_fkey FOREIGN KEY (changed_by) REFERENCES public.users(id);


--
-- Name: level_change_history level_change_history_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.level_change_history
    ADD CONSTRAINT level_change_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: milestone_reassessments milestone_reassessments_test_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.milestone_reassessments
    ADD CONSTRAINT milestone_reassessments_test_id_fkey FOREIGN KEY (test_id) REFERENCES public.placement_tests(id);


--
-- Name: milestone_reassessments milestone_reassessments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.milestone_reassessments
    ADD CONSTRAINT milestone_reassessments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: payment_transactions payment_transactions_subscription_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.payment_transactions
    ADD CONSTRAINT payment_transactions_subscription_id_fkey FOREIGN KEY (subscription_id) REFERENCES public.subscriptions(id);


--
-- Name: payment_transactions payment_transactions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.payment_transactions
    ADD CONSTRAINT payment_transactions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: personalized_lesson_plans personalized_lesson_plans_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.personalized_lesson_plans
    ADD CONSTRAINT personalized_lesson_plans_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: personalized_lesson_queue personalized_lesson_queue_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.personalized_lesson_queue
    ADD CONSTRAINT personalized_lesson_queue_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lessons(id) ON DELETE CASCADE;


--
-- Name: personalized_lesson_queue personalized_lesson_queue_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.personalized_lesson_queue
    ADD CONSTRAINT personalized_lesson_queue_plan_id_fkey FOREIGN KEY (plan_id) REFERENCES public.personalized_lesson_plans(id) ON DELETE CASCADE;


--
-- Name: personalized_lesson_queue personalized_lesson_queue_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.personalized_lesson_queue
    ADD CONSTRAINT personalized_lesson_queue_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: placement_answers placement_answers_test_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.placement_answers
    ADD CONSTRAINT placement_answers_test_id_fkey FOREIGN KEY (test_id) REFERENCES public.placement_tests(id) ON DELETE CASCADE;


--
-- Name: placement_tests placement_tests_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.placement_tests
    ADD CONSTRAINT placement_tests_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: reading_questions reading_questions_passage_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.reading_questions
    ADD CONSTRAINT reading_questions_passage_id_fkey FOREIGN KEY (passage_id) REFERENCES public.reading_passages(id) ON DELETE CASCADE;


--
-- Name: review_sessions review_sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.review_sessions
    ADD CONSTRAINT review_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: skill_breakdown_reports skill_breakdown_reports_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.skill_breakdown_reports
    ADD CONSTRAINT skill_breakdown_reports_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: speaking_attempts speaking_attempts_exercise_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.speaking_attempts
    ADD CONSTRAINT speaking_attempts_exercise_id_fkey FOREIGN KEY (exercise_id) REFERENCES public.exercises(id) ON DELETE CASCADE;


--
-- Name: speaking_attempts speaking_attempts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.speaking_attempts
    ADD CONSTRAINT speaking_attempts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: streak_history streak_history_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.streak_history
    ADD CONSTRAINT streak_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: subscriptions subscriptions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: system_performance_log system_performance_log_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.system_performance_log
    ADD CONSTRAINT system_performance_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: units units_section_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.units
    ADD CONSTRAINT units_section_id_fkey FOREIGN KEY (section_id) REFERENCES public.sections(id) ON DELETE CASCADE;


--
-- Name: user_achievements user_achievements_achievement_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.user_achievements
    ADD CONSTRAINT user_achievements_achievement_id_fkey FOREIGN KEY (achievement_id) REFERENCES public.achievements(id) ON DELETE CASCADE;


--
-- Name: user_achievements user_achievements_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.user_achievements
    ADD CONSTRAINT user_achievements_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_daily_quests user_daily_quests_quest_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.user_daily_quests
    ADD CONSTRAINT user_daily_quests_quest_id_fkey FOREIGN KEY (quest_id) REFERENCES public.quests(id) ON DELETE CASCADE;


--
-- Name: user_daily_quests user_daily_quests_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.user_daily_quests
    ADD CONSTRAINT user_daily_quests_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_exercise_attempts user_exercise_attempts_exercise_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.user_exercise_attempts
    ADD CONSTRAINT user_exercise_attempts_exercise_id_fkey FOREIGN KEY (exercise_id) REFERENCES public.exercises(id) ON DELETE CASCADE;


--
-- Name: user_exercise_attempts user_exercise_attempts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.user_exercise_attempts
    ADD CONSTRAINT user_exercise_attempts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_learning_preferences user_learning_preferences_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.user_learning_preferences
    ADD CONSTRAINT user_learning_preferences_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_lesson_progress user_lesson_progress_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.user_lesson_progress
    ADD CONSTRAINT user_lesson_progress_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lessons(id) ON DELETE CASCADE;


--
-- Name: user_lesson_progress user_lesson_progress_next_recommended_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.user_lesson_progress
    ADD CONSTRAINT user_lesson_progress_next_recommended_lesson_id_fkey FOREIGN KEY (next_recommended_lesson_id) REFERENCES public.lessons(id);


--
-- Name: user_lesson_progress user_lesson_progress_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.user_lesson_progress
    ADD CONSTRAINT user_lesson_progress_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_mistake_patterns user_mistake_patterns_grammar_rule_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.user_mistake_patterns
    ADD CONSTRAINT user_mistake_patterns_grammar_rule_id_fkey FOREIGN KEY (grammar_rule_id) REFERENCES public.grammar_rules(id) ON DELETE SET NULL;


--
-- Name: user_mistake_patterns user_mistake_patterns_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.user_mistake_patterns
    ADD CONSTRAINT user_mistake_patterns_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_mistake_patterns user_mistake_patterns_vocabulary_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.user_mistake_patterns
    ADD CONSTRAINT user_mistake_patterns_vocabulary_id_fkey FOREIGN KEY (vocabulary_id) REFERENCES public.vocabulary(id) ON DELETE SET NULL;


--
-- Name: user_skills user_skills_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.user_skills
    ADD CONSTRAINT user_skills_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_topics user_topics_topic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.user_topics
    ADD CONSTRAINT user_topics_topic_id_fkey FOREIGN KEY (topic_id) REFERENCES public.topics(id) ON DELETE CASCADE;


--
-- Name: user_topics user_topics_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.user_topics
    ADD CONSTRAINT user_topics_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_word_memory user_word_memory_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.user_word_memory
    ADD CONSTRAINT user_word_memory_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_word_memory user_word_memory_vocabulary_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.user_word_memory
    ADD CONSTRAINT user_word_memory_vocabulary_id_fkey FOREIGN KEY (vocabulary_id) REFERENCES public.vocabulary(id) ON DELETE CASCADE;


--
-- Name: word_relationships word_relationships_word_id_1_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.word_relationships
    ADD CONSTRAINT word_relationships_word_id_1_fkey FOREIGN KEY (word_id_1) REFERENCES public.vocabulary(id) ON DELETE CASCADE;


--
-- Name: word_relationships word_relationships_word_id_2_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.word_relationships
    ADD CONSTRAINT word_relationships_word_id_2_fkey FOREIGN KEY (word_id_2) REFERENCES public.vocabulary(id) ON DELETE CASCADE;


--
-- Name: xp_history xp_history_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.xp_history
    ADD CONSTRAINT xp_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict ROfcAPbPhabZf1schCtPk5vNptBvUHhh7nOk5lYXr4YTf7PnefrDbOhz3nz4lrk

