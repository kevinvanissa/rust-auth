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
-- Name: meal_plan; Type: TABLE; Schema: myfoodlog; Owner: kevin
--

CREATE TABLE myfoodlog.meal_plan (
    id bigint NOT NULL,
    meal_date date NOT NULL,
    userid bigint,
    fdc_id bigint,
    meal_type character varying(120) NOT NULL,
    amount double precision,
    pseq character varying(2) DEFAULT NULL::character varying,
    description character varying(120) DEFAULT NULL::character varying
);


ALTER TABLE myfoodlog.meal_plan OWNER TO kevin;

--
-- Name: meal_plan_id_seq; Type: SEQUENCE; Schema: myfoodlog; Owner: kevin
--

CREATE SEQUENCE myfoodlog.meal_plan_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE myfoodlog.meal_plan_id_seq OWNER TO kevin;

--
-- Name: meal_plan_id_seq; Type: SEQUENCE OWNED BY; Schema: myfoodlog; Owner: kevin
--

ALTER SEQUENCE myfoodlog.meal_plan_id_seq OWNED BY myfoodlog.meal_plan.id;


--
-- Name: meal_plan id; Type: DEFAULT; Schema: myfoodlog; Owner: kevin
--

ALTER TABLE ONLY myfoodlog.meal_plan ALTER COLUMN id SET DEFAULT nextval('myfoodlog.meal_plan_id_seq'::regclass);


--
-- Name: meal_plan idx_18176_primary; Type: CONSTRAINT; Schema: myfoodlog; Owner: kevin
--

ALTER TABLE ONLY myfoodlog.meal_plan
    ADD CONSTRAINT idx_18176_primary PRIMARY KEY (id);


--
-- Name: idx_18176_meal_plan_ibfk_3; Type: INDEX; Schema: myfoodlog; Owner: kevin
--

CREATE INDEX idx_18176_meal_plan_ibfk_3 ON myfoodlog.meal_plan USING btree (fdc_id);


--
-- Name: idx_18176_userid; Type: INDEX; Schema: myfoodlog; Owner: kevin
--

CREATE INDEX idx_18176_userid ON myfoodlog.meal_plan USING btree (userid);


--
-- Name: meal_plan meal_plan_ibfk_1; Type: FK CONSTRAINT; Schema: myfoodlog; Owner: kevin
--

ALTER TABLE ONLY myfoodlog.meal_plan
    ADD CONSTRAINT meal_plan_ibfk_1 FOREIGN KEY (userid) REFERENCES myfoodlog.users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: meal_plan meal_plan_ibfk_3; Type: FK CONSTRAINT; Schema: myfoodlog; Owner: kevin
--

ALTER TABLE ONLY myfoodlog.meal_plan
    ADD CONSTRAINT meal_plan_ibfk_3 FOREIGN KEY (fdc_id) REFERENCES myfoodlog.food(fdc_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

