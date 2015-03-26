--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: meteorology; Type: TABLE; Schema: public; Owner: user_samara; Tablespace: 
--

CREATE TABLE meteorology (
    day character varying(10),
    temperature numeric(6,2),
    par numeric(6,2),
    etp numeric(6,2),
    irrigation numeric(6,2),
    p numeric(6,2),
    idsite character varying(50)
);


ALTER TABLE public.meteorology OWNER TO user_samara;

--
-- Name: simulation; Type: TABLE; Schema: public; Owner: user_samara; Tablespace: 
--

CREATE TABLE simulation (
    id character varying(50) NOT NULL,
    name character varying(100),
    datebegin character varying(10),
    dateend character varying(10),
    idsite character varying(50) NOT NULL,
    idvariety character varying(50) NOT NULL
);


ALTER TABLE public.simulation OWNER TO user_samara;

--
-- Name: simulation_idsite_seq; Type: SEQUENCE; Schema: public; Owner: user_samara
--

CREATE SEQUENCE simulation_idsite_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.simulation_idsite_seq OWNER TO user_samara;

--
-- Name: simulation_idsite_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user_samara
--

ALTER SEQUENCE simulation_idsite_seq OWNED BY simulation.idsite;


--
-- Name: simulation_idvariety_seq; Type: SEQUENCE; Schema: public; Owner: user_samara
--

CREATE SEQUENCE simulation_idvariety_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.simulation_idvariety_seq OWNER TO user_samara;

--
-- Name: simulation_idvariety_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user_samara
--

ALTER SEQUENCE simulation_idvariety_seq OWNED BY simulation.idvariety;


--
-- Name: site; Type: TABLE; Schema: public; Owner: user_samara; Tablespace: 
--

CREATE TABLE site (
    id character varying(50) NOT NULL,
    name character varying(100)
);


ALTER TABLE public.site OWNER TO user_samara;

--
-- Name: variety; Type: TABLE; Schema: public; Owner: user_samara; Tablespace: 
--

CREATE TABLE variety (
    gdw numeric(19,15),
    "FSLA" numeric(19,15),
    "Lef1" numeric(19,15),
    "nb_leaf_max_after_PI" numeric(19,15),
    density numeric(19,15),
    "Epsib" numeric(19,15),
    "Kdf" numeric(19,15),
    "Kresp" numeric(19,15),
    "Kresp_internode" numeric(19,15),
    "Tresp" numeric(19,15),
    "Tb" numeric(19,15),
    "Kcpot" numeric(19,15),
    plasto_init numeric(19,15),
    coef_plasto_ligulo numeric(19,15),
    ligulo1 numeric(19,15),
    coef_ligulo1 numeric(19,15),
    "MGR_init" numeric(19,15),
    "Ict" numeric(19,15),
    "resp_Ict" numeric(19,15),
    "resp_R_d" numeric(19,15),
    "resp_LER" numeric(19,15),
    "SLAp" numeric(19,15),
    "G_L" numeric(19,15),
    "LL_BL_init" numeric(19,15),
    allo_area numeric(19,15),
    "WLR" numeric(19,15),
    "coeff1_R_d" numeric(19,15),
    "coeff2_R_d" numeric(19,15),
    "realocationCoeff" numeric(19,15),
    leaf_stock_max numeric(19,15),
    nb_leaf_enabling_tillering numeric(19,15),
    "deepL1" numeric(19,15),
    "deepL2" numeric(19,15),
    "FCL1" numeric(19,15),
    "WPL1" numeric(19,15),
    "FCL2" numeric(19,15),
    "WPL2" numeric(19,15),
    "RU1" numeric(19,15),
    "Sdepth" numeric(19,15),
    "Rolling_A" numeric(19,15),
    "Rolling_B" numeric(19,15),
    "thresLER" numeric(19,15),
    "slopeLER" numeric(19,15),
    "thresINER" numeric(19,15),
    "slopeINER" numeric(19,15),
    "thresTransp" numeric(19,15),
    power_for_cstr numeric(19,15),
    "ETPmax" numeric(19,15),
    nbleaf_pi numeric(19,15),
    nb_leaf_stem_elong numeric(19,15),
    nb_leaf_param2 numeric(19,15),
    "coef_plasto_PI" numeric(19,15),
    "coef_ligulo_PI" numeric(19,15),
    "coeff_PI_lag" numeric(19,15),
    "coef_MGR_PI" numeric(19,15),
    "slope_LL_BL_at_PI" numeric(19,15),
    coeff_flo_lag numeric(19,15),
    "TT_PI_to_Flo" numeric(19,15),
    "maximumReserveInInternode" numeric(19,15),
    "leaf_width_to_IN_diameter" numeric(19,15),
    "leaf_length_to_IN_length" numeric(19,15),
    "slope_length_IN" numeric(19,15),
    spike_creation_rate numeric(19,15),
    grain_filling_rate numeric(19,15),
    gdw_empty numeric(19,15),
    grain_per_cm_on_panicle numeric(19,15),
    phenostage_to_end_filling numeric(19,15),
    phenostage_to_maturity numeric(19,15),
    "IN_diameter_to_length" numeric(19,15),
    "Fldw" numeric(19,15),
    "testIc" numeric(19,15),
    nbtiller numeric(19,15),
    "K_IntN" numeric(19,15),
    pfact numeric(19,15),
    stressfact numeric(19,15),
    "Assim_A" numeric(19,15),
    "Assim_B" numeric(19,15),
    "LIN1" numeric(19,15),
    "IN_A" numeric(19,15),
    "IN_B" numeric(19,15),
    coeff_lifespan numeric(19,15),
    mu numeric(19,15),
    "ratio_INPed" numeric(19,15),
    peduncle_diam numeric(19,15),
    "IN_length_to_IN_diam" numeric(19,15),
    "coef_lin_IN_diam" numeric(19,15),
    "phenostage_PRE_FLO_to_FLO" numeric(19,15),
    "density_IN" numeric(19,15),
    "existTiller" numeric(19,15),
    id character varying(50) NOT NULL
);


ALTER TABLE public.variety OWNER TO user_samara;

--
-- Data for Name: meteorology; Type: TABLE DATA; Schema: public; Owner: user_samara
--

INSERT INTO meteorology VALUES ('27/05/2014', 17.20, 9.76, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('28/05/2014', 16.40, 13.00, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('29/05/2014', 20.10, 10.22, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('30/05/2014', 20.40, 11.24, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('31/05/2014', 21.00, 10.78, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('01/06/2014', 20.60, 12.89, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('02/06/2014', 20.60, 11.74, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('03/06/2014', 21.50, 9.85, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('04/06/2014', 19.10, 7.33, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('05/06/2014', 17.70, 13.18, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('06/06/2014', 18.80, 11.65, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('07/06/2014', 20.10, 12.16, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('08/06/2014', 22.00, 12.84, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('09/06/2014', 22.80, 11.66, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('10/06/2014', 24.30, 13.18, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('11/06/2014', 25.90, 13.01, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('12/06/2014', 27.20, 11.73, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('13/06/2014', 26.80, 9.56, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('14/06/2014', 27.10, 12.90, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('15/06/2014', 20.60, 4.48, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('16/06/2014', 23.30, 11.52, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('17/06/2014', 20.80, 8.63, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('18/06/2014', 18.90, 9.16, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('19/06/2014', 21.20, 13.37, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('20/06/2014', 23.20, 13.16, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('21/06/2014', 23.20, 12.99, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('22/06/2014', 22.90, 12.24, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('23/06/2014', 22.90, 9.11, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('24/06/2014', 24.70, 12.21, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('25/06/2014', 21.90, 9.02, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('26/06/2014', 24.80, 11.83, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('27/06/2014', 23.20, 12.90, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('28/06/2014', 22.90, 10.81, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('29/06/2014', 21.50, 10.55, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('30/06/2014', 22.20, 13.37, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('01/07/2014', 21.10, 9.75, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('02/07/2014', 22.20, 11.75, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('03/07/2014', 23.00, 10.50, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('04/07/2014', 23.10, 5.85, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('05/07/2014', 23.30, 11.53, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('06/07/2014', 22.90, 9.26, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('07/07/2014', 19.60, 4.33, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('08/07/2014', 21.20, 12.24, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('09/07/2014', 21.00, 9.37, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('10/07/2014', 20.50, 8.39, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('11/07/2014', 22.80, 12.24, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('12/07/2014', 23.40, 10.17, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('13/07/2014', 23.40, 11.06, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('14/07/2014', 24.50, 12.41, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('15/07/2014', 24.00, 13.09, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('16/07/2014', 25.40, 12.91, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('17/07/2014', 24.30, 12.86, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('18/07/2014', 23.70, 12.53, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('19/07/2014', 24.30, 7.90, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('20/07/2014', 23.00, 6.25, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('21/07/2014', 24.20, 10.63, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('22/07/2014', 26.00, 12.19, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('23/07/2014', 25.60, 9.80, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('24/07/2014', 25.40, 11.74, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('25/07/2014', 22.40, 6.21, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('26/07/2014', 24.90, 12.28, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('27/07/2014', 26.70, 11.25, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('28/07/2014', 23.60, 6.43, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('29/07/2014', 21.10, 7.40, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('30/07/2014', 25.70, 11.80, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('31/07/2014', 25.40, 11.91, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('01/08/2014', 23.30, 10.21, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('02/08/2014', 22.40, 9.27, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('03/08/2014', 23.20, 11.89, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('04/08/2014', 24.50, 8.93, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('05/08/2014', 24.90, 11.04, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('06/08/2014', 24.80, 11.54, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('07/08/2014', 26.70, 10.66, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('08/08/2014', 23.90, 10.88, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('09/08/2014', 22.60, 9.36, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('10/08/2014', 23.80, 6.41, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('11/08/2014', 25.50, 9.50, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('12/08/2014', 23.40, 10.73, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('13/08/2014', 21.50, 10.88, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('14/08/2014', 21.30, 10.63, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('15/08/2014', 21.60, 11.15, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('16/08/2014', 21.70, 11.13, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('17/08/2014', 20.50, 11.44, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('18/08/2014', 20.40, 10.46, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('19/08/2014', 22.60, 9.71, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('20/08/2014', 21.30, 9.73, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('21/08/2014', 20.40, 10.90, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('22/08/2014', 19.80, 5.98, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('23/08/2014', 21.80, 10.14, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('24/08/2014', 19.80, 9.58, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('25/08/2014', 20.20, 10.25, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('26/08/2014', 22.80, 6.97, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('27/08/2014', 24.80, 10.48, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('28/08/2014', 23.80, 10.36, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('29/08/2014', 24.50, 7.96, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('30/08/2014', 23.80, 8.83, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('31/08/2014', 23.70, 10.26, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('01/09/2014', 23.40, 10.26, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('02/09/2014', 23.40, 10.08, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('03/09/2014', 20.80, 10.02, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('04/09/2014', 20.20, 9.63, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('05/09/2014', 22.10, 9.33, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('06/09/2014', 22.50, 9.03, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('07/09/2014', 21.70, 8.95, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('08/09/2014', 22.30, 6.11, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('09/09/2014', 21.40, 9.41, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('10/09/2014', 23.20, 8.45, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('11/09/2014', 22.80, 9.05, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('12/09/2014', 22.20, 9.17, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('13/09/2014', 21.30, 9.12, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('14/09/2014', 20.60, 9.10, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('15/09/2014', 20.80, 5.96, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('16/09/2014', 20.80, 6.79, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('17/09/2014', 22.00, 3.61, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('18/09/2014', 21.20, 4.44, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('19/09/2014', 23.00, 6.48, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('20/09/2014', 22.50, 6.35, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('21/09/2014', 22.40, 6.11, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('22/09/2014', 20.50, 7.93, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('23/09/2014', 17.90, 3.06, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('24/09/2014', 16.30, 2.70, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('25/09/2014', 17.00, 7.81, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('26/09/2014', 17.20, 7.79, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('27/09/2014', 17.30, 7.70, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('28/09/2014', 19.70, 6.51, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('29/09/2014', 18.80, 0.55, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('30/09/2014', 19.30, 4.03, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('01/10/2014', 20.60, 7.20, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('02/10/2014', 19.90, 7.25, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('03/10/2014', 18.90, 7.01, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('04/10/2014', 18.40, 6.12, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('05/10/2014', 17.10, 6.27, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('06/10/2014', 16.60, 2.50, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('07/10/2014', 21.20, 5.04, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('08/10/2014', 22.30, 5.17, 0.00, 0.00, 0.00, '2');
INSERT INTO meteorology VALUES ('20/01/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('21/01/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('22/01/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('23/01/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('24/01/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('25/01/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('26/01/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('27/01/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('28/01/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('29/01/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('30/01/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('31/01/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('01/02/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('02/02/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('03/02/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('04/02/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('05/02/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('06/02/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('07/02/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('08/02/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('09/02/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('10/02/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('11/02/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('12/02/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('13/02/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('14/02/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('15/02/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('16/02/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('17/02/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('18/02/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('19/02/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('20/02/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('21/02/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('22/02/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('23/02/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('24/02/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('25/02/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('26/02/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('27/02/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('28/02/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('01/03/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('02/03/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('03/03/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('04/03/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('05/03/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('06/03/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('07/03/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('08/03/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('09/03/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('10/03/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('11/03/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('12/03/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('13/03/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('14/03/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('15/03/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('16/03/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('17/03/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('18/03/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('19/03/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('20/03/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('21/03/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('22/03/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('23/03/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('24/03/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('25/03/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('26/03/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('27/03/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('28/03/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('29/03/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('30/03/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('31/03/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('01/04/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('02/04/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('03/04/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('04/04/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('05/04/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('06/04/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('07/04/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('08/04/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('09/04/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('10/04/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('11/04/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('12/04/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('13/04/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('14/04/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('15/04/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('16/04/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('17/04/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('18/04/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('19/04/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('20/04/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('21/04/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('22/04/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('23/04/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('24/04/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('25/04/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('26/04/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('27/04/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('28/04/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('29/04/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('30/04/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('01/05/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('02/05/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('03/05/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('04/05/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('05/05/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('06/05/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('07/05/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');
INSERT INTO meteorology VALUES ('08/05/2010', 25.00, 8.00, 0.00, 0.00, 0.00, '1');


--
-- Data for Name: simulation; Type: TABLE DATA; Schema: public; Owner: user_samara
--

INSERT INTO simulation VALUES ('1', 'sim_rice', '20/01/2010', '08/05/2010', '1', 'rice');
INSERT INTO simulation VALUES ('2', 'sim_sorghum', '27/05/2014', '23/09/2014', '2', 'sorghum');


--
-- Name: simulation_idsite_seq; Type: SEQUENCE SET; Schema: public; Owner: user_samara
--

SELECT pg_catalog.setval('simulation_idsite_seq', 1, false);


--
-- Name: simulation_idvariety_seq; Type: SEQUENCE SET; Schema: public; Owner: user_samara
--

SELECT pg_catalog.setval('simulation_idvariety_seq', 1, false);


--
-- Data for Name: site; Type: TABLE DATA; Schema: public; Owner: user_samara
--

INSERT INTO site VALUES ('1', 'site 1');
INSERT INTO site VALUES ('2', 'site 2');


--
-- Data for Name: variety; Type: TABLE DATA; Schema: public; Owner: user_samara
--

INSERT INTO variety VALUES (0.020000000000000, 450.000000000000000, 6.600000000000000, 4.000000000000000, 30.000000000000000, 3.200000000000000, 0.650000000000000, 0.015000000000000, 0.005000000000000, 25.000000000000000, 12.000000000000000, 1.300000000000000, 50.000000000000000, 1.000000000000000, 45.000000000000000, 1.000000000000000, 6.500000000000000, 1.100000000000000, 0.200000000000000, 0.100000000000000, -0.100000000000000, 50.000000000000000, 0.600000000000000, 1.450000000000000, 0.725000000000000, 0.025000000000000, 0.990000000000000, -0.005000000000000, 0.400000000000000, 0.400000000000000, 4.000000000000000, 0.100000000000000, 0.000000000000000, 630.000000000000000, 134.000000000000000, 0.000000000000000, 0.000000000000000, 496.000000000000000, 0.100000000000000, 0.700000000000000, 0.300000000000000, 0.230000000000000, 2.050000000000000, 0.564000000000000, 2.385000000000000, 0.580000000000000, 0.500000000000000, 8000.000000000000000, 11.000000000000000, 11.000000000000000, 11.000000000000000, 2.000000000000000, 2.000000000000000, 1.000000000000000, 0.100000000000000, 0.055000000000000, 1.000000000000000, 1400.000000000000000, 0.750000000000000, -0.240000000000000, 22.000000000000000, 1.400000000000000, 0.030000000000000, 0.001000000000000, 0.008000000000000, 20.000000000000000, 22.000000000000000, 23.000000000000000, -77.000000000000000, 0.004400000000000, 1.000000000000000, 0.000000000000000, 0.000000000000000, 1.820000000000000, 1.820000000000000, 1.429200000000000, 1.369200000000000, 3.000000000000000, -0.010040000000000, 0.470000000000000, 910.000000000000000, 0.000000000000000, 2.000000000000000, 0.500000000000000, -0.010000000000000, 0.650000000000000, 2.000000000000000, 0.010000000000000, 0.000000000000000, 'rice');
INSERT INTO variety VALUES (0.030000000000000, 400.000000000000000, 6.000000000000000, 5.000000000000000, 20.000000000000000, 5.660340788000000, 0.500000000000000, 0.015000000000000, 0.007000000000000, 25.000000000000000, 11.000000000000000, 1.500000000000000, 32.615384680000000, 1.000000000000000, 35.000000000000000, 1.000000000000000, 9.871996688000000, 40.000000000000000, 0.200000000000000, 0.100000000000000, -0.100000000000000, 66.228461000000000, 0.600000000000000, 1.350000000000000, 0.690000000000000, 0.080000000000000, 0.990000000000000, -0.005000000000000, 0.400000000000000, 0.400000000000000, 4.000000000000000, 0.100000000000000, 0.000000000000000, 630.000000000000000, 134.000000000000000, 0.000000000000000, 0.000000000000000, 496.000000000000000, 0.100000000000000, 0.700000000000000, 0.300000000000000, 0.231821784301224, 2.050000000000000, 0.564000000000000, 2.385000000000000, 0.575950550584177, 0.500000000000000, 8000.000000000000000, 18.000000000000000, 8.000000000000000, 15.000000000000000, 2.000000000000000, 2.000000000000000, 1.000000000000000, 0.100000000000000, 0.060050621000000, 1.000000000000000, 1400.000000000000000, 0.750000000000000, -0.100000000000000, 20.000000000000000, 1.099355218000000, 0.150000000000000, 0.003000000000000, 0.008000000000000, 20.000000000000000, 30.000000000000000, 31.000000000000000, -77.000000000000000, 0.004400000000000, 1.000000000000000, 0.000000000000000, 0.000000000000000, 1.820000000000000, 1.820000000000000, 1.429200000000000, 1.369200000000000, 3.000000000000000, -0.010040000000000, 0.470000000000000, 594.084223000000000, 0.000000000000000, 1.700000000000000, 0.500000000000000, -0.012300000000000, 2.050000000000000, 2.000000000000000, 0.084596240000000, 0.000000000000000, 'sorghum');


--
-- Name: pk_variety; Type: CONSTRAINT; Schema: public; Owner: user_samara; Tablespace: 
--

ALTER TABLE ONLY variety
    ADD CONSTRAINT pk_variety PRIMARY KEY (id);


--
-- Name: simulation_pkey; Type: CONSTRAINT; Schema: public; Owner: user_samara; Tablespace: 
--

ALTER TABLE ONLY simulation
    ADD CONSTRAINT simulation_pkey PRIMARY KEY (id);


--
-- Name: site_pkey; Type: CONSTRAINT; Schema: public; Owner: user_samara; Tablespace: 
--

ALTER TABLE ONLY site
    ADD CONSTRAINT site_pkey PRIMARY KEY (id);


--
-- Name: fk_site; Type: FK CONSTRAINT; Schema: public; Owner: user_samara
--

ALTER TABLE ONLY simulation
    ADD CONSTRAINT fk_site FOREIGN KEY (idsite) REFERENCES site(id);


--
-- Name: fk_variety; Type: FK CONSTRAINT; Schema: public; Owner: user_samara
--

ALTER TABLE ONLY simulation
    ADD CONSTRAINT fk_variety FOREIGN KEY (idvariety) REFERENCES variety(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

