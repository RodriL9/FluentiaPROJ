-- Run against your Fluentia DB (tracks wrong answers until answered correctly)
CREATE TABLE IF NOT EXISTS user_trouble_items (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    language varchar(10) NOT NULL DEFAULT 'es',
    section varchar(32) NOT NULL,
    reference_type varchar(32) NOT NULL,
    reference_id uuid NULL,
    topic_tag varchar(96) NULL,
    label_snapshot text NULL,
    dedupe_key varchar(220) NOT NULL,
    wrong_count integer NOT NULL DEFAULT 1,
    last_wrong_at timestamp with time zone NOT NULL DEFAULT now(),
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    CONSTRAINT uq_user_trouble_dedupe UNIQUE (user_id, language, dedupe_key)
);

CREATE INDEX IF NOT EXISTS idx_user_trouble_user_lang ON public.user_trouble_items (user_id, language);
