/**
 * @file leaf/TimeFromApp.hpp
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

#ifndef __ECOMERISTEM_LEAF_TIME_FROM_APP_HPP
#define __ECOMERISTEM_LEAF_TIME_FROM_APP_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <model/models/ecomeristem/leaf/LeafManager.hpp>

namespace ecomeristem { namespace leaf {

class LeafTimeFromApp : public ecomeristem::AbstractAtomicModel < LeafTimeFromApp >
{
public:
    enum internals { TIME_FROM_APP };
    enum externals { DD, DELTA_T, PHASE };

    LeafTimeFromApp()
    {
        internal(TIME_FROM_APP, &LeafTimeFromApp::_time_from_app);
        external(DD, &LeafTimeFromApp::_dd);
        external(DELTA_T, &LeafTimeFromApp::_delta_t);
        external(PHASE, &LeafTimeFromApp::_phase);
    }

    virtual ~LeafTimeFromApp()
    { }

    void compute(double t, bool /* update */)
    {
        if (_first_day == t) {
            _time_from_app = _dd;
        } else {
            if (_phase != leaf::NOGROWTH) {
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

} } // namespace ecomeristem leaf

#endif
