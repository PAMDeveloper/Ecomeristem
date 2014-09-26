/**
 * @file ecomeristem/plant/Manager.cpp
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

#include <model/models/ecomeristem/plant/Manager.hpp>

namespace ecomeristem { namespace plant {

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

void Manager::compute(double /* t */)
{
    state_t old_state;

    do {
        old_state = (state_t)_state;

        switch ((state_t)_state) {
        case INIT: {
            _state = INITIAL;
            break;
        }
        case INITIAL: {
            if (_stock > 0 and _phenoStage < nbleaf_pi) {
                _state = PHYTOMER_MORPHO_GENESIS;
            } else {
                _state = DEAD;
            }
            break;
        }
        case PHYTOMER_MORPHO_GENESIS:
        case NOGROWTH:
        case DEAD:
        case NEW_PHYTOMER:
        case ELONG:
        case PI:
        case NOGROWTH_ELONG:
        case NOGROWTH_PI:
        case PRE_FLO:
        case NOGROWTH_PRE_FLO:
        case FLO:
        case NOGROWTH_FLO:
        case NEW_PHYTOMER_NOGROWTH:
        case NEW_PHYTOMER_NOGROWTH2:
        case NEW_PHYTOMER_NOGROWTH3:
        case NEW_PHYTOMER_NOGROWTH4:
        case NOGROWTH2:
        case NOGROWTH3:
        case NOGROWTH4:
        case NOGROWTH5:
        case NEW_PHYTOMER2:
        case NEW_PHYTOMER3:
        case LIG: break;
        };
    } while (old_state != _state);
}

void Manager::put(double t, unsigned int index, double value)
{
    AbstractAtomicModel < Manager >::put(t, index, value);
    compute(t);
}

} } // namespace ecomeristem plant
