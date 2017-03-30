// ---------------------------------------------------------------------------
/// creation et importation d'une entité talle générique pour EcoMeristem_LE
///
/// Description :
//
// ----------------------------------------------------------------------------
(** @Author JC Soulié
    @Version 14/06/10 LT v0.0 version initiale; statut : en cours *)

unit EntityTillerPhytomer_ng;

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
  ModuleMeristem_ng,
  ManagerMeristem_ng,
  DefinitionConstant,
  ClassTExtraProcInstanceInternal;

function ImportTillerPhytomer_ng(const name : string; const thresINER, slopeINER, leafStockMax, phenoStageAtCreation, maximumReserveInternode : Double; const isMainstem : Integer) : TEntityInstance;



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
//  fonction ImportTiller_ng
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

function ImportTillerPhytomer_ng(const name : string; const thresINER, slopeINER, leafStockMax, phenoStageAtCreation, maximumReserveInternode : Double; const isMainstem : Integer) : TEntityInstance;
var
  entityTiller : TEntityInstance;
  attributeTmp : TAttributeTmp;
  parameterTmp : TParameter;
  procTmp : TProcInstanceInternal;
  XprocTmp : TExtraProcInstanceInternal;
  managerTmp : TManagerInternal;
  initSample : TSample;
begin

  SRwriteln('isMainstem : ' + IntToStr(isMainstem));

  // ---------------------------
  // creation de 'EntityTiller'
  // ---------------------------
  entityTiller := TEntityInstance.Create('',
                                        ['degreeDayForLeafInitiation','kIn',
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

  parameterTmp := TParameter.Create('isMainstem', isMainstem);
  entityTiller.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('thresINER',thresINER);
  entityTiller.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('slopeINER',slopeINER);
  entityTiller.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('leafStockMax', leafStockMax);
  entityTiller.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('phenoStageAtCreation', phenoStageAtCreation);
  entityTiller.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('maximumReserveInternode', maximumReserveInternode);
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

  parameterTmp := TParameter.Create('panicleToBeActivated', 0);
  entityTiller.AddTAttribute(parameterTmp);

  attributeTmp := TAttributeTmp.Create('ifFirstDayOfPre_Elong');
  initSample.date := 0; initSample.value := 1;
  attributeTmp.SetSample(initSample);
  entityTiller.AddTAttribute(attributeTmp);

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

  attributeTmp := TAttributeTmp.Create('ic_tiller');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('max_reservoir_tiller');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('deficit_tiller');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('tmp_tiller');
  entityTiller.AddTAttribute(attributeTmp);

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

  attributeTmp := TAttributeTmp.Create('stockLeafTiller');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('stockINTiller');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('reservoirDispoLeafTiller');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('reservoirDispoINTiller');
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

  initSample.date := 0; initSample.value := 0;
  attributeTmp := TAttributeTmp.Create('sumOfInternodeBiomass', initSample);
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('leaf_internode_biomass_tiller');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('sumOfDailySenescedLeafBiomassTiller');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('sumOfDailyComputedReallocBiomassTiller');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('previousState');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('tillerIc');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('maxReservoirDispoLeaf');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('maxReservoirDispoInternode');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('dailyComputedReallocBiomass');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('dailySenescedLeafBiomass');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('totalSenescedLeafBiomass');
  entityTiller.AddTAttribute(attributeTmp);


  // ---------------------------------------------------
  // connection port <-> attribut pour 'EntityTiller'
  // ---------------------------------------------------

  entityTiller.InternalConnect(['degreeDayForLeafInitiation',
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

  // --------------------------------------------------- //
  // ajout d'un manageur                                 //
  // --------------------------------------------------- //

  managerTmp := TManagerInternal.Create('tillerManagerPhytomer_ng',TillerManagerPhytomer_ng);
  managerTmp.SetFunctName('TillerManagerPhytomer_ng');
  managerTmp.SetExeMode(intra);
  managerTmp.SetExeOrder(1);
  entityTiller.AddTManager(managerTmp);

  // --------------------------------------------------- //
  // procedures journalières                             //
  // --------------------------------------------------- //

  procTmp := TProcInstanceInternal.Create('identityDD',IdentityDyn,['inValue','kIn','outValue','kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10);
  entityTiller.AddTInstance(procTmp);

  procTmp.ExternalConnect(['degreeDayForLeafInitiation','degreeDayForInternodeInitiation']);

  procTmp := TProcInstanceInternal.Create('identityEDD',IdentityDyn,['inValue','kIn','outValue','kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(20);
  entityTiller.AddTInstance(procTmp);

  procTmp.ExternalConnect(['degreeDayForLeafRealization','degreeDayForInternodeRealization']);

  XprocTmp := TExtraProcInstanceInternal.Create('KillOldestLeafTiller_ng',KillOldestLeafTiller_ngDyn,['deficit', 'kInOut', 'stock', 'kInOut', 'activeLeafNb', 'kInOut', 'leafNb', 'kInOut']);
  XprocTmp.SetProcName('KillOldestLeafTiller_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(30);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerLeafBiomass'
  XprocTmp.ExternalConnect(['deficit_tiller', 'stock_tiller', 'activeLeavesNb', 'leafNb']);

  // --------------------------------------------------- //
  // procedures de l'etat 1                              //
  // INITIATION                                          //
  // --------------------------------------------------- //

  // calcule de la somme des biomass des feuille sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('sumOfBiomassOnTillerInLeafRec1',SumOfBiomassOnTillerInLeafRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfBiomassOnTillerInLeafRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10000);
  XprocTmp.SetActiveState(1);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerLeafBiomass'
  XprocTmp.ExternalConnect(['sumOfTillerLeafBiomass']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDailySenescedLeafBiomassOnCulm_ng1', SumOfDailySenescedLeafBiomassOnCulm_ngDyn,['sumOfDailySenescedLeafBiomass', 'kOut']);
  XprocTmp.SetProcName('SumOfDailySenescedLeafBiomassOnCulm_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10001);
  XprocTmp.SetActiveState(1);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['sumOfDailySenescedLeafBiomassTiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDailyComputedReallocBiomassOnCulm_ng1', SumOfDailyComputedReallocBiomassOnCulm_ngDyn,['sumOfDailyComputedReallocBiomass', 'kOut']);
  XprocTmp.SetProcName('SumOfDailyComputedReallocBiomassOnCulm_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10002);
  XprocTmp.SetActiveState(1);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfDailyComputedReallocBiomassTiller'
  XprocTmp.ExternalConnect(['sumOfDailyComputedReallocBiomassTiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('ComputeSumOfInternodeBiomassOnCulm_ng1', ComputeSumOfInternodeBiomassOnCulm_ngDyn,['total', 'kOut']);
  XprocTmp.SetProcName('ComputeSumOfInternodeBiomassOnCulm_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10003);
  XprocTmp.SetActiveState(1);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfInternodeBiomass'
  XprocTmp.ExternalConnect(['sumOfInternodeBiomass']);


  procTmp := TProcInstanceInternal.Create('ComputeMaxReservoirInternodeCulm_ng1',ComputeMaxReservoirInternodeCulm_ngDyn,['maximumReserveInInternode', 'kIn', 'sumOfInternodeBiomass', 'kIn', 'maxReservoidDispoInternode', 'kOut']);
  procTmp.SetProcName('ComputeMaxReservoirInternodeCulm_ng');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10004);
  procTmp.SetActiveState(1);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour maximumReserveInternode, sumOfInternodeBiomass et maxReservoirDispoInternode
  procTmp.ExternalConnect(['maximumReserveInternode', 'sumOfInternodeBiomass', 'maxReservoirDispoInternode']);


  XprocTmp := TExtraProcInstanceInternal.Create('ComputeLengthPeduncles_ng1', ComputeLengthPeduncles_ngDyn,[]);
  XprocTmp.SetProcName('ComputeLengthPeduncles_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10005);
  XprocTmp.SetActiveState(1);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour
  XprocTmp.ExternalConnect([]);


  XprocTmp := TExtraProcInstanceInternal.Create('ComputeTotalSenescedLeafBiomass_ng1', ComputeTotalSenescedLeafBiomass_ngDyn,['totalSenescedLeafBiomass', 'kOut']);
  XprocTmp.SetProcName('ComputeTotalSenescedLeafBiomass_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10006);
  XprocTmp.SetActiveState(1);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['totalSenescedLeafBiomass']);


  // --------------------------------------------------- //
  // procedures de l'etat 2                              //
  // REALIZATION                                         //
  // --------------------------------------------------- //

  // calcule de la somme des biomass des feuille sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('sumOfBiomassOnTillerInLeafRec2',SumOfBiomassOnTillerInLeafRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfBiomassOnTillerInLeafRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10010);
  XprocTmp.SetActiveState(2);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerLeafBiomass'
  XprocTmp.ExternalConnect(['sumOfTillerLeafBiomass']);

  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDailySenescedLeafBiomassOnCulm_ng2', SumOfDailySenescedLeafBiomassOnCulm_ngDyn,['sumOfDailySenescedLeafBiomass', 'kOut']);
  XprocTmp.SetProcName('SumOfDailySenescedLeafBiomassOnCulm_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10020);
  XprocTmp.SetActiveState(2);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['sumOfDailySenescedLeafBiomassTiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDailyComputedReallocBiomassOnCulm_ng2', SumOfDailyComputedReallocBiomassOnCulm_ngDyn,['sumOfDailyComputedReallocBiomass', 'kOut']);
  XprocTmp.SetProcName('SumOfDailyComputedReallocBiomassOnCulm_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10030);
  XprocTmp.SetActiveState(2);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfDailyComputedReallocBiomassTiller'
  XprocTmp.ExternalConnect(['sumOfDailyComputedReallocBiomassTiller']);

  XprocTmp := TExtraProcInstanceInternal.Create('ComputeSumOfInternodeBiomassOnCulm_ng2', ComputeSumOfInternodeBiomassOnCulm_ngDyn,['total', 'kOut']);
  XprocTmp.SetProcName('ComputeSumOfInternodeBiomassOnCulm_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10040);
  XprocTmp.SetActiveState(2);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfInternodeBiomass'
  XprocTmp.ExternalConnect(['sumOfInternodeBiomass']);


  procTmp := TProcInstanceInternal.Create('ComputeMaxReservoirInternodeCulm_ng2',ComputeMaxReservoirInternodeCulm_ngDyn,['maximumReserveInInternode', 'kIn', 'sumOfInternodeBiomass', 'kIn', 'maxReservoidDispoInternode', 'kOut']);
  procTmp.SetProcName('ComputeMaxReservoirInternodeCulm_ng');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10050);
  procTmp.SetActiveState(2);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour maximumReserveInternode, sumOfInternodeBiomass et maxReservoirDispoInternode
  procTmp.ExternalConnect(['maximumReserveInternode', 'sumOfInternodeBiomass', 'maxReservoirDispoInternode']);


  XprocTmp := TExtraProcInstanceInternal.Create('ComputeLengthPeduncles_ng2', ComputeLengthPeduncles_ngDyn,[]);
  XprocTmp.SetProcName('ComputeLengthPeduncles_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10060);
  XprocTmp.SetActiveState(2);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour
  XprocTmp.ExternalConnect([]);


  XprocTmp := TExtraProcInstanceInternal.Create('ComputeTotalSenescedLeafBiomass_ng2', ComputeTotalSenescedLeafBiomass_ngDyn,['totalSenescedLeafBiomass', 'kOut']);
  XprocTmp.SetProcName('ComputeTotalSenescedLeafBiomass_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10070);
  XprocTmp.SetActiveState(2);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['totalSenescedLeafBiomass']);


  procTmp := TProcInstanceInternal.Create('dispTotal',DispDyn,['value','kIn']);
  procTmp.SetProcName('Disp');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10080);
  procTmp.SetActiveState(2);
  entityTiller.AddTInstance(procTmp);

  procTmp.ExternalConnect(['totalSenescedLeafBiomass']);




  // --------------------------------------------------- //
  // procedures de l'etat 3                              //
  // FERTILECAPACITY                                     //
  // --------------------------------------------------- //

  // calcule de la somme des biomass des feuille sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('sumOfBiomassOnTillerInLeafRec3',SumOfBiomassOnTillerInLeafRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfBiomassOnTillerInLeafRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10100);
  XprocTmp.SetActiveState(3);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerLeafBiomass'
  XprocTmp.ExternalConnect(['sumOfTillerLeafBiomass']);

  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDailySenescedLeafBiomassOnCulm_ng3', SumOfDailySenescedLeafBiomassOnCulm_ngDyn,['sumOfDailySenescedLeafBiomass', 'kOut']);
  XprocTmp.SetProcName('SumOfDailySenescedLeafBiomassOnCulm_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10110);
  XprocTmp.SetActiveState(3);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['sumOfDailySenescedLeafBiomassTiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDailyComputedReallocBiomassOnCulm_ng3', SumOfDailyComputedReallocBiomassOnCulm_ngDyn,['sumOfDailyComputedReallocBiomass', 'kOut']);
  XprocTmp.SetProcName('SumOfDailyComputedReallocBiomassOnCulm_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10120);
  XprocTmp.SetActiveState(3);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfDailyComputedReallocBiomassTiller'
  XprocTmp.ExternalConnect(['sumOfDailyComputedReallocBiomassTiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('ComputeSumOfInternodeBiomassOnCulm_ng3', ComputeSumOfInternodeBiomassOnCulm_ngDyn,['total', 'kOut']);
  XprocTmp.SetProcName('ComputeSumOfInternodeBiomassOnCulm_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10130);
  XprocTmp.SetActiveState(3);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfInternodeBiomass'
  XprocTmp.ExternalConnect(['sumOfInternodeBiomass']);


  procTmp := TProcInstanceInternal.Create('ComputeMaxReservoirInternodeCulm_ng3',ComputeMaxReservoirInternodeCulm_ngDyn,['maximumReserveInInternode', 'kIn', 'sumOfInternodeBiomass', 'kIn', 'maxReservoidDispoInternode', 'kOut']);
  procTmp.SetProcName('ComputeMaxReservoirInternodeCulm_ng');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10140);
  procTmp.SetActiveState(3);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour maximumReserveInternode, sumOfInternodeBiomass et maxReservoirDispoInternode
  procTmp.ExternalConnect(['maximumReserveInternode', 'sumOfInternodeBiomass', 'maxReservoirDispoInternode']);


  XprocTmp := TExtraProcInstanceInternal.Create('ComputeLengthPeduncles_ng3', ComputeLengthPeduncles_ngDyn,[]);
  XprocTmp.SetProcName('ComputeLengthPeduncles_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10150);
  XprocTmp.SetActiveState(3);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour
  XprocTmp.ExternalConnect([]);


  XprocTmp := TExtraProcInstanceInternal.Create('ComputeTotalSenescedLeafBiomass_ng3', ComputeTotalSenescedLeafBiomass_ngDyn,['totalSenescedLeafBiomass', 'kOut']);
  XprocTmp.SetProcName('ComputeTotalSenescedLeafBiomass_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10160);
  XprocTmp.SetActiveState(3);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['totalSenescedLeafBiomass']);


  // --------------------------------------------------- //
  // procedures de l'etat 4                              //
  // PI                                                  //
  // --------------------------------------------------- //

  XprocTmp := TExtraProcInstanceInternal.Create('sumOfBladeAreaOnTillerInLeaf4', ComputeBladeAreaLeavesTillerDyn,['total', 'kOut']);
  XprocTmp.SetProcName('ComputeBladeAreaLeavesTiller');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10200);
  XprocTmp.SetActiveState(4);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfBladeAreaOnTillerInLeaf'
  XprocTmp.ExternalConnect(['sumOfBladeAreaOnTillerInLeaf']);


  // calcule de la somme des biomass des feuille sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('ComputeBiomassLeavesTiller4',ComputeBiomassLeavesTillerDyn,['sumOfTillerLeafBiomass', 'kOut']);
  XprocTmp.SetProcName('ComputeBiomassLeavesTiller');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10210);
  XprocTmp.SetActiveState(4);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerLeafBiomass'
  XprocTmp.ExternalConnect(['sumOfTillerLeafBiomass']);


  procTmp := TProcInstanceInternal.Create('ComputeMaxReservoirLeafCulm_ng4',ComputeMaxReservoirLeafCulm_ngDyn,['leafStockMax', 'kIn', 'sumOfLeafBiomass', 'kIn', 'maxReservoirDispoLeaf', 'kOut']);
  procTmp.SetProcName('ComputeMaxReservoirLeafCulm_ng');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10220);
  procTmp.SetActiveState(4);
  entityTiller.AddTInstance(procTmp);

  procTmp.ExternalConnect(['leafStockMax', 'sumOfTillerLeafBiomass', 'maxReservoirDispoLeaf']);


  // calcule de la somme des demand des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDemandOnCulmInInternode4',SumOfDemandOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDemandOnCulmInInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10230);
  XprocTmp.SetActiveState(4);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeDemand'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeDemand']);


  // calcule de la somme des stock des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfStockOnCulmInInternode4',SumOfStockOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfStockOnCulmInInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10240);
  XprocTmp.SetActiveState(4);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeStock'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeStock']);


  // calcule de la somme des stock des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDeficitOnCulmInInternode4',SumOfDeficitOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDeficitOnCulmInInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10250);
  XprocTmp.SetActiveState(4);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeStock'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeDeficit']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDemandOnCulmInNonInternode4',SumOfDemandOnCulmInNonInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDemandOnCulmInNonInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10260);
  XprocTmp.SetActiveState(4);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'demandOfNonINTiller'
  XprocTmp.ExternalConnect(['demandOfNonINTiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('sumOfLastdemandInOrganRec4', SumOfLastdemandInOrganRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfLastdemandInOrganRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10270);
  XprocTmp.SetActiveState(4);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'last_demand_tiller'
  XprocTmp.ExternalConnect(['last_demand_tiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('sumOfDemandInOrganOnTillerRec4', SumOfDemandInOrganOnTillerRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDemandInOrganOnTillerRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10280);
  XprocTmp.SetActiveState(4);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['day_demand_tiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDailySenescedLeafBiomassOnCulm_ng4', SumOfDailySenescedLeafBiomassOnCulm_ngDyn,['sumOfDailySenescedLeafBiomass', 'kOut']);
  XprocTmp.SetProcName('SumOfDailySenescedLeafBiomassOnCulm_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10290);
  XprocTmp.SetActiveState(4);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['sumOfDailySenescedLeafBiomassTiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDailyComputedReallocBiomassOnCulm_ng4', SumOfDailyComputedReallocBiomassOnCulm_ngDyn,['sumOfDailyComputedReallocBiomass', 'kOut']);
  XprocTmp.SetProcName('SumOfDailyComputedReallocBiomassOnCulm_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10300);
  XprocTmp.SetActiveState(4);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfDailyComputedReallocBiomassTiller'
  XprocTmp.ExternalConnect(['sumOfDailyComputedReallocBiomassTiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('ComputeSumOfInternodeBiomassOnCulm_ng4', ComputeSumOfInternodeBiomassOnCulm_ngDyn,['total', 'kOut']);
  XprocTmp.SetProcName('ComputeSumOfInternodeBiomassOnCulm_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10310);
  XprocTmp.SetActiveState(4);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfInternodeBiomass'
  XprocTmp.ExternalConnect(['sumOfInternodeBiomass']);


  procTmp := TProcInstanceInternal.Create('ComputeMaxReservoirInternodeCulm_ng4',ComputeMaxReservoirInternodeCulm_ngDyn,['maximumReserveInInternode', 'kIn', 'sumOfInternodeBiomass', 'kIn', 'maxReservoidDispoInternode', 'kOut']);
  procTmp.SetProcName('ComputeMaxReservoirInternodeCulm_ng');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10320);
  procTmp.SetActiveState(4);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour maximumReserveInternode, sumOfInternodeBiomass et maxReservoirDispoInternode
  procTmp.ExternalConnect(['maximumReserveInternode', 'sumOfInternodeBiomass', 'maxReservoirDispoInternode']);


  XprocTmp := TExtraProcInstanceInternal.Create('ComputeLengthPeduncles_ng4', ComputeLengthPeduncles_ngDyn,[]);
  XprocTmp.SetProcName('ComputeLengthPeduncles_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10330);
  XprocTmp.SetActiveState(4);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour
  XprocTmp.ExternalConnect([]);


  XprocTmp := TExtraProcInstanceInternal.Create('ComputeTotalSenescedLeafBiomass_ng4', ComputeTotalSenescedLeafBiomass_ngDyn,['totalSenescedLeafBiomass', 'kOut']);
  XprocTmp.SetProcName('ComputeTotalSenescedLeafBiomass_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10340);
  XprocTmp.SetActiveState(4);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['totalSenescedLeafBiomass']);


  // --------------------------------------------------- //
  // procedures de l'etat 5                              //
  // PRE_PI                                              //
  // --------------------------------------------------- //

  XprocTmp := TExtraProcInstanceInternal.Create('sumOfBladeAreaOnTillerInLeaf5', ComputeBladeAreaLeavesTillerDyn,['total', 'kOut']);
  XprocTmp.SetProcName('ComputeBladeAreaLeavesTiller');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10400);
  XprocTmp.SetActiveState(5);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfBladeAreaOnTillerInLeaf'
  XprocTmp.ExternalConnect(['sumOfBladeAreaOnTillerInLeaf']);


  // calcule de la somme des biomass des feuille sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('ComputeBiomassLeavesTiller5',ComputeBiomassLeavesTillerDyn,['sumOfTillerLeafBiomass', 'kOut']);
  XprocTmp.SetProcName('ComputeBiomassLeavesTiller');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10410);
  XprocTmp.SetActiveState(5);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerLeafBiomass'
  XprocTmp.ExternalConnect(['sumOfTillerLeafBiomass']);


  procTmp := TProcInstanceInternal.Create('ComputeMaxReservoirLeafCulm_ng5',ComputeMaxReservoirLeafCulm_ngDyn,['leafStockMax', 'kIn', 'sumOfLeafBiomass', 'kIn', 'maxReservoirDispoLeaf', 'kOut']);
  procTmp.SetProcName('ComputeMaxReservoirLeafCulm_ng');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10420);
  procTmp.SetActiveState(5);
  entityTiller.AddTInstance(procTmp);

  procTmp.ExternalConnect(['leafStockMax', 'sumOfTillerLeafBiomass', 'maxReservoirDispoLeaf']);


  // calcule de la somme des demand des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDemandOnCulmInInternode5',SumOfDemandOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDemandOnCulmInInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10430);
  XprocTmp.SetActiveState(5);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeDemand'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeDemand']);


  // calcule de la somme des stock des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfStockOnCulmInInternode5',SumOfStockOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfStockOnCulmInInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10440);
  XprocTmp.SetActiveState(5);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeStock'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeStock']);

  // calcule de la somme des stock des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDeficitOnCulmInInternode5',SumOfDeficitOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDeficitOnCulmInInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10450);
  XprocTmp.SetActiveState(5);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeStock'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeDeficit']);

  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDemandOnCulmInNonInternode5',SumOfDemandOnCulmInNonInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDemandOnCulmInNonInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10460);
  XprocTmp.SetActiveState(5);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'demandOfNonINTiller'
  XprocTmp.ExternalConnect(['demandOfNonINTiller']);

  XprocTmp := TExtraProcInstanceInternal.Create('sumOfLastdemandInOrganRec5', SumOfLastdemandInOrganRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfLastdemandInOrganRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10470);
  XprocTmp.SetActiveState(5);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'last_demand_tiller'
  XprocTmp.ExternalConnect(['last_demand_tiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('sumOfDemandInOrganOnTillerRec5', SumOfDemandInOrganOnTillerRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDemandInOrganOnTillerRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10480);
  XprocTmp.SetActiveState(5);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['day_demand_tiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDailySenescedLeafBiomassOnCulm_ng5', SumOfDailySenescedLeafBiomassOnCulm_ngDyn,['sumOfDailySenescedLeafBiomass', 'kOut']);
  XprocTmp.SetProcName('SumOfDailySenescedLeafBiomassOnCulm_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10490);
  XprocTmp.SetActiveState(5);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['sumOfDailySenescedLeafBiomassTiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDailyComputedReallocBiomassOnCulm_ng5', SumOfDailyComputedReallocBiomassOnCulm_ngDyn,['sumOfDailyComputedReallocBiomass', 'kOut']);
  XprocTmp.SetProcName('SumOfDailyComputedReallocBiomassOnCulm_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10500);
  XprocTmp.SetActiveState(5);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfDailyComputedReallocBiomassTiller'
  XprocTmp.ExternalConnect(['sumOfDailyComputedReallocBiomassTiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('ComputeSumOfInternodeBiomassOnCulm_ng5', ComputeSumOfInternodeBiomassOnCulm_ngDyn,['total', 'kOut']);
  XprocTmp.SetProcName('ComputeSumOfInternodeBiomassOnCulm_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10510);
  XprocTmp.SetActiveState(5);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfInternodeBiomass'
  XprocTmp.ExternalConnect(['sumOfInternodeBiomass']);


  procTmp := TProcInstanceInternal.Create('ComputeMaxReservoirInternodeCulm_ng5',ComputeMaxReservoirInternodeCulm_ngDyn,['maximumReserveInInternode', 'kIn', 'sumOfInternodeBiomass', 'kIn', 'maxReservoidDispoInternode', 'kOut']);
  procTmp.SetProcName('ComputeMaxReservoirInternodeCulm_ng');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10520);
  procTmp.SetActiveState(5);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour maximumReserveInternode, sumOfInternodeBiomass et maxReservoirDispoInternode
  procTmp.ExternalConnect(['maximumReserveInternode', 'sumOfInternodeBiomass', 'maxReservoirDispoInternode']);


  XprocTmp := TExtraProcInstanceInternal.Create('ComputeLengthPeduncles_ng5', ComputeLengthPeduncles_ngDyn,[]);
  XprocTmp.SetProcName('ComputeLengthPeduncles_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10530);
  XprocTmp.SetActiveState(5);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour
  XprocTmp.ExternalConnect([]);


  XprocTmp := TExtraProcInstanceInternal.Create('ComputeTotalSenescedLeafBiomass_ng5', ComputeTotalSenescedLeafBiomass_ngDyn,['totalSenescedLeafBiomass', 'kOut']);
  XprocTmp.SetProcName('ComputeTotalSenescedLeafBiomass_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10540);
  XprocTmp.SetActiveState(5);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['totalSenescedLeafBiomass']);


  // --------------------------------------------------- //
  // procedures de l'etat 6                              //
  // PRE_FLO                                             //
  // --------------------------------------------------- //

  XprocTmp := TExtraProcInstanceInternal.Create('sumOfBladeAreaOnTillerInLeaf6', ComputeBladeAreaLeavesTillerDyn,['total', 'kOut']);
  XprocTmp.SetProcName('ComputeBladeAreaLeavesTiller');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10600);
  XprocTmp.SetActiveState(6);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfBladeAreaOnTillerInLeaf'
  XprocTmp.ExternalConnect(['sumOfBladeAreaOnTillerInLeaf']);


  // calcule de la somme des biomass des feuille sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('ComputeBiomassLeavesTiller6',ComputeBiomassLeavesTillerDyn,['sumOfTillerLeafBiomass', 'kOut']);
  XprocTmp.SetProcName('ComputeBiomassLeavesTiller');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10610);
  XprocTmp.SetActiveState(6);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerLeafBiomass'
  XprocTmp.ExternalConnect(['sumOfTillerLeafBiomass']);


  procTmp := TProcInstanceInternal.Create('ComputeMaxReservoirLeafCulm_ng6',ComputeMaxReservoirLeafCulm_ngDyn,['leafStockMax', 'kIn', 'sumOfLeafBiomass', 'kIn', 'maxReservoirDispoLeaf', 'kOut']);
  procTmp.SetProcName('ComputeMaxReservoirLeafCulm_ng');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10620);
  procTmp.SetActiveState(6);
  entityTiller.AddTInstance(procTmp);

  procTmp.ExternalConnect(['leafStockMax', 'sumOfTillerLeafBiomass', 'maxReservoirDispoLeaf']);


  // calcule de la somme des demand des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDemandOnCulmInInternode6',SumOfDemandOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDemandOnCulmInInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10630);
  XprocTmp.SetActiveState(6);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeDemand'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeDemand']);


  // calcule de la somme des stock des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfStockOnCulmInInternode6',SumOfStockOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfStockOnCulmInInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10640);
  XprocTmp.SetActiveState(6);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeStock'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeStock']);

  // calcule de la somme des stock des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDeficitOnCulmInInternode6',SumOfDeficitOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDeficitOnCulmInInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10650);
  XprocTmp.SetActiveState(6);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeStock'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeDeficit']);

  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDemandOnCulmInNonInternode6',SumOfDemandOnCulmInNonInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDemandOnCulmInNonInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10660);
  XprocTmp.SetActiveState(6);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'demandOfNonINTiller'
  XprocTmp.ExternalConnect(['demandOfNonINTiller']);

  XprocTmp := TExtraProcInstanceInternal.Create('sumOfLastdemandInOrganRec6', SumOfLastdemandInOrganRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfLastdemandInOrganRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10670);
  XprocTmp.SetActiveState(6);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'last_demand_tiller'
  XprocTmp.ExternalConnect(['last_demand_tiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('sumOfDemandInOrganOnTillerRec6', SumOfDemandInOrganOnTillerRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDemandInOrganOnTillerRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10680);
  XprocTmp.SetActiveState(6);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['day_demand_tiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDailySenescedLeafBiomassOnCulm_ng6', SumOfDailySenescedLeafBiomassOnCulm_ngDyn,['sumOfDailySenescedLeafBiomass', 'kOut']);
  XprocTmp.SetProcName('SumOfDailySenescedLeafBiomassOnCulm_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10690);
  XprocTmp.SetActiveState(6);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['sumOfDailySenescedLeafBiomassTiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDailyComputedReallocBiomassOnCulm_ng6', SumOfDailyComputedReallocBiomassOnCulm_ngDyn,['sumOfDailyComputedReallocBiomass', 'kOut']);
  XprocTmp.SetProcName('SumOfDailyComputedReallocBiomassOnCulm_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10700);
  XprocTmp.SetActiveState(6);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfDailyComputedReallocBiomassTiller'
  XprocTmp.ExternalConnect(['sumOfDailyComputedReallocBiomassTiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('ComputeSumOfInternodeBiomassOnCulm_ng6', ComputeSumOfInternodeBiomassOnCulm_ngDyn,['total', 'kOut']);
  XprocTmp.SetProcName('ComputeSumOfInternodeBiomassOnCulm_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10710);
  XprocTmp.SetActiveState(6);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfInternodeBiomass'
  XprocTmp.ExternalConnect(['sumOfInternodeBiomass']);


  procTmp := TProcInstanceInternal.Create('ComputeMaxReservoirInternodeCulm_ng6',ComputeMaxReservoirInternodeCulm_ngDyn,['maximumReserveInInternode', 'kIn', 'sumOfInternodeBiomass', 'kIn', 'maxReservoidDispoInternode', 'kOut']);
  procTmp.SetProcName('ComputeMaxReservoirInternodeCulm_ng');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10720);
  procTmp.SetActiveState(6);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour maximumReserveInternode, sumOfInternodeBiomass et maxReservoirDispoInternode
  procTmp.ExternalConnect(['maximumReserveInternode', 'sumOfInternodeBiomass', 'maxReservoirDispoInternode']);


  XprocTmp := TExtraProcInstanceInternal.Create('ComputeLengthPeduncles_ng6', ComputeLengthPeduncles_ngDyn,[]);
  XprocTmp.SetProcName('ComputeLengthPeduncles_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10730);
  XprocTmp.SetActiveState(6);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour
  XprocTmp.ExternalConnect([]);


  XprocTmp := TExtraProcInstanceInternal.Create('ComputeTotalSenescedLeafBiomass_ng6', ComputeTotalSenescedLeafBiomass_ngDyn,['totalSenescedLeafBiomass', 'kOut']);
  XprocTmp.SetProcName('ComputeTotalSenescedLeafBiomass_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10740);
  XprocTmp.SetActiveState(6);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['totalSenescedLeafBiomass']);


  // --------------------------------------------------- //
  // procedures de l'etat 7                              //
  // FLO                                                 //
  // --------------------------------------------------- //

  XprocTmp := TExtraProcInstanceInternal.Create('sumOfBladeAreaOnTillerInLeaf7', ComputeBladeAreaLeavesTillerDyn,['total', 'kOut']);
  XprocTmp.SetProcName('ComputeBladeAreaLeavesTiller');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10800);
  XprocTmp.SetActiveState(7);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfBladeAreaOnTillerInLeaf'
  XprocTmp.ExternalConnect(['sumOfBladeAreaOnTillerInLeaf']);


  // calcule de la somme des biomass des feuille sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('ComputeBiomassLeavesTiller7',ComputeBiomassLeavesTillerDyn,['sumOfTillerLeafBiomass', 'kOut']);
  XprocTmp.SetProcName('ComputeBiomassLeavesTiller');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10810);
  XprocTmp.SetActiveState(6);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerLeafBiomass'
  XprocTmp.ExternalConnect(['sumOfTillerLeafBiomass']);


  procTmp := TProcInstanceInternal.Create('ComputeMaxReservoirLeafCulm_ng7',ComputeMaxReservoirLeafCulm_ngDyn,['leafStockMax', 'kIn', 'sumOfLeafBiomass', 'kIn', 'maxReservoirDispoLeaf', 'kOut']);
  procTmp.SetProcName('ComputeMaxReservoirLeafCulm_ng');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10820);
  procTmp.SetActiveState(7);
  entityTiller.AddTInstance(procTmp);

  procTmp.ExternalConnect(['leafStockMax', 'sumOfTillerLeafBiomass', 'maxReservoirDispoLeaf']);


  // calcule de la somme des demand des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDemandOnCulmInInternode7',SumOfDemandOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDemandOnCulmInInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10830);
  XprocTmp.SetActiveState(7);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeDemand'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeDemand']);


  // calcule de la somme des stock des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfStockOnCulmInInternode7',SumOfStockOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfStockOnCulmInInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10840);
  XprocTmp.SetActiveState(7);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeStock'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeStock']);

  // calcule de la somme des stock des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDeficitOnCulmInInternode7',SumOfDeficitOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDeficitOnCulmInInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10850);
  XprocTmp.SetActiveState(7);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeStock'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeDeficit']);

  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDemandOnCulmInNonInternode7',SumOfDemandOnCulmInNonInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDemandOnCulmInNonInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10860);
  XprocTmp.SetActiveState(7);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'demandOfNonINTiller'
  XprocTmp.ExternalConnect(['demandOfNonINTiller']);

  XprocTmp := TExtraProcInstanceInternal.Create('sumOfLastdemandInOrganRec7', SumOfLastdemandInOrganRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfLastdemandInOrganRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10870);
  XprocTmp.SetActiveState(7);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'last_demand_tiller'
  XprocTmp.ExternalConnect(['last_demand_tiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('sumOfDemandInOrganOnTillerRec7', SumOfDemandInOrganOnTillerRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDemandInOrganOnTillerRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10880);
  XprocTmp.SetActiveState(7);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['day_demand_tiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDailySenescedLeafBiomassOnCulm_ng7', SumOfDailySenescedLeafBiomassOnCulm_ngDyn,['sumOfDailySenescedLeafBiomass', 'kOut']);
  XprocTmp.SetProcName('SumOfDailySenescedLeafBiomassOnCulm_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10890);
  XprocTmp.SetActiveState(7);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['sumOfDailySenescedLeafBiomassTiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDailyComputedReallocBiomassOnCulm_ng7', SumOfDailyComputedReallocBiomassOnCulm_ngDyn,['sumOfDailyComputedReallocBiomass', 'kOut']);
  XprocTmp.SetProcName('SumOfDailyComputedReallocBiomassOnCulm_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10900);
  XprocTmp.SetActiveState(7);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfDailyComputedReallocBiomassTiller'
  XprocTmp.ExternalConnect(['sumOfDailyComputedReallocBiomassTiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('ComputeSumOfInternodeBiomassOnCulm_ng7', ComputeSumOfInternodeBiomassOnCulm_ngDyn,['total', 'kOut']);
  XprocTmp.SetProcName('ComputeSumOfInternodeBiomassOnCulm_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10910);
  XprocTmp.SetActiveState(7);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfInternodeBiomass'
  XprocTmp.ExternalConnect(['sumOfInternodeBiomass']);


  procTmp := TProcInstanceInternal.Create('ComputeMaxReservoirInternodeCulm_ng7',ComputeMaxReservoirInternodeCulm_ngDyn,['maximumReserveInInternode', 'kIn', 'sumOfInternodeBiomass', 'kIn', 'maxReservoidDispoInternode', 'kOut']);
  procTmp.SetProcName('ComputeMaxReservoirInternodeCulm_ng');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10920);
  procTmp.SetActiveState(7);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour maximumReserveInternode, sumOfInternodeBiomass et maxReservoirDispoInternode
  procTmp.ExternalConnect(['maximumReserveInternode', 'sumOfInternodeBiomass', 'maxReservoirDispoInternode']);


  XprocTmp := TExtraProcInstanceInternal.Create('ComputeLengthPeduncles_ng7', ComputeLengthPeduncles_ngDyn,[]);
  XprocTmp.SetProcName('ComputeLengthPeduncles_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10930);
  XprocTmp.SetActiveState(7);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour
  XprocTmp.ExternalConnect([]);


  XprocTmp := TExtraProcInstanceInternal.Create('ComputeTotalSenescedLeafBiomass_ng7', ComputeTotalSenescedLeafBiomass_ngDyn,['totalSenescedLeafBiomass', 'kOut']);
  XprocTmp.SetProcName('ComputeTotalSenescedLeafBiomass_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(10940);
  XprocTmp.SetActiveState(7);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['totalSenescedLeafBiomass']);


  // --------------------------------------------------- //
  // procedures de l'etat 9                              //
  // ELONG                                               //
  // --------------------------------------------------- //

  XprocTmp := TExtraProcInstanceInternal.Create('sumOfBladeAreaOnTillerInLeaf9', ComputeBladeAreaLeavesTillerDyn,['total', 'kOut']);
  XprocTmp.SetProcName('ComputeBladeAreaLeavesTiller');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(11000);
  XprocTmp.SetActiveState(9);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfBladeAreaOnTillerInLeaf'
  XprocTmp.ExternalConnect(['sumOfBladeAreaOnTillerInLeaf']);


  // calcule de la somme des biomass des feuille sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('ComputeBiomassLeavesTiller9',ComputeBiomassLeavesTillerDyn,['sumOfTillerLeafBiomass', 'kOut']);
  XprocTmp.SetProcName('ComputeBiomassLeavesTiller');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(11010);
  XprocTmp.SetActiveState(9);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerLeafBiomass'
  XprocTmp.ExternalConnect(['sumOfTillerLeafBiomass']);


  procTmp := TProcInstanceInternal.Create('ComputeMaxReservoirLeafCulm_ng9',ComputeMaxReservoirLeafCulm_ngDyn,['leafStockMax', 'kIn', 'sumOfLeafBiomass', 'kIn', 'maxReservoirDispoLeaf', 'kOut']);
  procTmp.SetProcName('ComputeMaxReservoirLeafCulm_ng');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(11020);
  procTmp.SetActiveState(9);
  entityTiller.AddTInstance(procTmp);

  procTmp.ExternalConnect(['leafStockMax', 'sumOfTillerLeafBiomass', 'maxReservoirDispoLeaf']);


  // calcule de la somme des demand des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDemandOnCulmInInternode9',SumOfDemandOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDemandOnCulmInInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(11030);
  XprocTmp.SetActiveState(9);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeDemand'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeDemand']);


  // calcule de la somme des stock des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfStockOnCulmInInternode9',SumOfStockOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfStockOnCulmInInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(11040);
  XprocTmp.SetActiveState(9);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeStock'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeStock']);

  // calcule de la somme des stock des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDeficitOnCulmInInternode9',SumOfDeficitOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDeficitOnCulmInInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(11050);
  XprocTmp.SetActiveState(9);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeStock'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeDeficit']);

  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDemandOnCulmInNonInternode9',SumOfDemandOnCulmInNonInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDemandOnCulmInNonInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(11060);
  XprocTmp.SetActiveState(9);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'demandOfNonINTiller'
  XprocTmp.ExternalConnect(['demandOfNonINTiller']);

  XprocTmp := TExtraProcInstanceInternal.Create('sumOfLastdemandInOrganRec9', SumOfLastdemandInOrganRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfLastdemandInOrganRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(11070);
  XprocTmp.SetActiveState(9);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'last_demand_tiller'
  XprocTmp.ExternalConnect(['last_demand_tiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('sumOfDemandInOrganOnTillerRec9', SumOfDemandInOrganOnTillerRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDemandInOrganOnTillerRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(11080);
  XprocTmp.SetActiveState(9);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['day_demand_tiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDailySenescedLeafBiomassOnCulm_ng9', SumOfDailySenescedLeafBiomassOnCulm_ngDyn,['sumOfDailySenescedLeafBiomass', 'kOut']);
  XprocTmp.SetProcName('SumOfDailySenescedLeafBiomassOnCulm_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(11090);
  XprocTmp.SetActiveState(9);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['sumOfDailySenescedLeafBiomassTiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDailyComputedReallocBiomassOnCulm_ng9', SumOfDailyComputedReallocBiomassOnCulm_ngDyn,['sumOfDailyComputedReallocBiomass', 'kOut']);
  XprocTmp.SetProcName('SumOfDailyComputedReallocBiomassOnCulm_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(11100);
  XprocTmp.SetActiveState(9);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfDailyComputedReallocBiomassTiller'
  XprocTmp.ExternalConnect(['sumOfDailyComputedReallocBiomassTiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('ComputeSumOfInternodeBiomassOnCulm_ng9', ComputeSumOfInternodeBiomassOnCulm_ngDyn,['total', 'kOut']);
  XprocTmp.SetProcName('ComputeSumOfInternodeBiomassOnCulm_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(11110);
  XprocTmp.SetActiveState(9);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfInternodeBiomass'
  XprocTmp.ExternalConnect(['sumOfInternodeBiomass']);


  procTmp := TProcInstanceInternal.Create('ComputeMaxReservoirInternodeCulm_ng9',ComputeMaxReservoirInternodeCulm_ngDyn,['maximumReserveInInternode', 'kIn', 'sumOfInternodeBiomass', 'kIn', 'maxReservoidDispoInternode', 'kOut']);
  procTmp.SetProcName('ComputeMaxReservoirInternodeCulm_ng');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(11120);
  procTmp.SetActiveState(9);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour maximumReserveInternode, sumOfInternodeBiomass et maxReservoirDispoInternode
  procTmp.ExternalConnect(['maximumReserveInternode', 'sumOfInternodeBiomass', 'maxReservoirDispoInternode']);


  XprocTmp := TExtraProcInstanceInternal.Create('ComputeLengthPeduncles_ng9', ComputeLengthPeduncles_ngDyn,[]);
  XprocTmp.SetProcName('ComputeLengthPeduncles_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(11130);
  XprocTmp.SetActiveState(9);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour
  XprocTmp.ExternalConnect([]);


  XprocTmp := TExtraProcInstanceInternal.Create('ComputeTotalSenescedLeafBiomass_ng9', ComputeTotalSenescedLeafBiomass_ngDyn,['totalSenescedLeafBiomass', 'kOut']);
  XprocTmp.SetProcName('ComputeTotalSenescedLeafBiomass_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(11140);
  XprocTmp.SetActiveState(9);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['totalSenescedLeafBiomass']);


  // --------------------------------------------------- //
  // procedures de l'etat 10                             //
  // PRE_ELONG                                           //
  // --------------------------------------------------- //

  procTmp := TProcInstanceInternal.Create('dispStock_Tiller10', DispDyn, ['value', 'kIn']);
  procTmp.SetProcName('Disp');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(11200);
  procTmp.SetActiveState(10);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour 'stock_tiller'
  procTmp.ExternalConnect(['stock_tiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('sumOfBladeAreaOnTillerInLeaf10', ComputeBladeAreaLeavesTillerDyn,['total', 'kOut']);
  XprocTmp.SetProcName('ComputeBladeAreaLeavesTiller');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(11210);
  XprocTmp.SetActiveState(10);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfBladeAreaOnTillerInLeaf'
  XprocTmp.ExternalConnect(['sumOfBladeAreaOnTillerInLeaf']);


  // calcule de la somme des biomass des feuille sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('ComputeBiomassLeavesTiller10',ComputeBiomassLeavesTillerDyn,['sumOfTillerLeafBiomass', 'kOut']);
  XprocTmp.SetProcName('ComputeBiomassLeavesTiller');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(11220);
  XprocTmp.SetActiveState(10);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerLeafBiomass'
  XprocTmp.ExternalConnect(['sumOfTillerLeafBiomass']);


  procTmp := TProcInstanceInternal.Create('ComputeMaxReservoirLeafCulm_ng10',ComputeMaxReservoirLeafCulm_ngDyn,['leafStockMax', 'kIn', 'sumOfLeafBiomass', 'kIn', 'maxReservoirDispoLeaf', 'kOut']);
  procTmp.SetProcName('ComputeMaxReservoirLeafCulm_ng');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(11230);
  procTmp.SetActiveState(10);
  entityTiller.AddTInstance(procTmp);

  procTmp.ExternalConnect(['leafStockMax', 'sumOfTillerLeafBiomass', 'maxReservoirDispoLeaf']);


  // calcule de la somme des demand des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDemandOnCulmInInternode10',SumOfDemandOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDemandOnCulmInInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(11240);
  XprocTmp.SetActiveState(10);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeDemand'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeDemand']);


  // calcule de la somme des stock des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfStockOnCulmInInternode10',SumOfStockOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfStockOnCulmInInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(11250);
  XprocTmp.SetActiveState(10);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeStock'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeStock']);

  // calcule de la somme des stock des entrenoeuds sur la talle
  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDeficitOnCulmInInternode10',SumOfDeficitOnCulmInInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDeficitOnCulmInInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(11260);
   XprocTmp.SetActiveState(10);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfTillerInternodeStock'
  XprocTmp.ExternalConnect(['sumOfTillerInternodeDeficit']);

  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDemandOnCulmInNonInternode10',SumOfDemandOnCulmInNonInternodeDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDemandOnCulmInNonInternode');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(11270);
  XprocTmp.SetActiveState(10);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'demandOfNonINTiller'
  XprocTmp.ExternalConnect(['demandOfNonINTiller']);

  XprocTmp := TExtraProcInstanceInternal.Create('sumOfLastdemandInOrganRec10', SumOfLastdemandInOrganRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfLastdemandInOrganRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(11280);
  XprocTmp.SetActiveState(10);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'last_demand_tiller'
  XprocTmp.ExternalConnect(['last_demand_tiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('setUpTillerStockPre_Elong_ng10', SetUpTillerStockPre_Elong_ngDyn,[]);
  XprocTmp.SetProcName('SetUpTillerStockPre_Elong_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(11290);
  XprocTmp.SetActiveState(10);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour ''
  XprocTmp.ExternalConnect([]);


  XprocTmp := TExtraProcInstanceInternal.Create('sumOfDemandInOrganOnTillerRec10', SumOfDemandInOrganOnTillerRecDyn,['total', 'kOut']);
  XprocTmp.SetProcName('SumOfDemandInOrganOnTillerRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(11300);
  XprocTmp.SetActiveState(10);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['day_demand_tiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDailySenescedLeafBiomassOnCulm_ng10', SumOfDailySenescedLeafBiomassOnCulm_ngDyn,['sumOfDailySenescedLeafBiomass', 'kOut']);
  XprocTmp.SetProcName('SumOfDailySenescedLeafBiomassOnCulm_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(11310);
  XprocTmp.SetActiveState(10);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['sumOfDailySenescedLeafBiomassTiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('SumOfDailyComputedReallocBiomassOnCulm_ng10', SumOfDailyComputedReallocBiomassOnCulm_ngDyn,['sumOfDailyComputedReallocBiomass', 'kOut']);
  XprocTmp.SetProcName('SumOfDailyComputedReallocBiomassOnCulm_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(11320);
  XprocTmp.SetActiveState(10);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfDailyComputedReallocBiomassTiller'
  XprocTmp.ExternalConnect(['sumOfDailyComputedReallocBiomassTiller']);


  XprocTmp := TExtraProcInstanceInternal.Create('ComputeSumOfInternodeBiomassOnCulm_ng10', ComputeSumOfInternodeBiomassOnCulm_ngDyn,['total', 'kOut']);
  XprocTmp.SetProcName('ComputeSumOfInternodeBiomassOnCulm_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(11330);
  XprocTmp.SetActiveState(10);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'sumOfInternodeBiomass'
  XprocTmp.ExternalConnect(['sumOfInternodeBiomass']);


  procTmp := TProcInstanceInternal.Create('ComputeMaxReservoirInternodeCulm_ng10',ComputeMaxReservoirInternodeCulm_ngDyn,['maximumReserveInInternode', 'kIn', 'sumOfInternodeBiomass', 'kIn', 'maxReservoidDispoInternode', 'kOut']);
  procTmp.SetProcName('ComputeMaxReservoirInternodeCulm_ng');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(11340);
  procTmp.SetActiveState(10);
  entityTiller.AddTInstance(procTmp);

  // connection port <-> attribut pour maximumReserveInternode, sumOfInternodeBiomass et maxReservoirDispoInternode
  procTmp.ExternalConnect(['maximumReserveInternode', 'sumOfInternodeBiomass', 'maxReservoirDispoInternode']);


  XprocTmp := TExtraProcInstanceInternal.Create('ComputeLengthPeduncles_ng10', ComputeLengthPeduncles_ngDyn,[]);
  XprocTmp.SetProcName('ComputeLengthPeduncles_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(11350);
  XprocTmp.SetActiveState(10);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour
  XprocTmp.ExternalConnect([]);


  XprocTmp := TExtraProcInstanceInternal.Create('ComputeTotalSenescedLeafBiomass_ng10', ComputeTotalSenescedLeafBiomass_ngDyn,['totalSenescedLeafBiomass', 'kOut']);
  XprocTmp.SetProcName('ComputeTotalSenescedLeafBiomass_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(11360);
  XprocTmp.SetActiveState(10);
  entityTiller.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'day_demand_tiller'
  XprocTmp.ExternalConnect(['totalSenescedLeafBiomass']);


  // fin de definition des procedure

  // retourne la talle créée
  result := entityTiller;

end;
end.
