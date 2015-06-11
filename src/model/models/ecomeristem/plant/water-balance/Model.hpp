/**
 * @file ecomeristem/plant/thermal-time/Model.hpp
 * @author The Ecomeristem Development Team
 * See the AUTHORS or Authors.txt file
 */

/*
 * Copyright (C) 2005-2015 Cirad http://www.cirad.fr
 * Copyright (C) 2012-2015 ULCO http://www.univ-littoral.fr
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

class Model : public AbstractCoupledModel < Model >
{
public:
    static const int ETP = 0;
    static const int INTERC = 1;
    static const int WATER_SUPPLY = 2;

    static const int CSTR = 0;
    static const int FCSTR = 1;
    static const int FTSW = 2;

    Model()
    {
        external(ETP, &Model::_etp);
        external(INTERC, &Model::_interc);
        external(WATER_SUPPLY, &Model::_water_supply);

        internal(CSTR, &cstr_model, cstr::CSTR);
        internal(FCSTR, &fcstr_model, Fcstr::FCSTR);
        internal(FTSW, &FTSW_model, Ftsw::FTSW);
    }

    virtual ~Model()
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

        cstr_model.put(t, cstr::FTSW, FTSW_model.get(t, Ftsw::FTSW));
        cstr_model(t);

        fcstr_model.put(t, Fcstr::CSTR, cstr_model.get(t, cstr::CSTR));
        fcstr_model(t);

        if (is_ready(t, INTERC)) {
            transpiration_model.put(t, Transpiration::ETP, _etp);
            transpiration_model.put(t, Transpiration::INTERC, _interc);
            transpiration_model.put(t, Transpiration::CSTR,
                                    cstr_model.get(t, cstr::CSTR));
            transpiration_model(t);

            SWC_model.put(t, Swc::WATER_SUPPLY, _water_supply);
            SWC_model.put(t, Swc::DELTA_P,
                          transpiration_model.get(t,
                              Transpiration::TRANSPIRATION));
            SWC_model(t);
            FTSW_model.put(t, Ftsw::SWC, SWC_model.get(t, Swc::SWC));
            transpiration_model.put(t, Transpiration::SWC,
                                    SWC_model.get(t, Swc::SWC));
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
