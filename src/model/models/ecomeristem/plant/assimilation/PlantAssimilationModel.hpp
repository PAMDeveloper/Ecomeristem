/**
 * @file ecomeristem/plant/assimilation/Model.hpp
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

class PlantAssimilationModel : public ecomeristem::AbstractCoupledModel < PlantAssimilationModel >
{
public:
    enum submodels { ASSIM_MODEL, ASSIM_POT_MODEL, INTERC_MODEL,
                     LAI_MODEL, RESP_MAINT_MODEL };
    enum internals { ASSIM, LAI, INTERC };
    enum externals { FCSTR, INTERNODE_BIOMASS, LEAF_BIOMASS, PAI, RADIATION,
                     TA, CSTR };

    PlantAssimilationModel()
    {
        //submodels
        submodel(ASSIM_MODEL, &assim_model);
        submodel(ASSIM_POT_MODEL, &assimPot_model);
        submodel(INTERC_MODEL, &interc_model);
        submodel(LAI_MODEL, &lai_model);
        submodel(RESP_MAINT_MODEL, &respMaint_model);

        // internals
        internal(ASSIM, &assim_model, Assim::ASSIM);
        internal(LAI, &assim_model, Lai::LAI);
        internal(INTERC, &interc_model, Interc::INTERC);

        // externals
        external(FCSTR, &PlantAssimilationModel::_fcstr);
        external(INTERNODE_BIOMASS, &PlantAssimilationModel::_internodeBiomass);
        external(LEAF_BIOMASS, &PlantAssimilationModel::_leafBiomass);
        external(PAI, &PlantAssimilationModel::_PAI);
        external(RADIATION, &PlantAssimilationModel::_Radiation);
        external(TA, &PlantAssimilationModel::_Ta);
        external(CSTR, &PlantAssimilationModel::_cstr);
    }

    virtual ~PlantAssimilationModel()
    { }

    void compute(double t, bool /* update */)
    {
        if (is_ready(t, LEAF_BIOMASS) and is_ready(t, INTERNODE_BIOMASS) and
            is_ready(t, TA)) {
            respMaint_model.put < double >(t, RespMaint::LEAF_BIOMASS, _leafBiomass);
            respMaint_model.put < double >(t, RespMaint::INTERNODE_BIOMASS,
                                _internodeBiomass);
            respMaint_model.put < double >(t, RespMaint::TA, _Ta);
            respMaint_model(t);
            if (is_ready(t, FCSTR) and is_ready(t, PAI)) {
                lai_model.put < double >(t, Lai::FCSTR, _fcstr);
                lai_model.put < double >(t, Lai::PAI, _PAI);
                lai_model(t);

                interc_model.put < double >(t, Interc::LAI,
                                 lai_model.get < double >(t, Lai::LAI));
                interc_model(t);
                if (is_ready(t, CSTR) and is_ready(t, RADIATION)) {
                    assimPot_model.put < double >(t, AssimPot::CSTR, _cstr);
                    assimPot_model.put < double >(t, AssimPot::RADIATION, _Radiation);
                    assimPot_model.put < double >(t, AssimPot::INTERC,
                                       interc_model.get < double >(t, Interc::INTERC));
                    assimPot_model(t);

                    assim_model.put < double >(t, Assim::RESP_MAINT,
                                    respMaint_model.get < double >(t,
                                                        RespMaint::RESP_MAINT));
                    assim_model.put < double >(t, Assim::ASSIM_POT,
                                    assimPot_model.get < double >(t, AssimPot::ASSIM_POT));
                    assim_model(t);
                }
            }
        }
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
