/**
 * @file leaf/Biomass.hpp
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

#ifndef __ECOMERISTEM_LEAF_BIOMASS_HPP
#define __ECOMERISTEM_LEAF_BIOMASS_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <model/models/ecomeristem/plant/Manager.hpp>

namespace ecomeristem { namespace leaf {

class Biomass : public AbstractAtomicModel < Biomass >
{
public:
    enum internals { BIOMASS };
    enum externals { BLADE_AREA, SLA, GROW, PHASE };

    Biomass()
    {
        internal(BIOMASS, &Biomass::_biomass);
        external(BLADE_AREA, &Biomass::_blade_area);
        external(SLA, &Biomass::_sla);
        external(GROW, &Biomass::_grow);
        external(PHASE, &Biomass::_phase);
    }

    virtual ~Biomass()
    { }

    void compute(double t, bool /* update */)
    {
        if (_first_day == t) {
            _biomass = (1. / _G_L) * _blade_area / _sla;

            // std::cout << "BIOMASS: " << _biomass << " " << _G_L << " "
            //           << _blade_area << " " << _sla << std::endl;

        } else {
            if (!_lig and _phase != plant::NOGROWTH) {
                _lig = _phase == plant::LIG;
                _biomass = (1. / _G_L) * _blade_area / _sla;
            }
        }
    }

    void init(double t,
              const model::models::ModelParameters& parameters)
    {
        _G_L = parameters.get < double >("G_L");
        _first_day = t;
        _lig = false;
        _biomass = 0;
    }

private:
// parameters
    double _G_L;

// internal variable
    double _biomass;
    double _first_day;
    bool _lig;

// external variables
    double _blade_area;
    double _sla;
    double _grow;
    double _phase;
};

} } // namespace ecomeristem leaf

#endif
