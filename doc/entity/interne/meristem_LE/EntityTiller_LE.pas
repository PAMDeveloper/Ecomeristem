// ---------------------------------------------------------------------------
/// creation et importation d'une entité talle générique pour EcoMeristem_LE
///
/// Description :
//
// ----------------------------------------------------------------------------
(** @Author Ludovic TAMBOUR
    @Version 10/10/06 LT v0.0 version initiale; statut : en cours *)

unit EntityTiller_LE;

// ****************************************************************************
// ****************************************************************************
// ****************************************************************************
// ****************************************************************************
//
// INTERFACE
//
// ****************************************************************************
// ****************************************************************************
// ****************************************************************************
// ****************************************************************************

interface

uses
  SysUtils,
  DateUtils,
  ClassTInstance,
  ClassTEntityInstance,
  ClassTProcInstance,
  ClassTModel,
  FunctionString,
  ClassTPort,
  ClassTAttribute,
  ClassTParameter,
  ClassTAttributeTmp,
  ClassTAttributeTable,
  ClassTAttributeTableIn,
  ClassTAttributeTableOut,
  ClassTAttributeTableInOut,
  FunctionTDateTime,
  ClassTProcInstanceInternal,
  ClassTProcInstanceDLL,
  ClassTManagerInternal,
  ClassTManagerDLL,
  ModuleMeristem,
  ManagerMeristem,
  ModuleMeristem_LE,
  ManagerMeristem_LE,
  DefinitionConstant,
  ClassTExtraProcInstanceInternal;

function ImportTiller_LE(name : string; thresINER, slopeINER, leafStockMax : Double) : TEntityInstance;



// ****************************************************************************
// ****************************************************************************
// ****************************************************************************
// ****************************************************************************
//
// IMPLEMENTATION
//
// ****************************************************************************
// ****************************************************************************
// ****************************************************************************
// ****************************************************************************

implementation

// ----------------------------------------------------------------------------
//  fonction ImportTiller_LE
//  ----------------------
//
/// creation et importation d'une entité talle générique
///
/// Description :
/// Une talle est une entité générique. Ses paramètres sont :
///   - :
///
/// Une talle contient des ports :
///   - (entrée) :
///
/// Une talle contient des attributs internes :
///   - leafNb : nombre de feuilles contenues par la talle
///
/// @param name nom de la nouvelle talle
/// @return nouvelle entité talle de nom 'name' et de parametre
// ---------------------------------------------------------------------------

function ImportTiller_LE(name : string; thresINER, slopeINER, leafStockMax : Double) : TEntityInstance;
var
  entityTiller : TEntityInstance;
  attributeTmp : TAttributeTmp;
  attributeOut : TAttributeTableOut;
  parameterTmp : TParameter;
  procTmp : TProcInstanceInternal;
  XprocTmp : TExtraProcInstanceInternal;
  managerTmp : TManagerInternal;
  initSample : TSample;
begin

	SRwriteln('ImportTiller_LE');

  // ---------------------------
  // creation de 'EntityTiller'
  // ---------------------------
  entityTiller := TEntityInstance.Create('',
                                        ['predimLeafOnMainstem','kIn',
                                        'degreeDayForLeafInitiation','kIn',
                                        'degreeDayForLeafRealization','kIn',
                                        'testIc','kIn',
                                        'fcstr','kIn',
                                        'phenoStage','kIn',
                                        'SLA','kIn',
                                        'plantStock','kIn',
                                        'Tair','kIn',
                                        'plasto_delay','kInOut',
                                        'thresLER','kIn',
                                        'slopeLER','kIn',
                                        'FTSW','kIn',
                                        'boolCrossedPlasto','kIn',
                        				        'lig','kIn',
                                        'P','kIn',
                                        'assimPlant','kIn',
                                        'PAI','kIn']);
  entityTiller.SetName(name);
  entityTiller.SetCategory('Tiller');

  // -----------------------------------------------
  // creation des attributs dans 'EntityTiller'
  // -----------------------------------------------

  attributeTmp := TAttributeTmp.Create('leafNb');
  initSample.date := 0; initSample.value := 0;
  attributeTmp.SetSample(initSample);
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('Lef1');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('predimLeafOnMainstem');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('degreeDayForLeafInitiation');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('degreeDayForLeafRealization');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('degreeDayForInternodeInitiation');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('degreeDayForInternodeRealization');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('testIc');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('fcstr');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('phenoStage');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('SLA');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('plantStock');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('Tair');
  entityTiller.AddTAttribute(attributeTmp);

  parameterTmp := TParameter.Create('zero',0);
  entityTiller.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('thresINER',thresINER);
  entityTiller.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('slopeINER',slopeINER);
  entityTiller.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('leafStockMax',leafStockMax);
  entityTiller.AddTAttribute(parameterTmp);

  attributeTmp := TAttributeTmp.Create('plasto_delay');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('thresLER');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('slopeLER');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('FTSW');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('boolCrossedPlasto');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('lig');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('sumOfTillerLeafBiomass');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('P');
  entityTiller.AddTAttribute(attributeTmp);

  parameterTmp := TParameter.Create('isFirstDayOfPi',1);
  entityTiller.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('one',1);
  entityTiller.AddTAttribute(parameterTmp);

  attributeTmp := TAttributeTmp.Create('assim_tiller');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('supply_tiller');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('reservoir_dispo_tiller');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('surplus_tiller');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('day_demand_tiller');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('deficit_tiller');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('Ic_tiller');
  entityTiller.AddTAttribute(attributeTmp);

  attributeOut := TAttributeTableOut.Create('stock_tiller');
  attributeOut.SetFileNameOut(GetCurrentDir() + '\stock_tiller_' + entityTiller.GetName() + '_out.txt', true);
  entityTiller.AddTAttribute(attributeOut);

  attributeTmp := TAttributeTmp.Create('phenoStageAtPI');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('phenoStageAtFlo');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('TTAtPI');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('sumOfDemandInOrganOnTiller');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('sumOfBladeAreaOnTillerInLeaf');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('sumOfReservoirDispoIN');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('assimPlant');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('sumOfTillerInternodeStock');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('sumOfTillerInternodeDemand');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('stockLeafTiller');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('reservoirDispoLeafTiller');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('demandOfNonINTiller');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('PAI');
  entityTiller.AddTAttribute(attributeTmp);

  // ---------------------------------------------------
  // connection port <-> attribut pour 'EntityTiller'
  // ---------------------------------------------------
  entityTiller.InternalConnect(['predimLeafOnMainstem',
                                'degreeDayForLeafInitiation',
                                'degreeDayForLeafRealization',
                                'testIc',
                                'fcstr',
                                'phenoStage',
                                'SLA',
                                'plantStock',
                                'Tair',
                                'plasto_delay',
                                'thresLER',
                                'slopeLER',
                                'FTSW',
                                'boolCrossedPlasto',
                                'lig',
                                'P',
                                'assimPlant',
                                'PAI']);

  // ---------------------------------------------------
  // ajout d'un manageur
  // ----------------------------------------------------

  managerTmp := TManagerInternal.Create('tillerManager_LE',tillerManager_LE);
  managerTmp.SetExeMode(intra);
  managerTmp.SetExeOrder(1);
  entityTiller.AddTManager(managerTmp);


  procTmp := TProcInstanceInternal.Create('identityDD',IdentityDyn,['inValue','kIn','outValue','kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(2);
  entityTiller.AddTInstance(procTmp);
  procTmp.ExternalConnect(['degreeDayForLeafInitiation','degreeDayForInternodeInitiation']);

  procTmp := TProcInstanceInternal.Create('identityEDD',IdentityDyn,['inValue','kIn','outValue','kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(3);
  entityTiller.AddTInstance(procTmp);
  procTmp.ExternalConnect(['degreeDayForLeafRealization','degreeDayForInternodeRealization']);


  // calcule de la somme des biomass des feuille sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('sumOfBiomassOnTillerInLeafRec1',SumOfBiomassOnTillerInLeafRecDyn,['total', 'kOut']);
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10005);
  XprocTmp.SetActiveState(1);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerLeafBiomass'
  XprocTmp.ExternalConnect(['sumOfTillerLeafBiomass']);

  // calcule de la somme des biomass des feuille sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('sumOfBiomassOnTillerInLeafRec2',SumOfBiomassOnTillerInLeafRecDyn,['total', 'kOut']);
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10006);
  XprocTmp.SetActiveState(2);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerLeafBiomass'
  XprocTmp.ExternalConnect(['sumOfTillerLeafBiomass']);

  // calcule de la somme des biomass des feuille sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('sumOfBiomassOnTillerInLeafRec3',SumOfBiomassOnTillerInLeafRecDyn,['total', 'kOut']);
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10007);
  XprocTmp.SetActiveState(3);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerLeafBiomass'
  XprocTmp.ExternalConnect(['sumOfTillerLeafBiomass']);



  //---------------------------------------//
  // procedure a l etat 4, c est a dire PI //
  //---------------------------------------//

  XprocTmp := TExtraProcInstanceInternal.Create('sumOfBladeAreaOnTillerInLeafRec4', SumOfBladeAreaOnTillerInLeafRecDyn,['total', 'kOut']);
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10010);
  XprocTmp.SetActiveState(4);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfBladeAreaOnTillerInLeaf'
  XprocTmp.ExternalConnect(['sumOfBladeAreaOnTillerInLeaf']);


  // calcule de la somme des biomass des feuille sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('sumOfBiomassOnTillerInLeafRec4',SumOfBiomassOnTillerInLeafRecDyn,['total', 'kOut']);
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10020);
  XprocTmp.SetActiveState(4);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerLeafBiomass'
  XprocTmp.ExternalConnect(['sumOfTillerLeafBiomass']);


  // calcule de la somme des demand des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDemandOnCulmInInternode4',SumOfDemandOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10030);
  XprocTmp.SetActiveState(4);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeDemand'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeDemand']);


  // calcule de la somme des stock des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfStockOnCulmInInternode4',SumOfStockOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10040);
  XprocTmp.SetActiveState(4);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeStock'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeStock']);


  procTmp := TProcInstanceInternal.Create('computeStockLeafCulm_LE4', ComputeStockLeafCulm_LEDyn, ['leafStockMax', 'kIn', 'sumOfBiomassInLeafCulm', 'kIn', 'stockCulm', 'kIn', 'sumOfCulmDemandIN', 'kIn', 'sumOfCulmStockIN', 'kIn', 'stockLeafCulm', 'kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10050);
  procTmp.SetActiveState(4);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'leafStockMax', 'sumOfTillerLeafBiomass', 'stock_tiller', 'sumOfTillerInternodeDemand', 'sumOfTillerInternodeStock', 'stockLeafTiller'
  procTmp.ExternalConnect(['leafStockMax', 'sumOfTillerLeafBiomass', 'stock_tiller', 'sumOfTillerInternodeDemand', 'sumOfTillerInternodeStock', 'stockLeafTiller']);


  procTmp := TProcInstanceInternal.Create('ComputeReservoirDispoLeafCulm_LE4', ComputeReservoirDispoLeafCulm_LEDyn, ['leafStockMax', 'kIn', 'sumOfBiomassInLeafCulm', 'kIn', 'stockLeafCulm', 'kIn', 'reservoirDispoLeafCulm', 'kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10060);
  procTmp.SetActiveState(4);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'leafStockMax', 'sumOfTillerLeafBiomass', 'stockLeafTiller', 'reservoirDispoLeafTiller'
  procTmp.ExternalConnect(['leafStockMax', 'sumOfTillerLeafBiomass', 'stockLeafTiller', 'reservoirDispoLeafTiller']);


  procTmp := TProcInstanceInternal.Create('computeAssimTiller_LE4', ComputeAssimTiller_LEDyn, ['assimPlant', 'kIn', 'sumOfBladeAreaOnTiller', 'kIn', 'sumOfBladeAreaPlant', 'kIn', 'assimTiller', 'kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10070);
  procTmp.SetActiveState(4);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'assimPlant' 'sumOfBladeAreaOnTillerInLeaf' 'sumOfBladeAreaPlant' 'assim_tiller'
  procTmp.ExternalConnect(['assimPlant', 'sumOfBladeAreaOnTillerInLeaf', 'PAI', 'assim_tiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumReservoirDispoInInternodeOnTillerRec4',SumReservoirDispoInInternodeOnTillerRecDyn,['total', 'kOut']);
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10080);
  XprocTmp.SetActiveState(4);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfReservoirDispoIN'
  XprocTmp.ExternalConnect(['sumOfReservoirDispoIN']);


  procTmp := TProcInstanceInternal.Create('computeSupply4', IdentityDyn, ['inValue', 'kIn', 'outValue', 'kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10090);
  procTmp.SetActiveState(4);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'assim_tiller' 'supply_tiller'
  procTmp.ExternalConnect(['assim_tiller', 'supply_tiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('sumOfDemandInOrganOnTillerRec4', SumOfDemandInOrganOnTillerRecDyn,['total', 'kOut']);
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10100);
  XprocTmp.SetActiveState(4);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['day_demand_tiller']);


  procTmp := TProcInstanceInternal.Create('computeReservoirDispo4', Add2ValuesDyn, ['inValue1', 'kIn', 'inValue2', 'kIn', 'outValue', 'kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10110);
  procTmp.SetActiveState(4);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'sumOfReservoirDispoIN', 'reservoirDispoLeafTiller', 'reservoir_dispo_tiller'
  procTmp.ExternalConnect(['sumOfReservoirDispoIN', 'reservoirDispoLeafTiller', 'reservoir_dispo_tiller']);


  procTmp := TProcInstanceInternal.Create('dispReservoirDispoTiller4', DispDyn, ['value', 'kIn']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10120);
  procTmp.SetActiveState(4);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'reservoir_dispo_tiller'
  procTmp.ExternalConnect(['reservoir_dispo_tiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDemandOnCulmInNonInternode4',SumOfDemandOnCulmInNonInternodeDyn,['total', 'kOut']);
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10130);
  XprocTmp.SetActiveState(4);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'demandOfNonINTiller'
  XprocTmp.ExternalConnect(['demandOfNonINTiller']);


  procTmp := TProcInstanceInternal.Create('computeStockTiller_LE4', ComputeStockTiller_LEDyn, ['sumOfStockINTiller', 'kIn', 'stockLeafTiller', 'kIn', 'reservoirDispoTiller', 'kIn', 'supplyTiller', 'kIn', 'sumOfDemandNonINTiller', 'kIn', 'stockTiller', 'kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10140);
  procTmp.SetActiveState(4);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeStock', 'stockLeafTiller', 'reservoir_dispo_tiller', 'supply_tiller', 'sumOfDemandNonINTiller', 'stock_tiller'
  procTmp.ExternalConnect(['sumOfTillerInternodeStock', 'stockLeafTiller', 'reservoir_dispo_tiller', 'supply_tiller', 'demandOfNonINTiller', 'stock_tiller']);


  procTmp := TProcInstanceInternal.Create('computeSurplusTiller_LE4', ComputeSurplusTiller_LEDyn, ['SupplyTiller', 'kIn', 'DemandOfNonINTiller', 'kIn', 'ReservoirDispoTiller', 'kIn', 'SurplusTiller', 'kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10150);
  procTmp.SetActiveState(4);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'supply_tiller' 'demand_tiller' 'reservoir_dispo_tiller' 'surplus_tiller'
  procTmp.ExternalConnect(['supply_tiller', 'demandOfNonINTiller', 'reservoir_dispo_tiller', 'surplus_tiller']);

  //-------------------------------------------//
  // procedure a l etat 5, c est a dire PRE_PI //
  //-------------------------------------------//

  XprocTmp := TExtraProcInstanceInternal.Create('sumOfBladeAreaOnTillerInLeafRec5', SumOfBladeAreaOnTillerInLeafRecDyn,['total', 'kOut']);
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10210);
  XprocTmp.SetActiveState(5);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfBladeAreaOnTillerInLeaf'
  XprocTmp.ExternalConnect(['sumOfBladeAreaOnTillerInLeaf']);


  // calcule de la somme des biomass des feuille sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('sumOfBiomassOnTillerInLeafRec5',SumOfBiomassOnTillerInLeafRecDyn,['total', 'kOut']);
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10220);
  XprocTmp.SetActiveState(5);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerLeafBiomass'
  XprocTmp.ExternalConnect(['sumOfTillerLeafBiomass']);


  // calcule de la somme des demand des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDemandOnCulmInInternode5',SumOfDemandOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10230);
  XprocTmp.SetActiveState(5);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeDemand'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeDemand']);


  // calcule de la somme des stock des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfStockOnCulmInInternode5',SumOfStockOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10240);
  XprocTmp.SetActiveState(5);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeStock'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeStock']);


  procTmp := TProcInstanceInternal.Create('computeStockLeafCulm_LE5', ComputeStockLeafCulm_LEDyn, ['leafStockMax', 'kIn', 'sumOfBiomassInLeafCulm', 'kIn', 'stockCulm', 'kIn', 'sumOfCulmDemandIN', 'kIn', 'sumOfCulmStockIN', 'kIn', 'stockLeafCulm', 'kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10250);
  procTmp.SetActiveState(5);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'leafStockMax', 'sumOfTillerLeafBiomass', 'stock_tiller', 'sumOfTillerInternodeDemand', 'sumOfTillerInternodeStock', 'stockLeafTiller'
  procTmp.ExternalConnect(['leafStockMax', 'sumOfTillerLeafBiomass', 'stock_tiller', 'sumOfTillerInternodeDemand', 'sumOfTillerInternodeStock', 'stockLeafTiller']);


  procTmp := TProcInstanceInternal.Create('ComputeReservoirDispoLeafCulm_LE5', ComputeReservoirDispoLeafCulm_LEDyn, ['leafStockMax', 'kIn', 'sumOfBiomassInLeafCulm', 'kIn', 'stockLeafCulm', 'kIn', 'reservoirDispoLeafCulm', 'kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10260);
  procTmp.SetActiveState(5);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'leafStockMax', 'sumOfTillerLeafBiomass', 'stockLeafTiller', 'reservoirDispoLeafTiller'
  procTmp.ExternalConnect(['leafStockMax', 'sumOfTillerLeafBiomass', 'stockLeafTiller', 'reservoirDispoLeafTiller']);


  procTmp := TProcInstanceInternal.Create('computeAssimTiller_LE5', ComputeAssimTiller_LEDyn, ['assimPlant', 'kIn', 'sumOfBladeAreaOnTiller', 'kIn', 'sumOfBladeAreaPlant', 'kIn', 'assimTiller', 'kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10270);
  procTmp.SetActiveState(5);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'assimPlant' 'sumOfBladeAreaOnTillerInLeaf' 'sumOfBladeAreaPlant' 'assim_tiller'
  procTmp.ExternalConnect(['assimPlant', 'sumOfBladeAreaOnTillerInLeaf', 'PAI', 'assim_tiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumReservoirDispoInInternodeOnTillerRec5',SumReservoirDispoInInternodeOnTillerRecDyn,['total', 'kOut']);
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10280);
  XprocTmp.SetActiveState(5);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfReservoirDispoIN'
  XprocTmp.ExternalConnect(['sumOfReservoirDispoIN']);


  procTmp := TProcInstanceInternal.Create('computeSupply5', IdentityDyn, ['inValue', 'kIn', 'outValue', 'kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10290);
  procTmp.SetActiveState(5);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'assim_tiller' 'supply_tiller'
  procTmp.ExternalConnect(['assim_tiller', 'supply_tiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('sumOfDemandInOrganOnTillerRec5', SumOfDemandInOrganOnTillerRecDyn,['total', 'kOut']);
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10300);
  XprocTmp.SetActiveState(5);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['day_demand_tiller']);


  procTmp := TProcInstanceInternal.Create('computeReservoirDispo5', Add2ValuesDyn, ['inValue1', 'kIn', 'inValue2', 'kIn', 'outValue', 'kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10310);
  procTmp.SetActiveState(5);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'sumOfReservoirDispoIN', 'reservoirDispoLeafTiller', 'reservoir_dispo_tiller'
  procTmp.ExternalConnect(['sumOfReservoirDispoIN', 'reservoirDispoLeafTiller', 'reservoir_dispo_tiller']);


  procTmp := TProcInstanceInternal.Create('dispReservoirDispoTiller5', DispDyn, ['value', 'kIn']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10320);
  procTmp.SetActiveState(5);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'reservoir_dispo_tiller'
  procTmp.ExternalConnect(['reservoir_dispo_tiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDemandOnCulmInNonInternode5',SumOfDemandOnCulmInNonInternodeDyn,['total', 'kOut']);
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10330);
  XprocTmp.SetActiveState(5);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'demandOfNonINTiller'
  XprocTmp.ExternalConnect(['demandOfNonINTiller']);


  procTmp := TProcInstanceInternal.Create('computeStockTiller_LE5', ComputeStockTiller_LEDyn, ['sumOfStockINTiller', 'kIn', 'stockLeafTiller', 'kIn', 'reservoirDispoTiller', 'kIn', 'supplyTiller', 'kIn', 'sumOfDemandNonINTiller', 'kIn', 'stockTiller', 'kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10340);
  procTmp.SetActiveState(5);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeStock', 'stockLeafTiller', 'reservoir_dispo_tiller', 'supply_tiller', 'sumOfDemandNonINTiller', 'stock_tiller'
  procTmp.ExternalConnect(['sumOfTillerInternodeStock', 'stockLeafTiller', 'reservoir_dispo_tiller', 'supply_tiller', 'demandOfNonINTiller', 'stock_tiller']);


  procTmp := TProcInstanceInternal.Create('computeSurplusTiller_LE5', ComputeSurplusTiller_LEDyn, ['SupplyTiller', 'kIn', 'DemandOfNonINTiller', 'kIn', 'ReservoirDispoTiller', 'kIn', 'SurplusTiller', 'kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10350);
  procTmp.SetActiveState(5);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'supply_tiller' 'demand_tiller' 'reservoir_dispo_tiller' 'surplus_tiller'
  procTmp.ExternalConnect(['supply_tiller', 'demandOfNonINTiller', 'reservoir_dispo_tiller', 'surplus_tiller']);

  //--------------------------------------------//
  // procedure a l etat 6, c est a dire PRE_FLO //
  //--------------------------------------------//

  XprocTmp := TExtraProcInstanceInternal.Create('sumOfBladeAreaOnTillerInLeafRec6', SumOfBladeAreaOnTillerInLeafRecDyn,['total', 'kOut']);
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10410);
  XprocTmp.SetActiveState(6);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfBladeAreaOnTillerInLeaf'
  XprocTmp.ExternalConnect(['sumOfBladeAreaOnTillerInLeaf']);


  // calcule de la somme des biomass des feuille sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('sumOfBiomassOnTillerInLeafRec6',SumOfBiomassOnTillerInLeafRecDyn,['total', 'kOut']);
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10420);
  XprocTmp.SetActiveState(6);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerLeafBiomass'
  XprocTmp.ExternalConnect(['sumOfTillerLeafBiomass']);


  // calcule de la somme des demand des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDemandOnCulmInInternode6',SumOfDemandOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10430);
  XprocTmp.SetActiveState(6);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeDemand'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeDemand']);


  // calcule de la somme des stock des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfStockOnCulmInInternode6',SumOfStockOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10440);
  XprocTmp.SetActiveState(6);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeStock'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeStock']);


  procTmp := TProcInstanceInternal.Create('computeStockLeafCulm_LE6', ComputeStockLeafCulm_LEDyn, ['leafStockMax', 'kIn', 'sumOfBiomassInLeafCulm', 'kIn', 'stockCulm', 'kIn', 'sumOfCulmDemandIN', 'kIn', 'sumOfCulmStockIN', 'kIn', 'stockLeafCulm', 'kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10450);
  procTmp.SetActiveState(6);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'leafStockMax', 'sumOfTillerLeafBiomass', 'stock_tiller', 'sumOfTillerInternodeDemand', 'sumOfTillerInternodeStock', 'stockLeafTiller'
  procTmp.ExternalConnect(['leafStockMax', 'sumOfTillerLeafBiomass', 'stock_tiller', 'sumOfTillerInternodeDemand', 'sumOfTillerInternodeStock', 'stockLeafTiller']);


  procTmp := TProcInstanceInternal.Create('ComputeReservoirDispoLeafCulm_LE6', ComputeReservoirDispoLeafCulm_LEDyn, ['leafStockMax', 'kIn', 'sumOfBiomassInLeafCulm', 'kIn', 'stockLeafCulm', 'kIn', 'reservoirDispoLeafCulm', 'kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10460);
  procTmp.SetActiveState(6);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'leafStockMax', 'sumOfTillerLeafBiomass', 'stockLeafTiller', 'reservoirDispoLeafTiller'
  procTmp.ExternalConnect(['leafStockMax', 'sumOfTillerLeafBiomass', 'stockLeafTiller', 'reservoirDispoLeafTiller']);


  procTmp := TProcInstanceInternal.Create('computeAssimTiller_LE6', ComputeAssimTiller_LEDyn, ['assimPlant', 'kIn', 'sumOfBladeAreaOnTiller', 'kIn', 'sumOfBladeAreaPlant', 'kIn', 'assimTiller', 'kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10470);
  procTmp.SetActiveState(6);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'assimPlant' 'sumOfBladeAreaOnTillerInLeaf' 'sumOfBladeAreaPlant' 'assim_tiller'
  procTmp.ExternalConnect(['assimPlant', 'sumOfBladeAreaOnTillerInLeaf', 'PAI', 'assim_tiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumReservoirDispoInInternodeOnTillerRec6',SumReservoirDispoInInternodeOnTillerRecDyn,['total', 'kOut']);
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10480);
  XprocTmp.SetActiveState(6);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfReservoirDispoIN'
  XprocTmp.ExternalConnect(['sumOfReservoirDispoIN']);


  procTmp := TProcInstanceInternal.Create('computeSupply6', IdentityDyn, ['inValue', 'kIn', 'outValue', 'kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10490);
  procTmp.SetActiveState(6);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'assim_tiller' 'supply_tiller'
  procTmp.ExternalConnect(['assim_tiller', 'supply_tiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('sumOfDemandInOrganOnTillerRec6', SumOfDemandInOrganOnTillerRecDyn,['total', 'kOut']);
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10500);
  XprocTmp.SetActiveState(6);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['day_demand_tiller']);


  procTmp := TProcInstanceInternal.Create('computeReservoirDispo6', Add2ValuesDyn, ['inValue1', 'kIn', 'inValue2', 'kIn', 'outValue', 'kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10510);
  procTmp.SetActiveState(6);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'sumOfReservoirDispoIN', 'reservoirDispoLeafTiller', 'reservoir_dispo_tiller'
  procTmp.ExternalConnect(['sumOfReservoirDispoIN', 'reservoirDispoLeafTiller', 'reservoir_dispo_tiller']);


  procTmp := TProcInstanceInternal.Create('dispReservoirDispoTiller6', DispDyn, ['value', 'kIn']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10520);
  procTmp.SetActiveState(6);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'reservoir_dispo_tiller'
  procTmp.ExternalConnect(['reservoir_dispo_tiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDemandOnCulmInNonInternode6',SumOfDemandOnCulmInNonInternodeDyn,['total', 'kOut']);
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10530);
  XprocTmp.SetActiveState(6);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'demandOfNonINTiller'
  XprocTmp.ExternalConnect(['demandOfNonINTiller']);


  procTmp := TProcInstanceInternal.Create('computeStockTiller_LE6', ComputeStockTiller_LEDyn, ['sumOfStockINTiller', 'kIn', 'stockLeafTiller', 'kIn', 'reservoirDispoTiller', 'kIn', 'supplyTiller', 'kIn', 'sumOfDemandNonINTiller', 'kIn', 'stockTiller', 'kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10540);
  procTmp.SetActiveState(6);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeStock', 'stockLeafTiller', 'reservoir_dispo_tiller', 'supply_tiller', 'sumOfDemandNonINTiller', 'stock_tiller'
  procTmp.ExternalConnect(['sumOfTillerInternodeStock', 'stockLeafTiller', 'reservoir_dispo_tiller', 'supply_tiller', 'demandOfNonINTiller', 'stock_tiller']);


  procTmp := TProcInstanceInternal.Create('computeSurplusTiller_LE6', ComputeSurplusTiller_LEDyn, ['SupplyTiller', 'kIn', 'DemandOfNonINTiller', 'kIn', 'ReservoirDispoTiller', 'kIn', 'SurplusTiller', 'kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10550);
  procTmp.SetActiveState(6);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'supply_tiller' 'demand_tiller' 'reservoir_dispo_tiller' 'surplus_tiller'
  procTmp.ExternalConnect(['supply_tiller', 'demandOfNonINTiller', 'reservoir_dispo_tiller', 'surplus_tiller']);

  //----------------------------------------//
  // procedure a l etat 7, c est a dire FLO //
  //-------------------------------- -------//

  XprocTmp := TExtraProcInstanceInternal.Create('sumOfBladeAreaOnTillerInLeafRec7', SumOfBladeAreaOnTillerInLeafRecDyn,['total', 'kOut']);
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10610);
  XprocTmp.SetActiveState(7);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfBladeAreaOnTillerInLeaf'
  XprocTmp.ExternalConnect(['sumOfBladeAreaOnTillerInLeaf']);


  // calcule de la somme des biomass des feuille sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('sumOfBiomassOnTillerInLeafRec7',SumOfBiomassOnTillerInLeafRecDyn,['total', 'kOut']);
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10620);
  XprocTmp.SetActiveState(7);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerLeafBiomass'
  XprocTmp.ExternalConnect(['sumOfTillerLeafBiomass']);


  // calcule de la somme des demand des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDemandOnCulmInInternode7',SumOfDemandOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10630);
  XprocTmp.SetActiveState(7);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeDemand'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeDemand']);


  // calcule de la somme des stock des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfStockOnCulmInInternode7',SumOfStockOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10640);
  XprocTmp.SetActiveState(7);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeStock'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeStock']);


  procTmp := TProcInstanceInternal.Create('computeStockLeafCulm_LE7', ComputeStockLeafCulm_LEDyn, ['leafStockMax', 'kIn', 'sumOfBiomassInLeafCulm', 'kIn', 'stockCulm', 'kIn', 'sumOfCulmDemandIN', 'kIn', 'sumOfCulmStockIN', 'kIn', 'stockLeafCulm', 'kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10650);
  procTmp.SetActiveState(7);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'leafStockMax', 'sumOfTillerLeafBiomass', 'stock_tiller', 'sumOfTillerInternodeDemand', 'sumOfTillerInternodeStock', 'stockLeafTiller'
  procTmp.ExternalConnect(['leafStockMax', 'sumOfTillerLeafBiomass', 'stock_tiller', 'sumOfTillerInternodeDemand', 'sumOfTillerInternodeStock', 'stockLeafTiller']);


  procTmp := TProcInstanceInternal.Create('ComputeReservoirDispoLeafCulm_LE7', ComputeReservoirDispoLeafCulm_LEDyn, ['leafStockMax', 'kIn', 'sumOfBiomassInLeafCulm', 'kIn', 'stockLeafCulm', 'kIn', 'reservoirDispoLeafCulm', 'kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10660);
  procTmp.SetActiveState(7);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'leafStockMax', 'sumOfTillerLeafBiomass', 'stockLeafTiller', 'reservoirDispoLeafTiller'
  procTmp.ExternalConnect(['leafStockMax', 'sumOfTillerLeafBiomass', 'stockLeafTiller', 'reservoirDispoLeafTiller']);


  procTmp := TProcInstanceInternal.Create('computeAssimTiller_LE7', ComputeAssimTiller_LEDyn, ['assimPlant', 'kIn', 'sumOfBladeAreaOnTiller', 'kIn', 'sumOfBladeAreaPlant', 'kIn', 'assimTiller', 'kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10670);
  procTmp.SetActiveState(7);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'assimPlant' 'sumOfBladeAreaOnTillerInLeaf' 'sumOfBladeAreaPlant' 'assim_tiller'
  procTmp.ExternalConnect(['assimPlant', 'sumOfBladeAreaOnTillerInLeaf', 'PAI', 'assim_tiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumReservoirDispoInInternodeOnTillerRec7',SumReservoirDispoInInternodeOnTillerRecDyn,['total', 'kOut']);
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10680);
  XprocTmp.SetActiveState(7);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfReservoirDispoIN'
  XprocTmp.ExternalConnect(['sumOfReservoirDispoIN']);


  procTmp := TProcInstanceInternal.Create('computeSupply7', IdentityDyn, ['inValue', 'kIn', 'outValue', 'kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10690);
  procTmp.SetActiveState(7);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'assim_tiller' 'supply_tiller'
  procTmp.ExternalConnect(['assim_tiller', 'supply_tiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('sumOfDemandInOrganOnTillerRec7', SumOfDemandInOrganOnTillerRecDyn,['total', 'kOut']);
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10700);
  XprocTmp.SetActiveState(7);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['day_demand_tiller']);


  procTmp := TProcInstanceInternal.Create('computeReservoirDispo7', Add2ValuesDyn, ['inValue1', 'kIn', 'inValue2', 'kIn', 'outValue', 'kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10710);
  procTmp.SetActiveState(7);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'sumOfReservoirDispoIN', 'reservoirDispoLeafTiller', 'reservoir_dispo_tiller'
  procTmp.ExternalConnect(['sumOfReservoirDispoIN', 'reservoirDispoLeafTiller', 'reservoir_dispo_tiller']);


  procTmp := TProcInstanceInternal.Create('dispReservoirDispoTiller7', DispDyn, ['value', 'kIn']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10720);
  procTmp.SetActiveState(7);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'reservoir_dispo_tiller'
  procTmp.ExternalConnect(['reservoir_dispo_tiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDemandOnCulmInNonInternode7',SumOfDemandOnCulmInNonInternodeDyn,['total', 'kOut']);
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10730);
  XprocTmp.SetActiveState(7);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'demandOfNonINTiller'
  XprocTmp.ExternalConnect(['demandOfNonINTiller']);


  procTmp := TProcInstanceInternal.Create('computeStockTiller_LE7', ComputeStockTiller_LEDyn, ['sumOfStockINTiller', 'kIn', 'stockLeafTiller', 'kIn', 'reservoirDispoTiller', 'kIn', 'supplyTiller', 'kIn', 'sumOfDemandNonINTiller', 'kIn', 'stockTiller', 'kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10740);
  procTmp.SetActiveState(7);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeStock', 'stockLeafTiller', 'reservoir_dispo_tiller', 'supply_tiller', 'sumOfDemandNonINTiller', 'stock_tiller'
  procTmp.ExternalConnect(['sumOfTillerInternodeStock', 'stockLeafTiller', 'reservoir_dispo_tiller', 'supply_tiller', 'demandOfNonINTiller', 'stock_tiller']);


  procTmp := TProcInstanceInternal.Create('computeSurplusTiller_LE7', ComputeSurplusTiller_LEDyn, ['SupplyTiller', 'kIn', 'DemandOfNonINTiller', 'kIn', 'ReservoirDispoTiller', 'kIn', 'SurplusTiller', 'kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10750);
  procTmp.SetActiveState(7);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'supply_tiller' 'demand_tiller' 'reservoir_dispo_tiller' 'surplus_tiller'
  procTmp.ExternalConnect(['supply_tiller', 'demandOfNonINTiller', 'reservoir_dispo_tiller', 'surplus_tiller']);

  //------------------------------------------//
  // procedure a l etat 9, c est a dire ELONG //
  //------------------------------------------//

  XprocTmp := TExtraProcInstanceInternal.Create('sumOfBladeAreaOnTillerInLeafRec9', SumOfBladeAreaOnTillerInLeafRecDyn,['total', 'kOut']);
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10810);
  XprocTmp.SetActiveState(9);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfBladeAreaOnTillerInLeaf'
  XprocTmp.ExternalConnect(['sumOfBladeAreaOnTillerInLeaf']);


  // calcule de la somme des biomass des feuille sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('sumOfBiomassOnTillerInLeafRec9',SumOfBiomassOnTillerInLeafRecDyn,['total', 'kOut']);
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10820);
  XprocTmp.SetActiveState(9);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerLeafBiomass'
  XprocTmp.ExternalConnect(['sumOfTillerLeafBiomass']);


  // calcule de la somme des demand des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDemandOnCulmInInternode9',SumOfDemandOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10830);
  XprocTmp.SetActiveState(9);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeDemand'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeDemand']);


  // calcule de la somme des stock des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfStockOnCulmInInternode9',SumOfStockOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10840);
  XprocTmp.SetActiveState(9);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeStock'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeStock']);


  procTmp := TProcInstanceInternal.Create('computeStockLeafCulm_LE9', ComputeStockLeafCulm_LEDyn, ['leafStockMax', 'kIn', 'sumOfBiomassInLeafCulm', 'kIn', 'stockCulm', 'kIn', 'sumOfCulmDemandIN', 'kIn', 'sumOfCulmStockIN', 'kIn', 'stockLeafCulm', 'kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10850);
  procTmp.SetActiveState(9);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'leafStockMax', 'sumOfTillerLeafBiomass', 'stock_tiller', 'sumOfTillerInternodeDemand', 'sumOfTillerInternodeStock', 'stockLeafTiller'
  procTmp.ExternalConnect(['leafStockMax', 'sumOfTillerLeafBiomass', 'stock_tiller', 'sumOfTillerInternodeDemand', 'sumOfTillerInternodeStock', 'stockLeafTiller']);


  procTmp := TProcInstanceInternal.Create('ComputeReservoirDispoLeafCulm_LE9', ComputeReservoirDispoLeafCulm_LEDyn, ['leafStockMax', 'kIn', 'sumOfBiomassInLeafCulm', 'kIn', 'stockLeafCulm', 'kIn', 'reservoirDispoLeafCulm', 'kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10860);
  procTmp.SetActiveState(9);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'leafStockMax', 'sumOfTillerLeafBiomass', 'stockLeafTiller', 'reservoirDispoLeafTiller'
  procTmp.ExternalConnect(['leafStockMax', 'sumOfTillerLeafBiomass', 'stockLeafTiller', 'reservoirDispoLeafTiller']);


  procTmp := TProcInstanceInternal.Create('computeAssimTiller_LE9', ComputeAssimTiller_LEDyn, ['assimPlant', 'kIn', 'sumOfBladeAreaOnTiller', 'kIn', 'sumOfBladeAreaPlant', 'kIn', 'assimTiller', 'kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10870);
  procTmp.SetActiveState(9);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'assimPlant' 'sumOfBladeAreaOnTillerInLeaf' 'sumOfBladeAreaPlant' 'assim_tiller'
  procTmp.ExternalConnect(['assimPlant', 'sumOfBladeAreaOnTillerInLeaf', 'PAI', 'assim_tiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumReservoirDispoInInternodeOnTillerRec9',SumReservoirDispoInInternodeOnTillerRecDyn,['total', 'kOut']);
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10880);
  XprocTmp.SetActiveState(9);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfReservoirDispoIN'
  XprocTmp.ExternalConnect(['sumOfReservoirDispoIN']);


  procTmp := TProcInstanceInternal.Create('computeSupply9', IdentityDyn, ['inValue', 'kIn', 'outValue', 'kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10890);
  procTmp.SetActiveState(9);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'assim_tiller' 'supply_tiller'
  procTmp.ExternalConnect(['assim_tiller', 'supply_tiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('sumOfDemandInOrganOnTillerRec9', SumOfDemandInOrganOnTillerRecDyn,['total', 'kOut']);
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10900);
  XprocTmp.SetActiveState(9);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['day_demand_tiller']);


  procTmp := TProcInstanceInternal.Create('computeReservoirDispo9', Add2ValuesDyn, ['inValue1', 'kIn', 'inValue2', 'kIn', 'outValue', 'kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10910);
  procTmp.SetActiveState(9);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'sumOfReservoirDispoIN', 'reservoirDispoLeafTiller', 'reservoir_dispo_tiller'
  procTmp.ExternalConnect(['sumOfReservoirDispoIN', 'reservoirDispoLeafTiller', 'reservoir_dispo_tiller']);


  procTmp := TProcInstanceInternal.Create('dispReservoirDispoTiller9', DispDyn, ['value', 'kIn']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10920);
  procTmp.SetActiveState(9);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'reservoir_dispo_tiller'
  procTmp.ExternalConnect(['reservoir_dispo_tiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDemandOnCulmInNonInternode9',SumOfDemandOnCulmInNonInternodeDyn,['total', 'kOut']);
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10930);
  XprocTmp.SetActiveState(9);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'demandOfNonINTiller'
  XprocTmp.ExternalConnect(['demandOfNonINTiller']);


  procTmp := TProcInstanceInternal.Create('computeStockTiller_LE9', ComputeStockTiller_LEDyn, ['sumOfStockINTiller', 'kIn', 'stockLeafTiller', 'kIn', 'reservoirDispoTiller', 'kIn', 'supplyTiller', 'kIn', 'sumOfDemandNonINTiller', 'kIn', 'stockTiller', 'kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10940);
  procTmp.SetActiveState(9);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeStock', 'stockLeafTiller', 'reservoir_dispo_tiller', 'supply_tiller', 'sumOfDemandNonINTiller', 'stock_tiller'
  procTmp.ExternalConnect(['sumOfTillerInternodeStock', 'stockLeafTiller', 'reservoir_dispo_tiller', 'supply_tiller', 'demandOfNonINTiller', 'stock_tiller']);


  procTmp := TProcInstanceInternal.Create('computeSurplusTiller_LE9', ComputeSurplusTiller_LEDyn, ['SupplyTiller', 'kIn', 'DemandOfNonINTiller', 'kIn', 'ReservoirDispoTiller', 'kIn', 'SurplusTiller', 'kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10950);
  procTmp.SetActiveState(9);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'supply_tiller' 'demand_tiller' 'reservoir_dispo_tiller' 'surplus_tiller'
  procTmp.ExternalConnect(['supply_tiller', 'demandOfNonINTiller', 'reservoir_dispo_tiller', 'surplus_tiller']);


  // retourne la talle créée
  result := entityTiller;

end;
end.
