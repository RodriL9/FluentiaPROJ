--
-- PostgreSQL database dump
--

\restrict OkZhv7klSvr3Xia7C9Whdd0Na9tElcKGowNawemvVqVjaC4jLC0cgDrnDewKckH

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
-- Name: alphabet; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.alphabet (
    id integer NOT NULL,
    letter character varying(100) NOT NULL,
    phonetic_es character varying(200) NOT NULL,
    phonetic_en character varying(200) NOT NULL,
    level character varying(50) DEFAULT 'BEGINNER'::character varying,
    lesson_number integer DEFAULT 1
);


ALTER TABLE public.alphabet OWNER TO rodrigo;

--
-- Name: alphabet_id_seq; Type: SEQUENCE; Schema: public; Owner: rodrigo
--

CREATE SEQUENCE public.alphabet_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.alphabet_id_seq OWNER TO rodrigo;

--
-- Name: alphabet_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rodrigo
--

ALTER SEQUENCE public.alphabet_id_seq OWNED BY public.alphabet.id;


--
-- Name: colors_descriptions; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.colors_descriptions (
    id integer NOT NULL,
    spanish character varying(100) NOT NULL,
    english character varying(100) NOT NULL,
    category character varying(50) NOT NULL,
    level character varying(50) NOT NULL,
    language character varying(5) DEFAULT 'es'::character varying,
    lesson_number integer DEFAULT 6
);


ALTER TABLE public.colors_descriptions OWNER TO rodrigo;

--
-- Name: colors_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: rodrigo
--

CREATE SEQUENCE public.colors_descriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.colors_descriptions_id_seq OWNER TO rodrigo;

--
-- Name: colors_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rodrigo
--

ALTER SEQUENCE public.colors_descriptions_id_seq OWNED BY public.colors_descriptions.id;


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
-- Name: family_relationships; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.family_relationships (
    id integer NOT NULL,
    spanish character varying(100) NOT NULL,
    english character varying(100) NOT NULL,
    category character varying(50) NOT NULL,
    level character varying(50) NOT NULL,
    language character varying(5) DEFAULT 'es'::character varying,
    lesson_number integer DEFAULT 7
);


ALTER TABLE public.family_relationships OWNER TO rodrigo;

--
-- Name: family_relationships_id_seq; Type: SEQUENCE; Schema: public; Owner: rodrigo
--

CREATE SEQUENCE public.family_relationships_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.family_relationships_id_seq OWNER TO rodrigo;

--
-- Name: family_relationships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rodrigo
--

ALTER SEQUENCE public.family_relationships_id_seq OWNED BY public.family_relationships.id;


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
-- Name: lesson_catalog; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.lesson_catalog (
    lesson_number integer NOT NULL,
    title character varying(100) NOT NULL,
    table_name character varying(100) NOT NULL,
    description text
);


ALTER TABLE public.lesson_catalog OWNER TO rodrigo;

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
-- Name: numbers; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.numbers (
    id integer NOT NULL,
    spanish character varying(100) NOT NULL,
    english character varying(100) NOT NULL,
    numeral character varying(20),
    number_type character varying(50) NOT NULL,
    level character varying(50) NOT NULL,
    language character varying(5) DEFAULT 'es'::character varying,
    lesson_number integer DEFAULT 5
);


ALTER TABLE public.numbers OWNER TO rodrigo;

--
-- Name: numbers_id_seq; Type: SEQUENCE; Schema: public; Owner: rodrigo
--

CREATE SEQUENCE public.numbers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.numbers_id_seq OWNER TO rodrigo;

--
-- Name: numbers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rodrigo
--

ALTER SEQUENCE public.numbers_id_seq OWNED BY public.numbers.id;


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
    lesson_number integer DEFAULT 4,
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
-- Name: sentence_structure; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.sentence_structure (
    id integer NOT NULL,
    spanish text NOT NULL,
    english text NOT NULL,
    level character varying(50) DEFAULT 'BEGINNER'::character varying NOT NULL,
    display_order integer NOT NULL,
    lesson_number integer DEFAULT 3
);


ALTER TABLE public.sentence_structure OWNER TO rodrigo;

--
-- Name: sentence_structure_id_seq; Type: SEQUENCE; Schema: public; Owner: rodrigo
--

CREATE SEQUENCE public.sentence_structure_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sentence_structure_id_seq OWNER TO rodrigo;

--
-- Name: sentence_structure_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rodrigo
--

ALTER SEQUENCE public.sentence_structure_id_seq OWNED BY public.sentence_structure.id;


--
-- Name: sentence_words; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.sentence_words (
    id integer NOT NULL,
    sentence_id integer,
    word character varying(100) NOT NULL,
    grammar_role character varying(100) NOT NULL,
    translation character varying(100) NOT NULL,
    grammar_note character varying(255),
    display_order integer NOT NULL,
    lesson_number integer DEFAULT 3
);


ALTER TABLE public.sentence_words OWNER TO rodrigo;

--
-- Name: sentence_words_id_seq; Type: SEQUENCE; Schema: public; Owner: rodrigo
--

CREATE SEQUENCE public.sentence_words_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sentence_words_id_seq OWNER TO rodrigo;

--
-- Name: sentence_words_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rodrigo
--

ALTER SEQUENCE public.sentence_words_id_seq OWNED BY public.sentence_words.id;


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
-- Name: time_expressions; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.time_expressions (
    id integer NOT NULL,
    spanish character varying(100) NOT NULL,
    english character varying(100) NOT NULL,
    category character varying(50) NOT NULL,
    level character varying(50) NOT NULL,
    language character varying(5) DEFAULT 'es'::character varying,
    lesson_number integer DEFAULT 5
);


ALTER TABLE public.time_expressions OWNER TO rodrigo;

--
-- Name: time_expressions_id_seq; Type: SEQUENCE; Schema: public; Owner: rodrigo
--

CREATE SEQUENCE public.time_expressions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.time_expressions_id_seq OWNER TO rodrigo;

--
-- Name: time_expressions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rodrigo
--

ALTER SEQUENCE public.time_expressions_id_seq OWNED BY public.time_expressions.id;


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
-- Name: user_lesson_catalog_progress; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.user_lesson_catalog_progress (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    lesson_number integer NOT NULL,
    status character varying(20) DEFAULT 'LOCKED'::character varying,
    score_percentage numeric(5,2),
    xp_earned integer DEFAULT 0,
    attempts integer DEFAULT 0,
    passed boolean DEFAULT false,
    completed_at timestamp without time zone,
    started_at timestamp without time zone,
    CONSTRAINT user_lesson_catalog_progress_lesson_number_check CHECK (((lesson_number >= 1) AND (lesson_number <= 7))),
    CONSTRAINT user_lesson_catalog_progress_status_check CHECK (((status)::text = ANY ((ARRAY['LOCKED'::character varying, 'AVAILABLE'::character varying, 'IN_PROGRESS'::character varying, 'COMPLETED'::character varying])::text[])))
);


ALTER TABLE public.user_lesson_catalog_progress OWNER TO rodrigo;

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
-- Name: user_trouble_items; Type: TABLE; Schema: public; Owner: rodrigo
--

CREATE TABLE public.user_trouble_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    language character varying(5) NOT NULL,
    section character varying(30) NOT NULL,
    reference_type character varying(30),
    reference_id uuid,
    topic_tag character varying(50),
    label_snapshot character varying(255),
    dedupe_key character varying(120) NOT NULL,
    wrong_count integer DEFAULT 1 NOT NULL,
    last_wrong_at timestamp without time zone DEFAULT now(),
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.user_trouble_items OWNER TO rodrigo;

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
    lesson_number integer DEFAULT 2,
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
-- Name: alphabet id; Type: DEFAULT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.alphabet ALTER COLUMN id SET DEFAULT nextval('public.alphabet_id_seq'::regclass);


--
-- Name: colors_descriptions id; Type: DEFAULT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.colors_descriptions ALTER COLUMN id SET DEFAULT nextval('public.colors_descriptions_id_seq'::regclass);


--
-- Name: family_relationships id; Type: DEFAULT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.family_relationships ALTER COLUMN id SET DEFAULT nextval('public.family_relationships_id_seq'::regclass);


--
-- Name: numbers id; Type: DEFAULT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.numbers ALTER COLUMN id SET DEFAULT nextval('public.numbers_id_seq'::regclass);


--
-- Name: sentence_structure id; Type: DEFAULT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.sentence_structure ALTER COLUMN id SET DEFAULT nextval('public.sentence_structure_id_seq'::regclass);


--
-- Name: sentence_words id; Type: DEFAULT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.sentence_words ALTER COLUMN id SET DEFAULT nextval('public.sentence_words_id_seq'::regclass);


--
-- Name: time_expressions id; Type: DEFAULT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.time_expressions ALTER COLUMN id SET DEFAULT nextval('public.time_expressions_id_seq'::regclass);


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
-- Name: alphabet alphabet_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.alphabet
    ADD CONSTRAINT alphabet_pkey PRIMARY KEY (id);


--
-- Name: colors_descriptions colors_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.colors_descriptions
    ADD CONSTRAINT colors_descriptions_pkey PRIMARY KEY (id);


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
-- Name: family_relationships family_relationships_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.family_relationships
    ADD CONSTRAINT family_relationships_pkey PRIMARY KEY (id);


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
-- Name: lesson_catalog lesson_catalog_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.lesson_catalog
    ADD CONSTRAINT lesson_catalog_pkey PRIMARY KEY (lesson_number);


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
-- Name: numbers numbers_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.numbers
    ADD CONSTRAINT numbers_pkey PRIMARY KEY (id);


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
-- Name: sentence_structure sentence_structure_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.sentence_structure
    ADD CONSTRAINT sentence_structure_pkey PRIMARY KEY (id);


--
-- Name: sentence_words sentence_words_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.sentence_words
    ADD CONSTRAINT sentence_words_pkey PRIMARY KEY (id);


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
-- Name: time_expressions time_expressions_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.time_expressions
    ADD CONSTRAINT time_expressions_pkey PRIMARY KEY (id);


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
-- Name: user_lesson_catalog_progress user_lesson_catalog_progress_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.user_lesson_catalog_progress
    ADD CONSTRAINT user_lesson_catalog_progress_pkey PRIMARY KEY (id);


--
-- Name: user_lesson_catalog_progress user_lesson_catalog_progress_user_id_lesson_number_key; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.user_lesson_catalog_progress
    ADD CONSTRAINT user_lesson_catalog_progress_user_id_lesson_number_key UNIQUE (user_id, lesson_number);


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
-- Name: user_trouble_items user_trouble_items_dedupe_uq; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.user_trouble_items
    ADD CONSTRAINT user_trouble_items_dedupe_uq UNIQUE (user_id, language, dedupe_key);


--
-- Name: user_trouble_items user_trouble_items_pkey; Type: CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.user_trouble_items
    ADD CONSTRAINT user_trouble_items_pkey PRIMARY KEY (id);


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
-- Name: idx_ulcp_user_id; Type: INDEX; Schema: public; Owner: rodrigo
--

CREATE INDEX idx_ulcp_user_id ON public.user_lesson_catalog_progress USING btree (user_id);


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
-- Name: sentence_words sentence_words_sentence_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.sentence_words
    ADD CONSTRAINT sentence_words_sentence_id_fkey FOREIGN KEY (sentence_id) REFERENCES public.sentence_structure(id);


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
-- Name: user_lesson_catalog_progress user_lesson_catalog_progress_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.user_lesson_catalog_progress
    ADD CONSTRAINT user_lesson_catalog_progress_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


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
-- Name: user_trouble_items user_trouble_items_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rodrigo
--

ALTER TABLE ONLY public.user_trouble_items
    ADD CONSTRAINT user_trouble_items_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


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

\unrestrict OkZhv7klSvr3Xia7C9Whdd0Na9tElcKGowNawemvVqVjaC4jLC0cgDrnDewKckH

