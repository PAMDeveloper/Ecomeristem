/**
 * @file ecomeristem/culm/Supply.hpp
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

#ifndef __ECOMERISTEM_CULM_SUPPLY_HPP
#define __ECOMERISTEM_CULM_SUPPLY_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace culm {

class Supply : public AbstractAtomicModel < Supply >
{
public:
    enum internals { SUPPLY };
    enum externals { ASSIM, BLADE_AREA_SUM, PLANT_BLADE_AREA };

    Supply()
    {
        internal(SUPPLY, &Supply::_supply);

        external(ASSIM, &Supply::_assim);
        external(BLADE_AREA_SUM, &Supply::_blade_area_sum);
        external(PLANT_BLADE_AREA, &Supply::_plant_blade_area);
    }

    virtual ~Supply()
    { }

    void compute(double t, bool /* update */)
    {
        _supply = _assim * _blade_area_sum / _plant_blade_area;

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("CULM_SUPPLY", t, utils::COMPUTE)
            << "Supply = " << _supply
            << " ; Assim = " << _assim
            << " ; BladeAreaSum = " << _blade_area_sum
            << " ; PlantBladeArea = " << _plant_blade_area;
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */,
              const model::models::ModelParameters& /* parameters */)
    {
        _supply = _assim * _blade_area_sum / _plant_blade_area;
    }

private:
// internal variables
    double _supply;

// external variables
    double _assim;
    double _blade_area_sum;
    double _plant_blade_area;
};

} } // namespace ecomeristem culm

#endif