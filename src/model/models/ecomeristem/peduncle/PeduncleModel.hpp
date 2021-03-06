/**
 * @file ecomeristem/peduncle/Model.hpp
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

#include <model/models/ModelParameters.hpp>

namespace ecomeristem { namespace peduncle {

class PeduncleModel
{
public:
    PeduncleModel()
    { }

    virtual ~PeduncleModel()
    { }

    void init(double /* t */,
              const model::models::ModelParameters& /* parameters */)
    {
    }

    void compute(double /* t */, bool /* update */)
    {
    }

private:
};

} } // namespace ecomeristem peduncle
