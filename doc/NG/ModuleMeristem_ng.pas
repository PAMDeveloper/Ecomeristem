unit ModuleMeristem_ng;

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
  UsefullFunctionsForMeristemModel,
  Dialogs,
  Classes,
  Windows,
  ShellAPI,
  DefinitionConstant,
  GlobalVariable;

// Liste des modules classiques
procedure ComputeLeafExpTime_ng(const predim, len, LER : double ; var exp_time : double);
procedure ComputeMaxReservoirLeafCulm_ng(const leafStockMax, sumOfLeafBiomass : Double; var maxReservoirDispoLeaf : Double);
procedure ComputeMaxReservoirInternodeCulm_ng(const maximumReserveInInternode, sumOfInternodeBiomass : Double; var maxReservoidDispoInternode : Double);
procedure ComputeLER_ng(const FTSW, ThresLER, SlopeLER, P, resp_LER, testIc : Double; var reductionLER : Double);
procedure ComputeReductionINER_ng(const FTSW, ThresINER, slopeINER, P, resp_INER, testIc : Double; var reductionINER : Double);



procedure ComputeLeafExpTime_ngDyn(var T : TPointerProcParam);
procedure ComputeMaxReservoirLeafCulm_ngDyn(var T : TPointerProcParam);
procedure ComputeMaxReservoirInternodeCulm_ngDyn(var T : TPointerProcParam);
procedure ComputeLER_ngDyn(var T : TPointerProcParam);
procedure ComputeReductionINER_ngDyn(var T : TPointerProcParam);


// Liste des modules 'extra'
procedure KillSenescLeaves_ng(var instance : TInstance; var deadLeafNb : Double);
procedure ComputePHT_ng(var instance : TInstance; const G_L, LL_BL, stockPlant, stockInternodePlant, structLeaf : double ;var PHT, SLALFEL, AreaLFEL, DWLFEL : double);
procedure ComputeLeafPredimensionnement_ng(var instance : TInstance; const isFirstLeaf, isOnMainstem, Lef1, MGR, testIc, fcstr : Double; var predimOfCurrentLeaf : Double);
procedure CountNbTiller_ng(var instance : TInstance; var total : Double);
procedure CountOfNbTillerWithMoreNbLeafEnablingTilleringLeaves_ng(var instance : TInstance; const nbLeafEnablingTillering : Double; var nbTillerWithMore4Leaves : Double);
procedure CreateTillersPhytomer_ng(var instance : TInstance; const boolCrossedPlasto,Ic,Ict,exeOrder,P,resp_Ict, thresINER, slopeINER, leafStockMax, phenoStageAtCreation, maximumReserveInternode : double; var nbTiller : double);
procedure KillYoungestTillerOldestLeaf_ng(var instance : TInstance ; const reallocationCoeff, nbLeafEnablingTillering : Double; var deficit, stock, senesc_dw, deadleafNb, deadtillerNb, computedReallocBiomass : Double);
procedure ComputeLeafInternodeBiomassCulms_ng(var instance : TInstance);
procedure ComputeSumOfInternodeBiomassOnCulm_ng(var instance : TInstance; var total : Double);
procedure SumOfDailyComputedReallocBiomass_ng(var instance : TInstance; var total : Double);
procedure SumOfDailySenescedLeafBiomass_ng(var instance : TInstance; var total : Double);
procedure ComputeMaxReservoirCulms_ng(var instance : TInstance);
procedure ComputeBiomassInternodeStruct_ng(var instance : TInstance; var biomInternodeStruct : Double);
procedure ComputeLengthPeduncles_ng(var instance : TInstance);
procedure SetUpTillerStockPre_Elong_ng(var instance : TInstance);
procedure ComputeLastDemandCulms_ng(var instance : TInstance; var lastDemand : Double);
procedure ComputeTmpCulms_ng(var instance : TInstance);
procedure ComputeDeficitCulms_ng(var instance : TInstance);
procedure ComputeSurplusCulms_ng(var instance : TInstance);
procedure ComputeStockCulms_ng(var instance : TInstance);
procedure ComputeSurplusPlant_ng(var instance : TInstance);
procedure ComputeSupplyPlant_ng(var instance : TInstance);
procedure ComputeStockPlant_ng(var instance : TInstance);
procedure ComputeDeficitPlant_ng(var instance : TInstance);
procedure ComputeTestIcCulm_ng(var instance : TInstance; var testIc : Double);
procedure ComputeGetFcstr_ng(var instance : TInstance; var fcstr : Double);
procedure ComputeBalanceSheet_ng(var instance : TInstance);
procedure ComputeStockInternodeOnCulm_ng(var instance : TInstance);
procedure KillOldestLeafMorphoGenesis_ng(var instance : TInstance ; const realocationCoeff : Double; var deficit, stock, senesc_dw, deadleafNb, computedReallocBiomass : Double);
procedure KillOldestLeafTiller_ng(var instance : TInstance ; var deficit, stock, activeLeafNb, leafNb : Double);
procedure SumOfDailyComputedReallocBiomassOnCulm_ng(var instance : TInstance; var sumOfDailyComputedReallocBiomass : Double);
procedure SumOfDailySenescedLeafBiomassOnCulm_ng(var instance : TInstance; var sumOfDailySenescedLeafBiomass : Double);
procedure KillTillerWithoutLigulatedLeaf_ng(var instance : TInstance; var nbTiller : Double);
procedure ComputeDayDemand_ng(var instance : TInstance; var dayDemand : Double);
procedure LeafTransitionToActive_ng(var instance : TInstance);
procedure InternodeTransitionToActive_ng(var instance : TInstance);
procedure SaveTableData_ng(var instance : TInstance);
procedure TransitionToLiguleState_ng(var instance : TInstance; const len, predim, isOnMainstem : double; var demand, lastDemand : Double);
procedure ComputeBiomInternodeMainstem_ng(var instance : TInstance; var biomInternodeMainstem : Double);
procedure ComputeBiomLeafMainstem_ng(var instance : TInstance; var biomLeafMainstem : Double);
procedure ComputeBiomStem_ng(var instance : TInstance; var biomStem : Double);
procedure ComputeStockInternodePlante_ng(var instance : TInstance; var stockInternodePlant : Double);
procedure ComputeWeightPanicle_ng(var instance : TInstance; var panicleDW, panicleMainstemDW : Double);
procedure ComputePanicleNumber_ng(var instance : TInstance; var panicleNumber : Double);
procedure ComputeFirstLastExpandedInternodeDiameterMainstem_ng(var instance : TInstance; var firstDiameter, lastDiameter, lastLength, lastRank : Double);
procedure ComputeNbActiveInternodesOnMainstem_ng(var instance : TInstance; var nbActiveInternodesOnMainstem : Double);
procedure ComputeInternodeLengthOnMainstem_ng(var instance : TInstance; var internodeLengthOnMainstem : Double);
procedure ComputeLeafNumberOnMainstem_ng(var instance : TInstance; var leafNumberOnMainstem : Double);
procedure ComputeInternodeBiomass_ng(var instance : TInstance; const Volume, density : Double; var Biomass : Double);
procedure ComputeNbLeafMainstem_ng(var instance : TInstance; var NbLeafMainstem : Double);
procedure ComputeNbLeafMainstem50_ng(var instance : TInstance; var NbLeafMainstem : Double);
procedure ComputeBiomLeafMainstemGreen_ng(var instance : TInstance; var biomLeafMainstem : Double);
procedure ComputeTotalSenescedLeafBiomass_ng(var instance : TInstance; var totalSenescedLeafBiomas : Double);
procedure SaveSupplyCulm_ng(var instance : TInstance; const nbDayOfSimulation : Double);
procedure ComputeBalanceSheetAssimByAxisFromR_ng(var instance : TInstance);
procedure DataForR_ng(var instance : TInstance);
procedure ReadAssimByAxisFromR_ng(var instance : TInstance);









procedure KillSenescLeaves_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputePHT_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeLeafPredimensionnement_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure CountNbTiller_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure CountOfNbTillerWithMoreNbLeafEnablingTilleringLeaves_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure CreateTillersPhytomer_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure KillYoungestTillerOldestLeaf_ngDyn(var instance : TInstance ; var T : TPointerProcParam);
procedure ComputeLeafInternodeBiomassCulms_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeSumOfInternodeBiomassOnCulm_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure SumOfDailyComputedReallocBiomass_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure SumOfDailySenescedLeafBiomass_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeMaxReservoirCulms_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeBiomassInternodeStruct_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeLengthPeduncles_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure SetUpTillerStockPre_Elong_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeLastDemandCulms_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeTmpCulms_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeDeficitCulms_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeSurplusCulms_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeStockCulms_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeSurplusPlant_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeSupplyPlant_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeStockPlant_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeDeficitPlant_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeTestIcCulm_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeGetFcstr_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeBalanceSheet_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeStockInternodeOnCulm_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure KillOldestLeafMorphoGenesis_ngDyn(var instance : TInstance ; var T : TPointerProcParam);
procedure KillOldestLeafTiller_ngDyn(var instance : TInstance ; var T : TPointerProcParam);
procedure SumOfDailyComputedReallocBiomassOnCulm_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure SumOfDailySenescedLeafBiomassOnCulm_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure KillTillerWithoutLigulatedLeaf_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeDayDemand_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure LeafTransitionToActive_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure InternodeTransitionToActive_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure SaveTableData_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure TransitionToLiguleState_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeBiomInternodeMainstem_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeBiomLeafMainstem_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeBiomStem_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeStockInternodePlante_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeWeightPanicle_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputePanicleNumber_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeFirstLastExpandedInternodeDiameterMainstem_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeNbActiveInternodesOnMainstem_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeInternodeLengthOnMainstem_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeLeafNumberOnMainstem_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeInternodeBiomass_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeNbLeafMainstem_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeNbLeafMainstem50_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeBiomLeafMainstemGreen_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeTotalSenescedLeafBiomass_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure SaveSupplyCulm_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ComputeBalanceSheetAssimByAxisFromR_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure DataForR_ngDyn(var instance : TInstance; var T : TPointerProcParam);
procedure ReadAssimByAxisFromR_ngDyn(var instance : TInstance; var T : TPointerProcParam);









implementation

uses
  EntityTillerPhytomer_ng;

procedure KillSenescLeaves_ng(var instance : TInstance; var deadLeafNb : Double);
var
  i1, i2, le1, le2, state, counter : Integer;
  currentInstance1, currentInstance2 : TInstance;
  category1, category2, name : String;

begin
  counter := 0;
  le1 := (instance as TEntityInstance).LengthTInstanceList;
  for i1 := 0 to le1 - 1 do
  begin
    currentInstance1 := (instance as TEntityInstance).GetTInstance(i1);
    if (currentInstance1 is TEntityInstance) then
    begin
      category1 := (currentInstance1 as TEntityInstance).GetCategory();
      if (category1 = 'Tiller') then
      begin
        name := currentInstance1.GetName();
        SRwriteln('Tiller name --> ' + name);
        le2 := (currentInstance1 as TEntityInstance).LengthTInstanceList();
        for i2 := 0 to le2 - 1 do
        begin
          currentInstance2 := (currentInstance1 as TEntityInstance).GetTInstance(i2);
          if (currentInstance2 is TEntityInstance) then
          begin
            category2 := (currentInstance2 as TEntityInstance).GetCategory();
            if (category2 = 'Leaf') then
            begin
              state := (currentInstance2 as TEntityInstance).GetCurrentState();
              SRwriteln('Leaf state --> ' + IntToStr(state));
              if ((state <> 500) and (state <> 2000) and (name = 'T_0')) then
              begin
                counter := counter + 1;
              end
              else if (state = 500) then
              begin
                deadLeafNb := deadLeafNb + 1;
                SRwriteln('La feuille' + currentInstance2.GetName() + ' supprimee par senescence');
                (currentInstance1 as TEntityInstance).RemoveTInstance(currentInstance2);
              end;
            end;
          end;
        end;
      end;
    end;
  end;
  if (counter = 0) then
  begin
    (instance as TEntityInstance).GetTInstance('computeSLAplantAlive').SetActiveState(-1);
    (instance as TEntityInstance).GetTInstance('computeSLArealAlive').SetActiveState(-1);
  end;
end;

procedure ComputePHT_ng(var instance : TInstance; const G_L, LL_BL, stockPlant, stockInternodePlant, structLeaf : double; var PHT, SLALFEL, AreaLFEL, DWLFEL : double);
var
   i, i1, i2, le, le1, le2, nbLeaf: Integer;
   currentInstance1, currentInstance2 : TInstance;
   category1, category2, name : String;
   state, stateLeaf : Integer;
   youngestCreationDate, currentCreationDate : TDateTime;
   youngestLigulatedLeaf : TInstance;
   date : TDateTime;
   leafLength, sumOfInternodeLength, internodeLength, peduncleLength : Double;
   tmp : Double;
   len, predim : Double;
begin
  // initialisation
  // ---------------
  nbLeaf := 0;
  leafLength := 0;
  youngestLigulatedLeaf := NIL;
  sumOfInternodeLength := 0;
  peduncleLength := 0;

  state := (instance as TEntityInstance).GetCurrentState();
  if (state <> 1000) then
  begin
    le1 := (instance as TEntityInstance).LengthTInstanceList();
    for i1 := 0 to le1 - 1 do
    begin
      currentInstance1 := (instance as TEntityInstance).GetTInstance(i1);
      if (currentInstance1 is TEntityInstance) then
      begin
        name := currentInstance1.GetName();
        category1 := (currentInstance1 as TEntityInstance).GetCategory();
        if ((category1 = 'Tiller') and (name = 'T_0')) then
        begin
          le2 := (currentInstance1 as TEntityInstance).LengthTInstanceList();
          for i2 := 0 to le2 - 1 do
          begin
            currentInstance2 := (currentInstance1 as TEntityInstance).GetTInstance(i2);
            if (currentInstance2 is TEntityInstance) then
            begin
              category2 := (currentInstance2 as TEntityInstance).GetCategory();
              if (category2 = 'Leaf') then
              begin
                nbLeaf := nbLeaf + 1;
                if (nbLeaf = 1) then
                begin
                  youngestLigulatedLeaf := currentInstance2;
                end;
                stateLeaf := (currentInstance2 as TEntityInstance).GetCurrentState();
                len := (currentInstance2 as TEntityInstance).GetTAttribute('len').GetCurrentSample().value;
                predim := (currentInstance2 as TEntityInstance).GetTAttribute('predim').GetCurrentSample().value;
                if ((len = predim) and ((stateLeaf = 4) or (stateLeaf = 5))) then
                begin
                  youngestLigulatedLeaf := currentInstance2;
                end;
              end;
              if (category2 = 'Internode') then
              begin
                if ((currentInstance2 as TEntityInstance).GetCurrentState() <> 2000) then
                begin
                  internodeLength := (currentInstance2 as TEntityInstance).GetTAttribute('LIN').GetCurrentSample().value;
                  sumOfInternodeLength := sumOfInternodeLength + internodeLength;
                end;
              end;
              if (category2 = 'Peduncle') then
              begin
                peduncleLength := (currentInstance2 as TEntityInstance).GetTAttribute('LIN').GetCurrentSample().value;
              end;
            end;
          end;
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
      SLALFEL := AreaLFEL / (DWLFEL * G_L * (1 + (stockPlant - stockInternodePlant) / structLeaf));
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
          //PHT := peduncleLength + sumOfInternodeLength;
           PHT := tmp + sumOfInternodeLength;
        end;
      end;
    end;
    SRwriteln('PHT                        --> ' + FloatToStr(PHT));
  end;
end;


function FindLeafPredim(var instance : TInstance; const rank : Double; const isOnMainstem : Boolean = False) : Double;
var
  i, le : Integer;
  currentInstance : TInstance;
  predim, localRank : Double;
  refFather : TInstance;
begin
  SRwriteln('rank recherche : ' + FloatToStr(rank));
  if (isOnMainstem) then
  begin
    refFather := instance;
  end
  else
  begin
    refFather := instance.GetFather();
  end;
  SRwriteln('refFather : ' + refFather.GetName());
  predim := 0;
  le := (refFather as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (refFather as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      if ((currentInstance as TEntityInstance).GetCategory() = 'Leaf') then
      begin
        localRank := (currentInstance as TEntityInstance).GetTAttribute('rank').GetCurrentSample().value;
        if (localRank = rank) then
        begin
          predim := (currentInstance as TEntityInstance).GetTAttribute('predim').GetCurrentSample().value;
        end;
      end;
    end;
  end;
  Result := predim;
end;

function FindMainstem(var instance : TInstance): TInstance;
var
  refFather : TInstance;
  refMainstem : TInstance;
  currentInstance : TInstance;
  i, le : Integer;
  isMainstem : Double;
begin
  refMainstem := nil;
  refFather := instance.GetFather();
  while (refFather.GetName() <> 'EntityMeristem') do
  begin
    refFather := refFather.GetFather();
  end;
  le := (refFather as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (refFather as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      if ((currentInstance as TEntityInstance).GetCategory() = 'Tiller') then
      begin
        isMainstem := (currentInstance as TEntityInstance).GetTAttribute('isMainstem').GetCurrentSample().value;
        if (isMainstem = 1) then
        begin
          refMainstem := currentInstance;
        end;
      end;
    end;
  end;
  Result := refMainstem;
end;

procedure ComputeLeafPredimensionnement_ng(var instance : TInstance; const isFirstLeaf, isOnMainstem, Lef1, MGR, testIc, fcstr : Double; var predimOfCurrentLeaf : Double);
var
  rank, phenoStage : Double;
  predimPreviousLeafTiller, predimPreviousLeafMainstem : Double;
  refMainstem : TInstance;
begin
  rank := (instance as TEntityInstance).GetTAttribute('rank').GetCurrentSample().value;
  phenoStage := (instance as TEntityInstance).GetTAttribute('phenoStage').GetCurrentSample().value;
  SRwriteln('MGR                        --> ' + FloatToStr(MGR));
  SRwriteln('Lef1                       --> ' + FloatToStr(Lef1));
  SRwriteln('testIc                     --> ' + FloatToStr(testIc));
  SRwriteln('fcstr                      --> ' + FloatToStr(fcstr));
  SRwriteln('rank                       --> ' + FloatToStr(rank));
  SRwriteln('phenoStage                 --> ' + FloatToStr(phenoStage));
  SRwriteln('isFirstLeaf                --> ' + FloatToStr(isFirstLeaf));
  SRwriteln('isOnMainstem               --> ' + FloatToStr(isOnMainstem));
  // Cas : premiere feuille sur le brin maitre
  if ((isFirstLeaf = 1) and (isOnMainstem = 1)) then
  begin
    predimOfCurrentLeaf := Lef1;
    SRwriteln('Cas                        -->  premiere feuille sur le brin maitre');
    SRwriteln('predimOfCurrentLeaf        --> ' + FloatToStr(predimOfCurrentLeaf));
  end

  // Cas : pas la premiere feuille sur le brin maitre
  else if ((isFirstLeaf = 0) and (isOnMainstem = 1)) then
  begin
    predimPreviousLeafMainstem := FindLeafPredim(instance, rank - 1);
    predimOfCurrentLeaf := predimPreviousLeafMainstem + MGR * testIc * fcstr;
    SRwriteln('Cas                        --> pas la premiere feuille sur le brin maitre');
    SRwriteln('predimPreviousLeafMainstem --> ' + FloatToStr(predimPreviousLeafMainstem));
    SRwriteln('predimOfCurrentLeaf        --> ' + FloatToStr(predimOfCurrentLeaf));
  end

  // Cas : premiere feuille sur une talle
  else if ((isFirstLeaf = 1) and (isOnMainstem = 0)) then
  begin
    refMainstem := FindMainstem(instance);
    predimPreviousLeafMainstem := FindLeafPredim(refMainstem, phenoStage - 1, True);
    predimOfCurrentLeaf := 0.5 * (predimPreviousLeafMainstem + Lef1) * testIc * fcstr;
    SRwriteln('phenostage                 --> ' + FloatToStr(phenoStage));
    SRwriteln('Cas                        --> premiere feuille sur une talle');
    SRwriteln('predimPreviousLeafMainstem --> ' + FloatToStr(predimPreviousLeafMainstem));
    SRwriteln('Lef1                       --> ' + FloatToStr(Lef1));
    SRwriteln('predimOfCurrentLeaf        --> ' + FloatToStr(predimOfCurrentLeaf));
  end

  // Cas : pas la premiere feuille sur une talle
  else if ((isFirstLeaf = 0) and (isOnMainstem = 0)) then
  begin
    refMainstem := FindMainstem(instance);
    predimPreviousLeafMainstem := FindLeafPredim(refMainstem, phenoStage - 1, True);
    predimPreviousLeafTiller := FindLeafPredim(instance, rank - 1, False);
    predimOfCurrentLeaf := 0.5 * (predimPreviousLeafMainstem + predimPreviousLeafTiller) + MGR * testIc * fcstr;
    SRwriteln('Cas                        --> pas la premiere feuille sur une talle');
    SRwriteln('predimPreviousLeafMainstem --> ' + FloatToStr(predimPreviousLeafMainstem));
    SRwriteln('predimPreviousLeafTiller   --> ' + FloatToStr(predimPreviousLeafTiller));
    SRwriteln('predimOfCurrentLeaf        --> ' + FloatToStr(predimOfCurrentLeaf));
  end;
end;

procedure CreateTillersPhytomer_ng(var instance : TInstance; const boolCrossedPlasto,Ic,Ict,exeOrder,P,resp_Ict, thresINER, slopeINER, leafStockMax, phenoStageAtCreation, maximumReserveInternode : double; var nbTiller : double);
var
  i, tillerExeOrder : integer;
  newTiller : TEntityInstance;
  date : TDateTime;
  name : String;
begin
  if ((boolCrossedPlasto >= 0) and (nbTiller >= 1)) then
  begin
    if (Ic > Ict * ((P * resp_Ict) + 1)) then
    begin
      for i := 1 to Trunc(nbTiller) do
      begin
        // creation de la talle
        // --------------------
        name := 'T_' + IntToStr(FindGreatestSuffixforASpecifiedCategory(instance as TEntityInstance,'Tiller')+1);
        SRwriteln('nbTiller : ' + FloatToStr(nbTiller));
        SRwriteln('Module Meristem ****  creation de la talle : ' + name + '  ****');
        SRwriteln('phenoStageAtCreation --> ' + FloatToStr(phenoStageAtCreation));
        newTiller := ImportTillerPhytomer_ng(name, thresINER, slopeINER, leafStockMax, phenoStageAtCreation, maximumReserveInternode, 0);
        // determination de l'ordre d'execution de newTiller :
        // -------------------------------------------------
        if (HasAnEntityWithASpecifiedCategory(instance as TEntityInstance, 'Tiller' ) = False) then
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

        newTiller.ExternalConnect(['DD',
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


procedure CountNbTiller_ng(var instance : TInstance; var total : Double);
var
  i, le : Integer;
  currentInstance : TInstance;
  isMainstem : Double;
begin
  total := 0;
  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      if ((currentInstance as TEntityInstance).GetCategory() = 'Tiller') then
      begin
        isMainstem :=(currentInstance as TEntityInstance).GetTAttribute('isMainstem').GetCurrentSample().value;
        if (isMainstem = 0) then
        begin
          SRwriteln(currentInstance.GetName() + ' est une talle');
          total := total + 1;
        end
        else
        begin
          SRwriteln(currentInstance.GetName() + ' est le mainstem');
        end;
      end;
    end;
  end;
  SRwriteln('Nombre de talles --> ' + FloatToStr(total));
end;

procedure CountOfNbTillerWithMoreNbLeafEnablingTilleringLeaves_ng(var instance : TInstance; const nbLeafEnablingTillering : Double; var nbTillerWithMore4Leaves : Double);
var
   i,le : Integer;
   currentInstance : TInstance;
   category : String;
   leafNb : Double;
   isMainstem : Double;
begin
  nbTillerWithMore4Leaves := 0;
  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to le-1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      category := (currentInstance as TEntityInstance).GetCategory();
      if (category = 'Tiller') then
      begin
        isMainstem := (currentInstance as TEntityInstance).GetTAttribute('isMainstem').GetCurrentSample().value;
        if (isMainstem = 0) then
        begin
          SRwriteln(currentInstance.GetName() + ' est une talle');
          leafNb := (currentInstance as TEntityInstance).GetTAttribute('activeLeavesNb').GetCurrentSample().value;
          SRwriteln('leafNb --> ' + FloatToStr(leafNb));
          SRwriteln('state  --> ' + IntToStr((currentInstance as TEntityInstance).GetCurrentState()));
          if(leafNb >= (nbLeafEnablingTillering - 1)) then
          begin
            nbTillerWithMore4Leaves := nbTillerWithMore4Leaves + 1;
          end;
        end
        else
        begin
          SRwriteln(currentInstance.GetName() + ' est le mainstem');
        end;
      end;
    end;
  end;
  SRwriteln('nbTillerWithMore4Leaves --> ' + FloatToStr(nbTillerWithMore4Leaves));
end;

procedure ComputeLeafExpTime_ng(const predim, len, LER : double ; var exp_time : double);
begin
  exp_time := (predim - len) / LER;
  SRwriteln('predim       --> ' + floattostr(predim));
  SRwriteln('len          --> ' + floattostr(len));
  SRwriteln('LER          --> ' + floattostr(LER));
  SRwriteln('exp_time     --> ' + floattostr(exp_time));
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

procedure KillOldestLeaf_ng(var instance : TInstance ; const realocationCoeff : Double; var deficit, stock, senesc_dw, deadleafNb, computedReallocBiomass : Double);
var
   oldestCreationDate, currentCreationDate : TDateTime;
   currentInstance, currentInstanceOnTiller : TInstance;
   refOldestLeaf : TInstance;
   refFather : TInstance;
   refLeafState2 : TInstance;
   i1,le1 : Integer;
   i2,le2 : Integer;
   leafBiomass : Double;
   date : TDateTime;
   nbLeaf : Integer; // nombre de feuilles presentes sur le brin maitre
   state4 : Integer; // nombre de feuilles presentent sur le brin maitre, mais en state = 4 ou 5
   existLeafstate4_5 : Boolean;
   currentState : Integer;
   stateOldestLeaf : Integer;
   localComputedReallocBiomass, dailySenescDw : Double;
   isMainstem : Double;
Begin
  // recherche de la plus vieille feuille
  // ------------------------------------
  refFather := instance;
  oldestCreationDate := MAX_DATE;
  nbLeaf := 0;
  refOldestLeaf := nil;
  le1 := (instance as TEntityInstance).LengthTInstanceList();
  for i1 := 0 to le1 - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i1);
    if (currentInstance is TEntityInstance) then
    begin
      if ((currentInstance as TEntityInstance).GetCategory() = 'Tiller') then
      begin
        isMainstem := (currentInstance as TEntityInstance).GetTAttribute('isMainstem').GetCurrentSample().value;
        le2 := (currentInstance as TEntityInstance).LengthTInstanceList();
        for i2 := 0 to le2 - 1 do
        begin
          currentInstanceOnTiller := (currentInstance as TEntityInstance).GetTInstance(i2);
          if (currentInstanceOnTiller is TEntityInstance) then
          begin
            if ((currentInstanceOnTiller as TEntityInstance).GetCategory() = 'Leaf') then
            begin
              if (isMainstem = 1) then
              begin
                nbLeaf := nbLeaf + 1;
              end;
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

  SRwriteln('----------------------------------------------');
  SRwriteln('Ancienne valeur du stock                  --> ' + FloatToStr(stock));
  SRwriteln('Ancienne valeur de computedReallocBiomass --> ' + FloatToStr(computedReallocBiomass));
  SRwriteln('Ancienne valeur de senesc_dw              --> ' + FloatToStr(senesc_dw));
  SRwriteln('Deficit                                   --> ' + FloatToStr(deficit));
  SRwriteln('Biomasse de la feuille tuee               --> ' + FloatToStr(leafBiomass));
  SRwriteln('On recupere                               --> ' + FloatToStr(realocationCoeff * leafBiomass));

  localComputedReallocBiomass := realocationCoeff * leafBiomass;

  computedReallocBiomass := computedReallocBiomass  + localComputedReallocBiomass;

  stock := max(0, localComputedReallocBiomass + deficit);
  deficit := min(0, localComputedReallocBiomass + deficit);
  senesc_dw := senesc_dw + (leafBiomass - localComputedReallocBiomass);
  dailySenescDw := leafBiomass - localComputedReallocBiomass;
  deadleafNb := deadleafNb + 1;

  SRwriteln('----------------------------------------------');
  SRwriteln('dailySenescDw                             --> ' + FloatToStr(dailySenescDw));
  SRwriteln('Nouvelle valeur de computedReallocBiomass --> ' + FloatToStr(computedReallocBiomass));
  SRwriteln('Nouvelle valeur de senesc_dw              --> ' + FloatToStr(senesc_dw));
  SRwriteln('Nouvelle valeur du stock                  --> ' + FloatToStr(stock));
  SRwriteln('Nouvelle valeur du deficit                --> ' + FloatToStr(deficit));
  SRwriteln('computedReallocBiomass                    --> ' + FloatToStr(computedReallocBiomass));

  // cas particulier ou la plante est morte
  // (cad plus de feuille sur le brin maitre)
  // ----------------------------------------
  if (nbLeaf = 1) then // il ne restait qu une seule feuille avant destruction de celle-ci
  begin
    SRWriteln('PLANT IS DEAD !!!!!!!!!!');
    (instance as TEntityInstance).SetCurrentState(1000); // la plante passe a l etat morte
  end;

  existLeafstate4_5 := false;

  le1 := (instance as TEntityInstance).LengthTInstanceList();
  for i1 := 0 to le1 - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i1);
    if (currentInstance is TEntityInstance) then
    begin
      if ((currentInstance as TEntityInstance).GetCategory() = 'Tiller') then
      begin
        isMainstem := (currentInstance as TEntityInstance).GetTAttribute('isMainstem').GetCurrentSample().value;
        if (isMainstem = 1) then
        begin
          le2 := (currentInstance as TEntityInstance).LengthTInstanceList();
          for i2 := 0 to le2 - 1 do
          begin
            currentInstanceOnTiller := (currentInstance as TEntityInstance).GetTInstance(i2);
            if (currentInstanceOnTiller is TEntityInstance) then
            begin
              if ((currentInstanceOnTiller as TEntityInstance).GetCategory() = 'Leaf') then
              begin
                state4 := (currentInstanceOnTiller as TEntityInstance).GetCurrentState();
                if ((state4 = 4) or (state4 = 5)) then
                begin
                  existLeafstate4_5 := True;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
  if (not(existLeafstate4_5)) then
  begin
    SRWriteln('PLANT IS DEAD !!!!!!!!!! No more leaf on mainsten in state 4 or 5');
    (instance as TEntityInstance).SetCurrentState(1000); // la plante passe a l etat morte
  end;
end;

procedure KillYoungestTillerOldestLeaf_ng(var instance : TInstance ; const reallocationCoeff, nbLeafEnablingTillering : Double; var deficit, stock, senesc_dw, deadleafNb, deadtillerNb, computedReallocBiomass : Double);
var
  state, leafState, le, i, counter : Integer;
  currentInstance : TInstance;
  refTiller, refLeaf : TEntityInstance;
  date, creationDate, nextDate : TDateTime;
  activeLeavesNb, sumOfTillerINBiomass, sumOfTillerLeafBiomass, leafBiomass, totalBiomass, computedReallocBiomassTiller : Double;
  oldDeficit, deficitTiller, tmp, previousDeficit : Double;
  sample : TSample;
begin
  state := (instance as TEntityInstance).GetCurrentState();
  SRwriteln('state   --> ' + IntToStr(state));
  SRwriteln('stock   --> ' + FloatToStr(stock));
  SRwriteln('deficit --> ' + FloatToStr(deficit));
  if ((stock = 0) and (state <> 1) and (state < 4)) then
  begin
    SRwriteln('Cas on tue une feuille - phase vegetative');
    SRwriteln('------------------------------------------');
    KillOldestLeaf_ng(instance, reallocationCoeff, deficit, stock, senesc_dw, deadleafNb, computedReallocBiomass);
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

          
          computedReallocBiomass := computedReallocBiomass + (reallocationCoeff * leafBiomass);

          stock := max(0, stock + computedReallocBiomass + deficit);
          deficit := Min(0, stock + computedReallocBiomass + deficit);
          deadleafNb := deadleafNb + 1;
          senesc_dw := senesc_dw + leafBiomass - (reallocationCoeff * leafBiomass);

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
            sumOfTillerINBiomass := refTiller.GetTAttribute('sumOfInternodeBiomass').GetSample(nextDate).value;
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
        KillOldestLeaf_ng(instance, reallocationCoeff, deficit, stock, senesc_dw, deadleafNb, computedReallocBiomass);
      end;
      SRwriteln('On force la remise a 0 des demandes et stock de mainstem et des talles');
      SRwriteln('----------------------------------------------------------------------');
      date := (instance as TEntityInstance).GetNextDate();
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

procedure ComputeLeafInternodeBiomassCulms_ng(var instance : TInstance);
var
  le1, le2, i1, i2 : Integer;
  currentInstance1, currentInstance2 : TInstance;
  currentEntityInstance1, currentEntityInstance2 : TEntityInstance;
  leafBiomass, internodeBiomass, leafInternodeBiomassTiller, total : Double;
  date : TDateTime;
  sample : TSample;
begin
  total := 0;
  le1 := (instance as TEntityInstance).LengthTInstanceList();
  for i1 := 0 to le1 - 1 do
  begin
    currentInstance1 := (instance as TEntityInstance).GetTInstance(i1);
    if (currentInstance1 is TEntityInstance) then
    begin
      currentEntityInstance1 := (currentInstance1 as TEntityInstance);
      if (currentEntityInstance1.GetCategory() = 'Tiller') then
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
      end;
    end;
  end;
  date := (instance as TEntityInstance).GetNextDate();
  sample.date := date;
  (instance as TEntityInstance).GetTAttribute('leaf_internode_biomass').SetSample(sample);
  SRwriteln('leaf_internode_biomass        --> ' + FloatToStr(total));
end;

procedure ComputeSumOfInternodeBiomassOnCulm_ng(var instance : TInstance; var total : Double);
var
  i, le, state : Integer;
  currentInstance : TInstance;
  biomass : Double;
begin
  total := 0;
  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      if ((currentInstance as TEntityInstance).GetCategory = 'Internode') then
      begin
        state := (currentInstance as TEntityInstance).GetCurrentState();
        if ((state <> 1000) and (state <> 2000)) then
        begin
          biomass := (currentInstance as TEntityInstance).GetTAttribute('biomassIN').GetCurrentSample().value;
          SRwriteln('Contribution de ' + currentInstance.GetName() + ' --> ' + FloatToStr(biomass));
          total := total + biomass;
        end;
      end;
    end;
  end;
  SRwriteln('Total --> ' + FloatToStr(total));
end;

procedure SumOfDailyComputedReallocBiomass_ng(var instance : TInstance; var total : Double);
var
  i, le : Integer;
  currentInstance : TInstance;
  dailyComputedReallocBiomass : Double;
begin
  total := 0;

  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      if ((currentInstance as TEntityInstance).GetCategory() = 'Tiller') then
      begin
        dailyComputedReallocBiomass := (currentInstance as TEntityInstance).GetTAttribute('sumOfDailyComputedReallocBiomassTiller').GetCurrentSample().value;
        SRwriteln('Contribution de ' + currentInstance.GetName() + ' --> ' + FloatToStr(dailyComputedReallocBiomass));
        total := total + dailyComputedReallocBiomass;
      end;
    end;
  end;
  SRwriteln('Total --> ' + FloatToStr(total));
end;

procedure SumOfDailySenescedLeafBiomass_ng(var instance : TInstance; var total : Double);
var
  i, le : Integer;
  currentInstance : TInstance;
  sumOfSenescedBiomass : Double;
begin
  total := 0;
  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      if ((currentInstance as TEntityInstance).GetCategory() = 'Tiller') then
      begin
        sumOfSenescedBiomass := (currentInstance as TEntityInstance).GetTAttribute('sumOfDailySenescedLeafBiomassTiller').GetCurrentSample().value;
        SRwriteln('Contribution de ' + currentInstance.GetName() + ' --> ' + FloatToStr(sumOfSenescedBiomass));
        total := total + sumOfSenescedBiomass;
      end;
    end;
  end;
  SRwriteln('total --> ' + FloatToStr(total));
end;

procedure ComputeMaxReservoirCulms_ng(var instance : TInstance);
var
  stateMeristem, stateTiller, i, le : Integer;
  MaxReservoirOnCulm, leafStockMax, maximumReserveInInternode, sumOfCulmInternodeBiomass, sumOfCulmLeafBiomass : Double;
  sample : TSample;
  currentInstance : TInstance;
begin
  stateMeristem := (instance as TEntityInstance).GetCurrentState();
  SRwriteln('state meristem : ' + IntToStr(stateMeristem));
  case stateMeristem of
    4, 5, 6, 9 :
    begin
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
                sumOfCulmInternodeBiomass := (currentInstance as TEntityInstance).GetTAttribute('sumOfInternodeBiomass').GetCurrentSample().value;
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

procedure ComputeBiomassInternodeStruct_ng(var instance : TInstance; var biomInternodeStruct : Double);
var
  i, le : Integer;
  currentInstance : TInstance;
  sumOfInternodeBiomass : Double;
begin
  biomInternodeStruct := 0;
  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      if ((currentInstance as TEntityInstance).GetCategory() = 'Tiller') then
      begin
        sumOfInternodeBiomass := (currentInstance as TEntityInstance).GetTAttribute('sumOfInternodeBiomass').GetCurrentSample().value;
        SRwriteln('Contribution de ' + currentInstance.GetName() + ' --> ' + FloatToStr(sumOfInternodeBiomass));
        biomInternodeStruct := biomInternodeStruct + sumOfInternodeBiomass;
      end;
    end;
  end;
  SRwriteln('biomInternodeStruct --> ' + FloatToStr(biomInternodeStruct));
end;

procedure ComputeLengthPeduncles_ng(var instance : TInstance);
var
  currentInstance : TInstance;
  le, i, state : Integer;
  lengthPeduncle, heightPanicle, sumOfInternodeLength : Double;
  sample : TSample;
  refPanicle : TEntityInstance;
  refAttribute : TAttribute;
begin
  refPanicle := nil;
  lengthPeduncle := 0;
  sumOfInternodeLength := 0;
  state := (instance as TEntityInstance).GetCurrentState();
  SRwriteln('state --> ' + IntToStr(state));
  case state of
    4, 6, 7, 12 :
    begin
      le := (instance as TEntityInstance).LengthTInstanceList();
      for i := 0 to le - 1 do
      begin
        currentInstance := (instance as TEntityInstance).GetTInstance(i);
        if (currentInstance is TEntityInstance) then
        begin
          if ((currentInstance as TEntityInstance).GetCategory() = 'Peduncle') then
          begin
            SRwriteln('Peduncle');
            refAttribute := (currentInstance as TEntityInstance).GetTAttribute('LIN');
            if (refAttribute <> nil) then
            begin
              lengthPeduncle := refAttribute.GetCurrentSample().value;
            end;
          end;
          if ((currentInstance as TEntityInstance).GetCategory() = 'Panicle') then
          begin
            SRwriteln('Panicle');
            refPanicle := (currentInstance as TEntityInstance);
          end;
          if ((currentInstance as TEntityInstance).GetCategory() = 'Internode') then
          begin
            refAttribute := (currentInstance as TEntityInstance).GetTAttribute('LIN');
            if (refAttribute <> nil) then
            begin
              sumOfInternodeLength := sumOfInternodeLength + refAttribute.GetCurrentSample().value;
            end;
          end;
        end;
      end;
      heightPanicle := lengthPeduncle + sumOfInternodeLength;
      SRwriteln('heightPanicle --> ' + FloatToStr(heightPanicle) + ' on panicle ' + refPanicle.GetName());
      sample := refPanicle.GetTAttribute('height_panicle').GetCurrentSample();
      sample.value := heightPanicle;
      refPanicle.GetTAttribute('height_panicle').SetSample(sample);
    end;
  end;
end;

procedure SetUpTillerStockPre_Elong_ng(var instance : TInstance);
var
  sumOfBiomass, sumOfTillerLeafBiomass, stockPlant, stockTiller, stockMainstem : Double;
  ifFirstDayOfPre_Elong : Double;
  tillerState : Integer;
  sample : TSample;
  attributeFirstDay, attributeStockTiller, attributeStockMainstem : TAttribute;
  attributeStockPlant : TAttributeTableOut;
  refFather, refMainstem : TInstance;
begin
  tillerState := (instance as TEntityInstance).GetCurrentState();
  if (tillerState = 10) then
  begin
    SRwriteln('Tiller a PRE_ELONG');
    attributeFirstDay := (instance as TEntityInstance).GetTAttribute('ifFirstDayOfPre_Elong');
    sample := attributeFirstDay.GetCurrentSample();
    ifFirstDayOfPre_Elong := sample.value;
    if (ifFirstDayOfPre_Elong = 1) then
    begin
      SRwriteln('Premier jour de PRE_ELONG, on initialise le stock de la talle');
      sample.value := 0;
      attributeFirstDay.SetSample(sample);
      refFather := instance.GetFather();
      while (refFather.GetName() <> 'EntityMeristem') do
      begin
        refFather := refFather.GetFather();
      end;
      refMainstem := FindMainstem(instance);
      attributeStockPlant := ((refFather as TEntityInstance).GetTAttribute('stock') as TAttributeTableOut);
      stockPlant := attributeStockPlant.GetCurrentSample().value;
      SRwriteln('stockPlant             --> ' + FloatToStr(stockPlant));
      attributeStockMainstem := (refMainstem as TEntityInstance).GetTAttribute('stock_tiller');
      stockMainstem := attributeStockMainstem.GetCurrentSample().value;
      SRwriteln('stockMainstem          --> ' + FloatToStr(stockMainstem));
      sumOfBiomass := (refFather as TEntityInstance).GetTAttribute('sumOfBiomass').GetCurrentSample().value;
      SRwriteln('sumOfBiomass           --> ' + FloatToStr(sumOfBiomass));
      sumOfTillerLeafBiomass := (instance as TEntityInstance).GetTAttribute('sumOfTillerLeafBiomass').GetCurrentSample().value;
      SRwriteln('sumOfTillerLeafBiomass --> ' + FloatToStr(sumOfTillerLeafBiomass));
      attributeStockTiller := (instance as TEntityInstance).GetTAttribute('stock_tiller');
      stockTiller := (sumOfTillerLeafBiomass / sumOfBiomass) * stockPlant;
      SRwriteln('stockTiller            --> ' + FloatToStr(stockTiller));
      stockMainstem := stockPlant - stockTiller;
      SRwriteln('Nouveau stockMainstem  --> ' + FloatToStr(stockMainstem));
      sample := attributeStockMainstem.GetCurrentSample();
      sample.value := stockMainstem;
      attributeStockMainstem.SetSample(sample);
      sample := attributeStockTiller.GetCurrentSample();
      sample.value := stockTiller;
      attributeStockTiller.SetSample(sample);
    end
    else
    begin
      SRwriteln('Pas premier jour de PRE_ELONG');
    end;
  end
  else
  begin
    SRwriteln('Tiller pas a PRE_ELONG');
  end;
end;

procedure ComputeLastDemandCulms_ng(var instance : TInstance; var lastDemand : Double);
var
  i, le, stateTiller, stateMeristem : Integer;
  currentInstance : TInstance;
  tillerContribution, total : Double;
begin
  stateMeristem := (instance as TEntityInstance).GetCurrentState();
  if (stateMeristem >= 4) then
  begin
    total := 0;
    lastDemand := 0;
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
            4, 5, 6, 7, 9, 12 :
            begin
              tillerContribution := (currentInstance as TEntityInstance).GetTAttribute('last_demand_tiller').GetCurrentSample().value;
              SRwriteln('Contribution de : ' + currentInstance.GetName() + ' = ' + FloatToStr(tillerContribution));
              total := total + tillerContribution;
            end;
          end;
        end;
      end;
    end;
  end
  else
  begin
    total := lastDemand;
  end;
  lastDemand := total;
  SRwriteln('Total lastDemand --> ' + FloatToStr(lastDemand));
end;

function ComputeBiomassCulm(var instance : TInstance) : Double;
var
  i, le, stateLeaf : Integer;
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
        stateLeaf := (currentInstance as TEntityInstance).GetCurrentState();
        if ((stateLeaf = 4) or (stateLeaf = 5)) then
        begin
          total := total + (currentInstance as TEntityInstance).GetTAttribute('correctedLeafBiomass').GetCurrentSample().value;
        end
        else
        begin
          total := total + (currentInstance as TEntityInstance).GetTAttribute('biomass').GetCurrentSample().value;        
        end;
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

procedure ComputeTmpCulms_ng(var instance : TInstance);
var
  stateMeristem, stateTiller, le, i : Integer;
  currentInstance : TInstance;
  stockCulm, deficitCulm, sumDemandINCulm, sumDemandNonINCulm, sumOfLastDemandCulm, supplyCulm, tmpCulm : Double;
  sumOfBiomassOnCulm, sumOfBiomassOnPlant : Double;
  stockPlant, deficitPlant, sumOfDailyComputedReallocBiomassCulm : Double;
  sample : TSample;
  date : TDateTime;
begin
  stateMeristem := (instance as TEntityInstance).GetCurrentState();
  if (stateMeristem >= 4) then
  begin
    date := (instance as TEntityInstance).GetNextDate();
    SRwriteln('stateMeristem : ' + IntToStr(stateMeristem));
    deficitPlant := ((instance as TEntityInstance).GetTAttribute('deficit') as TAttributeTableOut).GetCurrentSample().value;
    stockPlant :=  ((instance as TEntityInstance).GetTAttribute('stock') as TAttributeTableOut).GetCurrentSample().value;
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
            SRwriteln('Tiller                                 --> ' + currentInstance.GetName());
            SRwriteln('state Tiller                           --> ' + IntToStr(stateTiller));
            sumDemandINCulm := (currentInstance as TEntityInstance).GetTAttribute('sumOfTillerInternodeDemand').GetCurrentSample().value;
            sumDemandNonINCulm := (currentInstance as TEntityInstance).GetTAttribute('demandOfNonINTiller').GetCurrentSample().value;
            sumOfLastDemandCulm := (currentInstance as TEntityInstance).GetTAttribute('last_demand_tiller').GetCurrentSample().value;
            supplyCulm := (currentInstance as TEntityInstance).GetTAttribute('supply_tiller').GetCurrentSample().value;
            sumOfDailyComputedReallocBiomassCulm := (currentInstance as TEntityInstance).GetTAttribute('sumOfDailyComputedReallocBiomassTiller').GetCurrentSample().value;
            sumOfBiomassOnCulm := ComputeBiomassCulm(currentInstance);
            sumOfBiomassOnPlant := ComputeAllBiomass(instance);
            stockCulm := (sumOfBiomassOnCulm / sumOfBiomassOnPlant) * stockPlant;
            deficitCulm := (sumOfBiomassOnCulm / sumOfBiomassOnPlant) * deficitPlant;
            sample.date := date;
            sample.value :=  stockCulm;
            (currentInstance as TEntityInstance).GetTAttribute('stock_tiller').SetSample(sample);
            sample.value := deficitCulm;
            (currentInstance as TEntityInstance).GetTAttribute('deficit_tiller').SetSample(sample);
            SRwriteln('sumOfBiomassOnCulm                     --> ' + FloatToStr(sumOfBiomassOnCulm));
            SRwriteln('sumOfBiomassOnPlant                    --> ' + FloatToStr(sumOfBiomassOnPlant));
            SRwriteln('sumOfTillerInternodeDemand             --> ' + FloatToStr(sumDemandINCulm));
            SRwriteln('sumOfTillerNonInternodeDemand          --> ' + FloatToStr(sumDemandNonINCulm));
            SRwriteln('sumOfDailyComputedReallocBiomassTiller --> ' + FloatToStr(sumOfDailyComputedReallocBiomassCulm));
            SRwriteln('lastDemandTiller                       --> ' + FloatToStr(sumOfLastDemandCulm));
            SRwriteln('supplyTiller                           --> ' + FloatToStr(supplyCulm));
            SRwriteln('stockPlant                             --> ' + FloatToStr(stockPlant));
            SRwriteln('deficitPlant                           --> ' + FloatToStr(deficitPlant));
            SRwriteln('stockCulm                              --> ' + FloatToStr(stockCulm));
            SRwriteln('deficitCulm                            --> ' + FloatToStr(deficitCulm));
            tmpCulm := stockCulm + deficitCulm + supplyCulm - sumDemandINCulm - sumDemandNonINCulm - sumOfLastDemandCulm + sumOfDailyComputedReallocBiomassCulm;
            SRwriteln('tmpTiller                              --> ' + FloatToStr(tmpCulm));
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

procedure ComputeDeficitCulms_ng(var instance : TInstance);
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

procedure ComputeSurplusCulms_ng(var instance : TInstance);
var
  stateMeristem, stateTiller, i, le : Integer;
  sample : TSample;
  currentInstance : TInstance;
  stockCulm, maxReservoirOnCulm, sumDemandINCulm, sumDemandNonINCulm, sumOfLastDemandCulm, surplusCulm, supplyCulm : Double;
  sumOfDailyComputedReallocBiomassCulm : Double;
  date : TDateTime;
begin
  stateMeristem := (instance as TEntityInstance).GetCurrentState();
  if (stateMeristem >= 4) then
  begin
    SRwriteln('state meristem : ' + IntToStr(stateMeristem));
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
              sumOfDailyComputedReallocBiomassCulm := (currentInstance as TEntityInstance).GetTAttribute('sumOfDailyComputedReallocBiomassTiller').GetCurrentSample().value;
              supplyCulm := (currentInstance as TEntityInstance).GetTAttribute('supply_tiller').GetCurrentSample().value;
              SRwriteln('stockTiller                            --> ' + FloatToStr(stockCulm));
              SRwriteln('maxReservoirDispoOnTiller              --> ' + FloatToStr(maxReservoirOnCulm));
              SRwriteln('sumOfTillerInternodeDemand             --> ' + FloatToStr(sumDemandINCulm));
              SRwriteln('sumOfTillerNonInternodeDemand          --> ' + FloatToStr(sumDemandNonINCulm));
              SRwriteln('sumOfLastDemandTiller                  --> ' + FloatToStr(sumOfLastDemandCulm));
              SRwriteln('sumOfDailyComputedReallocBiomassTiller --> ' + FloatToStr(sumOfDailyComputedReallocBiomassCulm));
              SRwriteln('supplyTiller                           --> ' + FloatToStr(supplyCulm));
              surplusCulm := Max(0, stockCulm - sumDemandINCulm - sumDemandNonINCulm - sumOfLastDemandCulm + supplyCulm - maxReservoirOnCulm + sumOfDailyComputedReallocBiomassCulm);
              SRwriteln('surplusCulm                            --> ' + FloatToStr(surplusCulm));
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

procedure ComputeStockCulms_ng(var instance : TInstance);
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

procedure ComputeSurplusPlant_ng(var instance : TInstance);
var
  surplus, contribution, total : Double;
  stateMeristem, le, i : Integer;
  currentInstance : TInstance;
  sample : TSample;
  date : TDateTime;
begin
  surplus := ((instance as TEntityInstance).GetTAttribute('surplus') as TAttributeTableOut).GetCurrentSample().value;
  SRwriteln('Surplus initial --> ' + FloatToStr(surplus));
  stateMeristem := (instance as TEntityInstance).GetCurrentState();
  if (stateMeristem >= 4) then
  begin
    total := 0;
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
    sample.value := surplus + total;
    ((instance as TEntityInstance).GetTAttribute('surplus') as TAttributeTableOut).SetSample(sample);
    SRwriteln('Surplus Plant --> ' + FloatToStr(sample.value));
  end;
end;

procedure ComputeSupplyPlant_ng(var instance : TInstance);
var
  assim : Double;
  stateMeristem : Integer;
  sample : TSample;
  date : TDateTime;
begin
  stateMeristem := (instance as TEntityInstance).GetCurrentState();
  if (stateMeristem >= 4) then
  begin
    assim := ((instance as TEntityInstance).GetTAttribute('assim') as TAttributeTableOut).GetCurrentSample().value;
    date := (instance as TEntityInstance).GetNextDate();
    sample := ((instance as TEntityInstance).GetTAttribute('supply') as TAttributeTableOut).GetSample(date);
    sample.date := date;
    sample.value := assim;
    ((instance as TEntityInstance).GetTAttribute('supply') as TAttributeTableOut).SetSample(sample);
    SRwriteln('Supply Plant --> ' + FloatToStr(sample.value));
  end;
end;

procedure ComputeStockPlant_ng(var instance : TInstance);
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

procedure ComputeDeficitPlant_ng(var instance : TInstance);
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

procedure ComputeTestIcCulm_ng(var instance : TInstance; var testIc : Double);
var
  refMeristem, refTiller : TInstance;
  statePlant, stateTiller : Integer;
  testIcCalcule, icTiller : Double;
  nbDayOfSimulation : Double;
begin
  testIc := 0;
  testIcCalcule := 0;
  refMeristem := instance.GetFather();
  while (refMeristem.GetName() <> 'EntityMeristem') do
  begin
    refMeristem := refMeristem.GetFather();
  end;
  refTiller := instance.GetFather();
  while ((refTiller as TEntityInstance).GetCategory() <> 'Tiller') do
  begin
    refTiller := refTiller.GetFather();
  end;
  statePlant := (refMeristem as TEntityInstance).GetCurrentState();
  SRwriteln('state plant       --> ' + IntToStr(statePlant));
  nbDayOfSimulation := (refMeristem as TEntityInstance).GetTAttribute('nbDayOfSimulation').GetCurrentSample().value;
  SRwriteln('nbDayOfSimulation --> ' + FloatToStr(nbDayOfSimulation));
  case statePlant of
    1, 2, 3 :
    begin
      if (nbDayOfSimulation = 1) then
      begin
        SRwriteln('premier jour de simulation --> testIc = 1');
        testIcCalcule := 1;
      end
      else
      begin
        testIcCalcule := ((refMeristem as TEntityInstance).GetTAttribute('testIc') as TAttributeTableOut).GetCurrentSample().value;
        SRwriteln('morphogenese, on prend le testIc global --> ' + FloatToStr(testIcCalcule));
      end;
    end;
    4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 :
    begin
      stateTiller := (refTiller as TEntityInstance).GetCurrentState();
      if (stateTiller = 10) then
      begin                   
        SRwriteln('La talle est a PRE_ELONG on garde testIc global');
        testIcCalcule := ((refMeristem as TEntityInstance).GetTAttribute('testIc') as TAttributeTableOut).GetCurrentSample().value;
      end
      else
      begin
        SRwriteln('Elong et plus, on calcule testIc avec l''ic tiller');
        icTiller := (refTiller as TEntityInstance).GetTAttribute('ic_tiller').GetCurrentSample().value;
        SRwriteln('ic_tiller --> ' + FloatToStr(icTiller));
        testIcCalcule := Min(1, Sqrt(Max(icTiller, 0.001)));
        SRwriteln('testIc    --> ' + FloatToStr(testIcCalcule));
      end;
    end;
  end;
  testIc := testIcCalcule;
end;

procedure ComputeGetFcstr_ng(var instance : TInstance; var fcstr : Double);
var
  refMeristem : TInstance;
begin
  refMeristem := instance.GetFather();
  while (refMeristem.GetName() <> 'EntityMeristem') do
  begin
    refMeristem := refMeristem.GetFather();
  end;
  fcstr := ((refMeristem as TEntityInstance).GetTAttribute('fcstr') as TAttributeTableOut).GetCurrentSample().value;
  SRwriteln('fcstr --> ' + FloatToStr(fcstr));
end;

procedure ComputeMaxReservoirLeafCulm_ng(const leafStockMax, sumOfLeafBiomass : Double; var maxReservoirDispoLeaf : Double);
begin
  maxReservoirDispoLeaf := leafStockMax * sumOfLeafBiomass;
  SRwriteln('leafStockMax          --> ' + FloatToStr(leafStockMax));
  SRwriteln('sumOfLeafBiomass      --> ' + FloatToStr(sumOfLeafBiomass));
  SRwriteln('maxReservoirDispoLeaf --> ' + FloatToStr(maxReservoirDispoLeaf));
end;

procedure ComputeMaxReservoirInternodeCulm_ng(const maximumReserveInInternode, sumOfInternodeBiomass : Double; var maxReservoidDispoInternode : Double);
begin
  maxReservoidDispoInternode := maximumReserveInInternode * sumOfInternodeBiomass;
  SRwriteln('maximumReserveInInternode  --> ' + FloatToStr(maximumReserveInInternode));
  SRwriteln('sumOfInternodeBiomass      --> ' + FloatToStr(sumOfInternodeBiomass));
  SRwriteln('maxReservoidDispoInternode --> ' + FloatToStr(maxReservoidDispoInternode));
end;

procedure ComputeBalanceSheet_ng(var instance : TInstance);
var
  i, le, state, stateTiller : Integer;
  currentInstance : TInstance;
  currentEntityInstance : TEntityInstance;
  reservoirDispoINCulm, maxReservoirDispoInternodeCulm, stockINCulm : Double;
  demandOnCulmForGrowth, demandOfNonINCulm, demandINCulm, lastDemandCulm : Double;
  demandINStorageCulm, coeffStorageINActive : Double;
  remainToStoreOld : Double;
  sumOfDemandOnCulm : Double;
  supplyCulm, supplyPlant : Double;
  icCulm : Double;
  tmpCulm, stockLeafCulm, computedReallocBiomassLeafCulm : Double;
  tmpCulm2, coeffRemob : Double;
  remainToStoreCulm : Double;
  maxReservoirDispoLeafCulm : Double;
  reservoirDispoLeafCulm : Double;
  deficitCulm, deficitCulmOld, stockCulm : Double;
  phenoStage, boolCrossedPlasto, nbLeafStemElong, nbLeafPI, previousState : Double;
  plantLeafBiomass, culmLeafBiomass, stock : Double;
  refAttribute : TAttribute;
  refAttributeOut : TAttributeTableOut;
  sample : TSample;
  isFirstDayOfElong, isFirstDayOfPI : Boolean;
  tmpCulm3 : Double;
  surplus : Double;
  date : TDateTime;
begin
  state := (instance as TEntityInstance).GetCurrentState();
  SRwriteln('state meristem    --> ' + IntToStr(state));
  if (state <> 1000) then
  begin
    date := (instance as TEntityInstance).GetNextDate();
    phenoStage := ((instance as TEntityInstance).GetTAttribute('n') as TAttributeTableOut).GetCurrentSample().value;
    boolCrossedPlasto := (instance as TEntityInstance).GetTAttribute('boolCrossedPlasto').GetCurrentSample().value;
    nbLeafStemElong := (instance as TEntityInstance).GetTAttribute('nb_leaf_stem_elong').GetCurrentSample().value;
    nbLeafPI := (instance as TEntityInstance).GetTAttribute('nbleaf_pi').GetCurrentSample().value;
    previousState := (instance as TEntityInstance).GetTAttribute('previousState').GetCurrentSample().value;
    SRwriteln('phenoStage        --> ' + FloatToStr(phenoStage));
    SRwriteln('boolCrossedPlasto --> ' + FloatToStr(boolCrossedPlasto));
    SRwriteln('nbLeafStemElong   --> ' + FloatToStr(nbLeafStemElong));
    SRwriteln('nbLeafPI          --> ' + FloatToStr(nbLeafPI));
    SRwriteln('previousState     --> ' + FloatToStr(previousState));
    if ((phenoStage = nbLeafStemElong) and (boolCrossedPlasto > 0)) then
    begin
      isFirstDayOfElong := True;
      isFirstDayOfPI := False;
    end
    else if ((phenoStage = nbLeafPI) and (boolCrossedPlasto > 0) and (previousState <> 9)) then
    begin
      isFirstDayOfElong := False;
      isFirstDayOfPI := True;
    end
    else
    begin
      isFirstDayOfElong := False;
      isFirstDayOfPI := False;
    end;
    SRwriteln('isFirstDayOfElong --> ' + BoolToStr(isFirstDayOfElong));
    SRwriteln('isFirstDayOfPI    --> ' + BoolToStr(isFirstDayOfPI));
    if (state >= 4) then
    begin
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
            SRwriteln('stateTiller ' + currentEntityInstance.GetName() + ' --> ' + IntToStr(stateTiller));
            if (stateTiller <> 10) then // la talle n'est pas à PRE_ELONG
            begin
              SRwriteln('----------------------------------------------------------');
              SRwriteln('|Tiller name --> ' + currentEntityInstance.getName());
              SRwriteln('----------------------------------------------------------');
              SRwriteln('| Variables en entree                                    |');
              SRwriteln('----------------------------------------------------------');
              if (isFirstDayOfElong or isFirstDayOfPI) then
              begin
                SRwriteln('----------------------------------------------------------');
                SRwriteln('Premier jour, on initialise stockLeafCulm');
                SRwriteln('----------------------------------------------------------');
                plantLeafBiomass := (instance as TEntityInstance).GetTAttribute('biomLeafStruct').GetCurrentSample().value;
                culmLeafBiomass := currentEntityInstance.GetTAttribute('sumOfTillerLeafBiomass').GetCurrentSample().value;
                stock := ((instance as TEntityInstance).GetTAttribute('stock') as TAttributeTableOut).GetCurrentSample().value;
                stockLeafCulm := stock * (culmLeafBiomass / plantLeafBiomass);
                SRwriteln('plantLeafBiomass               --> ' + FloatToStr(plantLeafBiomass));
                SRwriteln('culmLeafBiomass                --> ' + FloatToStr(culmLeafBiomass));
                SRwriteln('stock                          --> ' + FloatToStr(stock));
                SRwriteln('stockLeafCulm                  --> ' + FloatToStr(stockLeafCulm));
                refAttribute := currentEntityInstance.GetTAttribute('stockLeafTiller');
                sample := refAttribute.GetCurrentSample();
                sample.value := stockLeafCulm;
                refAttribute.SetSample(sample);
                SRwriteln('----------------------------------------------------------');
              end;
              maxReservoirDispoInternodeCulm := currentEntityInstance.GetTAttribute('maxReservoirDispoInternode').GetCurrentSample().value;
              stockINCulm := currentEntityInstance.GetTAttribute('stockINTiller').GetCurrentSample().value;
              coeffStorageINActive := (instance as TEntityInstance).GetTAttribute('coeff_active_storage_IN').GetCurrentSample().value;
              demandOfNonINCulm := currentEntityInstance.GetTAttribute('demandOfNonINTiller').GetCurrentSample().value;
              demandINCulm := currentEntityInstance.GetTAttribute('sumOfTillerInternodeDemand').GetCurrentSample().value;
              lastDemandCulm := currentEntityInstance.GetTAttribute('last_demand_tiller').GetCurrentSample().value;
              supplyPlant := ((instance as TEntityInstance).GetTAttribute('supply') as TAttributeTableOut).GetCurrentSample().value;
              computedReallocBiomassLeafCulm := currentEntityInstance.GetTAttribute('sumOfDailyComputedReallocBiomassTiller').GetCurrentSample().value;
              stockLeafCulm := currentEntityInstance.GetTAttribute('stockLeafTiller').GetCurrentSample().value;
              coeffRemob := (instance as TEntityInstance).GetTAttribute('coeff_remob').GetCurrentSample().value;
              maxReservoirDispoLeafCulm := currentEntityInstance.GetTAttribute('maxReservoirDispoLeaf').GetCurrentSample().value;
              deficitCulm := currentEntityInstance.GetTAttribute('deficit_tiller').GetCurrentSample().value;
              SRwriteln('maxReservoirDispoInternodeCulm --> ' + FloatToStr(maxReservoirDispoInternodeCulm));
              SRwriteln('stockINCulm                    --> ' + FloatToStr(stockINCulm));
              SRwriteln('coeffStorageINActive           --> ' + FloatToStr(coeffStorageINActive));
              SRwriteln('demandOfNonINCulm              --> ' + FloatToStr(demandOfNonINCulm));
              SRwriteln('demandINCulm                   --> ' + FloatToStr(demandINCulm));
              SRwriteln('lastDemandCulm                 --> ' + FloatToStr(lastDemandCulm));
              SRwriteln('supplyPlant                    --> ' + FloatToStr(supplyPlant));
              SRwriteln('computedReallocBiomassLeafCulm --> ' + FloatToStr(computedReallocBiomassLeafCulm));
              SRwriteln('stockLeafCulm                  --> ' + FloatToStr(stockLeafCulm));
              SRwriteln('coeffRemob                     --> ' + FloatToStr(coeffRemob));
              SRwriteln('maxReservoirDispoLeafCulm      --> ' + FloatToStr(maxReservoirDispoLeafCulm));
              SRwriteln('deficitCulm                    --> ' + FloatToStr(deficitCulm));
              SRwriteln('----------------------------------------------------------');
              SRwriteln('| Calculs                                                |');
              SRwriteln('----------------------------------------------------------');
              reservoirDispoINCulm := maxReservoirDispoInternodeCulm - stockINCulm;
              demandOnCulmForGrowth := demandOfNonINCulm + demandINCulm + lastDemandCulm;
              demandINStorageCulm := reservoirDispoINCulm * coeffStorageINActive;
              sumOfDemandOnCulm := demandOnCulmForGrowth + demandINStorageCulm;
              supplyCulm := Min(supplyPlant, sumOfDemandOnCulm);
              icCulm := Min(supplyCulm  / Max(sumOfDemandOnCulm, 0.00001), 5);
              tmpCulm := supplyCulm - sumOfDemandOnCulm + computedReallocBiomassLeafCulm + stockLeafCulm;
              tmpCulm2 := Max((1 - coeffRemob) * stockINCulm, Min(stockINCulm + reservoirDispoINCulm, stockINCulm + tmpCulm + deficitCulm + demandINStorageCulm));
              deficitCulmOld := deficitCulm;
              deficitCulm :=  Min(0, deficitCulm + tmpCulm + coeffRemob * stockINCulm + demandINStorageCulm);
              remainToStoreCulm := Max(0, tmpCulm + demandINStorageCulm - reservoirDispoINCulm + deficitCulmOld - deficitCulm);
              remainToStoreOld := remainToStoreCulm;
              stockINCulm := tmpCulm2;
              stockLeafCulm := Min(maxReservoirDispoLeafCulm, remainToStoreCulm);
              remainToStoreCulm := remainToStoreCulm - stockLeafCulm;
              reservoirDispoINCulm := maxReservoirDispoInternodeCulm - stockINCulm;
              reservoirDispoLeafCulm := maxReservoirDispoLeafCulm - stockLeafCulm;
              stockCulm := stockLeafCulm + stockINCulm;
              supplyPlant := supplyPlant - supplyCulm + remainToStoreCulm;
              SRwriteln('reservoirDispoINCulm           --> ' + FloatToStr(reservoirDispoINCulm));
              SRwriteln('demandOnCulmForGrowth          --> ' + FloatToStr(demandOnCulmForGrowth));
              SRwriteln('demandINStorageCulm            --> ' + FloatToStr(demandINStorageCulm));
              SRwriteln('sumOfDemandOnCulm              --> ' + FloatToStr(sumOfDemandOnCulm));
              SRwriteln('supplyCulm                     --> ' + FloatToStr(supplyCulm));
              SRwriteln('icCulm                         --> ' + FloatToStr(icCulm));
              SRwriteln('tmpCulm                        --> ' + FloatToStr(tmpCulm));
              SRwriteln('tmpCulm2                       --> ' + FloatToStr(tmpCulm2));
              SRwriteln('remainToStoreCulmOld           --> ' + FloatToStr(remainToStoreOld));
              SRwriteln('remainToStoreCulm              --> ' + FloatToStr(remainToStoreCulm));
              SRwriteln('stockINCulm                    --> ' + FloatToStr(stockINCulm));
              SRwriteln('stockLeafCulm                  --> ' + FloatToStr(stockLeafCulm));
              SRwriteln('reservoirDispoINCulm           --> ' + FloatToStr(reservoirDispoINCulm));
              SRwriteln('reservoirDispoLeafCulm         --> ' + FloatToStr(reservoirDispoLeafCulm));
              SRwriteln('deficitCulm                    --> ' + FloatToStr(deficitCulm));
              SRwriteln('stockCulm                      --> ' + FloatToStr(stockCulm));
              SRwriteln('new supplyPlant                --> ' + FloatToStr(supplyPlant));
              refAttribute := currentEntityInstance.GetTAttribute('tmp_tiller');
              sample := refAttribute.GetCurrentSample();
              sample.date := date;
              sample.value := tmpCulm;
              refAttribute.SetSample(sample);
              refAttribute := currentEntityInstance.GetTAttribute('supply_tiller');
              sample := refAttribute.GetCurrentSample();
              sample.date := date;
              sample.value := supplyCulm;
              refAttribute.SetSample(sample);
              refAttribute := currentEntityInstance.GetTAttribute('deficit_tiller');
              sample := refAttribute.GetCurrentSample();
              sample.date := date;
              sample.value := deficitCulm;
              refAttribute.SetSample(sample);
              refAttribute := currentEntityInstance.GetTAttribute('stock_tiller');
              sample := refAttribute.GetCurrentSample();
              sample.date := date;
              sample.value := stockCulm;
              refAttribute.SetSample(sample);
              refAttribute := currentEntityInstance.GetTAttribute('ic_tiller');
              sample := refAttribute.GetCurrentSample();
              sample.date := date;
              sample.value := icCulm;
              refAttribute.SetSample(sample);
              refAttribute := currentEntityInstance.GetTAttribute('stockINTiller');
              sample := refAttribute.GetCurrentSample();
              sample.date := date;
              sample.value := stockINCulm;
              refAttribute.SetSample(sample);
              refAttribute := currentEntityInstance.GetTAttribute('stockLeafTiller');
              sample := refAttribute.GetCurrentSample();
              sample.date := date;
              sample.value := stockLeafCulm;
              refAttribute.SetSample(sample);
              refAttribute := currentEntityInstance.GetTAttribute('reservoirDispoLeafTiller');
              sample := refAttribute.GetCurrentSample();
              sample.date := date;
              sample.value := reservoirDispoLeafCulm;
              refAttribute.SetSample(sample);
              refAttribute := currentEntityInstance.GetTAttribute('reservoirDispoINTiller');
              sample := refAttribute.GetCurrentSample();
              sample.date := date;
              sample.value := reservoirDispoINCulm;
              refAttribute.SetSample(sample);
              refAttributeOut := ((instance as TEntityInstance).GetTAttribute('supply') as TAttributeTableOut);
              sample := refAttributeOut.GetCurrentSample();
              sample.date := date;
              sample.value := supplyPlant;
              refAttributeOut.SetSample(sample);
              refAttributeOut := ((instance as TEntityInstance).GetTAttribute('surplus') as TAttributeTableOut);
              sample := refAttributeOut.GetCurrentSample();
              sample.date := date;
              sample.value := 0;
              refAttributeOut.SetSample(sample);
            end;
          end;
        end;
      end;
      supplyPlant := ((instance as TEntityInstance).GetTAttribute('supply') as TAttributeTableOut).getCurrentSample().value;
      SRwriteln('supplyPlant fin processus : ' + FloatToStr(supplyPlant));
      if (supplyPlant > 0) then
      begin
        SRwriteln('supplyPlant > 0 --> on reitere le processus');
        for i := 0 to le - 1 do
        begin
          currentInstance := (instance as TEntityInstance).GetTInstance(i);
          if (currentInstance is TEntityInstance) then
          begin
            currentEntityInstance := currentInstance as TEntityInstance;
            if (currentEntityInstance.GetCategory() = 'Tiller') then
            begin
              stateTiller := currentEntityInstance.GetCurrentState();
              SRwriteln('stateTiller ' + currentEntityInstance.GetName() + ' --> ' + IntToStr(stateTiller));
              if (stateTiller <> 10) then // la talle n'est pas à PRE_ELONG
              begin
                SRwriteln('----------------------------------------------------------');
                SRwriteln('|Tiller name --> ' + currentEntityInstance.getName());
                SRwriteln('----------------------------------------------------------');
                SRwriteln('| Variables en entree                                    |');
                SRwriteln('----------------------------------------------------------');
                supplyPlant := ((instance as TEntityInstance).GetTAttribute('supply') as TAttributeTableOut).GetSample(date).value;
                deficitCulm := currentEntityInstance.GetTAttribute('deficit_tiller').GetCurrentSample().value;
                stockINCulm := currentEntityInstance.GetTAttribute('stockINTiller').GetCurrentSample().value;
                stockLeafCulm := currentEntityInstance.GetTAttribute('stockLeafTiller').GetCurrentSample().value;
                reservoirDispoINCulm := currentEntityInstance.GetTAttribute('reservoirDispoINTiller').GetCurrentSample().value;
                maxReservoirDispoInternodeCulm := currentEntityInstance.GetTAttribute('maxReservoirDispoInternode').GetCurrentSample().value;
                reservoirDispoLeafCulm := currentEntityInstance.GetTAttribute('reservoirDispoLeafTiller').GetCurrentSample().value;
                maxReservoirDispoLeafCulm := currentEntityInstance.GetTAttribute('maxReservoirDispoLeaf').GetCurrentSample().value;
                SRwriteln('supplyPlant                    --> ' + FloatToStr(supplyPlant));
                SRwriteln('deficitCulm                    --> ' + FloatToStr(deficitCulm));
                SRwriteln('stockINCulm                    --> ' + FloatToStr(stockINCulm));
                SRwriteln('stockLeafCulm                  --> ' + FloatToStr(stockLeafCulm));
                SRwriteln('reservoirDispoINCulm           --> ' + FloatToStr(reservoirDispoINCulm));
                SRwriteln('maxReservoirDispoInternodeCulm --> ' + FloatToStr(maxReservoirDispoInternodeCulm));
                SRwriteln('reservoirDispoLeafCulm         --> ' + FloatToStr(reservoirDispoLeafCulm));
                SRwriteln('maxReservoirDispoLeafCulm      --> ' + FloatToStr(maxReservoirDispoLeafCulm));
                SRwriteln('----------------------------------------------------------');
                SRwriteln('| Calculs                                                |');
                SRwriteln('----------------------------------------------------------');
                deficitCulmOld := deficitCulm;
                deficitCulm := Min(0, deficitCulm + supplyPlant);
                supplyPlant := Max(0, supplyPlant + deficitCulmOld);
                stockINCulm := stockINCulm + Min(reservoirDispoINCulm, supplyPlant);
                tmpCulm3 := supplyPlant -  Min(reservoirDispoINCulm, supplyPlant);
                stockLeafCulm := stockLeafCulm + Min(reservoirDispoLeafCulm, tmpCulm3);
                supplyPlant := tmpCulm3 - Min(reservoirDispoLeafCulm, tmpCulm3);
                reservoirDispoINCulm := maxReservoirDispoInternodeCulm - stockINCulm;
                reservoirDispoLeafCulm := maxReservoirDispoLeafCulm - stockLeafCulm;
                //supplyPlant := supplyPlant - Min(reservoirDispoLeafCulm, supplyPlant);
                stockCulm := stockLeafCulm + stockINCulm;
                SRwriteln('deficitCulm                    --> ' + FloatToStr(deficitCulm));
                SRwriteln('stockINCulm                    --> ' + FloatToStr(stockINCulm));
                SRwriteln('tmpCulm3                       --> ' + FloatToStr(tmpCulm3));
                SRwriteln('reservoirDispoINCulm           --> ' + FloatToStr(reservoirDispoINCulm));
                SRwriteln('supplyPlant                    --> ' + FloatToStr(supplyPlant));
                SRwriteln('stockLeafCulm                  --> ' + FloatToStr(stockLeafCulm));
                SRwriteln('reservoirDispoLeafCulm         --> ' + FloatToStr(reservoirDispoLeafCulm));
                SRwriteln('supplyPlant                    --> ' + FloatToStr(supplyPlant));
                refAttribute := currentEntityInstance.GetTAttribute('stockINTiller');
                sample := refAttribute.GetSample(date);
                sample.date := date;
                sample.value := stockINCulm;
                refAttribute.SetSample(sample);
                refAttribute := currentEntityInstance.GetTAttribute('reservoirDispoINTiller');
                sample := refAttribute.GetSample(date);
                sample.date := date;
                sample.value := reservoirDispoINCulm;
                refAttribute.SetSample(sample);
                refAttribute := currentEntityInstance.GetTAttribute('stockLeafTiller');
                sample := refAttribute.GetSample(date);
                sample.date := date;
                sample.value := stockLeafCulm;
                refAttribute.SetSample(sample);
                refAttribute := currentEntityInstance.GetTAttribute('reservoirDispoLeafTiller');
                sample := refAttribute.GetSample(date);
                sample.date := date;
                sample.value := reservoirDispoLeafCulm;
                refAttribute.SetSample(sample);
                refAttribute := currentEntityInstance.GetTAttribute('stock_tiller');
                sample := refAttribute.GetSample(date);
                sample.date := date;
                sample.value := stockCulm;
                refAttribute.SetSample(sample);
                refAttribute := currentEntityInstance.GetTAttribute('deficit_tiller');
                sample := refAttribute.GetSample(date);
                sample.date := date;
                sample.value := deficitCulm;
                refAttribute.SetSample(sample);
                refAttributeOut := ((instance as TEntityInstance).GetTAttribute('supply') as TAttributeTableOut);
                sample := refAttributeOut.GetSample(date);
                sample.date := date;
                sample.value := supplyPlant;
                 refAttributeOut.SetSample(sample);
                refAttributeOut := ((instance as TEntityInstance).GetTAttribute('surplus') as TAttributeTableOut);
                sample := refAttributeOut.GetSample(date);
                sample.date := date;
                sample.value := supplyPlant;
                refAttributeOut.SetSample(sample);
              end;
            end;
          end;
        end;
      end;
    end;
  end
  else
  begin
    SRwriteln('Plante morte');
  end;
end;

procedure ComputeBalanceSheetAssimByAxisFromR_ng(var instance : TInstance);
var
  i, le, state, stateTiller : Integer;
  currentInstance : TInstance;
  currentEntityInstance : TEntityInstance;
  reservoirDispoINCulm, maxReservoirDispoInternodeCulm, stockINCulm : Double;
  demandOnCulmForGrowth, demandOfNonINCulm, demandINCulm, lastDemandCulm : Double;
  demandINStorageCulm, coeffStorageINActive : Double;
  remainToStoreOld : Double;
  sumOfDemandOnCulm : Double;
  supplyCulm, supplyPlant : Double;
  icCulm : Double;
  tmpCulm, stockLeafCulm, computedReallocBiomassLeafCulm : Double;
  tmpCulm2, coeffRemob : Double;
  remainToStoreCulm : Double;
  maxReservoirDispoLeafCulm : Double;
  reservoirDispoLeafCulm : Double;
  deficitCulm, deficitCulmOld, stockCulm : Double;
  phenoStage, boolCrossedPlasto, nbLeafStemElong, nbLeafPI, previousState : Double;
  plantLeafBiomass, culmLeafBiomass, stock : Double;
  refAttribute : TAttribute;
  refAttributeOut : TAttributeTableOut;
  sample : TSample;
  isFirstDayOfElong, isFirstDayOfPI : Boolean;
  tmpCulm3 : Double;
  surplus : Double;
  date : TDateTime;
begin
  state := (instance as TEntityInstance).GetCurrentState();
  SRwriteln('state meristem    --> ' + IntToStr(state));
  if (state <> 1000) then
  begin
    date := (instance as TEntityInstance).GetNextDate();
    phenoStage := ((instance as TEntityInstance).GetTAttribute('n') as TAttributeTableOut).GetCurrentSample().value;
    boolCrossedPlasto := (instance as TEntityInstance).GetTAttribute('boolCrossedPlasto').GetCurrentSample().value;
    nbLeafStemElong := (instance as TEntityInstance).GetTAttribute('nb_leaf_stem_elong').GetCurrentSample().value;
    nbLeafPI := (instance as TEntityInstance).GetTAttribute('nbleaf_pi').GetCurrentSample().value;
    previousState := (instance as TEntityInstance).GetTAttribute('previousState').GetCurrentSample().value;
    SRwriteln('phenoStage        --> ' + FloatToStr(phenoStage));
    SRwriteln('boolCrossedPlasto --> ' + FloatToStr(boolCrossedPlasto));
    SRwriteln('nbLeafStemElong   --> ' + FloatToStr(nbLeafStemElong));
    SRwriteln('nbLeafPI          --> ' + FloatToStr(nbLeafPI));
    SRwriteln('previousState     --> ' + FloatToStr(previousState));
    if ((phenoStage = nbLeafStemElong) and (boolCrossedPlasto > 0)) then
    begin
      isFirstDayOfElong := True;
      isFirstDayOfPI := False;
    end
    else if ((phenoStage = nbLeafPI) and (boolCrossedPlasto > 0) and (previousState <> 9)) then
    begin
      isFirstDayOfElong := False;
      isFirstDayOfPI := True;
    end
    else
    begin
      isFirstDayOfElong := False;
      isFirstDayOfPI := False;
    end;
    SRwriteln('isFirstDayOfElong --> ' + BoolToStr(isFirstDayOfElong));
    SRwriteln('isFirstDayOfPI    --> ' + BoolToStr(isFirstDayOfPI));
    if (state >= 4) then
    begin
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
            SRwriteln('stateTiller ' + currentEntityInstance.GetName() + ' --> ' + IntToStr(stateTiller));
            if (stateTiller <> 10) then // la talle n'est pas à PRE_ELONG
            begin
              SRwriteln('----------------------------------------------------------');
              SRwriteln('|Tiller name --> ' + currentEntityInstance.getName());
              SRwriteln('----------------------------------------------------------');
              SRwriteln('| Variables en entree                                    |');
              SRwriteln('----------------------------------------------------------');
              if (isFirstDayOfElong or isFirstDayOfPI) then
              begin
                SRwriteln('----------------------------------------------------------');
                SRwriteln('Premier jour, on initialise stockLeafCulm');
                SRwriteln('----------------------------------------------------------');
                plantLeafBiomass := (instance as TEntityInstance).GetTAttribute('biomLeafStruct').GetCurrentSample().value;
                culmLeafBiomass := currentEntityInstance.GetTAttribute('sumOfTillerLeafBiomass').GetCurrentSample().value;
                stock := ((instance as TEntityInstance).GetTAttribute('stock') as TAttributeTableOut).GetCurrentSample().value;
                stockLeafCulm := stock * (culmLeafBiomass / plantLeafBiomass);
                SRwriteln('plantLeafBiomass               --> ' + FloatToStr(plantLeafBiomass));
                SRwriteln('culmLeafBiomass                --> ' + FloatToStr(culmLeafBiomass));
                SRwriteln('stock                          --> ' + FloatToStr(stock));
                SRwriteln('stockLeafCulm                  --> ' + FloatToStr(stockLeafCulm));
                refAttribute := currentEntityInstance.GetTAttribute('stockLeafTiller');
                sample := refAttribute.GetCurrentSample();
                sample.value := stockLeafCulm;
                refAttribute.SetSample(sample);
                SRwriteln('----------------------------------------------------------');
              end;
              maxReservoirDispoInternodeCulm := currentEntityInstance.GetTAttribute('maxReservoirDispoInternode').GetCurrentSample().value;
              stockINCulm := currentEntityInstance.GetTAttribute('stockINTiller').GetCurrentSample().value;
              coeffStorageINActive := (instance as TEntityInstance).GetTAttribute('coeff_active_storage_IN').GetCurrentSample().value;
              demandOfNonINCulm := currentEntityInstance.GetTAttribute('demandOfNonINTiller').GetCurrentSample().value;
              demandINCulm := currentEntityInstance.GetTAttribute('sumOfTillerInternodeDemand').GetCurrentSample().value;
              lastDemandCulm := currentEntityInstance.GetTAttribute('last_demand_tiller').GetCurrentSample().value;
              supplyPlant := ((instance as TEntityInstance).GetTAttribute('supply') as TAttributeTableOut).GetCurrentSample().value;
              computedReallocBiomassLeafCulm := currentEntityInstance.GetTAttribute('sumOfDailyComputedReallocBiomassTiller').GetCurrentSample().value;
              stockLeafCulm := currentEntityInstance.GetTAttribute('stockLeafTiller').GetCurrentSample().value;
              coeffRemob := (instance as TEntityInstance).GetTAttribute('coeff_remob').GetCurrentSample().value;
              maxReservoirDispoLeafCulm := currentEntityInstance.GetTAttribute('maxReservoirDispoLeaf').GetCurrentSample().value;
              deficitCulm := currentEntityInstance.GetTAttribute('deficit_tiller').GetCurrentSample().value;
              SRwriteln('maxReservoirDispoInternodeCulm --> ' + FloatToStr(maxReservoirDispoInternodeCulm));
              SRwriteln('stockINCulm                    --> ' + FloatToStr(stockINCulm));
              SRwriteln('coeffStorageINActive           --> ' + FloatToStr(coeffStorageINActive));
              SRwriteln('demandOfNonINCulm              --> ' + FloatToStr(demandOfNonINCulm));
              SRwriteln('demandINCulm                   --> ' + FloatToStr(demandINCulm));
              SRwriteln('lastDemandCulm                 --> ' + FloatToStr(lastDemandCulm));
              SRwriteln('supplyPlant                    --> ' + FloatToStr(supplyPlant));
              SRwriteln('computedReallocBiomassLeafCulm --> ' + FloatToStr(computedReallocBiomassLeafCulm));
              SRwriteln('stockLeafCulm                  --> ' + FloatToStr(stockLeafCulm));
              SRwriteln('coeffRemob                     --> ' + FloatToStr(coeffRemob));
              SRwriteln('maxReservoirDispoLeafCulm      --> ' + FloatToStr(maxReservoirDispoLeafCulm));
              SRwriteln('deficitCulm                    --> ' + FloatToStr(deficitCulm));
              SRwriteln('----------------------------------------------------------');
              SRwriteln('| Calculs                                                |');
              SRwriteln('----------------------------------------------------------');
              reservoirDispoINCulm := maxReservoirDispoInternodeCulm - stockINCulm;
              demandOnCulmForGrowth := demandOfNonINCulm + demandINCulm + lastDemandCulm;
              demandINStorageCulm := reservoirDispoINCulm * coeffStorageINActive;
              sumOfDemandOnCulm := demandOnCulmForGrowth + demandINStorageCulm;
              //supplyCulm := Min(supplyPlant, sumOfDemandOnCulm);
              supplyCulm := currentEntityInstance.GetTAttribute('supply_tiller').GetCurrentSample().value;
              SRwriteln('supplyCulm from file --> ' + FloatToStr(supplyCulm));
              icCulm := Min(supplyCulm  / Max(sumOfDemandOnCulm, 0.00001), 5);
              tmpCulm := supplyCulm - sumOfDemandOnCulm + computedReallocBiomassLeafCulm + stockLeafCulm;
              tmpCulm2 := Max((1 - coeffRemob) * stockINCulm, Min(stockINCulm + reservoirDispoINCulm, stockINCulm + tmpCulm + deficitCulm + demandINStorageCulm));
              deficitCulmOld := deficitCulm;
              deficitCulm :=  Min(0, deficitCulm + tmpCulm + coeffRemob * stockINCulm + demandINStorageCulm);
              remainToStoreCulm := Max(0, tmpCulm + demandINStorageCulm - reservoirDispoINCulm + deficitCulmOld - deficitCulm);
              remainToStoreOld := remainToStoreCulm;
              stockINCulm := tmpCulm2;
              stockLeafCulm := Min(maxReservoirDispoLeafCulm, remainToStoreCulm);
              remainToStoreCulm := remainToStoreCulm - stockLeafCulm;
              reservoirDispoINCulm := maxReservoirDispoInternodeCulm - stockINCulm;
              reservoirDispoLeafCulm := maxReservoirDispoLeafCulm - stockLeafCulm;
              stockCulm := stockLeafCulm + stockINCulm;
              supplyPlant := supplyPlant - supplyCulm + remainToStoreCulm;
              SRwriteln('reservoirDispoINCulm           --> ' + FloatToStr(reservoirDispoINCulm));
              SRwriteln('demandOnCulmForGrowth          --> ' + FloatToStr(demandOnCulmForGrowth));
              SRwriteln('demandINStorageCulm            --> ' + FloatToStr(demandINStorageCulm));
              SRwriteln('sumOfDemandOnCulm              --> ' + FloatToStr(sumOfDemandOnCulm));
              SRwriteln('supplyCulm                     --> ' + FloatToStr(supplyCulm));
              SRwriteln('icCulm                         --> ' + FloatToStr(icCulm));
              SRwriteln('tmpCulm                        --> ' + FloatToStr(tmpCulm));
              SRwriteln('tmpCulm2                       --> ' + FloatToStr(tmpCulm2));
              SRwriteln('remainToStoreCulmOld           --> ' + FloatToStr(remainToStoreOld));
              SRwriteln('remainToStoreCulm              --> ' + FloatToStr(remainToStoreCulm));
              SRwriteln('stockINCulm                    --> ' + FloatToStr(stockINCulm));
              SRwriteln('stockLeafCulm                  --> ' + FloatToStr(stockLeafCulm));
              SRwriteln('reservoirDispoINCulm           --> ' + FloatToStr(reservoirDispoINCulm));
              SRwriteln('reservoirDispoLeafCulm         --> ' + FloatToStr(reservoirDispoLeafCulm));
              SRwriteln('deficitCulm                    --> ' + FloatToStr(deficitCulm));
              SRwriteln('stockCulm                      --> ' + FloatToStr(stockCulm));
              SRwriteln('new supplyPlant                --> ' + FloatToStr(supplyPlant));
              refAttribute := currentEntityInstance.GetTAttribute('tmp_tiller');
              sample := refAttribute.GetCurrentSample();
              sample.date := date;
              sample.value := tmpCulm;
              refAttribute.SetSample(sample);
              refAttribute := currentEntityInstance.GetTAttribute('supply_tiller');
              sample := refAttribute.GetCurrentSample();
              sample.date := date;
              sample.value := supplyCulm;
              refAttribute.SetSample(sample);
              refAttribute := currentEntityInstance.GetTAttribute('deficit_tiller');
              sample := refAttribute.GetCurrentSample();
              sample.date := date;
              sample.value := deficitCulm;
              refAttribute.SetSample(sample);
              refAttribute := currentEntityInstance.GetTAttribute('stock_tiller');
              sample := refAttribute.GetCurrentSample();
              sample.date := date;
              sample.value := stockCulm;
              refAttribute.SetSample(sample);
              refAttribute := currentEntityInstance.GetTAttribute('ic_tiller');
              sample := refAttribute.GetCurrentSample();
              sample.date := date;
              sample.value := icCulm;
              refAttribute.SetSample(sample);
              refAttribute := currentEntityInstance.GetTAttribute('stockINTiller');
              sample := refAttribute.GetCurrentSample();
              sample.date := date;
              sample.value := stockINCulm;
              refAttribute.SetSample(sample);
              refAttribute := currentEntityInstance.GetTAttribute('stockLeafTiller');
              sample := refAttribute.GetCurrentSample();
              sample.date := date;
              sample.value := stockLeafCulm;
              refAttribute.SetSample(sample);
              refAttribute := currentEntityInstance.GetTAttribute('reservoirDispoLeafTiller');
              sample := refAttribute.GetCurrentSample();
              sample.date := date;
              sample.value := reservoirDispoLeafCulm;
              refAttribute.SetSample(sample);
              refAttribute := currentEntityInstance.GetTAttribute('reservoirDispoINTiller');
              sample := refAttribute.GetCurrentSample();
              sample.date := date;
              sample.value := reservoirDispoINCulm;
              refAttribute.SetSample(sample);
              refAttributeOut := ((instance as TEntityInstance).GetTAttribute('supply') as TAttributeTableOut);
              sample := refAttributeOut.GetCurrentSample();
              sample.date := date;
              sample.value := supplyPlant;
              refAttributeOut.SetSample(sample);
              refAttributeOut := ((instance as TEntityInstance).GetTAttribute('surplus') as TAttributeTableOut);
              sample := refAttributeOut.GetCurrentSample();
              sample.date := date;
              sample.value := 0;
              refAttributeOut.SetSample(sample);
            end;
          end;
        end;
      end;
      supplyPlant := ((instance as TEntityInstance).GetTAttribute('supply') as TAttributeTableOut).getCurrentSample().value;
      SRwriteln('supplyPlant fin processus : ' + FloatToStr(supplyPlant));
      if (supplyPlant > 0) then
      begin
        SRwriteln('supplyPlant > 0 --> on reitere le processus');
        for i := 0 to le - 1 do
        begin
          currentInstance := (instance as TEntityInstance).GetTInstance(i);
          if (currentInstance is TEntityInstance) then
          begin
            currentEntityInstance := currentInstance as TEntityInstance;
            if (currentEntityInstance.GetCategory() = 'Tiller') then
            begin
              stateTiller := currentEntityInstance.GetCurrentState();
              SRwriteln('stateTiller ' + currentEntityInstance.GetName() + ' --> ' + IntToStr(stateTiller));
              if (stateTiller <> 10) then // la talle n'est pas à PRE_ELONG
              begin
                SRwriteln('----------------------------------------------------------');
                SRwriteln('|Tiller name --> ' + currentEntityInstance.getName());
                SRwriteln('----------------------------------------------------------');
                SRwriteln('| Variables en entree                                    |');
                SRwriteln('----------------------------------------------------------');
                supplyPlant := ((instance as TEntityInstance).GetTAttribute('supply') as TAttributeTableOut).GetSample(date).value;
                deficitCulm := currentEntityInstance.GetTAttribute('deficit_tiller').GetCurrentSample().value;
                stockINCulm := currentEntityInstance.GetTAttribute('stockINTiller').GetCurrentSample().value;
                stockLeafCulm := currentEntityInstance.GetTAttribute('stockLeafTiller').GetCurrentSample().value;
                reservoirDispoINCulm := currentEntityInstance.GetTAttribute('reservoirDispoINTiller').GetCurrentSample().value;
                maxReservoirDispoInternodeCulm := currentEntityInstance.GetTAttribute('maxReservoirDispoInternode').GetCurrentSample().value;
                reservoirDispoLeafCulm := currentEntityInstance.GetTAttribute('reservoirDispoLeafTiller').GetCurrentSample().value;
                maxReservoirDispoLeafCulm := currentEntityInstance.GetTAttribute('maxReservoirDispoLeaf').GetCurrentSample().value;
                SRwriteln('supplyPlant                    --> ' + FloatToStr(supplyPlant));
                SRwriteln('deficitCulm                    --> ' + FloatToStr(deficitCulm));
                SRwriteln('stockINCulm                    --> ' + FloatToStr(stockINCulm));
                SRwriteln('stockLeafCulm                  --> ' + FloatToStr(stockLeafCulm));
                SRwriteln('reservoirDispoINCulm           --> ' + FloatToStr(reservoirDispoINCulm));
                SRwriteln('maxReservoirDispoInternodeCulm --> ' + FloatToStr(maxReservoirDispoInternodeCulm));
                SRwriteln('reservoirDispoLeafCulm         --> ' + FloatToStr(reservoirDispoLeafCulm));
                SRwriteln('maxReservoirDispoLeafCulm      --> ' + FloatToStr(maxReservoirDispoLeafCulm));
                SRwriteln('----------------------------------------------------------');
                SRwriteln('| Calculs                                                |');
                SRwriteln('----------------------------------------------------------');
                deficitCulmOld := deficitCulm;
                deficitCulm := Min(0, deficitCulm + supplyPlant);
                supplyPlant := Max(0, supplyPlant + deficitCulmOld);
                stockINCulm := stockINCulm + Min(reservoirDispoINCulm, supplyPlant);
                tmpCulm3 := supplyPlant -  Min(reservoirDispoINCulm, supplyPlant);
                stockLeafCulm := stockLeafCulm + Min(reservoirDispoLeafCulm, tmpCulm3);
                supplyPlant := tmpCulm3 - Min(reservoirDispoLeafCulm, tmpCulm3);
                reservoirDispoINCulm := maxReservoirDispoInternodeCulm - stockINCulm;
                reservoirDispoLeafCulm := maxReservoirDispoLeafCulm - stockLeafCulm;
                //supplyPlant := supplyPlant - Min(reservoirDispoLeafCulm, supplyPlant);
                stockCulm := stockLeafCulm + stockINCulm;
                SRwriteln('deficitCulm                    --> ' + FloatToStr(deficitCulm));
                SRwriteln('stockINCulm                    --> ' + FloatToStr(stockINCulm));
                SRwriteln('tmpCulm3                       --> ' + FloatToStr(tmpCulm3));
                SRwriteln('reservoirDispoINCulm           --> ' + FloatToStr(reservoirDispoINCulm));
                SRwriteln('supplyPlant                    --> ' + FloatToStr(supplyPlant));
                SRwriteln('stockLeafCulm                  --> ' + FloatToStr(stockLeafCulm));
                SRwriteln('reservoirDispoLeafCulm         --> ' + FloatToStr(reservoirDispoLeafCulm));
                SRwriteln('supplyPlant                    --> ' + FloatToStr(supplyPlant));
                refAttribute := currentEntityInstance.GetTAttribute('stockINTiller');
                sample := refAttribute.GetSample(date);
                sample.date := date;
                sample.value := stockINCulm;
                refAttribute.SetSample(sample);
                refAttribute := currentEntityInstance.GetTAttribute('reservoirDispoINTiller');
                sample := refAttribute.GetSample(date);
                sample.date := date;
                sample.value := reservoirDispoINCulm;
                refAttribute.SetSample(sample);
                refAttribute := currentEntityInstance.GetTAttribute('stockLeafTiller');
                sample := refAttribute.GetSample(date);
                sample.date := date;
                sample.value := stockLeafCulm;
                refAttribute.SetSample(sample);
                refAttribute := currentEntityInstance.GetTAttribute('reservoirDispoLeafTiller');
                sample := refAttribute.GetSample(date);
                sample.date := date;
                sample.value := reservoirDispoLeafCulm;
                refAttribute.SetSample(sample);
                refAttribute := currentEntityInstance.GetTAttribute('stock_tiller');
                sample := refAttribute.GetSample(date);
                sample.date := date;
                sample.value := stockCulm;
                refAttribute.SetSample(sample);
                refAttribute := currentEntityInstance.GetTAttribute('deficit_tiller');
                sample := refAttribute.GetSample(date);
                sample.date := date;
                sample.value := deficitCulm;
                refAttribute.SetSample(sample);
                refAttributeOut := ((instance as TEntityInstance).GetTAttribute('supply') as TAttributeTableOut);
                sample := refAttributeOut.GetSample(date);
                sample.date := date;
                sample.value := supplyPlant;
                 refAttributeOut.SetSample(sample);
                refAttributeOut := ((instance as TEntityInstance).GetTAttribute('surplus') as TAttributeTableOut);
                sample := refAttributeOut.GetSample(date);
                sample.date := date;
                sample.value := supplyPlant;
                refAttributeOut.SetSample(sample);
              end;
            end;
          end;
        end;
      end;
    end;
  end
  else
  begin
    SRwriteln('Plante morte');
  end;
end;

procedure ComputeStockInternodeOnCulm_ng(var instance : TInstance);
var
  i, le, stateInternode : Integer;
  currentInstance : TInstance;
  sample : TSample;
  maximumReserveInInternode, biomassIN, sumOfBiomassOnInternodeInMatureState : Double;
  stockCulm, stockIN, sumOfStockINInMatureState : Double;
begin
  sumOfStockINInMatureState := 0;
  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      if ((currentInstance as TEntityInstance).GetCategory() = 'Internode') then
      begin
        stateInternode := (currentInstance as TEntityInstance).GetCurrentState();
        if (stateInternode = 4) then
        begin
          SRwriteln('IN : ' + currentInstance.GetName() + ' state 4');
          maximumReserveInInternode := (instance as TEntityInstance).GetTAttribute('maximumReserveInternode').GetCurrentSample().value;
          biomassIN := (currentInstance as TEntityInstance).GetTAttribute('biomassIN').GetCurrentSample().value;
          sumOfBiomassOnInternodeInMatureState := (instance as TEntityInstance).GetTAttribute('sumOfBiomassOnInternodeInMatureState').GetCurrentSample().value;
          stockCulm := (instance as TEntityInstance).GetTAttribute('stock_tiller').GetCurrentSample().value;
          stockIN := Min(maximumReserveInInternode * biomassIN, (biomassIN / sumOfBiomassOnInternodeInMatureState) * stockCulm);
          sumOfStockINInMatureState := sumOfStockINInMatureState + stockIN;
          sample := (currentInstance as TEntityInstance).GetTAttribute('stockIN').GetCurrentSample();
          sample.value := stockIN;
          (currentInstance as TEntityInstance).GetTAttribute('stockIN').SetSample(sample);
          SRwriteln('maximumReserveInInternode            --> ' + FloatToStr(maximumReserveInInternode));
          SRwriteln('biomassIN                            --> ' + FloatToStr(biomassIN));
          SRwriteln('sumOfBiomassOnInternodeInMatureState --> ' + FloatToStr(sumOfBiomassOnInternodeInMatureState));
          SRwriteln('stockTiller                          --> ' + FloatToStr(stockCulm));
          SRwriteln('stockIN                              --> ' + FloatToStr(stockIN));
          SRwriteln('sumOfStockINInMatureState            --> ' + FloatToStr(sumOfStockINInMatureState));
        end
        else if ((stateInternode = 2) or (stateInternode = 10)) then
        begin
          SRwriteln('IN : ' + currentInstance.GetName() + ' state 2');
          maximumReserveInInternode := (instance as TEntityInstance).GetTAttribute('maximumReserveInternode').GetCurrentSample().value;
          biomassIN := (currentInstance as TEntityInstance).GetTAttribute('biomassIN').GetCurrentSample().value;
          stockCulm := (instance as TEntityInstance).GetTAttribute('stock_tiller').GetCurrentSample().value;
          stockIN := Min(maximumReserveInInternode * biomassIN, stockCulm - sumOfStockINInMatureState);
          sample := (currentInstance as TEntityInstance).GetTAttribute('stockIN').GetCurrentSample();
          sample.value := stockIN;
          (currentInstance as TEntityInstance).GetTAttribute('stockIN').SetSample(sample);
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

procedure KillOldestLeafMorphoGenesis_ng(var instance : TInstance ; const realocationCoeff : Double; var deficit, stock, senesc_dw, deadleafNb, computedReallocBiomass : Double);
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
   state, state4 : Integer; // nombre de feuilles presentent sur le brin maitre, mais en state = 4 ou 5
   existLeafstate4_5 : Boolean;
   currentState : Integer;
   stateOldestLeaf : Integer;
   localComputedReallocBiomass, dailySenescDw : Double;
   isMainstem : Double;
begin
  state := (instance as TEntityInstance).GetCurrentState();
  if ((state <> 1) and (state < 4)) then
  begin
    SRwriteln('module actif, on est en morphogenese');
  end
  else
  begin
    SRwriteln('module inactif');
  end;
  if ((stock = 0) and (state <> 1) and (state < 4)) then
  begin
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
        // c'est une talle...
        if((currentInstance as TEntityInstance).GetCategory()='Tiller') then
        begin
          isMainstem := (currentInstance as TEntityInstance).GetTAttribute('isMainstem').GetCurrentSample().value;
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
                if ((isMainstem = 1) and (currentState <> 2000)) then
                begin
                  nbLeaf := nbLeaf + 1;
                end;
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

    SRwriteln('----------------------------------------------');
    SRwriteln('Ancienne valeur du stock                  --> ' + FloatToStr(stock));
    SRwriteln('Ancienne valeur de computedReallocBiomass --> ' + FloatToStr(computedReallocBiomass));
    SRwriteln('Ancienne valeur de senesc_dw              --> ' + FloatToStr(senesc_dw));
    SRwriteln('Deficit                                   --> ' + FloatToStr(deficit));
    SRwriteln('Biomasse de la feuille tuee               --> ' + FloatToStr(leafBiomass));
    SRwriteln('On recupere                               --> ' + FloatToStr(realocationCoeff * leafBiomass));

    localComputedReallocBiomass := realocationCoeff * leafBiomass;

    computedReallocBiomass := computedReallocBiomass  + localComputedReallocBiomass;

    stock := max(0, localComputedReallocBiomass + deficit);
    deficit := min(0, localComputedReallocBiomass + deficit);
    senesc_dw := senesc_dw + (leafBiomass - localComputedReallocBiomass);
    dailySenescDw := leafBiomass - localComputedReallocBiomass;
    deadleafNb := deadleafNb + 1;

    SRwriteln('----------------------------------------------');
    SRwriteln('dailySenescDw                             --> ' + FloatToStr(dailySenescDw));
    SRwriteln('Nouvelle valeur de computedReallocBiomass --> ' + FloatToStr(computedReallocBiomass));
    SRwriteln('Nouvelle valeur de senesc_dw              --> ' + FloatToStr(senesc_dw));
    SRwriteln('Nouvelle valeur du stock                  --> ' + FloatToStr(stock));
    SRwriteln('Nouvelle valeur du deficit                --> ' + FloatToStr(deficit));
    SRwriteln('computedReallocBiomass                    --> ' + FloatToStr(computedReallocBiomass));

    // cas particulier ou la plante est morte
    // (cad plus de feuille sur le brin maitre)
    // ----------------------------------------
    if (nbLeaf = 1) then // il ne restait qu une seule feuille avant destruction de celle-ci
    begin
      SRWriteln('PLANT IS DEAD !!!!!!!!!!');
      (instance as TEntityInstance).SetCurrentState(1000); // la plante passe a l etat morte
      (instance as TEntityInstance).GetTInstance('computeSLAplantAlive').SetActiveState(-1);
      (instance as TEntityInstance).GetTInstance('computeSLArealAlive').SetActiveState(-1);
    end;

    //nbLeaf := 0;
    existLeafstate4_5 := false;

    le := (instance as TEntityInstance).LengthTInstanceList();
    for i := 0 to le - 1 do
    begin
      currentInstance := (instance as TEntityInstance).GetTInstance(i);
      if (currentInstance is TEntityInstance) then
      begin
        if ((currentInstance as TEntityInstance).GetCategory() = 'Tiller') then
        begin
          le2 := (currentInstance as TEntityInstance).LengthTInstanceList();
          for i2 := 0 to le2 - 1 do
          begin
            currentInstanceOnTiller := (currentInstance as TEntityInstance).GetTInstance(i2);
            if (currentInstanceOnTiller is TEntityInstance) then
            begin
              if ((currentInstanceOnTiller as TEntityInstance).GetCategory() = 'Leaf') then
              begin
                state4 := (currentInstanceOnTiller as TEntityInstance).GetCurrentState();
                if (state4 = 4) or (state4 = 5) then
                begin
                  existLeafstate4_5 := true;
                end;
              end;
            end;
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
end;

procedure KillOldestLeafTiller_ng(var instance : TInstance ; var deficit, stock, activeLeafNb, leafNb : Double);
var
  refMeristem, currentInstance : TInstance;
  statePlant, stateLeaf, stateOldestLeaf : Integer;
  i, le : Integer;
  oldestCreationDate, currentCreationDate : TDateTime;
  refOldestLeaf : TInstance;
  leafBiomass, localComputedReallocBiomass, dailySenescDw, realocationCoeff : Double;
  refDeadLeafNbAttribute, refLeafNbAttribute : TAttributeTableOut;
  refDailyComputedReallocBiomassAttribute, refDailySenescedLeafBiomass : TAttribute;
  refSenescDwAttribute : TAttributeTableOut;
  sample : TSample;
begin
  SRwriteln('deficit + stock --> ' + FloatToStr(deficit + stock));
  if (deficit + stock <= 0) then
  begin
    refMeristem := instance.GetFather();
    while (refMeristem.GetName() <> 'EntityMeristem') do
    begin
      refMeristem := refMeristem.GetFather();
    end;
    statePlant := (refMeristem as TEntityInstance).GetCurrentState();
    SRwriteln('statePlant --> ' + IntToStr(statePlant));
    if (statePlant >= 4) then
    begin
      oldestCreationDate := MAX_DATE;
      refOldestLeaf := nil;
      le := (instance as TEntityInstance).LengthTInstanceList();
      for i := 0 to le - 1 do
      begin
        currentInstance := (instance as TEntityInstance).GetTInstance(i);
        if (currentInstance is TEntityInstance) then
        begin
          if ((currentInstance as TEntityInstance).GetCategory() = 'Leaf') then
          begin
            currentCreationDate := (currentInstance as TEntityInstance).GetCreationDate();
            stateLeaf := (currentInstance as TEntityInstance).GetCurrentState();
            SRwriteln('stateLeaf --> ' + IntToStr(stateLeaf));
            if ((currentCreationDate < oldestCreationDate) and (stateLeaf <> 2000)) then
            begin
              refOldestLeaf := currentInstance;
              oldestCreationDate := currentCreationDate;
            end;
          end;
        end;
      end;
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
      (instance as TEntityInstance).RemoveTInstance(refOldestLeaf);

      // re alocation de la biomasse
      // ---------------------------

      realocationCoeff := (refMeristem as TEntityInstance).GetTAttribute('realocationCoeff').GetCurrentSample().value;

      SRwriteln('----------------------------------------------');
      SRwriteln('Ancienne valeur du stock    --> ' + FloatToStr(stock));
      SRwriteln('Deficit                     --> ' + FloatToStr(deficit));
      SRwriteln('Biomasse de la feuille tuee --> ' + FloatToStr(leafBiomass));
      SRwriteln('dailyComputedReallocBiomass --> ' + FloatToStr(realocationCoeff * leafBiomass));


      localComputedReallocBiomass := realocationCoeff * leafBiomass;

      refDailyComputedReallocBiomassAttribute := (instance as TEntityInstance).GetTAttribute('dailyComputedReallocBiomass');
      sample := refDailyComputedReallocBiomassAttribute.GetCurrentSample();
      sample.value := localComputedReallocBiomass;
      refDailyComputedReallocBiomassAttribute.SetSample(sample);

      dailySenescDw := leafBiomass - localComputedReallocBiomass;

      SRwriteln('dailySenescDw               --> ' + FloatToStr(dailySenescDw));

      refDailySenescedLeafBiomass := (instance as TEntityInstance).GetTAttribute('dailySenescedLeafBiomass');
      sample := refDailySenescedLeafBiomass.GetCurrentSample();
      sample.value := dailySenescDw;
      refDailySenescedLeafBiomass.SetSample(sample);

      refDeadLeafNbAttribute := (refMeristem as TEntityInstance).GetTAttribute('deadleafNb') as TAttributeTableOut;
      sample := refDeadLeafNbAttribute.GetCurrentSample();
      sample.value := sample.value + 1;
      refDeadLeafNbAttribute.SetSample(sample);

      refLeafNbAttribute := (refMeristem as TEntityInstance).GetTAttribute('leafNb') as TAttributeTableOut;
      sample := refLeafNbAttribute.GetCurrentSample();
      sample.value := sample.value - 1;
      refLeafNbAttribute.SetSample(sample);

      refSenescDwAttribute := (refMeristem as TEntityInstance).GetTAttribute('senesc_dw') as TAttributeTableOut;
      sample := refSenescDwAttribute.GetCurrentSample();
      sample.value := sample.value + dailySenescDw;
      refSenescDwAttribute.SetSample(sample);
    end;
  end
  else
  begin
    refDailyComputedReallocBiomassAttribute := (instance as TEntityInstance).GetTAttribute('dailyComputedReallocBiomass');
    sample := refDailyComputedReallocBiomassAttribute.GetCurrentSample();
    sample.value := 0;
    refDailyComputedReallocBiomassAttribute.SetSample(sample);

    refDailySenescedLeafBiomass := (instance as TEntityInstance).GetTAttribute('dailySenescedLeafBiomass');
    sample := refDailySenescedLeafBiomass.GetCurrentSample();
    sample.value := 0;
    refDailySenescedLeafBiomass.SetSample(sample);
  end;
end;

procedure SumOfDailyComputedReallocBiomassOnCulm_ng(var instance : TInstance; var sumOfDailyComputedReallocBiomass : Double);
var
  i, le, leafState : Integer;
  currentInstance : TInstance;
  dailyComputedReallocBiomass : Double;
begin
  dailyComputedReallocBiomass := (instance as TEntityInstance).GetTAttribute('dailyComputedReallocBiomass').GetCurrentSample().value;
  SRwriteln('dailyComputedReallocBiomass --> ' + FloatToStr(dailyComputedReallocBiomass));
  sumOfDailyComputedReallocBiomass := dailyComputedReallocBiomass;
  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      if ((currentInstance as TEntityInstance).GetCategory() = 'Leaf') then
      begin
        leafState := (currentInstance as TEntityInstance).GetCurrentState();
        if ((leafState = 4) or (leafState = 5) or (leafState = 500)) then
        begin
          dailyComputedReallocBiomass := (currentInstance as TEntityInstance).GetTAttribute('dailyComputedReallocBiomass').GetCurrentSample().value;
          SRwriteln((currentInstance as TEntityInstance).GetName() + ' dailyComputedReallocBiomass --> ' + FloatToStr(dailyComputedReallocBiomass));
          sumOfDailyComputedReallocBiomass := sumOfDailyComputedReallocBiomass + dailyComputedReallocBiomass;
          SRwriteln('sumOfDailyComputedReallocBiomass --> ' + FloatToStr(sumOfDailyComputedReallocBiomass));
        end;
      end;
    end;
  end;
end;

procedure SumOfDailySenescedLeafBiomassOnCulm_ng(var instance : TInstance; var sumOfDailySenescedLeafBiomass : Double);
var
  i, le, leafState : Integer;
  currentInstance : TInstance;
  dailySenescedLeafBiomass : Double;
begin
  dailySenescedLeafBiomass := (instance as TEntityInstance).GetTAttribute('dailySenescedLeafBiomass').GetCurrentSample().value;
  SRwriteln('dailySenescedLeafBiomass --> ' + FloatToStr(dailySenescedLeafBiomass));
  sumOfDailySenescedLeafBiomass := dailySenescedLeafBiomass;
  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      if ((currentInstance as TEntityInstance).GetCategory() = 'Leaf') then
      begin
        leafState := (currentInstance as TEntityInstance).GetCurrentState();
        if ((leafState = 4) or (leafState = 5) or (leafState = 500)) then
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

procedure KillTillerWithoutLigulatedLeaf_ng(var instance : TInstance; var nbTiller : Double);
var
  i1, i2, le1, le2, leafState, state, nbTillerToBeRemoved, index, lengthTab : Integer;
  currentInstance1, currentInstance2, refTiller : TInstance;
  isMainstem, nbLigulatedLeaf, totalTillerLeafBiomass, sumOfTillerLeafBiomass : Double;
  totalTillerInternodeBiomass, sumOfTillerInternodeBiomass : Double;
  reallocationCoeff, totalBiomass, computedReallocBiomass : Double;
  sumOfDailySenescedLeafBiomassTiller, totalDailySenescedLeafBiomassTiller : Double;
  sumOfDailyComputedReallocBiomassTiller, totalDailyComputedReallocBiomassTiller : Double;
  deficitTiller, totalDeficitTiller : Double;
  stockTiller, totalStockTiller : Double;
  totalComputedReallocBiomass : Double;
  dead : Boolean;
  arrayOfTillerToBeRemoved : Array of TEntityInstance;
  refSenescDwAttribute : TAttributeTableOut;
  refDeadTillerComputedReallocBiomass : TAttribute;
  sample : TSample;
begin
  state := (instance as TEntityInstance).GetCurrentState();
  if (state >= 4) then
  begin
    reallocationCoeff := (instance as TEntityInstance).GetTAttribute('realocationCoeff').GetCurrentSample().value;
    nbTillerToBeRemoved := 0;
    SetLength(arrayOfTillerToBeRemoved, nbTillerToBeRemoved);
    dead := false;
    le1 := (instance as TEntityInstance).LengthTInstanceList();
    for i1 := 0 to le1 - 1 do
    begin
      nbLigulatedLeaf := 0;
      currentInstance1 := (instance as TEntityInstance).GetTInstance(i1);
      if (currentInstance1 is TEntityInstance) then
      begin
        if ((currentInstance1 as TEntityInstance).GetCategory() = 'Tiller') then
        begin
          SRwriteln('Tiller name     --> ' + currentInstance1.GetName());
          isMainstem := (currentInstance1 as TEntityInstance).GetTAttribute('isMainstem').GetCurrentSample().value;
          SRwriteln('isMainstem      --> ' + FloatToStr(isMainstem));
          le2 := (currentInstance1 as TEntityInstance).LengthTInstanceList();
          for i2 := 0 to le2 - 1 do
          begin
            currentInstance2 := (currentInstance1 as TEntityInstance).GetTInstance(i2);
            if (currentInstance2 is TEntityInstance) then
            begin
              if ((currentInstance2 as TEntityInstance).GetCategory() = 'Leaf') then
              begin
                leafState := (currentInstance2 as TEntityInstance).GetCurrentState();
                SRwriteln('Feuille : ' + currentInstance2.GetName() + ' state : ' + IntToStr(leafState));
                if ((leafState = 4) or (leafState = 5)) then
                begin
                  nbLigulatedLeaf := nbLigulatedLeaf + 1;
                end;
              end;
            end;
          end;
          SRwriteln('nbLigulatedLeaf --> ' + FloatToStr(nbLigulatedLeaf));
          if (nbLigulatedLeaf = 0) then
          begin
            if (isMainstem = 1) then
            begin
              dead := True;
              SRwriteln('Plus de feuille ligulee sur le brin maitre, la plante est morte');
            end
            else
            begin
              nbTillerToBeRemoved := nbTillerToBeRemoved + 1;
              SetLength(arrayOfTillerToBeRemoved, nbTillerToBeRemoved);
              arrayOfTillerToBeRemoved[nbTillerToBeRemoved - 1] := currentInstance1 as TEntityInstance;
              SRwriteln('On stocke : ' + currentInstance1.GetName() + ' pour destruction');
            end;
          end;
        end;
      end;
    end;
    if (dead) then
    begin
      (instance as TEntityInstance).SetCurrentState(1000);
      (instance as TEntityInstance).GetTInstance('computeSLAplantAlive').SetActiveState(-1);
      (instance as TEntityInstance).GetTInstance('computeSLArealAlive').SetActiveState(-1);
    end;
    lengthTab := High(arrayOfTillerToBeRemoved);
    totalTillerLeafBiomass := 0;
    totalTillerInternodeBiomass := 0;
    totalDailySenescedLeafBiomassTiller := 0;
    totalDailyComputedReallocBiomassTiller:= 0;
    totalDeficitTiller := 0;
    totalStockTiller := 0;
    for index := 0 to lengthTab do
    begin
      refTiller := arrayOfTillerToBeRemoved[index];
      SRwriteln('On supprime : ' + refTiller.GetName());
      sumOfDailyComputedReallocBiomassTiller := (refTiller as TEntityInstance).GetTAttribute('sumOfDailyComputedReallocBiomassTiller').GetCurrentSample().value;
      //sumOfDailySenescedLeafBiomassTiller := (refTiller as TEntityInstance).GetTAttribute('sumOfDailySenescedLeafBiomassTiller').GetCurrentSample().value;
      sumOfTillerLeafBiomass := (refTiller as TEntityInstance).GetTAttribute('sumOfTillerLeafBiomass').GetCurrentSample().value;
      sumOfTillerInternodeBiomass := (refTiller as TEntityInstance).GetTAttribute('sumOfInternodeBiomass').GetCurrentSample().value;
      deficitTiller := (refTiller as TEntityInstance).GetTAttribute('deficit_tiller').GetCurrentSample().value;
      stockTiller := (refTiller as TEntityInstance).GetTAttribute('stock_tiller').GetCurrentSample().value;
      totalDailyComputedReallocBiomassTiller := totalDailyComputedReallocBiomassTiller + sumOfDailyComputedReallocBiomassTiller;
      //totalDailySenescedLeafBiomassTiller := totalDailySenescedLeafBiomassTiller + sumOfDailySenescedLeafBiomassTiller;
      totalTillerLeafBiomass := totalTillerLeafBiomass + sumOfTillerLeafBiomass;
      totalTillerInternodeBiomass := totalTillerInternodeBiomass + sumOfTillerInternodeBiomass;
      totalDeficitTiller := totalDeficitTiller + deficitTiller;
      totalStockTiller := totalStockTiller + stockTiller;
      SRwriteln('sumOfDailyComputedReallocBiomassTiller --> ' + FloatToStr(sumOfDailyComputedReallocBiomassTiller));
      //SRwriteln('sumOfDailySenescedLeafBiomassTiller    --> ' + FloatToStr(sumOfDailySenescedLeafBiomassTiller));
      SRwriteln('sumOfTillerLeafBiomass                 --> ' + FloatToStr(sumOfTillerLeafBiomass));
      SRwriteln('sumOfTillerInternodeBiomass            --> ' + FloatToStr(sumOfTillerInternodeBiomass));
      SRwriteln('deficitTiller                          --> ' + FloatToStr(deficitTiller));
      SRwriteln('stockTiller                            --> ' + FloatToStr(stockTiller));
      SRwriteln('totalDailyComputedReallocBiomassTiller --> ' + FloatToStr(totalDailyComputedReallocBiomassTiller));
      //SRwriteln('totalDailySenescedLeafBiomassTiller    --> ' + FloatToStr(totalDailySenescedLeafBiomassTiller));
      SRwriteln('totalTillerLeafBiomass                 --> ' + FloatToStr(totalTillerLeafBiomass));
      SRwriteln('totalTillerInternodeBiomass            --> ' + FloatToStr(totalTillerInternodeBiomass));
      SRwriteln('totalDeficitTiller                     --> ' + FloatToStr(totalDeficitTiller));
      SRwriteln('totalStockTiller                       --> ' + FloatToStr(totalStockTiller));
      (instance as TEntityInstance).RemoveTInstance(refTiller);
    end;
    totalBiomass := totalTillerLeafBiomass + totalTillerInternodeBiomass;
    SRwriteln('totalBiomass                             --> ' + FloatToStr(totalBiomass));
    computedReallocBiomass := reallocationCoeff * totalBiomass;
    SRwriteln('computedReallocBiomass                   --> ' + FloatToStr(computedReallocBiomass + totalDailyComputedReallocBiomassTiller));
    totalComputedReallocBiomass := computedReallocBiomass + totalDailyComputedReallocBiomassTiller + totalDeficitTiller + totalStockTiller;
    SRwriteln('totalComputedReallocBiomass              --> ' + FloatToStr(totalComputedReallocBiomass));
    //SRwriteln('dailySenesc                              --> ' + FloatToStr(totalBiomass - computedReallocBiomass + totalDailySenescedLeafBiomassTiller));
    SRwriteln('dailySenesc                              --> ' + FloatToStr(totalBiomass - computedReallocBiomass));
    refSenescDwAttribute := (instance as TEntityInstance).GetTAttribute('senesc_dw') as TAttributeTableOut;
    sample := refSenescDwAttribute.GetCurrentSample();
    //sample.value := sample.value + (totalBiomass - computedReallocBiomass) + totalDailySenescedLeafBiomassTiller;
    sample.value := sample.value + (totalBiomass - computedReallocBiomass);
    SRwriteln('senesc_dw                                --> ' + FloatToStr(sample.value));
    refSenescDwAttribute.SetSample(sample);
    refDeadTillerComputedReallocBiomass := (instance as TEntityInstance).GetTAttribute('deadTillerComputedReallocBiomass');
    sample := refDeadTillerComputedReallocBiomass.GetCurrentSample();
    sample.value := totalComputedReallocBiomass;
    refDeadTillerComputedReallocBiomass.SetSample(sample);
    SRwriteln('deadTillerComputedReallocBiomass         --> ' + FloatToStr(sample.value));
  end
  else
  begin
    refDeadTillerComputedReallocBiomass := (instance as TEntityInstance).GetTAttribute('deadTillerComputedReallocBiomass');
    sample := refDeadTillerComputedReallocBiomass.GetCurrentSample();
    sample.value := 0;
    refDeadTillerComputedReallocBiomass.SetSample(sample);
  end;
end;

procedure ComputeDayDemand_ng(var instance : TInstance; var dayDemand : Double);
var
  le1, i1, le2, i2, statePlant : Integer;
  demand, demands, lastDemand, lastDemands : Double;
  stockCulm : Double;
  currentInstance1, currentInstance2 : TInstance;
begin
  demands := 0;
  lastDemands := 0;
  statePlant := (instance as TEntityInstance).GetCurrentState();
  SRwriteln('state plant --> ' + IntToStr(statePlant));
  if ((statePlant = 4) or (statePlant = 5) or (statePlant = 6) or (statePlant = 9) or (statePlant = 12) or (statePlant = 14)) then
  begin
    le1 := (instance as TEntityInstance).LengthTInstanceList();
    for i1 := 0 to le1 - 1 do
    begin
      currentInstance1 := (instance as TEntityInstance).GetTInstance(i1);
      if (currentInstance1 is TEntityInstance) then
      begin
        if ((currentInstance1 as TEntityInstance).GetCategory() = 'Tiller') then
        begin
          stockCulm := (currentInstance1 as TEntityInstance).GetTAttribute('stock_tiller').GetCurrentSample().value;
          if (stockCulm > 0) then
          begin
            le2 := (currentInstance1 as TEntityInstance).LengthTInstanceList();
            for i2 := 0 to le2 - 1 do
            begin
              currentInstance2 := (currentInstance1 as TEntityInstance).GetTInstance(i2);
              if (currentInstance2 is TEntityInstance) then
              begin
                if ((currentInstance2 as TEntityInstance).GetCategory() = 'Leaf') then
                begin
                  demand := (currentInstance2 as TEntityInstance).GetTAttribute('demand').GetCurrentSample().value;
                  demands := demands + demand;
                  lastDemand := (currentInstance2 as TEntityInstance).GetTAttribute('lastdemand').GetCurrentSample().value;
                  lastDemands := lastDemands + lastDemand;
                  SRwriteln('demand de ' + currentInstance2.GetName() + ' --> ' + FloatToStr(demand));
                  SRwriteln('demands     --> ' + FloatToStr(demands));
                  SRwriteln('lastdemand de ' + currentInstance2.GetName() + ' --> ' + FloatToStr(lastDemand));
                  SRwriteln('lastdemands --> ' + FloatToStr(lastDemands));
                end
                else if ((currentInstance2 as TEntityInstance).GetCategory() = 'Internode') then
                begin
                  demand := (currentInstance2 as TEntityInstance).GetTAttribute('demandIN').GetCurrentSample().value;
                  demands := demands + demand;
                  lastDemand := (currentInstance2 as TEntityInstance).GetTAttribute('lastdemand').GetCurrentSample().value;
                  lastDemands := lastDemands + lastDemand;
                  SRwriteln('demand de ' + currentInstance2.GetName() + ' --> ' + FloatToStr(demand));
                  SRwriteln('demands     --> ' + FloatToStr(demands));
                  SRwriteln('lastdemand de ' + currentInstance2.GetName() + ' --> ' + FloatToStr(lastDemand));
                  SRwriteln('lastdemands --> ' + FloatToStr(lastDemands));
                end
                else if ((currentInstance2 as TEntityInstance).GetCategory() = 'Panicle') then
                begin
                  demand := (currentInstance2 as TEntityInstance).GetTAttribute('day_demand_panicle').GetCurrentSample().value;
                  demands := demands + demand;
                  SRwriteln('demand de ' + currentInstance2.GetName() + ' --> ' + FloatToStr(demand));
                  SRwriteln('demands     --> ' + FloatToStr(demands));
                end
                else if ((currentInstance2 as TEntityInstance).GetCategory() = 'Peduncle') then
                begin
                  demand := (currentInstance2 as TEntityInstance).GetTAttribute('demandIN').GetCurrentSample().value;
                  demands := demands + demand;
                  lastDemand := (currentInstance2 as TEntityInstance).GetTAttribute('lastdemand').GetCurrentSample().value;
                  lastDemands := lastDemands + lastDemand;
                  SRwriteln('demand de ' + currentInstance2.GetName() + ' --> ' + FloatToStr(demand));
                  SRwriteln('demands     --> ' + FloatToStr(demands));
                  SRwriteln('lastdemand de ' + currentInstance2.GetName() + ' --> ' + FloatToStr(lastDemand));
                  SRwriteln('lastdemands --> ' + FloatToStr(lastDemands));
                end;
              end;
            end;
          end;
        end
        else if ((currentInstance1 as TEntityInstance).GetCategory() = 'Root') then
        begin
          le2 := (currentInstance1 as TEntityInstance).LengthTInstanceList();
          for i2 := 0 to le2 - 1 do
          begin
            currentInstance2 := (currentInstance1 as TEntityInstance).GetTInstance(i2);
            if (currentInstance2 is TEntityInstance) then
            begin
              demand := (currentInstance2 as TEntityInstance).GetTAttribute('demand').GetCurrentSample().value;
              demands := demands + demand;
              SRwriteln('demand de ' + currentInstance2.GetName() + ' --> ' + FloatToStr(demand));
              SRwriteln('demands     --> ' + FloatToStr(demands));
            end;
          end;
        end;
      end;
    end;
    dayDemand := demands + lastDemands;
    SRwriteln('dayDemand --> ' + FloatToStr(dayDemand));
  end
  else if ((statePlant = 7) or (statePlant = 8) or (statePlant = 10) or (statePlant = 11) or (statePlant = 13) or (statePlant = 15)) then
  begin
    dayDemand := 0;
    SRwriteln('dayDemand --> ' + FloatToStr(dayDemand));
  end
  else
  begin
    dayDemand := dayDemand;
    SRwriteln('dayDemand --> ' + FloatToStr(dayDemand));
  end;
end;

procedure LeafTransitionToActive_ng(var instance : TInstance);
var
  stock, deficit, diff, boolCrossedPlasto, nbDayOfSimulation : Double;
  stateTiller, statePlant, organState: Integer;
  phenoStageAtCreation, currentPhenoStage, organRank : Double;
  refMeristem, refTiller : TInstance;
  Lef1, MGR, plasto, ligulo, WLR, LL_BL, allo_area : Double;
  G_L, Tb, resp_LER, coeffLifespan, mu, leaf_stock_max : Double;
  sample : TSample;
  date : TDateTime;
begin
  organState := (instance as TEntityInstance).GetCurrentState();
  organRank := (instance as TEntityInstance).GetTAttribute('rank').GetCurrentSample().value;
  refMeristem := instance.GetFather();
  while (refMeristem.GetName() <> 'EntityMeristem') do
  begin
    refMeristem := refMeristem.GetFather();
  end;
  refTiller := instance.GetFather();
  while ((refTiller as TEntityInstance).GetCategory() <> 'Tiller') do
  begin
    refTiller := refTiller.GetFather();
  end;
  statePlant := (refMeristem as TEntityInstance).GetCurrentState();
  if (statePlant < 4) then
  begin
    stock := ((refMeristem as TEntityInstance).GetTAttribute('stock') as TAttributeTableOut).GetCurrentSample().value;
    deficit := ((refMeristem as TEntityInstance).GetTAttribute('deficit') as TAttributeTableOut).GetCurrentSample().value;
  end
  else
  begin
    stock := (refTiller as TEntityInstance).GetTAttribute('stock_tiller').GetCurrentSample().value;
    deficit := (refTiller as TEntityInstance).GetTAttribute('deficit_tiller').GetCurrentSample().value;
  end;
  phenoStageAtCreation := (refTiller as TEntityInstance).GetTAttribute('phenoStageAtCreation').GetCurrentSample().value;
  stateTiller := (refTiller as TEntityInstance).GetCurrentState();
  diff := Max(0, stock + deficit);
  boolCrossedPlasto := (refMeristem as TEntityInstance).GetTAttribute('boolCrossedPlasto').GetCurrentSample().value;
  nbDayOfSimulation := (refMeristem as TEntityInstance).GetTAttribute('nbDayOfSimulation').GetCurrentSample().value;
  currentPhenoStage := ((refMeristem as TEntityInstance).GetTAttribute('n') as TAttributeTableOut).GetCurrentSample().value;
  SRwriteln('organState           --> ' + IntToStr(organState));
  SRwriteln('organRank            --> ' + FloatToStr(organRank));
  SRwriteln('stateTiller          --> ' + IntToStr(stateTiller));
  SRwriteln('phenoStageAtCreation --> ' + FloatToStr(phenoStageAtCreation));
  SRwriteln('stock                --> ' + FloatToStr(stock));
  SRwriteln('deficit              --> ' + FloatToStr(deficit));
  SRwriteln('diff                 --> ' + FloatToStr(diff));
  SRwriteln('statePlant           --> ' + IntToStr(statePlant));
  SRwriteln('boolCrossedPlasto    --> ' + FloatToStr(boolCrossedPlasto));
  SRwriteln('nbDayOfSimulation    --> ' + FloatToStr(nbDayOfSimulation));
  SRwriteln('currentPhenoStage    --> ' + FloatToStr(currentPhenoStage));
  date := (refMeristem as TEntityInstance).GetNextDate();
  if (nbDayOfSimulation = 1) and ((currentPhenoStage - phenoStageAtCreation) + 1 = organRank) then
  begin
    (instance as TEntityInstance).SetCurrentState(1);
    SRwriteln('LeafTransitionToActive_ng currentState --> ' + IntToStr(1));
  end
  else
  begin
    if ((boolCrossedPlasto > 0) and ((currentPhenoStage - phenoStageAtCreation) + 1 = organRank)) then
    begin
      if ((diff > 0) and (organState = 2000)) then
      begin
        Lef1 := (refMeristem as TEntityInstance).GetTAttribute('Lef1').GetCurrentSample().value;
        MGR := (refMeristem as TEntityInstance).GetTAttribute('MGR').GetCurrentSample().value;
        plasto := (refMeristem as TEntityInstance).GetTAttribute('plasto').GetCurrentSample().value;
        ligulo := (refMeristem as TEntityInstance).GetTAttribute('ligulo').GetCurrentSample().value;
        WLR := (refMeristem as TEntityInstance).GetTAttribute('WLR').GetCurrentSample().value;
        LL_BL := (refMeristem as TEntityInstance).GetTAttribute('LL_BL').GetCurrentSample().value;
        allo_area := (refMeristem as TEntityInstance).GetTAttribute('allo_area').GetCurrentSample().value;
        G_L :=(refMeristem as TEntityInstance).GetTAttribute('G_L').GetCurrentSample().value;
        Tb := (refMeristem as TEntityInstance).GetTAttribute('Tb').GetCurrentSample().value;
        resp_LER := (refMeristem as TEntityInstance).GetTAttribute('resp_LER').GetCurrentSample().value;
        coeffLifespan := (refMeristem as TEntityInstance).GetTAttribute('coeff_lifespan').GetCurrentSample().value;
        mu := (refMeristem as TEntityInstance).GetTAttribute('mu').GetCurrentSample().value;
        leaf_stock_max := (refMeristem as TEntityInstance).GetTAttribute('leaf_stock_max').GetCurrentSample().value;
        sample := (instance as TEntityInstance).GetTAttribute('Lef1').GetSample(date);
        sample.value := Lef1;
        (instance as TEntityInstance).GetTAttribute('Lef1').SetSample(sample);
        sample := (instance as TEntityInstance).GetTAttribute('MGR').GetSample(date);
        sample.value := MGR;
        (instance as TEntityInstance).GetTAttribute('MGR').SetSample(sample);
        sample := (instance as TEntityInstance).GetTAttribute('plasto').GetSample(date);
        sample.value := plasto;
        (instance as TEntityInstance).GetTAttribute('plasto').SetSample(sample);
        sample := (instance as TEntityInstance).GetTAttribute('ligulo').GetSample(date);
        sample.value := ligulo;
        (instance as TEntityInstance).GetTAttribute('ligulo').SetSample(sample);
        sample := (instance as TEntityInstance).GetTAttribute('WLR').GetSample(date);
        sample.value := WLR;
        (instance as TEntityInstance).GetTAttribute('WLR').SetSample(sample);
        sample := (instance as TEntityInstance).GetTAttribute('allo_area').GetSample(date);
        sample.value := allo_area;
        (instance as TEntityInstance).GetTAttribute('allo_area').SetSample(sample);
        sample := (instance as TEntityInstance).GetTAttribute('G_L').GetSample(date);
        sample.value := G_L;
        (instance as TEntityInstance).GetTAttribute('G_L').SetSample(sample);
        sample := (instance as TEntityInstance).GetTAttribute('Tb').GetSample(date);
        sample.value := Tb;
        (instance as TEntityInstance).GetTAttribute('Tb').SetSample(sample);
        sample := (instance as TEntityInstance).GetTAttribute('resp_LER').GetSample(date);
        sample.value := resp_LER;
        (instance as TEntityInstance).GetTAttribute('resp_LER').SetSample(sample);
        sample := (instance as TEntityInstance).GetTAttribute('LL_BL').GetSample(date);
        sample.value := LL_BL;
        (instance as TEntityInstance).GetTAttribute('LL_BL').SetSample(sample);
        sample := (instance as TEntityInstance).GetTAttribute('coeffLifespan').GetSample(date);
        sample.value := coeffLifespan;
        (instance as TEntityInstance).GetTAttribute('coeffLifespan').SetSample(sample);
        sample := (instance as TEntityInstance).GetTAttribute('mu').GetSample(date);
        sample.value := mu;
        (instance as TEntityInstance).GetTAttribute('mu').SetSample(sample);
        sample := (instance as TEntityInstance).GetTAttribute('leaf_stock_max').GetSample(date);
        sample.value := leaf_stock_max;
        (instance as TEntityInstance).GetTAttribute('leaf_stock_max').SetSample(sample);
        (instance as TEntityInstance).SetCurrentState(1);
        SRwriteln('LeafTransitionToActive_ng currentState --> ' + IntToStr(1));
      end;
    end
    else
    begin
      SRwriteln('LeafTransitionToActive_ng Etat inchange');
    end;
  end;
end;

procedure InternodeTransitionToActive_ng(var instance : TInstance);
var
  stock, deficit, diff, boolCrossedPlasto, nbDayOfSimulation : Double;
  nbLeafElong, nbLeafPI, isMainstem : Double;
  stateTiller, statePlant, organState: Integer;
  refMeristem, refTiller : TInstance;
  phenoStageAtCreation, currentPhenoStage, organRank, leafRank : Double;
  i, le : Integer;
  currentInstance : TInstance;
  startingElongationReally, startingElongationNoGrowth : Boolean;
  leafLength, leafWidth : Double;
  MGR, plasto, ligulo, Tb, resp_LER, LIN1, IN_A, IN_B, density_IN, MaximumReserveInInternode : Double;
  stock_tiller, leaf_width_to_IN_diameter, leaf_length_to_IN_length, slope_length_IN : Double;
  IN_length_to_IN_diam, coef_lin_IN_diam, resp_INER : Double;
  date : TDateTime;
  sample : TSample;
begin
  leafWidth := 0;
  leafLength := 0;
  startingElongationReally := False;
  startingElongationNoGrowth := False;
  organState := (instance as TEntityInstance).GetCurrentState();
  organRank := (instance as TEntityInstance).GetTAttribute('rank').GetCurrentSample().value;
  refMeristem := instance.GetFather();
  while (refMeristem.GetName() <> 'EntityMeristem') do
  begin
    refMeristem := refMeristem.GetFather();
  end;
  refTiller := instance.GetFather();
  while ((refTiller as TEntityInstance).GetCategory() <> 'Tiller') do
  begin
    refTiller := refTiller.GetFather();
  end;
  phenoStageAtCreation := (refTiller as TEntityInstance).GetTAttribute('phenoStageAtCreation').GetCurrentSample().value;
  isMainstem := (refTiller as TEntityInstance).GetTAttribute('isMainstem').GetCurrentSample().value;
  stateTiller := (refTiller as TEntityInstance).GetCurrentState();
  nbLeafElong := (refMeristem as TEntityInstance).GetTAttribute('nb_leaf_stem_elong').GetCurrentSample().value;
  nbLeafPI := (refMeristem as TEntityInstance).GetTAttribute('nbleaf_pi').GetCurrentSample().value;
  currentPhenoStage := ((refMeristem as TEntityInstance).GetTAttribute('n') as TAttributeTableOut).GetCurrentSample().value;
  boolCrossedPlasto := (refMeristem as TEntityInstance).GetTAttribute('boolCrossedPlasto').GetCurrentSample().value;
  stock := (refTiller as TEntityInstance).GetTAttribute('stock_tiller').GetCurrentSample().value;
  deficit := (refTiller as TEntityInstance).GetTAttribute('deficit_tiller').GetCurrentSample().value;
  diff := stock + deficit;
  date := (refMeristem as TEntityInstance).GetNextDate();
  SRwriteln('organState           --> ' + IntToStr(organState));
  SRwriteln('organRank            --> ' + FloatToStr(organRank));
  SRwriteln('phenoStageAtCreation --> ' + FloatToStr(phenoStageAtCreation));
  SRwriteln('isMainstem           --> ' + FloatToStr(isMainstem));
  SRwriteln('stateTiller          --> ' + FloatToStr(stateTiller));
  SRwriteln('nbLeafElong          --> ' + FloatToStr(nbLeafElong));
  SRwriteln('nbLeafPI             --> ' + FloatToStr(nbLeafPI));
  SRwriteln('currentPhenoStage    --> ' + FloatToStr(currentPhenoStage));
  SRwriteln('boolCrossedPlasto    --> ' + FloatToStr(boolCrossedPlasto));
  if (boolCrossedPlasto > 0) then
  begin
    if ((currentPhenoStage >= nbLeafElong) or (currentPhenoStage >= nbLeafPI)) then
    begin
      if (stateTiller <> 10) then
      begin
        if (isMainstem = 1) then
        begin
          if (organRank = currentPhenoStage - 1) then
          begin
            SRwriteln('L entrenoeud commence son allongement');
            if (diff > 0) then
            begin
              startingElongationReally := True;
              startingElongationNoGrowth := False;
            end
            else
            begin
              startingElongationReally := False;
              startingElongationNoGrowth := True;
            end;
          end;
        end
        else
        begin
          if ((organRank + phenoStageAtCreation) = currentPhenoStage) then
          begin
            SRwriteln('L entrenoeud commence son allongement');
            if (diff > 0) then
            begin
              startingElongationReally := True;
              startingElongationNoGrowth := False;
            end
            else
            begin
              startingElongationReally := False;
              startingElongationNoGrowth := True;
            end;
          end;
        end;
      end;
    end;
  end;
  if (startingElongationReally or startingElongationNoGrowth) then
  begin
    le := (refTiller as TEntityInstance).LengthTInstanceList();
    for i := 0 to le - 1 do
    begin
      currentInstance := (refTiller as TEntityInstance).GetTInstance(i);
      if (currentInstance is TEntityInstance) then
      begin
        if ((currentInstance as TEntityInstance).GetCategory() = 'Leaf') then
        begin
          leafRank := (currentInstance as TEntityInstance).GetTAttribute('rank').GetCurrentSample().value;
          SRwriteln('leafRank --> ' + FloatToStr(leafRank));
          SRwriteln('leafName --> ' + currentInstance.GetName());
          if (leafRank = organRank) then
          begin
            SRwriteln(currentInstance.GetName() + ' selectionne');
            leafLength := (currentInstance as TEntityInstance).GetTAttribute('len').GetCurrentSample().value;
            leafWidth := (currentInstance as TEntityInstance).GetTAttribute('width').GetCurrentSample().value;
          end;
        end;
      end;
    end;
    MGR := (refMeristem as TEntityInstance).GetTAttribute('MGR').GetSample(date).value;
    plasto := (refMeristem as TEntityInstance).GetTAttribute('plasto').GetSample(date).value;
    ligulo := (refMeristem as TEntityInstance).GetTAttribute('ligulo').GetSample(date).value;
    Tb := (refMeristem as TEntityInstance).GetTAttribute('Tb').GetSample(date).value;
    resp_LER := (refMeristem as TEntityInstance).GetTAttribute('resp_LER').GetSample(date).value;
    resp_INER := resp_LER;
    LIN1 := (refMeristem as TEntityInstance).GetTAttribute('LIN1').GetSample(date).value;
    IN_A := (refMeristem as TEntityInstance).GetTAttribute('IN_A').GetSample(date).value;
    IN_B := (refMeristem as TEntityInstance).GetTAttribute('IN_B').GetSample(date).value;
    density_IN := (refMeristem as TEntityInstance).GetTAttribute('density_IN').GetSample(date).value;
    MaximumReserveInInternode := (refMeristem as TEntityInstance).GetTAttribute('maximumReserveInInternode').GetSample(date).value;
    stock_tiller := (refTiller as TEntityInstance).GetTAttribute('stock_tiller').GetSample(date).value;
    leaf_width_to_IN_diameter := (refMeristem as TEntityInstance).GetTAttribute('leaf_width_to_IN_diameter').GetSample(date).value;
    leaf_length_to_IN_length := (refMeristem as TEntityInstance).GetTAttribute('leaf_length_to_IN_length').GetSample(date).value;
    slope_length_IN := (refMeristem as TEntityInstance).GetTAttribute('slope_length_IN').GetSample(date).value;
    IN_length_to_IN_diam := (refMeristem as TEntityInstance).GetTAttribute('IN_length_to_IN_diam').GetSample(date).value;
    coef_lin_IN_diam := (refMeristem as TEntityInstance).GetTAttribute('coef_lin_IN_diam').GetSample(date).value;

    sample.date := date;
    sample.value := leafLength;
    (instance as TEntityInstance).GetTAttribute('leafLength').SetSample(sample);

    sample.date := date;
    sample.value := leafWidth;
    (instance as TEntityInstance).GetTAttribute('leafWidth').SetSample(sample);

    sample.date := date;
    sample.value := MGR;
    (instance as TEntityInstance).GetTAttribute('MGR').SetSample(sample);

    sample.date := date;
    sample.value := plasto;
    (instance as TEntityInstance).GetTAttribute('plasto').SetSample(sample);

    sample.date := date;
    sample.value := ligulo;
    (instance as TEntityInstance).GetTAttribute('ligulo').SetSample(sample);

    sample.date := date;
    sample.value := Tb;
    (instance as TEntityInstance).GetTAttribute('Tb').SetSample(sample);

    sample.date := date;
    sample.value := resp_INER;
    (instance as TEntityInstance).GetTAttribute('resp_INER').SetSample(sample);

    sample.date := date;
    sample.value := LIN1;
    (instance as TEntityInstance).GetTAttribute('LIN1').SetSample(sample);

    sample.date := date;
    sample.value := IN_A;
    (instance as TEntityInstance).GetTAttribute('IN_A').SetSample(sample);

    sample.date := date;
    sample.value := IN_B;
    (instance as TEntityInstance).GetTAttribute('IN_B').SetSample(sample);

    sample.date := date;
    sample.value := density_IN;
    (instance as TEntityInstance).GetTAttribute('density_IN').SetSample(sample);

    sample.date := date;
    sample.value := MaximumReserveInInternode;
    (instance as TEntityInstance).GetTAttribute('MaximumReserveInInternode').SetSample(sample);

    sample.date := date;
    sample.value := stock_tiller;
    (instance as TEntityInstance).GetTAttribute('stock_culm').SetSample(sample);

    sample.date := date;
    sample.value := leaf_width_to_IN_diameter;
    (instance as TEntityInstance).GetTAttribute('leaf_width_to_IN_diameter').SetSample(sample);

    sample.date := date;
    sample.value := leaf_length_to_IN_length;
    (instance as TEntityInstance).GetTAttribute('leaf_length_to_IN_length').SetSample(sample);

    sample.date := date;
    sample.value := slope_length_IN;
    (instance as TEntityInstance).GetTAttribute('slope_length_IN').SetSample(sample);

    sample.date := date;
    sample.value := IN_length_to_IN_diam;
    (instance as TEntityInstance).GetTAttribute('IN_length_to_IN_diam').SetSample(sample);

    sample.date := date;
    sample.value := coef_lin_IN_diam;
    (instance as TEntityInstance).GetTAttribute('coef_lin_IN_diam').SetSample(sample);


    if (startingElongationReally and not startingElongationNoGrowth) then
    begin
      (instance as TEntityInstance).SetCurrentState(1);
      sample := (instance as TEntityInstance).GetTAttribute('no_growth_at_init').GetCurrentSample();
      sample.value := 0;
      (instance as TEntityInstance).GetTAttribute('no_growth_at_init').SetSample(sample);
      SRwriteln('on commence effectivement l''allongement');
    end
    else if (not startingElongationReally and startingElongationNoGrowth) then
    begin
      (instance as TEntityInstance).SetCurrentState(1);
      sample := (instance as TEntityInstance).GetTAttribute('no_growth_at_init').GetCurrentSample();
      sample.value := 1;
      (instance as TEntityInstance).GetTAttribute('no_growth_at_init').SetSample(sample);
      SRwriteln('on ne commence pas effectivement l''allongement');
    end;



  end;
end;

procedure SaveTableData_ng(var instance : TInstance);
const
  leafAttributes : array[1..4] of string = ('width', 'bladeArea', 'biomass', 'length');
  internodeAttributes : array[1..3] of string = ('biomass', 'length', 'diameter');
  panicleAttributes : array[1..6] of string = ('grainNb', 'fertileGrainNumber', 'filledGrainNumber', 'height', 'weight', 'length');
  peduncleAttributes : array[1..3] of string = ('biomass', 'length', 'diameter');
  prefixHeader : array[1..3] of string = ('Name', 'Category', 'Attribute');
  tillerBaseName = 'T_';
  leafBaseName = 'L';
  internodeBaseName = 'IN';
  panicleBaseName = 'Pan';
  peduncleBaseName = 'Ped';
  tab = #09;
  fileName = 'aggregatedData_out';
  extension = 'txt';
  dot = '.';
  separator = '\';
var
  refFather, currentInstance, currentInstance1, currentInstance2 : TInstance;
  i, i1, i2, le, le1, le2, index, j : Integer;
  indexBeginLeaf, indexBeginInternode, indexBeginPanicle, indexBeginPeduncle : Integer;
  lastLeafName, lastInternodeName, category : string;
  endingDate, currentDate : TDateTime;
  pos : Integer;
  nbLeafMax, nbInternodeMax, nbTillerMax : Integer;
  numberOfLeafAttributes, numberOfInternodeAttributes : Integer;
  numberOfPanicleAttributes, numberOfPeduncleAttributes : Integer;
  hasLeaf, hasInternode, hasPeduncle, hasPanicle : Boolean;
  numberOfLine, numberOfRow, decay : Integer;
  header, line : string;
  path, fullFileName : string;
  pFile : TextFile;
  grid : TArrayOfArrayOfString;
  tillerRank, leafRank, internodeRank, panicleRank, peduncleRank, state : Integer;
  tillerName, leafName, internodeName, panicleName, peduncleName : string;
  width, bladeArea, biomass, len, diameter, grainNb, fertileGrainNumber, filledGrainNumber, height, weight: Double;
  isMainstem : Double;
  LastTillerName : string;
begin
  refFather := instance.GetFather();
  endingDate := refFather.GetEndDate();
  currentDate := instance.GetNextDate();
  if (currentDate = endingDate) then
  begin
    indexBeginLeaf := -1;
    indexBeginInternode := -1;
    indexBeginPanicle := -1;
    indexBeginPeduncle := -1;
    path := GetCurrentDir();
    fullFileName := path + separator + fileName + dot + extension;
    AssignFile(pFile, fullFileName);
    ReWrite(pFile);
    hasLeaf := False;
    hasInternode := False;
    hasPeduncle := False;
    hasPanicle := False;
    numberOfLeafAttributes := High(leafAttributes);
    numberOfInternodeAttributes := High(internodeAttributes);
    numberOfPanicleAttributes := High(panicleAttributes);
    numberOfPeduncleAttributes := High(peduncleAttributes);
    le1 := (instance as TEntityInstance).LengthTInstanceList();
    for i1 := 0 to le1 - 1 do
    begin
      currentInstance1 := (instance as TEntityInstance).GetTInstance(i1);
      if (currentInstance1 is TEntityInstance) then
      begin
        if ((currentInstance1 as TEntityInstance).GetCategory() = 'Tiller') then
        begin
          lastTillerName := currentInstance1.GetName();
          isMainstem := (currentInstance1 as TEntityInstance).GetTAttribute('isMainstem').GetCurrentSample().value;
          if (isMainstem = 1) then
          begin
            le2 := (currentInstance1 as TEntityInstance).LengthTInstanceList();
            for i2 := 0 to le2 - 1 do
            begin
              currentInstance2 := (currentInstance1 as TEntityInstance).GetTInstance(i2);
              if (currentInstance2 is TEntityInstance) then
              begin
                if ((currentInstance2 as TEntityInstance).GetCategory() = 'Leaf') then
                begin
                  if ((currentInstance2 as TEntityInstance).GetCurrentState() <> 2000) then
                  begin
                    lastLeafName := currentInstance2.GetName();
                    hasLeaf := True;
                  end;
                end
                else if ((currentInstance2 as TEntityInstance).GetCategory() = 'Internode') then
                begin
                  if ((currentInstance2 as TEntityInstance).GetCurrentState() <> 2000) then
                  begin
                    lastInternodeName := currentInstance2.GetName();
                    hasInternode := True;
                  end;
                end
                else if ((currentInstance2 as TEntityInstance).GetCategory() = 'Peduncle') then
                begin
                  if ((currentInstance2 as TEntityInstance).GetCurrentState() <> 2000) then
                  begin
                    hasPeduncle := True;
                  end;
                end
                else if ((currentInstance2 as TEntityInstance).GetCategory() = 'Panicle') then
                begin
                  if ((currentInstance2 as TEntityInstance).GetCurrentState() <> 2000) then
                  begin
                    hasPanicle := True;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;

    Delete(lastTillerName, 1, length(lastTillerName) - 1);
    nbTillerMax := StrToInt(lastTillerName) + 1;

    if (hasLeaf) then
    begin
      pos := AnsiPos(lastLeafName, 'L');
      Delete(lastLeafName, 1, pos + 1);
      pos := LastDelimiter('T', lastLeafName);
      Delete(lastLeafName, pos - 1, length(lastLeafName) - (pos - 2));
      nbLeafMax := StrToInt(lastLeafName);
    end
    else
    begin
      nbLeafMax := 0;
    end;

    if (hasInternode) then
    begin
      pos := AnsiPos(lastInternodeName, 'N');
      Delete(lastInternodeName, 1, pos + 2);
      pos := LastDelimiter('T', lastInternodeName);
      Delete(lastInternodeName, pos - 1, length(lastInternodeName) - (pos - 2));
      nbInternodeMax := StrToInt(lastInternodeName);
    end
    else
    begin
      nbInternodeMax := 0;
    end;

    header := '';
    numberOfRow := High(prefixHeader) + nbTillerMax;
    numberOfLine := (nbLeafMax * numberOfLeafAttributes) + (nbInternodeMax * numberOfInternodeAttributes);
    if (hasPeduncle) then
    begin
      numberOfLine := numberOfLine + ((nbTillerMax + 1) * numberOfPeduncleAttributes);
    end;
    if (hasPanicle) then
    begin
      numberOfLine := numberOfLine + ((nbTillerMax + 1) * numberOfPanicleAttributes);
    end;
    numberOfLine := numberOfLine + 1; // on rajoute la ligne du header
    setLength(grid, numberOfLine, numberOfRow);
    for i := 0 to numberOfLine - 1 do
    begin
      for j := 0 to numberOfRow - 1 do
      begin
        grid[i, j] := 'NA';
      end;
    end;
    // on ecrit le header dans la grille
    index := 0;
    for i := 1 to High(prefixHeader) do
    begin
      grid[0, index] := prefixHeader[i];
      index := index + 1;
    end;
    for i := 0 to nbTillerMax - 1 do
    begin
      grid[0, index] := tillerBaseName + IntToStr(i);
      index := index + 1;
    end;
    // on ecrit les entete de ligne
    index := 1;
    indexBeginLeaf := index;
    for i := 0 to nbLeafMax - 1 do
    begin
      for j := 1 to High(leafAttributes) do
      begin
        grid[index, 0] := leafBaseName + IntToStr(i + 1);
        grid[index, 1] := 'Leaf';
        grid[index, 2] := leafAttributes[j];
        index := index + 1;
      end;
    end;
    indexBeginInternode := index;
    for i := 0 to nbInternodeMax - 1 do
    begin
      for j := 1 to High(internodeAttributes) do
      begin
        grid[index, 0] := internodeBaseName + IntToStr(i + 1);
        grid[index, 1] := 'Internode';
        grid[index, 2] := internodeAttributes[j];
        index := index + 1;
      end;
    end;
    if (hasPeduncle) then
    begin
      indexBeginPeduncle := index;
      for i := 0 to nbTillerMax do
      begin
        for j := 1 to High(peduncleAttributes) do
        begin
          grid[index, 0] := peduncleBaseName + IntToStr(i);
          grid[index, 1] := 'Peduncle';
          grid[index, 2] := peduncleAttributes[j];
          index := index + 1;
        end;
      end;
    end;
    if (hasPanicle) then
    begin
      indexBeginPanicle := index;
      for i := 0 to nbTillerMax do
      begin
        for j := 1 to High(panicleAttributes) do
        begin
          grid[index, 0] := panicleBaseName + IntToStr(i);
          grid[index, 1] := 'Panicle';
          grid[index, 2] := panicleAttributes[j];
          index := index + 1;
        end;
      end;
    end;
    // on remplit la grille avec les bonne valeurs
    le1 := (instance as TEntityInstance).LengthTInstanceList();
    for i1 := 0 to le1 - 1 do
    begin
      currentInstance1 := (instance as TEntityInstance).GetTInstance(i1);
      if (currentInstance1 is TEntityInstance) then
      begin
        category := (currentInstance1 as TEntityInstance).GetCategory();
        if (category = 'Tiller') then
        begin
          le2 := (currentInstance1 as TEntityInstance).LengthTInstanceList();
          for i2 := 0 to le2 - 1 do
          begin
            currentInstance2 := (currentInstance1 as TEntityInstance).GetTInstance(i2);
            if (currentInstance2 is TEntityInstance) then
            begin
              category := (currentInstance2 as TEntityInstance).GetCategory();
              state := (currentInstance2 as TEntityInstance).GetCurrentState();
              tillerName := currentInstance1.GetName();
              pos :=  AnsiPos(tillerName, 'T');
              Delete(tillerName, 1, pos + 2);
              tillerRank := StrToInt(tillerName);
              j := tillerRank + 3;
              if ((category = 'Leaf') and (state <> 2000)) then
              begin
                leafName := currentInstance2.GetName();
                pos := AnsiPos(leafName, 'L');
                Delete(leafName, 1, pos + 1);
                pos := LastDelimiter('T', leafName);
                Delete(leafName, pos - 1, length(leafName) - (pos - 2));
                leafRank := StrToInt(leafName);
                decay := (leafRank - 1) * numberOfLeafAttributes;
                i := decay + indexBeginLeaf;
                width := (currentInstance2 as TEntityInstance).GetTAttribute('width').GetCurrentSample().value;
                if (state >= 4) then
                begin
                  bladeArea := (currentInstance2 as TEntityInstance).GetTAttribute('correctedBladeArea').GetCurrentSample().value;
                  biomass := (currentInstance2 as TEntityInstance).GetTAttribute('correctedLeafBiomass').GetCurrentSample().value;
                end
                else
                begin
                  bladeArea := (currentInstance2 as TEntityInstance).GetTAttribute('bladeArea').GetCurrentSample().value;
                  biomass := (currentInstance2 as TEntityInstance).GetTAttribute('biomass').GetCurrentSample().value;
                end;
                len := (currentInstance2 as TEntityInstance).GetTAttribute('len').GetCurrentSample().value;
                grid[i, j] := FloatToStr(width);
                grid[i + 1, j] := FloatToStr(bladeArea);
                grid[i + 2, j] := FloatToStr(biomass);
                grid[i + 3, j] := FloatToStr(len);
              end
              else if ((category = 'Internode') and (state <> 2000)) then
              begin
                internodeName := currentInstance2.GetName();
                pos := AnsiPos(internodeName, 'N');
                Delete(internodeName, 1, pos + 2);
                pos := LastDelimiter('T', internodeName);
                Delete(internodeName, pos - 1, length(internodeName) - (pos - 2));
                internodeRank := StrToInt(internodeName);
                decay := (internodeRank - 1) * numberOfInternodeAttributes;
                i := decay + indexBeginInternode;
                biomass := (currentInstance2 as TEntityInstance).GetTAttribute('biomassIN').GetCurrentSample().value;
                len := (currentInstance2 as TEntityInstance).GetTAttribute('LIN').GetCurrentSample().value;
                diameter := (currentInstance2 as TEntityInstance).GetTAttribute('DIN').GetCurrentSample().value;
                grid[i, j] := FloatToStr(biomass);
                grid[i + 1, j] := FloatToStr(len);
                grid[i + 2, j] := FloatToStr(diameter);
              end
              else if ((category = 'Panicle') and (state <> 2000)) then
              begin
                panicleName := currentInstance2.GetName();
                pos :=  AnsiPos(panicleName, 'n');
                Delete(panicleName, 1, pos + 3);
                pos := LastDelimiter('T', panicleName);
                Delete(panicleName, pos - 1, length(panicleName) - (pos - 2));
                panicleRank := StrToInt(panicleName);
                decay := panicleRank * numberOfPanicleAttributes;
                i := decay + indexBeginPanicle;
                grainNb := (currentInstance2 as TEntityInstance).GetTAttribute('grain_nb').GetCurrentSample().value;
                fertileGrainNumber := (currentInstance2 as TEntityInstance).GetTAttribute('fertile_grain_number').GetCurrentSample().value;
                filledGrainNumber := (currentInstance2 as TEntityInstance).GetTAttribute('filled_grain_nb').GetCurrentSample().value;
                height := (currentInstance2 as TEntityInstance).GetTAttribute('height_panicle').GetCurrentSample().value;
                weight := (currentInstance2 as TEntityInstance).GetTAttribute('weight_panicle').GetCurrentSample().value;
                len := (currentInstance2 as TEntityInstance).GetTAttribute('length_panicle').GetCurrentSample().value;
                grid[i, j] := FloatToStr(grainNb);
                grid[i + 1, j] := FloatToStr(fertileGrainNumber);
                grid[i + 2, j] := FloatToStr(filledGrainNumber);
                grid[i + 3, j] := FloatToStr(height);
                grid[i + 4, j] := FloatToStr(weight);
                grid[i + 5, j] := FloatToStr(len);
              end
              else if ((category = 'Peduncle') and (state <> 2000)) then
              begin
                peduncleName := currentInstance2.GetName();
                pos :=  AnsiPos(peduncleName, 'n');
                Delete(peduncleName, 1, pos + 3);
                pos := LastDelimiter('T', peduncleName);
                Delete(peduncleName, pos - 1, length(peduncleName) - (pos - 2));
                peduncleRank := StrToInt(peduncleName);
                decay := peduncleRank * numberOfPeduncleAttributes;
                i := decay + indexBeginPeduncle;
                biomass := (currentInstance2 as TEntityInstance).GetTAttribute('biomassIN').GetCurrentSample().value;
                len := (currentInstance2 as TEntityInstance).GetTAttribute('LIN').GetCurrentSample().value;
                diameter := (currentInstance2 as TEntityInstance).GetTAttribute('DIN').GetCurrentSample().value;
                grid[i, j] := FloatToStr(biomass);
                grid[i + 1, j] := FloatToStr(len);
                grid[i + 2, j] := FloatToStr(diameter);
              end;
            end;
          end;
        end;
      end;
    end;
    for i := 0 to numberOfLine - 1 do
    begin
      line := '';
      for j := 0 to numberOfRow - 1 do
      begin
        line := line + grid[i, j] + tab;
      end;
      Writeln(pFile, line);
    end;
    CloseFile(pFile);
  end;
end;

procedure TransitionToLiguleState_ng(var instance : TInstance; const len, predim, isOnMainstem : double; var demand, lastDemand : Double);
var
  refMeristem : TInstance;
  lig : double;
  refAttribute : TAttributeTableOut;
  sample : TSample;
begin
	SRwriteln((instance as TEntityInstance).GetFather().GetName);
  SRwriteln('len    --> ' + floattostr(len));
  SRwriteln('predim --> ' + floattostr(predim));
  if (len >= predim) then // passage a l etat LIGULE
  begin

    // passage a l etat ligule
    (instance as TEntityInstance).SetCurrentState(20);
    SRWriteln('**** new ligulated leaf ****');

    SRwriteln('on affecte demand a lastDemand et on met demand a 0');
    lastDemand := demand;
    demand := 0;

    SRwriteln('lastDemand --> ' + FloatToStr(lastDemand));
    SRwriteln('demand     --> ' + FloatToStr(demand));

    sample := (instance as TEntityInstance).GetTAttribute('biomass').GetCurrentSample();
    (instance as TEntityInstance).GetTAttribute('oldCorrectedBiomass').SetSample(sample);
    SRwriteln('oldCorrectedBiomass --> ' + FloatToStr(sample.value));

    if (isOnMainstem = 1) then
    begin
      refMeristem := instance.GetFather();
      while (refMeristem.GetName() <> 'EntityMeristem') do
      begin
        refMeristem := refMeristem.GetFather();
      end;

      refAttribute := ((refMeristem as TEntityInstance).GetTAttribute('lig') as TAttributeTableOut);
      sample := refAttribute.GetCurrentSample();
      sample.value := sample.value + 1;
      refAttribute.SetSample(sample);
      lig := sample.value;

      refAttribute := ((refMeristem as TEntityInstance).GetTAttribute('TT_lig') as TAttributeTableOut);
      sample := refAttribute.GetCurrentSample();
      sample.value := 0;
      refAttribute.SetSample(sample);

      refAttribute := ((refMeristem as TEntityInstance).GetTAttribute('IH') as TAttributeTableOut);
      sample := refAttribute.GetCurrentSample();
      sample.value := lig;
      refAttribute.SetSample(sample);

    end;
  end;
end;

procedure ComputeBiomInternodeMainstem_ng(var instance : TInstance; var biomInternodeMainstem : Double);
var
  statePlant : Integer;
  le1, le2, i1, i2 : Integer;
  refTiller, refEntity : TInstance;
  isMainstem : Double;
  biomIN, stockInternodeTiller : Double;
  nameIN : string;
begin
  biomInternodeMainstem := 0;
  statePlant := (instance as TEntityInstance).GetCurrentState();
  if (statePlant >= 4) then
  begin
    le1 := (instance as TEntityInstance).LengthTInstanceList();
    for i1 := 0 to le1 - 1 do
    begin
      refTiller := (instance as TEntityInstance).GetTInstance(i1);
      if (refTiller is TEntityInstance) then
      begin
        if ((refTiller as TEntityInstance).GetCategory() = 'Tiller') then
        begin
          isMainstem := (refTiller as TEntityInstance).GetTAttribute('isMainstem').GetCurrentSample().value;
          if (isMainstem = 1) then
          begin
            stockInternodeTiller := (refTiller as TEntityInstance).GetTAttribute('stockINTiller').GetCurrentSample().value;
            SRwriteln('stockInternodeTiller  --> ' + FloatToStr(stockInternodeTiller));
            biomInternodeMainstem := biomInternodeMainstem + stockInternodeTiller;
            le2 := (refTiller as TEntityInstance).LengthTInstanceList();
            for i2 := 0 to le2 - 1 do
            begin
              refEntity := (refTiller as TEntityInstance).GetTInstance(i2);
              if (refEntity is TEntityInstance) then
              begin
                if ((refEntity as TEntityInstance).GetCategory() = 'Internode') then
                begin
                  nameIN := refEntity.GetName();
                  biomIN := (refEntity as TEntityInstance).GetTAttribute('biomassIN').GetCurrentSample().value;
                  biomInternodeMainstem := biomInternodeMainstem + biomIN;
                  SRwriteln('nameIN                --> ' + nameIN);
                  SRwriteln('biomIN                --> ' + FloatToStr(biomIN));
                  SRwriteln('biomInternodeMainstem --> ' + FloatToStr(biomInternodeMainstem));
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure ComputeBiomLeafMainstem_ng(var instance : TInstance; var biomLeafMainstem : Double);
var
  stateLeaf : Integer;
  i1, i2, le1, le2 : Integer;
  refTiller, currentInstance : TInstance;
  biomLeaf : Double;
  contribution1 : Double;
  stockLeaf : Double;
  isMainstem : Double;
  totalSenescedLeafBiomass : Double;
begin
  biomLeafMainstem := 0;
  biomLeaf := 0;
  le1 := (instance as TEntityInstance).LengthTInstanceList();
  for i1 := 0 to le1 - 1 do
  begin
    refTiller := (instance as TEntityInstance).GetTInstance(i1);
    if (refTiller is TEntityInstance) then
    begin
      if ((refTiller as TEntityInstance).GetCategory() = 'Tiller') then
      begin
        isMainstem := (refTiller as TEntityInstance).GetTAttribute('isMainstem').GetCurrentSample().value;
        if (isMainstem = 1) then
        begin
          le2 := (refTiller as TEntityInstance).LengthTInstanceList();
          for i2 := 0 to le2 - 1 do
          begin
            currentInstance := (refTiller as TEntityInstance).GetTInstance(i2);
            if (currentInstance is TEntityInstance) then
            begin
              if ((currentInstance as TEntityInstance).GetCategory() = 'Leaf') then
              begin
                SRwriteln('Leaf name                    --> ' + currentInstance.GetName());
                stateLeaf := (currentInstance as TEntityInstance).GetCurrentState();
                SRwriteln('stateLeaf                    --> ' +  FloatToStr(stateLeaf));
                if ((stateLeaf = 2) or (stateLeaf = 3) or (stateLeaf = 10) or (stateLeaf = 20)) then
                begin
                  SRwriteln('stateLeaf = realization');
                  contribution1 := (currentInstance as TEntityInstance).GetTAttribute('biomass').GetCurrentSample().value;
                  SRwriteln('biomass                      --> ' + FloatToStr(contribution1));
                  biomLeaf := biomLeaf  + contribution1;
                  SRwriteln('biomLeaf                     --> ' + FloatToStr(biomLeaf));
                end
                else if ((stateLeaf = 4) or (stateLeaf = 5)) then
                begin
                  SRwriteln('stateLeaf = ligule');
                  contribution1 := (currentInstance as TEntityInstance).GetTAttribute('correctedLeafBiomass').GetCurrentSample().value;
                  SRwriteln('biomass (corrected)          --> ' + FloatToStr(contribution1));
                  biomLeaf := biomLeaf + contribution1;
                  SRwriteln('biomLeaf                     --> ' + FloatToStr(biomLeaf));
                end;
              end;
            end;
          end;
          stockLeaf := (refTiller as TEntityInstance).GetTAttribute('stockLeafTiller').GetCurrentSample().value;
          SRwriteln('stockLeaf                    --> ' + FloatToStr(stockLeaf));
          totalSenescedLeafBiomass := (refTiller as TEntityInstance).GetTAttribute('totalSenescedLeafBiomass').GetCurrentSample().value;
          SRwriteln('totalSenescedLeafBiomass     --> ' + FloatToStr(totalSenescedLeafBiomass));
          biomLeafMainstem := stockLeaf + biomLeaf + totalSenescedLeafBiomass;
          SRwriteln('biomLeafMainstem             --> ' + FloatToStr(biomLeafMainstem));
        end;
      end;
    end;
  end;
end;
procedure ComputeBiomLeafMainstemGreen_ng(var instance : TInstance; var biomLeafMainstem : Double);
var
  stateLeaf : Integer;
  i1, i2, le1, le2 : Integer;
  refTiller, currentInstance : TInstance;
  biomLeaf : Double;
  contribution1 : Double;
  stockLeaf : Double;
  isMainstem : Double;
begin
  biomLeafMainstem := 0;
  biomLeaf := 0;
  le1 := (instance as TEntityInstance).LengthTInstanceList();
  for i1 := 0 to le1 - 1 do
  begin
    refTiller := (instance as TEntityInstance).GetTInstance(i1);
    if (refTiller is TEntityInstance) then
    begin
      if ((refTiller as TEntityInstance).GetCategory() = 'Tiller') then
      begin
        isMainstem := (refTiller as TEntityInstance).GetTAttribute('isMainstem').GetCurrentSample().value;
        if (isMainstem = 1) then
        begin
          le2 := (refTiller as TEntityInstance).LengthTInstanceList();
          for i2 := 0 to le2 - 1 do
          begin
            currentInstance := (refTiller as TEntityInstance).GetTInstance(i2);
            if (currentInstance is TEntityInstance) then
            begin
              if ((currentInstance as TEntityInstance).GetCategory() = 'Leaf') then
              begin
                SRwriteln('Leaf name                    --> ' + currentInstance.GetName());
                stateLeaf := (currentInstance as TEntityInstance).GetCurrentState();
                SRwriteln('stateLeaf                    --> ' +  FloatToStr(stateLeaf));
                if ((stateLeaf = 2) or (stateLeaf = 3) or (stateLeaf = 10) or (stateLeaf = 20)) then
                begin
                  SRwriteln('stateLeaf = realization');
                  contribution1 := (currentInstance as TEntityInstance).GetTAttribute('biomass').GetCurrentSample().value;
                  SRwriteln('biomass                      --> ' + FloatToStr(contribution1));
                  biomLeaf := biomLeaf  + contribution1;
                  SRwriteln('biomLeaf                     --> ' + FloatToStr(biomLeaf));
                end
                else if ((stateLeaf = 4) or (stateLeaf = 5)) then
                begin
                  SRwriteln('stateLeaf = ligule');
                  contribution1 := (currentInstance as TEntityInstance).GetTAttribute('correctedLeafBiomass').GetCurrentSample().value;
                  SRwriteln('biomass (corrected)        --> ' + FloatToStr(contribution1));
                  biomLeaf := biomLeaf + contribution1;
                  SRwriteln('biomLeaf            --> ' + FloatToStr(biomLeaf));
                end;
              end;
            end;
          end;
          stockLeaf := (refTiller as TEntityInstance).GetTAttribute('stockLeafTiller').GetCurrentSample().value;
          biomLeafMainstem := stockLeaf + biomLeaf;
        end;
      end;
    end;
  end;
end;

procedure ComputeBiomStem_ng(var instance : TInstance; var biomStem : Double);
var
  i1, le1, i2, le2 : Integer;
  currentInstance1, currentInstance2 : TInstance;
  biomassIN, totalBiomIN, stockIN, totalStockIN : Double;
begin
  biomStem := 0;
  totalBiomIN := 0;
  totalStockIN := 0;
  le1 := (instance as TEntityInstance).LengthTInstanceList();
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
              biomassIN := (currentInstance2 as TEntityInstance).GetTAttribute('biomassIN').GetCurrentSample().value;
              totalBiomIN := totalBiomIN + biomassIN;
              stockIN := (currentInstance2 as TEntityInstance).GetTAttribute('stockIN').GetCurrentSample().value;
              totalStockIN := totalStockIN + stockIN;
              SRwriteln(currentInstance2.GetName() + ' : biomassIN --> ' + FloatToStr(biomassIN));
              SRwriteln(currentInstance2.GetName() + ' : stockIN   --> ' + FloatToStr(stockIN));
              SRwriteln('totalBiomIN  --> ' + FloatToStr(totalBiomIN) );
              SRwriteln('totalStockIN --> ' + FloatToStr(totalStockIN) );
            end;
            if ((currentInstance2 as TEntityInstance).GetCategory() = 'Peduncle') then
            begin
              biomassIN := (currentInstance2 as TEntityInstance).GetTAttribute('biomassIN').GetCurrentSample().value;
              totalBiomIN := totalBiomIN + biomassIN;
              stockIN := (currentInstance2 as TEntityInstance).GetTAttribute('stockPeduncle').GetCurrentSample().value;
              totalStockIN := totalStockIN + stockIN;
              SRwriteln(currentInstance2.GetName() + ' : biomassIN       --> ' + FloatToStr(biomassIN));
              SRwriteln(currentInstance2.GetName() + ' : stockPeduncle   --> ' + FloatToStr(stockIN));
              SRwriteln('totalBiomIN  --> ' + FloatToStr(totalBiomIN) );
              SRwriteln('totalStockIN --> ' + FloatToStr(totalStockIN) );
            end;
          end;
        end;
      end;
    end;
  end;
  biomStem := totalBiomIN + totalStockIN;
  SRwriteln('biomStem --> ' + FloatToStr(biomStem));
end;

procedure ComputeStockInternodePlante_ng(var instance : TInstance; var stockInternodePlant : Double);
var
  i, le : Integer;
  currentInstance : TInstance;
  contribution : Double;
begin
  stockInternodePlant := 0;
  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      if ((currentInstance as TEntityInstance).GetCategory() = 'Tiller') then
      begin
        contribution := (currentInstance as TEntityInstance).GetTAttribute('stockINTiller').GetCurrentSample().value;
        stockInternodePlant := stockInternodePlant + contribution;
        SRwriteln('Tiller name         --> ' + currentInstance.GetName());
        SRwriteln('stockTiller         --> ' + FloatToStr(contribution));
        SRwriteln('stockInternodePlant --> ' + FloatToStr(stockInternodePlant));
      end;
    end;
  end;
end;

procedure ComputeLER_ng(const FTSW, ThresLER, SlopeLER, P, resp_LER, testIc : Double; var reductionLER : Double);
begin
  if (FTSW < ThresLER) then
  begin
    reductionLER := max(0.0001, (testIc * (1 / ThresLER) * FTSW) * (1 + (P * resp_LER)));
  end
  else
  begin
    reductionLER := 1 + (P * resp_LER);
  end;
  SRwriteln('testIc               --> ' + floattostr(FTSW));
  SRwriteln('FTSW                 --> ' + floattostr(FTSW));
  SRwriteln('ThresLER             --> ' + floattostr(ThresLER));
  SRwriteln('SlopeLER             --> ' + floattostr(SlopeLER));
  SRwriteln('P                    --> ' + floattostr(P));
  SRwriteln('resp_LER             --> ' + floattostr(resp_LER));
  SRwriteln('reductionLER Calcule --> ' + floattostr(reductionLER));
end;

procedure ComputeReductionINER_ng(const FTSW, ThresINER, slopeINER, P, resp_INER, testIc : Double; var reductionINER : Double);
begin
  if (FTSW < ThresINER) then
  begin
    reductionINER := max(0.0001, (testIc * (1 / ThresINER) * FTSW) * (1 + (P * resp_INER)));
  end
	else
  begin
    reductionINER := 1 + (P * resp_INER);
  end;
  SRwriteln('testIc               --> ' + floattostr(FTSW));
  SRwriteln('FTSW                  --> ' + floattostr(FTSW));
  SRwriteln('ThresINER             --> ' + floattostr(ThresINER));
  SRwriteln('SlopeINER             --> ' + floattostr(SlopeINER));
  SRwriteln('P                     --> ' + FloatToStr(P));
  SRwriteln('resp_INER             --> ' + FloatToStr(resp_INER));
  SRwriteln('reductionINER Calcule --> ' + floattostr(reductionINER));
end;

procedure ComputeWeightPanicle_ng(var instance : TInstance; var panicleDW, panicleMainstemDW : Double);
var
  i1, i2, le1, le2 : Integer;
  currentInstance1, currentInstance2 : TInstance;
  dWeightPanicle : Double;
  isMainstem: Double;
begin
  panicleDW := 0;
  panicleMainstemDW := 0;
  le1 := (instance as TEntityInstance).LengthTInstanceList();
  for i1 := 0 to le1 - 1 do
  begin
    currentInstance1 := (instance as TEntityInstance).GetTInstance(i1);
    if (currentInstance1 is TEntityInstance) then
    begin
      if ((currentInstance1 as TEntityInstance).GetCategory() = 'Tiller') then
      begin
        isMainstem := (currentInstance1 as TEntityInstance).GetTAttribute('isMainstem').GetCurrentSample().value;
        le2 := (currentInstance1 as TEntityInstance).LengthTInstanceList();
        for i2 := 0 to le2 - 1 do
        begin
          currentInstance2 := (currentInstance1 as TEntityInstance).GetTInstance(i2);
          if (currentInstance2 is TEntityInstance) then
          begin
            if ((currentInstance2 as TEntityInstance).GetCategory() = 'Panicle') then
            begin
              if (isMainstem = 1) then
              begin
                panicleMainstemDW := (currentInstance2 as TEntityInstance).GetTAttribute('weight_panicle').GetCurrentSample().value;
                panicleDW := panicleDW + panicleMainstemDW;
              end
              else
              begin
                dWeightPanicle := (currentInstance2 as TEntityInstance).GetTAttribute('weight_panicle').GetCurrentSample().value;
                panicleDW := panicleDW + dWeightPanicle;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure ComputePanicleNumber_ng(var instance : TInstance; var panicleNumber : Double);
var
  i1, i2, le1, le2 : Integer;
  currentInstance1, currentInstance2 : TInstance;
begin
  panicleNumber := 0;
  le1 := (instance as TEntityInstance).LengthTInstanceList();
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
            if ((currentInstance2 as TEntityInstance).GetCategory() = 'Panicle') then
            begin
              panicleNumber := panicleNumber + 1;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure ComputeFirstLastExpandedInternodeDiameterMainstem_ng(var instance : TInstance; var firstDiameter, lastDiameter, lastLength, lastRank : Double);
var
  state, internodeState, le1, le2, i1, i2 : Integer;
  maxCreationDate, minCreationDate, currentDate : TDateTime;
  currentInstance, tillerInstance, refMinInstance, refMaxInstance : TInstance;
  isMainstem : Double;
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
    le1 := (instance as TEntityInstance).LengthTInstanceList();
    for i1 := 0 to le1 - 1 do
    begin
      currentInstance := (instance as TEntityInstance).GetTInstance(i1);
      if (currentInstance is TEntityInstance) then
      begin
        if ((currentInstance as TEntityInstance).GetCategory() = 'Tiller') then
        begin
          isMainstem := (currentInstance as TEntityInstance).GetTAttribute('isMainstem').GetCurrentSample().value;
          if (isMainstem = 1) then
          begin
            le2 := (currentInstance as TEntityInstance).LengthTInstanceList();
            for i2 := 0 to le2 - 1 do
            begin
              tillerInstance := (currentInstance as TEntityInstance).GetTInstance(i2);
              if (tillerInstance is TEntityInstance) then
              begin
                if ((tillerInstance as TEntityInstance).GetCategory() = 'Internode') then
                begin
                  internodeState := (tillerInstance as TEntityInstance).GetCurrentState();
                  SRwriteln('internode state --> ' + FloatToStr(internodeState));
                  if ((internodeState = 4) or (internodeState = 5)) then
                  begin
                    currentDate := (tillerInstance as TEntityInstance).GetCreationDate();
                    if (currentDate < minCreationDate) then
                    begin
                      refMinInstance := tillerInstance;
                      minCreationDate := currentDate;
                    end;
                    if (currentDate > maxCreationDate) then
                    begin
                      refMaxInstance := tillerInstance;
                      maxCreationDate := currentDate;
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
    if ((refMinInstance <> nil) and (refMaxInstance <> nil)) then
    begin
      SRwriteln('first expanded internode          --> ' + refMinInstance.GetName());
      //firstDiameter := ((refMinInstance as TEntityInstance).GetTAttribute('DIN') as TAttributeTableOut).GetCurrentSample().value;
      firstDiameter := (refMinInstance as TEntityInstance).GetTAttribute('DIN').GetCurrentSample().value;
      SRwriteln('first expanded internode diameter --> ' + FloatToStr(firstDiameter));
      SRwriteln('last expanded internode           -->  ' + refMaxInstance.GetName());
      //lastDiameter := ((refMaxInstance as TEntityInstance).GetTAttribute('DIN') as TAttributeTableOut).GetCurrentSample().value;
      lastDiameter := (refMaxInstance as TEntityInstance).GetTAttribute('DIN').GetCurrentSample().value;
      lastRank := (refMaxInstance as TEntityInstance).GetTAttribute('rank').GetCurrentSample().value;
      //lastLength := ((refMaxInstance as TEntityInstance).GetTAttribute('LIN') as TAttributeTableOut).GetCurrentSample().value;
      lastLength := (refMaxInstance as TEntityInstance).GetTAttribute('LIN').GetCurrentSample().value;
      SRwriteln('last expanded internode diameter  --> ' + FloatToStr(lastDiameter));
    end;
  end;
end;

procedure ComputeNbActiveInternodesOnMainstem_ng(var instance : TInstance; var nbActiveInternodesOnMainstem : Double);
var
  state, le1, le2, i1, i2, internodeState : Integer;
  currentInstance, refTiller : TInstance;
  isMainstem : Double;
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
    le1 := (instance as TEntityInstance).LengthTInstanceList();
    for i1 := 0 to le1 - 1 do
    begin
      currentInstance := (instance as TEntityInstance).GetTInstance(i1);
      if (currentInstance is TEntityInstance) then
      begin
        if ((currentInstance as TEntityInstance).GetCategory() = 'Tiller') then
        begin
          isMainstem := (currentInstance as TEntityInstance).GetTAttribute('isMainstem').GetCurrentSample().value;
          if (isMainstem = 1) then
          begin
            le2 := (currentInstance as TEntityInstance).LengthTInstanceList();
            for i2 := 0 to le2 - 1 do
            begin
              refTiller := (currentInstance as TEntityInstance).GetTInstance(i2);
              if (refTiller is TEntityInstance) then
              begin
                if ((refTiller as TEntityInstance).GetCategory() = 'Internode') then
                begin
                  SRwriteln('Internode name -->  ' + refTiller.GetName());
                  internodeState := (refTiller as TEntityInstance).GetCurrentState();
                  SRwriteln('Internode state --> ' + IntToStr(internodeState));
                  if ((internodeState = 1) or (internodeState = 2) or (internodeState = 4) or (internodeState = 10) or (internodeState = 3) or (internodeState = 5)) then
                  begin
                    nbActiveInternodesOnMainstem := nbActiveInternodesOnMainstem + 1;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
    SRwriteln('nbActiveInternodesOnMainstem --> ' + FloatToStr(nbActiveInternodesOnMainstem));
  end;
end;

procedure ComputeInternodeLengthOnMainstem_ng(var instance : TInstance; var internodeLengthOnMainstem : Double);
var
  state, le1, le2, i1, i2 : Integer;
  currentInstance, refTiller : TInstance;
  isMainstem, inLength : Double;
begin
  internodeLengthOnMainstem := 0;
  state := (instance as TEntityInstance).GetCurrentState();
  SRwriteln('state --> ' + IntToStr(state));
  if (state < 4) then
  begin
    internodeLengthOnMainstem := 0;
    SRwriteln('internodeLengthOnMainstem --> ' + FloatToStr(internodeLengthOnMainstem));
  end
  else
  begin
    internodeLengthOnMainstem := 0;
    le1 := (instance as TEntityInstance).LengthTInstanceList();
    for i1 := 0 to le1 - 1 do
    begin
      currentInstance := (instance as TEntityInstance).GetTInstance(i1);
      if (currentInstance is TEntityInstance) then
      begin
        if ((currentInstance as TEntityInstance).GetCategory() = 'Tiller') then
        begin
          isMainstem := (currentInstance as TEntityInstance).GetTAttribute('isMainstem').GetCurrentSample().value;
          if (isMainstem = 1) then
          begin
            le2 := (currentInstance as TEntityInstance).LengthTInstanceList();
            for i2 := 0 to le2 - 1 do
            begin
              refTiller := (currentInstance as TEntityInstance).GetTInstance(i2);
              if (refTiller is TEntityInstance) then
              begin
                if ((refTiller as TEntityInstance).GetCategory() = 'Internode') then
                begin
                  inLength := (refTiller as TEntityInstance).GetTAttribute('LIN').GetCurrentSample().value;
                  SRwriteln(refTiller.GetName() + ' length --> ' + FloatToStr(inLength));
                  internodeLengthOnMainstem := internodeLengthOnMainstem + inLength;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
    SRwriteln('internodeLengthOnMainstem --> ' + FloatToStr(internodeLengthOnMainstem));
  end;
end;

procedure ComputeLeafNumberOnMainstem_ng(var instance : TInstance; var leafNumberOnMainstem : Double);
var
  i1, i2, le1, le2 : Integer;
  currentInstance, refTiller : TInstance;
  isMainstem, leafState : Double;
begin
  leafNumberOnMainstem := 0;
  le1 := (instance as TEntityInstance).LengthTInstanceList();
  for i1 := 0 to le1 - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i1);
    if (currentInstance is TEntityInstance) then
    begin
      if ((currentInstance as TEntityInstance).GetCategory() = 'Tiller') then
      begin
        isMainstem := (currentInstance as TEntityInstance).GetTAttribute('isMainstem').GetCurrentSample().value;
        if (isMainstem = 1) then
        begin
          le2 := (currentInstance as TEntityInstance).LengthTInstanceList();
          for i2 := 0 to le2 - 1 do
          begin
            refTiller := (currentInstance as TEntityInstance).GetTInstance(i2);
            if (refTiller is TEntityInstance) then
            begin
              if ((refTiller as TEntityInstance).GetCategory() = 'Leaf') then
              begin
                leafState := (refTiller as TEntityInstance).GetCurrentState();
                if ((leafState <> 2000) or (leafState <> 500)) then
                begin
                  leafNumberOnMainstem := leafNumberOnMainstem + 1;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
  SRwriteln('leafNumberOnMainstem --> ' + FloatToStr(leafNumberOnMainstem));
end;

procedure ComputeInternodeBiomass_ng(var instance : TInstance; const Volume, density : Double; var Biomass : Double);
var
  sample : TSample;
  refAttribute : TAttribute;
begin
  SRwriteln('toto');
  refAttribute := (instance as TEntityInstance).GetTAttribute('no_growth_at_init');
  sample := refAttribute.GetCurrentSample();
  SRwriteln('no_growth_at_init --> ' + FloatToStr(sample.value));
  if (sample.value = 1) then
  begin
    Biomass := 0;
    sample.value := 0;
    refAttribute.SetSample(sample);
    SRwriteln('no growth et init, on ne calcul pas la biomasse');
    SRwriteln('Biomass --> ' + FloatToStr(Biomass));
  end
  else
  begin
    Biomass := Volume * density;
    SRwriteln('Volume  --> ' + FloatToStr(Volume));
    SRwriteln('density --> ' + FloatToStr(density));
    SRwriteln('Biomass --> ' + FloatToStr(Biomass));
  end;
end;

procedure ComputeNbLeafMainstem50_ng(var instance : TInstance; var NbLeafMainstem : Double);
var
  currentInstance1, currentInstance2 : TInstance;
  i1, i2, le1, le2 : Integer;
  state : Integer;
  isMainstem : Double;
  bladeArea, correctedBladeArea, ratio : Double;
begin
  NbLeafMainstem := 0;
  le1 := (instance as TEntityInstance).LengthTInstanceList();
  for i1 := 0 to le1 - 1 do
  begin
    currentInstance1 := (instance as TEntityInstance).GetTInstance(i1);
    if (currentInstance1 is TEntityInstance) then
    begin
      if ((currentInstance1 as TEntityInstance).GetCategory() = 'Tiller') then
      begin
        isMainstem := (currentInstance1 as TEntityInstance).GetTAttribute('isMainstem').GetCurrentSample().value;
        if (isMainstem = 1) then
        begin
          SRwriteln('Tiller name        --> ' + currentInstance1.GetName() + ' is on mainstem');
          le2 := (currentInstance1 as TEntityInstance).LengthTInstanceList();
          for i2 := 0 to le2 - 1 do
          begin
            currentInstance2 := (currentInstance1 as TEntityInstance).GetTInstance(i2);
            if (currentInstance2 is TEntityInstance) then
            begin
              if ((currentInstance2 as TEntityInstance).GetCategory() = 'Leaf') then
              begin
                SRwriteln('Leaf name          --> ' + currentInstance2.GetName());
                state := (currentInstance2 as TEntityInstance).GetCurrentState();
                SRwriteln('state              --> ' + IntToStr(state));
                if (state = 10) then
                begin
                  NbLeafMainstem := NbLeafMainstem + 1;
                  SRwriteln('nbLeafMainstem     --> ' + FloatToStr(NbLeafMainstem));
                end
                else if (state = 20) then
                begin
                  NbLeafMainstem := NbLeafMainstem + 1;
                  SRwriteln('nbLeafMainstem     --> ' + FloatToStr(NbLeafMainstem));
                end
                else if ((state = 2) or (state = 3)) then
                begin
                  NbLeafMainstem := NbLeafMainstem + 1;
                  SRwriteln('nbLeafMainstem     --> ' + FloatToStr(NbLeafMainstem));
                end
                else if ((state = 4) or (state = 5)) then
                begin
                  bladeArea := (currentInstance2 as TEntityInstance).GetTAttribute('bladeArea').GetCurrentSample().value;
                  SRwriteln('bladeArea          --> ' + FloatToStr(bladeArea));
                  correctedBladeArea := (currentInstance2 as TEntityInstance).GetTAttribute('correctedBladeArea').GetCurrentSample().value;
                  SRwriteln('correctedBladeArea --> ' + FloatToStr(correctedBladeArea));
                  if (correctedBladeArea <> 0) then
                  begin
                    ratio := correctedBladeArea / bladeArea;
                    SRwriteln('ratio              --> ' + FloatToStr(ratio));
                    if (ratio >= 0.5) then
                    begin
                      NbLeafMainstem := NbLeafMainstem + 1;
                      SRwriteln('nbLeafMainstem     --> ' + FloatToStr(NbLeafMainstem));
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure ComputeNbLeafMainstem_ng(var instance : TInstance; var NbLeafMainstem : Double);
var
  currentInstance1, currentInstance2 : TInstance;
  i1, i2, le1, le2 : Integer;
  state : Integer;
  isMainstem : Double;
begin
  NbLeafMainstem := 0;
  le1 := (instance as TEntityInstance).LengthTInstanceList();
  for i1 := 0 to le1 - 1 do
  begin
    currentInstance1 := (instance as TEntityInstance).GetTInstance(i1);
    if (currentInstance1 is TEntityInstance) then
    begin
      if ((currentInstance1 as TEntityInstance).GetCategory() = 'Tiller') then
      begin
        isMainstem := (currentInstance1 as TEntityInstance).GetTAttribute('isMainstem').GetCurrentSample().value;
        if (isMainstem = 1) then
        begin
          SRwriteln('Tiller name        --> ' + currentInstance1.GetName() + ' is on mainstem');
          le2 := (currentInstance1 as TEntityInstance).LengthTInstanceList();
          for i2 := 0 to le2 - 1 do
          begin
            currentInstance2 := (currentInstance1 as TEntityInstance).GetTInstance(i2);
            if (currentInstance2 is TEntityInstance) then
            begin
              if ((currentInstance2 as TEntityInstance).GetCategory() = 'Leaf') then
              begin
                SRwriteln('Leaf name          --> ' + currentInstance2.GetName());
                state := (currentInstance2 as TEntityInstance).GetCurrentState();
                SRwriteln('state              --> ' + IntToStr(state));
                if ((state <> 2000) and (state <> 500)) then
                begin
                  NbLeafMainstem := NbLeafMainstem + 1;
                  SRwriteln('NbLeafMainstem     --> ' + FloatToStr(NbLeafMainstem));
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure ComputeTotalSenescedLeafBiomass_ng(var instance : TInstance; var totalSenescedLeafBiomas : Double);
var
  contribution : Double;
begin
  contribution := (instance as TEntityInstance).GetTAttribute('sumOfDailySenescedLeafBiomassTiller').GetCurrentSample().value;
  totalSenescedLeafBiomas := totalSenescedLeafBiomas + contribution;
  SRwriteln('contribution            --> ' + FloatToStr(contribution));
  SRwriteln('totalSenescedLeafBiomas --> ' + FloatToStr(totalSenescedLeafBiomas));
end;

procedure SaveSupplyCulm_ng(var instance : TInstance; const nbDayOfSimulation : Double);
const
  fileName = 'supply_per_culm_per_day.txt';
  tab = #09;
var
  myFile : TextFile;
  i, le : Integer;
  currentInstance : TInstance;
  supplyCulm : Double;
  line : String;
begin
  AssignFile(myFile, fileName);
  if (nbDayOfSimulation = 1) then
  begin
    Rewrite(myFile);
  end
  else
  begin
    Append(myfile);
  end;
  le := (instance as TEntityInstance).LengthTInstanceList();
  line := '';
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      if ((currentInstance as TEntityInstance).GetCategory() = 'Tiller') then
      begin
        supplyCulm := (currentInstance as TEntityInstance).GetTAttribute('supply_tiller').GetCurrentSample().value;
        SRwriteln('supply de : ' + currentInstance.GetName() + ' --> ' + FloatToStr(supplyCulm));
        line := line + FloatToStr(supplyCulm) + tab;
      end;
    end;
  end;
  Writeln(myFile, line);
  Closefile(myFile);
end;

function InternodesHeight(var instance : TInstance; const rank : Double) : Double;
var
  i, le, state : Integer;
  internodeRank, internodeLength : Double;
  currentInstance : TInstance;
  returnValue : Double;
begin
  returnValue := 0;
  le := (instance as TEntityInstance).LengthTAttributeList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      if ((currentInstance as TEntityInstance).GetCategory() = 'Internode') then
      begin
        state := (currentInstance as TEntityInstance).GetCurrentState();
        if ((state <> 1000) and (state <> 2000) and (state <> -1)) then
        begin
          internodeRank := (currentInstance as TEntityInstance).GetTAttribute('rank').GetCurrentSample().value;
          if (internodeRank <= rank) then
          begin
            internodeLength := (currentInstance as TEntityInstance).GetTAttribute('LIN').GetCurrentSample().value;
            returnValue := returnValue + internodeLength;
          end;
        end;
      end;
    end;
  end;
  Result := returnValue;
end;

procedure DataForR_ng(var instance : TInstance);
const
  N = 16;
type
  TLine = array[0..N - 1] of string;
var
  i, j, i1, len1, i2, len2 : Integer;
  tabLen : Integer;
  tab : array of TLine;
  header, line : TLine;
  entityInstance1, entityInstance2 : TEntityInstance;
  currentInstance1, currentInstance2 : TInstance;
  id, axis, rank, state, ttBegin, age, len, width, bladeArea, bladeAreaCorr : string;
  biomass, biomassCorr, ll_bl, bladeLength, sheathLength, bladeHeight : string;
  lengthDoubleValue, ll_blDoubleValue, bladeLengthDoubleValue, sheathLengthDoubleValue : Double;
  bladeHeightDoubleValue, rankDoubleValue : Double;
  PAI, density, fcstr, rolling_a, rolling_b, lai, nbDayOfSimulation, radiation, TT : Double;
  stateIntegerValue : Integer;
  myFile : TextFile;
begin
  header[0] := 'id';
  header[1] := 'axis';
  header[2] := 'rank';
  header[3] := 'state';
  header[4] := 'ttBegin';
  header[5] := 'age';
  header[6] := 'length';
  header[7] := 'width';
  header[8] := 'bladeArea';
  header[9] := 'bladeAreaCorr';
  header[10] := 'biomass';
  header[11] := 'biomassCorr';
  header[12] := 'll_bl';
  header[13] := 'bladeLength';
  header[14] := 'sheathLength';
  header[15] := 'bladeHeight';
  tabLen := 1;
  SetLength(tab, tabLen);
  tab[tabLen - 1] := header;
  tabLen := tabLen + 1;
  SetLength(tab, tabLen);
  len1 := (instance as TEntityInstance).LengthTInstanceList();
  for i1 := 0 to (len1 - 1) do
  begin
    currentInstance1 := (instance as TEntityInstance).GetTInstance(i1);
    if (currentInstance1 is TEntityInstance) then
    begin
      entityInstance1 := currentInstance1 as TEntityInstance;
      if (entityInstance1.GetCategory() = 'Tiller') then
      begin
        len2 := entityInstance1.LengthTInstanceList();
        for i2 := 0 to (len2 - 1) do
        begin
          currentInstance2 := entityInstance1.GetTInstance(i2);
          if (currentInstance2 is TEntityInstance) then
          begin
            entityInstance2 := currentInstance2 as TEntityInstance;
            if (entityInstance2.GetCategory() = 'Leaf') then
            begin
              stateIntegerValue := entityInstance2.GetCurrentState();
              if ((stateIntegerValue <> 500) and (stateIntegerValue <> 1000) and (stateIntegerValue <> 2000) and (stateIntegerValue <> -1)) then
              begin
                id := entityInstance2.GetName();
                SRwriteln('id            --> ' + id);
                axis := 'Tiller';
                SRwriteln('axis          --> ' + axis);
                rankDoubleValue := entityInstance2.GetTAttribute('rank').GetCurrentSample().value;
                rank := FloatToStr(rankDoubleValue);
                SRwriteln('rank          --> ' + rank);
                state := IntToStr(entityInstance2.GetCurrentState());
                SRwriteln('state         --> ' + state);
                ttBegin := FloatToStr(entityInstance2.GetTAttribute('thermalTimeAtInitiation').GetCurrentSample().value);
                SRwriteln('ttBegin       --> ' + ttBegin);
                age := FloatToStr(entityInstance2.GetTAttribute('time_from_app').GetCurrentSample().value);
                SRwriteln('age           --> ' + age);
                lengthDoubleValue := entityInstance2.GetTAttribute('len').GetCurrentSample().value;
                len := FloatToStr(lengthDoubleValue);
                SRwriteln('len           --> ' + len);
                width := FloatToStr(entityInstance2.GetTAttribute('width').GetCurrentSample().value);
                SRwriteln('width         --> ' + width);
                bladeArea := FloatToStr(entityInstance2.GetTAttribute('bladeArea').GetCurrentSample().value);
                SRwriteln('bladeArea     --> ' + bladeArea);
                bladeAreaCorr := FloatToStr(entityInstance2.GetTAttribute('correctedBladeArea').GetCurrentSample().value);
                SRwriteln('bladeAreaCorr --> ' + bladeAreaCorr);
                biomass := FloatToStr(entityInstance2.GetTAttribute('biomass').GetCurrentSample().value);
                SRwriteln('biomass       --> ' + biomass);
                biomassCorr := FloatToStr(entityInstance2.GetTAttribute('correctedLeafBiomass').GetCurrentSample().value);
                SRwriteln('biomassCorr   --> ' + biomassCorr);
                ll_blDoubleValue := entityInstance2.GetTAttribute('LL_BL').GetCurrentSample().value;
                ll_bl := FloatToStr(ll_blDoubleValue);
                SRwriteln('ll_bl         --> ' + ll_bl);
                bladeLengthDoubleValue := lengthDoubleValue / ll_blDoubleValue;
                bladeLength := FloatToStr(bladeLengthDoubleValue);
                SRwriteln('bladeLength   --> ' + bladeLength);
                sheathLengthDoubleValue := lengthDoubleValue - bladeLengthDoubleValue;
                sheathLength := FloatToStr(sheathLengthDoubleValue);
                SRwriteln('sheathLength  --> ' + sheathLength);
                bladeHeightDoubleValue := InternodesHeight(currentInstance1, rankDoubleValue) + sheathLengthDoubleValue;
                bladeHeight := FloatToStr(bladeHeightDoubleValue);
                SRwriteln('bladeHeight   --> ' + bladeHeight);
                line[0] := id;
                line[1] := axis;
                line[2] := rank;
                line[3] := state;
                line[4] := ttBegin;
                line[5] := age;
                line[6] := len;
                line[7] := width;
                line[8] := bladeArea;
                line[9] := bladeAreaCorr;
                line[10] := biomass;
                line[11] := biomassCorr;
                line[12] := ll_bl;
                line[13] := bladeLength;
                line[14] := sheathLength;
                line[15] := bladeHeight;
                tab[tabLen - 1] := line;
                tabLen := tabLen + 1;
                SetLength(tab, tabLen);
              end;
            end;
          end;
        end;
      end;
    end;
  end;
  AssignFile(myFile, 'D:\Mes donnees\ecophen\trunk\temporaryFiles\param_feuilles.txt');
  Rewrite(myFile);
  line := tab[0];
  for i := 0 to High(line) do
  begin
    Write(myFile, line[i]);
    Write(myfile, #9);
  end;
  Writeln(myFile, '');
  for i := 1 to High(tab) - 1 do
  begin
    line := tab[i];
    for j := 0 to High(line) do
    begin
      Write(myFile, line[j]);
      Write(myfile, #9);
    end;
    Writeln(myFile, '');
  end;
  CloseFile(myFile);
  AssignFile(myFile, 'D:\Mes donnees\ecophen\trunk\temporaryFiles\param.txt');
  Rewrite(myFile);
  nbDayOfSimulation := (instance as TEntityInstance).GetTAttribute('nbDayOfSimulation').GetCurrentSample().value;
  SRwriteln('nbDayOfSimulation --> ' + FloatToStr(nbDayOfSimulation));
  PAI := (instance as TEntityInstance).GetTAttribute('PAI').GetCurrentSample().value;
  SRwriteln('PAI               --> ' + FloatToStr(PAI));
  density := (instance as TEntityInstance).GetTAttribute('density').GetCurrentSample().value;
  SRwriteln('density           --> ' + FloatToStr(density));
  fcstr := ((instance as TEntityInstance).GetTAttribute('fcstr') as TAttributeTableOut).GetCurrentSample().value;
  SRwriteln('fcstr             --> ' + FloatToStr(fcstr));
  rolling_a := (instance as TEntityInstance).GetTAttribute('Rolling_A').GetCurrentSample().value;
  SRwriteln('rolling_a         --> ' + FloatToStr(rolling_a));
  rolling_b := (instance as TEntityInstance).GetTAttribute('Rolling_B').GetCurrentSample().value;
  SRwriteln('rolling_b         --> ' + FloatToStr(rolling_b));
  lai := PAI * (rolling_b + (rolling_a * fcstr)) * density / 10000;
  SRwriteln('lai               --> ' + FloatToStr(lai));
  radiation := (instance as TEntityInstance).GetTAttribute('radiation').GetCurrentSample().value;
  SRwriteln('par               --> ' + FloatToStr(radiation));
  TT := ((instance as TEntityInstance).GetTAttribute('TT') as TAttributeTableOut).GetCurrentSample().value;
  SRwriteln('TT               --> ' + FloatToStr(TT));
  Writeln(myFile, 'date = ' + FloatToStr(nbDayOfSimulation));
  Writeln(myFile, 'par = ' + FloatToStr(radiation));
  Writeln(myFile, 'lai = ' + FloatToStr(lai));
  Writeln(myFile, 'density = ' + FloatToStr(density));
  Writeln(myFile, 'TT = ' + FloatToStr(TT));
  CloseFile(myFile);
end;

procedure ReadAssimByAxisFromR_ng(var instance : TInstance);
var
  Si : STARTUPINFO;
  Pi : PROCESS_INFORMATION;
  assimStr : string;
  myFile : TextFile;
  tab : array of Double;
  i, le, index : Integer;
  assim : Double;
  currentInstance : TInstance;
  sample : TSample;
  stateTiller : Integer;
  totalAssim : Double;
  attributeSupply, attributeAssim : TAttributeTableOut;
begin
  ZeroMemory(@Si, SizeOf(STARTUPINFO));
  Si.dwFlags := STARTF_USESHOWWINDOW;
  Si.wShowWindow := SW_HIDE;
  //si.wShowWindow := SW_NORMAL;
  CreateProcess(nil, Pchar('D:\Mes donnees\ecophen\trunk\temporaryFiles\couplage.bat'), nil, nil, True, 0, nil, nil, Si, Pi);
  WaitForSingleObject(Pi.hProcess, INFINITE);
  AssignFile(myFile, 'D:\Mes donnees\ecophen\trunk\temporaryFiles\assimByAxis.txt');
  Reset(myFile);
  i := 1;
  index := 1;
  totalAssim := 0;
  while not (Eof(myFile)) do
  begin
    Readln(myFile, assimStr);
    assim := StrToFloat(assimStr);
    SRwriteln('assim from file --> ' + FloatToStr(assim));
    SetLength(tab, i);
    tab[i - 1] := assim;
    i := i + 1;
    SRwriteln('i --> ' + FloatToStr(i));
    totalAssim := totalAssim + assim;
  end;
  CloseFile(myFile);
  attributeAssim := ((instance as TEntityInstance).GetTAttribute('assim') as TAttributeTableOut);
  sample := attributeAssim.GetCurrentSample();
  sample.value := totalAssim;
  attributeAssim.SetSample(sample);
  attributeSupply := ((instance as TEntityInstance).GetTAttribute('supply') as TAttributeTableOut);
  attributeSupply.SetSample(sample);
  le := (instance as TEntityInstance).LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      if ((currentInstance as TEntityInstance).GetCategory() = 'Tiller') then
      begin
        SRwriteln('Tiller name --> ' + currentInstance.GetName());
        stateTiller := (currentInstance as TEntityInstance).GetCurrentState();
        case stateTiller of
          4, 5, 6, 7, 9, 10 :
          begin
            SRwriteln('index --> ' + IntToStr(index));
            sample := (currentInstance as TEntityInstance).GetTAttribute('assim_tiller').GetCurrentSample();
            sample.value := tab[index];
            SRwriteln('assim_tiller --> ' + FloatToStr(sample.value));
            (currentInstance as TEntityInstance).GetTAttribute('assim_tiller').SetSample(sample);
            sample := (currentInstance as TEntityInstance).GetTAttribute('supply_tiller').GetCurrentSample();
            sample.value := tab[index];
            (currentInstance as TEntityInstance).GetTAttribute('supply_tiller').SetSample(sample);
            index := index + 1;
          end;
        end;
      end;
    end;
  end;
end;

procedure KillSenescLeaves_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  KillSenescLeaves_ng(instance, T[0]);
end;

procedure ComputePHT_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputePHT_ng(instance, T[0], T[1], T[2], T[3], T[4], T[5], T[6], T[7], T[8]);
end;

procedure ComputeLeafPredimensionnement_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeLeafPredimensionnement_ng(instance, T[0], T[1], T[2], T[3], T[4], T[5], T[6]);
end;

procedure CountNbTiller_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  CountNbTiller_ng(instance, T[0]);
end;

procedure CountOfNbTillerWithMoreNbLeafEnablingTilleringLeaves_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  CountOfNbTillerWithMoreNbLeafEnablingTilleringLeaves_ng(instance, T[0], T[1]);
end;

procedure CreateTillersPhytomer_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  CreateTillersPhytomer_ng(instance, T[0], T[1], T[2], T[3], T[4], T[5], T[6], T[7], T[8], T[9], T[10], T[11]);
end;

procedure ComputeLeafExpTime_ngDyn(var T : TPointerProcParam);
begin
  ComputeLeafExpTime_ng(T[0], T[1], T[2], T[3]);
end;

procedure KillYoungestTillerOldestLeaf_ngDyn(var instance : TInstance ; var T : TPointerProcParam);
begin
  KillYoungestTillerOldestLeaf_ng(instance, T[0], T[1], T[2], T[3], T[4], T[5], T[6], T[7]);
end;

procedure ComputeLeafInternodeBiomassCulms_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeLeafInternodeBiomassCulms_ng(instance);
end;

procedure ComputeSumOfInternodeBiomassOnCulm_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeSumOfInternodeBiomassOnCulm_ng(instance, T[0]);
end;

procedure SumOfDailyComputedReallocBiomass_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  SumOfDailyComputedReallocBiomass_ng(instance, T[0]);
end;
procedure SumOfDailySenescedLeafBiomass_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  SumOfDailySenescedLeafBiomass_ng(instance, T[0]);
end;

procedure ComputeMaxReservoirCulms_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeMaxReservoirCulms_ng(instance);
end;

procedure ComputeBiomassInternodeStruct_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeBiomassInternodeStruct_ng(instance, T[0]);
end;

procedure ComputeLengthPeduncles_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeLengthPeduncles_ng(instance);
end;

procedure SetUpTillerStockPre_Elong_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  SetUpTillerStockPre_Elong_ng(instance);
end;

procedure ComputeLastDemandCulms_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeLastDemandCulms_ng(instance, T[0]);
end;

procedure ComputeTmpCulms_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeTmpCulms_ng(instance);
end;

procedure ComputeDeficitCulms_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeDeficitCulms_ng(instance);
end;

procedure ComputeSurplusCulms_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeSurplusCulms_ng(instance);
end;

procedure ComputeStockCulms_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
   ComputeStockCulms_ng(instance);
end;

procedure ComputeSurplusPlant_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeSurplusPlant_ng(instance);
end;

procedure ComputeSupplyPlant_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeSupplyPlant_ng(instance);
end;

procedure ComputeStockPlant_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeStockPlant_ng(instance);
end;

procedure ComputeDeficitPlant_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeDeficitPlant_ng(instance);
end;

procedure ComputeTestIcCulm_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeTestIcCulm_ng(instance, T[0]);
end;

procedure ComputeGetFcstr_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeGetFcstr_ng(instance, T[0]);
end;

procedure ComputeMaxReservoirLeafCulm_ngDyn(var T : TPointerProcParam);
begin
  ComputeMaxReservoirLeafCulm_ng(T[0], T[1], T[2]);
end;

procedure ComputeMaxReservoirInternodeCulm_ngDyn(var T : TPointerProcParam);
begin
  ComputeMaxReservoirInternodeCulm_ng(T[0], T[1], T[2]);
end;

procedure ComputeBalanceSheet_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeBalanceSheet_ng(instance);
end;

procedure ComputeBalanceSheetAssimByAxisFromR_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeBalanceSheetAssimByAxisFromR_ng(instance);
end;

procedure ComputeStockInternodeOnCulm_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeStockInternodeOnCulm_ng(instance);
end;

procedure KillOldestLeafMorphoGenesis_ngDyn(var instance : TInstance ; var T : TPointerProcParam);
begin
  KillOldestLeafMorphoGenesis_ng(instance, T[0], T[1], T[2], T[3], T[4], T[5]);
end;

procedure KillOldestLeafTiller_ngDyn(var instance : TInstance ; var T : TPointerProcParam);
begin
  KillOldestLeafTiller_ng(instance, T[0], T[1], T[2], T[3]);
end;

procedure SumOfDailyComputedReallocBiomassOnCulm_ngDyn(var instance : TInstance ; var T : TPointerProcParam);
begin
  SumOfDailyComputedReallocBiomassOnCulm_ng(instance, T[0]);
end;

procedure SumOfDailySenescedLeafBiomassOnCulm_ngDyn(var instance : TInstance ; var T : TPointerProcParam);
begin
  SumOfDailySenescedLeafBiomassOnCulm_ng(instance, T[0]);
end;

procedure KillTillerWithoutLigulatedLeaf_ngDyn(var instance : TInstance ; var T : TPointerProcParam);
begin
  KillTillerWithoutLigulatedLeaf_ng(instance, T[0]);
end;

procedure ComputeDayDemand_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeDayDemand_ng(instance, T[0]);
end;

procedure LeafTransitionToActive_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  LeafTransitionToActive_ng(instance);
end;

procedure InternodeTransitionToActive_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  InternodeTransitionToActive_ng(instance);
end;

procedure SaveTableData_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  SaveTableData_ng(instance);
end;

procedure TransitionToLiguleState_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  TransitionToLiguleState_ng(instance, T[0], T[1], T[2], T[3], T[4]);
end;

procedure ComputeBiomInternodeMainstem_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeBiomInternodeMainstem_ng(instance, T[0]);
end;

procedure ComputeBiomLeafMainstem_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeBiomLeafMainstem_ng(instance, T[0]);
end;

procedure ComputeBiomStem_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeBiomStem_ng(instance, T[0]);
end;

procedure ComputeStockInternodePlante_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeStockInternodePlante_ng(instance, T[0]);
end;

procedure ComputeLER_ngDyn(var T : TPointerProcParam);
begin
  ComputeLER_ng(T[0], T[1], T[2], T[3], T[4], T[5], T[6]);
end;

procedure ComputeReductionINER_ngDyn(var T : TPointerProcParam);
begin
   ComputeReductionINER_ng(T[0], T[1], T[2], T[3], T[4], T[5], T[6]);
end;

procedure ComputeWeightPanicle_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeWeightPanicle_ng(instance, T[0], T[1]);
end;

procedure ComputePanicleNumber_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputePanicleNumber_ng(instance, T[0]);
end;

procedure ComputeFirstLastExpandedInternodeDiameterMainstem_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeFirstLastExpandedInternodeDiameterMainstem_ng(instance, T[0], T[1], T[2], T[3]);
end;

procedure ComputeNbActiveInternodesOnMainstem_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeNbActiveInternodesOnMainstem_ng(instance, T[0]);
end;

procedure ComputeInternodeLengthOnMainstem_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeInternodeLengthOnMainstem_ng(instance, T[0]);
end;

procedure ComputeLeafNumberOnMainstem_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeLeafNumberOnMainstem_ng(instance, T[0]);
end;

procedure ComputeInternodeBiomass_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeInternodeBiomass_ng(instance, T[0], T[1], T[2]);
end;

procedure ComputeNbLeafMainstem_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeNbLeafMainstem_ng(instance, T[0]);
end;

procedure ComputeNbLeafMainstem50_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeNbLeafMainstem50_ng(instance, T[0]);
end;

procedure ComputeBiomLeafMainstemGreen_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeBiomLeafMainstemGreen_ng(instance, T[0]);
end;

procedure ComputeTotalSenescedLeafBiomass_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ComputeTotalSenescedLeafBiomass_ng(instance, T[0]);
end;

procedure SaveSupplyCulm_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  SaveSupplyCulm_ng(instance, T[0]);
end;

procedure DataForR_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  DataForR_ng(instance);
end;

procedure ReadAssimByAxisFromR_ngDyn(var instance : TInstance; var T : TPointerProcParam);
begin
  ReadAssimByAxisFromR_ng(instance);
end;


initialization

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',KillSenescLeaves_ngDyn,['deadLeafNb', 'kInOut']);
PROC_DECLARATION.SetProcName('KillSenescLeaves_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputePHT_ngDyn,['G_L', 'kIn', 'LL_BL', 'kIn', 'stockPlant', 'kIn', 'stockInternodePlant', 'kIn', 'structLeaf', 'kIn', 'PHT', 'kInOut', 'SLALFEL', 'kInOu', 'AreaLFEL', 'kInOut', 'DWLFEL', 'kInOut']);
PROC_DECLARATION.SetProcName('ComputePHT_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeLeafPredimensionnement_ngDyn,['isFirstLeaf', 'kIn', 'isOnMainstem', 'kIn', 'Lef1', 'kIn', 'MGR', 'kIn', 'testIc', 'kIn', 'fcstr', 'kIn', 'predimOfCurrentLeaf', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeLeafPredimensionnement_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',CountNbTiller_ngDyn,['total', 'kOut']);
PROC_DECLARATION.SetProcName('CountNbTiller_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',CountOfNbTillerWithMoreNbLeafEnablingTilleringLeaves_ngDyn,['nbLeafEnablingTillering', 'kIn', 'nbTillerWithMore4Leaves', 'kOut']);
PROC_DECLARATION.SetProcName('CountOfNbTillerWithMoreNbLeafEnablingTilleringLeaves_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',CreateTillersPhytomer_ngDyn,['boolCrossedPlasto', 'kIn', 'Ic', 'kIn', 'Ict', 'kIn', 'exeOrder', 'kIn', 'P', 'kIn', 'resp_Ict', 'kIn', 'thresINER', 'kIn', 'slopeINER', 'kIn', 'leafStockMax', 'kIn', 'phenoStageAtCreation', 'kIn', 'maximumReserveInInternode', 'kIn', 'nbTiller', 'kInOut']);
PROC_DECLARATION.SetProcName('CreateTillersPhytomer_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeLeafExpTime_ngDyn,['predim', 'kIn', 'len', 'kIn', 'LER', 'kIn', 'exp_time', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeLeafExpTime_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',KillYoungestTillerOldestLeaf_ngDyn,['reallocationCoeff', 'kIn', 'nbLeafEnablingTillering', 'kIn', 'deficit', 'kInOut', 'stock', 'kInOut', 'senesc_dw', 'kInOut', 'deadleafNb', 'kInOut', 'deadtillerNb', 'kInOut', 'computedReallocBiomass', 'kInOut']);
PROC_DECLARATION.SetProcName('KillYoungestTillerOldestLeaf_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeLeafInternodeBiomassCulms_ngDyn,[]);
PROC_DECLARATION.SetProcName('ComputeLeafInternodeBiomassCulms_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeSumOfInternodeBiomassOnCulm_ngDyn,['total', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeSumOfInternodeBiomassOnCulm_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SumOfDailyComputedReallocBiomass_ngDyn,['total', 'kOut']);
PROC_DECLARATION.SetProcName('SumOfDailyComputedReallocBiomass_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SumOfDailySenescedLeafBiomass_ngDyn,['total', 'kOut']);
PROC_DECLARATION.SetProcName('SumOfDailySenescedLeafBiomass_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeMaxReservoirCulms_ngDyn,[]);
PROC_DECLARATION.SetProcName('ComputeMaxReservoirCulms_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeBiomassInternodeStruct_ngDyn,['biomInternodeStruct', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeBiomassInternodeStruct_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeLengthPeduncles_ngDyn,[]);
PROC_DECLARATION.SetProcName('ComputeLengthPeduncles_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SetUpTillerStockPre_Elong_ngDyn,[]);
PROC_DECLARATION.SetProcName('SetUpTillerStockPre_Elong_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeLastDemandCulms_ngDyn,['lastDemand', 'kInOut']);
PROC_DECLARATION.SetProcName('ComputeLastDemandCulms_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeTmpCulms_ngDyn,[]);
PROC_DECLARATION.SetProcName('ComputeTmpCulms_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeDeficitCulms_ngDyn,[]);
PROC_DECLARATION.SetProcName('ComputeDeficitCulms_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeSurplusCulms_ngDyn,[]);
PROC_DECLARATION.SetProcName('ComputeSurplusCulms_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeStockCulms_ngDyn,[]);
PROC_DECLARATION.SetProcName('ComputeStockCulms_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeSurplusPlant_ngDyn,[]);
PROC_DECLARATION.SetProcName('ComputeSurplusPlant_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeSupplyPlant_ngDyn,[]);
PROC_DECLARATION.SetProcName('ComputeSupplyPlant_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeStockPlant_ngDyn,[]);
PROC_DECLARATION.SetProcName('ComputeStockPlant_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeDeficitPlant_ngDyn,[]);
PROC_DECLARATION.SetProcName('ComputeDeficitPlant_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeTestIcCulm_ngDyn,['testIc', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeTestIcCulm_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeGetFcstr_ngDyn,['fcstr', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeGetFcstr_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeMaxReservoirLeafCulm_ngDyn,['leafStockMax', 'kIn', 'sumOfLeafBiomass', 'kIn', 'maxReservoirDispoLeaf', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeMaxReservoirLeafCulm_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeMaxReservoirInternodeCulm_ngDyn,['maximumReserveInInternode', 'kIn', 'sumOfInternodeBiomass', 'kIn', 'maxReservoidDispoInternode', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeMaxReservoirInternodeCulm_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeBalanceSheet_ngDyn,[]);
PROC_DECLARATION.SetProcName('ComputeBalanceSheet_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeBalanceSheetAssimByAxisFromR_ngDyn,[]);
PROC_DECLARATION.SetProcName('ComputeBalanceSheetAssimByAxisFromR_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeStockInternodeOnCulm_ngDyn,[]);
PROC_DECLARATION.SetProcName('ComputeStockInternodeOnCulm_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',KillOldestLeafMorphoGenesis_ngDyn,['realocationCoeff', 'kIn', 'deficit', 'kInOut', 'stock', 'kInOut', 'senesc_dw', 'kInOut', 'deadleafNb', 'kInOut', 'computedReallocBiomass', 'kInOut']);
PROC_DECLARATION.SetProcName('KillOldestLeafMorphoGenesis_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',KillOldestLeafTiller_ngDyn,['deficit', 'kInOut', 'stock', 'kInOut', 'activeLeafNb', 'kInOut', 'leafNb', 'kInOut']);
PROC_DECLARATION.SetProcName('KillOldestLeafTiller_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SumOfDailyComputedReallocBiomassOnCulm_ngDyn,['sumOfDailyComputedReallocBiomass', 'kOut']);
PROC_DECLARATION.SetProcName('SumOfDailyComputedReallocBiomassOnCulm_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SumOfDailySenescedLeafBiomassOnCulm_ngDyn,['sumOfDailySenescedLeafBiomass', 'kOut']);
PROC_DECLARATION.SetProcName('SumOfDailySenescedLeafBiomassOnCulm_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',KillTillerWithoutLigulatedLeaf_ngDyn,['nbTiller', 'kInOut']);
PROC_DECLARATION.SetProcName('KillTillerWithoutLigulatedLeaf_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeDayDemand_ngDyn,['dayDemand', 'kInOut']);
PROC_DECLARATION.SetProcName('ComputeDayDemand_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',LeafTransitionToActive_ngDyn,[]);
PROC_DECLARATION.SetProcName('LeafTransitionToActive_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',InternodeTransitionToActive_ngDyn,[]);
PROC_DECLARATION.SetProcName('InternodeTransitionToActive_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SaveTableData_ngDyn,[]);
PROC_DECLARATION.SetProcName('SaveTableData_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',TransitionToLiguleState_ngDyn,['len', 'kIn', 'predim', 'kIn', 'isOnMainstem', 'kIn', 'demand', 'kInOut', 'lastDemand', 'kInOut']);
PROC_DECLARATION.SetProcName('TransitionToLiguleState_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeBiomInternodeMainstem_ngDyn,['biomInternodeMainstem', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeBiomInternodeMainstem_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeBiomLeafMainstem_ngDyn,['biomLeafMainstem', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeBiomLeafMainstem_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeBiomStem_ngDyn,['biomStem', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeBiomStem_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeStockInternodePlante_ngDyn,['stockInternodePlant', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeStockInternodePlante_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeLER_ngDyn,['FTSW', 'kIn', 'ThresLER', 'kIn', 'SlopeLER', 'kIn', 'P', 'kIn', 'resp_LER', 'kIn', 'testIc', 'kIn', 'reductionLER', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeLER_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TProcInstanceInternal.Create('',ComputeReductionINER_ngDyn,['FTSW', 'kIn', 'ThresLER', 'kIn', 'SlopeLER', 'kIn', 'P', 'kIn', 'resp_LER', 'kIn', 'testIc', 'kIn', 'reductionLER', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeReductionINER_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeWeightPanicle_ngDyn,['panicleDW', 'kOut', 'panicleMainstemDW', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeWeightPanicle_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputePanicleNumber_ngDyn,['panicleNumber','kOut']);
PROC_DECLARATION.SetProcName('ComputePanicleNumber_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeFirstLastExpandedInternodeDiameterMainstem_ngDyn,['firstDiameter', 'kOut', 'lastDiameter', 'kOut', 'lastLength', 'kOut', 'lastRank', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeFirstLastExpandedInternodeDiameterMainstem_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeNbActiveInternodesOnMainstem_ngDyn,['nbActiveInternodesOnMainstem', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeNbActiveInternodesOnMainstem_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeInternodeLengthOnMainstem_ngDyn,['internodeLengthOnMainstem', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeInternodeLengthOnMainstem_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeLeafNumberOnMainstem_ngDyn,['leafNumberOnMainstem', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeLeafNumberOnMainstem_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeInternodeBiomass_ngDyn,['Volume', 'kIn', 'density', 'kIn', 'Biomass', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeInternodeBiomass_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeNbLeafMainstem50_ngDyn,['NbLeafMainstem', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeNbLeafMainstem50_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeNbLeafMainstem_ngDyn,['NbLeafMainstem', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeNbLeafMainstem_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeBiomLeafMainstemGreen_ngDyn,['biomLeafMainstem', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeBiomLeafMainstemGreen_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ComputeTotalSenescedLeafBiomass_ngDyn,['totalSenescedLeafBiomas', 'kOut']);
PROC_DECLARATION.SetProcName('ComputeTotalSenescedLeafBiomass_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',SaveSupplyCulm_ngDyn,['nbDayOfSimulation', 'kIn']);
PROC_DECLARATION.SetProcName('SaveSupplyCulm_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',DataForR_ngDyn,[]);
PROC_DECLARATION.SetProcName('DataForR_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

PROC_DECLARATION := TExtraProcInstanceInternal.Create('',ReadAssimByAxisFromR_ngDyn,[]);
PROC_DECLARATION.SetProcName('ReadAssimByAxisFromR_ng');
PROC_LIBRARY.AddTProc(PROC_DECLARATION);

end.
