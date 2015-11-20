/**
 * @file ecomeristem/plant/Manager.cpp
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

#include <model/models/ecomeristem/plant/Manager.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace plant {

bool Manager::check(double t) const
{
    // TODO
    return true;
}

// INIT ---------------------------------------------------------> INITIAL
// INITIAL ------------------ c1/output4 ----------> PHYTOMER_MORPHO_GENESIS
// INITIAL ------------------ c2 --------------------------------> NOGROWTH

// PHYTOMER_MORPHO_GENESIS -- c6/output3 ------------------------> DEAD

// PHYTOMER_MORPHO_GENESIS -- c3 --------------------------------> NOGROWTH2
// NOGROWTH2 ---------------- output5 ---------------------------> NOGROWTH3
// NOGROWTH3 ---------------- after(1)/dec_leaf_number/output2 --> NOGROWTH4
// NOGROWTH4 ---------------- c6/output3 ------------------------> DEAD
// NOGROWTH4 ---------------- stock/action1 ---------------------> NOGROWTH5
// NOGROWTH5 ---------------- c5 --------------------------------> NOGROWTH
// NOGROWTH5 ---------------- c3 --------------------------------> NOGROWTH2
// NOGROWTH ----------------- c5/output4 ----------> PHYTOMER_MORPHO_GENESIS
// NOGROWTH ----------------- c6/output3 ------------------------> DEAD

// PHYTOMER_MORPHO_GENESIS -- c4/inc_leaf_number/output1 -----> NEW_PHYTOMER
// NEW_PHYTOMER ------------- phenoStage/action2 ------------> NEW_PHYTOMER2
// NEW_PHYTOMER2 ------------ c8/output6 ------------------------> ELONG
// NEW_PHYTOMER2 ------------ c9 ----------------------------> NEW_PHYTOMER3
// NEW_PHYTOMER3 ------------ c7/output4 ----------> PHYTOMER_MORPHO_GENESIS
// NEW_PHYTOMER3 ------------ c3 -------------------> NEW_PHYTOMER_NOGROWTH2
// NEW_PHYTOMER_NOGROWTH2 --- output5 --------------> NEW_PHYTOMER_NOGROWTH3
// NEW_PHYTOMER_NOGROWTH3 --- after(1)/dec_leaf_number/output2
//                                               ---> NEW_PHYTOMER_NOGROWTH3
// NEW_PHYTOMER_NOGROWTH4 --- c7/output4 ----------> PHYTOMER_MORPHO_GENESIS
// NEW_PHYTOMER_NOGROWTH4 --- c3 -------------------> NEW_PHYTOMER_NOGROWTH2
// NEW_PHYTOMER_NOGROWTH ---- stock/action1 --------> NEW_PHYTOMER_NOGROWTH4
// NEW_PHYTOMER_NOGROWTH ---- c6/output3 ------------------------> DEAD

void Manager::compute(double t, bool update)
{
    phase_t old_phase;

    do {
        old_phase = (phase_t)_phase;

        switch ((phase_t)_phase) {
        case INIT: {
            _phase = INITIAL;
            _state = VEGETATIVE;
            break;
        }
        case INITIAL: {
            if (_stock_1 > 0 and _phenoStage < nbleaf_pi) {
                _phase = GROWTH;
            } else {
                _phase = DEAD;
            }
            break;
        }
        case GROWTH:
            if (_boolCrossedPlasto > 0 and _stock_1 > 0) {
                leaf_number += culm_number;
                _phase = NEW_PHYTOMER;
            }
            if (_stock_1 <= 0) {
                _phase = NOGROWTH2;
            }
            break;
        case NOGROWTH: {
            if (_stock_1 > 0) {
                _phase = GROWTH;
            }
            break;
        }
        case DEAD: break;
        case NEW_PHYTOMER: {
            if (_phenoStage == nbleaf_culm_elong) {
                _state = ELONG;
            }
            _phase = NEW_PHYTOMER3;
            break;
        }
        case NOGROWTH2: {
            _last_time = t;
            _phase = NOGROWTH3;
            break;
        }
        case NOGROWTH3: {
            if (t == _last_time + 1) {
                _phase = NOGROWTH4;
            }
            break;
        }
        case NOGROWTH4: {
            if (_stock_1 > 0) {
                _phase = GROWTH;
            }
            break;
        }
        case NEW_PHYTOMER3: {
            if (_boolCrossedPlasto <= 0) {
                _phase = GROWTH;
            }
            if (_stock_1 <= 0) {
                _phase = NOGROWTH2;
            }
            break;
        }
        case LIG: break;
        };
    } while (old_phase != _phase);

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("PLANT_MANAGER", t, utils::COMPUTE)
            << "phase = " << _phase
            << " ; state = " << _state
            << " ; stock = " << _stock
            << " ; stock[-1] = " << _stock_1
            << " ; phenoStage = " << _phenoStage
            << " ; boolCrossedPlasto = " << _boolCrossedPlasto
            << " ; FTSW = " << _FTSW
            << " ; IC = " << _IC
            << " ; nbleaf_culm_elong = " << nbleaf_culm_elong
            << " ; nbleaf_pi = " << nbleaf_pi
            << " ; leaf_number = " << leaf_number
            << " ; culm_number = " << culm_number;
        utils::Trace::trace().flush();
#endif

}

void Manager::put(double t, unsigned int index, double value)
{
    if (index == STOCK and !is_ready(t, STOCK)) {
        _stock_1 = _stock;
    }

    AbstractAtomicModel < Manager >::put(t, index, value);
    (*this)(t);
}

} } // namespace ecomeristem plant
