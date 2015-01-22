// ---------------------------------------------------------------------------
/// creation et importation d'une entité talle générique pour EcoMeristem_LE
///
/// Description :
//
// ----------------------------------------------------------------------------
(** @Author JC Soulié
    @Version 14/06/10 LT v0.0 version initiale; statut : en cours *)

unit EntityTillerPhytomer_LE;

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

function ImportTillerPhytomer_LE(name : string; thresINER, slopeINER, leafStockMax : Double) : TEntityInstance;



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

function ImportTillerPhytomer_LE(name : string; thresINER, slopeINER, leafStockMax : Double) : TEntityInstance;
var
  entityTiller : TEntityInstance;
  attributeTmp : TAttributeTmp;
  parameterTmp : TParameter;
  procTmp : TProcInstanceInternal;
  XprocTmp : TExtraProcInstanceInternal;
  managerTmp : TManagerInternal;
  initSample : TSample;
begin

	SRwriteln('ImportTillerPhytomer_LE');

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

  attributeTmp := TAttributeTmp.Create('activeLeavesNb');
  initSample.date := 0; initSample.value := 0;
  attributeTmp.SetSample(initSample);
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('internodeNb');
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

  parameterTmp := TParameter.Create('leafStockMax', leafStockMax);
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

  attributeTmp := TAttributeTmp.Create('last_demand_tiller');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('Ic_tiller');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('max_reservoir_tiller');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('deficit_tiller');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('tmp_tiller');
  entityTiller.AddTAttribute(attributeTmp);

  // attributeOut := TAttributeTableOut.Create('stock_tiller');
  // attributeOut.SetFileNameOut(GetCurrentDir() + '\stock_tiller_' + entityTiller.GetName() + '_out.txt', true);
  // entityTiller.AddTAttribute(attributeOut);

  attributeTmp := TAttributeTmp.Create('stock_tiller');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('phenoStageAtPI');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('phenoStageAtFlo');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('phenoStageAtPreFlo');
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

  attributeTmp := TAttributeTmp.Create('sumOfTillerInternodeBiomass');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('stockLeafTiller');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('reservoirDispoLeafTiller');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('sumOfTillerInternodeDeficit');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('demandOfNonINTiller');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('PAI');
  entityTiller.AddTAttribute(attributeTmp);

  initSample.date := 0; initSample.value := 0;
  attributeTmp := TAttributeTmp.Create('sumOfBiomassOnInternodeInMatureState', initSample);
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('leaf_internode_biomass_tiller');
  entityTiller.AddTAttribute(attributeTmp);

   attributeTmp := TAttributeTmp.Create('sumOfDailySenescedLeafBiomassTiller');
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

  managerTmp := TManagerInternal.Create('tillerManagerPhytomer_LE',TillerManagerPhytomer_LE);
  managerTmp.SetFunctName('TillerManagerPhytomer_LE');
  managerTmp.SetExeMode(intra);
  managerTmp.SetExeOrder(1);
  entityTiller.AddTManager(managerTmp);


  procTmp := TProcInstanceInternal.Create('identityDD',IdentityDyn,['inValue','kIn','outValue','kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(2);
  entityTiller.AddTInstance(procTmp);
  procTmp.ExternalConnect(['degreeDayForLeafInitiation','degreeDayForInternodeInitiation']);

  procTmp := TProcInstanceInternal.Create('identityEDD',IdentityDyn,['inValue','kIn','outValue','kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(3);
  entityTiller.AddTInstance(procTmp);
  procTmp.ExternalConnect(['degreeDayForLeafRealization','degreeDayForInternodeRealization']);


  // calcule de la somme des biomass des feuille sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('sumOfBiomassOnTillerInLeafRec1',SumOfBiomassOnTillerInLeafRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfBiomassOnTillerInLeafRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10005);
  XprocTmp.SetActiveState(1);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerLeafBiomass'
  XprocTmp.ExternalConnect(['sumOfTillerLeafBiomass']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDailySenescedLeafBiomassOnCulm1', SumOfDailySenescedLeafBiomassOnCulmDyn,['sumOfDailySenescedLeafBiomass', 'kOut']);
  XprocTmp.SetProcName('SumOfDailySenescedLeafBiomassOnCulm');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10006);
  XprocTmp.SetActiveState(1);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['sumOfDailySenescedLeafBiomassTiller']);


  // calcule de la somme des biomass des feuille sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('sumOfBiomassOnTillerInLeafRec2',SumOfBiomassOnTillerInLeafRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfBiomassOnTillerInLeafRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10007);
  XprocTmp.SetActiveState(2);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerLeafBiomass'
  XprocTmp.ExternalConnect(['sumOfTillerLeafBiomass']);

  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDailySenescedLeafBiomassOnCulm2', SumOfDailySenescedLeafBiomassOnCulmDyn,['sumOfDailySenescedLeafBiomass', 'kOut']);
  XprocTmp.SetProcName('SumOfDailySenescedLeafBiomassOnCulm');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10008);
  XprocTmp.SetActiveState(2);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['sumOfDailySenescedLeafBiomassTiller']);

  // calcule de la somme des biomass des feuille sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('sumOfBiomassOnTillerInLeafRec3',SumOfBiomassOnTillerInLeafRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfBiomassOnTillerInLeafRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10008);
  XprocTmp.SetActiveState(3);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerLeafBiomass'
  XprocTmp.ExternalConnect(['sumOfTillerLeafBiomass']);

  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDailySenescedLeafBiomassOnCulm3', SumOfDailySenescedLeafBiomassOnCulmDyn,['sumOfDailySenescedLeafBiomass', 'kOut']);
  XprocTmp.SetProcName('SumOfDailySenescedLeafBiomassOnCulm');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10009);
  XprocTmp.SetActiveState(3);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['sumOfDailySenescedLeafBiomassTiller']);



  //---------------------------------------//
  // procedure a l etat 4, c est a dire PI //
  //---------------------------------------//

  XprocTmp := TExtraProcInstanceInternal.Create('sumOfBladeAreaOnTillerInLeafRec4', SumOfBladeAreaOnTillerInLeafRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfBladeAreaOnTillerInLeafRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10010);
  XprocTmp.SetActiveState(4);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfBladeAreaOnTillerInLeaf'
  XprocTmp.ExternalConnect(['sumOfBladeAreaOnTillerInLeaf']);


  // calcule de la somme des biomass des feuille sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('sumOfBiomassOnTillerInLeafRec4',SumOfBiomassOnTillerInLeafRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfBiomassOnTillerInLeafRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10020);
  XprocTmp.SetActiveState(4);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerLeafBiomass'
  XprocTmp.ExternalConnect(['sumOfTillerLeafBiomass']);


  // calcule de la somme des demand des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDemandOnCulmInInternode4',SumOfDemandOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDemandOnCulmInInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10030);
  XprocTmp.SetActiveState(4);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeDemand'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeDemand']);


  // calcule de la somme des stock des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfStockOnCulmInInternode4',SumOfStockOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfStockOnCulmInInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10040);
  XprocTmp.SetActiveState(4);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeStock'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeStock']);


  // calcule de la somme des stock des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDeficitOnCulmInInternode4',SumOfDeficitOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDeficitOnCulmInInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10050);
  XprocTmp.SetActiveState(4);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeStock'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeDeficit']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDemandOnCulmInNonInternode4',SumOfDemandOnCulmInNonInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDemandOnCulmInNonInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10060);
  XprocTmp.SetActiveState(4);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'demandOfNonINTiller'
  XprocTmp.ExternalConnect(['demandOfNonINTiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('sumOfLastdemandInOrganRec4', SumOfLastdemandInOrganRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfLastdemandInOrganRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10070);
  XprocTmp.SetActiveState(4);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'last_demand_tiller'
  XprocTmp.ExternalConnect(['last_demand_tiller']);


  procTmp := TProcInstanceInternal.Create('computeStockLeafCulm_LE4', ComputeStockLeafCulm2_LEDyn, ['leafStockMax', 'kIn', 'sumOfBiomassInLeafCulm', 'kIn', 'stockCulm', 'kIn', 'sumOfCulmStockIN', 'kIn', 'sumOfCulmDecifitIN', 'kIn', 'sumOfCulmDemandNonIN', 'kIn', 'sumOfCulmLastDemand', 'kIn', 'sumOfCulmDemandIN', 'kIn', 'stockLeafCulm', 'kOut']);
  procTmp.SetProcName('computeStockLeafCulm2_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10080);
  procTmp.SetActiveState(4);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'leafStockMax', 'sumOfTillerLeafBiomass', 'stock_tiller', 'sumOfTillerInternodeStock', 'sumOfTillerInternodeDeficit', 'demandOfNonINTiller', 'last_demand_tiller', 'sumOfTillerInternodeDemand', 'stockLeafTiller'
  procTmp.ExternalConnect(['leafStockMax', 'sumOfTillerLeafBiomass', 'stock_tiller', 'sumOfTillerInternodeStock', 'sumOfTillerInternodeDeficit', 'demandOfNonINTiller', 'last_demand_tiller', 'sumOfTillerInternodeDemand', 'stockLeafTiller']);


  procTmp := TProcInstanceInternal.Create('ComputeReservoirDispoLeafCulm_LE4', ComputeReservoirDispoLeafCulm_LEDyn, ['leafStockMax', 'kIn', 'sumOfBiomassInLeafCulm', 'kIn', 'stockLeafCulm', 'kIn', 'reservoirDispoLeafCulm', 'kOut']);
  procTmp.SetProcName('computeReservoirDispoLeafCulm_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10090);
  procTmp.SetActiveState(4);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'leafStockMax', 'sumOfTillerLeafBiomass', 'stockLeafTiller', 'reservoirDispoLeafTiller'
  procTmp.ExternalConnect(['leafStockMax', 'sumOfTillerLeafBiomass', 'stockLeafTiller', 'reservoirDispoLeafTiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumReservoirDispoInInternodeOnTillerRec4',SumReservoirDispoInInternodeOnTillerRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumReservoirDispoInInternodeOnTillerRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10110);
  XprocTmp.SetActiveState(4);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfReservoirDispoIN'
  XprocTmp.ExternalConnect(['sumOfReservoirDispoIN']);


  XprocTmp := TExtraProcInstanceInternal.Create('sumOfDemandInOrganOnTillerRec4', SumOfDemandInOrganOnTillerRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDemandInOrganOnTillerRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10130);
  XprocTmp.SetActiveState(4);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['day_demand_tiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumOfBiomassOnTillerInInternodeRec4', SumOfBiomassOnTillersInInternodeRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfBiomassOnTillersInInternodeRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10140);
  XprocTmp.SetActiveState(4);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeBiomass']);

  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDailySenescedLeafBiomassOnCulm4', SumOfDailySenescedLeafBiomassOnCulmDyn,['sumOfDailySenescedLeafBiomass', 'kOut']);
  XprocTmp.SetProcName('SumOfDailySenescedLeafBiomassOnCulm');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10150);
  XprocTmp.SetActiveState(4);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['sumOfDailySenescedLeafBiomassTiller']);

  //-------------------------------------------//
  // procedure a l etat 5, c est a dire PRE_PI //
  //-------------------------------------------//

  XprocTmp := TExtraProcInstanceInternal.Create('sumOfBladeAreaOnTillerInLeafRec5', SumOfBladeAreaOnTillerInLeafRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfBladeAreaOnTillerInLeafRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10210);
  XprocTmp.SetActiveState(5);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfBladeAreaOnTillerInLeaf'
  XprocTmp.ExternalConnect(['sumOfBladeAreaOnTillerInLeaf']);


  // calcule de la somme des biomass des feuille sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('sumOfBiomassOnTillerInLeafRec5',SumOfBiomassOnTillerInLeafRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfBiomassOnTillerInLeafRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10220);
  XprocTmp.SetActiveState(5);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerLeafBiomass'
  XprocTmp.ExternalConnect(['sumOfTillerLeafBiomass']);


  // calcule de la somme des demand des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDemandOnCulmInInternode5',SumOfDemandOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDemandOnCulmInInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10230);
  XprocTmp.SetActiveState(5);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeDemand'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeDemand']);


  // calcule de la somme des stock des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfStockOnCulmInInternode5',SumOfStockOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfStockOnCulmInInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10240);
  XprocTmp.SetActiveState(5);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeStock'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeStock']);

  // calcule de la somme des stock des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDeficitOnCulmInInternode5',SumOfDeficitOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDeficitOnCulmInInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10250);
  XprocTmp.SetActiveState(5);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeStock'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeDeficit']);

  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDemandOnCulmInNonInternode5',SumOfDemandOnCulmInNonInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDemandOnCulmInNonInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10260);
  XprocTmp.SetActiveState(5);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'demandOfNonINTiller'
  XprocTmp.ExternalConnect(['demandOfNonINTiller']);

  XprocTmp := TExtraProcInstanceInternal.Create('sumOfLastdemandInOrganRec5', SumOfLastdemandInOrganRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfLastdemandInOrganRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10270);
  XprocTmp.SetActiveState(5);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'last_demand_tiller'
  XprocTmp.ExternalConnect(['last_demand_tiller']);

  procTmp := TProcInstanceInternal.Create('computeStockLeafCulm_LE5', ComputeStockLeafCulm2_LEDyn, ['leafStockMax', 'kIn', 'sumOfBiomassInLeafCulm', 'kIn', 'stockCulm', 'kIn', 'sumOfCulmStockIN', 'kIn', 'sumOfCulmDecifitIN', 'kIn', 'sumOfCulmDemandNonIN', 'kIn', 'sumOfCulmLastDemand', 'kIn', 'sumOfCulmDemandIN', 'kIn', 'stockLeafCulm', 'kOut']);
  procTmp.SetProcName('computeStockLeafCulm2_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10280);
  procTmp.SetActiveState(5);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'leafStockMax', 'sumOfTillerLeafBiomass', 'stock_tiller', 'sumOfTillerInternodeStock', 'sumOfTillerInternodeDeficit', 'demandOfNonINTiller', 'last_demand_tiller', 'sumOfTillerInternodeDemand', 'stockLeafTiller'
  procTmp.ExternalConnect(['leafStockMax', 'sumOfTillerLeafBiomass', 'stock_tiller', 'sumOfTillerInternodeStock', 'sumOfTillerInternodeDeficit', 'demandOfNonINTiller', 'last_demand_tiller', 'sumOfTillerInternodeDemand', 'stockLeafTiller']);

  procTmp := TProcInstanceInternal.Create('ComputeReservoirDispoLeafCulm_LE5', ComputeReservoirDispoLeafCulm_LEDyn, ['leafStockMax', 'kIn', 'sumOfBiomassInLeafCulm', 'kIn', 'stockLeafCulm', 'kIn', 'reservoirDispoLeafCulm', 'kOut']);
  procTmp.SetProcName('computeReservoirDispoLeafCulm_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10290);
  procTmp.SetActiveState(5);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'leafStockMax', 'sumOfTillerLeafBiomass', 'stockLeafTiller', 'reservoirDispoLeafTiller'
  procTmp.ExternalConnect(['leafStockMax', 'sumOfTillerLeafBiomass', 'stockLeafTiller', 'reservoirDispoLeafTiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumReservoirDispoInInternodeOnTillerRec5',SumReservoirDispoInInternodeOnTillerRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumReservoirDispoInInternodeOnTillerRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10310);
  XprocTmp.SetActiveState(5);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfReservoirDispoIN'
  XprocTmp.ExternalConnect(['sumOfReservoirDispoIN']);


  XprocTmp := TExtraProcInstanceInternal.Create('sumOfDemandInOrganOnTillerRec5', SumOfDemandInOrganOnTillerRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDemandInOrganOnTillerRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10330);
  XprocTmp.SetActiveState(5);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['day_demand_tiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumOfBiomassOnTillerInInternodeRec5', SumOfBiomassOnTillersInInternodeRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfBiomassOnTillersInInternodeRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10360);
  XprocTmp.SetActiveState(5);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeBiomass']);

  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDailySenescedLeafBiomassOnCulm5', SumOfDailySenescedLeafBiomassOnCulmDyn,['sumOfDailySenescedLeafBiomass', 'kOut']);
  XprocTmp.SetProcName('SumOfDailySenescedLeafBiomassOnCulm');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10370);
  XprocTmp.SetActiveState(5);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['sumOfDailySenescedLeafBiomassTiller']);


  //--------------------------------------------//
  // procedure a l etat 6, c est a dire PRE_FLO //
  //--------------------------------------------//

  XprocTmp := TExtraProcInstanceInternal.Create('sumOfBladeAreaOnTillerInLeafRec6', SumOfBladeAreaOnTillerInLeafRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfBladeAreaOnTillerInLeafRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10410);
  XprocTmp.SetActiveState(6);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfBladeAreaOnTillerInLeaf'
  XprocTmp.ExternalConnect(['sumOfBladeAreaOnTillerInLeaf']);


  // calcule de la somme des biomass des feuille sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('sumOfBiomassOnTillerInLeafRec6',SumOfBiomassOnTillerInLeafRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfBiomassOnTillerInLeafRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10420);
  XprocTmp.SetActiveState(6);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerLeafBiomass'
  XprocTmp.ExternalConnect(['sumOfTillerLeafBiomass']);


  // calcule de la somme des demand des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDemandOnCulmInInternode6',SumOfDemandOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDemandOnCulmInInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10430);
  XprocTmp.SetActiveState(6);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeDemand'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeDemand']);


  // calcule de la somme des stock des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfStockOnCulmInInternode6',SumOfStockOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfStockOnCulmInInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10440);
  XprocTmp.SetActiveState(6);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeStock'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeStock']);

  // calcule de la somme des stock des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDeficitOnCulmInInternode6',SumOfDeficitOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDeficitOnCulmInInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10450);
  XprocTmp.SetActiveState(6);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeStock'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeDeficit']);

  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDemandOnCulmInNonInternode6',SumOfDemandOnCulmInNonInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDemandOnCulmInNonInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10460);
  XprocTmp.SetActiveState(6);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'demandOfNonINTiller'
  XprocTmp.ExternalConnect(['demandOfNonINTiller']);

  XprocTmp := TExtraProcInstanceInternal.Create('sumOfLastdemandInOrganRec6', SumOfLastdemandInOrganRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfLastdemandInOrganRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10470);
  XprocTmp.SetActiveState(6);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'last_demand_tiller'
  XprocTmp.ExternalConnect(['last_demand_tiller']);

  procTmp := TProcInstanceInternal.Create('computeStockLeafCulm_LE6', ComputeStockLeafCulm2_LEDyn, ['leafStockMax', 'kIn', 'sumOfBiomassInLeafCulm', 'kIn', 'stockCulm', 'kIn', 'sumOfCulmStockIN', 'kIn', 'sumOfCulmDecifitIN', 'kIn', 'sumOfCulmDemandNonIN', 'kIn', 'sumOfCulmLastDemand', 'kIn', 'sumOfCulmDemandIN', 'kIn', 'stockLeafCulm', 'kOut']);
  procTmp.SetProcName('computeStockLeafCulm2_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10480);
  procTmp.SetActiveState(6);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'leafStockMax', 'sumOfTillerLeafBiomass', 'stock_tiller', 'sumOfTillerInternodeStock', 'sumOfTillerInternodeDeficit', 'demandOfNonINTiller', 'last_demand_tiller', 'sumOfTillerInternodeDemand', 'stockLeafTiller'
  procTmp.ExternalConnect(['leafStockMax', 'sumOfTillerLeafBiomass', 'stock_tiller', 'sumOfTillerInternodeStock', 'sumOfTillerInternodeDeficit', 'demandOfNonINTiller', 'last_demand_tiller', 'sumOfTillerInternodeDemand', 'stockLeafTiller']);

  procTmp := TProcInstanceInternal.Create('ComputeReservoirDispoLeafCulm_LE6', ComputeReservoirDispoLeafCulm_LEDyn, ['leafStockMax', 'kIn', 'sumOfBiomassInLeafCulm', 'kIn', 'stockLeafCulm', 'kIn', 'reservoirDispoLeafCulm', 'kOut']);
  procTmp.SetProcName('computeReservoirDispoLeafCulm_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10490);
  procTmp.SetActiveState(6);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'leafStockMax', 'sumOfTillerLeafBiomass', 'stockLeafTiller', 'reservoirDispoLeafTiller'
  procTmp.ExternalConnect(['leafStockMax', 'sumOfTillerLeafBiomass', 'stockLeafTiller', 'reservoirDispoLeafTiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumReservoirDispoInInternodeOnTillerRec6',SumReservoirDispoInInternodeOnTillerRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumReservoirDispoInInternodeOnTillerRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10510);
  XprocTmp.SetActiveState(6);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfReservoirDispoIN'
  XprocTmp.ExternalConnect(['sumOfReservoirDispoIN']);


  XprocTmp := TExtraProcInstanceInternal.Create('sumOfDemandInOrganOnTillerRec6', SumOfDemandInOrganOnTillerRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDemandInOrganOnTillerRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10530);
  XprocTmp.SetActiveState(6);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['day_demand_tiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumOfBiomassOnTillerInInternodeRec6', SumOfBiomassOnTillersInInternodeRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfBiomassOnTillersInInternodeRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10560);
  XprocTmp.SetActiveState(6);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeBiomass']);

  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDailySenescedLeafBiomassOnCulm6', SumOfDailySenescedLeafBiomassOnCulmDyn,['sumOfDailySenescedLeafBiomass', 'kOut']);
  XprocTmp.SetProcName('SumOfDailySenescedLeafBiomassOnCulm');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10570);
  XprocTmp.SetActiveState(6);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['sumOfDailySenescedLeafBiomassTiller']);

  //----------------------------------------//
  // procedure a l etat 7, c est a dire FLO //
  //-------------------------------- -------//

  XprocTmp := TExtraProcInstanceInternal.Create('sumOfBladeAreaOnTillerInLeafRec7', SumOfBladeAreaOnTillerInLeafRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfBladeAreaOnTillerInLeafRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10610);
  XprocTmp.SetActiveState(7);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfBladeAreaOnTillerInLeaf'
  XprocTmp.ExternalConnect(['sumOfBladeAreaOnTillerInLeaf']);


  // calcule de la somme des biomass des feuille sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('sumOfBiomassOnTillerInLeafRec7',SumOfBiomassOnTillerInLeafRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfBiomassOnTillerInLeafRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10620);
  XprocTmp.SetActiveState(7);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerLeafBiomass'
  XprocTmp.ExternalConnect(['sumOfTillerLeafBiomass']);


  // calcule de la somme des demand des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDemandOnCulmInInternode7',SumOfDemandOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDemandOnCulmInInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10630);
  XprocTmp.SetActiveState(7);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeDemand'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeDemand']);


  // calcule de la somme des stock des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfStockOnCulmInInternode7',SumOfStockOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfStockOnCulmInInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10640);
  XprocTmp.SetActiveState(7);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeStock'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeStock']);

  // calcule de la somme des stock des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDeficitOnCulmInInternode7',SumOfDeficitOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDeficitOnCulmInInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10650);
  XprocTmp.SetActiveState(7);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeStock'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeDeficit']);

  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDemandOnCulmInNonInternode7',SumOfDemandOnCulmInNonInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDemandOnCulmInNonInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10660);
  XprocTmp.SetActiveState(7);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'demandOfNonINTiller'
  XprocTmp.ExternalConnect(['demandOfNonINTiller']);

  XprocTmp := TExtraProcInstanceInternal.Create('sumOfLastdemandInOrganRec7', SumOfLastdemandInOrganRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfLastdemandInOrganRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10670);
  XprocTmp.SetActiveState(7);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'last_demand_tiller'
  XprocTmp.ExternalConnect(['last_demand_tiller']);

  procTmp := TProcInstanceInternal.Create('computeStockLeafCulm_LE7', ComputeStockLeafCulm2_LEDyn, ['leafStockMax', 'kIn', 'sumOfBiomassInLeafCulm', 'kIn', 'stockCulm', 'kIn', 'sumOfCulmStockIN', 'kIn', 'sumOfCulmDecifitIN', 'kIn', 'sumOfCulmDemandNonIN', 'kIn', 'sumOfCulmLastDemand', 'kIn', 'sumOfCulmDemandIN', 'kIn', 'stockLeafCulm', 'kOut']);
  procTmp.SetProcName('computeStockLeafCulm2_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10680);
  procTmp.SetActiveState(7);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'leafStockMax', 'sumOfTillerLeafBiomass', 'stock_tiller', 'sumOfTillerInternodeStock', 'sumOfTillerInternodeDeficit', 'demandOfNonINTiller', 'last_demand_tiller', 'sumOfTillerInternodeDemand', 'stockLeafTiller'
  procTmp.ExternalConnect(['leafStockMax', 'sumOfTillerLeafBiomass', 'stock_tiller', 'sumOfTillerInternodeStock', 'sumOfTillerInternodeDeficit', 'demandOfNonINTiller', 'last_demand_tiller', 'sumOfTillerInternodeDemand', 'stockLeafTiller']);

  procTmp := TProcInstanceInternal.Create('ComputeReservoirDispoLeafCulm_LE7', ComputeReservoirDispoLeafCulm_LEDyn, ['leafStockMax', 'kIn', 'sumOfBiomassInLeafCulm', 'kIn', 'stockLeafCulm', 'kIn', 'reservoirDispoLeafCulm', 'kOut']);
  procTmp.SetProcName('computeReservoirDispoLeafCulm_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10690);
  procTmp.SetActiveState(7);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'leafStockMax', 'sumOfTillerLeafBiomass', 'stockLeafTiller', 'reservoirDispoLeafTiller'
  procTmp.ExternalConnect(['leafStockMax', 'sumOfTillerLeafBiomass', 'stockLeafTiller', 'reservoirDispoLeafTiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumReservoirDispoInInternodeOnTillerRec7',SumReservoirDispoInInternodeOnTillerRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumReservoirDispoInInternodeOnTillerRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10710);
  XprocTmp.SetActiveState(7);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfReservoirDispoIN'
  XprocTmp.ExternalConnect(['sumOfReservoirDispoIN']);


  XprocTmp := TExtraProcInstanceInternal.Create('sumOfDemandInOrganOnTillerRec7', SumOfDemandInOrganOnTillerRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDemandInOrganOnTillerRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10730);
  XprocTmp.SetActiveState(7);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['day_demand_tiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumOfBiomassOnTillerInInternodeRec7', SumOfBiomassOnTillersInInternodeRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfBiomassOnTillersInInternodeRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10760);
  XprocTmp.SetActiveState(7);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeBiomass']);

  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDailySenescedLeafBiomassOnCulm7', SumOfDailySenescedLeafBiomassOnCulmDyn,['sumOfDailySenescedLeafBiomass', 'kOut']);
  XprocTmp.SetProcName('SumOfDailySenescedLeafBiomassOnCulm');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10770);
  XprocTmp.SetActiveState(7);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['sumOfDailySenescedLeafBiomassTiller']);

  //------------------------------------------//
  // procedure a l etat 9, c est a dire ELONG //
  //------------------------------------------//

  XprocTmp := TExtraProcInstanceInternal.Create('sumOfBladeAreaOnTillerInLeafRec9', SumOfBladeAreaOnTillerInLeafRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfBladeAreaOnTillerInLeafRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10810);
  XprocTmp.SetActiveState(9);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfBladeAreaOnTillerInLeaf'
  XprocTmp.ExternalConnect(['sumOfBladeAreaOnTillerInLeaf']);


  // calcule de la somme des biomass des feuille sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('sumOfBiomassOnTillerInLeafRec9',SumOfBiomassOnTillerInLeafRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfBiomassOnTillerInLeafRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10820);
  XprocTmp.SetActiveState(9);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerLeafBiomass'
  XprocTmp.ExternalConnect(['sumOfTillerLeafBiomass']);


  // calcule de la somme des demand des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDemandOnCulmInInternode9',SumOfDemandOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDemandOnCulmInInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10830);
  XprocTmp.SetActiveState(9);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeDemand'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeDemand']);


  // calcule de la somme des stock des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfStockOnCulmInInternode9',SumOfStockOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfStockOnCulmInInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10840);
  XprocTmp.SetActiveState(9);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeStock'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeStock']);

  // calcule de la somme des stock des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDeficitOnCulmInInternode9',SumOfDeficitOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDeficitOnCulmInInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10850);
  XprocTmp.SetActiveState(9);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeStock'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeDeficit']);

  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDemandOnCulmInNonInternode9',SumOfDemandOnCulmInNonInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDemandOnCulmInNonInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10860);
  XprocTmp.SetActiveState(9);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'demandOfNonINTiller'
  XprocTmp.ExternalConnect(['demandOfNonINTiller']);

  XprocTmp := TExtraProcInstanceInternal.Create('sumOfLastdemandInOrganRec9', SumOfLastdemandInOrganRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfLastdemandInOrganRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10870);
  XprocTmp.SetActiveState(9);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'last_demand_tiller'
  XprocTmp.ExternalConnect(['last_demand_tiller']);

  procTmp := TProcInstanceInternal.Create('computeStockLeafCulm_LE9', ComputeStockLeafCulm2_LEDyn, ['leafStockMax', 'kIn', 'sumOfBiomassInLeafCulm', 'kIn', 'stockCulm', 'kIn', 'sumOfCulmStockIN', 'kIn', 'sumOfCulmDecifitIN', 'kIn', 'sumOfCulmDemandNonIN', 'kIn', 'sumOfCulmLastDemand', 'kIn', 'sumOfCulmDemandIN', 'kIn', 'stockLeafCulm', 'kOut']);
  procTmp.SetProcName('computeStockLeafCulm2_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10880);
  procTmp.SetActiveState(9);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'leafStockMax', 'sumOfTillerLeafBiomass', 'stock_tiller', 'sumOfTillerInternodeStock', 'sumOfTillerInternodeDeficit', 'demandOfNonINTiller', 'last_demand_tiller', 'sumOfTillerInternodeDemand', 'stockLeafTiller'
  procTmp.ExternalConnect(['leafStockMax', 'sumOfTillerLeafBiomass', 'stock_tiller', 'sumOfTillerInternodeStock', 'sumOfTillerInternodeDeficit', 'demandOfNonINTiller', 'last_demand_tiller', 'sumOfTillerInternodeDemand', 'stockLeafTiller']);

  procTmp := TProcInstanceInternal.Create('ComputeReservoirDispoLeafCulm_LE9', ComputeReservoirDispoLeafCulm_LEDyn, ['leafStockMax', 'kIn', 'sumOfBiomassInLeafCulm', 'kIn', 'stockLeafCulm', 'kIn', 'reservoirDispoLeafCulm', 'kOut']);
  procTmp.SetProcName('computeReservoirDispoLeafCulm_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10890);
  procTmp.SetActiveState(9);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'leafStockMax', 'sumOfTillerLeafBiomass', 'stockLeafTiller', 'reservoirDispoLeafTiller'
  procTmp.ExternalConnect(['leafStockMax', 'sumOfTillerLeafBiomass', 'stockLeafTiller', 'reservoirDispoLeafTiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumReservoirDispoInInternodeOnTillerRec9',SumReservoirDispoInInternodeOnTillerRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumReservoirDispoInInternodeOnTillerRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10910);
  XprocTmp.SetActiveState(9);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfReservoirDispoIN'
  XprocTmp.ExternalConnect(['sumOfReservoirDispoIN']);


  XprocTmp := TExtraProcInstanceInternal.Create('sumOfDemandInOrganOnTillerRec9', SumOfDemandInOrganOnTillerRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDemandInOrganOnTillerRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10930);
  XprocTmp.SetActiveState(9);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['day_demand_tiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumOfBiomassOnTillerInInternodeRec9', SumOfBiomassOnTillersInInternodeRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfBiomassOnTillersInInternodeRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10960);
  XprocTmp.SetActiveState(9);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeBiomass']);

  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDailySenescedLeafBiomassOnCulm9', SumOfDailySenescedLeafBiomassOnCulmDyn,['sumOfDailySenescedLeafBiomass', 'kOut']);
  XprocTmp.SetProcName('SumOfDailySenescedLeafBiomassOnCulm');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10970);
  XprocTmp.SetActiveState(9);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['sumOfDailySenescedLeafBiomassTiller']);

  //-----------------------------------------------//
  // procedure a l etat 10, c est a dire PRE_ELONG //
  //-----------------------------------------------//

  XprocTmp := TExtraProcInstanceInternal.Create('sumOfBladeAreaOnTillerInLeafRec10', SumOfBladeAreaOnTillerInLeafRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfBladeAreaOnTillerInLeafRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(11000);
  XprocTmp.SetActiveState(10);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfBladeAreaOnTillerInLeaf'
  XprocTmp.ExternalConnect(['sumOfBladeAreaOnTillerInLeaf']);


  // calcule de la somme des biomass des feuille sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('sumOfBiomassOnTillerInLeafRec10',SumOfBiomassOnTillerInLeafRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfBiomassOnTillerInLeafRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(11010);
  XprocTmp.SetActiveState(10);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerLeafBiomass'
  XprocTmp.ExternalConnect(['sumOfTillerLeafBiomass']);


  // calcule de la somme des demand des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDemandOnCulmInInternode10',SumOfDemandOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDemandOnCulmInInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(11020);
  XprocTmp.SetActiveState(10);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeDemand'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeDemand']);


  // calcule de la somme des stock des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfStockOnCulmInInternode10',SumOfStockOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfStockOnCulmInInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(11030);
  XprocTmp.SetActiveState(10);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeStock'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeStock']);

  // calcule de la somme des stock des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDeficitOnCulmInInternode10',SumOfDeficitOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDeficitOnCulmInInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(11040);
   XprocTmp.SetActiveState(10);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeStock'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeDeficit']);

  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDemandOnCulmInNonInternode10',SumOfDemandOnCulmInNonInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDemandOnCulmInNonInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(11050);
  XprocTmp.SetActiveState(10);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'demandOfNonINTiller'
  XprocTmp.ExternalConnect(['demandOfNonINTiller']);

  XprocTmp := TExtraProcInstanceInternal.Create('sumOfLastdemandInOrganRec10', SumOfLastdemandInOrganRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfLastdemandInOrganRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(11060);
  XprocTmp.SetActiveState(10);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'last_demand_tiller'
  XprocTmp.ExternalConnect(['last_demand_tiller']);

  procTmp := TProcInstanceInternal.Create('computeStockLeafCulm_LE10', ComputeStockLeafCulm2_LEDyn, ['leafStockMax', 'kIn', 'sumOfBiomassInLeafCulm', 'kIn', 'stockCulm', 'kIn', 'sumOfCulmStockIN', 'kIn', 'sumOfCulmDecifitIN', 'kIn', 'sumOfCulmDemandNonIN', 'kIn', 'sumOfCulmLastDemand', 'kIn', 'sumOfCulmDemandIN', 'kIn', 'stockLeafCulm', 'kOut']);
  procTmp.SetProcName('computeStockLeafCulm2_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(11070);
  procTmp.SetActiveState(10);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'leafStockMax', 'sumOfTillerLeafBiomass', 'stock_tiller', 'sumOfTillerInternodeStock', 'sumOfTillerInternodeDeficit', 'demandOfNonINTiller', 'last_demand_tiller', 'sumOfTillerInternodeDemand', 'stockLeafTiller'
  procTmp.ExternalConnect(['leafStockMax', 'sumOfTillerLeafBiomass', 'stock_tiller', 'sumOfTillerInternodeStock', 'sumOfTillerInternodeDeficit', 'demandOfNonINTiller', 'last_demand_tiller', 'sumOfTillerInternodeDemand', 'stockLeafTiller']);

  procTmp := TProcInstanceInternal.Create('ComputeReservoirDispoLeafCulm_LE10', ComputeReservoirDispoLeafCulm_LEDyn, ['leafStockMax', 'kIn', 'sumOfBiomassInLeafCulm', 'kIn', 'stockLeafCulm', 'kIn', 'reservoirDispoLeafCulm', 'kOut']);
  procTmp.SetProcName('computeReservoirDispoLeafCulm_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(11080);
  procTmp.SetActiveState(10);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'leafStockMax', 'sumOfTillerLeafBiomass', 'stockLeafTiller', 'reservoirDispoLeafTiller'
  procTmp.ExternalConnect(['leafStockMax', 'sumOfTillerLeafBiomass', 'stockLeafTiller', 'reservoirDispoLeafTiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumReservoirDispoInInternodeOnTillerRec10',SumReservoirDispoInInternodeOnTillerRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumReservoirDispoInInternodeOnTillerRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(11090);
  XprocTmp.SetActiveState(10);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfReservoirDispoIN'
  XprocTmp.ExternalConnect(['sumOfReservoirDispoIN']);


  XprocTmp := TExtraProcInstanceInternal.Create('sumOfDemandInOrganOnTillerRec10', SumOfDemandInOrganOnTillerRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDemandInOrganOnTillerRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(11100);
  XprocTmp.SetActiveState(10);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['day_demand_tiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumOfBiomassOnTillerInInternodeRec10', SumOfBiomassOnTillersInInternodeRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfBiomassOnTillersInInternodeRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(11110);
  XprocTmp.SetActiveState(10);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeBiomass']);

  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDailySenescedLeafBiomassOnCulm10', SumOfDailySenescedLeafBiomassOnCulmDyn,['sumOfDailySenescedLeafBiomass', 'kOut']);
  XprocTmp.SetProcName('SumOfDailySenescedLeafBiomassOnCulm');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(11120);
  XprocTmp.SetActiveState(10);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['sumOfDailySenescedLeafBiomassTiller']);



  // retourne la talle créée
  result := entityTiller;

end;
end.
