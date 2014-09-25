/**
 * @file ecomeristem/plant/Model.hpp
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

#include <model/models/ecomeristem/culm/Model.hpp>

#include <model/models/ecomeristem/plant/Lig.hpp>
#include <model/models/ecomeristem/plant/Manager.hpp>
#include <model/models/ecomeristem/plant/TillerManager.hpp>
#include <model/models/ecomeristem/plant/assimilation/Model.hpp>
#include <model/models/ecomeristem/root/Model.hpp>
#include <model/models/ecomeristem/plant/SLA.hpp>
#include <model/models/ecomeristem/plant/stock/Model.hpp>
#include <model/models/ecomeristem/plant/thermal-time/Model.hpp>
#include <model/models/ecomeristem/plant/water-balance/Model.hpp>
#include <model/kernel/AbstractCoupledModel.hpp>

#include <iostream>

namespace ecomeristem { namespace plant {

class Model : public AbstractCoupledModel < Model >
{
public:
    static const int LAI = 0;
    static const int DELTA_T = 1;
    static const int DD = 2;
    static const int EDD = 3;
    static const int IH = 4;
    static const int LIGULO_VISU = 5;
    static const int PHENO_STAGE = 6;
    static const int PLASTO_VISU = 7;
    static const int TT = 8;
    static const int TT_LIG = 9;
    static const int BOOL_CROSSED_PLASTO = 10;
    static const int ASSIM = 11;
    static const int CSTR = 12;

    static const int ETP = 0;
    static const int P = 1;
    static const int RADIATION = 2;
    static const int TA = 3;
    static const int WATER_SUPPLY = 4;

    Model()
    {
        internal(LAI, &assimilation_model, plant::assimilation::Model::LAI);
        internal(DELTA_T, &thermal_time_model,
                 plant::thermal_time::Model::DELTA_T);
        internal(BOOL_CROSSED_PLASTO, &thermal_time_model,
                 plant::thermal_time::Model::BOOL_CROSSED_PLASTO);
        internal(DD, &thermal_time_model, plant::thermal_time::Model::DD);
        internal(EDD, &thermal_time_model, plant::thermal_time::Model::EDD);
        internal(IH, &thermal_time_model, plant::thermal_time::Model::IH);
        internal(LIGULO_VISU, &thermal_time_model,
                 plant::thermal_time::Model::LIGULO_VISU);
        internal(PHENO_STAGE, &thermal_time_model,
                 plant::thermal_time::Model::PHENO_STAGE);
        internal(PLASTO_VISU, &thermal_time_model,
                 plant::thermal_time::Model::PLASTO_VISU);
        internal(TT, &thermal_time_model, plant::thermal_time::Model::TT);
        internal(TT_LIG, &thermal_time_model,
                 plant::thermal_time::Model::TT_LIG);
        internal(ASSIM, &assimilation_model,
                 plant::assimilation::Model::ASSIM);
        internal(CSTR, &water_balance_model,
                 plant::water_balance::Model::CSTR);

        external(ETP, &Model::_etp);
        external(P, &Model::_p);
        external(RADIATION, &Model::_radiation);
        external(TA, &Model::_ta);
        external(WATER_SUPPLY, &Model::_water_supply);
     }

    virtual ~Model()
    { }

    void build()
    { }

    void init(double t, const model::models::ModelParameters& parameters)
    {
        assimilation_model.init(t, parameters);
        root_model.init(t, parameters);
        stock_model.init(t, parameters);
        thermal_time_model.init(t, parameters);
        water_balance_model.init(t, parameters);
        manager_model.init(t, parameters);
        tiller_manager_model.init(t, parameters);
        lig_model.init(t, parameters);
        sla_model.init(t, parameters);

        culm::Model* meristem = new culm::Model();

        meristem->init(t, parameters);
        culm_models.push_back(meristem);
    }

    void compute(double t)
    {
        lig_model.compute(t);

        compute_thermal_time(t);

        sla_model.put(t, Sla::PHENO_STAGE, thermal_time_model.get(
                          thermal_time::Model::PHENO_STAGE));
        sla_model.compute(t);

        // std::cout << "*********************************" << std::endl;

        compute_assimilation(t);
        compute_water_balance(t);
        compute_assimilation(t);
        compute_water_balance(t);

        // std::cout << "*********************************" << std::endl;

        root_model.compute(t);

        manager_model.put(t, Manager::STOCK, 0.1);
        manager_model.put(t, Manager::PHENO_STAGE, thermal_time_model.get(
                              thermal_time::Model::PHENO_STAGE));
        manager_model.put(t, Manager::BOOL_CROSSED_PLASTO,
                          thermal_time_model.get(
                              thermal_time::Model::BOOL_CROSSED_PLASTO));
        manager_model.put(t, Manager::FTSW,
                          water_balance_model.get(water_balance::Model::FTSW));
        manager_model.put(t, Manager::IC, 0);
        // manager_model.compute(t);

        tiller_manager_model.put(t, TillerManager::BOOL_CROSSED_PLASTO,
                                 thermal_time_model.get(
                                     thermal_time::Model::BOOL_CROSSED_PLASTO));
        tiller_manager_model.put(t, TillerManager::PHENO_STAGE,
                                 thermal_time_model.get(
                                     thermal_time::Model::PHENO_STAGE));
        tiller_manager_model.put(t, TillerManager::IC, 0);
        tiller_manager_model.compute(t);

        std::vector < culm::Model* >::const_iterator it = culm_models.begin();
        while (it != culm_models.begin()) {
            (*it)->compute(t);
        }
    }

private:
    void compute_assimilation(double t)
    {
        assimilation_model.put(t, assimilation::Model::FCSTR,
                               water_balance_model.get(
                                   water_balance::Model::FCSTR));
        assimilation_model.put(t,
                               assimilation::Model::INTERNODE_BIOMASS, 0);
        assimilation_model.put(t, assimilation::Model::LEAF_BIOMASS,
                               9.40183908045977E-5);
        // TODO: PAI
        assimilation_model.put(t, assimilation::Model::PAI,
                               0.0253849655172414);
        assimilation_model.put(t,
                               assimilation::Model::RADIATION, _radiation);
        assimilation_model.put(t, assimilation::Model::TA, _ta);
        assimilation_model.put(t, assimilation::Model::CSTR,
                               water_balance_model.get(
                                   water_balance::Model::CSTR));
        assimilation_model.compute(t);
    }

    void compute_thermal_time(double t)
    {
        thermal_time_model.put(t, thermal_time::Model::STOCK,
                               3.76073563218391E-5);
        // stock_model.get(stock::Model::STOCK));
        thermal_time_model.put(t, thermal_time::Model::TA, _ta);
        thermal_time_model.put(t, thermal_time::Model::GROW, 0);
        // stock_model.get(stock::Model::GROW));
        thermal_time_model.put(t, thermal_time::Model::LIG,
                               lig_model.get(Lig::LIG));
        thermal_time_model.put(t, thermal_time::Model::PLASTO_DELAY, 0);
        thermal_time_model.compute(t);
    }

    void compute_water_balance(double t)
    {
        water_balance_model.put(t, water_balance::Model::ETP, _etp);
        water_balance_model.put(t, water_balance::Model::INTERC,
                                assimilation_model.get(
                                    assimilation::Model::INTERC));
        water_balance_model.put(t, water_balance::Model::WATER_SUPPLY,
                                _water_supply);
        water_balance_model.compute(t);
    }

// external variables
    double _etp;
    double _p;
    double _radiation;
    double _ta;
    double _water_supply;

// submodels
    ecomeristem::plant::assimilation::Model assimilation_model;
    ecomeristem::root::Model root_model;
    ecomeristem::plant::stock::Model stock_model;
    ecomeristem::plant::thermal_time::Model thermal_time_model;
    ecomeristem::plant::water_balance::Model water_balance_model;
    ecomeristem::plant::Manager manager_model;
    ecomeristem::plant::TillerManager tiller_manager_model;
    ecomeristem::plant::Lig lig_model;
    ecomeristem::plant::Sla sla_model;

    std::vector < culm::Model* > culm_models;
};

} } // namespace ecomeristem plant
