/**
 * @file ecomeristem/plant/TillerManager.hpp
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

#include <model/kernel/AbstractAtomicModel.hpp>

namespace ecomeristem { namespace plant {

class TillerManager : public ecomeristem::AbstractAtomicModel < TillerManager >
{
public:
    enum internals { NB_TILLERS, CREATE };
    enum externals { BOOL_CROSSED_PLASTO, IC, PHENO_STAGE, TAE };

    TillerManager()
    {
        internal(NB_TILLERS, &TillerManager::_nb_tillers);
        internal(CREATE, &TillerManager::_create);

        external(BOOL_CROSSED_PLASTO, &TillerManager::_boolCrossedPlasto);
        external(IC, &TillerManager::_IC);
        external(PHENO_STAGE, &TillerManager::_phenoStage);
        external(TAE, &TillerManager::_tae);
    }

    virtual ~TillerManager()
    { }

    virtual bool check(double t) const
    { return is_ready(t, IC); }

    void init(double /* t */, const model::models::ModelParameters& parameters)
    {
        _Ict = parameters.get < double >("Ict");
        _nbleaf_enabling_tillering =
            parameters.get < double >("nb_leaf_enabling_tillering");
        _P = 0; // parameters.get < double >("P");
        _resp_Ict = parameters.get < double >("resp_Ict");

        _nb_tillers = 0;
        nbExistingTillers = 1;
        _create = 0;
    }

    void compute(double t, bool update)
    {
        if (not update) {
            _create = 0;
            if (_IC > _Ict) {
                _nb_tillers += nbExistingTillers;
            }
            if (_boolCrossedPlasto > 0 and _nb_tillers >= 1 and
                _IC > _Ict * ((_P * _resp_Ict) + 1)) {
                _nb_tillers = std::min(_nb_tillers, _tae);
                nbExistingTillers += _nb_tillers;
                _create = 1;
            }

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("TILLER MANAGER", t, artis::utils::COMPUTE)
            << "NB_TILLERS = " << _nb_tillers
            << " ; create = " << _create
            << " ; boolCrossedPlasto = " << _boolCrossedPlasto
            << " ; IC = " << _IC
            << " ; Ict = " << _Ict;
        utils::Trace::trace().flush();
#endif
        } else {
            _create = 0;
        }

    }

private:

    // parameters
    double _Ict;
    double _nbleaf_enabling_tillering;
    double _P;
    double _resp_Ict;

    // internal variables
    double _nb_tillers;
    unsigned int nbExistingTillers;
    double _create;

    // external variables
    double _boolCrossedPlasto;
    double _IC;
    double _phenoStage;
    double _tae;
};

} } // namespace ecomeristem plant
