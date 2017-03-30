// ---------------------------------------------------------------------------
/// creation et importation d'une entité entrenoeud générique pour le modele
/// EcoMeristem_LE
///
/// Description :
//
// ----------------------------------------------------------------------------
(** @Author JCS and DL *)

unit EntityInternode_ng;

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
  ClassTExtraProcInstanceInternal,
  DefinitionConstant,
  Dialogs;

function ImportInternode_ng(const name : string; const phenoStageAtCreation, MGR, plasto, Tb, resp_INER, LIN1, IN_A, IN_B, density_In, leaf_width_to_IN_diameter, leaf_length_to_IN_length, leafLength, leafWidth, MaximumReserveInInternode : double ; const isFirstInterNode : Double = 0 ; const isOnMainstem : Double = 0) : TEntityInstance;

implementation

// ----------------------------------------------------------------------------
//  fonction ImportInternode_LE
//  ---------------------------
//
/// creation et importation d'une entité entrenoeud générique
///
/// Description :
/// Une feuille est une entité générique. Ses paramètres sont :
/// - isFirstInterNode : indique si l'entrenoeud est le premier entrenoeud de l organe
///     porteur. Si c'est le cas, ce parametre vaut 1 sinon il vaut 0.
/// - isOnMainstem : indique si l'entrenoeud est sur le brin maitre. Si c'est le
///     cas, ce parametre vaut 1 sinon il vaut 0.


function ImportInternode_ng(const name : string; const phenoStageAtCreation, MGR, plasto, Tb, resp_INER, LIN1, IN_A, IN_B, density_In, leaf_width_to_IN_diameter, leaf_length_to_IN_length, leafLength, leafWidth, MaximumReserveInInternode : double ; const isFirstInterNode : Double = 0 ; const isOnMainstem : Double = 0) : TEntityInstance;
var
  parameterTmp : TParameter;
  entityInternode : TEntityInstance;
  attributeTmp : TAttributeTmp;
  procTmp : TProcInstanceInternal;
  managerTmp : TManagerInternal;
  XprocTmp : TExtraProcInstanceInternal;
  initSample : TSample;
begin
  entityInternode := TEntityInstance.Create('',
                        ['degreeDayForInitiation','kIn',
                        'degreeDayForRealization','kIn',
                        'testIc','kIn',
                        'fcstr','kIn',
                        'phenoStage','kIn',
                        'stockCulm','kIn',
                        'Tair','kIn',
                        'plasto_delay','kIn',
                        'thresINER','kIn',
                        'slopeINER','kIn',
                        'FTSW','kIn',
                        'P','kIn']);

  entityInternode.SetName(name);
  entityInternode.SetCategory('Internode');

  // ----------------------------------------------
  // creation des attributs dans 'EntityInternode'
  // ----------------------------------------------

  attributeTmp := TAttributeTmp.Create('time_from_app');
  entityInternode .AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('INER');
  entityInternode.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('Volume');
  entityInternode.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('exp_time');
  entityInternode.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('predim');
  entityInternode.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('stock_culm');
  entityInternode.AddTAttribute(attributeTmp);

  parameterTmp := TParameter.Create('density_IN', density_IN);
  entityInternode.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('MaximumReserveInInternode', MaximumReserveInInternode);
  entityInternode.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('leaf_width_to_IN_diameter', leaf_width_to_IN_diameter);
  entityInternode.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('phenoStageAtCreation', phenoStageAtCreation);
  entityInternode.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('leafWidth', leafWidth);
  entityInternode.AddTAttribute(parameterTmp);

  attributeTmp := TAttributeTmp.Create('DDInitiation');
  entityInternode.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('DDRealization');
  entityInternode.AddTAttribute(attributeTmp);

  parameterTmp := TParameter.Create('isFirstInternode', isFirstInterNode);
  entityInternode.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('isOnMainstem', isOnMainstem);
  entityInternode.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('MGR', MGR);
  entityInternode.AddTAttribute(parameterTmp);

  attributeTmp := TAttributeTmp.Create('testIc');
  entityInternode.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('fcstr');
  entityInternode.AddTAttribute(attributeTmp);

  parameterTmp := TParameter.Create('plasto', plasto);
  entityInternode.AddTAttribute(parameterTmp);

  attributeTmp := TAttributeTmp.Create('phenoStage');
  entityInternode.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('rank');
  entityInternode.AddTAttribute(attributeTmp);

  parameterTmp := TParameter.Create('ligulo', plasto);
  entityInternode.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('IN_A', IN_A);   // OK
  entityInternode.AddTAttribute(parameterTmp);       // OK

  parameterTmp := TParameter.Create('IN_B',IN_B);    // OK
  entityInternode.AddTAttribute(parameterTmp);       // OK

  parameterTmp := TParameter.Create('RER');
  entityInternode.AddTAttribute(parameterTmp);

  attributeTmp := TAttributeTmp.Create('SSL');
  entityInternode.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('stockIN');
  entityInternode.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('deficitIN');
  entityInternode.AddTAttribute(attributeTmp);

  parameterTmp := TParameter.Create('Tb',Tb);
  entityInternode.AddTAttribute(parameterTmp);

  attributeTmp := TAttributeTmp.Create('Tair');
  entityInternode.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('deltaT');
  entityInternode.AddTAttribute(attributeTmp);

  parameterTmp := TParameter.Create('one',1);
  entityInternode.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('zero',0);
  entityInternode.AddTAttribute(parameterTmp);

  attributeTmp := TAttributeTmp.Create('biomassIN');
  entityInternode.AddTAttribute(attributeTmp);

  initSample.date := 0; initSample.value := 0;
  attributeTmp := TAttributeTmp.Create('lastdemand',initSample);
  entityInternode.AddTAttribute(attributeTmp);

  initSample.date := 0; initSample.value := 0;
  attributeTmp := TAttributeTmp.Create('demandIN',initSample);
  entityInternode.AddTAttribute(attributeTmp);

  parameterTmp := TParameter.Create('LIN1', LIN1);
  entityInternode.AddTAttribute(parameterTmp);

  attributeTmp := TAttributeTmp.Create('DIN');
  entityInternode.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('LIN');
  entityInternode.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('plasto_delay');
  entityInternode.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('thresINER');
  entityInternode.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('slopeINER');
  entityInternode.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('FTSW');
  entityInternode.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('lig');
  entityInternode.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('reductionINER');
  entityInternode.AddTAttribute(attributeTmp);

  parameterTmp := TParameter.Create('resp_INER', resp_INER);
  entityInternode.AddTAttribute(parameterTmp);

  attributeTmp := TAttributeTmp.Create('P');
  entityInternode.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('sumOfInternodeBiomassOnCulm');
  entityInternode.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('reservoirDispoIN');
  entityInternode.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('leafLength');
  entityInternode.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('leaf_length_to_IN_length');
  entityInternode.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('slope_length_IN');
  entityInternode.AddTAttribute(attributeTmp);

  parameterTmp := TParameter.Create('leafLength',leafLength);
  entityInternode.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('leaf_length_to_IN_length',leaf_length_to_IN_length);
  entityInternode.AddTAttribute(parameterTmp);

  initSample.date := 0; initSample.value := 0;
  attributeTmp := TAttributeTmp.Create('lastdemand', initSample);
  entityInternode.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('IN_length_to_IN_diam');
  entityInternode.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('coef_lin_IN_diam');
  entityInternode.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('no_growth_at_init');
  entityInternode.AddTAttribute(attributeTmp);


  /////////////////////////////////////////////////////////////////////////////
  // Connections internes des ports
  /////////////////////////////////////////////////////////////////////////////

  // connection port <-> attribut pour 'EntityInternode'
  entityInternode.InternalConnect(['DDInitiation',
                                   'DDRealization',
                                   'testIc',
                                   'fcstr',
                                   'phenoStage',
                                   'stock_culm',
                                   'Tair',
                                   'plasto_delay',
                                   'thresINER',
                                   'slopeINER',
                                   'FTSW',
                                   'P']);

  /////////////////////////////////////////////////////////////////////////////
  // Modules active en permanance
  /////////////////////////////////////////////////////////////////////////////

  XprocTmp := TExtraProcInstanceInternal.Create('InternodeTransitionToActive_ng',InternodeTransitionToActive_ngDyn,[]);
  XprocTmp.SetProcName('InternodeTransitionToActive_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(2);
  entityInternode.AddTInstance(XprocTmp);
  // connection port <-> attribut
  XprocTmp.ExternalConnect([]);

  /////////////////////////////////////////////////////////////////////////////
  // Modules pour l'etat vegetatif
  /////////////////////////////////////////////////////////////////////////////

  // creation de 'lengthZero'

  procTmp := TProcInstanceInternal.Create('lengthZero', IdentityDyn, ['inValue', 'kIn', 'outValue', 'kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1);
  procTmp.SetExeOrder(3);
  procTmp.SetActiveState(2000);
  entityInternode.AddTInstance(procTmp);
  // connection port <-> attribut pour lengthZero
  procTmp.ExternalConnect(['zero', 'LIN']);

  // creation de 'diameterZeo'

  procTmp := TProcInstanceInternal.Create('diameterZero2000', IdentityDyn, ['inValue', 'kIn', 'outValue', 'kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1);
  procTmp.SetExeOrder(4);
  procTmp.SetActiveState(2000);
  entityInternode.AddTInstance(procTmp);
  // connection prot <-> attribut pour diameterZero
  procTmp.ExternalConnect(['zero', 'DIN']);


  /////////////////////////////////////////////////////////////////////////////
  // Modules pour l'état initiation
  /////////////////////////////////////////////////////////////////////////////


  // creation de 'initTimeFromApp'
  procTmp := TProcInstanceInternal.Create('initTimeFromApp',IdentityDyn,['inValue','kIn','outValue','kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10);
  procTmp.SetActiveState(1);
  entityInternode.AddTInstance(procTmp);
  // connection port <-> attribut pour 'initTimeFromApp' de 'EntityInternode'
  procTmp.ExternalConnect(['DDInitiation','time_from_app']);

  // creation de 'initInternodeLengthPredim'
  XprocTmp := TExtraProcInstanceInternal.Create('initInternodeLengthPredim',ComputeInternodeLengthPredimDyn,['slopeLengthIN', 'kIn', 'leafLengthToINLength', 'kIn', 'internodeLengthPredim', 'kOut']);
  XprocTmp.SetProcName('ComputeInternodeLengthPredim');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(20);
  XprocTmp.SetActiveState(1);
  entityInternode.AddTInstance(XprocTmp);
  // connection port <-> attribut pour 'slope_length_IN', 'leaf_length_to_IN_length', 'predim' de 'EntityInternode'
  XprocTmp.ExternalConnect(['slope_length_IN', 'leaf_length_to_IN_length', 'predim']);

  // creation de 'initInternodeDiameterPredim'
  procTmp := TProcInstanceInternal.Create('initInternodeDiameterPredim',ComputeInternodeDiameterPredim2Dyn,['INLengthToINDiam', 'kIn', 'coefLinINDIam', 'kIn', 'internodeLengthPredim', 'kIn', 'internodeDiameterPredim', 'kOut']);
  procTmp.SetProcName('ComputeInternodeDiameterPredim2');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(30);
  procTmp.SetActiveState(1);
  entityInternode.AddTInstance(procTmp);
  // connection port <-> attribut pour 'IN_length_to_IN_diam', 'coef_lin_IN_diam', 'predim', 'DIN' de 'EntityInternode'
  procTmp.ExternalConnect(['IN_length_to_IN_diam', 'coef_lin_IN_diam', 'predim', 'DIN']);

  //creation de 'initReductionINER'
  procTmp := TProcInstanceInternal.Create('initReductionINER',ComputeReductionINER_ngDyn,['FTSW','kIn','ThresINER','kIn','SlopeINER','kIn','P','kIn','resp_INER','kIn','testIc','kIn','reductionINER','kOut']);
  procTmp.SetProcName('ComputeReductionINER_ng');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(40);
  procTmp.SetActiveState(1);
  entityInternode.AddTInstance(procTmp);
  // connection port <-> attribut pour 'initReductionINER' de 'EntityInternode'
  procTmp.ExternalConnect(['FTSW','thresINER','slopeINER','P','resp_INER','testIc','reductionINER']);

  // creation de 'initINER'
  procTmp := TProcInstanceInternal.Create('initINER',ComputeINER_LEDyn,['predimOfCurrentInternode','kIn','reductionINER','kIn','plasto','kIn','phenoStage','kIn','ligulo','kIn','INER','kOut']);
  procTmp.SetProcName('ComputeINER_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(50);
  procTmp.SetActiveState(1);
  entityInternode.AddTInstance(procTmp);
  // connection port <-> attribut pour 'initINER' de 'EntityInternode'
  procTmp.ExternalConnect(['predim','reductionINER','plasto','rank','ligulo','INER']);

  // creation de 'initLen'
  procTmp := TProcInstanceInternal.Create('initLen',Mult2ValuesDyn,['inValue1','kIn','inValue2','kIn','outValue','kOut']);
  procTmp.SetProcName('Mult2Values');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(60);
  procTmp.SetActiveState(1);
  entityInternode.AddTInstance(procTmp);

  // connection port <-> attribut pour 'initLen' de 'EntityInternode'
  procTmp.ExternalConnect(['INER','DDInitiation','LIN']);

  {debut affichage des paramètres}

  // creation de 'dispINER'
  procTmp := TProcInstanceInternal.Create('dispINER',DispDyn,['value','kIn']);
  procTmp.SetProcName('Disp');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(70);
  procTmp.SetActiveState(1);
  entityInternode.AddTInstance(procTmp);

  // connection port <-> attribut pour 'initLen' de 'EntityInternode'
  procTmp.ExternalConnect(['INER']);


  // creation de 'dispDDRealization'
  procTmp := TProcInstanceInternal.Create('dispDDInitiation',DispDyn,['value','kIn']);
  procTmp.SetProcName('Disp');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(80);
  procTmp.SetActiveState(1);
  entityInternode.AddTInstance(procTmp);

  // connection port <-> attribut pour 'initLen' de 'EntityInternode'
  procTmp.ExternalConnect(['DDInitiation']);


  // creation de 'dispLIN'
  procTmp := TProcInstanceInternal.Create('dispLIN',DispDyn,['value','kIn']);
  procTmp.SetProcName('Disp');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(90);
  procTmp.SetActiveState(1);
  entityInternode.AddTInstance(procTmp);

  // connection port <-> attribut pour 'initLen' de 'EntityInternode'
  procTmp.ExternalConnect(['LIN']);



  {fin affichage des paramètres}

  // creation de 'initVolume'
  procTmp := TProcInstanceInternal.Create('initVolume',ComputeInternodeVolumeDyn,['Length', 'kIn', 'Diameter', 'kIn', 'Volume', 'kOut']);
  procTmp.SetProcName('ComputeInternodeVolume');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(100);
  procTmp.SetActiveState(1);
  entityInternode.AddTInstance(procTmp);

  // connection port <-> attribut pour 'initVolume' de 'EntityInternode'
  procTmp.ExternalConnect(['LIN','DIN','Volume']);

  // creation de 'initExp_Time'
  procTmp := TProcInstanceInternal.Create('initExp_Time',ComputeInternodeExpTime_LEDyn,['isFirstInternode','kIn','isOnMainstem','kIn','predim','kIn','len','kIn','LER','kIn','exp_time','kOut']);
  procTmp.SetProcName('ComputeInternodeExpTime_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(110);
  procTmp.SetActiveState(1);
  entityInternode.AddTInstance(procTmp);

  // connection port <-> attribut pour 'initExp_Time' de 'EntityInternode'
  procTmp.ExternalConnect(['isFirstInternode','isOnMainstem','predim','LIN','INER','exp_time']);

  // creation de 'initBiomass'
  XprocTmp := TExtraProcInstanceInternal.Create('initBiomass',ComputeInternodeBiomass_ngDyn,['Volume','kIn','density','kIn','Biomass','kOut']);
  XprocTmp.SetProcName('ComputeInternodeBiomass_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(120);
  XprocTmp.SetActiveState(1);
  entityInternode.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'initBiomass' de 'EntityInternode'
  XprocTmp.ExternalConnect(['Volume','density_IN','biomassIN']);

  // creation de 'initSumOfBiomass'
  XprocTmp := TExtraProcInstanceInternal.Create('initSumOfBiomass',SumOfBiomassOnCulmInInternodeRecDyn,['sumOfInternodeBiomassOnMainstem','kOut']);
  XProcTmp.SetProcName('SumOfBiomassOnCulmInInternodeRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(130);
  XprocTmp.SetActiveState(1);
  entityInternode.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'initSumOfBiomass'
  XprocTmp.ExternalConnect(['sumOfInternodeBiomassOnCulm']);

  // creation de 'initDemand'
  procTmp := TProcInstanceInternal.Create('initDemand',IdentityDyn,['inValue','kIn','outValue','kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(140);
  procTmp.SetActiveState(1);
  entityInternode.AddTInstance(procTmp);

  // connection port <-> attribut pour 'initDemand' de 'EntityInternode'
  procTmp.ExternalConnect(['biomassIN','demandIN']);


  /////////////////////////////////////////////////////////////////////////////
  // Modules pour l'état realization
  /////////////////////////////////////////////////////////////////////////////

  // creation de 'computeDeltaT'
  procTmp := TProcInstanceInternal.Create('computeDeltaT',DiffDyn,['inValue1','kIn','inValue2','kIn','outValue','kOut']);
  procTmp.SetProcName('Diff');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(1000);
  procTmp.SetActiveState(2);
  entityInternode.AddTInstance(procTmp);

  // connection port <-> attribut pour 'computeDeltaT' de 'EntityInternode'
  procTmp.ExternalConnect(['Tair','Tb','deltaT']);

  // creation de 'computeDDF'
  procTmp := TProcInstanceInternal.Create('computeDDF',UpdateAddDyn,['quantity','kIn','attributeValue','kInOut']);
  procTmp.SetProcName('UpdateAdd');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(1010);
  procTmp.SetActiveState(2);
  entityInternode.AddTInstance(procTmp);

  // connection port <-> attribut pour 'computeDDF' de 'EntityInternode'
  procTmp.ExternalConnect(['deltaT','time_from_app']);

  //creation de 'computeReductionINER'
  procTmp := TProcInstanceInternal.Create('computeReductionINER',ComputeReductionINER_ngDyn,['FTSW','kIn','ThresINER','kIn','SlopeINER','kIn','P','kIn','resp_INER','kIn','testIc','kIn','reductionINER','kOut']);
  procTmp.SetProcName('ComputeReductionINER_ng');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(1020);
  procTmp.SetActiveState(2);
  entityInternode.AddTInstance(procTmp);
  // connection port <-> attribut pour 'initReductionINER' de 'EntityInternode'
  procTmp.ExternalConnect(['FTSW','thresINER','slopeINER','P','resp_INER','testIc','reductionINER']);

  // creation de 'computeLERRealization'
  procTmp := TProcInstanceInternal.Create('computeINERRealization',ComputeINER_LEDyn,['predimOfCurrentInternode','kIn','reductionINER','kIn','plasto','kIn','phenoStage',',kIn','ligulo','kIn','INER','kOut']);
  procTmp.SetProcName('ComputeINER_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(1030);
  procTmp.SetActiveState(2);
  entityInternode.AddTInstance(procTmp);

  // connection port <-> attribut pour 'computeINERRealization' de 'EntityInternode'
  procTmp.ExternalConnect(['predim','reductionINER','plasto','rank','ligulo','INER']);

  // creation de 'computeExpTimeRealization'
  procTmp := TProcInstanceInternal.Create('computeExpTimeRealization',ComputeInternodeExpTime_LEDyn,['isFirstInternode','kIn','isOnMainstem','kIn','predim','kIn','LIN','kIn','INER','kIn','exp_time','kOut']);
  procTmp.SetProcName('ComputeInternodeExpTime_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(1040);
  procTmp.SetActiveState(2);
  entityInternode.AddTInstance(procTmp);

  // connection port <-> attribut pour 'computeExpTimeRealization' de 'EntityInternode'
  procTmp.ExternalConnect(['zero','isOnMainstem','predim','LIN','INER','exp_time']);

  // creation de 'updateLenRealization'
  procTmp := TProcInstanceInternal.Create('updateLenRealization',UpdateInternodeLength_LEDyn,['INER','kIn','deltaT','kIn','exp_time','kIn','LIN','kInOut']);
  procTmp.SetProcName('UpdateInternodeLength_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(1050);
  procTmp.SetActiveState(2);
  entityInternode.AddTInstance(procTmp);

  // connection port <-> attribut pour 'updateLenRealization' de 'EntityInternode'
  procTmp.ExternalConnect(['INER','deltaT','exp_time','LIN']);

  // creation de 'initVolume'
  procTmp := TProcInstanceInternal.Create('ComputeVolume',ComputeInternodeVolumeDyn,['Length', 'kIn', 'Diameter', 'kIn', 'Volume', 'kOut']);
  procTmp.SetProcName('ComputeInternodeVolume');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(1070);
  procTmp.SetActiveState(2);
  entityInternode.AddTInstance(procTmp);

  // connection port <-> attribut pour 'initVolume' de 'EntityInternode'
  procTmp.ExternalConnect(['LIN','DIN','Volume']);

  // creation de 'computeDemandRealization'
  procTmp := TProcInstanceInternal.Create('computeDemandRealization',ComputeInternodeDemand_LEDyn,['density_IN', 'kIn', 'volume', 'kIn', 'biomass', 'kIn', 'demand', 'kOut']);
  procTmp.SetProcName('ComputeInternodeDemand_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(1080);
  procTmp.SetActiveState(2);
  entityInternode.AddTInstance(procTmp);

  // connection port <-> attribut pour 'computeDemandRealization' de 'EntityInternode'
  procTmp.ExternalConnect(['density_IN', 'Volume', 'biomassIN', 'demandIN']);

  // creation de 'computeBiomassRealization'
  XprocTmp := TExtraProcInstanceInternal.Create('computeBiomassRealization',ComputeInternodeBiomass_ngDyn,['Volume','kIn','density_IN','kIn','biomass','kOut']);
  XprocTmp.SetProcName('ComputeInternodeBiomass_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(1090);
  XprocTmp.SetActiveState(2);
  entityInternode.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'computeBiomass' de 'EntityInternode'
  XprocTmp.ExternalConnect(['Volume','density_IN','biomassIN']);

  // creation de 'computeSumOfBiomass'
  XprocTmp := TExtraProcInstanceInternal.Create('computeSumOfBiomass',SumOfBiomassOnCulmInInternodeRecDyn,['sumOfInternodeBiomassOnMainstem','kOut']);
  XprocTmp.SetProcName('SumOfBiomassOnCulmInInternodeRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(1100);
  XprocTmp.SetActiveState(2);
  entityInternode.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'computeSumOfBiomass'
  XprocTmp.ExternalConnect(['sumOfInternodeBiomassOnCulm']);

  // creation de 'transitionToMatureState'
  XprocTmp := TExtraProcInstanceInternal.Create('transitionToMatureState',TransitionToMatureStateDyn,['LIN','kIn','predim','kIn','isOnMainstem','kIn']);
  XprocTmp.SetProcName('TransitionToMatureState');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(1130);
  XprocTmp.SetActiveState(2);
  entityInternode.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'transitionToMatureState'
  XprocTmp.ExternalConnect(['LIN','predim','isOnMainstem']);


  // creation de 'keepDIN2'

  procTmp := TProcInstanceInternal.Create('keepDIN2', IdentityDyn, ['inValue', 'kIn', 'outValue', 'kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1);
  procTmp.SetExeOrder(1140);
  procTmp.SetActiveState(2);
  entityInternode.AddTInstance(procTmp);
  // connection prot <-> attribut pour keepDIN2
  procTmp.ExternalConnect(['DIN', 'DIN']);


  /////////////////////////////////////////////////////////////////////////////
  // Modules pour l'etat realization_nostock
  /////////////////////////////////////////////////////////////////////////////

  // creation de 'keepLength3'

  procTmp := TProcInstanceInternal.Create('keepLength3', IdentityDyn, ['inValue', 'kIn', 'outValue', 'kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1);
  procTmp.SetExeOrder(1200);
  procTmp.SetActiveState(3);
  entityInternode.AddTInstance(procTmp);
  // connection port <-> attribut pour keepLength3
  procTmp.ExternalConnect(['LIN', 'LIN']);

  // creation de 'keepDiameter3'

  procTmp := TProcInstanceInternal.Create('keepDiameter3', IdentityDyn, ['inValue', 'kIn', 'outValue', 'kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1);
  procTmp.SetExeOrder(1210);
  procTmp.SetActiveState(3);
  entityInternode.AddTInstance(procTmp);
  // connection prot <-> attribut pour keepDiameter3
  procTmp.ExternalConnect(['DIN', 'DIN']);




  /////////////////////////////////////////////////////////////////////////////
  // Modules pour l'état Maturity
  /////////////////////////////////////////////////////////////////////////////

  // creation de 'computeLastDemand'
  procTmp := TProcInstanceInternal.Create('computeLastDemand',IdentityDyn,['inValue','kIn','outValue','kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(1900);
  procTmp.SetActiveState(4);
  entityInternode.AddTInstance(procTmp);

  // connection port <-> attribut pour 'computeLastDemand' de 'EntityLeaf'
  procTmp.ExternalConnect(['demandIN','lastdemand']);

  // creation de 'computeExpTimeRealization'
  procTmp := TProcInstanceInternal.Create('computeExpTimeRealizationMaturity',ComputeInternodeExpTime_LEDyn,['isFirstInternode','kIn','isOnMainstem','kIn','predim','kIn','LIN','kIn','INER','kIn','exp_time','kOut']);
  procTmp.SetProcName('ComputeInternodeExpTime_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(2000);
  procTmp.SetActiveState(4);
  entityInternode.AddTInstance(procTmp);

  // connection port <-> attribut pour 'computeExpTimeRealization' de 'EntityInternode'
  procTmp.ExternalConnect(['zero','isOnMainstem','predim','LIN','INER','exp_time']);

  // creation de 'computeSumOfBiomass'
  XprocTmp := TExtraProcInstanceInternal.Create('computeSumOfBiomassMaturity',SumOfBiomassOnCulmInInternodeRecDyn,['sumOfInternodeBiomassOnMainstem','kOut']);
  XprocTmp.SetProcName('SumOfBiomassOnCulmInInternodeRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(2100);
  XprocTmp.SetActiveState(4);
  entityInternode.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'computeSumOfBiomass'
  XprocTmp.ExternalConnect(['sumOfInternodeBiomassOnCulm']);

  // creation de 'finalizeDemand'
  procTmp := TProcInstanceInternal.Create('finalizeDemand',IdentityDyn,['inValue','kIn','outValue','kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(2110);
  procTmp.SetActiveState(4);
  entityInternode.AddTInstance(procTmp);

  // connection port <-> attribut pour 'finalizeDemand' de 'EntityLeaf'
  procTmp.ExternalConnect(['zero','demandIN']);


  // creation de 'keepLength4'

  procTmp := TProcInstanceInternal.Create('keepLength4', IdentityDyn, ['inValue', 'kIn', 'outValue', 'kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1);
  procTmp.SetExeOrder(2115);
  procTmp.SetActiveState(4);
  entityInternode.AddTInstance(procTmp);
  // connection port <-> attribut pour keepLength3
  procTmp.ExternalConnect(['LIN', 'LIN']);

  // creation de 'keepDiameter4'

  procTmp := TProcInstanceInternal.Create('keepDiameter4', IdentityDyn, ['inValue', 'kIn', 'outValue', 'kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1);
  procTmp.SetExeOrder(2120);
  procTmp.SetActiveState(4);
  entityInternode.AddTInstance(procTmp);
  // connection prot <-> attribut pour keepDiameter3
  procTmp.ExternalConnect(['DIN', 'DIN']);


  // creation de 'cancelDemand3'
  procTmp := TProcInstanceInternal.Create('cancelDemand3',IdentityDyn,['inValue','kIn','outValue','kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(2130);
  procTmp.SetActiveState(3);
  entityInternode.AddTInstance(procTmp);

  // connection port <-> attribut pour 'demandIN' de 'EntityInternode'
  procTmp.ExternalConnect(['zero','demandIN']);


  // creation de 'cancelLastDemand3'
  procTmp := TProcInstanceInternal.Create('cancelLastDemand3',IdentityDyn,['inValue','kIn','outValue','kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(2135);
  procTmp.SetActiveState(3);
  entityInternode.AddTInstance(procTmp);

  // connection port <-> attribut pour 'lastdemand' de 'EntityInternode'
  procTmp.ExternalConnect(['zero','lastdemand']);


  // creation de 'cancelDemand5'
  procTmp := TProcInstanceInternal.Create('cancelDemand5',IdentityDyn,['inValue','kIn','outValue','kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(2140);
  procTmp.SetActiveState(5);
  entityInternode.AddTInstance(procTmp);

  // connection port <-> attribut pour 'demandIN' de 'EntityInternode'
  procTmp.ExternalConnect(['zero','demandIN']);


  // creation de 'cancelLastDemand5'
  procTmp := TProcInstanceInternal.Create('cancelLastDemand5',IdentityDyn,['inValue','kIn','outValue','kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(2145);
  procTmp.SetActiveState(5);
  entityInternode.AddTInstance(procTmp);

  // connection port <-> attribut pour 'demandIN' de 'EntityInternode'
  procTmp.ExternalConnect(['zero','lastdemand']);

  // creation de 'cancelStock5
  procTmp := TProcInstanceInternal.Create('cancelStock5',IdentityDyn,['inValue','kIn','outValue','kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1);
  procTmp.SetExeOrder(2150);
  procTmp.SetActiveState(5);
  entityInternode.AddTInstance(procTmp);

  // connection port <-> attribut pour 'demandIN' de 'EntityInternode'
  procTmp.ExternalConnect(['zero','stockIN']);

  // creation de 'cancelStock3
  procTmp := TProcInstanceInternal.Create('cancelStock3',IdentityDyn,['inValue','kIn','outValue','kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1);
  procTmp.SetExeOrder(2155);
  procTmp.SetActiveState(3);
  entityInternode.AddTInstance(procTmp);

  // connection port <-> attribut pour 'demandIN' de 'EntityInternode'
  procTmp.ExternalConnect(['zero','stockIN']);

  // creation de 'keepLength5'

  procTmp := TProcInstanceInternal.Create('keepLength5', IdentityDyn, ['inValue', 'kIn', 'outValue', 'kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1);
  procTmp.SetExeOrder(2160);
  procTmp.SetActiveState(5);
  entityInternode.AddTInstance(procTmp);
  // connection port <-> attribut pour keepLength3
  procTmp.ExternalConnect(['LIN', 'LIN']);

  // creation de 'keepDiameter5'

  procTmp := TProcInstanceInternal.Create('keepDiameter5', IdentityDyn, ['inValue', 'kIn', 'outValue', 'kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1);
  procTmp.SetExeOrder(2170);
  procTmp.SetActiveState(5);
  entityInternode.AddTInstance(procTmp);
  // connection prot <-> attribut pour keepDiameter3
  procTmp.ExternalConnect(['DIN', 'DIN']);


  ////////////////////////////////////////////////////////
  // ajout d'un manageur
  ////////////////////////////////////////////////////////
  managerTmp := TManagerInternal.Create('InternodeManager_ng',InternodeManager_ng);
  managerTmp.SetFunctName('InternodeManager_ng');
  managerTmp.SetExeMode(intra);
  managerTmp.SetExeOrder(500);
  entityInternode.AddTManager(managerTmp);

  /////////////////////////////////////
  // retourne la feuille créée
  ////////////////////////////////////}
  result := entityInternode;

end;

end.
