/**
 * @file test/test.cpp
 * @author The Ecomeristem Development Team
 * See the AUTHORS or Authors.txt file
 */

/*
 * Copyright (C) 2005-2014 Cirad http://www.cirad.fr
 * Copyright (C) 2012-2014 ULCO http://www.univ-littoral.fr
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

#define CATCH_CONFIG_MAIN
#include <test/catch.hpp>

#include <model/kernel/Model.hpp>
#include <model/kernel/Simulator.hpp>
#include <model/observer/View.hpp>

#include <model/models/ModelParameters.hpp>

#include <utils/DateTime.hpp>
#include <utils/ParametersReader.hpp>

#define BUFFER_SIZE 1024

using namespace model;

void check_values(const std::string& file_name,
                  double begin,
                  double end,
                  const kernel::Simulator& simulator,
                  const std::string& view_name,
                  const std::string& var_name)
{
    std::ifstream f(file_name);
    char line[BUFFER_SIZE];
    double t = begin;

    const observer::View& view(simulator.observer().view(view_name));

    f.getline(line, BUFFER_SIZE);
    f.getline(line, BUFFER_SIZE);
    f.getline(line, BUFFER_SIZE);
    for (unsigned int j = 0; j < (unsigned int)(end - begin + 1); ++j) {
	std::vector < std::string > columns;
        std::string l;

	f.getline(line, BUFFER_SIZE);
	l = line;
	boost::split(columns, l, boost::is_any_of(" \t\n"),
                     boost::token_compress_on);

        std::string info = (boost::format("[%1%] %2% => %3%") % var_name %
                            utils::DateTime::toJulianDay(begin + j) % j).str();

        CAPTURE(info);
        REQUIRE(boost::lexical_cast < double >(
                    columns[2]) == Approx(view.get(t, var_name))
            );
        ++t;
    }
}

static void format_dates(const model::models::ModelParameters& parameters,
                         std::string& begin, std::string& end)
{
    utils::DateTime::format_date(parameters.get < std::string >("BeginDate"),
                                 begin);
    utils::DateTime::format_date(parameters.get < std::string >("EndDate"),
                                 end);
}

TEST_CASE("Thermal_time_tests", "variables")
{
    kernel::Model* model = new kernel::Model;
    kernel::Simulator simulator(model);
    model::models::ModelParameters parameters;
    utils::ParametersReader reader;
    std::string begin;
    std::string end;

    reader.load("", parameters);
    format_dates(parameters, begin, end);
    simulator.init(utils::DateTime::toJulianDayNumber(begin), parameters);
    simulator.run(utils::DateTime::toJulianDayNumber(begin),
                  utils::DateTime::toJulianDayNumber(end));

    check_values("DD_out.txt", utils::DateTime::toJulianDayNumber(begin),
                 utils::DateTime::toJulianDayNumber(end), simulator,
                 "plant", "DD");
    check_values("EDD_out.txt", utils::DateTime::toJulianDayNumber(begin),
                 utils::DateTime::toJulianDayNumber(end), simulator,
                 "plant", "EDD");
    check_values("IH_out.txt", utils::DateTime::toJulianDayNumber(begin),
                 utils::DateTime::toJulianDayNumber(end), simulator,
                 "plant", "IH");
    check_values("ligulo_visu_out.txt",
                 utils::DateTime::toJulianDayNumber(begin),
                 utils::DateTime::toJulianDayNumber(end), simulator,
                 "plant", "LIGULO_VISU");
    check_values("n_out.txt",
                 utils::DateTime::toJulianDayNumber(begin),
                 utils::DateTime::toJulianDayNumber(end), simulator,
                 "plant", "PHENO_STAGE");
    check_values("plasto_visu_out.txt",
                 utils::DateTime::toJulianDayNumber(begin),
                 utils::DateTime::toJulianDayNumber(end), simulator,
                 "plant", "PLASTO_VISU");
    check_values("TT_out.txt",
                 utils::DateTime::toJulianDayNumber(begin),
                 utils::DateTime::toJulianDayNumber(end), simulator,
                 "plant", "TT");
    check_values("TT_lig_out.txt",
                 utils::DateTime::toJulianDayNumber(begin),
                 utils::DateTime::toJulianDayNumber(end), simulator,
                 "plant", "TT_LIG");
}

TEST_CASE("Water_balance_tests", "variables")
{
    kernel::Model* model = new kernel::Model;
    kernel::Simulator simulator(model);
    model::models::ModelParameters parameters;
    utils::ParametersReader reader;
    std::string begin;
    std::string end;

    reader.load("", parameters);
    format_dates(parameters, begin, end);
    simulator.init(utils::DateTime::toJulianDayNumber(begin), parameters);
    simulator.run(utils::DateTime::toJulianDayNumber(begin),
                  utils::DateTime::toJulianDayNumber(end));

    check_values("cstr_out.txt",
                 utils::DateTime::toJulianDayNumber(begin),
                 utils::DateTime::toJulianDayNumber(end), simulator,
                 "plant", "CSTR");
}

TEST_CASE("Assimilation_tests", "variables")
{
    kernel::Model* model = new kernel::Model;
    kernel::Simulator simulator(model);
    model::models::ModelParameters parameters;
    utils::ParametersReader reader;
    std::string begin;
    std::string end;

    reader.load("", parameters);
    format_dates(parameters, begin, end);
    simulator.init(utils::DateTime::toJulianDayNumber(begin), parameters);
    simulator.run(utils::DateTime::toJulianDayNumber(begin),
                  utils::DateTime::toJulianDayNumber(end));

    check_values("assim_out.txt",
                 utils::DateTime::toJulianDayNumber(begin),
                 utils::DateTime::toJulianDayNumber(end), simulator,
                 "plant", "ASSIM");
}

TEST_CASE("Root_tests", "variables")
{
    kernel::Model* model = new kernel::Model;
    kernel::Simulator simulator(model);
    model::models::ModelParameters parameters;
    utils::ParametersReader reader;
    std::string begin;
    std::string end;

    reader.load("", parameters);
    format_dates(parameters, begin, end);
    simulator.init(utils::DateTime::toJulianDayNumber(begin), parameters);
    simulator.run(utils::DateTime::toJulianDayNumber(begin),
                  utils::DateTime::toJulianDayNumber(end));

    check_values("R_d_out.txt",
                 utils::DateTime::toJulianDayNumber(begin),
                 utils::DateTime::toJulianDayNumber(end), simulator,
                 "plant", "ROOT_DEMAND_COEF");
    check_values("biomRoot_out.txt",
                 utils::DateTime::toJulianDayNumber(begin),
                 utils::DateTime::toJulianDayNumber(end), simulator,
                 "plant", "ROOT_BIOMASS");
}

TEST_CASE("Stock_tests", "variables")
{
    kernel::Model* model = new kernel::Model;
    kernel::Simulator simulator(model);
    model::models::ModelParameters parameters;
    utils::ParametersReader reader;
    std::string begin;
    std::string end;

    reader.load("", parameters);
    format_dates(parameters, begin, end);
    simulator.init(utils::DateTime::toJulianDayNumber(begin), parameters);
    simulator.run(utils::DateTime::toJulianDayNumber(begin),
                  utils::DateTime::toJulianDayNumber(end));

    check_values("supply_out.txt",
                 utils::DateTime::toJulianDayNumber(begin),
                 utils::DateTime::toJulianDayNumber(end), simulator,
                 "plant", "SUPPLY");
    check_values("stock_out.txt",
                 utils::DateTime::toJulianDayNumber(begin),
                 utils::DateTime::toJulianDayNumber(end), simulator,
                 "plant", "STOCK");
    check_values("reservoirDispo_out.txt",
                 utils::DateTime::toJulianDayNumber(begin),
                 utils::DateTime::toJulianDayNumber(end), simulator,
                 "plant", "RESERVOIR_DISPO");
    check_values("deficit_out.txt",
                 utils::DateTime::toJulianDayNumber(begin),
                 utils::DateTime::toJulianDayNumber(end), simulator,
                 "plant", "DEFICIT");
    check_values("dayDemand_out.txt",
                 utils::DateTime::toJulianDayNumber(begin),
                 utils::DateTime::toJulianDayNumber(end), simulator,
                 "plant", "DAY_DEMAND");
    check_values("seedres_out.txt",
                 utils::DateTime::toJulianDayNumber(begin),
                 utils::DateTime::toJulianDayNumber(end), simulator,
                 "plant", "SEED_RES");
}
