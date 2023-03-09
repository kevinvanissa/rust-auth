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
-- Name: food_nutrient_original; Type: TABLE; Schema: myfoodlog; Owner: kevin
--

CREATE TABLE myfoodlog.food_nutrient_original (
    id bigint NOT NULL,
    fdc_id bigint NOT NULL,
    nutrient_id bigint NOT NULL,
    amount double precision,
    data_points text,
    derivation_id bigint,
    min text,
    max text,
    median text,
    footnote text,
    min_year_acquired text
);


ALTER TABLE myfoodlog.food_nutrient_original OWNER TO kevin;

--
-- Name: food_nutrient_original idx_18122_primary; Type: CONSTRAINT; Schema: myfoodlog; Owner: kevin
--

ALTER TABLE ONLY myfoodlog.food_nutrient_original
    ADD CONSTRAINT idx_18122_primary PRIMARY KEY (fdc_id, nutrient_id);


--
-- PostgreSQL database dump complete
--

