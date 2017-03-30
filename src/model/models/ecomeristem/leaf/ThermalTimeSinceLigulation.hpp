/**
 * @file leaf/ThermalTimeSinceLigulation.hpp
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

#ifndef __ECOMERISTEM_LEAF_THERMAL_TIME_SINCE_LIGULATION_HPP
#define __ECOMERISTEM_LEAF_THERMAL_TIME_SINCE_LIGULATION_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace leaf {

class ThermalTimeSinceLigulation :
        public ecomeristem::AbstractAtomicModel < ThermalTimeSinceLigulation >
{
public:
    enum internals { THERMAL_TIME_SINCE_LIGULATION };
    enum externals { DELTA_T, PHASE };

    ThermalTimeSinceLigulation(int index) : _index(index)
    {
        internal(THERMAL_TIME_SINCE_LIGULATION,
                 &ThermalTimeSinceLigulation::_TT);
        external(DELTA_T,
                 &ThermalTimeSinceLigulation::_delta_t);
        external(PHASE,
                 &ThermalTimeSinceLigulation::_phase);
    }

    virtual ~ThermalTimeSinceLigulation()
    { }

    bool check(double t) const
    { return is_ready(t, DELTA_T) and is_ready(t, PHASE); }

    void compute(double t , bool update)
    {
        if (update) {
            _lig = _lig_1;
            _TT_1 = _TT;
        } else {
            _lig_1 = _lig;
            _TT_1 = _TT;
        }
        if (not _lig) {
            _lig = _phase == leaf::LIG;
        } else {
            _TT += _delta_t;
        }

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("THERMAL_TIME_SINCE_LIGUALTION", t,
                                   artis::utils::COMPUTE)
            << "TT = " << _TT
            << " ; delta_t = " << _delta_t
            << " ; index = " << _index;
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */,
              const model::models::ModelParameters& /* parameters */)
    {
        _TT = 0;
        _TT_1 = 0;
        _phase = leaf::INITIAL;
        _lig = false;
        _lig_1 = false;
    }

private:
// internal variable
    double _TT;
    double _TT_1;
    double _lig;
    double _lig_1;
    int _index;

// external variables
    double _delta_t;
    double _phase;
};

} } // namespace ecomeristem leaf

#endif
