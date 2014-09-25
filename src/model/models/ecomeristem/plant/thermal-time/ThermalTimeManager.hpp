/**
 * @file thermal-time/ThermalTimeManager.hpp
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

#ifndef __ECOMERISTEM_PLANT_THERMAL_TIME_THERMAL_TIME_MANAGER_HPP
#define __ECOMERISTEM_PLANT_THERMAL_TIME_THERMAL_TIME_MANAGER_HPP

#include <model/kernel/AbstractAtomicModel.hpp>

namespace ecomeristem { namespace plant { namespace thermal_time {

class ThermalTimeManager : public AbstractAtomicModel < ThermalTimeManager >
{
public:
    enum state_t { INIT, DEAD, STOCK_AVAILABLE, NO_STOCK };

    static const unsigned int PHASE = 0;
    static const unsigned int STOCK = 0;

    ThermalTimeManager()
    {
        internal(PHASE, &ThermalTimeManager::_state);
        external(STOCK, &ThermalTimeManager::_stock);
    }

    virtual ~ThermalTimeManager()
    { }

    void compute(double /* t */)
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
    }

    void init(double t,
              const model::models::ModelParameters& /* parameters */)
    {
        _state = INIT;
        compute(t);
    }

    void put(double t, unsigned int index, double value)
    {
        AbstractAtomicModel < ThermalTimeManager >::put(t, index, value);
        compute(t);
    }

private:
// internal variable
    double _state;

// external variables
    double _stock;
};

} } } // namespace ecomeristem plant thermal_time

#endif
