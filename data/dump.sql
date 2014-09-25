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
    p numeric(6,2)
);


ALTER TABLE public.meteorology OWNER TO user_samara;

--
-- Name: parameter; Type: TABLE; Schema: public; Owner: user_samara; Tablespace:
--

CREATE TABLE parameter (
    gdw numeric(10,6),
    "FSLA" numeric(10,6),
    "Lef1" numeric(10,6),
    "nb_leaf_max_after_PI" numeric(10,6),
    density numeric(10,6),
    "Epsib" numeric(10,6),
    "Kdf" numeric(10,6),
    "Kresp" numeric(10,6),
    "Kresp_internode" numeric(10,6),
    "Tresp" numeric(10,6),
    "Tb" numeric(10,6),
    "Kcpot" numeric(10,6),
    plasto_init numeric(10,6),
    coef_plasto_ligulo numeric(10,6),
    ligulo1 numeric(10,6),
    coef_ligulo1 numeric(10,6),
    "MRG_init" numeric(10,6),
    "Ict" numeric(10,6),
    "resp_Ict" numeric(10,6),
    "resp_R_d" numeric(10,6),
    "resp_LER" numeric(10,6),
    "SLAp" numeric(10,6),
    "G_L" numeric(10,6),
    "LL_BL_init" numeric(10,6),
    allo_area numeric(10,6),
    "WLR" numeric(10,6),
    "coeff1_R_d" numeric(10,6),
    "coeff2_R_d" numeric(10,6),
    "realocationCoeff" numeric(10,6),
    leaf_stock_max numeric(10,6),
    nb_leaf_enabling_tillering numeric(10,6),
    "deepL1" numeric(10,6),
    "deepL2" numeric(10,6),
    "FCL1" numeric(10,6),
    "WPL1" numeric(10,6),
    "FCL2" numeric(10,6),
    "WPL2" numeric(10,6),
    "RU1" numeric(10,6),
    "Sdepth" numeric(10,6),
    "Rolling_A" numeric(10,6),
    "Rolling_B" numeric(10,6),
    "thresLER" numeric(10,6),
    "slopeLER" numeric(10,6),
    "thresINER" numeric(10,6),
    "slopeINER" numeric(10,6),
    "thresTransp" numeric(10,6),
    power_for_cstr numeric(10,6),
    "ETPmax" numeric(10,6),
    nbleaf_pi numeric(10,6),
    nb_leaf_stem_elong numeric(10,6),
    nb_leaf_param2 numeric(10,6),
    "coef_plasto_PI" numeric(10,6),
    "coef_ligulo_PI" numeric(10,6),
    "coeff_PI_lag" numeric(10,6),
    "coef_MGR_PI" numeric(10,6),
    "slope_LL_BL_at_PI" numeric(10,6),
    coeff_flo_lag numeric(10,6),
    "TT_PI_to_Flo" numeric(10,6),
    "maximumReserveInInternode" numeric(10,6),
    "leaf_width_to_IN_diameter" numeric(10,6),
    "leaf_length_to_IN_length" numeric(10,6),
    "slope_length_IN" numeric(10,6),
    spike_creation_rate numeric(10,6),
    grain_filling_rate numeric(10,6),
    gdw_empty numeric(10,6),
    grain_per_cm_on_panicle numeric(10,6),
    phenostage_to_end_filling numeric(10,6),
    phenostage_to_maturity numeric(10,6),
    "IN_diameter_to_length" numeric(10,6),
    "Fldw" numeric(10,6),
    "testIc" numeric(10,6),
    nbtiller numeric(10,6),
    "K_IntN" numeric(10,6),
    pfact numeric(10,6),
    stressfact numeric(10,6),
    "Assim_A" numeric(10,6),
    "Assim_B" numeric(10,6),
    "LIN1" numeric(10,6),
    "IN_A" numeric(10,6),
    "IN_B" numeric(10,6),
    coeff_lifespan numeric(10,6),
    mu numeric(10,6),
    "ratio_INPed" numeric(10,6),
    peduncle_diam numeric(10,6),
    "IN_length_to_IN_diam" numeric(10,6),
    "coef_lin_IN_diam" numeric(10,6),
    "phenostage_PRE_FLO_to_FLO" numeric(10,6),
    "density_IN" numeric(10,6),
    "existTiller" numeric(10,6)
);


ALTER TABLE public.parameter OWNER TO user_samara;

--
-- Data for Name: meteorology; Type: TABLE DATA; Schema: public; Owner: user_samara
--

INSERT INTO meteorology VALUES ('20-01-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('21-01-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('22-01-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('23-01-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('24-01-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('25-01-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('26-01-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('27-01-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('28-01-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('29-01-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('30-01-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('31-01-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('01-02-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('02-02-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('03-02-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('04-02-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('05-02-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('06-02-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('07-02-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('08-02-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('09-02-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('10-02-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('11-02-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('12-02-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('13-02-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('14-02-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('15-02-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('16-02-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('17-02-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('18-02-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('19-02-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('20-02-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('21-02-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('22-02-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('23-02-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('24-02-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('25-02-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('26-02-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('27-02-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('28-02-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('01-03-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('02-03-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('03-03-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('04-03-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('05-03-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('06-03-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('07-03-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('08-03-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('09-03-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('10-03-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('11-03-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('12-03-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('13-03-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('14-03-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('15-03-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('16-03-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('17-03-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('18-03-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('19-03-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('20-03-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('21-03-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('22-03-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('23-03-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('24-03-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('25-03-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('26-03-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('27-03-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('28-03-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('29-03-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('30-03-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('31-03-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('01-04-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('02-04-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('03-04-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('04-04-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('05-04-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('06-04-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('07-04-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('08-04-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('09-04-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('10-04-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('11-04-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('12-04-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('13-04-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('14-04-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('15-04-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('16-04-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('17-04-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('18-04-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('19-04-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('20-04-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('21-04-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('22-04-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('23-04-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('24-04-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('25-04-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('26-04-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('27-04-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('28-04-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('29-04-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('30-04-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('01-05-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('02-05-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('03-05-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('04-05-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('05-05-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('06-05-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('07-05-2010', 25.00, 8.00, 0.00, 0.00, 0.00);
INSERT INTO meteorology VALUES ('08-05-2010', 25.00, 8.00, 0.00, 0.00, 0.00);


--
-- Data for Name: parameter; Type: TABLE DATA; Schema: public; Owner: user_samara
--

INSERT INTO parameter VALUES (0.020000, 450.000000, 6.600000, 4.000000, 30.000000, 3.200000, 0.650000, 0.015000, 0.005000, 25.000000, 12.000000, 1.300000, 50.000000, 1.000000, 45.000000, 1.000000, 6.500000, 1.100000, 0.200000, 0.100000, -0.100000, 50.000000, 0.600000, 1.450000, 0.725000, 0.025000, 0.990000, -0.005000, 0.400000, 0.400000, 4.000000, 0.100000, 0.000000, 630.000000, 134.000000, 0.000000, 0.000000, 496.000000, 0.100000, 0.700000, 0.300000, 0.230000, 2.050000, 0.564000, 2.385000, 0.580000, 0.500000, 8000.000000, 11.000000, 11.000000, 11.000000, 2.000000, 2.000000, 1.000000, 0.100000, 0.055000, 1.000000, 1400.000000, 0.750000, -0.240000, 22.000000, 1.400000, 0.030000, 0.001000, 0.008000, 20.000000, 22.000000, 23.000000, -77.000000, 0.004400, 1.000000, 0.000000, 0.000000, 1.820000, 1.820000, 1.429200, 1.369200, 3.000000, -0.010040, 0.470000, 910.000000, 0.000000, 2.000000, 0.500000, -0.010000, 0.650000, 2.000000, 0.010000, 0.000000);


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
