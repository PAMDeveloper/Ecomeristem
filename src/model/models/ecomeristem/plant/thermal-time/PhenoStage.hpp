/**
 * @file thermal-time/PhenoStage.hpp
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

#ifndef __ECOMERISTEM_PLANT_THERMAL_TIME_PHENO_STAGE_HPP
#define __ECOMERISTEM_PLANT_THERMAL_TIME_PHENO_STAGE_HPP

#include <model/kernel/AbstractAtomicModel.hpp>

namespace ecomeristem { namespace plant { namespace thermal_time {

class PhenoStage : public ecomeristem::AbstractAtomicModel < PhenoStage >
{
public:
    static const unsigned int PHENO_STAGE = 0;
    static const unsigned int BOOL_CROSSED_PLASTO = 0;
    static const unsigned int PHASE = 1;

    PhenoStage()
    {
        internal(PHENO_STAGE, &PhenoStage::_PhenoStage);
        external(BOOL_CROSSED_PLASTO, &PhenoStage::_boolCrossedPlasto);
        external(PHASE, &PhenoStage::_phase);
    }

    virtual ~PhenoStage()
    { }

    void compute(double t, bool update)
    {
        if (update) {
            _PhenoStage = _PhenoStage_1;
        } else {
            _PhenoStage_1 = _PhenoStage;
        }
        if (_phase == ThermalTimeManager::STOCK_AVAILABLE) {
            if (_boolCrossedPlasto >= 0) {
                _PhenoStage = _PhenoStage + 1;
            }
        }

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("PHENO_STAGE", t, artis::utils::COMPUTE)
            << "phenoStage = " << _PhenoStage
            << " ; phase = " << _phase
            << " ; phase[-1] = " << _phase_1
            << " ; boolCrossedPlasto = " << _boolCrossedPlasto;
        utils::Trace::trace().flush();
#endif
    }

    void init(double t,
              const model::models::ModelParameters& /* parameters */)
    {
        _PhenoStage = 1;
        _PhenoStage_1 = 1;
        _begin = t;
    }

    void put(double t, unsigned int index, double value)
    {
        if (index == PHASE and !is_ready(t, PHASE)) {
            _phase_1 = _phase;
        }

        ecomeristem::AbstractAtomicModel < PhenoStage >::put(t, index, value);
    }

private:
// internal variable
    double _PhenoStage;
    double _PhenoStage_1;
    double _begin;

// external variables
    double _boolCrossedPlasto;
    double _phase;
    double _phase_1;
};

} } } // namespace ecomeristem plant thermal_time

#endif
