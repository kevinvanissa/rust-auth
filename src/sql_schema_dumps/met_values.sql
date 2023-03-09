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
-- Name: met_values; Type: TABLE; Schema: myfoodlog; Owner: kevin
--

CREATE TABLE myfoodlog.met_values (
    id bigint NOT NULL,
    activity character varying(120) DEFAULT NULL::character varying,
    motion character varying(250) DEFAULT NULL::character varying,
    met double precision DEFAULT NULL::numeric
);


ALTER TABLE myfoodlog.met_values OWNER TO kevin;

--
-- Name: met_values_id_seq; Type: SEQUENCE; Schema: myfoodlog; Owner: kevin
--

CREATE SEQUENCE myfoodlog.met_values_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE myfoodlog.met_values_id_seq OWNER TO kevin;

--
-- Name: met_values_id_seq; Type: SEQUENCE OWNED BY; Schema: myfoodlog; Owner: kevin
--

ALTER SEQUENCE myfoodlog.met_values_id_seq OWNED BY myfoodlog.met_values.id;


--
-- Name: met_values id; Type: DEFAULT; Schema: myfoodlog; Owner: kevin
--

ALTER TABLE ONLY myfoodlog.met_values ALTER COLUMN id SET DEFAULT nextval('myfoodlog.met_values_id_seq'::regclass);


--
-- Name: met_values idx_18195_primary; Type: CONSTRAINT; Schema: myfoodlog; Owner: kevin
--

ALTER TABLE ONLY myfoodlog.met_values
    ADD CONSTRAINT idx_18195_primary PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

