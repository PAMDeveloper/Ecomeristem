/**
 * @file ecomeristem/plant/TillerManager.hpp
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

namespace ecomeristem { namespace plant {

class TillerManager : public AbstractAtomicModel < TillerManager >
{
public:
    static const int BOOL_CROSSED_PLASTO = 0;
    static const int IC = 1;
    static const int PHENO_STAGE = 2;

    TillerManager()
    {
        external(BOOL_CROSSED_PLASTO, &TillerManager::_boolCrossedPlasto);
        external(IC, &TillerManager::_IC);
        external(PHENO_STAGE, &TillerManager::_phenoStage);
    }

    virtual ~TillerManager()
    { }

    void init(double /* t */, const model::models::ModelParameters& /* parameters */)
    {
        nbTillers = 0;
        nbExistingTillers = 1;
        tae = 0;
    }

    void compute(double /* t */)
    {
        if (_IC > Ict) {
            nbTillers += nbExistingTillers;
        }
        if (_boolCrossedPlasto > 0 and nbTillers >= 1 and
            _IC > Ict * ((P * resp_Ict) + 1)) {
            nbTillers = std::min(nbTillers, tae);
            nbExistingTillers += nbTillers;
        }
    }

private:
    // parameters
    double Ict;
    double nbleaf_enabling_tillering;
    double P;
    double resp_Ict;

    // internal variables
    unsigned int nbTillers;
    unsigned int nbExistingTillers;
    unsigned int tae;

    // external variables
    double _boolCrossedPlasto;
    double _IC;
    double _phenoStage;
};

} } // namespace ecomeristem plant