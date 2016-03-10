/**
 * @file model/observer/PlantView.hpp
 * @author The Ecomeristem Development Team
 * See the AUTHORS file
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

#ifndef MODEL_OBSERVER_PLANT_VIEW_HPP
#define MODEL_OBSERVER_PLANT_VIEW_HPP

#include <model/observer/View.hpp>

namespace model { namespace observer {

class PlantView : public View
{
public:
    PlantView()
    {
        selector("Plant:DD", { kernel::Model::ECOMERISTEM,
                    ecomeristem::Model::PLANT,
                    ecomeristem::plant::Model::THERMAL_TIME,
                    ecomeristem::plant::thermal_time::Model::DD_MODEL,
                    ecomeristem::plant::thermal_time::Dd::DD });
        selector("Plant:EDD", { kernel::Model::ECOMERISTEM,
                    ecomeristem::Model::PLANT,
                    ecomeristem::plant::Model::THERMAL_TIME,
                    ecomeristem::plant::thermal_time::Model::DD_MODEL,
                    ecomeristem::plant::thermal_time::Dd::EDD });
        selector("Plant:IH", { kernel::Model::ECOMERISTEM,
                    ecomeristem::Model::PLANT,
                    ecomeristem::plant::Model::THERMAL_TIME,
                    ecomeristem::plant::thermal_time::Model::IH_MODEL,
                    ecomeristem::plant::thermal_time::Ih::IH });
        selector("Plant:LIGULO_VISU", { kernel::Model::ECOMERISTEM,
                    ecomeristem::Model::PLANT,
                    ecomeristem::plant::Model::THERMAL_TIME,
                    ecomeristem::plant::thermal_time::Model::LIGULO_VISU_MODEL,
                    ecomeristem::plant::thermal_time::LiguloVisu::LIGULO_VISU
                    });
        selector("Plant:PHENO_STAGE", { kernel::Model::ECOMERISTEM,
                    ecomeristem::Model::PLANT,
                    ecomeristem::plant::Model::THERMAL_TIME,
                    ecomeristem::plant::thermal_time::Model::PHENO_STAGE_MODEL,
                    ecomeristem::plant::thermal_time::PhenoStage::PHENO_STAGE
                    });
        selector("Plant:PLASTO_VISU", { kernel::Model::ECOMERISTEM,
                    ecomeristem::Model::PLANT,
                    ecomeristem::plant::Model::THERMAL_TIME,
                    ecomeristem::plant::thermal_time::Model::PLASTO_VISU_MODEL,
                    ecomeristem::plant::thermal_time::PlastoVisu::PLASTO_VISU
                    });
        selector("Plant:TT", { kernel::Model::ECOMERISTEM,
                    ecomeristem::Model::PLANT,
                    ecomeristem::plant::Model::THERMAL_TIME,
                    ecomeristem::plant::thermal_time::Model::TT_MODEL,
                    ecomeristem::plant::thermal_time::Tt::TT
                    });
        selector("Plant:TT_LIG", { kernel::Model::ECOMERISTEM,
                    ecomeristem::Model::PLANT,
                    ecomeristem::plant::Model::THERMAL_TIME,
                    ecomeristem::plant::thermal_time::Model::TT_LIG_MODEL,
                    ecomeristem::plant::thermal_time::TT_lig::TT_LIG
                    });

        selector("Plant:CSTR", { kernel::Model::ECOMERISTEM,
                    ecomeristem::Model::PLANT,
                    ecomeristem::plant::Model::WATER_BALANCE,
                    ecomeristem::plant::water_balance::Model::CSTR_MODEL,
                    ecomeristem::plant::water_balance::cstr::CSTR });

        selector("Plant:ASSIM", { kernel::Model::ECOMERISTEM,
                    ecomeristem::Model::PLANT,
                    ecomeristem::plant::Model::ASSIMILATION,
                    ecomeristem::plant::assimilation::Model::ASSIM_MODEL,
                    ecomeristem::plant::assimilation::Assim::ASSIM });

        selector("Plant:SUPPLY", { kernel::Model::ECOMERISTEM,
                    ecomeristem::Model::PLANT,
                    ecomeristem::plant::Model::STOCK,
                    ecomeristem::plant::stock::Model::SUPPLY_MODEL,
                    ecomeristem::plant::stock::Supply::SUPPLY });
        selector("Plant:IC", { kernel::Model::ECOMERISTEM,
                    ecomeristem::Model::PLANT,
                    ecomeristem::plant::Model::STOCK,
                    ecomeristem::plant::stock::Model::IC_MODEL,
                    ecomeristem::plant::stock::IndexCompetition::IC });
        selector("Plant:STOCK", { kernel::Model::ECOMERISTEM,
                    ecomeristem::Model::PLANT,
                    ecomeristem::plant::Model::STOCK,
                    ecomeristem::plant::stock::Model::STOCK_MODEL,
                    ecomeristem::plant::stock::Stock::STOCK });
        selector("Plant:SURPLUS", { kernel::Model::ECOMERISTEM,
                    ecomeristem::Model::PLANT,
                    ecomeristem::plant::Model::STOCK,
                    ecomeristem::plant::stock::Model::SURPLUS_MODEL,
                    ecomeristem::plant::stock::Surplus::SURPLUS });
        selector("Plant:DEFICIT", { kernel::Model::ECOMERISTEM,
                    ecomeristem::Model::PLANT,
                    ecomeristem::plant::Model::STOCK,
                    ecomeristem::plant::stock::Model::STOCK_MODEL,
                    ecomeristem::plant::stock::Stock::DEFICIT });
        selector("Plant:RESERVOIR_DISPO", { kernel::Model::ECOMERISTEM,
                    ecomeristem::Model::PLANT,
                    ecomeristem::plant::Model::STOCK,
                    ecomeristem::plant::stock::Model::RESERVOIR_DISPO_MODEL,
                    ecomeristem::plant::stock::ReservoirDispo::RESERVOIR_DISPO
                    });
        selector("Plant:DAY_DEMAND", { kernel::Model::ECOMERISTEM,
                    ecomeristem::Model::PLANT,
                    ecomeristem::plant::Model::STOCK,
                    ecomeristem::plant::stock::Model::DAY_DEMAND_MODEL,
                    ecomeristem::plant::stock::DayDemand::DAY_DEMAND });
        selector("Plant:SEED_RES", { kernel::Model::ECOMERISTEM,
                    ecomeristem::Model::PLANT,
                    ecomeristem::plant::Model::STOCK,
                    ecomeristem::plant::stock::Model::SEED_RES_MODEL,
                    ecomeristem::plant::stock::SeedRes::SEED_RES });

        selector("Plant:ROOT_DEMAND_COEF", { kernel::Model::ECOMERISTEM,
                    ecomeristem::Model::PLANT,
                    ecomeristem::plant::Model::ROOT,
                    ecomeristem::root::Model::ROOT_DEMAND_COEF_MODEL,
                    ecomeristem::root::RootDemandCoef::ROOT_DEMAND_COEF });

        selector("Plant:ROOT_BIOMASS", { kernel::Model::ECOMERISTEM,
                    ecomeristem::Model::PLANT,
                    ecomeristem::plant::Model::ROOT,
                    ecomeristem::root::Model::ROOT_DEMAND_MODEL,
                    ecomeristem::root::RootDemand::ROOT_BIOMASS });

        selector("Plant:SLA", { kernel::Model::ECOMERISTEM,
                    ecomeristem::Model::PLANT,
                    ecomeristem::plant::Model::SLA,
                    ecomeristem::plant::Sla::SLA });
    }

    virtual ~PlantView()
    { }
};

} }

#endif
