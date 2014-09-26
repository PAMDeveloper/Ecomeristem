/**
 * @file assimilation/Interc.hpp
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

#ifndef __ECOMERISTEM_PLANT_ASSIMILATION_INTERC_HPP
#define __ECOMERISTEM_PLANT_ASSIMILATION_INTERC_HPP

#include <model/kernel/AbstractAtomicModel.hpp>

namespace ecomeristem { namespace plant { namespace assimilation {

class Interc : public AbstractAtomicModel < Interc >
{
public:
    static const unsigned int INTERC = 0;
    static const unsigned int LAI = 0;

    Interc()
    {
        internal(INTERC, &Interc::_interc);
        external(LAI, &Interc::_lai);
    }

    virtual ~Interc()
    { }

    void compute(double /* t */)
    {
        _interc = 1. - std::exp(-_Kdf * _lai);

        // std::cout << "INTERC: " << _interc << " " << _Kdf << " " << _lai
        //           << std::endl;

    }

    void init(double /* t */,
              const model::models::ModelParameters& parameters)
    {
        _Kdf = parameters.get < double >("Kdf");
        _interc = 0;
    }

private:
// parameters
    double _Kdf;

// internal variable
    double _interc;

// external variables
    double _lai;
};

} } } // namespace ecomeristem plant assimilation

#endif
