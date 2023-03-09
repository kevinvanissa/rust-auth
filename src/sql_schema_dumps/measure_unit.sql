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
-- Name: measure_unit; Type: TABLE; Schema: myfoodlog; Owner: kevin
--

CREATE TABLE myfoodlog.measure_unit (
    id bigint NOT NULL,
    name text
);


ALTER TABLE myfoodlog.measure_unit OWNER TO kevin;

--
-- Name: idx_18189_id; Type: INDEX; Schema: myfoodlog; Owner: kevin
--

CREATE INDEX idx_18189_id ON myfoodlog.measure_unit USING btree (id);


--
-- PostgreSQL database dump complete
--

