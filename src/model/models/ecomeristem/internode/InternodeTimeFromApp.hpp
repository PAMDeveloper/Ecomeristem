/**
 * @file internode/TimeFromApp.hpp
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

#ifndef __ECOMERISTEM_INTERNODE_TIME_FROM_APP_HPP
#define __ECOMERISTEM_INTERNODE_TIME_FROM_APP_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <model/models/ecomeristem/internode/Manager.hpp>

namespace ecomeristem { namespace internode {

class InternodeTimeFromApp : public ecomeristem::AbstractAtomicModel < InternodeTimeFromApp >
{
public:
    enum internals { TIME_FROM_APP };
    enum externals { DD, DELTA_T, PHASE };

    InternodeTimeFromApp()
    {
        internal(TIME_FROM_APP, &InternodeTimeFromApp::_time_from_app);

        external(DD, &InternodeTimeFromApp::_dd);
        external(DELTA_T, &InternodeTimeFromApp::_delta_t);
        external(PHASE, &InternodeTimeFromApp::_phase);
    }

    virtual ~InternodeTimeFromApp()
    { }

    void compute(double t, bool /* update */)
    {
        if (_first_day == t) {
            _time_from_app = _dd;
        } else {
            if (_phase != internode::REALIZATION_NOGROWTH) {
                _time_from_app = _time_from_app + _delta_t;
            } else {
            }
        }
    }

    void init(double t,
              const model::models::ModelParameters& /* parameters */)
    {
        _first_day = t;
        _time_from_app = 0;
    }

private:
// internal variable
    double _time_from_app;
    double _first_day;

// external variables
    double _dd;
    double _delta_t;
    double _phase;
};

} } // namespace ecomeristem internode

#endif
