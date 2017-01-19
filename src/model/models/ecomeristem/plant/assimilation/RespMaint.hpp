/**
 * @file assimilation/RespMaint.hpp
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

#ifndef __ECOMERISTEM_PLANT_ASSIMILATION_RESP_MAINT_HPP
#define __ECOMERISTEM_PLANT_ASSIMILATION_RESP_MAINT_HPP

#include <model/kernel/AbstractAtomicModel.hpp>
#include <utils/Trace.hpp>

namespace ecomeristem { namespace plant { namespace assimilation {

class RespMaint : public ecomeristem::AbstractAtomicModel < RespMaint >
{
public:
    enum internals { RESP_MAINT };
    enum externals { LEAF_BIOMASS, INTERNODE_BIOMASS, TA };

    RespMaint()
    {
        internal(RESP_MAINT, &RespMaint::_RespMaint);
        external(LEAF_BIOMASS, &RespMaint::_LeafBiomass);
        external(INTERNODE_BIOMASS, &RespMaint::_InternodeBiomass);
        external(TA, &RespMaint::_Ta);
    }

    virtual ~RespMaint()
    { }

    bool check(double t) const
    { return is_ready(t, LEAF_BIOMASS) and is_ready(t, INTERNODE_BIOMASS) and
            is_ready(t, TA); }

    void compute(double t, bool /* update */)
    {
        _RespMaint = (_Kresp_leaf * _LeafBiomass +
                      _Kresp_internode * _InternodeBiomass) *
            std::pow(2., (_Ta - _Tresp) / 10.);

#ifdef WITH_TRACE
        utils::Trace::trace()
            << utils::TraceElement("RESPMAINT", t, artis::utils::COMPUTE)
            << "respMaint = " << _RespMaint << " ; LeafBiomass = "
            << _LeafBiomass << " ; InternodeBiomass = "
            << _InternodeBiomass << " ; TA = "
            << _Ta << " ; Tresp = " << _Tresp << " ; Kresp_leaf = "
            << _Kresp_leaf << " ; Kresp_internode = " << _Kresp_internode;
        utils::Trace::trace().flush();
#endif

    }

    void init(double /* t */,
              const model::models::ModelParameters& parameters)
    {
        _Kresp_leaf = parameters.get < double >("Kresp");
        _Kresp_internode = parameters.get < double >("Kresp_internode");
        _Tresp = parameters.get < double >("Tresp");
        _RespMaint = 0;
    }

private:
// parameters
    double _Kresp_leaf;
    double _Kresp_internode;
    double _Tresp;

// internal variable
    double _RespMaint;

// external variables
    double _LeafBiomass;
    double _InternodeBiomass;
    double _Ta;
};

} } } // namespace ecomeristem plant assimilation

#endif
