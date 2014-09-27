/**
 * @file assimilation/RespMaint.hpp
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

#ifndef __ECOMERISTEM_PLANT_ASSIMILATION_RESP_MAINT_HPP
#define __ECOMERISTEM_PLANT_ASSIMILATION_RESP_MAINT_HPP

#include <model/kernel/AbstractAtomicModel.hpp>

namespace ecomeristem { namespace plant { namespace assimilation {

class RespMaint : public AbstractAtomicModel < RespMaint >
{
public:
    static const unsigned int RESP_MAINT = 0;
    static const unsigned int LEAF_BIOMASS = 0;
    static const unsigned int INTERNODE_BIOMASS = 1;
    static const unsigned int TA = 2;

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

    void compute(double /* t */, bool /* update */)
    {
        _RespMaint = (_Kresp_leaf * _LeafBiomass +
                      _Kresp_internode * _InternodeBiomass) *
            std::pow(2., (_Ta - _Tresp) / 10.);

        std::cout << "RESPMAINT: " << _RespMaint << " " << _LeafBiomass << " "
                  << _InternodeBiomass << " " << _Ta << std::endl;

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
