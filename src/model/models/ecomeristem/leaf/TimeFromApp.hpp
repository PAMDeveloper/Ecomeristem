/**
 * @file leaf/TimeFromApp.hpp
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

#ifndef __ECOMERISTEM_LEAF_TIME_FROM_APP_HPP
#define __ECOMERISTEM_LEAF_TIME_FROM_APP_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <model/models/ecomeristem/plant/Manager.hpp>

namespace ecomeristem { namespace leaf {

class TimeFromApp : public AbstractAtomicModel < TimeFromApp >
{
public:
    enum internals { TIME_FROM_APP };
    enum externals { DD, DELTA_T, PHASE };

    TimeFromApp()
    {
        internal(TIME_FROM_APP, &TimeFromApp::_time_from_app);
        external(DD, &TimeFromApp::_dd);
        external(DELTA_T, &TimeFromApp::_delta_t);
        external(PHASE, &TimeFromApp::_phase);
    }

    virtual ~TimeFromApp()
    { }

    void compute(double /* t */)
    {
        if (_is_first_step) {
            _time_from_app = _dd;
            _is_first_step = false;
        } else {
            if (_phase != plant::NOGROWTH) {
                _time_from_app = _time_from_app + _delta_t;
            } else {
            }
        }
    }

    void init(double /* t */,
              const model::models::ModelParameters& /* parameters */)
    {
        _is_first_step = true;
        _time_from_app = 0;
    }

private:
// internal variable
    double _time_from_app;
    bool _is_first_step;

// external variables
    double _dd;
    double _delta_t;
    double _phase;
};

} } // namespace ecomeristem leaf

#endif
