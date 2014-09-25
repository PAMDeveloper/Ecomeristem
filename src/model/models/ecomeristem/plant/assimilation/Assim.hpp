/**
 * @file assimilation/Assim.hpp
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

#ifndef __ECOMERISTEM_PLANT_ASSIMILATION_ASSIM_HPP
#define __ECOMERISTEM_PLANT_ASSIMILATION_ASSIM_HPP

#include <model/kernel/AbstractAtomicModel.hpp>

namespace ecomeristem { namespace plant { namespace assimilation {

class Assim : public AbstractAtomicModel < Assim >
{
public:
    static const unsigned int ASSIM = 0;
    static const unsigned int RESP_MAINT = 0;
    static const unsigned int ASSIM_POT = 1;

    Assim() : _assim(0)
    {
        internal(ASSIM, &Assim::_assim);
        external(RESP_MAINT, &Assim::_resp_maint);
        external(ASSIM_POT, &Assim::_assim_pot);
    }

    virtual ~Assim()
    { }

    void compute(double /* t */)
    {
        _assim = std::max(0., _assim_pot / _density - _resp_maint);

        // std::cout << "ASSIM: " << _assim << " " << _assim_pot << " "
        //           << _resp_maint << std::endl;

    }

    void init(double /* t */,
              const model::models::ModelParameters& parameters)
    {
        _density = parameters.get < double >("density");
        _assim = 0;
    }

private:
// parameters
    double _density;

// internal variable
    double _assim;

// external variables
    double _resp_maint;
    double _assim_pot;
};

} } } // namespace ecomeristem plant assimilation

#endif
