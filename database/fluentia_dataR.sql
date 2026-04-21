--
-- PostgreSQL database dump
--

\restrict 0KaDIfikSrnbaYUYCyG4j0zcSc9Yb5I8GR4LvP7dKAqkLI8YtsjdOMtKFm1whiF

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
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.users (id, full_name, email, username, password_hash, oauth_provider, oauth_id, native_language, learning_language, assigned_level, role, is_verified, account_status, email_verification_token, email_verified_at, password_reset_token, password_reset_expires, is_premium, premium_expires_at, xp, streak_count, last_active_date, last_login_at, login_count, learning_goals, profile_picture_url, onboarding_completed, is_active, joined_at, updated_at) FROM stdin;
cb7b7c8b-987d-4557-b395-d91c017b19ef	Fluentia Admin	admin@fluentia.com	fluentia_admin	$2a$10$1vRUwI0srXp9DZgsygzOXurhKPeQG5AXqWgSFhOvMHKpFT.SnIWfu	\N	\N	en	es	ADVANCED	ADMIN	t	PENDING_VERIFICATION	\N	\N	\N	\N	t	\N	45	1	2026-03-24	2026-03-30 16:07:30.763672	9	\N	\N	t	t	2026-03-14 18:27:35.680554	2026-03-30 16:07:30.763675
a71511fb-db0c-4f97-bc9a-a4d6a735b136	Rodrigo Leites	rodrigonleites2@gmail.com	rodrigonleites2	\N	google	115281974306281077848	en	en	\N	LEARNER	t	ACTIVE	\N	\N	\N	\N	f	\N	0	0	\N	2026-04-16 15:53:22.103788	1	\N	\N	f	t	2026-04-16 15:53:22.103	2026-04-16 15:53:22.103788
00e2433e-b2df-4d86-b0e7-75fff3ab48d3	Test User	test@example.com	testuser	$2a$06$GV73ugUHob2fUIFuUgPMZeJ300gI08oIrMKs1WuUyH4KZOvZ78Sua	\N	\N	en	es	\N	LEARNER	f	PENDING_VERIFICATION	\N	\N	\N	\N	f	\N	0	0	\N	2026-03-14 23:07:12.239684	3	\N	\N	f	t	2026-03-14 22:47:40.168698	2026-03-14 23:07:12.239692
c01b44f7-7a64-48e6-8778-0ae3bdb0d382	Rodrigo	yoyouruguayo@hotmail.com	Rod9	$2a$10$4oJwRePEUwKQ.oYU2Oa6weXEMNVGYWUY8fAsbePpXegmt6CrOrCFm	\N	\N	en	es	BEGINNER	LEARNER	t	ACTIVE	\N	2026-04-16 15:53:57.197555	\N	\N	f	\N	0	0	\N	2026-04-19 22:35:27.639858	4	TRAVEL_ES,BUSINESS_ES	\N	t	t	2026-04-16 15:53:45.198851	2026-04-19 22:35:27.639858
\.


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
-- Data for Name: ai_sessions; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.ai_sessions (id, user_id, language, topic, template_id, session_status, fallback_used, fallback_reason, error_message, avg_response_ms, speech_attempts, speech_failures, grammar_score, vocabulary_score, fluency_score, feedback_summary, started_at, ended_at, total_messages, xp_awarded) FROM stdin;
66b0d1a9-4f11-4932-99af-9cd7b074a61b	cb7b7c8b-987d-4557-b395-d91c017b19ef	es	TRAVEL_ES	7b1adb99-2145-493f-8115-9071c70d7a99	ACTIVE	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-03-24 16:08:55.05156	\N	3	\N
3ce93126-8c72-4878-aef5-e0475e08c2f2	cb7b7c8b-987d-4557-b395-d91c017b19ef	es	TRAVEL_ES	a1558043-a419-4379-8bce-07ceefe2161c	ACTIVE	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-03-24 16:09:52.797124	\N	11	\N
dc63286e-c194-42af-a1cb-dde32d9b1cce	cb7b7c8b-987d-4557-b395-d91c017b19ef	es	TRAVEL_ES	7b1adb99-2145-493f-8115-9071c70d7a99	ACTIVE	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-03-30 16:20:34.33764	\N	5	\N
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
-- Data for Name: alphabet; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.alphabet (id, letter, phonetic_es, phonetic_en, level, lesson_number) FROM stdin;
1	A	ah	ay	BEGINNER	1
2	B	beh	bee	BEGINNER	1
3	C	seh	see	BEGINNER	1
4	D	deh	dee	BEGINNER	1
5	E	eh	ee	BEGINNER	1
6	F	EH-feh	ef	BEGINNER	1
7	G	heh	jee	BEGINNER	1
8	H	AH-cheh	aych	BEGINNER	1
9	I	ee	eye	BEGINNER	1
10	J	HOH-tah	jay	BEGINNER	1
11	K	kah	kay	BEGINNER	1
12	L	EH-leh	el	BEGINNER	1
13	M	EH-meh	em	BEGINNER	1
14	N	EH-neh	en	BEGINNER	1
15	Ñ	EH-nyeh	n/a	BEGINNER	1
16	O	oh	oh	BEGINNER	1
17	P	peh	pee	BEGINNER	1
18	Q	koo	kyoo	BEGINNER	1
19	R	EH-reh	ar	BEGINNER	1
20	S	EH-seh	es	BEGINNER	1
21	T	teh	tee	BEGINNER	1
22	U	oo	yoo	BEGINNER	1
23	V	beh	vee	BEGINNER	1
24	W	DOH-bleh-beh	dub-ul-yoo	BEGINNER	1
25	X	EH-kees	eks	BEGINNER	1
26	Y	ee-GREE-eh-gah	why	BEGINNER	1
27	Z	SEH-tah	zee	BEGINNER	1
28	RR	EH-rreh (rolled r)	n/a - no equivalent	INTERMEDIATE	1
29	LL	EH-yeh (like y)	n/a - no equivalent	INTERMEDIATE	1
30	CH	she (like ch in church)	ch	INTERMEDIATE	1
31	GU	goo (hard g before e/i)	goo	INTERMEDIATE	1
32	QU	keh/kee (k sound)	n/a	INTERMEDIATE	1
33	G	heh before e/i (like h)	n/a	INTERMEDIATE	1
34	C	keh before a/o/u	n/a	INTERMEDIATE	1
35	Z	seh in Latin America	n/a	INTERMEDIATE	1
36	H	always silent in Spanish	n/a	INTERMEDIATE	1
37	V	same as B in Spanish	n/a	INTERMEDIATE	1
38	á	ah (stressed)	n/a	UPPER_INTERMEDIATE	1
39	é	eh (stressed)	n/a	UPPER_INTERMEDIATE	1
40	í	ee (stressed)	n/a	UPPER_INTERMEDIATE	1
41	ó	oh (stressed)	n/a	UPPER_INTERMEDIATE	1
42	ú	oo (stressed)	n/a	UPPER_INTERMEDIATE	1
43	ü	oo (pronounced in güe/güi)	n/a	UPPER_INTERMEDIATE	1
44	¿	opening question mark	n/a	UPPER_INTERMEDIATE	1
45	¡	opening exclamation mark	n/a	UPPER_INTERMEDIATE	1
46	stress rule	words ending in vowel/n/s stress second to last syllable	n/a	UPPER_INTERMEDIATE	1
47	written accent	accent mark overrides natural stress rule	n/a	UPPER_INTERMEDIATE	1
48	seseo	S and Z sound the same in Latin America	n/a	ADVANCED	1
49	ceceo	Z sounds like th in Spain	n/a	ADVANCED	1
50	voseo	vos used instead of tu in Argentina/Uruguay	n/a	ADVANCED	1
51	yeismo	LL and Y sound the same in most regions	n/a	ADVANCED	1
52	aspiracion	S is aspirated or dropped in some dialects	n/a	ADVANCED	1
53	entonacion	rising intonation in questions varies by region	n/a	ADVANCED	1
54	liaison	words link together in spoken Spanish	n/a	ADVANCED	1
55	reduccion	vowels reduce in unstressed syllables	n/a	ADVANCED	1
56	diptongo	two vowels combine into one syllable	n/a	ADVANCED	1
57	triptongo	three vowels combine into one syllable	n/a	ADVANCED	1
\.


--
-- Data for Name: colors_descriptions; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.colors_descriptions (id, spanish, english, category, level, language, lesson_number) FROM stdin;
1	rojo	red	color	BEGINNER	es	6
2	azul	blue	color	BEGINNER	es	6
3	verde	green	color	BEGINNER	es	6
4	amarillo	yellow	color	BEGINNER	es	6
5	negro	black	color	BEGINNER	es	6
6	blanco	white	color	BEGINNER	es	6
7	naranja	orange	color	BEGINNER	es	6
8	morado	purple	color	BEGINNER	es	6
9	rosado	pink	color	BEGINNER	es	6
10	marron	brown	color	BEGINNER	es	6
11	gris	grey	color	BEGINNER	es	6
12	dorado	golden	color	BEGINNER	es	6
13	plateado	silver	color	BEGINNER	es	6
14	celeste	sky blue	color	BEGINNER	es	6
15	beige	beige	color	BEGINNER	es	6
16	grande	big large	size	BEGINNER	es	6
17	pequeno	small little	size	BEGINNER	es	6
18	alto	tall high	size	BEGINNER	es	6
19	bajo	short low	size	BEGINNER	es	6
20	largo	long	size	BEGINNER	es	6
21	corto	short	size	BEGINNER	es	6
22	ancho	wide	size	BEGINNER	es	6
23	delgado	thin slim	size	BEGINNER	es	6
24	gordo	fat chubby	size	BEGINNER	es	6
25	bonito	pretty nice	appearance	BEGINNER	es	6
26	feo	ugly	appearance	BEGINNER	es	6
27	nuevo	new	appearance	BEGINNER	es	6
28	viejo	old	appearance	BEGINNER	es	6
29	limpio	clean	appearance	BEGINNER	es	6
30	sucio	dirty	appearance	BEGINNER	es	6
31	azul marino	navy blue	color	INTERMEDIATE	es	6
32	azul claro	light blue	color	INTERMEDIATE	es	6
33	verde oscuro	dark green	color	INTERMEDIATE	es	6
34	rojo oscuro	dark red	color	INTERMEDIATE	es	6
35	amarillo claro	light yellow	color	INTERMEDIATE	es	6
36	rosa fuerte	hot pink	color	INTERMEDIATE	es	6
37	morado claro	light purple	color	INTERMEDIATE	es	6
38	turquesa	turquoise	color	INTERMEDIATE	es	6
39	coral	coral	color	INTERMEDIATE	es	6
40	oliva	olive	color	INTERMEDIATE	es	6
41	calido	warm	temperature	INTERMEDIATE	es	6
42	frio	cold	temperature	INTERMEDIATE	es	6
43	tibio	lukewarm	temperature	INTERMEDIATE	es	6
44	helado	freezing	temperature	INTERMEDIATE	es	6
45	ardiente	burning hot	temperature	INTERMEDIATE	es	6
46	rapido	fast quick	quality	INTERMEDIATE	es	6
47	lento	slow	quality	INTERMEDIATE	es	6
48	fuerte	strong	quality	INTERMEDIATE	es	6
49	debil	weak	quality	INTERMEDIATE	es	6
50	duro	hard	quality	INTERMEDIATE	es	6
51	suave	soft smooth	quality	INTERMEDIATE	es	6
52	aspero	rough	quality	INTERMEDIATE	es	6
53	liso	smooth flat	quality	INTERMEDIATE	es	6
54	pesado	heavy	quality	INTERMEDIATE	es	6
55	ligero	light lightweight	quality	INTERMEDIATE	es	6
56	ruidoso	noisy loud	quality	INTERMEDIATE	es	6
57	silencioso	quiet silent	quality	INTERMEDIATE	es	6
58	brillante	bright shiny	appearance	INTERMEDIATE	es	6
59	opaco	dull opaque	appearance	INTERMEDIATE	es	6
60	transparente	transparent	appearance	INTERMEDIATE	es	6
61	cromatico	chromatic	color	UPPER_INTERMEDIATE	es	6
62	monocromatico	monochromatic	color	UPPER_INTERMEDIATE	es	6
63	translucido	translucent	color	UPPER_INTERMEDIATE	es	6
64	iridiscente	iridescent	color	UPPER_INTERMEDIATE	es	6
65	fosforescente	phosphorescent	color	UPPER_INTERMEDIATE	es	6
66	vibrante	vibrant	color	UPPER_INTERMEDIATE	es	6
67	tenue	faint dim	color	UPPER_INTERMEDIATE	es	6
68	intenso	intense	color	UPPER_INTERMEDIATE	es	6
69	saturado	saturated	color	UPPER_INTERMEDIATE	es	6
70	desaturado	desaturated	color	UPPER_INTERMEDIATE	es	6
71	imponente	imposing	appearance	UPPER_INTERMEDIATE	es	6
72	esbelto	slender slim	appearance	UPPER_INTERMEDIATE	es	6
73	robusto	robust sturdy	appearance	UPPER_INTERMEDIATE	es	6
74	deteriorado	deteriorated	appearance	UPPER_INTERMEDIATE	es	6
75	impecable	impeccable	appearance	UPPER_INTERMEDIATE	es	6
76	desgastado	worn out	appearance	UPPER_INTERMEDIATE	es	6
77	reluciente	gleaming	appearance	UPPER_INTERMEDIATE	es	6
78	opulento	opulent	appearance	UPPER_INTERMEDIATE	es	6
79	austero	austere	appearance	UPPER_INTERMEDIATE	es	6
80	llamativo	striking flashy	appearance	UPPER_INTERMEDIATE	es	6
81	sutil	subtle	quality	UPPER_INTERMEDIATE	es	6
82	evidente	evident obvious	quality	UPPER_INTERMEDIATE	es	6
83	ambiguo	ambiguous	quality	UPPER_INTERMEDIATE	es	6
84	contradictorio	contradictory	quality	UPPER_INTERMEDIATE	es	6
85	efimero	ephemeral	quality	UPPER_INTERMEDIATE	es	6
86	duradero	lasting durable	quality	UPPER_INTERMEDIATE	es	6
87	versatil	versatile	quality	UPPER_INTERMEDIATE	es	6
88	rigido	rigid	quality	UPPER_INTERMEDIATE	es	6
89	flexible	flexible	quality	UPPER_INTERMEDIATE	es	6
90	fragil	fragile	quality	UPPER_INTERMEDIATE	es	6
91	cromaticamente	chromatically	color	ADVANCED	es	6
92	policromatico	polychromatic	color	ADVANCED	es	6
93	acromatico	achromatic	color	ADVANCED	es	6
94	bicromatico	bichromatic	color	ADVANCED	es	6
95	luminiscente	luminescent	color	ADVANCED	es	6
96	etereo	ethereal	appearance	ADVANCED	es	6
97	efimero	ephemeral	appearance	ADVANCED	es	6
98	trascendente	transcendent	appearance	ADVANCED	es	6
99	paradigmatico	paradigmatic	quality	ADVANCED	es	6
100	inherente	inherent	quality	ADVANCED	es	6
101	intrinseco	intrinsic	quality	ADVANCED	es	6
102	extrinseco	extrinsic	quality	ADVANCED	es	6
103	subjetivo	subjective	quality	ADVANCED	es	6
104	objetivo	objective	quality	ADVANCED	es	6
105	ambivalente	ambivalent	quality	ADVANCED	es	6
106	paradojico	paradoxical	quality	ADVANCED	es	6
107	pragmatico	pragmatic	quality	ADVANCED	es	6
108	holistico	holistic	quality	ADVANCED	es	6
109	sistemico	systemic	quality	ADVANCED	es	6
110	estructural	structural	quality	ADVANCED	es	6
111	funcional	functional	quality	ADVANCED	es	6
112	disfuncional	dysfunctional	quality	ADVANCED	es	6
113	sostenible	sustainable	quality	ADVANCED	es	6
114	vulnerable	vulnerable	quality	ADVANCED	es	6
115	resiliente	resilient	quality	ADVANCED	es	6
116	contundente	forceful	quality	ADVANCED	es	6
117	exhaustivo	exhaustive	quality	ADVANCED	es	6
118	significativo	significant	quality	ADVANCED	es	6
119	trascendental	transcendental	quality	ADVANCED	es	6
120	multidimensional	multidimensional	quality	ADVANCED	es	6
\.


--
-- Data for Name: common_mistakes; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.common_mistakes (id, user_id, mistake_type, reference_id, mistake_count, last_made_at, example_wrong, example_correct, created_at) FROM stdin;
\.


--
-- Data for Name: vocabulary; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.vocabulary (id, word, language, translation, transliteration, part_of_speech, topic_tag, level, example_sentence, example_translation, audio_text, image_keyword, gender, plural_form, conjugation_group, audio_phonetic, phonetic_guide, frequency_rank, accent, regional_variants, tags, is_irregular, notes, created_at, lesson_number) FROM stdin;
373ec324-4c74-480a-859a-4cab1bf941ce	agua	es	water	\N	noun	FOOD_ES	BEGINNER	Quiero agua, por favor.	I want water, please.	agua	water_bottle	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
68be6e3f-02c0-443f-acd4-7beaf5db7235	leche	es	milk	\N	noun	FOOD_ES	BEGINNER	Me gusta la leche fría.	I like cold milk.	leche	milk	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
89f39e10-367a-488e-9d47-2eec59027786	café	es	coffee	\N	noun	FOOD_ES	BEGINNER	El café está caliente.	The coffee is hot.	café	coffee_cup	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
8baee7b2-3afc-4e7d-a61e-ad0fbb00f187	pan	es	bread	\N	noun	FOOD_ES	BEGINNER	El pan está fresco.	The bread is fresh.	pan	bread	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
cacf0fbc-4fcc-4af2-b3f3-a9e5b719df8f	arroz	es	rice	\N	noun	FOOD_ES	BEGINNER	El arroz está listo.	The rice is ready.	arroz	rice_bowl	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
7274a5ba-49d9-4939-b073-2cc6e722a363	pollo	es	chicken	\N	noun	FOOD_ES	BEGINNER	El pollo está delicioso.	The chicken is delicious.	pollo	chicken	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
b34fc942-a428-44b5-8b87-98bec50fb9f2	carne	es	meat/beef	\N	noun	FOOD_ES	BEGINNER	Me gusta la carne asada.	I like grilled meat.	carne	meat	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
64af8df3-3d93-4410-82a8-315ce1790cd0	ensalada	es	salad	\N	noun	FOOD_ES	BEGINNER	La ensalada está fresca.	The salad is fresh.	ensalada	salad	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
1d43709d-0704-4e6f-9907-e17fb51cee60	sopa	es	soup	\N	noun	FOOD_ES	BEGINNER	La sopa está caliente.	The soup is hot.	sopa	soup	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
d29a4384-b091-49e3-87b4-9b5809d4c95e	fruta	es	fruit	\N	noun	FOOD_ES	BEGINNER	La fruta es saludable.	The fruit is healthy.	fruta	fruit	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
7635e185-8a82-4547-9ce7-e3e6b4efbdd3	manzana	es	apple	\N	noun	FOOD_ES	BEGINNER	La manzana es roja.	The apple is red.	manzana	apple	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
1955ed54-5da9-4a79-9e0f-46683186871e	naranja	es	orange	\N	noun	FOOD_ES	BEGINNER	La naranja está dulce.	The orange is sweet.	naranja	orange	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
19046ee8-3966-4d08-b7f7-70812c1a84f5	huevo	es	egg	\N	noun	FOOD_ES	BEGINNER	El huevo está cocido.	The egg is cooked.	huevo	egg	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
f53108f4-c15e-4166-95c7-2e4c73576e5c	queso	es	cheese	\N	noun	FOOD_ES	BEGINNER	El queso es amarillo.	The cheese is yellow.	queso	cheese	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
0a2bcc63-2d6d-4a70-a453-4c54558c030d	jugo	es	juice	\N	noun	FOOD_ES	BEGINNER	El jugo de naranja es rico.	The orange juice is delicious.	jugo	juice	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
01eb10f2-cc80-4b40-b185-ad18abdd3cc3	té	es	tea	\N	noun	FOOD_ES	BEGINNER	El té verde es saludable.	Green tea is healthy.	té	tea_cup	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
68d1eaac-4910-4501-a8af-93906420f928	cerveza	es	beer	\N	noun	FOOD_ES	BEGINNER	Una cerveza fría, por favor.	A cold beer, please.	cerveza	beer	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
9c41bbff-784b-4868-80cd-40180b02654e	vino	es	wine	\N	noun	FOOD_ES	BEGINNER	El vino tinto es delicioso.	The red wine is delicious.	vino	wine	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
774a5d7e-a671-4296-8287-b99f0c780e14	postre	es	dessert	\N	noun	FOOD_ES	BEGINNER	Quiero el postre, por favor.	I want dessert, please.	postre	dessert	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
254fefe5-ef1f-44d9-800f-8ef9b69b85fe	helado	es	ice cream	\N	noun	FOOD_ES	BEGINNER	El helado de chocolate es rico.	Chocolate ice cream is delicious.	helado	ice_cream	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
29029ca4-7979-4489-9e99-2cf682ae98af	hola	es	hello/hi	\N	interjection	CONVERSATION_ES	BEGINNER	Hola, ¿cómo estás?	Hello, how are you?	hola	greeting	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
ae69e806-9df5-4d0b-8b6e-7ad9276945ab	adiós	es	goodbye	\N	interjection	CONVERSATION_ES	BEGINNER	Adiós, hasta luego.	Goodbye, see you later.	adiós	wave	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
5628d973-54ce-4fec-bf15-eff382e2ee8e	buenos días	es	good morning	\N	phrase	CONVERSATION_ES	BEGINNER	Buenos días, señor García.	Good morning, Mr. García.	buenos días	morning	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
90503f4c-c3ae-4f83-a2fd-daafe8a993ff	buenas tardes	es	good afternoon	\N	phrase	CONVERSATION_ES	BEGINNER	Buenas tardes, ¿cómo le va?	Good afternoon, how are you doing?	buenas tardes	afternoon	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
4637a44c-eb47-4504-9674-2c2ca1f2bf1f	buenas noches	es	good night	\N	phrase	CONVERSATION_ES	BEGINNER	Buenas noches, que descanse.	Good night, rest well.	buenas noches	night	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
848d576c-1e80-4757-91c4-f530918f8647	gracias	es	thank you	\N	interjection	CONVERSATION_ES	BEGINNER	Muchas gracias por tu ayuda.	Thank you very much for your help.	gracias	thanks	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
4a823d82-2ecc-4dfd-a63b-9b291bcdf80d	de nada	es	you're welcome	\N	phrase	CONVERSATION_ES	BEGINNER	De nada, con mucho gusto.	You're welcome, with pleasure.	de nada	smile	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
bfa703d3-15ca-4391-ad24-75468e2cbc37	por favor	es	please	\N	adverb	CONVERSATION_ES	BEGINNER	Agua, por favor.	Water, please.	por favor	polite	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
6aaa3dec-e38f-493f-9e31-140fa6664ade	sí	es	yes	\N	adverb	CONVERSATION_ES	BEGINNER	Sí, estoy listo.	Yes, I am ready.	sí	yes	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
13a0dd51-58a9-4d3f-a521-d474396dc7b7	no	es	no	\N	adverb	CONVERSATION_ES	BEGINNER	No, gracias.	No, thank you.	no	no	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
ede6d5f4-2772-4b6d-9090-c46d9cc72a90	perdón	es	excuse me/sorry	\N	interjection	CONVERSATION_ES	BEGINNER	Perdón, ¿puede repetir?	Excuse me, can you repeat?	perdón	sorry	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
c65e818f-268e-48b6-bf9f-91b9e7d51481	me llamo	es	my name is	\N	phrase	CONVERSATION_ES	BEGINNER	Me llamo Carlos.	My name is Carlos.	me llamo	introduction	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
d79b1305-d673-4586-a9c6-1f6299166e3b	mucho gusto	es	nice to meet you	\N	phrase	CONVERSATION_ES	BEGINNER	Mucho gusto en conocerte.	Nice to meet you.	mucho gusto	handshake	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
1706ca35-e4b4-4ec7-bc86-c3dc7f6ddf2d	¿cómo estás?	es	how are you?	\N	phrase	CONVERSATION_ES	BEGINNER	¿Cómo estás hoy?	How are you today?	¿cómo estás?	greeting	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
7df3d936-c898-4ed1-85ee-49cd3e0992f3	bien	es	good/well	\N	adjective	CONVERSATION_ES	BEGINNER	Estoy muy bien, gracias.	I am very well, thank you.	bien	happy	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
8ba563bc-0a3b-4ebc-acd7-944b7f3899c4	mal	es	bad/not well	\N	adjective	CONVERSATION_ES	BEGINNER	Estoy un poco mal hoy.	I am a little unwell today.	mal	sick	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
d185dd75-058a-4521-9bda-60bf8655de9a	más o menos	es	so-so	\N	phrase	CONVERSATION_ES	BEGINNER	Estoy más o menos.	I am so-so.	más o menos	so_so	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
6eed9445-188a-42b9-8070-3747cf68a93e	uno	es	one	\N	number	GRAMMAR_ES	BEGINNER	Tengo un hijo.	I have one son.	uno	number_1	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
6e4e097d-14b7-4f37-a144-2640333f2f96	dos	es	two	\N	number	GRAMMAR_ES	BEGINNER	Tengo dos perros.	I have two dogs.	dos	number_2	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
4a845217-63ef-4f3a-a737-3e09631e58a9	tres	es	three	\N	number	GRAMMAR_ES	BEGINNER	Hay tres personas aquí.	There are three people here.	tres	number_3	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
1e9032d2-1228-4322-9c81-6385cff5109d	cuatro	es	four	\N	number	GRAMMAR_ES	BEGINNER	Son las cuatro.	It is four o'clock.	cuatro	number_4	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
783d1d04-debe-4094-ad76-f6fc37cd520c	cinco	es	five	\N	number	GRAMMAR_ES	BEGINNER	Tengo cinco libros.	I have five books.	cinco	number_5	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
6324f19b-5209-4573-b4be-46ca6088daa1	diez	es	ten	\N	number	GRAMMAR_ES	BEGINNER	Son diez dólares.	It is ten dollars.	diez	number_10	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
8102c7bc-176c-4a7d-8cc8-63bfe5cc440a	veinte	es	twenty	\N	number	GRAMMAR_ES	BEGINNER	Tengo veinte años.	I am twenty years old.	veinte	number_20	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
2a382745-89c0-4b6f-a9de-c8bec975107c	cien	es	one hundred	\N	number	GRAMMAR_ES	BEGINNER	Hay cien estudiantes.	There are one hundred students.	cien	number_100	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
fc2af132-6e75-41b0-8ddd-e4b7b15d2ada	aeropuerto	es	airport	\N	noun	TRAVEL_ES	BEGINNER	El aeropuerto está lejos.	The airport is far.	aeropuerto	airport	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
5a3aaf80-158e-414e-b4eb-902594b00801	hotel	es	hotel	\N	noun	TRAVEL_ES	BEGINNER	El hotel está cerca.	The hotel is nearby.	hotel	hotel	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
0ff60469-f027-4348-97c9-0e836c5af3d7	restaurante	es	restaurant	\N	noun	TRAVEL_ES	BEGINNER	El restaurante es bueno.	The restaurant is good.	restaurante	restaurant	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
552be32b-832a-4079-b9a7-47f0b1d5d9cc	taxi	es	taxi/cab	\N	noun	TRAVEL_ES	BEGINNER	Necesito un taxi.	I need a taxi.	taxi	taxi	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
ba67cafd-4641-4085-9859-6414ded33dcf	tren	es	train	\N	noun	TRAVEL_ES	BEGINNER	El tren llega a las dos.	The train arrives at two.	tren	train	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
289c96bf-c193-4f05-8cb7-f4665b524254	autobús	es	bus	\N	noun	TRAVEL_ES	BEGINNER	El autobús está lleno.	The bus is full.	autobús	bus	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
dc0abf55-9bd7-4483-bd3d-048aa9a89bdc	pasaporte	es	passport	\N	noun	TRAVEL_ES	BEGINNER	Necesito mi pasaporte.	I need my passport.	pasaporte	passport	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
956c6c8d-2d7b-4b05-a75f-a8eaa75c0f10	maleta	es	suitcase	\N	noun	TRAVEL_ES	BEGINNER	Mi maleta es pesada.	My suitcase is heavy.	maleta	suitcase	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
109650e0-e27d-451e-9de2-a37121a47b6e	billete	es	ticket	\N	noun	TRAVEL_ES	BEGINNER	Necesito un billete de ida.	I need a one-way ticket.	billete	ticket	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
3a902892-ea71-4f57-baf9-36d5f753543f	izquierda	es	left	\N	noun	TRAVEL_ES	BEGINNER	Gire a la izquierda.	Turn left.	izquierda	left_arrow	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
ead75fba-93e4-4c88-a7dc-b32ed7b01862	derecha	es	right	\N	noun	TRAVEL_ES	BEGINNER	Gire a la derecha.	Turn right.	derecha	right_arrow	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
30c473a8-5277-405c-b3b3-06c6bc3fd092	recto	es	straight ahead	\N	adverb	TRAVEL_ES	BEGINNER	Siga recto.	Go straight ahead.	recto	straight	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
03ddefc3-7033-42f6-8b40-7c0807e8a832	cerca	es	near/close	\N	adverb	TRAVEL_ES	BEGINNER	El hotel está cerca.	The hotel is close.	cerca	near	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
9a20789e-6b11-4644-bbfa-f0588872eb32	lejos	es	far	\N	adverb	TRAVEL_ES	BEGINNER	El aeropuerto está lejos.	The airport is far.	lejos	far	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
e30aeb37-9314-4a2e-aba4-aa44ad37d2d1	ser	es	to be (permanent)	\N	verb	GRAMMAR_ES	BEGINNER	Soy estudiante.	I am a student.	ser	identity	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
bcd1ef20-9b9f-49d1-9066-a65feeb2bbd4	estar	es	to be (temporary)	\N	verb	GRAMMAR_ES	BEGINNER	Estoy cansado.	I am tired.	estar	state	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
b1e3e497-c5ae-4935-b773-719bfdcfe645	tener	es	to have	\N	verb	GRAMMAR_ES	BEGINNER	Tengo un carro.	I have a car.	tener	have	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
6e74b698-6087-46f0-81ff-6fc5b4e126f0	querer	es	to want	\N	verb	GRAMMAR_ES	BEGINNER	Quiero café.	I want coffee.	querer	want	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
e5fe9372-d39f-4076-9e11-2a6dea2b868d	necesitar	es	to need	\N	verb	GRAMMAR_ES	BEGINNER	Necesito ayuda.	I need help.	necesitar	need	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
d29e534f-9333-4299-8529-40d4681acf5a	hablar	es	to speak/talk	\N	verb	GRAMMAR_ES	BEGINNER	Hablo español un poco.	I speak Spanish a little.	hablar	speaking	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
53a3b16a-6fad-45fc-bef4-c39c0a60a1fd	comer	es	to eat	\N	verb	GRAMMAR_ES	BEGINNER	Como arroz todos los días.	I eat rice every day.	comer	eating	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
fd5f5b4f-0efe-4574-8557-8650f411fad3	beber	es	to drink	\N	verb	GRAMMAR_ES	BEGINNER	Bebo agua.	I drink water.	beber	drinking	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
dfbcc480-2cb4-4378-ab97-434c9519f4dd	ir	es	to go	\N	verb	GRAMMAR_ES	BEGINNER	Voy al trabajo.	I go to work.	ir	going	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
3009a81f-f9d9-47a5-aaae-2f4ea8383672	vivir	es	to live	\N	verb	GRAMMAR_ES	BEGINNER	Vivo en Nueva York.	I live in New York.	vivir	home	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
0ac39b91-813d-469d-a7a1-846b82780ce5	llamarse	es	to be called/named	\N	verb	GRAMMAR_ES	BEGINNER	Me llamo Ana.	My name is Ana.	llamarse	name	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
b8ef52ff-7e40-4770-ac27-513d39027360	entender	es	to understand	\N	verb	GRAMMAR_ES	BEGINNER	No entiendo.	I do not understand.	entender	confused	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
5dc06fc8-2677-48da-bb57-719cb7840ac5	saber	es	to know	\N	verb	GRAMMAR_ES	BEGINNER	No sé la respuesta.	I do not know the answer.	saber	thinking	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
57d66110-d3a8-4155-bae6-24b1996c0607	poder	es	to be able to/can	\N	verb	GRAMMAR_ES	BEGINNER	¿Puedo pagar aquí?	Can I pay here?	poder	ability	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
f613e5ab-8ddb-460f-b0b6-2f34c123f885	pedir	es	to ask for/order	\N	verb	GRAMMAR_ES	BEGINNER	Quiero pedir la cuenta.	I want to ask for the check.	pedir	ordering	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
f44bba8e-3779-4942-ac88-877c954f572f	hombre	es	man	\N	noun	CONVERSATION_ES	BEGINNER	El hombre es alto.	The man is tall.	hombre	man	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
bfe9516e-2f08-4e0f-b09f-0795c606b2de	mujer	es	woman	\N	noun	CONVERSATION_ES	BEGINNER	La mujer es inteligente.	The woman is intelligent.	mujer	woman	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
a4183f51-15be-42e2-b6e1-2e189924afc2	niño	es	boy/child	\N	noun	CONVERSATION_ES	BEGINNER	El niño juega en el parque.	The boy plays in the park.	niño	boy	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
53ace493-3bd6-42c9-a728-e4c86263bd50	niña	es	girl/child	\N	noun	CONVERSATION_ES	BEGINNER	La niña es simpática.	The girl is nice.	niña	girl	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
aa93b66e-d542-4380-bd5e-1a261edf9cbd	familia	es	family	\N	noun	CONVERSATION_ES	BEGINNER	Mi familia es grande.	My family is big.	familia	family	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
7208ee26-dd18-4295-a28d-2e656f1b71c4	madre	es	mother	\N	noun	CONVERSATION_ES	BEGINNER	Mi madre es doctora.	My mother is a doctor.	madre	mother	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
c5766e68-bff4-413a-bba9-afd97cddfe98	padre	es	father	\N	noun	CONVERSATION_ES	BEGINNER	Mi padre trabaja mucho.	My father works a lot.	padre	father	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
0d14df8a-a655-4087-a06e-8651270b3398	amigo	es	friend (m)	\N	noun	CONVERSATION_ES	BEGINNER	Mi amigo se llama Pedro.	My friend's name is Pedro.	amigo	friends	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
106a2837-a4c5-4bfc-bc3a-3bb8620b94c6	amiga	es	friend (f)	\N	noun	CONVERSATION_ES	BEGINNER	Mi amiga es muy lista.	My friend is very smart.	amiga	friends	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
30862388-cc05-497f-9d72-90b7bcf7c20d	reunión	es	meeting	\N	noun	BUSINESS_ES	INTERMEDIATE	La reunión empieza a las nueve.	The meeting starts at nine.	reunión	meeting	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
0c845780-d15e-496c-82e0-61bc4b15f19b	empresa	es	company/firm	\N	noun	BUSINESS_ES	INTERMEDIATE	Trabajo en una empresa grande.	I work in a big company.	empresa	company	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
956930b7-3926-40dd-bb42-f8ba3d878a88	jefe	es	boss/manager	\N	noun	BUSINESS_ES	INTERMEDIATE	Mi jefe es muy exigente.	My boss is very demanding.	jefe	boss	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
eb013e9a-b0e5-4ba3-a6ab-b4548e9616b0	cliente	es	client/customer	\N	noun	BUSINESS_ES	INTERMEDIATE	El cliente siempre tiene razón.	The customer is always right.	cliente	customer	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
681f2ede-b681-4357-a3eb-6d75537cd5a3	contrato	es	contract	\N	noun	BUSINESS_ES	INTERMEDIATE	Firmé el contrato ayer.	I signed the contract yesterday.	contrato	contract	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
bbfb9567-c1ed-462f-a3b8-1398f822141c	trabajar	es	to work	\N	verb	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
5409c65d-6289-44e5-9e0c-c3453277eb39	presentación	es	presentation	\N	noun	BUSINESS_ES	INTERMEDIATE	Mi presentación es mañana.	My presentation is tomorrow.	presentación	presentation	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
0d4d8440-7898-4725-810f-a7da68a3c95b	correo electrónico	es	email	\N	noun	BUSINESS_ES	INTERMEDIATE	Te envío un correo electrónico.	I'll send you an email.	correo electrónico	email	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
dbdcef6b-7c11-4aaa-8d16-4139a4491821	presupuesto	es	budget	\N	noun	BUSINESS_ES	INTERMEDIATE	El presupuesto es limitado.	The budget is limited.	presupuesto	budget	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
a87d96bc-d963-49db-a28c-e556e49014cd	factura	es	invoice	\N	noun	BUSINESS_ES	INTERMEDIATE	Necesito la factura, por favor.	I need the invoice, please.	factura	invoice	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
8db70829-7426-4670-b6f6-91f288e1796a	negocio	es	business/deal	\N	noun	BUSINESS_ES	INTERMEDIATE	El negocio va bien.	The business is going well.	negocio	business	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
8f01a00e-7f90-4279-b94d-5e6950fb908f	doctor	es	doctor	\N	noun	HEALTH_ES	INTERMEDIATE	Necesito ver al doctor.	I need to see the doctor.	doctor	doctor	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
4993b711-eefa-4f92-bda3-c2dbf99e30e0	hospital	es	hospital	\N	noun	HEALTH_ES	INTERMEDIATE	El hospital está a dos cuadras.	The hospital is two blocks away.	hospital	hospital	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
d8d2dd71-c67d-492a-9951-5c2064934448	medicina	es	medicine	\N	noun	HEALTH_ES	INTERMEDIATE	Necesito esta medicina.	I need this medicine.	medicina	medicine	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
f4561431-224b-493c-9e83-cf497c7f9440	dolor	es	pain/ache	\N	noun	HEALTH_ES	INTERMEDIATE	Tengo dolor de cabeza.	I have a headache.	dolor	pain	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
a103efdf-089f-4793-a029-4542997b3f0f	fiebre	es	fever	\N	noun	HEALTH_ES	INTERMEDIATE	Tengo fiebre alta.	I have a high fever.	fiebre	thermometer	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
d45866ad-1656-43f8-9355-0c2d5c1a92ca	alergia	es	allergy	\N	noun	HEALTH_ES	INTERMEDIATE	Tengo alergia al maní.	I am allergic to peanuts.	alergia	allergy	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
dfaf2e54-679e-4351-9ba7-8ddf66da2643	farmacia	es	pharmacy	\N	noun	HEALTH_ES	INTERMEDIATE	La farmacia está abierta.	The pharmacy is open.	farmacia	pharmacy	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
630bda0d-a9fc-41cb-8fb0-0c710340aae0	emergencia	es	emergency	\N	noun	HEALTH_ES	INTERMEDIATE	Es una emergencia médica.	It is a medical emergency.	emergencia	emergency	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
627c3679-8d6e-4df5-a1bc-4bc0baf2110e	sin embargo	es	however/nevertheless	\N	conjunction	GRAMMAR_ES	UPPER_INTERMEDIATE	Es difícil; sin embargo, es posible.	It is difficult; however, it is possible.	sin embargo	contrast	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
7684bcc7-049e-4c7f-83dc-b0a189a68c87	aunque	es	although/even though	\N	conjunction	GRAMMAR_ES	UPPER_INTERMEDIATE	Aunque llueve, salgo.	Although it rains, I go out.	aunque	contrast	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
96e176f7-5f9b-4673-878d-175147a5634e	puesto que	es	since/because	\N	conjunction	GRAMMAR_ES	UPPER_INTERMEDIATE	Puesto que no hay tiempo, apuremos.	Since there is no time, let us hurry.	puesto que	reason	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
3aebab67-e4eb-4ad9-ae7f-e498433ddd67	a pesar de	es	in spite of	\N	phrase	GRAMMAR_ES	UPPER_INTERMEDIATE	A pesar del frío, salimos.	In spite of the cold, we went out.	a pesar de	despite	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
1a5f3738-c365-4cc6-a131-cc0910e17674	por lo tanto	es	therefore/thus	\N	conjunction	GRAMMAR_ES	UPPER_INTERMEDIATE	Estudió mucho; por lo tanto, aprobó.	He studied hard; therefore, he passed.	por lo tanto	result	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
195b316b-c68c-44f6-981b-c86ae204eb61	sostenible	es	sustainable	\N	adjective	BUSINESS_ES	ADVANCED	Necesitamos un modelo sostenible.	We need a sustainable model.	sostenible	sustainability	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
2787f114-73bd-4ba1-8fd0-a43fbb5bc0f1	implementar	es	to implement	\N	verb	BUSINESS_ES	ADVANCED	Vamos a implementar la estrategia.	We are going to implement the strategy.	implementar	implementation	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
f507be1e-20e1-411b-957e-bdccd9a88afa	promover	es	to promote	\N	verb	BUSINESS_ES	ADVANCED	Debemos promover la innovación.	We must promote innovation.	promover	promote	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
e960c344-78eb-438b-acb6-45a1addbf298	perspectiva	es	perspective	\N	noun	BUSINESS_ES	ADVANCED	Desde mi perspectiva, es correcto.	From my perspective, it is correct.	perspectiva	perspective	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
6797d1ff-2ece-452e-aa74-759754df685e	estrategia	es	strategy	\N	noun	BUSINESS_ES	ADVANCED	La estrategia es efectiva.	The strategy is effective.	estrategia	strategy	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-03-14 18:27:35.669207	2
7964be0f-8745-4bd6-9726-6cdaaa45a011	estudiar	es	to study	\N	verb	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
475f02e8-ee8f-414d-9405-b109c6710c64	aprender	es	to learn	\N	verb	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
ddb52f71-06e2-4852-a030-53226b8ae6df	explicar	es	to explain	\N	verb	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
e6b09bdc-a116-4f10-b90c-084acfec3a40	ayudar	es	to help	\N	verb	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
036a69f8-7945-424d-9bb2-fc76f79a3f20	cambiar	es	to change	\N	verb	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
906bccb4-7801-41d1-a9aa-91272ebf0090	conseguir	es	to get/achieve	\N	verb	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
7c6be0e0-938e-480a-8fd7-63ac8f336f4b	decidir	es	to decide	\N	verb	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
a1f188fd-ca59-43a7-a4eb-c44b829fc08a	esperar	es	to wait/hope	\N	verb	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
c841bfaa-8f93-454b-835f-f1d9d2a2a36d	intentar	es	to try	\N	verb	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
96feaf11-b3a4-4463-b42c-f4b08c1c35bc	cansado	es	tired	\N	adjective	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
840e90f5-3350-4d28-8f7c-70d5cc5e5762	enfermo	es	sick/ill	\N	adjective	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
a8432318-481d-4d96-a521-7968113fae40	ocupado	es	busy	\N	adjective	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
92615fae-9fd2-49ed-abe7-e4419bcb1c4e	seguro	es	safe/sure	\N	adjective	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
ba7fbe10-6fd0-4009-bd21-9380995956fd	difícil	es	difficult	\N	adjective	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
5ff26261-7aca-4223-9649-41e2d17c69e4	fácil	es	easy	\N	adjective	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
bc644ca7-472f-46b0-a51d-413c475e87c4	importante	es	important	\N	adjective	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
c35ca1e5-2bd7-41cf-ba6a-84efe565b545	posible	es	possible	\N	adjective	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
8fd4c097-d244-4fec-8274-4fcfca0d211e	diferente	es	different	\N	adjective	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
43d37218-016b-485a-9585-91f0eb5d04c0	siguiente	es	next/following	\N	adjective	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
a3a9c9ef-55b6-4286-9bdf-ac585a891249	cuenta	es	bill/account	\N	noun	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
dbe2c190-05db-4218-99c7-4300d94abed0	dirección	es	address/direction	\N	noun	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
5da8c199-d8f8-4780-bcf5-401247e8aa93	horario	es	schedule/timetable	\N	noun	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
c0f32dfc-ba4a-45e3-a304-0120e9371226	idioma	es	language	\N	noun	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
af50bb54-b095-46f8-863f-ed1382f56e11	llamada	es	phone call	\N	noun	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
963f8c7b-6fe4-40d3-b771-039931b256ba	mensaje	es	message	\N	noun	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
1f03b6bd-c926-476d-9ad7-201b3b9c501a	precio	es	price	\N	noun	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
d775c532-b4ad-4276-bbf7-2f6d439a4a7a	problema	es	problem	\N	noun	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
3d908da0-1a4d-4f35-a69c-ceb81604e81a	resultado	es	result	\N	noun	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
84bba27a-8478-49c2-a9fe-e134658d8bf3	situación	es	situation	\N	noun	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
764aa9c2-50c2-474a-8177-065b990218d8	¿cuánto cuesta?	es	how much does it cost?	\N	phrase	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
477ee4b4-577f-4036-bbc8-01ebdd978a47	¿dónde está?	es	where is it?	\N	phrase	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
998dd8c0-dbe2-442c-8c79-0e39cc85f084	no entiendo	es	I don't understand	\N	phrase	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
87908dab-f5e0-46af-9915-9a3f26a5705d	¿puede repetir?	es	can you repeat that?	\N	phrase	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
b75a159e-eaab-42a9-8698-fbf342183096	tengo una reserva	es	I have a reservation	\N	phrase	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
8fa9fb6f-cac3-4d10-bb15-5790424f7869	me duele	es	it hurts me	\N	phrase	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
da365ef9-a544-4558-b156-0b7907d81ad0	necesito ayuda	es	I need help	\N	phrase	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
0d887dd2-ac4c-4707-a269-a85296ba1d7f	¿a qué hora?	es	at what time?	\N	phrase	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
105aa69d-342e-4e75-a63c-d02a386abb51	está bien	es	it's okay/fine	\N	phrase	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
3c622609-18d8-4f09-8d54-84b3887731ac	lo siento	es	I'm sorry	\N	phrase	\N	INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.005386	2
c466bb59-37f9-4834-baa5-ed4c099131c4	alcanzar	es	to reach/achieve	\N	verb	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
7b034db4-4ce6-4a1d-8d99-13564b365a9c	analizar	es	to analyze	\N	verb	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
c202f2b7-68b3-4497-8f62-6bf22ac32d2a	comparar	es	to compare	\N	verb	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
8a9617a9-2e8b-4dfe-bc0d-0ce750cc0189	considerar	es	to consider	\N	verb	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
e8f08af5-1d31-4cf9-8e3d-2945a525ee5d	desarrollar	es	to develop	\N	verb	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
806c710b-cddf-4ae9-882b-b30b942f1136	establecer	es	to establish	\N	verb	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
6bc701f9-8ac8-470a-b76f-95f0a1a51305	evaluar	es	to evaluate	\N	verb	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
978af768-8610-4cca-9237-2953f5b0d505	generar	es	to generate	\N	verb	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
5e9dbdab-f455-4a2b-83ce-a1247b8f15f8	mantener	es	to maintain	\N	verb	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
aa615732-3eb0-440e-9359-80ce19a126ad	mejorar	es	to improve	\N	verb	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
e16d97a1-67b3-4e66-adfd-8c95a45538ce	adecuado	es	adequate/suitable	\N	adjective	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
e260cd1a-25c9-42d4-82bf-cb07e44e239c	ambiguo	es	ambiguous	\N	adjective	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
ab5ce6b4-8bc7-4965-9bc9-81c6a0c60f53	complejo	es	complex	\N	adjective	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
098e4a71-32eb-45e9-8a7e-19cffb07f76e	consistente	es	consistent	\N	adjective	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
670d9c84-de35-4068-b50f-071a5908b572	eficiente	es	efficient	\N	adjective	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
636d5a0d-52ae-4474-b927-be9cd01ef4c4	flexible	es	flexible	\N	adjective	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
d124f789-c940-45da-a495-ecda9ae5398a	relevante	es	relevant	\N	adjective	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
fe6d58a2-daa9-4040-9f14-74266e6fd6c2	significativo	es	significant	\N	adjective	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
39223ec4-b85e-488a-9169-f21e0eab5f5d	específico	es	specific	\N	adjective	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
be285cb8-353a-409c-996d-f1f8b5613c4a	adecuado	es	appropriate	\N	adjective	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
cf0522d0-df1c-4fd3-b987-d7c32b87a9cd	acuerdo	es	agreement	\N	noun	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
20203143-f3c7-4f7f-8c9b-f07c4c43eec5	ambiente	es	environment/atmosphere	\N	noun	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
bd2d9cec-1a33-47e7-80bd-d7556b915959	beneficio	es	benefit	\N	noun	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
8a346e71-5fc7-45e7-a58a-f88f7831b5de	capacidad	es	capacity/ability	\N	noun	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
d602b6e2-2b53-4a91-98a3-725a80468bad	consecuencia	es	consequence	\N	noun	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
7177baa8-2d77-4465-8cf0-d647c8363ba3	contexto	es	context	\N	noun	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
40565b89-e779-48f5-96d0-2e06eb2bcd6c	tomate	es	tomato	\N	noun	FOOD_ES	BEGINNER	Los tomates están maduros.	The tomatoes are ripe.	tomate	\N	\N	\N	\N	\N	to-MA-te	45	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894	2
5b965d4d-be9d-4681-9501-66e332bc3142	cebolla	es	onion	\N	noun	FOOD_ES	BEGINNER	Necesito una cebolla.	I need an onion.	cebolla	\N	\N	\N	\N	\N	se-BO-ya	52	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894	2
498a914f-fcbe-43ae-aea6-87727ce45ff0	lechuga	es	lettuce	\N	noun	FOOD_ES	BEGINNER	La lechuga está fresca.	The lettuce is fresh.	lechuga	\N	\N	\N	\N	\N	le-CHU-ga	58	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894	2
3a866466-1e69-4f7c-9691-afe3dfe6bc42	zanahoria	es	carrot	\N	noun	FOOD_ES	BEGINNER	Las zanahorias son saludables.	Carrots are healthy.	zanahoria	\N	\N	\N	\N	\N	sa-na-O-ria	61	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894	2
1ea7a9c6-9f55-48b2-8594-f60d6dd07cb1	desafío	es	challenge	\N	noun	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
4f73b489-e40a-42eb-9914-a879f3848818	estructura	es	structure	\N	noun	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
53341386-d7c5-40fd-bc90-b486b906d761	impacto	es	impact	\N	noun	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
b7046db6-a111-4cd9-81d1-ee46453d0719	proceso	es	process	\N	noun	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
dbf14e74-8841-4484-b75f-e970cfdaf64d	en cuanto a	es	regarding/as for	\N	phrase	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
8cb37d3b-3f29-40b0-b15d-d7bef216598f	hay que tener en cuenta	es	you have to take into account	\N	phrase	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
cb7ed1d4-8f35-4dd6-a06a-de0dca112dc2	por otro lado	es	on the other hand	\N	phrase	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
39c96dcf-968d-4ed4-a3e8-b3477e9273c8	en primer lugar	es	in the first place	\N	phrase	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
0305b1d9-1ec2-45cf-af6e-528c4a052caa	a diferencia de	es	unlike/in contrast to	\N	phrase	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
a7c28bd8-d361-46e6-9cbf-53a70420b31e	cabe destacar	es	it is worth noting	\N	phrase	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
e6a501e4-864d-4eec-9122-199b1357d19a	en términos de	es	in terms of	\N	phrase	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
25937039-9cfa-45eb-8637-5ecd5edaffd4	lo que es más	es	what is more	\N	phrase	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
00673b3c-8553-47d9-84b5-e3a2002c60da	a lo largo de	es	throughout/along	\N	phrase	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
77562400-e870-4fe0-8ed6-b9655c8efccf	con respecto a	es	with respect to	\N	phrase	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
be9db0d8-6f03-44d2-a1f3-ea66a434168a	dado que	es	given that	\N	conjunction	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
6691eb4e-cfaa-4491-a531-2fb998736627	mientras que	es	while/whereas	\N	conjunction	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
54d316db-09d7-4f9f-ad01-cdedd0299e43	siempre que	es	as long as	\N	conjunction	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
bbdcda40-37c9-4f17-b1c6-7d8db94b077a	papa	es	potato	\N	noun	FOOD_ES	BEGINNER	Me gustan las papas fritas.	I like french fries.	papa	\N	\N	\N	\N	\N	PA-pa	48	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894	2
a977c182-3ad4-4336-8b35-a187cde05985	aguacate	es	avocado	\N	noun	FOOD_ES	BEGINNER	El aguacate está verde.	The avocado is green.	aguacate	\N	\N	\N	\N	\N	a-gua-CA-te	65	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894	2
75e8727f-f36e-4276-bb12-281fb1f49133	limón	es	lemon	\N	noun	FOOD_ES	BEGINNER	Quiero un limón.	I want a lemon.	limón	\N	\N	\N	\N	\N	li-MON	55	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894	2
ff05924c-736d-4859-830b-36fe38233c1b	plátano	es	banana	\N	noun	FOOD_ES	BEGINNER	Los plátanos están dulces.	The bananas are sweet.	plátano	\N	\N	\N	\N	\N	PLA-ta-no	50	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894	2
8951fbb9-5ee8-4413-97f2-849d59735ac6	uva	es	grape	\N	noun	FOOD_ES	BEGINNER	Las uvas son deliciosas.	Grapes are delicious.	uva	\N	\N	\N	\N	\N	U-va	62	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894	2
7c5ed7ff-a847-4afe-b401-e47b62f58a3b	fresa	es	strawberry	\N	noun	FOOD_ES	BEGINNER	Me encantan las fresas.	I love strawberries.	fresa	\N	\N	\N	\N	\N	FRE-sa	59	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894	2
722ebf6a-db03-4027-a926-1362bb857242	equipaje	es	luggage	\N	noun	TRAVEL_ES	BEGINNER	Mi equipaje está en el avión.	My luggage is on the plane.	equipaje	\N	\N	\N	\N	\N	e-ki-PA-he	72	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894	2
a8ac6f19-0163-4d7d-b727-cc343bf00c59	facturación	es	check-in	\N	noun	TRAVEL_ES	INTERMEDIATE	La facturación cierra en una hora.	Check-in closes in one hour.	facturación	\N	\N	\N	\N	\N	fac-tu-ra-ci-ON	85	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894	2
e3c84eb7-134e-4511-9d15-d2e48eeb76e7	embarque	es	boarding	\N	noun	TRAVEL_ES	INTERMEDIATE	El embarque empieza a las diez.	Boarding starts at ten.	embarque	\N	\N	\N	\N	\N	em-BAR-ke	88	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894	2
1d86f93f-3900-4101-bc73-114b614da9d9	reserva	es	reservation	\N	noun	TRAVEL_ES	INTERMEDIATE	Tengo una reserva a nombre de García.	I have a reservation under García.	reserva	\N	\N	\N	\N	\N	re-SER-va	75	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894	2
6c3262da-a091-4064-8bac-da11f9a742ba	habitación	es	room	\N	noun	TRAVEL_ES	BEGINNER	Quiero una habitación doble.	I want a double room.	habitación	\N	\N	\N	\N	\N	a-bi-ta-ci-ON	68	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894	2
500a391c-cada-41f3-981f-509b3e20cc9d	recepción	es	reception	\N	noun	TRAVEL_ES	BEGINNER	La recepción está abierta 24 horas.	Reception is open 24 hours.	recepción	\N	\N	\N	\N	\N	re-sep-ci-ON	78	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894	2
ad6eb35b-4a8e-491a-a9af-12f86aa97c09	proyecto	es	project	\N	noun	BUSINESS_ES	INTERMEDIATE	El proyecto está casi terminado.	The project is almost finished.	proyecto	\N	\N	\N	\N	\N	pro-YEC-to	42	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894	2
aa76bb57-c383-4cd7-8a18-4481e91bc09c	a menos que	es	unless	\N	conjunction	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
17ff7458-5aa3-404e-bf3b-021976b0379f	informe	es	report	\N	noun	BUSINESS_ES	INTERMEDIATE	Necesito el informe antes del viernes.	I need the report before Friday.	informe	\N	\N	\N	\N	\N	in-FOR-me	55	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894	2
ef604988-e4aa-40a0-b6cf-e0c0ac7aad5b	objetivo	es	objective	\N	noun	BUSINESS_ES	INTERMEDIATE	Nuestro objetivo es aumentar ventas.	Our objective is to increase sales.	objetivo	\N	\N	\N	\N	\N	ob-he-TI-vo	48	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894	2
01e4efda-a5a1-4dae-8aad-57970f00fc8c	enfermera	es	nurse	\N	noun	HEALTH_ES	BEGINNER	La enfermera toma la presión.	The nurse takes the blood pressure.	enfermera	\N	\N	\N	\N	\N	en-fer-ME-ra	70	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894	2
546b0e70-ad0e-43a7-98fb-05bfb9f5b38d	receta	es	prescription	\N	noun	HEALTH_ES	INTERMEDIATE	Necesito una receta médica.	I need a medical prescription.	receta	\N	\N	\N	\N	\N	re-SE-ta	65	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894	2
cb760242-a77f-4452-a502-f491dd3b967d	inyección	es	injection	\N	noun	HEALTH_ES	INTERMEDIATE	El doctor me puso una inyección.	The doctor gave me an injection.	inyección	\N	\N	\N	\N	\N	in-yec-ci-ON	82	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894	2
4aad11dd-e99e-4a55-91f1-b9cfb58f298f	para que	es	so that/in order that	\N	conjunction	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
1227388e-5eb0-4047-8b7d-70ac73b5336f	preguntar	es	to ask	\N	verb	CONVERSATION_ES	BEGINNER	¿Puedo preguntar algo?	Can I ask something?	preguntar	\N	\N	\N	\N	\N	pregun-TAR	30	LATIN_AMERICAN	\N	\N	f	\N	2026-03-15 04:05:54.042894	2
01664d71-7ecf-47d2-926e-ec1017ed303b	en caso de que	es	in case	\N	conjunction	\N	UPPER_INTERMEDIATE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.012556	2
7fb10548-ab58-4fcf-b0b8-0d78eeff9040	abordar	es	to tackle/address	\N	verb	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
9ff48f45-907b-4adb-8da6-bb770bd15206	asumir	es	to assume	\N	verb	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
12478859-63cd-41d9-8ef1-3f31d645792e	contemplar	es	to contemplate	\N	verb	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
c75b8c8b-725e-42c2-bc86-bdd5d046e8d0	contrastar	es	to contrast	\N	verb	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
154acea2-2644-45e5-9880-7be09b937989	debatir	es	to debate	\N	verb	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
eacbab3e-4747-44a0-8c4b-47956ca4ee8c	destacar	es	to stand out/highlight	\N	verb	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
7cb29671-249d-4f9a-a80f-30b7aadf2748	fundamentar	es	to base/ground	\N	verb	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
f95cf99d-e6ca-4b1d-a4c9-dc9cf38023ef	matizar	es	to qualify/nuance	\N	verb	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
a884e9fb-740d-46a4-9be9-994a0f938729	plantear	es	to raise/put forward	\N	verb	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
a41ef869-8f20-4d25-8f07-1a51b961bb1a	profundizar	es	to deepen/go deeper	\N	verb	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
05d982cd-42fa-4fe0-bee4-28a488cdb1df	ambivalente	es	ambivalent	\N	adjective	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
43fb455f-5530-4ddf-8390-8ca75835d4ad	contundente	es	forceful/convincing	\N	adjective	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
6c3ba1d9-320d-40c6-81a6-1b3e77a465f6	exhaustivo	es	exhaustive	\N	adjective	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
a7f40f2f-9f48-43a3-89c7-e02b89b2b1ed	inherente	es	inherent	\N	adjective	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
67e13b41-e4d8-44e0-b55f-8cea0b52571f	paradójico	es	paradoxical	\N	adjective	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
1ed278c7-b7bd-43e2-b096-7d16048f4bcc	pragmático	es	pragmatic	\N	adjective	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
bf12aa56-db90-4121-b38c-4405dbd7319d	subjetivo	es	subjective	\N	adjective	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
eee9e4e6-c745-4b7e-8dab-78ff3fa97762	trascendental	es	transcendental	\N	adjective	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
7a75bf22-483a-4617-9946-a42f1e38789a	versátil	es	versatile	\N	adjective	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
a690688c-9cb1-4c8d-b42a-c92a51fff310	vulnerable	es	vulnerable	\N	adjective	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
9f0248a1-10f3-48d5-9f05-d57fdf65f544	argumento	es	argument	\N	noun	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
409d2d36-043a-4ebd-8378-98376dc4044e	conciencia	es	conscience/awareness	\N	noun	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
579cbfcd-4fb7-4cce-9b27-ca3317c0c132	criterio	es	criterion	\N	noun	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
799cd6fe-7aa5-4bc9-8cae-8a706eff943f	dilema	es	dilemma	\N	noun	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
cf529cfe-450d-4eae-9556-74e3b38cc84a	enfoque	es	approach/focus	\N	noun	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
04cf7f76-aa28-4030-97f2-2228372cda86	hipótesis	es	hypothesis	\N	noun	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
6cd7ecd6-9203-4054-9a80-8e18a6b51513	paradigma	es	paradigm	\N	noun	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
c155ac38-74c2-4512-8ff5-91c02f4caa71	premisa	es	premise	\N	noun	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
e0be86bd-8d8e-4c7d-9b6d-9684ea4c1d3b	tendencia	es	trend/tendency	\N	noun	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
cb8fb0c8-5918-45a6-a131-a6189096ed5b	vínculo	es	link/bond	\N	noun	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
357555b7-7c2c-441f-a641-4ca3dc3da947	a grandes rasgos	es	broadly speaking	\N	phrase	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
fca80830-fe18-45e4-82a3-cd503e651481	en definitiva	es	in short/ultimately	\N	phrase	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
c99c8ba0-a88d-4dde-ba5a-89ec362045e6	desde mi punto de vista	es	from my point of view	\N	phrase	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
26c47428-bc89-4f66-b7a1-a1541906ba2d	hay que reconocer	es	one must acknowledge	\N	phrase	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
8eb02f60-db02-43b4-8b2d-01fc9dbf75a0	vale la pena	es	it is worth it	\N	phrase	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
bbda7b2f-65e4-4a40-8827-2ac25d748c5f	sin lugar a dudas	es	without a doubt	\N	phrase	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
f9b71057-a025-4145-b159-d7d1926cd14c	en el fondo	es	deep down/at heart	\N	phrase	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
dcaae4c7-a072-4f3c-b3c9-cad2b25fbfec	a fin de cuentas	es	after all/in the end	\N	phrase	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
e11c350b-9613-4508-bc79-cdc916acdec4	dicho esto	es	having said that	\N	phrase	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
9f9d48aa-5885-40f8-b4d3-7f5af07b2da7	en pocas palabras	es	in a few words/in short	\N	phrase	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
a49f5bf5-d7f9-4077-bd38-d14855c7c236	no obstante	es	nevertheless/however	\N	conjunction	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
83de5bf9-bc79-45ea-b6ad-4def421a497a	así pues	es	so/therefore	\N	conjunction	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
84b39037-e2db-40d2-8cef-22dcde21a612	por consiguiente	es	consequently	\N	conjunction	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
6e939dc5-655a-4feb-bff3-3e424c6d6d74	de modo que	es	so that/in such a way	\N	conjunction	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
3d77010e-723b-4c17-9d61-7e01e59b9853	con todo	es	nevertheless/still	\N	conjunction	\N	ADVANCED	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LATIN_AMERICAN	\N	\N	f	\N	2026-04-16 00:27:42.013955	2
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
34b378a6-644e-42a3-ac47-3e9ec62f90f1	SUBJUNCTIVE_PAST	es	Past subjunctive — wishes and hypotheticals	Used for past wishes, doubts, and hypothetical situations. Formed from the preterite stem.	UPPER_INTERMEDIATE	TENSES	["Si tuviera dinero, viajaría.", "Quería que vinieras."]	["Confusing past subjunctive with imperfect", "Using indicative instead of subjunctive"]	\N	2	2026-04-16 01:23:29.004202
4d032c7c-83f4-4b5d-8764-956d5dd7cd0d	CONDITIONAL_PERFECT	es	Conditional perfect — would have done	Expresses what would have happened under different circumstances.	UPPER_INTERMEDIATE	TENSES	["Habría comido si hubiera tenido hambre.", "Lo habría dicho antes."]	["Confusing with simple conditional", "Wrong past participle form"]	\N	3	2026-04-16 01:23:29.004202
7031a84f-1083-44d5-8058-5d404f8ba3d8	FUTURE_PERFECT	es	Future perfect — will have done	Expresses an action that will be completed before another future action.	UPPER_INTERMEDIATE	TENSES	["Para mañana habré terminado.", "Cuando llegues ya habrá comido."]	["Confusing with simple future", "Wrong auxiliary verb"]	\N	4	2026-04-16 01:23:29.004202
6c83c9ca-56be-43ba-a5f0-553490aa07dc	PASSIVE_VOICE_ES	es	Passive voice — ser + past participle	Used when the subject receives the action. The agent is introduced with por.	UPPER_INTERMEDIATE	VERBS	["El libro fue escrito por Cervantes.", "La carta fue enviada ayer."]	["Confusing ser and estar in passive", "Wrong past participle agreement"]	\N	5	2026-04-16 01:23:29.004202
0c921690-5834-41bd-8a9b-a7b0ec92b333	SE_IMPERSONAL	es	Impersonal se — general statements	Used to make general statements without specifying a subject.	UPPER_INTERMEDIATE	VERBS	["Se habla español aquí.", "Se come bien en España."]	["Confusing with reflexive se", "Wrong verb agreement"]	\N	6	2026-04-16 01:23:29.004202
9356231f-71d9-4a5c-951d-5eedf664a2af	RELATIVE_CLAUSES	es	Relative clauses — que, quien, cual	Used to give more information about a noun.	UPPER_INTERMEDIATE	PRONOUNS	["El hombre que vino ayer.", "La ciudad en la cual vivía."]	["Confusing que and quien", "Omitting the relative pronoun"]	\N	7	2026-04-16 01:23:29.004202
559f934b-5ff8-4648-9f12-f05dbc8c861d	SUPERLATIVES_ES	es	Superlatives — the most, the least	Used to express the highest or lowest degree of a quality.	UPPER_INTERMEDIATE	ADJECTIVES	["Es el más alto de la clase.", "Es la menos cara de todas."]	["Wrong article agreement", "Confusing with comparatives"]	\N	8	2026-04-16 01:23:29.004202
6e44834d-001d-4daf-958f-03f1f9a3ec86	GERUND_ES	es	Gerund — estar + ando/iendo	Used for actions in progress. Also used after verbs like seguir, llevar, and ir.	UPPER_INTERMEDIATE	VERBS	["Estoy comiendo ahora.", "Lleva dos horas estudiando."]	["Using infinitive instead of gerund", "Wrong gerund formation"]	\N	9	2026-04-16 01:23:29.004202
7a6a4042-6dda-4c83-a3c4-4b5819976f4f	INDIRECT_SPEECH	es	Indirect speech — reporting what was said	Used to report what someone said without quoting directly.	UPPER_INTERMEDIATE	SENTENCE_STRUCTURE	["Dijo que vendría mañana.", "Me preguntó si había comido."]	["Not shifting tenses correctly", "Confusing direct and indirect speech"]	\N	10	2026-04-16 01:23:29.004202
7b250dff-7f44-4fa3-adf8-58ac16d77cd3	PREPOSITIONS_ADV	es	Advanced prepositions — a, en, de, con, sin, sobre	Complex uses of Spanish prepositions that differ from English equivalents.	UPPER_INTERMEDIATE	PREPOSITIONS	["Pienso en ti.", "Depende de ti.", "Cuenta con nosotros."]	["Translating prepositions literally from English", "Using wrong preposition with verbs"]	\N	11	2026-04-16 01:23:29.004202
d78029a1-a0c5-4fc1-a90a-30a27f057914	SUBJUNCTIVE_IMPERF	es	Imperfect subjunctive — past hypotheticals	Used in si clauses and after certain expressions to talk about hypothetical situations.	ADVANCED	TENSES	["Si tuviera tiempo, estudiaría más.", "Ojalá pudiera venir."]	["Using present subjunctive instead", "Wrong formation of imperfect subjunctive"]	\N	1	2026-04-16 01:23:29.007908
bbb80828-da6f-44cb-bbb8-d187275b2b4d	PLUPERFECT_ES	es	Pluperfect — had done	Expresses an action completed before another past action.	ADVANCED	TENSES	["Cuando llegué ya había comido.", "Nunca había visto eso."]	["Confusing with present perfect", "Wrong auxiliary conjugation"]	\N	2	2026-04-16 01:23:29.007908
d7de8265-a792-44de-ba97-cbd6a7eb387d	SUBJUNCTIVE_CONCESS	es	Subjunctive in concessive clauses	Used after aunque and similar expressions when the outcome is uncertain.	ADVANCED	TENSES	["Aunque venga, no lo veré.", "A pesar de que llueva, iré."]	["Using indicative when subjunctive needed", "Confusing concessive with causal"]	\N	3	2026-04-16 01:23:29.007908
64e689c9-5086-46de-b0c9-46a13f136fe2	NOMINALIZATION	es	Nominalization — turning verbs into nouns	Converting verbs or adjectives into nouns using el + infinitive or abstract noun forms.	ADVANCED	SENTENCE_STRUCTURE	["El correr es saludable.", "Lo importante es participar."]	["Overusing infinitive forms", "Wrong article with nominalized forms"]	\N	4	2026-04-16 01:23:29.007908
90653ec5-a9b1-4319-9030-3aee30ebc8e4	DISCOURSE_MARKERS	es	Discourse markers — linking ideas	Words and phrases used to connect ideas, show contrast, add information, or conclude arguments.	ADVANCED	CONJUNCTIONS	["Sin embargo, no pudimos llegar.", "Por lo tanto, debemos actuar."]	["Overusing sin embargo", "Placing markers in wrong position"]	\N	5	2026-04-16 01:23:29.007908
c8322a8f-6c06-403e-9fda-f3cbfab54f33	INVERSION_ES	es	Syntactic inversion — emphasis and style	Changing standard word order for emphasis, in questions, or in formal writing.	ADVANCED	SENTENCE_STRUCTURE	["Difícil es la situación.", "Nunca había visto tal cosa."]	["Overusing inversion in informal speech", "Wrong verb agreement after inversion"]	\N	6	2026-04-16 01:23:29.007908
0971fefd-2e4c-4f81-8e14-e9884b7137c3	ELLIPSIS_ES	es	Ellipsis — omitting understood elements	Leaving out words that are understood from context to avoid repetition.	ADVANCED	SENTENCE_STRUCTURE	["Yo fui al mercado y ella también.", "¿Vienes? — Sí, ahora."]	["Omitting elements that are not clear from context"]	\N	7	2026-04-16 01:23:29.007908
36cae7d2-6641-4b61-8db9-979e480d537a	REGISTER_FORMAL	es	Formal register — usted and professional language	Using formal vocabulary, usted, and professional expressions in formal contexts.	ADVANCED	PRONOUNS	["¿En qué le puedo ayudar?", "Le agradezco su atención."]	["Mixing formal and informal register", "Using tu in formal contexts"]	\N	8	2026-04-16 01:23:29.007908
3a953f96-a452-472e-98b6-164db61e9b3c	IDIOMATIC_EXPR	es	Idiomatic expressions — fixed phrases	Expressions whose meaning cannot be deduced from the individual words.	ADVANCED	SENTENCE_STRUCTURE	["No hay mal que por bien no venga.", "Más vale tarde que nunca."]	["Translating idioms literally", "Using idioms in wrong context"]	\N	9	2026-04-16 01:23:29.007908
22974187-8002-477f-bf56-520843fa2ab4	COHESION_COHERENCE	es	Cohesion and coherence in writing	Techniques for connecting sentences and paragraphs to create a unified and logical text.	ADVANCED	SENTENCE_STRUCTURE	["En primer lugar... Por otro lado... En definitiva..."]	["Repeating the same connector", "Lack of logical flow between ideas"]	\N	10	2026-04-16 01:23:29.007908
3a893fcc-3f81-4d16-9e51-7b9d83bc7442	REFLEXIVE_VERBS	es	Reflexive verbs — se, me, te	Verbs where the subject and object are the same person. Used for daily routines and reciprocal actions.	INTERMEDIATE	VERBS	["Me llamo Juan.", "Se ducha por la mañana.", "Nos vemos mañana."]	["Forgetting the reflexive pronoun", "Wrong pronoun placement"]	\N	8	2026-04-16 01:24:06.109795
f5bb31ea-20e4-46db-87da-2ec3dc2efcd1	DIRECT_INDIRECT_OBJ	es	Direct and indirect object pronouns	Pronouns that replace nouns to avoid repetition. Direct answers what, indirect answers to whom.	INTERMEDIATE	PRONOUNS	["Lo veo.", "Le doy el libro.", "Me lo da."]	["Confusing lo/la with le", "Wrong word order with double pronouns"]	\N	9	2026-04-16 01:24:06.109795
db7bfbda-800c-4c52-913c-c88428b62037	NEGATION_ES	es	Negation — no, nunca, nada, nadie	Spanish allows double negatives. Negative words can come before or after the verb.	INTERMEDIATE	NEGATION	["No tengo nada.", "Nunca comes verduras.", "No viene nadie."]	["Avoiding double negatives incorrectly", "Wrong placement of negative words"]	\N	10	2026-04-16 01:24:06.109795
ecb0e71c-9e06-4f33-9d31-2cc5e917ba11	QUESTIONS_ES	es	Question words — qué, quién, dónde, cuándo	Interrogative words used to ask specific questions. Always carry an accent mark.	INTERMEDIATE	QUESTIONS	["¿Qué quieres?", "¿Dónde vives?", "¿Cuándo llegas?"]	["Forgetting accent marks", "Wrong word order in questions"]	\N	11	2026-04-16 01:24:06.109795
7ccf7c17-1e37-4564-a18d-b86b3fc49681	ADVERBS_ES	es	Adverbs — mente and placement	Formed by adding mente to feminine adjective. Usually placed after the verb.	INTERMEDIATE	ADVERBS	["Habla rápidamente.", "Generalmente como en casa.", "Lamentablemente no pude ir."]	["Wrong adjective form before mente", "Placing adverb before verb"]	\N	12	2026-04-16 01:24:06.109795
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
-- Data for Name: family_relationships; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.family_relationships (id, spanish, english, category, level, language, lesson_number) FROM stdin;
1	la madre	the mother	immediate_family	BEGINNER	es	7
2	el padre	the father	immediate_family	BEGINNER	es	7
3	la hermana	the sister	immediate_family	BEGINNER	es	7
4	el hermano	the brother	immediate_family	BEGINNER	es	7
5	la hija	the daughter	immediate_family	BEGINNER	es	7
6	el hijo	the son	immediate_family	BEGINNER	es	7
7	la abuela	the grandmother	extended_family	BEGINNER	es	7
8	el abuelo	the grandfather	extended_family	BEGINNER	es	7
9	la tia	the aunt	extended_family	BEGINNER	es	7
10	el tio	the uncle	extended_family	BEGINNER	es	7
11	la prima	the cousin (f)	extended_family	BEGINNER	es	7
12	el primo	the cousin (m)	extended_family	BEGINNER	es	7
13	la sobrina	the niece	extended_family	BEGINNER	es	7
14	el sobrino	the nephew	extended_family	BEGINNER	es	7
15	la esposa	the wife	immediate_family	BEGINNER	es	7
16	el esposo	the husband	immediate_family	BEGINNER	es	7
17	la familia	the family	general	BEGINNER	es	7
18	los padres	the parents	immediate_family	BEGINNER	es	7
19	los hijos	the children	immediate_family	BEGINNER	es	7
20	los abuelos	the grandparents	extended_family	BEGINNER	es	7
21	el bebe	the baby	immediate_family	BEGINNER	es	7
22	la novia	the girlfriend	relationships	BEGINNER	es	7
23	el novio	the boyfriend	relationships	BEGINNER	es	7
24	el amigo	the friend (m)	relationships	BEGINNER	es	7
25	la amiga	the friend (f)	relationships	BEGINNER	es	7
26	el vecino	the neighbor (m)	relationships	BEGINNER	es	7
27	la vecina	the neighbor (f)	relationships	BEGINNER	es	7
28	soltero	single	status	BEGINNER	es	7
29	casado	married	status	BEGINNER	es	7
30	divorciado	divorced	status	BEGINNER	es	7
31	la nuera	the daughter in law	extended_family	INTERMEDIATE	es	7
32	el yerno	the son in law	extended_family	INTERMEDIATE	es	7
33	la suegra	the mother in law	extended_family	INTERMEDIATE	es	7
34	el suegro	the father in law	extended_family	INTERMEDIATE	es	7
35	la cunada	the sister in law	extended_family	INTERMEDIATE	es	7
36	el cunado	the brother in law	extended_family	INTERMEDIATE	es	7
37	la madrastra	the stepmother	extended_family	INTERMEDIATE	es	7
38	el padrastro	the stepfather	extended_family	INTERMEDIATE	es	7
39	la hermanastra	the stepsister	extended_family	INTERMEDIATE	es	7
40	el hermanastro	the stepbrother	extended_family	INTERMEDIATE	es	7
41	la bisabuela	the great grandmother	extended_family	INTERMEDIATE	es	7
42	el bisabuelo	the great grandfather	extended_family	INTERMEDIATE	es	7
43	el gemelo	the twin (m)	immediate_family	INTERMEDIATE	es	7
44	la gemela	the twin (f)	immediate_family	INTERMEDIATE	es	7
45	el hijo adoptivo	the adopted son	immediate_family	INTERMEDIATE	es	7
46	la pareja	the partner/couple	relationships	INTERMEDIATE	es	7
47	comprometido	engaged	status	INTERMEDIATE	es	7
48	viudo	widowed	status	INTERMEDIATE	es	7
49	separado	separated	status	INTERMEDIATE	es	7
50	convivir	to live together	relationships	INTERMEDIATE	es	7
51	llevarse bien	to get along well	relationships	INTERMEDIATE	es	7
52	llevarse mal	to not get along	relationships	INTERMEDIATE	es	7
53	parecerse a	to look like	relationships	INTERMEDIATE	es	7
54	cuidar a	to take care of	relationships	INTERMEDIATE	es	7
55	apoyar	to support	relationships	INTERMEDIATE	es	7
56	respetar	to respect	relationships	INTERMEDIATE	es	7
57	querer	to love/care for	relationships	INTERMEDIATE	es	7
58	discutir	to argue	relationships	INTERMEDIATE	es	7
59	reconciliarse	to make up/reconcile	relationships	INTERMEDIATE	es	7
60	mudarse	to move out	relationships	INTERMEDIATE	es	7
61	el hogar	the home/household	general	UPPER_INTERMEDIATE	es	7
62	la convivencia	living together/coexistence	general	UPPER_INTERMEDIATE	es	7
63	los lazos familiares	family ties/bonds	general	UPPER_INTERMEDIATE	es	7
64	la herencia	the inheritance/heritage	general	UPPER_INTERMEDIATE	es	7
65	la custodia	the custody	general	UPPER_INTERMEDIATE	es	7
66	la adopcion	the adoption	general	UPPER_INTERMEDIATE	es	7
67	la crianza	the upbringing/raising	general	UPPER_INTERMEDIATE	es	7
68	los valores familiares	family values	general	UPPER_INTERMEDIATE	es	7
69	la dinamica familiar	family dynamics	general	UPPER_INTERMEDIATE	es	7
70	el rol familiar	the family role	general	UPPER_INTERMEDIATE	es	7
71	la responsabilidad	the responsibility	general	UPPER_INTERMEDIATE	es	7
72	el compromiso	the commitment	relationships	UPPER_INTERMEDIATE	es	7
73	la confianza	the trust	relationships	UPPER_INTERMEDIATE	es	7
74	la lealtad	the loyalty	relationships	UPPER_INTERMEDIATE	es	7
75	el respeto mutuo	mutual respect	relationships	UPPER_INTERMEDIATE	es	7
76	la comunicacion	the communication	relationships	UPPER_INTERMEDIATE	es	7
77	el conflicto	the conflict	relationships	UPPER_INTERMEDIATE	es	7
78	la reconciliacion	the reconciliation	relationships	UPPER_INTERMEDIATE	es	7
79	el apoyo emocional	emotional support	relationships	UPPER_INTERMEDIATE	es	7
80	la dependencia	the dependence	relationships	UPPER_INTERMEDIATE	es	7
81	la independencia	the independence	relationships	UPPER_INTERMEDIATE	es	7
82	el divorcio	the divorce	status	UPPER_INTERMEDIATE	es	7
83	la separacion	the separation	status	UPPER_INTERMEDIATE	es	7
84	el matrimonio	the marriage	status	UPPER_INTERMEDIATE	es	7
85	la boda	the wedding	status	UPPER_INTERMEDIATE	es	7
86	el noviazgo	the courtship/dating	status	UPPER_INTERMEDIATE	es	7
87	la luna de miel	the honeymoon	status	UPPER_INTERMEDIATE	es	7
88	el aniversario	the anniversary	status	UPPER_INTERMEDIATE	es	7
89	la familia monoparental	single parent family	general	UPPER_INTERMEDIATE	es	7
90	la familia numerosa	large family	general	UPPER_INTERMEDIATE	es	7
91	el nucleo familiar	the nuclear family	concept	ADVANCED	es	7
92	la familia extendida	the extended family	concept	ADVANCED	es	7
93	el vinculo afectivo	the emotional bond	concept	ADVANCED	es	7
94	la identidad familiar	family identity	concept	ADVANCED	es	7
95	la cohesion familiar	family cohesion	concept	ADVANCED	es	7
96	la estructura familiar	family structure	concept	ADVANCED	es	7
97	el patrimonio familiar	family heritage/patrimony	concept	ADVANCED	es	7
98	la transmision de valores	transmission of values	concept	ADVANCED	es	7
99	el apego	the attachment	concept	ADVANCED	es	7
100	el desapego	the detachment	concept	ADVANCED	es	7
101	la resiliencia familiar	family resilience	concept	ADVANCED	es	7
102	la disfuncion familiar	family dysfunction	concept	ADVANCED	es	7
103	el abuso familiar	family abuse	concept	ADVANCED	es	7
104	la reconciliacion generacional	generational reconciliation	concept	ADVANCED	es	7
105	el conflicto generacional	generational conflict	concept	ADVANCED	es	7
106	la brecha generacional	generational gap	concept	ADVANCED	es	7
107	los roles de genero	gender roles	concept	ADVANCED	es	7
108	la maternidad	motherhood	concept	ADVANCED	es	7
109	la paternidad	fatherhood	concept	ADVANCED	es	7
110	la parentalidad	parenthood	concept	ADVANCED	es	7
111	el bienestar familiar	family wellbeing	concept	ADVANCED	es	7
112	la autonomia	autonomy	concept	ADVANCED	es	7
113	la interdependencia	interdependence	concept	ADVANCED	es	7
114	el vinculo generacional	generational bond	concept	ADVANCED	es	7
115	la solidaridad familiar	family solidarity	concept	ADVANCED	es	7
116	el tejido social	social fabric	concept	ADVANCED	es	7
117	la institucion familiar	the family institution	concept	ADVANCED	es	7
118	el modelo familiar	the family model	concept	ADVANCED	es	7
119	la convivencia intergeneracional	intergenerational coexistence	concept	ADVANCED	es	7
120	el contrato social familiar	the family social contract	concept	ADVANCED	es	7
\.


--
-- Data for Name: leaderboard_entries; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.leaderboard_entries (id, user_id, week_start, xp_earned, league, rank) FROM stdin;
\.


--
-- Data for Name: lesson_catalog; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.lesson_catalog (lesson_number, title, table_name, description) FROM stdin;
1	Alphabet & Pronunciation	alphabet	Learn the Spanish alphabet and how each letter sounds
2	Basic Vocabulary	vocabulary	Essential everyday Spanish words
3	Sentence Structure	sentence_structure	How to build sentences in Spanish
4	Phrases and Conversation	phrases	Real life phrases grouped by scenario
5	Numbers and Time	numbers,time_expressions	Cardinal numbers, ordinals, telling time, days and months
6	Colors and Descriptions	colors_descriptions	Colors and descriptive adjectives
7	Family and Relationships	family_relationships	Family members and relationship vocabulary
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
-- Data for Name: level_change_history; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.level_change_history (id, user_id, changed_by, change_type, previous_level, new_level, reason, changed_at) FROM stdin;
\.


--
-- Data for Name: placement_tests; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.placement_tests (id, user_id, language, score, total_questions, percentage_score, assigned_level, duration_seconds, was_completed, exit_reason, difficulty_path, recommended_unit_id, taken_at) FROM stdin;
f4e8ee57-bf8d-48e6-8593-3bc00c0c0805	cb7b7c8b-987d-4557-b395-d91c017b19ef	es	8	10	80.00	ADVANCED	79	t	\N	\N	\N	2026-03-24 03:48:24.473402
ea86fe1e-3100-458f-93a5-1bb8a52d2f53	c01b44f7-7a64-48e6-8778-0ae3bdb0d382	es	1	10	10.00	BEGINNER	0	t	\N	\N	\N	2026-04-16 15:54:25.952704
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
-- Data for Name: numbers; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.numbers (id, spanish, english, numeral, number_type, level, language, lesson_number) FROM stdin;
1	uno	one	1	cardinal	BEGINNER	es	5
2	dos	two	2	cardinal	BEGINNER	es	5
3	tres	three	3	cardinal	BEGINNER	es	5
4	cuatro	four	4	cardinal	BEGINNER	es	5
5	cinco	five	5	cardinal	BEGINNER	es	5
6	seis	six	6	cardinal	BEGINNER	es	5
7	siete	seven	7	cardinal	BEGINNER	es	5
8	ocho	eight	8	cardinal	BEGINNER	es	5
9	nueve	nine	9	cardinal	BEGINNER	es	5
10	diez	ten	10	cardinal	BEGINNER	es	5
11	once	eleven	11	cardinal	BEGINNER	es	5
12	doce	twelve	12	cardinal	BEGINNER	es	5
13	trece	thirteen	13	cardinal	BEGINNER	es	5
14	catorce	fourteen	14	cardinal	BEGINNER	es	5
15	quince	fifteen	15	cardinal	BEGINNER	es	5
16	dieciséis	sixteen	16	cardinal	BEGINNER	es	5
17	diecisiete	seventeen	17	cardinal	BEGINNER	es	5
18	dieciocho	eighteen	18	cardinal	BEGINNER	es	5
19	diecinueve	nineteen	19	cardinal	BEGINNER	es	5
20	veinte	twenty	20	cardinal	BEGINNER	es	5
21	veintiuno	twenty one	21	cardinal	BEGINNER	es	5
22	veintidós	twenty two	22	cardinal	BEGINNER	es	5
23	treinta	thirty	30	cardinal	BEGINNER	es	5
24	cuarenta	forty	40	cardinal	BEGINNER	es	5
25	cincuenta	fifty	50	cardinal	BEGINNER	es	5
26	sesenta	sixty	60	cardinal	BEGINNER	es	5
27	setenta	seventy	70	cardinal	BEGINNER	es	5
28	ochenta	eighty	80	cardinal	BEGINNER	es	5
29	noventa	ninety	90	cardinal	BEGINNER	es	5
30	cien	one hundred	100	cardinal	BEGINNER	es	5
31	ciento uno	one hundred one	101	cardinal	INTERMEDIATE	es	5
32	doscientos	two hundred	200	cardinal	INTERMEDIATE	es	5
33	trescientos	three hundred	300	cardinal	INTERMEDIATE	es	5
34	cuatrocientos	four hundred	400	cardinal	INTERMEDIATE	es	5
35	quinientos	five hundred	500	cardinal	INTERMEDIATE	es	5
36	seiscientos	six hundred	600	cardinal	INTERMEDIATE	es	5
37	setecientos	seven hundred	700	cardinal	INTERMEDIATE	es	5
38	ochocientos	eight hundred	800	cardinal	INTERMEDIATE	es	5
39	novecientos	nine hundred	900	cardinal	INTERMEDIATE	es	5
40	mil	one thousand	1000	cardinal	INTERMEDIATE	es	5
41	primero	first	1st	ordinal	INTERMEDIATE	es	5
42	segundo	second	2nd	ordinal	INTERMEDIATE	es	5
43	tercero	third	3rd	ordinal	INTERMEDIATE	es	5
44	cuarto	fourth	4th	ordinal	INTERMEDIATE	es	5
45	quinto	fifth	5th	ordinal	INTERMEDIATE	es	5
46	sexto	sixth	6th	ordinal	INTERMEDIATE	es	5
47	séptimo	seventh	7th	ordinal	INTERMEDIATE	es	5
48	octavo	eighth	8th	ordinal	INTERMEDIATE	es	5
49	noveno	ninth	9th	ordinal	INTERMEDIATE	es	5
50	décimo	tenth	10th	ordinal	INTERMEDIATE	es	5
51	la mitad	half	1/2	fraction	INTERMEDIATE	es	5
52	un tercio	one third	1/3	fraction	INTERMEDIATE	es	5
53	un cuarto	one quarter	1/4	fraction	INTERMEDIATE	es	5
54	tres cuartos	three quarters	3/4	fraction	INTERMEDIATE	es	5
55	el doble	double	x2	multiple	INTERMEDIATE	es	5
56	el triple	triple	x3	multiple	INTERMEDIATE	es	5
57	diez mil	ten thousand	10,000	cardinal	INTERMEDIATE	es	5
58	cien mil	one hundred thousand	100,000	cardinal	INTERMEDIATE	es	5
59	un millón	one million	1,000,000	cardinal	INTERMEDIATE	es	5
60	dos millones	two million	2,000,000	cardinal	INTERMEDIATE	es	5
61	más	plus	+	math	UPPER_INTERMEDIATE	es	5
62	menos	minus	-	math	UPPER_INTERMEDIATE	es	5
63	por	times/multiplied by	x	math	UPPER_INTERMEDIATE	es	5
64	dividido entre	divided by	÷	math	UPPER_INTERMEDIATE	es	5
65	igual a	equals	=	math	UPPER_INTERMEDIATE	es	5
66	el porcentaje	percentage	%	math	UPPER_INTERMEDIATE	es	5
67	el promedio	average	avg	math	UPPER_INTERMEDIATE	es	5
68	la suma	sum/total	Σ	math	UPPER_INTERMEDIATE	es	5
69	el resultado	result	\N	math	UPPER_INTERMEDIATE	es	5
70	aproximadamente	approximately	≈	math	UPPER_INTERMEDIATE	es	5
71	undécimo	eleventh	11th	ordinal	UPPER_INTERMEDIATE	es	5
72	duodécimo	twelfth	12th	ordinal	UPPER_INTERMEDIATE	es	5
73	decimotercero	thirteenth	13th	ordinal	UPPER_INTERMEDIATE	es	5
74	decimocuarto	fourteenth	14th	ordinal	UPPER_INTERMEDIATE	es	5
75	decimoquinto	fifteenth	15th	ordinal	UPPER_INTERMEDIATE	es	5
76	vigésimo	twentieth	20th	ordinal	UPPER_INTERMEDIATE	es	5
77	trigésimo	thirtieth	30th	ordinal	UPPER_INTERMEDIATE	es	5
78	centésimo	hundredth	100th	ordinal	UPPER_INTERMEDIATE	es	5
79	milésimo	thousandth	1000th	ordinal	UPPER_INTERMEDIATE	es	5
80	billón	billion	1B	cardinal	UPPER_INTERMEDIATE	es	5
81	número par	even number	\N	concept	UPPER_INTERMEDIATE	es	5
82	número impar	odd number	\N	concept	UPPER_INTERMEDIATE	es	5
83	número negativo	negative number	\N	concept	UPPER_INTERMEDIATE	es	5
84	número positivo	positive number	\N	concept	UPPER_INTERMEDIATE	es	5
85	la raíz cuadrada	square root	√	math	UPPER_INTERMEDIATE	es	5
86	el cuadrado	square	²	math	UPPER_INTERMEDIATE	es	5
87	el cubo	cube	³	math	UPPER_INTERMEDIATE	es	5
88	infinito	infinite	∞	concept	UPPER_INTERMEDIATE	es	5
89	la cifra	digit/figure	\N	concept	UPPER_INTERMEDIATE	es	5
90	el número decimal	decimal number	\N	concept	UPPER_INTERMEDIATE	es	5
91	la estadística	statistics	\N	concept	ADVANCED	es	5
92	la probabilidad	probability	\N	concept	ADVANCED	es	5
93	la variable	variable	\N	concept	ADVANCED	es	5
94	la constante	constant	\N	concept	ADVANCED	es	5
95	el coeficiente	coefficient	\N	concept	ADVANCED	es	5
96	la ecuación	equation	\N	concept	ADVANCED	es	5
97	la fórmula	formula	\N	concept	ADVANCED	es	5
98	el algoritmo	algorithm	\N	concept	ADVANCED	es	5
99	la proporción	proportion	\N	concept	ADVANCED	es	5
100	la relación	ratio	\N	concept	ADVANCED	es	5
101	la desviación estándar	standard deviation	\N	concept	ADVANCED	es	5
102	la mediana	median	\N	concept	ADVANCED	es	5
103	la moda	mode	\N	concept	ADVANCED	es	5
104	el rango	range	\N	concept	ADVANCED	es	5
105	la muestra	sample	\N	concept	ADVANCED	es	5
106	la población	population	\N	concept	ADVANCED	es	5
107	la hipótesis nula	null hypothesis	\N	concept	ADVANCED	es	5
108	el margen de error	margin of error	\N	concept	ADVANCED	es	5
109	la correlación	correlation	\N	concept	ADVANCED	es	5
110	exponencial	exponential	\N	concept	ADVANCED	es	5
111	logarítmico	logarithmic	\N	concept	ADVANCED	es	5
112	la tasa de crecimiento	growth rate	\N	concept	ADVANCED	es	5
113	el valor absoluto	absolute value	\N	concept	ADVANCED	es	5
114	el número primo	prime number	\N	concept	ADVANCED	es	5
115	la función	function	\N	concept	ADVANCED	es	5
116	el eje	axis	\N	concept	ADVANCED	es	5
117	el gráfico	graph/chart	\N	concept	ADVANCED	es	5
118	el porcentaje acumulado	cumulative percentage	\N	concept	ADVANCED	es	5
119	la tendencia	trend	\N	concept	ADVANCED	es	5
120	el índice	index	\N	concept	ADVANCED	es	5
\.


--
-- Data for Name: subscriptions; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.subscriptions (id, user_id, plan, status, started_at, expires_at, payment_reference, transaction_id, payment_gateway, payment_method, payment_status, trial_start_date, trial_end_date, auto_renew, cancellation_reason, last_payment_at, next_billing_date, amount_paid, currency, cancelled_at) FROM stdin;
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

COPY public.phrases (id, language, phrase, translation, phonetic_guide, context, level, topic_tag, formality, audio_text, example_dialogue, lesson_number) FROM stdin;
d6706c6c-5bdb-4f65-a631-04a807b2b2e5	es	¿Dónde está el baño?	Where is the bathroom?	DOHN-deh ehs-TAH el BAH-nyoh	Restaurant, travel	BEGINNER	TRAVEL_ES	NEUTRAL	¿Dónde está el baño?	[{"text": "Perdón, ¿dónde está el baño?", "speaker": "learner"}, {"text": "Al fondo a la derecha.", "speaker": "native"}]	4
ab3c306f-a5fa-4e46-a99a-4484dc8a7011	es	¿Cuánto cuesta?	How much does it cost?	KWAHN-toh KWEHS-tah	Shopping, market	BEGINNER	TRAVEL_ES	NEUTRAL	¿Cuánto cuesta?	[{"text": "¿Cuánto cuesta esta camisa?", "speaker": "learner"}, {"text": "Cuesta veinte dólares.", "speaker": "native"}]	4
d95bbce4-1fc5-4d39-beb0-5874fdf770f6	es	No entiendo.	I do not understand.	Noh ehn-TYEHN-doh	Any conversation	BEGINNER	CONVERSATION_ES	NEUTRAL	No entiendo.	[{"text": "Lo siento, no entiendo. ¿Puede repetir?", "speaker": "learner"}, {"text": "Claro, con gusto.", "speaker": "native"}]	4
bcc04708-e7ea-4fa7-b572-4274981df6d5	es	¿Puede repetir, por favor?	Can you repeat, please?	PWEH-deh reh-peh-TEER, por fah-BOR	Any conversation	BEGINNER	CONVERSATION_ES	FORMAL	¿Puede repetir, por favor?	\N	4
e9696143-912c-4553-af1a-026a265cea3d	es	Habla más despacio, por favor.	Speak more slowly, please.	AH-blah mahs dehs-PAH-syoh, por fah-BOR	Any conversation	BEGINNER	CONVERSATION_ES	NEUTRAL	Habla más despacio, por favor.	\N	4
e2e1903b-ce1d-4936-8952-ce8605a8b276	es	¿Habla inglés?	Do you speak English?	AH-blah een-GLEHS	Travel emergency	BEGINNER	TRAVEL_ES	FORMAL	¿Habla inglés?	\N	4
2a1a3b7a-ba32-4906-a370-867b19a9e65d	es	Estoy perdido/a.	I am lost.	ehs-TOY pehr-DEE-doh	Travel, navigation	BEGINNER	TRAVEL_ES	NEUTRAL	Estoy perdido.	\N	4
becb4a37-c209-4eba-98b8-8b719b01f7aa	es	La cuenta, por favor.	The bill, please.	Lah KWEHN-tah, por fah-BOR	Restaurant	BEGINNER	FOOD_ES	NEUTRAL	La cuenta, por favor.	[{"text": "Disculpe, la cuenta por favor.", "speaker": "learner"}, {"text": "Enseguida.", "speaker": "native"}]	4
b2356ac8-4e76-4f0e-970c-a03427f1a294	es	¿Me puede traer...?	Can you bring me...?	Meh PWEH-deh trah-EHR	Restaurant	BEGINNER	FOOD_ES	FORMAL	¿Me puede traer más agua?	\N	4
8b7df538-0e68-46f1-b5c5-c43ee1916ba0	es	Tengo una reservación.	I have a reservation.	TEHN-goh OO-nah reh-sehr-bah-SYOHN	Hotel, restaurant	BEGINNER	TRAVEL_ES	FORMAL	Tengo una reservación a nombre de García.	\N	4
b9600f6b-8266-4ef5-a13c-eab5732e09c1	es	¿A qué hora...?	At what time...?	Ah keh OH-rah	Scheduling, transport	BEGINNER	TRAVEL_ES	NEUTRAL	¿A qué hora sale el tren?	\N	4
b93eafe1-2988-46b8-b027-f6888f64decc	es	Me gustaría...	I would like...	Meh goos-tah-REE-ah	Ordering, requests	BEGINNER	FOOD_ES	FORMAL	Me gustaría el menú del día.	\N	4
4da80abe-e984-426e-b306-e5f801ec32bc	es	¿Tiene...?	Do you have...?	TYEH-neh	Shopping, restaurant	BEGINNER	FOOD_ES	NEUTRAL	¿Tiene una mesa para dos?	\N	4
e99a21c6-6d53-4f6d-863b-dba26627c4c8	es	Soy alérgico/a a...	I am allergic to...	Soy ah-LEHR-hee-koh ah	Health, restaurant	INTERMEDIATE	HEALTH_ES	NEUTRAL	Soy alérgico al maní.	\N	4
6f50d921-dd7e-48fb-858d-32e972519b34	es	Llame a un médico.	Call a doctor.	YAH-meh ah oon MEH-dee-koh	Emergency	INTERMEDIATE	HEALTH_ES	NEUTRAL	Por favor, llame a un médico. Es una emergencia.	\N	4
16ed4126-dbba-442e-817e-ddf534838643	es	¿Podría hablar con...?	Could I speak with...?	poh-DREE-ah ah-BLAR kon	Business, phone	INTERMEDIATE	BUSINESS_ES	FORMAL	¿Podría hablar con el gerente?	\N	4
be39ce55-299b-4112-87a1-0ea17fbaff59	es	Estoy de acuerdo.	I agree.	ehs-TOY deh ah-KWEHR-doh	Business, conversation	INTERMEDIATE	BUSINESS_ES	FORMAL	Estoy de acuerdo con su propuesta.	\N	4
1a4176cf-dac4-4a92-b7be-dfcd17fa5d9f	es	Sin embargo...	However...	seen ehm-BAR-goh	Business, debate	UPPER_INTERMEDIATE	BUSINESS_ES	FORMAL	Es una buena idea; sin embargo, el presupuesto es limitado.	\N	4
08281ea6-2805-4dc1-b612-be1be9ee5757	es	¿Me puede dar la cuenta, por favor?	Can you give me the bill, please?	me PWE-de dar la KWEN-ta por fa-VOR	restaurant	BEGINNER	FOOD_ES	NEUTRAL	\N	\N	4
e4dad6ac-1abb-4281-8a59-2844ab61c07a	es	No entiendo. ¿Puede repetir?	I do not understand. Can you repeat?	no en-tien-DO PWE-de re-pe-TIR	general	BEGINNER	CONVERSATION_ES	FORMAL	\N	\N	4
446f4b89-cb13-4790-8caf-b61b264e1260	es	Mucho gusto en conocerte.	Nice to meet you.	MU-cho GUS-to en co-no-CER-te	introductions	BEGINNER	CONVERSATION_ES	NEUTRAL	\N	\N	4
8a9479c2-fdec-4f26-ad3e-21800908aeef	es	¿A qué hora abre el banco?	What time does the bank open?	a ke O-ra A-bre el BAN-co	services	INTERMEDIATE	CONVERSATION_ES	NEUTRAL	\N	\N	4
288b6250-a268-427e-856d-02b98eee0a7b	es	Me gustaría hacer una reserva.	I would like to make a reservation.	me gus-ta-RI-a a-CER u-na re-SER-va	hotel/restaurant	INTERMEDIATE	TRAVEL_ES	FORMAL	\N	\N	4
d3ce8176-5363-48f9-8c0a-3e345db2435e	es	¿Podría hablar con el gerente?	Could I speak with the manager?	po-DRI-a ha-BLAR con el he-REN-te	business	INTERMEDIATE	BUSINESS_ES	FORMAL	\N	\N	4
fbca31be-5ed9-4768-bb65-d4572d7b0488	es	¿Cómo te llamas?	What is your name?	\N	introductions	BEGINNER	CONVERSATION_ES	NEUTRAL	\N	\N	4
533e5507-e7b0-4426-a611-6ef3e37e708e	es	Me llamo Juan.	My name is Juan.	\N	introductions	BEGINNER	CONVERSATION_ES	NEUTRAL	\N	\N	4
db6a87d5-dd8c-46a8-9c34-80a8785f8b90	es	¿De dónde eres?	Where are you from?	\N	introductions	BEGINNER	CONVERSATION_ES	NEUTRAL	\N	\N	4
0b3152dc-22e0-4ebe-b891-2d21dc0edc9c	es	Soy de México.	I am from Mexico.	\N	introductions	BEGINNER	CONVERSATION_ES	NEUTRAL	\N	\N	4
b8a86f86-0492-4230-a478-81e5b4ffbe9d	es	¿Cuántos años tienes?	How old are you?	\N	introductions	BEGINNER	CONVERSATION_ES	NEUTRAL	\N	\N	4
362cdf33-d894-441b-aa94-7d74197ba02a	es	Tengo veinte años.	I am twenty years old.	\N	introductions	BEGINNER	CONVERSATION_ES	NEUTRAL	\N	\N	4
76606343-0251-46e0-a7f5-16f7d5554c23	es	¿Hablas inglés?	Do you speak English?	\N	general	BEGINNER	CONVERSATION_ES	NEUTRAL	\N	\N	4
bf875c61-daf4-4084-91a8-662681280b4a	es	Un poco.	A little.	\N	general	BEGINNER	CONVERSATION_ES	NEUTRAL	\N	\N	4
6254a14d-841a-4a4d-8842-d5fac7a855e4	es	¿Puedes ayudarme?	Can you help me?	\N	general	BEGINNER	CONVERSATION_ES	NEUTRAL	\N	\N	4
12863ac1-a109-4882-9d33-24060d1e97d1	es	Por supuesto.	Of course.	\N	general	BEGINNER	CONVERSATION_ES	NEUTRAL	\N	\N	4
62b44df4-d653-473f-9cac-c1b67bd83fea	es	¿Qué significa esto?	What does this mean?	\N	general	BEGINNER	CONVERSATION_ES	NEUTRAL	\N	\N	4
c4dd3a10-d07e-4501-9243-3ec702d7aad8	es	No sé.	I do not know.	\N	general	BEGINNER	CONVERSATION_ES	NEUTRAL	\N	\N	4
5b543621-feaa-4956-94e7-9f32b65240d8	es	¿Puede escribirlo?	Can you write it down?	\N	general	BEGINNER	CONVERSATION_ES	NEUTRAL	\N	\N	4
afa889e8-b3c1-480e-bbd9-b0084592aab9	es	Estoy aprendiendo español.	I am learning Spanish.	\N	general	BEGINNER	CONVERSATION_ES	NEUTRAL	\N	\N	4
3649d4d0-6e7d-4501-b05d-5f257a6b22c1	es	¿Cómo se dice en español?	How do you say it in Spanish?	\N	general	BEGINNER	CONVERSATION_ES	NEUTRAL	\N	\N	4
8c0897ae-b1f2-4b78-bf00-f57f263304f5	es	¿Qué piensas sobre esto?	What do you think about this?	\N	opinion	INTERMEDIATE	CONVERSATION_ES	NEUTRAL	\N	\N	4
842ea4ea-edd9-4467-9c3a-002bf7f4f763	es	En mi opinión...	In my opinion...	\N	opinion	INTERMEDIATE	CONVERSATION_ES	NEUTRAL	\N	\N	4
fa9a8cfa-ca92-4da3-b898-19f81eca08a0	es	Estoy de acuerdo contigo.	I agree with you.	\N	opinion	INTERMEDIATE	CONVERSATION_ES	NEUTRAL	\N	\N	4
5808d3e0-5088-4b79-ab12-809ebbc7a9c0	es	No estoy de acuerdo.	I disagree.	\N	opinion	INTERMEDIATE	CONVERSATION_ES	NEUTRAL	\N	\N	4
23f696e3-eb77-4b92-883e-54b13f3d903a	es	¿Me puedes dar más información?	Can you give me more information?	\N	general	INTERMEDIATE	CONVERSATION_ES	NEUTRAL	\N	\N	4
cca03ec3-efb1-4284-adfb-13e0f99e0d6f	es	Déjame pensar.	Let me think.	\N	general	INTERMEDIATE	CONVERSATION_ES	NEUTRAL	\N	\N	4
44f47b15-758b-4398-b163-27dbd0e2538c	es	¿Qué recomiendas?	What do you recommend?	\N	general	INTERMEDIATE	CONVERSATION_ES	NEUTRAL	\N	\N	4
bc94cc1f-642a-4022-b83b-cfdbe25fb0e1	es	Depende de la situación.	It depends on the situation.	\N	general	INTERMEDIATE	CONVERSATION_ES	NEUTRAL	\N	\N	4
9de2ef34-b4d3-45dc-bc2f-d965ddef6601	es	Tiene mucho sentido.	That makes a lot of sense.	\N	general	INTERMEDIATE	CONVERSATION_ES	NEUTRAL	\N	\N	4
141bac01-2ad0-42c6-9b95-0939a4dc2f18	es	¿Podemos hablar de otro tema?	Can we talk about another topic?	\N	general	INTERMEDIATE	CONVERSATION_ES	NEUTRAL	\N	\N	4
273fe4ea-6784-4c48-999b-28837149b910	es	Desde mi punto de vista...	From my point of view...	\N	opinion	UPPER_INTERMEDIATE	CONVERSATION_ES	FORMAL	\N	\N	4
aac1812f-3f09-4108-8fb8-6fe9a9f037b6	es	Hay que tener en cuenta que...	You have to take into account that...	\N	opinion	UPPER_INTERMEDIATE	CONVERSATION_ES	FORMAL	\N	\N	4
236849b3-50a3-4369-8651-4936bc9c0bc7	es	Por otro lado...	On the other hand...	\N	debate	UPPER_INTERMEDIATE	CONVERSATION_ES	FORMAL	\N	\N	4
d0e8665c-cbd7-4e05-9b59-3fc0af781dc9	es	En términos generales...	Generally speaking...	\N	debate	UPPER_INTERMEDIATE	CONVERSATION_ES	FORMAL	\N	\N	4
86e0c2a7-5711-4bee-a829-0ba9c90b0bf4	es	Cabe destacar que...	It is worth noting that...	\N	debate	UPPER_INTERMEDIATE	CONVERSATION_ES	FORMAL	\N	\N	4
5dd9bce3-0b66-4e97-801f-cd71ffabffcf	es	No obstante...	Nevertheless...	\N	debate	UPPER_INTERMEDIATE	CONVERSATION_ES	FORMAL	\N	\N	4
b912639c-258e-45be-a684-b64dc6201804	es	En definitiva...	Ultimately...	\N	debate	UPPER_INTERMEDIATE	CONVERSATION_ES	FORMAL	\N	\N	4
f052bce3-13d5-4124-9213-f853f63a5f44	es	A grandes rasgos...	Broadly speaking...	\N	debate	UPPER_INTERMEDIATE	CONVERSATION_ES	FORMAL	\N	\N	4
833b34e7-6ef6-43c1-8b19-7a9b91526672	es	Sin lugar a dudas...	Without a doubt...	\N	debate	UPPER_INTERMEDIATE	CONVERSATION_ES	FORMAL	\N	\N	4
8504d06f-c8fc-495c-9e32-ffdca213f418	es	Vale la pena mencionar que...	It is worth mentioning that...	\N	debate	UPPER_INTERMEDIATE	CONVERSATION_ES	FORMAL	\N	\N	4
1160e3ca-f2f6-4b43-86cd-dce1cd656ea3	es	El argumento carece de fundamento.	The argument lacks foundation.	\N	debate	ADVANCED	CONVERSATION_ES	FORMAL	\N	\N	4
33eaabbf-fcb2-4afd-9fa1-3b87c52e4d68	es	Habría que matizar esa afirmación.	That statement would need to be qualified.	\N	debate	ADVANCED	CONVERSATION_ES	FORMAL	\N	\N	4
82bdc7b4-8469-4281-8555-216e4f9369c9	es	La evidencia apunta en otra dirección.	The evidence points in another direction.	\N	debate	ADVANCED	CONVERSATION_ES	FORMAL	\N	\N	4
0715dc11-ec49-4bd9-baff-5562b2851f70	es	Es un planteamiento paradójico.	It is a paradoxical approach.	\N	debate	ADVANCED	CONVERSATION_ES	FORMAL	\N	\N	4
60cc0e3c-b818-4bc4-bb30-84d8fe7cc821	es	Dicho esto, la conclusión es clara.	Having said that, the conclusion is clear.	\N	debate	ADVANCED	CONVERSATION_ES	FORMAL	\N	\N	4
628d2253-d58a-4024-831a-1b3f18f58552	es	Una mesa para dos, por favor.	A table for two, please.	\N	restaurant	BEGINNER	FOOD_ES	NEUTRAL	\N	\N	4
9da66f4c-8728-45df-bb40-3800f78b4174	es	¿Cuál es el menú del día?	What is the daily menu?	\N	restaurant	BEGINNER	FOOD_ES	NEUTRAL	\N	\N	4
8a0ce400-b9b7-445d-893a-ab632712be63	es	Quiero pedir...	I would like to order...	\N	restaurant	BEGINNER	FOOD_ES	NEUTRAL	\N	\N	4
92186452-a210-4b7f-b5b9-8d9ce7f11f81	es	¿Qué recomienda?	What do you recommend?	\N	restaurant	BEGINNER	FOOD_ES	NEUTRAL	\N	\N	4
1b70b64e-6093-4ad0-96ab-c1cdd25e8197	es	Soy vegetariano/a.	I am vegetarian.	\N	restaurant	BEGINNER	FOOD_ES	NEUTRAL	\N	\N	4
9c57cfb4-ffec-4d32-b350-93cfeff1e4b6	es	¿Tiene opciones sin gluten?	Do you have gluten-free options?	\N	restaurant	BEGINNER	FOOD_ES	NEUTRAL	\N	\N	4
bda9d624-4fea-48bc-b5fe-15e8d11dec34	es	Está muy delicioso.	It is very delicious.	\N	restaurant	BEGINNER	FOOD_ES	NEUTRAL	\N	\N	4
109582d2-c5ec-447b-83b8-90f24f01446a	es	Más agua, por favor.	More water, please.	\N	restaurant	BEGINNER	FOOD_ES	NEUTRAL	\N	\N	4
a6acfcf4-a7d0-4bcd-a0f0-719f6aa53d93	es	¿Está incluido el postre?	Is dessert included?	\N	restaurant	BEGINNER	FOOD_ES	NEUTRAL	\N	\N	4
0e95b1f5-4959-4c8e-91c5-62e1308e21ef	es	Para llevar, por favor.	To go, please.	\N	restaurant	BEGINNER	FOOD_ES	NEUTRAL	\N	\N	4
a6c39263-c7ab-47f2-90f8-3ed6f8cd63ca	es	¿Puedo ver la carta?	Can I see the menu?	\N	restaurant	BEGINNER	FOOD_ES	NEUTRAL	\N	\N	4
d7316045-fc20-49ab-967d-058a70abfbe9	es	Estaba muy bueno.	It was very good.	\N	restaurant	BEGINNER	FOOD_ES	NEUTRAL	\N	\N	4
518b801d-4e0f-404c-8d5e-a5576d4d023b	es	Sin sal, por favor.	Without salt, please.	\N	restaurant	BEGINNER	FOOD_ES	NEUTRAL	\N	\N	4
0ce2cd8f-627a-40f5-828d-7f723dce75b0	es	¿Tiene mesa disponible?	Do you have a table available?	\N	restaurant	BEGINNER	FOOD_ES	NEUTRAL	\N	\N	4
cdb4b1b2-2d9e-45b8-9c4a-abcd271502f5	es	Voy a pagar con tarjeta.	I am going to pay by card.	\N	restaurant	BEGINNER	FOOD_ES	NEUTRAL	\N	\N	4
947373d6-d417-41bc-931e-759efcff179e	es	¿Podría cambiar mi pedido?	Could I change my order?	\N	restaurant	INTERMEDIATE	FOOD_ES	FORMAL	\N	\N	4
608cd512-cbf6-476d-9544-3ad7ab659f66	es	Me falta un cubierto.	I am missing a utensil.	\N	restaurant	INTERMEDIATE	FOOD_ES	NEUTRAL	\N	\N	4
30f50faa-05fd-4155-97b7-fa598f6726bf	es	¿Cuánto tiempo de espera hay?	How long is the wait?	\N	restaurant	INTERMEDIATE	FOOD_ES	NEUTRAL	\N	\N	4
a64d60da-87a0-44ac-bf65-ce82bce996f1	es	El plato llegó frío.	The dish arrived cold.	\N	restaurant	INTERMEDIATE	FOOD_ES	NEUTRAL	\N	\N	4
99948ba0-9bea-4cd2-a4a7-1057647ac4c4	es	¿Pueden separar la cuenta?	Can you split the bill?	\N	restaurant	INTERMEDIATE	FOOD_ES	NEUTRAL	\N	\N	4
10e4ea87-7b9e-407d-9423-b40928962746	es	Tenemos una reserva a nombre de...	We have a reservation under the name of...	\N	restaurant	INTERMEDIATE	FOOD_ES	FORMAL	\N	\N	4
911c02e7-fb48-4846-b7bb-319d940b14e3	es	¿Hay alguna promoción hoy?	Is there any special today?	\N	restaurant	INTERMEDIATE	FOOD_ES	NEUTRAL	\N	\N	4
765103cb-f6e7-43f4-a25d-8d8f29424db6	es	Me gustaría una mesa cerca de la ventana.	I would like a table near the window.	\N	restaurant	INTERMEDIATE	FOOD_ES	FORMAL	\N	\N	4
1062def9-86f5-4eee-af3b-01f54b25208e	es	¿El precio incluye el servicio?	Does the price include the service charge?	\N	restaurant	INTERMEDIATE	FOOD_ES	NEUTRAL	\N	\N	4
7c546e76-3195-4190-ae19-e6fa6b58a65a	es	Quiero dejar propina.	I want to leave a tip.	\N	restaurant	INTERMEDIATE	FOOD_ES	NEUTRAL	\N	\N	4
e7569dd0-0164-49e0-9073-de9048878745	es	¿Dónde está la estación de tren?	Where is the train station?	\N	transport	BEGINNER	TRAVEL_ES	NEUTRAL	\N	\N	4
4d8bdddb-8f08-4176-8927-aaabd3db360c	es	¿Cuánto cuesta un boleto?	How much does a ticket cost?	\N	transport	BEGINNER	TRAVEL_ES	NEUTRAL	\N	\N	4
d82043cb-2e4e-4b5e-b28b-e92fa16dab13	es	¿A qué hora sale el tren?	What time does the train leave?	\N	transport	BEGINNER	TRAVEL_ES	NEUTRAL	\N	\N	4
38f8b484-8b8c-40b7-b279-2f23046835a7	es	Quiero ir al aeropuerto.	I want to go to the airport.	\N	transport	BEGINNER	TRAVEL_ES	NEUTRAL	\N	\N	4
64489c0a-bf06-4e1b-8749-c26d6a53ccec	es	¿Hay un autobús al centro?	Is there a bus to the center?	\N	transport	BEGINNER	TRAVEL_ES	NEUTRAL	\N	\N	4
4324e4e3-ca2e-4d6a-9d74-99bf26cb7631	es	¿Puede llamar un taxi?	Can you call a taxi?	\N	transport	BEGINNER	TRAVEL_ES	NEUTRAL	\N	\N	4
d0980466-d18f-4f40-8452-c2204b7254eb	es	¿Dónde puedo comprar un billete?	Where can I buy a ticket?	\N	transport	BEGINNER	TRAVEL_ES	NEUTRAL	\N	\N	4
2ba3eb6f-5765-435b-a103-256be22bd2be	es	Necesito un mapa.	I need a map.	\N	navigation	BEGINNER	TRAVEL_ES	NEUTRAL	\N	\N	4
deff1c63-42e4-4905-8acc-50e62284f7b6	es	¿Está lejos de aquí?	Is it far from here?	\N	navigation	BEGINNER	TRAVEL_ES	NEUTRAL	\N	\N	4
9c8cbf4e-6dc6-4dd4-8be0-aad62f5ae7de	es	Gire a la derecha.	Turn right.	\N	navigation	BEGINNER	TRAVEL_ES	NEUTRAL	\N	\N	4
29ca7740-789f-47f6-9b0b-edaf175a52ca	es	Gire a la izquierda.	Turn left.	\N	navigation	BEGINNER	TRAVEL_ES	NEUTRAL	\N	\N	4
9d81f533-da1f-4250-b795-b53982c82cb0	es	Siga recto.	Go straight ahead.	\N	navigation	BEGINNER	TRAVEL_ES	NEUTRAL	\N	\N	4
5b064f6b-017e-428d-8abf-4be011a2d9dd	es	¿Cuánto tiempo tarda?	How long does it take?	\N	navigation	BEGINNER	TRAVEL_ES	NEUTRAL	\N	\N	4
2f659fbb-1736-4daf-ac8d-ec4cc12b7ada	es	Mi maleta se perdió.	My suitcase was lost.	\N	airport	BEGINNER	TRAVEL_ES	NEUTRAL	\N	\N	4
53310921-9e4b-486a-baf5-21bdaeadc596	es	¿Hay retrasos en el vuelo?	Are there delays on the flight?	\N	airport	INTERMEDIATE	TRAVEL_ES	NEUTRAL	\N	\N	4
147dd090-e762-44f1-b4b7-94a9c136fa48	es	¿Dónde es la recogida de equipaje?	Where is the baggage claim?	\N	airport	INTERMEDIATE	TRAVEL_ES	NEUTRAL	\N	\N	4
b6c2706a-c909-4c7c-923a-5297cf777f5d	es	Necesito facturar mi maleta.	I need to check my suitcase.	\N	airport	INTERMEDIATE	TRAVEL_ES	NEUTRAL	\N	\N	4
91cdaf6e-8e69-47d4-972d-75a20dbd9403	es	¿Puedo cambiar mi asiento?	Can I change my seat?	\N	airport	INTERMEDIATE	TRAVEL_ES	FORMAL	\N	\N	4
5ac33e73-21eb-45d9-bebc-0aebc1bfd75e	es	¿Cuál es la puerta de embarque?	What is the boarding gate?	\N	airport	INTERMEDIATE	TRAVEL_ES	NEUTRAL	\N	\N	4
e48b66ec-ba38-456b-8754-ad1b689386df	es	Quiero hacer una escala en Madrid.	I want to make a stopover in Madrid.	\N	airport	INTERMEDIATE	TRAVEL_ES	FORMAL	\N	\N	4
b618d333-af41-4104-86be-b8abffaca5e4	es	¿El hotel incluye desayuno?	Does the hotel include breakfast?	\N	hotel	INTERMEDIATE	TRAVEL_ES	NEUTRAL	\N	\N	4
769e1470-42fd-48aa-90b4-4f4a15384aec	es	Quisiera una habitación doble.	I would like a double room.	\N	hotel	INTERMEDIATE	TRAVEL_ES	FORMAL	\N	\N	4
b9252d56-d783-45cc-b535-ed56cfaae5ff	es	¿A qué hora es el check-out?	What time is check-out?	\N	hotel	INTERMEDIATE	TRAVEL_ES	NEUTRAL	\N	\N	4
d1a74912-1e87-4d6a-a0fc-4c76e300bb44	es	El aire acondicionado no funciona.	The air conditioning is not working.	\N	hotel	INTERMEDIATE	TRAVEL_ES	NEUTRAL	\N	\N	4
1bd80dca-4289-4ee3-b5c7-e6290fc6bc98	es	Me duele la cabeza.	My head hurts.	\N	doctor	BEGINNER	HEALTH_ES	NEUTRAL	\N	\N	4
be8ad903-847c-4d73-a212-561fa0180a7f	es	Tengo fiebre.	I have a fever.	\N	doctor	BEGINNER	HEALTH_ES	NEUTRAL	\N	\N	4
09f1f61d-b366-444b-9f49-d75fae4383b7	es	Me siento mal.	I feel sick.	\N	doctor	BEGINNER	HEALTH_ES	NEUTRAL	\N	\N	4
dbba0479-f5cf-4459-bf1e-1e96dc4e83fd	es	Necesito un médico.	I need a doctor.	\N	emergency	BEGINNER	HEALTH_ES	NEUTRAL	\N	\N	4
740417f3-5781-4d25-8b7b-ea8d6a75830e	es	¿Dónde está la farmacia?	Where is the pharmacy?	\N	pharmacy	BEGINNER	HEALTH_ES	NEUTRAL	\N	\N	4
0df71b8f-5e6f-43dd-baeb-1304e8dd22fc	es	Tengo tos.	I have a cough.	\N	doctor	BEGINNER	HEALTH_ES	NEUTRAL	\N	\N	4
03fa62fe-3e23-4027-8fe3-50a567f90e91	es	Me duele el estómago.	My stomach hurts.	\N	doctor	BEGINNER	HEALTH_ES	NEUTRAL	\N	\N	4
52e639f6-f63d-427e-b28a-1b8ddfd4b379	es	Necesito una receta.	I need a prescription.	\N	pharmacy	BEGINNER	HEALTH_ES	NEUTRAL	\N	\N	4
f9534f97-ab52-4667-9af2-2dcc51742610	es	¿Tiene algo para el dolor?	Do you have something for the pain?	\N	pharmacy	BEGINNER	HEALTH_ES	NEUTRAL	\N	\N	4
0a0b9701-5390-49d1-bbbe-2ee4bb4d1811	es	Me corté el dedo.	I cut my finger.	\N	emergency	BEGINNER	HEALTH_ES	NEUTRAL	\N	\N	4
bdff1c4f-4c44-4cd2-8bb1-8505d0dbafb1	es	Estoy embarazada.	I am pregnant.	\N	doctor	BEGINNER	HEALTH_ES	NEUTRAL	\N	\N	4
7a403ce3-20fa-470a-8606-c3a3c16aa316	es	Tengo alergia a la penicilina.	I am allergic to penicillin.	\N	doctor	BEGINNER	HEALTH_ES	NEUTRAL	\N	\N	4
e3951da2-a06f-4165-a1bb-41ff319e95c0	es	No puedo respirar bien.	I cannot breathe well.	\N	emergency	BEGINNER	HEALTH_ES	NEUTRAL	\N	\N	4
ffd75fa6-7969-428b-9e3f-9e6b1d7ef504	es	¿Cuándo debo tomar la medicina?	When should I take the medicine?	\N	pharmacy	BEGINNER	HEALTH_ES	NEUTRAL	\N	\N	4
c7459771-e72a-4bc5-aaf4-f170a13469c8	es	Quiero hacer una cita.	I want to make an appointment.	\N	doctor	BEGINNER	HEALTH_ES	NEUTRAL	\N	\N	4
3c5af3c9-a0e3-424a-9ba1-6ab60209c1b2	es	Llevo tres días con dolor.	I have had pain for three days.	\N	doctor	INTERMEDIATE	HEALTH_ES	NEUTRAL	\N	\N	4
1ea5bd3f-a267-47cc-9805-a4295a7395af	es	¿Necesito una radiografía?	Do I need an X-ray?	\N	doctor	INTERMEDIATE	HEALTH_ES	NEUTRAL	\N	\N	4
2a753c33-9ee0-4f09-b423-24d0c427fd94	es	El dolor es constante.	The pain is constant.	\N	doctor	INTERMEDIATE	HEALTH_ES	NEUTRAL	\N	\N	4
163350ed-4934-49b2-8b72-a5ebf44b796a	es	Tomo medicamento para la presión.	I take medication for blood pressure.	\N	doctor	INTERMEDIATE	HEALTH_ES	NEUTRAL	\N	\N	4
064f3ac4-5ba0-4c3e-a919-da921664fc17	es	Necesito que me remita a un especialista.	I need a referral to a specialist.	\N	doctor	INTERMEDIATE	HEALTH_ES	FORMAL	\N	\N	4
265e955b-f370-4d3a-a3a5-f7565bde07a4	es	¿Cuáles son los efectos secundarios?	What are the side effects?	\N	pharmacy	INTERMEDIATE	HEALTH_ES	NEUTRAL	\N	\N	4
755ae3c5-bf24-48eb-849f-09608177fbaf	es	¿Tengo que operar?	Do I need surgery?	\N	doctor	INTERMEDIATE	HEALTH_ES	NEUTRAL	\N	\N	4
3a97866b-24d2-4daf-a9a3-18c120a95dcc	es	Me desmayé esta mañana.	I fainted this morning.	\N	emergency	INTERMEDIATE	HEALTH_ES	NEUTRAL	\N	\N	4
a5b6c522-980b-4a28-8756-c389091a620b	es	¿Cuándo estarán listos los resultados?	When will the results be ready?	\N	doctor	INTERMEDIATE	HEALTH_ES	NEUTRAL	\N	\N	4
f329b4f3-adc6-4b4d-b31a-bb18c951664e	es	Tengo seguro médico.	I have medical insurance.	\N	doctor	INTERMEDIATE	HEALTH_ES	NEUTRAL	\N	\N	4
67ad7beb-f90f-4ff5-a21e-dc4d57882894	es	Buenos días, ¿en qué le puedo ayudar?	Good morning, how can I help you?	\N	office	BEGINNER	BUSINESS_ES	FORMAL	\N	\N	4
6e745c73-5fd9-47e5-920e-da419d3608db	es	Tengo una reunión a las tres.	I have a meeting at three.	\N	office	BEGINNER	BUSINESS_ES	NEUTRAL	\N	\N	4
dc07e0c6-f2bd-41ab-996e-44e2f2d8703b	es	¿Puede enviarme el informe?	Can you send me the report?	\N	office	BEGINNER	BUSINESS_ES	FORMAL	\N	\N	4
b8fe20c2-1312-4be0-a91a-52a9ce6e6e6e	es	Necesito hablar con el director.	I need to speak with the director.	\N	office	BEGINNER	BUSINESS_ES	FORMAL	\N	\N	4
60a5d86e-1a98-45fc-a4d9-d63bb59b2cd5	es	El plazo es el viernes.	The deadline is Friday.	\N	office	BEGINNER	BUSINESS_ES	NEUTRAL	\N	\N	4
0cf18ab0-119a-455e-a6bf-038f5a58b8c0	es	¿Puede repetir eso más despacio?	Can you repeat that more slowly?	\N	office	BEGINNER	BUSINESS_ES	FORMAL	\N	\N	4
cb1995f2-bb04-4ff8-9897-e2b24a9bc402	es	Voy a enviarle un correo.	I am going to send you an email.	\N	office	BEGINNER	BUSINESS_ES	FORMAL	\N	\N	4
c999a407-979a-48be-b123-6dfa8aaa5cd6	es	El proyecto está en progreso.	The project is in progress.	\N	office	BEGINNER	BUSINESS_ES	NEUTRAL	\N	\N	4
9768cc59-21bc-4d96-8f9b-d2c3d6b488bd	es	Necesitamos más tiempo.	We need more time.	\N	office	BEGINNER	BUSINESS_ES	NEUTRAL	\N	\N	4
c7783b63-ee0d-4c0b-ba55-5e090ffef56f	es	¿Cuál es el presupuesto?	What is the budget?	\N	office	BEGINNER	BUSINESS_ES	NEUTRAL	\N	\N	4
20be68fe-5b22-4a91-8a28-94dfda0a7306	es	Hay que revisar el contrato.	We need to review the contract.	\N	office	BEGINNER	BUSINESS_ES	FORMAL	\N	\N	4
f60159fb-ec95-4628-be14-6d8e78510b0a	es	La presentación es mañana.	The presentation is tomorrow.	\N	office	BEGINNER	BUSINESS_ES	NEUTRAL	\N	\N	4
401c2a40-c269-410b-9dbc-6334f5d1b28b	es	¿Podemos agendar una llamada?	Can we schedule a call?	\N	office	BEGINNER	BUSINESS_ES	FORMAL	\N	\N	4
f78e2da9-f853-42f7-9f19-915837bd37c9	es	Voy a trabajar desde casa hoy.	I am going to work from home today.	\N	office	BEGINNER	BUSINESS_ES	NEUTRAL	\N	\N	4
971efc20-a27d-4170-b36b-bfdcd24b3815	es	El cliente está satisfecho.	The client is satisfied.	\N	office	BEGINNER	BUSINESS_ES	NEUTRAL	\N	\N	4
73acef83-890e-4014-89bb-4674da9add9d	es	Quisiera proponer una nueva estrategia.	I would like to propose a new strategy.	\N	meeting	UPPER_INTERMEDIATE	BUSINESS_ES	FORMAL	\N	\N	4
dd599fa4-9758-4b1d-87fb-8d59cc1c6c2e	es	Los resultados superaron las expectativas.	The results exceeded expectations.	\N	meeting	UPPER_INTERMEDIATE	BUSINESS_ES	FORMAL	\N	\N	4
f3a6699c-613f-411a-8724-f13d4ee29cca	es	Debemos analizar el impacto a largo plazo.	We must analyze the long-term impact.	\N	meeting	UPPER_INTERMEDIATE	BUSINESS_ES	FORMAL	\N	\N	4
66480b16-3269-4559-b2df-c8f5dafd50b0	es	El informe refleja una tendencia positiva.	The report reflects a positive trend.	\N	meeting	UPPER_INTERMEDIATE	BUSINESS_ES	FORMAL	\N	\N	4
968540fe-6a4f-4b05-9127-d0f559e01e86	es	Necesitamos llegar a un acuerdo hoy.	We need to reach an agreement today.	\N	meeting	UPPER_INTERMEDIATE	BUSINESS_ES	FORMAL	\N	\N	4
940506d3-5d53-40e3-9dd1-1024470690d9	es	Eso está fuera de nuestro presupuesto.	That is outside our budget.	\N	negotiation	UPPER_INTERMEDIATE	BUSINESS_ES	FORMAL	\N	\N	4
32630147-0e52-41d1-9fb6-2b24781f84f0	es	¿Cuáles son los términos del contrato?	What are the terms of the contract?	\N	negotiation	UPPER_INTERMEDIATE	BUSINESS_ES	FORMAL	\N	\N	4
07e2e939-05c8-426e-af65-2793829f5a32	es	Podemos ofrecer un descuento del diez por ciento.	We can offer a ten percent discount.	\N	negotiation	UPPER_INTERMEDIATE	BUSINESS_ES	FORMAL	\N	\N	4
1f77be7c-b91b-4174-b3ee-282330b25e25	es	El plazo de entrega es negociable.	The delivery deadline is negotiable.	\N	negotiation	UPPER_INTERMEDIATE	BUSINESS_ES	FORMAL	\N	\N	4
cbb4f0cb-c041-4f5f-a65b-ef82881fc7c0	es	Firmaremos el acuerdo la próxima semana.	We will sign the agreement next week.	\N	negotiation	UPPER_INTERMEDIATE	BUSINESS_ES	FORMAL	\N	\N	4
1152496f-39da-4515-a6c4-d455e27c2e2e	es	El cliente quiere una reunión urgente.	The client wants an urgent meeting.	\N	office	INTERMEDIATE	BUSINESS_ES	FORMAL	\N	\N	4
61c4bf09-9f6d-4a6e-980c-b3517988e506	es	Necesito revisar los números antes.	I need to review the numbers first.	\N	office	INTERMEDIATE	BUSINESS_ES	NEUTRAL	\N	\N	4
d78aaaca-2de0-48fc-af71-a8c1afc61916	es	¿Cuándo es la fecha límite?	When is the deadline?	\N	office	INTERMEDIATE	BUSINESS_ES	NEUTRAL	\N	\N	4
772493c4-4df1-4694-bb4b-8293a93926cc	es	El equipo está trabajando en ello.	The team is working on it.	\N	office	INTERMEDIATE	BUSINESS_ES	NEUTRAL	\N	\N	4
8db65585-29b3-49ff-8058-05ad38ce377f	es	Hay que actualizar el presupuesto.	We need to update the budget.	\N	office	INTERMEDIATE	BUSINESS_ES	FORMAL	\N	\N	4
b77ac305-4a69-4024-826d-a13de67ec988	es	La reunión fue cancelada.	The meeting was cancelled.	\N	office	INTERMEDIATE	BUSINESS_ES	NEUTRAL	\N	\N	4
15276013-dc8d-49be-8f76-0cd8abdee7f0	es	Vamos a reagendar para la próxima semana.	We are going to reschedule for next week.	\N	office	INTERMEDIATE	BUSINESS_ES	FORMAL	\N	\N	4
462b7444-d9e3-4994-8378-8bbffebf1353	es	La propuesta carece de fundamento financiero.	The proposal lacks financial foundation.	\N	negotiation	ADVANCED	BUSINESS_ES	FORMAL	\N	\N	4
2b678783-e63c-46b2-a716-d501c568aff3	es	Debemos reevaluar nuestra posición estratégica.	We must reevaluate our strategic position.	\N	negotiation	ADVANCED	BUSINESS_ES	FORMAL	\N	\N	4
2d9b748b-ee04-451d-b6ca-702c650af9f5	es	El impacto a largo plazo es significativo.	The long-term impact is significant.	\N	meeting	ADVANCED	BUSINESS_ES	FORMAL	\N	\N	4
41ef8d7f-d716-47fd-aa7a-139e93fe60ce	es	Hay que matizar los términos del acuerdo.	We need to qualify the terms of the agreement.	\N	negotiation	ADVANCED	BUSINESS_ES	FORMAL	\N	\N	4
26488e8c-0b65-401c-b03b-2e45c0d23079	es	La tendencia del mercado apunta al crecimiento.	The market trend points toward growth.	\N	meeting	ADVANCED	BUSINESS_ES	FORMAL	\N	\N	4
92ebac0b-aea7-4a09-b6cc-4fb632c57f61	es	El paradigma empresarial ha cambiado radicalmente.	The business paradigm has changed radically.	\N	meeting	ADVANCED	BUSINESS_ES	FORMAL	\N	\N	4
380d010e-889c-4740-99b3-b49649fb819b	es	Abordar este desafío requiere un enfoque innovador.	Addressing this challenge requires an innovative approach.	\N	meeting	ADVANCED	BUSINESS_ES	FORMAL	\N	\N	4
a38d4f73-cc0a-41d1-9812-a1de2fb7a449	es	La sostenibilidad es un criterio fundamental.	Sustainability is a fundamental criterion.	\N	meeting	ADVANCED	BUSINESS_ES	FORMAL	\N	\N	4
bc39aabb-442a-4917-8f53-3c4cf0f90c72	es	Debemos fundamentar mejor nuestra propuesta.	We must better ground our proposal.	\N	negotiation	ADVANCED	BUSINESS_ES	FORMAL	\N	\N	4
623fbed0-a99e-4c28-991d-83fe4728bcf7	es	El vínculo con el cliente es estratégico.	The relationship with the client is strategic.	\N	negotiation	ADVANCED	BUSINESS_ES	FORMAL	\N	\N	4
317c3813-5876-478a-9aea-148430f03f7d	es	La premisa de tu argumento es cuestionable.	The premise of your argument is questionable.	\N	debate	ADVANCED	CONVERSATION_ES	FORMAL	\N	\N	4
5e3ed8c3-fae3-4193-b5ad-648b549df4ea	es	Hay una contradicción inherente en ese enfoque.	There is an inherent contradiction in that approach.	\N	debate	ADVANCED	CONVERSATION_ES	FORMAL	\N	\N	4
159d04bf-601e-48f3-8d74-2a66f8832350	es	El debate requiere un análisis más exhaustivo.	The debate requires a more exhaustive analysis.	\N	debate	ADVANCED	CONVERSATION_ES	FORMAL	\N	\N	4
817e62d9-cede-40b7-a027-fcf0d8eb17b1	es	Tu perspectiva es válida pero incompleta.	Your perspective is valid but incomplete.	\N	debate	ADVANCED	CONVERSATION_ES	FORMAL	\N	\N	4
27748321-b855-4874-98cd-ca6426f6f9d7	es	En pocas palabras, el argumento no se sostiene.	In a few words, the argument does not hold.	\N	debate	ADVANCED	CONVERSATION_ES	FORMAL	\N	\N	4
450487ff-2b9e-4b44-8549-4e953be261f7	es	El maridaje de este vino es perfecto.	The pairing of this wine is perfect.	\N	restaurant	UPPER_INTERMEDIATE	FOOD_ES	FORMAL	\N	\N	4
a74c4578-ee08-4d50-b039-699021a15b6b	es	¿Podría describir los ingredientes del plato?	Could you describe the ingredients of the dish?	\N	restaurant	UPPER_INTERMEDIATE	FOOD_ES	FORMAL	\N	\N	4
5e231a34-1083-4f8f-bcd4-a68aeeb03e2b	es	Prefiero algo ligero para cenar.	I prefer something light for dinner.	\N	restaurant	UPPER_INTERMEDIATE	FOOD_ES	NEUTRAL	\N	\N	4
e072f8c7-128f-43f6-b264-63de38c19c2b	es	El menú de degustación incluye siete platos.	The tasting menu includes seven courses.	\N	restaurant	UPPER_INTERMEDIATE	FOOD_ES	FORMAL	\N	\N	4
db500b6a-8cc9-4ecb-8a24-a9995859c42f	es	Quisiera algo típico de la región.	I would like something typical of the region.	\N	restaurant	UPPER_INTERMEDIATE	FOOD_ES	FORMAL	\N	\N	4
b2fcfadd-a5f8-4bc0-b814-a54673112792	es	¿Tiene opciones para intolerantes a la lactosa?	Do you have options for the lactose intolerant?	\N	restaurant	UPPER_INTERMEDIATE	FOOD_ES	NEUTRAL	\N	\N	4
283ed0d8-ceff-4227-a39d-c23c7b30bd8c	es	El servicio estuvo a la altura.	The service was up to standard.	\N	restaurant	UPPER_INTERMEDIATE	FOOD_ES	FORMAL	\N	\N	4
9b4d32ae-2d3b-4293-a981-5c6d1ac8ac12	es	Me gustaría reservar una mesa privada.	I would like to reserve a private table.	\N	restaurant	UPPER_INTERMEDIATE	FOOD_ES	FORMAL	\N	\N	4
d369b79b-f5ed-428b-ba7b-815f54526320	es	El precio no refleja la calidad del plato.	The price does not reflect the quality of the dish.	\N	restaurant	UPPER_INTERMEDIATE	FOOD_ES	NEUTRAL	\N	\N	4
798cb243-c5ce-4cf6-8183-393c041c6eff	es	¿Podría hablar con el chef?	Could I speak with the chef?	\N	restaurant	UPPER_INTERMEDIATE	FOOD_ES	FORMAL	\N	\N	4
ec020a9e-8ae3-42d4-a5ea-57be93e6afe5	es	La gastronomía local refleja la identidad cultural.	Local gastronomy reflects cultural identity.	\N	culture	ADVANCED	FOOD_ES	FORMAL	\N	\N	4
f9eee5e0-8f40-48d0-9779-bbcdb191792f	es	El equilibrio de sabores es extraordinariamente complejo.	The balance of flavors is extraordinarily complex.	\N	culture	ADVANCED	FOOD_ES	FORMAL	\N	\N	4
d6c83042-a5b5-4e8f-bd76-cddcb2979aff	es	La sostenibilidad alimentaria es un desafío global.	Food sustainability is a global challenge.	\N	culture	ADVANCED	FOOD_ES	FORMAL	\N	\N	4
839f71d4-c270-4712-bbfa-536944b1d718	es	La fusión culinaria trasciende las fronteras culturales.	Culinary fusion transcends cultural boundaries.	\N	culture	ADVANCED	FOOD_ES	FORMAL	\N	\N	4
31e8b6f0-3bbc-491c-a179-d8362717dc5e	es	El concepto de umami es inherente a esta cocina.	The concept of umami is inherent to this cuisine.	\N	culture	ADVANCED	FOOD_ES	FORMAL	\N	\N	4
90baf855-41b7-40d3-adac-c0ae8f93951e	es	La técnica culinaria requiere precisión y consistencia.	The culinary technique requires precision and consistency.	\N	culture	ADVANCED	FOOD_ES	FORMAL	\N	\N	4
2302381b-1841-48e7-b81a-20b312ff4ff8	es	El vínculo entre alimentación y salud es innegable.	The link between diet and health is undeniable.	\N	culture	ADVANCED	FOOD_ES	FORMAL	\N	\N	4
dc87c010-4f33-4f15-84df-b87379afb5de	es	Los ingredientes locales otorgan autenticidad al plato.	Local ingredients give authenticity to the dish.	\N	culture	ADVANCED	FOOD_ES	FORMAL	\N	\N	4
c5691b60-ffc0-46ab-a4ba-cab6f0fd159c	es	La tendencia vegana está transformando la industria.	The vegan trend is transforming the industry.	\N	culture	ADVANCED	FOOD_ES	FORMAL	\N	\N	4
312108b2-0c7d-49a4-8bd9-da2fe42eadad	es	Dicho esto, la tradición culinaria prevalece.	Having said that, culinary tradition prevails.	\N	culture	ADVANCED	FOOD_ES	FORMAL	\N	\N	4
f15a4a52-55f7-41e1-9237-da312ab9fa5e	es	El diagnóstico requiere más pruebas.	The diagnosis requires more tests.	\N	doctor	UPPER_INTERMEDIATE	HEALTH_ES	FORMAL	\N	\N	4
7a2045c3-008e-430a-b17c-0c80795fe0ac	es	Los síntomas empezaron hace una semana.	The symptoms started a week ago.	\N	doctor	UPPER_INTERMEDIATE	HEALTH_ES	NEUTRAL	\N	\N	4
cfa26468-2933-416c-b72a-089ebf7289a9	es	¿Hay alguna contraindicación con este medicamento?	Is there any contraindication with this medication?	\N	pharmacy	UPPER_INTERMEDIATE	HEALTH_ES	FORMAL	\N	\N	4
251e8ce8-59e3-4d97-9c39-8c0882662a46	es	Necesito que me hagan un análisis de sangre.	I need to have a blood test done.	\N	doctor	UPPER_INTERMEDIATE	HEALTH_ES	FORMAL	\N	\N	4
bdb3eb13-8ca6-4051-87ec-ea66d760e4de	es	El médico me recetó un antiinflamatorio.	The doctor prescribed me an anti-inflammatory.	\N	pharmacy	UPPER_INTERMEDIATE	HEALTH_ES	NEUTRAL	\N	\N	4
e0058595-4f51-45a9-9d1c-f9aecb355b16	es	¿Cuál es el tratamiento recomendado?	What is the recommended treatment?	\N	doctor	UPPER_INTERMEDIATE	HEALTH_ES	FORMAL	\N	\N	4
ac1ed4f5-3485-4b80-b265-6e27a647076c	es	El dolor se irradia hacia la espalda.	The pain radiates toward the back.	\N	doctor	UPPER_INTERMEDIATE	HEALTH_ES	NEUTRAL	\N	\N	4
dd71f3d1-4776-4df2-85f3-e1d22df01534	es	Tengo antecedentes familiares de diabetes.	I have a family history of diabetes.	\N	doctor	UPPER_INTERMEDIATE	HEALTH_ES	FORMAL	\N	\N	4
b83712fd-b4bd-4280-a2bc-ad4c411cd970	es	¿Es necesaria la cirugía en este caso?	Is surgery necessary in this case?	\N	doctor	UPPER_INTERMEDIATE	HEALTH_ES	FORMAL	\N	\N	4
4b58aa17-c2c8-46e3-bc9f-4637791122d8	es	El paciente está respondiendo bien al tratamiento.	The patient is responding well to the treatment.	\N	doctor	UPPER_INTERMEDIATE	HEALTH_ES	FORMAL	\N	\N	4
42906e2e-079b-4727-8fb0-7953ea44c93d	es	La etiología de la enfermedad es aún desconocida.	The etiology of the disease is still unknown.	\N	medical	ADVANCED	HEALTH_ES	FORMAL	\N	\N	4
0fef5632-c27a-447e-8acd-53f2b8a6a983	es	El pronóstico depende de varios factores inherentes.	The prognosis depends on several inherent factors.	\N	medical	ADVANCED	HEALTH_ES	FORMAL	\N	\N	4
b10be751-4ead-4d02-8a56-ead4f0748d88	es	La intervención quirúrgica conlleva riesgos significativos.	The surgical intervention carries significant risks.	\N	medical	ADVANCED	HEALTH_ES	FORMAL	\N	\N	4
b41301c3-5d3a-4d0e-818e-3d9a69f32892	es	El sistema inmunológico está comprometido.	The immune system is compromised.	\N	medical	ADVANCED	HEALTH_ES	FORMAL	\N	\N	4
f6ca8aab-c961-431f-a9bc-34353a22c4e7	es	Se requiere un enfoque multidisciplinario.	A multidisciplinary approach is required.	\N	medical	ADVANCED	HEALTH_ES	FORMAL	\N	\N	4
019c6f6e-4936-4c19-a20d-06d2e22044fb	es	La evidencia clínica respalda este tratamiento.	The clinical evidence supports this treatment.	\N	medical	ADVANCED	HEALTH_ES	FORMAL	\N	\N	4
df398d92-16ee-46a7-8826-117f1bf569dd	es	El paciente presenta una condición crónica subyacente.	The patient presents an underlying chronic condition.	\N	medical	ADVANCED	HEALTH_ES	FORMAL	\N	\N	4
3826f936-8656-4eff-ae99-d82c954f8d45	es	Hay que evaluar la relación riesgo-beneficio.	We must evaluate the risk-benefit relationship.	\N	medical	ADVANCED	HEALTH_ES	FORMAL	\N	\N	4
344a15d5-b7bf-441a-a362-f8311d022dca	es	El tratamiento debe ser personalizado al paciente.	The treatment must be personalized to the patient.	\N	medical	ADVANCED	HEALTH_ES	FORMAL	\N	\N	4
be57d2b5-24bf-4946-b71e-58502a675e78	es	La remisión completa es el objetivo terapéutico.	Complete remission is the therapeutic objective.	\N	medical	ADVANCED	HEALTH_ES	FORMAL	\N	\N	4
dae2c07a-e998-4c4c-8336-888abfcfbfdf	es	Quisiera extender mi estancia dos noches más.	I would like to extend my stay two more nights.	\N	hotel	UPPER_INTERMEDIATE	TRAVEL_ES	FORMAL	\N	\N	4
f3bdf396-c96f-4134-9391-ccc6c4f6c72f	es	El vuelo fue desviado por mal tiempo.	The flight was diverted due to bad weather.	\N	airport	UPPER_INTERMEDIATE	TRAVEL_ES	NEUTRAL	\N	\N	4
81f0f4fa-33ae-4332-8a49-0237a434c5fd	es	¿Hay servicio de transporte al aeropuerto?	Is there a transport service to the airport?	\N	hotel	UPPER_INTERMEDIATE	TRAVEL_ES	NEUTRAL	\N	\N	4
1d47c4a5-2a77-4789-a404-8bc65dff139c	es	Perdí mi pasaporte y necesito ayuda urgente.	I lost my passport and need urgent help.	\N	emergency	UPPER_INTERMEDIATE	TRAVEL_ES	NEUTRAL	\N	\N	4
92818da7-f51f-48aa-9028-68bf5e5d9a92	es	¿Puede recomendarme un lugar fuera de lo común?	Can you recommend an off-the-beaten-path place?	\N	tourism	UPPER_INTERMEDIATE	TRAVEL_ES	NEUTRAL	\N	\N	4
8a1c0632-b5be-4c11-a30d-56299fdf2725	es	La excursión incluye guía en español.	The excursion includes a Spanish-speaking guide.	\N	tourism	UPPER_INTERMEDIATE	TRAVEL_ES	NEUTRAL	\N	\N	4
c2707ce9-6b3a-4d38-b29c-2450c8773499	es	Necesito un seguro de viaje para este destino.	I need travel insurance for this destination.	\N	planning	UPPER_INTERMEDIATE	TRAVEL_ES	NEUTRAL	\N	\N	4
9e31399e-bf49-4299-b45b-5afe3c8917bc	es	¿Cuáles son los requisitos de entrada al país?	What are the entry requirements to the country?	\N	planning	UPPER_INTERMEDIATE	TRAVEL_ES	FORMAL	\N	\N	4
93de514f-3fb6-49ff-af04-39c8b8569367	es	La visa tarda diez días hábiles en procesarse.	The visa takes ten business days to process.	\N	planning	UPPER_INTERMEDIATE	TRAVEL_ES	FORMAL	\N	\N	4
a76cae24-2102-41f5-83ca-56654fd930c3	es	El alojamiento incluye todas las comidas.	The accommodation includes all meals.	\N	hotel	UPPER_INTERMEDIATE	TRAVEL_ES	NEUTRAL	\N	\N	4
d4afcc72-806c-46d6-a417-1034413c4868	es	El impacto del turismo masivo es paradójico.	The impact of mass tourism is paradoxical.	\N	culture	ADVANCED	TRAVEL_ES	FORMAL	\N	\N	4
c3fd07ce-cfb6-4d37-87b8-ab3100bc9254	es	Viajar amplía la perspectiva cultural del individuo.	Travelling broadens the cultural perspective of the individual.	\N	culture	ADVANCED	TRAVEL_ES	FORMAL	\N	\N	4
7c8aa32a-1297-4f15-aa84-b45c772a5335	es	La autenticidad del destino se está diluyendo.	The authenticity of the destination is being diluted.	\N	culture	ADVANCED	TRAVEL_ES	FORMAL	\N	\N	4
68b1bb46-630b-4200-aff1-b0416f809d9e	es	El turismo sostenible preserva el patrimonio local.	Sustainable tourism preserves local heritage.	\N	culture	ADVANCED	TRAVEL_ES	FORMAL	\N	\N	4
5ad42eef-2759-450f-b622-8f02995e883a	es	La globalización ha transformado la experiencia viajera.	Globalization has transformed the travel experience.	\N	culture	ADVANCED	TRAVEL_ES	FORMAL	\N	\N	4
2ea7d82b-52ec-49fb-8e28-7662f8691c30	es	El intercambio cultural enriquece la conciencia colectiva.	Cultural exchange enriches collective awareness.	\N	culture	ADVANCED	TRAVEL_ES	FORMAL	\N	\N	4
caadc322-6a7f-4f44-8ef6-b8325c23aa24	es	Hay que cuestionar el paradigma del turista pasivo.	We must question the paradigm of the passive tourist.	\N	culture	ADVANCED	TRAVEL_ES	FORMAL	\N	\N	4
81b37866-c517-4fbc-8255-1199959a9c44	es	La huella de carbono del turismo es significativa.	The carbon footprint of tourism is significant.	\N	culture	ADVANCED	TRAVEL_ES	FORMAL	\N	\N	4
adc69ced-0c4f-4d7b-9eee-15b87bae84f1	es	El vínculo entre viaje y aprendizaje es inherente.	The link between travel and learning is inherent.	\N	culture	ADVANCED	TRAVEL_ES	FORMAL	\N	\N	4
eaef0d6d-4314-47bc-8893-aa270eb761f3	es	Dicho esto, el turismo responsable es posible.	Having said that, responsible tourism is possible.	\N	culture	ADVANCED	TRAVEL_ES	FORMAL	\N	\N	4
\.


--
-- Data for Name: placement_answers; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.placement_answers (id, test_id, question_index, question_type, user_answer, correct_answer, is_correct) FROM stdin;
f1f355d5-b347-4397-9c3c-ab255ca1c8eb	ea86fe1e-3100-458f-93a5-1bb8a52d2f53	1	IMAGE_PICK	manzana	agua	f
250abacb-0d59-43de-8252-87b36dfb966c	ea86fe1e-3100-458f-93a5-1bb8a52d2f53	2	IMAGE_PICK	pan	pan	t
3263df32-a911-4510-b7d9-23655b1218bd	ea86fe1e-3100-458f-93a5-1bb8a52d2f53	3	GRAMMAR_FILL	somos	soy	f
85f2eccd-aa15-434d-a0de-68c31a42e2aa	ea86fe1e-3100-458f-93a5-1bb8a52d2f53	4	GRAMMAR_FILL	vivimos	vive	f
2e7d6010-2d2d-40e0-baf9-8acf02e177c3	ea86fe1e-3100-458f-93a5-1bb8a52d2f53	5	READING	agua	café con leche	f
28bdac95-c72b-430a-9f96-8eb68ad1dba2	ea86fe1e-3100-458f-93a5-1bb8a52d2f53	6	READING	lejos de todo	cerca de la estación	f
214ff144-d363-4e61-86c0-4ee3aa3914f6	ea86fe1e-3100-458f-93a5-1bb8a52d2f53	7	AUDIO_TAP	días ¿cómo	Buenos días, ¿cómo estás?	f
6663ddf8-e2be-4732-8f7a-0ec0b5a572c4	ea86fe1e-3100-458f-93a5-1bb8a52d2f53	8	AUDIO_TAP	mucho	Me llamo Carlos, mucho gusto.	f
e38112a8-2cdf-41aa-bff5-711248132cf5	ea86fe1e-3100-458f-93a5-1bb8a52d2f53	9	FREE_WRITE	r	Buenos días, quisiera un café, por favor.	f
3837ddaf-e5a0-4e1d-95c9-2335262b2d48	ea86fe1e-3100-458f-93a5-1bb8a52d2f53	10	FREE_WRITE	r	Perdón, ¿dónde está la farmacia más cercana?	f
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
-- Data for Name: sentence_structure; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.sentence_structure (id, spanish, english, level, display_order, lesson_number) FROM stdin;
1	Yo como manzanas	I eat apples	BEGINNER	1	3
2	Él habla español	He speaks Spanish	BEGINNER	2	3
3	Ella come pan	She eats bread	BEGINNER	3	3
4	Nosotros vivimos aquí	We live here	BEGINNER	4	3
5	Tú tienes un libro	You have a book	BEGINNER	5	3
6	Ellos beben agua	They drink water	BEGINNER	6	3
7	Yo quiero café	I want coffee	BEGINNER	7	3
8	Ella es mi madre	She is my mother	BEGINNER	8	3
9	Él tiene hambre	He is hungry	BEGINNER	9	3
10	Nosotros comemos arroz	We eat rice	BEGINNER	10	3
11	Yo estaba cansado ayer	I was tired yesterday	INTERMEDIATE	1	3
12	Ella quiere aprender inglés	She wants to learn English	INTERMEDIATE	2	3
13	Nosotros necesitamos más tiempo	We need more time	INTERMEDIATE	3	3
14	Él está trabajando ahora	He is working now	INTERMEDIATE	4	3
15	¿Puedes ayudarme por favor?	Can you help me please?	INTERMEDIATE	5	3
16	Ella tiene que ir al doctor	She has to go to the doctor	INTERMEDIATE	6	3
17	Yo no entiendo la pregunta	I don't understand the question	INTERMEDIATE	7	3
18	Ellos están esperando el tren	They are waiting for the train	INTERMEDIATE	8	3
19	¿A qué hora abre el banco?	What time does the bank open?	INTERMEDIATE	9	3
20	Nosotros vivimos cerca del centro	We live near the center	INTERMEDIATE	10	3
21	Aunque estaba cansado, terminó el trabajo	Although he was tired, he finished the work	UPPER_INTERMEDIATE	1	3
22	Si tuviera dinero, viajaría al mundo	If I had money, I would travel the world	UPPER_INTERMEDIATE	2	3
23	Es importante que estudies todos los días	It is important that you study every day	UPPER_INTERMEDIATE	3	3
24	Me alegra que hayas llegado a tiempo	I am glad that you arrived on time	UPPER_INTERMEDIATE	4	3
25	Sin embargo, no pudimos llegar al acuerdo	However, we could not reach an agreement	UPPER_INTERMEDIATE	5	3
26	Ella lleva tres años trabajando aquí	She has been working here for three years	UPPER_INTERMEDIATE	6	3
27	Por lo tanto, debemos cambiar la estrategia	Therefore, we must change the strategy	UPPER_INTERMEDIATE	7	3
28	¿Podrías explicarme cómo funciona esto?	Could you explain to me how this works?	UPPER_INTERMEDIATE	8	3
29	Puesto que no hay tiempo, hay que decidir	Since there is no time, we must decide	UPPER_INTERMEDIATE	9	3
30	Él se había ido antes de que yo llegara	He had left before I arrived	UPPER_INTERMEDIATE	10	3
31	A pesar de los desafíos, logramos el objetivo	Despite the challenges, we achieved the objective	ADVANCED	1	3
32	Cabe destacar que el impacto fue significativo	It is worth noting that the impact was significant	ADVANCED	2	3
33	Desde mi punto de vista, el argumento es débil	From my point of view, the argument is weak	ADVANCED	3	3
34	En definitiva, la sostenibilidad es fundamental	Ultimately, sustainability is fundamental	ADVANCED	4	3
35	Sin lugar a dudas, el paradigma ha cambiado	Without a doubt, the paradigm has changed	ADVANCED	5	3
36	Hay que reconocer que la situación es compleja	One must acknowledge that the situation is complex	ADVANCED	6	3
37	A fin de cuentas, los vínculos son lo que importa	After all, bonds are what matter	ADVANCED	7	3
38	El enfoque pragmático resultó ser más eficiente	The pragmatic approach turned out to be more efficient	ADVANCED	8	3
39	Dicho esto, la hipótesis requiere más análisis	Having said that, the hypothesis requires more analysis	ADVANCED	9	3
40	En pocas palabras, debemos profundizar el debate	In a few words, we must deepen the debate	ADVANCED	10	3
41	Yo tengo hambre	I am hungry	BEGINNER	11	3
42	Ella bebe leche	She drinks milk	BEGINNER	12	3
43	Él es mi amigo	He is my friend	BEGINNER	13	3
44	Nosotros somos familia	We are family	BEGINNER	14	3
45	Tú hablas muy bien	You speak very well	BEGINNER	15	3
46	Yo vivo en una casa	I live in a house	BEGINNER	16	3
47	Ella tiene un gato	She has a cat	BEGINNER	17	3
48	Él come pollo	He eats chicken	BEGINNER	18	3
49	Nosotros bebemos café	We drink coffee	BEGINNER	19	3
50	Tú eres mi amiga	You are my friend	BEGINNER	20	3
51	Yo necesito agua	I need water	BEGINNER	21	3
52	Ella habla español	She speaks Spanish	BEGINNER	22	3
53	Él quiere pan	He wants bread	BEGINNER	23	3
54	Nosotros tenemos un perro	We have a dog	BEGINNER	24	3
55	Tú comes ensalada	You eat salad	BEGINNER	25	3
56	Yo bebo jugo	I drink juice	BEGINNER	26	3
57	Ella vive con su familia	She lives with her family	BEGINNER	27	3
58	Él necesita un taxi	He needs a taxi	BEGINNER	28	3
59	Nosotros queremos sopa	We want soup	BEGINNER	29	3
60	Tú tienes una maleta	You have a suitcase	BEGINNER	30	3
61	Yo tengo que estudiar hoy	I have to study today	INTERMEDIATE	11	3
62	Ella está buscando su pasaporte	She is looking for her passport	INTERMEDIATE	12	3
63	Él no puede venir a la reunión	He cannot come to the meeting	INTERMEDIATE	13	3
64	Nosotros queremos hacer una reserva	We want to make a reservation	INTERMEDIATE	14	3
65	¿Dónde está la farmacia más cercana?	Where is the nearest pharmacy?	INTERMEDIATE	15	3
66	Ella lleva dos horas esperando	She has been waiting for two hours	INTERMEDIATE	16	3
67	Él necesita hablar con el jefe	He needs to speak with the boss	INTERMEDIATE	17	3
68	Nosotros tenemos un problema	We have a problem	INTERMEDIATE	18	3
69	¿Cuánto cuesta el billete de tren?	How much does the train ticket cost?	INTERMEDIATE	19	3
70	Ella quiere cambiar su habitación	She wants to change her room	INTERMEDIATE	20	3
71	Yo estoy aprendiendo español	I am learning Spanish	INTERMEDIATE	21	3
72	Él trabaja en una empresa grande	He works in a big company	INTERMEDIATE	22	3
73	Nosotros necesitamos más información	We need more information	INTERMEDIATE	23	3
74	¿Puede traerme la cuenta por favor?	Can you bring me the bill please?	INTERMEDIATE	24	3
75	Ella tiene alergia al queso	She is allergic to cheese	INTERMEDIATE	25	3
76	Yo tengo una cita con el doctor	I have an appointment with the doctor	INTERMEDIATE	26	3
77	Él está buscando trabajo	He is looking for work	INTERMEDIATE	27	3
78	Nosotros estamos esperando el vuelo	We are waiting for the flight	INTERMEDIATE	28	3
79	¿A qué hora sale el autobús?	What time does the bus leave?	INTERMEDIATE	29	3
80	Ella no entiende el contrato	She does not understand the contract	INTERMEDIATE	30	3
81	A menos que cambies de opinión, seguiremos adelante	Unless you change your mind, we will move forward	UPPER_INTERMEDIATE	11	3
82	Mientras que él trabaja, ella estudia	While he works, she studies	UPPER_INTERMEDIATE	12	3
83	Dado que no hay evidencia, no podemos concluir nada	Given that there is no evidence, we cannot conclude	UPPER_INTERMEDIATE	13	3
84	Para que funcione, necesitamos más recursos	So that it works, we need more resources	UPPER_INTERMEDIATE	14	3
85	Siempre que estudies, mejorarás tu nivel	As long as you study, you will improve your level	UPPER_INTERMEDIATE	15	3
86	En caso de que llegues tarde, avísame	In case you arrive late, let me know	UPPER_INTERMEDIATE	16	3
87	Ella lleva años desarrollando esta estrategia	She has spent years developing this strategy	UPPER_INTERMEDIATE	17	3
88	Por otro lado, los beneficios superan los riesgos	On the other hand, the benefits outweigh the risks	UPPER_INTERMEDIATE	18	3
89	En primer lugar, debemos analizar el contexto	In the first place, we must analyze the context	UPPER_INTERMEDIATE	19	3
90	A diferencia de antes, ahora tenemos más capacidad	Unlike before, we now have more capacity	UPPER_INTERMEDIATE	20	3
91	Cabe destacar que los resultados fueron positivos	It is worth noting that the results were positive	UPPER_INTERMEDIATE	21	3
92	En términos de impacto, el proyecto fue un éxito	In terms of impact, the project was a success	UPPER_INTERMEDIATE	22	3
93	Con respecto a tu pregunta, no tengo una respuesta	With respect to your question, I have no answer	UPPER_INTERMEDIATE	23	3
94	A lo largo del proceso, mantuvimos la consistencia	Throughout the process, we maintained consistency	UPPER_INTERMEDIATE	24	3
95	Lo que es más, el equipo trabajó de manera eficiente	What is more, the team worked efficiently	UPPER_INTERMEDIATE	25	3
96	Hay que tener en cuenta todos los factores	You have to take into account all the factors	UPPER_INTERMEDIATE	26	3
97	En cuanto a los resultados, son muy relevantes	Regarding the results, they are very relevant	UPPER_INTERMEDIATE	27	3
98	Si hubiera sabido, habría actuado de otra manera	If I had known, I would have acted differently	UPPER_INTERMEDIATE	28	3
99	Me alegra que hayas tomado la decisión correcta	I am glad that you made the right decision	UPPER_INTERMEDIATE	29	3
100	¿Podrías explicarme el proceso paso a paso?	Could you explain the process to me step by step?	UPPER_INTERMEDIATE	30	3
101	El paradigma actual no refleja la realidad compleja	The current paradigm does not reflect the complex reality	ADVANCED	11	3
102	Hay que reconocer que el dilema es de naturaleza ética	One must acknowledge that the dilemma is ethical in nature	ADVANCED	12	3
103	A grandes rasgos, la hipótesis carece de fundamento	Broadly speaking, the hypothesis lacks foundation	ADVANCED	13	3
104	El enfoque pragmático contrasta con el enfoque teórico	The pragmatic approach contrasts with the theoretical one	ADVANCED	14	3
105	Sin lugar a dudas, debemos profundizar en el análisis	Without a doubt, we must deepen the analysis	ADVANCED	15	3
106	Dicho esto, la premisa inicial sigue siendo válida	Having said that, the initial premise remains valid	ADVANCED	16	3
107	En pocas palabras, el vínculo entre ambos es inherente	In a few words, the link between both is inherent	ADVANCED	17	3
108	Vale la pena matizar que no todo es blanco o negro	It is worth qualifying that not everything is black or white	ADVANCED	18	3
109	Desde mi punto de vista, el criterio es subjetivo	From my point of view, the criterion is subjective	ADVANCED	19	3
110	El argumento contundente logró cambiar la perspectiva	The forceful argument managed to change the perspective	ADVANCED	20	3
111	A fin de cuentas, la conciencia colectiva prevalece	After all, collective conscience prevails	ADVANCED	21	3
112	En definitiva, la tendencia apunta hacia lo sostenible	Ultimately, the trend points toward sustainability	ADVANCED	22	3
113	Plantear un debate exhaustivo requiere preparación	Raising an exhaustive debate requires preparation	ADVANCED	23	3
114	La vulnerabilidad del sistema es un factor paradójico	The vulnerability of the system is a paradoxical factor	ADVANCED	24	3
115	Abordar el tema requiere una visión trascendental	Addressing the topic requires a transcendental vision	ADVANCED	25	3
116	El criterio ambivalente dificulta llegar a un consenso	The ambivalent criterion makes it difficult to reach consensus	ADVANCED	26	3
117	Fundamentar una tesis exige rigor y consistencia	Grounding a thesis demands rigor and consistency	ADVANCED	27	3
118	La estrategia versátil demostró ser más eficiente	The versatile strategy proved to be more efficient	ADVANCED	28	3
119	Asumir el desafío implica reconocer las consecuencias	Assuming the challenge implies acknowledging the consequences	ADVANCED	29	3
120	Generar un impacto real exige un enfoque pragmático	Generating real impact requires a pragmatic approach	ADVANCED	30	3
\.


--
-- Data for Name: sentence_words; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.sentence_words (id, sentence_id, word, grammar_role, translation, grammar_note, display_order, lesson_number) FROM stdin;
1	1	Yo	Subject (Pronoun)	I	—	1	3
2	1	como	Verb	eat	comer → 1st person	2	3
3	1	manzanas	Object	apples	feminine, plural	3	3
4	2	Él	Subject (Pronoun)	He	masculine	1	3
5	2	habla	Verb	speaks	hablar → 3rd person	2	3
6	2	español	Object	Spanish	masculine, singular	3	3
7	3	Ella	Subject (Pronoun)	She	feminine	1	3
8	3	come	Verb	eats	comer → 3rd person	2	3
9	3	pan	Object	bread	masculine, singular	3	3
10	4	Nosotros	Subject (Pronoun)	We	plural	1	3
11	4	vivimos	Verb	live	vivir → 1st person pl	2	3
12	4	aquí	Adverb	here	location adverb	3	3
13	5	Tú	Subject (Pronoun)	You	—	1	3
14	5	tienes	Verb	have	tener → 2nd person	2	3
15	5	un	Article	a	masculine article	3	3
16	5	libro	Object	book	masculine, singular	4	3
17	6	Ellos	Subject (Pronoun)	They	masculine plural	1	3
18	6	beben	Verb	drink	beber → 3rd person pl	2	3
19	6	agua	Object	water	feminine, singular	3	3
20	7	Yo	Subject (Pronoun)	I	—	1	3
21	7	quiero	Verb	want	querer → 1st person	2	3
22	7	café	Object	coffee	masculine, singular	3	3
23	8	Ella	Subject (Pronoun)	She	feminine	1	3
24	8	es	Verb	is	ser → 3rd person	2	3
25	8	mi	Possessive	my	possessive adjective	3	3
26	8	madre	Object	mother	feminine, singular	4	3
27	9	Él	Subject (Pronoun)	He	masculine	1	3
28	9	tiene	Verb	has	tener → 3rd person	2	3
29	9	hambre	Object	hunger	feminine, singular	3	3
30	10	Nosotros	Subject (Pronoun)	We	plural	1	3
31	10	comemos	Verb	eat	comer → 1st person pl	2	3
32	10	arroz	Object	rice	masculine, singular	3	3
33	11	Yo	Subject (Pronoun)	I	—	1	3
34	11	tengo	Verb	have	tener → 1st person	2	3
35	11	hambre	Object	hunger	feminine, singular	3	3
36	12	Ella	Subject (Pronoun)	She	feminine	1	3
37	12	bebe	Verb	drinks	beber → 3rd person	2	3
38	12	leche	Object	milk	feminine, singular	3	3
39	13	Él	Subject (Pronoun)	He	masculine	1	3
40	13	es	Verb	is	ser → 3rd person	2	3
41	13	mi	Possessive	my	possessive adjective	3	3
42	13	amigo	Object	friend	masculine, singular	4	3
43	14	Nosotros	Subject (Pronoun)	We	plural	1	3
44	14	somos	Verb	are	ser → 1st person pl	2	3
45	14	familia	Object	family	feminine, singular	3	3
46	15	Tú	Subject (Pronoun)	You	—	1	3
47	15	hablas	Verb	speak	hablar → 2nd person	2	3
48	15	muy	Adverb	very	intensifier adverb	3	3
49	15	bien	Adverb	well	manner adverb	4	3
50	16	Yo	Subject (Pronoun)	I	—	1	3
51	16	vivo	Verb	live	vivir → 1st person	2	3
52	16	en	Preposition	in	location preposition	3	3
53	16	una	Article	a	feminine article	4	3
54	16	casa	Object	house	feminine, singular	5	3
55	17	Ella	Subject (Pronoun)	She	feminine	1	3
56	17	tiene	Verb	has	tener → 3rd person	2	3
57	17	un	Article	a	masculine article	3	3
58	17	gato	Object	cat	masculine, singular	4	3
59	18	Él	Subject (Pronoun)	He	masculine	1	3
60	18	come	Verb	eats	comer → 3rd person	2	3
61	18	pollo	Object	chicken	masculine, singular	3	3
62	19	Nosotros	Subject (Pronoun)	We	plural	1	3
63	19	bebemos	Verb	drink	beber → 1st person pl	2	3
64	19	café	Object	coffee	masculine, singular	3	3
65	20	Tú	Subject (Pronoun)	You	—	1	3
66	20	eres	Verb	are	ser → 2nd person	2	3
67	20	mi	Possessive	my	possessive adjective	3	3
68	20	amiga	Object	friend	feminine, singular	4	3
69	21	Yo	Subject (Pronoun)	I	—	1	3
70	21	necesito	Verb	need	necesitar → 1st person	2	3
71	21	agua	Object	water	feminine, singular	3	3
72	22	Ella	Subject (Pronoun)	She	feminine	1	3
73	22	habla	Verb	speaks	hablar → 3rd person	2	3
74	22	español	Object	Spanish	masculine, singular	3	3
75	23	Él	Subject (Pronoun)	He	masculine	1	3
76	23	quiere	Verb	wants	querer → 3rd person	2	3
77	23	pan	Object	bread	masculine, singular	3	3
78	24	Nosotros	Subject (Pronoun)	We	plural	1	3
79	24	tenemos	Verb	have	tener → 1st person pl	2	3
80	24	un	Article	a	masculine article	3	3
81	24	perro	Object	dog	masculine, singular	4	3
82	25	Tú	Subject (Pronoun)	You	—	1	3
83	25	comes	Verb	eat	comer → 2nd person	2	3
84	25	ensalada	Object	salad	feminine, singular	3	3
85	26	Yo	Subject (Pronoun)	I	—	1	3
86	26	bebo	Verb	drink	beber → 1st person	2	3
87	26	jugo	Object	juice	masculine, singular	3	3
88	27	Ella	Subject (Pronoun)	She	feminine	1	3
89	27	vive	Verb	lives	vivir → 3rd person	2	3
90	27	con	Preposition	with	company preposition	3	3
91	27	su	Possessive	her	possessive adjective	4	3
92	27	familia	Object	family	feminine, singular	5	3
93	28	Él	Subject (Pronoun)	He	masculine	1	3
94	28	necesita	Verb	needs	necesitar → 3rd person	2	3
95	28	un	Article	a	masculine article	3	3
96	28	taxi	Object	taxi	masculine, singular	4	3
97	29	Nosotros	Subject (Pronoun)	We	plural	1	3
98	29	queremos	Verb	want	querer → 1st person pl	2	3
99	29	sopa	Object	soup	feminine, singular	3	3
100	30	Tú	Subject (Pronoun)	You	—	1	3
101	30	tienes	Verb	have	tener → 2nd person	2	3
102	30	una	Article	a	feminine article	3	3
103	30	maleta	Object	suitcase	feminine, singular	4	3
104	16	Yo	Subject (Pronoun)	I	—	1	3
105	16	tengo que	Verb Phrase	have to	tener que + infinitive	2	3
106	16	estudiar	Infinitive Verb	study	infinitive form	3	3
107	16	hoy	Adverb	today	time adverb	4	3
108	17	Ella	Subject (Pronoun)	She	feminine	1	3
109	17	está	Verb (auxiliary)	is	estar → present	2	3
110	17	buscando	Verb (gerund)	looking	buscar → gerund (-ando)	3	3
111	17	su	Possessive	her	possessive adjective	4	3
112	17	pasaporte	Object	passport	masculine, singular	5	3
113	18	Él	Subject (Pronoun)	He	masculine	1	3
114	18	no	Negation	not	negation particle	2	3
115	18	puede	Verb	can	poder → 3rd person	3	3
116	18	venir	Infinitive Verb	come	infinitive after poder	4	3
117	18	a	Preposition	to	direction preposition	5	3
118	18	la	Article	the	feminine article	6	3
119	18	reunión	Object	meeting	feminine, singular	7	3
120	19	Nosotros	Subject (Pronoun)	We	plural	1	3
121	19	queremos	Verb	want	querer → 1st person pl	2	3
122	19	hacer	Infinitive Verb	to make	infinitive after querer	3	3
123	19	una	Article	a	feminine article	4	3
124	19	reserva	Object	reservation	feminine, singular	5	3
125	20	Dónde	Adverb	where	question word	1	3
126	20	está	Verb	is	estar → 3rd person	2	3
127	20	la	Article	the	feminine article	3	3
128	20	farmacia	Subject	pharmacy	feminine, singular	4	3
129	20	más	Adverb	most	superlative marker	5	3
130	20	cercana	Adjective	nearest	feminine adjective	6	3
131	21	Ella	Subject (Pronoun)	She	feminine	1	3
132	21	lleva	Verb	has been	llevar → duration of time	2	3
133	21	dos	Number	two	quantity	3	3
134	21	horas	Object	hours	feminine, plural	4	3
135	21	esperando	Verb (gerund)	waiting	esperar → gerund	5	3
136	22	Él	Subject (Pronoun)	He	masculine	1	3
137	22	necesita	Verb	needs	necesitar → 3rd person	2	3
138	22	hablar	Infinitive Verb	speak	infinitive after necesitar	3	3
139	22	con	Preposition	with	company preposition	4	3
140	22	el	Article	the	masculine article	5	3
141	22	jefe	Object	boss	masculine, singular	6	3
142	23	Nosotros	Subject (Pronoun)	We	plural	1	3
143	23	tenemos	Verb	have	tener → 1st person pl	2	3
144	23	un	Article	a	masculine article	3	3
145	23	problema	Object	problem	masculine, singular	4	3
146	24	Cuánto	Adverb	how much	question word	1	3
147	24	cuesta	Verb	costs	costar → 3rd person	2	3
148	24	el	Article	the	masculine article	3	3
149	24	billete	Subject	ticket	masculine, singular	4	3
150	24	de	Preposition	of	possession particle	5	3
151	24	tren	Object	train	masculine, singular	6	3
152	25	Ella	Subject (Pronoun)	She	feminine	1	3
153	25	quiere	Verb	wants	querer → 3rd person	2	3
154	25	cambiar	Infinitive Verb	change	infinitive after querer	3	3
155	25	su	Possessive	her	possessive adjective	4	3
156	25	habitación	Object	room	feminine, singular	5	3
157	26	Yo	Subject (Pronoun)	I	—	1	3
158	26	estoy	Verb (auxiliary)	am	estar → 1st person	2	3
159	26	aprendiendo	Verb (gerund)	learning	aprender → gerund (-iendo)	3	3
160	26	español	Object	Spanish	masculine, singular	4	3
161	27	Él	Subject (Pronoun)	He	masculine	1	3
162	27	trabaja	Verb	works	trabajar → 3rd person	2	3
163	27	en	Preposition	in	location preposition	3	3
164	27	una	Article	a	feminine article	4	3
165	27	empresa	Object	company	feminine, singular	5	3
166	27	grande	Adjective	big	singular adjective	6	3
167	28	Nosotros	Subject (Pronoun)	We	plural	1	3
168	28	necesitamos	Verb	need	necesitar → 1st person pl	2	3
169	28	más	Adverb	more	quantity adverb	3	3
170	28	información	Object	information	feminine, singular	4	3
171	29	Puede	Verb	can you	poder → 3rd person formal	1	3
172	29	traerme	Verb+Pronoun	bring me	traer + me attached	2	3
173	29	la	Article	the	feminine article	3	3
174	29	cuenta	Object	bill	feminine, singular	4	3
175	29	por favor	Phrase	please	politeness phrase	5	3
176	30	Ella	Subject (Pronoun)	She	feminine	1	3
177	30	no	Negation	not	negation particle	2	3
178	30	entiende	Verb	understand	entender → 3rd person	3	3
179	30	el	Article	the	masculine article	4	3
180	30	contrato	Object	contract	masculine, singular	5	3
181	21	A menos que	Conjunction	unless	conditional conjunction	1	3
182	21	cambies	Verb (subjunctive)	change	cambiar → subjunctive	2	3
183	21	de opinión	Phrase	your mind	idiomatic phrase	3	3
184	21	seguiremos	Verb	will continue	seguir → future 1st pl	4	3
185	21	adelante	Adverb	forward	direction adverb	5	3
186	22	Mientras que	Conjunction	while	simultaneous conjunction	1	3
187	22	él	Subject (Pronoun)	he	masculine	2	3
188	22	trabaja	Verb	works	trabajar → 3rd person	3	3
189	22	ella	Subject (Pronoun)	she	feminine	4	3
190	22	estudia	Verb	studies	estudiar → 3rd person	5	3
191	23	Dado que	Conjunction	given that	causal conjunction	1	3
192	23	no	Negation	not	negation particle	2	3
193	23	hay	Verb	there is	haber → impersonal	3	3
194	23	evidencia	Object	evidence	feminine, singular	4	3
195	23	no podemos	Verb	we cannot	poder → 1st person pl	5	3
196	23	concluir	Infinitive	conclude	infinitive after poder	6	3
197	24	Para que	Conjunction	so that	purpose conjunction	1	3
198	24	funcione	Verb (subjunctive)	works	funcionar → subjunctive	2	3
199	24	necesitamos	Verb	we need	necesitar → 1st person pl	3	3
200	24	más	Adverb	more	quantity adverb	4	3
201	24	recursos	Object	resources	masculine, plural	5	3
202	25	Siempre que	Conjunction	as long as	conditional conjunction	1	3
203	25	estudies	Verb (subjunctive)	you study	estudiar → subjunctive	2	3
204	25	mejorarás	Verb (future)	will improve	mejorar → future 2nd	3	3
205	25	tu nivel	Object	your level	possessive + noun	4	3
206	21	A fin de cuentas	Phrase	after all	idiomatic expression	1	3
207	21	la	Article	the	feminine article	2	3
208	21	conciencia	Subject	conscience	feminine, singular	3	3
209	21	colectiva	Adjective	collective	feminine adjective	4	3
210	21	prevalece	Verb	prevails	prevalecer → 3rd person	5	3
211	22	En definitiva	Phrase	ultimately	discourse marker	1	3
212	22	la	Article	the	feminine article	2	3
213	22	tendencia	Subject	trend	feminine, singular	3	3
214	22	apunta	Verb	points	apuntar → 3rd person	4	3
215	22	hacia	Preposition	toward	direction preposition	5	3
216	22	lo sostenible	Object	sustainability	neuter article + adj	6	3
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
-- Data for Name: system_performance_log; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.system_performance_log (id, endpoint, method, response_ms, status_code, user_id, threshold_ms, exceeded_threshold, logged_at) FROM stdin;
\.


--
-- Data for Name: time_expressions; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.time_expressions (id, spanish, english, category, level, language, lesson_number) FROM stdin;
1	la hora	the time/hour	telling_time	BEGINNER	es	5
2	el minuto	the minute	telling_time	BEGINNER	es	5
3	el segundo	the second	telling_time	BEGINNER	es	5
4	¿Qué hora es?	What time is it?	telling_time	BEGINNER	es	5
5	Son las tres.	It is three o'clock.	telling_time	BEGINNER	es	5
6	Es la una.	It is one o'clock.	telling_time	BEGINNER	es	5
7	y media	half past	telling_time	BEGINNER	es	5
8	y cuarto	quarter past	telling_time	BEGINNER	es	5
9	menos cuarto	quarter to	telling_time	BEGINNER	es	5
10	en punto	exactly/on the dot	telling_time	BEGINNER	es	5
11	de la mañana	in the morning/AM	telling_time	BEGINNER	es	5
12	de la tarde	in the afternoon/PM	telling_time	BEGINNER	es	5
13	de la noche	at night/PM	telling_time	BEGINNER	es	5
14	el mediodía	noon/midday	telling_time	BEGINNER	es	5
15	la medianoche	midnight	telling_time	BEGINNER	es	5
16	lunes	Monday	days	BEGINNER	es	5
17	martes	Tuesday	days	BEGINNER	es	5
18	miércoles	Wednesday	days	BEGINNER	es	5
19	jueves	Thursday	days	BEGINNER	es	5
20	viernes	Friday	days	BEGINNER	es	5
21	sábado	Saturday	days	BEGINNER	es	5
22	domingo	Sunday	days	BEGINNER	es	5
23	enero	January	months	BEGINNER	es	5
24	febrero	February	months	BEGINNER	es	5
25	marzo	March	months	BEGINNER	es	5
26	abril	April	months	BEGINNER	es	5
27	mayo	May	months	BEGINNER	es	5
28	junio	June	months	BEGINNER	es	5
29	julio	July	months	BEGINNER	es	5
30	agosto	August	months	BEGINNER	es	5
31	septiembre	September	months	BEGINNER	es	5
32	octubre	October	months	BEGINNER	es	5
33	noviembre	November	months	BEGINNER	es	5
34	diciembre	December	months	BEGINNER	es	5
35	hoy	today	general	BEGINNER	es	5
36	mañana	tomorrow	general	BEGINNER	es	5
37	ayer	yesterday	general	BEGINNER	es	5
38	el fin de semana	the weekend	general	BEGINNER	es	5
39	la semana	the week	general	BEGINNER	es	5
40	el mes	the month	general	BEGINNER	es	5
41	el año	the year	general	BEGINNER	es	5
42	el día	the day	general	BEGINNER	es	5
43	la primavera	spring	seasons	BEGINNER	es	5
44	el verano	summer	seasons	BEGINNER	es	5
45	el otoño	autumn/fall	seasons	BEGINNER	es	5
46	el invierno	winter	seasons	BEGINNER	es	5
47	ahora	now	general	BEGINNER	es	5
48	después	after/later	general	BEGINNER	es	5
49	antes	before/earlier	general	BEGINNER	es	5
50	pronto	soon	general	BEGINNER	es	5
51	tarde	late	general	BEGINNER	es	5
52	la próxima semana	next week	schedule	INTERMEDIATE	es	5
53	la semana pasada	last week	schedule	INTERMEDIATE	es	5
54	el mes que viene	next month	schedule	INTERMEDIATE	es	5
55	el año pasado	last year	schedule	INTERMEDIATE	es	5
56	dentro de dos días	in two days	schedule	INTERMEDIATE	es	5
57	hace tres semanas	three weeks ago	schedule	INTERMEDIATE	es	5
58	a tiempo	on time	schedule	INTERMEDIATE	es	5
59	con retraso	late/delayed	schedule	INTERMEDIATE	es	5
60	puntual	punctual	schedule	INTERMEDIATE	es	5
61	la cita	the appointment	schedule	INTERMEDIATE	es	5
62	el plazo	the deadline	schedule	INTERMEDIATE	es	5
63	el horario	the schedule/timetable	schedule	INTERMEDIATE	es	5
64	la agenda	the agenda/diary	schedule	INTERMEDIATE	es	5
65	reservar	to book/reserve	schedule	INTERMEDIATE	es	5
66	cancelar	to cancel	schedule	INTERMEDIATE	es	5
67	posponer	to postpone	schedule	INTERMEDIATE	es	5
68	confirmar	to confirm	schedule	INTERMEDIATE	es	5
69	¿A qué hora...?	At what time...?	schedule	INTERMEDIATE	es	5
70	el trimestre	the quarter/term	periods	INTERMEDIATE	es	5
71	el semestre	the semester	periods	INTERMEDIATE	es	5
72	la década	the decade	periods	INTERMEDIATE	es	5
73	el siglo	the century	periods	INTERMEDIATE	es	5
74	a mediados de	in the middle of	periods	INTERMEDIATE	es	5
75	a finales de	at the end of	periods	INTERMEDIATE	es	5
76	a principios de	at the beginning of	periods	INTERMEDIATE	es	5
77	durante	during	periods	INTERMEDIATE	es	5
78	mientras	while/meanwhile	periods	INTERMEDIATE	es	5
79	desde	since/from	periods	INTERMEDIATE	es	5
80	hasta	until/up to	periods	INTERMEDIATE	es	5
81	en cuanto	as soon as	periods	INTERMEDIATE	es	5
82	a largo plazo	in the long term	complex	UPPER_INTERMEDIATE	es	5
83	a corto plazo	in the short term	complex	UPPER_INTERMEDIATE	es	5
84	a mediano plazo	in the medium term	complex	UPPER_INTERMEDIATE	es	5
85	con anterioridad	previously/beforehand	complex	UPPER_INTERMEDIATE	es	5
86	con posterioridad	afterwards/subsequently	complex	UPPER_INTERMEDIATE	es	5
87	simultáneamente	simultaneously	complex	UPPER_INTERMEDIATE	es	5
88	de manera progresiva	progressively	complex	UPPER_INTERMEDIATE	es	5
89	en el transcurso de	in the course of	complex	UPPER_INTERMEDIATE	es	5
90	a lo largo del tiempo	over time/throughout time	complex	UPPER_INTERMEDIATE	es	5
91	con el paso del tiempo	as time goes by	complex	UPPER_INTERMEDIATE	es	5
92	en un futuro próximo	in the near future	complex	UPPER_INTERMEDIATE	es	5
93	en el pasado reciente	in the recent past	complex	UPPER_INTERMEDIATE	es	5
94	de forma inmediata	immediately	complex	UPPER_INTERMEDIATE	es	5
95	eventualmente	eventually	complex	UPPER_INTERMEDIATE	es	5
96	periódicamente	periodically	complex	UPPER_INTERMEDIATE	es	5
97	temporalmente	temporarily	complex	UPPER_INTERMEDIATE	es	5
98	permanentemente	permanently	complex	UPPER_INTERMEDIATE	es	5
99	cronológicamente	chronologically	complex	UPPER_INTERMEDIATE	es	5
100	retrospectivamente	retrospectively	complex	UPPER_INTERMEDIATE	es	5
101	prospectivamente	prospectively	complex	UPPER_INTERMEDIATE	es	5
102	en el momento oportuno	at the right moment	complex	UPPER_INTERMEDIATE	es	5
103	a destiempo	at the wrong time	complex	UPPER_INTERMEDIATE	es	5
104	sin demora	without delay	complex	UPPER_INTERMEDIATE	es	5
105	de inmediato	immediately/at once	complex	UPPER_INTERMEDIATE	es	5
106	con frecuencia	frequently	complex	UPPER_INTERMEDIATE	es	5
107	raramente	rarely	complex	UPPER_INTERMEDIATE	es	5
108	ocasionalmente	occasionally	complex	UPPER_INTERMEDIATE	es	5
109	habitualmente	usually/habitually	complex	UPPER_INTERMEDIATE	es	5
110	constantemente	constantly	complex	UPPER_INTERMEDIATE	es	5
111	indefinidamente	indefinitely	complex	UPPER_INTERMEDIATE	es	5
112	la temporalidad	temporality	concept	ADVANCED	es	5
113	la cronología	chronology	concept	ADVANCED	es	5
114	la simultaneidad	simultaneity	concept	ADVANCED	es	5
115	la periodicidad	periodicity	concept	ADVANCED	es	5
116	la transitoriedad	transitoriness	concept	ADVANCED	es	5
117	la duración	duration	concept	ADVANCED	es	5
118	el lapso	the lapse/span	concept	ADVANCED	es	5
119	la efímero	the ephemeral	concept	ADVANCED	es	5
120	la perpetuidad	perpetuity	concept	ADVANCED	es	5
121	la intemporalidad	timelessness	concept	ADVANCED	es	5
122	en retrospectiva	in retrospect	academic	ADVANCED	es	5
123	en perspectiva futura	in future perspective	academic	ADVANCED	es	5
124	a escala temporal	on a time scale	academic	ADVANCED	es	5
125	el horizonte temporal	the time horizon	academic	ADVANCED	es	5
126	la línea temporal	the timeline	academic	ADVANCED	es	5
127	el punto de inflexión	the turning point	academic	ADVANCED	es	5
128	el hito histórico	the historical milestone	academic	ADVANCED	es	5
129	la era	the era/age	academic	ADVANCED	es	5
130	el período	the period	academic	ADVANCED	es	5
131	la época	the epoch/era	academic	ADVANCED	es	5
132	el intervalo	the interval	academic	ADVANCED	es	5
133	la fase	the phase	academic	ADVANCED	es	5
134	la etapa	the stage/phase	academic	ADVANCED	es	5
135	el ciclo	the cycle	academic	ADVANCED	es	5
136	la recurrencia	recurrence	academic	ADVANCED	es	5
137	la secuencia	the sequence	academic	ADVANCED	es	5
138	el flujo temporal	the temporal flow	academic	ADVANCED	es	5
139	la cadencia	the cadence/rhythm	academic	ADVANCED	es	5
140	el compás	the tempo/beat	academic	ADVANCED	es	5
141	la progresión	the progression	academic	ADVANCED	es	5
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
-- Data for Name: user_lesson_catalog_progress; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.user_lesson_catalog_progress (id, user_id, lesson_number, status, score_percentage, xp_earned, attempts, passed, completed_at, started_at) FROM stdin;
9fa0293f-8cf3-4c66-94d2-aef4c9c662a7	cb7b7c8b-987d-4557-b395-d91c017b19ef	1	AVAILABLE	\N	0	0	f	\N	\N
3105aa4a-075f-4a0e-b5d6-7a9af9fcb0e2	a71511fb-db0c-4f97-bc9a-a4d6a735b136	1	AVAILABLE	\N	0	0	f	\N	\N
24b5142a-af13-42ff-9b88-ba405bb300c3	00e2433e-b2df-4d86-b0e7-75fff3ab48d3	1	AVAILABLE	\N	0	0	f	\N	\N
0d75a9b1-fc12-4df8-beb0-5825445d3e99	c01b44f7-7a64-48e6-8778-0ae3bdb0d382	1	AVAILABLE	\N	0	0	f	\N	\N
b031cbc8-3ded-40b3-8aec-9c0ed030ffb0	cb7b7c8b-987d-4557-b395-d91c017b19ef	2	LOCKED	\N	0	0	f	\N	\N
53323d40-d7df-4a30-94eb-82033281bb15	a71511fb-db0c-4f97-bc9a-a4d6a735b136	2	LOCKED	\N	0	0	f	\N	\N
7affafd2-e45e-4170-b4fc-cc0c491b1d6b	00e2433e-b2df-4d86-b0e7-75fff3ab48d3	2	LOCKED	\N	0	0	f	\N	\N
c7815347-53fc-4d61-96bd-101f08235f82	c01b44f7-7a64-48e6-8778-0ae3bdb0d382	2	LOCKED	\N	0	0	f	\N	\N
bf5fb698-b1ae-4f5c-805f-ed60c0842691	cb7b7c8b-987d-4557-b395-d91c017b19ef	3	LOCKED	\N	0	0	f	\N	\N
94c89954-e08b-4b1c-95d5-38e34d05dbc6	a71511fb-db0c-4f97-bc9a-a4d6a735b136	3	LOCKED	\N	0	0	f	\N	\N
a3cca658-587e-4449-87d5-3eea49677e8e	00e2433e-b2df-4d86-b0e7-75fff3ab48d3	3	LOCKED	\N	0	0	f	\N	\N
2f2e7db6-5afd-44a2-88a3-76a776b59354	c01b44f7-7a64-48e6-8778-0ae3bdb0d382	3	LOCKED	\N	0	0	f	\N	\N
9a853099-8019-443a-8a68-e555ecf18bf8	cb7b7c8b-987d-4557-b395-d91c017b19ef	4	LOCKED	\N	0	0	f	\N	\N
51b60979-c55e-4447-a802-123181a944ec	a71511fb-db0c-4f97-bc9a-a4d6a735b136	4	LOCKED	\N	0	0	f	\N	\N
a65fdcde-88b5-4188-920e-5e67043aee63	00e2433e-b2df-4d86-b0e7-75fff3ab48d3	4	LOCKED	\N	0	0	f	\N	\N
3f1ec4ed-4aba-4809-a875-f9f9219ba8ec	c01b44f7-7a64-48e6-8778-0ae3bdb0d382	4	LOCKED	\N	0	0	f	\N	\N
12314b39-8b80-4b50-811e-dbf115037629	cb7b7c8b-987d-4557-b395-d91c017b19ef	5	LOCKED	\N	0	0	f	\N	\N
93e69ca8-7437-41d3-b3dc-4597ca23059e	a71511fb-db0c-4f97-bc9a-a4d6a735b136	5	LOCKED	\N	0	0	f	\N	\N
6076d339-b316-492a-bf44-c3c098015c00	00e2433e-b2df-4d86-b0e7-75fff3ab48d3	5	LOCKED	\N	0	0	f	\N	\N
ba29358c-f34c-4fa0-a117-ef08e8b548db	c01b44f7-7a64-48e6-8778-0ae3bdb0d382	5	LOCKED	\N	0	0	f	\N	\N
4d088c18-662f-4e77-ab90-38ec708c424e	cb7b7c8b-987d-4557-b395-d91c017b19ef	6	LOCKED	\N	0	0	f	\N	\N
19fc0c89-1d2a-48cc-8c33-165b987dfb86	a71511fb-db0c-4f97-bc9a-a4d6a735b136	6	LOCKED	\N	0	0	f	\N	\N
84a7d58e-385b-45db-add8-2369d7e76d1a	00e2433e-b2df-4d86-b0e7-75fff3ab48d3	6	LOCKED	\N	0	0	f	\N	\N
b8bba111-e459-4029-ad74-309a5b478dd3	c01b44f7-7a64-48e6-8778-0ae3bdb0d382	6	LOCKED	\N	0	0	f	\N	\N
b834d49c-42ca-4c2c-a371-79e1c5126fc5	cb7b7c8b-987d-4557-b395-d91c017b19ef	7	LOCKED	\N	0	0	f	\N	\N
43f30970-6b6b-493d-9b01-5ec3a74a9301	a71511fb-db0c-4f97-bc9a-a4d6a735b136	7	LOCKED	\N	0	0	f	\N	\N
a0728f79-3140-43d7-9a63-4569d6453e7e	00e2433e-b2df-4d86-b0e7-75fff3ab48d3	7	LOCKED	\N	0	0	f	\N	\N
588f9e9b-42e1-4715-998a-b5b31158df51	c01b44f7-7a64-48e6-8778-0ae3bdb0d382	7	LOCKED	\N	0	0	f	\N	\N
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
-- Data for Name: user_trouble_items; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.user_trouble_items (id, user_id, language, section, reference_type, reference_id, topic_tag, label_snapshot, dedupe_key, wrong_count, last_wrong_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: user_word_memory; Type: TABLE DATA; Schema: public; Owner: rodrigo
--

COPY public.user_word_memory (id, user_id, vocabulary_id, times_seen, times_correct, times_incorrect, last_seen_at, next_review_at, ease_factor, interval_days, memory_strength, last_answer, last_was_correct, created_at, updated_at) FROM stdin;
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
-- Name: alphabet_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rodrigo
--

SELECT pg_catalog.setval('public.alphabet_id_seq', 57, true);


--
-- Name: colors_descriptions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rodrigo
--

SELECT pg_catalog.setval('public.colors_descriptions_id_seq', 120, true);


--
-- Name: family_relationships_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rodrigo
--

SELECT pg_catalog.setval('public.family_relationships_id_seq', 120, true);


--
-- Name: numbers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rodrigo
--

SELECT pg_catalog.setval('public.numbers_id_seq', 120, true);


--
-- Name: sentence_structure_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rodrigo
--

SELECT pg_catalog.setval('public.sentence_structure_id_seq', 120, true);


--
-- Name: sentence_words_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rodrigo
--

SELECT pg_catalog.setval('public.sentence_words_id_seq', 216, true);


--
-- Name: time_expressions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rodrigo
--

SELECT pg_catalog.setval('public.time_expressions_id_seq', 141, true);


--
-- PostgreSQL database dump complete
--

\unrestrict 0KaDIfikSrnbaYUYCyG4j0zcSc9Yb5I8GR4LvP7dKAqkLI8YtsjdOMtKFm1whiF

