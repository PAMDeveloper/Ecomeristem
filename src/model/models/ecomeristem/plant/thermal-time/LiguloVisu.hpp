/**
 * @file thermal-time/LiguloVisu.hpp
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

#ifndef __ECOMERISTEM_PLANT_THERMAL_TIME_LIGULO_VISU_HPP
#define __ECOMERISTEM_PLANT_THERMAL_TIME_LIGULO_VISU_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <model/models/ecomeristem/plant/thermal-time/ThermalTimeManager.hpp>

namespace ecomeristem { namespace plant { namespace thermal_time {

class LiguloVisu : public ecomeristem::AbstractAtomicModel < LiguloVisu >
{
public:
    static const unsigned int LIGULO_VISU = 0;
    static const unsigned int PLASTO_DELAY = 0;
    static const unsigned int EDD = 1;
    static const unsigned int PHASE = 2;

    LiguloVisu()
    {
        internal(LIGULO_VISU, &LiguloVisu::_LiguloVisu);
        external(PLASTO_DELAY, &LiguloVisu::_plasto_delay);
        external(EDD, &LiguloVisu::_EDD);
        external(PHASE, &LiguloVisu::_phase);
    }

    virtual ~LiguloVisu()
    { }

    void compute(double t, bool update)
    {
        if (not update) {
            if (_phase == ThermalTimeManager::STOCK_AVAILABLE) {
                _LiguloVisu = _LiguloVisu - _plasto_delay;
            } else {
                _LiguloVisu = _LiguloVisu + _EDD;
            }
        }

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("LIGULO_VISU", t, artis::utils::COMPUTE)
            << "LIGULO_VISU = " << _LiguloVisu
            << " ; plasto_delay = " << _plasto_delay
            << " ; EDD = " << _EDD;
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */,
              const model::models::ModelParameters& parameters)
    {
        _coef_ligulo = parameters.get < double >("coef_ligulo1");
        _plasto = parameters.get < double >("plasto_init");
        _ligulo = _plasto * _coef_ligulo;
        _LiguloVisu = _ligulo;
    }

private:
// parameters
    double _coef_ligulo;
    double _plasto;

// internal variable
    double _LiguloVisu;
    double _ligulo;

// external variables
    double _plasto_delay;
    double _EDD;
    double _phase;
};

} } } // namespace ecomeristem plant thermal_time

#endif
