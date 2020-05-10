--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2
-- Dumped by pg_dump version 12.2

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: katafrakt
--

CREATE TABLE public.schema_migrations (
    version text NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO katafrakt;

--
-- Name: stats; Type: TABLE; Schema: public; Owner: katafrakt
--

CREATE TABLE public.stats (
    id integer NOT NULL,
    num_repos integer NOT NULL,
    num_users integer NOT NULL,
    num_files integer NOT NULL,
    day date NOT NULL,
    created_at integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    updated_at integer
);


ALTER TABLE public.stats OWNER TO katafrakt;

--
-- Name: stats_id_seq; Type: SEQUENCE; Schema: public; Owner: katafrakt
--

CREATE SEQUENCE public.stats_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stats_id_seq OWNER TO katafrakt;

--
-- Name: stats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: katafrakt
--

ALTER SEQUENCE public.stats_id_seq OWNED BY public.stats.id;


--
-- Name: stats id; Type: DEFAULT; Schema: public; Owner: katafrakt
--

ALTER TABLE ONLY public.stats ALTER COLUMN id SET DEFAULT nextval('public.stats_id_seq'::regclass);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: katafrakt
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: stats stats_pkey; Type: CONSTRAINT; Schema: public; Owner: katafrakt
--

ALTER TABLE ONLY public.stats
    ADD CONSTRAINT stats_pkey PRIMARY KEY (id);


--
-- Name: idx_stats_day; Type: INDEX; Schema: public; Owner: katafrakt
--

CREATE INDEX idx_stats_day ON public.stats USING btree (day);


--
-- PostgreSQL database dump complete
--

