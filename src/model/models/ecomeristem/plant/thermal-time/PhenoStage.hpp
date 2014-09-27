/**
 * @file thermal-time/PhenoStage.hpp
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

#ifndef __ECOMERISTEM_PLANT_THERMAL_TIME_PHENO_STAGE_HPP
#define __ECOMERISTEM_PLANT_THERMAL_TIME_PHENO_STAGE_HPP

#include <model/kernel/AbstractAtomicModel.hpp>

namespace ecomeristem { namespace plant { namespace thermal_time {

class PhenoStage : public AbstractAtomicModel < PhenoStage >
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

    void compute(double /* t */, bool /* update */)
    {
        if (_phase == ThermalTimeManager::STOCK_AVAILABLE) {
            if (_boolCrossedPlasto >= 0) {
                _PhenoStage = _PhenoStage + 1;
            }
        }
    }

    void init(double /* t */,
              const model::models::ModelParameters& /* parameters */)
    {
        _PhenoStage = 1;
    }

private:
// internal variable
    double _PhenoStage;

// external variables
    double _boolCrossedPlasto;
    double _phase;
};

} } } // namespace ecomeristem plant thermal_time

#endif
