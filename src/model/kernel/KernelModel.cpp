/**
 * @file model/kernel/Model.hpp
 * @author The Ecomeristem Development Team
 * See the AUTHORS file
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

#include <model/kernel/KernelModel.hpp>

namespace model { namespace kernel {

void KernelModel::compute(double t, bool /* update */)
{
    meteo_model(t);

    ecomeristem_model.put < double >(t, ecomeristem::EcomeristemModel::ETP, meteo_model.get().Etp);
    ecomeristem_model.put < double >(t, ecomeristem::EcomeristemModel::P, meteo_model.get().P);
    ecomeristem_model.put < double >(t, ecomeristem::EcomeristemModel::RADIATION,
                          meteo_model.get().Par);
    ecomeristem_model.put < double >(t, ecomeristem::EcomeristemModel::WATER_SUPPLY,
                          meteo_model.get().Irrigation);
    ecomeristem_model.put < double >(t, ecomeristem::EcomeristemModel::TA,
                          meteo_model.get().Temperature);
    ecomeristem_model(t);
}

} }
