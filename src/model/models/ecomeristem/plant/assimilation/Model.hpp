/**
 * @file ecomeristem/plant/assimilation/Model.hpp
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

#ifndef __ECOMERISTEM_PLANT_ASSIMILATION_HPP
#define __ECOMERISTEM_PLANT_ASSIMILATION_HPP

#include <model/kernel/AbstractCoupledModel.hpp>

#include <model/models/ModelParameters.hpp>
#include <model/models/ecomeristem/plant/assimilation/Assim.hpp>
#include <model/models/ecomeristem/plant/assimilation/AssimPot.hpp>
#include <model/models/ecomeristem/plant/assimilation/Interc.hpp>
#include <model/models/ecomeristem/plant/assimilation/Lai.hpp>
#include <model/models/ecomeristem/plant/assimilation/RespMaint.hpp>

namespace ecomeristem { namespace plant { namespace assimilation {

class Model : public AbstractCoupledModel < Model >
{
public:
    static const int ASSIM = 0;
    static const int INTERC = 1;

    static const int FCSTR = 0;
    static const int INTERNODE_BIOMASS = 1;
    static const int LEAF_BIOMASS = 2;
    static const int PAI = 3;
    static const int RADIATION = 4;
    static const int TA = 5;
    static const int CSTR = 6;

    Model()
    {
        internal(ASSIM, &assim_model, Assim::ASSIM);
        internal(INTERC, &interc_model, Interc::INTERC);

        external(FCSTR, &Model::_fcstr);
        external(INTERNODE_BIOMASS, &Model::_internodeBiomass);
        external(LEAF_BIOMASS, &Model::_leafBiomass);
        external(PAI, &Model::_PAI);
        external(RADIATION, &Model::_Radiation);
        external(TA, &Model::_Ta);
        external(CSTR, &Model::_cstr);
    }

    virtual ~Model()
    { }

    void build()
    { }

    void compute(double t)
    {
        lai_model.put(t, Lai::FCSTR, _fcstr);
        lai_model.put(t, Lai::PAI, _PAI);
        lai_model.compute(t);

        interc_model.put(t, Interc::LAI,
                          lai_model.get(Lai::LAI));
        interc_model.compute(t);

        assimPot_model.put(t, AssimPot::CSTR, _cstr);
        assimPot_model.put(t, AssimPot::RADIATION, _Radiation);
        assimPot_model.put(t, AssimPot::INTERC,
                            interc_model.get(Interc::INTERC));
        assimPot_model.compute(t);

        respMaint_model.put(t, RespMaint::LEAF_BIOMASS, _leafBiomass);
        respMaint_model.put(t, RespMaint::INTERNODE_BIOMASS,
                             _internodeBiomass);
        respMaint_model.put(t, RespMaint::TA, _Ta);
        respMaint_model.compute(t);

        assim_model.put(t, Assim::RESP_MAINT,
                         respMaint_model.get(RespMaint::RESP_MAINT));
        assim_model.put(t, Assim::ASSIM_POT,
                         assimPot_model.get(AssimPot::ASSIM_POT));
        assim_model.compute(t);
    }

    void init(double t, const model::models::ModelParameters& parameters)
    {
        assim_model.init(t, parameters);
        assimPot_model.init(t, parameters);
        interc_model.init(t, parameters);
        lai_model.init(t, parameters);
        respMaint_model.init(t, parameters);
    }

private:
// external variables
    double _fcstr;
    double _internodeBiomass;
    double _leafBiomass;
    double _PAI;
    double _Radiation;
    double _Ta;
    double _cstr;

// models
    ecomeristem::plant::assimilation::Assim assim_model;
    ecomeristem::plant::assimilation::AssimPot assimPot_model;
    ecomeristem::plant::assimilation::Interc interc_model;
    ecomeristem::plant::assimilation::Lai lai_model;
    ecomeristem::plant::assimilation::RespMaint respMaint_model;
};

} } } // namespace ecomeristem plant assimilation

#endif
