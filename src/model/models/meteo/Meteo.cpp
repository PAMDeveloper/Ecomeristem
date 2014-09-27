/**
 * @file model/models/meteo/Meteo.cpp
 * @author The Ecomeristem Development Team
 * See the AUTHORS file
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

#include <model/models/meteo/Meteo.hpp>

#include <utils/Connections.hpp>
#include <utils/DateTime.hpp>

namespace meteo {

Model::Model()
{
}

void Model::compute(double /* t */, bool /* update */)
{
    if (it == values.end()) {
        it = values.begin();
    } else {
        ++it;
    }
}

void Model::init(double /* t */,
                 const model::models::ModelParameters& parameters)
{
    pqxx::connection& connection(
        utils::Connections::connection(
            "ecomeristem",
            "dbname=ecomeristem user=user_samara password=toto"));
    std::string beginDate;
    std::string endDate;
    double begin;
    double end;
    unsigned int beginYear;
    unsigned int endYear;

    utils::DateTime::format_date(parameters.get < std::string >("BeginDate"),
                                 beginDate);
    utils::DateTime::format_date(parameters.get < std::string >("EndDate"),
                                 endDate);
    begin = utils::DateTime::toJulianDayNumber(beginDate);
    end = utils::DateTime::toJulianDayNumber(endDate);
    beginYear = utils::DateTime::year(begin);
    endYear = utils::DateTime::year(end);
    try {
        pqxx::work action(connection);
        for (unsigned int year = beginYear; year <= endYear; year++) {
            std::string request =
                (boost::format("SELECT * FROM \"meteorology\" "         \
                               "WHERE \"day\" like \'%%%1%%%\' order by " \
                               "\"day\" asc") % year).str();
            pqxx::result result = action.exec(request);

            if (not result.empty()) {
                for (pqxx::result::const_iterator it = result.begin();
                     it != result.end(); ++it) {
                    std::string day;
                    double t;

                    utils::DateTime::format_date(
                        boost::lexical_cast < std::string >(it->at(0)), day);
                    t = utils::DateTime::toJulianDayNumber(day);
                    if (t >= begin and t <= end) {
                        values.push_back(
                            Climate(
                                boost::lexical_cast < double >(it->at(1)),
                                boost::lexical_cast < double >(it->at(2)),
                                boost::lexical_cast < double >(it->at(3)),
                                boost::lexical_cast < double >(it->at(4)),
                                boost::lexical_cast < double >(it->at(5))));
                    }
                }
            }
        }
    } catch (pqxx::sql_error e) {
        std::cout << "Error: " << e.query() << std::endl;
    }
    it = values.end();
}

}
