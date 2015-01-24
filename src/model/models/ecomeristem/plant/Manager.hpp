/**
 * @file ecomeristem/plant/Manager.hpp
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

#ifndef __ECOMERISTEM_PLANT_MANAGER_HPP
#define __ECOMERISTEM_PLANT_MANAGER_HPP

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
    static const int STOCK = 0;
    static const int PHENO_STAGE = 1;
    static const int BOOL_CROSSED_PLASTO = 2;
    static const int FTSW = 3;
    static const int IC = 4;

    static const int PHASE = 0;

    Manager()
    {
        external(STOCK, &Manager::_stock);
        external(PHENO_STAGE, &Manager::_phenoStage);
        external(BOOL_CROSSED_PLASTO, &Manager::_boolCrossedPlasto);
        external(FTSW, &Manager::_FTSW);
        external(IC, &Manager::_IC);

        internal(PHASE, &Manager::_state);
    }

    virtual ~Manager()
    { }

    virtual void init(double /* t */,
                      const model::models::ModelParameters& parameters)
    {
        nbleaf_pi = 10; // parameters.get < double >("nbleaf_pi");
        nbleaf_culm_elong = parameters.get < double >("nb_leaf_stem_elong");
        nbleaf_max_after_pi = parameters.get < double >("nb_leaf_max_after_PI");

        culm_number = 1;
        leaf_number = 1;
        first_leaf = true;

        // TODO
        _stock = 1e-10;
    }

    virtual void compute(double t, bool /* update */);

    virtual void put(double t, unsigned int index, double value);

private:
// parameters
    double nbleaf_pi;
    double nbleaf_culm_elong;
    double nbleaf_max_after_pi;

// internal variables
    double _state;
    unsigned int leaf_number;
    unsigned int culm_number;
    bool first_leaf;
    double _last_time;

// external variables
    double _stock;
    double _phenoStage;
    double _boolCrossedPlasto;
    double _FTSW;
    double _IC;
};

} } // namespace ecomeristem plant

#endif
