// ---------------------------------------------------------------------------
/// creation et importation d'une entité entrenoeud générique pour le modele
/// EcoMeristem_LE
///
/// Description :
//
// ----------------------------------------------------------------------------
(** @Author JCS and DL *)

unit EntityPeduncle_ng;

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

function ImportPeduncle_ng(const name : string; const MGR, plasto, Tb, resp_INER, LIN1, IN_A, IN_B, density_In, stock_mainstem, leaf_width_to_IN_diameter, leaf_length_to_IN_length, leafLength, leafWidth, MaximumReserveInInternode, ratioINPed, peduncleDiam : double ; const isFirstInterNode : Double = 0 ; const isOnMainstem : Double = 0) : TEntityInstance;

implementation

// ----------------------------------------------------------------------------
//  fonction ImportPeduncle_LE
//  --------------------------
//
/// creation et importation d'une entité entrenoeud générique
///
/// Description :
/// Une feuille est une entité générique. Ses paramètres sont :
/// - isFirstInterNode : indique si l'entrenoeud est le premier entrenoeud de l organe
///     porteur. Si c'est le cas, ce parametre vaut 1 sinon il vaut 0.
/// - isOnMainstem : indique si l'entrenoeud est sur le brin maitre. Si c'est le
///     cas, ce parametre vaut 1 sinon il vaut 0.


function ImportPeduncle_ng(const name : string; const MGR, plasto, Tb, resp_INER, LIN1, IN_A, IN_B, density_In, stock_mainstem, leaf_width_to_IN_diameter, leaf_length_to_IN_length, leafLength, leafWidth, MaximumReserveInInternode, ratioINPed, peduncleDiam : double ; const isFirstInterNode : Double = 0 ; const isOnMainstem : Double = 0) : TEntityInstance;
var
  parameterTmp : TParameter;
  entityPeduncle : TEntityInstance;
  attributeTmp : TAttributeTmp;
  procTmp : TProcInstanceInternal;
  managerTmp : TManagerInternal;
  XprocTmp : TExtraProcInstanceInternal;
  initSample : TSample;
begin
  entityPeduncle := TEntityInstance.Create('',
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

  entityPeduncle.SetName(name);
  entityPeduncle.SetCategory('Peduncle');

  // ----------------------------------------------
  // creation des attributs dans 'EntityInternode'
  // ----------------------------------------------

  attributeTmp := TAttributeTmp.Create('time_from_app');
  entityPeduncle .AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('INER');
  entityPeduncle.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('Volume');
  entityPeduncle.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('exp_time');
  entityPeduncle.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('predim');
  entityPeduncle.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('stock_culm');
  entityPeduncle.AddTAttribute(attributeTmp);

  parameterTmp := TParameter.Create('density_IN', density_IN);
  entityPeduncle.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('MaximumReserveInInternode', MaximumReserveInInternode);
  entityPeduncle.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('leaf_width_to_IN_diameter', leaf_width_to_IN_diameter);
  entityPeduncle.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('leaf_length_to_IN_length', leaf_length_to_IN_length);
  entityPeduncle.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('leafLength', leafLength);
  entityPeduncle.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('leafWidth', leafWidth);
  entityPeduncle.AddTAttribute(parameterTmp);

  attributeTmp := TAttributeTmp.Create('DDInitiation');
  entityPeduncle.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('DDRealization');
  entityPeduncle.AddTAttribute(attributeTmp);

  parameterTmp := TParameter.Create('isFirstInternode', isFirstInterNode);
  entityPeduncle.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('isOnMainstem', isOnMainstem);
  entityPeduncle.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('MGR', MGR);
  entityPeduncle.AddTAttribute(parameterTmp);

  attributeTmp := TAttributeTmp.Create('testIc');
  entityPeduncle.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('fcstr');
  entityPeduncle.AddTAttribute(attributeTmp);

  parameterTmp := TParameter.Create('plasto', plasto);
  entityPeduncle.AddTAttribute(parameterTmp);

  attributeTmp := TAttributeTmp.Create('phenoStage');
  entityPeduncle.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('rank');
  entityPeduncle.AddTAttribute(attributeTmp);

  parameterTmp := TParameter.Create('ligulo', plasto);
  entityPeduncle.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('IN_A', IN_A);   // OK
  entityPeduncle.AddTAttribute(parameterTmp);       // OK

  parameterTmp := TParameter.Create('IN_B',IN_B);    // OK
  entityPeduncle.AddTAttribute(parameterTmp);       // OK

  parameterTmp := TParameter.Create('RER');
  entityPeduncle.AddTAttribute(parameterTmp);

  attributeTmp := TAttributeTmp.Create('SSL');
  entityPeduncle.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('stockPeduncle');
  entityPeduncle.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('deficitIN');
  entityPeduncle.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('stockPlant');
  entityPeduncle.AddTAttribute(attributeTmp);

  parameterTmp := TParameter.Create('Tb',Tb);
  entityPeduncle.AddTAttribute(parameterTmp);

  attributeTmp := TAttributeTmp.Create('Tair');
  entityPeduncle.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('deltaT');
  entityPeduncle.AddTAttribute(attributeTmp);

  parameterTmp := TParameter.Create('one',1);
  entityPeduncle.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('zero',0);
  entityPeduncle.AddTAttribute(parameterTmp);

  attributeTmp := TAttributeTmp.Create('biomassIN');
  entityPeduncle.AddTAttribute(attributeTmp);

  initSample.date := 0; initSample.value := 0;
  attributeTmp := TAttributeTmp.Create('lastdemand',initSample);
  entityPeduncle.AddTAttribute(attributeTmp);

  initSample.date := 0; initSample.value := 0;
  attributeTmp := TAttributeTmp.Create('demandIN',initSample);
  entityPeduncle.AddTAttribute(attributeTmp);

  parameterTmp := TParameter.Create('LIN1', LIN1);
  entityPeduncle.AddTAttribute(parameterTmp);

  attributeTmp := TAttributeTmp.Create('LIN');  // OK
  entityPeduncle.AddTAttribute(attributeTmp);  // OK

  attributeTmp := TAttributeTmp.Create('DIN');  // OK
  entityPeduncle.AddTAttribute(attributeTmp);  // OK

  attributeTmp := TAttributeTmp.Create('plasto_delay');
  entityPeduncle.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('thresINER');
  entityPeduncle.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('slopeINER');
  entityPeduncle.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('FTSW');
  entityPeduncle.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('lig');
  entityPeduncle.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('reductionINER');
  entityPeduncle.AddTAttribute(attributeTmp);

  parameterTmp := TParameter.Create('resp_INER', resp_INER);
  entityPeduncle.AddTAttribute(parameterTmp);

  attributeTmp := TAttributeTmp.Create('P');
  entityPeduncle.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('sumOfInternodeBiomassOnCulm');
  entityPeduncle.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('reservoirDispoIN');
  entityPeduncle.AddTAttribute(attributeTmp);

  initSample.date := 0; initSample.value := 0;
  attributeTmp := TAttributeTmp.Create('lastdemand', initSample);
  entityPeduncle.AddTAttribute(attributeTmp);

  parameterTmp := TParameter.Create('ratio_INPed', ratioINPed);
  entityPeduncle.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('peduncle_diam', peduncleDiam);
  entityPeduncle.AddTAttribute(parameterTmp);

  /////////////////////////////////////////////////////////////////////////////
  // Connections internes des ports
  /////////////////////////////////////////////////////////////////////////////

  // connection port <-> attribut pour 'EntityInternode'
  entityPeduncle.InternalConnect(['DDInitiation',
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
  // Modules pour l'état initiation
  /////////////////////////////////////////////////////////////////////////////


  // creation de 'initTimeFromApp'
  procTmp := TProcInstanceInternal.Create('initTimeFromApp', IdentityDyn,['inValue', 'kIn', 'outValue', 'kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10);
  procTmp.SetActiveState(1);
  entityPeduncle.AddTInstance(procTmp);
  // connection port <-> attribut pour 'initTimeFromApp' de 'EntityPeduncle'
  procTmp.ExternalConnect(['DDInitiation', 'time_from_app']);

  // creation de 'initPeduncleLengthPredim'
  XprocTmp := TExtraProcInstanceInternal.Create('initPeduncleLengthPredim',ComputePeduncleLengthPredimDyn,['ratioINPed', 'kIn', 'peduncleLengthPredim', 'kOut']);
  XprocTmp.SetProcName('ComputePeduncleLengthPredim');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(20);
  XprocTmp.SetActiveState(1);
  entityPeduncle.AddTInstance(XprocTmp);
  // connection port <-> attribut pour 'ratio_INPed', 'predim' de 'EntityInternode'
  XprocTmp.ExternalConnect(['ratio_INPed', 'predim']);

  // creation de 'initPeduncleDiameterPredim'
  XprocTmp := TExtraProcInstanceInternal.Create('initPeduncleDiameterPredim',ComputePeduncleDiameterPredimDyn,['peduncleDiam', 'kIn', 'peduncleDiameterPredim', 'kOut']);
  XprocTmp.SetProcName('ComputePeduncleDiameterPredim');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(30);
  XprocTmp.SetActiveState(1);
  entityPeduncle.AddTInstance(XprocTmp);
  // connection port <-> attribut pour 'peduncle_diam', 'DIN' de 'EntityInternode'
  XprocTmp.ExternalConnect(['peduncle_diam', 'DIN']);

  //creation de 'initReductionINER'
  procTmp := TProcInstanceInternal.Create('initReductionINER', ComputeReductionINER_LEDyn,['FTSW', 'kIn', 'ThresINER', 'kIn', 'SlopeINER', 'kIn', 'P', 'kIn', 'resp_INER', 'kIn', 'reductionINER', 'kOut']);
  procTmp.SetProcName('ComputeReductionINER_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(40);
  procTmp.SetActiveState(1);
  entityPeduncle.AddTInstance(procTmp);
  // connection port <-> attribut
  procTmp.ExternalConnect(['FTSW', 'thresINER', 'slopeINER', 'P', 'resp_INER', 'reductionINER']);

  // creation de 'initINER'
  procTmp := TProcInstanceInternal.Create('initINER', ComputeINER_LEDyn,['predimOfCurrentInternode', 'kIn', 'reductionINER', 'kIn', 'plasto','kIn','phenoStage','kIn','ligulo','kIn','INER','kOut']);
  procTmp.SetProcName('ComputeINER_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(50);
  procTmp.SetActiveState(1);
  entityPeduncle.AddTInstance(procTmp);
  // connection port <-> attribut
  procTmp.ExternalConnect(['predim','reductionINER','plasto','rank','ligulo','INER']);

  // creation de 'initLen'
  procTmp := TProcInstanceInternal.Create('initLen',Mult2ValuesDyn,['inValue1','kIn','inValue2','kIn','outValue','kOut']);
  procTmp.SetProcName('Mult2Values');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(60);
  procTmp.SetActiveState(1);
  entityPeduncle.AddTInstance(procTmp);

  // connection port <-> attribut
  procTmp.ExternalConnect(['INER','DDRealization','LIN']);

  {debut affichage des paramètres}

  // creation de 'dispINER'
  procTmp := TProcInstanceInternal.Create('dispINER',DispDyn,['value','kIn']);
  procTmp.SetProcName('Disp');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(70);
  procTmp.SetActiveState(1);
  entityPeduncle.AddTInstance(procTmp);

  // connection port <-> attribut
  procTmp.ExternalConnect(['INER']);


  // creation de 'dispDDRealization'
  procTmp := TProcInstanceInternal.Create('dispDDRealization',DispDyn,['value','kIn']);
  procTmp.SetProcName('Disp');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(80);
  procTmp.SetActiveState(1);
  entityPeduncle.AddTInstance(procTmp);

  // connection port <-> attribut
  procTmp.ExternalConnect(['DDRealization']);


  // creation de 'dispLIN'
  procTmp := TProcInstanceInternal.Create('dispLIN',DispDyn,['value','kIn']);
  procTmp.SetProcName('Disp');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(90);
  procTmp.SetActiveState(1);
  entityPeduncle.AddTInstance(procTmp);

  // connection port <-> attribut
  procTmp.ExternalConnect(['LIN']);



  {fin affichage des paramètres}

  // creation de 'initVolume'
  procTmp := TProcInstanceInternal.Create('initVolume',ComputeInternodeVolumeDyn,['Length', 'kIn', 'Diameter', 'kIn', 'Volume', 'kOut']);
  procTmp.SetProcName('ComputeInternodeVolume');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(100);
  procTmp.SetActiveState(1);
  entityPeduncle.AddTInstance(procTmp);

  // connection port <-> attribut
  procTmp.ExternalConnect(['LIN','DIN','Volume']);

  // creation de 'initExp_Time'
  procTmp := TProcInstanceInternal.Create('initExp_Time',ComputeInternodeExpTime_LEDyn,['isFirstInternode','kIn','isOnMainstem','kIn','predim','kIn','len','kIn','LER','kIn','exp_time','kOut']);
  procTmp.SetProcName('ComputeInternodeExpTime_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(110);
  procTmp.SetActiveState(1);
  entityPeduncle.AddTInstance(procTmp);

  // connection port <-> attribut
  procTmp.ExternalConnect(['isFirstInternode','isOnMainstem','predim','LIN','INER','exp_time']);

  // creation de 'initBiomass'
  procTmp := TProcInstanceInternal.Create('initBiomass',ComputeInternodeBiomass_LEDyn,['Volume','kIn','density','kIn','Biomass','kOut']);
  procTmp.SetProcName('ComputeInternodeBiomass_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(120);
  procTmp.SetActiveState(1);
  entityPeduncle.AddTInstance(procTmp);

  // connection port <-> attribut
  procTmp.ExternalConnect(['Volume','density_IN','biomassIN']);

  // creation de 'initSumOfBiomass'
  XprocTmp := TExtraProcInstanceInternal.Create('initSumOfBiomass',SumOfBiomassOnCulmInInternodeRecDyn,['sumOfInternodeBiomassOnMainstem','kOut']);
  XProcTmp.SetProcName('SumOfBiomassOnCulmInInternodeRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(130);
  XprocTmp.SetActiveState(1);
  entityPeduncle.AddTInstance(XprocTmp);

  // connection port <-> attribut
  XprocTmp.ExternalConnect(['sumOfInternodeBiomassOnCulm']);

  // creation de 'initDemand'
  procTmp := TProcInstanceInternal.Create('initDemand',IdentityDyn,['inValue','kIn','outValue','kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(140);
  procTmp.SetActiveState(1);
  entityPeduncle.AddTInstance(procTmp);

  // connection port <-> attribut
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
  entityPeduncle.AddTInstance(procTmp);

  // connection port <-> attribut
  procTmp.ExternalConnect(['Tair','Tb','deltaT']);

  // creation de 'computeDDF'
  procTmp := TProcInstanceInternal.Create('computeDDF',UpdateAddDyn,['quantity','kIn','attributeValue','kInOut']);
  procTmp.SetProcName('UpdateAdd');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(1010);
  procTmp.SetActiveState(2);
  entityPeduncle.AddTInstance(procTmp);

  // connection port <-> attribut
  procTmp.ExternalConnect(['deltaT','time_from_app']);

  //creation de 'computeReductionINER'
  procTmp := TProcInstanceInternal.Create('computeReductionINER',ComputeReductionINER_LEDyn,['FTSW','kIn','ThresINER','kIn','SlopeINER','kIn','P','kIn','resp_INER','kIn','reductionINER','kOut']);
  procTmp.SetProcName('ComputeReductionINER_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(1020);
  procTmp.SetActiveState(2);
  entityPeduncle.AddTInstance(procTmp);
  // connection port <-> attribut
  procTmp.ExternalConnect(['FTSW','thresINER','slopeINER','P','resp_INER','reductionINER']);

  // creation de 'computeLERRealization'
  procTmp := TProcInstanceInternal.Create('computeINERRealization',ComputeINER_LEDyn,['predimOfCurrentInternode','kIn','reductionINER','kIn','plasto','kIn','phenoStage',',kIn','ligulo','kIn','INER','kOut']);
  procTmp.SetProcName('ComputeINER_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(1030);
  procTmp.SetActiveState(2);
  entityPeduncle.AddTInstance(procTmp);

  // connection port <-> attribut
  procTmp.ExternalConnect(['predim','reductionINER','plasto','rank','ligulo','INER']);

  // creation de 'computeExpTimeRealization'
  procTmp := TProcInstanceInternal.Create('computeExpTimeRealization',ComputeInternodeExpTime_LEDyn,['isFirstInternode','kIn','isOnMainstem','kIn','predim','kIn','LIN','kIn','INER','kIn','exp_time','kOut']);
  procTmp.SetProcName('ComputeInternodeExpTime_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(1040);
  procTmp.SetActiveState(2);
  entityPeduncle.AddTInstance(procTmp);

  // connection port <-> attribut
  procTmp.ExternalConnect(['zero','isOnMainstem','predim','LIN','INER','exp_time']);

  // creation de 'updateLenRealization'
  procTmp := TProcInstanceInternal.Create('updateLenRealization',UpdateInternodeLength_LEDyn,['INER','kIn','deltaT','kIn','exp_time','kIn','LIN','kInOut']);
  procTmp.SetProcName('UpdateInternodeLength_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(1050);
  procTmp.SetActiveState(2);
  entityPeduncle.AddTInstance(procTmp);

  // connection port <-> attribut
  procTmp.ExternalConnect(['INER','deltaT','exp_time','LIN']);

  // creation de 'initVolume'
  procTmp := TProcInstanceInternal.Create('ComputeVolume',ComputeInternodeVolumeDyn,['Length', 'kIn', 'Diameter', 'kIn', 'Volume', 'kOut']);
  procTmp.SetProcName('ComputeInternodeVolume');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(1070);
  procTmp.SetActiveState(2);
  entityPeduncle.AddTInstance(procTmp);

  // connection port <-> attribut
  procTmp.ExternalConnect(['LIN','DIN','Volume']);

  // creation de 'computeDemandRealization'
  procTmp := TProcInstanceInternal.Create('computeDemandRealization',ComputeInternodeDemand_LEDyn,['density_IN', 'kIn', 'volume', 'kIn', 'biomass', 'kIn', 'demand', 'kOut']);
  procTmp.SetProcName('ComputeInternodeDemand_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(1080);
  procTmp.SetActiveState(2);
  entityPeduncle.AddTInstance(procTmp);

  // connection port <-> attribut
  procTmp.ExternalConnect(['density_IN', 'Volume', 'biomassIN', 'demandIN']);

  // creation de 'computeBiomassRealization'
  procTmp := TProcInstanceInternal.Create('computeBiomassRealization',ComputeInternodeBiomass_LEDyn,['Volume','kIn','density_IN','kIn','biomass','kOut']);
  procTmp.SetProcName('ComputeInternodeBiomass_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(1090);
  procTmp.SetActiveState(2);
  entityPeduncle.AddTInstance(procTmp);

  // connection port <-> attribut
  procTmp.ExternalConnect(['Volume','density_IN','biomassIN']);

  // creation de 'computeSumOfBiomass'
  XprocTmp := TExtraProcInstanceInternal.Create('computeSumOfBiomass',SumOfBiomassOnCulmInInternodeRecDyn,['sumOfInternodeBiomassOnMainstem','kOut']);
  XprocTmp.SetProcName('SumOfBiomassOnCulmInInternodeRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(1100);
  XprocTmp.SetActiveState(2);
  entityPeduncle.AddTInstance(XprocTmp);

  // connection port <-> attribut
  XprocTmp.ExternalConnect(['sumOfInternodeBiomassOnCulm']);

  // creation de 'transitionToMatureState'
  XprocTmp := TExtraProcInstanceInternal.Create('transitionToMatureState',TransitionToMatureStateDyn,['LIN','kIn','predim','kIn','isOnMainstem','kIn']);
  XprocTmp.SetProcName('TransitionToMatureState');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(1130);
  XprocTmp.SetActiveState(2);
  entityPeduncle.AddTInstance(XprocTmp);

  // connection port <-> attribut
  XprocTmp.ExternalConnect(['LIN','predim','isOnMainstem']);


  /////////////////////////////////////////////////////////////////////////////
  // Modules pour l'état Maturity
  /////////////////////////////////////////////////////////////////////////////

  // creation de 'computeLastDemand'
  procTmp := TProcInstanceInternal.Create('computeLastDemand',IdentityDyn,['inValue','kIn','outValue','kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(1900);
  procTmp.SetActiveState(4);
  entityPeduncle.AddTInstance(procTmp);

  // connection port <-> attribut
  procTmp.ExternalConnect(['demandIN','lastdemand']);

  // creation de 'computeExpTimeRealization'
  procTmp := TProcInstanceInternal.Create('computeExpTimeRealizationMaturity',ComputeInternodeExpTime_LEDyn,['isFirstInternode','kIn','isOnMainstem','kIn','predim','kIn','LIN','kIn','INER','kIn','exp_time','kOut']);
  procTmp.SetProcName('ComputeInternodeExpTime_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(2000);
  procTmp.SetActiveState(4);
  entityPeduncle.AddTInstance(procTmp);

  // connection port <-> attribut
  procTmp.ExternalConnect(['zero','isOnMainstem','predim','LIN','INER','exp_time']);

  // creation de 'computeSumOfBiomass'
  XprocTmp := TExtraProcInstanceInternal.Create('computeSumOfBiomassMaturity',SumOfBiomassOnCulmInInternodeRecDyn,['sumOfInternodeBiomassOnMainstem','kOut']);
  XprocTmp.SetProcName('SumOfBiomassOnCulmInInternodeRec');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(2100);
  XprocTmp.SetActiveState(4);
  entityPeduncle.AddTInstance(XprocTmp);

  // connection port <-> attribut
  XprocTmp.ExternalConnect(['sumOfInternodeBiomassOnCulm']);

  // creation de 'finalizeDemand'
  procTmp := TProcInstanceInternal.Create('finalizeDemand',IdentityDyn,['inValue','kIn','outValue','kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(2120);
  procTmp.SetActiveState(4);
  entityPeduncle.AddTInstance(procTmp);

  // connection port <-> attribut
  procTmp.ExternalConnect(['zero','demandIN']);


  // creation de 'cancelDemand3'
  procTmp := TProcInstanceInternal.Create('cancelDemand3',IdentityDyn,['inValue','kIn','outValue','kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(2130);
  procTmp.SetActiveState(3);
  entityPeduncle.AddTInstance(procTmp);

  // connection port <-> attribut
  procTmp.ExternalConnect(['zero','demandIN']);


  // creation de 'cancelDemand 5'
  procTmp := TProcInstanceInternal.Create('cancelDemand5',IdentityDyn,['inValue','kIn','outValue','kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(2140);
  procTmp.SetActiveState(5);
  entityPeduncle.AddTInstance(procTmp);

  // connection port <-> attribut
  procTmp.ExternalConnect(['zero','demandIN']);


  // creation de 'cancelStock5
  procTmp := TProcInstanceInternal.Create('cancelStock5',IdentityDyn,['inValue','kIn','outValue','kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1);
  procTmp.SetExeOrder(2150);
  procTmp.SetActiveState(5);
  entityPeduncle.AddTInstance(procTmp);

  // connection port <-> attribut
  procTmp.ExternalConnect(['zero','stockPeduncle']);

  ////////////////////////////////////////////////////////
  // ajout d'un manageur
  ////////////////////////////////////////////////////////
  managerTmp := TManagerInternal.Create('PeduncleManager_ng',PeduncleManager_ng);
  managerTmp.SetExeMode(intra);
  managerTmp.SetExeOrder(500);
  entityPeduncle.AddTManager(managerTmp);

  /////////////////////////////////////
  // retourne la feuille créée
  ////////////////////////////////////}
  result := entityPeduncle;

end;

end.
