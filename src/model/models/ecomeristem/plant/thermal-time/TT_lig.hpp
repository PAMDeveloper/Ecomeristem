/**
 * @file thermal-time/TT_lig.hpp
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

#ifndef __ECOMERISTEM_PLANT_THERMAL_TIME_TT_LIG_HPP
#define __ECOMERISTEM_PLANT_THERMAL_TIME_TT_LIG_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <model/models/ecomeristem/plant/thermal-time/ThermalTimeManager.hpp>

namespace ecomeristem { namespace plant { namespace thermal_time {

class TT_lig : public ecomeristem::AbstractAtomicModel < TT_lig >
{
public:
    static const unsigned int TT_LIG = 0;
    static const unsigned int EDD = 0;
    static const unsigned int PHASE = 1;
    static const unsigned int LIG = 2;

    TT_lig()
    {
        internal(TT_LIG, &TT_lig::_TT_lig);
        external(EDD, &TT_lig::_EDD);
        external(PHASE, &TT_lig::_phase);
        external(LIG, &TT_lig::_lig);
    }

    virtual ~TT_lig()
    { }

    void compute(double t, bool update)
    {
        if (not update) {
            _no_grow = false;
        }
        if (not _no_grow) {
            if (not update) {
                _TT_lig_1 = _TT_lig;
                _no_grow = false;
            }
            if (_isFirstStep) {
                _isFirstStep = false;
            } else {
                if (_lig_1 == _lig) {
                    if (_phase == ThermalTimeManager::STOCK_AVAILABLE) {
                        _TT_lig = _TT_lig_1 + _EDD;
                    } else {
                        _no_grow = true;
                    }
                } else {
                    _TT_lig = 0;
                }
            }
        }


 #ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("TT_lig", t, artis::utils::COMPUTE)
            << "TT_lig = " << _TT_lig
            << " ; TT_lig[-1] = " << _TT_lig_1
            << " ; phase = " << _phase
            << " ; lig = " << _lig
            << " ; lig[-1] = " << _lig_1
            << " ; EDD = " << _EDD;
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */,
              const model::models::ModelParameters& /* parameters */)
    {
        _TT_lig = 0;
        _isFirstStep = true;
        _lig_1 = 0;
        _no_grow = false;
    }

    void put(double t, unsigned int index, double value)
    {
        if (index == LIG and !is_ready(t, LIG)) {
            _lig_1 = _lig;
        }
        ecomeristem::AbstractAtomicModel < TT_lig >::put(t, index, value);
    }

private:
// internal variable
    double _TT_lig;
    double _TT_lig_1;
    bool _isFirstStep;
    bool _no_grow;

// external variables
    double _EDD;
    double _phase;
    double _lig;
    double _lig_1;
};

} } } // namespace ecomeristem plant thermal_time

#endif
