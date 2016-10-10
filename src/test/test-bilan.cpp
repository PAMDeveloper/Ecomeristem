/**
 * @file test/test-bilan.cpp
 * @author The Ecomeristem Development Team
 * See the AUTHORS or Authors.txt file
 */

/*
 * Copyright (C) 2005-2016 Cirad http://www.cirad.fr
 * Copyright (C) 2012-2016 ULCO http://www.univ-littoral.fr
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
#include <model/observer/PlantView.hpp>

#include <model/models/ModelParameters.hpp>

#include <utils/DateTime.hpp>
#include <utils/ParametersReader.hpp>

#define SIMULATION_NAME "sim_sorghum"

using namespace model;

static void format_dates(const model::models::ModelParameters& parameters,
                         std::string& begin, std::string& end)
{
    utils::DateTime::format_date(parameters.get < std::string >("BeginDate"),
                                 begin);
    utils::DateTime::format_date(parameters.get < std::string >("EndDate"),
                                 end);
}

TEST_CASE("Bilan_tests", "variables")
{
    ecomeristem::GlobalParameters globalParameters;
    kernel::Model* model = new kernel::Model;
    kernel::Simulator simulator(model, globalParameters);
    model::models::ModelParameters parameters;
    utils::ParametersReader reader;
    std::string begin;
    std::string end;

    simulator.attachView("plant", new observer::PlantView);

    utils::Trace::trace().clear();
    reader.loadParametersFromProstgresql(SIMULATION_NAME, parameters);
    format_dates(parameters, begin, end);
    simulator.init(utils::DateTime::toJulianDayNumber(begin), parameters);
    simulator.run(utils::DateTime::toJulianDayNumber(begin),
                  utils::DateTime::toJulianDayNumber(end));


    double t0 = utils::DateTime::toJulianDayNumber(begin);
    double t1 = utils::DateTime::toJulianDayNumber(end);
    double seed_res_1 = parameters.get < double >("gdw");
    double totalBiomass_1 = 0;
    double deficit_1 = 0;
    double senesc_dw_sum = 0;
    double senesc_dw_sum_1 = 0;

    std::cout << "time\t" << "assim\t" << "totalBiomass\t"
              << "deficit\t" << "senesc\t" << "surplus\t"
              << "seed res\t" << "sum1\t" << "sum2\t"
              << "bilan\t" << "day demand\t" << "last_demand\t"
              << "leaf_demand_sum\t" << "internode_demand_sum\t"
              << "root_demand\tpheno_stage\tstock\t"
              << "rootBiomass\tleafBiomassSum\tinternodeBiomassSum"
              << std::endl;

    for (double t = t0; t <= t1; ++t) {
        const model::observer::View & view(simulator.observer().view("plant"));
        double pheno_stage = view.get(t, "Plant:PHENO_STAGE");
        double assim = view.get(t, "Plant:ASSIM");
        double deficit = view.get(t, "Plant:DEFICIT");
        double stock = view.get(t, "Plant:STOCK");
        double leafBiomassSum = view.get(t, "Plant:LEAF_BIOMASS_SUM");
        double internodeBiomassSum = view.get(t, "Plant:INTERNODE_BIOMASS_SUM");
        double surplus = view.get(t, "Plant:SURPLUS");
        double rootBiomass = view.get(t, "Plant:ROOT_BIOMASS");
        double seed_res = view.get(t, "Plant:SEED_RES");
        double day_demand = view.get(t, "Plant:DAY_DEMAND");
        double root_demand = view.get(t, "Plant:ROOT_DEMAND");
        double leaf_last_demand_sum = view.get(t, "Plant:LEAF_LAST_DEMAND_SUM");
        double internode_last_demand_sum =
            view.get(t, "Plant:INTERNODE_LAST_DEMAND_SUM");
        double leaf_demand_sum = view.get(t, "Plant:LEAF_DEMAND_SUM");
        double internode_demand_sum =
            view.get(t, "Plant:INTERNODE_DEMAND_SUM");
        double totalBiomass = rootBiomass + leafBiomassSum +
            internodeBiomassSum + stock;
        double sum1 = assim + (seed_res_1 - seed_res);

        senesc_dw_sum += view.get(t, "Plant:SENESC_DW_SUM");

        double sum2 = totalBiomass == 0 ? 0 : totalBiomass + deficit +
            surplus + senesc_dw_sum - (totalBiomass_1 + deficit_1 +
                                       senesc_dw_sum_1);

        std::cout << utils::DateTime::toJulianDay(t)
                  << "\t" << assim
                  << "\t" << totalBiomass
                  << "\t" << deficit
                  << "\t" << senesc_dw_sum
                  << "\t" << surplus
                  << "\t" << seed_res
                  << "\t" << sum1
                  << "\t" << sum2
                  << "\t" << (sum1 - sum2)
                  << "\t" << day_demand
                  << "\t" << (leaf_last_demand_sum + internode_last_demand_sum)
                  << "\t" << leaf_demand_sum
                  << "\t" << internode_demand_sum
                  << "\t" << root_demand
                  << "\t" << pheno_stage
                  << "\t" << stock
                  << "\t" << rootBiomass
                  << "\t" << leafBiomassSum
                  << "\t" << internodeBiomassSum
                  << std::endl;

        seed_res_1 = seed_res;
        totalBiomass_1 = totalBiomass;
        deficit_1 = deficit;
        senesc_dw_sum_1 = senesc_dw_sum;
    }
}
