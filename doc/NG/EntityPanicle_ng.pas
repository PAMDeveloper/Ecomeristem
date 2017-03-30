// ---------------------------------------------------------------------------
/// creation et importation d'une entité panicle générique pour EcoMeristem_LE
///
/// Description :
//
// ---------------------------------------------------------------------------
(** @Author Jean-Christophe SOULIE
    @Version 04/02/2010 LT v0.0 version initiale; statut : en cours *)


unit EntityPanicle_ng;

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
  ManagerMeristem_ng,
  ClassTExtraProcInstanceInternal,
  DefinitionConstant, Dialogs;

function ImportPanicle_ng(const name : string; spike_creation_rate, grain_filling_rate, grain_per_cm, gdw_empty, gdw, Tb, n, isOnMainstem : Double) : TEntityInstance;

implementation

function ImportPanicle_ng(const name : string; spike_creation_rate, grain_filling_rate, grain_per_cm, gdw_empty, gdw, Tb, n, isOnMainstem : Double) : TEntityInstance;
var
  parameterTmp : TParameter;
  entityPanicle : TEntityInstance;
  attributeTmp : TAttributeTmp;
  procTmp : TProcInstanceInternal;
  managerTmp : TManagerInternal;
  initSample : TSample;
begin
  entityPanicle := TEntityInstance.Create('',
                        ['degreeDayForInitiation','kIn',
                        'degreeDayForRealization','kIn',
                        'testIc','kIn',
                        'fcstr','kIn',
                        'phenoStage','kIn',
                        'Tair','kIn',
                        'plasto_delay','kIn',
                        'thresINER','kIn',
                        'slopeINER','kIn',
                        'FTSW','kIn',
                        'P','kIn']);

  entityPanicle.SetName(name);
  entityPanicle.SetCategory('Panicle');

  attributeTmp := TAttributeTmp.Create('predimOfPreviousInternode');
  entityPanicle.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('predimInternodeOnMainstem');
  entityPanicle.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('predim');
  entityPanicle.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('DDInitiation');
  entityPanicle.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('DDRealization');
  entityPanicle.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('plasto_delay');
  entityPanicle.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('thresINER');
  entityPanicle.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('slopeINER');
  entityPanicle.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('phenoStage');
  entityPanicle.AddTAttribute(attributeTmp);

  parameterTmp := TParameter.Create('spike_creation_rate', spike_creation_rate);
  entityPanicle.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('isOnMainstem', isOnMainstem);
  entityPanicle.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('creation_phenostage', n);
  entityPanicle.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('Tb', Tb);
  entityPanicle.AddTAttribute(parameterTmp);

  initSample.date := 0;
  initSample.value := 0;
  attributeTmp := TAttributeTmp.Create('grain_nb');
  attributeTmp.SetSample(initSample);
  entityPanicle.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('fertile_grain_number');
  entityPanicle.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('filled_grain_nb');
  entityPanicle.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('height_panicle');
  entityPanicle.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('day_demand_panicle');
  entityPanicle.AddTAttribute(attributeTmp);

  initSample.date := 0;
  initSample.value := 0;
  attributeTmp := TAttributeTmp.Create('weight_panicle');
  attributeTmp.SetSample(initSample);
  entityPanicle.AddTAttribute(attributeTmp);

  initSample.date := 0;
  initSample.value := 1;
  attributeTmp := TAttributeTmp.Create('firstDayOfFLO');
  attributeTmp.SetSample(initSample);
  entityPanicle.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('length_panicle');
  entityPanicle.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('testIc');
  entityPanicle.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('fcstr');
  entityPanicle.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('phenoStage');
  entityPanicle.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('Tair');
  entityPanicle.AddTAttribute(attributeTmp);

  parameterTmp := TParameter.Create('zero', 0);
  entityPanicle.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('gdw_empty', gdw_empty);
  entityPanicle.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('gdw', gdw);
  entityPanicle.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('grain_filling_rate', grain_filling_rate);
  entityPanicle.AddTAttribute(parameterTmp);

  attributeTmp := TAttributeTmp.Create('FTSW');
  entityPanicle.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('boolCrossedPlasto');
  entityPanicle.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('length_peduncle');
  entityPanicle.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('P');
  entityPanicle.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('time_from_app');
  entityPanicle.AddTAttribute(attributeTmp);

  parameterTmp := TParameter.Create('grain_per_cm', grain_per_cm);
  entityPanicle.AddTAttribute(parameterTmp);

  attributeTmp := TAttributeTmp.Create('reservoir_dispo_panicle');
  entityPanicle.AddTAttribute(attributeTmp);

  entityPanicle.InternalConnect(['DDInitiation',
                                 'DDRealization',
                                 'testIc',
                                 'fcstr',
                                 'phenoStage',
                                 'Tair',
                                 'plasto_delay',
                                 'thresINER',
                                 'slopeINER',
                                 'FTSW',
                                 'P']);

  // creation de 'initTimeFromApp'
  procTmp := TProcInstanceInternal.Create('initTimeFromApp',IdentityDyn,['inValue','kIn','outValue','kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10);
  procTmp.SetActiveState(1);
  entityPanicle.AddTInstance(procTmp);

  // connection port <-> attribut pour 'initTimeFromApp' de 'EntityLeaf'
  procTmp.ExternalConnect(['DDInitiation','time_from_app']);

  // creation de 'computePanicleGrainNb'
  procTmp := TProcInstanceInternal.Create('computePanicleGrainNb', ComputePanicleGrainNb_LEDyn, ['spikeCreationRate', 'kIn', 'Tair', 'kIn', 'Tb', 'kIn', 'fcstr', 'kIn', 'testIc', 'kIn', 'grainNb', 'kInOut']);
  procTmp.SetExeStep(1);
  procTmp.SetExeOrder(20);
  procTmp.SetActiveState(1);
  entityPanicle.AddTInstance(procTmp);

  // connection port <-> attribut pour 'computePanicleGrainNb'
  procTmp.ExternalConnect(['spike_creation_rate', 'Tair', 'Tb', 'fcstr', 'testIc', 'grain_nb']);

  // creation de 'computePanicleFertileGrainNb'
  procTmp := TProcInstanceInternal.Create('computePanicleFertileGrainNb', IdentityDyn,['inValue','kIn','outValue','kOut']);
  procTmp.SetExeStep(1);
  procTmp.SetExeOrder(30);
  procTmp.SetActiveState(1);
  entityPanicle.AddTInstance(procTmp);

  // connection port <-> attribut pour 'computePanicleFertileGrainNb'
  procTmp.ExternalConnect(['grain_nb','fertile_grain_number']);

  // --------------------------------------------------------------------------
  // procedure à l'état 2 (TRANSITION_TO_FLO)
  // --------------------------------------------------------------------------

  // creation de 'computePanicleFertileGrainNb'
  procTmp := TProcInstanceInternal.Create('computePanicleFertileGrainNb_LE', ComputePanicleFertileGrainNumber_LEDyn,['fcstr', 'kIn', 'testIc', 'kIn', 'fertileGrainNumber', 'kInOut']);
  procTmp.SetExeStep(1);
  procTmp.SetExeOrder(400);
  procTmp.SetActiveState(2);
  entityPanicle.AddTInstance(procTmp);

  // connection port <-> attribut pour 'computePanicleFertileGrainNb_LE'
  procTmp.ExternalConnect(['fcstr','testIc','fertile_grain_number']);

  // --------------------------------------------------------------------------
  // procedures à l'état 3 (FLO)
  // --------------------------------------------------------------------------

  procTmp := TProcInstanceInternal.Create('computePanicleReservoirDispo',ComputePanicleReservoirDispoDyn,['fertileGrainNumber', 'kIn', 'gdw', 'kIn', 'weight', 'kIn', 'reservoirDispo', 'kOut']);
  procTmp.SetExeStep(1);
  procTmp.SetExeOrder(900);
  procTmp.SetActiveState(3);
  entityPanicle.AddTInstance(procTmp);

  // connection port <-> attribut pour 'computePanicleReservoirDispo'
  procTmp.ExternalConnect(['fertile_grain_number', 'gdw', 'weight_panicle', 'reservoir_dispo_panicle']);


  procTmp := TProcInstanceInternal.Create('computePanicleDayDemandFlo_LE',ComputePanicleDayDemandFlo_LEDyn,['grainFillingRate', 'kIn', 'Tair', 'kIn', 'Tb', 'kIn', 'fcstr', 'kIn', 'testIc', 'kIn', 'reservoirDispo', 'kIn', 'panicleDayDemand', 'kOut']);
  procTmp.SetExeStep(1);
  procTmp.SetExeOrder(1000);
  procTmp.SetActiveState(3);
  entityPanicle.AddTInstance(procTmp);

  // connection port <-> attribut pour 'computePanicleDayDemandFlo_LE'
  procTmp.ExternalConnect(['grain_filling_rate','Tair','Tb','fcstr','testIc','reservoir_dispo_panicle','day_demand_panicle']);


  // creation de 'computePanicleWeight'
  procTmp := TProcInstanceInternal.Create('computePanicleWeightFlo_LE', ComputePanicleWeightFlo_LEDyn,['panicleDayDemand', 'kIn', 'panicleWeight', 'kInOut']);
  procTmp.SetExeStep(1);
  procTmp.SetExeOrder(1100);
  procTmp.SetActiveState(3);
  entityPanicle.AddTInstance(procTmp);

  // connection port <-> attribut pour 'computePanicleWeightFlo'
  procTmp.ExternalConnect(['day_demand_panicle','weight_panicle']);

  procTmp := TProcInstanceInternal.Create('computePanicleFilledGrainNbFlo_LE', ComputePanicleFilledGrainNbFlo_LEDyn,['fertileGrainNb', 'kIn', 'panicleWeight', 'kIn', 'gdw', 'kIn', 'filledGrainNb', 'kOut']);
  procTmp.SetExeStep(1);
  procTmp.SetExeOrder(1200);
  procTmp.SetActiveState(3);
  entityPanicle.AddTInstance(procTmp);

  // connection port <-> attribut pour 'computePanicleFilledGrainNbtFlo_LE'
  procTmp.ExternalConnect(['fertile_grain_number','weight_panicle','gdw','filled_grain_nb']);

  ////////////////////////////////////////////////////////
  // ajout d'un manageur
  ////////////////////////////////////////////////////////
  managerTmp := TManagerInternal.Create('panicleManager_ng',PanicleManager_ng);
  managerTmp.SetExeMode(intra);
  managerTmp.SetExeOrder(500);
  entityPanicle.AddTManager(managerTmp);

  result := entityPanicle;
end;

end.
 