/**
 * @file internode/ReductionINER.hpp
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

#ifndef __ECOMERISTEM_INTERNODE_REDUCTION_INER_HPP
#define __ECOMERISTEM_INTERNODE_REDUCTION_INER_HPP

#include <model/kernel/AbstractAtomicModel.hpp>

namespace ecomeristem { namespace internode {

class ReductionINER : public ecomeristem::AbstractAtomicModel < ReductionINER >
{
public:
    enum internals { REDUCTION_INER };
    enum externals { FTSW, P };

    ReductionINER()
    {
        internal(REDUCTION_INER, &ReductionINER::_reduction_iner);

        external(FTSW, &ReductionINER::_ftsw);
        external(P, &ReductionINER::_p);
    }

    virtual ~ReductionINER()
    { }

    void compute(double t, bool /* update */)
    {
        if (_ftsw < _thresINER) {
            _reduction_iner = std::max(1e-4, (1. - (_thresINER - _ftsw) *
                                              _slopeINER) *
                                       (1. + (_p * _respINER)));
        } else {
            _reduction_iner = 1. + _p * _respINER;
        }

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("INTERNODE_REDUCTION_INER",
                                   t, artis::utils::COMPUTE)
            << "ReductionINER = " << _reduction_iner
            << " ; FTSW = " << _ftsw
            << " ; P = " << _p;
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */,
              const model::models::ModelParameters& parameters)
    {
        _thresINER = parameters.get < double >("thresINER");
        _respINER = parameters.get < double >("resp_LER");
        _slopeINER = parameters.get < double >("slopeINER");
        _reduction_iner = 0;
    }

private:
// parameters
    double _thresINER;
    double _respINER;
    double _slopeINER;

// internal variable
    double _reduction_iner;

// external variables
    double _ftsw;
    double _p;
};

} } // namespace ecomeristem internode

#endif
