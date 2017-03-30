/**
 * @file leaf/ReductionLER.hpp
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

#ifndef __ECOMERISTEM_LEAF_REDUCTION_LER_HPP
#define __ECOMERISTEM_LEAF_REDUCTION_LER_HPP

#include <model/kernel/AbstractAtomicModel.hpp>

namespace ecomeristem { namespace leaf {

class ReductionLER : public ecomeristem::AbstractAtomicModel < ReductionLER >
{
public:
    enum internals { REDUCTION_LER };
    enum externals { FTSW, P };

    ReductionLER()
    {
        internal(REDUCTION_LER, &ReductionLER::_reduction_ler);
        external(FTSW, &ReductionLER::_ftsw);
        external(P, &ReductionLER::_p);
    }

    virtual ~ReductionLER()
    { }

    void compute(double /* t */, bool /* update */)
    {
        if (_ftsw < _thresLER) {
            _reduction_ler = std::max(1e-4, ((1. / _thresLER) * _ftsw) *
                                      (1. + (_p * _respLER)));
        } else {
            _reduction_ler = 1. + _p * _respLER;
        }
    }

    void init(double /* t */,
              const model::models::ModelParameters& parameters)
    {
        _thresLER = parameters.get < double >("thresLER");
        _respLER = parameters.get < double >("resp_LER");
        _reduction_ler = 0;
    }

private:
// parameters
    double _thresLER;
    double _respLER;

// internal variable
    double _reduction_ler;

// external variables
    double _ftsw;
    double _p;
};

} } // namespace ecomeristem leaf

#endif
