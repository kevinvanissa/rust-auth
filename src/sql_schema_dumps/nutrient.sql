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
-- Name: nutrient; Type: TABLE; Schema: myfoodlog; Owner: kevin
--

CREATE TABLE myfoodlog.nutrient (
    id bigint NOT NULL,
    name text,
    unit_name text,
    nutrient_nbr bigint NOT NULL,
    rank double precision
);


ALTER TABLE myfoodlog.nutrient OWNER TO kevin;

--
-- Name: nutrient idx_18202_primary; Type: CONSTRAINT; Schema: myfoodlog; Owner: kevin
--

ALTER TABLE ONLY myfoodlog.nutrient
    ADD CONSTRAINT idx_18202_primary PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

