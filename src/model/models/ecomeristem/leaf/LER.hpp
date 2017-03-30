/**
 * @file leaf/LER.hpp
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

#ifndef __ECOMERISTEM_LEAF_LER_HPP
#define __ECOMERISTEM_LEAF_LER_HPP

#include <model/kernel/AbstractAtomicModel.hpp>

namespace ecomeristem { namespace leaf {

class Ler : public ecomeristem::AbstractAtomicModel < Ler >
{
public:
    enum internals { LER };
    enum externals { REDUCTION_LER, PREDIM };

    Ler(int index) : _index(index)
    {
        internal(LER, &Ler::_ler);

        external(REDUCTION_LER, &Ler::_reduction_ler);
        external(PREDIM, &Ler::_predim);
    }

    virtual ~Ler()
    { }

    void compute(double t, bool /* update */)
    {
        _ler = _predim * _reduction_ler / (_plasto + _index *
                                           (_ligulo - _plasto));

 #ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("LEAF_LER", t, artis::utils::COMPUTE)
            << "LER = " << _ler
            << " ; predim = " << _predim
            << " ; reduction_ler = " << _reduction_ler
            << " ; plasto = " << _plasto
            << " ; index = " << _index
            << " ; ligulo = " << _ligulo;
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */,
              const model::models::ModelParameters& parameters)
    {
        _coef_ligulo = parameters.get < double >("coef_ligulo1");
        _plasto = parameters.get < double >("plasto_init");
        _ligulo = _plasto * _coef_ligulo;
        _ler = 0;
        // need for stability
        _predim = 0;
    }

private:
// parameters
    double _coef_ligulo;
    double _ligulo;
    double _plasto;
    int _index;

// internal variable
    double _ler;

// external variables
    double _reduction_ler;
    double _predim;
};

} } // namespace ecomeristem leaf

#endif
