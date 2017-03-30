/**
 * @file leaf/Predim.hpp
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

#ifndef __ECOMERISTEM_LEAF_PREDIM_HPP
#define __ECOMERISTEM_LEAF_PREDIM_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace leaf {

class LeafPredim : public ecomeristem::AbstractAtomicModel < LeafPredim >
{
public:
    enum internals { PREDIM };
    enum externals { FCSTR, PREDIM_LEAF_ON_MAINSTEM, PREDIM_PREVIOUS_LEAF,
                     TEST_IC };

    LeafPredim(int index, bool is_first_leaf, bool is_on_mainstem) :
        _index(index), _is_first_leaf(is_first_leaf), _is_on_mainstem(is_on_mainstem)
    {
        internal(PREDIM, &LeafPredim::_predim);

        external(FCSTR, &LeafPredim::_fcstr);
        external(PREDIM_LEAF_ON_MAINSTEM, &LeafPredim::_predim_leaf_on_mainstem);
        external(PREDIM_PREVIOUS_LEAF, &LeafPredim::_predim_previous_leaf);
        external(TEST_IC, &LeafPredim::_test_ic);
   }

    virtual ~LeafPredim()
    { }

    bool check(double t) const
    {
        if (_is_first_leaf and _is_on_mainstem) {
            return true;
        } else if (not _is_first_leaf and _is_on_mainstem) {
            return is_ready(t, PREDIM_LEAF_ON_MAINSTEM) and
                is_ready(t, TEST_IC) and is_ready(t, FCSTR);
        } else if (_is_first_leaf and not _is_on_mainstem) {
            return is_ready(t, PREDIM_LEAF_ON_MAINSTEM) and
                is_ready(t, TEST_IC) and is_ready(t, FCSTR);
        } else {
            return is_ready(t, PREDIM_LEAF_ON_MAINSTEM) and
                is_ready(t, PREDIM_PREVIOUS_LEAF) and
                is_ready(t, TEST_IC) and is_ready(t, FCSTR);
        }
    }

    void compute(double t, bool /* update */)
    {
        if (t == _first_day) {
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

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("LEAF_PREDIM", t, artis::utils::COMPUTE)
            << "Predim = " << _predim
            << " ; Lef1 = " << _Lef1
            << " ; index = " << _index
            << " ; is_first_leaf = " << _is_first_leaf
            << " ; is_on_mainstem = " << _is_on_mainstem
            << " ; MGR = " << _MGR
            << " ; testIC = " << _test_ic
            << " ; fcstr = " << _fcstr
            << " ; predim_previous_leaf = " << _predim_previous_leaf
            << " ; predim_leaf_on_mainstem = " << _predim_leaf_on_mainstem;
        utils::Trace::trace().flush();
#endif

    }

    void init(double t, const model::models::ModelParameters& parameters)
    {
        _Lef1 = parameters.get < double >("Lef1");
        _MGR = parameters.get < double >("MGR_init");
        _predim = 0;
        _first_day = t;
    }

private:
// parameters
    int _index;
    bool _is_first_leaf;
    bool _is_on_mainstem;
    double _Lef1;
    double _MGR;
    double _first_day;

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
