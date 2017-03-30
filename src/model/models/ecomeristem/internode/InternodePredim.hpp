/**
 * @file internode/Predim.hpp
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

#ifndef __ECOMERISTEM_INTERNODE_PREDIM_HPP
#define __ECOMERISTEM_INTERNODE_PREDIM_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace internode {

class InternodePredim : public ecomeristem::AbstractAtomicModel < InternodePredim >
{
public:
    enum internals { PREDIM, LL_BL };
    enum externals { PREDIM_PREVIOUS_LEAF };

    InternodePredim(int index) : _index(index)
    {
        internal(PREDIM, &InternodePredim::_predim);
        internal(LL_BL, &InternodePredim::_LL_BL);

        external(PREDIM_PREVIOUS_LEAF, &InternodePredim::_leaf_predim);
   }

    virtual ~InternodePredim()
    { }

    void compute(double t, bool /* update */)
    {
        if (_index - 1 - _nb_leaf_param2 < 0) {
            _LL_BL = _LL_BL_init;
        } else {
            _LL_BL = _LL_BL_init + _slope_LL_BL_at_PI * (_index - 1 -
                                                         _nb_leaf_param2);
        }
        _predim = std::max(1e-4, _slope_length_IN *
                           _leaf_predim - _leaf_length_to_IN_length);

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("INTERNODE_PREDIM", t, artis::utils::COMPUTE)
            << "Predim = " << _predim
            << " ; leaf_predim = " << _leaf_predim
            << " ; index = " << _index
            << " ; LL_BL = " << _LL_BL;
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */, const model::models::ModelParameters& parameters)
    {
        _LL_BL_init = parameters.get < double >("LL_BL_init");
        _slope_LL_BL_at_PI = parameters.get < double >("slope_LL_BL_at_PI");
        _nb_leaf_param2 = parameters.get < double >("nb_leaf_param2");
        _slope_length_IN = parameters.get < double >("slope_length_IN");
        _leaf_length_to_IN_length =
            parameters.get < double >("leaf_length_to_IN_length");
        _predim = 0;
    }

private:
// parameters
    int _index;
    double _LL_BL_init;
    double _slope_LL_BL_at_PI;
    double _nb_leaf_param2;
    double _slope_length_IN;
    double _leaf_length_to_IN_length;

// internal variable
    double _predim;
    double _LL_BL;

// external variables
    double _leaf_predim;
};

} } // namespace ecomeristem internode

#endif
