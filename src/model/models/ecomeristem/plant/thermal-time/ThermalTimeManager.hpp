/**
 * @file thermal-time/ThermalTimeManager.hpp
 * @author The Ecomeristem Development Team
 * See the AUTHORS or Authors.txt file
 */

/*
 * Copyright (C) 2005-2015 Cirad http://www.cirad.fr
 * Copyright (C) 2012-2015 ULCO http://www.univ-littoral.fr
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

#ifndef __ECOMERISTEM_PLANT_THERMAL_TIME_THERMAL_TIME_MANAGER_HPP
#define __ECOMERISTEM_PLANT_THERMAL_TIME_THERMAL_TIME_MANAGER_HPP

#include <model/kernel/AbstractAtomicModel.hpp>

#include <model/models/ecomeristem/plant/Manager.hpp>

namespace ecomeristem { namespace plant { namespace thermal_time {

class ThermalTimeManager : public AbstractAtomicModel < ThermalTimeManager >
{
public:
    enum state_t { INIT, DEAD, STOCK_AVAILABLE, NO_STOCK };

    enum internals { STATE };
    enum externals { STOCK, PHASE };

    ThermalTimeManager()
    {
        internal(STATE, &ThermalTimeManager::_state);

        external(STOCK, &ThermalTimeManager::_stock);
        external(PHASE, &ThermalTimeManager::_phase);
    }

    virtual ~ThermalTimeManager()
    { }

    void compute(double t, bool /* update */)
    {
        state_t old_state;

        do {
            old_state = (state_t)_state;

            switch ((state_t)_state) {
            case INIT: {
                _state = STOCK_AVAILABLE;
                break;
            }
            case DEAD: {
                break;
            }
            case STOCK_AVAILABLE: {
                if (_stock <= 0){
                    _state = NO_STOCK;
                }
                break;
            }
            case NO_STOCK: {
                if (_stock > 0){
                    _state = STOCK_AVAILABLE;
                }
                // TODO: => dead
                break;
            }
            };
        } while (old_state != _state);

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("THERMAL_TIME_MANAGER", t, utils::COMPUTE)
            << "phase = " << _phase
            << " ; state = " << _state
            << " ; stock = " << _stock;
        utils::Trace::trace().flush();
#endif
    }

    void init(double t,
              const model::models::ModelParameters& /* parameters */)
    {
        _state = INIT;
        // TODO: why ?
        _stock = 1e-10;
        _phase = plant::INIT;
        _phase_1 = plant::INIT;
        _begin = t;
    }

    void put(double t, unsigned int index, double value)
    {
        if (index == PHASE and !is_ready(t, PHASE)) {
            _phase_1 = _phase;
        }

        AbstractAtomicModel < ThermalTimeManager >::put(t, index, value);
        (*this)(t);
    }

private:
// internal variable
    double _state;
    double _begin;

// external variables
    double _stock;
    double _phase;
    double _phase_1;
};

} } } // namespace ecomeristem plant thermal_time

#endif
