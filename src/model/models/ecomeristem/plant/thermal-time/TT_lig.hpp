/**
 * @file thermal-time/TT_lig.hpp
 * @author The Ecomeristem Development Team
 * See the AUTHORS or Authors.txt file
 */

/*
 * Copyright (C) 2005-2014 INRA http://www.cirad.fr
 * Copyright (C) 2014 ULCO http://www.univ-littoral.fr
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

#ifndef __ECOMERISTEM_PLANT_THERMAL_TIME_TT_LIG_HPP
#define __ECOMERISTEM_PLANT_THERMAL_TIME_TT_LIG_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <model/models/ecomeristem/plant/thermal-time/ThermalTimeManager.hpp>

namespace ecomeristem { namespace plant { namespace thermal_time {

class TT_lig : public AbstractAtomicModel < TT_lig >
{
public:
    static const unsigned int TT_LIG = 0;
    static const unsigned int EDD = 0;
    static const unsigned int PHASE = 1;

    TT_lig()
    {
        internal(TT_LIG, &TT_lig::_TT_lig);
        external(EDD, &TT_lig::_EDD);
        external(PHASE, &TT_lig::_phase);
    }

    virtual ~TT_lig()
    { }

    void compute(double /* t */)
    {
        if (_phase == ThermalTimeManager::STOCK_AVAILABLE) {
            _TT_lig = _TT_lig + _EDD;
        }
    }

    void init(double /* t */,
              const model::models::ModelParameters& /* parameters */)
    {
        _TT_lig = 0;
    }

private:
// internal variable
    double _TT_lig;

// external variables
    double _EDD;
    double _phase;
};

} } } // namespace ecomeristem plant thermal_time

#endif
