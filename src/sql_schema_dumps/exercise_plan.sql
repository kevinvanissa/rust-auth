--
-- PostgreSQL database dump
--

-- Dumped from database version 14.7 (Ubuntu 14.7-0ubuntu0.22.10.1)
-- Dumped by pg_dump version 14.7 (Ubuntu 14.7-0ubuntu0.22.10.1)

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
-- Name: exercise_plan; Type: TABLE; Schema: myfoodlog; Owner: kevin
--

CREATE TABLE myfoodlog.exercise_plan (
    id bigint NOT NULL,
    userid bigint,
    metid bigint NOT NULL,
    timemins bigint NOT NULL,
    edate date NOT NULL
);


ALTER TABLE myfoodlog.exercise_plan OWNER TO kevin;

--
-- Name: exercise_plan_id_seq; Type: SEQUENCE; Schema: myfoodlog; Owner: kevin
--

CREATE SEQUENCE myfoodlog.exercise_plan_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE myfoodlog.exercise_plan_id_seq OWNER TO kevin;

--
-- Name: exercise_plan_id_seq; Type: SEQUENCE OWNED BY; Schema: myfoodlog; Owner: kevin
--

ALTER SEQUENCE myfoodlog.exercise_plan_id_seq OWNED BY myfoodlog.exercise_plan.id;


--
-- Name: exercise_plan id; Type: DEFAULT; Schema: myfoodlog; Owner: kevin
--

ALTER TABLE ONLY myfoodlog.exercise_plan ALTER COLUMN id SET DEFAULT nextval('myfoodlog.exercise_plan_id_seq'::regclass);


--
-- Name: exercise_plan idx_18064_primary; Type: CONSTRAINT; Schema: myfoodlog; Owner: kevin
--

ALTER TABLE ONLY myfoodlog.exercise_plan
    ADD CONSTRAINT idx_18064_primary PRIMARY KEY (id);


--
-- Name: idx_18064_metid; Type: INDEX; Schema: myfoodlog; Owner: kevin
--

CREATE INDEX idx_18064_metid ON myfoodlog.exercise_plan USING btree (metid);


--
-- Name: idx_18064_userid; Type: INDEX; Schema: myfoodlog; Owner: kevin
--

CREATE INDEX idx_18064_userid ON myfoodlog.exercise_plan USING btree (userid);


--
-- PostgreSQL database dump complete
--

