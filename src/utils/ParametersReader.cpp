/**
 * @file utils/ParametersReader.cpp
 * @author The Samara Development Team
 * See the AUTHORS file
 */

/*
 * Copyright (C) 2013-2014 ULCO http://www.univ-littoral.fr
 * Copyright (C) 2013-2014 INRA http://www.inra.fr
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

#include <iostream>

namespace utils {

void ParametersReader::load(const std::string& id,
                            model::models::ModelParameters& parameters)
{
    pqxx::connection& connection(
        utils::Connections::connection(
            "samara", "dbname=samara user=user_samara password=toto"));

    load_simulation(id, connection, parameters);

    load_variety(parameters.get < std::string >("IdVariety"), connection,
                 parameters);
    load_itineraire_technique(
        parameters.get < std::string >("IdItineraireTechnique"), connection,
        parameters);
    load_plot(parameters.get < std::string >("IdPlot"), connection, parameters);
    load_site(parameters.get < std::string >("IdSite"), connection, parameters);
    load_station(parameters.get < std::string >("CodeStationMeteo"),
                 connection, parameters);
    load_type_soil(parameters.get < std::string >("IdTypeSol"), connection,
                   parameters);

    std::cout << "Simulation " << id << ":" << std::endl;
    std::cout << " - begin = " << parameters.get < std::string >("BeginDate")
              << std::endl;
    std::cout << " - end = " << parameters.get < std::string >("EndDate")
              << std::endl;
    std::cout << " - variety = " << parameters.get < std::string >("IdVariety")
              << std::endl;
    std::cout << " - itineraire technique = "
              << parameters.get < std::string >("IdItineraireTechnique")
              << std::endl;
    std::cout << " - date semis = "
              << parameters.get < std::string >("DateSemis")
              << std::endl;
    std::cout << " - plot = " << parameters.get < std::string >("IdPlot")
              << std::endl;
    std::cout << " - site = " << parameters.get < std::string >("IdSite")
              << std::endl;
    std::cout << " - station = "
              << parameters.get < std::string >("CodeStationMeteo")
              << std::endl;
    std::cout << " - type_soil = "
              << parameters.get < std::string >("IdTypeSol")
              << std::endl;

}

void ParametersReader::load_data(pqxx::connection& connection,
                                 const std::string& table,
                                 const std::string& key,
                                 const std::string& value,
                                 const std::vector < std::string >& names,
                                 model::models::ModelParameters& parameters)
{
    try {
        pqxx::work action(connection);
        pqxx::result result = action.exec(
            (boost::format("SELECT * FROM \"%1%\" WHERE \"%2%\"='%3%'") %
             table % key % value).str());

        if (not result.empty()) {
            for (pqxx::result::tuple::const_iterator it = result[0].begin();
                 it != result[0].end(); ++it) {
                std::vector < std::string >::const_iterator itv =
                    std::find(names.begin(), names.end(), it->name());

                if (itv != names.end()) {
                    if (it->type() == 1043) {
                        parameters.set < std::string >(
                            *itv,  boost::lexical_cast < std::string >(*it));
                    } else {
                        parameters.set < double >(
                            *itv, boost::lexical_cast < double >(*it));
                    }
                } else {
                    parameters.set < double >(it->name(), 0.);
                }
            }
        }
    } catch (pqxx::sql_error e) {
        std::cout << "Error: " << e.query() << std::endl;
    }
}

void ParametersReader::load_variety(
    const std::string& id,
    pqxx::connection& connection,
    model::models::ModelParameters& parameters)
{
    std::vector < std::string > names = {
        "ASScstr",
        "AttenMitch",
        "Ca",
        "CO2Cp",
        "CO2Exp",
        "CoeffAssimSla",
        "CoefficientQ10",
        "CoeffInternodeMass",
        "CoeffInternodeNum",
        "CoeffLeafDeath",
        "CoeffLeafWLRatio",
        "CoeffPanicleMass",
        "CoeffPanSinkPop",
        "CoeffResCapacityInternode",
        "CoeffReserveSink",
        "CoeffRootMassPerVolMax",
        "CoeffTillerDeath",
        "DEVcstr",
        "ExcessAssimToRoot",
        "FTSWIrrig",
        "HaunCritTillering",
        "IcTillering",
        "InternodeLengthMax",
        "IrrigAutoResume",
        "IrrigAutoStop",
        "KcMax",
        "KCritSterCold1",
        "KCritSterCold2",
        "KCritSterFtsw1",
        "KCritSterFtsw2",
        "KCritSterHeat2",
        "KCritStressCold1",
        "KCritStressCold2",
        "Kdf",
        "KRespInternode",
        "KRespMaintLeaf",
        "KRespMaintRoot",
        "KRespMaintSheath",
        "KRespPanicle",
        "KTempMaint",
        "LeafLengthMax",
        "PanStructMassMax",
        "PFactor",
        "Phyllo",
        "PoidsSecGrain",
        "PPCrit",
        "PPExp",
        "PriorityPan",
        "RankLongestLeaf",
        "RelMobiliInternodeMax",
        "RollingBase",
        "RollingSens",
        "RootCstr",
        "RootFrontMax",
        "RootPartitMax",
        "SDJBVP",
        "SDJLevee",
        "SDJMatu1",
        "SDJMatu2",
        "SDJRPR",
        "SeuilPP",
        "SlaMax",
        "SlaMin",
        "TBase",
        "TempSla",
        "TilAbility",
        "TLet",
        "TOpt1",
        "TOpt2",
        "TransplantingDepth",
        "TxAssimBVP",
        "TxAssimMatu1",
        "TxAssimMatu2",
        "TxConversion",
        "TxResGrain",
        "VRacBVP",
        "VRacLevee",
        "VRacMatu1",
        "VRacMatu2",
        "VRacPSP",
        "VRacRPR",
        "WaterLoggingSens",
        "WtRatioLeafSheath"
    };

    load_data(connection, "variety", "Id", id, names, parameters);
}

void ParametersReader::load_itineraire_technique(
    const std::string& id,
    pqxx::connection& connection,
    model::models::ModelParameters& parameters)
{
    std::vector < std::string > names = {
        "BundHeight",
        "CoeffTransplantingShock",
        "DateSemis",
        "DensityField",
        "DensityNursery",
        "DurationNursery",
        "FTSWIrrig",
        "IrrigAuto",
        "IrrigAutoResume",
        "IrrigAutoStop",
        "IrrigAutoTarget",
        "LifeSavingDrainage",
        "Mulch",
        "PlantsPerHill",
        "PlotDrainageDAF",
        "ProfRacIni",
        "Transplanting",
        "TransplantingDepth"
    };

    load_data(connection, "itineraireTechnique", "Id", id, names, parameters);
}

void ParametersReader::load_plot(
    const std::string& id,
    pqxx::connection& connection,
    model::models::ModelParameters& parameters)
{
    std::vector < std::string > names = {
        "Ca", "EpaisseurProf", "EpaisseurSurf", "StockIniProf", "StockIniSurf",
        "IdTypeSol"
    };

    load_data(connection, "plot", "Id", id, names, parameters);
}

void ParametersReader::load_simulation(
    const std::string& id,
    pqxx::connection& connection,
    model::models::ModelParameters& parameters)
{
    std::vector < std::string > names = { "IdSite","IdPlot", "IdVariety",
                                          "IdItineraireTechnique",
                                          "BeginDate", "EndDate" };

    load_data(connection, "simulation", "Id", id, names, parameters);
}

void ParametersReader::load_site(
    const std::string& id,
    pqxx::connection& connection,
    model::models::ModelParameters& parameters)
{
    std::vector < std::string > names = { "SeuilPluie", "Kpar",
                                          "CodeStationMeteo" };

    load_data(connection, "site", "Id", id, names, parameters);
}

void ParametersReader::load_station(
    const std::string& id,
    pqxx::connection& connection,
    model::models::ModelParameters& parameters)
{
    std::vector < std::string > names = { "Altitude", "Latitude" };

    load_data(connection, "station", "Code", id, names, parameters);
}

void ParametersReader::load_type_soil(
    const std::string& id,
    pqxx::connection& connection,
    model::models::ModelParameters& parameters)
{
    std::vector < std::string > names = {
        "HumFC", "HumPF", "HumSat", "PercolationMax", "PourcRuiss",
        "SeuilRuiss"
    };

    load_data(connection, "typeSoil", "Id", id, names, parameters);
}

} // namespace utils
