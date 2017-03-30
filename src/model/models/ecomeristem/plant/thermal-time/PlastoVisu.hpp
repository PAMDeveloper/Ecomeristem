/**
 * @file thermal_time/PlastoVisu.hpp
 * @author The Ecomeristem Development Team
 * See the AUTHORS or Authors.txt file
 */

/*
 * Copyright (C) 2005-2017 Cirad http://www.cirad.fr
 * Copyright (C) 2012-2017 ULCO http://www.univ-littoral.fr
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

#ifndef __ECOMERISTEM_PLANT_THERMAL_TIME_PLASTO_VISU_HPP
#define __ECOMERISTEM_PLANT_THERMAL_TIME_PLASTO_VISU_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <model/models/ecomeristem/plant/thermal-time/ThermalTimeManager.hpp>

namespace ecomeristem { namespace plant { namespace thermal_time {

class PlastoVisu : public ecomeristem::AbstractAtomicModel < PlastoVisu >
{
public:
    static const unsigned int PLASTO_VISU = 0;
    static const unsigned int PLASTO_DELAY = 0;
    static const unsigned int EDD = 1;
    static const unsigned int PHASE = 2;

    PlastoVisu()
    {
        internal(PLASTO_VISU, &PlastoVisu::_PlastoVisu);
        external(PLASTO_DELAY, &PlastoVisu::_plasto_delay);
        external(EDD, &PlastoVisu::_EDD);
        external(PHASE, &PlastoVisu::_phase);
    }

    virtual ~PlastoVisu()
    { }

    void compute(double t, bool update)
    {
        if (not update) {
            if (_phase == ThermalTimeManager::STOCK_AVAILABLE) {
                _PlastoVisu = _PlastoVisu - _plasto_delay;
            } else {
                _PlastoVisu = _PlastoVisu + _EDD;
            }
        }

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("PLASTO_VISU", t, artis::utils::COMPUTE)
            << "PLASTO_VISU = " << _PlastoVisu
            << " ; plasto_delay = " << _plasto_delay
            << " ; EDD = " << _EDD;
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */,
              const model::models::ModelParameters& parameters)
    {
        _plasto = parameters.get < double >("plasto_init");
        _PlastoVisu = _plasto;
    }

private:
// parameters
    double _plasto;

// internal variable
    double _PlastoVisu;

// external variables
    double _plasto_delay;
    double _EDD;
    double _phase;
};

} } } // namespace ecomeristem plant thermal_time

#endif
