///**
// * @file utils/ParametersReader.cpp
// * @author The Ecomeristem Development Team
// * See the AUTHORS file
// */
//
///*
// * Copyright (C) 2012-2015 ULCO http://www.univ-littoral.fr
// * Copyright (C) 2005-2015 Cirad http://www.cirad.fr
// *
// * This program is free software: you can redistribute it and/or modify
// * it under the terms of the GNU General Public License as published by
// * the Free Software Foundation, either version 3 of the License, or
// * (at your option) any later version.
// *
// * This program is distributed in the hope that it will be useful,
// * but WITHOUT ANY WARRANTY; without even the implied warranty of
// * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// * GNU General Public License for more details.
// *
// * You should have received a copy of the GNU General Public License
// * along with this program.  If not, see <http://www.gnu.org/licenses/>.
// */
//
//#include <boost/format.hpp>
//
//#include <utils/ParametersReader.hpp>
//
//namespace utils {
//
//void ParametersReader::load(const std::string& id,
//                            model::models::ModelParameters& parameters)
//{
//    pqxx::connection& connection(
//        utils::Connections::connection(
//            "ecomeristem",
//            "dbname=ecomeristem user=user_samara password=toto"));
//
//    load_simulation(id, connection, parameters);
//}
//
//void ParametersReader::load_data(pqxx::connection& connection,
//                                 const std::string& table,
//                                 const std::string& id,
//                                 const std::vector < std::string >& names,
//                                 model::models::ModelParameters& parameters)
//{
//    try {
//        pqxx::work action(connection);
//        pqxx::result result = action.exec(
//            (boost::format("SELECT * FROM \"%1%\" WHERE \"id\" = '%2%'") %
//             table % id).str());
//
//        if (not result.empty()) {
//            for (pqxx::result::tuple::const_iterator it = result[0].begin();
//                 it != result[0].end(); ++it) {
//                std::vector < std::string >::const_iterator itv =
//                    std::find(names.begin(), names.end(), it->name());
//
//                if (itv != names.end()) {
//                    if (it->type() == 1043) {
//                        parameters.set < std::string >(
//                            *itv,  boost::lexical_cast < std::string >(*it));
//                    } else {
//                        parameters.set < double >(
//                            *itv, boost::lexical_cast < double >(*it));
//                    }
//                } else {
//                    parameters.set < double >(it->name(), 0.);
//                }
//            }
//        }
//    } catch (pqxx::sql_error e) {
//        std::cout << "Error: " << e.query() << std::endl;
//    }
//}
//
//void ParametersReader::load_simulation(
//    const std::string& id,
//    pqxx::connection& connection,
//    model::models::ModelParameters& parameters)
//{
//    std::vector < std::string > names = { "gdw",
//                                          "FSLA",
//                                          "Lef1",
//                                          "nb_leaf_max_after_PI",
//                                          "density",
//                                          "Epsib",
//                                          "Kdf",
//                                          "Kresp",
//                                          "Kresp_internode",
//                                          "Tresp",
//                                          "Tb",
//                                          "Kcpot",
//                                          "plasto_init",
//                                          "coef_plasto_ligulo",
//                                          "ligulo1",
//                                          "coef_ligulo1",
//                                          "MGR_init",
//                                          "Ict",
//                                          "resp_Ict",
//                                          "resp_R_d",
//                                          "resp_LER",
//                                          "SLAp",
//                                          "G_L",
//                                          "LL_BL_init",
//                                          "allo_area",
//                                          "WLR",
//                                          "coeff1_R_d",
//                                          "coeff2_R_d",
//                                          "realocationCoeff",
//                                          "leaf_stock_max",
//                                          "nb_leaf_enabling_tillering",
//                                          "deepL1",
//                                          "deepL2",
//                                          "FCL1",
//                                          "WPL1",
//                                          "FCL2",
//                                          "WPL2",
//                                          "RU1",
//                                          "Sdepth",
//                                          "Rolling_A",
//                                          "Rolling_B",
//                                          "thresLER",
//                                          "slopeLER",
//                                          "thresINER",
//                                          "slopeINER",
//                                          "thresTransp",
//                                          "power_for_cstr",
//                                          "ETPmax",
//                                          "nbleaf_pi",
//                                          "nb_leaf_stem_elong",
//                                          "nb_leaf_param2",
//                                          "coef_plasto_PI",
//                                          "coef_ligulo_PI",
//                                          "coeff_PI_lag",
//                                          "coef_MGR_PI",
//                                          "slope_LL_BL_at_PI",
//                                          "coeff_flo_lag",
//                                          "TT_PI_to_Flo",
//                                          "maximumReserveInInternode",
//                                          "leaf_width_to_IN_diameter",
//                                          "leaf_length_to_IN_length",
//                                          "slope_length_IN",
//                                          "spike_creation_rate",
//                                          "grain_filling_rate",
//                                          "gdw_empty",
//                                          "grain_per_cm_on_panicle",
//                                          "phenostage_to_end_filling",
//                                          "phenostage_to_maturity",
//                                          "IN_diameter_to_length",
//                                          "Fldw",
//                                          "testIc",
//                                          "nbtiller",
//                                          "K_IntN",
//                                          "pfact",
//                                          "stressfact",
//                                          "Assim_A",
//                                          "Assim_B",
//                                          "LIN1",
//                                          "IN_A",
//                                          "IN_B",
//                                          "coeff_lifespan",
//                                          "mu",
//                                          "ratio_INPed",
//                                          "peduncle_diam",
//                                          "IN_length_to_IN_diam",
//                                          "coef_lin_IN_diam",
//                                          "phenostage_PRE_FLO_to_FLO",
//                                          "density_IN",
//                                          "existTiller" };
//
//    try {
//        pqxx::work action(connection);
//        pqxx::result result = action.exec(
//            (boost::format("SELECT * FROM \"simulation\" "      \
//                           "WHERE \"name\" = '%1%'") % id).str());
//
//        if (not result.empty()) {
//            pqxx::result::const_iterator it = result.begin();
//
//            parameters.set < std::string >(
//                "BeginDate", boost::lexical_cast < std::string >(it->at(2)));
//            parameters.set < std::string >(
//                "EndDate", boost::lexical_cast < std::string >(it->at(3)));
//            parameters.set < std::string >(
//                "idsite", boost::lexical_cast < std::string >(it->at(4)));
//            parameters.set < std::string >(
//                "idvariety", boost::lexical_cast < std::string >(it->at(5)));
//        }
//
//    // parameters.set < std::string >("BeginDate", "20-01-2010");
//    // parameters.set < std::string >("EndDate", "26-02-2010");
//    // parameters.set < std::string >("idsite", "1");
//    // parameters.set < std::string >("idvariety", "rice");
//
//    } catch (pqxx::sql_error e) {
//        std::cout << "Error: " << e.query() << std::endl;
//    }
//
//
//    load_data(connection, "variety",
//              parameters.get < std::string >("idvariety"), names, parameters);
//}
//
//} // namespace utils


/**
* @file utils/ParametersReader.cpp
* @author The Ecomeristem Development Team
* See the AUTHORS file
*/

/*
* Copyright (C) 2012-2015 ULCO http://www.univ-littoral.fr
* Copyright (C) 2005-2015 Cirad http://www.cirad.fr
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include <boost/format.hpp>
#include <utils/ParametersReader.hpp>
#include <utils/DateTime.hpp>
#include <fstream>

namespace utils {

	void ParametersReader::loadParametersFromProstgresql(const std::string &id,
		model::models::ModelParameters &parameters)
	{

		PGconn* connection =
			PQconnectdb("port='5433' hostaddr='127.0.0.1' dbname='ecomeristem' user='postgres' password='admin'");
		std::cout << PQerrorMessage(connection) << std::endl;
		load_simulation(id, connection, parameters);
		load_meteo(connection, parameters);
	}


	void ParametersReader::loadParametersFromFiles(const std::string &folder,
		model::models::ModelParameters &parameters)
	{
		std::ifstream varietyParams(folder + "/ECOMERISTEM_parameters.txt");
		std::string line;

		while (varietyParams >> line) {
#ifdef OPTIM_NO_LEXCAST
			parameters.set <double>(line.substr(0, line.find("=")),
				std::stod(line.substr(line.find("=") + 1, line.size()).c_str()));
#else
			parameters.set <double>(line.substr(0, line.find("=")),
				boost::lexical_cast<double>(line.substr(line.find("=") + 1, line.size())));
#endif
		}

		std::ifstream meteoFiles[5] = {
			std::ifstream(folder + "/meteo_T.txt"),
			std::ifstream(folder + "/meteo_PAR.txt"),
			std::ifstream(folder + "/meteo_ETP.txt"),
			std::ifstream(folder + "/meteo_irrig.txt"),
			std::ifstream(folder + "/meteo_P.txt")
		};


		std::string values[5] = { "", "", "", "", "" };
		std::string date;
		bool first = true;

		while (meteoFiles[0] >> date) {
			if (first) {
				parameters.set < std::string >("BeginDate", date);
				first = false;
			}

			meteoFiles[0] >> values[0] >> values[0];

			for (int i = 1; i < 5; i++)
				meteoFiles[i] >> values[i] >> values[i] >> values[i];

#ifdef OPTIM_NO_LEXCAST
			parameters.meteoValues.push_back(
				model::models::Climate(
					std::stod(values[0]),
					std::stod(values[1]),
					std::stod(values[2]),
					std::stod(values[3]),
					std::stod(values[4])
				)
			);
#else
			parameters.meteoValues.push_back(
				model::models::Climate(
					boost::lexical_cast<double>(values[0]),
					boost::lexical_cast<double>(values[1]),
					boost::lexical_cast<double>(values[2]),
					boost::lexical_cast<double>(values[3]),
					boost::lexical_cast<double>(values[4])
				)
			);
#endif
		}

		parameters.set < std::string >("EndDate", date);
	}



	void ParametersReader::load_meteo(PGconn* connection, model::models::ModelParameters &parameters)
	{
		std::vector < model::models::Climate > values;
		std::string beginDate;
		std::string endDate;
		double begin;
		double end;
		unsigned int beginYear;
		unsigned int endYear;


		begin = DateTime::fromDayMonthYearToJulianDay(parameters.get
			< std::string >("BeginDate"));
		end = DateTime::fromDayMonthYearToJulianDay(parameters.get < std::string >("EndDate"));
		beginYear = DateTime::year(begin);
		endYear = DateTime::year(end);

		for (unsigned int year = beginYear; year <= endYear; year++) {
			std::string request =
				(boost::format("Select * from meteorology where " \
					"EXTRACT(YEAR FROM day) = %1% " \
					"AND \"idsite\" = '%2%' "       \
					"order by EXTRACT(YEAR FROM day) asc")
					% year % parameters.get < std::string >("idsite")
					).str();

			PGresult* result = PQexec(connection, request.c_str());

			if (PQresultStatus(result) != PGRES_TUPLES_OK) {
				std::cout << "Error: " << PQerrorMessage(connection) << std::endl;
				return;
			}

			for (int i = 0; i < PQntuples(result); i++) {
				std::string day;
				double t;

				//utils::DateTime::format_date(boost::lexical_cast < std::string >(PQgetvalue(result, i, 0)), day);
				t = utils::DateTime::fromYearMonthDayToJulianDay(boost::lexical_cast < std::string >(PQgetvalue(
					result, i, 0)));

				if (t >= begin && t <= end) {
					parameters.meteoValues.push_back(
						model::models::Climate(
							boost::lexical_cast < double >(PQgetvalue(result, i, 1)),
							boost::lexical_cast < double >(PQgetvalue(result, i, 2)),
							boost::lexical_cast < double >(PQgetvalue(result, i, 3)),
							boost::lexical_cast < double >(PQgetvalue(result, i, 4)),
							boost::lexical_cast < double >(PQgetvalue(result, i, 5))
						)
					);
				}
			}
		}
	}


	void ParametersReader::load_data(PGconn* connection,
		const std::string &table,
		const std::string &id,
		const std::vector < std::string > &names,
		model::models::ModelParameters &parameters)
	{

		PGresult* result = PQexec(
			connection,
			(boost::format("SELECT * FROM \"%1%\" WHERE \"id\" = '%2%'") % table % id).str().c_str()
		);

		if (PQresultStatus(result) != PGRES_TUPLES_OK)
			std::cout << "Error: " << PQerrorMessage(connection) << std::endl;


		for (int i = 0; i < PQnfields(result); i++) {
			std::vector < std::string >::const_iterator itv = std::find(names.begin(), names.end(),
				PQfname(result, i));

			if (itv != names.end()) {
				if ((PQftype(result, i) == 1043) || (PQftype(result, i) == 1082))
					parameters.set <std::string>(*itv, PQgetvalue(result, 0, i));

				else
					parameters.set<double>(*itv, boost::lexical_cast<double>(PQgetvalue(result, 0, i)));

			}
			else
				parameters.set < double >(PQfname(result, i), 0.);
		}
	}

	void ParametersReader::load_simulation(
		const std::string &id,
		PGconn* connection,
		model::models::ModelParameters &parameters)
	{
		std::vector < std::string > names = {
			"gdw",
			"FSLA",
			"Lef1",
			"nb_leaf_max_after_PI",
			"density",
			"Epsib",
			"Kdf",
			"Kresp",
			"Kresp_internode",
			"Tresp",
			"Tb",
			"Kcpot",
			"plasto_init",
			"coef_plasto_ligulo",
			"ligulo1",
			"coef_ligulo1",
			"MGR_init",
			"Ict",
			"resp_Ict",
			"resp_R_d",
			"resp_LER",
			"SLAp",
			"G_L",
			"LL_BL_init",
			"allo_area",
			"WLR",
			"coeff1_R_d",
			"coeff2_R_d",
			"realocationCoeff",
			"leaf_stock_max",
			"nb_leaf_enabling_tillering",
			"deepL1",
			"deepL2",
			"FCL1",
			"WPL1",
			"FCL2",
			"WPL2",
			"RU1",
			"Sdepth",
			"Rolling_A",
			"Rolling_B",
			"thresLER",
			"slopeLER",
			"thresINER",
			"slopeINER",
			"thresTransp",
			"power_for_cstr",
			"ETPmax",
			"nbleaf_pi",
			"nb_leaf_stem_elong",
			"nb_leaf_param2",
			"coef_plasto_PI",
			"coef_ligulo_PI",
			"coeff_PI_lag",
			"coef_MGR_PI",
			"slope_LL_BL_at_PI",
			"coeff_flo_lag",
			"TT_PI_to_Flo",
			"maximumReserveInInternode",
			"leaf_width_to_IN_diameter",
			"leaf_length_to_IN_length",
			"slope_length_IN",
			"spike_creation_rate",
			"grain_filling_rate",
			"gdw_empty",
			"grain_per_cm_on_panicle",
			"phenostage_to_end_filling",
			"phenostage_to_maturity",
			"IN_diameter_to_length",
			"Fldw",
			"testIc",
			"nbtiller",
			"K_IntN",
			"pfact",
			"stressfact",
			"Assim_A",
			"Assim_B",
			"LIN1",
			"IN_A",
			"IN_B",
			"coeff_lifespan",
			"mu",
			"ratio_INPed",
			"peduncle_diam",
			"IN_length_to_IN_diam",
			"coef_lin_IN_diam",
			"phenostage_PRE_FLO_to_FLO",
			"density_IN",
			"existTiller"
		};



		std::string request = (boost::format("SELECT * FROM simulation WHERE name = '%1%'") % id).str();

		PGresult* result = PQexec(connection, request.c_str());

		if (PQresultStatus(result) != PGRES_TUPLES_OK) {
			std::cout << "Error: " << PQerrorMessage(connection) << std::endl;
			return;
		}

		parameters.set < std::string >(
			"BeginDate", boost::lexical_cast <std::string>(PQgetvalue(result, 0, 2)));
		parameters.set < std::string >(
			"EndDate", boost::lexical_cast <std::string>(PQgetvalue(result, 0, 3)));
		parameters.set < std::string >(
			"idsite", boost::lexical_cast <std::string>(PQgetvalue(result, 0, 4)));
		parameters.set < std::string >(
			"idvariety", boost::lexical_cast <std::string>(PQgetvalue(result, 0, 5)));

		// parameters.set < std::string >("BeginDate", "20-01-2010");
		// parameters.set < std::string >("EndDate", "26-02-2010");
		// parameters.set < std::string >("idsite", "1");
		// parameters.set < std::string >("idvariety", "rice");


		load_data(connection, "variety",
			parameters.get < std::string >("idvariety"), names, parameters);
	}

} // namespace utils
