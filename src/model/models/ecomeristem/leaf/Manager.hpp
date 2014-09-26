/**
 * @file leaf/Manager.hpp
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

#ifndef __ECOMERISTEM_LEAF_MANAGER_HPP
#define __ECOMERISTEM_LEAF_MANAGER_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <model/models/ecomeristem/plant/Manager.hpp>

namespace ecomeristem { namespace leaf {

class Manager : public AbstractAtomicModel < Manager >
{
public:
    enum internals { LEAF_PHASE };
    enum externals { PHASE, STOP, LEN, PREDIM };

    Manager()
    {
        internal(LEAF_PHASE, &Manager::_phase_);
        external(PHASE, &Manager::_phase);
        external(STOP, &Manager::_stop);
        external(LEN, &Manager::_len);
        external(PREDIM, &Manager::_predim);
    }

    virtual ~Manager()
    { }

    void compute(double /* t */)
    {
        if (_phase_ == plant::INITIAL and _len >= _predim) {
            _phase_ = plant::LIG;
        } else if (_phase_ == plant::INITIAL and _phase == plant::NOGROWTH) {
            _phase_ = plant::NOGROWTH;
        } else if (_phase_ == plant::NOGROWTH and
                   _phase == plant::PHYTOMER_MORPHO_GENESIS) {
            _phase_ = plant::INITIAL;
        }
    }

    void init(double /* t */,
              const model::models::ModelParameters& /* parameters */)
    {
        _phase_ = plant::INITIAL;
    }

    void put(double t, unsigned int index, double value)
    {
        AbstractAtomicModel < Manager >::put(t, index, value);
        compute(t);
    }

private:
// internal variable
    double _phase_;

// external variables
    double _phase;
    double _stop;
    double _len;
    double _predim;
};

} } // namespace ecomeristem leaf

#endif
