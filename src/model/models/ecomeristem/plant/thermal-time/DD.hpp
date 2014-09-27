/**
 * @file thermal-time/DD.hpp
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

#ifndef __ECOMERISTEM_PLANT_THERMAL_TIME_DD_HPP
#define __ECOMERISTEM_PLANT_THERMAL_TIME_DD_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <model/models/ecomeristem/plant/thermal-time/ThermalTimeManager.hpp>

namespace ecomeristem { namespace plant { namespace thermal_time {

class Dd : public AbstractAtomicModel < Dd >
{
public:
    static const unsigned int DD = 0;
    static const unsigned int EDD = 1;
    static const unsigned int BOOL_CROSSED_PLASTO = 2;

    static const unsigned int DELTA_T = 0;
    static const unsigned int PLASTO_DELAY = 1;
    static const unsigned int PHASE = 2;
    static const unsigned int GROW = 3;

    Dd()
    {
        internal(DD, &Dd::_DD);
        internal(EDD, &Dd::_EDD);
        internal(BOOL_CROSSED_PLASTO, &Dd::_BoolCrossedPlasto);

        external(DELTA_T, &Dd::_DeltaT);
        external(PLASTO_DELAY, &Dd::_PlastoDelay);
        external(PHASE, &Dd::_phase);
        external(GROW, &Dd::_grow);
    }

    virtual ~Dd()
    { }

    bool check(double t) const
    { return is_ready(t, DELTA_T) and is_ready(t, PLASTO_DELAY) and
            is_ready(t, PHASE) and is_ready(t, GROW); }

    void compute(double t, bool /* update */)
    {
        if (_last_time != t) {
            _DD_1 = _DD;
            _EDD_1 = _EDD;
            _last_time = t;
        }

        if (_phase == ThermalTimeManager::STOCK_AVAILABLE or _grow) {
            double tempDD = _DD_1 + _DeltaT + _PlastoDelay_1;

            _BoolCrossedPlasto = tempDD - _plasto;
            if (_BoolCrossedPlasto >= 0) {
                _DD = tempDD - _plasto;
            } else {
                _DD = tempDD;
            }
            if (_BoolCrossedPlasto <= 0) {
                _EDD = _DeltaT + _PlastoDelay_1;
            } else {
                _EDD = _plasto - _DD_1;
            }

            std::cout << "DD: " << _DD << " " << _BoolCrossedPlasto
                      << " " << _plasto << " " << tempDD << " "
                      << _DeltaT << " " << _PlastoDelay_1 << std::endl;

       } else {
           _DD = _DD_1;
           _EDD = _EDD_1;
       }
    }

    void init(double /* t */,
              const model::models::ModelParameters& parameters)
    {
        _plasto = parameters.get < double >("plasto_init");
        _DD_1 = 0;
        _DD = 0;
        _EDD_1 = 0;
        _EDD = 0;
        _BoolCrossedPlasto = 0;
        _PlastoDelay_1 = 0;
        _PlastoDelay = 0;
        _last_time = -1;
    }

    virtual void put(double t, unsigned int index, double value)
    {
        if (index == PLASTO_DELAY and !is_ready(t, PLASTO_DELAY)) {
            _PlastoDelay_1 = _PlastoDelay;
        }
        AbstractAtomicModel < Dd >::put(t, index, value);
    }

private:
    // parameters
    double _plasto;

    // external variables
    double _DeltaT;
    double _PlastoDelay;
    double _PlastoDelay_1;
    double _phase;
    double _grow;

    // internal variable
    double _DD;
    double _DD_1;
    double _EDD;
    double _EDD_1;
    double _BoolCrossedPlasto;
    double _last_time;
};

} } } // namespace ecomeristem plant thermal_time

#endif
