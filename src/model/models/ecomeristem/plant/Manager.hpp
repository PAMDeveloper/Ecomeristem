/**
 * @file ecomeristem/plant/Manager.hpp
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

#include <model/kernel/AbstractAtomicModel.hpp>
#include <model/models/ModelParameters.hpp>

namespace ecomeristem { namespace plant {

enum state_t { INIT, /* 0 */
               INITIAL, /* 1 */
               PHYTOMER_MORPHO_GENESIS, /* 2 */
               NOGROWTH, /* 3 */
               DEAD, /* 4 */
               NEW_PHYTOMER, /* 5 */
               ELONG, /* 6 */
               PI, /* 7 */
               NOGROWTH_ELONG, /* 8 */
               NOGROWTH_PI, /* 9 */
               PRE_FLO, /* 10 */
               NOGROWTH_PRE_FLO, /* 11 */
               FLO, /* 12 */
               NOGROWTH_FLO, /* 13 */
               NEW_PHYTOMER_NOGROWTH, /* 14 */
               NEW_PHYTOMER_NOGROWTH2, /* 15 */
               NEW_PHYTOMER_NOGROWTH3, /* 16 */
               NEW_PHYTOMER_NOGROWTH4, /* 17 */
               NOGROWTH2, /* 18 */
               NOGROWTH3, /* 19 */
               NOGROWTH4, /* 20 */
               NOGROWTH5, /* 21 */
               NEW_PHYTOMER2, /* 22 */
               NEW_PHYTOMER3, /* 23 */
               LIG /* 24 */
};

class Manager : public AbstractAtomicModel < Manager >
{
public:
    Manager()
    { }

    virtual ~Manager()
    { }

    virtual void init(double /* t */,
                      const model::models::ModelParameters& /* parameters */)
    {
        stock = 0;
        phenoStage = 0;
        boolCrossedPlasto = 0;
        FTSW = 0;
        IC = 0;
        culm_number = 1;
        leaf_number = 0;
        first_leaf = false;
    }

    virtual void compute(double t);

    virtual void put(double t, unsigned int index, double value);

private:
// parameters
    double nbleaf_pi;
    double nbleaf_culm_elong;
    double nbleaf_max_after_pi;

// internal variables
    state_t state;
    double stock;
    double phenoStage;
    double boolCrossedPlasto;
    double FTSW;
    double IC;
    unsigned int leaf_number;
    unsigned int culm_number;
    bool first_leaf;
};

} } // namespace ecomeristem plant
