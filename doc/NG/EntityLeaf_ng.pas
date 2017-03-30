// ---------------------------------------------------------------------------
/// creation et importation d'une entité feuille générique pour le modele
/// EcoMeristem_LE
///
/// Description :
//
// ----------------------------------------------------------------------------
(** @Author Ludovic TAMBOUR
    @Version 06/10/06 LT v0.0 version initiale; statut : en cours *)

unit EntityLeaf_ng;

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
  DefinitionConstant;

function ImportLeaf_ng(const name : string ; const rank, Lef1, MGR, plasto, ligulo, WLR, LL_BL, allo_area, G_L, Tb, resp_LER, coeff_lifespan, mu, leaf_stock_max : double ; const isFirstLeaf : Double = 0 ; const isOnMainstem : Double = 1) : TEntityInstance;



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
//  fonction ImportLeaf
//  ----------------------
//
/// creation et importation d'une entité feuille générique
///
/// Description :
/// Une feuille est une entité générique. Ses paramètres sont :
/// - Lef1 : final first leaf length
/// - MGR : meristem growth rate param to estimate potential demand (in grams)
///     of consecutive leaves (leaf (n)_biomss = MRG * leaf (n-1)_biom
/// - plasto : plastochron
/// - ligulo : time separating the ligulation of two consecutive leaves
/// - WLR : ratio between blade width and length
/// - LL_BL : length ratio between leaf and blade length
/// - allo_area : relationship between blade area and length*width
/// - G_L : blade / sheath dry weight ratio
/// - Tb : temperature de base
/// - isFirstLeaf : indique si la feuille est la premiere feuille de l organe
///     porteur. Si c'est le cas, ce parametre vaut 1 sinon il vaut 0.
/// - isOnMainstem : indique si la feuille est sur le brin maitre. Si c'est le
///     cas, ce parametre vaut 1 sinon il vaut 0.
///
/// Une feuille contient des ports :
/// - predimOfPreviousLeaf (entree) : predimensionnement de la précédente
///     feuille créée sur le meme organe porteur
/// - predimLeafOnMainstem (entree) : predimensionnement de la feuille qui vient
///     de se finaliser sur le brin maitre
/// - predimOfCurrentLeaf (sortie) : predimensionnment de la feuille
/// - degreeDayForInitiation (entree) : degrée jour lors de la premiere realisation
/// - degreeDayForRealization (entree) : degré jour pour la realisation autre que
///     la premiere realisation
/// - testIc (entree) : ???????????????
/// - fcstr (entree) : ????????????????
/// - phenoStage (entree) : stade phenologique de la plante
/// - SLA (entree) : surface leaf area
/// - plantStock (entree) : reserve en biomasse de la plante
/// - Tair (entree) : Temperature de l'air
///
/// Une feuille contient des attributs internes :
///   - XXXXXXX
///
/// XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
///
/// @param name nom de la nouvelle feuille
/// @param Lef1 final first leaf length
/// @param MGR meristem growth rate
/// @param plasto plastochron
/// @param ligulo time separating the ligulation of two consecutive leaves
/// @param WLR ratio between blade width and length
/// @param LL_BL length ratio between leaf and blade length
/// @param allo_area relationship between blade area and length*width
/// @param G_L blade / sheath dry weight ratio
/// @param isFirstLeaf indique si la feuille est la premiere feuille de l organe porteur
/// @param isOnMainstem indique si la feuille est sur le brin maitre ou non
// ---------------------------------------------------------------------------

function ImportLeaf_ng(const name : string ; const rank, Lef1, MGR, plasto, ligulo, WLR, LL_BL, allo_area, G_L, Tb, resp_LER, coeff_lifespan, mu, leaf_stock_max : double ; const isFirstLeaf : Double = 0 ; const isOnMainstem : Double = 1) : TEntityInstance;
var
  entityLeaf : TEntityInstance;
  attributeTmp : TAttributeTmp;
  parameterTmp : TParameter;
  initSample : TSample;
  procTmp : TProcInstanceInternal;
  managerTmp : TManagerInternal;
  XprocTmp : TExtraProcInstanceInternal;
begin
  // ---------------------------
  // creation de 'EntityLeaf'
  // ---------------------------
  entityLeaf := TEntityInstance.Create('',
                        ['degreeDayForInitiation','kIn',
                        'degreeDayForRealization','kIn',
                        'phenoStage','kIn',
                        'SLA','kIn',
                        'plantStock','kIn',
                        'Tair','kIn',
                        'plasto_delay','kInOut',
                        'thresLER','kIn',
                        'slopeLER','kIn',
                        'FTSW','kIn',
                        'lig','kIn',
                        'P','kIn']);
  entityLeaf.SetName(name);
  entityLeaf.SetCategory('Leaf');

  // ----------------------------------------------
  // creation des attributs dans 'EntityLeaf'
  // ----------------------------------------------
  attributeTmp := TAttributeTmp.Create('time_from_app');
  entityLeaf.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('predim');
  entityLeaf.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('LER');
  entityLeaf.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('width');
  entityLeaf.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('bladeArea');
  entityLeaf.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('exp_time');
  entityLeaf.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('predimOfPreviousLeaf');
  entityLeaf.AddTAttribute(attributeTmp);

  parameterTmp := TParameter.Create('rank', rank);
  entityLeaf.AddTAttribute(parameterTmp);

  attributeTmp := TAttributeTmp.Create('predimLeafOnMainstem');
  entityLeaf.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('DDInitiation');
  entityLeaf.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('DDRealization');
  entityLeaf.AddTAttribute(attributeTmp);

  parameterTmp := TParameter.Create('isFirstLeaf',isFirstLeaf);
  entityLeaf.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('isOnMainstem',isOnMainstem);
  entityLeaf.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('Lef1',Lef1);
  entityLeaf.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('MGR',MGR);
  entityLeaf.AddTAttribute(parameterTmp);

  attributeTmp := TAttributeTmp.Create('testIc');
  entityLeaf.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('fcstr');
  entityLeaf.AddTAttribute(attributeTmp);

  parameterTmp := TParameter.Create('plasto',plasto);
  entityLeaf.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('leaf_stock_max',leaf_stock_max);
  entityLeaf.AddTAttribute(parameterTmp);

  attributeTmp := TAttributeTmp.Create('phenoStage');
  entityLeaf.AddTAttribute(attributeTmp);

  parameterTmp := TParameter.Create('ligulo',ligulo);
  entityLeaf.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('WLR',WLR);
  entityLeaf.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('LL_BL',LL_BL);
  entityLeaf.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('allo_area',allo_area);
  entityLeaf.AddTAttribute(parameterTmp);

  attributeTmp := TAttributeTmp.Create('SLA');
  entityLeaf.AddTAttribute(attributeTmp);

  parameterTmp := TParameter.Create('G_L',G_L);
  entityLeaf.AddTAttribute(parameterTmp);

  attributeTmp := TAttributeTmp.Create('stock');
  entityLeaf.AddTAttribute(attributeTmp);

  parameterTmp := TParameter.Create('Tb',Tb);
  entityLeaf.AddTAttribute(parameterTmp);

  attributeTmp := TAttributeTmp.Create('Tair');
  entityLeaf.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('deltaT');
  entityLeaf.AddTAttribute(attributeTmp);

  parameterTmp := TParameter.Create('one',1);
  entityLeaf.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('zero',0);
  entityLeaf.AddTAttribute(parameterTmp);

  attributeTmp := TAttributeTmp.Create('biomass');
  entityLeaf.AddTAttribute(attributeTmp);

  initSample.date := 0; initSample.value := 0;
  attributeTmp := TAttributeTmp.Create('lastdemand',initSample);
  entityLeaf.AddTAttribute(attributeTmp);

  initSample.date := 0; initSample.value := 0;
  attributeTmp := TAttributeTmp.Create('demand',initSample);
  entityLeaf.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('len');
  entityLeaf.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('plasto_delay');
  entityLeaf.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('thresLER');
  entityLeaf.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('slopeLER');
  entityLeaf.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('thermalTimeAtInitiation');
  entityLeaf.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('FTSW');
  entityLeaf.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('lig');
  entityLeaf.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('reductionLER');
  entityLeaf.AddTAttribute(attributeTmp);

  parameterTmp := TParameter.Create('resp_LER', resp_LER);
  entityLeaf.AddTAttribute(parameterTmp);

  attributeTmp := TAttributeTmp.Create('P');
  entityLeaf.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('lifespan');
  entityLeaf.AddTAttribute(attributeTmp);

  initSample.date := 0; initSample.value := 0;
  attributeTmp := TAttributeTmp.Create('thermalTimeSinceLigulation', initSample);
  entityLeaf.AddTAttribute(attributeTmp);

  parameterTmp := TParameter.Create('coeffLifespan', coeff_lifespan);
  entityLeaf.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('mu', mu);
  entityLeaf.AddTAttribute(parameterTmp);

  attributeTmp := TAttributeTmp.Create('correctedBladeArea');
  entityLeaf.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('correctedLeafBiomass');
  entityLeaf.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('deadLeafBiomass');
  entityLeaf.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('leafBiomassStructAtInitiation');
  entityLeaf.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('oldCorrectedBiomass');
  entityLeaf.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('dailySenescedLeafBiomass');
  entityLeaf.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('dailySenescedDwLeafBiomass');
  entityLeaf.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('dailyComputedReallocBiomass');
  entityLeaf.AddTAttribute(attributeTmp);

  /////////////////////////////////////////////////////////////////////////////
  // Connections internes des ports
  /////////////////////////////////////////////////////////////////////////////

  // connection port <-> attribut pour 'EntityLeaf'
  entityLeaf.InternalConnect(['DDInitiation',
                              'DDRealization',
                              'phenoStage',
                              'SLA',
                              'stock',
                              'Tair',
                              'plasto_delay',
                              'thresLER',
                              'slopeLER',
                              'FTSW',
                              'lig',
                              'P']);

  /////////////////////////////////////////////////////////////////////////////
  // Modules pour testIc & fcstr
  /////////////////////////////////////////////////////////////////////////////

  XprocTmp := TExtraProcInstanceInternal.Create('ComputeTestIcCulm_ng',ComputeTestIcCulm_ngDyn,['testIc', 'kOut']);
  XprocTmp.SetProcName('ComputeTestIcCulm_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(2);
  entityLeaf.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'ComputeTestIcCulm_ng' de 'EntityLeaf'
  XprocTmp.ExternalConnect(['testIc']);

  
  XprocTmp := TExtraProcInstanceInternal.Create('ComputeGetFcstr_ng',ComputeGetFcstr_ngDyn,['fcstr', 'kOut']);
  XprocTmp.SetProcName('ComputeGetFcstr_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(4);
  entityLeaf.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'initLeafPredim' de 'EntityLeaf'
  XprocTmp.ExternalConnect(['fcstr']);


  XprocTmp := TExtraProcInstanceInternal.Create('LeafTransitionToActive_ng',LeafTransitionToActive_ngDyn,[]);
  XprocTmp.SetProcName('LeafTransitionToActive_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(5);
  entityLeaf.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'initLeafPredim' de 'EntityLeaf'
  XprocTmp.ExternalConnect([]);


  /////////////////////////////////////////////////////////////////////////////
  // Modules pour l'état initiation
  /////////////////////////////////////////////////////////////////////////////

  // creation de 'initTimeFromApp'
  procTmp := TProcInstanceInternal.Create('initTimeFromApp',IdentityDyn,['inValue','kIn','outValue','kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(10);
  procTmp.SetActiveState(1);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'initTimeFromApp' de 'EntityLeaf'
  procTmp.ExternalConnect(['DDInitiation','time_from_app']);

  // creation de 'storeThermalTimeAtInitiation'
  procTmp := TProcInstanceInternal.Create('storeThermalTimeAtInitiation',IdentityDyn,['inValue','kIn','outValue','kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(20);
  procTmp.SetActiveState(1);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'initTimeFromApp' de 'EntityLeaf'
  procTmp.ExternalConnect(['DDInitiation','thermalTimeAtInitiation']);

  // creation de initLeafBiomassStructAtInitiation
  procTmp := TProcInstanceInternal.Create('initLeafBiomassStructAtInitiation',IdentityDyn,['inValue','kIn','outValue','kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(30);
  procTmp.SetActiveState(1);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'initLeafBiomassStructAtInitiation' de 'EntityLeaf'
  procTmp.ExternalConnect(['SLA','leafBiomassStructAtInitiation']);


  // creation de 'initLeafPredim'
  XprocTmp := TExtraProcInstanceInternal.Create('initLeafPredim',ComputeLeafPredimensionnement_ngDyn,['isFirstLeaf', 'kIn', 'isOnMainstem', 'kIn', 'Lef1', 'kIn', 'MGR', 'kIn', 'testIc', 'kIn', 'fcstr', 'kIn', 'predimOfCurrentLeaf', 'kOut']);
  XprocTmp.SetProcName('ComputeLeafPredimensionnement_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(40);
  XprocTmp.SetActiveState(1);
  entityLeaf.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'initLeafPredim' de 'EntityLeaf'
  XprocTmp.ExternalConnect(['isFirstLeaf', 'isOnMainstem', 'Lef1', 'MGR', 'testIc', 'fcstr', 'predim']);
                           

  //creation de 'initReductionLER'
  procTmp := TProcInstanceInternal.Create('initReductionLER',ComputeLER_ngDyn,['FTSW','kIn','Thres','kIn','slope','kIn','P','kIn','resp_LER','kIn','testIc','kIn','reductionLER','kOut']);
  procTmp.SetProcName('ComputeLER_ng');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(50);
  procTmp.SetActiveState(1);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'initReductionLER' de 'EntityLeaf'
  procTmp.ExternalConnect(['FTSW','thresLER','slopeLER','P','resp_LER','testIc','reductionLER']);

  // creation de 'initLER'
  procTmp := TProcInstanceInternal.Create('initLER',ComputeLeafLER_LEDyn,['predimOfCurrentLeaf','kIn','reductionLER','kIn','plasto','kIn','phenoStage',',kIn','ligulo','kIn','LER','kOut']);
  procTmp.SetProcName('ComputeLeafLER_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(60);
  procTmp.SetActiveState(1);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'initLER' de 'EntityLeaf'
  procTmp.ExternalConnect(['predim','reductionLER','plasto','rank','ligulo','LER']);

  // creation de 'initLen'
  procTmp := TProcInstanceInternal.Create('initLen',Mult2ValuesDyn,['inValue1','kIn','inValue2','kIn','outValue','kOut']);
  procTmp.SetProcName('Mult2Values');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(70);
  procTmp.SetActiveState(1);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'initLen' de 'EntityLeaf'
  procTmp.ExternalConnect(['LER','DDInitiation','len']);

  // creation de 'initWidth'
  procTmp := TProcInstanceInternal.Create('initWidth',ComputeLeafWidth_LEDyn,['len','kIn','WLR','kIn','LL_BL','kIn','width','kOut']);
  procTmp.SetProcName('ComputeLeafWidth_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(80);
  procTmp.SetActiveState(1);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'initWidth' de 'EntityLeaf'
  procTmp.ExternalConnect(['len','WLR','LL_BL','width']);

  // creation de 'initBladeArea'
  procTmp := TProcInstanceInternal.Create('initBladeArea',ComputeLeafBladeArea_LEDyn,['len','kIn','width','kIn','allo_area','kIn','LL_BL','kIn','bladeArea','kOut']);
  procTmp.SetProcName('ComputeLeafBladeArea_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(90);
  procTmp.SetActiveState(1);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'initBladeArea' de 'EntityLeaf'
  procTmp.ExternalConnect(['len','width','allo_area','LL_BL','bladeArea']);

  // creation de 'initExp_Time'
  procTmp := TProcInstanceInternal.Create('initExp_Time',ComputeLeafExpTime_ngDyn,['predim','kIn','len','kIn','LER','kIn','exp_time','kOut']);
  procTmp.SetProcName('ComputeLeafExpTime_ng');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(100);
  procTmp.SetActiveState(1);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'initExp_Time' de 'EntityLeaf'
  procTmp.ExternalConnect(['predim','len','LER','exp_time']);

  // creation de 'initBiomass'
  procTmp := TProcInstanceInternal.Create('initBiomass',ComputeLeafBiomass_LEDyn,['bladeArea','kIn','leafBiomassStructAtInitiation','kIn','G_L','kIn','biomass','kOut']);
  procTmp.SetProcName('ComputeLeafBiomass_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(110);
  procTmp.SetActiveState(1);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'initBiomass' de 'EntityLeaf'
  procTmp.ExternalConnect(['bladeArea','leafBiomassStructAtInitiation','G_L','biomass']);

  // creation de 'initDemand'
  procTmp := TProcInstanceInternal.Create('initDemand',IdentityDyn,['inValue','kIn','outValue','kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(120);
  procTmp.SetActiveState(1);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'initDemand' de 'EntityLeaf'
  procTmp.ExternalConnect(['biomass','demand']);

  // creation de initLifespan

  procTmp := TProcInstanceInternal.Create('initLifespan',ComputeLifespan_LEDyn,['coeffLifespan', 'kIn', 'mu', 'kIn', 'rank', 'kIn', 'lifespan', 'kOut']);
  procTmp.SetProcName('ComputeLifespan_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(130);
  procTmp.SetActiveState(1);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'coeffLifespan', 'mu', 'rank' et 'lifespan' de 'EntityLeaf'
  procTmp.ExternalConnect(['coeffLifespan','mu','phenoStage','lifespan']);

  /////////////////////////////////////////////////////////////////////////////
  // Modules pour l'état realization
  /////////////////////////////////////////////////////////////////////////////

  // creation de 'computeDeltaT'
  procTmp := TProcInstanceInternal.Create('computeDeltaT',DiffDyn,['inValue1','kIn','inValue2','kIn','outValue','kOut']);
  procTmp.SetProcName('Diff');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(1000);
  procTmp.SetActiveState(2);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'computeDeltaT' de 'EntityLeaf'
  procTmp.ExternalConnect(['Tair','Tb','deltaT']);

  // creation de 'computeDDF'
  procTmp := TProcInstanceInternal.Create('computeDDF',UpdateAddDyn,['quantity','kIn','attributeValue','kInOut']);
  procTmp.SetProcName('UpdateAdd');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(1010);
  procTmp.SetActiveState(2);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'computeDDF' de 'EntityLeaf'
  procTmp.ExternalConnect(['deltaT','time_from_app']);

  //creation de 'computeReductionLER'
  procTmp := TProcInstanceInternal.Create('initReductionLER',ComputeLER_ngDyn,['FTSW','kIn','Thres','kIn','slope','kIn','P','kIn','resp_LER','kIn','testIc','kIn','reductionLER','kOut']);
  procTmp.SetProcName('ComputeLER_ng');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(1020);
  procTmp.SetActiveState(2);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'initReductionLER' de 'EntityLeaf'
  procTmp.ExternalConnect(['FTSW','thresLER','slopeLER','P','resp_LER','testIc','reductionLER']);


  // creation de 'computeLERRealization'
  procTmp := TProcInstanceInternal.Create('computeLERRealization',ComputeLeafLER_LEDyn,['predimOfCurrentLeaf','kIn','reductionLER','kIn','plasto','kIn','phenoStage',',kIn','ligulo','kIn','LER','kOut']);
  procTmp.SetProcName('ComputeLeafLER_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(1030);
  procTmp.SetActiveState(2);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'computeLERRealization' de 'EntityLeaf'
  procTmp.ExternalConnect(['predim','reductionLER','plasto','rank','ligulo','LER']);

  // creation de 'computeExpTimeRealization'
  procTmp := TProcInstanceInternal.Create('computeExpTimeRealization',ComputeLeafExpTime_ngDyn,['predim','kIn','len','kIn','LER','kIn','exp_time','kOut']);
  procTmp.SetProcName('ComputeLeafExpTime_ng');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(1040);
  procTmp.SetActiveState(2);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'computeExpTimeRealization' de 'EntityLeaf'
  procTmp.ExternalConnect(['predim','len','LER','exp_time']);

  // creation de 'updateLenRealization'
  procTmp := TProcInstanceInternal.Create('updateLenRealization',UpdateLeafLength_LEDyn,['LER','kIn','deltaT','kIn','exp_time','kIn','len','kInOut']);
  procTmp.SetProcName('UpdateLeafLength_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(1050);
  procTmp.SetActiveState(2);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'updateLenRealization' de 'EntityLeaf'
  procTmp.ExternalConnect(['LER','deltaT','exp_time','len']);

  // creation de 'computeWidthRealization'
  procTmp := TProcInstanceInternal.Create('computeWidthRealization',ComputeLeafWidth_LEDyn,['len','kIn','WLR','kIn','LL_BL','kIn','width','kOut']);
  procTmp.SetProcName('ComputeLeafWidth_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(1060);
  procTmp.SetActiveState(2);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'computeWidthRealization' de 'EntityLeaf'
  procTmp.ExternalConnect(['len','WLR','LL_BL','width']);

  // creation de 'computeBladeAreaRealization'
  procTmp := TProcInstanceInternal.Create('computeBladeAreaRealization',ComputeLeafBladeArea_LEDyn,['len','kIn','width','kIn','allo_area','kIn','LL_BL','kIn','bladeArea','kOut']);
  procTmp.SetProcName('ComputeLeafBladeArea_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(1070);
  procTmp.SetActiveState(2);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'computeBladeAreaRealization' de 'EntityLeaf'
  procTmp.ExternalConnect(['len','width','allo_area','LL_BL','bladeArea']);

  // creation de 'computeDemandRealization'
  procTmp := TProcInstanceInternal.Create('computeDemandRealization',ComputeLeafDemand_LEDyn,['bladeArea','kIn','leafBiomassStructAtInitiation','kIn','G_L','kIn','biomass','kIn','demand','kOut']);
  procTmp.SetProcName('ComputeLeafDemand_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(1080);
  procTmp.SetActiveState(2);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'computeDemandRealization' de 'EntityLeaf'
  procTmp.ExternalConnect(['bladeArea','leafBiomassStructAtInitiation','G_L','biomass','demand']);

  // creation de 'computeBiomassRealization'
  procTmp := TProcInstanceInternal.Create('computeBiomassRealization',ComputeLeafBiomass_LEDyn,['bladeArea','kIn','leafBiomassStructAtInitiation','kIn','G_L','kIn','biomass','kOut']);
  procTmp.SetProcName('ComputeLeafBiomass_LE');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(1090);
  procTmp.SetActiveState(2);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'computeBiomassRealization' de 'EntityLeaf'
  procTmp.ExternalConnect(['bladeArea','leafBiomassStructAtInitiation','G_L','biomass']);

  // creation de 'updatePlastoDelay'
  procTmp := TProcInstanceInternal.Create('updatePlastoDelay',UpdatePlastoDelayDyn,['LER','kIn','deltaT','kIn','exp_time','kIn','plasto_delay','kOut']);
  procTmp.SetProcName('UpdatePlastoDelay');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(1110);
  procTmp.SetActiveState(2);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'updatePlastoDelay' de 'EntityLeaf'
  procTmp.ExternalConnect(['reductionLER','deltaT','exp_time','plasto_delay']);

  // creation de 'transitionToLiguleState'
  XprocTmp := TExtraProcInstanceInternal.Create('transitionToLiguleState',TransitionToLiguleState_ngDyn,['len','kIn','predim','kIn','isOnMainstem','kIn','demand','kInOut','lastDemand','kInOut']);
  XprocTmp.SetProcName('TransitionToLiguleState_ng');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(1500);
  XprocTmp.SetActiveState(2);
  entityLeaf.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'transitionToLiguleState'
  XprocTmp.ExternalConnect(['len', 'predim', 'isOnMainstem', 'demand', 'lastdemand']);


  /////////////////////////////////////////////////////////////////////////////
  // Modules pour l'état ligule
  /////////////////////////////////////////////////////////////////////////////

  procTmp := TProcInstanceInternal.Create('dispBiomass',DispDyn,['inValue','kIn']);
  procTmp.SetProcName('Disp');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(2000);
  procTmp.SetActiveState(4);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'computeLastDemand' de 'EntityLeaf'
  procTmp.ExternalConnect(['biomass']);


  // creation de 'computeLastDemand'
  procTmp := TProcInstanceInternal.Create('computeLastDemand',IdentityDyn,['inValue','kIn','outValue','kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(2010);
  procTmp.SetActiveState(4);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'computeLastDemand' de 'EntityLeaf'
  procTmp.ExternalConnect(['zero','lastdemand']);

  // creation de 'finalizeDemand'
  procTmp := TProcInstanceInternal.Create('finalizeDemand',IdentityDyn,['inValue','kIn','outValue','kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(2020);
  procTmp.SetActiveState(4);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'finalizeDemand' de 'EntityLeaf'
  procTmp.ExternalConnect(['zero','demand']);

  // creation de 'computeExpTimeLigule'
  procTmp := TProcInstanceInternal.Create('computeExpTimeLigule',ComputeLeafExpTime_ngDyn,['predim','kIn','len','kIn','LER','kIn','exp_time','kOut']);
  procTmp.SetProcName('ComputeLeafExpTime_ng');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(2030);
  procTmp.SetActiveState(4);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'computeExpTimeLigule' de 'EntityLeaf'
  procTmp.ExternalConnect(['predim','len','LER','exp_time']);


    // creation de 'cancelDemand3'
  procTmp := TProcInstanceInternal.Create('cancelDemand3',IdentityDyn,['inValue','kIn','outValue','kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(2040);
  procTmp.SetActiveState(3);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'demand' de 'EntityLeaf'
  procTmp.ExternalConnect(['zero','demand']);

      // creation de 'cancelLastDemand3'
  procTmp := TProcInstanceInternal.Create('cancelLastDemand3',IdentityDyn,['inValue','kIn','outValue','kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(2045);
  procTmp.SetActiveState(3);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'demand' de 'EntityLeaf'
  procTmp.ExternalConnect(['zero','lastdemand']);


  // creation de 'cancelDemand5'
  procTmp := TProcInstanceInternal.Create('cancelDemand5',IdentityDyn,['inValue','kIn','outValue','kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(2050);
  procTmp.SetActiveState(5);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'demand' de 'EntityLeaf'
  procTmp.ExternalConnect(['zero','demand']);

    // creation de 'cancelLastDemand5'
  procTmp := TProcInstanceInternal.Create('cancelLastDemand5',IdentityDyn,['inValue','kIn','outValue','kOut']);
  procTmp.SetProcName('Identity');
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(2055);
  procTmp.SetActiveState(5);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'demand' de 'EntityLeaf'
  procTmp.ExternalConnect(['zero','lastdemand']);

  // creation de computeThermalTimeSinceLigulation
  XprocTmp := TExtraProcInstanceInternal.Create('computeThermalTimeSinceLigulation4',ComputeThermalTimeSinceLigulation_LEDyn,['thermalTimeSinceLigulation', 'kInOut']);
  XprocTmp.SetProcName('ComputeThermalTimeSinceLigulation_LE');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(2060);
  XprocTmp.SetActiveState(4);
  entityLeaf.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'thermalTime' et 'thermalTimeSinceLigulation' de 'EntityLeaf'
  XprocTmp.ExternalConnect(['thermalTimeSinceLigulation']);


  // creation de computeThermalTimeSinceLigulation
  XprocTmp := TExtraProcInstanceInternal.Create('computeThermalTimeSinceLigulation5',ComputeThermalTimeSinceLigulation_LEDyn,['thermalTimeSinceLigulation', 'kInOut']);
  XprocTmp.SetProcName('ComputeThermalTimeSinceLigulation_LE');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(2070);
  XprocTmp.SetActiveState(5);
  entityLeaf.AddTInstance(XprocTmp);

  // connection port <-> attribut pour 'thermalTime' et 'thermalTimeSinceLigulation' de 'EntityLeaf'
  XprocTmp.ExternalConnect(['thermalTimeSinceLigulation']);

  // creation de ComputeCorrectedBladeArea
  XprocTmp := TExtraProcInstanceInternal.Create('computeCorrectedBladeArea',ComputeCorrectedBladeAreaDyn,['correctedBladeArea','kOut']);
  XprocTmp.SetProcName('ComputeCorrectedBladeArea');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(2080);
  entityLeaf.AddTInstance(XprocTmp);

 // connection port <-> attribut pour 'correctedBladeArea'
  XprocTmp.ExternalConnect(['correctedBladeArea']);

  // creation de ComputeCorrectedLeafArea
  XprocTmp := TExtraProcInstanceInternal.Create('computeCorrectedLeafBiomass',ComputeCorrectedLeafBiomassDyn,['correctedLeafBiomass','kOut']);
  XprocTmp.SetProcName('ComputeCorrectedLeafBiomass');
  XprocTmp.SetExeStep(1); // pas journalier
  XprocTmp.SetExeOrder(2090);
  entityLeaf.AddTInstance(XprocTmp);

 // connection port <-> attribut pour 'correctedBladeArea'
  XprocTmp.ExternalConnect(['correctedLeafBiomass']);


  ////////////////////////////////////////////////////////
  // ajout d'un manageur
  ////////////////////////////////////////////////////////
  managerTmp := TManagerInternal.Create('leafManager_ng',LeafManager_ng);
  managerTmp.SetFunctName('LeafManager_ng');
  managerTmp.SetExeMode(intra);
  managerTmp.SetExeOrder(500);
  entityLeaf.AddTManager(managerTmp);

  /////////////////////////////////////
  // retourne la feuille créée
  ////////////////////////////////////
  result := entityLeaf;

end;



end.
