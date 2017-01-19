/**
 * @file thermal-time/DD.hpp
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

#ifndef __ECOMERISTEM_PLANT_THERMAL_TIME_DD_HPP
#define __ECOMERISTEM_PLANT_THERMAL_TIME_DD_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <model/models/ecomeristem/plant/thermal-time/ThermalTimeManager.hpp>

#include <utils/Trace.hpp>

namespace ecomeristem { namespace plant { namespace thermal_time {

class Dd : public ecomeristem::AbstractAtomicModel < Dd >
{
public:
    enum internals { DD, EDD, BOOL_CROSSED_PLASTO };
    enum externals { DELTA_T, PLASTO_DELAY, PHASE, GROW };

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

    void compute(double t, bool update)
    {
        if (not update) {
            _stop = false;
            _DD_1 = _DD;
            _EDD_1 = _EDD;
        }
        if (not _stop) {
            if (/*(_phase == ThermalTimeManager::NO_STOCK and
                  _phase_1 == ThermalTimeManager::STOCK_AVAILABLE) or */
                _phase == ThermalTimeManager::STOCK_AVAILABLE or _grow) {
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
                // _stop = _phase_1 == ThermalTimeManager::NO_STOCK and
                //     _phase == ThermalTimeManager::STOCK_AVAILABLE;
            } else {
                _DD = _DD_1;
                _EDD = _EDD_1;
            }
        }

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("DD", t, artis::utils::COMPUTE)
            << "DD = " << _DD
            << " ; EDD = " << _EDD
            << " ; DD[-1] = " << _DD_1
            << " ; EDD[-1] = " << _EDD_1
            << " ; DeltaT = " << _DeltaT
            << " ; PlastoDelay = " << _PlastoDelay
            << " ; PlastoDelay[-1] = " << _PlastoDelay_1
            << " ; BoolCrossedPlasto = " << _BoolCrossedPlasto
            << " ; stop = " << _stop
            << " ; phase = " << _phase
            << " ; phase[-1] = " << _phase_1
            << " ; plasto = " << _plasto;
        utils::Trace::trace().flush();
#endif

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
        _phase = ThermalTimeManager::INIT;
        _phase_1 = ThermalTimeManager::INIT;
    }

    virtual void put(double t, unsigned int index, double value)
    {
        if (index == PLASTO_DELAY and !is_ready(t, PLASTO_DELAY)) {
            _PlastoDelay_1 = _PlastoDelay;
        }
        if (index == PHASE and !is_ready(t, PHASE)) {
            _phase_1 = _phase;
        }
        ecomeristem::AbstractAtomicModel < Dd >::put(t, index, value);
    }

private:
    // parameters
    double _plasto;

    // external variables
    double _DeltaT;
    double _PlastoDelay;
    double _PlastoDelay_1;
    double _phase;
    double _phase_1;
    double _grow;

    // internal variable
    double _DD;
    double _DD_1;
    double _EDD;
    double _EDD_1;
    double _BoolCrossedPlasto;
    double _stop;
};

} } } // namespace ecomeristem plant thermal_time

#endif
