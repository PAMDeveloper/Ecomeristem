/**
 * @file ecomeristem/plant/thermal-time/Model.hpp
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

#include <model/models/ecomeristem/plant/water-balance/cstr.hpp>
#include <model/models/ecomeristem/plant/water-balance/FTSW.hpp>
#include <model/models/ecomeristem/plant/water-balance/fcstr.hpp>
#include <model/models/ecomeristem/plant/water-balance/SWC.hpp>
#include <model/models/ecomeristem/plant/water-balance/transpiration.hpp>
#include <model/kernel/AbstractCoupledModel.hpp>

namespace ecomeristem { namespace plant { namespace water_balance {

class WaterBalanceModel : public ecomeristem::AbstractCoupledModel < WaterBalanceModel >
{
public:
    enum submodels { CSTR_MODEL, FCSTR_MODEL, FTSW_MODEL, SWC_MODEL,
                     TRANSPIRATION_MODEL };
    enum internals { CSTR, FCSTR, FTSW };
    enum externals { ETP, INTERC, WATER_SUPPLY };

    WaterBalanceModel()
    {
        // submodels
        submodel(CSTR_MODEL, &cstr_model);
        submodel(FCSTR_MODEL, &fcstr_model);
        submodel(FTSW_MODEL, &FTSW_model);
        submodel(SWC_MODEL, &SWC_model);
        submodel(TRANSPIRATION_MODEL, &transpiration_model);

        // internals
        internal(CSTR, &cstr_model, cstr::CSTR);
        internal(FCSTR, &fcstr_model, Fcstr::FCSTR);
        internal(FTSW, &FTSW_model, Ftsw::FTSW);

        // externals
        external(ETP, &WaterBalanceModel::_etp);
        external(INTERC, &WaterBalanceModel::_interc);
        external(WATER_SUPPLY, &WaterBalanceModel::_water_supply);
    }

    virtual ~WaterBalanceModel()
    { }

    void init(double t, const model::models::ModelParameters& parameters)
    {
        SWC_model.init(t, parameters);
        FTSW_model.init(t, parameters);
        fcstr_model.init(t, parameters);
        cstr_model.init(t, parameters);
        transpiration_model.init(t, parameters);
    }

    void compute(double t, bool /* update */)
    {
        FTSW_model(t);

        cstr_model.put < double >(t, cstr::FTSW,
                                  FTSW_model.get < double >(t, Ftsw::FTSW));
        cstr_model(t);

        fcstr_model.put < double >(t, Fcstr::CSTR,
                                   cstr_model.get < double >(t, cstr::CSTR));
        fcstr_model(t);

        if (is_ready(t, INTERC)) {
            transpiration_model.put(t, Transpiration::ETP, _etp);
            transpiration_model.put(t, Transpiration::INTERC, _interc);
            transpiration_model.put(t, Transpiration::CSTR,
                                    cstr_model.get < double >(t, cstr::CSTR));
            transpiration_model(t);

            SWC_model.put < double >(t, Swc::WATER_SUPPLY, _water_supply);
            SWC_model.put < double >(t, Swc::DELTA_P,
                          transpiration_model.get < double >(t,
                              Transpiration::TRANSPIRATION));
            SWC_model(t);
            FTSW_model.put(t, Ftsw::SWC, SWC_model.get < double >(t, Swc::SWC));
            transpiration_model.put(t, Transpiration::SWC,
                                    SWC_model.get < double >(t, Swc::SWC));
        }
    }

private:
// parameters
    double _etp;
    double _interc;
    double _water_supply;

// submodels
    ecomeristem::plant::water_balance::Swc SWC_model;
    ecomeristem::plant::water_balance::Ftsw FTSW_model;
    ecomeristem::plant::water_balance::Fcstr fcstr_model;
    ecomeristem::plant::water_balance::cstr cstr_model;
    ecomeristem::plant::water_balance::Transpiration transpiration_model;
};

} } } // namespace ecomeristem plant water_balance
