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
-- Name: users; Type: TABLE; Schema: myfoodlog; Owner: kevin
--

CREATE TABLE myfoodlog.users (
    id bigint NOT NULL,
    firstname character varying(100) NOT NULL,
    lastname character varying(100) NOT NULL,
    email character varying(120) DEFAULT NULL::character varying,
    password character varying(140) NOT NULL,
    confirmationid character varying(140) DEFAULT NULL::character varying,
    user_role boolean,
    active_user boolean,
    weight numeric(5,2) DEFAULT NULL::numeric,
    height numeric(5,2) DEFAULT NULL::numeric,
    dob date,
    gender character varying(6) DEFAULT NULL::character varying,
    activity_level character varying(50) DEFAULT NULL::character varying,
    phone character varying(15) DEFAULT NULL::character varying,
    avatar character varying(1000) DEFAULT NULL::character varying,
    daily_calorie_goal numeric(6,2) DEFAULT NULL::numeric,
    username character varying
);


ALTER TABLE myfoodlog.users OWNER TO kevin;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: myfoodlog; Owner: kevin
--

CREATE SEQUENCE myfoodlog.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE myfoodlog.users_id_seq OWNER TO kevin;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: myfoodlog; Owner: kevin
--

ALTER SEQUENCE myfoodlog.users_id_seq OWNED BY myfoodlog.users.id;


--
-- Name: users id; Type: DEFAULT; Schema: myfoodlog; Owner: kevin
--

ALTER TABLE ONLY myfoodlog.users ALTER COLUMN id SET DEFAULT nextval('myfoodlog.users_id_seq'::regclass);


--
-- Name: users idx_18255_primary; Type: CONSTRAINT; Schema: myfoodlog; Owner: kevin
--

ALTER TABLE ONLY myfoodlog.users
    ADD CONSTRAINT idx_18255_primary PRIMARY KEY (id);


--
-- Name: idx_18255_ix_user_email; Type: INDEX; Schema: myfoodlog; Owner: kevin
--

CREATE UNIQUE INDEX idx_18255_ix_user_email ON myfoodlog.users USING btree (email);


--
-- PostgreSQL database dump complete
--

