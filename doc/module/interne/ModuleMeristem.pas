//---------------------------------------------------------------------------
/// Module utilises par le modele meristem
///
///Description :
///
//----------------------------------------------------------------------------
(** @Author Ludovic TAMBOUR
    @Version 07/06/05 LT v0.0 version initiale; statut : en cours *)

unit ModuleMeristem;

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
  DefinitionConstant, Dialogs;

// modules non visibles

procedure SumOfStockOnMainstemInInternodeRec(var instance : TInstance; var total : Double);
procedure SumOfStockOnTillersInInternodeRec(var instance : TInstance; var total : Double);

// Liste des modules
Procedure ComputeIC(const supply,dayDemand: double; var Ic,testIc: Double);
Procedure Diff(const inValue1,inValue2: double; var outValue: Double);
Procedure Divide(const inValue1,inValue2: double; var outValue: Double);
Procedure Add2Values(const inValue1,inValue2: double; var outValue: Double);
Procedure Mult2Values(const inValue1,inValue2: double; var outValue: Double);
Procedure Min2Values(const inValue1,inValue2: double; var outValue: Double);
Procedure Max2Values(const inValue1,inValue2: double; var outValue: Double);
Procedure SqrtReal(const inValue : double; var outValue: Double);
Procedure Identity(const inValue : double; var outValue: Double);
Procedure UpdatePlastoDelay(const LER,deltaT,exp_time : Double; var plasto_delay : Double);
Procedure UpdateDegreeDay(const deltaT,plasto,plasto_delay : double; var DD,EDD,boolCrossedPlasto : Double);
Procedure UpdatePhenoStage(const boolCrossedPlasto : Double; var phenoStage : Double);
Procedure ComputeSLA(const FSLA,SLAp,phenoStage : Double; var SLA : Double);
Procedure ComputeW(const phenoStage,w1,w2 : Double; var W : Double);
Procedure ComputeLeafBladeArea(const biomass,G_L,SLA : Double; var bladeArea : Double);
Procedure ComputeLeafLength(const bladeArea,W,surfaceCoeff,ratio : Double; var le : Double);
Procedure ComputeOrganDemand(const predim,DD,plasto : Double; var demand : Double);
Procedure ComputeRest(const previousSupply,previousDayDemand : Double; var rest : Double);
Procedure ReallocateBiomass(const biomass,reallocationRate : Double; var stock : Double);
Procedure UpdateAdd(const quantity : Double; var attributeValue : Double);
Procedure UpdateLinear(const quantity,coeff : Double; var attributeValue : Double);
Procedure UpdateOrganBiomass(const demand : Double; var biomass : Double);
Procedure UpdateSupply(const previousAssim,previousDayDemand,rest : Double; var supply : Double);
Procedure ComputeLAI(const PAI,density : Double; var LAI : Double);
Procedure ComputeRolledLAI(const PAI,density,fcstr,rollingA, rollingB : Double; var LAI : Double);
Procedure ComputeRadiationInterception(const Kdf,LAI : Double; var radiationInterception : Double);
Procedure ComputePotentialAssimilation(const Assim_A,Assim_B,fcstr,radiationInterception,Epsib,radiation,Kpar : Double; var potentialAssimilation : Double);
Procedure ComputePotentialAssimilationCstr(const power_for_cstr,cstr,radiationInterception,Epsib,radiation,Kpar : Double; var potentialAssimilation : Double);
Procedure ComputeRespirationMaintenance(const Kresp, Kresp_internode, biomassLeaf, biomassInternode, airTemperature, Tresp : Double; var respirationMaintenance : Double);
Procedure ComputeAssimilationNet(const PotentialAssimilation,respirationMaintenance,density : Double; var assimilationNet : Double);
Procedure ComputeLeafPredimensionnement(const boolFirstLeaf,predimOfPreviousLeaf,predimLeafOnMainstem,MGR,testIc : Double; var predimOfCurrentLeaf : Double);
Procedure UpdateNbTillerCount(const Ic,IcThreshold : Double; var nbTiller : Double);
Procedure Threshold(const inValue,thresholdValue : Double;var outValue : double);
Procedure Linear(const coeff,offset,inValue: double; var outValue: Double);

Procedure ComputeICDyn(Var T : TPointerProcParam);
Procedure DiffDyn(Var T : TPointerProcParam);
Procedure DivideDyn(Var T : TPointerProcParam);
Procedure Add2ValuesDyn(Var T : TPointerProcParam);
Procedure Mult2ValuesDyn(Var T : TPointerProcParam);
Procedure Min2ValuesDyn(Var T : TPointerProcParam);
Procedure Max2ValuesDyn(Var T : TPointerProcParam);
Procedure SqrtRealDyn(Var T : TPointerProcParam);
Procedure IdentityDyn(var T : TPointerProcParam);
Procedure UpdatePlastoDelayDyn(var T : TPointerProcParam);
Procedure UpdateDegreeDayDyn(Var T : TPointerProcParam);
Procedure UpdatePhenoStageDyn(Var T : TPointerProcParam);
Procedure ComputeSLADyn(Var T : TPointerProcParam);
Procedure ComputeWDyn(Var T : TPointerProcParam);
Procedure ComputeLeafBladeAreaDyn(Var T : TPointerProcParam);
Procedure ComputeLeafLengthDyn(Var T : TPointerProcParam);
Procedure ComputeOrganDemandDyn(Var T : TPointerProcParam);
Procedure ComputeRestDyn(Var T : TPointerProcParam);
Procedure ReallocateBiomassDyn(Var T : TPointerProcParam);
Procedure UpdateAddDyn(Var T : TPointerProcParam);
Procedure UpdateOrganBiomassDyn(Var T : TPointerProcParam);
Procedure UpdateSupplyDyn(Var T : TPointerProcParam);
Procedure ComputeLAIDyn(Var T : TPointerProcParam);
Procedure ComputeRolledLAIDyn(var T : TPointerProcParam);
Procedure ComputeRadiationInterceptionDyn(Var T : TPointerProcParam);
Procedure ComputePotentialAssimilationDyn(Var T : TPointerProcParam);
Procedure ComputePotentialAssimilationCstrDyn(Var T : TPointerProcParam);
Procedure ComputeRespirationMaintenanceDyn(Var T : TPointerProcParam);
Procedure ComputeAssimilationNetDyn(Var T : TPointerProcParam);
Procedure ComputeLeafPredimensionnementDyn(Var T : TPointerProcParam);
Procedure UpdateNbTillerCountDyn(Var T : TPointerProcParam);
Procedure ThresholdDyn(Var T : TPointerProcParam);
Procedure LinearDyn(var T : TPointerProcParam);

// Liste des modules 'extra'
Procedure SumOfDemandRec(var instance : TInstance; var total : Double);
Procedure SumOfBladeAreaInLeafRec(var instance : TInstance; var total : Double);
Procedure SumOfBiomassInLeafRec(var instance : TInstance; var total : Double);
Procedure SumOfDemandInLeafRec(var instance : TInstance; var total : Double);
Procedure SumOfBiomassRec(var instance : TInstance; var total : Double);
Procedure EnableNbTillerCount(var instance : TInstance; plasto : Double);
Procedure CountOfNbTillerWithMore4Leaves(var instance : TInstance; var nbTillerWithMore4Leaves : Double);
Procedure KillOldestLeaf(var instance : TInstance;var stock : Double);
Procedure SumOfBiomassInInternodeRec(var instance : TInstance; var total : Double);
Procedure SumOfBiomassInRootRec(var instance : TInstance; var total : Double);
procedure SumOfBiomassOnMainstemInInternodeRec(var instance : TInstance; var total : Double);
procedure SumOfBiomassOnTillersInInternodeRec(var instance : TInstance; var total : Double);
procedure SumOfBiomassOnMainstemInLeafRec(var instance : TInstance; var total : Double);
Procedure SumOfDemandInOrganOnMainstemRec(var instance : TInstance; var total : Double);
Procedure SumOfDemandInOrganOnTillerRec(var instance : TInstance; var total : Double);
Procedure SumOfBladeAreaOnMainstemInLeafRec(var instance : TInstance; var total : Double);
procedure SumOfBladeAreaOnTillerInLeafRec(var instance : TInstance; var total : Double);
procedure SumReservoirDispoInInternodeOnMainstemRec(var instance : TInstance; var total : Double);
procedure SumReservoirDispoInInternodeOnTillerRec(var instance : TInstance; var total : Double);
procedure SumOfBiomassOnTillerInLeafRec(var instance : TInstance; var total : Double);
Procedure StressOnSet(var instance : TInstance; boolSwitch : Double);
procedure SumOfBiomassOnCulmInInternodeRec(var instance : TInstance; var total : Double);
procedure SumOfStockOnCulmInInternodeRec(var instance : TInstance; var total : Double);
procedure SumOfLengthOnCulmInInternodeRec(var instance : TInstance; var total : Double);
procedure SumOfDemandOnCulmInInternode(var instance : TInstance; var total : Double);
procedure SumOfStockOnCulmInInternode(var instance : TInstance; var total : Double);
procedure SumOfDemandOnCulmInNonInternode(var instance : TInstance; var total : Double);
procedure SumOfDeficitOnCulmInInternode(var instance : TInstance; var total : Double);
procedure SumOfDemandOnTillers(var instance : TInstance; var total : Double);
procedure SumOfLastDemandOnTillers(var instance : TInstance; var total : Double);




Procedure SumOfDemandRecDyn(var instance : TInstance; Var T : TPointerProcParam);
Procedure SumOfBladeAreaInLeafRecDyn(var instance : TInstance; Var T : TPointerProcParam);
Procedure SumOfBiomassInLeafRecDyn(var instance : TInstance; Var T : TPointerProcParam);
Procedure SumOfDemandInLeafRecDyn(var instance : TInstance; Var T : TPointerProcParam);
Procedure SumOfBiomassRecDyn(var instance : TInstance; Var T : TPointerProcParam);
Procedure EnableNbTillerCountDyn(var instance : TInstance; Var T : TPointerProcParam);
Procedure CountOfNbTillerWithMore4LeavesDyn(var instance : TInstance; Var T : TPointerProcParam);
Procedure KillOldestLeafDyn(var instance : TInstance; Var T : TPointerProcParam);
Procedure SumOfBiomassInInternodeRecDyn(var instance : TInstance; Var T : TPointerProcParam);
Procedure SumOfBiomassInRootRecDyn(var instance : TInstance; Var T : TPointerProcParam);
procedure SumOfBiomassOnMainstemInInternodeRecDyn(var instance : TInstance; Var T : TPointerProcParam);
procedure SumOfBiomassOnTillersInInternodeRecDyn(var instance : TInstance; Var T : TPointerProcParam);
procedure SumOfBiomassOnMainstemInLeafRecDyn(var instance : TInstance; Var T : TPointerProcParam);
Procedure SumOfDemandInOrganOnMainstemRecDyn(var instance : TInstance; Var T : TPointerProcParam);
Procedure SumOfDemandInOrganOnTillerRecDyn(var instance : TInstance; Var T : TPointerProcParam);
Procedure SumOfBladeAreaOnMainstemInLeafRecDyn(var instance : TInstance; Var T : TPointerProcParam);
Procedure SumOfBladeAreaOnTillerInLeafRecDyn(var instance : TInstance; Var T : TPointerProcParam);
procedure SumReservoirDispoInInternodeOnMainstemRecDyn(var instance : TInstance; Var T : TPointerProcParam);
procedure SumReservoirDispoInInternodeOnTillerRecDyn(var instance : TInstance; Var T : TPointerProcParam);
procedure SumOfBiomassOnTillerInLeafRecDyn(var instance : TInstance; Var T : TPointerProcParam);
procedure StressOnSetDyn(var instance : TInstance; Var T : TPointerProcParam);
procedure SumOfBiomassOnCulmInInternodeRecDyn(var instance : TInstance; Var T : TPointerProcParam);
procedure SumOfStockOnCulmInInternodeRecDyn(var instance : TInstance; Var T : TPointerProcParam);
procedure SumOfLengthOnCulmInInternodeRecDyn(var instance : TInstance; var T : TPointerProcParam);
procedure SumOfDemandOnCulmInInternodeDyn(var instance : TInstance; var T : TPointerProcParam);
procedure SumOfStockOnCulmInInternodeDyn(var instance : TInstance; var T : TPointerProcParam);
procedure SumOfDemandOnCulmInNonInternodeDyn(var instance : TInstance; var T : TPointerProcParam);
procedure SumOfDeficitOnCulmInInternodeDyn(var instance : TInstance; var T : TPointerProcParam);
procedure SumOfDemandOnTillersDyn(var instance : TInstance; var T : TPointerProcParam);
procedure SumOfLastDemandOnTillersDyn(var instance : TInstance; var T : TPointerProcParam);

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

//----------------------------------------------------------------------------
// Procedure ComputeIC
// -------------------
//
/// Calcule l'indice de competition 'Ic' et 'testIc' du jour
///
/// Description : Calcule l'indice de competition 'Ic' et 'testIc' du jour a
/// partir de l'offre 'supply' et la demande journaliere 'dayDemand' du jour
/// precedent
///
///  equation :
///    Ic(i)    = supply(i-1) / dayDemand(i-1);
///    testIc(i)= min(1,sqrt(Ic(i)));
///
// ---------------------------------------------------------------------------
(**
@param supply  (In) offre du jour precedent
@param dayDemand (In) demande journaliere du jour precedent
@param Ic (Out) indice de competition
@param testIc (Out) ??????????????????????
*)

Procedure ComputeIC(const supply, dayDemand : double; var Ic, testIc : Double);
begin
  if (dayDemand = 0) then
  begin
    Ic := 1;
  end
  else
  begin
    Ic := supply / dayDemand;
  end;
  testIc := min(1 , sqrt(Ic));
end;

// ----------------------------------------------------------------------------
//  Procedure Diff
//  --------------
//
/// Calcule la difference 'inValue1' - 'inValue2'
///
/// Description :
///
/// equation :
///   outValue = inValue1 - inValue2
///
// ---------------------------------------------------------------------------
(**
@param inValue1 (In) valeur a soustraire
@param inValue2 (In) valeur a soustraire
@param outValue (Out) resultat de la difference
*)

Procedure Diff(const inValue1, inValue2 : double; var outValue: Double);
begin
  outValue := inValue1 - inValue2;
end;

// ----------------------------------------------------------------------------
//  Procedure Divide
//  -----------------
//
/// Calcule la division 'inValue1' / 'inValue2'
///
/// Description :
///
/// ATTENTION, il est a la responsabilité de l utilisateur de verifier que
/// invalue2 est non nul
///
/// equation :
///   outValue = inValue1 / inValue2
///
// ---------------------------------------------------------------------------
(**
@param inValue1 (In) valeur a diviser
@param inValue2 (In) dividende
@param outValue (Out) resultat de la dividende
*)

Procedure Divide(const inValue1, inValue2: double; var outValue : Double);
begin
  outValue := inValue1 / inValue2;
end;

// ----------------------------------------------------------------------------
//  Procedure Add2Values
//  --------------------
//
/// Calcule la somme de 2 elements
///
/// Description :
///
/// equation :
///   outValue = inValue1 + inValue2
///
// ---------------------------------------------------------------------------
(**
@param inValue1 (In) premiere valeur a additionner
@param inValue2 (In) deuxieme valeur a additionner
@param outValue (Out) resultat de l'addition
*)

Procedure Add2Values(const inValue1, inValue2 : double; var outValue : Double);
begin
  outValue := inValue1 + inValue2;
end;

// ----------------------------------------------------------------------------
//  Procedure Mult2Values
//  --------------------
//
/// Calcule le produit de 2 elements
///
/// Description :
///
/// equation :
///   outValue = inValue1 * inValue2
///
// ---------------------------------------------------------------------------
(**
@param inValue1 (In) premiere valeur a additionner
@param inValue2 (In) deuxieme valeur a additionner
@param outValue (Out) resultat de l'addition
*)

Procedure Mult2Values(const inValue1, inValue2 : double; var outValue : Double);
begin
  outValue := inValue1 * inValue2;
end;

// ----------------------------------------------------------------------------
//  Procedure Min2Values
//  --------------------
//
/// Calcule le minimum de 2 elements
///
/// Description :
///
/// equation :
///   outValue = min(inValue1,inValue2)
///
// ---------------------------------------------------------------------------
(**
@param inValue1 (In) premiere valeur
@param inValue2 (In) deuxieme valeur
@param outValue (Out) minimum des deux valeurs
*)

Procedure Min2Values(const inValue1, inValue2 : double; var outValue : Double);
begin
  outValue := min(inValue1, inValue2);
end;

// ----------------------------------------------------------------------------
//  Procedure Max2Values
//  --------------------
//
/// Calcule le maximum de 2 elements
///
/// Description :
///
/// equation :
///   outValue = max(inValue1,inValue2)
///
// ---------------------------------------------------------------------------
(**
@param inValue1 (In) premiere valeur
@param inValue2 (In) deuxieme valeur
@param outValue (Out) maximum des deux valeurs
*)

Procedure Max2Values(const inValue1, inValue2 : double; var outValue : Double);
begin
  outValue := max(inValue1, inValue2);
end;


// ----------------------------------------------------------------------------
//  Procedure sqrtReal
//  --------------------
//
/// Calcule la racine carré d un nombre reel positif
///
/// Description :
///
/// ATTENTION : il est à la charge de l'utilisateur de s'assurer que 'inValue'
/// est positif
///
/// equation :
///   outValue = sqrt(inValue)
///
// ---------------------------------------------------------------------------
(**
@param inValue1 (In) premiere valeur
@param inValue2 (In) deuxieme valeur
@param outValue (Out) maximum des deux valeurs
*)

Procedure SqrtReal(const inValue : double; var outValue : Double);
begin
  outValue := sqrt(inValue);
end;


// ----------------------------------------------------------------------------
//  Procedure Identity
//  ------------------
//
/// Recopie la valeur inValue dans outValue
/// Note : pratique pour faire la connection TAttributeTableIn vers port
/// et port vers TAttributeTableOut
///
/// Description :
///
/// equation :
///   outValue = inValue
///
// ---------------------------------------------------------------------------
(**
@param inValue (In) valeur a copier
@param outValue (Out) valeur de sortie
*)

Procedure Identity(const inValue : double; var outValue : Double);
begin
  outValue := inValue;
end;

// ----------------------------------------------------------------------------
//  Procedure UpdateDegreeDay
//  -------------------------
//
/// Calcule duree du jour 'DD' et la duree du jour efficace 'EDD'
///
/// Description :
/// La duree du jour est une accumulation de temperature utile
/// 'deltaT' (ou deltaT = temperature de l'air - temperature de base) modulo le
/// plastochron. Ici, la fonction calcule la duree du jour actuel comme etant
/// la somme de la duree du jour du jour precedent et de la temperature utile.
/// Lorsque la nouvelle duree du jour franchit le seuil du plastochron,
/// on supprime alors a cette duree du jour, la valeur du plastochron.
///
/// La duree du jour restante (non utilisée pour le franchissement du
/// plastochron) est appelée 'duree du jour efficace' (EDD)
///
/// 'boolCrossedPlasto' indique si le plastochron a été franchit ou non (et
/// de combien). boolCrossedPlasto < 0 si non franchissement et
/// boolCrossedPlasto >= 0 si franchissement
///
/// equation (mise à jour du 03/07/2008):
///    DD(i) = DD(i-1) + deltaT(i) + plasto_delay modulo plasto
///    EDD(i) = deltaT(i) si non franchissement strict du plastochron
///           = plasto - DD(i-1) sinon
///    boolCrossedPlasto(i) = (DD(i-1) + deltaT(i)) - plasto
///
// ---------------------------------------------------------------------------
(**
@param deltaT (In) temperature du jour a cumuler
@param plasto (In) plastochron
@param DD (InOut) nouvelle duree du jour
@param EDD (Out) nouvelle duree du jour efficace
@param boolCrossedPlasto (Out) indique si le plastochron a ete franchit ou non
*)

Procedure UpdateDegreeDay(const deltaT,plasto,plasto_delay : double; var DD,EDD,boolCrossedPlasto : Double);
var
  previousDD : double;
begin
  previousDD := DD;
  DD := previousDD + deltaT + plasto_delay;
  boolCrossedPlasto := DD - plasto;

  if (boolCrossedPlasto >= 0) then
  begin
    SRwriteln('****  changement de plastochron  ****');
    DD := DD - plasto;
  end;

  if (boolCrossedPlasto <= 0) then
  begin
    EDD := deltaT + plasto_delay;
  end
  else
  begin
    EDD := plasto - previousDD;
  end;

  SRwriteln('deltaT            --> ' + floattostr(deltaT));
  SRwriteln('plasto            --> ' + floattostr(plasto));
  SRwriteln('previousDD        --> ' + floattostr(previousDD));
  SRwriteln('boolCrossedPlasto --> ' + floattostr(boolCrossedPlasto));
  SRwriteln('DD                --> ' + floattostr(DD));
  SRwriteln('EDD               --> ' + floattostr(EDD));

end;

// ----------------------------------------------------------------------------
//  Procedure UpdatePlastoDelay
//  ---------------------------
//
/// Met a jour la variable plasto_delay
///
/// Description :
/// Dans le cas d'un stress, le LER diminue et donc l'agrandissement de la
/// plante aussi. Il faut donc prendre en compte de temps restant le jour
/// suivant
///
/// Equation :
///     plasto_delay(t) = min(EDDF*(-1*LER),0)
///
// ----------------------------------------------------------------------------
(**
@param LER (In) Leaf Expansion Rate de la feuille
@parem deltaT (In) Température actuelle moins la température de base
@param exp_time (In) Temps d'expansion de la plante
@param plasto_delay (Out) Le delay à rajouter à Degree Day
*)

Procedure UpdatePlastoDelay(const LER, deltaT, exp_time : Double; var plasto_delay : Double);
var
  EDDF : Double;
begin
  if (deltaT > exp_time) then
  begin
    EDDF := exp_time;
  end
  else
  begin
    EDDF := deltaT;
  end;
  plasto_delay := min(EDDF * (-1 + LER), 0);

  SRwriteln('LER          --> ' + floattostr(LER));
  SRwriteln('deltaT       --> ' + floattostr(deltaT));
  SRwriteln('exp_time     --> ' + floattostr(exp_time));
  SRwriteln('EDDF         --> ' + floattostr(EDDF));
  SRwriteln('plasto_delay --> ' + floattostr(plasto_delay));
end;

// ----------------------------------------------------------------------------
//  Procedure UpdatePhenoStage
//  --------------------------
//
/// Met a jour le stade phenologique
///
/// Description :
/// Le nouveau stade phénologique est egale a l'ancien stade phenologique
/// si le seuil du plasto n'a pas ete franchi. Sinon, il est incremente.
///
/// boolCrossedPlasto : indique si le plasto a ete franchi (<0 si n'a pas
/// ete franchi; >= 0 si le plasto a ete franchi)
///
// ---------------------------------------------------------------------------
(**
@param boolCrossedPlasto (In) temperature du jour a cumuler
@param phenoStage (InOut) stade phenologique
*)

Procedure UpdatePhenoStage(const boolCrossedPlasto : Double; var phenoStage : Double);
begin
  if (boolCrossedPlasto >= 0) then
  begin
    PhenoStage := PhenoStage + 1;
    SRWriteln('Nouveau phenostage : ' + FloatToStr(PhenoStage));
  end
  // sinon rien faire -> 'phenoStage' garde la meme valeur
end;

// ----------------------------------------------------------------------------
//  Procedure ComputeSLA
//  ---------------------
//
/// Calcule le SLA en fonction du FSLA,SLAp, et du stade phénologique.
///
/// Description :
///
/// equation :
///   SLA(i) = FSLA - SLAp * log(phenoStage(i));
///
// ---------------------------------------------------------------------------
(**
@param FSLA (In) XXXXXXXXXXXXXXX
@param SLAp (In) XXXXXXXXXXXXXXX
@param phenoStage (In) stade phenologique
@param SLA (Out) Surface Leaf Area
*)

Procedure ComputeSLA(const FSLA, SLAp, phenoStage : Double; var SLA : Double);
begin
    SRwriteln('FSLA       --> ' + floattostr(FSLA));
    SRwriteln('SLAp       --> ' + floattostr(SLAp));
    SRwriteln('phenoStage --> ' + floattostr(phenoStage));

    SLA := FSLA - SLAp * ln(phenoStage);

    SRwriteln('SLA        --> ' + FloatToStr(SLA))
end;

// ----------------------------------------------------------------------------
//  Procedure ComputeW
//  ------------------
//
/// Calcule le W en fonction du stade phénologique et de 2 parametres empiriques w1 et w2.
///
/// Description :
///
/// equation :
///   W = w1 * phenoStage + w2;
///
// ---------------------------------------------------------------------------
(**
@param phenoStage (In) stade phenologique
@param w1 (In) coeff multiplicatif
@param w2 (In) offset
@param W (Out) XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
*)

Procedure ComputeW(const phenoStage, w1, w2 : Double; var W : Double);
begin
    W := w1 * phenoStage + w2;
end;

// ----------------------------------------------------------------------------
//  Procedure ComputeLeafBladeArea
//  ------------------------------
//
/// Calcule le 'bladeArea' d'une feuille en fonction de sa biomasse, du ratio de 'sheath_blade dry weight' et du SLA
///
/// Description :
///
/// equation :
///   bladeArea(i) = biomass(i) * (1/(1+G_L)) *SLA(i);
///
// ---------------------------------------------------------------------------
(**
@param biomass (In) biomasse de la feuille
@param G_L (In) sheath_blade dry weight ratio
@param SLA (In) surface leaf area
@param bladeArea (Out) XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
*)

Procedure ComputeLeafBladeArea(const biomass, G_L, SLA : Double; var bladeArea : Double);
begin
    bladeArea := biomass * (1 / (1 + G_L)) * SLA;
end;

// ----------------------------------------------------------------------------
//  Procedure ComputeLeafLength
//  ---------------------------
//
/// Calcule la longueur d'une feuille
///
/// Description : Calcule la surface d'une feuille en fonction de sa
/// 'bladeArea', de sa profondeur 'w', d'un coefficient 'surfaceCoeff'
/// allometrique de surface foliaire et d'un facteur de ratio 'ratio' empirique
/// (longueur/G_L)
///
/// equation :
///   le(i) = bladeArea(i) * ratio / (surfaceCoeff * W);
///
// ---------------------------------------------------------------------------
(**
@param bladeArea (In) ????????????????????????????????????
@param W (In) profondeur de la feuille ???????????????????????????
@param surfaceCoeff (In) coefficient allometrique de surface foliaire ??????????????
@param ratio (In) facteur de ratio empirique (longueur/G_L) ?????????????
@param le (Out) longueur de la feuille
*)

Procedure ComputeLeafLength(const bladeArea, W, surfaceCoeff, ratio : Double; var le : Double);
begin
    le := bladeArea * ratio / (surfaceCoeff * W);
end;

// ----------------------------------------------------------------------------
//  Procedure ComputeOrganDemand
//  ----------------------------
//
/// Calcule la demande d'un organe
///
/// Description : Calcule la demande d'un organe en fonction de son
/// predimensionnement, de la duree du jour et du plastochron.
///
/// equation :
///   demand(i) = predim(i) * (DD(i) / plasto);
///
// ---------------------------------------------------------------------------
(**
@param predim (In) predimensionnement de l'organe
@param DD (In) duree du jour (efficace ou non)
@param plasto (In) plastochron
@param demand (Out) demande de l'organe
*)

Procedure ComputeOrganDemand(const predim, DD, plasto : Double; var demand : Double);
begin
    demand := predim * (DD / plasto);
end;

// ----------------------------------------------------------------------------
//  Procedure ComputeRest
//  ---------------------
//
/// Calcule le reste de biomasse
///
/// Description : Calcule le reste de biomasse en fonction de l'offre
///'previousSupply' et de la demande journaliere 'dayDemand' du jour precedent.
///
/// equation :
///   rest(i) = min(supply(i-1)-dayDemand(i-1), 0.5*dayDemand(i-1));
///
// ---------------------------------------------------------------------------
(**
@param previousSupply (In) offre du jour precedent
@param previousDayDemand (In) demande du jour precedent
@param rest (Out) reste de biomasse
*)

Procedure ComputeRest(const previousSupply, previousDayDemand : Double; var rest : Double);
begin
    rest := min(previousSupply - previousDayDemand, 0.5 * previousDayDemand);
end;

// ----------------------------------------------------------------------------
//  Procedure ReallocateBiomass
//  ---------------------------
//
/// Realloue une partie de la biomasse d'un organe
///
/// Description : Realloue une partie de la biomasse d'un organe
///
/// equation :
///   stock(i) = stock(i-1) + reallocationRate * biomass(i);
///
// ---------------------------------------------------------------------------
(**
@param biomass (In) biomasse de l'organe
@param reallocationRate (In) taux de reallocation (pourcentage < 100%)
@param stock (InOut) stock a modifier
*)

Procedure ReallocateBiomass(const biomass, reallocationRate : Double; var stock : Double);
begin
    stock := stock + reallocationRate * biomass;
end;

// ----------------------------------------------------------------------------
//  Procedure UpdateAdd
//  -------------------
//
/// Mise a jour d'un attribut en ajoutant une certaine quantité
///
/// Description : Mise a jour d'un attribut en ajoutant une certaine quantité
///
/// equation :
///   attributeValue(i) = attributeValue(i-1) + quantity(i)
///
// ---------------------------------------------------------------------------
(**
@param quantity (In) quantite a ajouter a attributeValue
@param attributeValue (InOut) valeur a mettre a jour
*)

Procedure UpdateAdd(const quantity : Double; var attributeValue : Double);
begin
  attributeValue := attributeValue + quantity;
end;


// ----------------------------------------------------------------------------
//  Procedure UpdateLinear
//  -----------------------
//
/// Mise a jour d'un attribut en ajoutant une fraction d'une quantité
///
/// Description : Mise a jour d'un attribut en ajoutant une fraction d'une
/// quantité
///
/// equation :
///   attributeValue(i) = attributeValue(i-1) + coeff(i) * quantity(i)
///
// ---------------------------------------------------------------------------
(**
@param quantity (In) quantite a ajouter a attributeValue
@param coeff (In) coefficient multiplicatif
@param attributeValue (InOut) valeur a mettre a jour
*)

Procedure UpdateLinear(const quantity,coeff : Double; var attributeValue : Double);
begin
  attributeValue := attributeValue + coeff * quantity;
end;



// ----------------------------------------------------------------------------
//  Procedure UpdateOrganBiomass
//  ----------------------------
//
/// Mise a jour la biomasse d'un organe
///
/// Description : La nouvelle biomasse est egale a la precedente biomasse
/// augmentée de la demande
///
/// equation :
///   biomass(i) = biomass(i-1) + demand(i)
///
// ---------------------------------------------------------------------------
(**
@param demand (In) quantite a ajouter a attributeValue
@param biomass (InOut) biomasse a mettre a jour
*)

Procedure UpdateOrganBiomass(const demand : Double; var biomass : Double);
begin
    biomass := biomass + demand;
end;

// ----------------------------------------------------------------------------
//  Procedure UpdateSupply
//  ----------------------
//
/// Mise a jour du supply
///
/// Description : Mise a jour du supply en fonction de l'assimilat de la
/// journee precedente de la demande journaliere de la journee precedente
/// et du reste de la journee
///
/// equation :
///   supply(i) = supply(i-1) + assim(i-1) - dayDemand(i-1) - rest(i);
///
// ---------------------------------------------------------------------------
(**
@param previousAssim (In) quantite a ajouter a attributeValue
@param previousDayDemand (In) quantite a ajouter a attributeValue
@param rest (In) quantite a ajouter a attributeValue
@param supply (InOut) supply a mettre a jour
*)

Procedure UpdateSupply(const previousAssim, previousDayDemand, rest : Double; var supply : Double);
begin
    supply := supply + previousAssim - previousDayDemand - rest;
end;

// ----------------------------------------------------------------------------
//  Procedure ComputeLAI
//  --------------------
//
/// Calcule le LAI
///
/// Description : Calcule le LAI en fonction du PAI et de la densité
///
/// equation :
/// LAI(i) = PAI(i) * density / 10000;
///
// ---------------------------------------------------------------------------
(**
@param PAI (In) plant area index
@param density (In) densité ?????????????
@param LAI (Out) leaf area index
*)

Procedure ComputeLAI(const PAI, density : Double; var LAI : Double);
begin
    LAI := PAI * density / 10000;
end;

// ----------------------------------------------------------------------------
// Procedure ComputeRolledLAI
// --------------------------
//
/// Calcule le LAI enroulé
///
/// Description : Calcule le LAI, , mais en tenant compte de l'enroulement de
/// la feuille
///
/// equation :
/// LAI(i) = PAI(i) * (0.3 + 0.7 * fcstr) * density/10000
///
// ----------------------------------------------------------------------------
(**
@param PAI (In) plant area index
@param density (In) densité ?????????????
@param LAI (Out) leaf area index
*)

Procedure ComputeRolledLAI(const PAI, density, fcstr, rollingA, rollingB : Double; var LAI : Double);
begin
	LAI := PAI * (rollingB + (rollingA * fcstr)) * density / 10000;
  SRwriteln('PAI      --> ' + floattostr(PAI));
  SRwriteln('rollingB --> ' + floattostr(rollingB));
  SRwriteln('rollingA --> ' + floattostr(rollingA));
  SRwriteln('fcstr    --> ' + floattostr(fcstr));
  SRwriteln('density  --> ' + floattostr(density));
  SRwriteln('LAI      --> ' + floattostr(LAI));
end;


// ----------------------------------------------------------------------------
//  Procedure ComputeRadiationInterception
//  --------------------------------------
//
/// Calcule l'interception des radiations
///
/// Description : Calcule l'interception des radiations en fonction du LAI et du
/// Kdf
///
/// equation :
/// radiationInterception = 1 - exp(-Kdf * LAI(i))
///
// ---------------------------------------------------------------------------
(**
@param Kdf (In) extinction coefficient for beer lambert law
@param LAI (In) leaf area index
@param radiationInterception (Out) ??????????????????
*)

Procedure ComputeRadiationInterception(const Kdf, LAI : Double; var radiationInterception : Double);
begin
  SRwriteln('Kdf --> ' + floattostr(kdf));
	SRwriteln('LAI --> ' + floattostr(LAI));
  radiationInterception := 1 - exp(-Kdf * LAI);
  SRwriteln('radiation interception --> ' + floattostr(radiationInterception));
end;

// ----------------------------------------------------------------------------
//  Procedure ComputePotentialAssimilation
//  --------------------------------------
//
/// Calcule l'assimilation potentielle
///
/// Description : Calcule l'assimilation potentielle en fonction l'interception
/// des radiations, des radiations, de l'Epsib et du Kpar
///
/// equation :
/// potentialAssimilation(i) = radiationInterception(i)*Epsib*radiation(i)*Kpar;
///
// ---------------------------------------------------------------------------
(**
@param radiationInterception (In) interception des radiations
@param Epsib (In) conversion efficiency (g.MJ.M-².j-1)
@param radiation (In) radiation
@param Kpar (In) ????????
@param potentialAssimilation (Out) assimilation potentielle
*)

Procedure ComputePotentialAssimilation(const Assim_A, Assim_B, fcstr, radiationInterception, Epsib, radiation, Kpar : Double; var potentialAssimilation : Double);
begin
  potentialAssimilation := ln(Assim_A + Assim_B * fcstr) * radiationInterception * Epsib * radiation * Kpar;
end;


// ----------------------------------------------------------------------------
//  Procedure ComputePotentialAssimilationCstr
//  ------------------------------------------
//
/// Calcule l'assimilation potentielle
///
/// Description : Calcule l'assimilation potentielle reduite par une fonction
/// puissance de cstr si stress hydrique
///
/// equation :
/// potentialAssimilation(i) = radiationInterception(i)*Epsib*radiation(i)*Kpar;
///
// ---------------------------------------------------------------------------
(**
@param radiationInterception (In) interception des radiations
@param Epsib (In) conversion efficiency (g.MJ.M-².j-1)
@param radiation (In) radiation
@param Kpar (In) ????????
@param potentialAssimilation (Out) assimilation potentielle
*)

Procedure ComputePotentialAssimilationCstr(const power_for_cstr, cstr, radiationInterception, Epsib, radiation, Kpar : Double; var potentialAssimilation : Double);
begin
	SRwriteln('cstr                   --> ' + floattostr(cstr));
  SRwriteln('power_for_cstr         --> ' + floattostr(power_for_cstr));
  SRwriteln('radiation interception --> ' + floattostr(radiationInterception));
  SRwriteln('epsib                  --> ' + floattostr(epsib));
  SRwriteln('radiation              --> ' + floattostr(radiation));
  SRwriteln('kpar                   --> ' + floattostr(kpar));
  potentialAssimilation := Power(cstr, power_for_cstr) * radiationInterception * Epsib * radiation * Kpar;
  SRwriteln('potential assimilation --> ' + floattostr(potentialassimilation));
end;


// ----------------------------------------------------------------------------
//  Procedure ComputeRespirationMaintenance
//  --------------------------------------
//
/// assimilate consumption computation by maintenance respiration
///
/// Description : Calcule ?????? en fonction du Kresp, de la biomasse totale,
/// de la température de l'air et de la température optimal
///
/// equation :
/// respirationMaintenance(i) = Kresp*biomassTotal(i)*2^((airTemperature-Tresp)/10);
///
// ---------------------------------------------------------------------------
(**
@param Kresp (In) interception des radiations
@param biomassTotal (In) conversion efficiency (g.MJ.M-².j-1)
@param airTemperature (In) radiation
@param Tresp (In) ????????
@param respirationMaintenance (Out) assimilation potentielle
*)

Procedure ComputeRespirationMaintenance(const Kresp, Kresp_internode, biomassLeaf, biomassInternode, airTemperature, Tresp : Double; var respirationMaintenance : Double);
begin
    respirationMaintenance := ((Kresp * biomassLeaf) + (Kresp_internode * biomassInternode))* Power(2, (airTemperature - Tresp) / 10);
    SRwriteln('Kresp                  --> ' + FloatToStr(Kresp));
    SRwriteln('biomassLeaf            --> ' + FloatToStr(biomassLeaf));
    SRwriteln('Kresp_internode        --> ' + FloatToStr(Kresp_internode));
    SRwriteln('biomassInternode       --> ' + FloatToStr(biomassInternode));
    SRwriteln('airTemperature         --> ' + FloatToStr(airTemperature));
    SRwriteln('Tresp                  --> ' + FloatToStr(Tresp));
    SRwriteln('respirationMaintenance --> ' + FloatToStr(respirationMaintenance));
end;

// ----------------------------------------------------------------------------
//  Procedure ComputeAssimilationNet
//  --------------------------------
//
/// ??????????????
///
/// Description : Calcule ?????? en fonction de l'assimilation potentiel, de
/// respirationMaintenance et de la densité
///
/// equation :
/// assimilationNet(i)=(PotentialAssimilation(i)-respirationMaintenance(i))/density;
///
// ---------------------------------------------------------------------------
(**
@param PotentialAssimilation (In) assimilation potentielle
@param respirationMaintenance (In) ??????
@param density (In) densité
@param assimilationNet (Out) assimilation net
*)

Procedure ComputeAssimilationNet(const PotentialAssimilation, respirationMaintenance, density : Double; var assimilationNet : Double);
begin
    assimilationNet := (PotentialAssimilation - respirationMaintenance) / density;
end;

// ----------------------------------------------------------------------------
//  Procedure ComputeLeafPredimensionnement
//  ---------------------------------------
//
/// Calcule le predimensionnement d'une feuille
///
/// Description : Calcule le predimensionnement d'une feuille. Le
/// prédimensionnement 'predimOfCurrentLeaf' de la feuille est égale a la
/// moyenne du predimensionnement 'predimOfPreviousLeaf' de la feuille
/// précédente du meme organe et du predimensionnement 'predimLeafOnMainstem'
/// de la feuille en cours de realisation sur le mainstem; cette moyenne est
/// pondéré par un coefficient.
/// La valeur de ce coeeficient dépend du faite que la feuille soit ou non, la
/// premiere feuille de l'organe portant cette feuille :
///    - Si la feuille est la premiere (parametre 'boolFirstLeaf' = 1), le
///      coefficient pondérateur vaut 1.
///    - Sinon, le coefficient pondérateur vaut 'MGR' * 'testIc'
///
/// equation :
/// si premiere feuille de l'organe,
///       predimOfCurrentLeaf = (predimOfPreviousLeaf + predimLeafOnMainstem)/2;
/// sinon
///       predimOfCurrentLeaf = (predimOfPreviousLeaf + predimLeafOnMainstem)/2 * MGR * testIc;
///
// ---------------------------------------------------------------------------
(**
@param boolFirstLeaf (In) indique si la feuille est la premiere feuille de l'organe porteur
@param predimOfPreviousLeaf (In) predimensionnement de la feuille precedente
@param predimLeafOnMainstem (In) predimensionnement de la feuille en realisation sur le mainstem
@param MGR (In) meristem growth rate param to estimate potential demand (in grams ) of consecutive leaves (leaf (n)_biomss = MRG * leaf (n-1)_biom
@param testIc (In) ???????????????????????
@param predimOfCurrentLeaf (Out) predimensionnement de la feuille actuelle
*)

Procedure ComputeLeafPredimensionnement(const boolFirstLeaf, predimOfPreviousLeaf, predimLeafOnMainstem, MGR, testIc : Double; var predimOfCurrentLeaf : Double);
begin
    if (boolFirstLeaf = 1) then
    begin
      predimOfCurrentLeaf := (predimOfPreviousLeaf + predimLeafOnMainstem) / 2 ;
    end
    else
    begin
      predimOfCurrentLeaf := MGR * testIc * (predimOfPreviousLeaf + predimLeafOnMainstem) / 2;
    end;
end;

// ----------------------------------------------------------------------------
//  Procedure UpdateNbTillerCount
//  -----------------------------
//
/// Incrémente le comptage du nombre de talle lorsque l'IC a franchit un seuil
///
/// Description : Incrémente le comptage du nombre de talle 'nbTiller' lorsque
/// l'IC a franchit un seuil 'ICThreshold'
///
/// equation :
/// Si (IC(i) >= ICThreshold)
///     nbTiller(i) = nbTiller(i-1) + 1
/// Sinon
///     nbTiller(i) = nbTiller(i-1)
///
// ---------------------------------------------------------------------------
(**
@param Ic (In) indice de competition
@param IcThreshold (In) seuil
@param nbTiller (InOut) nombre de talle
*)

Procedure UpdateNbTillerCount(const Ic, IcThreshold : Double; var nbTiller : Double);
begin
    if (IC >= ICThreshold) then
    begin
      nbTiller := nbTiller + 1;
    end
end;

// ----------------------------------------------------------------------------
//  Procedure Threshold
//  -------------------
//
/// réalise une saturation (limitation par une borne sup)
///
/// Description : réalise une saturation. Retourne 'inValue' si 'inValue' est
/// plus petit qu'une valeur seuil 'thresholdValue' sinon retourne
/// 'thresholdValue'
///
/// equation :
/// outValue(i) = min(inValue(i),thresholdValue)
///
// ---------------------------------------------------------------------------
(**
@param inValue (In) valeur a seuiller
@param thresholdValue (In) valeur du seuil
@param outValue (Out) résultat aprés seuillage
*)

Procedure Threshold(const inValue,thresholdValue : Double;var outValue : double);
begin
    outValue := min(inValue, thresholdValue);
end;


// ----------------------------------------------------------------------------
//  Procedure Linear
//  -------------------
//
/// equation d une droite
///
/// Description : equation d une droite
///
/// equation :
///     outValue(i) := coeff * inValue(i) + offset
///
// ---------------------------------------------------------------------------
(**
@param inValue (In) valeur d entree
@param coeff (In) pente de la droite
@param offset (In) valeur de la droite a l origine
@param outValue (Out) résultat de l equation
*)


Procedure Linear(const coeff, offset, inValue : double; var outValue : Double);
begin
  outValue := coeff * inValue + offset;
end;

// ----------------------------------------------------------------------------
//  Procedure SumOfDemandRec (extra)
//  ------------------------
//
/// Calcule recursivement la somme de tous les attributs nommés 'demand' de TOUTES les entites
///
/// Description : Calcule récursivement la somme de tous les attributs nommés
/// 'demand' pour toutes les entités ayant un attribut nommé 'demand' a partir
/// de l'entité placé en paramètre
///
/// module 'extra'
///
// ---------------------------------------------------------------------------
(**
@param instance entité à partir de laquelle la recherche est faite récursivement
@param total (Kout) somme des attributs 'demand'
*)

Procedure SumOfDemandRec(var instance : TInstance; var total : Double);
var
  i,le : Integer;
  entityContribution : Double;
  currentInstance : TInstance;
  attributeRef : TAttribute;
begin
  total := 0;

  // ajout de la demande pour l'entité 'instance'
  if ((instance as TEntityInstance).GetTAttribute('demand') <> nil) then
  begin
    entityContribution := (instance as TEntityInstance).GetTAttribute('demand').GetCurrentSample().value;
    total := total + entityContribution;

    SRwriteln('demand de ' + (instance as TEntityInstance).GetName() + ' = ' + floattostr(entityContribution));

  end;

  // ajout (récursif) des demande de chaque entité
  le := (instance as TEntityInstance).LengthTInstanceList();
  for i:=0 to le-1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      entityContribution := 0;
      SumOfDemandRec(currentInstance,entityContribution);
      total := total + entityContribution;
    end;
  end;
end;


// procedure SumOfBiomassOnCulmInInternodeRec(extra)

procedure SumOfBiomassOnCulmInInternodeRec(var instance : TInstance; var total : Double);
var
  refFather, currentInstance : TInstance;
  i, le : Integer;
  biomassIN : Double;
begin
{  if ((instance as TEntityInstance).GetTAttribute('isOnMainstem') <> nil) then
  begin
    isOnMainstem := (instance as TEntityInstance).GetTAttribute('isOnMainstem').GetCurrentSample().value;
    if (isOnMainstem = 1) then
    begin
      refFather := instance.GetFather();
      if (refFather is TEntityInstance) then
      begin
      end;
    end;
    if (isOnMainstem = 0) then
    begin
    end;
  end;}
  total := 0;
  refFather := instance.GetFather();
  if (refFather is TEntityInstance) then
  begin
    le := (refFather as TEntityInstance).LengthTInstanceList();
    for i :=  0 to le - 1 do
    begin
      currentInstance := (refFather as TEntityInstance).GetTInstance(i);
      if (currentInstance is TEntityInstance) then
      begin
        if ((currentInstance as TEntityInstance).GetCategory() = 'Internode') then
        begin
          if ((currentInstance as TEntityInstance).GetTAttribute('biomassIN') <> nil) then
          begin
            biomassIN := (currentInstance as TEntityInstance).GetTAttribute('biomassIN').GetCurrentSample().value;
            SRwriteln('Contribution de ' + currentInstance.GetName() + ' : ' + FloatToStr(biomassIN));
            total := total + biomassIN;
          end;
        end;
      end;
    end;
    SRwriteln('Total : ' + FloatToStr(total));
  end;
end;


// procedure SumOfStockOnCulmInInternodeRec(extra)

procedure SumOfStockOnCulmInInternodeRec(var instance : TInstance; var total : Double);
var
  isOnMainstem : Double;
begin
  if ((instance as TEntityInstance).GetTAttribute('isOnMainstem') <> nil) then
  begin
    isOnMainstem := (instance as TEntityInstance).GetTAttribute('isOnMainstem').GetCurrentSample().value;
    if (isOnMainstem = 1) then
    begin
      //showmessage('on mainstem');
      SumOfStockOnMainstemInInternodeRec(instance, total);
    end;
    if (isOnMainstem = 0) then
    begin
      //showmessage('on tiller');
      SumOfStockOnTillersInInternodeRec(instance, total);
    end;
  end;
end;

procedure SumOfLengthOnTillersInInternodeRec(var instance : TInstance; var total : Double);
var
  i,le : Integer;
  entityContribution : Double;
  currentInstance : TInstance;
  currentTEntityInstance : TEntityInstance;
  father : TInstance;
begin

  total := 0;

  father := (instance as TEntityInstance).GetFather();
  while ((father as TEntityInstance).GetCategory() <> 'Tiller') do
  begin
    father := (father as TEntityInstance).GetFather();
  end;

  //showmessage('instance name : ' + (instance as TEntityInstance).GetName());

  le := (father as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (father as TEntityInstance).GetTInstance(i);

    //showmessage('currentInstance name : ' + currentInstance.GetName());

    if (currentInstance is TEntityInstance) then
    begin
      currentTEntityInstance := (currentInstance as TEntityInstance);
      if (currentTEntityInstance.GetCategory() = 'Internode') then
      begin
        if (currentTEntityInstance.GetTAttribute('LIN') <> nil) then
        begin
          entityContribution := currentTEntityInstance.GetTAttribute('LIN').GetCurrentSample().value;
          //showmessage(' contribution de ' + currentTEntityInstance.GetName() + ' : ' + floattostr(entityContribution));
          total := total + entityContribution;
        end;
      end;
      //showmessage('nom : ' + currentInstance.GetName() + ' category : ' + (currentInstance as TEntityInstance).GetCategory());
    end;
  end;
  SRwriteln('SumOfLengthOnTillersInInternodeRec : ' + FloatToStr(total));

end;


procedure SumOfLengthOnMainstemInInternodeRec(var instance : TInstance; var total : Double);
var
  i,le : Integer;
  entityContribution : Double;
  currentInstance : TInstance;
  currentTEntityInstance : TEntityInstance;
  father : TInstance;

  isOnMainstem : Double;

begin
  total := 0;

  father := (instance as TEntityInstance).GetFather();
  while (father.GetName() <> 'EntityMeristem') do
  begin
    father := (father as TEntityInstance).GetFather();
  end;

  {showmessage('instance name : ' + (instance as TEntityInstance).GetName());
  showmessage('father name : ' + (father as TEntityInstance).GetName());
  showmessage('father category : ' + (father as TEntityInstance).GetCategory());
  showmessage('instance on mainsem ? : ' +  floattostr((instance as TEntityInstance).GetTAttribute('isOnMainstem').getcurrentsample().value));}

  le := (father as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (father as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      currentTEntityInstance := (currentInstance as TEntityInstance);
      if (currentTEntityInstance.GetCategory() = 'Internode') then
      begin
        if (currentTEntityInstance.GetTAttribute('LIN') <> nil) then
        begin
          entityContribution := currentTEntityInstance.GetTAttribute('LIN').GetCurrentSample().value;
          SRwriteln(' contribution de ' + currentTEntityInstance.GetName() + ' : ' + floattostr(entityContribution));
          total := total + entityContribution;
        end;
      end;
      //showmessage('nom : ' + currentInstance.GetName() + ' category : ' + (currentInstance as TEntityInstance).GetCategory());
    end;
  end;
  SRwriteln('SumOfLengthOnMainstemInInternodeRec : ' + FloatToStr(total));

end;

procedure SumOfDemandOnCulmInInternode(var instance : TInstance; var total : Double);
var
  i,le : Integer;
  entityContribution : Double;
  currentInstance : TInstance;
  currentTEntityInstance : TEntityInstance;
  father : TInstance;

  isOnMainstem : Double;

begin
  total := 0;
  SRwriteln('instance name : ' + (instance as TEntityInstance).GetName());
  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      currentTEntityInstance := (currentInstance as TEntityInstance);
      if (currentTEntityInstance.GetCategory() = 'Internode') then
      begin
        if (currentTEntityInstance.GetTAttribute('demandIN') <> nil) then
        begin
          entityContribution := currentTEntityInstance.GetTAttribute('demandIN').GetCurrentSample().value;
          SRwriteln(' contribution de ' + currentTEntityInstance.GetName() + ' : ' + floattostr(entityContribution));
          total := total + entityContribution;
        end;
      end;
    end;
  end;
  SRwriteln('SumOfDemandOnCulmInInternode : ' + FloatToStr(total));

end;

procedure SumOfDemandOnCulmInNonInternode(var instance : TInstance; var total : Double);
var
  i,le : Integer;
  entityContribution : Double;
  currentInstance : TInstance;
  currentTEntityInstance : TEntityInstance;
  father : TInstance;

  isOnMainstem : Double;

begin
  total := 0;

  SRwriteln('instance name : ' + (instance as TEntityInstance).GetName());
  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      currentTEntityInstance := (currentInstance as TEntityInstance);
      if ((currentTEntityInstance.GetCategory() <> 'Internode') and (currentTEntityInstance.GetCategory() <> 'Root')) then
      begin
        if (currentTEntityInstance.GetTAttribute('demand') <> nil) then
        begin
          entityContribution := currentTEntityInstance.GetTAttribute('demand').GetCurrentSample().value;
          SRwriteln(' contribution de ' + currentTEntityInstance.GetName() + ' : ' + floattostr(entityContribution));
          total := total + entityContribution;
        end;
        if (currentTEntityInstance.GetTAttribute('demandIN') <> nil) then
        begin
          entityContribution := currentTEntityInstance.GetTAttribute('demandIN').GetCurrentSample().value;
          SRwriteln(' contribution de ' + currentTEntityInstance.GetName() + ' : ' + floattostr(entityContribution));
          total := total + entityContribution;
        end;
        if (currentTEntityInstance.GetTAttribute('day_demand_panicle') <> nil) then
        begin
          entityContribution := currentTEntityInstance.GetTAttribute('day_demand_panicle').GetCurrentSample().value;
          SRwriteln(' contribution de ' + currentTEntityInstance.GetName() + ' : ' + floattostr(entityContribution));
          total := total + entityContribution;
        end;
      end;
    end;
  end;
  SRwriteln('SumOfDemandOnCulmInNonInternode : ' + FloatToStr(total));
end;


procedure SumOfStockOnCulmInInternode(var instance : TInstance; var total : Double);
var
  i,le : Integer;
  entityContribution : Double;
  currentInstance : TInstance;
  currentTEntityInstance : TEntityInstance;
  father : TInstance;

  isOnMainstem : Double;

begin
  total := 0;

  //father := (instance as TEntityInstance).GetFather();
  SRwriteln('instance name : ' + (instance as TEntityInstance).GetName());
  //SRwriteln('father name : ' + (father as TEntityInstance).GetName());
  //SRwriteln('father category : ' + (father as TEntityInstance).GetCategory());
  //while (father.GetName() <> 'EntityMeristem') do
  //begin
  //  father := (father as TEntityInstance).GetFather();
  //end;

  //showmessage('instance on mainsem ? : ' +  floattostr((instance as TEntityInstance).GetTAttribute('isOnMainstem').getcurrentsample().value));

  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      currentTEntityInstance := (currentInstance as TEntityInstance);
      if (currentTEntityInstance.GetCategory() = 'Internode') then
      begin
        if (currentTEntityInstance.GetTAttribute('stockIN') <> nil) then
        begin
          entityContribution := currentTEntityInstance.GetTAttribute('stockIN').GetCurrentSample().value;
          SRwriteln(' contribution de ' + currentTEntityInstance.GetName() + ' : ' + floattostr(entityContribution));
          total := total + entityContribution;
        end;
      end;
      //showmessage('nom : ' + currentInstance.GetName() + ' category : ' + (currentInstance as TEntityInstance).GetCategory());
    end;
  end;
  SRwriteln('SumOfStockOnMainstemInInternode : ' + FloatToStr(total));

end;

// procedure SumOfDeficitOnCulmInInternode

procedure SumOfDeficitOnCulmInInternode(var instance : TInstance; var total : Double);
var
  i,le : Integer;
  entityContribution : Double;
  currentInstance : TInstance;
  currentTEntityInstance : TEntityInstance;
  father : TInstance;

  isOnMainstem : Double;

begin
  total := 0;

  //father := (instance as TEntityInstance).GetFather();
  SRwriteln('instance name : ' + (instance as TEntityInstance).GetName());
  //SRwriteln('father name : ' + (father as TEntityInstance).GetName());
  //SRwriteln('father category : ' + (father as TEntityInstance).GetCategory());
  //while (father.GetName() <> 'EntityMeristem') do
  //begin
  //  father := (father as TEntityInstance).GetFather();
  //end;

  //showmessage('instance on mainsem ? : ' +  floattostr((instance as TEntityInstance).GetTAttribute('isOnMainstem').getcurrentsample().value));

  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      currentTEntityInstance := (currentInstance as TEntityInstance);
      if (currentTEntityInstance.GetCategory() = 'Internode') then
      begin
        if (currentTEntityInstance.GetTAttribute('deficitIN') <> nil) then
        begin
          entityContribution := currentTEntityInstance.GetTAttribute('deficitIN').GetCurrentSample().value;
          SRwriteln(' contribution de ' + currentTEntityInstance.GetName() + ' : ' + floattostr(entityContribution));
          total := total + entityContribution;
        end;
      end;
      //showmessage('nom : ' + currentInstance.GetName() + ' category : ' + (currentInstance as TEntityInstance).GetCategory());
    end;
  end;
  SRwriteln('SumOfDeficitOnCulmInInternode : ' + FloatToStr(total));

end;

// procedure SumOfStockOnCulmInInternodeRec(extra)

procedure SumOfLengthOnCulmInInternodeRec(var instance : TInstance; var total : Double);
var
  isOnMainstem : Double;
begin
  if ((instance as TEntityInstance).GetTAttribute('isOnMainstem') <> nil) then
  begin
    isOnMainstem := (instance as TEntityInstance).GetTAttribute('isOnMainstem').GetCurrentSample().value;
    if (isOnMainstem = 1) then
    begin
      //showmessage('on mainstem');
      SumOfLengthOnMainstemInInternodeRec(instance, total);
    end;
    if (isOnMainstem = 0) then
    begin
      //showmessage('on tiller');
      SumOfLengthOnTillersInInternodeRec(instance, total);
    end;
  end;
end;


// ----------------------------------------------------------------------------
// Procedure SumOfBiomassOnTillersInInternodeRec (extra)
// ------------------------------------------------------
//
// Calcule recursivement la somme de tous les attributs nommés 'biomass' dans les
// entrenoeuds des talles
//
// module 'extra'
//
// ----------------------------------------------------------------------------
(**
@param instance entité à partir de laquelle la recherche est faite récursivement
@param total (Kout) somme des attributs 'biomass' des entités 'Internode' des talles
*)

procedure SumOfBiomassOnTillersInInternodeRec(var instance : TInstance; var total : Double);
var
  i,le : Integer;
  currentInstance : TInstance;
  biomassIN :  Double;
begin
  total := 0;

  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      if ((currentInstance as TEntityInstance).GetCategory() = 'Internode') then
      begin
        if ((currentInstance as TEntityInstance).GetTAttribute('biomassIN') <> nil) then
        begin
          biomassIN := (currentInstance as TEntityInstance).GetTAttribute('biomassIN').GetCurrentSample().value;
          SRwriteln('Contribution de ' + currentInstance.GetName() + ' : ' + FloatToStr(biomassIN));
          total := total + biomassIN;
        end;
      end;
    end;
  end;
  SRwriteln('Total : ' + FloatToStr(total));
end;



// ----------------------------------------------------------------------------
// Procedure SumOfStockOnTillersInInternodeRec (extra)
// ------------------------------------------------------
//
// Calcule recursivement la somme de tous les attributs nommés 'biomass' dans les
// entrenoeuds des talles
//
// module 'extra'
//
// ----------------------------------------------------------------------------
(**
@param instance entité à partir de laquelle la recherche est faite récursivement
@param total (Kout) somme des attributs 'biomass' des entités 'Internode' des talles
*)

procedure SumOfStockOnTillersInInternodeRec(var instance : TInstance; var total : Double);
var
  i,le : Integer;
  entityContribution : Double;
  currentInstance : TInstance;
  currentTEntityInstance : TEntityInstance;
  father : TInstance;
begin

  total := 0;

  father := (instance as TEntityInstance).GetFather();
  while ((father as TEntityInstance).GetCategory() <> 'Tiller') do
  begin
    father := (father as TEntityInstance).GetFather();
  end;

  //showmessage('instance name : ' + (instance as TEntityInstance).GetName());

  le := (father as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (father as TEntityInstance).GetTInstance(i);

    //showmessage('currentInstance name : ' + currentInstance.GetName());

    if (currentInstance is TEntityInstance) then
    begin
      currentTEntityInstance := (currentInstance as TEntityInstance);
      if (currentTEntityInstance.GetCategory() = 'Internode') then
      begin
        if (currentTEntityInstance.GetTAttribute('stockIN') <> nil) then
        begin
          entityContribution := currentTEntityInstance.GetTAttribute('stockIN').GetCurrentSample().value;
          //showmessage(' contribution de ' + currentTEntityInstance.GetName() + ' : ' + floattostr(entityContribution));
          total := total + entityContribution;
        end;
      end;
      //showmessage('nom : ' + currentInstance.GetName() + ' category : ' + (currentInstance as TEntityInstance).GetCategory());
    end;
  end;
  SRwriteln('SumOfStockOnTillersInInternodeRec : ' + FloatToStr(total));

end;



// ----------------------------------------------------------------------------
// Procedure SumOfBiomassOnMainstemInInternodeRec (extra)
// ------------------------------------------------------
//
// Calcule recursivement la somme de tous les attributs nommés 'biomass' dans les
// entrenoeuds du brin maître
//
// module 'extra'
//
// ----------------------------------------------------------------------------
(**
@param instance entité à partir de laquelle la recherche est faite récursivement
@param total (Kout) somme des attributs 'biomass' des entités 'Internode'
*)

procedure SumOfBiomassOnMainstemInInternodeRec(var instance : TInstance; var total : Double);
var
  i,le : Integer;
  currentInstance : TInstance;
  biomassIN :  Double;
begin
  total := 0;

  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      if ((currentInstance as TEntityInstance).GetCategory() = 'Internode') then
      begin
        if ((currentInstance as TEntityInstance).GetTAttribute('biomassIN') <> nil) then
        begin
          biomassIN := (currentInstance as TEntityInstance).GetTAttribute('biomassIN').GetCurrentSample().value;
          SRwriteln('Contribution de ' + currentInstance.GetName() + ' : ' + FloatToStr(biomassIN));
          total := total + biomassIN;
        end;
      end;
    end;
  end;
  SRwriteln('Total : ' + FloatToStr(total));

  {father := (instance as TEntityInstance).GetFather();
  while (father.GetName() <> 'EntityMeristem') do
  begin
    father := (father as TEntityInstance).GetFather();
  end;

  {showmessage('instance name : ' + (instance as TEntityInstance).GetName());
  showmessage('father name : ' + (father as TEntityInstance).GetName());
  showmessage('father category : ' + (father as TEntityInstance).GetCategory());
  showmessage('instance on mainsem ? : ' +  floattostr((instance as TEntityInstance).GetTAttribute('isOnMainstem').getcurrentsample().value));}

  {le := (father as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (father as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      currentTEntityInstance := (currentInstance as TEntityInstance);
      if (currentTEntityInstance.GetCategory() = 'Internode') then
      begin
        if (currentTEntityInstance.GetTAttribute('biomassIN') <> nil) then
        begin
          entityContribution := currentTEntityInstance.GetTAttribute('biomassIN').GetCurrentSample().value;
          srwriteln(' contribution de ' + currentTEntityInstance.GetName() + ' : ' + floattostr(entityContribution));
          total := total + entityContribution;
        end;
      end;
      //showmessage('nom : ' + currentInstance.GetName() + ' category : ' + (currentInstance as TEntityInstance).GetCategory());
    end;
  end;
  SRwriteln('SumOfBiomassOnMainstemInInternodeRec : ' + FloatToStr(total)); }




end;



// ----------------------------------------------------------------------------
// Procedure SumOfStockOnMainstemInInternodeRec (extra)
// ------------------------------------------------------
//
// Calcule recursivement la somme de tous les attributs nommés 'biomass' dans les
// entrenoeuds du brin maître
//
// module 'extra'
//
// ----------------------------------------------------------------------------
(**
@param instance entité à partir de laquelle la recherche est faite récursivement
@param total (Kout) somme des attributs 'biomass' des entités 'Internode'
*)

procedure SumOfStockOnMainstemInInternodeRec(var instance : TInstance; var total : Double);
var
  i,le : Integer;
  entityContribution : Double;
  currentInstance : TInstance;
  currentTEntityInstance : TEntityInstance;
  father : TInstance;

  isOnMainstem : Double;

begin
  total := 0;

  father := (instance as TEntityInstance).GetFather();
  while (father.GetName() <> 'EntityMeristem') do
  begin
    father := (father as TEntityInstance).GetFather();
  end;

  {showmessage('instance name : ' + (instance as TEntityInstance).GetName());
  showmessage('father name : ' + (father as TEntityInstance).GetName());
  showmessage('father category : ' + (father as TEntityInstance).GetCategory());
  showmessage('instance on mainsem ? : ' +  floattostr((instance as TEntityInstance).GetTAttribute('isOnMainstem').getcurrentsample().value));}

  le := (father as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (father as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      currentTEntityInstance := (currentInstance as TEntityInstance);
      if (currentTEntityInstance.GetCategory() = 'Internode') then
      begin
        if (currentTEntityInstance.GetTAttribute('stockIN') <> nil) then
        begin
          entityContribution := currentTEntityInstance.GetTAttribute('stockIN').GetCurrentSample().value;
          SRwriteln(' contribution de ' + currentTEntityInstance.GetName() + ' : ' + floattostr(entityContribution));
          total := total + entityContribution;
        end;
      end;
      //showmessage('nom : ' + currentInstance.GetName() + ' category : ' + (currentInstance as TEntityInstance).GetCategory());
    end;
  end;
  SRwriteln('SumOfStockOnMainstemInInternodeRec : ' + FloatToStr(total));

end;

// ----------------------------------------------------------------------------
// Procedure SumOfBiomassOnMainstemInLeafRec (extra)
// -------------------------------------------------
//
// Calcule recursivement la somme de tous les attributs nommés 'biomass' dans les
// feuille du brin maître
//
// module 'extra'
//
// ----------------------------------------------------------------------------
(**
@param instance entité à partir de laquelle la recherche est faite récursivement
@param total (Kout) somme des attributs 'biomass' des entités 'Leaf'
*)

procedure SumOfBiomassOnMainstemInLeafRec(var instance : TInstance; var total : Double);
var
  i, le, stateMeristem : Integer;
  entityContribution : Double;
  currentInstance : TInstance;
  father : TInstance;
begin
  stateMeristem := (instance as TEntityInstance).GetCurrentState();
  case stateMeristem of
    2, 3, 4, 5, 6, 9 :
    begin
      total := 0;
      SRwriteln('state meristem : ' + IntToStr(stateMeristem));
      le := (instance as TEntityInstance).LengthTInstanceList();
      for i := 0 to le - 1 do
      begin
        currentInstance := (instance as TEntityInstance).GetTInstance(i);
        if (currentInstance is TEntityInstance) then
        begin
          if (((currentInstance as TEntityInstance).GetTAttribute('biomass') <> nil) and
              ((currentInstance as TEntityInstance).GetCategory() = 'Leaf')) then
          begin
            SRwriteln('Name : ' +  (currentInstance as TEntityInstance).GetName());
            entityContribution := (currentInstance as TEntityInstance).GetTAttribute('biomass').GetCurrentSample().value;
            SRwriteln('Contribution : ' + floattostr(entityContribution));
            total := total + entityContribution;
          end;
        end;
      end;
      SRwriteln('sumOfBiomassOnMainstemInLeafRec --> ' + FloatToStr(total));
    end;
  end;
end;

// -----------------------------------------------------------------------------
// Procedure SumOfBiomassOnTillerInLeafRec (extra)
// -------------------------------------------------
//
// Calcule recursivement la somme de tous les attributs nommés 'biomass' dans les
// feuille de l'entité Tiller qui l'appelle
//
// module extra
//
// -----------------------------------------------------------------------------

procedure SumOfBiomassOnTillerInLeafRec(var instance : TInstance; var total : Double);
var
  i,le : Integer;
  entityContribution : Double;
  currentInstance : TInstance;
  father : TInstance;
begin
  total := 0;

  //showmessage('category : '  + (instance as TEntityInstance).GetCategory());
  //showmessage('name : ' + (instance as TEntityInstance).GetName());
  //showmessage('type : ' + (instance as TEntityInstance).GetCategory());
  //showmessage('class type : ' + (instance as TEntityInstance).GetClassType());

  //if ((instance as TEntityInstance).GetCategory() = 'Internode') then
  //  showmessage('halt');

  father := (instance as TEntityInstance).GetFather();

  // ajout de la contribution pour l'entité 'instance'
  if ( ((instance as TEntityInstance).GetTAttribute('biomass') <> nil) and
       ((instance as TEntityInstance).GetCategory() = 'Leaf') and
       ((father as TEntityInstance).GetCategory() = 'Tiller')
     ) then
  begin
    entityContribution := (instance as TEntityInstance).GetTAttribute('biomass').GetCurrentSample().value;
    total := total + entityContribution;
  end;
  //else
    //total := 0;

  // ajout (récursif) des demande de chaque entité
  le := (instance as TEntityInstance).LengthTInstanceList();

  //showmessage('longueur de la liste : ' + inttostr(le));

  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    //if (currentInstance is TEntityInstance) then
    if (currentInstance is TEntityInstance) then
    begin
      entityContribution := 0;
      SumOfBiomassOnTillerInLeafRec(currentInstance, entityContribution);
      total := total + entityContribution;
    end
    //else
    // total := 0;
  end;

  SRwriteln('total : ' + floattostr(total));

end;

// ----------------------------------------------------------------------------
// Procedure SumOfBladeAreaOnMainstemInLeafRec (extra)
// -------------------------------------------------
//
// Calcule recursivement la somme de tous les attributs nommés 'bladeArea' dans les
// feuille du brin maître
//
// module 'extra'
//
// ----------------------------------------------------------------------------
(**
@param instance entité à partir de laquelle la recherche est faite récursivement
@param total (Kout) somme des attributs 'biomass' des entités 'Leaf'
*)

procedure SumOfBladeAreaOnMainstemInLeafRec(var instance : TInstance; var total : Double);
var
  i, le, stateMeristem : Integer;
  entityContribution : Double;
  currentInstance : TInstance;
begin
  stateMeristem := (instance as TEntityInstance).GetCurrentState();
  case StateMeristem of
    4, 5, 6, 7, 8, 9, 10, 11 :
    begin
      SRwriteln('state meristem : ' + IntToStr(stateMeristem));
      le := (instance as TEntityInstance).LengthTInstanceList();
      total := 0;
      for i := 0 to le - 1 do
      begin
        currentInstance := (instance as TEntityInstance).GetTInstance(i);
        if (currentInstance is TEntityInstance) then
        begin
          if ( ((currentInstance as TEntityInstance).GetTAttribute('bladeArea') <> nil) and
             ((currentInstance as TEntityInstance).GetCategory() = 'Leaf')) then
          begin
            entityContribution := (currentInstance as TEntityInstance).GetTAttribute('bladeArea').GetCurrentSample().value;
            SRwriteln('contribution : ' + currentInstance.GetName() + ' = ' + FloatToStr(entityContribution));
            total := total + entityContribution;
          end;
        end;
      end;
      SRwriteln('sumOfBladeAreaOnMainstemInLeafRec : ' + FloatToStr(total));
    end;
  end;
end;


// ----------------------------------------------------------------------------
// Procedure SumOfBladeAreaOnTillerInLeafRec (extra)
// -------------------------------------------------
//
// Calcule recursivement la somme de tous les attributs nommés 'bladeArea' dans les
// feuille du brin maître
//
// module 'extra'
//
// ----------------------------------------------------------------------------
(**
@param instance entité à partir de laquelle la recherche est faite récursivement
@param total (Kout) somme des attributs 'biomass' des entités 'Leaf'
*)

procedure SumOfBladeAreaOnTillerInLeafRec(var instance : TInstance; var total : Double);
var
  i,le : Integer;
  entityContribution : Double;
  currentInstance : TInstance;
  father : TInstance;
begin
  total := 0;

  father := (instance as TEntityInstance).GetFather();

  // ajout de la contribution pour l'entité 'instance'
  if ( ((instance as TEntityInstance).GetTAttribute('bladeArea') <> nil) and
       ((instance as TEntityInstance).GetCategory() = 'Leaf') and
       ((father as TEntityInstance).GetCategory() = 'Tiller')
     ) then
  begin
    entityContribution := (instance as TEntityInstance).GetTAttribute('bladeArea').GetCurrentSample().value;
    total := total + entityContribution;
  end;

  // ajout (récursif) des demande de chaque entité
  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      entityContribution := 0;
      SumOfBladeAreaOnTillerInLeafRec(currentInstance, entityContribution);
      total := total + entityContribution;
    end;
  end;

  SRwriteln('total : ' + floattostr(total));

end;

// ----------------------------------------------------------------------------
// Procedure SumOfAttributeInOrganRec
// ----------------------------------
//
// Fonction interne permettant de calculer la somme de la valeur d'un attribut
// passé en paramètre sur un organe lui aussi passé en paramètre. Retourne la
// somme
//
// ----------------------------------------------------------------------------

procedure SumOfAttributeInOrganRec(var instance : TInstance; attribute, organ : String; var total : Double);
var
  i,le : Integer;
  entityContribution : Double;
  currentInstance : TInstance;
begin
  total := 0;

  // ajout de la contribution pour l'entité 'instance'
  if ( ((instance as TEntityInstance).GetTAttribute(attribute) <> nil) and
       ((instance as TEntityInstance).GetCategory() = organ)
     ) then
  begin
    entityContribution := (instance as TEntityInstance).GetTAttribute(attribute).GetCurrentSample().value;
    total := total + entityContribution;
    SRwriteln('contribution de ' + instance.GetName() + ' --> ' + FloatToStr(entityContribution));
  end;

  // ajout (récursif) des demande de chaque entité
  le := (instance as TEntityInstance).LengthTInstanceList();
  for i:=0 to le-1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      entityContribution := 0;
      SumOfAttributeInOrganRec(currentInstance,attribute,organ,entityContribution);
      total := total + entityContribution;
    end;
  end;
  SRwriteln('total --> ' + FloatToStr(total));
end;

// ----------------------------------------------------------------------------
//  Procedure SumOfBladeAreaInLeafRec (extra)
//  ----------------------------------
//
/// Calcule recursivement la somme de tous les attributs nommés 'bladeArea' de TOUTES les entites de type 'Leaf'
///
/// Description : Calcule récursivement la somme de tous les attributs nommés
/// 'bladeArea' pour toutes les entités de type 'Leaf' ayant un attribut nommé
/// 'bladeArea' a partir de l'entité placé en paramètre
///
/// module 'extra'
///
// ---------------------------------------------------------------------------
(**
@param instance entité à partir de laquelle la recherche est faite récursivement
@param total (Kout) somme des attributs 'bladeArea' des entité 'Leaf'
*)

Procedure SumOfBladeAreaInLeafRec(var instance : TInstance; var total : Double);
begin
  SumOfAttributeInOrganRec(instance, 'bladeArea', 'Leaf', total);
end;


// ----------------------------------------------------------------------------
//  Procedure SumOfBiomassInLeafRec (extra)
//  ----------------------------------
//
/// Calcule recursivement la somme de tous les attributs nommés 'biomass' de TOUTES les entites de type 'Leaf'
///
/// Description : Calcule récursivement la somme de tous les attributs nommés
/// 'biomass' pour toutes les entités de type 'Leaf' ayant un attribut nommé
/// 'biomass' a partir de l'entité placé en paramètre
///
/// module 'extra'
///
// ---------------------------------------------------------------------------
(**
@param instance entité à partir de laquelle la recherche est faite récursivement
@param total (Kout) somme des attributs 'biomass' des entité 'Leaf'
*)

Procedure SumOfBiomassInLeafRec(var instance : TInstance; var total : Double);
begin
  SumOfAttributeInOrganRec(instance, 'biomass', 'Leaf', total);
end;


// ----------------------------------------------------------------------------
//  Procedure SumOfDemandInLeafRec (extra)
//  ----------------------------------
//
/// Calcule recursivement la somme de tous les attributs nommés 'demand' de TOUTES les entites de type 'Leaf'
///
/// Description : Calcule récursivement la somme de tous les attributs nommés
/// 'demand' pour toutes les entités de type 'Leaf' ayant un attribut nommé
/// 'demand' a partir de l'entité placé en paramètre
///
/// module 'extra'
///
// ---------------------------------------------------------------------------
(**
@param instance entité à partir de laquelle la recherche est faite récursivement
@param total (Kout) somme des attributs 'demand' des entité 'Leaf'
*)

Procedure SumOfDemandInLeafRec(var instance : TInstance; var total : Double);
begin
  SumOfAttributeInOrganRec(instance, 'demand', 'Leaf', total);
end;


// ----------------------------------------------------------------------------
//  Procedure SumOfDemandInLeafOnMainstemRec (extra)
//  ------------------------------------------------
//
/// Calcule recursivement la somme de tous les attributs nommés 'demand' de TOUTES les entites de type 'Leaf'
/// sur la brin maitre
///
/// Description : Calcule récursivement la somme de tous les attributs nommés
/// 'demand' pour toutes les entités de type 'Leaf' sur le brin maitre
///
/// module 'extra'
///
// ---------------------------------------------------------------------------
(**
@param instance entité à partir de laquelle la recherche est faite récursivement
@param total (Kout) somme des attributs 'demand' des entité 'Leaf'
*)


Procedure SumOfDemandInOrganOnMainstemRec(var instance : TInstance; var total : Double);
var
  i,le : Integer;
  entityContribution : Double;
  currentInstance : TInstance;
  currentEntity : TEntityInstance;
  father : TInstance;
begin
  total := 0;
  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      currentEntity := (currentInstance as TEntityInstance);
      if ((currentEntity.GetCategory() = 'Leaf') and
        (currentEntity.GetTAttribute('demand') <> nil)) then
      begin
        entityContribution := currentEntity.GetTAttribute('demand').GetCurrentSample().value;
        total := total + entityContribution;
        SRwriteln('contribution de : ' + currentEntity.GetName() + ' = ' + FloatToStr(entityContribution));
      end
      else
      begin
        if ((currentEntity.GetCategory() = 'Internode') and
           (currentEntity.GetTAttribute('demandIN') <> nil)) then
        begin
          entityContribution := currentEntity.GetTAttribute('demandIN').GetCurrentSample().value;
          total := total + entityContribution;
          SRwriteln('contribution de : ' + currentEntity.GetName() + ' = ' + FloatToStr(entityContribution));
        end
        else
        begin
          if ((currentEntity.GetCategory() = 'Peduncle') and
             (currentEntity.GetTAttribute('demandIN') <> nil)) then
          begin
            entityContribution := currentEntity.GetTAttribute('demandIN').GetCurrentSample().value;
            total := total + entityContribution;
            SRwriteln('contribution de : ' + currentEntity.GetName() + ' = ' + FloatToStr(entityContribution));
          end
          else
          begin
            if ((currentEntity.GetCategory() = 'Panicle') and
               (currentEntity.GetTAttribute('day_demand_panicle') <> nil)) then
            begin
              entityContribution := currentEntity.GetTAttribute('day_demand_panicle').GetCurrentSample().value;
              total := total + entityContribution;
              SRwriteln('contribution de : ' + currentEntity.GetName() + ' = ' + FloatToStr(entityContribution));
            end
            else
            begin
              if ((currentEntity.GetCategory() = 'Root') and
                 (currentEntity.GetTAttribute('demand') <> nil)) then
              begin
                entityContribution := currentEntity.GetTAttribute('demand').GetCurrentSample().value;
                total := total + entityContribution;
                SRwriteln('contribution de : ' + currentEntity.GetName() + ' = ' + FloatToStr(entityContribution));
              end;
            end;
          end;
        end;
      end;
    end;
  end;
  SRwriteln('total : ' + FloatToStr(total));
end;

// ----------------------------------------------------------------------------
//  Procedure SumOfDemandInOrganOnTillerRec (extra)
//  ------------------------------------------------
//
/// Calcule recursivement la somme de tous les attributs nommés 'demand' de TOUTES les entites de type 'Leaf'
/// sur la brin maitre
///
/// Description : Calcule récursivement la somme de tous les attributs nommés
/// 'demand' pour toutes les entités de type 'Leaf' sur le brin maitre
///
/// module 'extra'
///
// ---------------------------------------------------------------------------
(**
@param instance entité à partir de laquelle la recherche est faite récursivement
@param total (Kout) somme des attributs 'demand' des entité 'Leaf'
*)


Procedure SumOfDemandInOrganOnTillerRec(var instance : TInstance; var total : Double);
var
  i,le : Integer;
  entityContribution : Double;
  currentInstance : TInstance;
  father : TInstance;
  currentEntity : TEntityInstance;
begin
  total := 0;
  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      currentEntity := (currentInstance as TEntityInstance);
      if ((currentEntity.GetCategory() = 'Leaf') and
        (currentEntity.GetTAttribute('demand') <> nil)) then
      begin
        entityContribution := currentEntity.GetTAttribute('demand').GetCurrentSample().value;
        total := total + entityContribution;
        SRwriteln('contribution de : ' + currentEntity.GetName() + ' = ' + FloatToStr(entityContribution));
      end
      else
      begin
        if ((currentEntity.GetCategory() = 'Internode') and
           (currentEntity.GetTAttribute('demandIN') <> nil)) then
        begin
          entityContribution := currentEntity.GetTAttribute('demandIN').GetCurrentSample().value;
          total := total + entityContribution;
          SRwriteln('contribution de : ' + currentEntity.GetName() + ' = ' + FloatToStr(entityContribution));
        end
        else
        begin
          if ((currentEntity.GetCategory() = 'Peduncle') and
             (currentEntity.GetTAttribute('demandIN') <> nil)) then
          begin
            entityContribution := currentEntity.GetTAttribute('demandIN').GetCurrentSample().value;
            total := total + entityContribution;
            SRwriteln('contribution de : ' + currentEntity.GetName() + ' = ' + FloatToStr(entityContribution));
          end
          else
          begin
            if ((currentEntity.GetCategory() = 'Panicle') and
               (currentEntity.GetTAttribute('day_demand_panicle') <> nil)) then
            begin
              entityContribution := currentEntity.GetTAttribute('day_demand_panicle').GetCurrentSample().value;
              total := total + entityContribution;
              SRwriteln('contribution de : ' + currentEntity.GetName() + ' = ' + FloatToStr(entityContribution));
            end
            else
            begin
              if ((currentEntity.GetCategory() = 'Root') and
                 (currentEntity.GetTAttribute('demand') <> nil)) then
              begin
                entityContribution := currentEntity.GetTAttribute('demand').GetCurrentSample().value;
                total := total + entityContribution;
                SRwriteln('contribution de : ' + currentEntity.GetName() + ' = ' + FloatToStr(entityContribution));
              end;
            end;
          end;
        end;
      end;
    end;
  end;
  SRwriteln('total : ' + floattostr(total));

end;

// ----------------------------------------------------------------------------
//  Procedure SumOfBiomassRec (extra)
//  ------------------------
//
/// Calcule recursivement la somme de tous les attributs nommés 'biomass' de TOUTES les entites
///
/// Description : Calcule récursivement la somme de tous les attributs nommés
/// 'biomass' pour toutes les entités ayant un attribut nommé 'biomass' a partir
/// de l'entité placé en paramètre
///
/// module 'extra'
///
// ---------------------------------------------------------------------------
(**
@param instance entité à partir de laquelle la recherche est faite récursivement
@param total (Kout) somme des attributs 'biomass'
*)

Procedure SumOfBiomassRec(var instance : TInstance; var total : Double);
var
  i,le : Integer;
  entityContribution : Double;
  currentInstance : TInstance;
begin
  total := 0;

  // ajout de la demande pour l'entité 'instance'
  if ((instance as TEntityInstance).GetTAttribute('biomass') <> nil) then
  begin
    entityContribution := (instance as TEntityInstance).GetTAttribute('biomass').GetCurrentSample().value;
    SRwriteln('contribution de : ' + instance.GetName() + ' = ' + FloatToStr(entityContribution));
    total := total + entityContribution;
  end
  else
  begin
    if ((instance as TEntityInstance).GetTAttribute('biomassIN') <> nil) then
    begin
      entityContribution := (instance as TEntityInstance).GetTAttribute('biomassIN').GetCurrentSample().value;
      SRwriteln('contribution de : ' + instance.GetName() + ' = ' + FloatToStr(entityContribution));
      total := total + entityContribution;
    end
    else
    begin
      if ((instance as TEntityInstance).GetTAttribute('weight_panicle') <> nil) then
      begin
        entityContribution := (instance as TEntityInstance).GetTAttribute('weight_panicle').GetCurrentSample().value;
        SRwriteln('contribution de : ' + instance.GetName() + ' = ' + FloatToStr(entityContribution));
        total := total + entityContribution;
      end;
    end;
  end;

  // ajout (récursif) des demande de chaque entité
  le := (instance as TEntityInstance).LengthTInstanceList();
  for i:=0 to le-1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      entityContribution := 0;
      SumOfBiomassRec(currentInstance,entityContribution);
      total := total + entityContribution;
    end;
  end;
  SRwriteln('total : ' + FloatToStr(total));
end;

// ----------------------------------------------------------------------------
//  Procedure EnableNbTillerCount (extra)
//  ----------------------------------
//
/// active le module 'UpdateNbTiller' lorsque le plastochron vaut 3
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

Procedure EnableNbTillerCount(var instance : TInstance; plasto : Double);
begin
  if (plasto=3) then
  begin
    (instance as TEntityInstance).GetTInstance('UpdateNbTiller').SetActiveState(0); // devient toujours actif
  end;
  if (plasto=4) then
  begin
    (instance as TEntityInstance).GetTInstance('CountOfNbTillerWithMore4Leaves').SetActiveState(0); // devient toujours actif
    (instance as TEntityInstance).GetTInstance('minNbTillerAndTAE').SetActiveState(0); // devient toujours actif
  end;
end;

// ----------------------------------------------------------------------------
//  CountOfNbTillerWithMore4Leaves (extra)
//  ----------------------------------
//
/// compte le nombre talle ayant construite plus de 4 feuilles, additionné de 1
///
/// Description : compte le nombre de talle ayant construite plus de 4 feuilles,
/// additionné de 1. Le '+1' est ici car le mainstem a construite plus de 4
/// feuilles au moment du tallage.
/// Pour le comptage, les talles doivent etre des entités de categorie 'Tiller'
/// et doivent comporter un attribut 'nbLeaf' qui comptabilise le nombre de
/// feuilles créés depuis le debut de la simulation.
///
/// module 'extra'
///
// ---------------------------------------------------------------------------
(**
@param instance entité à partir de laquelle la recherche est faite
@param nbTillerWithMore4Leaves (kOut) nombre de talles ayant plus de 4 feuilles, additionné de 1
*)

// TODO -u Model : astuce pas du tout rigoureuse. On recherche ici les talles
// telles que leafNB >=3 au lieu de 4. Cela est du a la place du module dans
// l'entité meristem. En effet, le comptage des feuilles sur les talles doit
// etre fait avant l'execution du manageur (puisque ce comptage est utilisé
// par celui-ci pour déterminer le nombre de talles a creer). Mais, dans ce
// cas, le comptage est fait avant l execution des talles presntes. Donc, le
// comptage ne tient pas compte des feuilles qui vont etre créées pendant
// ce cycle. Le probleme est le meme si l ordre d execution du comptage est
// deplacé.
// 2 solutions pour regler le probleme :
// 1) la bidouille ci-dessous
// 2) forcer l execution du comptage dans le manageur
// 3) répartir les taches du manageur en plusieurs Xmodules (le mieux et sera
// fait par la suite)

Procedure CountOfNbTillerWithMore4Leaves(var instance : TInstance; var nbTillerWithMore4Leaves : Double);
var
   i,le : Integer;
   currentInstance : TInstance;
   category : String;
   leafNb : Double;
   entityTmp : TEntityInstance;
begin
  // initialisation du nombre de talle ayant plus de 4 feuilles
  nbTillerWithMore4Leaves := 1;

  // recherche des entitéss 'Tiller' ayant l'attribut 'nbLeaf' >= 4
  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      category := (currentInstance as TEntityInstance).GetCategory();
      if (category = 'Tiller') then
      begin
        leafNb := (currentInstance as TEntityInstance).GetTAttribute('leafNb').GetCurrentSample().value;
        if(leafNb >= 3) then        // TODO -u Model : ATTENTION ASTUCE PAS DU TOUT RIGOUREUSE !!!!!!!!!!!
        begin
          nbTillerWithMore4Leaves := nbTillerWithMore4Leaves + 1;
        end;
      end;
    end;
  end;
end;

// ----------------------------------------------------------------------------
//  KillOldestLeaf (extra)
//  ----------------------
//
/// XXXXXXXXXXXXXXXXXXX
///
/// Description : XXXXXXXXXXX
///
/// module 'extra'
///
/// @param XXXXXXX
// ---------------------------------------------------------------------------

Procedure KillOldestLeaf(var instance : TInstance; var stock : Double);
var
   oldestCreationDate, currentCreationDate : TDateTime;
   currentInstance, currentInstanceOnTiller : TInstance;
   i,le : Integer;
   i2,le2 : Integer;
   biomass : Double;
Begin
  if(stock<0) then
  begin
    // recherche de la plus vieille feuille
    oldestCreationDate := MAX_DATE;

    le := (instance as TEntityInstance).LengthTInstanceList();
    for i:=0 to le-1 do
    begin
      currentInstance := (instance as TEntityInstance).GetTInstance(i);
      if (currentInstance is TEntityInstance) then
      begin
        // c'est une feuille...
        if((currentInstance as TEntityInstance).GetCategory()='Leaf') then
        begin
           currentCreationDate := currentInstance.GetCreationDate();
           oldestCreationDate := min(oldestCreationDate,currentCreationDate);
        end;

        // c'est une talle...
        if((currentInstance as TEntityInstance).GetCategory()='Tiller') then
        begin
          le2 := (currentInstance as TEntityInstance).LengthTInstanceList();
          for i2:=0 to le-1 do
          begin
            currentInstanceOnTiller := (currentInstance as TEntityInstance).GetTInstance(i2);
            if (currentInstanceOnTiller is TEntityInstance) then
            begin
              if((currentInstanceOnTiller as TEntityInstance).GetCategory()='Leaf') then
              begin
                currentCreationDate := currentInstanceOnTiller.GetCreationDate();
                oldestCreationDate := min(oldestCreationDate,currentCreationDate);
              end;
            end;
          end;
        end;

      end;
    end;

    // destruction des feuilles dont la date de creation est egale a creationDate
    // et tant que le stock est négatif
    le := (instance as TEntityInstance).LengthTInstanceList();
    for i:=0 to le-1 do
    begin
      currentInstance := (instance as TEntityInstance).GetTInstance(i);
      if (currentInstance is TEntityInstance) then
      begin
        // c'est une feuille...
        if((currentInstance as TEntityInstance).GetCategory()='Leaf') then
        begin
           // test pour savoir si c'est une vieille feuille
           if (currentInstance.GetCreationDate() = oldestCreationDate) then
           begin
             // reallocation du stock
             biomass := (currentInstance as TEntityInstance).GetTAttribute('biomass').GetCurrentSample().value;
             stock := stock + 0.4*biomass;

             // destruction de la feuille
             SRwriteln('****  destruction de la feuille : ' + currentInstance.GetName() + '  ****');
             (instance as TEntityInstance).RemoveTInstance(currentInstance);

             // verification de l'état du stock
             if (stock>=0) then exit;
             continue;
           end;
        end;

        // c'est une talle...
        if((currentInstance as TEntityInstance).GetCategory()='Tiller') then
        begin
          le2 := (currentInstance as TEntityInstance).LengthTInstanceList();
          for i2:=0 to le-1 do
          begin
            currentInstanceOnTiller := (currentInstance as TEntityInstance).GetTInstance(i2);
            if (currentInstanceOnTiller is TEntityInstance) then
            begin
              if((currentInstanceOnTiller as TEntityInstance).GetCategory()='Leaf') then
              begin
                // test pour savoir si c'est une vieille feuille
                if (currentInstanceOnTiller.GetCreationDate() = oldestCreationDate) then
                begin
                  // reallocation du stock
                  biomass := (currentInstanceOnTiller as TEntityInstance).GetTAttribute('biomass').GetCurrentSample().value;
                  stock := stock + 0.4*biomass;

                  // destruction de la feuille
                  //writeln('Destruction de la feuille : ', currentInstanceOnTiller.GetName());
                  (currentInstance as TEntityInstance).RemoveTInstance(currentInstanceOnTiller);

                  // verification de l'état du stock
                  if (stock>=0) then exit;
                end;
              end;
            end;
          end;
        end;

      end;
    end;
  end;

end;

// ----------------------------------------------------------------------------
//  Procedure SumOfBiomassInInternodeRec (extra)
//  ----------------------------------
//
/// Calcule recursivement la somme de tous les attributs nommés 'biomass' de TOUTES les entites de type 'Internode'
///
/// Description : Calcule récursivement la somme de tous les attributs nommés
/// 'biomass' pour toutes les entités de type 'Internode' ayant un attribut nommé
/// 'biomass' a partir de l'entité placé en paramètre
///
/// module 'extra'
///
// ---------------------------------------------------------------------------
(**
@param instance entité à partir de laquelle la recherche est faite récursivement
@param total (Kout) somme des attributs 'biomass' des entité 'Internode'
*)

Procedure SumOfBiomassInInternodeRec(var instance : TInstance; var total : Double);
var
  i,le : Integer;
  entityContribution : Double;
  currentInstance : TInstance;
  tmp : String;
begin
  total := 0;
  // ajout de la contribution pour l'entité 'instance'
  if ( ((instance as TEntityInstance).GetTAttribute('biomassIN') <> nil) and
       ((instance as TEntityInstance).GetCategory() = 'Internode')
     ) then
  begin
    entityContribution := (instance as TEntityInstance).GetTAttribute('biomassIN').GetCurrentSample().value;
    tmp := 'Contribution de : ';
    tmp := tmp + instance.GetName();
    tmp := tmp + ' --> ' + FloatToStr(entityContribution);
    SRwriteln(tmp);
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
      SumOfBiomassInInternodeRec(currentInstance,entityContribution);
      total := total + entityContribution;
    end;
  end;
  SRwriteln('Total biomass in internode : ' + FloatToStr(total));
end;

// ----------------------------------------------------------------------------
//  Procedure SumReservoirDispoInInternodeOnMainstemRec (extra)
//  ---------------------------------------------------
//
/// Calcule recursivement la somme de tous les attributs nommés 'reservoirDispoIN'
/// de TOUTES les entites de type 'Internode'
///
/// Description : Calcule récursivement la somme de tous les attributs nommés
/// 'reservoirDispoIN' pour toutes les entités de type 'Internode' ayant un attribut nommé
/// 'reservoirDispoIN' a partir de l'entité placé en paramètre
///
/// module 'extra'
///
// ---------------------------------------------------------------------------
(**
@param instance entité à partir de laquelle la recherche est faite récursivement
@param total (Kout) somme des attributs 'reservoirDispoIN' des entité 'Internode'
*)

procedure SumReservoirDispoInInternodeOnMainstemRec(var instance : TInstance; var total : Double);
var
  i,le : Integer;
  entityContribution : Double;
  currentInstance : TInstance;
begin
  total := 0;

  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      if ( ((currentInstance as TEntityInstance).GetTAttribute('reservoirDispoIN') <> nil) and
           ((currentInstance as TentityInstance).GetCategory() = 'Internode')) then
      begin
        entityContribution := (currentInstance as TEntityInstance).GetTAttribute('reservoirDispoIN').GetCurrentSample().value;
        SRwriteln('contribution de : ' + currentInstance.GetName() + ' = ' + FloatToStr(entityContribution));
        total := total + entityContribution;
      end;
    end;
  end;

  {father := (instance as TEntityInstance).GetFather();

  // ajout de la contribution pour l'entité 'instance'
  if ( ((instance as TEntityInstance).GetTAttribute('reservoirDispoIN') <> nil) and
       ((instance as TEntityInstance).GetCategory() = 'Internode') and
       ((father as TEntityInstance).GetName() = 'EntityMeristem')
     ) then
  begin
    entityContribution := (instance as TEntityInstance).GetTAttribute('reservoirDispoIN').GetCurrentSample().value;
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
      SumReservoirDispoInInternodeOnMainstemRec(currentInstance,entityContribution);
      total := total + entityContribution;
    end;
  end; }
  SRwriteln('total : ' + FloatToStr(total));
end;

// ----------------------------------------------------------------------------
//  Procedure SumReservoirDispoInInternodeOnTillerRec (extra)
//  ---------------------------------------------------
//
/// Calcule recursivement la somme de tous les attributs nommés 'reservoirDispoIN'
/// de TOUTES les entites de type 'Internode'
///
/// Description : Calcule récursivement la somme de tous les attributs nommés
/// 'reservoirDispoIN' pour toutes les entités de type 'Internode' ayant un attribut nommé
/// 'reservoirDispoIN' a partir de l'entité placé en paramètre
///
/// module 'extra'
///
// ---------------------------------------------------------------------------
(**
@param instance entité à partir de laquelle la recherche est faite récursivement
@param total (Kout) somme des attributs 'reservoirDispoIN' des entité 'Internode'
*)

procedure SumReservoirDispoInInternodeOnTillerRec(var instance : TInstance; var total : Double);
var
  i,le : Integer;
  entityContribution : Double;
  currentInstance : TInstance;
  father : TInstance;
begin
  total := 0;

  father := (instance as TEntityInstance).GetFather();
  SRwriteln('instance name : ' + instance.GetName());
  SRwriteln('instance category : ' + (instance as TEntityInstance).GetCategory());
  SRwriteln('father category : ' + (father as TEntityInstance).GetCategory());

  // ajout de la contribution pour l'entité 'instance'
  if ( ((instance as TEntityInstance).GetTAttribute('reservoirDispoIN') <> nil) and
       ((instance as TEntityInstance).GetCategory() = 'Internode') and
       ((father as TEntityInstance).GetCategory() = 'Tiller')
     ) then
  begin
    SRwriteln(instance.GetName());
    entityContribution := (instance as TEntityInstance).GetTAttribute('reservoirDispoIN').GetCurrentSample().value;
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
      SumReservoirDispoInInternodeOnTillerRec(currentInstance,entityContribution);
      total := total + entityContribution;
    end;
  end;

  SRwriteln('total : ' + floattostr(total));

end;

// ----------------------------------------------------------------------------
//  Procedure SumOfBiomassInRootRec (extra)
//  ----------------------------------
//
/// Calcule recursivement la somme de tous les attributs nommés 'biomass' de TOUTES les entites de type 'Root'
///
/// Description : Calcule récursivement la somme de tous les attributs nommés
/// 'biomass' pour toutes les entités de type 'Root' ayant un attribut nommé
/// 'biomass' a partir de l'entité placé en paramètre
///
/// module 'extra'
///
// ---------------------------------------------------------------------------
(**
@param instance entité à partir de laquelle la recherche est faite récursivement
@param total (Kout) somme des attributs 'biomass' des entité 'Root'
*)

Procedure SumOfBiomassInRootRec(var instance : TInstance; var total : Double);
var
  i,le : Integer;
  entityContribution : Double;
  currentInstance : TInstance;
begin
  total := 0;

  // ajout de la contribution pour l'entité 'instance'
  if ( ((instance as TEntityInstance).GetTAttribute('biomass') <> nil) and
       ((instance as TEntityInstance).GetCategory() = 'Root')
     ) then
  begin
    entityContribution := (instance as TEntityInstance).GetTAttribute('biomass').GetCurrentSample().value;
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
      SumOfBiomassInRootRec(currentInstance,entityContribution);
      total := total + entityContribution;
    end;
  end;
end;

procedure SumOfDemandOnTillers(var instance : TInstance; var total : Double);
var
  le, i : Integer;
  currentInstance : TInstance;
  currentEntity : TEntityInstance;
  entityContribution : Double;
begin
  le := (instance as TEntityInstance).LengthTInstanceList();
  total := 0;
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      currentEntity := (currentInstance as TEntityInstance);
      if (currentEntity.GetCategory() = 'Tiller') then
      begin
        if (currentEntity.GetTAttribute('day_demand_tiller') <> nil) then
        begin
          entityContribution := currentEntity.GetTAttribute('day_demand_tiller').GetCurrentSample().value;
          SRwriteln('contribution de : ' + currentEntity.GetName() + ' = ' + FloatToStr(entityContribution));
          total := total + entityContribution;
        end;
      end;
    end;
  end;
  SRwriteln('total : ' + FloatToStr(total));
end;

procedure SumOfLastDemandOnTillers(var instance : TInstance; var total : Double);
var
  le, i : Integer;
  currentInstance : TInstance;
  currentEntity : TEntityInstance;
  entityContribution : Double;
begin
  le := (instance as TEntityInstance).LengthTInstanceList();
  total := 0;
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      currentEntity := (currentInstance as TEntityInstance);
      if (currentEntity.GetCategory() = 'Tiller') then
      begin
        if (currentEntity.GetTAttribute('last_demand_tiller') <> nil) then
        begin
          entityContribution := currentEntity.GetTAttribute('last_demand_tiller').GetCurrentSample().value;
          SRwriteln('contribution de : ' + currentEntity.GetName() + ' = ' + FloatToStr(entityContribution));
          total := total + entityContribution;
        end;
      end;
    end;
  end;
  SRwriteln('total : ' + FloatToStr(total));
end;


// ----------------------------------------------------------------------------
//  Procedure StressOnSet (extra)
//  -----------------------

Procedure StressOnSet(var instance : TInstance; boolSwitch : Double);
begin
	SRwriteln('Valeur de boolSwitch : ' + FloatToStr(boolSwitch));
  if (boolSwitch = 1) then
  begin
    //(instance as TEntityInstance).GetTInstance('updateBoolSwitch').SetActiveState(100);
    (instance as TEntityInstance).GetTInstance('ReadETPDefault').SetActiveState(100);
    SRwriteln('ReadETPDefault --> active state = 100');
    (instance as TEntityInstance).GetTInstance('ReadETPFromFile').SetActiveState(1);
    SRwriteln('ReadETPFromFile --> active state = 1');
    //(instance as TEntityInstance).GetTInstance('ReadWaterSupply').SetActiveState(100);
    //SRwriteln('ReadWaterSupply --> active state = 100');
    (instance as TEntityInstance).GetTInstance('ReadWaterSupplyExternal').SetActiveState(1);
    SRwriteln('ReadWaterSupplyExternal --> active state = 1');
    //(instance as TEntityInstance).GetTInstance('stressOnSet').SetActiveState(100);
  end;
  if (boolSwitch = 0) then
  begin
    (instance as TEntityInstance).GetTInstance('updateBoolSwitch').SetActiveState(100);
    SRwriteln('updateBoolSwitch desactive');
    (instance as TEntityInstance).GetTInstance('ReadWaterSupplyExternal').SetActiveState(100);
    SRwriteln('ReadWaterSupplyExternal --> active state = 100');
    (instance as TEntityInstance).GetTInstance('stressOnSet').SetActiveState(100);
    SRwriteln('stressOnSet desactive');
    (instance as TEntityInstance).GetTInstance('dispBoolSwitch').SetActiveState(100);
    SRwriteln('dispBoolSwitch desactive');
    (instance as TEntityInstance).GetTInstance('updateNbDayOfSimulation').SetActiveState(100);
    SRwriteln('updateNbDayOfSimulation desactive');
  end;
end;

//----------------------------------------------------------------------------
// LISTE DES PROCEDURES DYNAMIQUES
//----------------------------------------------------------------------------

Procedure ComputeICDyn(Var T : TPointerProcParam);
Begin
  ComputeIC(T[0],T[1],T[2],T[3]);
end;

Procedure DiffDyn(Var T : TPointerProcParam);
Begin
  Diff(T[0],T[1],T[2]);
end;

Procedure DivideDyn(Var T : TPointerProcParam);
Begin
  Divide(T[0],T[1],T[2]);
end;

Procedure Add2ValuesDyn(Var T : TPointerProcParam);
Begin
  Add2Values(T[0],T[1],T[2]);
end;

Procedure Mult2ValuesDyn(Var T : TPointerProcParam);
Begin
  Mult2Values(T[0],T[1],T[2]);
end;

Procedure Min2ValuesDyn(Var T : TPointerProcParam);
Begin
  Min2Values(T[0],T[1],T[2]);
end;

Procedure Max2ValuesDyn(Var T : TPointerProcParam);
Begin
  Max2Values(T[0],T[1],T[2]);
end;

Procedure SqrtRealDyn(Var T : TPointerProcParam);
Begin
  SqrtReal(T[0],T[1]);
end;

Procedure IdentityDyn(var T : TPointerProcParam);
Begin
  Identity(T[0],T[1]);
end;

Procedure UpdatePlastoDelayDyn(var T : TPointerProcParam);
Begin
  UpdatePlastoDelay(T[0],T[1],T[2],T[3]);
End;

Procedure UpdateDegreeDayDyn(Var T : TPointerProcParam);
Begin
  UpdateDegreeDay(T[0],T[1],T[2],T[3],T[4],T[5]);
end;

Procedure UpdatePhenoStageDyn(Var T : TPointerProcParam);
Begin
  UpdatePhenoStage(T[0],T[1]);
end;

Procedure ComputeSLADyn(Var T : TPointerProcParam);
Begin
  ComputeSLA(T[0],T[1],T[2],T[3]);
end;

Procedure ComputeWDyn(Var T : TPointerProcParam);
Begin
  ComputeW(T[0],T[1],T[2],T[3]);
end;

Procedure ComputeLeafBladeAreaDyn(Var T : TPointerProcParam);
Begin
  ComputeLeafBladeArea(T[0],T[1],T[2],T[3]);
end;

Procedure ComputeLeafLengthDyn(Var T : TPointerProcParam);
Begin
  ComputeLeafLength(T[0],T[1],T[2],T[3],T[4]);
end;

Procedure ComputeOrganDemandDyn(Var T : TPointerProcParam);
Begin
  ComputeOrganDemand(T[0],T[1],T[2],T[3]);
end;

Procedure ComputeRestDyn(Var T : TPointerProcParam);
Begin
  ComputeRest(T[0],T[1],T[2]);
end;

Procedure ReallocateBiomassDyn(Var T : TPointerProcParam);
Begin
  ReallocateBiomass(T[0],T[1],T[2]);
end;

Procedure UpdateAddDyn(Var T : TPointerProcParam);
Begin
  UpdateAdd(T[0],T[1]);
end;

Procedure UpdateLinearDyn(Var T : TPointerProcParam);
Begin
  UpdateLinear(T[0],T[1],T[2]);
end;

Procedure UpdateOrganBiomassDyn(Var T : TPointerProcParam);
Begin
  UpdateOrganBiomass(T[0],T[1]);
end;

Procedure UpdateSupplyDyn(Var T : TPointerProcParam);
Begin
  UpdateSupply(T[0],T[1],T[2],T[3]);
end;

Procedure ComputeLAIDyn(Var T : TPointerProcParam);
Begin
  ComputeLAI(T[0],T[1],T[2]);
end;

Procedure ComputeRolledLAIDyn(Var T : TPointerProcParam);
Begin
  ComputeRolledLAI(T[0],T[1],T[2],T[3],T[4],T[5]);
end;

Procedure ComputeRadiationInterceptionDyn(Var T : TPointerProcParam);
Begin
  ComputeRadiationInterception(T[0],T[1],T[2]);
end;

Procedure ComputePotentialAssimilationDyn(Var T : TPointerProcParam);
Begin
	ComputePotentialAssimilation(T[0],T[1],T[2],T[3],T[4],T[5],T[6],T[7]);
end;

Procedure ComputePotentialAssimilationCstrDyn(Var T : TPointerProcParam);
Begin
	ComputePotentialAssimilationCstr(T[0],T[1],T[2],T[3],T[4],T[5],T[6]);
end;

Procedure ComputeRespirationMaintenanceDyn(Var T : TPointerProcParam);
Begin
  ComputeRespirationMaintenance(T[0],T[1],T[2],T[3],T[4],T[5],T[6]);
end;

Procedure ComputeAssimilationNetDyn(Var T : TPointerProcParam);
Begin
  ComputeAssimilationNet(T[0],T[1],T[2],T[3]);
end;

Procedure ComputeLeafPredimensionnementDyn(Var T : TPointerProcParam);
Begin
  ComputeLeafPredimensionnement(T[0],T[1],T[2],T[3],T[4],T[5]);
end;

Procedure UpdateNbTillerCountDyn(Var T : TPointerProcParam);
Begin
  UpdateNbTillerCount(T[0],T[1],T[2]);
end;

Procedure ThresholdDyn(Var T : TPointerProcParam);
Begin
  Threshold(T[0],T[1],T[2]);
end;

Procedure LinearDyn(Var T : TPointerProcParam);
Begin
  Linear(T[0],T[1],T[2],T[3]);
end;

Procedure SumOfDemandRecDyn(var instance : TInstance; Var T : TPointerProcParam);
Begin
  SumOfDemandRec(instance,T[0]);
end;

Procedure SumOfBladeAreaInLeafRecDyn(var instance : TInstance; Var T : TPointerProcParam);
Begin
  SumOfBladeAreaInLeafRec(instance,T[0]);
end;

Procedure SumOfBiomassInLeafRecDyn(var instance : TInstance; Var T : TPointerProcParam);
Begin
  SumOfBiomassInLeafRec(instance,T[0]);
end;

Procedure SumOfDemandInLeafRecDyn(var instance : TInstance; Var T : TPointerProcParam);
Begin
  SumOfDemandInLeafRec(instance,T[0]);
end;

Procedure SumOfBiomassRecDyn(var instance : TInstance; Var T : TPointerProcParam);
Begin
  SumOfBiomassRec(instance,T[0]);
end;

Procedure EnableNbTillerCountDyn(var instance : TInstance; Var T : TPointerProcParam);
Begin
  EnableNbTillerCount(instance,T[0]);
end;

Procedure CountOfNbTillerWithMore4LeavesDyn(var instance : TInstance; Var T : TPointerProcParam);
Begin
  CountOfNbTillerWithMore4Leaves(instance,T[0]);
end;

Procedure KillOldestLeafDyn(var instance : TInstance; Var T : TPointerProcParam);
Begin
  KillOldestLeaf(instance,T[0]);
end;

Procedure SumOfBiomassInInternodeRecDyn(var instance : TInstance; Var T : TPointerProcParam);
Begin
  SumOfBiomassInInternodeRec(instance,T[0]);
end;

Procedure SumOfBiomassInRootRecDyn(var instance : TInstance; Var T : TPointerProcParam);
Begin
  SumOfBiomassInRootRec(instance,T[0]);
end;

procedure SumOfBiomassOnMainstemInInternodeRecDyn(var instance : TInstance; Var T : TPointerProcParam);
begin
  SumOfBiomassOnMainstemInInternodeRec(instance, T[0]);
end;


procedure SumOfBiomassOnMainstemInLeafRecDyn(var instance : TInstance; Var T : TPointerProcParam);
begin
  SumOfBiomassOnMainstemInLeafRec(instance, T[0]);
end;

procedure SumOfDemandInOrganOnMainstemRecDyn(var instance : TInstance; Var T : TPointerProcParam);
begin
  SumOfDemandInOrganOnMainstemRec(instance, T[0]);
end;

procedure SumOfDemandInOrganOnTillerRecDyn(var instance : TInstance; Var T : TPointerProcParam);
begin
  SumOfDemandInOrganOnTillerRec(instance, T[0]);
end;

procedure SumOfBladeAreaOnMainstemInLeafRecDyn(var instance : TInstance; Var T : TPointerProcParam);
begin
  SumOfBladeAreaOnMainstemInLeafRec(instance, T[0]);
end;

procedure SumOfBladeAreaOnTillerInLeafRecDyn(var instance : TInstance; Var T : TPointerProcParam);
begin
  SumOfBladeAreaOnTillerInLeafRec(instance, T[0]);
end;

procedure SumReservoirDispoInInternodeOnMainstemRecDyn(var instance : TInstance; Var T : TPointerProcParam);
begin
  SumReservoirDispoInInternodeOnMainstemRec(instance, T[0]);
end;

procedure SumReservoirDispoInInternodeOnTillerRecDyn(var instance : TInstance; Var T : TPointerProcParam);
begin
  SumReservoirDispoInInternodeOnTillerRec(instance, T[0]);
end;

procedure SumOfBiomassOnTillerInLeafRecDyn(var instance : TInstance; Var T : TPointerProcParam);
begin
  SumOfBiomassOnTillerInLeafRec(instance, T[0]);
end;

procedure SumOfBiomassOnTillersInInternodeRecDyn(var instance : TInstance; Var T : TPointerProcParam);
begin
  SumOfBiomassOnTillersInInternodeRec(instance, T[0]);
end;

procedure StressOnSetDyn(var instance : TInstance; Var T : TPointerProcParam);
begin
  StressOnSet(instance, T[0]);
end;

procedure SumOfBiomassOnCulmInInternodeRecDyn(var instance : TInstance; Var T : TPointerProcParam);
begin
  SumOfBiomassOnCulmInInternodeRec(instance, T[0]);
end;

procedure SumOfStockOnCulmInInternodeRecDyn(var instance : TInstance; Var T : TPointerProcParam);
begin
  SumOfStockOnCulmInInternodeRec(instance, T[0]);
end;

procedure SumOfLengthOnCulmInInternodeRecDyn(var instance : TInstance; Var T : TPointerProcParam);
begin
  SumOfLengthOnCulmInInternodeRec(instance, T[0]);
end;

procedure SumOfDemandOnCulmInInternodeDyn(var instance : TInstance; Var T : TPointerProcParam);
begin
  SumOfDemandOnCulmInInternode(instance, T[0]);
end;

procedure SumOfStockOnCulmInInternodeDyn(var instance : TInstance; Var T : TPointerProcParam);
begin
  SumOfStockOnCulmInInternode(instance, T[0]);
end;

procedure SumOfDemandOnCulmInNonInternodeDyn(var instance : TInstance; Var T : TPointerProcParam);
begin
  SumOfDemandOnCulmInNonInternode(instance, T[0]);
end;

procedure SumOfDeficitOnCulmInInternodeDyn(var instance : TInstance; Var T : TPointerProcParam);
begin
  SumOfDeficitOnCulmInInternode(instance, T[0]);
end;

procedure SumOfDemandOnTillersDyn(var instance : TInstance; Var T : TPointerProcParam);
begin
  SumOfDemandOnTillers(instance, T[0]);
end;

procedure SumOfLastDemandOnTillersDyn(var instance : TInstance; Var T : TPointerProcParam);
begin
  SumOfLastDemandOnTillers(instance, T[0]);
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

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeICDyn,['supply','kIn','dayDemand','kIn','Ic','kOut','testIc','kOut']);
PROC_DECLARATION.SetProcName('ComputeIC');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',DiffDyn,['inValue1','kIn','inValue2','kIn','outValue','kOut']);
PROC_DECLARATION.SetProcName('Diff');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',DivideDyn,['inValue1','kIn','inValue2','kIn','outValue','kOut']);
PROC_DECLARATION.SetProcName('Divide');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',Add2ValuesDyn,['inValue1','kIn','inValue2','kIn','outValue','kOut']);
PROC_DECLARATION.SetProcName('Add2Values');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',Mult2ValuesDyn,['inValue1','kIn','inValue2','kIn','outValue','kOut']);
PROC_DECLARATION.SetProcName('Mult2Values');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',Min2ValuesDyn,['inValue1','kIn','inValue2','kIn','outValue','kOut']);
PROC_DECLARATION.SetProcName('Min2Values');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',Max2ValuesDyn,['inValue1','kIn','inValue2','kIn','outValue','kOut']);
PROC_DECLARATION.SetProcName('Max2Values');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',SqrtRealDyn,['inValue','kIn','outValue','kOut']);
PROC_DECLARATION.SetProcName('SqrtReal');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',IdentityDyn,['inValue','kIn','outValue','kOut']);
PROC_DECLARATION.SetProcName('Identity');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',UpdatePlastoDelayDyn,['LER','kIn','deltaT','kIn','exp_time','kIn','plasto_delay','kOut']);
PROC_DECLARATION.SetProcName('UpdatePlastoDelay');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',UpdateDegreeDayDyn,['deltaT','kIn','plasto','kIn','plasto_delay','kIn','DD','kInOut','EDD','kOut','boolCrossedPlasto','kOut']);
PROC_DECLARATION.SetProcName('UpdateDegreeDay');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',UpdatePhenoStageDyn,['boolCrossedPlasto','kIn','phenoStage','kInOut']);
PROC_DECLARATION.SetProcName('UpdatePhenoStage');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeSLADyn,['FSLA','kIn','SLAp','kIn','phenoStage','kIn','SLA','kOut']);
PROC_DECLARATION.SetProcName('ComputeSLA');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeWDyn,['phenoStage','kIn','w1','kIn','w2','kIn','W','kOut']);
PROC_DECLARATION.SetProcName('ComputeW');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeLeafBladeAreaDyn,['biomass','kIn','G_L','kIn','SLA','kIn','bladeArea','kOut']);
PROC_DECLARATION.SetProcName('ComputeLeafBladeArea');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeLeafLengthDyn,['bladeArea','kIn','W','kIn','surfaceCoeff','kIn','ratio','kIn','le','kOut']);
PROC_DECLARATION.SetProcName('ComputeLeafLength');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeOrganDemandDyn,['predim','kIn','DD','kIn','plasto','kIn','demand','kOut']);
PROC_DECLARATION.SetProcName('ComputeOrganDemand');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeRestDyn,['previousSupply','kIn','previousDayDemand','kIn','rest','kOut']);
PROC_DECLARATION.SetProcName('ComputeRest');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ReallocateBiomassDyn,['biomass','kIn','reallocationRate','kIn','stock','kOut']);
PROC_DECLARATION.SetProcName('ReallocateBiomass');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',UpdateAddDyn,['quantity','kIn','attributeValue','kInOut']);
PROC_DECLARATION.SetProcName('UpdateAdd');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',UpdateLinearDyn,['quantity','kIn','coeff','kIn','attributeValue','kInOut']);
PROC_DECLARATION.SetProcName('UpdateLinear');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',UpdateOrganBiomassDyn,['demand','kIn','biomass','kInOut']);
PROC_DECLARATION.SetProcName('UpdateOrganBiomass');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',UpdateSupplyDyn,['previousAssim','kIn','previousDayDemand','kIn','rest','kIn','supply','kInOut']);
PROC_DECLARATION.SetProcName('UpdateSupply');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeLAIDyn,['PAI','kIn','density','kIn','LAI','kOut']);
PROC_DECLARATION.SetProcName('ComputeLAI');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeRolledLAIDyn,['PAI','kIn','density','kIn','fcstr','kIn','rollingA','kIn','rollingB','kIn','LAI','kOut']);
PROC_DECLARATION.SetProcName('ComputeRolledLAI');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeRadiationInterceptionDyn,['Kdf','kIn','LAI','kIn','radiationInterception','kOut']);
PROC_DECLARATION.SetProcName('ComputeRadiationInterception');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputePotentialAssimilationDyn,['Assim_A','kIn','Assim_B','kIn','fcstr','kIn','radiationInterception','kIn','Epsib','kIn','radiation','kIn','Kpar','kIn','potentialAssimilation','kOut']);
PROC_DECLARATION.SetProcName('ComputePotentialAssimilation');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputePotentialAssimilationCstrDyn,['power_for_cstr','kIn','cstr','kIn','radiationInterception','kIn','Epsib','kIn','radiation','kIn','Kpar','kIn','potentialAssimilation','kOut']);
PROC_DECLARATION.SetProcName('ComputePotentialAssimilationCstr');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeRespirationMaintenanceDyn,['Kresp','kIn','Kresp_internode','kIn','biomassLeaf','kIn','biomassInternode','kIn','airTemperature','kIn','Tresp','kIn','respirationMaintenance','kOut']);
PROC_DECLARATION.SetProcName('ComputeRespirationMaintenance');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeAssimilationNetDyn,['potentialAssimilation','kIn','respirationMaintenance','kIn','density','kIn','assimilationNet','kOut']);
PROC_DECLARATION.SetProcName('ComputeAssimilationNet');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeLeafPredimensionnementDyn,['boolFirstLeaf','kIn','predimOfPreviousLeaf','kIn','predimLeafOnMainstem','kIn','MGR','kIn','testIc','kIn','predimOfCurrentLeaf','kOut']);
PROC_DECLARATION.SetProcName('ComputeLeafPredimensionnement');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',UpdateNbTillerCountDyn,['Ic','kIn','IcThreshold','kIn','nbTiller','kInOut']);
PROC_DECLARATION.SetProcName('UpdateNbTillerCount');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ThresholdDyn,['inValue','kIn','thresholdValue','kIn','outValue','kOut']);
PROC_DECLARATION.SetProcName('Threshold');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',LinearDyn,['coeff','kIn','offset','kIn','inValue','kIn','outValue','kOut']);
PROC_DECLARATION.SetProcName('Linear');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SumOfDemandRecDyn,['total','kOut']);
PROC_DECLARATION.SetProcName('SumOfDemandRec');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SumReservoirDispoInInternodeOnMainstemRecDyn,['total','kOut']);
PROC_DECLARATION.SetProcName('SumReservoirDispoInInternodeOnMainstemRec');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SumReservoirDispoInInternodeOnTillerRecDyn,['total','kOut']);
PROC_DECLARATION.SetProcName('SumReservoirDispoInInternodeOnTillerRec');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SumOfBladeAreaInLeafRecDyn,['total','kOut']);
PROC_DECLARATION.SetProcName('SumOfBladeAreaInLeafRec');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SumOfDemandInOrganOnMainstemRecDyn,['total','kOut']);
PROC_DECLARATION.SetProcName('SumOfDemandInOrganOnMainstemRec');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SumOfDemandInOrganOnTillerRecDyn,['total','kOut']);
PROC_DECLARATION.SetProcName('SumOfDemandInOrganOnTillerRec');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SumOfBiomassInLeafRecDyn,['total','kOut']);
PROC_DECLARATION.SetProcName('SumOfBiomassInLeafRec');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SumOfBiomassOnMainstemInInternodeRecDyn,['total','kOut']);
PROC_DECLARATION.SetProcName('SumOfBiomassOnMainstemInInternodeRec');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SumOfBiomassOnTillersInInternodeRecDyn,['total','kOut']);
PROC_DECLARATION.SetProcName('SumOfBiomassOnTillersInInternodeRec');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SumOfBiomassOnMainstemInLeafRecDyn,['total','kOut']);
PROC_DECLARATION.SetProcName('SumOfBiomassOnMainstemInLeafRec');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SumOfBladeAreaOnMainstemInLeafRecDyn,['total','kOut']);
PROC_DECLARATION.SetProcName('SumOfBladeAreaOnMainstemInLeafRec');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SumOfBladeAreaOnTillerInLeafRecDyn,['total','kOut']);
PROC_DECLARATION.SetProcName('SumOfBladeAreaOnTillerInLeafRec');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SumOfBiomassOnTillerInLeafRecDyn,['total','kOut']);
PROC_DECLARATION.SetProcName('SumOfBiomassOnTillerInLeafRec');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SumOfDemandInLeafRecDyn,['total','kOut']);
PROC_DECLARATION.SetProcName('SumOfDemandInLeafRec');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SumOfBiomassRecDyn,['total','kOut']);
PROC_DECLARATION.SetProcName('SumOfBiomassRec');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',EnableNbTillerCountDyn,['plasto','kIn']);
PROC_DECLARATION.SetProcName('EnableNbTillerCount');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',CountOfNbTillerWithMore4LeavesDyn,['NbTillerWithMore4Leaves','kOut']);
PROC_DECLARATION.SetProcName('CountOfNbTillerWithMore4Leaves');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',KillOldestLeafDyn,['stock','kInOut']);
PROC_DECLARATION.SetProcName('KillOldestLeaf');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SumOfBiomassInInternodeRecDyn,['total','kOut']);
PROC_DECLARATION.SetProcName('SumOfBiomassInInternodeRec');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SumOfBiomassInRootRecDyn,['total','kOut']);
PROC_DECLARATION.SetProcName('SumOfBiomassInRootRec');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',StressOnSetDyn,['boolSwitch','kIn']);
PROC_DECLARATION.SetProcName('StressOnSet');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SumOfBiomassOnCulmInInternodeRecDyn,['total','kOut']);
PROC_DECLARATION.SetProcName('SumOfBiomassOnCulmInInternodeRec');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SumOfStockOnCulmInInternodeRecDyn,['total','kOut']);
PROC_DECLARATION.SetProcName('SumOfStockOnCulmInInternodeRec');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SumOfLengthOnCulmInInternodeRecDyn,['total','kOut']);
PROC_DECLARATION.SetProcName('SumOfLengthOnCulmInInternodeRec');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SumOfDemandOnCulmInInternodeDyn,['total','kOut']);
PROC_DECLARATION.SetProcName('SumOfDemandOnCulmInInternode');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SumOfStockOnCulmInInternodeDyn,['total','kOut']);
PROC_DECLARATION.SetProcName('SumOfStockOnCulmInInternode');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SumOfDemandOnCulmInNonInternodeDyn,['total','kOut']);
PROC_DECLARATION.SetProcName('SumOfDemandOnCulmInNonInternode');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SumOfDeficitOnCulmInInternodeDyn,['total','kOut']);
PROC_DECLARATION.SetProcName('SumOfDeficitOnCulmInInternode');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SumOfDemandOnTillersDyn,['total','kOut']);
PROC_DECLARATION.SetProcName('SumOfDemandOnTillers');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SumOfLastDemandOnTillersDyn,['total','kOut']);
PROC_DECLARATION.SetProcName('SumOfLastDemandOnTillers');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

end.
