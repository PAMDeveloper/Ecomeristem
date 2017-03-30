unit ManagerMeristem_ng;

interface

uses
  SysUtils,
  StrUtils,
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
  UsefullFunctionsForMeristemModel,
  ModuleMeristem,
  ClassTManagerLibrary,
  Dialogs,
  GlobalVariable,
  Math,
  DefinitionConstant;

// fonction à appeler pour gérer les états
function EcoMeristemManager_ng(var instance : TEntityInstance; const date : TDateTime = 0 ; const state : Integer = 0) : Integer;
function InternodeManager_ng(var instance : TEntityInstance; const date : TDateTime = 0 ; const state : Integer = 0) : Integer;
function LeafManager_ng(var instance : TEntityInstance; const date : TDateTime = 0 ; const state : Integer = 0) : Integer;
function MeristemManagerPhytomers_ng(var instance : TEntityInstance; const date : TDateTime = 0 ; const state : Integer = 0) : Integer;
function PanicleManager_ng(var instance : TEntityInstance; const date : TDateTime = 0; const state : Integer = 0) : Integer;
function PeduncleManager_ng(var instance : TEntityInstance; const date : TDateTime = 0; const state : Integer = 0) : Integer;
function ThermalTimeManager_ng(var instance : TEntityInstance; const date : TDateTime = 0 ; const state : Integer = 0) : Integer;
function TillerManagerPhytomer_ng(var instance : TEntityInstance; const date : TDateTime = 0 ; const state : Integer = 0) : Integer;

// procedures internes
procedure CreateFirstCulm_ng(var instance : TEntityInstance; const date : TDateTime);
procedure PanicleTransitionToFLO(var instance : TEntityInstance);
procedure PeduncleTransitionToFLO(var instance : TEntityInstance);
procedure RootTransitionToState(var instance : TEntityInstance; const state : Integer);
procedure RootTransitionToElong(var instance : TEntityInstance);
procedure RootTransitionToPI(var instance : TEntityInstance);
procedure RootTransitionToFLO(var instance : TEntityInstance);
procedure SetAllActiveStateToValue(instance : TEntityInstance; value : Integer);
procedure SetAllInstanceToEndFilling(var instance : TEntityInstance);
procedure StoreIcOnCulms(var instance : TEntityInstance);
procedure StoreThermalTimeAtPI(var instance : TEntityInstance; const date : TDateTime = 0);
procedure StorePhenostageAtPre_Flo(var instance : TEntityInstance; const date : TDateTime = 0; const phenostage : Double = 0);
procedure TillerManagerCreateFirstPhytomers(var instance : TEntityInstance; const date : TDateTime = 0; const isMainstem : Double = 0);
procedure TillerManagerCreateFirstIN(var instance : TEntityInstance; const date : TDateTime = 0; const isMainstem : Double = 0);
procedure TillerManagerCreateFirstLeaf(var instance : TEntityInstance; const date : TDateTime = 0; const isMainstem : Double = 0);
procedure TillerManagerCreateOthersPhytomers(var instance : TEntityInstance; const date : TDateTime = 0; const n : Integer = 0; const isMainstem : Double = 0);
procedure TillerManagerCreateOthersIN(var instance : TEntityInstance; const date : TDateTime = 0; const n : Integer = 0; const isMainstem : Double = 0);
procedure TillerManagerCreateOthersLeaf(var instance : TEntityInstance; const date : TDateTime = 0; const n : Integer = 0; const isMainstem : Double = 0);
procedure TillerManagerPhytomerInternodeCreation(var instance : TEntityInstance; const date : TDateTime; const IsFirstDayOfPI : Boolean = False);
procedure TillerManagerPhytomerLeafCreation(var instance : TEntityInstance; const date : TDateTime; const IsInitiation : Boolean = False; const LL_BL_MODIFIED : Boolean = False);
procedure TillerManagerPhytomerLeafActivation(var instance : TEntityInstance; const date : TDateTime);
procedure TillerManagerStartInternodeElongation(var instance : TEntityInstance; const date : TDateTime = 0; const n : Integer = 0);
procedure TillerManagerPhytomerPanicleCreation(var instance : TEntityInstance; const date : TDateTime = 0);
procedure TillerManagerPhytomerPeduncleCreation(var instance : TEntityInstance; const date : TDateTime; const IsFirstDayOfPI : Boolean = False; const plantStock : Double = 0);
procedure TillerManagerPhytomerPanicleActivation(var instance : TEntityInstance);
procedure TillerManagerPhytomerPeduncleActivation(var instance : TEntityInstance; const date : TDateTime);
procedure TillersStockIndividualization(var instance : TEntityInstance; const date : TDateTime);
procedure TillerStorePhenostageAtPI(var instance : TEntityInstance; const date : TDateTime = 0; const phenostage : Double = 0);
procedure TillerStorePhenostageAtPre_Flo(var instance : TEntityInstance; const date : TDateTime = 0; const phenostage : Double = 0);
procedure TillersTransitionToElong(var instance : TEntityInstance);
procedure TillersTransitionToPI_LE(var instance : TEntityInstance; const oldState : Integer);
procedure TillersTransitionToPre_PI_LE(var instance : TEntityInstance; const oldState : Integer);
procedure TillersTransitionToPIPre_PI_ng(var instance : TEntityInstance; const oldState : Integer; const phenoStage : Double);
procedure TillersTransitionToState(var instance : TEntityInstance; const state : Integer; const oldState : Integer);

// usefull functions
function FindLeafAtRank(var instance : TEntityInstance; rank : String) : TEntityInstance;
function FindInternodeAtRank(var instance : TEntityInstance; rank : String) : TEntityInstance;
function FindPanicle(var instance : TEntityInstance) : TEntityInstance;
function FindPeduncle(var instance : TEntityInstance) : TEntityInstance;
function FindLastLigulatedLeafNumberOnCulm(var instance : TEntityInstance) : String;
function FindLeafOnSameRankLength(var instance : TEntityInstance; rank : String) : Double;
function FindLeafOnSameRankWidth(var instance : TEntityInstance; rank : String) : Double;



implementation

uses
  EntityTillerPhytomer_ng, EntityLeaf_ng, EntityInternode_ng, EntityPanicle_ng, EntityPeduncle_ng;

procedure StoreIcOnCulms(var instance : TEntityInstance);
var
  icPlant : Double;
  i, le : Integer;
  currentInstance : TInstance;
  refAttribute : TAttribute;
  sample : TSample;
begin
  icPlant := (instance.GetTAttribute('Ic') as TAttributeTableOut).GetCurrentSample().value;
  le := instance.LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      if ((currentInstance as TEntityInstance).GetCategory() = 'Tiller') then
      begin
        refAttribute := (currentInstance as TEntityInstance).GetTAttribute('ic_tiller');
        sample := refAttribute.GetCurrentSample();
        sample.value := icPlant;
        refAttribute.SetSample(sample);
        SRwriteln(currentInstance.GetName() + ' ic initialise a : ' + FloatToStr(sample.value));
      end;
    end;
  end;
end;

procedure TillerStorePhenostageAtPI(var instance : TEntityInstance; const date : TDateTime = 0; const phenostage : Double = 0);
var
  le, i : Integer;
  currentInstance : TInstance;
  category : string;
  refAttribute : TAttribute;
  sample : TSample;
begin
  le := instance.LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := instance.GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      category := (currentInstance as TEntityInstance).GetCategory();
      if (category = 'Tiller') then
      begin
        refAttribute := (currentInstance as TEntityInstance).GetTAttribute('phenoStageAtPI');
        sample := refAttribute.GetCurrentSample();
        sample.value := phenostage;
        refAttribute.SetSample(sample);
      end;
    end;
  end;
end;

procedure SetAllInstanceToEndFilling(var instance : TEntityInstance);
var
  i1, i2, le1, le2 : Integer;
  currentInstance1, currentInstance2 : TInstance;
  category1, category2 : string;
begin
  le1 := (instance as TEntityInstance).LengthTAttributeList();
  for i1 := 0 to le1 - 1 do
  begin
    currentInstance1 := (instance as TEntityInstance).GetTInstance(i1);
    if (currentInstance1 is TEntityInstance) then
    begin
      category1 := (currentInstance1 as TEntityInstance).GetCategory();
      if (category1 = 'Internode') or (category1 = 'Leaf') or (category1 = 'Panicle') or (category1 = 'Peduncle') or (category1 = 'Root') then
      begin
        (currentInstance1 as TEntityInstance).SetCurrentState(12);
        SRwriteln(currentInstance1.GetName() + ' passe a END FILLING');
      end
      else if (category1 = 'Tiller') then
      begin
        (currentInstance1 as TEntityInstance).SetCurrentState(12);
        le2 := (currentInstance1 as TEntityInstance).LengthTInstanceList();
        for i2 := 0 to le2 - 1 do
        begin
          currentInstance2 := (currentInstance1 as TEntityInstance).GetTInstance(i2);
          if (currentInstance2 is TEntityInstance) then
          begin
            category2 := (currentInstance2 as TEntityInstance).GetCategory();
            if (category2 = 'Internode') or (category2 = 'Leaf') or (category2 = 'Panicle') or (category2 = 'Peduncle') or (category2 = 'Root') then
            begin
              (currentInstance2 as TEntityInstance).SetCurrentState(12);
              SRwriteln(currentInstance2.GetName() + ' passe a END FILLING');
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure StorePhenostageAtPre_Flo(var instance : TEntityInstance; const date : TDateTime = 0; const phenostage : Double = 0);
var
  refPhenostagePre_Flo_To_Flo : TAttribute;
  sample : TSample;
begin
  refPhenostagePre_Flo_To_Flo := instance.GetTAttribute('phenostage_at_PRE_FLO');
  sample.date := date;
  sample.value := phenostage;
  refPhenostagePre_Flo_To_Flo.SetSample(sample);
end;

procedure StoreThermalTimeAtPI(var instance : TEntityInstance; const date : TDateTime = 0);
var
  TT : Double;
  refAttributeTTPI : TAttribute;
  sample : TSample;
begin
  TT := instance.GetTAttribute('TT').GetSample(date).value;
  refAttributeTTPI := instance.GetTAttribute('TT_PI');
  sample.date := date;
  sample.value := TT;
  refAttributeTTPI.SetSample(sample);
end;

procedure TillersTransitionToPre_PI_LE(var instance : TEntityInstance; const oldState : Integer);
begin
  TillersTransitionToState(instance, 5, oldState);
end;

procedure TillersTransitionToPI_LE(var instance : TEntityInstance; const oldState : Integer);
begin
  TillersTransitionToState(instance, 4, oldState);
end;

procedure TillersTransitionToState(var instance : TEntityInstance; const state : Integer; const oldState : Integer);
var
  le, i : Integer;
  currentInstance : TInstance;
  currentTEntityInstance : TEntityInstance;
  refTAttribute : TAttribute;
  sample : TSample;
  category : String;
begin
  le := instance.LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := instance.GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      category := (currentInstance as TEntityInstance).GetCategory();
      if (category = 'Tiller') then
      begin
        currentTEntityInstance := (currentInstance as TEntityInstance);
        currentTEntityInstance.SetCurrentState(state);
        SRwriteln('La talle : ' + currentInstance.GetName() + ' passe a l''etat ' + IntToStr(state));
        refTAttribute := currentTEntityInstance.GetTAttribute('previousState');
        sample := refTAttribute.GetCurrentSample();
        sample.value := oldState;
        refTAttribute.SetSample(sample);
        SRwriteln('previousState --> ' + IntToStr(oldState));
      end;
    end;
  end;

end;

procedure TillersTransitionToPIPre_PI_ng(var instance : TEntityInstance; const oldState : Integer; const phenoStage : Double);
var
  le, i : Integer;
  isMainstem : Double;
  currentInstance : TInstance;
  currentEntityInstance : TEntityInstance;
  refTAttribute : TAttribute;
  sample : TSample;
  category : string;
begin
  le := instance.LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := instance.GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      currentEntityInstance := currentInstance as TEntityInstance;
      category := currentEntityInstance.GetCategory();
      if (category = 'Tiller') then
      begin
        isMainstem := currentEntityInstance.GetTAttribute('isMainstem').GetCurrentSample().value;
        if (isMainstem = 1) then
        begin
          SRwriteln(currentEntityInstance.GetName() + ' est le brin maitre, il passe a PI');
          currentEntityInstance.SetCurrentState(4);
          refTAttribute := currentEntityInstance.GetTAttribute('phenoStageAtPI');
          sample := refTAttribute.GetCurrentSample();
          sample.value := phenoStage;
          refTAttribute.SetSample(sample);
        end
        else
        begin
          SRwriteln(currentEntityInstance.GetName() + ' n''est pas le brin maitre, il passe a PRE_PI');
          currentEntityInstance.SetCurrentState(5);
        end;
        refTAttribute := currentEntityInstance.GetTAttribute('previousState');
        sample := refTAttribute.GetCurrentSample();
        sample.value := oldState;
        refTAttribute.SetSample(sample);
      end;
    end;
  end;
end;

procedure RootTransitionToState(var instance : TEntityInstance; const state : Integer);
var
  le : Integer;
  i : Integer;
  currentInstance : TInstance;
begin
  le := instance.LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := instance.GetTInstance(i);
    if (currentInstance is TEntityInstance) and (currentInstance.GetName() = 'Root') then
    begin
      (currentInstance as TEntityInstance).SetCurrentState(state);
    end;
  end;
end;

procedure RootTransitionToElong(var instance : TEntityInstance);
begin
  RootTransitionToState(instance, 9);
end;

procedure RootTransitionToPI(var instance : TEntityInstance);
begin
  RootTransitionToState(instance, 4);
end;

procedure RootTransitionToFLO(var instance : TEntityInstance);
begin
  RootTransitionToState(instance, 6);
end;


procedure TillersTransitionToElong(var instance : TEntityInstance);
var
  le, i : Integer;
  currentInstance : TInstance;
  currentTEntityInstance : TEntityInstance;
  nameOfLastLigulatedLeafOnTiller : string;
begin
  le := instance.LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := instance.GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      currentTEntityInstance := currentInstance as TEntityInstance;
      if (currentTEntityInstance.GetCategory() = 'Tiller') then
      begin
        nameOfLastLigulatedLeafOnTiller := FindLastLigulatedLeafNumberOnCulm(currentTEntityInstance);
        if (nameOfLastLigulatedLeafOnTiller = '-1') then
        begin
          SRwriteln('La talle : ' + currentTEntityInstance.GetName() + ' n''a pas de feuille ligulée, elle passe à l''etat PRE_ELONG');
          currentTEntityInstance.SetCurrentState(10);
        end
        else
        begin
          SRwriteln('La talle : ' + currentTEntityInstance.GetName() + ' a une feuille ligulée, elle passe à l''etat ELONG');
          currentTEntityInstance.SetCurrentState(9);
        end;
      end;
    end;
  end;
end;

procedure TillersStockIndividualization(var instance : TEntityInstance; const date : TDateTime);
var
  le, i : Integer;
  currentInstance : TInstance;
  currentTEntityInstance : TEntityInstance;
  category : String;
  sumOfPlantBiomass, sumOfTillerLeafBiomass, plantStock : Double;
  stockTillerAttribute : TAttribute;
  sample : TSample;
begin
  le := instance.LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := instance.GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      category := (currentInstance as TEntityInstance).GetCategory();
      if (category = 'Tiller') then
      begin
        currentTEntityInstance := (currentInstance as TEntityInstance);
        sumOfPlantBiomass := instance.GetTAttribute('sumOfLeafBiomass').GetSample(date).value;
        sumOfTillerLeafBiomass := currentTEntityInstance.GetTAttribute('sumOfTillerLeafBiomass').GetSample(date).value;
        plantStock := (instance.GetTAttribute('stock') as TAttributeTableOut).GetSample(date).value;
        SRwriteln('sumOfPlantBiomass      --> ' + FloatToStr(sumOfPlantBiomass));
        SRwriteln('sumOfTillerLeafBiomass --> ' + FloatToStr(sumOfTillerLeafBiomass));
        SRwriteln('plantStock             --> ' + FloatToStr(plantStock));
        stockTillerAttribute := currentTEntityInstance.GetTAttribute('stock_tiller');
        sample := stockTillerAttribute.GetSample(date);
        sample.value := (sumOfTillerLeafBiomass / sumOfPlantBiomass) * plantStock;
        stockTillerAttribute.SetSample(sample);
        SRwriteln('La talle : ' + currentInstance.GetName() + ' propre stock : ' + floattostr(stockTillerAttribute.GetSample(date).value));
      end;
    end;
  end;
end;

procedure SetAllActiveStateToValue(instance : TEntityInstance; value : Integer);
var
  currentInstance : TInstance;
  nbInstance : Integer;
  i : Integer;
begin
  instance.SetCurrentState(value);
	nbInstance := instance.LengthTInstanceList();
  for i:=0 to nbInstance-1 do
  begin
    currentInstance := instance.GetTInstance(i);
    if (currentInstance is TProcInstance) then
    begin
      if (currentInstance.GetName <> 'setAliveToDead') then
      begin
        currentInstance.SetActiveState(value * 2);
      end;
    end
    else
    begin
    	if (currentInstance is TEntityInstance) then
      begin
      	SetAllActiveStateToValue(currentInstance as TEntityInstance, value);
      end;
    end;

  end;
end;

function MeristemManagerPhytomers_ng(var instance : TEntityInstance; const date : TDateTime = 0 ; const state : Integer = 0) : Integer;
const
  //INITIAL = 1;
  LEAFMORPHOGENESIS = 2;
  NOGROWTH = 3;
  PI = 4;
  FLO = 5;
  PRE_FLO = 6;
  NOGROWTH_PI = 7;
  NOGROWTH_FLO = 8;
  ELONG = 9;
  NOGROWTH_ELONG = 10;
  NOGROWTH_PRE_FLO = 11;
  ENDFILLING = 12;
  NOGROWTH_ENDFILLING = 13;
  MATURITY = 14;
  NOGROWTH_MATURITY = 15;
  DEAD = 1000;
var
   newState : Integer;
   stock, deficit, diff : Double;
   boolCrossedPlasto,n : Double;
   nbleaf_pi : Double;
   nb_leaf_max_after_PI : Double;
   phenostageAtPre_Flo, phenostage_PRE_FLO_to_FLO : Double;
   FTSW : double;
   Ic : double;
   nb_leaf_stem_elong, phenostage_to_end_filling, phenostage_to_maturity : Double;
   newStateStr, oldStateStr : string;
   refAttribute : TAttribute;
   sample : TSample;

begin
  newState := 0;
  stock := instance.GetTAttribute('stock').GetSample(date).value;
  deficit := instance.GetTAttribute('deficit').GetSample(date).value;
  nbleaf_pi := instance.GetTAttribute('nbleaf_pi').GetSample(date).value;
  n := instance.GetTAttribute('n').GetSample(date).value;
  boolCrossedPlasto := instance.GetTAttribute('boolCrossedPlasto').GetSample(date).value;
  nb_leaf_max_after_PI := instance.GetTAttribute('nb_leaf_max_after_PI').GetSample(date).value;
  FTSW := instance.GetTAttribute('FTSW').GetSample(date).value;
  Ic := instance.GetTAttribute('Ic').GetSample(date).value;
  nb_leaf_stem_elong := instance.GetTAttribute('nb_leaf_stem_elong').GetSample(date).value;
  phenostageAtPre_Flo := instance.GetTAttribute('phenostage_at_PRE_FLO').GetSample(date).value;
  phenostage_PRE_FLO_to_FLO := instance.GetTAttribute('phenostage_PRE_FLO_to_FLO').GetSample(date).value;
  phenostage_to_end_filling := instance.GetTAttribute('phenostage_to_end_filling').GetSample(date).value;
  phenostage_to_maturity := instance.GetTAttribute('phenostage_to_maturity').GetSample(date).value;
  
  case state of
    INITIAL :
      begin
        oldStateStr := 'INITIAL';
        if (stock >= 0) and (n < nbleaf_pi) then
        begin
          newState := LEAFMORPHOGENESIS;
          newStateStr := 'LEAFMORPHOGENESIS';
        end
        else
        begin
          newState := NOGROWTH;
          newStateStr := 'NOGROWTH';
        end;
      end;

    LEAFMORPHOGENESIS :
    begin
      oldStateStr := 'LEAFMORPHOGENESIS';
    	if (FTSW <= 0) or (Ic = -1) then
      begin
      	newState := DEAD;
        newStateStr := 'DEAD';
        SetAllActiveStateToValue(instance, DEAD);
      end
      else
      begin
	      if (stock = 0) then
        begin
	        newState := NOGROWTH;
          newStateStr := 'NOGROWTH';
        end
	      else if (stock > 0) then
	      begin
	        if (boolCrossedPlasto < 0) then
          begin
	          newState := LEAFMORPHOGENESIS;
            newStateStr := 'LEAFMORPHOGENESIS';
          end
	        else
	        begin
            if ((n = Trunc(nb_leaf_stem_elong)) and (n < nbleaf_pi) and (Trunc(nb_leaf_stem_elong) < nbleaf_pi)) then
            begin
              SRwriteln('elong');
              StoreIcOnCulms(instance);
              TillersStockIndividualization(instance, date);
              TillersTransitionToElong(instance);
              RootTransitionToElong(instance);
              newState := ELONG;
              newStateStr := 'ELONG';
            end
            else
            begin
              if (n = nbleaf_pi) then
              begin
                SRwriteln('n = nbleaf_pi, on passe a PI');
                StoreIcOnCulms(instance);
                TillersStockIndividualization(instance, date);
                TillersTransitionToPIPre_PI_ng(instance, state, n);
                StoreThermalTimeAtPI(instance, date);
                RootTransitionToPI(instance);
                newState := PI;
                newStateStr := 'PI';
              end
              else
              begin
                newState := LEAFMORPHOGENESIS;
                newStateStr := 'LEAFMORPHOGENESIS';
              end;
            end;
	        end;
	      end;
	    end;
    end;

    NOGROWTH :
      begin
        oldStateStr := 'NOGROWTH';
    	  if (FTSW <= 0) or (Ic = -1) then
        begin
      	  newState := DEAD;
          newStateStr := 'DEAD';
          SetAllActiveStateToValue(instance, DEAD);
        end
        else
        begin
	        if (stock > 0) then
	        begin
	          if ((n < Trunc(nb_leaf_stem_elong)) and (n < nbleaf_pi)) then
	          begin
	            newState := LEAFMORPHOGENESIS;
              newStateStr := 'LEAFMORPHOGENESIS';
	          end
	          else
	          begin
              if ((n = Trunc(nb_leaf_stem_elong)) and (n < nbleaf_pi) and (Trunc(nb_leaf_stem_elong) < nbleaf_pi)) then
              begin
                if (boolCrossedPlasto >= 0) then
                begin
                  StoreIcOnCulms(instance);
                  TillersStockIndividualization(instance, date);
                  TillersTransitionToElong(instance);
                  RootTransitionToElong(instance);
                  newState := ELONG;
                  newStateStr := 'ELONG';
                end;
              end
              else
              begin
                if (n = nbleaf_pi) then
                begin
                  if (boolCrossedPlasto >= 0) then
  	              begin
                    SRwriteln('n = nbleaf_pi, on passe a PI');
                    StoreIcOnCulms(instance);
                    TillersStockIndividualization(instance, date);
                    TillersTransitionToPIPre_PI_ng(instance, state, n);
                    StoreThermalTimeAtPI(instance, date);
                    RootTransitionToPI(instance);
                    newState := PI;
                    newStateStr := 'PI';
                  end;
                end;
	            end;
	          end;
	        end
	        else
	        begin
	          newState := NOGROWTH;
            newStateStr := 'NOGROWTH';
	        end;
	      end;
      end;

    PI :
      begin
        oldStateStr := 'PI';
        diff := Max(0, stock + deficit);
        SRwriteln('diff --> ' + FloatToStr(diff));
        if (diff = 0) then
        begin
          newState := NOGROWTH_PI;
          newStateStr := 'NOGROWTH_PI';
        end
        else if (diff > 0) then
        begin
          if (boolCrossedPlasto >= 0) then
          begin
            if (n <= nbleaf_pi + nb_leaf_max_after_PI) then
            begin
              SRwriteln('n <= nbleaf_pi + nb_leaf_max_after_PI');
              newState := PI;
              newStateStr := 'PI';
            end;
            if (n = (nbleaf_pi + nb_leaf_max_after_PI + 1)) then
            begin
              isFirstDayOfPRE_FLO := True;
              newState := PRE_FLO;
              newStateStr := 'PRE_FLO';
              StorePhenostageAtPre_Flo(instance, date, n);
            end;
          end
          else
          begin
            newState := PI;
            newStateStr := 'PI';
          end;
        end;
      end;

    NOGROWTH_PI:
      begin
        oldStateStr := 'NOGROWTH_PI';
        diff := Max(0, stock + deficit);
        SRwriteln('diff --> ' + FloatToStr(diff));
        if (diff = 0) then
        begin
          newState := NOGROWTH_PI;
          newStateStr := 'NOGROWTH_PI';
        end
        else if (diff > 0) then
        begin
          if (boolCrossedPlasto >= 0) then
          begin
            if (n <= nbleaf_pi + nb_leaf_max_after_PI) then
            begin
              newState := PI;
              newStateStr := 'PI';
            end;
            if (n = (nbleaf_pi + nb_leaf_max_after_PI + 1)) then
            begin
              isFirstDayOfPRE_FLO := True;
              newState := PRE_FLO;
              newStateStr := 'PRE_FLO';
              StorePhenostageAtPre_Flo(instance, date, n);
            end;
          end
          else
          begin
            newState := PI;
            newStateStr := 'PI';
          end;
        end;
      end;

    PRE_FLO :
      begin
        oldStateStr := 'PRE_FLO';
        diff := Max(0, stock + deficit);
        SRwriteln('diff --> ' + FloatToStr(diff));
        if (diff = 0) then
        begin
          newState := NOGROWTH_PRE_FLO;
          newStateStr := 'NOGROWTH_PRE_FLO';
        end
        else if (diff > 0) then
        begin
          SRwriteln('currentPhenostage         --> ' + FloatToStr(n));
          SRwriteln('phenostageAtPre_Flo       --> ' + FloatToStr(phenostageAtPre_Flo));
          SRwriteln('phenostage_PRE_FLO_to_FLO --> ' + FloatToStr(phenostage_PRE_FLO_to_FLO));
          if (n = (phenostageAtPre_Flo + phenostage_PRE_FLO_to_FLO)) then
          begin
            PanicleTransitionToFLO(instance);
            PeduncleTransitionToFLO(instance);
            newState := FLO;
            newStateStr := 'FLO';
          end
          else
          begin
            newState := PRE_FLO;
            newStateStr := 'PRE_FLO';
          end;
        end;
      end;

    NOGROWTH_PRE_FLO :
      begin
        oldStateStr := 'NOGROWTH_PRE_FLO';
        diff := Max(0, stock + deficit);
        SRwriteln('diff --> ' + FloatToStr(diff));
        if (diff > 0) then
        begin
          SRwriteln('currentPhenostage         --> ' + FloatToStr(n));
          SRwriteln('phenostageAtPre_Flo       --> ' + FloatToStr(phenostageAtPre_Flo));
          SRwriteln('phenostage_PRE_FLO_to_FLO --> ' + FloatToStr(phenostage_PRE_FLO_to_FLO));
          if (n = (phenostageAtPre_Flo + phenostage_PRE_FLO_to_FLO)) then
          begin
            PanicleTransitionToFLO(instance);
            PeduncleTransitionToFLO(instance);
            newState := FLO;
            newStateStr := 'FLO';
          end
          else
          begin
            newState := PRE_FLO;
            newStateStr := 'PRE_FLO';
          end;
        end
        else if (diff = 0) then
        begin
          newState := NOGROWTH_PRE_FLO;
          newStateStr := 'NOGROWTH_PRE_FLO';
        end;
      end;

    NOGROWTH_FLO:
      begin
        oldStateStr := 'NOGROWTH_FLO';
        SRwriteln('n                         --> ' + FloatToStr(n));
        SRwriteln('phenostage_to_end_filling --> ' + FloatToStr(phenostage_to_end_filling));
        diff := Max(0, stock + deficit);
        SRwriteln('diff --> ' + FloatToStr(diff));
        if (diff > 0) then
        begin
          if (n = phenostage_to_end_filling) then
          begin
            SetAllInstanceToEndFilling(instance);
            newState := ENDFILLING;
            newStateStr := 'ENDFILLING';
          end
          else
          begin
            newstate := FLO;
            newStateStr := 'FLO';
          end;
        end
        else if (diff = 0)then
        begin
          newState := NOGROWTH_FLO;
          newStateStr := 'NOGROWTH_FLO';
        end;
      end;

    FLO :
      begin
        oldStateStr := 'FLO';
        SRwriteln('n                         --> ' + FloatToStr(n));
        SRwriteln('phenostage_to_end_filling --> ' + FloatToStr(phenostage_to_end_filling));
        diff := Max(0, stock + deficit);
        SRwriteln('diff --> ' + FloatToStr(diff));
        if (diff > 0) then
        begin
          if (n = phenostage_to_end_filling) then
          begin
            newState := ENDFILLING;
            newStateStr := 'ENDFILLING';
          end
          else
          begin
            newstate := FLO;
            newStateStr := 'FLO';
          end;
        end
        else if (diff = 0)then
        begin
          newState := NOGROWTH_FLO;
          newStateStr := 'NOGROWTH_FLO';
        end;
      end;

    DEAD:
      begin
        oldStateStr := 'DEAD';
    	  newState := DEAD;
        newStateStr := 'DEAD';
        SetAllActiveStateToValue(instance, DEAD);
      end;

    ELONG :
      begin
        oldStateStr := 'ELONG';
        diff := Max(0, stock + deficit);
        SRwriteln('diff --> ' + FloatToStr(diff));
     	  if (FTSW <= 0) or (Ic = -1) then
        begin
      	  newState := DEAD;
          newStateStr := 'DEAD';
          SetAllActiveStateToValue(instance, DEAD);
        end
        else
        begin
          if (diff = 0) then
          begin
            newState := NOGROWTH_ELONG;
            newStateStr := 'NOGROWTH_ELONG';
          end
          else if (diff > 0) then
          begin
            if (boolCrossedPlasto >= 0) then
            begin
              if ((n >= nb_leaf_stem_elong) and (n < nbleaf_pi)) then
              begin
                newState := ELONG;
                newStateStr := 'ELONG';
              end
              else
              begin
                if (n = nbleaf_pi) then
                begin
                  SRwriteln('n = nbleaf_pi, on passe a PI');
                  TillersTransitionToPIPre_PI_ng(instance, state, n);
                  StoreThermalTimeAtPI(instance, date);
                  RootTransitionToPI(instance);
                  newState := PI;
                  newStateStr := 'PI';
                end;
              end;
            end
            else
            begin
              newState := ELONG;
              newStateStr := 'ELONG';
            end;
          end;
        end;
      end;

    NOGROWTH_ELONG :
      begin
        oldStateStr := 'NOGROWTH_ELONG';
        diff := Max(0, stock + deficit);
        SRwriteln('diff --> ' + FloatToStr(diff));
    	  if (FTSW <= 0) or (Ic = -1) then
        begin
      	  newState := DEAD;
          newStateStr := 'DEAD';
          SetAllActiveStateToValue(instance, DEAD);
        end
        else
        begin
	        if (diff > 0) then
	        begin
            if ((n >= nb_leaf_stem_elong) and (n < nbleaf_pi)) then
            begin
              if (boolCrossedPlasto >= 0) then
              begin
                newState := ELONG;
                newStateStr := 'ELONG';
              end
              else
              begin
                newState := ELONG;
                newStateStr := 'ELONG';
              end;
            end
            else
            begin
              if (n = nbleaf_pi) then
              begin
                if (boolCrossedPlasto >= 0) then
                begin
                  SRwriteln('n = nbleaf_pi, on passe a PI');
                  TillersTransitionToPIPre_PI_ng(instance, state, n);
                  StoreThermalTimeAtPI(instance, date);
                  RootTransitionToPI(instance);
                  newState := PI;
                  newStateStr := 'PI';
                end;
              end;
            end;
	        end
	        else if (diff = 0) then
	        begin
	          newState := NOGROWTH_ELONG;
            newStateStr := 'NOGROWTH_ELONG';
	        end;
	      end;
      end;

    ENDFILLING:
      begin
        oldStateStr := 'ENDFILLING';
        SRwriteln('n                      --> ' + FloatToStr(n));
        SRwriteln('phenostage_to_maturity --> ' + FloatToStr(phenostage_to_maturity));
        diff := Max(0, stock + deficit);
        SRwriteln('diff --> ' + FloatToStr(diff));
        if (diff = 0) then
        begin
          newState := NOGROWTH_ENDFILLING;
          newStateStr := 'NOGROWTH_ENDFILLING';
        end
        else if (diff > 0) then
        begin
          if (n = phenostage_to_maturity) then
          begin
            newState := MATURITY;
            newStateStr := 'MATURITY';
          end
          else
          begin
            newState := ENDFILLING;
            newStateStr := 'ENDFILLING';
          end;
        end;
      end;

    NOGROWTH_ENDFILLING:
      begin
        oldStateStr := 'NOGROWTH_ENDFILLING';
        SRwriteln('n                      --> ' + FloatToStr(n));
        SRwriteln('phenostage_to_maturity --> ' + FloatToStr(phenostage_to_maturity));
        diff := Max(0, stock + deficit);
        SRwriteln('diff --> ' + FloatToStr(diff));
        if (diff > 0) then
        begin
          if (n = phenostage_to_maturity) then
          begin
            newState := MATURITY;
            newStateStr := 'MATURITY';
          end
          else
          begin
            newState := ENDFILLING;
            newStateStr := 'ENDFILLING';
          end;
        end
        else
        begin
          newState := NOGROWTH_ENDFILLING;
          newStateStr := 'NOGROWTH_ENDFILLING';
        end;
      end;

    MATURITY:
      begin
        oldStateStr := 'MATURITY';
        diff := Max(0, stock + deficit);
        SRwriteln('diff --> ' + FloatToStr(diff));
        if (diff = 0) then
        begin
          newState := NOGROWTH_MATURITY;
          newStateStr := 'NOGROWTH_MATURITY';
        end
        else
        begin
          newState := MATURITY;
          newStateStr := 'MATURITY';
        end;
      end;

    NOGROWTH_MATURITY:
      begin
        oldStateStr := 'NOGROWTH_MATURITY';
        diff := Max(0, stock + deficit);
        SRwriteln('diff --> ' + FloatToStr(diff));
        if (diff > 0) then
        begin
          newState := MATURITY;
          newStateStr := 'MATURITY';
        end
        else
        begin
          newState := NOGROWTH_MATURITY;
          newStateStr := 'NOGROWTH_MATURITY';
        end;
      end;
  end;

  refAttribute := instance.GetTAttribute('previousState');
  sample := refAttribute.GetCurrentSample();
  sample.value := state;
  refAttribute.SetSample(sample);

  SRwriteln('n                           --> ' + FLoatToStr(n));
  SRwriteln('nb_leaf_stem_elong          --> ' + FloatToStr(nb_leaf_stem_elong));
  SRwriteln('nbleafpi                    --> ' + FloatToStr(nbleaf_pi));
  SRwriteln('nbleafpi + nbleafmaxafterpi --> ' + FloatToStr(nbleaf_pi + nb_leaf_max_after_PI));
  SRwriteln('-------------------------------------------------------');
  SRwriteln('Meristem Manager Phytomers, transition de : ' + oldStateStr + ' --> ' + newStateStr);

  result := newState;
end;

procedure PanicleTransitionToFLO(var instance : TEntityInstance);
var
  le : Integer;
  i : Integer;
  currentInstance : TInstance;
begin
  le := instance.LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := instance.GetTInstance(i);
    if (currentInstance is TEntityInstance) and ((currentInstance as TEntityInstance).GetCategory() = 'Panicle') then
    begin
      (currentInstance as TEntityInstance).SetCurrentState(2);
    end;
  end;
end;

procedure PeduncleTransitionToFLO(var instance : TEntityInstance);
var
  le : Integer;
  i : Integer;
  currentInstance : TInstance;
begin
  le := instance.LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := instance.GetTInstance(i);
    if (currentInstance is TEntityInstance) and ((currentInstance as TEntityInstance).GetCategory() = 'Peduncle') then
    begin
      (currentInstance as TEntityInstance).SetCurrentState(500);
    end;
  end;
end;

procedure TillerStorePhenostageAtPre_Flo(var instance : TEntityInstance; const date : TDateTime = 0; const phenostage : Double = 0);
var
  refPhenostageAtPre_Flo : TAttribute;
  sample : TSample;
begin
  refPhenostageAtPre_Flo := instance.GetTAttribute('phenoStageAtPreFlo');
  sample.date := date;
  sample.value := phenostage;
  refPhenostageAtPre_Flo.SetSample(sample);
end;

function FindPeduncle(var instance : TEntityInstance) : TEntityInstance;
var
  le, i : Integer;
  currentInstance : TInstance;
  currentEntityInstance : TEntityInstance;
  entityPeduncle : TEntityInstance;
begin
  entityPeduncle := nil;
  le := instance.LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      currentEntityInstance := (currentInstance as TEntityInstance);
      if (currentEntityInstance.GetCategory() = 'Peduncle') then
      begin
        entityPeduncle := currentEntityInstance;
      end;
    end;
  end;
  Result := entityPeduncle;
end;

procedure TillerManagerPhytomerPeduncleActivation(var instance : TEntityInstance; const date : TDateTime);
var
  entityPeduncle, refMeristem : TEntityInstance;
  internodeNumber, name : string;
  leafLength, leafWidth, MGR, plasto, Tb, resp_LER, resp_INER, LIN1 : Double;
  IN_A, IN_B, density_IN, MaximumReserveInInternode : Double;
  leaf_width_to_IN_diameter, leaf_length_to_IN_length, ligulo, n : Double;
  ratioINPed, peduncleDiam : Double;
  sample : TSample;
begin
  entityPeduncle := FindPeduncle(instance);

  refMeristem := instance.GetFather() as TEntityInstance;

  internodeNumber := FindLastLigulatedLeafNumberOnCulm(instance);

  SRwriteln('Last ligulated leaf : ' + internodeNumber);

  name := 'IN' + internodeNumber;

  leafLength := FindLeafOnSameRankLength(instance, internodeNumber);
  leafWidth := FindLeafOnSameRankWidth(instance, internodeNumber);
  MGR := refMeristem.GetTAttribute('MGR').GetSample(date).value;
  plasto := refMeristem.GetTAttribute('plasto').GetSample(date).value;
  ligulo := refMeristem.GetTAttribute('ligulo').GetSample(date).value;
  Tb := refMeristem.GetTAttribute('Tb').GetSample(date).value;
  resp_LER := refMeristem.GetTAttribute('resp_LER').GetSample(date).value;
  resp_INER := resp_LER;
  LIN1 := refMeristem.GetTAttribute('LIN1').GetSample(date).value;
  IN_A := refMeristem.GetTAttribute('IN_A').GetSample(date).value;
  IN_B := refMeristem.GetTAttribute('IN_B').GetSample(date).value;
  density_IN := refMeristem.GetTAttribute('density_IN').GetSample(date).value;
  MaximumReserveInInternode := refMeristem.GetTAttribute('maximumReserveInInternode').GetSample(date).value;
  leaf_width_to_IN_diameter := refMeristem.GetTAttribute('leaf_width_to_IN_diameter').GetSample(date).value;
  leaf_length_to_IN_length := refMeristem.GetTAttribute('leaf_length_to_IN_length').GetSample(date).value;
  n := refMeristem.GetTAttribute('n').GetSample(date).value;
  ratioINPed := refMeristem.GetTAttribute('ratio_INPed').GetSample(date).value;
  peduncleDiam := refMeristem.GetTAttribute('peduncle_diam').GetSample(date).value;

  sample.date := date;
  sample.value := leafLength;
  entityPeduncle.GetTAttribute('leafLength').SetSample(sample);

  sample.date := date;
  sample.value := leafWidth;
  entityPeduncle.GetTAttribute('leafWidth').SetSample(sample);

  sample.date := date;
  sample.value := MGR;
  entityPeduncle.GetTAttribute('MGR').SetSample(sample);

  sample.date := date;
  sample.value := plasto;
  entityPeduncle.GetTAttribute('plasto').SetSample(sample);

  sample.date := date;
  sample.value := ligulo;
  entityPeduncle.GetTAttribute('ligulo').SetSample(sample);

  sample.date := date;
  sample.value := Tb;
  entityPeduncle.GetTAttribute('Tb').SetSample(sample);

  sample.date := date;
  sample.value := resp_INER;
  entityPeduncle.GetTAttribute('resp_INER').SetSample(sample);

  sample.date := date;
  sample.value := LIN1;
  entityPeduncle.GetTAttribute('LIN1').SetSample(sample);

  sample.date := date;
  sample.value := IN_A;
  entityPeduncle.GetTAttribute('IN_A').SetSample(sample);

  sample.date := date;
  sample.value := IN_B;
  entityPeduncle.GetTAttribute('IN_B').SetSample(sample);

  sample.date := date;
  sample.value := density_IN;
  entityPeduncle.GetTAttribute('density_IN').SetSample(sample);

  sample.date := date;
  sample.value := MaximumReserveInInternode;
  entityPeduncle.GetTAttribute('MaximumReserveInInternode').SetSample(sample);

  sample.date := date;
  sample.value := leaf_width_to_IN_diameter;
  entityPeduncle.GetTAttribute('leaf_width_to_IN_diameter').SetSample(sample);

  sample.date := date;
  sample.value := leaf_length_to_IN_length;
  entityPeduncle.GetTAttribute('leaf_length_to_IN_length').SetSample(sample);

  sample.date := date;
  sample.value := ratioINPed;
  entityPeduncle.GetTAttribute('ratio_INPed').SetSample(sample);

  sample.date := date;
  sample.value := peduncleDiam;
  entityPeduncle.GetTAttribute('peduncle_diam').SetSample(sample);

  sample.date := date;
  sample.value := n;
  entityPeduncle.GetTAttribute('rank').SetSample(sample);

  entityPeduncle.SetCurrentState(1);
  SRwriteln('Le pedoncule : ' + entityPeduncle.GetName() + ' est active');
end;

function FindPanicle(var instance : TEntityInstance) : TEntityInstance;
var
  le, i : Integer;
  currentInstance : TInstance;
  currentEntityInstance : TEntityInstance;
  entityPanicle : TEntityInstance;
begin
  entityPanicle := nil;
  le := instance.LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      currentEntityInstance := (currentInstance as TEntityInstance);
      if (currentEntityInstance.GetCategory() = 'Panicle') then
      begin
        entityPanicle := currentEntityInstance;
      end;
    end;
  end;
  Result := entityPanicle;
end;

procedure TillerManagerPhytomerPanicleActivation(var instance : TEntityInstance);
var
  entityPanicle : TEntityInstance;
begin
  entityPanicle := FindPanicle(instance);
  entityPanicle.SetCurrentState(1);
  SRwriteln('La panicule : ' + entityPanicle.GetName() + ' est activee');
end;

procedure TillerManagerPhytomerPeduncleCreation(var instance : TEntityInstance; const date : TDateTime; const IsFirstDayOfPI : Boolean = False; const plantStock : Double = 0);
var
//  sumOfTillerLeafBiomass, SumOfPlantBiomass : Double;
  sample : TSample;
  exeOrder : Integer;
//  internodeNumber : Integer;
//  rank : Double;
  name, instanceName : String;
  TT : Double;
  TT_PI_Attribute : TAttribute;
//  attributeTmp : TAttribute;
  refMeristem : TEntityInstance;
  newInternode : TEntityInstance;
//  previousInternodePredimName, currentInternodePredimName : String;
//  sampleTmp : TSample;

//  i : integer;

begin
  refMeristem := instance.GetFather() as TEntityInstance;

  exeOrder := Trunc(refMeristem.GetTAttribute('exeOrderOfPeduncle').GetSample(date).value);
  SRwriteln('exe order: ' + inttostr(exeorder));

  TT := refMeristem.GetTAttribute('TT').GetSample(date).value;
  TT_PI_Attribute := refMeristem.GetTAttribute('TT_PI');
  Sample := TT_PI_Attribute.GetSample(date);
  Sample.value := TT;
  TT_PI_Attribute.SetSample(Sample);
  SRwriteln('TT_PI : ' + floattostr(Sample.value));

//  pos := 1;

  instanceName := instance.GetName();
  Delete(instanceName, 1, 2);

  name := 'Ped' + instanceName;

  // on crée le premier entre noeud

  SRwriteln('****  creation du pedoncule ImportPeduncle_ng : ' + name + '  ****');

  newInternode := ImportPeduncle_ng(name, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
  newInterNode.SetExeOrder(exeOrder);
  newInterNode.SetStartDate(date);
  newInterNode.InitCreationDate(date);
  newInterNode.InitNextDate();
  newInternode.SetCurrentState(2000);

  instance.AddTInstance(newInternode);

  newInterNode.ExternalConnect(['degreeDayForInternodeInitiation',
                                'degreeDayForInternodeRealization',
                                'testIc',
                                'fcstr',
                                'phenoStage',
                                'stock_tiller',
                                'Tair',
                                'plasto_delay',
                                'thresINER',
                                'slopeINER',
                                'FTSW',
                                'P']);

  instance.SortTInstance();

end;

procedure TillerManagerPhytomerPanicleCreation(var instance : TEntityInstance; const date : TDateTime = 0);
var
  instanceName : String;
  name : String;
  spike_creation_rate, grain_filling_rate, Tb : Double;
  gdw_empty, gdw, grain_per_cm_on_panicle : Double;
  phenoStage : Double;
  exeOrder : Integer;
  newPanicle : TEntityInstance;
  refMeristem : TEntityInstance;
begin
  refMeristem := instance.GetFather() as TEntityInstance;
  spike_creation_rate := refMeristem.GetTAttribute('spike_creation_rate').GetSample(date).value;
  grain_filling_rate := refMeristem.GetTAttribute('grain_filling_rate').GetSample(date).value;
  gdw_empty := refMeristem.GetTAttribute('gdw_empty').GetSample(date).value;
  gdw := refMeristem.GetTAttribute('gdw').GetSample(date).value;
  gdw_empty := gdw_empty * gdw;
  grain_per_cm_on_panicle := refMeristem.GetTAttribute('grain_per_cm_on_panicle').GetSample(date).value;
  exeOrder := Trunc(refMeristem.GetTAttribute('exeOrderOfPanicle').GetSample(date).value);
  phenoStage := refMeristem.GetTAttribute('n').GetSample(date).value;
  Tb := refMeristem.GetTAttribute('Tb').GetSample(date).value;

  SRwriteln('exeOrderOfPanicle : ' + IntToStr(exeOrder));

  instanceName := instance.GetName();
  Delete(instanceName, 1, 2);

  name := 'Pan' + instanceName;


  SRwriteln('****  creation de la panicule ImportPanicle_ng : ' + name + '  ****');

  newPanicle := ImportPanicle_ng(name, spike_creation_rate, grain_filling_rate, grain_per_cm_on_panicle, gdw_empty, gdw, Tb, phenoStage, 0);

  newPanicle.SetExeOrder(exeOrder);
  newPanicle.SetStartDate(date);
  newPanicle.InitCreationDate(date);
  newPanicle.InitNextDate();
  newPanicle.SetCurrentState(2000);

  instance.AddTInstance(newPanicle);

  newPanicle.ExternalConnect(['degreeDayForInternodeInitiation',
                              'degreeDayForInternodeRealization',
                              'testIc',
                              'fcstr',
                              'phenoStage',
                              'Tair',
                              'plasto_delay',
                              'thresLER',
                              'slopeLER',
                              'FTSW',
                              'P']);


  instance.SortTInstance();
end;

function FindLeafOnSameRankWidth(var instance : TEntityInstance; rank : String) : Double;
var
  le, i : Integer;
  currentInstance : TInstance;
  currentEntityInstance : TEntityInstance;
  leafPredim, LL_BL, WLR, leafWidthPredim : Double;
  leafName : String;
begin
  leafWidthPredim := 0;
  le := instance.LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      currentEntityInstance := (currentInstance as TEntityInstance);
      if (currentEntityInstance.GetCategory() = 'Leaf') then
      begin
        leafName := currentEntityInstance.GetName();
        if (instance.GetCategory() <> 'Tiller') then
        begin
          Delete(leafName, AnsiPos('L', leafName), 1);
        end
        else
        begin
          Delete(leafName, AnsiPos('_', leafName), Length(leafName));
          Delete(leafName, AnsiPos('L', leafName), 1);
        end;
        if (leafName = rank) then
        begin
          SRwriteln('Feuille considérée : ' + currentEntityInstance.GetName());
          leafPredim := currentEntityInstance.GetTAttribute('predim').GetCurrentSample().value;
          LL_BL := currentEntityInstance.GetTAttribute('LL_BL').GetCurrentSample().value;
          WLR := currentEntityInstance.GetTAttribute('WLR').GetCurrentSample().value;
          leafWidthPredim := (leafPredim / LL_BL) * WLR;
          SRwriteln('leafPredim      --> ' + FloatToStr(leafPredim));
          SRwriteln('LL_BL           --> ' + FloatToStr(LL_BL));
          SRwriteln('WLR             --> ' + FloatToStr(WLR));
          SRwriteln('leafWidthPredim --> ' + FloatToStr(leafWidthPredim));
        end;
      end;
    end;
  end;
  SRwriteln('Feuille de rang : ' + rank + ' --> widthPredim : ' + FloatToStr(leafWidthPredim));
  Result := leafWidthPredim;
end;

function FindLeafOnSameRankLength(var instance : TEntityInstance; rank : String) : Double;
var
  le, i : Integer;
  currentInstance : TInstance;
  currentEntityInstance : TEntityInstance;
  leafLength : Double;
  leafName : String;
begin
  leafLength := 0;
  le := instance.LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      currentEntityInstance := (currentInstance as TEntityInstance);
      if (currentEntityInstance.GetCategory() = 'Leaf') then
      begin
        leafName := currentEntityInstance.GetName();
        if (instance.GetCategory() <> 'Tiller') then
        begin
          Delete(leafName, AnsiPos('L', leafName), 1);
        end
        else
        begin
          Delete(leafName, AnsiPos('_', leafName), Length(leafName));
          Delete(leafName, AnsiPos('L', leafName), 1);
        end;
        if (leafName = rank) then
        begin
          SRwriteln('Feuille considérée : ' + currentEntityInstance.GetName());
          leafLength := currentEntityInstance.GetTAttribute('len').GetCurrentSample().value;
        end;
      end;
    end;
  end;
  SRwriteln('Feuille de rang : ' + rank + ' --> leafLength : ' + FloatToStr(leafLength));
  Result := leafLength;
end;

function FindInternodeAtRank(var instance : TEntityInstance; rank : String) : TEntityInstance;
var
  le, i : Integer;
  currentInstance : TInstance;
  currentEntityInstance : TEntityInstance;
  entityInternode : TEntityInstance;
  internodeName : String;
begin
  entityInternode := nil;
  le := instance.LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      currentEntityInstance := (currentInstance as TEntityInstance);
      if (currentEntityInstance.GetCategory() = 'Internode') then
      begin
        internodeName := currentEntityInstance.GetName();
        if (instance.GetCategory() <> 'Tiller') then
        begin
          Delete(internodeName, AnsiPos('IN', internodeName), 2);
        end
        else
        begin
          Delete(internodeName, AnsiPos('_', internodeName), Length(internodeName));
          Delete(internodeName, AnsiPos('IN', internodeName), 2);
        end;
        if (internodeName = rank) then
        begin
          entityInternode := currentEntityInstance;
        end;
      end;
    end;
  end;
  SRwriteln('Entrenoeud de rang : ' + rank);
  Result := entityInternode;
end;

function FindLastLigulatedLeafNumberOnCulm(var instance : TEntityInstance) : String;
var
  le : Integer;
  i : Integer;
  currentInstance : TInstance;
  currentEntityInstance : TEntityInstance;
  state : Integer;
  minDate, currentDate : TDateTime;
  minName : String;
begin
  minDate := MIN_DATE;
  minName := '';
  le := instance.LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      currentEntityInstance := (currentInstance as TEntityInstance);
      if (currentEntityInstance.GetCategory() = 'Leaf') then
      begin
        state := currentEntityInstance.GetCurrentState();
        if ((state = 4) or (state = 5)) then
        begin
          currentDate := currentEntityInstance.GetCreationDate();
          if (currentDate > minDate) then
          begin
            minDate := currentDate;
            minName := currentEntityInstance.GetName();
          end;
        end;
      end;
    end;
  end;
  if (minName <> '') then
  begin
    SRwriteln('last ligulated leaf name : ' + minName);
    if (instance.GetCategory() <> 'Tiller') then
    begin
      //SRwriteln('Sur brin maitre');
      Delete(minName, AnsiPos('L', minName), 1);
    end
    else
    begin
      //SRwriteln('Sur talle');
      Delete(minName, AnsiPos('_', minName), Length(minName));
      Delete(minName, AnsiPos('L', minName), 1);
    end;
    //SRwriteln('last ligulated leaf number : ' + minName);
  end
  else
  begin
    SRwriteln('Pas de feuille ligulee sur l''axe : ' + instance.GetName());
    minName := '-1';
  end;
  Result := minName;
end;

procedure TillerManagerStartInternodeElongation(var instance : TEntityInstance; const date : TDateTime = 0; const n : Integer = 0);
var
  entityInternode, refMeristem : TEntityInstance;
  internodeNumber : String;
  name : String;
  leafLength, leafWidth, MGR, plasto, ligulo, Tb, resp_LER, resp_INER, LIN1, IN_A, IN_B : Double;
  density_IN, MaximumReserveInInternode, stock_tiller, leaf_width_to_IN_diameter : Double;
  leaf_length_to_IN_length, slope_length_IN : Double;
  IN_length_to_IN_diam, coef_lin_IN_diam : Double;
  phenosStageAtCreation : Integer;
  sample : TSample;
begin
  refMeristem := (instance.GetFather() as TEntityInstance);
  phenosStageAtCreation := Trunc((instance as TEntityInstance).GetTAttribute('phenoStageAtCreation').GetCurrentSample().value);
  SRwriteln('phenoStageAtCreation --> ' + FloatToStr(phenosStageAtCreation));
  SRwriteln('n --> ' + FloatToStr(n));
  internodeNumber := FindLastLigulatedLeafNumberOnCulm(instance);
  SRwriteln('internodeNumber --> ' + internodeNumber);
  if (internodeNumber = '-1') then
  begin
    SRwriteln('Pas de feuille ligulee sur la talle, je passe mon tour');
  end
  else
  begin
    internodeNumber := IntToStr(n - phenosStageAtCreation);
    SRwriteln('internode number : ' + internodeNumber);
    name := 'IN' + internodeNumber;

    entityInternode := FindInternodeAtRank(instance, internodeNumber);

    SRwriteln('L''entrenoeud : ' + entityInternode.GetName() + ' commence de s''allonger');

    leafLength := FindLeafOnSameRankLength(instance, internodeNumber);
    leafWidth := FindLeafOnSameRankWidth(instance, internodeNumber);
    MGR := refMeristem.GetTAttribute('MGR').GetSample(date).value;
    plasto := refMeristem.GetTAttribute('plasto').GetSample(date).value;
    ligulo := refMeristem.GetTAttribute('ligulo').GetSample(date).value;
    Tb := refMeristem.GetTAttribute('Tb').GetSample(date).value;
    resp_LER := refMeristem.GetTAttribute('resp_LER').GetSample(date).value;
    resp_INER := resp_LER;
    LIN1 := refMeristem.GetTAttribute('LIN1').GetSample(date).value;
    IN_A := refMeristem.GetTAttribute('IN_A').GetSample(date).value;
    IN_B := refMeristem.GetTAttribute('IN_B').GetSample(date).value;
    density_IN := refMeristem.GetTAttribute('density_IN').GetSample(date).value;
    MaximumReserveInInternode := refMeristem.GetTAttribute('maximumReserveInInternode').GetSample(date).value;
    stock_tiller := instance.GetTAttribute('stock_tiller').GetSample(date).value;
    leaf_width_to_IN_diameter := refMeristem.GetTAttribute('leaf_width_to_IN_diameter').GetSample(date).value;
    leaf_length_to_IN_length := refMeristem.GetTAttribute('leaf_length_to_IN_length').GetSample(date).value;
    slope_length_IN := refMeristem.GetTAttribute('slope_length_IN').GetSample(date).value;
    IN_length_to_IN_diam := refMeristem.GetTAttribute('IN_length_to_IN_diam').GetSample(date).value;
    coef_lin_IN_diam := refMeristem.GetTAttribute('coef_lin_IN_diam').GetSample(date).value;

    sample.date := date;
    sample.value := leafLength;
    entityInternode.GetTAttribute('leafLength').SetSample(sample);

    sample.date := date;
    sample.value := leafWidth;
    entityInternode.GetTAttribute('leafWidth').SetSample(sample);

    sample.date := date;
    sample.value := MGR;
    entityInternode.GetTAttribute('MGR').SetSample(sample);

    sample.date := date;
    sample.value := plasto;
    entityInternode.GetTAttribute('plasto').SetSample(sample);

    sample.date := date;
    sample.value := ligulo;
    entityInternode.GetTAttribute('ligulo').SetSample(sample);

    sample.date := date;
    sample.value := Tb;
    entityInternode.GetTAttribute('Tb').SetSample(sample);

    sample.date := date;
    sample.value := resp_INER;
    entityInternode.GetTAttribute('resp_INER').SetSample(sample);

    sample.date := date;
    sample.value := LIN1;
    entityInternode.GetTAttribute('LIN1').SetSample(sample);

    sample.date := date;
    sample.value := IN_A;
    entityInternode.GetTAttribute('IN_A').SetSample(sample);

    sample.date := date;
    sample.value := IN_B;
    entityInternode.GetTAttribute('IN_B').SetSample(sample);

    sample.date := date;
    sample.value := density_IN;
    entityInternode.GetTAttribute('density_IN').SetSample(sample);

    sample.date := date;
    sample.value := MaximumReserveInInternode;
    entityInternode.GetTAttribute('MaximumReserveInInternode').SetSample(sample);

    sample.date := date;
    sample.value := stock_tiller;
    entityInternode.GetTAttribute('stock_culm').SetSample(sample);

    sample.date := date;
    sample.value := leaf_width_to_IN_diameter;
    entityInternode.GetTAttribute('leaf_width_to_IN_diameter').SetSample(sample);

    sample.date := date;
    sample.value := leaf_length_to_IN_length;
    entityInternode.GetTAttribute('leaf_length_to_IN_length').SetSample(sample);

    sample.date := date;
    sample.value := slope_length_IN;
    entityInternode.GetTAttribute('slope_length_IN').SetSample(sample);

    sample.date := date;
    sample.value := IN_length_to_IN_diam;
    entityInternode.GetTAttribute('IN_length_to_IN_diam').SetSample(sample);

    sample.date := date;
    sample.value := coef_lin_IN_diam;
    entityInternode.GetTAttribute('coef_lin_IN_diam').SetSample(sample);

    entityInternode.SetCurrentState(1);
  end;
  
end;

function FindLeafAtRank(var instance : TEntityInstance; rank : String) : TEntityInstance;
var
  le, i : Integer;
  currentInstance : TInstance;
  currentEntityInstance : TEntityInstance;
  entityLeaf : TEntityInstance;
  leafName : String;
begin

  SRwriteln(instance.GetName());

  entityLeaf := nil;
  SRwriteln('rank : ' + rank);
  le := instance.LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    currentInstance := (instance as TEntityInstance).GetTInstance(i);
    if (currentInstance is TEntityInstance) then
    begin
      currentEntityInstance := (currentInstance as TEntityInstance);
      if (currentEntityInstance.GetCategory() = 'Leaf') then
      begin
        leafName := currentEntityInstance.GetName();
        if (instance.GetCategory() <> 'Tiller') then
        begin
          Delete(leafName, AnsiPos('L', leafName), 1);
        end
        else
        begin
          Delete(leafName, AnsiPos('_', leafName), Length(leafName));
          Delete(leafName, AnsiPos('L', leafName), 1);
        end;
        if (leafName = rank) then
        begin
          entityLeaf := currentEntityInstance;
        end;
      end;
    end;
  end;
  SRwriteln('Feuille de rang : ' + rank);
  Result := entityLeaf;
end;

procedure TillerManagerPhytomerLeafActivation(var instance : TEntityInstance; const date : TDateTime);
var
  refMeristem, entityLeaf : TEntityInstance;
  activeLeavesNb, Lef1, MGR, plasto, ligulo, WLR, LL_BL, allo_area, G_L, resp_LER, Tb, coeffLifespan, mu, leaf_stock_max : Double;
  sample : TSample;
begin
  refMeristem := instance.GetFather() as TEntityInstance;
  activeLeavesNb := instance.GetTAttribute('activeLeavesNb').GetSample(date).value;

  SRwriteln('activeLeavesNb --> ' + FloatToStr(activeLeavesNb));

  entityLeaf := FindLeafAtRank(instance, FloatToStr(activeLeavesNb + 1));
  activeLeavesNb := activeLeavesNb + 1;
  sample.date := date;
  sample.value := activeLeavesNb;
  instance.GetTAttribute('activeLeavesNb').SetSample(sample);

  SRwriteln('La feuille : ' + entityLeaf.GetName() + ' est activée');

  Lef1 := refMeristem.GetTAttribute('Lef1').GetSample(date).value;
  MGR := refMeristem.GetTAttribute('MGR').GetSample(date).value;
  plasto := refMeristem.GetTAttribute('plasto').GetSample(date).value;
  ligulo := refMeristem.GetTAttribute('ligulo').GetSample(date).value;
  WLR := refMeristem.GetTAttribute('WLR').GetSample(date).value;
  LL_BL := refMeristem.GetTAttribute('LL_BL').GetSample(date).value;
  allo_area := refMeristem.GetTAttribute('allo_area').GetSample(date).value;
  G_L := refMeristem.GetTAttribute('G_L').GetSample(date).value;
  Tb := refMeristem.GetTAttribute('Tb').GetSample(date).value;
  resp_LER := refMeristem.GetTAttribute('resp_LER').GetSample(date).value;
  coeffLifespan := refMeristem.GetTAttribute('coeff_lifespan').GetSample(date).value;
  mu := refMeristem.GetTAttribute('mu').GetSample(date).value;
  leaf_stock_max := refMeristem.GetTAttribute('leaf_stock_max').GetSample(date).value;

  sample := entityLeaf.GetTAttribute('Lef1').GetSample(date);
  sample.value := Lef1;
  entityLeaf.GetTAttribute('Lef1').SetSample(sample);
  sample := entityLeaf.GetTAttribute('rank').GetSample(date);
  sample.value := activeLeavesNb;
  entityLeaf.GetTAttribute('rank').SetSample(sample);
  sample := entityLeaf.GetTAttribute('MGR').GetSample(date);
  sample.value := MGR;
  entityLeaf.GetTAttribute('MGR').SetSample(sample);
  sample := entityLeaf.GetTAttribute('plasto').GetSample(date);
  sample.value := plasto;
  entityLeaf.GetTAttribute('plasto').SetSample(sample);
  sample := entityLeaf.GetTAttribute('ligulo').GetSample(date);
  sample.value := ligulo;
  entityLeaf.GetTAttribute('ligulo').SetSample(sample);
  sample := entityLeaf.GetTAttribute('WLR').GetSample(date);
  sample.value := WLR;
  entityLeaf.GetTAttribute('WLR').SetSample(sample);
  sample := entityLeaf.GetTAttribute('allo_area').GetSample(date);
  sample.value := allo_area;
  entityLeaf.GetTAttribute('allo_area').SetSample(sample);
  sample := entityLeaf.GetTAttribute('G_L').GetSample(date);
  sample.value := G_L;
  entityLeaf.GetTAttribute('G_L').SetSample(sample);
  sample := entityLeaf.GetTAttribute('Tb').GetSample(date);
  sample.value := Tb;
  entityLeaf.GetTAttribute('Tb').SetSample(sample);
  sample := entityLeaf.GetTAttribute('resp_LER').GetSample(date);
  sample.value := resp_LER;
  entityLeaf.GetTAttribute('resp_LER').SetSample(sample);
  sample := entityLeaf.GetTAttribute('LL_BL').GetSample(date);
  sample.value := LL_BL;
  entityLeaf.GetTAttribute('LL_BL').SetSample(sample);
  sample := entityLeaf.GetTAttribute('coeffLifespan').GetSample(date);
  sample.value := coeffLifespan;
  entityLeaf.GetTAttribute('coeffLifespan').SetSample(sample);
  sample := entityLeaf.GetTAttribute('mu').GetSample(date);
  sample.value := mu;
  entityLeaf.GetTAttribute('mu').SetSample(sample);
  sample := entityLeaf.GetTAttribute('leaf_stock_max').GetSample(date);
  sample.value := leaf_stock_max;
  entityLeaf.GetTAttribute('leaf_stock_max').SetSample(sample);


  entityLeaf.SetCurrentState(1);

  entityLeaf.SetStartDate(date);
  entityLeaf.InitCreationDate(date);
  entityLeaf.InitNextDate();


end;

procedure TillerManagerPhytomerLeafCreation(var instance : TEntityInstance; const date : TDateTime; const IsInitiation : Boolean = False; const LL_BL_MODIFIED : Boolean = False);
var
  refMeristem, newLeaf : TEntityInstance;
  nb_leaf_max_after_PI : Double;
  activeLeavesNb, leafNb, isMainstem : Double;
  sample : TSample;
  attributeTmp : TAttribute;
  exeOrder : Integer;
  name : String;
  previousLeafPredimName, currentLeafPredimName : String;
begin
  refMeristem := instance.GetFather() as TEntityInstance;

  //TillerManagerPhytomerLeafActivation(instance, date);

  activeLeavesNb := instance.GetTAttribute('activeLeavesNb').GetSample(date).value;
  isMainstem := instance.GetTAttribute('isMainstem').GetSample(date).value;

  SRwriteln('isMainstem --> ' + FloatToStr(isMainstem));
  SRwriteln('activeLeavesNb --> ' + FloatToStr(activeLeavesNb));

  nb_leaf_max_after_PI := refMeristem.GetTAttribute('nb_leaf_max_after_PI').GetSample(date).value;

  leafNb := instance.GetTAttribute('leafNb').GetSample(date).value;
  leafNb := leafNb + 1;
  sample.date := date;
  sample.value := leafNb;
  instance.GetTAttribute('leafNb').SetSample(sample);

  activeLeavesNb := activeLeavesNb + 1;
  sample.value := activeLeavesNb;
  instance.GetTAttribute('activeLeavesNb').SetSample(sample);

  name := 'L' + FloatToStr(activeLeavesNb + nb_leaf_max_after_PI) + '_' + instance.GetName();

  SRwriteln('****  creation de la feuille : ' + name + '  ****');
  newLeaf := ImportLeaf_ng(name, (activeLeavesNb + nb_leaf_max_after_PI), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, isMainstem);

  // determination de l'ordre d'execution de newLeaf :
  exeOrder := Trunc(refMeristem.GetTAttribute('exeOrderOfFirstPhytomer').GetSample(date).value + (2 * (activeLeavesNb + nb_leaf_max_after_PI)) - 1);
  SRwriteln('ExeOrder : ' + IntToStr(exeOrder));


  newLeaf.SetExeOrder(exeOrder);
  newLeaf.SetStartDate(date);
  newLeaf.InitCreationDate(date);
  newLeaf.InitNextDate();
  newLeaf.SetCurrentState(2000);
  instance.AddTInstance(newLeaf);

  // connection port <-> attribut pour newLeaf
  previousLeafPredimName := 'predim_L' + FloatToStr((activeLeavesNb + nb_leaf_max_after_PI) - 1);
  currentLeafPredimName := 'predim_L' + FloatToStr(activeLeavesNb + nb_leaf_max_after_PI);

  attributeTmp := TAttributeTmp.Create(currentLeafPredimName);
  instance.AddTAttribute(attributeTmp);

  newLeaf.ExternalConnect(['degreeDayForLeafInitiation',
                           'degreeDayForLeafRealization',
                           //'testIc',
                           //'fcstr',
                           'phenoStage',
                           'SLA',
                           'plantStock',
                           'Tair',
                           'plasto_delay',
                           'thresLER',
                           'slopeLER',
                           'FTSW',
                           'lig',
                           'P']);
  instance.SortTInstance();
end;

procedure TillerManagerPhytomerInternodeCreation(var instance : TEntityInstance; const date : TDateTime; const IsFirstDayOfPI : Boolean = False);
var
  refMeristem, newInterNode : TEntityInstance;
  phenoStage : Double;
  internodeNb : Double;
  exeOrder : Integer;
  sample : TSample;
  name : String;
begin
  refMeristem := instance.GetFather() as TEntityInstance;

  phenoStage := (refMeristem.GetTAttribute('n') as TAttributeTableOut).GetCurrentSample().value;

//  nb_leaf_max_after_PI := refMeristem.GetTAttribute('nb_leaf_max_after_PI').GetSample(date).value;
  internodeNb := instance.GetTAttribute('internodeNb').GetSample(date).value;
  SRwriteln('Nombre d''entrenoeud : ' + FloatToStr(internodeNb));

  exeOrder := Trunc(refMeristem.GetTAttribute('exeOrderOfFirstPhytomer').GetSample(date).value + (2 * internodeNb));

  name := 'IN' + FloatToStr(internodeNb + 1) + '_' + instance.GetName();
  // on crée le premier entre noeud

  SRwriteln('****  creation de l''entrenoeud : ' + name + '  ****');
  SRwriteln('ExeOrder : ' + IntToStr(ExeOrder));

  newInternode := ImportInternode_ng(name, phenoStage, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

  sample.date := date;
  sample.value := internodeNb + 1;
  instance.GetTAttribute('internodeNb').SetSample(sample);

  sample.date := date;
  sample.value := internodeNb + 1;
  newInternode.GetTAttribute('rank').SetSample(sample);

  newInterNode.SetExeOrder(exeOrder);
  newInterNode.SetStartDate(date);
  newInterNode.InitCreationDate(date);
  newInterNode.SetCurrentState(2000);
  newInterNode.InitNextDate();

  instance.AddTInstance(newInternode);

  newInterNode.ExternalConnect(['degreeDayForInternodeInitiation',
                                'degreeDayForInternodeRealization',
                                'testIc',
                                'fcstr',
                                'phenoStage',
                                'stock_tiller',
                                'Tair',
                                'plasto_delay',
                                'thresINER',
                                'slopeINER',
                                'FTSW',
                                'P']);

  instance.SortTInstance();
end;

procedure TillerManagerCreateOthersPhytomers(var instance : TEntityInstance; const date : TDateTime = 0; const n : Integer = 0; const isMainstem : Double = 0);
begin
  TillerManagerCreateOthersIN(instance, date, n, isMainstem);
  TillerManagerCreateOthersLeaf(instance, date, n, isMainstem);
end;

procedure TillerManagerCreateOthersLeaf(var instance : TEntityInstance; const date : TDateTime = 0; const n : Integer = 0; const isMainstem : Double = 0);
var
  name : String;
  exeOrder : Integer;
  newLeaf, refMeristem : TEntityInstance;
  previousLeafPredimName, currentLeafPredimName :  String;
  attributeTmp : TAttribute;
  sample : TSample;
begin
  // creation des autres feuilles
  name := 'L' + FloatToStr(n + 1) + '_' + instance.GetName();
  refMeristem := instance.GetFather as TEntityInstance;
  exeOrder := Trunc(refMeristem.GetTAttribute('exeOrderOfFirstPhytomer').GetSample(date).value) + (2 * n) + 1;

  SRwriteln('****  creation de la feuille : ' + name + '  ****');

  newLeaf := ImportLeaf_ng(name, n + 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, isMainstem);

  // determination de l'ordre d'execution de newLeaf :
  // recherche de la premiere place vide apres la premiere entité de type 'Leaf'
  newLeaf.SetExeOrder(exeOrder);
  newLeaf.SetStartDate(date);
  newLeaf.InitCreationDate(date);
  newLeaf.InitNextDate();
  newLeaf.SetCurrentState(2000);
  instance.AddTInstance(newLeaf);

  previousLeafPredimName := 'predim_L' + FloatToStr(n);
  currentLeafPredimName := 'predim_L' + FloatToStr(n + 1);

  attributeTmp := TAttributeTmp.Create(currentLeafPredimName);
  instance.AddTAttribute(attributeTmp);

  newLeaf.ExternalConnect(['degreeDayForLeafInitiation',
                           'degreeDayForLeafRealization',
                           'phenoStage',
                           'SLA',
                           'plantStock',
                           'Tair',
                           'plasto_delay',
                           'thresLER',
                           'slopeLER',
                           'FTSW',
                           'lig',
                           'P']);

  sample := instance.GetTAttribute('leafNb').GetCurrentSample();
  sample.value := sample.value+1;
  sample.date := date;
  instance.GetTAttribute('leafNb').SetSample(sample);
  instance.SortTInstance();
end;

procedure TillerManagerCreateOthersIN(var instance : TEntityInstance; const date : TDateTime = 0; const n : Integer = 0; const isMainstem : Double = 0);
var
  refMeristem, newInternode : TEntityInstance;
  exeOrder : Integer;
  name : String;
  internodeNb : Double;
  sample : TSample;
begin
  refMeristem := instance.GetFather as TEntityInstance;
  exeOrder := Trunc(refMeristem.GetTAttribute('exeOrderOfFirstPhytomer').GetSample(date).value) + (2 * n);
  name := 'IN' + IntToStr(n + 1) + '_' + instance.GetName();

  // on crée le premier entre noeud

  SRwriteln('****  creation de l''entrenoeud : ' + name + '  ****');

  newInternode := ImportInternode_ng(name, n + 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0);

  internodeNb := instance.GetTAttribute('internodeNb').GetCurrentSample().value + 1;
  sample.date := date;
  sample.value := internodeNb;
  instance.GetTAttribute('internodeNb').SetSample(sample);

  sample.date := date;
  sample.value := internodeNb;
  newInternode.GetTAttribute('rank').SetSample(sample);

  //showmessage(inttostr(exeorder));

  newInterNode.SetExeOrder(exeOrder);
  newInterNode.SetStartDate(date);
  newInterNode.InitCreationDate(date);
  newInterNode.InitNextDate();
  newInternode.SetCurrentState(2000);

  instance.AddTInstance(newInternode);

  newInterNode.ExternalConnect(['degreeDayForInternodeInitiation',
                                'degreeDayForInternodeRealization',
                                'testIc',
                                'fcstr',
                                'phenoStage',
                                'stock_tiller',
                                'Tair',
                                'plasto_delay',
                                'thresINER',
                                'slopeINER',
                                'FTSW',
                                'P']);
  instance.SortTInstance();
end;

procedure TillerManagerCreateFirstPhytomers(var instance : TEntityInstance; const date : TDateTime = 0; const isMainstem : Double = 0);
begin
  TillerManagerCreateFirstIN(instance, date, isMainstem);
  TillerManagerCreateFirstLeaf(instance, date, isMainstem);
end;

procedure TillerManagerCreateFirstLeaf(var instance : TEntityInstance; const date : TDateTime = 0; const isMainstem : Double = 0);
var
  name : String;
  refMeristem, newLeaf : TEntityInstance;
  exeOrder : Integer;
  pos, Lef1, MGR, plasto, ligulo, WLR, LL_BL, LL_BL_New, allo_area, G_L, Tb, resp_LER, coeffLifespan, mu : Double;
  phenoStageAtPI, currentPhenoStage, slope_LL_BL_at_PI, leaf_stock_max : Double;
  sample : TSample;
  attributeTmp : TAttribute;
begin
  refMeristem := instance.GetFather() as TEntityInstance;
  // creation d'une premiere feuille
  sample.date := date;
  sample.value := 1;
  instance.GetTAttribute('leafNb').SetSample(sample);
  instance.GetTAttribute('activeLeavesNb').SetSample(sample);
  exeOrder := Trunc(refMeristem.GetTAttribute('exeOrderOfFirstPhytomer').GetCurrentSample().value) + 1;
  name := 'L1_' + instance.GetName();
  pos := 1;

  Lef1 := refMeristem.GetTAttribute('Lef1').GetSample(date).value;
  MGR := refMeristem.GetTAttribute('MGR_init').GetSample(date).value;
  plasto := refMeristem.GetTAttribute('plasto').GetSample(date).value;
  ligulo := refMeristem.GetTAttribute('ligulo').GetSample(date).value;
  WLR := refMeristem.GetTAttribute('WLR').GetSample(date).value;
  LL_BL := refMeristem.GetTAttribute('LL_BL_init').GetSample(date).value;
  allo_area := refMeristem.GetTAttribute('allo_area').GetSample(date).value;
  G_L := refMeristem.GetTAttribute('G_L').GetSample(date).value;
  Tb := refMeristem.GetTAttribute('Tb').GetSample(date).value;
  resp_LER := refMeristem.GetTAttribute('resp_LER').GetSample(date).value;
  phenoStageAtPI := instance.GetTAttribute('phenoStageAtPI').GetSample(date).value;
  currentPhenoStage := instance.GetTAttribute('phenoStage').GetSample(date).value;
  coeffLifespan := refMeristem.GetTAttribute('coeff_lifespan').GetSample(date).value;
  mu := refMeristem.GetTAttribute('mu').GetSample(date).value;
  leaf_stock_max := refMeristem.GetTAttribute('leaf_stock_max').GetSample(date).value;

  SRwriteln('****  creation de la feuille : ' + name + '  ****');

  slope_LL_BL_at_PI := refMeristem.GetTAttribute('slope_LL_BL_at_PI').GetSample(date).value;
  if ((currentPhenoStage > phenoStageAtPI) and (phenoStageAtPI <> 0)) then
  begin
    LL_BL_New := LL_BL + slope_LL_BL_at_PI * (currentPhenoStage - phenoStageAtPI);
  end
  else
  begin
    LL_BL_New := LL_BL;
  end;

  newLeaf := ImportLeaf_ng(name, 1, Lef1, MGR, plasto, ligulo, WLR, LL_BL_New, allo_area, G_L, Tb, resp_LER, coeffLifespan, mu, leaf_stock_max, pos, isMainstem);

  {sample := newLeaf.GetTAttribute('rank').GetSample(date);
  sample.value := 1;
  newLeaf.GetTAttribute('rank').SetSample(sample);}

  // determination de l'ordre d'execution de newLeaf :
  // recherche de la premiere place vide apres la premiere entité de type 'Leaf'
  newLeaf.SetExeOrder(exeOrder);
  newLeaf.SetStartDate(date);
  newLeaf.InitCreationDate(date);
  newLeaf.InitNextDate();
  newLeaf.SetCurrentState(2000);
  instance.AddTInstance(newLeaf);

  // connection port <-> attribut pour newLeaf
  attributeTmp := TAttributeTmp.Create('predim_L1');
  instance.AddTAttribute(attributeTmp);

  newLeaf.ExternalConnect(['degreeDayForLeafInitiation',
                           'degreeDayForLeafRealization',
                           'phenoStage',
                           'SLA',
                           'plantStock',
                           'Tair',
                           'plasto_delay',
                           'thresLER',
                           'slopeLER',
                           'FTSW',
                           'lig',
                           'P']);
  instance.SortTInstance();
end;

procedure TillerManagerCreateFirstIN(var instance : TEntityInstance; const date : TDateTime = 0; const isMainstem : Double = 0);
var
  exeOrder : Integer;
  name : String;
  newInternode, refMeristem : TEntityInstance;
  internodeNb : Double;
  sample : TSample;
begin
  refMeristem := instance.GetFather() as TEntityInstance;
  exeOrder := Trunc(refMeristem.GetTAttribute('exeOrderOfFirstPhytomer').GetSample(date).value);
  name := 'IN1_' + instance.GetName();

  // on crée le premier entre noeud

  SRwriteln('****  creation de l''entrenoeud : ' + name + '  ****');

  newInternode := ImportInternode_ng(name, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0);

  internodeNb := instance.GetTAttribute('internodeNb').GetCurrentSample().value + 1;
  sample.date := date;
  sample.value := internodeNb;
  instance.GetTAttribute('internodeNb').SetSample(sample);

  sample.date := date;
  sample.value := 1;
  newInternode.GetTAttribute('rank').SetSample(sample);

  newInterNode.SetExeOrder(exeOrder);
  newInterNode.SetStartDate(date);
  newInterNode.InitCreationDate(date);
  newInterNode.InitNextDate();
  newInternode.SetCurrentState(2000);

  instance.AddTInstance(newInternode);

  newInterNode.ExternalConnect(['degreeDayForInternodeInitiation',
                                'degreeDayForInternodeRealization',
                                'testIc',
                                'fcstr',
                                'phenoStage',
                                'stock_tiller',
                                'Tair',
                                'plasto_delay',
                                'thresINER',
                                'slopeINER',
                                'FTSW',
                                'P']);
  instance.SortTInstance();
end;

function TillerManagerPhytomer_ng(var instance : TEntityInstance; const date : TDateTime = 0 ; const state : Integer = 0) : Integer;
const
  INITIATION = 1;
  REALIZATION = 2;
  FERTILECAPACITY = 3;
  PI = 4;
  PRE_PI = 5;
  PRE_FLO = 6;
  FLO = 7;
  ELONG = 9;
  PRE_ELONG = 10;
  ENDFILLING = 12;
  DEAD = 1000;
var
  newState : Integer;
  plantState : Integer;
  newStateStr, oldStateStr : string;
  boolCrossedPlasto : Double;
  stock, deficit, diff, plantStock : Double;
  isFirstDayOfPi : Integer;
  phenoStageAtPI : Double;
  nb_leaf_max_after_PI : Double;
  currentPhenoStage : Double;
  refInstance : TInstance;
  i : Integer;
  nameOfLastLigulatedLeafOnTiller : String;
  fatherState : Integer;
  sample : TSample;
  previousState : Double;
  phenoStageAtPreFlo, phenostage_PRE_FLO_to_FLO, phenostage : Double;
  isMainstem : Double;
  refAttribute : TAttribute;
begin
  newState := 0;
  case state of
    // ETAT INITIATION :
    // -----------------
    INITIATION :
      begin
        oldStateStr := 'INITIATION';
        refInstance := (instance as TEntityInstance).GetFather();
        nb_leaf_max_after_PI := (refInstance as TEntityInstance).GetTAttribute('nb_leaf_max_after_PI').GetSample(date).value;
        isMainstem := instance.GetTAttribute('isMainstem').GetCurrentSample().value;
        // creation du premier phytomere
        TillerManagerCreateFirstPhytomers(instance, date, isMainstem);

        for i := 1 to Trunc(nb_leaf_max_after_PI) do
        begin
          TillerManagerCreateOthersPhytomers(instance, date, i, isMainstem);
        end;
        // nouvel état
        fatherState := (refInstance as TEntityInstance).GetCurrentState();
        if (fatherState = 9) then
        begin
          refAttribute := instance.GetTAttribute('stock_tiller');
          sample := refAttribute.GetCurrentSample();
          sample.value := 0.0000000000000001;
          refAttribute.SetSample(sample);
          newState := PRE_ELONG;
          newStateStr := 'PRE_ELONG';
        end
        else if (fatherState = 4) then
        begin
          refAttribute := instance.GetTAttribute('stock_tiller');
          sample := refAttribute.GetCurrentSample();
          sample.value := 0.0000000000000001;
          refAttribute.SetSample(sample);
        end
        else
        begin
          newState := REALIZATION;
          newStateStr := 'REALIZATION';
        end;
      end;

    // ETAT REALISATION :
    // ----------------
    REALIZATION :
      begin
        oldStateStr := 'REALIZATION';
        // initiation d'une nouvelle feuille a chaque nouveau plasto
        boolCrossedPlasto := instance.GetTAttribute('boolCrossedPlasto').GetSample(date).value;
        plantStock := instance.GetTAttribute('plantStock').GetSample(date).value;
        if ((boolCrossedPlasto >= 0) and (plantStock > 0)) then // New plastochron et stock disponible
        begin
          TillerManagerPhytomerInternodeCreation(instance, date, false);
          TillerManagerPhytomerLeafCreation(instance, date, false, false);
        end;
        // pas de changement d etat
        newState := state;
        newStateStr := 'REALIZATION';
      end;

    // Etat en attente de la fertilité
    // -------------------------------
    FERTILECAPACITY :
      begin
        oldStateStr := 'FERTILECAPACITY';
        // initiation d'une nouvelle feuille a chaque nouveau plasto
        boolCrossedPlasto := instance.GetTAttribute('boolCrossedPlasto').GetSample(date).value;
        plantStock := instance.GetTAttribute('plantStock').GetSample(date).value;
        if ((boolCrossedPlasto >= 0) and (plantStock > 0)) then // New plastochron et stock disponible
        begin
          // creation d'une nouvelle feuille
          // -------------------------------
          TillerManagerPhytomerInternodeCreation(instance, date, false);
          TillerManagerPhytomerLeafCreation(instance, date, false, false);
        end;
        // pas de changement d etat
        newState := state;
        newStateStr := 'FERTILECAPACITY';
      end;
    PRE_PI :
      begin
        SRwriteln('PRE_PI');
        oldStateStr := 'PRE_PI';
        // initiation d'une nouvelle feuille a chaque nouveau plasto
        boolCrossedPlasto := instance.GetTAttribute('boolCrossedPlasto').GetSample(date).value;
        previousState := instance.GetTAttribute('previousState').GetSample(date).value;
        currentPhenoStage := instance.GetTAttribute('phenoStage').GetSample(date).value;
        stock := instance.GetTAttribute('stock_tiller').GetCurrentSample().value;
        deficit := instance.GetTAttribute('deficit_tiller').GetCurrentSample().value;
        diff := Max(0, stock + deficit);
        SRwriteln('diff              --> ' + FloatToStr(diff));
        SRwriteln('boolCrossedPlasto --> ' + FloatToStr(boolCrossedPlasto));
        SRwriteln('previousState     --> ' + FloatToStr(previousState));

        if ((boolCrossedPlasto >= 0) and (diff > 0)) then // New plastochron et stock disponible
        begin
          // creation d'une nouvelle feuille
          // -------------------------------
          SRwriteln('TillerManagerPhytomerInternodeCreation');
          TillerManagerPhytomerInternodeCreation(instance, date, false);
          SRwriteln('TillerManagerPhytomerLeafCreation');
          TillerManagerPhytomerLeafCreation(instance, date, false, false);
          if (previousState = 9)then
          begin
            //SRwriteln('previous state --> ' + FloatToStr(previousState) + ' on allonge des IN meme a PRE_PI');
            //TillerManagerStartInternodeElongation(instance, date, Trunc(currentPhenoStage));
          end;
        end;
        // pas de changement d etat
        newState := state;
        newStateStr := 'PRE_PI';
      end;
    PI :
      begin
        oldStateStr := 'PI';
        SRwriteln('PI');
        refInstance := (instance as TEntityInstance).GetFather();
        nb_leaf_max_after_PI := (refInstance as TEntityInstance).GetTAttribute('nb_leaf_max_after_PI').GetSample(date).value;
        boolCrossedPlasto := instance.GetTAttribute('boolCrossedPlasto').GetSample(date).value;
        plantStock := instance.GetTAttribute('plantStock').GetSample(date).value;
        isFirstDayOfPi := Trunc(instance.GetTAttribute('isFirstDayOfPi').GetSample(date).value);
        phenoStageAtPI := instance.GetTAttribute('phenoStageAtPI').GetSample(date).value;
        currentPhenoStage := instance.GetTAttribute('phenoStage').GetSample(date).value;
        plantState := (refInstance as TEntityInstance).GetCurrentState();
        stock := instance.GetTAttribute('stock_tiller').GetCurrentSample().value;
        deficit := instance.GetTAttribute('deficit_tiller').GetCurrentSample().value;
        diff := Max(0, stock + deficit);
        SRwriteln('boolCrossedPlasto                     --> ' + FloatToStr(boolCrossedPlasto));
        SRwriteln('plantstock                            --> ' + FloatToStr(plantStock));
        SRwriteln('plantState                            --> ' + FloatToStr(plantState));
        SRwriteln('currentPhenoStage                     --> ' + FloatToStr(currentPhenoStage));
        SRwriteln('phenoStageAtPI                        --> ' + FloatToStr(phenostageAtPI));
        SRwriteln('nb_leaf_max_after_PI                  --> ' + FloatToStr(nb_leaf_max_after_PI));
        SRwriteln('phenoStageAtPI + nb_leaf_max_after_PI --> ' + FloatToStr(phenoStageAtPI + nb_leaf_max_after_PI));
        SRwriteln('stock                                 --> ' + FloatToStr(stock));
        SRwriteln('deficit                               --> ' + FloatToStr(deficit));
        SRwriteln('diff                                  --> ' + FloatToStr(diff));
        SRwriteln('isFirstDayOfPI                        --> ' + FloatToStr(isFirstDayOfPi));
        if ((boolCrossedPlasto >= 0) and (diff > 0)) then
        begin
          SRwriteln('currentPhenoStage    --> ' + FloatToStr(currentPhenoStage));
          SRwriteln('phenoStageAtPI       --> ' + FloatToStr(phenostageAtPI));
          SRwriteln('nb_leaf_max_after_PI --> ' + FloatToStr(nb_leaf_max_after_PI));
          if (currentPhenoStage <= phenoStageAtPI + nb_leaf_max_after_PI) then
          begin
            if (isFirstDayOfPI = 1) then
            begin
              SRwriteln('First day of PI on tiller');
              TillerManagerPhytomerInternodeCreation(instance, date, false);
              TillerManagerPhytomerLeafCreation(instance, date, false, false);
              //TillerManagerStartInternodeElongation(instance, date, Trunc(currentPhenoStage));
              SRwriteln('TillerManagerPhytomerPanicleCreation');
              TillerManagerPhytomerPanicleCreation(instance, date);
              SRwriteln('TillerManagerPhytomerPeduncleCreation');
              TillerManagerPhytomerPeduncleCreation(instance, date, false, plantStock);
              SRwriteln('TillerManagerPhytomerPanicleActivation');
              TillerManagerPhytomerPanicleActivation(instance);
              sample := instance.GetTAttribute('isFirstDayOfPi').GetSample(date);
              sample.value := 0;
              instance.GetTAttribute('isFirstDayOfPi').SetSample(sample);
              newState := PI;
              newStateStr := 'PI';
            end
            else
            begin
              sample := instance.GetTAttribute('panicleToBeActivated').GetCurrentSample();
              if (sample.value = 1) then
              begin
                SRwriteln('on avait pas active la panicule, il faut le faire');
                SRwriteln('TillerManagerPhytomerPanicleActivation');
                TillerManagerPhytomerPanicleActivation(instance);
                sample.value := 0;
                instance.GetTAttribute('panicleToBeActivated').SetSample(sample);
              end;
              SRwriteln('pas first day of pi');
              {SRwriteln('TillerManagerPhytomerLeafActivation');
              TillerManagerPhytomerLeafActivation(instance, date);}
              //SRwriteln('TillerManagerStartInternodeElongation');
              //TillerManagerStartInternodeElongation(instance, date, Trunc(currentPhenoStage));
              newState := PI;
              newStateStr := 'PI';
            end;
          end
          else
          begin
            if (currentPhenoStage >= (phenoStageAtPI + nb_leaf_max_after_PI + 1)) then
            begin
              SRwriteln('currentPhenoStage = (phenoStageAtPI + nb_leaf_max_after_PI + 1)');
              //SRwriteln('--- Appel de TillerManagerStartInternodeElongation ---');
              //TillerManagerStartInternodeElongation(instance, date, Trunc(currentPhenoStage));
              SRwriteln('--- Appel de TillerManagerPhytomerPeduncleActivation ---');
              TillerManagerPhytomerPeduncleActivation(instance, date);
              TillerStorePhenostageAtPre_Flo(instance, date, currentPhenoStage);
              newState := PRE_FLO;
              newStateStr := 'PRE_FLO';
            end;
          end;
        end
        else if ((boolCrossedPlasto >= 0) and (diff <= 0)) then
        begin
          SRwriteln('currentPhenoStage    --> ' + FloatToStr(currentPhenoStage));
          SRwriteln('phenoStageAtPI       --> ' + FloatToStr(phenostageAtPI));
          SRwriteln('nb_leaf_max_after_PI --> ' + FloatToStr(nb_leaf_max_after_PI));
          SRwriteln('pas de stock, mais on créé les entités');
          if (currentPhenoStage <= phenoStageAtPI + nb_leaf_max_after_PI) then
          begin
            if (isFirstDayOfPI = 1) then
            begin
              SRwriteln('First day of PI on tiller');
              TillerManagerPhytomerInternodeCreation(instance, date, false);
              TillerManagerPhytomerLeafCreation(instance, date, false, false);
              //TillerManagerStartInternodeElongation(instance, date, Trunc(currentPhenoStage));
              SRwriteln('TillerManagerPhytomerPanicleCreation');
              TillerManagerPhytomerPanicleCreation(instance, date);
              SRwriteln('TillerManagerPhytomerPeduncleCreation');
              TillerManagerPhytomerPeduncleCreation(instance, date, false, plantStock);
              //SRwriteln('TillerManagerPhytomerPanicleActivation');
              //TillerManagerPhytomerPanicleActivation(instance);
              sample := instance.GetTAttribute('isFirstDayOfPi').GetSample(date);
              sample.value := 0;
              instance.GetTAttribute('isFirstDayOfPi').SetSample(sample);
              sample := instance.GetTAttribute('panicleToBeActivated').GetCurrentSample();
              sample.value := 1;
              instance.GetTAttribute('panicleToBeActivated').SetSample(sample);
              newState := PI;
              newStateStr := 'PI';
            end
            else
            begin
              newState := PI;
              newStateStr := 'PI';
            end;
          end
          else
          begin
            if (currentPhenoStage >= (phenoStageAtPI + nb_leaf_max_after_PI + 1)) then
            begin
              SRwriteln('currentPhenoStage = (phenoStageAtPI + nb_leaf_max_after_PI + 1)');
              //SRwriteln('--- Appel de TillerManagerStartInternodeElongation ---');
              //TillerManagerStartInternodeElongation(instance, date, Trunc(currentPhenoStage));
              SRwriteln('--- Appel de TillerManagerPhytomerPeduncleActivation ---');
              TillerManagerPhytomerPeduncleActivation(instance, date);
              TillerStorePhenostageAtPre_Flo(instance, date, currentPhenoStage);
              newState := PRE_FLO;
              newStateStr := 'PRE_FLO';
            end;
          end;
        end
        else
        begin
          newState := PI;
          newStateStr := 'PI';
        end;
      end;


        // ------------------------
        // pas de changement d'etat
        // ------------------------

    PRE_FLO :
      begin
        oldStateStr := 'PRE_FLO';
        phenoStageAtPreFlo := instance.GetTAttribute('phenoStageAtPreFlo').GetSample(date).value;
        refInstance := (instance as TEntityInstance).GetFather();
        phenostage := (refInstance as TEntityInstance).GetTAttribute('n').GetSample(date).value;
        phenostage_PRE_FLO_to_FLO := (refInstance as TEntityInstance).GetTAttribute('phenostage_PRE_FLO_to_FLO').GetSample(date).value;
        SRwriteln('phenostage                --> ' + FloatToStr(phenostage));
        SRwriteln('phenoStageAtPreFlo        --> ' + FloatToStr(phenoStageAtPreFlo));
        SRwriteln('phenostage_PRE_FLO_to_FLO --> ' + FloatToStr(phenostage_PRE_FLO_to_FLO));
        if (phenostage = (phenoStageAtPreFlo + phenostage_PRE_FLO_to_FLO)) then
        begin
          PanicleTransitionToFLO(instance);
          PeduncleTransitionToFLO(instance);
          newState := FLO;
          newStateStr := 'FLO';
        end
        else
        begin
          newState := PRE_FLO;
          newStateStr := 'PRE_FLO';
        end;
      end;

    FLO :
      begin
        oldStateStr := 'FLO';
        newState := FLO;
        newStateStr := 'FLO';
      end;

    DEAD :
      begin
        oldStateStr := 'DEAD';
        newState := DEAD;
        newStateStr := 'DEAD';
      end;

    ELONG :
      begin
        oldStateStr := 'ELONG';
        nameOfLastLigulatedLeafOnTiller := FindLastLigulatedLeafNumberOnCulm(instance);
        if (nameOfLastLigulatedLeafOnTiller = '') then
        begin
          SRwriteln('Pas de feuille ligulee sur la talle, on passe en PRE_ELONG');
          newState := PRE_ELONG;
          newStateStr := 'PRE_ELONG';
        end
        else
        begin
          SRwriteln('Elongation');
          boolCrossedPlasto := instance.GetTAttribute('boolCrossedPlasto').GetSample(date).value;
          stock := instance.GetTAttribute('stock_tiller').GetCurrentSample().value;
          deficit := instance.GetTAttribute('deficit_tiller').GetCurrentSample().value;
          diff := Max(0, stock + deficit);
          currentPhenoStage := instance.GetTAttribute('phenoStage').GetSample(date).value;
          SRwriteln('currentPhenoStage --> ' + FloatToStr(currentPhenoStage));
          SRwriteln('stock   --> ' + FloatToStr(stock));
          SRwriteln('deficit --> ' + FloatToStr(deficit));
          SRwriteln('diff    --> ' + FloatToStr(diff));
          if ((boolCrossedPlasto >= 0) and (diff > 0)) then // New plastochron et stock disponible
          begin
            TillerManagerPhytomerInternodeCreation(instance, date, false);
            SRwriteln('Internode creation');
            TillerManagerPhytomerLeafCreation(instance, date, false, false);
            SRwriteln('Leaf creation');
            //TillerManagerStartInternodeElongation(instance, date, Trunc(currentPhenoStage));
            //SRwriteln('Internode elongation');
          end;
          newState := ELONG;
          newStateStr := 'ELONG';
        end;
      end;

      PRE_ELONG :
        begin
          oldStateStr := 'PRE_ELONG';
          nameOfLastLigulatedLeafOnTiller := FindLastLigulatedLeafNumberOnCulm(instance);
          if (nameOfLastLigulatedLeafOnTiller = '-1') then
          begin
            SRwriteln('Pas de feuille ligulee sur la talle, on reste en PRE_ELONG');
            boolCrossedPlasto := instance.GetTAttribute('boolCrossedPlasto').GetSample(date).value;
            stock := instance.GetTAttribute('stock_tiller').GetCurrentSample().value;
            deficit := instance.GetTAttribute('deficit_tiller').GetCurrentSample().value;
            diff := Max(0, stock + deficit);
            if ((boolCrossedPlasto >= 0) and (diff > 0)) then
            begin
              TillerManagerPhytomerInternodeCreation(instance, date, false);
              SRwriteln('Internode creation');
              TillerManagerPhytomerLeafCreation(instance, date, false, false);
              SRwriteln('Leaf creation');
            end;
            newState := PRE_ELONG;
            newStateStr := 'PRE_ELONG';
          end
          else
          begin
            boolCrossedPlasto := instance.GetTAttribute('boolCrossedPlasto').GetSample(date).value;
            currentPhenoStage := instance.GetTAttribute('phenoStage').GetSample(date).value;
            stock := instance.GetTAttribute('stock_tiller').GetCurrentSample().value;
            deficit := instance.GetTAttribute('deficit_tiller').GetCurrentSample().value;
            diff := Max(0, stock + deficit);
            if ((boolCrossedPlasto >= 0) and (diff > 0)) then // New plastochron et stock disponible
            begin
              SRwriteln('Une feuille ligulee sur la talle et changement de plastochron et stock positif, on passe en ELONG');
              TillerManagerPhytomerInternodeCreation(instance, date, false);
              SRwriteln('Internode creation');
              TillerManagerPhytomerLeafCreation(instance, date, false, false);
              SRwriteln('Leaf creation');
              //TillerManagerStartInternodeElongation(instance, date, Trunc(currentPhenoStage));
              //SRwriteln('Internode elongation');
              newState := ELONG;
              newStateStr := 'ELONG';
            end
            else
            begin
              newState := PRE_ELONG;
              newStateStr := 'PRE_ELONG';
            end;
          end;

        end;

      ENDFILLING :
        begin
          oldStateStr := 'ENDFILLING';
          newState := ENDFILLING;
          newStateStr := 'ENDFILLING';
        end;

      // ETAT NON DEFINI :
      // ----------------
      else
      begin
        result := -1;
        exit;
      end;
    end;


  SRwriteln('Tiller Manager Phytomer, transition de : ' + oldStateStr + ' --> ' + newStateStr);

  // retourne le nouvel état
  result := newState;
end;

function InternodeManager_ng(var instance : TEntityInstance; const date : TDateTime = 0 ; const state : Integer = 0) : Integer;
const
  PREDIM = 1;
  TRANSITION = 10;
  REALIZATION = 2;
  REALIZATION_NOSTOCK = 3;
  MATURITY = 4;
  MATURITY_NOSTOCK = 5;
  ENDFILLING = 12;
  PREDIM_NOGROWTH = 15;
  UNKNOWN = -1;
  DEAD = 1000;
  VEGETATIVE = 2000;
var
   newState, statePlant : Integer;
   stock, deficit, diff : Double;
   isDeficitConsidered : Boolean;
   oldStateStr, newStateStr : String;
   refMeristem, refTiller : TInstance;
begin
  SRwriteln('State : ' + IntToStr(state));
  refMeristem := instance.GetFather();
  refTiller := instance.GetFather();
  while (refMeristem.GetName() <> 'EntityMeristem') do
  begin
    refMeristem := refMeristem.GetFather();
  end;

  statePlant := (refMeristem as TEntityInstance).GetCurrentState();
  SRwriteln('statePlant  --> ' + IntToStr(statePlant));
  
  if (statePlant >= 4) then
  begin
    deficit := (refTiller as TEntityInstance).GetTAttribute('deficit_tiller').GetCurrentSample().value;
    stock := (refTiller as TEntityInstance).GetTAttribute('stock_tiller').GetCurrentSample().value;
    diff := Max(0, stock + deficit);
    SRwriteln('deficit_tiller --> ' + FloatToStr(deficit));
    SRwriteln('stock_tiller   --> ' + FloatToStr(stock));
    SRwriteln('diff           --> ' + FloatToStr(diff));
    isDeficitConsidered := True;
    stock := 1;
  end
  else
  begin
    stock := ((refMeristem as TEntityInstance).GetTAttribute('stock') as TAttributeTableOut).GetCurrentSample().value;
    SRwriteln('switch = stock_plant  --> ' + FloatToStr(stock));
    isDeficitConsidered := False;
    diff := 1;
  end;
  case state of
    VEGETATIVE :
      begin
        oldStateStr := 'VEGETATIVE';
        newState := VEGETATIVE;
        newStateStr := 'VEGETATIVE';
      end;

    // ETAT PREDIMENSIONNEMENT :
    // -----------------------
    PREDIM :
      begin
        oldStateStr := 'PREDIM';
        newState := TRANSITION;
        newStateStr := 'TRANSITION';
      end;

    // ETAT TRANSITION : (evite que etat 1 et 2 soit fait pendant le meme pas de temps)
    // ---------------
    TRANSITION :
      begin
        oldStateStr := 'TRANSITION';
        if (isDeficitConsidered) then
        begin
          if (diff = 0) then
          begin
            newState := REALIZATION_NOSTOCK;
            newStateStr := 'REALIZATION_NOSTOCK';
          end
          else
          begin
            newState := REALIZATION;
            newStateStr := 'REALIZATION';
          end;
        end
        else
        begin
          if (stock = 0) then
          begin
            newState := REALIZATION_NOSTOCK;
            newStateStr := 'REALIZATION_NOSTOCK';
          end
          else
          begin
            newState := REALIZATION;
            newStateStr := 'REALIZATION';
          end;
        end;
      end;

    // ETAT REALIZATION
    // ----------------
    REALIZATION :
      begin
        oldStateStr := 'REALIZATION';
        if (isDeficitConsidered) then
        begin
          if (diff = 0) then
          begin
            newState := REALIZATION_NOSTOCK;
            newStateStr := 'REALIZATION_NOSTOCK';
          end
          else
          begin
            newState := REALIZATION;
            newStateStr := 'REALIZATION';
          end;
        end
        else
        begin
          if (stock = 0) then
          begin
            newState := REALIZATION_NOSTOCK;
            newStateStr := 'REALIZATION_NOSTOCK';
          end
          else
          begin
            newState := REALIZATION;
            newStateStr := 'REALIZATION';
          end;
        end;
      end;

    // ETAT REALIZATION_NOSTOCK
    // ------------------------
    REALIZATION_NOSTOCK :
      begin
        oldStateStr := 'REALIZATION_NOSTOCK';
        if (isDeficitConsidered) then
        begin
          if (diff = 0) then
          begin
            newState := REALIZATION_NOSTOCK;
            newStateStr := 'REALIZATION_NOSTOCK';
          end
          else
          begin
            newState := REALIZATION;
            newStateStr := 'REALIZATION';
          end;
        end
        else
        begin
          if (stock = 0) then
          begin
            newState := REALIZATION_NOSTOCK;
            newStateStr := 'REALIZATION_NOSTOCK';
          end
          else
          begin
            newState := REALIZATION;
            newStateStr := 'REALIZATION';
          end;
        end;
      end;

    // ETAT LIGULE
    // -----------
    MATURITY :
      begin
        oldStateStr := 'MATURITY';
        if (isDeficitConsidered) then
        begin
          if (diff = 0) then
          begin
            newState := MATURITY_NOSTOCK;
            newStateStr := 'MATURITY_NOSTOCK';
          end
          else
          begin
            newState := MATURITY;
            newStateStr := 'MATURITY';
          end;
        end
        else
        begin
          if (stock = 0) then
          begin
            newState := MATURITY_NOSTOCK;
            newStateStr := 'MATURITY_NOSTOCK';
          end
          else
          begin
            newState := MATURITY;
            newStateStr := 'MATURITY';
          end;
        end;
      end;

    // ETAT LIGULE SANS STOCK
    // ----------------------
    MATURITY_NOSTOCK :
      begin
        oldStateStr := 'MATURITY_NOSTOCK';
        if (isDeficitConsidered) then
        begin
          if (diff = 0) then
          begin
            newState := MATURITY_NOSTOCK;
            newStateStr := 'MATURITY_NOSTOCK';
          end
          else
          begin
            newState := MATURITY;
            newStateStr := 'MATURITY';
          end;
        end
        else
        begin
          if (stock = 0) then
          begin
            newState := MATURITY_NOSTOCK;
            newStateStr := 'MATURITY_NOSTOCK';
          end
          else
          begin
            newState := MATURITY;
            newStateStr := 'MATURITY';
          end;
        end;
      end;

    DEAD :
      begin
        oldStateStr := 'DEAD';
        newState := DEAD;
        newStateStr := 'DEAD';
      end;

    ENDFILLING :
      begin
        oldStateStr := 'ENDFILLING';
        newState := ENDFILLING;
        newStateStr := 'ENDFILLING';
      end;

      // ETAT NON DEFINIT :
      // ----------------
      else
      begin
        newState := UNKNOWN;
      end;
    end;

  // retourne l'état (pas de modification d'état)
  SRwriteln('**** Internode --> Current State ' + oldStateStr + ' --> ' + newStateStr + ' ***');
  result := newState;
end;

function EcoMeristemManager_ng(var instance : TEntityInstance; const date : TDateTime = 0 ; const state : Integer = 0) : Integer;
const
  INIT = 1;
  INACTIVE = 2;
var
  newState, oldState : Integer;
  oldStateStr, newStateStr : String;
begin
  newState := INIT;
  oldState := state;
  if (oldState = INIT) then
  begin
    oldStateStr := 'INIT';
  end
  else if (oldState = INACTIVE) then
  begin
    oldStateStr := 'INACTIVE';
  end;
  case state of
    INIT :
    begin
      CreateFirstCulm_ng(instance, date);
      newState := INACTIVE;
      newStateStr := 'INACTIVE';
    end;
    INACTIVE :
    begin
      newState := INACTIVE;
      newStateStr := 'INACTIVE';
    end;
  end;
  SRwriteln('**** EcoMeristemManager_ng transition de ' + oldStateStr + ' vers ' + newStateStr);
  result := newState;
end;

procedure CreateFirstCulm_ng(var instance : TEntityInstance; const date : TDateTime);
var
  refFather : TModel;
  refInstance : TInstance;
  refMeristem : TEntityInstance;
  newTiller : TEntityInstance;
  i, le, exeOrderOfFirstCulm : Integer;
  name : string;
  thresINER, slopeINER, leafStockMax, n, maximumReserveInInternode : Double;

begin
  refFather := (instance.getFather() as TModel);
  refMeristem := nil;
  le := refFather.LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    refInstance := refFather.GetTInstance(i);
    if (refInstance.GetName() = 'EntityMeristem') then
    begin
      refMeristem := refInstance as TEntityInstance;
    end;
  end;
  if (refMeristem <> nil) then
  begin
    name := 'T_0';
    exeOrderOfFirstCulm := Trunc(refMeristem.GetTAttribute('exeOrderOfFirstCulm').GetSample(date).value);
    thresINER := refMeristem.GetTAttribute('thresINER').GetSample(date).value;
    slopeINER := refMeristem.GetTAttribute('slopeINER').GetSample(date).value;
    leafStockMax := refMeristem.GetTAttribute('leaf_stock_max').GetSample(date).value;
    n := refMeristem.GetTAttribute('n').GetSample(date).value;
    maximumReserveInInternode := refMeristem.GetTAttribute('maximumReserveInInternode').GetSample(date).value;
    SRwriteln('name                      --> ' + name);
    SRwriteln('exeOrderOfFirstCulm       --> ' + IntToStr(exeOrderOfFirstCulm));
    SRwriteln('thresINER                 --> ' + FloatToStr(thresINER));
    SRwriteln('slopeINER                 --> ' + FloatToStr(slopeINER));
    SRwriteln('leafStockMax              --> ' + FloatToStr(leafStockMax));
    SRwriteln('n                         --> ' + FloatToStr(n));
    SRwriteln('maximumReserveInInternode --> ' + FloatToStr(maximumReserveInInternode));
    newTiller := ImportTillerPhytomer_ng(name, thresINER, slopeINER, leafStockMax, n, maximumReserveInInternode, 1);
    newTiller.SetExeOrder(exeOrderOfFirstCulm);
    newTiller.SetStartDate(date);
    newTiller.InitCreationDate(date);
    newTiller.InitNextDate();
    refMeristem.AddTInstance(newTiller);
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
    refMeristem.SortTInstance();
  end;
end;

function LeafManager_ng(var instance : TEntityInstance; const date : TDateTime = 0 ; const state : Integer = 0) : Integer;
const
  PREDIM = 1;
  TRANSITION = 10;
  TRANSITION_TO_LIGULE = 20;
  REALIZATION_WITH_STOCK = 2;
  REALIZATION_WITHOUT_STOCK = 3;
  LIGULE_WITH_STOCK = 4;
  LIGULE_WITHOUT_STOCK = 5;
  ENDFILLING = 12;
  DEAD_BY_SENESCENCE = 500;
  DEAD = 1000;
  VEGETATIVE = 2000;
  UNDEFINED = -1;
var
   newState, statePlant : Integer;
   stock, deficit, diff : Double;
   newStateStr, oldStateStr : string;
   refMeristem, refTiller : TInstance;
   isDeficitConsidered : Boolean;
begin

  refMeristem := instance.GetFather();
  refTiller := instance.GetFather();

  while (refMeristem.GetName() <> 'EntityMeristem') do
  begin
    refMeristem := refMeristem.GetFather();
  end;

  statePlant := (refMeristem as TEntityInstance).GetCurrentState();
  SRwriteln('statePlant  --> ' + IntToStr(statePlant));
  
  if (statePlant >= 4) then
  begin
    deficit := (refTiller as TEntityInstance).GetTAttribute('deficit_tiller').GetCurrentSample().value;
    stock := (refTiller as TEntityInstance).GetTAttribute('stock_tiller').GetCurrentSample().value;
    diff := Max(0, stock + deficit);
    SRwriteln('deficit_tiller --> ' + FloatToStr(deficit));
    SRwriteln('stock_tiller   --> ' + FloatToStr(stock));
    SRwriteln('diff           --> ' + FloatToStr(diff));
    isDeficitConsidered := True;
  end
  else
  begin
    stock := instance.GetTAttribute('stock').GetSample(date).value;
    SRwriteln('stock = stock_plant  --> ' + FloatToStr(stock));
    isDeficitConsidered := False;
    diff := 1;
  end;

  case state of
    VEGETATIVE :
      begin
        oldStateStr := 'VEGETATIVE';
        newState := VEGETATIVE;
        newStateStr := 'VEGETATIVE';
      end;

    // ETAT PREDIMENSIONNEMENT :
    // -----------------------
    PREDIM :
      begin
        oldStateStr := 'PREDIM';
        newState := TRANSITION;
        newStateStr := 'TRANSITION';
      end;

    // ETAT TRANSITION : (evite que etat 1 et 2 soit fait pendant le meme pas de temps)
    // ---------------
    TRANSITION :
      begin
        oldStateStr := 'TRANSITION';
        if (isDeficitConsidered) then
        begin
          if (diff = 0) then
          begin
            // ETAT STOCK INDISPONIBLE
            newState := REALIZATION_WITHOUT_STOCK;
            newStateStr := 'REALIZATION_WITHOUT_STOCK';
          end
          else
          begin
            // ETAT STOCK DISPONIBLE
            newState := REALIZATION_WITH_STOCK;
            newStateStr := 'REALIZATION_WITH_STOCK';
          end;
        end
        else
        begin
          if (stock = 0) then
          begin
            // ETAT STOCK INDISPONIBLE
            newState := REALIZATION_WITHOUT_STOCK;
            newStateStr := 'REALIZATION_WITHOUT_STOCK';
          end
          else
          begin
            // ETAT STOCK DISPONIBLE
            newState := REALIZATION_WITH_STOCK;
            newStateStr := 'REALIZATION_WITH_STOCK';
          end;
        end;
      end;

    // ETAT REALIZATION et STOCK DISPONIBLE
    // ------------------------------------
    REALIZATION_WITH_STOCK :
      begin
        oldStateStr := 'REALIZATION_WITH_STOCK';
        if (isDeficitConsidered) then
        begin
          if (diff = 0) then
          begin
            // ETAT REALIZATION et STOCK INDISPONIBLE
            newState := REALIZATION_WITHOUT_STOCK;
            newStateStr := 'REALIZATION_WITHOUT_STOCK';
          end
          else
          begin
            // ETAT REALIZATION et STOCK DISPONIBLE
            newState := REALIZATION_WITH_STOCK;
            newStateStr := 'REALIZATION_WITH_STOCK';
          end;
        end
        else
        begin
          if (stock = 0) then
          begin
            // ETAT REALIZATION et STOCK INDISPONIBLE
            newState := REALIZATION_WITHOUT_STOCK;
            newStateStr := 'REALIZATION_WITHOUT_STOCK';
          end
          else
          begin
            // ETAT REALIZATION et STOCK DISPONIBLE
            newState := REALIZATION_WITH_STOCK;
            newStateStr := 'REALIZATION_WITH_STOCK';
          end;
        end;
      end;

    // ETAT REALIZATION et STOCK INDISPONIBLE
    // ------------------------------------
    REALIZATION_WITHOUT_STOCK :
      begin
        oldStateStr := 'REALIZATION_WITHOUT_STOCK';
        if (isDeficitConsidered) then
        begin
          if (diff = 0) then
          begin
            // ETAT REALIZATION et STOCK INDISPONIBLE
            newState := REALIZATION_WITHOUT_STOCK;
            newStateStr := 'REALIZATION_WITHOUT_STOCK';
          end
          else
          begin
            // ETAT REALIZATION et STOCK DISPONIBLE
            newState := REALIZATION_WITH_STOCK;
            newStateStr := 'REALIZATION_WITH_STOCK';
          end;
        end
        else
        begin
          if (stock = 0) then
          begin
            // ETAT REALIZATION et STOCK INDISPONIBLE
            newState := REALIZATION_WITHOUT_STOCK;
            newStateStr := 'REALIZATION_WITHOUT_STOCK';
          end
          else
          begin
            // ETAT REALIZATION et STOCK DISPONIBLE
            newState := REALIZATION_WITH_STOCK;
            newStateStr := 'REALIZATION_WITH_STOCK';
          end;
        end;
      end;

    // ETAT TRANSITION_TO_LIGULE
    // -------------------------

    TRANSITION_TO_LIGULE :
      begin
        oldStateStr := 'TRANSITION_TO_LIGULE';
        if (isDeficitConsidered) then
        begin
          if (diff = 0) then
          begin
            newState := LIGULE_WITHOUT_STOCK;
            newStateStr := 'LIGULE_WITHOUT_STOCK';
          end
          else
          begin
            newState := LIGULE_WITH_STOCK;
            newStateStr := 'LIGULE_WITH_STOCK';
          end;
        end
        else
        begin
          if (stock = 0) then
          begin
            newState := LIGULE_WITHOUT_STOCK;
            newStateStr := 'LIGULE_WITHOUT_STOCK';
          end
          else
          begin
            newState := LIGULE_WITH_STOCK;
            newStateStr := 'LIGULE_WITH_STOCK';
          end;
        end;
      end;

    // ETAT LIGULE et STOCK DISPONIBLE
    // ------------------------------------
    LIGULE_WITH_STOCK :
      begin
        oldStateStr := 'LIGULE_WITH_STOCK';
        if (isDeficitConsidered) then
        begin
          if (diff = 0) then
          begin
            newState := LIGULE_WITHOUT_STOCK;
            newStateStr := 'LIGULE_WITHOUT_STOCK';
          end
          else
          begin
            newState := LIGULE_WITH_STOCK;
            newStateStr := 'LIGULE_WITH_STOCK';
          end;
        end
        else
        begin
          if (stock = 0) then
          begin
            newState := LIGULE_WITHOUT_STOCK;
            newStateStr := 'LIGULE_WITHOUT_STOCK';
          end
          else
          begin
            newState := LIGULE_WITH_STOCK;
            newStateStr := 'LIGULE_WITH_STOCK';
          end;
        end;
      end;

    // ETAT LIGULE et STOCK INDISPONIBLE
    // ------------------------------------
    LIGULE_WITHOUT_STOCK :
      begin
        oldStateStr := 'LIGULE_WITHOUT_STOCK';
        if (isDeficitConsidered) then
        begin
          if (diff = 0) then
          begin
            newState := LIGULE_WITHOUT_STOCK;
            newStateStr := 'LIGULE_WITHOUT_STOCK';
          end
          else
          begin
            newState := LIGULE_WITH_STOCK;
            newStateStr := 'LIGULE_WITH_STOCK';
          end;
        end
        else
        begin
          if (stock = 0) then
          begin
            newState := LIGULE_WITHOUT_STOCK;
            newStateStr := 'LIGULE_WITHOUT_STOCK';
          end
          else
          begin
            newState := LIGULE_WITH_STOCK;
            newStateStr := 'LIGULE_WITH_STOCK';
          end;
        end;
      end;

    // ETAT MORT
    // ---------
    DEAD :
      begin
        oldStateStr := 'DEAD';
        newState := DEAD;
        newStateStr := 'DEAD';
      end;

    // ETAT MORT PAR SENESCENCE
    // ------------------------
    DEAD_BY_SENESCENCE :
      begin
        oldStateStr := 'DEAD_BY_SENESCENCE';
        newState := DEAD_BY_SENESCENCE;
        newStateStr := 'DEAD_BY_SENESCENCE';
      end;

    ENDFILLING :
      begin
        oldStateStr := 'ENDFILLING';
        newState := ENDFILLING;
        newStateStr := 'ENDFILLING';
      end;

      // ETAT NON DEFINIT :
      // ----------------
  else
  begin
    result := UNDEFINED;
    exit;
  end;
  end;

  // retourne l'état (pas de modification d'état)
  SRwriteln('leaf, etat de : ' + oldStateStr + ' --> ' + newStateStr);
  result := newState;
end;

function PanicleManager_ng(var instance : TEntityInstance; const date : TDateTime = 0; const state : Integer = 0) : Integer;
const
  PI = 1;
  TRANSITION_TO_FLO = 2;
  FLO = 3;
  ENDFILLING = 12;
  PI_NOSTOCK = 11;
  FLO_NOSTOCK = 13;
  DEAD = 1000;

  VEGETATIVE = 2000;
var
  newState, statePlant : Integer;
  oldStateStr, newStateStr : string;
  stock, deficit, diff : Double;
  refMeristem, refTiller : TInstance;
  isDeficitConsidered : Boolean;
begin

  newState := state;

  refMeristem := instance.GetFather();
  refTiller := instance.GetFather();

  while (refMeristem.GetName() <> 'EntityMeristem') do
  begin
    refMeristem := refMeristem.GetFather();
  end;

  statePlant := (refMeristem as TEntityInstance).GetCurrentState();
  SRwriteln('statePlant  --> ' + IntToStr(statePlant));

  if (statePlant >= 4) then
  begin
    deficit := (refTiller as TEntityInstance).GetTAttribute('deficit_tiller').GetCurrentSample().value;
    stock := (refTiller as TEntityInstance).GetTAttribute('stock_tiller').GetCurrentSample().value;
    diff := Max(0, stock + deficit);
    SRwriteln('deficit_tiller --> ' + FloatToStr(deficit));
    SRwriteln('stock_tiller   --> ' + FloatToStr(stock));
    SRwriteln('diff           --> ' + FloatToStr(diff));
    isDeficitConsidered := True;
    stock := 1;
  end
  else
  begin
    stock := instance.GetTAttribute('stock').GetSample(date).value;
    SRwriteln('stock = stock_plant  --> ' + FloatToStr(stock));
    isDeficitConsidered := False;
    diff := 1;
  end;

  case state of
    PI :
      begin
        oldStateStr := 'PI';
        if (isDeficitConsidered) then
        begin
          if (diff = 0) then
          begin
            newState := PI_NOSTOCK;
            newStateStr := 'PI_NOSTOCK';
          end
          else
          begin
            newState := PI;
            newStateStr := 'PI';
          end;
        end
        else
        begin
          if (stock = 0) then
          begin
            newState := PI_NOSTOCK;
            newStateStr := 'PI_NOSTOCK';
          end
          else
          begin
            newState := PI;
            newStateStr := 'PI';
          end;
        end;
      end;

    PI_NOSTOCK :
      begin
        oldStateStr := 'PI_NOSTOCK';
        if (isDeficitConsidered) then
        begin
          if (diff = 0) then
          begin
            newState := PI_NOSTOCK;
            newStateStr := 'PI_NOSTOCK';
          end
          else
          begin
            newState := PI;
            newStateStr := 'PI';
          end;
        end
        else
        begin
          if (stock = 0) then
          begin
            newState := PI_NOSTOCK;
            newStateStr := 'PI_NOSTOCK';
          end
          else
          begin
            newState := PI;
            newStateStr := 'PI';
          end;
        end;
      end;

    TRANSITION_TO_FLO :
      begin
        oldStateStr := 'TRANSITION_TO_FLO';
        newState := FLO;
        newStateStr := 'FLO';
      end;

    FLO :
      begin
        oldStateStr := 'FLO';
        if (isDeficitConsidered) then
        begin
          if (diff = 0) then
          begin
            newState := FLO_NOSTOCK;
            newStateStr := 'FLO_NOSTOCK';
          end
          else
          begin
            newState := FLO;
            newStateStr := 'FLO';
          end;
        end
        else
        begin
          if (stock = 0) then
          begin
            newState := FLO_NOSTOCK;
            newStateStr := 'FLO_NOSTOCK';
          end
          else
          begin
            newState := FLO;
            newStateStr := 'FLO';
          end;
        end;
      end;

    FLO_NOSTOCK :
      begin
        oldStateStr := 'FLO_NOSTOCK';
        if (isDeficitConsidered) then
        begin
          if (diff = 0) then
          begin
            newState := FLO_NOSTOCK;
            newStateStr := 'FLO_NOSTOCK';
          end
          else
          begin
            newState := FLO;
            newStateStr := 'FLO';
          end;
        end
        else
        begin
          if (stock = 0) then
          begin
            newState := FLO_NOSTOCK;
            newStateStr := 'FLO_NOSTOCK';
          end
          else
          begin
            newState := FLO;
            newStateStr := 'FLO';
          end;
        end;
      end;

    VEGETATIVE :
      begin
        oldStateStr := 'VEGETATIVE';
        newState := VEGETATIVE;
        newStateStr := 'VEGETATIVE';
      end;

    ENDFILLING :
      begin
        oldStateStr := 'ENDFILLING';
        newState := ENDFILLING;
        newStateStr := 'ENDFILLING';
      end;

    DEAD:
      begin
        oldStateStr := 'DEAD';
        newState := DEAD;
        newStateStr := 'DEAD';
      end;


  end;
  SRwriteln('Panicle Manager, transition de : ' + oldStateStr + ' --> ' + newStateStr);
  Result := newState;
end;

function PeduncleManager_ng(var instance : TEntityInstance; const date : TDateTime = 0; const state : Integer = 0) : Integer;
const
  PREDIM = 1;
  TRANSITION = 10;
  REALIZATION = 2;
  REALIZATION_NOSTOCK = 3;
  MATURITY = 4;
  MATURITY_NOSTOCK = 5;
  ENDFILLING = 12;
  UNKNOWN = -1;
  DEAD = 1000;
  FLO = 500;
  FLO_NOSTOCK = 501;
  VEGETATIVE = 2000;
var
  newState, statePlant : Integer;
  newStateStr, oldStateStr : string;
  stock, deficit, diff : Double;
  refMeristem, refTiller : TInstance;
  isDeficitConsidered : Boolean;
begin

  refMeristem := instance.GetFather();
  refTiller := instance.GetFather();

  while (refMeristem.GetName() <> 'EntityMeristem') do
  begin
    refMeristem := refMeristem.GetFather();
  end;

  statePlant := (refMeristem as TEntityInstance).GetCurrentState();
  SRwriteln('statePlant  --> ' + IntToStr(statePlant));

  if (statePlant >= 4) then
  begin
    deficit := (refTiller as TEntityInstance).GetTAttribute('deficit_tiller').GetCurrentSample().value;
    stock := (refTiller as TEntityInstance).GetTAttribute('stock_tiller').GetCurrentSample().value;
    diff := Max(0, stock + deficit);
    SRwriteln('deficit_tiller --> ' + FloatToStr(deficit));
    SRwriteln('stock_tiller   --> ' + FloatToStr(stock));
    SRwriteln('diff           --> ' + FloatToStr(diff));
    isDeficitConsidered := True;
    stock := 1;
  end
  else
  begin
    stock := instance.GetTAttribute('stock').GetSample(date).value;
    SRwriteln('stock = stock_plant  --> ' + FloatToStr(stock));
    isDeficitConsidered := False;
    diff := 1;
  end;

  case state of
    // ETAT PREDIMENSIONNEMENT :
    // -----------------------
    PREDIM :
      begin
        oldStateStr := 'PREDIM';
        newState := TRANSITION;
        newStateStr := 'TRANSITION';
      end;

    // ETAT TRANSITION : (evite que etat 1 et 2 soit fait pendant le meme pas de temps)
    // ---------------
    TRANSITION :
      begin
        oldStateStr := 'TRANSITION';
        newState := REALIZATION;
        newStateStr := 'REALIZATION';
      end;

    // ETAT REALIZATION
    // ----------------
    REALIZATION :
      begin
        oldStateStr := 'REALIZATION';
        if (isDeficitConsidered) then
        begin
          if (diff = 0) then
          begin
            newState := REALIZATION_NOSTOCK;
            newStateStr := 'REALIZATION_NOSTOCK';
          end
          else
          begin
            newState := REALIZATION;
            newStateStr := 'REALIZATION';
          end;
        end
        else
        begin
          if (stock = 0) then
          begin
            newState := REALIZATION_NOSTOCK;
            newStateStr := 'REALIZATION_NOSTOCK';
          end
          else
          begin
            newState := REALIZATION;
            newStateStr := 'REALIZATION';
          end;
        end;
      end;

    REALIZATION_NOSTOCK :
      begin
        oldStateStr := 'REALIZATION_NOSTOCK';
        if (isDeficitConsidered) then
        begin
          if (diff = 0) then
          begin
            newState := REALIZATION_NOSTOCK;
            newStateStr := 'REALIZATION_NOSTOCK';
          end
          else
          begin
            newState := REALIZATION;
            newStateStr := 'REALIZATION';
          end;
        end
        else
        begin
          if (stock = 0) then
          begin
            newState := REALIZATION_NOSTOCK;
            newStateStr := 'REALIZATION_NOSTOCK';
          end
          else
          begin
            newState := REALIZATION;
            newStateStr := 'REALIZATION';
          end;
        end;
      end;

    // ETAT LIGULE
    // -----------
    MATURITY :
      begin
        oldStateStr := 'MATURITY';
        if (isDeficitConsidered) then
        begin
          if (diff = 0) then
          begin
            newState := MATURITY_NOSTOCK;
            newStateStr := 'MATURITY_NOSTOCK';
          end
          else
          begin
            newState := MATURITY;
            newStateStr := 'MATURITY';
          end;  
        end
        else
        begin
          if (stock = 0) then
          begin
            newState := MATURITY_NOSTOCK;
            newStateStr := 'MATURITY_NOSTOCK';
          end
          else
          begin
            newState := MATURITY;
            newStateStr := 'MATURITY';
          end;
        end;
      end;

    MATURITY_NOSTOCK :
      begin
        oldStateStr := 'MATURITY_NOSTOCK';
        if (isDeficitConsidered) then
        begin
          if (diff = 0) then
          begin
            newState := MATURITY_NOSTOCK;
            newStateStr := 'MATURITY_NOSTOCK';
          end
          else
          begin
            newState := MATURITY;
            newStateStr := 'MATURITY';
          end;  
        end
        else
        begin
          if (stock = 0) then
          begin
            newState := MATURITY_NOSTOCK;
            newStateStr := 'MATURITY_NOSTOCK';
          end
          else
          begin
            newState := MATURITY;
            newStateStr := 'MATURITY';
          end;
        end;
      end;


    DEAD :
      begin
        oldStateStr := 'DEAD';
        newState := DEAD;
        newStateStr := 'DEAD';
      end;

    FLO :
      begin
        oldStateStr := 'FLO';
        if (isDeficitConsidered) then
        begin
          if (diff = 0) then
          begin
            newState := FLO_NOSTOCK;
            newStateStr := 'FLO_NOSTOCK';
          end
          else
          begin
            newState := FLO;
            newStateStr := 'FLO';
          end;
        end
        else
        begin
          if (stock = 0) then
          begin
            newState := FLO_NOSTOCK;
            newStateStr := 'FLO_NOSTOCK';
          end
          else
          begin
            newState := FLO;
            newStateStr := 'FLO';
          end;
        end;
      end;

    FLO_NOSTOCK :
      begin
        oldStateStr := 'FLO_NOSTOCK';
        if (isDeficitConsidered) then
        begin
          if (diff = 0) then
          begin
            newState := FLO_NOSTOCK;
            newStateStr := 'FLO_NOSTOCK';
          end
          else
          begin
            newState := FLO;
            newStateStr := 'FLO';
          end;
        end
        else
        begin
          if (stock = 0) then
          begin
            newState := FLO_NOSTOCK;
            newStateStr := 'FLO_NOSTOCK';
          end
          else
          begin
            newState := FLO;
            newStateStr := 'FLO';
          end;
        end;
      end;

    VEGETATIVE :
      begin
        oldStateStr := 'VEGETATIVE';
        newState := VEGETATIVE;
        newStateStr := 'VEGETATIVE';
      end;

    ENDFILLING :
      begin
        oldStateStr := 'ENDFILLING';
        newState := ENDFILLING;
        newStateStr := 'ENDFILLING';
      end;

      // ETAT NON DEFINIT :
      // ----------------
      else
      begin
        result := UNKNOWN;
        exit;
      end;
    end;

  // retourne l'état (pas de modification d'état)
  SRwriteln('**** Peduncle transition de ' + oldStateStr + ' --> ' + newStateStr);
  result := newState;

end;

function ThermalTimeManager_ng(var instance : TEntityInstance; const date : TDateTime = 0 ; const state : Integer = 0) : Integer;
const
  STOCK_AVAILABLE = 2;
  NO_STOCK = 3;
  DEAD = 1000;
var
  newState : Integer;
  stock, deficit, diff : Double;
begin

  if (state <> DEAD) then
  begin
    stock := instance.GetTAttribute('stock').GetSample(date).value;
    deficit := instance.GetTAttribute('deficit').GetSample(date).value;
    diff := Max(0, stock + deficit);
    SRwriteln('stock   --> ' + floattostr(stock));
    SRwriteln('deficit --> ' + floattostr(deficit));
    SRwriteln('diff    --> ' + floattostr(diff));

    if ((stock = 0) and (state = 1)) then
    begin
      // PREMIER JOUR
      // ------------
      newState := STOCK_AVAILABLE
    end
    else if (diff > 0) then
    begin
      // ETAT STOCK DISPONIBLE
      // ---------------------
      newState := STOCK_AVAILABLE;
    end
    else
    begin
      // ETAT STOCK INDISPONIBLE
      // -----------------------
      SRwriteln('*** phyllochrone is increased ***');
      newState := NO_STOCK;
    end;
  end
  else
  begin
    newState := DEAD;
  end;

  // retourne le nouvel état (pas de modification d'état)
  SRwriteln('ThermalTime manager new state : ' + FloatToStr(newState));
  result := newState;
end;

initialization

MANAGER_DECLARATION := TManagerInternal.Create('',EcoMeristemManager_ng);
MANAGER_DECLARATION.SetFunctName('EcoMeristemManager_ng');
MANAGER_LIBRARY.AddTManager(MANAGER_DECLARATION);

MANAGER_DECLARATION := TManagerInternal.Create('',MeristemManagerPhytomers_ng);
MANAGER_DECLARATION.SetFunctName('MeristemManagerPhytomers_ng');
MANAGER_LIBRARY.AddTManager(MANAGER_DECLARATION);

MANAGER_DECLARATION := TManagerInternal.Create('',InternodeManager_ng);
MANAGER_DECLARATION.SetFunctName('InternodeManager_ng');
MANAGER_LIBRARY.AddTManager(MANAGER_DECLARATION);

MANAGER_DECLARATION := TManagerInternal.Create('',LeafManager_ng);
MANAGER_DECLARATION.SetFunctName('LeafManager_ng');
MANAGER_LIBRARY.AddTManager(MANAGER_DECLARATION);

MANAGER_DECLARATION := TManagerInternal.Create('',PanicleManager_ng);
MANAGER_DECLARATION.SetFunctName('PanicleManager_ng');
MANAGER_LIBRARY.AddTManager(MANAGER_DECLARATION);

MANAGER_DECLARATION := TManagerInternal.Create('',PeduncleManager_ng);
MANAGER_DECLARATION.SetFunctName('PeduncleManager_ng');
MANAGER_LIBRARY.AddTManager(MANAGER_DECLARATION);

MANAGER_DECLARATION := TManagerInternal.Create('',ThermalTimeManager_ng);
MANAGER_DECLARATION.SetFunctName('ThermalTimeManager_ng');
MANAGER_LIBRARY.AddTManager(MANAGER_DECLARATION);

MANAGER_DECLARATION := TManagerInternal.Create('',TillerManagerPhytomer_ng);
MANAGER_DECLARATION.SetFunctName('TillerManagerPhytomer_ng');
MANAGER_LIBRARY.AddTManager(MANAGER_DECLARATION);

end.
