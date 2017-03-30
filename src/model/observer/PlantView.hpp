/**
 * @file model/observer/PlantView.hpp
 * @author The Ecomeristem Development Team
 * See the AUTHORS file
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

#ifndef MODEL_OBSERVER_PLANT_VIEW_HPP
#define MODEL_OBSERVER_PLANT_VIEW_HPP

#include <artis/observer/View.hpp>
#include <artis/utils/DateTime.hpp>

#include <model/models/ModelParameters.hpp>

namespace model { namespace observer {

class PlantView : public artis::observer::View <
    artis::utils::DoubleTime, model::models::ModelParameters >
{
public:
    PlantView()
    {
        selector("Plant:DD", artis::kernel::DOUBLE, { kernel::KernelModel::ECOMERISTEM,
                    ecomeristem::EcomeristemModel::PLANT,
                    ecomeristem::plant::PlantModel::THERMAL_TIME,
                    ecomeristem::plant::thermal_time::ThermalTimeModel::DD_MODEL,
                    ecomeristem::plant::thermal_time::Dd::DD });
        selector("Plant:EDD", artis::kernel::DOUBLE, { kernel::KernelModel::ECOMERISTEM,
                    ecomeristem::EcomeristemModel::PLANT,
                    ecomeristem::plant::PlantModel::THERMAL_TIME,
                    ecomeristem::plant::thermal_time::ThermalTimeModel::DD_MODEL,
                    ecomeristem::plant::thermal_time::Dd::EDD });
        selector("Plant:IH", artis::kernel::DOUBLE, { kernel::KernelModel::ECOMERISTEM,
                    ecomeristem::EcomeristemModel::PLANT,
                    ecomeristem::plant::PlantModel::THERMAL_TIME,
                    ecomeristem::plant::thermal_time::ThermalTimeModel::IH_MODEL,
                    ecomeristem::plant::thermal_time::Ih::IH });
        selector("Plant:LIGULO_VISU", artis::kernel::DOUBLE, { kernel::KernelModel::ECOMERISTEM,
                    ecomeristem::EcomeristemModel::PLANT,
                    ecomeristem::plant::PlantModel::THERMAL_TIME,
                    ecomeristem::plant::thermal_time::ThermalTimeModel::LIGULO_VISU_MODEL,
                    ecomeristem::plant::thermal_time::LiguloVisu::LIGULO_VISU
                    });
        selector("Plant:PHENO_STAGE", artis::kernel::DOUBLE, { kernel::KernelModel::ECOMERISTEM,
                    ecomeristem::EcomeristemModel::PLANT,
                    ecomeristem::plant::PlantModel::THERMAL_TIME,
                    ecomeristem::plant::thermal_time::ThermalTimeModel::PHENO_STAGE_MODEL,
                    ecomeristem::plant::thermal_time::PhenoStage::PHENO_STAGE
                    });
        selector("Plant:PLASTO_VISU", artis::kernel::DOUBLE, { kernel::KernelModel::ECOMERISTEM,
                    ecomeristem::EcomeristemModel::PLANT,
                    ecomeristem::plant::PlantModel::THERMAL_TIME,
                    ecomeristem::plant::thermal_time::ThermalTimeModel::PLASTO_VISU_MODEL,
                    ecomeristem::plant::thermal_time::PlastoVisu::PLASTO_VISU
                    });
        selector("Plant:TT", artis::kernel::DOUBLE, { kernel::KernelModel::ECOMERISTEM,
                    ecomeristem::EcomeristemModel::PLANT,
                    ecomeristem::plant::PlantModel::THERMAL_TIME,
                    ecomeristem::plant::thermal_time::ThermalTimeModel::TT_MODEL,
                    ecomeristem::plant::thermal_time::Tt::TT
                    });
        selector("Plant:TT_LIG", artis::kernel::DOUBLE, { kernel::KernelModel::ECOMERISTEM,
                    ecomeristem::EcomeristemModel::PLANT,
                    ecomeristem::plant::PlantModel::THERMAL_TIME,
                    ecomeristem::plant::thermal_time::ThermalTimeModel::TT_LIG_MODEL,
                    ecomeristem::plant::thermal_time::TT_lig::TT_LIG
                    });

        selector("Plant:CSTR", artis::kernel::DOUBLE, { kernel::KernelModel::ECOMERISTEM,
                    ecomeristem::EcomeristemModel::PLANT,
                    ecomeristem::plant::PlantModel::WATER_BALANCE,
                    ecomeristem::plant::water_balance::WaterBalanceModel::CSTR_MODEL,
                    ecomeristem::plant::water_balance::cstr::CSTR });

        selector("Plant:ASSIM", artis::kernel::DOUBLE, { kernel::KernelModel::ECOMERISTEM,
                    ecomeristem::EcomeristemModel::PLANT,
                    ecomeristem::plant::PlantModel::ASSIMILATION,
                    ecomeristem::plant::assimilation::PlantAssimilationModel::ASSIM_MODEL,
                    ecomeristem::plant::assimilation::Assim::ASSIM });

        selector("Plant:SUPPLY", artis::kernel::DOUBLE, { kernel::KernelModel::ECOMERISTEM,
                    ecomeristem::EcomeristemModel::PLANT,
                    ecomeristem::plant::PlantModel::STOCK,
                    ecomeristem::plant::stock::PlantStockModel::SUPPLY_MODEL,
                    ecomeristem::plant::stock::PlantSupply::SUPPLY });
        selector("Plant:IC", artis::kernel::DOUBLE, { kernel::KernelModel::ECOMERISTEM,
                    ecomeristem::EcomeristemModel::PLANT,
                    ecomeristem::plant::PlantModel::STOCK,
                    ecomeristem::plant::stock::PlantStockModel::IC_MODEL,
                    ecomeristem::plant::stock::IndexCompetition::IC });
        selector("Plant:STOCK", artis::kernel::DOUBLE, { kernel::KernelModel::ECOMERISTEM,
                    ecomeristem::EcomeristemModel::PLANT,
                    ecomeristem::plant::PlantModel::STOCK,
                    ecomeristem::plant::stock::PlantStockModel::STOCK_MODEL,
                    ecomeristem::plant::stock::PlantStock::STOCK });
        selector("Plant:SURPLUS", artis::kernel::DOUBLE, { kernel::KernelModel::ECOMERISTEM,
                    ecomeristem::EcomeristemModel::PLANT,
                    ecomeristem::plant::PlantModel::STOCK,
                    ecomeristem::plant::stock::PlantStockModel::SURPLUS_MODEL,
                    ecomeristem::plant::stock::StockSurplus::SURPLUS });
        selector("Plant:DEFICIT", artis::kernel::DOUBLE, { kernel::KernelModel::ECOMERISTEM,
                    ecomeristem::EcomeristemModel::PLANT,
                    ecomeristem::plant::PlantModel::STOCK,
                    ecomeristem::plant::stock::PlantStockModel::STOCK_MODEL,
                    ecomeristem::plant::stock::PlantStock::DEFICIT });
        selector("Plant:RESERVOIR_DISPO", artis::kernel::DOUBLE, { kernel::KernelModel::ECOMERISTEM,
                    ecomeristem::EcomeristemModel::PLANT,
                    ecomeristem::plant::PlantModel::STOCK,
                    ecomeristem::plant::stock::PlantStockModel::RESERVOIR_DISPO_MODEL,
                    ecomeristem::plant::stock::ReservoirDispo::RESERVOIR_DISPO
                    });
        selector("Plant:DAY_DEMAND", artis::kernel::DOUBLE, { kernel::KernelModel::ECOMERISTEM,
                    ecomeristem::EcomeristemModel::PLANT,
                    ecomeristem::plant::PlantModel::STOCK,
                    ecomeristem::plant::stock::PlantStockModel::DAY_DEMAND_MODEL,
                    ecomeristem::plant::stock::DayDemand::DAY_DEMAND });
        selector("Plant:SEED_RES", artis::kernel::DOUBLE, { kernel::KernelModel::ECOMERISTEM,
                    ecomeristem::EcomeristemModel::PLANT,
                    ecomeristem::plant::PlantModel::STOCK,
                    ecomeristem::plant::stock::PlantStockModel::SEED_RES_MODEL,
                    ecomeristem::plant::stock::SeedRes::SEED_RES });

        selector("Plant:ROOT_DEMAND_COEF", artis::kernel::DOUBLE, { kernel::KernelModel::ECOMERISTEM,
                    ecomeristem::EcomeristemModel::PLANT,
                    ecomeristem::plant::PlantModel::ROOT,
                    ecomeristem::root::RootModel::ROOT_DEMAND_COEF_MODEL,
                    ecomeristem::root::RootDemandCoef::ROOT_DEMAND_COEF });

        selector("Plant:ROOT_BIOMASS", artis::kernel::DOUBLE, { kernel::KernelModel::ECOMERISTEM,
                    ecomeristem::EcomeristemModel::PLANT,
                    ecomeristem::plant::PlantModel::ROOT,
                    ecomeristem::root::RootModel::ROOT_DEMAND_MODEL,
                    ecomeristem::root::RootDemand::ROOT_BIOMASS });
        selector("Plant:ROOT_DEMAND", artis::kernel::DOUBLE, { kernel::KernelModel::ECOMERISTEM,
                    ecomeristem::EcomeristemModel::PLANT,
                    ecomeristem::plant::PlantModel::ROOT,
                    ecomeristem::root::RootModel::ROOT_DEMAND_MODEL,
                    ecomeristem::root::RootDemand::ROOT_DEMAND });

        selector("Plant:SLA", artis::kernel::DOUBLE, { kernel::KernelModel::ECOMERISTEM,
                    ecomeristem::EcomeristemModel::PLANT,
                    ecomeristem::plant::PlantModel::SLA,
                    ecomeristem::plant::Sla::SLA });

        selector("Plant:LEAF_BIOMASS_SUM", artis::kernel::DOUBLE, { kernel::KernelModel::ECOMERISTEM,
                    ecomeristem::EcomeristemModel::PLANT,
                    ecomeristem::plant::PlantModel::LEAF_BIOMASS_SUM });
        selector("Plant:INTERNODE_BIOMASS_SUM", artis::kernel::DOUBLE,
                 { kernel::KernelModel::ECOMERISTEM,
                         ecomeristem::EcomeristemModel::PLANT,
                         ecomeristem::plant::PlantModel::INTERNODE_BIOMASS_SUM });
        selector("Plant:SENESC_DW_SUM", artis::kernel::DOUBLE, { kernel::KernelModel::ECOMERISTEM,
                    ecomeristem::EcomeristemModel::PLANT,
                    ecomeristem::plant::PlantModel::SENESC_DW_SUM });
        selector("Plant:LEAF_LAST_DEMAND_SUM", artis::kernel::DOUBLE,
                 { kernel::KernelModel::ECOMERISTEM,
                         ecomeristem::EcomeristemModel::PLANT,
                         ecomeristem::plant::PlantModel::LEAF_LAST_DEMAND_SUM });
        selector("Plant:INTERNODE_LAST_DEMAND_SUM", artis::kernel::DOUBLE,
                 { kernel::KernelModel::ECOMERISTEM,
                         ecomeristem::EcomeristemModel::PLANT,
                         ecomeristem::plant::PlantModel::INTERNODE_LAST_DEMAND_SUM
                         });
        selector("Plant:LEAF_DEMAND_SUM", artis::kernel::DOUBLE,
                 { kernel::KernelModel::ECOMERISTEM,
                         ecomeristem::EcomeristemModel::PLANT,
                         ecomeristem::plant::PlantModel::LEAF_DEMAND_SUM });
        selector("Plant:INTERNODE_DEMAND_SUM", artis::kernel::DOUBLE,
                 { kernel::KernelModel::ECOMERISTEM,
                         ecomeristem::EcomeristemModel::PLANT,
                         ecomeristem::plant::PlantModel::INTERNODE_DEMAND_SUM
                         });

    }

    virtual ~PlantView()
    { }
};

} }

#endif
