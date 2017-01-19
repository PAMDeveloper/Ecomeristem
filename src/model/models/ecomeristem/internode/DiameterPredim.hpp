/**
 * @file internode/DiameterPredim.hpp
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

#ifndef __ECOMERISTEM_INTERNODE_DIAMETER_PREDIM_HPP
#define __ECOMERISTEM_INTERNODE_DIAMETER_PREDIM_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace internode {

class DiameterPredim : public ecomeristem::AbstractAtomicModel < DiameterPredim >
{
public:
    enum internals { DIAMETER_PREDIM };
    enum externals { PREDIM };

    DiameterPredim()
    {
        internal(DIAMETER_PREDIM, &DiameterPredim::_diameter_predim);
        external(PREDIM, &DiameterPredim::_predim);
    }

    virtual ~DiameterPredim()
    { }

    void compute(double t, bool /* update */)
    {
        _diameter_predim = _IN_length_to_IN_diam * _predim + _coef_lin_IN_diam;

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("INTERNODE_DIAMETER", t, artis::utils::COMPUTE)
            << "DiameterPredim = " << _diameter_predim
            << " ; predim = " << _predim;
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */,
              const model::models::ModelParameters& parameters)
    {
        _IN_length_to_IN_diam =
            parameters.get < double >("IN_length_to_IN_diam");
        _coef_lin_IN_diam = parameters.get < double >("coef_lin_IN_diam");
        _diameter_predim = 0;
    }

private:
// parameters
    double _IN_length_to_IN_diam;
    double _coef_lin_IN_diam;

// internal variable
    double _diameter_predim;

// external variables
    double _predim;
};

} } // namespace ecomeristem internode

#endif
