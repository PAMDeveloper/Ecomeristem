/**
 * @file leaf/Predim.hpp
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

#ifndef __ECOMERISTEM_LEAF_PREDIM_HPP
#define __ECOMERISTEM_LEAF_PREDIM_HPP

#include <model/kernel/AbstractAtomicModel.hpp>

namespace ecomeristem { namespace leaf {

class Predim : public AbstractAtomicModel < Predim >
{
public:
    enum internals { PREDIM };
    enum externals { FCSTR, PREDIM_LEAF_ON_MAINSTEM, PREDIM_PREVIOUS_LEAF,
                     TEST_IC };

    Predim(bool is_first_leaf, bool is_on_mainstem) :
        _is_first_leaf(is_first_leaf), _is_on_mainstem(is_on_mainstem)
    {
        internal(PREDIM, &Predim::_predim);

        external(FCSTR, &Predim::_fcstr);
        external(PREDIM_LEAF_ON_MAINSTEM, &Predim::_predim_leaf_on_mainstem);
        external(PREDIM_PREVIOUS_LEAF, &Predim::_predim_previous_leaf);
        external(TEST_IC, &Predim::_test_ic);
   }

    virtual ~Predim()
    { }

    void compute(double /* t */)
    {
        if (_is_first_leaf and _is_on_mainstem) {
            _predim = _Lef1;
        } else if (not _is_first_leaf and _is_on_mainstem) {
            _predim =  _predim_leaf_on_mainstem + _MGR * _test_ic * _fcstr;
        } else if (_is_first_leaf and not _is_on_mainstem) {
            _predim = 0.5 * (_predim_leaf_on_mainstem + _Lef1) *
                _test_ic * _fcstr;
        } else {
            _predim = 0.5 * (_predim_leaf_on_mainstem +
                             _predim_previous_leaf) +
                _MGR * _test_ic * _fcstr;
        }
    }

    void init(double /* t */,
              const model::models::ModelParameters& parameters)
    {
        _Lef1 = parameters.get < double >("Lef1");
        _MGR = parameters.get < double >("MRG_init");
        _predim = 0;
    }

private:
// parameters
    bool _is_first_leaf;
    bool _is_on_mainstem;
    double _Lef1;
    double _MGR;

// internal variable
    double _predim;

// external variables
    double _fcstr;
    double _predim_leaf_on_mainstem;
    double _predim_previous_leaf;
    double _test_ic;
};

} } // namespace ecomeristem leaf

#endif
