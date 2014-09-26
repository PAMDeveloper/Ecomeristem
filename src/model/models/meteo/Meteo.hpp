/**
 * @file model/models/meteo/Meteo.hpp
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

#ifndef MODEL_MODELS_METEO_METEO_HPP
#define MODEL_MODELS_METEO_METEO_HPP

#include <model/models/ModelParameters.hpp>

namespace meteo {

struct Climate
{
    double Temperature;
    double Par;
    double Etp;
    double Irrigation;
    double P;

    Climate(double Temperature, double Par, double Etp, double Irrigation,
        double P) :
        Temperature(Temperature), Par(Par), Etp(Etp), Irrigation(Irrigation),
        P(P)
    { }
};

class Model
{
public:
    Model();

    virtual ~Model()
    { }

    void compute(double t);

    const Climate& get() const
    { return *it; }

    void init(double t, const model::models::ModelParameters& parameters);

private:
    double begin;
    double end;

    std::vector < Climate > values;
    std::vector < Climate >::const_iterator it;
};

} // namespace meteo

#endif
