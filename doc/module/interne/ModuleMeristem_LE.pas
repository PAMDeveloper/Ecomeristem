//---------------------------------------------------------------------------
/// Modules utilises par le modele EcoMeristem_LE.
///
/// Description : Modules utilises par le modele EcoMeristem.
/// Inclus les nouveaux modules de EcoMeristem qui ne sont pas presents dans
/// la library ModuleMersitem.pas
///
//----------------------------------------------------------------------------
(** @Author Ludovic TAMBOUR
    @Version 02/10/06 LT v0.0 version initiale; statut : en cours *)

unit ModuleMeristem_LE;

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
  StrUtils,
  DateUtils,
  Math,
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
  ClassTProcLibrary,
  ClassTExtraProcInstanceInternal,
  UsefullFunctionsForMeristemModel,    Dialogs, Classes,
  DefinitionConstant;

type
  TArrayOfArrayOfString = array of array of string;

// Internal utility functions
function FindPredimOrganLength(var instance : TInstance; organRankName, organType : string) : Double;
function FindFirstNonVegetativePredimOrgan(var instance : TInstance; organType, attributeName : string) : Double;

// Liste des modules
Procedure ComputeRootDemand_LE(const A, K, numOfSimulationDay, resp_R_d, P: double; var R_d: Double);
Procedure ComputeLeafPredimensionnement_LE(const isFirstLeaf,isOnMainstem,predimOfPreviousLeaf,predimLeafOnMainstem,Lef1,MGR,testIc,fcstr : Double; var predimOfCurrentLeaf : Double);
Procedure ComputeInternodePredimensionnement_LE(const leafLength, leafLengthToINLength, testIc,fcstr : Double; var predimOfCurrentInternode : Double);
Procedure ComputeCstr_LE(const FTSW, ThresTransp : Double; var Cstr : Double);
Procedure ComputeLER_LE(const FTSW,ThresLER,SlopeLER,P,resp_LER : Double; var reductionLER : Double);
Procedure ComputeReductionINER_LE(const FTSW,ThresINER,slopeINER,P,resp_INER : Double; var reductionINER : Double);
Procedure ComputeLeafLER_LE(const predimOfCurrentLeaf,reductionLER,plasto,phenoStage,ligulo : Double; var LER : Double);
Procedure ComputeINER_LE(const predimOfCurrentInternode,reductionINER,plasto,phenoStage,ligulo : Double; var INER : Double);
Procedure ComputeLeafWidth_LE(const len, WLR, LL_BL : double ; var width : double);
Procedure ComputeLeafBladeArea_LE(const len, width, allo_area, LL_BL : double ; var bladeArea : double);
Procedure ComputeLeafExpTime_LE(const isFirstLeaf,isOnMainstem,predim,len,LER : double ; var exp_time : double);
Procedure ComputeInternodeExpTime_LE(const isFirstInternode,isOnMainstem,predim,len,INER : double ; var exp_time : double);
Procedure ComputeLeafBiomass_LE(const bladeArea, SLA, G_L : double ; var biomass : double);
procedure ComputeInternodeBiomass_LE(const Volume, density : Double; var Biomass : Double);
procedure ComputeInternodeDemand_LE(const density_IN, volume, biomass: double; var demand : double);
procedure ComputeInternodeStock_LE(const maximumReserveInInternode, biomassIN, sumOfInternodeBiomassOnCulm, stockCulm, demandIN : Double; var stock_IN, deficit_IN : Double);
Procedure ComputeLeafDemand_LE(const bladeArea, SLA, G_L, biomass : double ; var demand : double);
Procedure UpdateIH_LE(const lig, TT_lig, ligulo : double ; var IH, isFirstStep : double);
Procedure UpdateTT_lig_LE(const EDD : double ; var TT_lig, isFirstStep : double);
Procedure UpdateInternodeLength_LE(const INER, deltaT, exp_time : double ; var len : double);
Procedure UpdateLeafLength_LE(const LER, deltaT, exp_time : double ; var len : double);
Procedure ComputeReservoirDispo_LE(const leafStockMax,sumOfLeavesBiomass,stock : double ; var reservoirDispo : double);
Procedure UpdateSeedres_LE(var seedres, dayDemand : double);
Procedure UpdateSeedres2_LE(const reservoirDispo, supply : double; var restDayDemand, seedres, dayDemand, deficit, stock : double);
procedure UpdateStock_LE(const dayDemand, reservoirDispo, supply, dailySenescedLeafBiomass : Double; var stock, deficit, seedres, surplus : Double);
Procedure UpdateSurplus_LE(const reservoirDispo, supply, seedres, restDayDemand, dayDemand : double; var surplus : double);
Procedure ComputeIC_LE(const seedres,seedres_previous1,seedres_previous2,seedres_previous3,supply,supply_previous1,supply_previous2,supply_previous3,dayDemand,dayDemand_previous1,dayDemand_previous2,dayDemand_previous3, Ic_previous1 : double ; var Ic, testIc : double);
Procedure UpdateNbTillerCount_LE(const Ic,IcThreshold,nbExistingTiller : Double; var nbTiller : Double);
Procedure ComputeBalance_LE(const stock,supply,dayDemand,seedres,reservoirDispo : Double; var balance : Double);
procedure compute_LAI_str(const PAI : double ; const density : double ; const fcstr : double ; var LAI : double);
procedure computeAssimpot_str(const radiationinterception : double ; const epsib : double ; const radiation : double ; const fcstr : double ;const Kpar : double ; var potentialAssimilation : double);
procedure ComputeInternodeVolume(const Length, Diameter : Double; var Volume : Double);
procedure Disp(const value : double);
procedure ComputeInternodeReservoirDispo_LE(const maximumReserveInInternode, biomass_IN, stock_IN : Double; var reservoirDispo_IN : Double);
procedure ComputeAssimMainstem_LE(const assimPlant, sumOfBladeAreaOnMainstem, sumOfBladeAreaPlant : Double; var assimMainstem : Double);
procedure ComputeAssimTiller_LE(const assimPlant, sumOfBladeAreaOnTiller, sumOfBladeAreaPlant : Double; var assimTiller : Double);
procedure ComputeReservoirDispoMainstem_LE(const maxReserveInInternode, SumOfBiomassInMainstemInternode, leafStockMax, SumOfBiomassInMainstemLeaf : Double; var ReservoirDispoMainstem : Double);
procedure ComputeReservoirDispoTiller_LE(const maxReserveInInternode, SumOfBiomassInTillerInternode, leafStockMax, SumOfBiomassInTillerLeaf : Double; var ReservoirDispoTiller : Double);
procedure ComputeSurplusMainstem_LE(const SupplyMainstem, DemandOfNonINMainstem, ReservoirDispoMainstem : Double; var SurplusMainstem : Double);
procedure ComputeSurplusTiller_LE(const SupplyTiller, DemandofNonINTiller, ReservoirDispoTiller : Double; var SurplusTiller : Double);
procedure ComputeStockMainstem_LE(const sumOfStockINMainstem, stockLeafMainstem, reservoirDispoMainstem, supplyMainstem, sumOfDemandNonINMainstem : Double; var stockMainstem : Double);
procedure ComputeStockMainstem2_LE(const sumOfStockINMainstem, stockLeafMainstem, reservoirDispoMainstem, supplyMainstem : Double; var stockMainstem : Double);
procedure ComputeStockTiller_LE(const sumOfStockINTiller, stockLeafTiller, reservoirDispoTiller, supplyTiller, sumOfDemandNonINTiller : Double; var stockTiller : Double);
procedure ComputeStockTiller2_LE(const sumOfStockINTiller, stockLeafTiller, reservoirDispoTiller, supplyTiller : Double; var stockTiller : Double);
procedure ComputeSWC_LE(const deltap, waterSupply : Double; var SWC : Double);
procedure ComputeDayDemand_LE(const sumOfDemand, lastDemand, nbDayOfSimulation : Double; var dayDemand : Double);
procedure UpdateRootDemand_LE(var rootDemand, surplusPlant : Double);
procedure ComputeInternodeDiameterPredim_LE(const leafWidthToINDiameter, leafOnSameRankWidth : Double; var diameter : Double);
procedure ComputePanicleGrainNb_LE(const spikeCreationRate, Tair, Tb, fcstr, testIc : Double; var grainNb : Double);
procedure ComputePanicleFertileGrainNumber_LE(const fcstr, testIc : Double; var fertileGrainNumber : Double);
procedure ComputePanicleDayDemandFlo_LE(const fillingRate, Tair, Tb, fcstr, testIc : Double; var panicleDayDemand : Double);
procedure ComputePanicleWeightFlo_LE(const gdwEmpty, grainNb, panicleDayDemand : Double; var firstDayOfFLO, panicleWeight : Double);
procedure ComputePanicleFilledGrainNbFlo_LE(const fertileGrainNb, panicleWeight, gdw : Double; var filledGrainNb : Double);
procedure ComputeStockLeafCulm_LE(const leafStockMax, sumOfBiomassInLeafCulm, stockCulm, sumOfCulmDemandIN, sumOfCulmStockIN : Double; var stockLeafCulm : Double);
procedure ComputeStockLeafCulm2_LE(const leafStockMax, sumOfBiomassInLeafCulm, stockCulm, sumOfCulmStockIN, sumOfCulmDecifitIN, sumOfCulmDemandNonIN, sumOfCulmLastDemand, sumOfCulmDemandIN : Double; var stockLeafCulm : Double);
procedure ComputeReservoirDispoLeafCulm_LE(const leafStockMax, sumOfBiomassInLeafCulm, stockLeafCulm : Double; var reservoirDispoLeafCulm : Double);
procedure ComputeCGRStress_LE(const BoolSwitch, BiomAero2, TT : Double; var BiomAero2StressOnSet, TTStressOnSet, CGRStress : Double);
procedure ComputeDegreeDay_LE(const TMax, TMin, TBase, TLet, TOpt1, TOpt2 : Double; var DegreeDay : Double);
procedure ComputeNewPlasto_Ligulo_LL_BL_MGR(const n, boolCrossedPlasto, nbLeafParam2, slopeLL_BL, coeffPlastoPI, coeffLiguloPI, coeffMGRPI, stock, nbLeafPI, nbLeafMaxAfterPI, LL_BL_init : Double; var plasto, ligulo, LL_BL, MGR : Double);
procedure ComputeLifespan_LE(const coeffLifespan, mu, rank : Double; var lifespan : Double);
procedure ComputeInternodeDiameterPredim2(const INLengthToINDiam, coefLinINDIam, internodeLengthPredim : Double; var internodeDiameterPredim : Double);
procedure ComputeBiomLeaf(const stock, stockInternodePlant, biomLeafStruct : Double; var structLeaf : Double);





Procedure ComputeRootDemand_LEDyn(Var T : TPointerProcParam);
Procedure ComputeLeafPredimensionnement_LEDyn(Var T : TPointerProcParam);
Procedure ComputeInternodePredimensionnement_LEDyn(Var T : TPointerProcParam);
Procedure ComputeCstr_LEDyn(Var T : TPointerProcParam);
Procedure ComputeLER_LEDyn(Var T : TPointerProcParam);
Procedure ComputeReductionINER_LEDyn(Var T : TPointerProcParam);
Procedure ComputeLeafLER_LEDyn(Var T : TPointerProcParam);
Procedure ComputeINER_LEDyn(Var T : TPointerProcParam);
Procedure ComputeLeafWidth_LEDyn(Var T : TPointerProcParam);
Procedure ComputeLeafBladeArea_LEDyn(Var T : TPointerProcParam);
Procedure ComputeLeafExpTime_LEDyn(Var T : TPointerProcParam);
Procedure ComputeInternodeExpTime_LEDyn(Var T : TPointerProcParam);
Procedure ComputeLeafBiomass_LEDyn(Var T : TPointerProcParam);
procedure ComputeInternodeStock_LEDyn(Var T : TPointerProcParam);
Procedure ComputeInternodeBiomass_LEDyn(Var T : TPointerProcParam);
Procedure ComputeInternodeDemand_LEDyn(Var T : TPointerProcParam);
Procedure ComputeLeafDemand_LEDyn(Var T : TPointerProcParam);
Procedure UpdateIH_LEDyn(Var T : TPointerProcParam);
Procedure UpdateTT_lig_LEDyn(Var T : TPointerProcParam);
Procedure UpdateInternodeLength_LEDyn(Var T : TPointerProcParam);
Procedure UpdateLeafLength_LEDyn(Var T : TPointerProcParam);
Procedure ComputeReservoirDispo_LEDyn(Var T : TPointerProcParam);
Procedure UpdateSeedres_LEDyn(Var T : TPointerProcParam);
Procedure UpdateSeedres2_LEDyn(Var T : TPointerProcParam);
Procedure UpdateStock_LEDyn(Var T : TPointerProcParam);
Procedure UpdateSurplus_LEDyn(Var T : TPointerProcParam);
Procedure ComputeIC_LEDyn(Var T : TPointerProcParam);
Procedure UpdateNbTillerCount_LEDyn(Var T : TPointerProcParam);
Procedure ComputeBalance_LEDyn(Var T : TPointerProcParam);
procedure compute_LAI_strDyn(var T : TPointerProcParam);
procedure computeAssimpot_strDyn(var T : TPointerProcParam);
procedure ComputeInternodeVolumeDyn(var T : TPointerProcParam);
procedure DispDyn(var T : TPointerProcParam);
procedure ComputeInternodeReservoirDispo_LEDyn(var T : TPointerProcParam);
procedure ComputeAssimMainstem_LEDyn(var T : TPointerProcParam);
procedure ComputeAssimTiller_LEDyn(var T : TPointerProcParam);
procedure ComputeReservoirDispoMainstem_LEDyn(var T : TPointerProcParam);
procedure ComputeReservoirDispoTiller_LEDyn(var T : TPointerProcParam);
procedure ComputeSurplusMainstem_LEDyn(var T : TPointerProcParam);
procedure ComputeSurplusTiller_LEDyn(var T : TPointerProcParam);
procedure ComputeStockMainstem_LEDyn(var T : TPointerProcParam);
procedure ComputeStockMainstem2_LEDyn(var T : TPointerProcParam);
procedure ComputeStockTiller_LEDyn(var T : TPointerProcParam);
procedure ComputeStockTiller2_LEDyn(var T : TPointerProcParam);
procedure ComputeSWC_LEDyn(var T : TPointerProcParam);
procedure ComputeDayDemand_LEDyn(var T : TPointerProcParam);
procedure UpdateRootDemand_LEDyn(var T : TPointerProcParam);
procedure ComputeInternodeDiameterPredim_LEDyn(var T : TPointerProcParam);
procedure ComputePanicleGrainNb_LEDyn(var T : TPointerProcParam);
procedure ComputePanicleFertileGrainNumber_LEDyn(var T : TPointerProcParam);
procedure ComputePanicleDayDemandFlo_LEDyn(var T : TPointerProcParam);
procedure ComputePanicleWeightFlo_LEDyn(var T : TPointerProcParam);
procedure ComputePanicleFilledGrainNbFlo_LEDyn(var T : TPointerProcParam);
procedure ComputeStockLeafCulm_LEDyn(var T : TPointerProcParam);
procedure ComputeStockLeafCulm2_LEDyn(var T : TPointerProcParam);
procedure ComputeReservoirDispoLeafCulm_LEDyn(var T : TPointerProcParam);
procedure ComputeCGRStress_LEDyn(var T : TPointerProcParam);
procedure ComputeDegreeDay_LEDyn(var T : TPointerProcParam);
procedure ComputeNewPlasto_Ligulo_LL_BL_MGRDyn(var T : TPointerProcParam);
procedure ComputeLifespan_LEDyn(var T : TPointerProcParam);
procedure ComputeInternodeDiameterPredim2Dyn(var T : TPointerProcParam);
procedure ComputeBiomLeafDyn(var T : TPointerProcParam);





// Liste des modules 'extra'
Procedure TransitionToLiguleState(var instance : TInstance; const len, predim, isOnMainstem : double);
Procedure TransitionToMatureState(var instance : TInstance; const len, predim, isOnMainstem : double);
Procedure SumOfLastdemandInLeafRec(var instance : TInstance; var total : Double);
Procedure EnableNbTillerCount_LE(var instance : TInstance; const stadePheno, nbLeafEnablingTillering : Double);
Procedure CountNbTiller_LE(var instance : TInstance; var total : double);
Procedure CreateTillers_LE(var instance : TInstance; const boolCrossedPlasto,Ic,Ict,exeOrder,P,resp_Ict, thresINER, slopeINER, leafStockMax : double; var nbTiller : double);
Procedure CreateTillersPhytomer_LE(var instance : TInstance; const boolCrossedPlasto,Ic,Ict,exeOrder,P,resp_Ict, thresINER, slopeINER, leafStockMax : double; var nbTiller : double);
Procedure ChangeOrganExeOrder_LE(var instance : TInstance);
Procedure KillOldestLeaf_LE(var instance : TInstance ; const realocationCoeff : Double; var deficit, stock, senesc_dw, deadleafNb, computedReallocBiomass : Double);
procedure KillYoungestTillerOldestLeaf_LE(var instance : TInstance ; const reallocationCoeff, nbLeafEnablingTillering : Double; var deficit, stock, senesc_dw, deadleafNb, deadtillerNb, computedReallocBiomass : Double);
Procedure CountNbLeaf_LE(var instance : TInstance; var total : double);
Procedure CountOfNbTillerWithMore4Leaves_LE(var instance : TInstance; var nbTillerWithMore4Leaves : Double);
Procedure CountOfNbTillerWithMoreNbLeafEnablingTilleringLeaves_LE(var instance : TInstance; const nbLeafEnablingTillering : Double; var nbTillerWithMore4Leaves : Double);
Procedure ComputePHT_LE(var instance : TInstance; const G_L, LL_BL, stockPlant, stockInternodePlant, structLeaf : double ;var PHT, SLALFEL, AreaLFEL, DWLFEL : double);
Procedure CountAndTagOfNbTillerWithMore4Leaves_LE(var instance : TInstance; var nbTillerFertile : Double);
procedure TillerSequenceToPI_LE(var instance : TInstance; const n, nbLeafPI, coeffPILag, isNewPlasto : Double; var addedLag : Double);
procedure TillerSequenceToFlo_LE(var instance : TInstance; const n, nbLeafFlo, coeffFloLag, isNewPlasto : Double; var addedLag : Double);
procedure ComputeSupplyPlant_LE(var instance : TInstance);
procedure ComputeSurplusPlant_LE(var instance : TInstance);
procedure ComputeStockPlant_LE(var instance : TInstance);
procedure ComputeDeficitPlant_LE(var instance : TInstance);
procedure SaveTableData_LE(var instance : TInstance);
Procedure SumOfLastdemandInOrganRec(var instance : TInstance; var total : Double);
procedure ComputeAssimTillers_LE(var instance : TInstance);
procedure ComputeStockTillers_LE(var instance : TInstance);
procedure ComputeSurplusTillers_LE(var instance : TInstance);
Procedure OA_StopInterceptionComputation_LE(var instance : TInstance);
procedure ComputeMaxReservoirCulms_LE(var instance : TInstance);
procedure ComputeLastDemandCulms_LE(var instance : TInstance);
procedure ComputeAssimCulms_LE(var instance : TInstance);
procedure ComputeStockCulms_LE(var instance : TInstance);
procedure ComputeDeficitCulms_LE(var instance : TInstance);
procedure ComputeSurplusCulms_LE(var instance : TInstance);
procedure ComputeTmpCulms_LE(var instance : TInstance);
procedure ComputeLeafInternodeBiomassCulms_LE(var instance : TInstance);
procedure ComputeSumOfBiomassOnInternodeInMatureStateOnCulms_LE(var instance : TInstance);
procedure ComputeStockInternodeOnCulms_LE(var instance : TInstance);
procedure ComputeNbActiveInternodesOnMainstem(var instance : TInstance; var nbActiveInternodesOnMainstem : Double);
procedure ComputeStockMainstemOutput(var instance : TInstance; var stockMainstem : Double);
procedure SumOfInternodeLengthOnMainstem(var instance : TInstance; var internodeLengthOnMainstem : Double);
procedure ComputeFirstLastExpandedInternodeDiameterMainstem(var instance : TInstance; var firstDiameter, lastDiameter, lastLength, lastRank : Double);
procedure ComputeStockInternodeMainstem(var instance : TInstance; var stock : Double);
procedure ComputeStockInternodeTillers(var instance : TInstance; var stock : Double);
procedure SetAliveToDead(var instance : TInstance; var alive : Double);
procedure FindLengthPeduncle(var instance : TInstance; var lengthPeduncle : Double);                                          
procedure ComputeLengthPeduncles(var instance : TInstance; var heightPanicleMainstem : Double);
procedure ComputeCorrectedBladeArea(var instance : TInstance; var correctedBladeArea : Double);
procedure ComputeCorrectedLeafBiomass(var instance : TInstance; var correctedLeafBiomass : Double);
procedure ComputeDeadLeafBiomass(var instance : TInstance; var deadLeafBiomass : Double);
procedure ComputeLeavesSenescenceStock(var instance : TInstance; const reallocCoef : Double; var senesc_dw, stock : Double);
procedure ComputeBiomassInAllLeaves(var instance : TInstance; var biomLeafStruct : Double);
procedure ComputeBiomassLeavesMainstem(var instance : TInstance; var sumOfMainstemLeafBiomass : Double);
procedure ComputeBladeAreaInAllLeaves(var instance : TInstance; var PAI : Double);
procedure ComputeBladeAreaLeavesMainstem(var instance : TInstance; var sumOfBladeAreaOnMainstem : Double);
procedure KillSenescLeaves(var instance : TInstance; var deadLeafNb : Double);
procedure ComputeThermalTimeSinceLigulation_LE(var instance : TInstance; var ThermalTimeSinceLigulation : Double);
procedure ComputeInternodeLengthPredim(var instance : TInstance; const slopeLengthIN, leafLengthToINLength : Double; var internodeLengthPredim : Double);
procedure ComputePeduncleLengthPredim(var instance : TInstance; const ratioINPed : Double; var peduncleLengthPredim : Double);
procedure ComputePeduncleDiameterPredim(var instance : TInstance; const peduncleDiam : Double; var peduncleDiameterPredim : Double);
procedure ComputeStructLeaf(var instance : TInstance; var structLeaf : Double);
procedure ComputeSumOfBiomass(var instance : TInstance; var sumOfBiomass : Double);
procedure ComputeWeightPanicle(var instance : TInstance; var weightPanicle, weightPanicleMainstem : Double);
procedure SumOfDailySenescedLeafBiomassOnCulm(var instance : TInstance; var sumOfDailySenescedLeafBiomass : Double);
procedure SumOfDailySenescedLeafBiomass(var instance : TInstance; var total : Double);










Procedure TransitionToLiguleStateDyn(var instance : TInstance; Var T : TPointerProcParam);
Procedure TransitionToMatureStateDyn(var instance : TInstance; Var T : TPointerProcParam);
Procedure SumOfLastdemandInLeafRecDyn(var instance : TInstance; Var T : TPointerProcParam);
Procedure EnableNbTillerCount_LEDyn(var instance : TInstance; Var T : TPointerProcParam);
Procedure CountNbTiller_LEDyn(var instance : TInstance; Var T : TPointerProcParam);
Procedure CreateTillers_LEDyn(var instance : TInstance; Var T : TPointerProcParam);
Procedure CreateTillersPhytomer_LEDyn(var instance : TInstance; var T : TPointerProcParam);
Procedure ChangeOrganExeOrder_LEDyn(var instance : TInstance; Var T : TPointerProcParam);
Procedure KillOldestLeaf_LEDyn(var instance : TInstance; Var T : TPointerProcParam);
procedure KillYoungestTillerOldestLeaf_LEDyn(var instance : TInstance; Var T : TPointerProcParam);
Procedure CountNbLeaf_LEDyn(var instance : TInstance; Var T : TPointerProcParam);
Procedure CountOfNbTillerWithMore4Leaves_LEDyn(var instance : TInstance; Var T : TPointerProcParam);
procedure CountOfNbTillerWithMoreNbLeafEnablingTilleringLeaves_LEDyn(var instance : TInstance; Var T : TPointerProcParam);
Procedure ComputePHT_LEDyn(var instance : TInstance; Var T : TPointerProcParam);
Procedure CountAndTagOfNbTillerWithMore4Leaves_LEDyn(var instance : TInstance; Var T : TPointerProcParam);
procedure TillerSequenceToPI_LEDyn(var instance : TInstance; Var T : TPointerProcParam);
procedure TillerSequenceToFlo_LEDyn(var instance : TInstance; Var T : TPointerProcParam);
procedure ComputeSupplyPlant_LEDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeSurplusPlant_LEDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeStockPlant_LEDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeDeficitPlant_LEDyn(var instance : TInstance; var T : TPointerProcParam);
procedure SaveTableData_LEDyn(var instance : TInstance; var T : TPointerProcParam);
Procedure SumOfLastdemandInOrganRecDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeAssimTillers_LEDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeStockTillers_LEDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeSurplusTillers_LEDyn(var instance : TInstance; var T : TPointerProcParam);
Procedure OA_StopInterceptionComputation_LEDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeMaxReservoirCulms_LEDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeLastDemandCulms_LEDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeAssimCulms_LEDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeStockCulms_LEDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeDeficitCulms_LEDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeSurplusCulms_LEDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeTmpCulms_LEDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeLeafInternodeBiomassCulms_LEDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeSumOfBiomassOnInternodeInMatureStateOnCulms_LEDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeStockInternodeOnCulms_LEDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeNbActiveInternodesOnMainstemDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeStockMainstemOutputDyn(var instance : TInstance; var T : TPointerProcParam);
procedure SumOfInternodeLengthOnMainstemDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeFirstLastExpandedInternodeDiameterMainstemDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeStockInternodeMainstemDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeStockInternodeTillersDyn(var instance : TInstance; var T : TPointerProcParam);
procedure SetAliveToDeadDyn(var instance : TInstance; var T : TPointerProcParam);
procedure FindLengthPeduncleDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeLengthPedunclesDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeCorrectedBladeAreaDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeCorrectedLeafBiomassDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeDeadLeafBiomassDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeLeavesSenescenceStockDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeBiomassInAllLeavesDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeBiomassLeavesMainstemDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeBladeAreaInAllLeavesDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeBladeAreaLeavesMainstemDyn(var instance : TInstance; var T : TPointerProcParam);
procedure KillSenescLeavesDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeThermalTimeSinceLigulation_LEDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeInternodeLengthPredimDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputePeduncleLengthPredimDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputePeduncleDiameterPredimDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeStructLeafDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeSumOfBiomassDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeWeightPanicleDyn(var instance : TInstance; var T : TPointerProcParam);
procedure SumOfDailySenescedLeafBiomassOnCulmDyn(var instance : TInstance; var T : TPointerProcParam);
procedure SumOfDailySenescedLeafBiomassDyn(var instance : TInstance; var T : TPointerProcParam);








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

uses EntityTiller_LE, EntityTillerPhytomer_LE;

const
  PI = 3.1416;

//----------------------------------------------------------------------------
// Procedure ComputeRootDemand_LE
// -------------------------------
//
/// exponential decrease of root vs. shoot demand
///
/// Description : Calcule le coeeficient de demande racinaire.
///     Ce coefficient decroit exponentiellement jour apres jour
///
///  equation :
///    R_d(i) = A*exp(K*numOfSimulationDay(i));
///
// ---------------------------------------------------------------------------
(**
@param supply  (In) offre du jour precedent
@param dayDemand (In) demande journaliere du jour precedent
@param Ic (Out) indice de competition
@param testIc (Out) ??????????????????????
*)

Procedure ComputeRootDemand_LE(const A, K, numOfSimulationDay, resp_R_d, P : Double; var R_d: Double);
begin
  R_d := A * exp(K * numOfSimulationDay) * ((P * resp_R_d) + 1);
end;


// ----------------------------------------------------------------------------
//  Procedure ComputeLeafPredimensionnement_LE
//  ------------------------------------------
//
/// Calcule le predimensionnement d'une feuille (pour le modele EcoMeristem_LE)
///
/// Description : Calcule le predimensionnement d'une feuille. Ce
/// predimensionnment depend de la position de la feuille (si la feuille est sur
/// le brin maitre ou non et si c est la premiere feuille du brin maitre / talle
/// ou non)
///
/// equation :
///
///
// ---------------------------------------------------------------------------
(**
@param isFirstLeaf (In) indique si la feuille est la premiere feuille de l'organe porteur
@param isOnMaistem (In) indique si la feuille est sur le brin maitre ou sur une talle
@param predimOfPreviousLeaf (In) predimensionnement de la feuille precedente
@param predimLeafOnMainstem (In) predimensionnement de la feuille en realisation sur le mainstem
@param Lef1 (In) Lenght of the first leaf on the mainstem (in centimeter)
@param MGR (In) meristem growth rate param to estimate potential demand (in centimeter ) of consecutive leaves (leaf (n)_biomss = MRG * leaf (n-1)_biom
@param testIc (In) IC related reducing factor of leaf predim
@param fcstr (In) water stress related reducing factor of leaf predim
@param predimOfCurrentLeaf (Out) predimensionnement de la feuille actuelle
*)

Procedure ComputeLeafPredimensionnement_LE(const isFirstLeaf, isOnMainstem, predimOfPreviousLeaf, predimLeafOnMainstem, Lef1, MGR, testIc, fcstr : Double; var predimOfCurrentLeaf : Double);
begin
  // Cas : premiere feuille sur le brin maitre
  if ((isFirstLeaf = 1) and (isOnMainstem = 1)) then
  begin
    SRwriteln('Cas : premiere feuille sur le brin maitre');
    predimOfCurrentLeaf := Lef1;
  end

  // Cas : pas la premiere feuille sur le brin maitre
  else if ((isFirstLeaf = 0) and (isOnMainstem = 1)) then
  begin
    SRwriteln('Cas : pas la premiere feuille sur le brin maitre');
    predimOfCurrentLeaf := predimLeafOnMainstem + MGR * testIc * fcstr;
  end

  // Cas : premiere feuille sur une talle
  else if ((isFirstLeaf = 1) and (isOnMainstem = 0)) then
  begin
    SRwriteln('Cas : premiere feuille sur une talle');
    predimOfCurrentLeaf := 0.5 * (predimLeafOnMainstem + Lef1) * testIc * fcstr;
  end

  // Cas : pas la premiere feuille sur une talle
  else if ((isFirstLeaf = 0) and (isOnMainstem = 0)) then
  begin
    SRwriteln('Cas : pas la premiere feuille sur une talle');
    predimOfCurrentLeaf := 0.5 * (predimLeafOnMainstem + predimOfPreviousLeaf) + MGR * testIc * fcstr;
  end;

  SRwriteln('MGR                  --> ' + FloatToStr(MGR));
  SRwriteln('Lef1                 --> ' + FloatToStr(Lef1));
  SRwriteln('testIc               --> ' + FloatToStr(testIc));
  SRwriteln('fcstr                --> ' + FloatToStr(fcstr));
  SRwriteln('predimLeafOnMainstem --> ' + FloatToStr(predimLeafOnMainstem));
  SRwriteln('predimOfPreviousLeaf --> ' + FloatToStr(predimOfPreviousLeaf));
  SRwriteln('predimOfCurrentLeaf  --> ' + FloatToStr(predimOfCurrentLeaf));
end;

// -----------------------------------------------------------------------------
// Procedure ComputeInternodeDiameterPredim_LE
// -------------------------------------------
//
// Calcule le predimensionnement du diamètre d'un entre noeud
//
//
// Equation :
//     predim := 1 + leafWidthToINDiameter * leafOfSameRankWidth
//
// -----------------------------------------------------------------------------

procedure ComputeInternodeDiameterPredim_LE(const leafWidthToINDiameter, leafOnSameRankWidth : Double; var diameter : Double);
begin
  //diameter := min(leafWidthToINDiameter * leafOnSameRankWidth, 2.5);
  diameter := leafWidthToINDiameter * leafOnSameRankWidth;
   // for rice below:
  //diameter := leafWidthToINDiameter * leafOnSameRankWidth + 0.76 ;
  SRwriteln('leafWidthToINDiameter --> ' + FloatToStr(leafWidthToINDiameter));
  SRwriteln('leafOnSameRankWidth   --> ' + FloatToStr(leafOnSameRankWidth));
  SRwriteln('diameter              --> ' + FloatToStr(diameter));
end;

// ----------------------------------------------------------------------------
//  Procedure ComputeInternodePredimensionnement_LE
//  ------------------------------------------
//
/// Calcule le predimensionnement d'un entrenoeud (pour le modele EcoMeristem_LE)
///
/// Description : Calcule le predimensionnement d'un entrenoeud. Ce
/// predimensionnment depend de la position de l'entrenoeud (si l'entrenoeud est sur
/// le brin maitre ou non et si c est le premier entrenoeud du brin maitre / talle
/// ou non)
///
/// equation :
///
///
// ---------------------------------------------------------------------------
(**
@param isFirstInternode (In) indique si l'entrenoeud est le premier entrenoeud de l'organe porteur
@param isOnMaistem (In) indique si l'entrenoeud est sur le brin maitre ou sur une talle
@param predimOfPreviousInternode (In) predimensionnement de l'entrenoeud precedent
@param predimInternodeOnMainstem (In) predimensionnement de l'entrenoeud en realisation sur le mainstem
@param LIN1 (In) length of the first internode
@param MGR (In) meristem growth rate param to estimate potential demand (in centimeter) of consecutive internodes (internode(n)_length = MGR + internode(n-1)_length)
@param testIc (In) IC related reducing factor of leaf predim
@param fcstr (In) water stress related reducing factor of leaf predim
@param predimOfCurrentInternode (Out) predimensionnement de l'entrenoeud actuel
*)

Procedure ComputeInternodePredimensionnement_LE(const leafLength, leafLengthToINLength, testIc,fcstr : Double; var predimOfCurrentInternode : Double);
begin
  //for sugarcane:
  //predimOfCurrentInternode := max(2, (diameter * INDiameterToLength) * fcstr * testIc);
  predimOfCurrentInternode := max(2, (leafLength * leafLengthTOINLength) * fcstr * testIc);
   // for rice below:
  //predimOfCurrentInternode := (diameter * INDiameterToLength + 48) * fcstr * testIc;
  SRwriteln('leafLength               --> ' + FloatToStr(leafLength));
  SRwriteln('leafLengthTOINLength     --> ' + FloatToStr(leafLengthToINLength));
  SRwriteln('fcstr                    --> ' + FloatToStr(fcstr));
  SRwriteln('testIc                   --> ' + FloatToStr(testIc));
  SRwriteln('predimOfCurrentInternode --> ' + FloatToStr(predimOfCurrentInternode));

end;

//-----------------------------------------------------------------------------
// Procedure ComputeCstr_LE
//-------------------------
//
// Computation of Cstr
//
// Description:
//
// Equation:
//   Si FTSW < ThresTransp Alors
//      Cstr = max(0.0001, FTWS * (1 / ThresTransp)
//   Sinon
//      Cstr = 1
//
//-----------------------------------------------------------------------------
(**
@param FTSW (In)
@param ThresTransp (In)
@param Cstr (Out)
*)

Procedure ComputeCstr_LE(const FTSW, ThresTransp : Double; var Cstr : Double);
begin
  if (FTSW < ThresTransp) then
  begin
    cstr := max(0.0001, (FTSW * (1 / ThresTransp)));
  end
  else
  begin
    cstr := 1;
  end;

  SRwriteln('FTSW        --> ' + FloatToStr(FTSW));
  SRwriteln('ThresTransp --> ' + FloatToStr(ThresTransp));
  SRwriteln('Cstr        --> ' + FloatToStr(Cstr));
end;

//-----------------------------------------------------------------------------
// Procedure ComputeLER_LE
//------------------------
//
/// Computation of Leaf Expansion Rate (LER)
///
/// Description:
///
/// Equation:
///   Si FTSW < ThresLER Alors LER = max(0,1-(ThresSlope-FTSW)*SlopeLER);
///   Sinon LER = 1
///
//-----------------------------------------------------------------------------
(**
@param FTSW (In)
@param ThresLER (In)
@param SlopeLER (In)
@param reductionLER (Out)
*)

Procedure ComputeLER_LE(const FTSW,ThresLER,SlopeLER,P,resp_LER : Double; var reductionLER : Double);
begin
  if (FTSW < ThresLER) then
  begin
    reductionLER := max(0.0001, ((1 / ThresLER) * FTSW) * (1 + (P * resp_LER)));
  end
  else
  begin
    reductionLER := 1 + (P * resp_LER);
  end;

  SRwriteln('FTSW                 --> ' + floattostr(FTSW));
  SRwriteln('ThresLER             --> ' + floattostr(ThresLER));
  SRwriteln('SlopeLER             --> ' + floattostr(SlopeLER));
  SRwriteln('P                    --> ' + floattostr(P));
  SRwriteln('resp_LER             --> ' + floattostr(resp_LER));
  SRwriteln('reductionLER Calcule --> ' + floattostr(reductionLER));

end;

//-----------------------------------------------------------------------------
// Procedure CompuINER
//--------------------
//
/// Computation of the Internode Expansion Rate (INER)
///
/// Description:
///
/// Equation:
///   Si FTSW < ThresINER Alors LER = max(0,1-(ThresINER-FTSW)*SlopeINER);
///   Sinon LER = 1
///
//-----------------------------------------------------------------------------
(**
@param FTSW (In)
@param ThresINER (In)
@param SlopeINER (In)
@param reductionINER (Out)
*)

Procedure ComputeReductionINER_LE(const FTSW,ThresINER,slopeINER,P,resp_INER : Double; var reductionINER : Double);
begin
	if FTSW < ThresINER then
  begin
		reductionINER := max(0.0001, ((1 - (ThresINER - FTSW) * SlopeINER) * (1 + (P * resp_INER))));
  end
	else
  begin
    reductionINER := 1 + (P * resp_INER);
  end;

  SRwriteln('FTSW                  --> ' + floattostr(FTSW));
  SRwriteln('ThresINER             --> ' + floattostr(ThresINER));
  SRwriteln('SlopeINER             --> ' + floattostr(SlopeINER));
  SRwriteln('reductionINER Calcule --> ' + floattostr(reductionINER));

end;


// ----------------------------------------------------------------------------
//  Procedure ComputeLeafLER_LE
//  ------------------------------------------
//
/// Calcule le LER (pour le modele EcoMeristem_LE)
///
/// Description : Calcule LER d'une feuille. Ce
/// LER depend de la position de la feuille (si la feuille est sur
/// le brin maitre ou non et si c est la premiere feuille du brin maitre / talle
/// ou non)
///
/// equation :
///
///
// ---------------------------------------------------------------------------
(**
@param isFirstLeaf (In) indique si la feuille est la premiere feuille de l'organe porteur
@param isOnMainstem (In) indique si la feuille est sur le brin maitre ou sur une talle
@param predimOfCurrentLeaf (In) predimensionnement de la feuille
@param predimLeafOnMainstem (In) predimensionnement de la feuille en realisation sur le mainstem
@param fcstr (In) ???????????????????????
@param plasto (In) plastochron
@param phenoStage (In) stage phenologique de la plante
@param ligulo (In) ???????????????????????
@param LER (Out) LER de la feuille
*)

Procedure ComputeLeafLER_LE(const predimOfCurrentLeaf,reductionLER,plasto,phenoStage,ligulo : Double; var LER : Double);
begin
  SRwriteln('predimOfCurrentLeaf --> ' + FloatToStr(predimOfCurrentLeaf));
  SRwriteln('rank                --> ' + FloatToStr(phenoStage));
  SRwriteln('plasto              --> ' + FloatToStr(plasto));
  SRwriteln('ligulo              --> ' + FloatToStr(ligulo));
  SRwriteln('reductionLER        --> ' + FloatToStr(reductionLER));
  LER := predimOfCurrentLeaf * reductionLER / (plasto + phenoStage * (ligulo - plasto));
  SRwriteln('LER                 --> ' + FloatToStr(LER));
end;

// ----------------------------------------------------------------------------
//  Procedure ComputeINER_LE
//  ------------------------------------------
//
/// Computer the Internode Expansion Rate
///
// ---------------------------------------------------------------------------
(**
@param isFirstInternode (In)
@param isOnMainstem (In)
@param predimOfCurrentInternode (In)
@param predimInternodeOnMainstem (In)
@param fcstr (In)
@param plasto (In) plastochron
@param phenoStage (In) phenological stage of the plant
@param ligulo (In) thermal time between ligulation of two leaves (equal with plasto for rice)
@param INER (Out) internode's expansion rate
*)

Procedure ComputeINER_LE(const predimOfCurrentInternode,reductionINER,plasto,phenoStage,ligulo : Double; var INER : Double);
begin

  SRwriteln('predimOfCurrentInternode  --> ' + floattostr(predimOfCurrentInternode));
  SRwriteln('reductionINER             --> ' + floattostr(reductionINER));
  SRwriteln('plasto                    --> ' + floattostr(plasto));
  SRwriteln('rank                      --> ' + floattostr(phenoStage));
  SRwriteln('ligulo                    --> ' + floattostr(ligulo));
  INER := predimOfCurrentInternode * reductionINER / (plasto + phenoStage * (ligulo - plasto));
  SRwriteln('ComputeINER_LE --> INER : ' + floattostr(INER));

end;

// ----------------------------------------------------------------------------
//  Procedure ComputeLeafWidth_LE
//  -----------------------------
//
/// Calcule le width d'une feuille (pour le modele EcoMeristem_LE)
///
/// Description :
///
/// equation :
///     width(i) = len(i) * WLR / LL_BL
///
///
// ---------------------------------------------------------------------------
(**
@param width (In) ????????
@param len (In) ????????
@param WLR (In) ????????
@param LL_BL (In) ??????????
@param width (Out) ?????????
*)

Procedure ComputeLeafWidth_LE(const len, WLR, LL_BL : double; var width : double);
begin
  SRwriteln('len   --> ' + FloatToStr(len));
  SRwriteln('WLR   --> ' + FloatToStr(WLR));
  SRwriteln('LL_BL --> ' + FloatToStr(LL_BL));
  width := len * WLR / LL_BL;
  SRwriteln('width --> ' + FloatToStr(width));
end;

//
// procedure interne invisible de l'extérieur
//

procedure ComputeSurplusOrgan(const SupplyOrgan, DemandOfNonINOrgan, ReservoirDispoOrgan : Double; var SurplusOrgan : Double);
begin

  SRwriteln('SupplyOrgan         --> ' + floattostr(SupplyOrgan));
  SRwriteln('DemandOfNonINOrgan  --> ' + floattostr(0));
  SRwriteln('ReservoirDispoOrgan --> ' + floattostr(ReservoirDispoOrgan));

  SurplusOrgan := max(0, SupplyOrgan - ReservoirDispoOrgan);

  SRwriteln('SurplusOrgan        --> ' + floattostr(SurplusOrgan));

end;

// ----------------------------------------------------------------------------
//  Procedure ComputeSurplusMainstem_LE
//  -----------------------------------
//
/// Calcule  le surplus le mainstem
///
/// Description :
///
/// equation :
///     surplusmainstem = max(0, supplymainstem - demandmainstem - reservoirdispomainstem)
///
///
// ---------------------------------------------------------------------------
(**
@param SupplyMainstem (In)
@param DemandMainstem (In)
@param ReservoirDispoMainstem (In)
@param SurplusMainstem (Out)
*)

procedure ComputeSurplusMainstem_LE(const SupplyMainstem, DemandOfNonINMainstem, ReservoirDispoMainstem : Double; var SurplusMainstem : Double);
begin
  ComputeSurplusOrgan(SupplyMainstem, DemandOfNonINMainstem, ReservoirDispoMainstem, SurplusMainstem);
end;

// ----------------------------------------------------------------------------
//  Procedure ComputeSurplusTiller_LE
//  -----------------------------------
//
/// Calcule  le surplus le tiller
///
/// Description :
///
/// equation :
///     surplustiller = max(0, supplytiller - demandtiller - reservoirtiller)
///
///
// ---------------------------------------------------------------------------
(**
@param SupplyTiller (In)
@param DemandTiller (In)
@param ReservoirDispoTiller (In)
@param SurplusTiller (Out)
*)

procedure ComputeSurplusTiller_LE(const SupplyTiller, DemandOfNonINTiller, ReservoirDispoTiller : Double; var SurplusTiller : Double);
begin
  ComputeSurplusOrgan(SupplyTiller, DemandOfNonINTiller, ReservoirDispoTiller, SurplusTiller);
end;


// ----------------------------------------------------------------------------
//  Procedure ComputeLeafBladeArea_LE
//  ---------------------------------
//
/// Calcule le bladeArea d'une feuille (pour le modele EcoMeristem_LE)
///
/// Description :
///
/// equation :
///     bladeArea(i) = len(i) * width(i) * allo_area / LL_BL
///
///
// ---------------------------------------------------------------------------
(**
@param len (In) ????????
@param width (In) ????????
@param allo_area (In) ????????
@param LL_BL (In) ??????????
@param bladeArea (Out) ?????????
*)
Procedure ComputeLeafBladeArea_LE(const len, width, allo_area, LL_BL : double ; var bladeArea : double);
begin
  SRWriteln('len       --> ' + FloatToStr(len));
  SRWriteln('width     --> ' + FloatToStr(width));
  SRWriteln('allo_area --> ' + FloatToStr(allo_area));
  SRWriteln('LL_BL     --> ' + FloatToStr(LL_BL));
  bladeArea := len * width * allo_area / LL_BL;
  SRWriteln('bladeArea --> ' + FloatToStr(bladeArea));
end;


// ----------------------------------------------------------------------------
//  Procedure ComputeLeafExpTime_LE
//  ------------------------------------------
//
/// Calcule le exp_time d'une feuille (pour le modele EcoMeristem_LE)
///
/// Description : Calcule le exp_time d'une feuille. Ce exp_time
/// depend de la position de la feuille (si la feuille est la premiere
/// feuille du brin maitre ou non)
///
/// equation :
///     Si la feuille est la premiere feuille du brin maitre
///             exp_time(i) = predim(i) / LER(i)
///     Sinon
///             exp_time(i) = (predim(i)-len(i)) / LER(i)
///
///
// ---------------------------------------------------------------------------
(**
@param isFirstLeaf (In) indique si la feuille est la premiere feuille de l'organe porteur
@param isOnMainstem (In) indique si la feuille est sur le brin maitre ou sur une talle
@param predim (In) predimensionnement de la feuille
@param len (In) ????????? de la feuille
@param LER (In) ??????????????????????? de la feuille
@param exp_time (Out) ???????? de la feuille
*)

Procedure ComputeLeafExpTime_LE(const isFirstLeaf,isOnMainstem,predim,len,LER : double ; var exp_time : double);
begin

  SRwriteln('isFirstLeaf  --> ' + floattostr(isFirstLeaf));
  SRwriteln('isOnMainstem --> ' + floattostr(isOnMainstem));
  SRwriteln('predim       --> ' + floattostr(predim));
  SRwriteln('len          --> ' + floattostr(len));
  SRwriteln('LER          --> ' + floattostr(LER));

  // Cas : premiere feuille sur le brin maitre
  if ((isFirstLeaf = 1) and (isOnMainstem = 1)) then
  begin
    exp_time := predim / LER;
  end
  else
  begin
    exp_time := (predim - len) / LER;
  end;

  SRwriteln('exp_time     --> ' + floattostr(exp_time));
end;

// ----------------------------------------------------------------------------
//  Procedure ComputeInternodeExpTime_LE
//  ------------------------------------
//
/// Compute the remaining expansion duration
/// equation :
///     If first internode on the mainstem
///             exp_time(i) = predim(i) / INER(i)
///     Else
///             exp_time(i) = (predim(i)-len(i)) / INER(i)
///
///
// ---------------------------------------------------------------------------
(**
@param isFirstInternode (In) indique si l'entrenoeud est le premier entrenoeud de l'organe porteur
@param isOnMainstem (In) indique si l'entrenoeud est sur le brin maitre ou sur une talle
@param predim (In) predimensionnement de l'entrenoeud
@param len (In) longueur de l'entrenoeud
@param INER (In) internode expansion rate
@param exp_time (Out) time to final size of internode
*)

Procedure ComputeInternodeExpTime_LE(const isFirstInternode,isOnMainstem,predim,len,INER : double ; var exp_time : double);
begin

  SRwriteln('isFirstInternode  --> ' + floattostr(isFirstInternode));
  SRwriteln('isOnMainstem      --> ' + floattostr(isOnMainstem));
  SRwriteln('predim            --> ' + floattostr(predim));
  SRwriteln('len               --> ' + floattostr(len));
  SRwriteln('INER              --> ' + floattostr(INER));
  // Case: main stem first internode
  if ((isFirstInternode = 1) and (isOnMainstem = 1)) then
  begin
    exp_time := predim / INER;
  end
  // other case
  else
  begin
    exp_time := (predim - len) / INER;
  end;
  SRwriteln('exp_time         --> ' + floattostr(exp_time));
end;


// ----------------------------------------------------------------------------
//  Procedure ComputeLeafBiomass_LE
//  ------------------------------------------
//
/// Calcule la biomasse d'une feuille (pour le modele EcoMeristem_LE)
///
/// Description : Calcule la biomasse d'une feuille.
///
/// equation :
///     biomass(i) = (1/G_L) * bladeArea / SLA
///
///
// ---------------------------------------------------------------------------
(**
@param bladeArea (In) ????? de la feuille
@param SLA (In) SLA de la feuille
@param G_L (In) ??????????
@param biomasse (Out) biomasse de la feuille
*)

Procedure ComputeLeafBiomass_LE(const bladeArea, SLA, G_L : double ; var biomass : double);
begin
  biomass := (1 / G_L) * bladeArea / SLA;
  SRwriteln('G_L       --> ' + FloatToStr(G_L));
  SRwriteln('bladeArea --> ' + FloatToStr(bladeArea));
  SRwriteln('SLA       --> ' + FloatToStr(SLA));
  SRwriteln('biomass   --> ' + FloatToStr(biomass));
end;

// ----------------------------------------------------------------------------
//  Procedure ComputeInternodeBiomass_LE
//  ------------------------------------------
//
/// Compute the internode biomass
///
/// equation :
///     biomass(i) = volume(i) * density(i)
///
///
// ---------------------------------------------------------------------------
(**
@param volume (In)
@param density (In)
@param biomass (Out)
*)

procedure ComputeInternodeBiomass_LE(const Volume, density : Double; var Biomass : Double);
begin
  Biomass := Volume * density;

  SRwriteln('Volume  --> ' + FloatToStr(Volume));
  SRwriteln('density --> ' + FloatToStr(density));
  SRwriteln('Biomass --> ' + FloatToStr(Biomass));

end;

// ----------------------------------------------------------------------------
// Procedure ComputeInternodeStock_LE
// ----------------------------------
//
// Calcule le stock de l'entrenoeud
// equation :
//      stock = min(0.9*biomass_IN, (biomass_IN / sumOfInternodeBiomassOnCulm) * stockCulm)
//
// ----------------------------------------------------------------------------
(**
@param biomass_IN (In)
@param sumOfInternodeBiomassOnCulm (In)
@param stockCulm (In)
@param stock_IN (Out)
*)

procedure ComputeInternodeStock_LE(const maximumReserveInInternode, biomassIN, sumOfInternodeBiomassOnCulm, stockCulm, demandIN : Double; var stock_IN, deficit_IN : Double);
begin
  SRwriteln('maximumReserveInInternode   --> ' + floattostr(maximumReserveInInternode));
  SRwriteln('biomassIN                   --> ' + floattostr(biomassIN));
  SRwriteln('sumOfInternodeBiomassOnCulm --> ' + floattostr(sumOfInternodeBiomassOnCulm));
  SRwriteln('stockCulm                   --> ' + floattostr(stockCulm));
  SRwriteln('demandIN                    --> ' + floattostr(demandIN));
  stock_IN := max(0, min(maximumReserveInInternode * biomassIN, ((biomassIN / sumOfInternodeBiomassOnCulm) * stockCulm) - demandIN));
  deficit_IN := min(0, ((biomassIN / sumOfInternodeBiomassOnCulm) * stockCulm) - demandIN);
  SRwriteln('stock_IN                    --> ' + floattostr(stock_IN));
  SRwriteln('deficit_IN                  --> ' + floattostr(deficit_IN));
end;

// ----------------------------------------------------------------------------
//  Procedure ComputeSWC_LE
//  -----------------------
//
/// Calcule le Soil Water Content en prenant en compte une éventuelle irrigation
///
///
// ----------------------------------------------------------------------------
(**
@param deltap (In)
@param waterSupply (In)
@param SWC (Out)
*)


procedure ComputeSWC_LE(const deltap, waterSupply : Double; var SWC : Double);
begin
  SRwriteln('AVANT');
  SRwriteln('-----');
  SRwriteln('SWC         --> ' + floattostr(SWC));
  SRwriteln('deltap      --> ' + floattostr(deltap));
  SRwriteln('waterSupply --> ' + floattostr(waterSupply));
  SWC := (SWC - deltap) + waterSupply;
  SRwriteln('APRES');
  SRwriteln('-----');
  SRwriteln('SWC         --> ' + floattostr(SWC));
end;

// ----------------------------------------------------------------------------
//  Procedure ComputeInternodeReservoirDispo_LE
//  -----------------------------------
//
/// Calcule le reservoir disponible de l'entrenoeud
///
// ----------------------------------------------------------------------------
(**
@param biomass_IN (In)
@param stock_IN (In)
@param reservoiDispo_IN (Out)
*)

procedure ComputeInternodeReservoirDispo_LE(const maximumReserveInInternode, biomass_IN, stock_IN : Double; var reservoirDispo_IN : Double);
begin

  SRwriteln('maximumReserveInInternode --> ' + floattostr(maximumReserveInInternode));
  SRwriteln('biomass_IN                --> ' + floattostr(biomass_IN));
  SRwriteln('stock_IN                  --> ' + floattostr(stock_IN));

  reservoirDispo_IN := max(0, maximumReserveInInternode*biomass_IN-stock_IN);

  SRwriteln('reservoirDispo_IN         --> ' + floattostr(reservoirDispo_IN));
end;

//
// procedure interne invisible de l'extérieur
//
procedure ComputeAssimCulm(const assimPlant, sumOfBladeAreaOnCulm, sumOfBladeAreaPlant : Double; var assimCulm : Double);
begin
  SRwriteln('assimPlant           --> ' + floattostr(assimPlant));
  SRwriteln('sumOfBladeAreaOnCulm --> ' + floattostr(sumOfBladeAreaOnCulm));
  SRwriteln('sumOfBladeAreaPlant  --> ' + floattostr(sumOfBladeAreaPlant));

  assimCulm := assimPlant * (sumOfBladeAreaOnCulm / sumOfBladeAreaPlant);

  SRwriteln('assimCulm            --> ' + floattostr(assimCulm));
end;

// ----------------------------------------------------------------------------
//  Procedure ComputeAssimTiller_LE
//  ---------------------------------
//
/// Calcule la demande du tiller
///
/// equation :
///     assimTiller = assimPlant * (sumOfBladeAreaOnTiller / sumOfBladeAreaPlant)
///
///
// ---------------------------------------------------------------------------
(**
@param assimPlant (In)
@param sumOfBladeAreaOnTiller (In)
@param sumOfBladeAreaPlant (In)
@param assimTiller (Out)
*)

procedure ComputeAssimTiller_LE(const assimPlant, sumOfBladeAreaOnTiller, sumOfBladeAreaPlant : Double; var assimTiller : Double);
begin
  ComputeAssimCulm(assimPlant, sumOfBladeAreaOnTiller, sumOfBladeAreaPlant, assimTiller);
end;


// ----------------------------------------------------------------------------
//  Procedure ComputeAssimMainstem_LE
//  ---------------------------------
//
/// Calcule la demande du mainstem
///
/// equation :
///     assimMainstem = assimPlant * (sumOfBladeAreaOnMainstem / sumOfBladeAreaPlant)
///
///
// ---------------------------------------------------------------------------
(**
@param assimPlant (In)
@param sumOfBladeAreaOnMainstem (In)
@param sumOfBladeAreaPlant (In)
@param assimMainstem (Out)
*)

procedure ComputeAssimMainstem_LE(const assimPlant, sumOfBladeAreaOnMainstem, sumOfBladeAreaPlant : Double; var assimMainstem : Double);
begin
  ComputeAssimCulm(assimPlant, sumOfBladeAreaOnMainstem, sumOfBladeAreaPlant, assimMainstem);
end;

// ----------------------------------------------------------------------------
//  Procedure ComputeInternodeDemand_LE
//  -----------------------------------
//
/// Calcule la demande d'un entrenoeud
///
/// equation :
///     demand(i) = volume * density_IN
///
///
// ---------------------------------------------------------------------------
(**
@param density_IN (In)
@param volume (In)
@param biomass (In)
@param demand (Out)
*)

procedure ComputeInternodeDemand_LE(const density_IN, volume, biomass: double; var demand : double);
begin
  demand := (density_IN * volume) - biomass;
  SRwriteln('density_IN --> ' + FloatToStr(density_IN));
  SRwriteln('volume     --> ' + FloatToStr(volume));
  SRwriteln('biomass    --> ' + FloatToStr(biomass));
  SRwriteln('demand     --> ' + FloatToStr(demand));
end;

// ----------------------------------------------------------------------------
//  Procedure ComputeLeafDemand_LE
//  ------------------------------------------
//
/// Calcule la demande d'une feuille (pour le modele EcoMeristem_LE)
///
/// Description : Calcule la demande d'une feuille.
///
/// equation :
///     demand(i) = (1/G_L) * bladeArea / SLA -biomass
///
///
// ---------------------------------------------------------------------------
(**
@param bladeArea (In) ????? de la feuille
@param SLA (In) SLA de la feuille
@param G_L (In) ??????????
@param biomass (In) biomasse de la feuille
@param demand (Out) demand de la feuille
*)

Procedure ComputeLeafDemand_LE(const bladeArea, SLA, G_L, biomass : double ; var demand : double);
begin
  SRwriteln('bladeArea --> ' + floattostr(bladeArea));
  SRwriteln('SLA       --> ' + floattostr(SLA));
  SRwriteln('G_L       --> ' + floattostr(G_L));
  SRwriteln('biomass   --> ' + floattostr(biomass));
  demand := ((1/G_L) * bladeArea / SLA) - biomass;
  SRwriteln('demand    --> ' + floattostr(demand));
end;

// ----------------------------------------------------------------------------
// Procedure UpdateIH
// ------------------
//
// Mise à jour de l'indice de Haun
//
// equation :
//      IH(i) = lig(i) + min(1,TT_lig(i)/ligulo)
//
//
// ----------------------------------------------------------------------------
(**
@param IH (Out) le nouvel indice de Haun
@param lig (In)
@param TT_lig(In)
@param ligulo (In)
*)

Procedure UpdateIH_LE(const lig, TT_lig, ligulo : double ; var IH, isFirstStep : double);
begin

	if (isFirstStep = 1) then
  begin
    IH := 0;
    isFirstStep := 0;
  end
  else
  begin
		IH := lig + min(1, TT_lig / ligulo);
  end;

  SRwriteln('lig    --> ' + floattostr(lig));
  SRwriteln('TT_lig --> ' + floattostr(TT_lig));
  SRwriteln('ligulo --> ' + floattostr(ligulo));
  SRwriteln('IH     --> ' + floattostr(IH));
end;

// ----------------------------------------------------------------------------
// Procedure UpdateTT_lig
// ----------------------
//
// Mise à jour du TT_lig
//
// equation :
//      TT_lig(i) = TT_lig(i-1)+EDD(i)
//
//
// ----------------------------------------------------------------------------
(**
@param EDD (In)
@param TT_lig(InOut)
*)

Procedure UpdateTT_lig_LE(const EDD : double ; var TT_lig, isFirstStep : double);
begin

	if (isFirstStep = 1) then
  begin
    TT_lig := 0;
    isFirstStep := 0;
  end
  else
  begin
    SRwriteln('previous TT_lig --> ' + floattostr(TT_lig));
    TT_lig := TT_lig + EDD;
  end;

  SRwriteln('EDD             --> ' + floattostr(EDD));
  SRwriteln('TT_lig          --> ' + floattostr(TT_lig));

end;

// ----------------------------------------------------------------------------
//  Procedure UpdateInternodeLength_LE
//  ----------------------------------
//
/// Mise a jour de la longueur de l'entrenoeud (pour le modele EcoMeristem_LE)
///
/// equation :
///     len(i) = len(i-1) + INER(i) * min(deltaT(i),exp_time(i))
///
///
// ---------------------------------------------------------------------------
(**
@param INER (In)
@param deltaT (In) Temperature utile (Tair -Tbase)
@param exp_time (In)
@param demand (InOut) longueur de l'entrenoeud
*)

Procedure UpdateInternodeLength_LE(const INER, deltaT, exp_time : double ; var len : double);
begin
  SRwriteln('INER     --> ' + FloatToStr(INER));
  SRwriteln('deltaT   --> ' + FloatToStr(deltaT));
  SRwriteln('exp_time --> ' + FloatToStr(exp_time));
  len := len + INER * min(deltaT, exp_time);
  SRwriteln('len      --> ' + FloatToStr(len));
end;

// ----------------------------------------------------------------------------
//  Procedure UpdateLeafLength_LE
//  -----------------------------
//
/// Mise a jour de la longueur d'une feuille (pour le modele EcoMeristem_LE)
///
/// Description : Mise a jour de la longueur d'une feuille.
///
/// equation :
///     len(i) = len(i-1) + LER(i) * min(deltaT(i),exp_time(i))
///
///
// ---------------------------------------------------------------------------
(**
@param LER (In) ????? de la feuille
@param deltaT (In) Temperature utile (Tair -Tbase)
@param exp_time (In) ??????????
@param demand (InOut) longueur de la feuille
*)

Procedure UpdateLeafLength_LE(const LER, deltaT, exp_time : double ; var len : double);
begin
  SRwriteln('len avant --> ' + floattostr(len));
  SRwriteln('LER       --> ' + floattostr(LER));
  SRwriteln('deltaT    --> ' + floattostr(deltaT));
  SRwriteln('exp_time  --> ' + floattostr(exp_time));
  len := len + LER * min(deltaT, exp_time);
  SRwriteln('len apres --> ' + floattostr(len));
end;



// ----------------------------------------------------------------------------
//  Procedure ComputeReservoirDispo_LE
//  ------------------------------------------
//
/// Calcule ??????????
///
/// Description :
///
/// equation :
///     reservoirDispo(i) = 0.5 * sumOfLeavesBiomass - stock
///
///
// ---------------------------------------------------------------------------
(**
@param sumOfLeavesBiomass (In) somme des biomasses de toutes les feuilles
@param stock (In) stock de biomasse
@param reservoirDispo (Out) ????????????????????
*)

Procedure ComputeReservoirDispo_LE(const leafStockMax, sumOfLeavesBiomass, stock : double ; var reservoirDispo : double);
begin
  reservoirDispo := leafStockMax * sumOfLeavesBiomass - stock;
  SRwriteln('leafStockMax       --> ' + FloatToStr(leafStockMax));
  SRwriteln('stock              --> ' + FloatToStr(stock));
  SRwriteln('sumOfLeavesBiomass --> ' + FloatToStr(sumOfLeavesBiomass));
  SRwriteln('reservoirDispo     --> ' + FloatToStr(reservoirDispo));
end;


// ----------------------------------------------------------------------------
//  Procedure UpdateSeedres_LE
//  --------------------------
//
/// Calcule ??????????
///
/// Description :
///
/// equation :
///
///
///
// ---------------------------------------------------------------------------
(**
@param seedres (InOut) somme des biomasses de toutes les feuilles
@param dayDemand (InOut) stock de biomasse
*)
Procedure UpdateSeedres_LE(var seedres,dayDemand : double);
begin

  if (seedres > 0) then
  begin
    seedres := seedres - dayDemand;
    dayDemand := 0;
  end
  else
  begin
    seedres := 0;
  end;

end;

// ----------------------------------------------------------------------------
// Procedure ComputeDayDemand_LE
// -----------------------------
//
// Gère le dayDemand en état 3 et le premier jour
//
// Equation : si nbDayOfSimulation = 1 alors
//                dayDemand = sumOfDemand + lastDemand
//            sinon
//                dayDemand = 0
//            fin si
//
//
// ----------------------------------------------------------------------------
(**
@param sumOfDemand (In)
@parem lastDemand (In)
@param nbDayOfSimulation (In)
@param dayDemand (Out)
*)

procedure ComputeDayDemand_LE(const sumOfDemand, lastDemand, nbDayOfSimulation : Double; var dayDemand : Double);
begin
  SRwriteln('nbDayOfSimulation --> ' + floattostr(nbDayOfSimulation));
  SRwriteln('sumOfDemand       --> ' + floattostr(sumOfDemand));
  SRwriteln('lastDemand        --> ' + floattostr(lastDemand));
  if (Trunc(nbDayOfSimulation) = 1) then
    dayDemand := sumOfDemand + lastDemand
  else
    dayDemand := 0;
  SRwriteln('dayDemand         --> ' + floattostr(dayDemand));
end;

// ----------------------------------------------------------------------------
// Procedure UpdateSeedres2_LE
// ---------------------------
//
// Gère la réserve de carbone dans la graine
//
// Description :
//
// Equation : cf code matlab
//
//
//
// ----------------------------------------------------------------------------
(**
@param seedres (InOut) la ressource disponible dans la graine
@param dayDemand (InOut) la demande journalière
@param stock (InOut) le stock de biomasse
@param reservoirDispo (In)
@param supply (In)
*)
Procedure UpdateSeedres2_LE(const reservoirDispo, supply : double; var restDayDemand, seedres, dayDemand, deficit, stock : double);
begin
	SRwriteln('AVANT');
  SRwriteln('-----');
  SRwriteln('stock          --> ' + FloatToStr(stock));
  SRwriteln('deficit        --> ' + FloatToStr(deficit));
  SRwriteln('seedres        --> ' + FloatToStr(seedres));
  SRwriteln('dayDemand      --> ' + FloatToStr(dayDemand));
  SRwriteln('reservoirDispo --> ' + FloatToStr(reservoirDispo));
  SRwriteln('supply         --> ' + FloatToStr(supply));
	if (seedres > 0) then
  begin
    if (seedres > dayDemand) then
    begin
      seedres := seedres  - dayDemand;
      stock := stock + min(reservoirDispo, supply);

    end
    else
    begin
      restDayDemand := dayDemand - seedres;
      seedres := 0;
      stock := stock + min(reservoirDispo, supply - restDayDemand);
    end;
  end
  else
  begin
    seedres := 0;
    stock := stock + min(reservoirDispo, supply - dayDemand);
  end;
  stock := Max(0, stock);
  deficit := Min(0, stock);
  
  SRwriteln('APRES');
  SRwriteln('-----');
  SRwriteln('stock          --> ' + FloatToStr(stock));
  SRwriteln('deficit        --> ' + FloatToStr(deficit));
  SRwriteln('seedres        --> ' + FloatToStr(seedres));
  SRwriteln('dayDemand      --> ' + FloatToStr(dayDemand));
  SRwriteln('reservoirDispo --> ' + FloatToStr(reservoirDispo));
  SRwriteln('supply         --> ' + FloatToStr(supply));
end;

// ----------------------------------------------------------------------------
//  Procedure UpdateStock_LE
//  --------------------------
//
/// Mise a jour du stock disponible de biomasse
///
/// Description :
///
/// equation :
///
///
///
// ---------------------------------------------------------------------------
(**
@param reservoirDispo (In) ????????????????????
@param supply (In) offre en biomasse
@param dayDemand (In) demande journalière en biomasse
@param stock (InOut) stock de biomasse
*)
procedure UpdateStock_LE(const dayDemand, reservoirDispo, supply, dailySenescedLeafBiomass: Double; var stock, deficit, seedres, surplus : Double);
var
  restDayDemand, tmp : Double;
begin
	SRwriteln('AVANT');
  SRwriteln('-----');
  SRwriteln('stock                    --> ' + FloatToStr(stock));
  SRwriteln('deficit                  --> ' + FloatToStr(deficit));
  SRwriteln('seedres                  --> ' + FloatToStr(seedres));
  SRwriteln('dayDemand                --> ' + FloatToStr(dayDemand));
  SRwriteln('reservoirDispo           --> ' + FloatToStr(reservoirDispo));
  SRwriteln('supply                   --> ' + FloatToStr(supply));
  SRwriteln('surplus                  --> ' + FloatToStr(surplus));
  SRwriteln('dailySenescedLeafBiomass --> ' + FloatToStr(dailySenescedLeafBiomass));
	if (seedres > 0) then
  begin
    if (seedres > dayDemand) then
    begin
      seedres := seedres  - dayDemand;
      stock := stock + min(reservoirDispo, supply);
      surplus := max(supply - reservoirDispo, 0);
    end
    else
    begin
      restDayDemand := dayDemand - seedres;
      seedres := 0;
      stock := stock + min(reservoirDispo, supply - restDayDemand);
      surplus := max(supply - restDayDemand - reservoirDispo, 0);
    end;
  end
  else
  begin
    seedres := 0;
    stock := stock + min(reservoirDispo, supply - dayDemand);
    surplus := max(supply - dayDemand - reservoirDispo, 0);
  end;
  tmp := deficit + stock + dailySenescedLeafBiomass;
  deficit := Min(0, tmp);
  stock := Max(0, tmp);

  SRwriteln('APRES');
  SRWRITELN('-----');
  SRwriteln('stock                    --> ' + FloatToStr(stock));
  SRwriteln('deficit                  --> ' + FloatToStr(deficit));
  SRwriteln('seedres                  --> ' + FloatToStr(seedres));
  SRwriteln('dayDemand                --> ' + FloatToStr(dayDemand));
  SRwriteln('reservoirDispo           --> ' + FloatToStr(reservoirDispo));
  SRwriteln('supply                   --> ' + FloatToStr(supply));
  SRwriteln('surplus                  --> ' + FloatToStr(surplus));
  SRwriteln('dailySenescedLeafBiomass --> ' + FloatToStr(dailySenescedLeafBiomass));
end;


// ----------------------------------------------------------------------------
//  Procedure UpdateSurplus_LE
//  --------------------------
//
/// Mise a jour du surplus de biomasse
///
/// Description :
///
/// equation :
///
///
///
// ---------------------------------------------------------------------------
(**
@param reservoirDispo (In) ????????????????????
@param supply (In) offre en biomasse
@param dayDemand (In) demande journalière en biomasse
@param surplus (InOut) stock de biomasse
*)
Procedure UpdateSurplus_LE(const reservoirDispo, supply, seedres, restDayDemand, dayDemand : double; var surplus : double);
begin
	if (seedres > 0) then
  begin
    if (seedres > dayDemand) then
    begin

      surplus := max(supply - reservoirDispo, 0);
    end
    else
    begin
      surplus := max(supply - restDayDemand - reservoirDispo, 0);
    end;
  end
  else
  begin
    surplus := max(supply - dayDemand - reservoirDispo, 0);
  end;
  SRwriteln('reservoirDispo --> ' + FloatToStr(reservoirDispo));
  SRwriteln('seedres        --> ' + FloatToStr(seedres));
  SRwriteln('supply         --> ' + FloatToStr(supply));
  SRwriteln('restDayDemand  --> ' + FloatToStr(restDayDemand));
  SRwriteln('dayDemand      --> ' + FloatToStr(dayDemand));
  SRwriteln('surplus        --> ' + FloatToStr(surplus));
end;


//----------------------------------------------------------------------------
// Procedure ComputeIC
// -------------------
//
/// Calcule l'indice de competition 'Ic' et 'testIc' du jour
///
/// Description :
///
///  equation :
///
///
// ---------------------------------------------------------------------------
(**
@param seedres  (In) ???????????????
@param supply (In) offre en biomasse du jour
@param supply_previous1 (In) offre en biomasse du jour i-1
@param supply_previous2 (In) offre en biomasse du jour i-2
@param supply_previous3 (In) offre en biomasse du jour i-3
@param dayDemand (In) demande journaliere en biomasse du jour
@param dayDemand_previous1 (In) demande journaliere en biomasse du jour i-1
@param dayDemand_previous2 (In) demande journaliere en biomasse du jour i-2
@param dayDemand_previous3 (In) demande journaliere en biomasse du jour i-3
@param Ic (Out) indice de competition
@param testIc (Out) ??????????????????????
*)

Procedure ComputeIC_LE(const seedres,seedres_previous1,seedres_previous2,seedres_previous3,supply,supply_previous1,supply_previous2,supply_previous3,dayDemand,dayDemand_previous1,dayDemand_previous2,dayDemand_previous3, Ic_previous1 : double ; var Ic, testIc : double);
var
  resDiv, total, mean : double;
  n : integer;
begin

  SRwriteln('seedres             --> ' + floattostr(seedres));
  SRwriteln('supply              --> ' + floattostr(supply));
  SRwriteln('dayDemand           --> ' + floattostr(dayDemand));
  SRwriteln('------------------------');
  SRwriteln('seedres_previous1   --> ' + floattostr(seedres_previous1));
  SRwriteln('supply_previous1    --> ' + floattostr(supply_previous1));
  SRwriteln('dayDemand_previous1 --> ' + floattostr(dayDemand_previous1));
  SRwriteln('------------------------');
  SRwriteln('seedres_previous2   --> ' + floattostr(seedres_previous2));
  SRwriteln('supply_previous2    --> ' + floattostr(supply_previous2));
  SRwriteln('dayDemand_previous2 --> ' + floattostr(dayDemand_previous2));
  SRwriteln('------------------------');
  SRwriteln('seedres_previous3   --> ' + floattostr(seedres_previous3));
  SRwriteln('supply_previous3    --> ' + floattostr(supply_previous3));
  SRwriteln('dayDemand_previous3 --> ' + floattostr(dayDemand_previous3));
  SRwriteln('------------------------');
  SRwriteln('Ic_previous1        --> ' + floattostr(Ic_previous1));


  n := 0;
  total := 0;

  if (dayDemand <> 0) then
  begin
    resDiv := (max(0,seedres) + supply)/dayDemand;
    total := total + resDiv;
    n := n + 1;
  end;

  if (dayDemand_previous1 <> 0) then
  begin
    resDiv := (max(0,seedres_previous1) + supply_previous1)/dayDemand_previous1;
    total := total + resDiv;
    n := n + 1;
  end;

  if (dayDemand_previous2 <> 0) then
  begin
    resDiv := (max(0,seedres_previous2) + supply_previous2)/dayDemand_previous2;
    total := total + resDiv;
    n := n + 1;
  end;

  if (dayDemand_previous3 <> 0) then
  begin
    resDiv := (max(0,seedres_previous3) + supply_previous3)/dayDemand_previous3;
    total := total + resDiv;
    n := n + 1;
  end;

  if (n <> 0) then
  begin
    mean := total / n;
  end
  else
  begin
    mean := Ic_previous1;
  end;

  Ic := min(5,mean);

  if ((Ic = 0) and (seedres = 0) and (seedres_previous1 = 0) and (seedres_previous2 = 0)
     and (seedres_previous3 = 0)) then
  begin
    //Ic := -1;
    //testIc := -1;
    Ic := 0.001;
    testIc := 0.001;
  end
  else
  begin
    testIc := min(1 , sqrt(Ic) );
  end;

  SRwriteln('total               --> ' + floattostr(total));
  SRwriteln('n                   --> ' + floattostr(n));
  SRwriteln('mean                --> ' + floattostr(mean));
  SRwriteln('Ic                  --> ' + floattostr(Ic));
  SRwriteln('testIc              --> ' + floattostr(testIc));
end;


// ----------------------------------------------------------------------------
//  Procedure UpdateNbTillerCount_LE
//  --------------------------------
//
/// Incrémente le comptage du nombre de talle lorsque l'IC a franchit un seuil
///
/// Description : Incrémente le comptage du nombre de talle 'nbTiller' lorsque
/// l'IC a franchit un seuil 'ICThreshold'
///
/// equation :
/// Si (IC(i) >= ICThreshold)
///     nbTiller(i) = nbTiller(i-1) + 1 + nbExistingTiller
/// Sinon
///     nbTiller(i) = nbTiller(i-1)
///
// ---------------------------------------------------------------------------
(**
@param Ic (In) indice de competition
@param IcThreshold (In) seuil
@param nbTiller (InOut) nombre de talle
*)

Procedure UpdateNbTillerCount_LE(const Ic,IcThreshold,nbExistingTiller : Double; var nbTiller : Double);
begin
  if (IC >= ICThreshold) then
  begin
    SRwriteln('nbExistingTiller --> ' + FloatToStr(nbExistingTiller));
    SRwriteln('nbTiller (avant) --> ' + FloatToStr(nbTiller));
    nbTiller := nbTiller + 1 + nbExistingTiller;
    SRwriteln('nbTiller (apres) --> ' + FloatToStr(nbTiller));
  end;
end;


// ----------------------------------------------------------------------------
//  Procedure biomLeaf_LE
//  --------------------------------
//
/// Calcule la biomLeaf
///
/// Description : ??????????????????
///
/// equation :
///
// ---------------------------------------------------------------------------
(**
@param structLeaf (In) biomasse des feuilles
@param K_IntN (In) ????
@param stock (In) stock disponible en biomasse
@param assim (In) assimilat
@param supply (In) offre en biomasse
@param dayDemand (In) demande journaliere en biomasse
@param seedres (In) ??????????
@param biomLeaf (Out) ???????????????
*)
Procedure ComputeBalance_LE(const stock,supply,dayDemand,seedres,reservoirDispo : Double; var balance : Double);
begin
  balance := stock + supply - dayDemand + min(reservoirDispo, seedres - dayDemand);
end;

// ----------------------------------------------------------------------------
// Procedure Disp
// --------------
//
// Ecrit dans le fichier rapport la valeur passée en paramètre
//
// ----------------------------------------------------------------------------
(**
@param value (In) valeur à afficher
*)

procedure Disp(const value : double);
begin
	SRwriteln('Disp --> ' + floattostr(value));
end;

// ----------------------------------------------------------------------------
// Procedure ComputeInternodeVolume
// --------------------------------
//
// Compute the internode volume
//
// ----------------------------------------------------------------------------
(**
@param Length (In) length in cm
@param Diameter (In) diameter in cm
@param Volume (Out) volume in cm^3
*)

procedure ComputeInternodeVolume(const Length, Diameter : Double; var Volume : Double);
begin
  Volume := Length * Power(0.5 * Diameter, 2) * PI;

  SRwriteln('ComputeInternodeVolume --> Volume : ' + floattostr(Volume));

end;

// ----------------------------------------------------------------------------
//  Procedure TransitionToMatureState (extra)
//  -----------------------------------------
//
/// Fais passer l'entrenoeud à l'état mature
///
/// module 'extra'
///
// ---------------------------------------------------------------------------
(**
@param instance entité feuille portant la procedure
@param len (In) longueur de la feuille
@param predim (In) predimensionnement de la feuille
@param inOnMainstem (In) est-ce que la feuille sur le brin maître ou non ?
*)

Procedure TransitionToMatureState(var instance : TInstance; const len, predim, isOnMainstem : double);
begin
  SRwriteln('len          --> ' + floattostr(len));
  SRwriteln('predim       --> ' + floattostr(predim));
  SRwriteln('isOnMainstem --> ' + floattostr(isonmainstem));
  if (len >= predim) then
  begin
    (instance as TEntityInstance).SetCurrentState(4);
    SRwriteln('change en mature state');
  end;
end;

// ----------------------------------------------------------------------------
//  Procedure TransitionToLiguleState (extra)
//  ---------------------------------
//
/// Fais passer la feuille a l etat LIGULE lorsque len >= predim
///
/// Description : Fais passer la feuille a l etat LIGULE lorsque len >= predim.
/// Incremente l'attribut 'len' du grand-pere de ce module
///
/// module 'extra'
///
// ---------------------------------------------------------------------------
(**
@param instance entité feuille portant la procedure
@param len (In) longueur de la feuille
@param predim (In) predimensionnement de la feuille
@param inOnMainstem (In) est-ce que la feuille sur le brin maître ou non ?
*)

Procedure TransitionToLiguleState(var instance : TInstance; const len, predim, isOnMainstem : double);
var
  refInstance : TInstance;
  lig, biomass : double;
  date : TDateTime;

  titi,toto : double;

  refAttribute, refAttribute2, refAttribute3: TAttribute;
  sample,sample2,sample3 : TSample;
begin
	SRwriteln((instance as TEntityInstance).GetFather().GetName);
  SRwriteln('len    --> ' + floattostr(len));
  SRwriteln('predim --> ' + floattostr(predim));
  if (len >= predim) then // passage a l etat LIGULE
  begin

    // passage a l etat ligule
    (instance as TEntityInstance).SetCurrentState(20);
    SRWriteln('**** new ligulated leaf ****');

    date := (instance as TEntityInstance).GetNextDate();
    SRwriteln('date  --> ' + datetostr(date));

    sample := (instance as TEntityInstance).GetTAttribute('biomass').GetCurrentSample();
    (instance as TEntityInstance).GetTAttribute('oldCorrectedBiomass').SetSample(sample);
    SRwriteln('oldCorrectedBiomass --> ' + FloatToStr(sample.value));

    // incrementation de 1 de l attribut 'lig' du grand pere
    refInstance := (instance as TEntityInstance).GetFather();

    if ((refInstance as TEntityInstance).GetTAttribute('lig') <> NIL) then
    begin
      refAttribute := (refInstance as TEntityInstance).GetTAttribute('lig');
      lig := refAttribute.GetSample(date).value;
      lig := lig + 1;
      sample.date := date;
      sample.value := lig;
      refAttribute.SetSample(sample);

      SRwriteln('TransitionToLiguleState lig : ' + floattostr(sample.value));

      refAttribute2 := (refInstance as TEntityInstance).GetTAttribute('TT_lig');
      refAttribute3 := (refInstance as TEntityInstance).GetTAttribute('IH');

      if (isOnMainstem = 1) then
      begin
        if (refAttribute2 <> NIL) and (refAttribute3 <> NIL) then
        begin
          sample2.date := date;
          sample2.value := 0;
          refAttribute2.SetSample(sample2);

          titi := (refInstance as TEntityInstance).GetTAttribute('TT_lig').GetSample(date).value;

  			  SRwriteln('TT_lig : ' + floattostr(titi));

          sample3.date := date;
          sample3.value := lig;
          refAttribute3.SetSample(sample3);

          toto := (refInstance as TEntityInstance).GetTAttribute('IH').GetSample(date).value;

          SRwriteln('IH : ' + floattostr(toto));
        end
        else
        begin
          SRwriteln('Pb sur GetTAttribute(''TT_lig'') ou sur GetTAttribute(''IH'')');
        end;
      end;
    end;
  end;
end;


// ----------------------------------------------------------------------------
//  Procedure SumOfLastdemandInLeafRec (extra)
//  ----------------------------------
//
/// Calcule recursivement la somme de tous les attributs nommés 'lastdemand' de TOUTES les entites de type 'Leaf'
///
/// Description : Calcule récursivement la somme de tous les attributs nommés
/// 'lastdemand' pour toutes les entités de type 'Leaf' ayant un attribut nommé
/// 'lastdemand' a partir de l'entité placé en paramètre
///
/// module 'extra'
///
// ---------------------------------------------------------------------------
(**
@param instance entité à partir de laquelle la recherche est faite récursivement
@param total (Kout) somme des attributs 'lastdemand' des entité 'Leaf'
*)

Procedure SumOfLastdemandInLeafRec(var instance : TInstance; var total : Double);
var
  i,le : Integer;
  entityContribution : Double;
  currentInstance : TInstance;
begin
  total := 0;

  // ajout de la contribution pour l'entité 'instance'
  if ( ((instance as TEntityInstance).GetTAttribute('lastdemand') <> nil) and
       ((instance as TEntityInstance).GetCategory() = 'Leaf')
     ) then
  begin
    entityContribution := (instance as TEntityInstance).GetTAttribute('lastdemand').GetCurrentSample().value;
    SRwriteln('contribution de : ' + (instance as TEntityInstance).GetName() + ' --> ' + FloatToStr(entityContribution));
    total := total + entityContribution;
  end;

  // ajout (récursif) des demande de chaque entité
  le := (instance as TEntityInstance).LengthTInstanceList();
  for i:=0 to le-1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      entityContribution := 0;
      SumOfLastdemandInLeafRec(currentInstance,entityContribution);
      total := total + entityContribution;
    end;
  end;
end;


Procedure SumOfLastdemandInOrganRec(var instance : TInstance; var total : Double);
var
  i,le : Integer;
  entityContribution : Double;
  currentInstance : TInstance;
  currentEntityInstance : TEntityInstance;
begin
  total := 0;

  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      currentEntityInstance := (currentInstance as TEntityInstance);
      if ( (currentEntityInstance.GetTAttribute('lastdemand') <> nil) and
           ((currentEntityInstance.GetCategory() = 'Leaf') or
           (currentEntityInstance.GetCategory() = 'Internode') or
           (currentEntityInstance.GetCategory() = 'Peduncle'))
         ) then
      begin
        entityContribution := (currentEntityInstance as TEntityInstance).GetTAttribute('lastdemand').GetCurrentSample().value;
        SRwriteln('contribution de : ' + currentEntityInstance.GetName() + ' = ' + FloatToStr(entityContribution));
        total := total + entityContribution;
      end;
    end;
  end;

  // ajout de la contribution pour l'entité 'instance'
  {if ( ((instance as TEntityInstance).GetTAttribute('lastdemand') <> nil) and
       (((instance as TEntityInstance).GetCategory() = 'Leaf') or
       ((instance as TEntityInstance).GetCategory() = 'Internode') or
       ((instance as TEntityInstance).GetCategory() = 'Peduncle'))
     ) then
  begin
    entityContribution := (instance as TEntityInstance).GetTAttribute('lastdemand').GetCurrentSample().value;
    SRwriteln('contribution de : ' + instance.GetName() + ' = ' + FloatToStr(entityContribution));
    total := total + entityContribution;
  end;

  // ajout (récursif) des demande de chaque entité
  le := (instance as TEntityInstance).LengthTInstanceList();
  for i:=0 to le-1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      entityContribution := 0;
      SumOfLastdemandInOrganRec(currentInstance,entityContribution);
      total := total + entityContribution;
    end;
  end;}
  SRwriteln('total : ' + FloatToStr(total));
end;

// ----------------------------------------------------------------------------
//  Procedure EnableNbTillerCount_LE (extra)
//  ----------------------------------
//
/// active le module 'UpdateNbTiller_LE' lorsque le plastochron vaut 3
///
/// Description : active le module 'UpdateNbTiller' lorsque le plastochron
/// 'plasto' vaut 3
///
/// module 'extra'
///
// ---------------------------------------------------------------------------
(**
@param instance entité à partir de laquelle la recherche est faite récursivement
@param plasto (kIn) plastochron
*)

// TODO -u Model : doit etre supprime par la suite

Procedure EnableNbTillerCount_LE(var instance : TInstance; const stadePheno, nbLeafEnablingTillering : Double);
begin
  SRwriteln('stadePheno              --> ' + FloatToStr(stadePheno));
  SRwriteln('nbLeafEnablingTillering --> ' + FloatToStr(nbLeafEnablingTillering));
  if (stadePheno = (nbLeafEnablingTillering - 1)) then
  begin
    SRwriteln('activation countNbTiller');
    SRwriteln('activation updateNbTillerCount');
    (instance as TEntityInstance).GetTInstance('countNbTiller_2').SetActiveState(2);
    (instance as TEntityInstance).GetTInstance('updateNbTillerCount_2').SetActiveState(2); // pour morphogenesis
    (instance as TEntityInstance).GetTInstance('countNbTiller_9').SetActiveState(9);
    (instance as TEntityInstance).GetTInstance('updateNbTillerCount_9').SetActiveState(9); // pour ELONG
  end;

  if (stadePheno = nbLeafEnablingTillering) then
  begin
    SRwriteln('activation createTillers');
    SRwriteln('activation countNbTillerWith4Leaves');
    SRwriteln('activation addOne');
    SRwriteln('activation minTAEandnbTiller');
    (instance as TEntityInstance).GetTInstance('createTillers_2').SetActiveState(2); // pour morphogenesis
    (instance as TEntityInstance).GetTInstance('countNbTillerWith4Leaves_2').SetActiveState(2);
    (instance as TEntityInstance).GetTInstance('addOne_2').SetActiveState(2);
    (instance as TEntityInstance).GetTInstance('minTAEandnbTiller_2').SetActiveState(2);
    (instance as TEntityInstance).GetTInstance('createTillers_9').SetActiveState(9); // pour ELONG
    (instance as TEntityInstance).GetTInstance('countNbTillerWith4Leaves_9').SetActiveState(9);
    (instance as TEntityInstance).GetTInstance('addOne_9').SetActiveState(9);
    (instance as TEntityInstance).GetTInstance('minTAEandnbTiller_9').SetActiveState(9);
  end;
end;


// ----------------------------------------------------------------------------
//  Procedure CountNbTiller_LE (extra)
//  ----------------------------------
//
/// Compte le nombre d'entité 'Tiller'
///
/// Description : Compte le nombre d'entité 'Tiller' a partir de l'entité
/// placé en paramètre. Si l'entité est de type 'Tiller', elle est comptée
/// également
///
/// module 'extra'
///
// ---------------------------------------------------------------------------
(**
@param instance entité à partir de laquelle la recherche est faite récursivement
@param total (Kout) nombre d'entité de type 'Tiller' dans l'instance
*)

Procedure CountNbTiller_LE(var instance : TInstance; var total : Double);
var
  i,le : Integer;
  entityContribution : Double;
  currentInstance : TInstance;
begin
  total := 0;

  // ajout de la contribution pour l'entité 'instance'
  if ((instance as TEntityInstance).GetCategory() = 'Tiller') then
  begin
    total := total + 1;
  end;

  // ajout (récursif) des demande de chaque entité
  le := (instance as TEntityInstance).LengthTInstanceList();
  for i:=0 to le-1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      entityContribution := 0;
      CountNbTiller_LE(currentInstance,entityContribution);
      total := total + entityContribution;
    end;
  end;
end;

// ----------------------------------------------------------------------------
//  Procedure createTillers_LE (extra)
//  ----------------------------------
//
/// Creer 'nbTiller' Talle sur l'entité portant ce module
///
/// Description : ce module crée 'nbTiller' talles sur l'entité portant ce
/// module a chaque franchissement du plastochron et que Ic >Ict.
///
/// De plus a chaque franchissement de plastochron, nbTiller est  reinitialiase
/// a 0
///
/// Dans l'ordre d'execution des modules : S'ils existent des talles,
/// la nouvelle talle est créée aprés les talles existantes. Sinon, la talle est
/// créée à la place définit par le paramètre 'exeOrder'.
///
/// module 'extra'
///
// ---------------------------------------------------------------------------
(**
@param instance entité sur laquelle on crée des talles
@param boolCrossedPlasto (kIn) indique si franchissement de plasto
@param Ic (kIn) Indice de compétition
@param Ict (kIn) seuil sur l'indice de compétition a partir duquel il y a creation de talles
@param exeOrder (kIn) ordre d execution de la talle
@param nbTiller (kInOut) nombre de talles a creer
*)
Procedure CreateTillers_LE(var instance : TInstance; const boolCrossedPlasto,Ic,Ict,exeOrder,P,resp_Ict, thresINER, slopeINER, leafStockMax : double; var nbTiller : double);
var
  i, tillerExeOrder : integer;
  newTiller : TEntityInstance;
  date : TDateTime;
  name : String;
begin
  if ((boolCrossedPlasto>=0) and (nbTiller >= 1)) then
  begin
    if (Ic>Ict*((P*resp_Ict)+1)) then
    begin
      for i:=1 to Trunc(nbTiller) do
      begin
        // creation de la talle
        // --------------------
        name := 'T_' + IntToStr(FindGreatestSuffixforASpecifiedCategory(instance as TEntityInstance,'Tiller')+1);
        SRwriteln('Module Meristem ****  creation de la talle : ' + name + '  ****');
        newTiller := ImportTiller_LE(name, thresINER, slopeINER, leafStockMax);
        // determination de l'ordre d'execution de newTiller :
        // -------------------------------------------------
        if (HasAnEntityWithASpecifiedCategory(instance as TEntityInstance,'Tiller')=False) then
        begin // cas particulier ou c'est la premiere talle a creer
          tillerExeOrder := FindFirstEmptyPlaceAfterASpecifiedExeOrder(instance as TEntityInstance,Trunc(exeOrder));
          //tillerExeOrder := FindFirstEmptyPlaceAfterASpecifiedCategory(instance as TEntityInstance,'Leaf');
          newTiller.SetExeOrder(tillerExeOrder);
        end
        else
        begin
          tillerExeOrder := FindFirstEmptyPlaceAfterASpecifiedCategory(instance as TEntityInstance,'Tiller');
          //tillerExeOrder := FindFirstEmptyPlaceAfterASpecifiedCategory(instance as TEntityInstance,'Leaf');
          newTiller.SetExeOrder(tillerExeOrder);
        end;

        // initialisation des attributs temporels de la talle
        // --------------------------------------------------
        date := (instance as TEntityInstance).GetNextDate();

        //newTiller.SetActiveState(2);
        newTiller.SetStartDate(date);
        newTiller.InitCreationDate(date);
        newTiller.InitNextDate();
        (instance as TEntityInstance).AddTInstance(newTiller);

        newTiller.ExternalConnect(['predimOfNewLeaf',
                                   'DD',
                                   'EDD',
                					         'testIc',
                                   'fcstr',
                                   'n',
                                   'SLA',
                                   'stock',
                                   'Tair',
                                   'plasto_delay',
                                   'thresLER',
                                   'slopeLER',
                                   'FTSW',
                                   'boolCrossedPlasto',
                                   'lig',
                                   'P',
                                   'assim',
                                   'PAI']);
        (instance as TEntityInstance).SortTInstance();
      end;
    end
    else
    begin
      SRwriteln('Ic>Ict*((P*resp_Ict)+1)');
    end;

    // re-initialisation  de nbTiller
    // ------------------------------
    nbTiller := 0;
  end;

end;

Procedure CreateTillersPhytomer_LE(var instance : TInstance; const boolCrossedPlasto,Ic,Ict,exeOrder,P,resp_Ict, thresINER, slopeINER, leafStockMax : double; var nbTiller : double);
var
  i, tillerExeOrder : integer;
  newTiller : TEntityInstance;
  date : TDateTime;
  name : String;
begin
  if ((boolCrossedPlasto>=0) and (nbTiller >= 1)) then
  begin
    if (Ic>Ict*((P*resp_Ict)+1)) then
    begin
      for i:=1 to Trunc(nbTiller) do
      begin
        // creation de la talle
        // --------------------
        name := 'T_' + IntToStr(FindGreatestSuffixforASpecifiedCategory(instance as TEntityInstance,'Tiller')+1);
        SRwriteln('nbTiller : ' + FloatToStr(nbTiller));
        SRwriteln('Module Meristem ****  creation de la talle : ' + name + '  ****');
        newTiller := ImportTillerPhytomer_LE(name, thresINER, slopeINER, leafStockMax);
        // determination de l'ordre d'execution de newTiller :
        // -------------------------------------------------
        if (HasAnEntityWithASpecifiedCategory(instance as TEntityInstance,'Tiller')=False) then
        begin // cas particulier ou c'est la premiere talle a creer
          tillerExeOrder := FindFirstEmptyPlaceAfterASpecifiedExeOrder(instance as TEntityInstance,Trunc(exeOrder));
          //tillerExeOrder := FindFirstEmptyPlaceAfterASpecifiedCategory(instance as TEntityInstance,'Leaf');
          newTiller.SetExeOrder(tillerExeOrder);
        end
        else
        begin
          tillerExeOrder := FindFirstEmptyPlaceAfterASpecifiedCategory(instance as TEntityInstance,'Tiller');
          //tillerExeOrder := FindFirstEmptyPlaceAfterASpecifiedCategory(instance as TEntityInstance,'Leaf');
          newTiller.SetExeOrder(tillerExeOrder);
        end;

        // initialisation des attributs temporels de la talle
        // --------------------------------------------------
        date := (instance as TEntityInstance).GetNextDate();

        //newTiller.SetActiveState(2);
        newTiller.SetStartDate(date);
        newTiller.InitCreationDate(date);
        newTiller.InitNextDate();

        (instance as TEntityInstance).AddTInstance(newTiller);

        newTiller.ExternalConnect(['predimOfNewLeaf',
                                   'DD',
                                   'EDD',
                					         'testIc',
                                   'fcstr',
                                   'n',
                                   'SLA',
                                   'stock',
                                   'Tair',
                                   'plasto_delay',
                                   'thresLER',
                                   'slopeLER',
                                   'FTSW',
                                   'boolCrossedPlasto',
                                   'lig',
                                   'P',
                                   'assim',
                                   'PAI']);
        (instance as TEntityInstance).SortTInstance();
      end;
    end
    else
    begin
      SRwriteln('Ic  --> ' + FloatToStr(Ic));
      SRwriteln('Ict --> ' + FloatToStr(Ict));
      SRwriteln('Ic < Ict');
    end;

    // re-initialisation  de nbTiller
    // ------------------------------
    nbTiller := 0;
  end;

end;


// ----------------------------------------------------------------------------
//  Procedure ChangeOrganExeOrder_LE (extra)
//  ----------------------------------
//
/// Change l'ordre d execution des organes
///
/// Description : change l'ordre d execution des organes.
/// Dans le modele Matlab initial : pour i = 1, il avait d abord activation
/// de la feuille L1 puis de l'internoeud et racine; pour i > 1 c est
/// l inverse (i.e. internoeud et racine puis L1)
/// Ici, ce module a pour role de changer l ordre d execution des organes
/// pre-cités pour etre conforme au modele Matlab.
///
/// Ce module est desactive apres son premier emploi (ie activeState = 100)
///
/// module 'extra'
///
// ---------------------------------------------------------------------------
(**
@param instance entité portant le module
*)
Procedure ChangeOrganExeOrder_LE(var instance : TInstance);
begin
  (instance as TEntityInstance).GetTInstance('computeSumOfLeafDemand').SetExeOrder(1900);
  //(instance as TEntityInstance).GetTInstance('Internode').SetExeOrder(1910);
  (instance as TEntityInstance).GetTInstance('Root').SetExeOrder(1920);

  (instance as TEntityInstance).GetTInstance('changeOrganExeOrder').SetActiveState(100);

  (instance as TEntityInstance).SortTInstance();
end;

// ----------------------------------------------------------------------------
//  Procedure OA_StopInterceptionComputation_LE (extra)
// ----------------------------------------------------
//
//  dans le cas du couplage avec OpenAlea, il faut pouvoir stoper le calcul
//  dans la variable interc car elle est fournie via caribu. on change donc
//  l'ActiveState de la procedure computeInterc afin qu'elle ne soit plus
//  appelée
///
/// module 'extra'
///
// ---------------------------------------------------------------------------
(**
@param instance entité portant le module
*)
Procedure OA_StopInterceptionComputation_LE(var instance : TInstance);
begin
  (instance as TEntityInstance).GetTInstance('computeInterc').SetActiveState(100);
  (instance as TEntityInstance).GetTInstance('OA_StopInterceptionComputation_LE').SetActiveState(100);
  (instance as TEntityInstance).SortTInstance();
end;

// ----------------------------------------------------------------------------
//  KillOldestLeaf (extra)
//  ----------------------
//
/// detruit le feuille la plus vieille et realloue une partie de la biomasse
///
/// Description : ce module detruit la plus vieille feuille si le stock est <0.
/// Une partie de la biomasse (precisement, realocationCoeff * biomass de la feuille detruite)
/// est realoué au stock de la plante. L attribut 'senesc_dw' est augmente
/// du reste de biomasse non réaloué (soit (1-realocationCoeff)*biomass).
/// Le compteur de feuille est augmenté de 1
///
/// equation :
///
/// module 'extra'
///
// ---------------------------------------------------------------------------
(**
@param instance entité portant le module
@param realocationCoeff (in) pourcentage de biomasse a ré-aloué
@param stock (inOut) stock de biomasse de la plante
@param senesc_dw (inOut) ?????????????????????
@param deadleafNb (inOut) nombre de feuilles mortes
*)

Procedure KillOldestLeaf_LE(var instance : TInstance ; const realocationCoeff : Double; var deficit, stock, senesc_dw, deadleafNb, computedReallocBiomass : Double);
var
   oldestCreationDate, currentCreationDate : TDateTime;
   currentInstance, currentInstanceOnTiller : TInstance;
   refOldestLeaf : TInstance;
   refFather : TInstance;
   refLeafState2 : TInstance;
   i,le : Integer;
   i2,le2 : Integer;
   leafBiomass : Double;
   date : TDateTime;
   nbLeaf : Integer; // nombre de feuilles presentes sur le brin maitre
   state4 : Integer; // nombre de feuilles presentent sur le brin maitre, mais en state = 4 ou 5
   existLeafstate4_5 : Boolean;
   currentState : Integer;
   stateOldestLeaf : Integer;
Begin
  // recherche de la plus vieille feuille
  // ------------------------------------
  refFather := instance;
  oldestCreationDate := MAX_DATE;
  nbLeaf := 0;
  refOldestLeaf := nil;
  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      // c'est une feuille...
      if((currentInstance as TEntityInstance).GetCategory()='Leaf') then
      begin
        nbLeaf := nbLeaf + 1;
        currentCreationDate := currentInstance.GetCreationDate();
        currentState := (currentInstance as TEntityInstance).GetCurrentState();
        SRwriteln('Feuille : ' + currentInstance.GetName() + ' date de creation : ' + DateTimeToStr(currentCreationDate));
        SRwriteln('Feuille : ' + currentInstance.GetName() + ' currentState : ' + IntToStr(currentState));
        if ((currentCreationDate < oldestCreationDate) and (currentState <> 2000)) then
        begin
          refOldestLeaf := (instance as TEntityInstance).GetTInstance(i);
          refFather := instance;
          oldestCreationDate := currentCreationDate;
        end;
      end;
      // c'est une talle...
      if((currentInstance as TEntityInstance).GetCategory()='Tiller') then
      begin
        le2 := (currentInstance as TEntityInstance).LengthTInstanceList();
        for i2:=0 to le2-1 do
        begin
          currentInstanceOnTiller := (currentInstance as TEntityInstance).GetTInstance(i2);
          if (currentInstanceOnTiller is TEntityInstance) then
          begin
            if((currentInstanceOnTiller as TEntityInstance).GetCategory()='Leaf') then
            begin
              currentCreationDate := currentInstanceOnTiller.GetCreationDate();
              currentState := (currentInstanceOnTiller as TEntityInstance).GetCurrentState();
              SRwriteln('Feuille : ' + currentInstanceOnTiller.GetName() + ' date de creation : ' + DateTimeToStr(currentCreationDate));
              SRwriteln('Feuille : ' + currentInstanceOnTiller.GetName() + ' currentState : ' + IntToStr(currentState));
              if ((currentCreationDate < oldestCreationDate) and (currentState <> 2000)) then
              begin
                refOldestLeaf := (currentInstance as TEntityInstance).GetTInstance(i2);
                refFather := currentInstance;
                oldestCreationDate := currentCreationDate;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
  // recuperation de la biomasse de la feuille
  // -----------------------------------------
  date := (instance as TEntityInstance).GetNextDate();
  stateOldestLeaf := (refOldestLeaf as TEntityInstance).GetCurrentState();
  if ((stateOldestLeaf = 4) or (stateOldestLeaf = 5)) then
  begin
    leafBiomass := (refOldestLeaf as TEntityInstance).GetTAttribute('correctedLeafBiomass').GetSample(date).value;
  end
  else
  begin
    leafBiomass := (refOldestLeaf as TEntityInstance).GetTAttribute('biomass').GetSample(date).value;
  end;

  // destruction de la feuille
  // -------------------------
  SRwriteln('Destruction de la feuille : ' + refOldestLeaf.GetName());
  (refFather as TEntityInstance).RemoveTInstance(refOldestLeaf);

  // re alocation de la biomasse
  // ---------------------------

  SRwriteln('-----------------------------');
  SRwriteln('Ancienne valeur du stock    --> ' + FloatToStr(stock));
  SRwriteln('Deficit                     --> ' + FloatToStr(deficit));
  SRwriteln('Biomasse de la feuille tuee --> ' + FloatToStr(leafBiomass));
  SRwriteln('On recupere                 --> ' + FloatToStr(realocationCoeff * leafBiomass));

  computedReallocBiomass := realocationCoeff * leafBiomass;

  stock := max(0, computedReallocBiomass + deficit);
  deficit := min(0, computedReallocBiomass + deficit);
  senesc_dw := senesc_dw + leafBiomass - computedReallocBiomass;
  deadleafNb := deadleafNb + 1;

  SRwriteln('-----------------------------');
  SRwriteln('Nouvelle valeur du stock   --> ' + FloatToStr(stock));
  SRwriteln('Nouvelle valeur du deficit --> ' + FloatToStr(deficit));
  SRwriteln('computedReallocBiomass     --> ' + FloatToStr(computedReallocBiomass));

  // cas particulier ou la plante est morte
  // (cad plus de feuille sur le brin maitre)
  // ----------------------------------------
  if (nbLeaf = 1) then // il ne restait qu une seule feuille avant destruction de celle-ci
  begin
    SRWriteln('PLANT IS DEAD !!!!!!!!!!');
    (instance as TEntityInstance).SetCurrentState(1000); // la plante passe a l etat morte
  end;

  //nbLeaf := 0;
  existLeafstate4_5 := false;

  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      // c'est une feuille...
      if((currentInstance as TEntityInstance).GetCategory()='Leaf') then
      begin
        //nbLeaf := nbLeaf + 1;
        refLeafState2:= (instance as TEntityInstance).GetTInstance(i);
        state4 := (refLeafState2 as TEntityInstance).GetCurrentState();
        if (state4 = 4) or (state4 = 5) then
        begin
          existLeafstate4_5 := true;
        end;
      end;
    end;
  end;
  //if (not(existLeafstate4_5)) and (nbLeaf = 1) then
  if (not(existLeafstate4_5)) then
  begin
    SRWriteln('PLANT IS DEAD !!!!!!!!!! By another method');
    (instance as TEntityInstance).SetCurrentState(1000); // la plante passe a l etat morte
  end;
end;

// ----------------------------------------------------------------------------
//  Procedure CountNbLeaf_LE (extra)
//  ----------------------------------
//
/// Compte le nombre d'entité 'Leaf'
///
/// Description : Compte le nombre d'entité 'Leaf' a partir de l'entité
/// placé en paramètre. Si l'entité est de type 'Leaf', elle est comptée
/// également
///
/// module 'extra'
///
// ---------------------------------------------------------------------------
(**
@param instance entité à partir de laquelle la recherche est faite récursivement
@param total (Kout) nombre d'entité de type 'Leaf' dans l'instance
*)

Procedure CountNbLeaf_LE(var instance : TInstance; var total : Double);
var
  i1, le1, i2, le2, leafState : Integer;
  currentInstance1, currentInstance2 : TInstance;
begin
  total := 0;
  le1 := (instance as TEntityInstance).LengthTInstanceList();
  for i1 := 0 to le1 - 1 do
  begin
    currentInstance1 := (instance as TEntityInstance).GetTInstance(i1);
    if (currentInstance1 is TEntityInstance) then
    begin
      if ((currentInstance1 as TEntityInstance).GetCategory() = 'Leaf') then
      begin
        leafState := (currentInstance1 as TEntityInstance).GetCurrentState();
        if (leafState <> 2000) then
        begin
          total := total + 1;
        end;
      end
      else if ((currentInstance1 as TEntityInstance).GetCategory() = 'Tiller') then
      begin
        le2 := (currentInstance1 as TEntityInstance).LengthTInstanceList();
        for i2 := 0 to le2 - 1 do
        begin
          currentInstance2 := (currentInstance1 as TEntityInstance).GetTInstance(i2);
          if (currentInstance2 is TEntityInstance) then
          begin
            if ((currentInstance2 as TEntityInstance).GetCategory() = 'Leaf') then
            begin
              leafState := (currentInstance2 as TEntityInstance).GetCurrentState();
              if (leafState <> 2000) then
              begin
                total := total + 1;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
  SRwriteln('NbLeaf : ' + FloatToStr(total));
end;

// ----------------------------------------------------------------------------
//  CountOfNbTillerWithMore4Leaves_LE (extra)
//  ----------------------------------
//
/// compte le nombre talle ayant construite au moins 4 feuilles
///
/// Description : compte le nombre de talle ayant construite au moins 4 feuilles,
/// Pour le comptage, les talles doivent etre des entités de categorie 'Tiller'
/// et doivent comporter un attribut 'nbLeaf' qui comptabilise le nombre de
/// feuilles créés depuis le debut de la simulation.
///
/// module 'extra'
///
// ---------------------------------------------------------------------------
(**
@param instance entité à partir de laquelle la recherche est faite
@param nbTillerWithMore4Leaves (kOut) nombre de talles ayant au moins 4 feuilles
*)


Procedure CountOfNbTillerWithMore4Leaves_LE(var instance : TInstance; var nbTillerWithMore4Leaves : Double);
var
   i,le : Integer;
   currentInstance : TInstance;
   category : String;
   leafNb : Double;
begin
  // initialisation du nombre de talle ayant plus de 4 feuilles
  nbTillerWithMore4Leaves := 0;

  // recherche des entités 'Tiller' ayant l'attribut 'nbLeaf' >= 4
  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to le-1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      category := (currentInstance as TEntityInstance).GetCategory();
      if (category = 'Tiller') then
      begin
        leafNb := (currentInstance as TEntityInstance).GetTAttribute('leafNb').GetCurrentSample().value;
        if(leafNb>=3) then
        begin
          nbTillerWithMore4Leaves := nbTillerWithMore4Leaves + 1;
        end;
      end;
    end;
  end;
end;

Procedure CountOfNbTillerWithMoreNbLeafEnablingTilleringLeaves_LE(var instance : TInstance; const nbLeafEnablingTillering : Double; var nbTillerWithMore4Leaves : Double);
var
   i,le : Integer;
   currentInstance : TInstance;
   category : String;
   leafNb : Double;
begin
  // initialisation du nombre de talle ayant plus de 4 feuilles
  nbTillerWithMore4Leaves := 0;

  // recherche des entités 'Tiller' ayant l'attribut 'nbLeaf' >= 4
  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to le-1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      category := (currentInstance as TEntityInstance).GetCategory();
      if (category = 'Tiller') then
      begin
        leafNb := (currentInstance as TEntityInstance).GetTAttribute('activeLeavesNb').GetCurrentSample().value;
        SRwriteln('leafNb --> ' + FloatToStr(leafNb));
        SRwriteln('state --> ' + IntToStr((currentInstance as TEntityInstance).GetCurrentState()));
        if(leafNb >= (nbLeafEnablingTillering - 1)) then
        begin
          nbTillerWithMore4Leaves := nbTillerWithMore4Leaves + 1;
        end;
      end;
    end;
  end;
  SRwriteln('nbTillerWithMore4Leaves --> ' + FloatToStr(nbTillerWithMore4Leaves));
end;

procedure TillerSequenceToState_LE(var instance : TInstance; const n, nbLeafState, coeffStateLag, isNewPlasto, newState : Double; phenoStageName : String; var addedLag : Double);
var
  stage : Double;
  i : Integer;
  le : Integer;
  category : String;
  currentState : Integer;
  currentInstance : TInstance;
  entityInstance : TEntityInstance;
  phenoStageAtStateAttribute : TAttribute;
  currentTT : TAttribute;
  TTAtPI : TAttribute;
  sample : TSample;
  ttSample : TSample;
  ttAtPISample : TSample;
  date : TDateTime;
  leafNb : Double;
begin
  stage := (nbLeafState + coeffStateLag) - n;

  SRwriteln('stage : ' + floattostr(stage));
  SRwriteln('coeffStateLag : ' + floattostr(coeffStateLag));
  SRwriteln('isNewPlasto : ' + floattostr(isNewPlasto));

  if (stage < coeffStateLag) and (stage >= 0) and (isNewPlasto > 0) then // les conditions sont réalisées pour passer les talles à pi
  begin
    le := (instance as TEntityInstance).LengthTInstanceList();
    for i := 0 to le - 1 do
    begin
      currentInstance := (instance as TEntityInstance).GetTInstance(i);
      if (currentInstance is TEntityInstance) then
      begin
        category := (currentInstance as TEntityInstance).GetCategory();
        currentState := (currentInstance as TEntityInstance).GetCurrentState();
        {srwriteln('category : ' + category);
        srwriteln('active state : ' + floattostr(currentState));
        srwriteln('name : ' + (currentInstance as TEntityInstance).GetName());}
        if ((category = 'Tiller') and (currentState = 5)) then
        begin
          leafNb := (currentInstance as TEntityInstance).GetTAttribute('leafNb').GetCurrentSample().value;
          if (leafNb >= 3) then
          begin
            SRwriteln('la talle ' + (currentInstance as TEntityInstance).GetName + ' passe a l etat 4');
            (currentInstance as TEntityInstance).SetCurrentState(Trunc(newState));
            phenoStageAtStateAttribute := (currentInstance as TEntityInstance).GetTAttribute(phenoStageName);
            date := (currentInstance as TEntityInstance).GetNextDate();
            sample := phenoStageAtStateAttribute.GetSample(date);
            sample.date := date;
            sample.value := n;
            phenoStageAtStateAttribute.SetSample(sample);
            entityInstance := (instance as TEntityInstance);
            //currentTT := entityInstance.GetTAttribute('n');
            //ttSample := (currentTT as TAttributeTableOut).GetCurrentSample();
            //TTAtPI := (currentInstance as TEntityInstance).GetTAttribute('phenoStageAtPreFlo');
            //ttAtPISample := TTAtPI.GetCurrentSample();
            //ttAtPISample.value := ttSample.value;
            //ttAtPISample := sample;
            //TTAtPI.SetSample(ttAtPISample);
          end;
        end;
      end;
    end;
  end;
end;

// -----------------------------------------------------------------------------
// TillerSequenceToPI_LE (extra)
// -----------------------------
//
// La procedure fait passer les talles de l'état 3 à l'état 4 par ordre d'apparition
// seulement si phenostage > nb_leaf_pi et phenostage <= nb_leaf_pi + coeff_PI_lag et
// boolCrossedPlasto > 0
//
// module 'extra'
//
// -----------------------------------------------------------------------------

procedure TillerSequenceToPI_LE(var instance : TInstance; const n, nbLeafPI, coeffPILag, isNewPlasto : Double; var addedLag : Double);
begin
  TillerSequenceToState_LE(instance, n, nbLeafPI, coeffPILag, isNewPlasto, 4, 'phenoStageAtPI', addedLag);
end;

// -----------------------------------------------------------------------------
// TillerSequenceToFlo_LE (extra)
// -----------------------------
//
// La procedure fait passer les talles de l'état 3 à l'état 4 par ordre d'apparition
// seulement si phenostage > nb_leaf_pi et phenostage <= nb_leaf_pi + coeff_PI_lag et
// boolCrossedPlasto > 0
//
// module 'extra'
//
// -----------------------------------------------------------------------------

procedure TillerSequenceToFlo_LE(var instance : TInstance; const n, nbLeafFlo, coeffFloLag, isNewPlasto : Double; var addedLag : Double);
begin
  TillerSequenceToState_LE(instance, n, nbLeafFlo, coeffFloLag, isNewPlasto, 5, 'phenoStageAtFlo', addedLag);
end;


// ----------------------------------------------------------------------------
//  CountAndTagOfNbTillerWithMore4Leaves_LE (extra)
//  ---------------------------------------
//
/// compte le nombre talle ayant construite au moins 4 feuilles
///
/// Description : compte le nombre de talle ayant construite au moins 4 feuilles,
/// Pour le comptage, les talles doivent etre des entités de categorie 'Tiller'
/// et doivent comporter un attribut 'nbLeaf' qui comptabilise le nombre de
/// feuilles créés depuis le debut de la simulation.
/// Active le passe de la talle de l'état 2 à l'état 3 (talle potentielle fertile)
///
/// module 'extra'
///
// ---------------------------------------------------------------------------
(**
@param instance entité à partir de laquelle la recherche est faite
@param nbTillerFertile (kOut) nombre de talles fertiles
*)

Procedure CountAndTagOfNbTillerWithMore4Leaves_LE(var instance : TInstance; var nbTillerFertile : Double);
var
   i,le : Integer;
   currentInstance : TInstance;
   category : String;
   leafNb : Double;
begin
  // initialisation du nombre de talle ayant plus de 4 feuilles
  nbTillerFertile := 0;

  // recherche des entités 'Tiller' ayant l'attribut 'nbLeaf' >= 4
  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to le-1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      category := (currentInstance as TEntityInstance).GetCategory();
      if (category = 'Tiller') then
      begin
        leafNb := (currentInstance as TEntityInstance).GetTAttribute('leafNb').GetCurrentSample().value;
        //showmessage('leafNb : ' + floattostr(leafNb));
        if(leafNb>=3) then
        begin
          nbTillerFertile := nbTillerFertile + 1;
          (currentInstance as TEntityInstance).SetCurrentState(3);

          //SRwriteln('la talle ' + (currentInstance as TEntityInstance).GetName() + ' passe à 3');

        end;
      end;
    end;
  end;
  // on passe cette procedure en active state = 200 comme ça elle n'est appelée qu'une seule fois
  (instance as TEntityInstance).GetTInstance('countAndTagOfNbTillerWithMore4Leaves').SetActiveState(200);
end;


// ----------------------------------------------------------------------------
//  ComputePHT_LE (extra)
//  -------------------------------
//
/// calcule le PHT et SLALFEL
///
/// Description : ce module calcule le PHT
/// et le SLALFEL de la derniere feuille ligulee. Si la plante ne contient
/// qu'une seule feuille, le calcule de PHT et SLALFEL est realisee en fonction
/// des attributs de cette feuille (que cette feuille soit ligulée ou non).
/// Si la plante contient zero feuille ou bien plusieurs feuilles mais qu aucune
/// ne soit ligulée, PHT et SLALFEL est inchangé
///
/// module 'extra'
///
// ---------------------------------------------------------------------------
(**
@param instance entité à partir de laquelle la recherche est faite
@param G_L (In) ??????????????????
@param reserveRatio (In) ????????????????????
@param nbLigulatedLeaf (Out) nombre de feuille ligulée sur le brin maitre
@param PHT (Out) ??????????????
@param SLALFEL (Out) ?????????????????
@param AreaLFEL (Out) ????????????????
@param DWLEFL (Out) ????????????????
*)
Procedure ComputePHT_LE(var instance : TInstance; const G_L, LL_BL, stockPlant, stockInternodePlant, structLeaf : double ;var PHT, SLALFEL, AreaLFEL, DWLFEL : double);
var
   i,le, nbLeaf: Integer;
   currentInstance : TInstance;
   category : String;
   state, stateLeaf : Integer;
   youngestCreationDate, currentCreationDate : TDateTime;
   youngestLigulatedLeaf : TInstance;
   date : TDateTime;
   leafLength, sumOfInternodeLength, internodeLength, peduncleLength : Double;
   tmp : Double;
begin
  // initialisation
  // ---------------
  nbLeaf := 0;
  youngestCreationDate := MIN_DATE;
  youngestLigulatedLeaf := NIL;
  sumOfInternodeLength := 0;
  peduncleLength := 0;
  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to le-1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      category := (currentInstance as TEntityInstance).GetCategory();
      if (category = 'Leaf') then
      begin
        nbLeaf := nbLeaf + 1;
        if (nbLeaf = 1) then // CP si la plante ne contient qu une seule feuille
        begin
          youngestLigulatedLeaf := currentInstance;
        end;
        stateLeaf := (currentInstance as TEntityInstance).GetCurrentState();
        currentCreationDate:= (currentInstance as TEntityInstance).GetCreationDate();
        if((stateLeaf = 4) or (stateLeaf = 5)) then // feuille ligulee
        begin
          // verifie si la feuille en cours est la plus vielle
          if (currentCreationDate > youngestCreationDate) then
          begin
            youngestCreationDate := currentCreationDate;
            youngestLigulatedLeaf := currentInstance;
          end;
        end;
      end;
      if (category = 'Internode') then
      begin
        if ((currentInstance as TEntityInstance).GetCurrentState() <> 2000) then
        begin
          internodeLength := ((currentInstance as TEntityInstance).GetTAttribute('LIN') as TAttributeTableOut).GetCurrentSample().value;
          sumOfInternodeLength := sumOfInternodeLength + internodeLength;
        end;
      end;
      if (category = 'Peduncle') then
      begin
        peduncleLength := (currentInstance as TEntityInstance).GetTAttribute('LIN').GetCurrentSample().value;
      end;
    end;
  end;

  // calcul de PHT et SLALFEL
  // ------------------------

  // cas : la plante contient au moins une feuille ligulée
  // ou la plante ne contient qu une seule feuille
  if (youngestLigulatedLeaf <> NIL) then
  begin
    date := (instance as TEntityInstance).GetNextDate();
    leafLength := (youngestLigulatedLeaf as TEntityInstance).GetTAttribute('len').GetSample(date).value;
    AreaLFEL := (youngestLigulatedLeaf as TEntityInstance).GetTAttribute('bladeArea').GetSample(date).value;
    DWLFEL := (youngestLigulatedLeaf as TEntityInstance).GetTAttribute('biomass').GetSample(date).value;
    SLALFEL := AreaLFEL / DWLFEL * G_L * (1 + (stockPlant - stockInternodePlant) / structLeaf);
    SRwriteln('youngestLigulatedLeaf name --> ' + youngestLigulatedLeaf.GetName());
    SRwriteln('G_L                        --> ' + FloatToStr(G_L));
    SRwriteln('LL_BL                      --> ' + FloatToStr(LL_BL));
    SRwriteln('stockPlant                 --> ' + FloatToStr(stockPlant));
    SRwriteln('stockInternodePlant        --> ' + FloatToStr(stockInternodePlant));
    SRwriteln('structLeaf                 --> ' + FloatToStr(structLeaf));
    SRwriteln('AreaLFEL                   --> ' + FloatToStr(AreaLFEL));
    SRwriteln('DWLFEL                     --> ' + FloatToStr(DWLFEL));
    SRwriteln('SLALFEL                    --> ' + FloatToStr(SLALFEL));
  end;

  state := (instance as TEntityInstance).GetCurrentState();
  tmp := (1 - 1/LL_BL) * leafLength;
  SRwriteln('leafLength                 --> ' + FloatToStr(leafLength));
  SRwriteln('sumOfInternodeLength       --> ' + FloatToStr(sumOfInternodeLength));
  SRwriteln('peduncleLength             --> ' + FloatToStr(peduncleLength));
  case state of
    1, 2, 3 :
    begin
      SRwriteln('morphogenesis');
      PHT := tmp;
    end;
    9, 10 :
    begin
      SRwriteln('elong');
      PHT := tmp + sumOfInternodeLength;
    end;
    4, 5, 6, 7, 8, 11, 12, 13, 14, 15 :
    begin
      SRwriteln('pi et plus');
      if (tmp >= peduncleLength) then
      begin
        SRwriteln('(1 - 1/LL_BL) * leafLength >= peduncleLength');
        PHT := tmp + sumOfInternodeLength;
      end
      else
      begin
        SRwriteln('(1 - 1/LL_BL) * leafLength < peduncleLength');
        PHT := peduncleLength + sumOfInternodeLength;
      end;
    end;
  end;
  SRwriteln('PHT                        --> ' + FloatToStr(PHT));

end;

// ----------------------------------------------------------------------------
// Procedure compute_LAI_str
// -------------------------
//
/// LAI computation including water stress effect on leaf rolling
//
// ---------------------------------------------------------------------------
(**
@param PAI (In) sum of leaf area in plant
@param density (In) plant density per m²
@param fcstr (In) stress coeff (square root)
@param LAI (Out) LAI
*)
procedure compute_LAI_str(const PAI : double ; const density : double ; const fcstr : double ; var LAI : double);
begin

   LAI := PAI * density * (0.3+0.7*fcstr) / 10000;

end;


// ----------------------------------------------------------------------------
// Procedure computeAssimpot_str
// -----------------------------
//
/// Compute potential assimilation including an effect of water stress
/// on assimilation efficiency (empirical equation)
//
// ---------------------------------------------------------------------------
(**
@param radiationinterception (In) radiation  interception ratio (1-exp-Kdf*LAI)
@param epsib (In) radiation use efficiency g/MJ/m²/s
@param radiation (In) global radiation intensity (MJ.m².s)
@param Kpar (In) PAR fraction in global radiation (fraction)
@param potentialAssimilation (Out) potential biomass created daily (g)
*)
procedure computeAssimpot_str(const radiationinterception : double ; const epsib : double ; const radiation : double ; const fcstr : double ;const Kpar : double ; var potentialAssimilation : double);
begin
  potentialAssimilation := radiationInterception*Epsib*Ln(1.4292 + 1.3692 * fcstr)*radiation*Kpar;
end;

//
// procedure interne invisible
//

procedure ComputeReservoirDispoOrgan(const maxReserveInInternode, SumOfBiomassInOrganInternode, leafStockMax, SumOfBiomassInOrganLeaf : Double; var ReservoirDispoOrgan : Double);
begin
  ReservoirDispoOrgan := (maxReserveInInternode * SumOfBiomassInOrganInternode) + (leafStockMax * SumOfBiomassInOrganLeaf);
  SRwriteln('maxReserveInInternode        --> ' + floattostr(maxReserveInInternode));
  SRwriteln('SumOfBiomassInOrganInternode --> ' + floattostr(SumOfBiomassInOrganInternode));
  SRwriteln('leafStockMax                 --> ' + floattostr(leafStockMax));
  SRwriteln('SumOfBiomassInOrganLeaf      --> ' + floattostr(SumOfBiomassInOrganLeaf));
  SRwriteln('ReservoirDispoOrgan          --> ' + floattostr(ReservoirDispoOrgan));

end;

// ----------------------------------------------------------------------------
// Procedure ComputeReservoirDispoTiller
// ---------------------------------------
//
/// Calcule le reservoir disponible sur le tiller
//
// ---------------------------------------------------------------------------
(**
@param SumOfBiomassInTillerLeaf (In)
@param SumOfReservoirDispoIN (In)
@param StockTiller (In)
@param ReservoirDispoTiller (Out)
*)

procedure ComputeReservoirDispoTiller_LE(const maxReserveInInternode, SumOfBiomassInTillerInternode, leafStockMax, SumOfBiomassInTillerLeaf : Double; var ReservoirDispoTiller : Double);
begin
  ComputeReservoirDispoOrgan(maxReserveInInternode, SumOfBiomassInTillerInternode, leafStockMax, SumOfBiomassInTillerLeaf, ReservoirDispoTiller);
end;

// ----------------------------------------------------------------------------
// Procedure ComputeReservoirDispoMainstem
// ---------------------------------------
//
/// Calcule le reservoir disponible sur le mainstem
//
// ---------------------------------------------------------------------------
(**
@param SumOfBiomassInMainstemLeaf (In)
@param SumOfReservoirDispoIN (In)
@param StockMainstem (In)
@param ReservoirDispoMainstem (Out)
*)

procedure ComputeReservoirDispoMainstem_LE(const maxReserveInInternode, SumOfBiomassInMainstemInternode, leafStockMax, SumOfBiomassInMainstemLeaf : Double; var ReservoirDispoMainstem : Double);
begin
  ComputeReservoirDispoOrgan(maxReserveInInternode, SumOfBiomassInMainstemInternode, leafStockMax, SumOfBiomassInMainstemLeaf, ReservoirDispoMainstem);
end;

//
// procédure interne invisible de l'extérieur
//

procedure ComputeStockStem(const sumOfStockINCulm, stockLeafCulm, reservoirDispoCulm, supplyCulm, sumOfDemandNonINCulm : Double; var stockCulm : Double);
begin
  SRwriteln('sumOfStockINCulm     --> ' + FloatToStr(sumOfStockINCulm));
  SRwriteln('stockLeafCulm        --> ' + FloatToStr(stockLeafCulm));
  SRwriteln('reservoirDispoCulm   --> ' + FloatToStr(reservoirDispoCulm));
  SRwriteln('supplyCulm           --> ' + FloatToStr(supplyCulm));
  SRwriteln('sumOfDemandNonInCulm --> ' + FloatToStr(sumOfDemandNonInCulm));

  stockCulm := sumOfStockINCulm + stockLeafCulm + min(reservoirDispoCulm, supplyCulm - sumOfDemandNonInCulm);

  SRwriteln('stockCulm            --> ' + FloatToStr(stockCulm));
end;

procedure ComputeStockStem2(const sumOfStockINCulm, stockLeafCulm, reservoirDispoCulm, supplyCulm : Double; var stockCulm : Double);
begin
  SRwriteln('sumOfStockINCulm     --> ' + FloatToStr(sumOfStockINCulm));
  SRwriteln('stockLeafCulm        --> ' + FloatToStr(stockLeafCulm));
  SRwriteln('reservoirDispoCulm   --> ' + FloatToStr(reservoirDispoCulm));
  SRwriteln('supplyCulm           --> ' + FloatToStr(supplyCulm));

  stockCulm := sumOfStockINCulm + stockLeafCulm + min(reservoirDispoCulm, supplyCulm);

  SRwriteln('stockCulm            --> ' + FloatToStr(stockCulm));
end;

// ----------------------------------------------------------------------------
// Procedure ComputeStockMainstem_LE
// ---------------------------------
//
/// Calcule le stock disponible sur le mainstem
//
// ---------------------------------------------------------------------------
(**
@param ReservoirDispoMainstem (In)
@param SupplyMainstem (In)
@param DemandMainstem (In)
@param StockMainstem (Out)
*)

procedure ComputeStockTiller_LE(const sumOfStockINTiller, stockLeafTiller, reservoirDispoTiller, supplyTiller, sumOfDemandNonINTiller : Double; var stockTiller : Double);
begin
  ComputeStockStem(sumOfStockINTiller, stockLeafTiller, reservoirDispoTiller, supplyTiller, sumOfDemandNonINTiller, stockTiller);
end;

procedure ComputeStockTiller2_LE(const sumOfStockINTiller, stockLeafTiller, reservoirDispoTiller, supplyTiller : Double; var stockTiller : Double);
begin
  ComputeStockStem2(sumOfStockINTiller, stockLeafTiller, reservoirDispoTiller, supplyTiller, stockTiller);
end;


// ----------------------------------------------------------------------------
// Procedure ComputeStockMainstem_LE
// ---------------------------------
//
/// Calcule le stock disponible sur le mainstem
//
// ---------------------------------------------------------------------------
(**
@param ReservoirDispoMainstem (In)
@param SupplyMainstem (In)
@param DemandMainstem (In)
@param StockMainstem (Out)
*)

procedure ComputeStockMainstem_LE(const sumOfStockINMainstem, stockLeafMainstem, reservoirDispoMainstem, supplyMainstem, sumOfDemandNonINMainstem : Double; var stockMainstem : Double);
begin
  ComputeStockStem(sumOfStockINMainstem, stockLeafMainstem, reservoirDispoMainstem, supplyMainstem, sumOfDemandNonINMainstem, stockMainstem);
end;

procedure ComputeStockMainstem2_LE(const sumOfStockINMainstem, stockLeafMainstem, reservoirDispoMainstem, supplyMainstem : Double; var stockMainstem : Double);
begin
  ComputeStockStem2(sumOfStockINMainstem, stockLeafMainstem, reservoirDispoMainstem, supplyMainstem, stockMainstem);
end;

// ---------------------------------------------------------------------------
// Procedure ComputeSupplyPlant_LE
// -------------------------------
//
// Calcule la somme des variables assim sur la plante
//
//
// module 'extra'
// --------------------------------------------------------------------------

procedure ComputeSupplyPlant_LE(var instance : TInstance);
var
  contribution, total : Double;
  stateMeristem, le, i : Integer;
  currentInstance : TInstance;
  sample : TSample;
  date : TDateTime;
begin
  stateMeristem := (instance as TEntityInstance).GetCurrentState();
  if (stateMeristem >= 4) then
  begin
    total := 0;
    contribution := (instance as TEntityInstance).GetTAttribute('supply_mainstem').GetCurrentSample().value;
    total := total + contribution;
    SRwriteln('Supply Mainstem --> ' + FloatToStr(contribution));
    le := (instance as TEntityInstance).LengthTInstanceList();
    for i := 0 to le - 1 do
    begin
      currentInstance := (instance as TEntityInstance).GetTInstance(i);
      if (currentInstance is TEntityInstance) then
      begin
        if ((currentInstance as TEntityInstance).GetCategory() = 'Tiller') then
        begin
          contribution := (currentInstance as TEntityInstance).GetTAttribute('supply_tiller').GetCurrentSample().value;
          SRwriteln('Supply ' + currentInstance.GetName() + ' --> ' + FloatToStr(contribution));
          total := total + contribution;
        end;
      end;
    end;
    date := (instance as TEntityInstance).GetNextDate();
    sample := ((instance as TEntityInstance).GetTAttribute('supply') as TAttributeTableOut).GetSample(date);
    sample.date := date;
    sample.value := total;
    ((instance as TEntityInstance).GetTAttribute('supply') as TAttributeTableOut).SetSample(sample);
    SRwriteln('Supply Plant --> ' + FloatToStr(total));
  end;
end;


// ---------------------------------------------------------------------------
// Procedure ComputeSurplusPlant_LE
// --------------------------------
//
// Calcule la somme des variables assim sur la plante
//
//
// module 'extra'
// --------------------------------------------------------------------------

procedure ComputeSurplusPlant_LE(var instance : TInstance);
var
  contribution, total : Double;
  stateMeristem, le, i : Integer;
  currentInstance : TInstance;
  sample : TSample;
  date : TDateTime;
begin
  stateMeristem := (instance as TEntityInstance).GetCurrentState();
  if (stateMeristem >= 4) then
  begin
    total := 0;
    contribution := (instance as TEntityInstance).GetTAttribute('surplus_mainstem').GetCurrentSample().value;
    total := total + contribution;
    SRwriteln('Surplus Mainstem --> ' + FloatToStr(contribution));
    le := (instance as TEntityInstance).LengthTInstanceList();
    for i := 0 to le - 1 do
    begin
      currentInstance := (instance as TEntityInstance).GetTInstance(i);
      if (currentInstance is TEntityInstance) then
      begin
        if ((currentInstance as TEntityInstance).GetCategory() = 'Tiller') then
        begin
          contribution := (currentInstance as TEntityInstance).GetTAttribute('surplus_tiller').GetCurrentSample().value;
          SRwriteln('Surplus ' + currentInstance.GetName() + ' --> ' + FloatToStr(contribution));
          total := total + contribution;
        end;
      end;
    end;
    date := (instance as TEntityInstance).GetNextDate();
    sample := ((instance as TEntityInstance).GetTAttribute('surplus') as TAttributeTableOut).GetSample(date);
    sample.date := date;
    sample.value := total;
    ((instance as TEntityInstance).GetTAttribute('surplus') as TAttributeTableOut).SetSample(sample);
    SRwriteln('Surplus Plant --> ' + FloatToStr(total));
  end;end;

// -----------------------------------------------------------------------------
// Procedure ComputeDeficitPlant_LE
// --------------------------------
//
// Calcule la somme des variables deficit_mainstem et deficit_tiller sur toute
// la plante
//
//
// module 'extra'
// -----------------------------------------------------------------------------

procedure ComputeDeficitPlant_LE(var instance : TInstance);
var
  contribution, total : Double;
  stateMeristem, le, i : Integer;
  currentInstance : TInstance;
  sample : TSample;
  date : TDateTime;
begin
  stateMeristem := (instance as TEntityInstance).GetCurrentState();
  if (stateMeristem >= 4) then
  begin
    total := 0;
    contribution := (instance as TEntityInstance).GetTAttribute('deficit_mainstem').GetCurrentSample().value;
    total := total + contribution;
    SRwriteln('Deficit Mainstem --> ' + FloatToStr(contribution));
    le := (instance as TEntityInstance).LengthTInstanceList();
    for i := 0 to le - 1 do
    begin
      currentInstance := (instance as TEntityInstance).GetTInstance(i);
      if (currentInstance is TEntityInstance) then
      begin
        if ((currentInstance as TEntityInstance).GetCategory() = 'Tiller') then
        begin
          contribution := (currentInstance as TEntityInstance).GetTAttribute('deficit_tiller').GetCurrentSample().value;
          SRwriteln('Deficit ' + currentInstance.GetName() + ' --> ' + FloatToStr(contribution));
          total := total + contribution;
        end;
      end;
    end;
    date := (instance as TEntityInstance).GetNextDate();
    sample := ((instance as TEntityInstance).GetTAttribute('deficit') as TAttributeTableOut).GetSample(date);
    sample.date := date;
    sample.value := total;
    (instance as TEntityInstance).GetTAttribute('deficit').SetSample(sample);
    SRwriteln('Deficit Plant --> ' + FloatToStr(total));
  end;
end;

// ---------------------------------------------------------------------------
// Procedure ComputeStockPlant_LE
// ------------------------------
//
// Calcule la somme des variables stock_mainstem et stock_tiller sur la plante
//
//
// module 'extra'
// --------------------------------------------------------------------------

procedure ComputeStockPlant_LE(var instance : TInstance);
var
  contribution, total : Double;
  stateMeristem, le, i : Integer;
  currentInstance : TInstance;
  sample : TSample;
  date : TDateTime;
begin
  stateMeristem := (instance as TEntityInstance).GetCurrentState();
  if (stateMeristem >= 4) then
  begin
    total := 0;
    contribution := ((instance as TEntityInstance).GetTAttribute('stock_mainstem') as TAttributeTableOut).GetCurrentSample().value;
    total := total + contribution;
    SRwriteln('Stock Mainstem --> ' + FloatToStr(contribution));
    le := (instance as TEntityInstance).LengthTInstanceList();
    for i := 0 to le - 1 do
    begin
      currentInstance := (instance as TEntityInstance).GetTInstance(i);
      if (currentInstance is TEntityInstance) then
      begin
        if ((currentInstance as TEntityInstance).GetCategory() = 'Tiller') then
        begin
          contribution := (currentInstance as TEntityInstance).GetTAttribute('stock_tiller').GetCurrentSample().value;
          SRwriteln('Stock ' + currentInstance.GetName() + ' --> ' + FloatToStr(contribution));
          total := total + contribution;
        end;
      end;
    end;
    date := (instance as TEntityInstance).GetNextDate();
    sample := ((instance as TEntityInstance).GetTAttribute('stock') as TAttributeTableOut).GetSample(date);
    sample.date := date;
    sample.value := total;
    ((instance as TEntityInstance).GetTAttribute('stock') as TAttributeTableOut).SetSample(sample);
    SRwriteln('Stock Plant --> ' + FloatToStr(total));
  end;
end;

// -----------------------------------------------------------------------------
// Procedure ComputeSumOfBiomassOnInternodeInMatureStateOnCulm_LE
// --------------------------------------------------------------
//
//
//
// module 'extra'
// -----------------------------------------------------------------------------


procedure ComputeSumOfBiomassOnInternodeInMatureStateOnCulms_LE(var instance : TInstance);
var
  stateMeristem, i1, i2, le1, le2 : Integer;
  totalMeristem, totalTiller, biomassIN : Double;
  currentInstance, currentCurrentInstance : TInstance;
  sample : TSample;
  date : TDateTime;
begin
  stateMeristem := (instance as TEntityInstance).GetCurrentState();
  if (stateMeristem >= 4) and (stateMeristem <> 1000) then
  begin
    le1 := (instance as TEntityInstance).LengthTInstanceList();
    totalMeristem := 0;
    for i1 := 0 to le1 - 1 do
    begin
      currentInstance := (instance as TEntityInstance).GetTInstance(i1);
      if (currentInstance is TEntityInstance) then
      begin
        if ((currentInstance as TEntityInstance).GetCategory() = 'Internode') then
        begin
          if ((currentInstance as TEntityInstance).GetCurrentState() = 4) then
          begin
            biomassIN := (currentInstance as TEntityInstance).GetTAttribute('biomassIN').GetCurrentSample().value;
            totalMeristem := totalMeristem + biomassIN;
          end;
        end
        else if ((currentInstance as TEntityInstance).GetCategory() = 'Tiller') then
        begin
          totalTiller := 0;
          le2 := (currentInstance as TEntityInstance).LengthTInstanceList();
          for i2 := 0 to le2 - 1 do
          begin
            currentCurrentInstance := (currentInstance as TEntityInstance).GetTInstance(i2);
            if (currentCurrentInstance is TEntityInstance) then
            begin
              if ((currentCurrentInstance as TEntityInstance).GetCategory() = 'Internode') then
              begin
                if ((currentCurrentInstance as TEntityInstance).GetCurrentState() = 4) then
                begin
                  biomassIN := (currentCurrentInstance as TEntityInstance).GetTAttribute('biomassIN').GetCurrentSample().value;
                  totalTiller := totalTiller + biomassIN;
                end;
              end;
            end;
          end;
          date := (currentInstance as TEntityInstance).GetNextDate();
          sample := (currentInstance as TEntityInstance).GetTAttribute('sumOfBiomassOnInternodeInMatureState').GetSample(date);
          sample.date := date;
          sample.value := totalTiller;
          (currentInstance as TEntityInstance).GetTAttribute('sumOfBiomassOnInternodeInMatureState').SetSample(sample);
          SRwriteln('Talle : ' + currentInstance.GetName() + ' sumOfBiomassOnInternodeInMatureState --> ' + FloatToStr(sample.value));
        end;
      end;
    end;
    date := (instance as TEntityInstance).GetNextDate();
    sample := (instance as TEntityInstance).GetTAttribute('sumOfBiomassOnInternodeInMatureState').GetSample(date);
    sample.date := date;
    sample.value := totalMeristem;
    (instance as TEntityInstance).GetTAttribute('sumOfBiomassOnInternodeInMatureState').SetSample(sample);
    SRwriteln('Mainstem sumOfBiomassOnInternodeInMatureState --> ' + FloatToStr(sample.value));
  end;
end;


// -----------------------------------------------------------------------------
// Procedure ComputeSurplusCulms_LE
// --------------------------------
//
// Calcule le deficit sur les axes
//
// module 'extra'
// -----------------------------------------------------------------------------

procedure ComputeSurplusCulms_LE(var instance : TInstance);
var
  stateMeristem, stateTiller, i, le : Integer;
  sample : TSample;
  currentInstance : TInstance;
  stockCulm, maxReservoirOnCulm, sumDemandINCulm, sumDemandNonINCulm, sumOfLastDemandCulm, surplusCulm, supplyCulm : Double;
  date : TDateTime;
begin
  stateMeristem := (instance as TEntityInstance).GetCurrentState();
  if (stateMeristem >= 4) then
  begin
    SRwriteln('state meristem : ' + IntToStr(stateMeristem));
    stockCulm := ((instance as TEntityInstance).GetTAttribute('stock_mainstem') as TAttributeTableOut).GetCurrentSample().value;
    maxReservoirOnCulm := (instance as TEntityInstance).GetTAttribute('max_reservoir_mainstem').GetCurrentSample().value;
    sumDemandINCulm := (instance as TEntityInstance).GetTAttribute('sumOfMainstemInternodeDemand').GetCurrentSample().value;
    sumDemandNonINCulm := (instance as TEntityInstance).GetTAttribute('sumOfMainstemNonInternodeDemand').GetCurrentSample().value;
    sumOfLastDemandCulm := (instance as TEntityInstance).GetTAttribute('lastDemandMainstem').GetCurrentSample().value;
    supplyCulm := (instance as TEntityInstance).GetTAttribute('supply_mainstem').GetCurrentSample().value;
    SRwriteln('stockMainstem                   --> ' + FloatToStr(stockCulm));
    SRwriteln('maxReservoirDispoOnMainstem     --> ' + FloatToStr(maxReservoirOnCulm));
    SRwriteln('sumOfMainstemInternodeDemand    --> ' + FloatToStr(sumDemandINCulm));
    SRwriteln('sumOfMainstemNonInternodeDemand --> ' + FloatToStr(sumDemandNonINCulm));
    SRwriteln('sumOfLastDemandMainstem         --> ' + FloatToStr(sumOfLastDemandCulm));
    SRwriteln('supplyMainstem                  --> ' + FloatToStr(supplyCulm));
    surplusCulm := Max(0, stockCulm - sumDemandINCulm - sumDemandNonINCulm - sumOfLastDemandCulm + supplyCulm - maxReservoirOnCulm);
    SRwriteln('surplusCulm                     --> ' + FloatToStr(surplusCulm));
    date := (instance as TEntityInstance).GetNextDate();
    sample := (instance as TEntityInstance).GetTAttribute('surplus_mainstem').GetSample(date);
    sample.date := date;
    sample.value := surplusCulm;
    (instance as TEntityInstance).GetTAttribute('surplus_mainstem').SetSample(sample);
    le := (instance as TEntityInstance).LengthTInstanceList();
    for i := 0 to le - 1 do
    begin
      currentInstance := (instance as TEntityInstance).GetTInstance(i);
      if (currentInstance is TEntityInstance) then
      begin
        if ((currentInstance as TEntityInstance).GetCategory() = 'Tiller') then
        begin
          stateTiller := (currentInstance as TEntityInstance).GetCurrentState();
          case stateTiller of
            4, 6, 7, 9, 10 :
            begin
              SRwriteln('Tiller                 --> ' + currentInstance.GetName());
              SRwriteln('state tiller           --> ' + IntToStr(stateTiller));
              stockCulm := (currentInstance as TEntityInstance).GetTAttribute('stock_tiller').GetCurrentSample().value;
              maxReservoirOnCulm := (currentInstance as TEntityInstance).GetTAttribute('max_reservoir_tiller').GetCurrentSample().value;
              sumDemandINCulm := (currentInstance as TEntityInstance).GetTAttribute('sumOfTillerInternodeDemand').GetCurrentSample().value;
              sumDemandNonINCulm := (currentInstance as TEntityInstance).GetTAttribute('demandOfNonINTiller').GetCurrentSample().value;
              sumOfLastDemandCulm := (currentInstance as TEntityInstance).GetTAttribute('last_demand_tiller').GetCurrentSample().value;
              supplyCulm := (currentInstance as TEntityInstance).GetTAttribute('supply_tiller').GetCurrentSample().value;
              SRwriteln('stockTiller                   --> ' + FloatToStr(stockCulm));
              SRwriteln('maxReservoirDispoOnTiller     --> ' + FloatToStr(maxReservoirOnCulm));
              SRwriteln('sumOfTillerInternodeDemand    --> ' + FloatToStr(sumDemandINCulm));
              SRwriteln('sumOfTillerNonInternodeDemand --> ' + FloatToStr(sumDemandNonINCulm));
              SRwriteln('sumOfLastDemandTiller         --> ' + FloatToStr(sumOfLastDemandCulm));
              SRwriteln('supplyTiller                  --> ' + FloatToStr(supplyCulm));
              surplusCulm := Max(0, stockCulm - sumDemandINCulm - sumDemandNonINCulm - sumOfLastDemandCulm + supplyCulm - maxReservoirOnCulm);
              SRwriteln('surplusCulm                   --> ' + FloatToStr(surplusCulm));
              date := (currentInstance as TEntityInstance).GetNextDate();
              sample := (currentInstance as TEntityInstance).GetTAttribute('surplus_tiller').GetSample(date);
              sample.date := date;
              sample.value := surplusCulm;
              (currentInstance as TEntityInstance).GetTAttribute('surplus_tiller').SetSample(sample);
            end;
          end;
        end;
      end;
    end;
  end;
end;

// -----------------------------------------------------------------------------
// Procedure ComputeDeficitCulms_LE
// --------------------------------
//
// Calcule le deficit sur les axes
//
// module 'extra'
// -----------------------------------------------------------------------------

procedure ComputeDeficitCulms_LE(var instance : TInstance);
var
  stateMeristem, stateTiller, i, le : Integer;
  sample : TSample;
  currentInstance : TInstance;
  deficitCulm, tmpCulm : Double;
  date : TDateTime;
begin
  stateMeristem := (instance as TEntityInstance).GetCurrentState();
  if (stateMeristem >= 4) then
  begin
    SRwriteln('state meristem : ' + IntToStr(stateMeristem));
    tmpCulm := (instance as TEntityInstance).GetTAttribute('tmp_mainstem').GetCurrentSample().value;
    deficitCulm := Min(0, tmpCulm);
    SRwriteln('tmpMainstem     --> ' + FloatToStr(tmpCulm));
    SRwriteln('deficitMainstem --> ' + FloatToStr(deficitCulm));
    date := (instance as TEntityInstance).GetNextDate();
    sample := (instance as TEntityInstance).GetTAttribute('deficit_mainstem').GetSample(date);
    sample.date := date;
    sample.value := deficitCulm;
    (instance as TEntityInstance).GetTAttribute('deficit_mainstem').SetSample(sample);
    le := (instance as TEntityInstance).LengthTInstanceList();
    for i := 0 to le - 1 do
    begin
      currentInstance := (instance as TEntityInstance).GetTInstance(i);
      if (currentInstance is TEntityInstance) then
      begin
        if ((currentInstance as TEntityInstance).GetCategory() = 'Tiller') then
        begin
          stateTiller := (currentInstance as TEntityInstance).GetCurrentState();
          case stateTiller of
            4, 6, 7, 9, 10 :
              begin
                SRwriteln('Tiller        --> ' + currentInstance.GetName());
                SRwriteln('state tiller  --> ' + IntToStr(stateTiller));
                tmpCulm := (currentInstance as TEntityInstance).GetTAttribute('tmp_tiller').GetCurrentSample().value;
                deficitCulm := Min(0, tmpCulm);
                SRwriteln('tmpTiller     --> ' + FloatToStr(tmpCulm));
                SRwriteln('deficitTiller --> ' + FloatToStr(deficitCulm));
                date := (currentInstance as TEntityInstance).GetNextDate();
                sample := (currentInstance as TEntityInstance).GetTAttribute('deficit_tiller').GetSample(date);
                sample.date := date;
                sample.value := deficitCulm;
                (currentInstance as TEntityInstance).GetTAttribute('deficit_tiller').SetSample(sample);
              end;
            end;
        end;
      end;
    end;
  end;
end;

// -----------------------------------------------------------------------------
// Procedure ComputeLeafInternodeBiomassCulms_LE
// ---------------------------------------------
//
// Calcule la somme des biomasses des IN et Leafs sur les axes
//
// module 'extra'
// -----------------------------------------------------------------------------

procedure ComputeLeafInternodeBiomassCulms_LE(var instance : TInstance);
var
  le1, le2, i1, i2 : Integer;
  currentInstance1, currentInstance2 : TInstance;
  currentEntityInstance1, currentEntityInstance2 : TEntityInstance;
  leafBiomass, internodeBiomass, leafInternodeBiomassMainstem, leafInternodeBiomassTiller, total : Double;
  date : TDateTime;
  sample : TSample;
begin
  total := 0;
  leafInternodeBiomassMainstem := 0;
  le1 := (instance as TEntityInstance).LengthTInstanceList();
  for i1 := 0 to le1 - 1 do
  begin
    currentInstance1 := (instance as TEntityInstance).GetTInstance(i1);
    if (currentInstance1 is TEntityInstance) then
    begin
      currentEntityInstance1 := (currentInstance1 as TEntityInstance);
      if (currentEntityInstance1.GetCategory() = 'Leaf') then
      begin
        date := currentEntityInstance1.GetNextDate();
        leafBiomass := currentEntityInstance1.GetTAttribute('biomass').GetSample(date).value;
        leafInternodeBiomassMainstem := leafInternodeBiomassMainstem + leafBiomass;
        total := total + leafBiomass;
      end
      else if (currentEntityInstance1.GetCategory() = 'Internode') then
      begin
        date := currentEntityInstance1.GetNextDate();
        internodeBiomass := currentEntityInstance1.GetTAttribute('biomassIN').GetSample(date).value;
        leafInternodeBiomassMainstem := leafInternodeBiomassMainstem + internodeBiomass;
        total := total + internodeBiomass;
      end
      else if (currentEntityInstance1.GetCategory() = 'Tiller') then
      begin
        leafInternodeBiomassTiller := 0;
        le2 := currentEntityInstance1.LengthTInstanceList();
        for i2 := 0 to le2 - 1 do
        begin
          currentInstance2 := currentEntityInstance1.GetTInstance(i2);
          if (currentInstance2 is TEntityInstance) then
          begin
            currentEntityInstance2 := (currentInstance2 as TEntityInstance);
            if (currentEntityInstance2.GetCategory() = 'Leaf') then
            begin
              date := currentEntityInstance2.GetNextDate();
              leafBiomass := currentEntityInstance2.GetTAttribute('biomass').GetSample(date).value;
              leafInternodeBiomassTiller := leafInternodeBiomassTiller + leafBiomass;
              total := total + leafBiomass;
            end
            else if (currentEntityInstance2.GetCategory() = 'Internode') then
            begin
              date := currentEntityInstance2.GetNextDate();
              internodeBiomass := currentEntityInstance2.GetTAttribute('biomassIN').GetSample(date).value;
              leafInternodeBiomassTiller := leafInternodeBiomassTiller + internodeBiomass;
              total := total + internodeBiomass;
            end;
          end;
        end;
        date := currentEntityInstance1.GetNextDate();
        sample.date := date;
        sample.value := leafInternodeBiomassTiller;
        currentEntityInstance1.GetTAttribute('leaf_internode_biomass_tiller').SetSample(sample);
        SRwriteln('Tiller                        --> ' + currentEntityInstance1.GetName());
        SRwriteln('leaf_internode_biomass_tiller --> ' + FloatToStr(leafInternodeBiomassTiller));
        SRwriteln('leaf_internode_biomass        --> ' + FloatToStr(total));
      end;
    end;
  end;
  date := (instance as TEntityInstance).GetNextDate();
  sample.date := date;
  sample.value := leafInternodeBiomassMainstem;
  (instance as TEntityInstance).GetTAttribute('leaf_internode_biomass_mainstem').SetSample(sample);
  sample.value := total;
  (instance as TEntityInstance).GetTAttribute('leaf_internode_biomass').SetSample(sample);
  SRwriteln('Mainstem');
  SRwriteln('leaf_internode_biomass_mainstem --> ' + FloatToStr(leafInternodeBiomassMainstem));
  SRwriteln('leaf_internode_biomass          --> ' + FloatToStr(total));
end;

// -----------------------------------------------------------------------------
// Procedure ComputeTmpCulms_LE
// -----------------------------------
//
// Calcule le tmp sur les axes
//
// module 'extra'
// -----------------------------------------------------------------------------

function ComputeBiomassCulm(var instance : TInstance) : Double;
var
  i, le : Integer;
  currentInstance : TInstance;
  total : Double;
begin
  total := 0;
  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      if ((currentInstance as TEntityInstance).GetCategory() = 'Leaf') then
      begin
        total := total + (currentInstance as TEntityInstance).GetTAttribute('biomass').GetCurrentSample().value;
      end
      else if ((currentInstance as TEntityInstance).GetCategory() = 'Internode') then
      begin
        total := total + (currentInstance as TEntityInstance).GetTAttribute('biomassIN').GetCurrentSample().value;
      end;
    end;
  end;
  result := total;
end;

function ComputeAllBiomass(var instance : TInstance) : Double;
var
  i, le : Integer;
  currentInstance : TInstance;
  total, contribution : Double;
begin
  total := 0;
  contribution := ComputeBiomassCulm(instance);
  total := total + contribution;
  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      if ((currentInstance as TEntityInstance).GetCategory() = 'Tiller') then
      begin
        contribution := ComputeBiomassCulm(currentInstance);
        total := total + contribution;
      end;
    end;
  end;
  result := total;
end;

procedure ComputeTmpCulms_LE(var instance : TInstance);
var
  stateMeristem, stateTiller, le, i : Integer;
  currentInstance : TInstance;
  stockCulm, deficitCulm, sumDemandINCulm, sumDemandNonINCulm, sumOfLastDemandCulm, supplyCulm, tmpCulm : Double;
  sumOfBiomassOnCulm, sumOfBiomassOnPlant, sumOfDailySenescedLeafBiomassCulm : Double;
  stockPlant, deficitPlant, computedReallocBiomass, reallocCulm : Double;
  sample : TSample;
  date : TDateTime;
begin
  stateMeristem := (instance as TEntityInstance).GetCurrentState();
  if (stateMeristem >= 4) then
  begin
    SRwriteln('stateMeristem : ' + IntToStr(stateMeristem));
    deficitPlant := ((instance as TEntityInstance).GetTAttribute('deficit') as TAttributeTableOut).GetCurrentSample().value;
    stockPlant :=  ((instance as TEntityInstance).GetTAttribute('stock') as TAttributeTableOut).GetCurrentSample().value;
    computedReallocBiomass := ((instance as TEntityInstance).GetTAttribute('computedReallocBiomass') as TAttributeTableOut).GetCurrentSample().value;
    stockCulm := ((instance as TEntityInstance).GetTAttribute('stock_mainstem') as TAttributeTableOut).GetCurrentSample().value;
    deficitCulm := (instance as TEntityInstance).GetTAttribute('deficit_mainstem').GetCurrentSample().value;
    sumDemandINCulm := (instance as TEntityInstance).GetTAttribute('sumOfMainstemInternodeDemand').GetCurrentSample().value;
    sumDemandNonINCulm := (instance as TEntityInstance).GetTAttribute('sumOfMainstemNonInternodeDemand').GetCurrentSample().value;
    sumOfLastDemandCulm := (instance as TEntityInstance).GetTAttribute('lastDemandMainstem').GetCurrentSample().value;
    supplyCulm := (instance as TEntityInstance).GetTAttribute('supply_mainstem').GetCurrentSample().value;
    sumOfDailySenescedLeafBiomassCulm := (instance as TEntityInstance).GetTAttribute('sumOfDailySenescedLeafBiomassMainstem').GetCurrentSample().value;

    date := (instance as TEntityInstance).GetNextDate();

    SRwriteln('stockMainstem                         --> ' + FloatToStr(stockCulm));
    SRwriteln('deficitMainstem                       --> ' + FloatToStr(deficitCulm));
    SRwriteln('deficitPlant                          --> ' + FloatToStr(deficitPlant));
    SRwriteln('sumOfMainstemInternodeDemand          --> ' + FloatToStr(sumDemandINCulm));
    SRwriteln('sumOfMainstemNonInternodeDemand       --> ' + FloatToStr(sumDemandNonINCulm));
    SRwriteln('lastDemandMainstem                    --> ' + FloatToStr(sumOfLastDemandCulm));
    SRwriteln('supplyMainstem                        --> ' + FloatToStr(supplyCulm));
    SRwriteln('computedReallocBiomass                --> ' + FloatToStr(computedReallocBiomass));
    SRwriteln('sumOfDailySenescedLeafBiomassMainstem --> ' + FloatToStr(sumOfDailySenescedLeafBiomassCulm));

    if (deficitPlant < 0) then
    begin
      sumOfBiomassOnCulm := ComputeBiomassCulm(instance);
      sumOfBiomassOnPlant := ComputeAllBiomass(instance);
      stockCulm := (sumOfBiomassOnCulm / sumOfBiomassOnPlant) * stockPlant;
      deficitCulm := (sumOfBiomassOnCulm / sumOfBiomassOnPlant) * deficitPlant;
      sample.date := date;
      sample.value :=  stockCulm;
      (instance as TEntityInstance).GetTAttribute('stock_mainstem').SetSample(sample);
      sample.value := deficitCulm;
      (instance as TEntityInstance).GetTAttribute('deficit_mainstem').SetSample(sample);
      SRwriteln('Nouveau stock, nouveau deficit');
      SRwriteln('------------------------------');
      SRwriteln('sumOfBiomassOnCulm  --> ' + FloatToStr(sumOfBiomassOnCulm));
      SRwriteln('sumOfBiomassOnPlant --> ' + FloatToStr(sumOfBiomassOnPlant));
      SRwriteln('stockPlant          --> ' + FloatToStr(stockPlant));
      SRwriteln('deficitPlant        --> ' + FloatToStr(deficitPlant));
      SRwriteln('stockCulm           --> ' + FloatToStr(stockCulm));
      SRwriteln('deficitCulm         --> ' + FloatToStr(deficitCulm));
      SRwriteln('------------------------------');
    end;
    tmpCulm := stockCulm + deficitCulm + supplyCulm - sumDemandINCulm - sumDemandNonINCulm - sumOfLastDemandCulm + sumOfDailySenescedLeafBiomassCulm;
    SRwriteln('tmpMainstem                     --> ' + FloatToStr(tmpCulm));
    SRwriteln('-------------------------------------------------');
    sample := (instance as TEntityInstance).GetTAttribute('tmp_mainstem').GetSample(date);
    sample.date := date;
    sample.value := tmpCulm;
    (instance as TEntityInstance).GetTAttribute('tmp_mainstem').SetSample(sample);
    le := (instance as TEntityInstance).LengthTInstanceList();
    for i := 0 to le - 1 do
    begin
      currentInstance := (instance as TEntityInstance).GetTInstance(i);
      if (currentInstance is TEntityInstance) then
      begin
        if ((currentInstance as TEntityInstance).GetCategory() = 'Tiller') then
        begin
          stateTiller := (currentInstance as TEntityInstance).GetCurrentState();
          if (stateTiller >= 4) then
          begin
            SRwriteln('Tiller                        --> ' + currentInstance.GetName());
            SRwriteln('state Tiller                  --> ' + IntToStr(stateTiller));
            stockCulm := (currentInstance as TEntityInstance).GetTAttribute('stock_tiller').GetCurrentSample().value;
            deficitCulm := (currentInstance as TEntityInstance).GetTAttribute('deficit_tiller').GetCurrentSample().value;
            sumDemandINCulm := (currentInstance as TEntityInstance).GetTAttribute('sumOfTillerInternodeDemand').GetCurrentSample().value;
            sumDemandNonINCulm := (currentInstance as TEntityInstance).GetTAttribute('demandOfNonINTiller').GetCurrentSample().value;
            sumOfLastDemandCulm := (currentInstance as TEntityInstance).GetTAttribute('last_demand_tiller').GetCurrentSample().value;
            supplyCulm := (currentInstance as TEntityInstance).GetTAttribute('supply_tiller').GetCurrentSample().value;
            sumOfDailySenescedLeafBiomassCulm := (currentInstance as TEntityInstance).GetTAttribute('sumOfDailySenescedLeafBiomassTiller').GetCurrentSample().value;
            SRwriteln('stockTiller                         --> ' + FloatToStr(stockCulm));
            SRwriteln('deficitTiller                       --> ' + FloatToStr(deficitCulm));
            SRwriteln('deficitPlant                        --> ' + FloatToStr(deficitPlant));
            SRwriteln('sumOfTillerInternodeDemand          --> ' + FloatToStr(sumDemandINCulm));
            SRwriteln('sumOfTillerNonInternodeDemand       --> ' + FloatToStr(sumDemandNonINCulm));
            SRwriteln('lastDemandTiller                    --> ' + FloatToStr(sumOfLastDemandCulm));
            SRwriteln('supplyTiller                        --> ' + FloatToStr(supplyCulm));
            SRwriteln('sumOfDailySenescedLeafBiomassTiller --> ' + FloatToStr(sumOfDailySenescedLeafBiomassCulm));
            if (deficitPlant < 0) then
            begin
              sumOfBiomassOnCulm := ComputeBiomassCulm(currentInstance);
              sumOfBiomassOnPlant := ComputeAllBiomass(instance);
              stockCulm := (sumOfBiomassOnCulm / sumOfBiomassOnPlant) * stockPlant;
              deficitCulm := (sumOfBiomassOnCulm / sumOfBiomassOnPlant) * deficitPlant;
              sample.date := date;
              sample.value :=  stockCulm;
              (currentInstance as TEntityInstance).GetTAttribute('stock_tiller').SetSample(sample);
              sample.value := deficitCulm;
              (currentInstance as TEntityInstance).GetTAttribute('deficit_tiller').SetSample(sample);
              SRwriteln('Nouveau stock, nouveau deficit');
              SRwriteln('------------------------------');
              SRwriteln('sumOfBiomassOnCulm  --> ' + FloatToStr(sumOfBiomassOnCulm));
              SRwriteln('sumOfBiomassOnPlant --> ' + FloatToStr(sumOfBiomassOnPlant));
              SRwriteln('stockPlant          --> ' + FloatToStr(stockPlant));
              SRwriteln('deficitPlant        --> ' + FloatToStr(deficitPlant));
              SRwriteln('stockCulm           --> ' + FloatToStr(stockCulm));
              SRwriteln('deficitCulm         --> ' + FloatToStr(deficitCulm));
              SRwriteln('------------------------------');              
            end;
            tmpCulm := stockCulm + deficitCulm + supplyCulm - sumDemandINCulm - sumDemandNonINCulm - sumOfLastDemandCulm + sumOfDailySenescedLeafBiomassCulm;
            SRwriteln('tmpTiller                     --> ' + FloatToStr(tmpCulm));
            SRwriteln('-------------------------------------------------');
            date := (currentInstance as TEntityInstance).GetNextDate();
            sample := (currentInstance as TEntityInstance).GetTAttribute('tmp_tiller').GetSample(date);
            sample.date := date;
            sample.value := tmpCulm;
            (currentInstance as TEntityInstance).GetTAttribute('tmp_tiller').SetSample(sample);
          end;
        end;
      end;
    end;
  end;
end;

// -----------------------------------------------------------------------------
// Procedure ComputeStockCulms_LE
// -----------------------------------
//
// Calcule le stock sur les axes
//
// module 'extra'
// -----------------------------------------------------------------------------

procedure ComputeStockCulms_LE(var instance : TInstance);
var
  stateMeristem, stateTiller, i, le : Integer;
  sample : TSample;
  currentInstance : TInstance;
  stockCulm, maxReservoirOnCulm, tmpCulm  : Double;
  date : TDateTime;
begin
  stateMeristem := (instance as TEntityInstance).GetCurrentState();
  if (stateMeristem >= 4) then
  begin
    SRwriteln('state meristem : ' + IntToStr(stateMeristem));
    maxReservoirOnCulm := (instance as TEntityInstance).GetTAttribute('max_reservoir_mainstem').GetCurrentSample().value;
    tmpCulm := (instance as TEntityInstance).GetTAttribute('tmp_mainstem').GetCurrentSample().value;
    stockCulm := Max(0, Min(maxReservoirOnCulm, tmpCulm));
    SRwriteln('maxReservoirOnMainstem --> ' + FloatToStr(maxReservoirOnCulm));
    SRwriteln('tmpMainstem            --> ' + FloatToStr(tmpCulm));
    SRwriteln('stockMainstem          --> ' + FloatToStr(stockCulm));
    date := (instance as TEntityInstance).GetNextDate();
    sample := (instance as TEntityInstance).GetTAttribute('stock_mainstem').GetSample(date);
    sample.date := date;
    sample.value := stockCulm;
    (instance as TEntityInstance).GetTAttribute('stock_mainstem').SetSample(sample);
    le := (instance as TEntityInstance).LengthTInstanceList();
    for i := 0 to le - 1 do
    begin
      currentInstance := (instance as TEntityInstance).GetTInstance(i);
      if (currentInstance is TEntityInstance) then
      begin
        if ((currentInstance as TEntityInstance).GetCategory() = 'Tiller') then
        begin
          stateTiller := (currentInstance as TEntityInstance).GetCurrentState();
          case stateTiller of
            4, 6, 7, 9, 10 :
            begin
              SRwriteln('Tiller                 --> ' + currentInstance.GetName());
              SRwriteln('state tiller           --> ' + IntToStr(stateTiller));
              maxReservoirOnCulm := (currentInstance as TEntityInstance).GetTAttribute('max_reservoir_tiller').GetCurrentSample().value;
              tmpCulm := (currentInstance as TEntityInstance).GetTAttribute('tmp_tiller').GetCurrentSample().value;
              stockCulm := Max(0, Min(maxReservoirOnCulm, tmpCulm));
              SRwriteln('maxReservoirOnTiller --> ' + FloatToStr(maxReservoirOnCulm));
              SRwriteln('tmpTiller            --> ' + FloatToStr(tmpCulm));
              SRwriteln('stockTiller          --> ' + FloatToStr(stockCulm));
              date := (currentInstance as TEntityInstance).GetNextDate();
              sample := (currentInstance as TEntityInstance).GetTAttribute('stock_tiller').GetSample(date);
              sample.date := date;
              sample.value := stockCulm;
              (currentInstance as TEntityInstance).GetTAttribute('stock_tiller').SetSample(sample);
            end;
          end;
        end;
      end;
    end;
  end;
end;

// -----------------------------------------------------------------------------
// Procedure ComputeAssimCulms_LE
// ------------------------------
//
// Calcule l'assimilation sur les talles
//
// module 'extra'
// -----------------------------------------------------------------------------

procedure ComputeAssimCulms_LE(var instance : TInstance);
var
  stateMeristem, stateTiller, i, le : Integer;
  currentInstance : TInstance;
  currentEntityInstance : TEntityInstance;
  assimPlant, sumOfBladeAreaPlant, sumOfBladeAreaMainstem, sumOfBladeAreaOnCulm, assim_tiller, assim_mainstem : Double;
  sample : TSample;
  assimTillerAttribute, supplyTillerAttribute : TAttribute;
  date : TDateTime;
begin
  stateMeristem := (instance as TEntityInstance).GetCurrentState();
  case stateMeristem of
    4, 5, 6, 8, 9, 10, 11 :
    begin
      SRwriteln('state meristem : ' + IntToStr(stateMeristem));
      assimPlant := ((instance as TEntityInstance).GetTAttribute('assim') as TAttributeTableOut).GetCurrentSample().value;
      sumOfBladeAreaPlant := (instance as TEntityInstance).GetTAttribute('PAI').GetCurrentSample().value;
      sumOfBladeAreaMainstem := (instance as TEntityInstance).GetTAttribute('sumOfBladeAreaOnMainstem').GetCurrentSample().value;
      assim_mainstem := assimPlant * (sumOfBladeAreaMainstem / sumOfBladeAreaPlant);
      date := (instance as TEntityInstance).GetNextDate();
      sample := ((instance as TEntityInstance).GetTAttribute('assim_mainstem') as TAttributeTableOut).GetSample(date);
      sample.date := date;
      sample.value := assim_mainstem;
      ((instance as TEntityInstance).GetTAttribute('assim_mainstem') as TAttributeTableOut).SetSample(sample);
      sample := (instance as TEntityInstance).GetTAttribute('supply_mainstem').GetSample(date);
      sample.date := date;
      sample.value := assim_mainstem;
      (instance as TEntityInstance).GetTAttribute('supply_mainstem').SetSample(sample);
      SRwriteln('assimPlant             --> ' + FloatToStr(assimPlant));
      SRwriteln('sumOfBladeAreaMainstem --> ' + FloatToStr(sumOfBladeAreaMainstem));
      SRwriteln('sumOfBladeAreaPlant    --> ' + FloatToStr(sumOfBladeAreaPlant));
      SRwriteln('assimMainstem          --> ' + FloatToStr(assim_mainstem));
      SRwriteln('supplyMainstem         --> ' + FloatToStr(assim_mainstem));
      le := (instance as TEntityInstance).LengthTInstanceList();
      for i := 0 to le - 1 do
      begin
        currentInstance := (instance as TEntityInstance).GetTInstance(i);
        if (currentInstance is TEntityInstance) then
        begin
          currentEntityInstance := currentInstance as TEntityInstance;
          if (currentEntityInstance.GetCategory() = 'Tiller') then
          begin
            stateTiller := currentEntityInstance.GetCurrentState();
            case stateTiller of
              4, 5, 6, 7, 9, 10 :
              begin
                SRwriteln('Tiller                 --> ' + currentEntityInstance.GetName());
                SRwriteln('state tiller           --> ' + IntToStr(stateTiller));
                sumOfBladeAreaOnCulm := currentEntityInstance.GetTAttribute('sumOfBladeAreaOnTillerInLeaf').GetCurrentSample().value;
                SRwriteln('assimPlant             --> ' + FloatToStr(assimPlant));
                SRwriteln('sumOfBladeAreaOnTiller --> ' + FloatToStr(sumOfBladeAreaOnCulm));
                SRwriteln('sumOfBladeAreaPlant    --> ' + FloatToStr(sumOfBladeAreaPlant));
                assim_tiller := assimPlant * (sumOfBladeAreaOnCulm / sumOfBladeAreaPlant);
                assimTillerAttribute := currentEntityInstance.GetTAttribute('assim_tiller');
                sample := assimTillerAttribute.GetCurrentSample();
                sample.value := assim_tiller;
                assimTillerAttribute.SetSample(sample);
                SRwriteln('assimTiller            --> ' + FloatToStr(assim_tiller));
                supplyTillerAttribute := currentEntityInstance.GetTAttribute('supply_tiller');
                supplyTillerAttribute.SetSample(sample);
                SRwriteln('supplyTiller           --> ' + FloatToStr(sample.value));
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

// -----------------------------------------------------------------------------
// Procedure ComputeAssimTillers_LE
// --------------------------------
//
// Calcule l'assimilation sur les talles
//
// module 'extra'
// -----------------------------------------------------------------------------

procedure ComputeAssimTillers_LE(var instance : TInstance);
var
  stateMeristem, stateTiller, i, le : Integer;
  currentInstance : TInstance;
  currentEntityInstance : TEntityInstance;
  assimPlant, sumOfBladeAreaPlant, sumOfBladeAreaOnCulm, assim_tiller : Double;
  sample : TSample;
  assimTillerAttribute, supplyTillerAttribute : TAttribute;
begin
  stateMeristem := (instance as TEntityInstance).GetCurrentState();
  case stateMeristem of
    4, 5, 6, 8, 9, 10, 11 :
    begin
      SRwriteln('state meristem : ' + IntToStr(stateMeristem));
      assimPlant := ((instance as TEntityInstance).GetTAttribute('assim') as TAttributeTableOut).GetCurrentSample().value;
      sumOfBladeAreaPlant := (instance as TEntityInstance).GetTAttribute('PAI').GetCurrentSample().value;
      le := (instance as TEntityInstance).LengthTInstanceList();
      for i := 0 to le - 1 do
      begin
        currentInstance := (instance as TEntityInstance).GetTInstance(i);
        if (currentInstance is TEntityInstance) then
        begin
          currentEntityInstance := currentInstance as TEntityInstance;
          if (currentEntityInstance.GetCategory() = 'Tiller') then
          begin
            stateTiller := currentEntityInstance.GetCurrentState();
            case stateTiller of
              4, 5, 6, 7, 9 :
              begin
                SRwriteln('Tiller               --> ' + currentEntityInstance.GetName());
                SRwriteln('state tiller         --> ' + IntToStr(stateTiller));
                sumOfBladeAreaOnCulm := currentEntityInstance.GetTAttribute('sumOfBladeAreaOnTillerInLeaf').GetCurrentSample().value;
                SRwriteln('assimPlant           --> ' + FloatToStr(assimPlant));
                SRwriteln('sumOfBladeAreaOnCulm --> ' + FloatToStr(sumOfBladeAreaOnCulm));
                SRwriteln('sumOfBladeAreaPlant  --> ' + FloatToStr(sumOfBladeAreaPlant));
                assim_tiller := assimPlant * (sumOfBladeAreaOnCulm / sumOfBladeAreaPlant);
                assimTillerAttribute := currentEntityInstance.GetTAttribute('assim_tiller');
                sample := assimTillerAttribute.GetCurrentSample();
                sample.value := assim_tiller;
                assimTillerAttribute.SetSample(sample);
                SRwriteln('assimCulm            --> ' + FloatToStr(assim_tiller));
                supplyTillerAttribute := currentEntityInstance.GetTAttribute('supply_tiller');
                supplyTillerAttribute.SetSample(sample);
                SRwriteln('supplyCulm           --> ' + FloatToStr(sample.value));
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

// -----------------------------------------------------------------------------
// Procedure ComputeStockTillers_LE
// --------------------------------
//
// Calcule l'assimilation sur les talles
//
// module 'extra'
// -----------------------------------------------------------------------------

procedure ComputeStockTillers_LE(var instance : TInstance);
var
  stateMeristem, stateTiller, i, le : Integer;
  currentInstance : TInstance;
  currentEntityInstance : TEntityInstance;
  sumOfStockINCulm, stockLeafCulm, reservoirDispoCulm, supplyCulm, stockCulm : Double;
  sample : TSample;
  stockTillerAttribute : TAttributeTableOut;
begin
  stateMeristem := (instance as TEntityInstance).GetCurrentState();
  case stateMeristem of
    4, 5, 6, 8, 9, 10, 11 :
    begin
      SRwriteln('state meristem : ' + IntToStr(stateMeristem));
      le := (instance as TEntityInstance).LengthTInstanceList();
      for i := 0 to le - 1 do
      begin
        currentInstance := (instance as TEntityInstance).GetTInstance(i);
        if (currentInstance is TEntityInstance) then
        begin
          currentEntityInstance := currentInstance as TEntityInstance;
          if (currentEntityInstance.GetCategory() = 'Tiller') then
          begin
            stateTiller := currentEntityInstance.GetCurrentState();
            case stateTiller of
              4, 5, 6, 7, 9 :
              begin
                SRwriteln('Tiller             --> ' + currentEntityInstance.GetName());
                SRwriteln('state tiller       --> ' + IntToStr(stateTiller));
                sumOfStockINCulm := currentEntityInstance.GetTAttribute('sumOfTillerInternodeStock').GetCurrentSample().value;
                stockLeafCulm := currentEntityInstance.GetTAttribute('stockLeafTiller').GetCurrentSample().value;
                reservoirDispoCulm := currentEntityInstance.GetTAttribute('reservoir_dispo_tiller').GetCurrentSample().value;
                supplyCulm := currentEntityInstance.GetTAttribute('supply_tiller').GetCurrentSample().value;
                SRwriteln('sumOfStockINCulm   --> ' + FloatToStr(sumOfStockINCulm));
                SRwriteln('stockLeafCulm      --> ' + FloatToStr(stockLeafCulm));
                SRwriteln('reservoirDispoCulm --> ' + FloatToStr(reservoirDispoCulm));
                SRwriteln('supplyCulm         --> ' + FloatToStr(supplyCulm));
                stockCulm := sumOfStockINCulm + stockLeafCulm + min(reservoirDispoCulm, supplyCulm);
                SRwriteln('stockCulm          --> ' + FloatToStr(stockCulm));
                stockTillerAttribute := (currentEntityInstance.GetTAttribute('stock_tiller') as TAttributeTableOut);
                sample := stockTillerAttribute.GetCurrentSample();
                sample.value := stockCulm;
                stockTillerAttribute.SetSample(sample);
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

// -----------------------------------------------------------------------------
// Procedure ComputeSurplusTillers_LE
// ----------------------------------
//
// Calcule l'assimilation sur les talles
//
// module 'extra'
// -----------------------------------------------------------------------------

procedure ComputeSurplusTillers_LE(var instance : TInstance);
var
  stateMeristem, stateTiller, i, le : Integer;
  currentInstance : TInstance;
  currentEntityInstance : TEntityInstance;
  supplyCulm, reservoirDispoCulm, surplusCulm : Double;
  sample : TSample;
  surplusTillerAttribute : TAttribute;
begin
  stateMeristem := (instance as TEntityInstance).GetCurrentState();
  case stateMeristem of
    4, 5, 6, 8, 9, 10, 11 :
    begin
      SRwriteln('state meristem : ' + IntToStr(stateMeristem));
      le := (instance as TEntityInstance).LengthTInstanceList();
      for i := 0 to le - 1 do
      begin
        currentInstance := (instance as TEntityInstance).GetTInstance(i);
        if (currentInstance is TEntityInstance) then
        begin
          currentEntityInstance := currentInstance as TEntityInstance;
          if (currentEntityInstance.GetCategory() = 'Tiller') then
          begin
            stateTiller := currentEntityInstance.GetCurrentState();
            case stateTiller of
              4, 5, 6, 7, 9 :
              begin
                SRwriteln('Tiller             --> ' + currentEntityInstance.GetName());
                SRwriteln('state tiller       --> ' + IntToStr(stateTiller));
                supplyCulm := currentEntityInstance.GetTAttribute('supply_tiller').GetCurrentSample().value;
                reservoirDispoCulm := currentEntityInstance.GetTAttribute('reservoir_dispo_tiller').GetCurrentSample().value;
                SRwriteln('supplyCulm         --> ' + FloatToStr(supplyCulm));
                SRwriteln('reservoirDispoCulm --> ' + FloatToStr(reservoirDispoCulm));
                surplusCulm := max(0, supplyCulm - reservoirDispoCulm);
                SRwriteln('surplusCulm        --> ' + FloatToStr(surplusCulm));
                surplusTillerAttribute := currentEntityInstance.GetTAttribute('surplus_tiller');
                sample := surplusTillerAttribute.GetCurrentSample();
                sample.value := surplusCulm;
                surplusTillerAttribute.SetSample(sample);
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

// -----------------------------------------------------------------------------
// Procedure ComputeLastDemandCulms_LE
// -----------------------------------
//
// Calcule la somme des lastDemand sur les axes et fait la somme
//
// module 'extra'
// -----------------------------------------------------------------------------

procedure ComputeLastDemandCulms_LE(var instance : TInstance);
var
  i, le : Integer;
  stateMeristem : Integer;
  currentInstance : TInstance;
  entityMainstemContribution, entityTillerContribution : Double;
  sample : TSample;
  lastDemandMainstem, lastDemandTillers : Double;
begin
  stateMeristem := (instance as TEntityInstance).GetCurrentState();
  if (stateMeristem >= 4) then
  begin
    // on commence par le brin maitre
    lastDemandMainstem := 0;
    lastDemandTillers := 0;
    le := (instance as TEntityInstance).LengthTInstanceList();
    case stateMeristem of
      4, 5, 6, 9 :
      begin
        for i := 0 to le - 1 do
        begin
          currentInstance := (instance as TEntityInstance).GetTInstance(i);
          if (currentInstance is TEntityInstance) then
          begin
            if ( ((currentInstance as TEntityInstance).GetTAttribute('lastdemand') <> nil) and
                 (((currentInstance as TEntityInstance).GetCategory() = 'Leaf') or
                 ((currentInstance as TEntityInstance).GetCategory() = 'Internode') or
                 ((currentInstance as TEntityInstance).GetCategory() = 'Peduncle'))
               ) then
            begin
              entityMainstemContribution := (currentInstance as TEntityInstance).GetTAttribute('lastdemand').GetCurrentSample().value;
              SRwriteln('contribution de : ' + currentInstance.GetName() + ' = ' + FloatToStr(entityMainstemContribution));
              lastDemandMainstem := lastDemandMainstem + entityMainstemContribution;
            end
            else
            begin
              if ((currentInstance as TEntityInstance).GetCategory() = 'Tiller') then
              begin
                if ((currentInstance as TEntityInstance).GetTAttribute('last_demand_tiller') <> nil) then
                begin
                  entityTillerContribution := (currentInstance as TEntityInstance).GetTAttribute('last_demand_tiller').GetCurrentSample().value;
                  SRwriteln('contribution de : ' + currentInstance.GetName() + ' = ' + FloatToStr(entityTillerContribution));
                  lastDemandTillers := lastDemandTillers + entityTillerContribution;
                end;
              end;
            end;
          end;
        end;
        sample := (instance as TEntityInstance).GetTAttribute('lastDemandMainstem').GetCurrentSample();
        sample.value := lastDemandMainstem;
        (instance as TEntityInstance).GetTAttribute('lastDemandMainstem').SetSample(sample);
        SRwriteln('lastDemandMainstem : ' + FloatToStr(lastDemandMainstem));
        sample := (instance as TEntityInstance).GetTAttribute('lastDemandTillers').GetCurrentSample();
        sample.value := lastDemandTillers;
        (instance as TEntityInstance).GetTAttribute('lastDemandTillers').SetSample(sample);
        SRwriteln('lastDemandTillers : ' + FloatToStr(lastDemandTillers));
        sample := ((instance as TEntityInstance).GetTAttribute('lastDemand') as TAttributeTableOut).GetCurrentSample();
        sample.value := lastDemandMainstem + lastDemandTillers;
        (instance as TEntityInstance).GetTAttribute('lastDemand').SetSample(sample);
        SRwriteln('lastDemand : ' + FloatToStr(lastDemandMainstem + lastDemandTillers));
      end
      else
      begin
        if ((instance as TEntityInstance).GetTAttribute('lastDemandMainstem') <> nil) then
        begin
          sample := (instance as TEntityInstance).GetTAttribute('lastDemandMainstem').GetCurrentSample();
          sample.value := 0;
          (instance as TEntityInstance).GetTAttribute('lastDemandMainstem').SetSample(sample);
          SRwriteln('lastDemandMainstem : ' + FloatToStr(sample.value));
        end;
        if ((instance as TEntityInstance).GetTAttribute('lastDemandTillers') <> nil) then
        begin
          sample := (instance as TEntityInstance).GetTAttribute('lastDemandTillers').GetCurrentSample();
          sample.value := 0;
          (instance as TEntityInstance).GetTAttribute('lastDemandTillers').SetSample(sample);
          SRwriteln('lastDemandTillers : ' + FloatToStr(sample.value));
        end;
        sample := ((instance as TEntityInstance).GetTAttribute('lastDemand') as TAttributeTableOut).GetCurrentSample();
        sample.value := 0;
        (instance as TEntityInstance).GetTAttribute('lastDemand').SetSample(sample);
        SRwriteln('lastDemand : ' + FloatToStr(sample.value));
      end;
    end;
  end;
end;

// -----------------------------------------------------------------------------
// Procedure ComputeMaxReservoirCulms_LE
// -------------------------------------
//
// Calcule le reservoir max de la plante de la plante
//
// module 'extra'
// -----------------------------------------------------------------------------

procedure ComputeMaxReservoirCulms_LE(var instance : TInstance);
var
  stateMeristem, stateTiller, i, le : Integer;
  MaxReservoirOnCulm, leafStockMax, maximumReserveInInternode, sumOfCulmInternodeBiomass, sumOfCulmLeafBiomass : Double;
  sample : TSample;
  currentInstance : TInstance;
begin
  stateMeristem := (instance as TEntityInstance).GetCurrentState();
  case stateMeristem of
    4, 5, 6, 9 :
    begin
      SRwriteln('state meristem : ' + IntToStr(stateMeristem));
      // on commence par calculer MaxReservoir sur le brin maitre
      maximumReserveInInternode := (instance as TEntityInstance).GetTAttribute('maximumReserveInInternode').GetCurrentSample().value;
      sumOfCulmInternodeBiomass := (instance as TEntityInstance).GetTAttribute('sumOfMainstemInternodeBiomass').GetCurrentSample().value;
      leafStockMax := (instance as TEntityInstance).GetTAttribute('leaf_stock_max').GetCurrentSample().value;
      sumOfCulmLeafBiomass := (instance as TEntityInstance).GetTAttribute('sumOfMainstemLeafBiomass').GetCurrentSample().value;
      MaxReservoirOnCulm := maximumReserveInInternode * sumOfCulmInternodeBiomass + leafStockMax * sumOfCulmLeafBiomass;
      sample := (instance as TEntityInstance).GetTAttribute('max_reservoir_mainstem').GetCurrentSample();
      sample.value := MaxReservoirOnCulm;
      (instance as TEntityInstance).GetTAttribute('max_reservoir_mainstem').SetSample(sample);
      SRwriteln('maximumReserveInInternode     --> ' + FloatToStr(maximumReserveInInternode));
      SRwriteln('sumOfMainstemInternodeBiomass --> ' + FloatToStr(sumOfCulmInternodeBiomass));
      SRwriteln('leafStockMax                  --> ' + FloatToStr(leafStockMax));
      SRwriteln('sumOfMainstemLeafBiomass      --> ' + FloatToStr(sumOfCulmLeafBiomass));
      SRwriteln('MaxReservoirOnMainstem        --> ' + FloatToStr(MaxReservoirOnCulm));
      // maintenant on passe aux talles
      le := (instance as TEntityInstance).LengthTInstanceList();
      for i := 0 to le - 1 do
      begin
        currentInstance := (instance as TEntityInstance).GetTInstance(i);
        if (currentInstance is TEntityInstance) then
        begin
          if ((currentInstance as TEntityInstance).GetCategory() = 'Tiller') then
          begin
            stateTiller := (currentInstance as TEntityInstance).GetCurrentState();
            SRwriteln('Tiller : ' + currentInstance.GetName());
            SRwriteln('state tiller : ' + IntToStr(stateTiller));
            case stateTiller of
              4, 5, 6, 7, 9, 10 :
              begin
                maximumReserveInInternode := (instance as TEntityInstance).GetTAttribute('maximumReserveInInternode').GetCurrentSample().value;
                sumOfCulmInternodeBiomass := (currentInstance as TEntityInstance).GetTAttribute('sumOfTillerInternodeBiomass').GetCurrentSample().value;
                leafStockMax := (currentInstance as TEntityInstance).GetTAttribute('leafStockMax').GetCurrentSample().value;
                sumOfCulmLeafBiomass := (currentInstance as TEntityInstance).GetTAttribute('sumOfTillerLeafBiomass').GetCurrentSample().value;
                MaxReservoirOnCulm := maximumReserveInInternode * sumOfCulmInternodeBiomass + leafStockMax * sumOfCulmLeafBiomass;
                sample := (currentInstance as TEntityInstance).GetTAttribute('max_reservoir_tiller').GetCurrentSample();
                sample.value := MaxReservoirOnCulm;
                (currentInstance as TEntityInstance).GetTAttribute('max_reservoir_tiller').SetSample(sample);
                SRwriteln('maximumReserveInInternode   --> ' + FloatToStr(maximumReserveInInternode));
                SRwriteln('sumOfTillerInternodeBiomass --> ' + FloatToStr(sumOfCulmInternodeBiomass));
                SRwriteln('leafStockMax                --> ' + FloatToStr(leafStockMax));
                SRwriteln('sumOftillerLeafBiomass      --> ' + FloatToStr(sumOfCulmLeafBiomass));
                SRwriteln('MaxReservoirOnTiller        --> ' + FloatToStr(MaxReservoirOnCulm));
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

// ----------------------------------------------------------------------------
// procedure UpdateRootDemand_LE
// -----------------------------
//
//   Mise à jour de la biomasse s'il reste du surplus
//   Executee seulement à PI
//
//   Equation : rootBiomass = rootBiomass + min(rootDemand, surplusPlant)
//              surplusPlant = surplusPlant - min(rootDemand, surplusPlant)
//
// ----------------------------------------------------------------------------

procedure UpdateRootDemand_LE(var rootDemand, surplusPlant : Double);
begin
  SRwriteln('rootDemand (avant)  --> ' + FloatToStr(rootDemand));
  rootDemand := Min(rootDemand, surplusPlant);
  SRwriteln('rootDemand (apres)  --> ' + FloatToStr(rootDemand));
  SRwriteln('surplusPlant avant --> ' + FloatToStr(surplusPlant));
  surplusPlant := surPlusPlant - rootDemand;
  SRwriteln('surplusPlant apres --> ' + FloatToStr(surplusPlant));
end;

// ----------------------------------------------------------------------------
// procedure ComputePanicleGrainNb_LE
// ----------------------------------
//
// Calcule le nombre de grain sur la panicule
//
// Equation : grainNb = grainNb + grainCreationRate * DD * fcstr * testIc
//
// ----------------------------------------------------------------------------

procedure ComputePanicleGrainNb_LE(const spikeCreationRate, Tair, Tb, fcstr, testIc : Double; var grainNb : Double);
begin
  SRwriteln('grainNb           --> ' + FloatToStr(grainNb));
  grainNb := grainNb + (spikeCreationRate * (Tair - Tb) * fcstr * testIc);
  SRwriteln('spikeCreationRate --> ' + FloatToStr(spikeCreationRate));
  SRwriteln('Tair              --> ' + FloatToStr(Tair));
  SRwriteln('Tb                --> ' + FloatToStr(Tb));
  SRwriteln('fcstr             --> ' + FLoatToStr(fcstr));
  SRwriteln('testIc            --> ' + FloatToStr(testIc));
  SRwriteln('grainNb           --> ' + FloatToStr(grainNb));
end;

// ----------------------------------------------------------------------------
// procedure ComputePanicleFertileGrainNumber_LE
// ---------------------------------------------
//
// Calcule le nombre de grain fertile sur la panicle lors du passage à FLORAISON
//
// Equation : fertileGrainNumber = fertileGrainNumber * fcstr * testIc
//
// ----------------------------------------------------------------------------

procedure ComputePanicleFertileGrainNumber_LE(const fcstr, testIc : Double; var fertileGrainNumber : Double);
begin
  SRwriteln('fertileGrainNumber --> ' + FloatToStr(fertileGrainNumber));
  fertileGrainNumber := fertileGrainNumber * fcstr * testIc;
  SRwriteln('fcstr              --> ' + FloatToStr(fcstr));
  SRwriteln('testIc             --> ' + FloatToStr(testIc));
  SRwriteln('fertileGrainNumber --> ' + FloatToStr(fertileGrainNumber));
end;

// ----------------------------------------------------------------------------
// procedure ComputePanicleDayDemandFlo_LE
// ---------------------------------------
//
// Calcule le day demand de la panicle lorsque qu'elle est passée à FLORAISON
//
// Equation : panicleDayDemand = fillingRate * DD * fcstr * testIc
//
// ----------------------------------------------------------------------------

procedure ComputePanicleDayDemandFlo_LE(const fillingRate, Tair, Tb, fcstr, testIc : Double; var panicleDayDemand : Double);
begin
  SRwriteln('Debut ComputePanicleDayDemandFlo_LE');
  panicleDayDemand := fillingRate * (Tair - Tb) * fcstr * testIc;
  SRwriteln('fillingRate      --> ' + FloatToStr(fillingRate));
  SRwriteln('Tair             --> ' + FloatToStr(Tair));
  SRwriteln('Tb               --> ' + FloatToStr(Tb));
  SRwriteln('fcstr            --> ' + FloatToStr(fcstr));
  SRwriteln('testIc           --> ' + FloatToStr(testIc));
  SRwriteln('panicleDayDemand --> ' + FloatToStr(panicleDayDemand));
end;

// ----------------------------------------------------------------------------
// procedure ComputePanicleWeightFlo_LE
// ------------------------------------
//
// Calcule le weight de la panicle lorsqu'elle est passé à FLORAISON
//
// Equation : panicleWeight = gdwEmpty * grainNb + panicleDayDemand
//
// ----------------------------------------------------------------------------

procedure ComputePanicleWeightFlo_LE(const gdwEmpty, grainNb, panicleDayDemand : Double; var firstDayOfFLO, panicleWeight : Double);
begin
  if (firstDayOfFLO = 1) then
  begin
    panicleWeight := gdwEmpty * grainNb + panicleDayDemand;
    firstDayOfFLO := 0;
    SRwriteln('gdwEmpty         --> ' + FloatToStr(gdwEmpty));
    SRwriteln('grainNb          --> ' + FloatToStr(grainNb));
    SRwriteln('panicleDayDemand --> ' + FloatToStr(panicleDayDemand));
    SRwriteln('panicleWeight    --> ' + FloatToStr(panicleWeight));
  end
  else
  begin
    SRwriteln('AVANT');
    SRwriteln('-----');
    SRwriteln('panicleWeight    --> ' + FloatToStr(panicleWeight));
    panicleWeight := panicleWeight + panicleDayDemand;
    SRwriteln('APRES');
    SRwriteln('-----');
    SRwriteln('panicleDayDemand --> ' + FloatToStr(panicleDayDemand));
    SRwriteln('panicleWeight    --> ' + FloatToStr(panicleWeight));

  end;

end;

// ----------------------------------------------------------------------------
// procedure ComputePanicleFilledGrainNbFlo_LE
// -------------------------------------------
//
// Calcule le nombre de grains remplis de la panicle lorsqu'elle est passée
// à FLORAISON
//
// Equation : filledGrainNb = fertileGrainNb * panicleWeight / (fertileGrainNb * gdw)
//
// ----------------------------------------------------------------------------

procedure ComputePanicleFilledGrainNbFlo_LE(const fertileGrainNb, panicleWeight, gdw : Double; var filledGrainNb : Double);
begin
  filledGrainNb := fertileGrainNb * panicleWeight / (fertileGrainNb * gdw);
  SRwriteln('fertileGrainNb --> ' + FloatToStr(fertileGrainNb));
  SRwriteln('panicleWeight  --> ' + FloatToStr(panicleWeight));
  SRwriteln('gdw            --> ' + FloatToStr(gdw));
  SRwriteln('filledGrainNb  --> ' + FloatToStr(filledGrainNb));
end;

// ----------------------------------------------------------------------------
// procedure ComputeStockLeafCulm_LE
// ---------------------------------
//
//  à PI, on calcule le stock relatif aux feuilles
//
// Equation : stockLeafCulm := min(leafStockMax * sumOfBiomassInLeafCulm, sumOfCulmDemandIN - sumOfCulmStockIN)
//
// ----------------------------------------------------------------------------

procedure ComputeStockLeafCulm_LE(const leafStockMax, sumOfBiomassInLeafCulm, stockCulm, sumOfCulmDemandIN, sumOfCulmStockIN : Double; var stockLeafCulm : Double);
begin
  //stockLeafCulm := min(leafStockMax * sumOfBiomassInLeafCulm, stockCulm - sumOfCulmDemandIN - sumOfCulmStockIN);
  stockLeafCulm := min(leafStockMax * sumOfBiomassInLeafCulm, stockCulm - sumOfCulmStockIN);
  SRwriteln('leafStockMax           --> ' + FloatToStr(leafStockMax));
  SRwriteln('sumOfBiomassInLeafCulm --> ' + FloatToStr(sumOfBiomassInLeafCulm));
  SRwriteln('stockCulm              --> ' + FloatToStr(stockCulm));
  SRwriteln('sumOfCulmDemandIN      --> ' + FloatToStr(sumOfCulmDemandIN));
  SRwriteln('sumOfCulmStockIN       --> ' + FloatToStr(sumOfCulmStockIN));
  SRwriteln('stockLeafCulm          --> ' + FloatToStr(stockLeafCulm));
end;

procedure ComputeStockLeafCulm2_LE(const leafStockMax, sumOfBiomassInLeafCulm, stockCulm, sumOfCulmStockIN, sumOfCulmDecifitIN, sumOfCulmDemandNonIN, sumOfCulmLastDemand, sumOfCulmDemandIN : Double; var stockLeafCulm : Double);
begin
  stockLeafCulm := min(leafStockMax * sumOfBiomassInLeafCulm, stockCulm - sumOfCulmStockIN + sumOfCulmDecifitIN - (sumOfCulmDemandNonIN + sumOfCulmLastDemand + sumOfCulmDemandIN));
  SRwriteln('leafStockMax           --> ' + FloatToStr(leafStockMax));
  SRwriteln('sumOfBiomassInLeafCulm --> ' + FloatToStr(sumOfBiomassInLeafCulm));
  SRwriteln('stockCulm              --> ' + FloatToStr(stockCulm));
  SRwriteln('sumOfCulmStockIN       --> ' + FloatToStr(sumOfCulmStockIN));
  SRwriteln('sumOfCulmDecifitIN     --> ' + FloatToStr(sumOfCulmDecifitIN));
  SRwriteln('sumOfCulmDemandNonIN   --> ' + FloatToStr(sumOfCulmDemandNonIN));
  SRwriteln('sumOfCulmLastDemand    --> ' + FloatToStr(sumOfCulmLastDemand));
  SRwriteln('sumOfCulmDemandIN      --> ' + FloatToStr(sumOfCulmDemandIN));
  SRwriteln('stockLeafCulm          --> ' + FloatToStr(stockLeafCulm));
end;

// ----------------------------------------------------------------------------
// procedure ComputeReservoirDispoLeafCulm_LE
// ------------------------------------------
//
// à PI, calcule le reservoirDispo relatif aux feuilles
//
// Equation : reservoirDispoLeafCulm := max(0, leafStockMax * sumOfBiomassInLeafCulm - stockLeafCulm)
//
// ----------------------------------------------------------------------------

procedure ComputeReservoirDispoLeafCulm_LE(const leafStockMax, sumOfBiomassInLeafCulm, stockLeafCulm : Double; var reservoirDispoLeafCulm : Double);
begin
  reservoirDispoLeafCulm := max(0, leafStockMax * sumOfBiomassInLeafCulm - stockLeafCulm);
  SRwriteln('leafStockMax           --> ' + FloatToStr(leafStockMax));
  SRwriteln('sumOfBiomassInLeafCulm --> ' + FloatToStr(sumOfBiomassInLeafCulm));
  SRwriteln('stockLeafCulm          --> ' + FloatToStr(stockLeafCulm));
  SRwriteln('reservoirDispoLeafCulm --> ' + FloatToStr(reservoirDispoLeafCulm));
end;

// ----------------------------------------------------------------------------
// procedure ComputeCGRStress_LE
// -----------------------------
//
// Compute the crop growth rate during stress period
//
//
// Equation :
//     CGRStress = biomAero2(dayStressOnSet) - biomAero2(dayEndSimul) / TT(dayStressOnSet) - TT(dayEndSimul)
//
// ----------------------------------------------------------------------------

procedure ComputeCGRStress_LE(const BoolSwitch, BiomAero2, TT : Double; var BiomAero2StressOnSet, TTStressOnSet, CGRStress : Double);
begin
  SRwriteln('BoolSwitch --> ' + FloatToStr(BoolSwitch));
  if (BoolSwitch > 0) then
  begin
    SRWriteln('Pas encore de stress');
    CGRStress := 0;
  end
  else
  begin
    if (BiomAero2StressOnSet = -1) and (TTStressOnSet = -1) then
    begin
      BiomAero2StressOnSet := BiomAero2;
      TTStressOnSet := TT;
      SRwriteln('Activation du stress, on sauvegarde BiomAero2StressOnSet = ' +
                FloatToStr(BiomAero2StressOnSet) +
                ' et TTStressOnSet = ' +
                FloatToStr(TTStressOnSet));
      CGRStress := 0;
    end
    else
    begin
      SRwriteln('BiomAero2StressOnSet --> ' + FloatToStr(BiomAero2StressOnSet));
      SRwriteln('BiomAero2            --> ' + FloatToStr(BiomAero2));
      SRwriteln('TTStressOnSet        --> ' + FloatToStr(TTStressOnSet));
      SRwriteln('TT                   --> ' + FloatToStr(TT));
      CGRStress := (BiomAero2StressOnSet - BiomAero2) / (TTStressOnSet - TT);
      SRwriteln('CGRStress            --> ' + FloatToStr(CGRStress));
    end;
  end;
end;

// ----------------------------------------------------------------------------
// procedure SaveTableData_LE
// --------------------------
//
// At the end of the simulation, save all the data as a csv with different
// culms and their values (biomass, stock, length, panicle weight, ...)
//
// module extra
// ----------------------------------------------------------------------------

procedure ComputeMaxNumberOfLeaf(var instance : TInstance; var number : Integer);
var
  i, le : Integer;
  currentInstance : TInstance;
  nbLeaf : Integer;
begin
  number := 0;
  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to (le - 1) do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      if ((currentInstance as TEntityInstance).GetCategory() = 'Leaf') then
      begin
        number := number + 1;
      end;
      if ((currentInstance as TEntityInstance).GetCategory() = 'Tiller') then
      begin
        ComputeMaxNumberOfLeaf(currentInstance, nbLeaf);
        if (nbLeaf > number) then
        begin
          number := nbLeaf;
        end;
      end;
    end;
  end;
end;

procedure ComputeMinMaxNumberOfInternode(var instance : TInstance; var min, max : Integer);
var
  i, le : Integer;
  currentInstance : TInstance;
  myMin, myMax : Integer;
  underscorePos : Integer;
  name : String;
begin
  min := 999999;
  max := -99999;
  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to (le - 1) do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      if ((currentInstance as TEntityInstance).GetCategory() = 'Internode')then
      begin
        name := (currentInstance as TEntityInstance).GetName();
        if (AnsiContainsStr(name, 'T')) then
        begin // on est sur une talle
          underscorePos := AnsiPos('_', name);
          Delete(name, underscorePos, Length(name) - underscorePos + 1);
        end;
        Delete(name, 1, 2);
        if (StrToInt(name) < min) then
          min := StrToInt(name);
        if (StrToInt(name) > max) then
          max := StrToInt(name);
      end;
      if ((currentInstance as TEntityInstance).GetCategory() = 'Tiller') then
      begin
        ComputeMinMaxNumberOfInternode(currentInstance, myMin, myMax);
        if (myMin < min) then
          min := myMin;
        if (myMax > max) then
          max := myMax;
      end;
    end;
  end;
end;

procedure ComputeNbPanicle(var instance : TInstance; var number : Integer);
var
  i, le : Integer;
  currentInstance : TInstance;
  nbPanicle : Integer;
begin
  number := 0;
  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to (le - 1) do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      if ((currentInstance as TEntityInstance).GetCategory() = 'Panicle') then
      begin
        number := number + 1;
      end;
      if ((currentInstance as TEntityInstance).GetCategory() = 'Tiller') then
      begin
        ComputeNbPanicle(currentInstance, nbPanicle);
        number := number + nbPanicle;
      end;
    end;
  end;
end;

procedure ComputeNbPeduncle(var instance : TInstance; var number : Integer);
var
  i, le : Integer;
  currentInstance : TInstance;
  nbPanicle : Integer;
begin
  number := 0;
  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to (le - 1) do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      if ((currentInstance as TEntityInstance).GetCategory() = 'Peduncle') then
      begin
        number := number + 1;
      end;
      if ((currentInstance as TEntityInstance).GetCategory() = 'Tiller') then
      begin
        ComputeNbPanicle(currentInstance, nbPanicle);
        number := number + nbPanicle;
      end;
    end;
  end;
end;

procedure PutValueInGrid(var grid : TArrayOfArrayOfString; const culmPos : Integer; const nbRow, nbLine : Integer; const organName, attributeName : String; const value : Double);
var
  i : Integer;
  find : Boolean;
  realOrganName : String;
begin
  if (attributeName = 'stock') then
  begin
    grid[1, culmPos + 3] := FloatToStr(value);
  end
  else
  begin
    find := false;
    i := 0;
    while (i < (nbLine)) and (not find) do
    begin
      realOrganName := grid[i, 1] + grid[i,2];
      if ((realOrganName = organName) and (grid[i, 0] = attributeName)) then
      begin
        find := true;
      end
      else
      begin
        i := i + 1;
      end;
    end;
    if find and (i < nbLine)then
    begin
      grid[i, culmPos + 3] := FloatToStr(value);
    end
    else
    begin
      SRwriteln('Pas trouve');
    end;
  end;
end;

procedure FillGrid(var instance : TInstance; var grid : TArrayOfArrayOfString; const nbRow, nbLine : Integer);
var
  i1, i2, le1, le2, culmPos, underscorePos : Integer;
  currentInstance1, currentInstance2 : TInstance;
  currentTEntityInstance1, currentTEntityInstance2 : TEntityInstance;
  culmName, name : String;
  value : Double;
begin
  culmPos := 0;
  value := ((instance as TEntityInstance).GetTAttribute('stock_mainstem') as TAttributeTableOut).GetCurrentSample().value;
  PutValueInGrid(grid, culmPos, nbRow, nbLine, '', 'stock', value);
  le1 := (instance as TEntityInstance).LengthTInstanceList();
  for i1 := 0 to (le1 - 1) do
  begin
    currentInstance1 := (instance as TEntityInstance).GetTInstance(i1);
    if (currentInstance1 is TEntityInstance) then
    begin
      currentTEntityInstance1 := (currentInstance1 as TEntityInstance);
      if (currentTEntityInstance1.GetCategory() = 'Tiller') then
      begin
        culmName := currentTEntityInstance1.GetName();
        Delete(culmName, 1, 2);
        culmPos := StrToInt(culmName);
        value := (currentTEntityInstance1.GetTAttribute('stock_tiller') as TAttributeTableOut).GetCurrentSample().value;
        PutValueInGrid(grid, culmPos, nbRow, nbLine, '', 'stock', value);
        le2 := currentTEntityInstance1.LengthTInstanceList();
        for i2 := 0 to (le2 - 1) do
        begin
          currentInstance2 := currentTEntityInstance1.GetTInstance(i2);
          if (currentInstance2 is TEntityInstance) then
          begin
            currentTEntityInstance2 := (currentInstance2 as TEntityInstance);
            if (currentTEntityInstance2.GetCategory() = 'Leaf') then
            begin
              name := currentTEntityInstance2.GetName();
              underscorePos := AnsiPos('_', name);
              Delete(name, underscorePos, Length(name) - underscorePos + 1);
              value := currentTEntityInstance2.GetTAttribute('width').GetCurrentSample().value;
              PutValueInGrid(grid, culmPos, nbRow, nbLine, name, 'width', value);
              value := currentTEntityInstance2.GetTAttribute('bladeArea').GetCurrentSample().value;
              PutValueInGrid(grid, culmPos, nbRow, nbLine, name, 'bladeArea', value);
              value := currentTEntityInstance2.GetTAttribute('biomass').GetCurrentSample().value;
              PutValueInGrid(grid, culmPos, nbRow, nbLine, name, 'biomass', value);
              value := currentTEntityInstance2.GetTAttribute('len').GetCurrentSample().value;
              PutValueInGrid(grid, culmPos, nbRow, nbLine, name, 'length', value);
            end;
            if (currentTEntityInstance2.GetCategory() = 'Internode') then
            begin
              name := currentTEntityInstance2.GetName();
              underscorePos := AnsiPos('_', name);
              Delete(name, underscorePos, Length(name) - underscorePos + 1);
              value := currentTEntityInstance2.GetTAttribute('biomassIN').GetCurrentSample().value;
              PutValueInGrid(grid, culmPos, nbRow, nbLine, name, 'biomass', value);
              value := currentTEntityInstance2.GetTAttribute('LIN').GetCurrentSample().value;
              PutValueInGrid(grid, culmPos, nbRow, nbLine, name, 'length', value);
              value := currentTEntityInstance2.GetTAttribute('DIN').GetCurrentSample().value;
              PutValueInGrid(grid, culmPos, nbRow, nbLine, name, 'diameter', value);
            end;
            if (currentTEntityInstance2.GetCategory() = 'Panicle') then
            begin
              name := currentTEntityInstance2.GetName();
              underscorePos := AnsiPos('_', name);
              Delete(name, underscorePos, Length(name) - underscorePos + 1);
              value := currentTEntityInstance2.GetTAttribute('grain_nb').GetCurrentSample().value;
              PutValueInGrid(grid, culmPos, nbRow, nbLine, name, 'grainNb', value);
              value := currentTEntityInstance2.GetTAttribute('fertile_grain_number').GetCurrentSample().value;
              PutValueInGrid(grid, culmPos, nbRow, nbLine, name, 'fertileGrainNb', value);
              value := currentTEntityInstance2.GetTAttribute('filled_grain_nb').GetCurrentSample().value;
              PutValueInGrid(grid, culmPos, nbRow, nbLine, name, 'filledGrainNb', value);
              value := currentTEntityInstance2.GetTAttribute('height_panicle').GetCurrentSample().value;
              PutValueInGrid(grid, culmPos, nbRow, nbLine, name, 'height', value);
              value := currentTEntityInstance2.GetTAttribute('weight_panicle').GetCurrentSample().value;
              PutValueInGrid(grid, culmPos, nbRow, nbLine, name, 'weight', value);
              value := currentTEntityInstance2.GetTAttribute('length_panicle').GetCurrentSample().value;
              PutValueInGrid(grid, culmPos, nbRow, nbLine, name, 'length', value);
            end;
            if (currentTEntityInstance2.GetCategory() = 'Peduncle') then
            begin
              name := currentTEntityInstance2.GetName();
              underscorePos := AnsiPos('_', name);
              Delete(name, underscorePos, Length(name) - underscorePos + 1);
              value := currentTEntityInstance2.GetTAttribute('biomassIN').GetCurrentSample().value;
              PutValueInGrid(grid, culmPos, nbRow, nbLine, name, 'biomass', value);
              value := currentTEntityInstance2.GetTAttribute('LIN').GetCurrentSample().value;
              PutValueInGrid(grid, culmPos, nbRow, nbLine, name, 'length', value);
              value := currentTEntityInstance2.GetTAttribute('DIN').GetCurrentSample().value;
              PutValueInGrid(grid, culmPos, nbRow, nbLine, name, 'diameter', value);
            end;
          end;
        end;
      end;
      culmPos := 0;
      if (currentTEntityInstance1.GetCategory() = 'Leaf') then
      begin
        name := currentTEntityInstance1.GetName();
        value := currentTEntityInstance1.GetTAttribute('width').GetCurrentSample().value;
        PutValueInGrid(grid, culmPos, nbRow, nbLine, name, 'width', value);
        value := currentTEntityInstance1.GetTAttribute('bladeArea').GetCurrentSample().value;
        PutValueInGrid(grid, culmPos, nbRow, nbLine, name, 'bladeArea', value);
        value := currentTEntityInstance1.GetTAttribute('biomass').GetCurrentSample().value;
        PutValueInGrid(grid, culmPos, nbRow, nbLine, name, 'biomass', value);
        value := currentTEntityInstance1.GetTAttribute('len').GetCurrentSample().value;
        PutValueInGrid(grid, culmPos, nbRow, nbLine, name, 'length', value);
      end;
      if (currentTEntityInstance1.GetCategory() = 'Internode') then
      begin
        name := currentTEntityInstance1.GetName();
        value := currentTEntityInstance1.GetTAttribute('biomassIN').GetCurrentSample().value;
        PutValueInGrid(grid, culmPos, nbRow, nbLine, name, 'biomass', value);
        value := currentTEntityInstance1.GetTAttribute('LIN').GetCurrentSample().value;
        PutValueInGrid(grid, culmPos, nbRow, nbLine, name, 'length', value);
        value := currentTEntityInstance1.GetTAttribute('DIN').GetCurrentSample().value;
        PutValueInGrid(grid, culmPos, nbRow, nbLine, name, 'diameter', value);
      end;
      if (currentTEntityInstance1.GetCategory() = 'Panicle') then
      begin
        name := currentTEntityInstance1.GetName();
        value := currentTEntityInstance1.GetTAttribute('grain_nb').GetCurrentSample().value;
        PutValueInGrid(grid, culmPos, nbRow, nbLine, name, 'grainNb', value);
        value := currentTEntityInstance1.GetTAttribute('fertile_grain_number').GetCurrentSample().value;
        PutValueInGrid(grid, culmPos, nbRow, nbLine, name, 'fertileGrainNb', value);
        value := currentTEntityInstance1.GetTAttribute('filled_grain_nb').GetCurrentSample().value;
        PutValueInGrid(grid, culmPos, nbRow, nbLine, name, 'filledGrainNb', value);
        value := currentTEntityInstance1.GetTAttribute('height_panicle').GetCurrentSample().value;
        PutValueInGrid(grid, culmPos, nbRow, nbLine, name, 'height', value);
        value := currentTEntityInstance1.GetTAttribute('weight_panicle').GetCurrentSample().value;
        PutValueInGrid(grid, culmPos, nbRow, nbLine, name, 'weight', value);
        value := currentTEntityInstance1.GetTAttribute('length_panicle').GetCurrentSample().value;
        PutValueInGrid(grid, culmPos, nbRow, nbLine, name, 'length', value);
      end;
      if (currentTEntityInstance1.GetCategory() = 'Peduncle') then
      begin
        name := currentTEntityInstance1.GetName();
        value := currentTEntityInstance1.GetTAttribute('biomassIN').GetCurrentSample().value;
        PutValueInGrid(grid, culmPos, nbRow, nbLine, name, 'biomass', value);
        value := currentTEntityInstance1.GetTAttribute('LIN').GetCurrentSample().value;
        PutValueInGrid(grid, culmPos, nbRow, nbLine, name, 'length', value);
        value := currentTEntityInstance1.GetTAttribute('DIN').GetCurrentSample().value;
        PutValueInGrid(grid, culmPos, nbRow, nbLine, name, 'diameter', value);
      end;
    end;
  end;
end;

procedure SaveTableData_LE(var instance : TInstance);
const
  fileName = 'aggregatedData_out';
  extension = 'txt';
  dot = '.';
  separator = '\';
  nbAttributeForLeaf = 4;
  nbAttributeForInternode = 3;
  nbAttributeForPanicle = 6;
  nbAttributeForPeduncle = 3;
  baseNameTiller = 'T';
  baseNameLeaf = 'L';
  baseNameInternode = 'IN';
  baseNamePanicle = 'Pan';
  baseNamePeduncle = 'Ped';
var
  father : TInstance;
  endingDate : TDateTime;
  currentDate : TDateTime;
  path, line : String;
  pFile : TextFile;
  minInternodeName, maxInternodeName : Integer;
  nbLeafMax, nbTiller, nbInternode, nbPanicle, nbPeduncle : Integer;
  nbLine, nbRow, state : Integer;
  grid : TArrayOfArrayOfString;
  i, j, base : Integer;
begin
{  father := instance.GetFather();
  endingDate := father.GetEndDate();
  currentDate := instance.GetNextDate();
  state := Trunc((instance as TEntityInstance).GetCurrentState());
  path := GetCurrentDir();

  if ((endingDate = currentDate) and (state >= 4)) or (state = 1000) then
  begin
    ComputeMaxNumberOfLeaf(instance, nbLeafMax);
    nbTiller := Trunc((instance as TEntityInstance).GetTAttribute('nbExistingTiller').GetCurrentSample().value);
    ComputeMinMaxNumberOfInternode(instance, minInternodeName, maxInternodeName);
    nbInternode := (maxInternodeName - minInternodeName) + 1;
    ComputeNbPanicle(instance, nbPanicle);
    ComputeNbPeduncle(instance, nbPeduncle);
    nbLine := (nbAttributeForLeaf * nbLeafMax) +
              (nbInternode * nbAttributeForInternode) +
              (nbAttributeForPanicle * nbPanicle) +
              (nbAttributeForPeduncle * nbPeduncle) + 2;
    nbRow := nbTiller + 4;
    setLength(grid, nbLine, nbRow);
    for i := 0 to nbLine - 1 do
    begin
      for j := 0 to nbRow - 1 do
      begin
        grid[i, j] := 'NA';
      end;
    end;
    grid[0, 0] := 'attribute name';
    grid[0, 1] := 'organ type';
    grid[0, 2] := 'organ number';
    grid[0, 3] := 'Mainstem';
    for i := 0 to nbTiller - 1 do
    begin
      grid[0, i + 3] := 'T_' + IntToStr(i + 1);
    end;
    grid[1, 0] := 'stock';
    grid[1, 1] := '';
    grid[1, 2] := '';
    i := 0;
    j := 0;
    while i < ((nbLeafMax) * nbAttributeForLeaf) do
    begin
      grid[i + 0 + 2, 0] := 'width';
      grid[i + 0 + 2, 1] := baseNameLeaf;
      grid[i + 0 + 2, 2] := IntToStr(j + 1);
      grid[i + 1 + 2, 0] := 'bladeArea';
      grid[i + 1 + 2, 1] := baseNameLeaf;
      grid[i + 1 + 2, 2] := IntToStr(j + 1);
      grid[i + 2 + 2, 0] := 'biomass';
      grid[i + 2 + 2, 1] := baseNameLeaf;
      grid[i + 2 + 2, 2] := IntToStr(j + 1);
      grid[i + 3 + 2, 0] := 'length';
      grid[i + 3 + 2, 1] := baseNameLeaf;
      grid[i + 3 + 2, 2] := IntToStr(j + 1);
      i := i + 4;
      j := j + 1;
    end;
    base := ((nbLeafMax) * nbAttributeForLeaf) + 2;
    i := base;
    j := minInternodeName;
    while (i < (base + (nbInternode * nbAttributeForInternode))) do
    begin
      grid[i + 0, 0] := 'biomass';
      grid[i + 0, 1] := baseNameInternode;
      grid[i + 0, 2] := IntToStr(j);
      grid[i + 1, 0] := 'length';
      grid[i + 1, 1] := baseNameInternode;
      grid[i + 1, 2] := IntToStr(j);
      grid[i + 2, 0] := 'diameter';
      grid[i + 2, 1] := baseNameInternode;
      grid[i + 2, 2] := IntToStr(j);
      i := i + 3;
      j := j + 1;
    end;
    base := base + (nbInternode * nbAttributeForInternode);
    i := base;
    j := 0;
    while (i < (base + (nbPanicle * nbAttributeForPanicle))) do
    begin
      grid[i + 0, 0] := 'grainNb';
      grid[i + 0, 1] := baseNamePanicle;
      grid[i + 0, 2] := IntToStr(j);
      grid[i + 1, 0] := 'fertileGrainNb';
      grid[i + 1, 1] := baseNamePanicle;
      grid[i + 1, 2] := IntToStr(j);
      grid[i + 2, 0] := 'filledGrainNb';
      grid[i + 2, 1] := baseNamePanicle;
      grid[i + 2, 2] := IntToStr(j);
      grid[i + 3, 0] := 'height';
      grid[i + 3, 1] := baseNamePanicle;
      grid[i + 3, 2] := IntToStr(j);
      grid[i + 4, 0] := 'weight';
      grid[i + 4, 1] := baseNamePanicle;
      grid[i + 4, 2] := IntToStr(j);
      grid[i + 5, 0] := 'length';
      grid[i + 5, 1] := baseNamePanicle;
      grid[i + 5, 2] := IntToStr(j);
      i := i + 6;
      j := j + 1;
    end;
    base := i + (nbPeduncle * nbAttributeForPeduncle);
    j := 0;
    while (i < (base - 1)) do
    begin
      grid[i + 0, 0] := 'biomass';
      grid[i + 0, 1] := baseNamePeduncle;
      grid[i + 0, 2] := IntToStr(j);
      grid[i + 1, 0] := 'length';
      grid[i + 1, 1] := baseNamePeduncle;
      grid[i + 1, 2] := IntToStr(j);
      grid[i + 2, 0] := 'diameter';
      grid[i + 2, 1] := baseNamePeduncle;
      grid[i + 2, 2] := IntToStr(j);
      i := i + 3;
      j := j + 1;
    end;
    FillGrid(instance, grid, nbRow, nbLine);
    AssignFile(pFile, path + separator + fileName + dot + extension);
    ReWrite(pFile);
    for i := 0 to nbLine - 1 do
    begin
      line := '';
      for j := 0 to nbRow - 1 do
      begin
        line := line + grid[i, j] + #9;
      end;
      Writeln(pFile, line);
    end;
    CloseFile(pFile);
  end;  }
end;

procedure SaveTableData_LE2(var instance : TInstance);
const
  fileName = 'aggregatedData_out';
  extension = 'txt';
  dot = '.';
  separator = '\';
  nbAttributeForLeaf = 4;
  nbAttributeForInternode = 3;
  nbAttributeForPanicle = 6;
  nbAttributeForPeduncle = 3;
  baseNameTiller = 'T';
  baseNameLeaf = 'L';
  baseNameInternode = 'IN';
  baseNamePanicle = 'Pan';
  baseNamePeduncle = 'Ped';
var
  father : TInstance;
  endingDate : TDateTime;
  currentDate : TDateTime;
  path, line : String;
  pFile : TextFile;
  minInternodeName, maxInternodeName : Integer;
  nbLeafMax, nbTiller, nbInternode, nbPanicle, nbPeduncle : Integer;
  nbLine, nbRow, state : Integer;
  grid : TArrayOfArrayOfString;
  i, j, base : Integer;
begin
  father := instance.GetFather();
  endingDate := father.GetEndDate();
  currentDate := instance.GetNextDate();
  state := Trunc((instance as TEntityInstance).GetCurrentState());
  path := GetCurrentDir();

  if ((endingDate = currentDate) and (state >= 4)) or (state = 1000) then
  begin
    ComputeMaxNumberOfLeaf(instance, nbLeafMax);
    nbTiller := Trunc((instance as TEntityInstance).GetTAttribute('nbExistingTiller').GetCurrentSample().value);
    ComputeMinMaxNumberOfInternode(instance, minInternodeName, maxInternodeName);
    nbInternode := (maxInternodeName - minInternodeName) + 1;
    ComputeNbPanicle(instance, nbPanicle);
    ComputeNbPeduncle(instance, nbPeduncle);
    nbLine := (nbAttributeForLeaf * nbLeafMax) +
              (nbInternode * nbAttributeForInternode) +
              (nbAttributeForPanicle * nbPanicle) +
              (nbAttributeForPeduncle * nbPeduncle) + 2;
    nbRow := nbTiller + 3;
    setLength(grid, nbLine, nbRow);
    for i := 0 to nbLine - 1 do
    begin
      for j := 0 to nbRow - 1 do
      begin
        grid[i, j] := 'NA';
      end;
    end;
    grid[0, 0] := '';
    grid[0, 1] := '';
    grid[0, 2] := 'Mainstem';
    for i := 0 to nbTiller - 1 do
    begin
      grid[0, i + 3] := 'T_' + IntToStr(i + 1);
    end;
    grid[1, 0] := 'stock';
    grid[1, 1] := '';
    i := 0;
    j := 0;
    while i < ((nbLeafMax) * nbAttributeForLeaf) do
    begin
      grid[i + 0 + 2, 0] := 'width';
      grid[i + 0 + 2, 1] := baseNameLeaf + IntToStr(j + 1);
      grid[i + 1 + 2, 0] := 'bladeArea';
      grid[i + 1 + 2, 1] := baseNameLeaf + IntToStr(j + 1);
      grid[i + 2 + 2, 0] := 'biomass';
      grid[i + 2 + 2, 1] := baseNameLeaf + IntToStr(j + 1);
      grid[i + 3 + 2, 0] := 'length';
      grid[i + 3 + 2, 1] := baseNameLeaf + IntToStr(j + 1);
      i := i + 4;
      j := j + 1;
    end;
    base := ((nbLeafMax) * nbAttributeForLeaf) + 2;
    i := base;
    j := minInternodeName;
    while (i < (base + (nbInternode * nbAttributeForInternode))) do
    begin
      grid[i + 0, 0] := 'biomass';
      grid[i + 0, 1] := baseNameInternode + IntToStr(j);
      grid[i + 1, 0] := 'length';
      grid[i + 1, 1] := baseNameInternode + IntToStr(j);
      grid[i + 2, 0] := 'diameter';
      grid[i + 2, 1] := baseNameInternode + IntToStr(j);
      i := i + 3;
      j := j + 1;
    end;
    base := base + (nbInternode * nbAttributeForInternode);
    i := base;
    j := 0;
    while (i < (base + (nbPanicle * nbAttributeForPanicle))) do
    begin
      grid[i + 0, 0] := 'grainNb';
      grid[i + 0, 1] := baseNamePanicle + IntToStr(j);
      grid[i + 1, 0] := 'fertileGrainNb';
      grid[i + 1, 1] := baseNamePanicle + IntToStr(j);
      grid[i + 2, 0] := 'filledGrainNb';
      grid[i + 2, 1] := baseNamePanicle + IntToStr(j);
      grid[i + 3, 0] := 'height';
      grid[i + 3, 1] := baseNamePanicle + IntToStr(j);
      grid[i + 4, 0] := 'weight';
      grid[i + 4, 1] := baseNamePanicle + IntToStr(j);
      grid[i + 5, 0] := 'length';
      grid[i + 5, 1] := baseNamePanicle + IntToStr(j);
      i := i + 6;
      j := j + 1;
    end;
    base := i + (nbPeduncle * nbAttributeForPeduncle);
    j := 0;
    while (i < (base - 1)) do
    begin
      grid[i, 0] := 'biomass';
      grid[i, 1] := baseNamePeduncle + IntToStr(j);
      grid[i + 1, 0] := 'length';
      grid[i + 1, 1] := baseNamePeduncle + IntToStr(j);
      grid[i + 2, 0] := 'diameter';
      grid[i + 2, 1] := baseNamePeduncle + IntToStr(j);
      i := i + 3;
      j := j + 1;
    end;
    FillGrid(instance, grid, nbRow, nbLine);
    AssignFile(pFile, path + separator + fileName + dot + extension);
    ReWrite(pFile);
    for i := 0 to nbLine - 1 do
    begin
      line := '';
      for j := 0 to nbRow - 1 do
      begin
        line := line + grid[i, j] + #9;
      end;
      Writeln(pFile, line);
    end;
    CloseFile(pFile);
  end; 
end;

// ---------------------------------------------------------------------------
// Procedure ComputeDegreeDay_LE
// -----------------------------
//
// Calcule les Degrés jours
//
//
// ---------------------------------------------------------------------------

procedure ComputeDegreeDay_LE(const TMax, TMin, TBase, TLet, TOpt1, TOpt2 : Double; var DegreeDay : Double);
var
  S1, S2, S3, V1, V3, V : Double;
  MyTMax : Double;
  Tn, Tx : Double;
begin
  MyTMax := TMax;
  if MyTMax <> TMin then
    if ((MyTMax <= Tbase) or (TMin >= TLet)) then
      V := 0   // exceptions pendant optimisation
    else
    begin
      Tn := Max(TMin, TBase);
      Tx := Min(MyTMax, TLet);
      V1 := ((Tn + Min(TOpt1, Tx)) / 2 - TBase) / (TOpt1 - TBase);
      S1 := V1 * Max(0, min(TOpt1, Tx) - Tn) ;          // = 0 si Tn>TOpt1
      S2 := 1 * Max(0, min(Tx, TOpt2) - Max(Tn, TOpt1));
      V3 := (TLet - (Max(Tx, TOpt2) + Max(TOpt2, Tn)) / 2) / (TLet - TOpt2);
      S3 := V3 * Max(0, Tx - Max(TOpt2, Tn));        // =0 siTx < TOpt2
      V := (S1 + S2 + S3) / (MyTMax - TMin);
    end
  else
    if MyTMax < TOpt1 then
      V := (MyTMax - TBase) / (TOpt1 - TBase)
    else
      if  MyTMax < TOpt2 then
        V := 1
      else
        V := (TLet - MyTMax) / (TLet - TOpt2);
  DegreeDay := V * (TOpt1 - TBase);
end;

procedure ComputeNewPlasto_Ligulo_LL_BL_MGR(const n, boolCrossedPlasto, nbLeafParam2, slopeLL_BL, coeffPlastoPI, coeffLiguloPI, coeffMGRPI, stock, nbLeafPI, nbLeafMaxAfterPI, LL_BL_init : Double; var plasto, ligulo, LL_BL, MGR : Double);
begin
  SRwriteln('n                 --> ' + FloatToStr(n));
  SRwriteln('stock             --> ' + FloatToStr(stock));
  SRwriteln('plasto            --> ' + FloatToStr(plasto));
  SRwriteln('ligulo            --> ' + FloatToStr(ligulo));
  SRwriteln('LL_BL_init        --> ' + FloatToStr(LL_BL_init));
  SRwriteln('boolCrossedPlasto --> ' + FloatToStr(boolCrossedPlasto));
  SRwriteln('nbLeafParam2      --> ' + FloatToStr(nbLeafParam2));
  SRwriteln('slopeLL_BL        --> ' + FloatToStr(slopeLL_BL));
  SRwriteln('coeffPlastoPI     --> ' + FloatToStr(coeffPlastoPI));
  SRwriteln('coeffLiguloPI     --> ' + FloatToStr(coeffLiguloPI));
  SRwriteln('coeffMGRPI        --> ' + FloatToStr(coeffMGRPI));
  SRwriteln('nbLeafPI          --> ' + FloatToStr(nbLeafPI));
  SRwriteln('nbLeafMaxAfterPI  --> ' + FloatToStr(nbLeafMAxAfterPI));

  if ((n = nbLeafParam2) and (boolCrossedPlasto > 0) and (stock > 0)) then
  begin
    plasto := plasto * coeffPlastoPI;
    ligulo := ligulo * coeffLiguloPI;
    LL_BL := LL_BL_init + slopeLL_BL * (n - nbLeafParam2);
    MGR := MGR * coeffMGRPI;
    SRwriteln('Nouvelles valeurs');
    SRwriteln('plasto      --> ' + FloatToStr(plasto));
    SRwriteln('ligulo      --> ' + FloatToStr(ligulo));
    SRwriteln('LL_BL_init  --> ' + FloatToStr(LL_BL_init));
    SRwriteln('LL_BL       --> ' + FloatToStr(LL_BL));
    SRwriteln('MGR         --> ' + FloatToStr(MGR));
  end
  else if ((n >= nbLeafParam2) and (boolCrossedPlasto > 0) and (n < nbLeafPI + nbLeafMaxAfterPI + 1)) then
  begin
    LL_BL := LL_BL_init + slopeLL_BL * (n - nbLeafParam2);
    plasto := plasto;
    ligulo := ligulo;
    LL_BL := LL_BL;
    MGR := MGR;
    SRwriteln('(n >= nbLeafParam2) and (boolCrossedPlasto > 0) and (n < nbLeafPI + nbLeafMaxAfterPI + 1)');
    SRwriteln('LL_BL_init  --> ' + FloatToStr(LL_BL_init));
    SRwriteln('LL_BL modifie');
    SRwriteln('LL_BL       --> ' + FloatToStr(LL_BL));
    SRwriteln('Valeurs inchangees');
    SRwriteln('plasto      --> ' + FloatToStr(plasto));
    SRwriteln('ligulo      --> ' + FloatToStr(ligulo));
    SRwriteln('MGR         --> ' + FloatToStr(MGR));
  end
  else
  begin
    SRwriteln('Valeurs inchangees');
    SRwriteln('plasto      --> ' + FloatToStr(plasto));
    SRwriteln('ligulo      --> ' + FloatToStr(ligulo));
    SRwriteln('LL_BL       --> ' + FloatToStr(LL_BL));
    SRwriteln('MGR         --> ' + FloatToStr(MGR));
  end;
end;

// ---------------------------------------------------------------------------
// Procedure ComputeStockInternodeOnCulms_LE
// -----------------------------------------
//
//
//
// module 'extra'
// ---------------------------------------------------------------------------

procedure ComputeStockInternodeOnCulms_LE(var instance : TInstance);
var
  stateMeristem, i1, i2, le1, le2 : Integer;
  sumOfStockINInMatureState, sumOfBiomassOnInternodeInMatureState : Double;
  biomassIN, stockCulm, stockIN, maximumReserveInInternode : Double;
  currentInstance, currentCurrentInstance : TInstance;
  sample : TSample;
begin
  stateMeristem := (instance as TEntityInstance).GetCurrentState();
  if ((stateMeristem >= 4) and (stateMeristem <> 1000)) then
  begin
    le1 := (instance as TEntityInstance).LengthTInstanceList();
    sumOfStockINInMatureState := 0;
    for i1 := 0 to le1 - 1 do // on commence avec les IN en état 4
    begin
      currentInstance := (instance as TEntityInstance).GetTInstance(i1);
      if (currentInstance is TEntityInstance) then
      begin
        if ((currentInstance as TEntityInstance).GetCategory() = 'Internode') then
        begin
          if ((currentInstance as TEntityInstance).GetCurrentState() = 4) then
          begin
              SRwriteln('IN : ' + currentInstance.GetName() + ' state 4');
              maximumReserveInInternode := (instance as TEntityInstance).GetTAttribute('maximumReserveInInternode').GetCurrentSample().value;
              biomassIN := (currentInstance as TEntityInstance).GetTAttribute('biomassIN').GetCurrentSample().value;
              sumOfBiomassOnInternodeInMatureState := (instance as TEntityInstance).GetTAttribute('sumOfBiomassOnInternodeInMatureState').GetCurrentSample().value;
              stockCulm := ((instance as TEntityInstance).GetTAttribute('stock_mainstem') as TAttributeTableOut).GetCurrentSample().value;
              stockIN := Min(maximumReserveInInternode * biomassIN, (biomassIN / sumOfBiomassOnInternodeInMatureState) * stockCulm);
              sumOfStockINInMatureState := sumOfStockINInMatureState + stockIN;
              sample := (currentInstance as TEntityInstance).GetTAttribute('stockIN').GetCurrentSample();
              sample.value := stockIN;
              (currentInstance as TEntityInstance).GetTAttribute('stockIN').SetSample(sample);
              SRwriteln('maximumReserveInInternode            --> ' + FloatToStr(maximumReserveInInternode));
              SRwriteln('biomassIN                            --> ' + FloatToStr(biomassIN));
              SRwriteln('sumOfBiomassOnInternodeInMatureState --> ' + FloatToStr(sumOfBiomassOnInternodeInMatureState));
              SRwriteln('stockMainstem                        --> ' + FloatToStr(stockCulm));
              SRwriteln('stockIN                              --> ' + FloatToStr(stockIN));
              SRwriteln('sumOfStockINInMatureState            --> ' + FloatToStr(sumOfStockINInMatureState));
          end;
        end;
      end;
    end;
    for i1 := 0 to le1 - 1 do // ensuite avec les IN en etat 2
    begin
      currentInstance := (instance as TEntityInstance).GetTInstance(i1);
      if (currentInstance is TEntityInstance) then
      begin
        if ((currentInstance as TEntityInstance).GetCategory() = 'Internode') then
        begin
          if ((currentInstance as TEntityInstance).GetCurrentState() = 2) or ((currentInstance as TEntityInstance).GetCurrentState() = 10) then
          begin
              SRwriteln('IN : ' + currentInstance.GetName() + ' state 2');
              maximumReserveInInternode := (instance as TEntityInstance).GetTAttribute('maximumReserveInInternode').GetCurrentSample().value;
              biomassIN := (currentInstance as TEntityInstance).GetTAttribute('biomassIN').GetCurrentSample().value;
              stockCulm := ((instance as TEntityInstance).GetTAttribute('stock_mainstem') as TAttributeTableOut).GetCurrentSample().value;
              stockIN := Min(maximumReserveInInternode * biomassIN, stockCulm - sumOfStockINInMatureState);
              sample := (currentInstance as TEntityInstance).GetTAttribute('stockIN').GetCurrentSample();
              sample.value := stockIN;
              (currentInstance as TEntityInstance).GetTAttribute('stockIN').SetSample(sample);
              SRwriteln('maximumReserveInInternode            --> ' + FloatToStr(maximumReserveInInternode));
              SRwriteln('biomassIN                            --> ' + FloatToStr(biomassIN));
              SRwriteln('stockMainstem                        --> ' + FloatToStr(stockCulm));
              SRwriteln('sumOfStockINInMatureState            --> ' + FloatToStr(sumOfStockINInMatureState));
              SRwriteln('stockIN                              --> ' + FloatToStr(stockIN));
          end;
        end;
      end;
    end;
    for i1 := 0 to le1 - 1 do // ensuite on passe au talles
    begin
      currentInstance := (instance as TEntityInstance).GetTInstance(i1);
      if (currentInstance is TEntityInstance) then
      begin
        sumOfStockINInMatureState := 0;
        if ((currentInstance as TEntityInstance).GetCategory() = 'Tiller') then
        begin
          le2 := (currentInstance as TEntityInstance).LengthTInstanceList();
          for i2 := 0 to le2 - 1 do // on commence par les IN en etat 4
          begin
            currentCurrentInstance := (currentInstance as TEntityInstance).GetTInstance(i2);
            if (currentCurrentInstance is TEntityInstance) then
            begin
              if ((currentCurrentInstance as TEntityInstance).GetCategory() = 'Internode') then
              begin
                if ((currentCurrentInstance as TEntityInstance).GetCurrentState() = 4) then
                begin
                  SRwriteln('IN : ' + currentCurrentInstance.GetName() + ' state 4');
                  maximumReserveInInternode := (instance as TEntityInstance).GetTAttribute('maximumReserveInInternode').GetCurrentSample().value;
                  biomassIN := (currentCurrentInstance as TEntityInstance).GetTAttribute('biomassIN').GetCurrentSample().value;
                  sumOfBiomassOnInternodeInMatureState := (currentInstance as TEntityInstance).GetTAttribute('sumOfBiomassOnInternodeInMatureState').GetCurrentSample().value;
                  stockCulm := (currentInstance as TEntityInstance).GetTAttribute('stock_tiller').GetCurrentSample().value;
                  SRwriteln('stockTiller                          --> ' + FloatToStr(stockCulm));
                  stockIN := Min(maximumReserveInInternode * biomassIN, (biomassIN / sumOfBiomassOnInternodeInMatureState) * stockCulm);
                  sumOfStockINInMatureState := sumOfStockINInMatureState + stockIN;
                  sample := (currentCurrentInstance as TEntityInstance).GetTAttribute('stockIN').GetCurrentSample();
                  sample.value := stockIN;
                  (currentCurrentInstance as TEntityInstance).GetTAttribute('stockIN').SetSample(sample);
                  SRwriteln('maximumReserveInInternode            --> ' + FloatToStr(maximumReserveInInternode));
                  SRwriteln('biomassIN                            --> ' + FloatToStr(biomassIN));
                  SRwriteln('sumOfBiomassOnInternodeInMatureState --> ' + FloatToStr(sumOfBiomassOnInternodeInMatureState));
                  SRwriteln('stockIN                              --> ' + FloatToStr(stockIN));
                  SRwriteln('sumOfStockINInMatureState            --> ' + FloatToStr(sumOfStockINInMatureState));
                end;
              end;
            end;
          end;
          for i2 := 0 to le2 - 1 do
          begin
            currentCurrentInstance := (currentInstance as TEntityInstance).GetTInstance(i2);
            if (currentCurrentInstance is TEntityInstance) then
            begin
              if ((currentCurrentInstance as TEntityInstance).GetCategory() = 'Internode') then
              begin
                if ((currentCurrentInstance as TEntityInstance).GetCurrentState() = 2) or ((currentCurrentInstance as TEntityInstance).GetCurrentState() = 10) then
                begin
                  SRwriteln('IN : ' + currentCurrentInstance.GetName() + ' state 2');
                  maximumReserveInInternode := (instance as TEntityInstance).GetTAttribute('maximumReserveInInternode').GetCurrentSample().value;
                  biomassIN := (currentCurrentInstance as TEntityInstance).GetTAttribute('biomassIN').GetCurrentSample().value;
                  stockCulm := (currentInstance as TEntityInstance).GetTAttribute('stock_tiller').GetCurrentSample().value;
                  stockIN := Min(maximumReserveInInternode * biomassIN, stockCulm - sumOfStockINInMatureState);
                  sample := (currentCurrentInstance as TEntityInstance).GetTAttribute('stockIN').GetCurrentSample();
                  sample.value := stockIN;
                  (currentCurrentInstance as TEntityInstance).GetTAttribute('stockIN').SetSample(sample);
                  SRwriteln('maximumReserveInInternode            --> ' + FloatToStr(maximumReserveInInternode));
                  SRwriteln('biomassIN                            --> ' + FloatToStr(biomassIN));
                  SRwriteln('stockTiller                          --> ' + FloatToStr(stockCulm));
                  SRwriteln('sumOfStockINInMatureState            --> ' + FloatToStr(sumOfStockINInMatureState));
                  SRwriteln('stockIN                              --> ' + FloatToStr(stockIN));
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure ChangeRootEntityExeOrder(var instance : TInstance);
begin
  if (instance is TEntityInstance) then
  begin
    (instance as TEntityInstance).GetTInstance('Root').SetExeOrder(7650);
    (instance as TEntityInstance).GetTInstance('changeRootEntityExeOrder9').SetActiveState(100);
    (instance as TEntityInstance).GetTInstance('changeRootEntityExeOrder4').SetActiveState(100);
    (instance as TEntityInstance).SortTInstance();
  end;
end;

procedure ComputeSumOfDemandOnLeafInternode(var instance : TInstance; var total : Double);
var
  state, i1, i2, le1, le2 : Integer;
  currentInstance1, currentInstance2 : TInstance;
  currentEntityInstance1, currentEntityInstance2 : TEntityInstance;
  contribution : Double;
begin
  total := 0;
  state := (instance as TEntityInstance).GetCurrentState();
  if ((state = 4) or (state = 9)) then
  begin
    le1 := (instance as TEntityInstance).LengthTInstanceList();
    for i1 := 0 to le1 - 1 do
    begin
      currentInstance1 := (instance as TEntityInstance).GetTInstance(i1);
      if (currentInstance1 is TEntityInstance) then
      begin
        currentEntityInstance1 := (currentInstance1 as TEntityInstance);
        if (currentEntityInstance1.GetCategory() = 'Leaf') then
        begin
          contribution := currentEntityInstance1.GetTAttribute('demand').GetCurrentSample().value;
          SRwriteln('Contribution de ' + currentEntityInstance1.GetName() + ' --> ' + FloatToStr(contribution));
          total := total + contribution;
        end
        else if (currentEntityInstance1.GetCategory() = 'Internode') then
        begin
          contribution := currentEntityInstance1.GetTAttribute('demandIN').GetCurrentSample().value;
          SRwriteln('Contribution de ' + currentEntityInstance1.GetName() + ' --> ' + FloatToStr(contribution));
          total := total + contribution;
        end
        else if (currentEntityInstance1.GetCategory() = 'Tiller') then
        begin
          le2 := currentEntityInstance1.LengthTInstanceList();
          for i2 := 0 to le2 - 1 do
          begin
            currentInstance2 := currentEntityInstance1.GetTInstance(i2);
            if (currentInstance2 is TEntityInstance) then
            begin
              currentEntityInstance2 := (currentInstance2 as TEntityInstance);
              if (currentEntityInstance2.GetCategory() = 'Leaf') then
              begin
                contribution := currentEntityInstance2.GetTAttribute('demand').GetCurrentSample().value;
                SRwriteln('Contribution de ' + currentEntityInstance2.GetName() + ' --> ' + FloatToStr(contribution));
                total := total + contribution;
              end
              else if (currentEntityInstance2.GetCategory() = 'Internode') then
              begin
                contribution := currentEntityInstance2.GetTAttribute('demandIN').GetCurrentSample().value;
                SRwriteln('Contribution de ' + currentEntityInstance2.GetName() + ' --> ' + FloatToStr(contribution));
              total := total + contribution;
              end;
            end;
          end;
        end;
      end;
    end;
    SRwriteln('total --> ' + FloatToStr(total));
  end;
end;

// -----------------------------------------------------------------------------
// Procedure KillOldestTillerLeaf_LE
// ---------------------------------
//
//
// module 'extra'
//
//
// -----------------------------------------------------------------------------

function FindYoungestTiller(const instance : TInstance; const minimalLeavesNumber : Double) : TInstance;
var
  le, i : Integer;
  currentInstance : TInstance;
  refTiller : TInstance;
  date, creationDate, currentDate : TDateTime;
  nbActiveLeaves : Double;
begin
  le := (instance as TEntityInstance).LengthTInstanceList();
  date := MIN_DATE;
  refTiller := nil;
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      if ((currentInstance as TEntityInstance).GetCategory() = 'Tiller') then
      begin
        SRwriteln('Talle : ' + (currentInstance as TEntityInstance).GetName());
        creationDate := (currentInstance as TEntityInstance).GetCreationDate();
        currentDate := currentInstance.GetNextDate();
        nbActiveLeaves := (currentInstance as TEntityInstance).GetTAttribute('activeLeavesNb').GetSample(currentDate).value;
        SRwriteln('Nombre de feuilles actives   --> ' + FloatToStr(nbActiveLeaves));
        SRwriteln('nb_leaves_enabling_tillering --> ' + FloatToStr(minimalLeavesNumber));
        if (nbActiveLeaves <= minimalLeavesNumber) then
        begin
          SRwriteln('OK pour le nombre de feuille');
          SRwriteln('Date de creation : ' + DateToStr(creationDate));
          if (creationDate >= date) then
          begin
            date := creationDate;
            refTiller := currentInstance;
          end;
        end;
      end;
    end;
  end;
  if (refTiller <> nil) then
  begin
    SRwriteln('Plus jeune talle : ' + refTiller.GetName());
  end
  else
  begin
    SRwriteln('Pas de talle');
  end;
  Result := refTiller;
end;

function AllCulmsWithoutDeficit(const instance : TInstance) : Boolean;
var
  le, i : Integer;
  deficitCulm : Double;
  currentInstance : TInstance;
  all : Boolean;
  date : TDateTime;
begin
  all := True;
  date := instance.GetNextDate();
  deficitCulm := (instance as TEntityInstance).GetTAttribute('deficit_mainstem').GetSample(date).value;
  SRwriteln('Deficit mainstem --> ' + FloatToStr(deficitCulm));
  all := all and (deficitCulm = 0);
  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      if ((currentInstance as TEntityInstance).GetCategory() = 'Tiller') then
      begin
        deficitCulm := (currentInstance as TEntityInstance).GetTAttribute('deficit_tiller').GetSample(date).value;
        SRwriteln('Tiller name      --> ' + currentInstance.GetName());
        SRwriteln('Deficit tiller   --> ' + FloatToStr(deficitCulm));
        all := all and (deficitCulm = 0)
      end;
    end;
  end;
  if all then
  begin
    SRwriteln('AllCulmsWithoutDeficit --> True');
  end
  else
  begin
    Srwriteln('AllCulmsWithoutDeficit --> False');
  end;
  Result := all;
end;

procedure KillYoungestTillerOldestLeaf_LE(var instance : TInstance ; const reallocationCoeff, nbLeafEnablingTillering : Double; var deficit, stock, senesc_dw, deadleafNb, deadtillerNb, computedReallocBiomass : Double);
var
  state, leafState, le, i, counter : Integer;
  currentInstance : TInstance;
  refTiller, refLeaf : TEntityInstance;
  date, creationDate, nextDate : TDateTime;
  activeLeavesNb, sumOfTillerINBiomass, sumOfTillerLeafBiomass, leafBiomass, totalBiomass, computedReallocBiomassTiller : Double;
  oldDeficit, deficitTiller, tmp, previousDeficit : Double;
  sample : TSample;
begin
  computedReallocBiomass := 0;
  activeLeavesNb := 0;
  state := (instance as TEntityInstance).GetCurrentState();
  SRwriteln('state   --> ' + IntToStr(state));
  SRwriteln('stock   --> ' + FloatToStr(stock));
  SRwriteln('deficit --> ' + FloatToStr(deficit));
  if ((stock = 0) and (state <> 1) and (state < 4)) then
  begin
    SRwriteln('Cas on tue une feuille - phase vegetative');
    SRwriteln('------------------------------------------');
    KillOldestLeaf_LE(instance, reallocationCoeff, deficit, stock, senesc_dw, deadleafNb, computedReallocBiomass);
  end
  else if ((state >= 4) and (state <> 1) and (stock = 0)) then
  begin
    previousDeficit := deficit;
    SRwriteln('On essaye de compenser le deficit par le stock, si necessaire');
    SRwriteln('-------------------------------------------------------------');
    SRwriteln('AVANT');
    SRwriteln('-----');
    SRwriteln('stock   --> ' + FloatToStr(stock));
    SRwriteln('deficit --> ' + FloatToStr(deficit));
    tmp := stock + deficit;
    if (tmp > 0) then
    begin
      stock := tmp;
      deficit := 0;
    end
    else
    begin
      stock := 0;
      deficit := tmp;
    end;
    SRwriteln('APRES');
    SRwriteln('-----');
    SRwriteln('stock   --> ' + FloatToStr(stock));
    SRwriteln('deficit --> ' + FloatToStr(deficit));
    if ((stock > 0) and (deficit = 0) and (previousDeficit < 0)) then
    begin
      SRwriteln('Le stock a tout compense, on doit remettre les deficits des axes a 0');
      SRwriteln('--------------------------------------------------------------------');
      date := (instance as TEntityInstance).GetNextDate();
      sample := (instance as TEntityInstance).GetTAttribute('deficit_mainstem').GetSample(date);
      sample.value := 0;
      (instance as TEntityInstance).GetTAttribute('deficit_mainstem').SetSample(sample);
      //SRwriteln('deficit_mainstem a zero');
      le := (instance as TEntityInstance).LengthTInstanceList();
      for i := 0 to le - 1 do
      begin
        currentInstance := (instance as TEntityInstance).GetTInstance(i);
        if (currentInstance is TEntityInstance) then
        begin
          if ((currentInstance as TEntityInstance).GetCategory() = 'Tiller') then
          begin
            refTiller := (currentInstance as TEntityInstance);
            //SRwriteln('deficit_tiller sur talle ' + refTiller.GetName() + ' a zero');
            sample := refTiller.GetTAttribute('deficit_tiller').GetSample(date);
            sample.value := 0;
            refTiller.GetTAttribute('deficit_tiller').SetSample(sample);
          end;
        end;
      end;
    end
    else if ((stock = 0) and (deficit < 0)) then
    begin
      SRwriteln('Le stock n a pas tout compense, on va tuer une feuille de la plus jeune talle');
      SRwriteln('qui a un nombre de feuilles < nb_leaf_enabling_tillering');
      SRwriteln('------------------------------------------------------------------------------');
      refTiller := FindYoungestTiller(instance, nbLeafEnablingTillering) as TEntityInstance;
      if (refTiller <> nil) then
      begin
        date := MAX_DATE;
        le := refTiller.LengthTInstanceList();
        counter := 0;
        refLeaf := nil;
        for i := 0 to le - 1 do
        begin
          currentInstance := refTiller.GetTInstance(i);
          if (currentInstance is TEntityInstance) then
          begin
            if ((currentInstance as TEntityInstance).GetCategory() = 'Leaf') then
            begin
              SRwriteln('Leaf : ' + (currentInstance as TEntityInstance).GetName());
              creationDate := (currentInstance as TEntityInstance).GetCreationDate();
              SRwriteln('Date de creation : ' + DateToStr(creationDate));
              leafState := (currentInstance as TEntityInstance).GetCurrentState();
              if (leafState <> 2000) then
              begin
                if (creationDate <= date) then
                begin
                  date := creationDate;
                  refLeaf := (currentInstance as TEntityInstance);
                end;
                counter := counter + 1;
              end;
            end;
          end;
        end;
        if (refLeaf <> nil) then
        begin
          SRwriteln('Destruction de la feuille : ' + refLeaf.GetName());
          nextDate := refLeaf.GetNextDate();
          leafState := refLeaf.GetCurrentState();
          if ((leafState = 4) or (leafState = 5)) then
          begin
            leafBiomass := refLeaf.GetTAttribute('correctedLeafBiomass').GetSample(nextDate).value;
          end
          else
          begin
            leafBiomass := refLeaf.GetTAttribute('biomass').GetSample(nextDate).value;
          end;

          // destruction de la feuille
          // -------------------------
          refTiller.RemoveTInstance(refLeaf);
          // re allocation de la biomass
          // ---------------------------
          SRwriteln('-----------------------------');
          SRwriteln('Ancienne valeur du stock   --> ' + FloatToStr(stock));
          SRwriteln('Deficit                    --> ' + FloatToStr(deficit));
          SRwriteln('On recupere                --> ' + FloatToStr(reallocationCoeff * leafBiomass));
          SRwriteln('deadleafNb                 --> ' + FloatToStr(deadleafNb));
          SRwriteln('deadtillerNb               --> ' + FloatToStr(deadtillerNb));
          SRwriteln('senesc_dw                  --> ' + FloatToStr(senesc_dw));

          
          computedReallocBiomass := reallocationCoeff * leafBiomass;

          stock := max(0, stock + computedReallocBiomass + deficit);
          deadleafNb := deadleafNb + 1;
          senesc_dw := senesc_dw + leafBiomass - computedReallocBiomass;

          SRwriteln('-----------------------------');
          SRwriteln('Nouvelle valeur du stock   --> ' + FloatToStr(stock));
          SRwriteln('Nouvelle valeur du deficit --> ' + FloatToStr(deficit));
          SRwriteln('computedReallocBiomass     --> ' + FloatToStr(computedReallocBiomass));
          SRwriteln('deadleafNb                 --> ' + FloatToStr(deadleafNb));
          SRwriteln('deadtillerNb               --> ' + FloatToStr(deadtillerNb));
          SRwriteln('senesc_dw                  --> ' + FloatToStr(senesc_dw));

          if (counter = 1) then // il ne restait plus qu'une seuille feuille sur la talle, donc on detruit la talle aussi
          begin
            SRwriteln('Il ne restait plus qu une seule feuille sur la talle, on la detruire aussi');
            SRwriteln('--------------------------------------------------------------------------');
            nextDate := refTiller.GetNextDate();
            SRwriteln('Talle choisie pour destruction : ' + refTiller.GetName());
            deficitTiller := refTiller.GetTAttribute('deficit_tiller').GetSample(nextDate).value;
            sumOfTillerINBiomass := refTiller.GetTAttribute('sumOfTillerInternodeBiomass').GetSample(nextDate).value;
            totalBiomass := sumOfTillerINBiomass;
            SRwriteln('Biomasse totale --> ' + FloatToStr(totalBiomass));
            SRwriteln('Avant destruction');
            SRwriteln('-----------------');
            SRwriteln('stock         --> ' + FloatToStr(stock));
            SRwriteln('deficit       --> ' + FloatToStr(deficit));
            SRwriteln('deficitTiller --> ' + FloatToStr(deficitTiller));
            SRwriteln('senesc_dw     --> ' + FloatToStr(senesc_dw));
            SRwriteln('deadleafNb    --> ' + FloatToStr(deadleafNb));
            SRwriteln('deadtillerNb  --> ' + FloatToStr(deadtillerNb));

            computedReallocBiomassTiller := reallocationCoeff * totalBiomass;
            stock := max(0, stock + computedReallocBiomassTiller);
            deficit := min(0, deficit - deficitTiller);
            senesc_dw := senesc_dw + totalBiomass - computedReallocBiomassTiller;
            deadleafNb := deadleafNb + 1;
            deadtillerNb := deadtillerNb + 1;

            computedReallocBiomass := computedReallocBiomass + computedReallocBiomassTiller + deficitTiller;

            SRwriteln('Apres destruction');
            SRwriteln('---------------------------------');
            SRwriteln('stock                        --> ' + FloatToStr(stock));
            SRwriteln('deficit                      --> ' + FloatToStr(deficit));
            SRwriteln('senesc_dw                    --> ' + FloatToStr(senesc_dw));
            SRwriteln('deadleafNb                   --> ' + FloatToStr(deadleafNb));
            SRwriteln('deadtillerNb                 --> ' + FloatToStr(deadtillerNb));
            SRwriteln('computedReallocBiomassTiller --> ' + FloatToStr(computedReallocBiomassTiller));
            SRwriteln('computedReallocBiomass       --> ' + FloatToStr(computedReallocBiomass));

            // destruction de la talle
            // -----------------------
            (instance as TEntityInstance).RemoveTInstance(refTiller);

            if (AllCulmsWithoutDeficit(instance)) then
            begin
              SRwriteln('Tous les autres axes n ont pas de deficit : senesc_dw := senesc_dw + computedReallocBiomass');
              senesc_dw := senesc_dw + computedReallocBiomass;
              SRwriteln('senesc_dw --> ' + FloatToStr(senesc_dw));
              computedReallocBiomass := 0;
            end;
          end;
        end;
      end
      else
      begin
        SRwriteln('Il n y a pas de talles qui satisfassent les contraintes, donc on tue la plus vieille feuille');
        SRwriteln('--------------------------------------------------------------------------------------------');
        KillOldestLeaf_LE(instance, reallocationCoeff, deficit, stock, senesc_dw, deadleafNb, computedReallocBiomass);
      end;
      SRwriteln('On force la remise a 0 des demandes et stock de mainstem et des talles');
      SRwriteln('----------------------------------------------------------------------');
      date := (instance as TEntityInstance).GetNextDate();
      sample := (instance as TEntityInstance).GetTAttribute('day_demand_mainstem').GetSample(date);
      sample.value := 0;
      (instance as TEntityInstance).GetTAttribute('day_demand_mainstem').SetSample(sample);
      sample := (instance as TEntityInstance).GetTAttribute('stock_mainstem').GetSample(date);
      sample.value := 0;
      (instance as TEntityInstance).GetTAttribute('stock_mainstem').SetSample(sample);
      le := (instance as TEntityInstance).LengthTInstanceList();
      for i := 0 to le - 1 do
      begin
        currentInstance := (instance as TEntityInstance).GetTInstance(i);
        if (currentInstance is TEntityInstance) then
        begin
          if ((currentInstance as TEntityInstance).GetCategory() = 'Tiller') then
          begin
            refTiller := (currentInstance as TEntityInstance);
            sample := refTiller.GetTAttribute('day_demand_tiller').GetSample(date);
            sample.value := 0;
            refTiller.GetTAttribute('day_demand_tiller').SetSample(sample);
            sample := refTiller.GetTAttribute('stock_tiller').GetSample(date);
            sample.value := 0;
            refTiller.GetTAttribute('stock_tiller').SetSample(sample);
          end;
        end;
      end;

    end;
  end;
end;

procedure ComputeNbActiveInternodesOnMainstem(var instance : TInstance; var nbActiveInternodesOnMainstem : Double);
var
  state, le, i, internodeState : Integer;
  currentInstance : TInstance;
  currentTEntityInstance : TEntityInstance;
begin
  nbActiveInternodesOnMainstem := 0;
  state := (instance as TEntityInstance).GetCurrentState();
  SRwriteln('state --> ' + IntToStr(state));
  if (state < 4) then
  begin
    nbActiveInternodesOnMainstem := 0;
    SRwriteln('nbActiveInternodesOnMainstem --> ' + FloatToStr(nbActiveInternodesOnMainstem));
  end
  else
  begin
    le := (instance as TEntityInstance).LengthTInstanceList();
    for i := 0 to le - 1 do
    begin
      currentInstance := (instance as TEntityInstance).GetTInstance(i);
      if (currentInstance is TEntityInstance) then
      begin
        currentTEntityInstance := (currentInstance as TEntityInstance);
        if (currentTEntityInstance.GetCategory() = 'Internode') then
        begin
          SRwriteln('Internode name -->  ' + currentTEntityInstance.GetName());
          internodeState := currentTEntityInstance.GetCurrentState();
          SRwriteln('Internode state --> ' + IntToStr(internodeState));
          if ((internodeState = 1) or (internodeState = 2) or (internodeState = 4) or (internodeState = 10) or (internodeState = 3) or (internodeState = 5)) then
          begin
            nbActiveInternodesOnMainstem := nbActiveInternodesOnMainstem + 1;
          end;
        end;
      end;
    end;
    SRwriteln('nbActiveInternodesOnMainstem --> ' + FloatToStr(nbActiveInternodesOnMainstem));
  end;
end;

procedure ComputeStockMainstemOutput(var instance : TInstance; var stockMainstem : Double);
var
  state : Integer;
begin
  state := (instance as TEntityInstance).GetCurrentState();
  SRwriteln('state --> ' + FloatToStr(state));
  if (state < 4) and (state <> -1) then
  begin
    stockMainstem := 0;
  end;
end;

procedure SumOfInternodeLengthOnMainstem(var instance : TInstance; var internodeLengthOnMainstem : Double);
var
  state, internodeState, le, i : Integer;
  currentInstance : TInstance;
  internodeLength : Double;
begin
  internodeLengthOnMainstem := 0;
  state := (instance as TEntityInstance).GetCurrentState();
  SRwriteln('state --> ' + IntToStr(state));
  if (state >= 4) then
  begin
    le := (instance as TEntityInstance).LengthTInstanceList();
    for i := 0 to le - 1 do
    begin
      currentInstance := (instance as TEntityInstance).GetTInstance(i);
      if (currentInstance is TEntityInstance) then
      begin
        if ((currentInstance as TEntityInstance).GetCategory() = 'Internode') then
        begin
          SRwriteln('Internode name         --> ' + (currentInstance as TEntityInstance).GetName());
          internodeState := (currentInstance as TEntityInstance).GetCurrentState();
          SRwriteln('Internode state        --> ' + IntToStr(internodeState));
          if ((internodeState <> 2000) and (internodeState <> 1000) and (internodeState <> -1)) then
          begin
          if ((currentInstance as TEntityInstance).GetTAttribute('LIN') <> Nil) then
            begin
              internodeLength := ((currentInstance as TEntityInstance).GetTAttribute('LIN') as TAttributeTableOut).GetCurrentSample().value;
              SRwriteln('Internode contribution --> ' + FloatToStr(internodeLength));
              internodeLengthOnMainstem := internodeLengthOnMainstem + internodeLength
            end;
          end;
        end;
      end;
    end;
  end;
  SRwriteln('internodeLengthOnMainstem --> ' + FloatToStr(internodeLengthOnMainstem));
end;

procedure ComputeFirstLastExpandedInternodeDiameterMainstem(var instance : TInstance; var firstDiameter, lastDiameter, lastLength, lastRank : Double);
var
  state, internodeState, le, i : Integer;
  maxCreationDate, minCreationDate, currentDate : TDateTime;
  currentInstance, refMinInstance, refMaxInstance : TInstance;
begin
  firstDiameter := 0;
  lastDiameter := 0;
  refMinInstance := nil;
  refMaxInstance := nil;
  maxCreationDate := MIN_DATE;
  minCreationDate := MAX_DATE;
  state := (instance as TEntityInstance).GetCurrentState();
  SRwriteln('state --> ' + IntToStr(state));
  if (state >= 4) then
  begin
    le := (instance as TEntityInstance).LengthTInstanceList();
    for i := 0 to le - 1 do
    begin
      currentInstance := (instance as TEntityInstance).GetTInstance(i);
      if (currentInstance is TEntityInstance) then
      begin
        if ((currentInstance as TEntityInstance).GetCategory() = 'Internode') then
        begin
          internodeState := (currentInstance as TEntityInstance).GetCurrentState();
          if (internodeState = 4) then
          begin
            currentDate := (currentInstance as TEntityInstance).GetCreationDate();
            if (currentDate < minCreationDate) then
            begin
              refMinInstance := currentInstance;
              minCreationDate := currentDate;
            end;
            if (currentDate > maxCreationDate) then
            begin
              refMaxInstance := currentInstance;
              maxCreationDate := currentDate;
            end;
          end;
        end;
      end;
    end;
    if ((refMinInstance <> nil) and (refMaxInstance <> nil)) then
    begin
      SRwriteln('first expanded internode          --> ' + refMinInstance.GetName());
      firstDiameter := ((refMinInstance as TEntityInstance).GetTAttribute('DIN') as TAttributeTableOut).GetCurrentSample().value;
      SRwriteln('first expanded internode diameter --> ' + FloatToStr(firstDiameter));
      SRwriteln('last expanded internode           -->  ' + refMaxInstance.GetName());
      lastDiameter := ((refMaxInstance as TEntityInstance).GetTAttribute('DIN') as TAttributeTableOut).GetCurrentSample().value;
      lastRank := (refMaxInstance as TEntityInstance).GetTAttribute('rank').GetCurrentSample().value;
      lastLength := ((refMaxInstance as TEntityInstance).GetTAttribute('LIN') as TAttributeTableOut).GetCurrentSample().value;
      SRwriteln('last expanded internode diameter  --> ' + FloatToStr(lastDiameter));
    end;
  end;
end;

procedure ComputeStockInternodeMainstem(var instance : TInstance; var stock : Double);
var
  le, i : Integer;
  currentInstance : TInstance;
  stockIN : Double;
begin
  stock := 0;
  le := (instance as TEntityInstance).LengthTAttributeList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      if ((currentInstance as TEntityInstance).GetCategory() = 'Internode') then
      begin
        if ((currentInstance as TEntityInstance).GetTAttribute('stockIN') <> nil) then
        begin
          stockIN := (currentInstance as TEntityInstance).GetTAttribute('stockIN').GetCurrentSample().value;
          SRwriteln('Internode name ' + (currentInstance as TEntityInstance).GetName() + ' stock : ' + FloatToStr(stockIN));
          stock := stock + stockIN;
        end;
      end;
    end;
  end;
  SRwriteln('Total stock internode mainstem --> ' + FloatToStr(stock));
end;

procedure ComputeStockInternodeTillers(var instance : TInstance; var stock : Double);
var
  le1, le2, i1, i2 : Integer;
  currentInstance1, currentInstance2 : TInstance;
  stockIN : Double;
begin
  stock := 0;
  le1 := (instance as TEntityInstance).LengthTAttributeList();
  for i1 := 0 to le1 - 1 do
  begin
    currentInstance1 := (instance as TEntityInstance).GetTInstance(i1);
    if (currentInstance1 is TEntityInstance) then
    begin
      if ((currentInstance1 as TEntityInstance).GetCategory() = 'Tiller') then
      begin
        le2 := (currentInstance1 as TEntityInstance).LengthTInstanceList();
        for i2 := 0 to le2 - 1 do
        begin
          currentInstance2 := (currentInstance1 as TEntityInstance).GetTInstance(i2);
          if (currentInstance2 is TEntityInstance) then
          begin
            if ((currentInstance2 as TEntityInstance).GetCategory() = 'Internode') then
            begin
              if ((currentInstance2 as TEntityInstance).GetTAttribute('stockIN') <> nil) then
              begin
                stockIN := (currentInstance2 as TEntityInstance).GetTAttribute('stockIN').GetCurrentSample().value;
                SRwriteln('Internode name ' + (currentInstance2 as TEntityInstance).GetName() + ' stock : ' + FloatToStr(stockIN));
                stock := stock + stockIN;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
  SRwriteln('Total stock internode tillers --> ' + FloatToStr(stock));
end;

procedure SetAliveToDead(var instance : TInstance; var alive : Double);
var
  state : Integer;
begin
  state := (instance as TEntityInstance).GetCurrentState();
  SRwriteln('state --> ' + IntToStr(state));
  if (state <> 1000) then
  begin
    alive := 0;
  end
  else
  begin
    alive := 1;
    SRwriteln('Plante morte !!');
  end;
end;

procedure FindLengthPeduncle(var instance : TInstance; var lengthPeduncle : Double);
var
  father, currentInstance : TInstance;
  name : string;
  le, i : Integer;
begin
  father := instance.GetFather();
  le := (father as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (father as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      if ((currentInstance as TEntityInstance).GetCategory() = 'Peduncle') then
      begin
        if ((currentInstance as TEntityInstance).GetTAttribute('LIN') <> nil) then
        begin
          name := (currentInstance as TEntityInstance).GetName();
          lengthPeduncle := (currentInstance as TEntityInstance).GetTAttribute('LIN').GetCurrentSample().value;
          SRwriteln('Peduncle ' + name + ', length --> ' + FloatToStr(lengthPeduncle));
        end;
      end;
    end;
  end;
end;

procedure ComputeLengthPeduncles(var instance : TInstance; var heightPanicleMainstem : Double);
var
  currentInstance1, currentInstance2 : TInstance;
  le1, le2, i, j, state, stateTiller : Integer;
  lengthPeduncleMainstem, sumOfInternodeLengthMainstem : Double;
  lengthPeduncleTiller, heightPanicleTiller, sumOfInternodeLengthTiller : Double;
  sample : TSample;
  refPanicle : TEntityInstance;
begin
  state := (instance as TEntityInstance).GetCurrentState();
  SRwriteln('state --> ' + IntToStr(state));
  case state of
    1, 2, 3 :
    begin
      heightPanicleMainstem := 0;
    end;
    4, 5, 6, 7, 8, 11, 12, 13, 14, 15:
    begin
      sumOfInternodeLengthMainstem := 0;
      le1 := (instance as TEntityInstance).LengthTInstanceList();
      for i := 0 to le1 - 1 do
      begin
        currentInstance1 := (instance as TEntityInstance).GetTInstance(i);
        if (currentInstance1 is TEntityInstance) then
        begin
          if ((currentInstance1 as TEntityInstance).GetCategory() = 'Peduncle') then
          begin
            if ((currentInstance1 as TEntityInstance).GetTAttribute('LIN') <> Nil) then
            begin
              sample := (currentInstance1 as TEntityInstance).GetTAttribute('LIN').GetCurrentSample();
              lengthPeduncleMainstem := sample.value;
              SRwriteln('lengthPeduncleMainstem --> ' + FloatToStr(lengthPeduncleMainstem) + ' on ' + (currentInstance1 as TEntityInstance).GetName());
            end;
          end;
          if ((currentInstance1 as TEntityInstance).GetCategory() = 'Internode') then
          begin
            if ((currentInstance1 as TEntityInstance).GetTAttribute('LIN') <> Nil) then
            begin
              sample := ((currentInstance1 as TEntityInstance).GetTAttribute('LIN') as TAttributeTableOut).GetCurrentSample();
              SRwriteln('Internode : ' + currentInstance1.GetName() + ' length --> ' + FloatToStr(sample.value));
              sumOfInternodeLengthMainstem := sumOfInternodeLengthMainstem + sample.value;
            end;
          end;
          if ((currentInstance1 as TEntityInstance).GetCategory() = 'Tiller') then
          begin
            SRwriteln('Talle --> ' + (currentInstance1 as TEntityInstance).GetName());
            stateTiller := (currentInstance1 as TEntityInstance).GetCurrentState();
            SRwriteln('state tiller --> ' + IntToStr(stateTiller));
            case stateTiller of
              4, 6, 7, 10 :
              begin
                le2 := (currentInstance1 as TEntityInstance).LengthTInstanceList();
                sumOfInternodeLengthTiller := 0;
                for j := 0 to le2 - 1 do
                begin
                  currentInstance2 := (currentInstance1 as TEntityInstance).GetTInstance(j);
                  if (currentInstance2 is TEntityInstance) then
                  begin
                    if ((currentInstance2 as TEntityInstance).GetCategory() = 'Peduncle') then
                    begin
                      SRwriteln('Peduncle');
                      if ((currentInstance2 as TEntityInstance).GetTAttribute('LIN') <> nil) then
                      begin
                        sample := (currentInstance2 as TEntityInstance).GetTAttribute('LIN').GetCurrentSample();
                        lengthPeduncleTiller := sample.value;
                        SRwriteln('lengthPeduncleTiller -- > ' + FloatToStr(lengthPeduncleTiller));
                      end;
                    end;
                    if ((currentInstance2 as TEntityInstance).GetCategory() = 'Panicle') then
                    begin
                      SRwriteln('Panicle');
                      refPanicle := (currentInstance2 as TEntityInstance);
                    end;
                    if ((currentInstance2 as TEntityInstance).GetCategory() = 'Internode') then
                    begin
                      if ((currentInstance2 as TEntityInstance).GetTAttribute('LIN') <> Nil) then
                      begin
                        sample := ((currentInstance2 as TEntityInstance).GetTAttribute('LIN') as TAttributeTableOut).GetCurrentSample();
                        SRwriteln('Internode : ' + currentInstance2.GetName() + ' length --> ' + FloatToStr(sample.value));
                        sumOfInternodeLengthTiller := sumOfInternodeLengthTiller + sample.value;
                      end;
                    end;
                  end;
                end;
                heightPanicleTiller := lengthPeduncleTiller + sumOfInternodeLengthTiller;
                SRwriteln('heightPanicleTiller --> ' + FloatToStr(heightPanicleTiller) + ' on panicle ' + refPanicle.GetName());
                sample := refPanicle.GetTAttribute('height_panicle').GetCurrentSample();
                sample.value := heightPanicleTiller;
                refPanicle.GetTAttribute('height_panicle').SetSample(sample);
              end;
            end;
          end;
        end;
      end;
      heightPanicleMainstem := lengthPeduncleMainstem + sumOfInternodeLengthMainstem;
      SRwriteln('heightPanicleMainstem --> ' + FloatToStr(heightPanicleMainstem));
    end;

  end;
end;

procedure ComputeThermalTimeSinceLigulation_LE(var instance : TInstance; var ThermalTimeSinceLigulation : Double);
var
  tAir, tB, thermalTime : Double;
  refInstance : TInstance;
begin
  SRwriteln('Ancienne valeur de ThermalTimeSinceLigulation --> ' + FloatToStr(ThermalTimeSinceLigulation));
  refInstance := instance.GetFather();
  while refInstance.GetName() <> 'EntityMeristem' do
  begin
    refInstance := refInstance.GetFather();
  end;
  tAir := (refInstance as TEntityInstance).GetTAttribute('Tair').GetCurrentSample().value;
  tB := (refInstance as TEntityInstance).GetTAttribute('Tb').GetCurrentSample().value;
  thermalTime := tAir - tB;
  SRwriteln('Tair                                          --> ' + FloatToStr(tAir));
  SRwriteln('Tb                                            --> ' + FloatToStr(tB));
  SRwriteln('ThermalTime                                   --> ' + FloatToStr(thermalTime));
  ThermalTimeSinceLigulation := thermalTimeSinceLigulation + thermalTime;
  SRwriteln('Nouvelle valeur de ThermalTimeSinceLigulation --> ' + FloatToStr(ThermalTimeSinceLigulation));
end;

procedure ComputeLifespan_LE(const coeffLifespan, mu, rank : Double; var lifespan : Double);
begin
  lifespan := coeffLifespan * Exp(mu *  rank);
  SRwriteln('coeffLifespan --> ' + FloatToStr(coeffLifespan));
  SRwriteln('mu            --> ' + FloatToStr(mu));
  SRwriteln('rank          --> ' + FloatToStr(rank));
  SRwriteln('lifespan      --> ' + FloatToStr(lifespan));
end;

procedure ComputeCorrectedBladeArea(var instance : TInstance; var correctedBladeArea : Double);
var
  state : Integer;
  bladeArea, thermalTimeSinceLigulation, lifespan : Double;
begin
  state := (instance as TEntityInstance).GetCurrentState();
  if (state <> 2000) then
  begin
    if ((state = 4) or (state = 5)) then
    begin
      bladeArea := (instance as TEntityInstance).GetTAttribute('bladeArea').GetCurrentSample().value;
      thermalTimeSinceLigulation := (instance as TEntityInstance).GetTAttribute('thermalTimeSinceLigulation').GetCurrentSample().value;
      lifespan := (instance as TEntityInstance).GetTAttribute('lifespan').GetCurrentSample().value;
      correctedBladeArea :=  bladeArea * (1 - thermalTimeSinceLigulation / lifespan);
      SRwriteln('bladeArea                  --> ' + FloatToStr(bladeArea));
      SRwriteln('thermalTimeSinceLigulation --> ' + FloatToStr(thermalTimeSinceLigulation));
      SRwriteln('lifespan                   --> ' + FloatToStr(lifespan));
      SRwriteln('correctedBladeArea         --> ' + FloatToStr(correctedBladeArea));
      if (correctedBladeArea <= 0) then
      begin
        (instance as TEntityInstance).SetCurrentState(500);
        SRwriteln('Passage a l''etat DEAD_BY_SENESCENCE');
        correctedBladeArea := 0;
      end;
    end
    else
    begin
      correctedBladeArea := 0;
    end;
  end;
end;

procedure ComputeCorrectedLeafBiomass(var instance : TInstance; var correctedLeafBiomass : Double);
var
  state : Integer;
  biomass, bladeArea, thermalTimeSinceLigulation, lifespan, SLA : Double;
  oldCorrectedBiomass, delta, reallocationCoeff : Double;
  computedReallocBiomass, computedSenesc_dw, stock, senesc_dw, G_L : Double;
  refInstance : TInstance;
  refTAttribute : TAttributeTableOut;
  refTa : TAttribute;
  sample : TSample;
begin
  state := (instance as TEntityInstance).GetCurrentState();
  refInstance := nil;
  if (state <> 2000) then
  begin
    if ((state = 4) or (state = 5)) then
    begin
      biomass := (instance as TEntityInstance).GetTAttribute('biomass').GetCurrentSample().value;
      oldCorrectedBiomass := (instance as TEntityInstance).GetTAttribute('oldCorrectedBiomass').GetCurrentSample().value;
      bladeArea := (instance as TEntityInstance).GetTAttribute('bladeArea').GetCurrentSample().value;
      thermalTimeSinceLigulation := (instance as TEntityInstance).GetTAttribute('thermalTimeSinceLigulation').GetCurrentSample().value;
      lifespan := (instance as TEntityInstance).GetTAttribute('lifespan').GetCurrentSample().value;
      SLA := (instance as TEntityInstance).GetTAttribute('leafBiomassStructAtInitiation').GetCurrentSample().value;
      G_L := (instance as TEntityInstance).GetTAttribute('G_L').GetCurrentSample().value;
      correctedLeafBiomass :=  (biomass - bladeArea * (1 + G_L) * (thermalTimeSinceLigulation / lifespan) / SLA);
      SRwriteln('biomass                    --> ' + FloatToStr(biomass));
      SRwriteln('bladeArea                  --> ' + FloatToStr(bladeArea));
      SRwriteln('thermalTimeSinceLigulation --> ' + FloatToStr(thermalTimeSinceLigulation));
      SRwriteln('lifespan                   --> ' + FloatToStr(lifespan));
      SRwriteln('SLA                        --> ' + FloatToStr(SLA));
      SRwriteln('G_L                        --> ' + FloatToStr(G_L));
      SRwriteln('correctedLeafBiomass       --> ' + FloatToStr(correctedLeafBiomass));
      SRwriteln('oldCorrectedBiomass        --> ' + FloatToStr(oldCorrectedBiomass));
      delta := oldCorrectedBiomass - correctedLeafBiomass;
      SRwriteln('delta                      --> ' + FloatToStr(delta));
      refTA := (instance as TEntityInstance).GetTAttribute('oldCorrectedBiomass');
      sample := refTA.GetCurrentSample();
      sample.value := correctedLeafBiomass;
      refTA.SetSample(sample);
      refInstance := instance.GetFather();
      while refInstance.GetName() <> 'EntityMeristem' do
      begin
        refInstance := refInstance.GetFather();
      end;
      reallocationCoeff := (refInstance as TEntityInstance).GetTAttribute('realocationCoeff').GetCurrentSample().value;
      SRwriteln('reallocationCoeff          --> ' + FloatToStr(reallocationCoeff));
      computedReallocBiomass := reallocationCoeff * delta;
      computedSenesc_dw := delta - computedReallocBiomass;
      SRwriteln('computedReallocBiomass     --> ' + FloatToStr(computedReallocBiomass));
      SRwriteln('dailySenescedLeafBiomass   --> ' + FloatToStr(computedReallocBiomass));
      SRwriteln('computedSenesc_dw          --> ' + FloatToStr(computedSenesc_dw));
      refTa := (instance as TEntityInstance).GetTAttribute('dailySenescedLeafBiomass');
      sample := refTa.GetCurrentSample();
      sample.value := computedReallocBiomass;
      refTa.SetSample(sample);
      //refTAttribute := ((refInstance as TEntityInstance).GetTAttribute('stock') as TAttributeTableOut);
      //sample := refTAttribute.GetCurrentSample();
      //stock := sample.value + computedReallocBiomass;
      //sample.value := stock;
      //refTAttribute.SetSample(sample);
      refTAttribute := ((refInstance as TEntityInstance).GetTAttribute('senesc_dw') as TAttributeTableOut);
      sample := refTAttribute.GetCurrentSample();
      senesc_dw := sample.value + computedSenesc_dw;
      sample.value := senesc_dw;
      refTAttribute.SetSample(sample);
      refTAttribute := ((refInstance as TEntityInstance).GetTAttribute('computedReallocBiomass') as TAttributeTableOut);
      sample := refTAttribute.GetCurrentSample();
      sample.value := sample.value + computedReallocBiomass;
      refTAttribute.SetSample(sample);
    end
    else
    begin
      correctedLeafBiomass := 0;
    end;
  end;
end;

procedure ComputeDeadLeafBiomass(var instance : TInstance; var deadLeafBiomass : Double);
var
  state : Integer;
  bladeArea, lifespan, SLA, G_L : Double;
  tAir, tB, thermalTime : Double;
  refInstance : TInstance;
begin
  state := (instance as TEntityInstance).GetCurrentState();
  if (state <> 2000) then
  begin
    if ((state = 4) or (state = 5)) then
    begin
      bladeArea := (instance as TEntityInstance).GetTAttribute('bladeArea').GetCurrentSample().value;
      lifespan := (instance as TEntityInstance).GetTAttribute('lifespan').GetCurrentSample().value;
      SLA := (instance as TEntityInstance).GetTAttribute('leafBiomassStructAtInitiation').GetCurrentSample().value;
      G_L := (instance as TEntityInstance).GetTAttribute('G_L').GetCurrentSample().value;
      refInstance := instance.GetFather();
      while refInstance.GetName() <> 'EntityMeristem' do
      begin
        refInstance := refInstance.GetFather();
      end;
      tAir := (refInstance as TEntityInstance).GetTAttribute('Tair').GetCurrentSample().value;
      tB := (refInstance as TEntityInstance).GetTAttribute('Tb').GetCurrentSample().value;
      thermalTime := tAir - tB;
      deadLeafBiomass := bladeArea * (1 + G_L) * (thermalTime / lifespan) / SLA;
      SRwriteln('bladeArea       --> ' + FloatToStr(bladeArea));
      SRwriteln('lifespan        --> ' + FloatToStr(lifespan));
      SRwriteln('SLA             --> ' + FloatToStr(SLA));
      SRwriteln('G_L             --> ' + FloatToStr(G_L));
      SRwriteln('thermalTime     --> ' + FloatToStr(thermalTime));
      SRwriteln('deadLeafBiomass --> ' + FloatToStr(deadLeafBiomass));
    end
    else
    begin
      deadLeafBiomass := 0;
    end;
  end;
end;

procedure ComputeLeavesSenescenceStock(var instance : TInstance; const reallocCoef : Double; var senesc_dw, stock : Double);
var
  i, le, leafState : Integer;
  currentInstance : TInstance;
  deadLeafBiomass : Double;
begin
  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      if ((currentInstance as TEntityInstance).GetCategory() = 'Leaf') then
      begin
        leafState := (currentInstance as TEntityInstance).GetCurrentState();
        if (leafState <> 2000) then
        begin
          if ((leafState = 4) or (leafState = 5)) then
          begin
            SRwriteln(currentInstance.GetName() + ' --> ligulee');
            deadLeafBiomass := (currentInstance as TEntityInstance).GetTAttribute('deadLeafBiomass').GetCurrentSample().value;
            SRwriteln('reallocCoef     --> ' + FloatToStr(reallocCoef));
            SRwriteln('deadLeafBiomass --> ' + FloatToStr(deadLeafBiomass));
            SRwriteln('delta stock     --> ' + FloatToStr(deadLeafBiomass * reallocCoef));
            SRwriteln('delta senesc_dw --> ' + FloatToStr(deadLeafBiomass * (1 - reallocCoef)));
            SRwriteln('AVANT');
            SRwriteln('-----');
            SRwriteln('stock           --> ' + FloatToStr(stock));
            SRwriteln('senesc_dw       --> ' + FloatToStr(senesc_dw));
            stock := stock + (deadLeafBiomass * reallocCoef);
            senesc_dw := senesc_dw + (deadLeafBiomass * (1 - reallocCoef));
            SRwriteln('APRES');
            SRwriteln('-----');
            SRwriteln('stock           --> ' + FloatToStr(stock));
            SRwriteln('senesc_dw       --> ' + FloatToStr(senesc_dw));
          end
          else
          begin
            SRwriteln(currentInstance.GetName() + ' --> pas ligulee');
          end;
        end;
      end;
    end;
  end;
end;

procedure ComputeBiomassInAllLeaves(var instance : TInstance; var biomLeafStruct : Double);
var
  i1, i2, le1, le2, stateLeaf : Integer;
  currentInstance1, currentInstance2 : TInstance;
  biomLeaf : Double;
begin
  biomLeafStruct := 0;
  le1 := (instance as TEntityInstance).LengthTInstanceList();
  for i1 := 0 to le1 - 1 do
  begin
    currentInstance1 := (instance as TEntityInstance).GetTInstance(i1);
    if (currentInstance1 is TEntityInstance) then
    begin
      if ((currentInstance1 as TEntityInstance).GetCategory() = 'Leaf') then
      begin
        stateLeaf := (currentInstance1 as TEntityInstance).GetCurrentState();
        if (stateLeaf <> 2000) then
        begin
          if ((stateLeaf = 4) or (stateLeaf = 5)) then
          begin
            SRwriteln('Feuille : ' + currentInstance1.GetName() + ' ligulee');
            biomLeaf := (currentInstance1 as TEntityInstance).GetTAttribute('correctedLeafBiomass').GetCurrentSample().value;
          end
          else
          begin
            SRwriteln('Feuille : ' + currentInstance1.GetName() + ' pas ligulee');
            biomLeaf := (currentInstance1 as TEntityInstance).GetTAttribute('biomass').GetCurrentSample().value;
          end;
          SRwriteln('biomLeaf       --> ' + FloatToStr(biomLeaf));
          biomLeafStruct := biomLeafStruct + biomLeaf;
          SRwriteln('biomLeafStruct --> ' + FloatToStr(biomLeafStruct));
        end;
      end
      else
      begin
        if ((currentInstance1 as TEntityInstance).GetCategory() = 'Tiller') then
        begin
          le2 := (currentInstance1 as TEntityInstance).LengthTInstanceList();
          for i2 := 0 to le2 - 1 do
          begin
            currentInstance2 := (currentInstance1 as TEntityInstance).GetTInstance(i2);
            if (currentInstance2 is TEntityInstance) then
            begin
              if ((currentInstance2 as TEntityInstance).GetCategory() = 'Leaf') then
              begin
                stateLeaf := (currentInstance2 as TEntityInstance).GetCurrentState();
                if (stateLeaf <> 2000) then
                begin
                  if (((stateLeaf = 4) or (stateLeaf = 5)) and (stateLeaf <> 2000)) then
                  begin
                    SRwriteln('Feuille : ' + currentInstance2.GetName() + ' ligulee');
                    biomLeaf := (currentInstance2 as TEntityInstance).GetTAttribute('correctedLeafBiomass').GetCurrentSample().value;
                  end
                  else
                  begin
                    SRwriteln('Feuille : ' + currentInstance2.GetName() + ' ligulee');
                    biomLeaf := (currentInstance2 as TEntityInstance).GetTAttribute('biomass').GetCurrentSample().value;
                  end;
                  SRwriteln('biomLeaf       --> ' + FloatToStr(biomLeaf));
                  biomLeafStruct := biomLeafStruct + biomLeaf;
                  SRwriteln('biomLeafStruct --> ' + FloatToStr(biomLeafStruct));
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure ComputeBiomassLeavesMainstem(var instance : TInstance; var sumOfMainstemLeafBiomass : Double);
var
  i, le, state : Integer;
  currentInstance : TInstance;
  biomLeaf : Double;
begin
  sumOfMainstemLeafBiomass := 0;
  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      if ((currentInstance as TEntityInstance).GetCategory() = 'Leaf') then
      begin
        state := (currentInstance as TEntityInstance).GetCurrentState();
        if (state <> 2000) then
        begin
          if ((state = 4) or (state = 5)) then
          begin
            SRwriteln('Feuille : ' + currentInstance.GetName() + ' ligulee');
            biomLeaf := (currentInstance as TEntityInstance).GetTAttribute('correctedLeafBiomass').GetCurrentSample().value;
          end
          else
          begin
            SRwriteln('Feuille : ' + currentInstance.GetName() + ' pas ligulee');
            biomLeaf := (currentInstance as TEntityInstance).GetTAttribute('biomass').GetCurrentSample().value;
          end;
          SRwriteln('biomLeaf --> ' + FloatToStr(biomLeaf));
          sumOfMainstemLeafBiomass := sumOfMainstemLeafBiomass + biomLeaf;
          SRwriteln('sumOfMainstemLeafBiomass --> ' + FloatToStr(sumOfMainstemLeafBiomass));
        end;
      end;
    end;
  end;
end;

procedure ComputeBladeAreaInAllLeaves(var instance : TInstance; var PAI : Double);
var
  i1, i2, le1, le2, stateLeaf : Integer;
  currentInstance1, currentInstance2 : TInstance;
  bladeAreaLeaf : Double;
begin
  PAI := 0;
  le1 := (instance as TEntityInstance).LengthTInstanceList();
  for i1 := 0 to le1 - 1 do
  begin
    currentInstance1 := (instance as TEntityInstance).GetTInstance(i1);
    if (currentInstance1 is TEntityInstance) then
    begin
      if ((currentInstance1 as TEntityInstance).GetCategory() = 'Leaf') then
      begin
        stateLeaf := (currentInstance1 as TEntityInstance).GetCurrentState();
        if ((stateLeaf <> 2000) and (stateLeaf <> 500)) then
        begin
          if ((stateLeaf = 4) or (stateLeaf = 5)) then
          begin
            SRwriteln('Feuille : ' + currentInstance1.GetName() + ' ligulee');
            bladeAreaLeaf := (currentInstance1 as TEntityInstance).GetTAttribute('correctedBladeArea').GetCurrentSample().value;
          end
          else
          begin
            SRwriteln('Feuille : ' + currentInstance1.GetName() + ' pas ligulee');
            bladeAreaLeaf := (currentInstance1 as TEntityInstance).GetTAttribute('bladeArea').GetCurrentSample().value;
          end;
          SRwriteln('bladeAreaLeaf --> ' + FloatToStr(bladeAreaLeaf));
          PAI := PAI + bladeAreaLeaf;
          SRwriteln('PAI           --> ' + FloatToStr(PAI));
        end;
      end
      else
      begin
        if ((currentInstance1 as TEntityInstance).GetCategory() = 'Tiller') then
        begin
          le2 := (currentInstance1 as TEntityInstance).LengthTInstanceList();
          for i2 := 0 to le2 - 1 do
          begin
            currentInstance2 := (currentInstance1 as TEntityInstance).GetTInstance(i2);
            if (currentInstance2 is TEntityInstance) then
            begin
              if ((currentInstance2 as TEntityInstance).GetCategory() = 'Leaf') then
              begin
                stateLeaf := (currentInstance2 as TEntityInstance).GetCurrentState();
                if ((stateLeaf <> 2000) and (stateLeaf <> 500)) then
                begin
                  if (((stateLeaf = 4) or (stateLeaf = 5)) and (stateLeaf <> 2000)) then
                  begin
                    SRwriteln('Feuille : ' + currentInstance2.GetName() + ' ligulee');
                    bladeAreaLeaf := (currentInstance2 as TEntityInstance).GetTAttribute('correctedBladeArea').GetCurrentSample().value;
                  end
                  else
                  begin
                    SRwriteln('Feuille : ' + currentInstance2.GetName() + ' pas ligulee');
                    bladeAreaLeaf := (currentInstance2 as TEntityInstance).GetTAttribute('bladeArea').GetCurrentSample().value;
                  end;
                  SRwriteln('bladeAreaLeaf --> ' + FloatToStr(bladeAreaLeaf));
                  PAI := PAI + bladeAreaLeaf;
                  SRwriteln('PAI           --> ' + FloatToStr(PAI));
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure ComputeBladeAreaLeavesMainstem(var instance : TInstance; var sumOfBladeAreaOnMainstem : Double);
var
  i, le, state : Integer;
  currentInstance : TInstance;
  bladeAreaLeaf : Double;
begin
  sumOfBladeAreaOnMainstem := 0;
  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      if ((currentInstance as TEntityInstance).GetCategory() = 'Leaf') then
      begin
        state := (currentInstance as TEntityInstance).GetCurrentState();
        if ((state <> 2000) and (state <> 500)) then
        begin
          if ((state = 4) or (state = 5)) then
          begin
            SRwriteln('Feuille : ' + currentInstance.GetName() + ' ligulee');
            bladeAreaLeaf := (currentInstance as TEntityInstance).GetTAttribute('correctedBladeArea').GetCurrentSample().value;
          end
          else
          begin
            SRwriteln('Feuille : ' + currentInstance.GetName() + ' pas ligulee');
            bladeAreaLeaf := (currentInstance as TEntityInstance).GetTAttribute('bladeArea').GetCurrentSample().value;
          end;
          SRwriteln('bladeAreaLeaf            --> ' + FloatToStr(bladeAreaLeaf));
          sumOfBladeAreaOnMainstem := sumOfBladeAreaOnMainstem + bladeAreaLeaf;
          SRwriteln('sumOfBladeAreaOnMainstem --> ' + FloatToStr(sumOfBladeAreaOnMainstem));
        end;
      end;
    end;
  end;
end;

procedure KillSenescLeaves(var instance : TInstance; var deadLeafNb : Double);
var
  i1, i2, le1, le2, state1, state2 : Integer;
  currentInstance1, currentInstance2 : TInstance;
  category1, category2 : String;
begin
  le1 := (instance as TEntityInstance).LengthTInstanceList();
  for i1 := 0 to le1 - 1 do
  begin
    currentInstance1 := (instance as TEntityInstance).GetTInstance(i1);
    if (currentInstance1 is TEntityInstance) then
    begin
      category1 := (currentInstance1 as TEntityInstance).GetCategory();
      if (category1 = 'Leaf') then
      begin
        state1 := (currentInstance1 as TEntityInstance).GetCurrentState();
        if (state1 = 500) then
        begin
          deadLeafNb := deadLeafNb + 1;
          SRwriteln('La feuille : ' + currentInstance1.GetName() + ' detruite par senescence');
          SRwriteln('deadLeafNb --> ' + FloatToStr(deadLeafNb));
          (instance as TEntityInstance).RemoveTInstance(currentInstance1);
        end;
      end
      else if (category1 = 'Tiller') then
      begin
        le2 := (currentInstance1 as TEntityInstance).LengthTInstanceList();
        for i2 := 0 to le2 do
        begin
          currentInstance2 := (currentInstance1 as TEntityInstance).GetTInstance(i2);
          if (currentInstance2 is TEntityInstance) then
          begin
            category2 := (currentInstance2 as TEntityInstance).GetCategory();
            if (category2 = 'Leaf') then
            begin
              state2 := (currentInstance2 as TEntityInstance).GetCurrentState();
              if (state2 = 500) then
              begin
                deadLeafNb := deadLeafNb + 1;
                SRwriteln('La feuille : ' + currentInstance2.GetName() + ' detruite par senescence');
                SRwriteln('deadLeafNb --> ' + FloatToStr(deadLeafNb));
                (currentInstance1 as TEntityInstance).RemoveTInstance(currentInstance2);
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function FindPredimOrganLength(var instance : TInstance; organRankName, organType : string) : Double;
var
  i, le : Integer;
  currentInstance, refFather : TInstance;
  predim : Double;
begin
  predim := -1;
  refFather := instance.GetFather();
  le := (refFather as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (refFather as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      if ((currentInstance as TEntityInstance).GetCategory() = organType) then
      begin
        if ((currentInstance as TEntityInstance).GetName() = organRankName) then
        begin
          predim := (currentInstance as TEntityInstance).GetTAttribute('predim').GetCurrentSample().value;
        end;
      end;
    end;
  end;
  Result := predim;
end;

function FindFirstNonVegetativePredimOrgan(var instance : TInstance; organType, attributeName : string) : Double;
var
  i, le, state : Integer;
  currentInstance, refFather : TInstance;
  predim : Double;
  find : boolean;
begin
  predim := -1;
  refFather := instance.GetFather();
  le := (refFather as TEntityInstance).LengthTInstanceList();
  i := le - 1;
  find := False;
  while (i >= 0) and not(find) do
  begin
    currentInstance := (refFather as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      state := (currentInstance as TEntityInstance).GetCurrentState();
      if (state <> 2000) and ((currentInstance as TEntityInstance).GetCategory() = organType) then
      begin
        find := True;
      end
      else
      begin
        i := i - 1;
      end;
    end
    else
    begin
      i := i - 1;
    end;
  end;
  if find then
  begin
    if ((currentInstance as TEntityInstance).GetTAttribute(attributeName) is TAttributeTableOut) then
    begin
      predim := ((currentInstance as TEntityInstance).GetTAttribute(attributeName) as TAttributeTableOut).GetCurrentSample().value;
    end
    else
    begin
      predim := (currentInstance as TEntityInstance).GetTAttribute(attributeName).GetCurrentSample().value;
    end;
    SRwriteln('internode name --> ' + currentInstance.GetName());
    SRwriteln('predim         --> ' + FloatToStr(predim));
  end;
  Result := predim;
end;

procedure ComputeInternodeLengthPredim(var instance : TInstance; const slopeLengthIN, leafLengthToINLength : Double; var internodeLengthPredim : Double);
var
  leafPredim, LL_BL, LL_BL_init, slope_LL_BL_at_PI, nbLeafParam2 : Double;
  internodeName, leafRankName : string;
  rank : Integer;
  refFather : TInstance;
begin
  internodeName := instance.GetName();
  rank := Trunc((instance as TEntityInstance).GetTAttribute('rank').GetCurrentSample().value);
  SRwriteln('rank                    --> ' + FloatToStr(rank));
  SRwriteln('slopeLengthIN           --> ' + FloatToStr(slopeLengthIN));
  SRwriteln('leafLengthToINLength    --> ' + FloatToStr(leafLengthToINLength));
  SRwriteln('InternodeName           --> ' + internodeName);
  refFather := instance.GetFather();
  if ((refFather as TEntityInstance).GetCategory() = 'Tiller') then
  begin
    leafRankName := 'L' + IntToStr(rank - 1) + '_'+ (refFather as TEntityInstance).GetName();
  end
  else
  begin
    leafRankName := 'L' + IntToStr(rank - 1);
  end;
  refFather := instance.GetFather();
  while refFather.GetName() <> 'EntityMeristem' do
  begin
    refFather := refFather.GetFather();
  end;
  LL_BL_init := (refFather as TEntityInstance).GetTAttribute('LL_BL_init').GetCurrentSample().value;
  slope_LL_BL_at_PI := (refFather as TEntityInstance).GetTAttribute('slope_LL_BL_at_PI').GetCurrentSample().value;
  nbLeafParam2 := (refFather as TEntityInstance).GetTAttribute('nb_leaf_param2').GetCurrentSample().value;
  if (((rank - 1) - nbLeafParam2) < 0) then
  begin
    LL_BL := LL_BL_init;
  end
  else
  begin
    LL_BL := LL_BL_init + slope_LL_BL_at_PI * ((rank - 1) - nbLeafParam2);
  end;
  SRwriteln('LeafName                --> ' + leafRankName);
  SRwriteln('LL_BL_init              --> ' + FloatToStr(LL_BL_init));
  SRwriteln('slope_LL_BL_at_PI       --> ' + FloatToStr(slope_LL_BL_at_PI));
  SRwriteln('nb_leaf_param2          --> ' + FloatToStr(nbLeafParam2));
  SRwriteln('LL_BL                   --> ' + FloatToStr(LL_BL));
  leafPredim := FindPredimOrganLength(instance, leafRankName, 'Leaf');
  SRwriteln('Leaf predim             --> ' + FloatToStr(leafPredim));
  internodeLengthPredim := Max(0.0001, slopeLengthIN * (1 - (1 / LL_BL)) * leafPredim - leafLengthToINLength);
  SRwriteln('Internode length predim --> ' + FloatToStr(internodeLengthPredim));
end;

procedure ComputeInternodeDiameterPredim2(const INLengthToINDiam, coefLinINDIam, internodeLengthPredim : Double; var internodeDiameterPredim : Double);
begin
  SRwriteln('INLengthToINDiam        --> ' + FloatToStr(INLengthToINDiam));
  SRwriteln('internodeLengthPredim   --> ' + FloatToStr(internodeLengthPredim));
  SRwriteln('coefLinINDIam           --> ' + FloatToStr(coefLinINDIam));
  internodeDiameterPredim := INLengthToINDiam * internodeLengthPredim + coefLinINDIam;
  SRwriteln('internodeDiameterPredim --> ' + FloatToStr(internodeDiameterPredim));  
end;

procedure ComputePeduncleLengthPredim(var instance : TInstance; const ratioINPed : Double; var peduncleLengthPredim : Double);
var
  internodePredim : Double;
begin
  internodePredim := FindFirstNonVegetativePredimOrgan(instance, 'Internode', 'predim');
  peduncleLengthPredim := ratioINPed * internodePredim;
  SRwriteln('rationINPed          --> ' + FloatToStr(ratioINPed));
  SRwriteln('internodePredim      --> ' + FloatToStr(internodePredim));
  SRwriteln('peduncleLengthPredim --> ' + FloatToStr(peduncleLengthPredim));
end;

procedure ComputePeduncleDiameterPredim(var instance : TInstance; const peduncleDiam : Double; var peduncleDiameterPredim : Double);
var
  internodePredim : Double;
begin
  SRwriteln('ok');
  internodePredim := FindFirstNonVegetativePredimOrgan(instance, 'Internode', 'DIN');
  peduncleDiameterPredim := peduncleDiam * internodePredim;
  SRwriteln('peduncleDiam           --> ' + FloatToStr(peduncleDiam));
  SRwriteln('internodePredim        --> ' + FloatToStr(internodePredim));
  SRwriteln('peduncleDiameterPredim --> ' + FloatToStr(peduncleDiameterPredim));
end;

procedure ComputeStructLeaf(var instance : TInstance; var structLeaf : Double);
var
  i1, le1, i2, le2 : Integer;
  currentInstance1, currentInstance2 : TInstance;
  state1, state2 : Integer;
  strLeaf : Double;
begin
  structLeaf := 0;
  le1 := (instance as TEntityInstance).LengthTInstanceList();
  for i1 := 0 to le1 - 1 do
  begin
    currentInstance1 := (instance as TEntityInstance).GetTInstance(i1);
    if (currentInstance1 is TEntityInstance) then
    begin
      if ((currentInstance1 as TEntityInstance).GetCategory() = 'Leaf') then
      begin
        state1 := (currentInstance1 as TEntityInstance).GetCurrentState();
        if ((state1 = 4) or (state1 = 5)) then
        begin
          strLeaf := (currentInstance1 as TEntityInstance).GetTAttribute('correctedLeafBiomass').GetCurrentSample().value;
          SRwriteln(currentInstance1.GetName() + ' : correctedLeafBiomass --> ' + FloatToStr(strLeaf));
        end
        else
        begin
          strLeaf := (currentInstance1 as TEntityInstance).GetTAttribute('biomass').GetCurrentSample().value;
          SRwriteln(currentInstance1.GetName() + ' : biomass              --> ' + FloatToStr(strLeaf));
        end;
        structLeaf := structLeaf + strLeaf
      end
      else if ((currentInstance1 as TEntityInstance).GetCategory() = 'Tiller') then
      begin
        le2 := (currentInstance1 as TEntityInstance).LengthTInstanceList();
        for i2 := 0 to le2 - 1 do
        begin
          currentInstance2 := (currentInstance1 as TEntityInstance).GetTInstance(i2);
          if (currentInstance2 is TEntityInstance) then
          begin
            if ((currentInstance2 as TEntityInstance).GetCategory() = 'Leaf') then
            begin
              state2 := (currentInstance2 as TEntityInstance).GetCurrentState();
              if ((state2 = 4) or (state2 = 5)) then
              begin
                strLeaf := (currentInstance2 as TEntityInstance).GetTAttribute('correctedLeafBiomass').GetCurrentSample().value;
                SRwriteln(currentInstance2.GetName() + ' : correctedLeafBiomass --> ' + FloatToStr(strLeaf));
              end
              else
              begin
                strLeaf := (currentInstance2 as TEntityInstance).GetTAttribute('biomass').GetCurrentSample().value;
                SRwriteln(currentInstance2.GetName() + ' : biomass              --> ' + FloatToStr(strLeaf));
              end;
              structLeaf := structLeaf + strLeaf;
            end;
          end;
        end;
      end;
    end;
  end;
  SRwriteln('Total --> ' + FloatToStr(structLeaf));
end;

procedure ComputeSumOfBiomass(var instance : TInstance; var sumOfBiomass : Double);
var
  i1, i2, le1, le2 : Integer;
  state1, state2 : Integer;
  currentInstance1, currentInstance2 : TInstance;
  biomass : Double;
begin
  sumOfBiomass := 0;
  le1 := (instance as TEntityInstance).LengthTInstanceList();
  for i1 := 0 to le1 - 1 do
  begin
    currentInstance1 := (instance as TEntityInstance).GetTInstance(i1);
    if (currentInstance1 is TEntityInstance) then
    begin
      if ((currentInstance1 as TEntityInstance).GetCategory() <> 'Tiller') then
      begin
        if ((currentInstance1 as TEntityInstance).GetCategory() = 'Leaf') then
        begin
          state1 := (currentInstance1 as TEntityInstance).GetCurrentState();
          if ((state1 = 4) or (state1 = 5)) then
          begin
            biomass := (currentInstance1 as TEntityInstance).GetTAttribute('correctedLeafBiomass').GetCurrentSample().value;
            SRwriteln('contribution (senesc) de : ' + currentInstance1.GetName() + ' --> ' + FloatToStr(biomass));
            sumOfBiomass := sumOfBiomass + biomass;
          end
          else
          begin
            biomass := (currentInstance1 as TEntityInstance).GetTAttribute('biomass').GetCurrentSample().value;
            SRwriteln('contribution de : ' + currentInstance1.GetName() + ' --> ' + FloatToStr(biomass));
            sumOfBiomass := sumOfBiomass + biomass;
          end;
        end
        else if ((currentInstance1 as TEntityInstance).GetTAttribute('biomassIN') <> nil) then
        begin
          biomass := (currentInstance1 as TEntityInstance).GetTAttribute('biomassIN').GetCurrentSample().value;
          SRwriteln('contribution de : ' + currentInstance1.GetName() + ' --> ' + FloatToStr(biomass));
          sumOfBiomass := sumOfBiomass + biomass;
        end
        else if ((currentInstance1 as TEntityInstance).GetTAttribute('weight_panicle') <> nil) then
        begin
          biomass := (currentInstance1 as TEntityInstance).GetTAttribute('weight_panicle').GetCurrentSample().value;
          SRwriteln('contribution de : ' + currentInstance1.GetName() + ' --> ' + FloatToStr(biomass));
          sumOfBiomass := sumOfBiomass + biomass;
        end;
      end
      else
      begin
        le2 := (currentInstance1 as TEntityInstance).LengthTInstanceList();
        for i2 := 0 to le2 - 1 do
        begin
          currentInstance2 := (currentInstance1 as TEntityInstance).GetTInstance(i2);
          if (currentInstance2 is TEntityInstance) then
          begin
            if ((currentInstance2 as TEntityInstance).GetCategory() = 'Leaf') then
            begin
              state2 := (currentInstance2 as TEntityInstance).GetCurrentState();
              if ((state2 = 4) or (state2 = 5)) then
              begin
                biomass := (currentInstance2 as TEntityInstance).GetTAttribute('correctedLeafBiomass').GetCurrentSample().value;
                SRwriteln('contribution (senesc) de : ' + currentInstance2.GetName() + ' --> ' + FloatToStr(biomass));
                sumOfBiomass := sumOfBiomass + biomass;
              end
              else
              begin
                biomass := (currentInstance2 as TEntityInstance).GetTAttribute('biomass').GetCurrentSample().value;
                SRwriteln('contribution de : ' + currentInstance2.GetName() + ' --> ' + FloatToStr(biomass));
                sumOfBiomass := sumOfBiomass + biomass;
              end;
            end
            else if ((currentInstance2 as TEntityInstance).GetTAttribute('biomassIN') <> nil) then
            begin
              biomass := (currentInstance2 as TEntityInstance).GetTAttribute('biomassIN').GetCurrentSample().value;
              SRwriteln('contribution de : ' + currentInstance2.GetName() + ' --> ' + FloatToStr(biomass));
              sumOfBiomass := sumOfBiomass + biomass;
            end
            else if ((currentInstance2 as TEntityInstance).GetTAttribute('weight_panicle') <> nil) then
            begin
              biomass := (currentInstance2 as TEntityInstance).GetTAttribute('weight_panicle').GetCurrentSample().value;
              SRwriteln('contribution de : ' + currentInstance2.GetName() + ' --> ' + FloatToStr(biomass));
              sumOfBiomass := sumOfBiomass + biomass;
            end;
          end;
        end;
      end;
    end;
  end;
  SRwriteln('sumOfBiomass --> ' + FloatToStr(sumOfBiomass));
end;

procedure ComputeWeightPanicle(var instance : TInstance; var weightPanicle, weightPanicleMainstem : Double);
var
  i1, i2, le1, le2 : Integer;
  currentInstance1, currentInstance2 : TInstance;
  dWeightPanicle : Double;
begin
  weightPanicle := 0;
  weightPanicleMainstem := 0;
  le1 := (instance as TEntityInstance).LengthTInstanceList();
  for i1 := 0 to le1 - 1 do
  begin
    currentInstance1 := (instance as TEntityInstance).GetTInstance(i1);
    if (currentInstance1 is TEntityInstance) then
    begin
      if ((currentInstance1 as TEntityInstance).GetCategory() = 'Panicle') then
      begin
        dWeightPanicle := (currentInstance1 as TEntityInstance).GetTAttribute('weight_panicle').GetCurrentSample().value;
        weightPanicleMainstem := dWeightPanicle;
        weightPanicle := weightPanicle + dWeightPanicle;
        SRwriteln('dWeightPanicle          --> ' + FloatToStr(dWeightPanicle));
        SRwriteln('weight_panicle_mainstem --> ' + FloatToStr(weightPanicleMainstem));
      end
      else if ((currentInstance1 as TEntityInstance).GetCategory() = 'Tiller') then
      begin
        le2 := (currentInstance1 as TEntityInstance).LengthTInstanceList();
        for i2 := 0 to le2 - 1 do
        begin
          currentInstance2 := (currentInstance1 as TEntityInstance).GetTInstance(i2);
          if (currentInstance2 is TEntityInstance) then
          begin
            if ((currentInstance2 as TEntityInstance).GetCategory() = 'Panicle') then
            begin
              dWeightPanicle := (currentInstance2 as TEntityInstance).GetTAttribute('weight_panicle').GetCurrentSample().value;
              weightPanicle := weightPanicle + dWeightPanicle;
              SRwriteln('dWeightPanicle          --> ' + FloatToStr(dWeightPanicle));
            end;
          end;
        end;
      end;
    end;
  end;
  SRwriteln('weight_panicle --> ' + FloatToStr(weightPanicle));
end;

procedure ComputeBiomLeaf(const stock, stockInternodePlant, biomLeafStruct : Double; var structLeaf : Double);
begin
  structLeaf := biomLeafStruct + (stock - stockInternodePlant);
  SRwriteln('stock               --> ' + FloatToStr(stock));
  SRwriteln('stockInternodePlant --> ' + FloatToStr(stockInternodePlant));
  SRwriteln('biomLeafStruct      --> ' + FloatToStr(biomLeafStruct));
  SRwriteln('structLeaf          --> ' + FloatToStr(structLeaf));
end;

procedure SumOfDailySenescedLeafBiomassOnCulm(var instance : TInstance; var sumOfDailySenescedLeafBiomass : Double);
var
  i, le, leafState : Integer;
  currentInstance : TInstance;
  dailySenescedLeafBiomass : Double;
begin
  sumOfDailySenescedLeafBiomass := 0;
  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      if ((currentInstance as TEntityInstance).GetCategory() = 'Leaf') then
      begin
        leafState := (currentInstance as TEntityInstance).GetCurrentState();
        if ((leafState = 4) or (leafState = 5)) then
        begin
          dailySenescedLeafBiomass := (currentInstance as TEntityInstance).GetTAttribute('dailySenescedLeafBiomass').GetCurrentSample().value;
          SRwriteln((currentInstance as TEntityInstance).GetName() + ' dailySenescedLeafBiomass --> ' + FloatToStr(dailySenescedLeafBiomass));
          sumOfDailySenescedLeafBiomass := sumOfDailySenescedLeafBiomass + dailySenescedLeafBiomass;
          SRwriteln('sumOfDailySenescedLeafBiomass --> ' + FloatToStr(sumOfDailySenescedLeafBiomass));
        end;
      end;
    end;
  end;
end;

procedure SumOfDailySenescedLeafBiomass(var instance : TInstance; var total : Double);
var
  i, le : Integer;
  currentInstance : TInstance;
  sumOfSenescedBiomass : Double;
begin
  total := 0;
  sumOfSenescedBiomass := (instance as TEntityInstance).GetTAttribute('sumOfDailySenescedLeafBiomassMainstem').GetCurrentSample().value;
  SRwriteln('sumOfDailySenescedLeafBiomassMainstem --> ' + FloatToStr(sumOfSenescedBiomass));
  total := total + sumOfSenescedBiomass;
  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      if ((currentInstance as TEntityInstance).GetCategory() = 'Tiller') then
      begin
        sumOfSenescedBiomass := (currentInstance as TEntityInstance).GetTAttribute('sumOfDailySenescedLeafBiomassTiller').GetCurrentSample().value;
        SRwriteln(currentInstance.GetName() + ' : sumOfDailySenescedLeafBiomassTiller --> ' + FloatToStr(sumOfSenescedBiomass));
        total := total + sumOfSenescedBiomass;
      end;
    end;
  end;
  SRwriteln('total --> ' + FloatToStr(total));
end;


//----------------------------------------------------------------------------
// LISTE DES PROCEDURES DYNAMIQUES
//----------------------------------------------------------------------------

Procedure ComputeRootDemand_LEDyn(Var T : TPointerProcParam);
Begin
  ComputeRootDemand_LE(T[0],T[1],T[2],T[3],T[4],T[5]);
end;

Procedure ComputeLeafPredimensionnement_LEDyn(Var T : TPointerProcParam);
Begin
  ComputeLeafPredimensionnement_LE(T[0],T[1],T[2],T[3],T[4],T[5],T[6],T[7],T[8]);
end;

Procedure ComputeInternodePredimensionnement_LEDyn(Var T : TPointerProcParam);
begin
  ComputeInternodePredimensionnement_LE(T[0],T[1],T[2],T[3],T[4]);
end;

Procedure ComputeCstr_LEDyn(Var T : TPointerProcParam);
begin
  ComputeCstr_LE(T[0], T[1], T[2]);
end;

Procedure ComputeLER_LEDyn(Var T : TPointerProcParam);
Begin
	ComputeLER_LE(T[0],T[1],T[2],T[3],T[4],T[5]);
end;

Procedure ComputeReductionINER_LEDyn(Var T : TPointerProcParam);
begin
  ComputeReductionINER_LE(T[0],T[1],T[2],T[3],T[4],T[5]);
end;

Procedure ComputeLeafLER_LEDyn(Var T : TPointerProcParam);
Begin
  ComputeLeafLER_LE(T[0],T[1],T[2],T[3],T[4],T[5]);
end;

Procedure ComputeINER_LEDyn(Var T : TPointerProcParam);
begin
  ComputeINER_LE(T[0],T[1],T[2],T[3],T[4],T[5]);
end;

Procedure ComputeLeafWidth_LEDyn(Var T : TPointerProcParam);
Begin
  ComputeLeafWidth_LE(T[0],T[1],T[2],T[3]);
end;

Procedure ComputeLeafBladeArea_LEDyn(Var T : TPointerProcParam);
Begin
  ComputeLeafBladeArea_LE(T[0],T[1],T[2],T[3],T[4]);
end;

Procedure ComputeLeafExpTime_LEDyn(Var T : TPointerProcParam);
Begin
  ComputeLeafExpTime_LE(T[0],T[1],T[2],T[3],T[4],T[5]);
end;

Procedure ComputeInternodeExpTime_LEDyn(Var T : TPointerProcParam);
Begin
  ComputeInternodeExpTime_LE(T[0],T[1],T[2],T[3],T[4],T[5]);
end;

Procedure ComputeLeafBiomass_LEDyn(Var T : TPointerProcParam);
Begin
  ComputeLeafBiomass_LE(T[0],T[1],T[2],T[3]);
end;

procedure ComputeInternodeBiomass_LEDyn(Var T : TPointerProcParam);
begin
  ComputeInternodeBiomass_LE(T[0],T[1],T[2]);
end;

Procedure ComputeLeafDemand_LEDyn(Var T : TPointerProcParam);
Begin
  ComputeLeafDemand_LE(T[0],T[1],T[2],T[3],T[4]);
end;

Procedure ComputeInternodeDemand_LEDyn(Var T : TPointerProcParam);
Begin
  ComputeInternodeDemand_LE(T[0],T[1],T[2],T[3]);
end;

procedure ComputeInternodeStock_LEDyn(Var T : TPointerProcParam);
begin
  ComputeInternodeStock_LE(T[0], T[1], T[2], T[3], T[4], T[5], T[6]);
end;

Procedure UpdateIH_LEDyn(Var T : TPointerProcParam);
begin
    UpdateIH_LE(T[0],T[1],T[2],T[3],T[4]);
end;

Procedure UpdateTT_lig_LEDyn(Var T : TPointerProcParam);
begin
	UpdateTT_lig_LE(T[0],T[1],T[2]);
end;

Procedure UpdateLeafLength_LEDyn(Var T : TPointerProcParam);
Begin
  UpdateLeafLength_LE(T[0],T[1],T[2],T[3]);
end;

Procedure UpdateInternodeLength_LEDyn(Var T : TPointerProcParam);
Begin
  UpdateInternodeLength_LE(T[0],T[1],T[2],T[3]);
end;

Procedure ComputeReservoirDispo_LEDyn(Var T : TPointerProcParam);
Begin
  ComputeReservoirDispo_LE(T[0],T[1],T[2],T[3]);
end;

Procedure UpdateSeedres_LEDyn(Var T : TPointerProcParam);
Begin
  UpdateSeedres_LE(T[0],T[1]);
end;

Procedure UpdateSeedres2_LEDyn(Var T : TPointerProcParam);
begin
	UpdateSeedres2_LE(T[0],T[1],T[2],T[3],T[4],T[5],T[6]);
end;

Procedure UpdateStock_LEDyn(Var T : TPointerProcParam);
Begin
  UpdateStock_LE(T[0],T[1],T[2],T[3],T[4],T[5],T[6],T[7]);
end;

Procedure UpdateSurplus_LEDyn(Var T : TPointerProcParam);
Begin
  UpdateSurplus_LE(T[0],T[1],T[2],T[3],T[4],T[5]);
end;

Procedure ComputeIC_LEDyn(Var T : TPointerProcParam);
Begin
  ComputeIC_LE(T[0],T[1],T[2],T[3],T[4],T[5],T[6],T[7],T[8],T[9],T[10],T[11],T[12],T[13],T[14]);
end;

Procedure UpdateNbTillerCount_LEDyn(Var T : TPointerProcParam);
Begin
  UpdateNbTillerCount_LE(T[0],T[1],T[2],T[3]);
end;

Procedure ComputeBalance_LEDyn(Var T : TPointerProcParam);
Begin
  ComputeBalance_LE(T[0],T[1],T[2],T[3],T[4],T[5]);
end;

Procedure TransitionToLiguleStateDyn(var instance : TInstance; Var T : TPointerProcParam);
Begin
  TransitionToLiguleState(instance,T[0],T[1],T[2]);
end;

Procedure TransitionToMatureStateDyn(var instance : TInstance; Var T : TPointerProcParam);
Begin
  TransitionToMatureState(instance,T[0],T[1],T[2]);
end;

Procedure SumOfLastdemandInLeafRecDyn(var instance : TInstance; Var T : TPointerProcParam);
Begin
  SumOfLastdemandInLeafRec(instance,T[0]);
end;

Procedure EnableNbTillerCount_LEDyn(var instance : TInstance; Var T : TPointerProcParam);
Begin
  EnableNbTillerCount_LE(instance, T[0], T[1]);
end;

Procedure CountNbTiller_LEDyn(var instance : TInstance; Var T : TPointerProcParam);
Begin
  CountNbTiller_LE(instance,T[0]);
end;

Procedure CreateTillers_LEDyn(var instance : TInstance; Var T : TPointerProcParam);
Begin
  CreateTillers_LE(instance,T[0],T[1],T[2],T[3],T[4],T[5],T[6],T[7],T[8],T[9]);
end;

Procedure CreateTillersPhytomer_LEDyn(var instance : TInstance; Var T : TPointerProcParam);
Begin
  CreateTillersPhytomer_LE(instance,T[0],T[1],T[2],T[3],T[4],T[5],T[6],T[7],T[8],T[9]);
end;

procedure CountAndTagOfNbTillerWithMore4Leaves_LEDyn(var instance : TInstance; Var T : TPointerProcParam);
begin
  CountAndTagOfNbTillerWithMore4Leaves_LE(instance, T[0]);
end;

procedure CountOfNbTillerWithMoreNbLeafEnablingTilleringLeaves_LEDyn(var instance : TInstance; Var T : TPointerProcParam);
begin
  CountOfNbTillerWithMoreNbLeafEnablingTilleringLeaves_LE(instance, T[0], T[1]);
end;

Procedure ChangeOrganExeOrder_LEDyn(var instance : TInstance; Var T : TPointerProcParam);
Begin
  ChangeOrganExeOrder_LE(instance);
end;

Procedure KillOldestLeaf_LEDyn(var instance : TInstance; Var T : TPointerProcParam);
Begin
  KillOldestLeaf_LE(instance,T[0],T[1],T[2],T[3],T[4],T[5]);
end;

procedure KillYoungestTillerOldestLeaf_LEDyn(var instance : TInstance; Var T : TPointerProcParam);
begin
  KillYoungestTillerOldestLeaf_LE(instance, T[0],T[1],T[2],T[3],T[4],T[5],T[6],T[7]);
end;

Procedure CountNbLeaf_LEDyn(var instance : TInstance; Var T : TPointerProcParam);
Begin
  CountNbLeaf_LE(instance,T[0]);
end;

Procedure CountOfNbTillerWithMore4Leaves_LEDyn(var instance : TInstance; Var T : TPointerProcParam);
Begin
  CountOfNbTillerWithMore4Leaves_LE(instance,T[0]);
end;

Procedure ComputePHT_LEDyn(var instance : TInstance; Var T : TPointerProcParam);
Begin
  ComputePHT_LE(instance,T[0],T[1],T[2],T[3],T[4],T[5], T[6], T[7], T[8]);
end;

procedure compute_LAI_strDyn(var T : TPointerProcParam);
begin
  compute_LAI_str(T[0],T[1],T[2],T[3]);
end;

procedure computeAssimpot_strDyn(var T : TPointerProcParam);
begin
  computeAssimpot_str(T[0],T[1],T[2],T[3],T[4],T[5]);
end;

procedure DispDyn(var T : TPointerProcParam);
begin
	Disp(T[0]);
end;

procedure ComputeInternodeVolumeDyn(var T : TPointerProcParam);
begin
  ComputeInternodeVolume(T[0],T[1],T[2]);
end;

procedure ComputeInternodeReservoirDispo_LEDyn(var T : TPointerProcParam);
begin
  ComputeInternodeReservoirDispo_LE(T[0],T[1],T[2],T[3]);
end;

procedure ComputeAssimMainstem_LEDyn(var T : TPointerProcParam);
begin
  ComputeAssimMainstem_LE(T[0],T[1],T[2],T[3]);
end;

procedure ComputeAssimTiller_LEDyn(var T : TPointerProcParam);
begin
  ComputeAssimTiller_LE(T[0],T[1],T[2],T[3]);
end;

procedure ComputeReservoirDispoMainstem_LEDyn(var T : TPointerProcParam);
begin
  ComputeReservoirDispoMainstem_LE(T[0],T[1],T[2],T[3],T[4]);
end;

procedure ComputeReservoirDispoTiller_LEDyn(var T : TPointerProcParam);
begin
  ComputeReservoirDispoTiller_LE(T[0],T[1],T[2],T[3],T[4]);
end;

procedure ComputeSurplusMainstem_LEDyn(var T : TPointerProcParam);
begin
  ComputeSurplusMainstem_LE(T[0],T[1],T[2],T[3]);
end;

procedure ComputeSurplusTiller_LEDyn(var T : TPointerProcParam);
begin
  ComputeSurplusTiller_LE(T[0],T[1],T[2],T[3]);
end;

procedure ComputeStockMainstem_LEDyn(var T : TPointerProcParam);
begin
  ComputeStockMainstem_LE(T[0],T[1],T[2],T[3],T[4],T[5]);
end;

procedure ComputeStockMainstem2_LEDyn(var T : TPointerProcParam);
begin
  ComputeStockMainstem2_LE(T[0],T[1],T[2],T[3],T[4]);
end;

procedure ComputeStockTiller_LEDyn(var T : TPointerProcParam);
begin
  ComputeStockTiller_LE(T[0],T[1],T[2],T[3],T[4],T[5]);
end;

procedure ComputeStockTiller2_LEDyn(var T : TPointerProcParam);
begin
  ComputeStockTiller2_LE(T[0], T[1], T[2], T[3], T[4]);
end;

procedure ComputeSWC_LEDyn(var T : TPointerProcParam);
begin
  ComputeSWC_LE(T[0],T[1],T[2]);
end;

procedure TillerSequenceToPI_LEDyn(var instance : TInstance; Var T : TPointerProcParam);
begin
  TillerSequenceToPI_LE(instance, T[0], T[1], T[2], T[3], T[4]);
end;

procedure TillerSequenceToFlo_LEDyn(var instance : TInstance; Var T : TPointerProcParam);
begin
  TillerSequenceToFlo_LE(instance, T[0], T[1], T[2], T[3], T[4]);
end;

procedure ComputeDayDemand_LEDyn(var T : TPointerProcParam);
begin
  ComputeDayDemand_LE(T[0], T[1], T[2], T[3]);
end;

procedure ComputeSupplyPlant_LEDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeSupplyPlant_LE(instance);
end;

procedure ComputeSurplusPlant_LEDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeSurplusPlant_LE(instance);
end;

procedure ComputeStockPlant_LEDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeStockPlant_LE(instance);
end;

procedure ComputeDeficitPlant_LEDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeDeficitPlant_LE(instance);
end;

procedure UpdateRootDemand_LEDyn(var T : TPointerProcParam);
begin
  UpdateRootDemand_LE(T[0], T[1]);
end;

procedure ComputeInternodeDiameterPredim_LEDyn(var T : TPointerProcParam);
begin
  ComputeInternodeDiameterPredim_LE(T[0], T[1], T[2]);
end;

procedure ComputePanicleGrainNb_LEDyn(var T : TPointerProcParam);
begin
  ComputePanicleGrainNb_LE(T[0], T[1], T[2], T[3], T[4], T[5]);
end;

procedure ComputePanicleFertileGrainNumber_LEDyn(var T : TPointerProcParam);
begin
  ComputePanicleFertileGrainNumber_LE(T[0], T[1], T[2]);
end;

procedure ComputePanicleDayDemandFlo_LEDyn(var T : TPointerProcParam);
begin
  ComputePanicleDayDemandFlo_LE(T[0], T[1], T[2], T[3], T[4], T[5]);
end;

procedure ComputePanicleWeightFlo_LEDyn(var T : TPointerProcParam);
begin
  ComputePanicleWeightFlo_LE(T[0], T[1], T[2], T[3], T[4]);
end;

procedure ComputePanicleFilledGrainNbFlo_LEDyn(var T : TPointerProcParam);
begin
  ComputePanicleFilledGrainNbFlo_LE(T[0], T[1], T[2], T[3]);
end;

procedure ComputeStockLeafCulm_LEDyn(var T : TPointerProcParam);
begin
  ComputeStockLeafCulm_LE(T[0], T[1], T[2], T[3], T[4], T[5]);
end;

procedure ComputeStockLeafCulm2_LEDyn(var T : TPointerProcParam);
begin
  ComputeStockLeafCulm2_LE(T[0], T[1], T[2], T[3], T[4], T[5], T[6], T[7], T[8]);
end;

procedure ComputeReservoirDispoLeafCulm_LEDyn(var T : TPointerProcParam);
begin
  ComputeReservoirDispoLeafCulm_LE(T[0], T[1], T[2], T[3]);
end;

procedure ComputeCGRStress_LEDyn(var T : TPointerProcParam);
begin
  ComputeCGRStress_LE(T[0], T[1], T[2], T[3], T[4], T[5]);
end;

procedure SaveTableData_LEDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  SaveTableData_LE(instance);
end;

procedure ComputeDegreeDay_LEDyn(var T : TPointerProcParam);
begin
  ComputeDegreeDay_LE(T[0], T[1], T[2], T[3], T[4], T[5], T[6]);
end;

procedure ComputeNewPlasto_Ligulo_LL_BL_MGRDyn(var T : TPointerProcParam);
begin
  ComputeNewPlasto_Ligulo_LL_BL_MGR(T[0], T[1], T[2], T[3], T[4], T[5], T[6], T[7], T[8], T[9], T[10], T[11], T[12], T[13], T[14]);
end;

Procedure SumOfLastdemandInOrganRecDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  SumOfLastdemandInOrganRec(instance, T[0]);
end;

procedure ComputeAssimTillers_LEDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeAssimTillers_LE(instance);
end;

procedure ComputeStockTillers_LEDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeStockTillers_LE(instance);
end;

procedure ComputeSurplusTillers_LEDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeSurplusTillers_LE(instance);
end;

Procedure OA_StopInterceptionComputation_LEDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  OA_StopInterceptionComputation_LE(instance);
end;

procedure ComputeMaxReservoirCulms_LEDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeMaxReservoirCulms_LE(instance);
end;

procedure ComputeLastDemandCulms_LEDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeLastDemandCulms_LE(instance);
end;

procedure ComputeAssimCulms_LEDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeAssimCulms_LE(instance);
end;

procedure ComputeStockCulms_LEDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeStockCulms_LE(instance);
end;

procedure ComputeDeficitCulms_LEDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeDeficitCulms_LE(instance);
end;

procedure ComputeSurplusCulms_LEDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeSurplusCulms_LE(instance);
end;

procedure ComputeTmpCulms_LEDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeTmpCulms_LE(instance);
end;

procedure ComputeLeafInternodeBiomassCulms_LEDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeLeafInternodeBiomassCulms_LE(instance);
end;

procedure ComputeSumOfBiomassOnInternodeInMatureStateOnCulms_LEDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeSumOfBiomassOnInternodeInMatureStateOnCulms_LE(instance);
end;

procedure ComputeStockInternodeOnCulms_LEDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeStockInternodeOnCulms_LE(instance);
end;

procedure ChangeRootEntityExeOrderDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ChangeRootEntityExeOrder(instance);
end;

procedure ComputeSumOfDemandOnLeafInternodeDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeSumOfDemandOnLeafInternode(instance, T[0]);
end;

procedure ComputeNbActiveInternodesOnMainstemDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeNbActiveInternodesOnMainstem(instance, T[0]);
end;

procedure ComputeStockMainstemOutputDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeStockMainstemOutput(instance, T[0]);
end;

procedure SumOfInternodeLengthOnMainstemDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  SumOfInternodeLengthOnMainstem(instance, T[0]);
end;

procedure ComputeFirstLastExpandedInternodeDiameterMainstemDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeFirstLastExpandedInternodeDiameterMainstem(instance, T[0], T[1], T[2], T[3]);
end;

procedure ComputeStockInternodeMainstemDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeStockInternodeMainstem(instance, T[0]);
end;

procedure ComputeStockInternodeTillersDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeStockInternodeTillers(instance, T[0]);
end;

procedure SetAliveToDeadDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  SetAliveToDead(instance, T[0]);
end;

procedure FindLengthPeduncleDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  FindLengthPeduncle(instance, T[0]);
end;

procedure ComputeLengthPedunclesDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeLengthPeduncles(instance, T[0]);
end;

procedure ComputeThermalTimeSinceLigulation_LEDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeThermalTimeSinceLigulation_LE(instance, T[0]);
end;

procedure ComputeLifespan_LEDyn(var T : TPointerProcParam);
begin
  ComputeLifespan_LE(T[0], T[1], T[2], T[3]);
end;

procedure ComputeCorrectedBladeAreaDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeCorrectedBladeArea(instance, T[0]);
end;

procedure ComputeCorrectedLeafBiomassDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeCorrectedLeafBiomass(instance, T[0]);
end;

procedure ComputeDeadLeafBiomassDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeDeadLeafBiomass(instance, T[0]);
end;

procedure ComputeLeavesSenescenceStockDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeLeavesSenescenceStock(instance, T[0], T[1], T[2]);
end;

procedure ComputeBiomassInAllLeavesDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeBiomassInAllLeaves(instance, T[0]);
end;

procedure ComputeBiomassLeavesMainstemDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeBiomassLeavesMainstem(instance, T[0]);
end;

procedure ComputeBladeAreaInAllLeavesDyn(var instance : TInstance; var T : TPointerProcParam);
begin
   ComputeBladeAreaInAllLeaves(instance, T[0]);
end;

procedure ComputeBladeAreaLeavesMainstemDyn(var instance : TInstance; var T : TPointerProcParam);
begin
   ComputeBladeAreaLeavesMainstem(instance, T[0]);
end;

procedure KillSenescLeavesDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  KillSenescLeaves(instance, T[0]);
end;

procedure ComputeInternodeLengthPredimDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeInternodeLengthPredim(instance, T[0], T[1], T[2]);
end;

procedure ComputeInternodeDiameterPredim2Dyn(var T : TPointerProcParam);
begin
  ComputeInternodeDiameterPredim2(T[0], T[1], T[2], T[3]);
end;

procedure ComputePeduncleLengthPredimDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputePeduncleLengthPredim(instance, T[0], T[1]);
end;

procedure ComputePeduncleDiameterPredimDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputePeduncleDiameterPredim(instance, T[0], T[1]);
end;

procedure ComputeStructLeafDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeStructLeaf(instance, T[0]);
end;

procedure ComputeSumOfBiomassDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeSumOfBiomass(instance, T[0]);
end;

procedure ComputeWeightPanicleDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeWeightPanicle(instance, T[0], T[1]);
end;

procedure ComputeBiomLeafDyn(var T : TPointerProcParam);
begin
  ComputeBiomLeaf(T[0], T[1], T[2], T[3]);
end;

procedure SumOfDailySenescedLeafBiomassOnCulmDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  SumOfDailySenescedLeafBiomassOnCulm(instance, T[0]);
end;

procedure SumOfDailySenescedLeafBiomassDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  SumOfDailySenescedLeafBiomass(instance, T[0]);
end;





// ****************************************************************************
// ****************************************************************************
// ****************************************************************************
// ****************************************************************************
//
// INITIALIZATION
//
// ****************************************************************************
// ****************************************************************************
// ****************************************************************************
// ****************************************************************************
initialization

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeRootDemand_LEDyn,['A','kIn','K','kIn','numOfSimulationDay','kIn','resp_R_d','kIn','P','kIn','R_d','kOut']);
PROC_DECLARATION.SetProcName('ComputeRootDemand_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeLeafPredimensionnement_LEDyn,['isFirstLeaf','kIn','isOnMainstem','kIn','predimOfPreviousLeaf','kIn','predimLeafOnMainstem','kIn','Lef1','kIn','MGR','kIn','testIc','kIn','fcstr','kIn','predimOfCurrentLeaf','kOut']);
PROC_DECLARATION.SetProcName('ComputeLeafPredimensionnement_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATIOn := TProcInstanceInternal.Create('',ComputeInternodePredimensionnement_LEDyn,['leafLength', 'kIn', 'leafLengthToINLength', 'kIn', 'testIc', 'kIn', 'fcstr', 'kIn', 'predimOfCurrentInternode', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeInternodePredimensionnement_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('', ComputeCstr_LEDyn,['FTSW','kIn','ThresTransp', 'kIn', 'Cstr', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeCstr_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeLER_LEDyn,['FTSW','kIn','Thres','kIn','slope','kIn','P','kIn','resp_LER','kIn','reductionLER','kOut']);
PROC_DECLARATION.SetProcName('ComputeLER_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeReductionINER_LEDyn,['FTSW','kIn','Thres','kIn','slope','kIn','P','kIn','resp_LER','kIn','reductionLER','kOut']);
PROC_DECLARATION.SetProcName('ComputeReductionINER_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeLeafLER_LEDyn,['predimOfCurrentLeaf','kIn','reductionLER','kIn','plasto','kIn','phenoStage',',kIn','ligulo','kIn','LER','kOut']);
PROC_DECLARATION.SetProcName('ComputeLeafLER_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeINER_LEDyn,['predimOfCurrentInternode','kIn','reductionINER','kIn','plasto','kIn','phenoStage','kIn','ligulo','kIn','INER','kOut']);
PROC_DECLARATION.SetProcName('ComputeINER_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeLeafWidth_LEDyn,['len','kIn','WLR','kIn','LL_BL','kIn','width','kOut']);
PROC_DECLARATION.SetProcName('ComputeLeafWidth_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeLeafBladeArea_LEDyn,['len','kIn','width','kIn','allo_area','kIn','LL_BL','kIn','bladeArea','kOut']);
PROC_DECLARATION.SetProcName('ComputeLeafBladeArea_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeLeafExpTime_LEDyn,['isFirstLeaf','kIn','isOnMainstem','kIn','predim','kIn','len','kIn','LER','kIn','exp_time','kOut']);
PROC_DECLARATION.SetProcName('ComputeLeafExpTime_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeInternodeExpTime_LEDyn,['isFirstInternode','kIn','isOnMainstem','kIn','predim','kIn','len','kIn','INER','kIn','exp_time','kOut']);
PROC_DECLARATION.SetProcName('ComputeInternodeExpTime_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeInternodeStock_LEDyn,['maximumReserveInInternode', 'kIn', 'biomassIN','kIn','sum','kIn','stockCulm','kIn','demandIN','kIn','stock_IN','kOut', 'deficit_IN', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeInternodeStock_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeLeafBiomass_LEDyn,['bladeArea','kIn','SLA','kIn','G_L','kIn','biomass','kOut']);
PROC_DECLARATION.SetProcName('ComputeLeafBiomass_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeInternodeBiomass_LEDyn,['Volume','kIn','density','kIn','biomass','kOut']);
PROC_DECLARATION.SetProcName('ComputeInternodeBiomass_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeLeafDemand_LEDyn,['bladeArea','kIn','SLA','kIn','G_L','kIn','biomass','kIn','demand','kOut']);
PROC_DECLARATION.SetProcName('ComputeLeafDemand_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeInternodeDemand_LEDyn,['density_In', 'kIn', 'volume', 'kIn', 'biomass', 'kIn', 'demand', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeInternodeDemand_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',UpdateIH_LEDyn,['lig','kIn','TT_lig','kIn','ligulo','kIn','IH','kOut','isFirstStep','kInOut']);
PROC_DECLARATION.SetProcName('UpdateIH_LE');
PROC_LIBRARY.ADDTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',UpdateTT_lig_LEDyn,['EDD','kIn','TT_lig','kInOut','isFirstStep','kInOut']);
PROC_DECLARATION.SetProcName('UpdateTT_lig_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',UpdateLeafLength_LEDyn,['LER','kIn','deltaT','kIn','exp_time','kIn','len','kInOut']);
PROC_DECLARATION.SetProcName('UpdateLeafLength_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',UpdateInternodeLength_LEDyn,['INER','kIn','deltaT','kIn','exp_time','kIn','len','kInOut']);
PROC_DECLARATION.SetProcName('UpdateInternodeLength_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeReservoirDispo_LEDyn,['leakStockMax','kIn','sumOfLeavesBiomass','kIn','stock','kIn','reservoirDispo','kOut']);
PROC_DECLARATION.SetProcName('ComputeReservoirDispo_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',UpdateSeedres_LEDyn,['seedres','kInOut','dayDemand','kInOut']);
PROC_DECLARATION.SetProcName('UpdateSeedres_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',UpdateSeedres2_LEDyn,['reservoirDispo','kIn','supply','kIn','restDayDemand','kOut','seedres','kInOut','dayDemand','kInOut','deficit','kInOut','stock','kInOut']);
PROC_DECLARATION.SetProcName('UpdateSeedres2_LE');  
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',UpdateStock_LEDyn,['dayDemand','kIn','reservoirDispo','kIn','supply','kIn','dailySenescedLeafBiomass','kIn','stock','kInOut','deficit','kInOut','seedres','kInOut','surplus','kOut']);
PROC_DECLARATION.SetProcName('UpdateStock_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',UpdateSurplus_LEDyn,['reservoirDispo','kIn','supply','kIn','seedres','kIn','restDayDemand','kIn','dayDemand','kIn','surplus','kInOut']);
PROC_DECLARATION.SetProcName('UpdateSurplus_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeIC_LEDyn,['seedres','kIn','seedres_previous1','kIn','seedres_previous2','kIn','seedres_previous3','kIn','supply','kIn','supply_previous1','kIn','supply_previous2','kIn','supply_previous3','kIn','dayDemand','kIn','dayDemand_previous1','kIn','dayDemand_previous2','kIn','dayDemand_previous3','kIn','Ic_previous1', 'kIn','Ic','kOut','testIc','kOut']);
PROC_DECLARATION.SetProcName('ComputeIC_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',UpdateNbTillerCount_LEDyn,['Ic','kIn','IcThreshold','kIn','nbExistingTiller','kIn','nbTiller','kInOut']);
PROC_DECLARATION.SetProcName('UpdateNbTillerCount_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeBalance_LEDyn,['stock','kIn','supply','kIn','dayDemand','kIn','seedres','kIn','reservoirDispo', 'kIn','balance','kOut']);
PROC_DECLARATION.SetProcName('ComputeBalance_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',TransitionToLiguleStateDyn,['len','kIn','predim','kIn','isOnMainstem','kIn']);
PROC_DECLARATION.SetProcName('TransitionToLiguleState');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',CountAndTagOfNbTillerWithMore4Leaves_LEDyn,['nbTillerFertile','kOut']);
PROC_DECLARATION.SetProcName('CountAndTagOfNbTillerWithMore4Leaves_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',TransitionToMatureStateDyn,['len','kIn','predim','kIn','isOnMainstem','kIn']);
PROC_DECLARATION.SetProcName('TransitionToMatureState');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SumOfLastdemandInLeafRecDyn,['total','kOut']);
PROC_DECLARATION.SetProcName('SumOfLastdemandInLeafRec');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',EnableNbTillerCount_LEDyn,['stadePheno','kIn', 'nbLeafEnablingTillering', 'kIn']);
PROC_DECLARATION.SetProcName('EnableNbTillerCount_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',CountNbTiller_LEDyn,['total','kOut']);
PROC_DECLARATION.SetProcName('CountNbTiller_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',CreateTillers_LEDyn,['boolCrossedPlasto','kIn','Ic','kIn','Ict','kIn','exeOrder','kIn','P','kIn','resp_Ict','kIn','thresINER', 'kIn','slopeINER', 'kIn', 'leafStockMax', 'kIn', 'nbTiller','kInOut']);
PROC_DECLARATION.SetProcName('CreateTillers_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',CreateTillersPhytomer_LEDyn,['boolCrossedPlasto','kIn','Ic','kIn','Ict','kIn','exeOrder','kIn','P','kIn','resp_Ict','kIn','thresINER', 'kIn','slopeINER', 'kIn', 'leafStockMax', 'kIn', 'nbTiller','kInOut']);
PROC_DECLARATION.SetProcName('CreateTillersPhytomer_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ChangeOrganExeOrder_LEDyn,[]);
PROC_DECLARATION.SetProcName('ChangeOrganExeOrder_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',KillOldestLeaf_LEDyn,['realocationCoeff','kIn','deficit','kInOut','stock','kInOut','senesc_dw','kInOut','deadleafNb','kInOut','computedReallocBiomass','kOut']);
PROC_DECLARATION.SetProcName('KillOldestLeaf_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',KillYoungestTillerOldestLeaf_LEDyn,['reallocationCoeff','kIn','nbLeafEnablingTillering','kIn','deficit','kInOut','stock','kInOut','senesc_dw','kInOut','deadleafNb','kInOut','deadTillerNb','kInOut','computedReallocBiomass','kInOut']);
PROC_DECLARATION.SetProcName('KillYoungestTillerOldestLeaf_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',CountNbLeaf_LEDyn,['total','kOut']);
PROC_DECLARATION.SetProcName('CountNbLeaf_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',CountOfNbTillerWithMore4Leaves_LEDyn,['nbTillerWithMore4Leaves','kOut']);
PROC_DECLARATION.SetProcName('CountOfNbTillerWithMore4Leaves_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',CountOfNbTillerWithMoreNbLeafEnablingTilleringLeaves_LEDyn,['nbLeafEnablingTillering', 'kIn', 'nbTillerWithMore4Leaves','kOut']);
PROC_DECLARATION.SetProcName('countOfNbTillerWithMoreNbLeafEnablingTilleringLeaves_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputePHT_LEDyn,['G_L','kIn','LL_BL','kIn','stockPlant','kIn','stockInternodePlant','kIn','structLeaf','kIn','PHT','kInOut','SLALFEL','kInOut','AreaLFEL','kInOut','DWLFEL','kInOut']);
PROC_DECLARATION.SetProcName('ComputePHT_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',TillerSequenceToPI_LEDyn,['n','kIn','nbLeafPI','kIn','coeffPILag','kIn', 'isNewPlasto', 'kIn','addedLag','kInOut']);
PROC_DECLARATION.SetProcName('TillerSequenceToPI_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',TillerSequenceToFlo_LEDyn,['n','kIn','nbLeafFlo','kIn','coeffFloLag','kIn', 'isNewPlasto', 'kIn','addedLag','kInOut']);
PROC_DECLARATION.SetProcName('TillerSequenceToFlo_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',compute_LAI_strDyn,['PAI','kIn','density','kIn','fcstr','kIn','LAI','kOut']);
PROC_DECLARATION.SetProcName('compute_LAI_str');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',computeAssimpot_strDyn,['radiationinterception','kIn','epsib','kIn','radiation','kIn','fcstr', 'kIn', 'Kpar','kIn','potentialAssimilation','kOut']);
PROC_DECLARATION.SetProcName('computeAssimpot_str');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',DispDyn,['value','kIn']);
PROC_DECLARATION.SetProcName('Disp');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeInternodeVolumeDyn,['Length', 'kIn', 'Diameter', 'kIn', 'Volume', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeInternodeVolume');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeInternodeReservoirDispo_LEDyn,['biomass_IN', 'kIn', 'stock_IN', 'kIn', 'reservoirDispo_IN', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeInternodeReservoirDispo_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeAssimMainstem_LEDyn,['assimPlant', 'kIn', 'sumOfBladeAreaOnMainstem', 'kIn', 'sumOfBladeAreaPlant', 'kIn', 'assimMainstem', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeAssimMainstem_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeAssimTiller_LEDyn,['assimPlant', 'kIn', 'sumOfBladeAreaOnTiller', 'kIn', 'sumOfBladeAreaPlant', 'kIn', 'assimTiller', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeAssimTiller_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeReservoirDispoMainstem_LEDyn,['maxReserveInInternode','kIn','SumOfBiomassInMainstemInternode', 'kIn', 'leafStockMax', 'kIn', 'SumOfBiomassInMainstemLeaf', 'kIn', 'ReservoirDispoMainstem', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeReservoirDispoMainstem_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeReservoirDispoTiller_LEDyn,['maxReserveInInternode','kIn','SumOfBiomassInTillerInternode', 'kIn', 'leafStockMax', 'kIn', 'SumOfBiomassInTillerLeaf', 'kIn', 'ReservoirDispoTiller', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeReservoirDispoTiller_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeSurplusMainstem_LEDyn,['SupplyMainstem', 'kIn', 'DemandOfNonINMainstem', 'kIn', 'ReservoirDispoMainstem', 'kIn', 'SurplusMainstem', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeSurplusMainstem_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeSurplusTiller_LEDyn,['SupplyTiller', 'kIn', 'DemandOfNonINTiller', 'kIn', 'ReservoirDispoTiller', 'kIn', 'SurplusTiller', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeSurplusTiller_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeStockMainstem_LEDyn,['sumOfStockINMainstem', 'kIn', 'stockLeafMainstem', 'kIn', 'reservoirDispoMainstem', 'kIn', 'supplyMainstem', 'kIn', 'sumOfDemandNonINMainstem', 'kIn', 'stockMainstem', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeStockMainstem_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeStockMainstem2_LEDyn,['sumOfStockINMainstem', 'kIn', 'stockLeafMainstem', 'kIn', 'reservoirDispoMainstem', 'kIn', 'supplyMainstem', 'kIn', 'stockMainstem', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeStockMainstem2_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeStockTiller_LEDyn,['sumOfStockINTiller', 'kIn', 'stockLeafTiller', 'kIn', 'reservoirDispoTiller', 'kIn', 'supplyTiller', 'kIn', 'sumOfDemandNonINTiller', 'kIn', 'stockTiller', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeStockTiller_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeStockTiller2_LEDyn,['sumOfStockINTiller', 'kIn', 'stockLeafTiller', 'kIn', 'reservoirDispoTiller', 'kIn', 'supplyTiller', 'kIn', 'stockTiller', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeStockTiller2_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeSWC_LEDyn,['deltap', 'kIn', 'waterSupply', 'kIn', 'SWC', 'kInOut']);
PROC_DECLARATION.SetProcName('ComputeSWC_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeDayDemand_LEDyn,['sumOfDemand', 'kIn', 'lastDemand', 'kIn', 'nbDayOfSimulation', 'kIn', 'dayDemand', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeDayDemand_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeSupplyPlant_LEDyn,[]);
PROC_DECLARATION.SetProcName('ComputeSupplyPlant_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeStockPlant_LEDyn,[]);
PROC_DECLARATION.SetProcName('ComputeStockPlant_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeDeficitPlant_LEDyn,[]);
PROC_DECLARATION.SetProcName('ComputeDeficitPlant_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeSurplusPlant_LEDyn,[]);
PROC_DECLARATION.SetProcName('ComputeSurplusPlant_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',UpdateRootDemand_LEDyn,['rootDemand', 'kInOut', 'surplusPlant', 'kInOut']);
PROC_DECLARATION.SetProcName('UpdateRootDemand_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeInternodeDiameterPredim_LEDyn,['leafWidthToINDiameter', 'kIn', 'leafOnSameRankWidth', 'kIn', 'diameter', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeInternodeDiameterPredim_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputePanicleGrainNb_LEDyn,['spikeCreationRate', 'kIn', 'Tair', 'kIn', 'Tb', 'kIn', 'fcstr', 'kIn', 'testIc', 'kIn', 'grainNb', 'kInOut']);
PROC_DECLARATION.SetProcName('ComputePanicleGrainNb_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputePanicleFertileGrainNumber_LEDyn,['fcstr', 'kIn', 'testIc', 'kIn', 'fertileGrainNumber', 'kInOut']);
PROC_DECLARATION.SetProcName('computePanicleFertileGrainNumber_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputePanicleDayDemandFlo_LEDyn,['fillingRate', 'kIn', 'Tair', 'kIn', 'Tb', 'kIn', 'fcstr', 'kIn', 'testIc', 'kIn', 'panicleDayDemand', 'kOut']);
PROC_DECLARATION.SetProcName('computePanicleDayDemandFlo_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputePanicleWeightFlo_LEDyn,['gdwEmpty', 'kIn', 'grainNb', 'kIn', 'panicleDayDemand', 'kIn', 'firstDayOfFLO', 'kInOut', 'panicleWeight', 'kInOut']);
PROC_DECLARATION.SetProcName('computePanicleWeightFlo_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputePanicleFilledGrainNbFlo_LEDyn,['fertileGrainNb', 'kIn', 'panicleWeight', 'kIn', 'gdw', 'kIn', 'filledGrainNb', 'kOut']);
PROC_DECLARATION.SetProcName('computePanicleFilledGrainNbFlo_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeStockLeafCulm_LEDyn,['leafStockMax', 'kIn', 'sumOfBiomassInLeafCulm', 'kIn', 'stockCulm', 'kIn', 'sumOfCulmDemandIN', 'kIn', 'sumOfCulmStockIN', 'kIn', 'stockLeafCulm', 'kOut']);
PROC_DECLARATION.SetProcName('computeStockLeafCulm_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeStockLeafCulm2_LEDyn,['leafStockMax', 'kIn', 'sumOfBiomassInLeafCulm', 'kIn', 'stockCulm', 'kIn', 'sumOfCulmStockIN', 'kIn', 'sumOfCulmDeficitIN', 'kIn', 'sumOfCulmDemandNonIN', 'kIN', 'sumOfCulmLastDemand', 'kIn', 'sumOfCulmDemandIN', 'kIn', 'stockLeafCulm', 'kOut']);
PROC_DECLARATION.SetProcName('computeStockLeafCulm2_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeReservoirDispoLeafCulm_LEDyn,['leafStockMax', 'kIn', 'sumOfBiomassInLeafCulm', 'kIn', 'stockLeafCulm', 'kIn', 'reservoirDispoLeafCulm', 'kOut']);
PROC_DECLARATION.SetProcName('computeReservoirDispoLeafCulm_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeCGRStress_LEDyn,['BoolSwitch', 'kIn', 'BiomAero2', 'kIn', 'TT', 'kIn', 'BiomAero2StressOnSet', 'kInOut', 'TTStressOnSet', 'kInOut', 'CGRStress', 'kOut']);
PROC_DECLARATION.SetProcName('computeCGRStress_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SaveTableData_LEDyn,[]);
PROC_DECLARATION.SetProcName('saveTableData_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeDegreeDay_LEDyn,['TMax', 'kIn', 'TMin', 'kIn', 'TBase', 'kIn', 'TLet', 'kIn', 'TOpt1', 'kIn', 'TOpt2', 'kIn', 'DegreeDay', 'kOut']);
PROC_DECLARATION.SetProcName('computeDegreeDay_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeNewPlasto_Ligulo_LL_BL_MGRDyn,['n', 'kIn', 'boolCrossedPlasto', 'kIn', 'nbLeafParam2', 'kIn', 'slopeLL_BL', 'kIn', 'coeffPlastoPI', 'kIn', 'coeffLiguloPI', 'kIn', 'coeffMGRPI', 'kIn', 'stock', 'kIn', 'nbLeafPI', 'kIN', 'nbLeafMaxAfterPI', 'kIn', 'LL_BL_init', 'kIn', 'plasto', 'kInOut', 'ligulo', 'kInOut', 'LL_BL', 'kInOut', 'MGR', 'kInOut']);
PROC_DECLARATION.SetProcName('computeNewPlasto_Ligulo_LL_BL_MGR');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SumOfLastdemandInOrganRecDyn,['total','kOut']);
PROC_DECLARATION.SetProcName('SumOfLastdemandInOrganRec');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeAssimTillers_LEDyn,[]);
PROC_DECLARATION.SetProcName('ComputeAssimTillers_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeStockTillers_LEDyn,[]);
PROC_DECLARATION.SetProcName('ComputeStockTillers_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeSurplusTillers_LEDyn,[]);
PROC_DECLARATION.SetProcName('ComputeSurplusTillers_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',OA_StopInterceptionComputation_LEDyn,[]);
PROC_DECLARATION.SetProcName('OA_StopInterceptionComputation_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeMaxReservoirCulms_LEDyn,[]);
PROC_DECLARATION.SetProcName('ComputeMaxReservoirCulms_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeLastDemandCulms_LEDyn,[]);
PROC_DECLARATION.SetProcName('ComputeLastDemandCulms_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeAssimCulms_LEDyn,[]);
PROC_DECLARATION.SetProcName('ComputeAssimCulms_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeStockCulms_LEDyn,[]);
PROC_DECLARATION.SetProcName('ComputeStockCulms_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeDeficitCulms_LEDyn,[]);
PROC_DECLARATION.SetProcName('ComputeDeficitCulms_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeSurplusCulms_LEDyn,[]);
PROC_DECLARATION.SetProcName('ComputeSurplusCulms_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeTmpCulms_LEDyn,[]);
PROC_DECLARATION.SetProcName('ComputeTmpCulms_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeLeafInternodeBiomassCulms_LEDyn,[]);
PROC_DECLARATION.SetProcName('ComputeLeafInternodeBiomassCulms_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeSumOfBiomassOnInternodeInMatureStateOnCulms_LEDyn,[]);
PROC_DECLARATION.SetProcName('ComputeSumOfBiomassOnInternodeInMatureStateOnCulms_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeStockInternodeOnCulms_LEDyn,[]);
PROC_DECLARATION.SetProcName('ComputeStockInternodeOnCulms_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ChangeRootEntityExeOrderDyn,[]);
PROC_DECLARATION.SetProcName('changeRootEntityExeOrder');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeSumOfDemandOnLeafInternodeDyn,['total','kOut']);
PROC_DECLARATION.SetProcName('computeSumOfDemandOnLeafInternode');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeNbActiveInternodesOnMainstemDyn,['nbActiveInternodesOnMainstem','kInOut']);
PROC_DECLARATION.SetProcName('ComputeNbActiveInternodesOnMainstem');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeStockMainstemOutputDyn,['stockMainstem','kInOut']);
PROC_DECLARATION.SetProcName('ComputeStockMainstemOutput');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SumOfInternodeLengthOnMainstemDyn,['internodeLengthOnMainstem','kInOut']);
PROC_DECLARATION.SetProcName('SumOfInternodeLengthOnMainstem');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeFirstLastExpandedInternodeDiameterMainstemDyn,['firstDiameter','kInOut','lastDiameter','kInOut','lastLength','kInOut','lastRank','kInOut']);
PROC_DECLARATION.SetProcName('ComputeFirstLastExpandedInternodeDiameterMainstem');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeStockInternodeMainstemDyn,['stock','kInOut']);
PROC_DECLARATION.SetProcName('ComputeStockInternodeMainstem');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeStockInternodeTillersDyn,['stock','kInOut']);
PROC_DECLARATION.SetProcName('ComputeStockInternodeTillers');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SetAliveToDeadDyn,['alive','kInOut']);
PROC_DECLARATION.SetProcName('SetAliveToDead');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',FindLengthPeduncleDyn,['lengthPeduncle','kOut']);
PROC_DECLARATION.SetProcName('FindLengthPeduncle');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeLengthPedunclesDyn,['heightPanicleMainstem','kOut']);
PROC_DECLARATION.SetProcName('ComputeLengthPeduncles');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeThermalTimeSinceLigulation_LEDyn,['thermalTimeSinceLigulation', 'kInOut']);
PROC_DECLARATION.SetProcName('ComputeThermalTimeSinceLigulation_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeLifespan_LEDyn,['coeffLifespan', 'kIn', 'mu', 'kIn', 'rank', 'kIn', 'lifespan', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeLifespan_LE');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeCorrectedBladeAreaDyn,['correctedBladeArea','kOut']);
PROC_DECLARATION.SetProcName('ComputeCorrectedBladeArea');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeCorrectedLeafBiomassDyn,['correctedLeafBiomass','kOut']);
PROC_DECLARATION.SetProcName('ComputeCorrectedLeafBiomass');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeDeadLeafBiomassDyn,['deadLeafBiomass','kOut']);
PROC_DECLARATION.SetProcName('ComputeDeadLeafBiomass');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeLeavesSenescenceStockDyn,['reallocCoef','kIn','senesc_dw','kInOut','stock','kInOut']);
PROC_DECLARATION.SetProcName('ComputeLeavesSenescenceStock');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeBiomassInAllLeavesDyn,['biomLeafStruct', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeBiomassInAllLeaves');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeBiomassLeavesMainstemDyn,['sumOfMainstemLeafBiomass', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeBiomassLeavesMainstem');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeBladeAreaInAllLeavesDyn,['PAI', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeBladeAreaInAllLeaves');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeBladeAreaLeavesMainstemDyn,['sumOfBladeAreaOnMainstem', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeBladeAreaLeavesMainstem');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',KillSenescLeavesDyn,['deadLeafNb', 'kInOut']);
PROC_DECLARATION.SetProcName('KillSenescLeaves');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeInternodeLengthPredimDyn,['slopeLengthIN', 'kIn', 'leafLengthToINLength', 'kIn', 'internodeLengthPredim', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeInternodeLengthPredim');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeInternodeDiameterPredim2Dyn,['INLengthToINDiam', 'kIn', 'coefLinINDIam', 'kIn', 'internodeLengthPredim', 'kIn', 'internodeDiameterPredim', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeInternodeDiameterPredim2');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputePeduncleLengthPredimDyn,['ratioINPed', 'kIn', 'peduncleLengthPredim', 'kOut']);
PROC_DECLARATION.SetProcName('ComputePeduncleLengthPredim');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputePeduncleDiameterPredimDyn,['peduncleDiam', 'kIn', 'peduncleDiameterPredim', 'kOut']);
PROC_DECLARATION.SetProcName('ComputePeduncleDiameterPredim');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeStructLeafDyn,['structLeaf', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeStructLeaf');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeSumOfBiomassDyn,['sumOfBiomass', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeSumOfBiomass');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeWeightPanicleDyn,['weightPanicle', 'kOut', 'weightPanicleMainstem', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeWeightPanicle');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeBiomLeafDyn,['stock', 'kIn', 'stockInternodePlant', 'kIn', 'biomLeafStruct', 'kIn', 'biomLeaf', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeBiomLeaf');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SumOfDailySenescedLeafBiomassOnCulmDyn,['sumOfDailySenescedLeafBiomass', 'kOut']);
PROC_DECLARATION.SetProcName('SumOfDailySenescedLeafBiomassOnCulm');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SumOfDailySenescedLeafBiomassDyn,['total', 'kOut']);
PROC_DECLARATION.SetProcName('SumOfDailySenescedLeafBiomass');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

end.
