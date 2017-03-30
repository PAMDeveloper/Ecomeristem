/**
 * @file internode/Manager.hpp
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

#ifndef __ECOMERISTEM_INTERNODE_MANAGER_HPP
#define __ECOMERISTEM_INTERNODE_MANAGER_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <model/models/ecomeristem/plant/PlantManager.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace internode {

enum Phase { INIT, VEGETATIVE, REALIZATION, REALIZATION_NOGROWTH, MATURITY,
             MATURITY_NOGROWTH };

class InternodeManager : public ecomeristem::AbstractAtomicModel < InternodeManager >
{
public:
    enum internals { INTERNODE_PHASE };
    enum externals { PHASE, STATE, LEN, PREDIM, LIG };

    InternodeManager(int index) : _index(index)
    {
        internal(INTERNODE_PHASE, &InternodeManager::_phase_);

        external(PHASE, &InternodeManager::_phase);
        external(STATE, &InternodeManager::_state);
        external(LEN, &InternodeManager::_len);
        external(PREDIM, &InternodeManager::_predim);
        external(LIG, &InternodeManager::_lig);
    }

    virtual ~InternodeManager()
    { }

    virtual bool check(double /* t */) const
    { return true; }

    void compute(double t, bool /* update */)
    {
        if (_phase_ == internode::INIT) {
            _phase_ = internode::VEGETATIVE;
        } else if (_phase_ == internode::VEGETATIVE and
                   _state == plant::ELONG and _lig == t) {
            _phase_ = internode::REALIZATION;
        } else if (_phase_ == internode::REALIZATION and _len >= _predim) {
            _phase_ = internode::MATURITY;
        } else if (_phase_ == internode::REALIZATION and
                   (_phase == plant::NOGROWTH or _phase == plant::NOGROWTH3
                    or _phase == plant::NOGROWTH4)) {
            _phase_ = internode::REALIZATION_NOGROWTH;
        } else if (_phase_ == internode::REALIZATION_NOGROWTH and
                   (_phase == plant::GROWTH or
                    _phase == plant::NEW_PHYTOMER3)) {
            _phase_ = internode::REALIZATION;
        } else if (_phase_ == internode::MATURITY and
                   (_phase == plant::NOGROWTH or _phase == plant::NOGROWTH3
                    or _phase == plant::NOGROWTH4)) {
            _phase_ = internode::MATURITY_NOGROWTH;
        } else if (_phase_ == internode::MATURITY_NOGROWTH and
                   (_phase == plant::GROWTH or
                    _phase == plant::NEW_PHYTOMER3)) {
            _phase_ = internode::MATURITY;
        }

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("INTERNODE_MANAGER", t,
                                   artis::utils::COMPUTE)
            << "index = " << _index
            << " ; phase = " << _phase_
            << " ; phase = " << _phase
            << " ; len = " << _len
            << " ; predim = " << _predim;
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */,
              const model::models::ModelParameters& /* parameters */)
    {
        _phase = plant::INIT;
        _phase_ = internode::INIT;
        _predim_init = false;
    }

    void put(double t, unsigned int index, double value)
    {
        if (index == PREDIM) {
            _predim_init = true;
        }

        ecomeristem::AbstractAtomicModel < InternodeManager >::put(t, index, value);

        //TODO: remove _phase_ == internode::REALIZATION !!!!
        if (_phase_ == internode::INIT or _phase_ == internode::REALIZATION
            or _phase_ == internode::REALIZATION_NOGROWTH
            or (is_ready(t, LEN) and _predim_init)) {
            (*this)(t);
        }
    }

private:
// internal variable
    int _index;
    double _phase_;
    bool   _predim_init;

// external variables
    double _phase;
    double _state;
    double _len;
    double _predim;
    double _lig;
};} } // namespace ecomeristem internode

#endif
