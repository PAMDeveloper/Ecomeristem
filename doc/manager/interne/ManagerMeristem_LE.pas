//---------------------------------------------------------------------------
/// Manageurs utilises pour le modele EcoMeristem_LE
///
///Description :
///
//----------------------------------------------------------------------------
(** @Author Ludovic TAMBOUR
    @Version 02/10/06 LT v0.0 version initiale; statut : en cours *)

unit ManagerMeristem_LE;

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
  DefinitionConstant;

function LeafManager_LE(var instance : TEntityInstance; const date : TDateTime = 0 ; const state : Integer = 0) : Integer;
function EcoMeristemManager_LE(var instance : TEntityInstance; const date : TDateTime = 0 ; const state : Integer = 0) : Integer;
function RootManager_LE(var instance : TEntityInstance; const date : TDateTime = 0 ; const state : Integer = 0) : Integer;
function InternodeManager_LE(var instance : TEntityInstance; const date : TDateTime = 0 ; const state : Integer = 0) : Integer;
function TillerManager_LE(var instance : TEntityInstance; const date : TDateTime = 0 ; const state : Integer = 0) : Integer;
function TillerManagerPhytomer_LE(var instance : TEntityInstance; const date : TDateTime = 0 ; const state : Integer = 0) : Integer;
function MeristemManager_LE(var instance : TEntityInstance; const date : TDateTime = 0 ; const state : Integer = 0) : Integer;
function MeristemManagerPhytomers_LE(var instance : TEntityInstance; const date : TDateTime = 0 ; const state : Integer = 0) : Integer;
function ThermalTimeManager_LE(var instance : TEntityInstance; const date : TDateTime = 0 ; const state : Integer = 0) : Integer;
function PanicleManager_LE(var instance : TEntityInstance; const date : TDateTime = 0; const state : Integer = 0) : Integer;
function PeduncleManager_LE(var instance : TEntityInstance; const date : TDateTime = 0; const state : Integer = 0) : Integer;

//
// procedures interne non appelée par d'autres fonctions que celle de cette unite
//
procedure MeristemManagerLeafCreation(var instance : TEntityInstance; const date : TDateTime = 0; const n : Double = 0; const LL_BL_MODIFIED : Boolean = False);
procedure MeristemManagerPhytomerLeafCreation(var instance : TEntityInstance; const date : TDateTime = 0; const n : Double = 0; const LL_BL_MODIFIED : Boolean = False);
procedure MeristemManagerPhytomerLeafActivation(var instance : TEntityInstance; const date : TDateTime = 0; const n : Double = 0);
procedure MeristemManagerInternodeCreation(var instance : TEntityInstance; const date : TDateTime = 0; isFirstInternode : Boolean = True; const n : Double = 0; const stock : Double = 0);
procedure MeristemManagerPhytomerInternodeCreation(var instance : TEntityInstance; const date : TDateTime = 0; isFirstInternode : Boolean = True; const n : Double = 0; const stock : Double = 0);
procedure MeristemManagerPanicleCreation(var instance : TEntityInstance; const date : TDateTime = 0);
procedure MeristemManagerPhytomerPanicleCreation(var instance : TEntityInstance; const date : TDateTime = 0);
procedure MeristemManagerPeduncleCreation(var instance : TEntityInstance; const date : TDateTime = 0; isFirstInternode : Boolean = True; const n : Double = 0; const stock : Double = 0);
procedure MeristemManagerPhytomerPeduncleCreation(var instance : TEntityInstance; const date : TDateTime = 0; isFirstInternode : Boolean = True; const n : Double = 0; const stock : Double = 0);
procedure MeristemManagerUpdatePlasto(var instance : TEntityInstance);
procedure MeristemManagerStartInternodeElongation(var instance : TEntityInstance; const date : TDateTime = 0; const n : Integer = 0; const IsFirstInternode : Boolean = False);
procedure MeristemManagerPhytomerPanicleActivation(var instance : TEntityInstance);
procedure MeristemManagerPhytomerPeduncleActivation(var instance : TEntityInstance; const date : TDateTime);
procedure TillerManagerLeafCreation(var instance : TEntityInstance; const date : TDateTime; const IsInitiation : Boolean = False; const LL_BL_MODIFIED : Boolean = False);
procedure TillerManagerPhytomerLeafCreation(var instance : TEntityInstance; const date : TDateTime; const IsInitiation : Boolean = False; const LL_BL_MODIFIED : Boolean = False);
procedure TillerManagerPhytomerLeafActivation(var instance : TEntityInstance; const date : TDateTime);
procedure TillerManagerInternodeCreation(var instance : TEntityInstance; const date : TDateTime; const IsFirstDayOfPI : Boolean = False; const plantStock : Double = 0);
procedure TillerManagerPhytomerInternodeCreation(var instance : TEntityInstance; const date : TDateTime; const IsFirstDayOfPI : Boolean = False; const plantStock : Double = 0);
procedure TillerManagerPanicleCreation(var instance : TEntityInstance; const date : TDateTime = 0);
procedure TillerManagerPhytomerPanicleCreation(var instance : TEntityInstance; const date : TDateTime = 0);
procedure TillerManagerPeduncleCreation(var instance : TEntityInstance; const date : TDateTime; const IsFirstDayOfPI : Boolean = False; const plantStock : Double = 0);
procedure TillerManagerPhytomerPeduncleCreation(var instance : TEntityInstance; const date : TDateTime; const IsFirstDayOfPI : Boolean = False; const plantStock : Double = 0);
procedure TillerManagerCreateFirstPhytomers(var instance : TEntityInstance; const date : TDateTime = 0);
procedure TillerManagerCreateOthersPhytomers(var instance : TEntityInstance; const date : TDateTime = 0; const n : Integer = 0);
procedure SetAllActiveStateToValue(instance : TEntityInstance; value : Integer);
procedure TillerManagerCreateFirstLeaf(var instance : TEntityInstance; const date : TDateTime = 0);
procedure TillerManagerCreateFirstIN(var instance : TEntityInstance; const date : TDateTime = 0);
procedure TillerManagerCreateOthersLeaf(var instance : TEntityInstance; const date : TDateTime = 0; const n : Integer = 0);
procedure TillerManagerCreateOthersIN(var instance : TEntityInstance; const date : TDateTime = 0; const n : Integer = 0);
procedure TillersTransitionToPre_PI_LE(var instance : TEntityInstance);
procedure TillersTransitionToState(var instance : TEntityInstance; const state : Integer);
procedure TillersTransitionToElong(var instance : TEntityInstance);
procedure TillersStockIndividualization(var instance : TEntityInstance; const date : TDateTime);
procedure TillerManagerPhytomerPanicleActivation(var instance : TEntityInstance);
procedure TillerManagerPhytomerPeduncleActivation(var instance : TEntityInstance; const date : TDateTime);
procedure TillerManagerStartInternodeElongation(var instance : TEntityInstance; const date : TDateTime = 0; const n : Integer = 0);
procedure RootTransitionToState(var instance : TEntityInstance; const state : Integer);
procedure RootTransitionToElong(var instance : TEntityInstance);
procedure RootTransitionToPI(var instance : TEntityInstance);
procedure RootTransitionToFLO(var instance : TEntityInstance);
procedure PanicleTransitionToFLO(var instance : TEntityInstance);
procedure PeduncleTransitionToFLO(var instance : TEntityInstance);
procedure CreateInitialPhytomers_LE(var instance : TEntityInstance; const date : TDateTime = 0);
procedure EcoMeristemFirstINCreation(var instance : TEntityInstance; const date : TDateTime = 0);
procedure EcoMeristemFirstLeafCreation(var instance : TEntityInstance; const date : TDateTime = 0);
procedure CreateFirstPhytomer_LE(var instance : TEntityInstance; const date : TDateTime = 0);
procedure EcoMeristemInitialOtherINCreation(var instance : TEntityInstance; const date : TDateTime = 0; const n : Integer = 0);
procedure EcoMeristemInitialOtherLeafCreation(var instance : TEntityInstance; const date : TDateTime = 0; const n : Integer = 0);
procedure CreateOtherPhytomers_LE(var instance : TEntityInstance; const date : TDateTime = 0; const n : Integer = 0);
procedure StoreThermalTimeAtPI(var instance : TEntityInstance; const date : TDateTime = 0);
procedure StorePhenostageAtPre_Flo(var instance : TEntityInstance; const date : TDateTime = 0; const phenostage : Double = 0);
procedure SetAllInstanceToEndFilling(var instance : TEntityInstance);
procedure TillerStorePhenostageAtPre_Flo(var instance : TEntityInstance; const date : TDateTime = 0; const phenostage : Double = 0);
function FindLastLigulatedLeafNumberOnCulm(var instance : TEntityInstance) : String;
function FindLeafOnSameRankWidth(var instance : TEntityInstance; rank : String) : Double;
function FindLeafOnSameRankLength(var instance : TEntityInstance; rank : String) : Double;
function FindLeafAtRank(var instance : TEntityInstance; rank : String) : TEntityInstance;
function FindInternodeAtRank(var instance : TEntityInstance; rank : String) : TEntityInstance;
function FindPeduncle(var instance : TEntityInstance) : TEntityInstance;
function FindPanicle(var instance : TEntityInstance) : TEntityInstance;

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

uses
  EntityLeaf_LE, EntityInternode_LE, EntityPanicle_LE, EntityPeduncle_LE;

// ----------------------------------------------------------------------------
//  fonction LeafManager_LE
//  ------------------------
//
/// gere le comportement d'une feuille
///
/// description : TODO
///
///
/// @param instance instance d'entité portant le manageur
/// @param date date actuelle de simulation  (par défaut, MIN_DATE)
/// @param state état actuel de l'instance portant le manageur (par défaut, 0)
/// @return nouvelle etat
// ---------------------------------------------------------------------------

function LeafManager_LE(var instance : TEntityInstance; const date : TDateTime = 0 ; const state : Integer = 0) : Integer;
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
   newState : Integer;
   stock : Double;
   newStateStr, oldStateStr : string;
begin
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
        stock := instance.GetTAttribute('stock').GetSample(date).value;
        if (stock > 0) then
        begin
          // ETAT STOCK DISPONIBLE
          newState := REALIZATION_WITH_STOCK;
          newStateStr := 'REALIZATION_WITH_STOCK';
        end
        else
        begin
          // ETAT STOCK INDISPONIBLE
        newState := REALIZATION_WITHOUT_STOCK;
        newStateStr := 'REALIZATION_WITHOUT_STOCK';
        end;
      end;

    // ETAT REALIZATION et STOCK DISPONIBLE
    // ------------------------------------
    REALIZATION_WITH_STOCK :
      begin
        oldStateStr := 'REALIZATION_WITH_STOCK';
        stock := instance.GetTAttribute('stock').GetSample(date).value;

        if (stock > 0) then
        begin
          // ETAT REALIZATION et STOCK DISPONIBLE
          newState := REALIZATION_WITH_STOCK;
          newStateStr := 'REALIZATION_WITH_STOCK';
        end
        else
        begin
          // ETAT REALIZATION et STOCK INDISPONIBLE
          newState := REALIZATION_WITHOUT_STOCK;
          newStateStr := 'REALIZATION_WITHOUT_STOCK';
        end;
      end;

    // ETAT REALIZATION et STOCK INDISPONIBLE
    // ------------------------------------
    REALIZATION_WITHOUT_STOCK :
      begin
        oldStateStr := 'REALIZATION_WITHOUT_STOCK';
        stock := instance.GetTAttribute('stock').GetSample(date).value;

        if (stock > 0) then
        begin
          // ETAT REALIZATION et STOCK DISPONIBLE
          newState := REALIZATION_WITH_STOCK;
          newStateStr := 'REALIZATION_WITH_STOCK';
        end
        else
        begin
          // ETAT REALIZATION et STOCK INDISPONIBLE
          newState := REALIZATION_WITHOUT_STOCK;
          newStateStr := 'REALIZATION_WITHOUT_STOCK';
        end;
      end;

    // ETAT TRANSITION_TO_LIGULE
    // -------------------------

    TRANSITION_TO_LIGULE :
      begin
        oldStateStr := 'TRANSITION_TO_LIGULE';
        stock := instance.GetTAttribute('stock').GetSample(date).value;

        if (stock > 0) then
        begin
          newState := LIGULE_WITH_STOCK;
          newStateStr := 'LIGULE_WITH_STOCK';
        end
        else
        begin
          newState := LIGULE_WITHOUT_STOCK;
          newStateStr := 'LIGULE_WITHOUT_STOCK';
        end;  
      end;

    // ETAT LIGULE et STOCK DISPONIBLE
    // ------------------------------------
    LIGULE_WITH_STOCK :
      begin
        oldStateStr := 'LIGULE_WITH_STOCK';
        stock := instance.GetTAttribute('stock').GetSample(date).value;

        if (stock > 0) then
        begin
          // ETAT LIGULE et STOCK DISPONIBLE
          newState := LIGULE_WITH_STOCK;
          newStateStr := 'LIGULE_WITH_STOCK';
        end
        else
        begin
          // ETAT LIGULE et STOCK INDISPONIBLE
          newState := LIGULE_WITHOUT_STOCK;
          newStateStr := 'LIGULE_WITHOUT_STOCK';
        end;
      end;

    // ETAT LIGULE et STOCK INDISPONIBLE
    // ------------------------------------
    LIGULE_WITHOUT_STOCK :
      begin
        oldStateStr := 'LIGULE_WITHOUT_STOCK';
        stock := instance.GetTAttribute('stock').GetSample(date).value;

        if (stock > 0) then
        begin
          // ETAT LIGULE et STOCK DISPONIBLE
          newState := LIGULE_WITH_STOCK;
          newStateStr := 'LIGULE_WITH_STOCK';
        end
        else
        begin
          // ETAT LIGULE et STOCK INDISPONIBLE
          newState := LIGULE_WITHOUT_STOCK;
          newStateStr := 'LIGULE_WITHOUT_STOCK';
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


// ----------------------------------------------------------------------------
//  fonction RootManager_LE
//  ------------------------
//
/// gere le comportement des racines
///
/// description : TODO
///
///
/// @param instance instance d'entité portant le manageur
/// @param date date actuelle de simulation  (par défaut, MIN_DATE)
/// @param state état actuel de l'instance portant le manageur (par défaut, 0)
/// @return nouvelle etat
// ---------------------------------------------------------------------------

function RootManager_LE(var instance : TEntityInstance; const date : TDateTime = 0 ; const state : Integer = 0) : Integer;
const
  INIT = 1;
  STOCK_AVAILABLE = 2;
  NO_STOCK = 3;
  PI_STOCK_AVAILABLE = 4;
  PI_NO_STOCK = 5;
  FLO = 6;
  ELONG_STOCK_AVAILABLE = 9;
  ELONG_NO_STOCK = 10;
  ENDFILLING = 12;
  DEAD = 1000;
var
   newState : Integer;
   stock : Double;
   newStateStr, oldStateStr : string;
begin

  if (state <> DEAD) then
  begin

    stock := instance.GetTAttribute('stock').GetSample(date).value;

    SRwriteln('stock = ' + floattostr(stock));

    case state of
      INIT :
      begin
        oldStateStr := 'INIT';
        newState := STOCK_AVAILABLE;
        newStateStr := 'STOCK_AVAILABLE';
      end;
      
      STOCK_AVAILABLE :
      begin
        oldStateStr := 'STOCK_AVAILABLE';
        if (stock > 0) then
        begin
          // ETAT STOCK DISPONIBLE
          // ---------------------
          newState := STOCK_AVAILABLE;
          newStateStr := 'STOCK_AVAILABLE';
        end
        else
        begin
          // ETAT STOCK INDISPONIBLE
          // -----------------------
          newState := NO_STOCK;
          newStateStr := 'NO_STOCK';
        end;
      end;

      NO_STOCK :
      begin
        oldStateStr := 'NO_STOCK';
        if (stock > 0) then
        begin
          // ETAT STOCK DISPONIBLE
          // ---------------------
          newState := STOCK_AVAILABLE;
          newStateStr := 'STOCK_AVAILABLE';
        end
        else
        begin
          // ETAT STOCK INDISPONIBLE
          // -----------------------
          newState := NO_STOCK;
          newStateStr := 'NO_STOCK';
        end;
      end;

      PI_STOCK_AVAILABLE :
      begin
        oldStateStr := 'PI_STOCK_AVAILABLE';
        if (stock > 0) then
        begin
          // ETAT STOCK DISPONIBLE
          // ---------------------
          newState := PI_STOCK_AVAILABLE;
          newStateStr := 'PI_STOCK_AVAILABLE';
        end
        else
        begin
          // ETAT STOCK INDISPONIBLE
          // -----------------------
          newState := PI_NO_STOCK;
          newStateStr := 'PI_NO_STOCK';
        end;
      end;

      PI_NO_STOCK :
      begin
        oldStateStr := 'PI_NO_STOCK';
        if (stock > 0) then
        begin
          // ETAT STOCK DISPONIBLE
          // ---------------------
          newState := PI_STOCK_AVAILABLE;
          newStateStr := 'PI_STOCK_AVAILABLE';
        end
        else
        begin
          // ETAT STOCK INDISPONIBLE
          // -----------------------
          newState := PI_NO_STOCK;
          newStateStr := 'PI_NO_STOCK';
        end;
      end;

      FLO :
      begin
        oldStateStr := 'FLO';
        newState := FLO;
        newStateStr := 'FLO';
      end;

      ELONG_STOCK_AVAILABLE :
      begin
        oldStateStr := 'ELONG_STOCK_AVAILABLE';
        if (stock > 0) then
        begin
          newState := ELONG_STOCK_AVAILABLE;
          newStateStr := 'ELONG_STOCK_AVAILABLE';
        end
        else
        begin
          newState := ELONG_NO_STOCK;
          newStateStr := 'ELONG_NO_STOCK';
        end;
      end;

      ELONG_NO_STOCK :
      begin
        oldStateStr := 'ELONG_NO_STOCK';
        if (stock > 0) then
        begin
          newState := ELONG_STOCK_AVAILABLE;
          newStateStr := 'ELONG_STOCK_AVAILABLE';
        end
        else
        begin
          newState := ELONG_NO_STOCK;
          newStateStr := 'ELONG_NO_STOCK';
        end;
      end;

      ENDFILLING :
      begin
        oldStateStr := 'ENDFILLING';
        newState := ENDFILLING;
        newStateStr := 'ENDFILLING';
      end;
    end;
  end
  else
  begin
    newState := DEAD;
    newStateStr := 'DEAD';
  end;

  // retourne le nouvel état (pas de modification d'état)
  SRwriteln('root, etat ' + oldStateStr + ' --> ' + newStateStr);
  result := newState;
end;


// ----------------------------------------------------------------------------
//  fonction InternodeManager_LE
//  ------------------------
//
/// gere le comportement des inter-noeuds
///
/// description : TODO
///
///
/// @param instance instance d'entité portant le manageur
/// @param date date actuelle de simulation  (par défaut, MIN_DATE)
/// @param state état actuel de l'instance portant le manageur (par défaut, 0)
/// @return nouvelle etat
// ---------------------------------------------------------------------------

function InternodeManager_LE(var instance : TEntityInstance; const date : TDateTime = 0 ; const state : Integer = 0) : Integer;
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
  VEGETATIVE = 2000;
var
   newState : Integer;
   stock : Double;
   name, oldStateStr, newStateStr : String;
begin
  name := instance.GetName();
  if (AnsiContainsStr(name, 'T')) then
  begin
    SRwriteln('Sur talle');
    stock := (instance.GetFather().GetFather() as TEntityInstance).GetTAttribute('stock').GetSample(date).value
  end
  else
  begin
    SRwriteln('Mainstem');
    stock := (instance.GetFather() as TEntityInstance).GetTAttribute('stock').GetSample(date).value
  end;
  SRwriteln('stock --> ' + FloatToStr(stock));
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
        newState := REALIZATION;
        newStateStr := 'REALIZATION';
      end;

    // ETAT REALIZATION
    // ----------------
    REALIZATION :
      begin
        oldStateStr := 'REALIZATION';
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

    // ETAT REALIZATION_NOSTOCK
    // ------------------------
    REALIZATION_NOSTOCK :
      begin
        oldStateStr := 'REALIZATION_NOSTOCK';
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

    // ETAT LIGULE
    // -----------
    MATURITY :
      begin
        oldStateStr := 'MATURITY';
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

    // ETAT LIGULE SANS STOCK
    // ----------------------
    MATURITY_NOSTOCK :
      begin
        oldStateStr := 'MATURITY_NOSTOCK';
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

procedure TillerManagerLeafCreation(var instance : TEntityInstance; const date : TDateTime; const IsInitiation : Boolean = False; const LL_BL_MODIFIED : Boolean = False);
var
  sample : Tsample;
  name : String;
  refMeristem : TEntityInstance;
  Lef1,MGR,plasto,ligulo,WLR,LL_BL,allo_area,G_L,Tb,resp_LER, coeffLifespan, mu : double;
  LL_BL_New, phenoStageAtPI, currentPhenoStage : Double;
  slope_LL_BL_at_PI : Double;
  newLeaf : TEntityInstance;
  attributeTmp : TAttribute;
  exeOrder : Integer;
  pos : Integer;
  rank : Integer;
  previousLeafPredimName, currentLeafPredimName : String;
begin
  if IsInitiation then
  begin
    // creation d'une premiere feuille
    sample.date := date; sample.value := 1;
    instance.GetTAttribute('leafNb').SetSample(sample);
    name := 'L1_' + instance.GetName();
    exeOrder := 2000;
    pos := 1;
  end
  else
  begin
    // creation des autres feuilles
    rank := FindGreatestSuffixforASpecifiedCategory(instance,'Leaf') + 1;
    name := 'L' + FloatToStr(rank) + '_' + instance.GetName();
    exeOrder := FindFirstEmptyPlaceAfterASpecifiedCategory(instance,'Leaf');
    pos := 0;
  end;
  refMeristem := instance.GetFather() as TEntityInstance;
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
  phenoStageAtPI := instance.GetTAttribute('phenoStageAtPI').GetSample(date).value;
  currentPhenoStage := instance.GetTAttribute('phenoStage').GetSample(date).value;
  coeffLifespan := refMeristem.GetTAttribute('coeff_lifespan').GetSample(date).value;
  mu := refMeristem.GetTAttribute('mu').GetSample(date).value;

  SRwriteln('****  creation de la feuille : ' + name + '  ****');

  slope_LL_BL_at_PI := refMeristem.GetTAttribute('slope_LL_BL_at_PI').GetSample(date).value;
  if LL_BL_MODIFIED then
    LL_BL_New := LL_BL + slope_LL_BL_at_PI * (currentPhenoStage - phenoStageAtPI)
  else
    LL_BL_New := LL_BL;

  newLeaf := ImportLeaf_LE(name, Lef1, MGR, plasto, ligulo, WLR, LL_BL_New, allo_area, G_L, Tb, resp_LER, coeffLifespan, mu, 0);

  // determination de l'ordre d'execution de newLeaf :
  // recherche de la premiere place vide apres la premiere entité de type 'Leaf'
  newLeaf.SetExeOrder(exeOrder);
  newLeaf.SetStartDate(date);
  newLeaf.InitCreationDate(date);
  newLeaf.InitNextDate();
  instance.AddTInstance(newLeaf);

  if IsInitiation then
  begin
    // connection port <-> attribut pour newLeaf
    attributeTmp := TAttributeTmp.Create('predim_L1');
    instance.AddTAttribute(attributeTmp);

    newLeaf.ExternalConnect(['zero',
                             'predimLeafOnMainstem',
                             'predim_L1',
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
                             'lig',
                             'P']);
  end
  else
  begin
    previousLeafPredimName := 'predim_L' + FloatToStr(rank-1);
    currentLeafPredimName := 'predim_L' + FloatToStr(rank);

    attributeTmp := TAttributeTmp.Create(currentLeafPredimName);
    instance.AddTAttribute(attributeTmp);

    newLeaf.ExternalConnect([previousLeafPredimName,
                             'predimLeafOnMainstem',
                             currentLeafPredimName,
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
                             'lig',
                             'P']);

    sample := instance.GetTAttribute('leafNb').GetCurrentSample();
    sample.value := sample.value+1; sample.date := date;
    instance.GetTAttribute('leafNb').SetSample(sample);
  end;
  instance.SortTInstance();
end;

procedure TillerManagerPhytomerLeafActivation(var instance : TEntityInstance; const date : TDateTime);
var
  refMeristem, entityLeaf : TEntityInstance;
  activeLeavesNb, Lef1, MGR, plasto, ligulo, WLR, LL_BL, allo_area, G_L, resp_LER, Tb, coeffLifespan, mu : Double;
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


  entityLeaf.SetCurrentState(1);

  entityLeaf.SetStartDate(date);
  entityLeaf.InitCreationDate(date);
  entityLeaf.InitNextDate();


end;

procedure TillerManagerPhytomerLeafCreation(var instance : TEntityInstance; const date : TDateTime; const IsInitiation : Boolean = False; const LL_BL_MODIFIED : Boolean = False);
var
  refMeristem, newLeaf : TEntityInstance;
  nb_leaf_max_after_PI : Double;
  activeLeavesNb, leafNb : Double;
  sample : TSample;
  attributeTmp : TAttribute;
  exeOrder : Integer;
  name : String;
  previousLeafPredimName, currentLeafPredimName : String;
begin
  refMeristem := instance.GetFather() as TEntityInstance;

  TillerManagerPhytomerLeafActivation(instance, date);

  activeLeavesNb := instance.GetTAttribute('activeLeavesNb').GetSample(date).value;
  nb_leaf_max_after_PI := refMeristem.GetTAttribute('nb_leaf_max_after_PI').GetSample(date).value;

  leafNb := instance.GetTAttribute('leafNb').GetSample(date).value;
  leafNb := leafNb + 1;
  sample.date := date;
  sample.value := leafNb;

  name := 'L' + FloatToStr(activeLeavesNb + nb_leaf_max_after_PI) + '_' + instance.GetName();

  SRwriteln('****  creation de la feuille : ' + name + '  ****');
  newLeaf := ImportLeaf_LE(name, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

  instance.GetTAttribute('leafNb').SetSample(sample);

  // determination de l'ordre d'execution de newLeaf :
  exeOrder := Trunc(refMeristem.GetTAttribute('exeOrderOfFirstPhytomer').GetSample(date).value + (2 * (activeLeavesNb + nb_leaf_max_after_PI)) - 1);
  SRwriteln('ExeOrder : ' + IntToStr(exeOrder));


  newLeaf.SetExeOrder(exeOrder);
  newLeaf.SetStartDate(MAX_DATE);
  newLeaf.InitCreationDate(MAX_DATE);
  newLeaf.InitNextDate();
  newLeaf.SetCurrentState(2000);
  instance.AddTInstance(newLeaf);

  // connection port <-> attribut pour newLeaf
  previousLeafPredimName := 'predim_L' + FloatToStr((activeLeavesNb + nb_leaf_max_after_PI) - 1);
  currentLeafPredimName := 'predim_L' + FloatToStr(activeLeavesNb + nb_leaf_max_after_PI);

  attributeTmp := TAttributeTmp.Create(currentLeafPredimName);
  instance.AddTAttribute(attributeTmp);

  newLeaf.ExternalConnect([previousLeafPredimName,
                           'predimLeafOnMainstem',
                           currentLeafPredimName,
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
                           'lig',
                           'P']);
  instance.SortTInstance();
end;

procedure TillerManagerInternodeCreation(var instance : TEntityInstance; const date : TDateTime; const IsFirstDayOfPI : Boolean = False; const plantStock : Double = 0);
var
  sumOfTillerLeafBiomass, SumOfPlantBiomass : Double;
  sample : TSample;
  exeOrder, pos : Integer;
  internodeNumber : Integer;
  rank : Double;
  name : String;
  TT : Double;
  TT_PI_Attribute : TAttribute;
  attributeTmp : TAttribute;
  refMeristem : TEntityInstance;
  newInternode : TEntityInstance;
  MGR, plasto, Tb, resp_LER, resp_INER, LIN1, IN_A, IN_B, density_IN : Double;
  MaximumReserveInInternode : Double;
  leaf_width_to_IN_diameter, leaf_length_to_IN_length : Double;
  leafLength, leafWidth : Double;
  previousInternodePredimName, currentInternodePredimName : String;
  sampleTmp : TSample;

  i : integer;

begin
  refMeristem := instance.GetFather() as TEntityInstance;
  if IsFirstDayOfPI then
  begin
    sumOfTillerLeafBiomass := instance.GetTAttribute('sumOfTillerLeafBiomass').GetSample(date).value;
    SumOfPlantBiomass := refMeristem.GetTAttribute('sumOfLeafBiomass').GetSample(date).value;
    sample := instance.GetTAttribute('stock_tiller').GetSample(date);
    sample.value := (sumOfTillerLeafBiomass / SumOfPlantBiomass) * plantStock;
    instance.GetTAttribute('stock_tiller').SetSample(sample);

    sample := instance.GetTAttribute('isFirstDayOfPi').GetSample(date);
    sample.value := 0;
    instance.GetTAttribute('isFirstDayOfPi').SetSample(sample);

    exeOrder := Trunc(refMeristem.GetTAttribute('exeOrderOfFirstInternode').GetSample(date).value);
    SRwriteln('exe order: ' + inttostr(exeorder));

    //
    // les entrenoeuds seront creees de la même manière que sur le brin maitre
    // -----------------------------------------------------------------


    ////////////////////////////////////////////////////////////////
    // On récupère la valeur de TT et on la stocke dans Tiller_TT_PI
    ////////////////////////////////////////////////////////////////

    TT := refMeristem.GetTAttribute('TT').GetSample(date).value;
    TT_PI_Attribute := refMeristem.GetTAttribute('TT_PI');
    Sample := TT_PI_Attribute.GetSample(date);
    Sample.value := TT;
    TT_PI_Attribute.SetSample(Sample);
    SRwriteln('TT_PI : ' + floattostr(Sample.value));

    pos := 1;
  end
  else
  begin
    exeOrder := FindFirstEmptyPlaceAfterASpecifiedCategory(instance,'Internode');
    pos := 0;
  end;
  rank := instance.GetTAttribute('leafNb').GetSample(date).value - 1;
  internodeNumber := StrToInt(FindLastLigulatedLeafNumberOnCulm(instance));
  name := 'IN' + IntToStr(internodeNumber) + '_' + instance.GetName();
  leafLength := FindLeafOnSameRankLength(instance, intToStr(internodeNumber));
  leafWidth := FindLeafOnSameRankWidth(instance, intToStr(internodeNumber));
  MGR := refMeristem.GetTAttribute('MGR').GetSample(date).value;
  plasto := refMeristem.GetTAttribute('plasto').GetSample(date).value;
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


  // on crée le premier entre noeud

  SRwriteln('****  creation de l''entrenoeud : ' + name + '  ****');

  newInternode := ImportInternode_LE(name, MGR, plasto, Tb, resp_INER, LIN1, IN_A, IN_B, density_IN, leaf_width_to_IN_diameter, leaf_length_to_IN_length, leafLength, leafWidth, MaximumReserveInInternode, pos, 1);
  newInterNode.SetExeOrder(exeOrder);
  newInterNode.SetStartDate(date);
  newInterNode.InitCreationDate(date);
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

procedure TillerManagerPhytomerInternodeCreation(var instance : TEntityInstance; const date : TDateTime; const IsFirstDayOfPI : Boolean = False; const plantStock : Double = 0);
var
  refMeristem, newInterNode : TEntityInstance;
  nb_leaf_max_after_PI, internodeNb : Double;
  exeOrder : Integer;
  sample : TSample;
  name : String;
begin
  refMeristem := instance.GetFather() as TEntityInstance;

  nb_leaf_max_after_PI := refMeristem.GetTAttribute('nb_leaf_max_after_PI').GetSample(date).value;
  internodeNb := instance.GetTAttribute('internodeNb').GetSample(date).value;
  SRwriteln('Nombre d''entrenoeud : ' + FloatToStr(internodeNb));

  exeOrder := Trunc(refMeristem.GetTAttribute('exeOrderOfFirstPhytomer').GetSample(date).value + (2 * internodeNb));

  name := 'IN' + FloatToStr(internodeNb + 1) + '_' + instance.GetName();
  // on crée le premier entre noeud

  SRwriteln('****  creation de l''entrenoeud : ' + name + '  ****');
  SRwriteln('ExeOrder : ' + IntToStr(ExeOrder));

  newInternode := ImportInternode_LE(name, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

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

procedure TillerManagerPeduncleCreation(var instance : TEntityInstance; const date : TDateTime; const IsFirstDayOfPI : Boolean = False; const plantStock : Double = 0);
var
  sumOfTillerLeafBiomass, SumOfPlantBiomass : Double;
  sample : TSample;
  exeOrder, pos : Integer;
  internodeNumber : Integer;
  rank : Double;
  name, instanceName : String;
  TT : Double;
  TT_PI_Attribute : TAttribute;
  attributeTmp : TAttribute;
  refMeristem : TEntityInstance;
  newInternode : TEntityInstance;
  MGR, plasto, Tb, resp_LER, resp_INER, LIN1, IN_A, IN_B, density_IN : Double;
  MaximumReserveInInternode, stock_mainstem : Double;
  leaf_width_to_IN_diameter, leaf_length_to_IN_length : Double;
  leafLength, leafWidth : Double;
  previousInternodePredimName, currentInternodePredimName : String;
  sampleTmp : TSample;

  i : integer;

begin
  refMeristem := instance.GetFather() as TEntityInstance;
  sumOfTillerLeafBiomass := instance.GetTAttribute('sumOfTillerLeafBiomass').GetSample(date).value;
  SumOfPlantBiomass := refMeristem.GetTAttribute('sumOfLeafBiomass').GetSample(date).value;
  sample := instance.GetTAttribute('stock_tiller').GetSample(date);
  sample.value := (sumOfTillerLeafBiomass / SumOfPlantBiomass) * plantStock;
  instance.GetTAttribute('stock_tiller').SetSample(sample);
  sample := instance.GetTAttribute('isFirstDayOfPi').GetSample(date);
  sample.value := 0;
  instance.GetTAttribute('isFirstDayOfPi').SetSample(sample);

  exeOrder := Trunc(refMeristem.GetTAttribute('exeOrderOfPeduncle').GetSample(date).value);
  SRwriteln('exe order: ' + inttostr(exeorder));

  TT := refMeristem.GetTAttribute('TT').GetSample(date).value;
  TT_PI_Attribute := refMeristem.GetTAttribute('TT_PI');
  Sample := TT_PI_Attribute.GetSample(date);
  Sample.value := TT;
  TT_PI_Attribute.SetSample(Sample);
  SRwriteln('TT_PI : ' + floattostr(Sample.value));

  pos := 1;

  instanceName := instance.GetName();
  Delete(instanceName, 1, 2);

  name := 'Ped' + instanceName;
  leafLength := FindLeafOnSameRankLength(instance, intToStr(internodeNumber));
  leafWidth := FindLeafOnSameRankWidth(instance, intToStr(internodeNumber));
  MGR := refMeristem.GetTAttribute('MGR').GetSample(date).value;
  plasto := refMeristem.GetTAttribute('plasto').GetSample(date).value;
  Tb := refMeristem.GetTAttribute('Tb').GetSample(date).value;
  resp_LER := refMeristem.GetTAttribute('resp_LER').GetSample(date).value;
  resp_INER := resp_LER;
  LIN1 := refMeristem.GetTAttribute('LIN1').GetSample(date).value;
  IN_A := refMeristem.GetTAttribute('IN_A').GetSample(date).value;
  IN_B := refMeristem.GetTAttribute('IN_B').GetSample(date).value;
  density_IN := refMeristem.GetTAttribute('density_IN').GetSample(date).value;
  MaximumReserveInInternode := refMeristem.GetTAttribute('maximumReserveInInternode').GetSample(date).value;
  stock_mainstem := refMeristem.GetTAttribute('stock_mainstem').GetSample(date).value;

  leaf_width_to_IN_diameter := refMeristem.GetTAttribute('leaf_width_to_IN_diameter').GetSample(date).value;
  leaf_length_to_IN_length := refMeristem.GetTAttribute('leaf_length_to_IN_length').GetSample(date).value;


  // on crée le premier entre noeud

  SRwriteln('****  creation du pedoncule : ' + name + '  ****');

  newInternode := ImportPeduncle_LE(name, MGR, plasto, Tb, resp_INER, LIN1, IN_A, IN_B, density_IN, leaf_width_to_IN_diameter, leaf_length_to_IN_length, leafLength, MaximumReserveInInternode, 0, 0, pos, 1);
  newInterNode.SetExeOrder(exeOrder);
  newInterNode.SetStartDate(date);
  newInterNode.InitCreationDate(date);
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

procedure TillerManagerPhytomerPeduncleCreation(var instance : TEntityInstance; const date : TDateTime; const IsFirstDayOfPI : Boolean = False; const plantStock : Double = 0);
var
  sumOfTillerLeafBiomass, SumOfPlantBiomass : Double;
  sample : TSample;
  exeOrder, pos : Integer;
  internodeNumber : Integer;
  rank : Double;
  name, instanceName : String;
  TT : Double;
  TT_PI_Attribute : TAttribute;
  attributeTmp : TAttribute;
  refMeristem : TEntityInstance;
  newInternode : TEntityInstance;
  MGR, plasto, Tb, resp_LER, resp_INER, LIN1, IN_A, IN_B, density_IN : Double;
  MaximumReserveInInternode, stock_mainstem : Double;
  leaf_width_to_IN_diameter, leaf_length_to_IN_length : Double;
  leafLength, leafWidth : Double;
  previousInternodePredimName, currentInternodePredimName : String;
  sampleTmp : TSample;

  i : integer;

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

  pos := 1;

  instanceName := instance.GetName();
  Delete(instanceName, 1, 2);

  name := 'Ped' + instanceName;

  // on crée le premier entre noeud

  SRwriteln('****  creation du pedoncule : ' + name + '  ****');

  newInternode := ImportPeduncle_LE(name, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
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


// ----------------------------------------------------------------------------
//  fonction TillerManager_LE
//  ------------------------
//
/// gere le comportement d'une talle
///
/// description : TODO
///
///
/// @param instance instance d'entité portant le manageur
/// @param date date actuelle de simulation  (par défaut, MIN_DATE)
/// @param state état actuel de l'instance portant le manageur (par défaut, 0)
/// @return nouvelle etat
// ---------------------------------------------------------------------------

function TillerManager_LE(var instance : TEntityInstance; const date : TDateTime = 0 ; const state : Integer = 0) : Integer;
const
  INITIATION = 1;
  REALIZATION = 2;
  FERTILECAPACITY = 3;
  PI = 4;
  PRE_PI = 5;
  PRE_FLO = 6;
  FLO = 7;
  DEAD = 1000;
var
  newState : Integer;
  boolCrossedPlasto, plantStock : Double;
  isFirstDayOfPi : Integer;
  phenoStageAtPI : Double;
  nb_leaf_max_after_PI : Double;
  currentPhenoStage : Double;
  TTAtPI : Double;
  TT : Double;
  TT_PI_To_Flo : Double;
  refInstance : TInstance;
  
begin
  case state of
    // ETAT INITIATION :
    // -----------------
    INITIATION :
      begin
        // creation d'une premiere feuille
        TillerManagerLeafCreation(instance, date, true, false);
        // nouvelle état
        newState := REALIZATION;
      end;

    // ETAT REALISATION :
    // ----------------
    REALIZATION :
      begin
        // initiation d'une nouvelle feuille a chaque nouveau plasto
        boolCrossedPlasto := instance.GetTAttribute('boolCrossedPlasto').GetSample(date).value;
        plantStock := instance.GetTAttribute('plantStock').GetSample(date).value;
        if ((boolCrossedPlasto>=0) and (plantStock >=0)) then // New plastochron et stock disponible
        begin
          TillerManagerLeafCreation(instance, date, false, false);
        end;
        // pas de changement d etat
        newState := state;
      end;

    // Etat en attente de la fertilité
    // -------------------------------
    FERTILECAPACITY :
      begin
        // initiation d'une nouvelle feuille a chaque nouveau plasto
        boolCrossedPlasto := instance.GetTAttribute('boolCrossedPlasto').GetSample(date).value;
        plantStock := instance.GetTAttribute('plantStock').GetSample(date).value;
        if ((boolCrossedPlasto>=0) and (plantStock >=0)) then // New plastochron et stock disponible
        begin
          // creation d'une nouvelle feuille
          // -------------------------------
          TillerManagerLeafCreation(instance, date, false, false);
      end;
      // pas de changement d etat
      newState := state;
    end;
  PRE_PI :
    begin
      // initiation d'une nouvelle feuille a chaque nouveau plasto
      boolCrossedPlasto := instance.GetTAttribute('boolCrossedPlasto').GetSample(date).value;
      plantStock := instance.GetTAttribute('plantStock').GetSample(date).value;
      if ((boolCrossedPlasto>=0) and (plantStock >=0)) then // New plastochron et stock disponible
      begin
        // creation d'une nouvelle feuille
        // -------------------------------
        TillerManagerLeafCreation(instance, date, false, false);
      end;
      // pas de changement d etat
      newState := state;
    end;
  PI :
    begin

      refInstance := (instance as TEntityInstance).GetFather();
      nb_leaf_max_after_PI := (refInstance as TEntityInstance).GetTAttribute('nb_leaf_max_after_PI').GetSample(date).value;

      boolCrossedPlasto := instance.GetTAttribute('boolCrossedPlasto').GetSample(date).value;
      plantStock := instance.GetTAttribute('plantStock').GetSample(date).value;
      isFirstDayOfPi := Trunc(instance.GetTAttribute('isFirstDayOfPi').GetSample(date).value);
      phenoStageAtPI := instance.GetTAttribute('phenoStageAtPI').GetSample(date).value;
      currentPhenoStage := instance.GetTAttribute('phenoStage').GetSample(date).value;

      if (plantStock >= 0) then
      begin
        if (boolCrossedPlasto >= 0) then
        begin
          SRwriteln('currentPhenoStage    --> ' + FloatToStr(currentPhenoStage));
          SRwriteln('phenoStageAtPI       --> ' + FloatToStr(phenostageAtPI));
          SRwriteln('nb_leaf_max_after_PI --> ' + FloatToStr(nb_leaf_max_after_PI));
          if (currentPhenoStage <= phenoStageAtPI + nb_leaf_max_after_PI) then
          begin
            if (isFirstDayOfPI = 1) then
            begin
              TillerManagerLeafCreation(instance, date, false, true);
              TillerManagerInternodeCreation(instance, date, true, plantStock);
              TillerManagerPanicleCreation(instance, date);
              newState := PI;
            end
            else
            begin
              TillerManagerLeafCreation(instance, date, false, true);
              TillerManagerInternodeCreation(instance, date, false, plantStock);
              newState := PI;
            end;
          end
          else
          begin
            newState := PI;
          end;
          if (currentPhenoStage = (phenoStageAtPI + nb_leaf_max_after_PI) + 1) then
          begin
            TillerManagerInternodeCreation(instance, date, false, plantStock);
            newState := PI;
          end
          else
          begin
            newState := PI          
          end;
          if (currentPhenoStage = (phenoStageAtPI + nb_leaf_max_after_PI) + 2) then
          begin
            TillerManagerPeduncleCreation(instance, date, false, plantStock);
            newState := PRE_FLO;
          end
          else
          begin
            newState := PI;
          end;
        end
        else
        begin
          newState := PI;
        end;
      end
      else
      begin
        newState := PI;
      end;


      // ------------------------
      // pas de changement d'etat
      // ------------------------
    end;
  PRE_FLO :
    begin
      TTAtPI := instance.GetTAttribute('TTAtPI').GetSample(date).value;
      refInstance := (instance as TEntityInstance).GetFather();
      TT := (refInstance as TEntityInstance).GetTAttribute('TT').GetSample(date).value;
      TT_PI_To_Flo := (refInstance as TEntityInstance).GetTAttribute('TT_PI_To_Flo').GetSample(date).value;
      if ((TT - TTAtPI) >= TT_PI_To_Flo) then
      begin
        PanicleTransitionToFLO(instance);
        PeduncleTransitionToFLO(instance);
        newState := FLO;
      end
      else
      begin
        newState := PRE_FLO;
      end;
    end;
  FLO :
    begin
      newState := FLO;
    end;
  DEAD :
    begin
      newState := DEAD;
    end;
    // ETAT NON DEFINI :
    // ----------------
    else
    begin
      result := -1;
      exit;
    end;
  end;


  SRwriteln('Tiller Manager, transition de : ' + inttostr(state) + ' --> ' + inttostr(newState));

  // retourne le nouvel état
  result := newState;
end;

procedure TillerManagerCreateFirstLeaf(var instance : TEntityInstance; const date : TDateTime = 0);
var
  name : String;
  refMeristem, newLeaf : TEntityInstance;
  exeOrder, pos : Integer;
  Lef1, MGR, plasto, ligulo, WLR, LL_BL, LL_BL_New, allo_area, G_L, Tb, resp_LER, coeffLifespan, mu : Double;
  phenoStageAtPI, currentPhenoStage, slope_LL_BL_at_PI : Double;
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
  plasto := refMeristem.GetTAttribute('plasto_init').GetSample(date).value;
  ligulo := refMeristem.GetTAttribute('ligulo1').GetSample(date).value;
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

  SRwriteln('****  creation de la feuille : ' + name + '  ****');

  slope_LL_BL_at_PI := refMeristem.GetTAttribute('slope_LL_BL_at_PI').GetSample(date).value;
  if (currentPhenoStage > phenoStageAtPi) then
    LL_BL_New := LL_BL + slope_LL_BL_at_PI * (currentPhenoStage - phenoStageAtPI)
  else
    LL_BL_New := LL_BL;

  newLeaf := ImportLeaf_LE(name, Lef1, MGR, plasto, ligulo, WLR, LL_BL_New, allo_area, G_L, Tb, resp_LER, coeffLifespan, mu, pos, 0);

  sample := newLeaf.GetTAttribute('rank').GetSample(date);
  sample.value := 1;
  newLeaf.GetTAttribute('rank').SetSample(sample);

  // determination de l'ordre d'execution de newLeaf :
  // recherche de la premiere place vide apres la premiere entité de type 'Leaf'
  newLeaf.SetExeOrder(exeOrder);
  newLeaf.SetStartDate(date);
  newLeaf.InitCreationDate(date);
  newLeaf.InitNextDate();
  instance.AddTInstance(newLeaf);

  // connection port <-> attribut pour newLeaf
  attributeTmp := TAttributeTmp.Create('predim_L1');
  instance.AddTAttribute(attributeTmp);

  newLeaf.ExternalConnect(['zero',
                           'predimLeafOnMainstem',
                           'predim_L1',
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
                           'lig',
                           'P']);
  instance.SortTInstance();
end;

procedure TillerManagerCreateFirstIN(var instance : TEntityInstance; const date : TDateTime = 0);
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

  newInternode := ImportInternode_LE(name, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0);

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

procedure TillerManagerCreateFirstPhytomers(var instance : TEntityInstance; const date : TDateTime = 0);
begin
  TillerManagerCreateFirstIN(instance, date);
  TillerManagerCreateFirstLeaf(instance, date);
end;

procedure TillerManagerCreateOthersLeaf(var instance : TEntityInstance; const date : TDateTime = 0; const n : Integer = 0);
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

  newLeaf := ImportLeaf_LE(name, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

  // determination de l'ordre d'execution de newLeaf :
  // recherche de la premiere place vide apres la premiere entité de type 'Leaf'
  newLeaf.SetExeOrder(exeOrder);
  newLeaf.SetStartDate(MAX_DATE);
  newLeaf.InitCreationDate(MAX_DATE);
  newLeaf.InitNextDate();
  newLeaf.SetCurrentState(2000);
  instance.AddTInstance(newLeaf);

  previousLeafPredimName := 'predim_L' + FloatToStr(n);
  currentLeafPredimName := 'predim_L' + FloatToStr(n + 1);

  attributeTmp := TAttributeTmp.Create(currentLeafPredimName);
  instance.AddTAttribute(attributeTmp);

  newLeaf.ExternalConnect([previousLeafPredimName,
                           'predimLeafOnMainstem',
                           currentLeafPredimName,
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
                           'lig',
                           'P']);

  sample := instance.GetTAttribute('leafNb').GetCurrentSample();
  sample.value := sample.value+1;
  sample.date := date;
  instance.GetTAttribute('leafNb').SetSample(sample);
  instance.SortTInstance();
end;

procedure TillerManagerCreateOthersIN(var instance : TEntityInstance; const date : TDateTime = 0; const n : Integer = 0);
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

  newInternode := ImportInternode_LE(name, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0);

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

procedure TillerManagerCreateOthersPhytomers(var instance : TEntityInstance; const date : TDateTime = 0; const n : Integer = 0);
begin
  TillerManagerCreateOthersIN(instance, date, n);
  TillerManagerCreateOthersLeaf(instance, date, n);
end;

function TillerManagerPhytomer_LE(var instance : TEntityInstance; const date : TDateTime = 0 ; const state : Integer = 0) : Integer;
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
  boolCrossedPlasto, plantStock : Double;
  isFirstDayOfPi : Integer;
  phenoStageAtPI : Double;
  nb_leaf_max_after_PI : Double;
  currentPhenoStage : Double;
  TTAtPI : Double;
  TT : Double;
  TT_PI_To_Flo : Double;
  refInstance : TInstance;
  i : Integer;
  nameOfLastLigulatedLeafOnTiller : String;
  fatherState : Integer;
  sample : TSample;
  phenoStageAtPreFlo, phenostage_PRE_FLO_to_FLO, phenostage : Double;
begin
  case state of
    // ETAT INITIATION :
    // -----------------
    INITIATION :
      begin
        oldStateStr := 'INITIATION';
        refInstance := (instance as TEntityInstance).GetFather();
        nb_leaf_max_after_PI := (refInstance as TEntityInstance).GetTAttribute('nb_leaf_max_after_PI').GetSample(date).value;
        // creation du premier phytomere
        TillerManagerCreateFirstPhytomers(instance, date);

        for i := 1 to Trunc(nb_leaf_max_after_PI) do
        begin
          TillerManagerCreateOthersPhytomers (instance, date, i);
        end;
        // nouvel état
        fatherState := (refInstance as TEntityInstance).GetCurrentState();
        if (fatherState = 9) then
        begin
          newState := PRE_ELONG;
          newStateStr := 'PRE_ELONG';
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
          TillerManagerPhytomerInternodeCreation(instance, date, false, plantStock);
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
          TillerManagerPhytomerInternodeCreation(instance, date, false, plantStock);
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
        plantStock := instance.GetTAttribute('plantStock').GetSample(date).value;
        SRwriteln('boolCrossedPlasto --> ' + FloatToStr(boolCrossedPlasto));
        SRwriteln('plantStock        --> ' + FloatToStr(plantStock));
        if ((boolCrossedPlasto >= 0) and (plantStock > 0)) then // New plastochron et stock disponible
        begin
          // creation d'une nouvelle feuille
          // -------------------------------
          SRwriteln('TillerManagerPhytomerInternodeCreation');
          TillerManagerPhytomerInternodeCreation(instance, date, false, plantStock);
          SRwriteln('TillerManagerPhytomerLeafCreation');
          TillerManagerPhytomerLeafCreation(instance, date, false, false);
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
        SRwriteln('boolCrossedPlasto --> ' + FloatToStr(boolCrossedPlasto));
        SRwriteln('plantstock --> ' + FloatToStr(plantStock));
        SRwriteln('plantState --> ' + FloatToStr(plantState));
        SRwriteln('currentPhenoStage    --> ' + FloatToStr(currentPhenoStage));
        SRwriteln('phenoStageAtPI       --> ' + FloatToStr(phenostageAtPI));
        SRwriteln('nb_leaf_max_after_PI --> ' + FloatToStr(nb_leaf_max_after_PI));
        //if (plantStock > 0) then
        if (plantState = 4) or (plantState = 6) or (plantState = 5) then
        begin
          if (boolCrossedPlasto >= 0) then
          begin
            SRwriteln('currentPhenoStage    --> ' + FloatToStr(currentPhenoStage));
            SRwriteln('phenoStageAtPI       --> ' + FloatToStr(phenostageAtPI));
            SRwriteln('nb_leaf_max_after_PI --> ' + FloatToStr(nb_leaf_max_after_PI));
            if (currentPhenoStage <= phenoStageAtPI + nb_leaf_max_after_PI) then
            begin
              if (isFirstDayOfPI = 1) then
              begin
                SRwriteln('First day of PI on tiller');
                TillerManagerPhytomerInternodeCreation(instance, date, false, plantStock);
                TillerManagerPhytomerLeafCreation(instance, date, false, false);
                TillerManagerStartInternodeElongation(instance, date, Trunc(currentPhenoStage));
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
                SRwriteln('pas first day of pi');
                SRwriteln('TillerManagerPhytomerLeafActivation');
                TillerManagerPhytomerLeafActivation(instance, date);
                SRwriteln('TillerManagerStartInternodeElongation');
                TillerManagerStartInternodeElongation(instance, date, Trunc(currentPhenoStage));
                newState := PI;
                newStateStr := 'PI';
              end;
            end
            else
            begin
              if (currentPhenoStage = (phenoStageAtPI + nb_leaf_max_after_PI + 1)) then
              begin
                SRwriteln('currentPhenoStage = (phenoStageAtPI + nb_leaf_max_after_PI + 1)');
                SRwriteln('--- Appel de TillerManagerStartInternodeElongation ---');
                TillerManagerStartInternodeElongation(instance, date, Trunc(currentPhenoStage));
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
        end
        else
        begin
          newState := PI;
          newStateStr := 'PI';
        end;


        // ------------------------
        // pas de changement d'etat
        // ------------------------
      end;
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
          plantStock := instance.GetTAttribute('plantStock').GetSample(date).value;
          currentPhenoStage := instance.GetTAttribute('phenoStage').GetSample(date).value;
          if ((boolCrossedPlasto >= 0) and (plantStock > 0)) then // New plastochron et stock disponible
          begin
            TillerManagerPhytomerInternodeCreation(instance, date, false, plantStock);
            SRwriteln('Internode creation');
            TillerManagerPhytomerLeafCreation(instance, date, false, false);
            SRwriteln('Leaf creation');
            TillerManagerStartInternodeElongation(instance, date, Trunc(currentPhenoStage));
            SRwriteln('Internode elongation');
          end;
          newState := ELONG;
          newStateStr := 'ELONG';
        end;
      end;

      PRE_ELONG :
        begin
          oldStateStr := 'PRE_ELONG';
          nameOfLastLigulatedLeafOnTiller := FindLastLigulatedLeafNumberOnCulm(instance);
          if (nameOfLastLigulatedLeafOnTiller = '') then
          begin
            SRwriteln('Pas de feuille ligulee sur la talle, on reste en PRE_ELONG');
            newState := PRE_ELONG;
            newStateStr := 'PRE_ELONG';
          end
          else
          begin
            boolCrossedPlasto := instance.GetTAttribute('boolCrossedPlasto').GetSample(date).value;
            plantStock := instance.GetTAttribute('plantStock').GetSample(date).value;
            currentPhenoStage := instance.GetTAttribute('phenoStage').GetSample(date).value;
            if ((boolCrossedPlasto >= 0) and (plantStock > 0)) then // New plastochron et stock disponible
            begin
              SRwriteln('Une feuille ligulee sur la talle et changement de plastochron et stock positif, on passe en ELONG');
              TillerManagerPhytomerInternodeCreation(instance, date, false, plantStock);
              SRwriteln('Internode creation');
              TillerManagerPhytomerLeafCreation(instance, date, false, false);
              SRwriteln('Leaf creation');
              TillerManagerStartInternodeElongation(instance, date, Trunc(currentPhenoStage));
              SRwriteln('Internode elongation');
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

procedure MeristemManagerLeafCreation(var instance : TEntityInstance; const date : TDateTime = 0; const n : Double = 0; const LL_BL_MODIFIED : Boolean = False);
var
  name : String;
  Lef1, MGR, plasto, ligulo, WLR, LL_BL, allo_area : Double;
  G_L, Tb, resp_LER, nbleaf_pi, LL_BL_New, slope_LL_BL_at_PI, coeffLifespan, mu : Double;
  exeOrder : Integer;
  newLeaf : TEntityInstance;
  attributeTmp : TAttribute;
  refAttribute : TAttribute;
  refPort : TPort;
  previousLeafPredimName, currentLeafPredimName : String;

begin
  // creation d'une nouvelle feuille
  // -------------------------------
  //
  name := 'L' + FloatToStr(n);
  Lef1 := instance.GetTAttribute('Lef1').GetSample(date).value;
  MGR := instance.GetTAttribute('MGR').GetSample(date).value;
  plasto := instance.GetTAttribute('plasto').GetSample(date).value;
  ligulo := instance.GetTAttribute('ligulo').GetSample(date).value;
  WLR := instance.GetTAttribute('WLR').GetSample(date).value;
  LL_BL := instance.GetTAttribute('LL_BL').GetSample(date).value;
  allo_area := instance.GetTAttribute('allo_area').GetSample(date).value;
  G_L := instance.GetTAttribute('G_L').GetSample(date).value;
  Tb := instance.GetTAttribute('Tb').GetSample(date).value;
  resp_LER := instance.GetTAttribute('resp_LER').GetSample(date).value;
  coeffLifespan := instance.GetTAttribute('coeff_lifespan').GetSample(date).value;
  mu := instance.GetTAttribute('mu').GetSample(date).value;


  slope_LL_BL_at_PI := instance.GetTAttribute('slope_LL_BL_at_PI').GetSample(date).value;
  nbleaf_pi := instance.GetTAttribute('nbleaf_pi').GetSample(date).value;
  if LL_BL_MODIFIED then
    LL_BL_New := LL_BL + slope_LL_BL_at_PI * (n - nbleaf_pi)
  else
    LL_BL_New := LL_BL;

  SRwriteln('LL_BL_New --> ' + FloatToStr(LL_BL_New));
  SRwriteln('****  creation de la feuille : ' + name + '  ****');
  newLeaf := ImportLeaf_LE(name, Lef1, MGR, plasto, ligulo, WLR, LL_BL_New, allo_area, G_L, Tb, resp_LER, coeffLifespan, mu, 0, 1);

  // determination de l'ordre d'execution de newLeaf :
  // recherche de la premiere place vide apres la premiere entité de type 'Leaf'
  exeOrder := FindFirstEmptyPlaceAfterASpecifiedCategory(instance,'Leaf');

  newLeaf.SetExeOrder(exeOrder);
  newLeaf.SetStartDate(date);
  newLeaf.InitCreationDate(date);
  newLeaf.InitNextDate();
  instance.AddTInstance(newLeaf);

  // connection port <-> attribut pour newLeaf
  previousLeafPredimName := 'predim_L' + FloatToStr(n-1);
  currentLeafPredimName := 'predim_L' + FloatToStr(n);

  attributeTmp := TAttributeTmp.Create(currentLeafPredimName);
  instance.AddTAttribute(attributeTmp);

  newLeaf.ExternalConnect([previousLeafPredimName,
                           previousLeafPredimName,
                           currentLeafPredimName,
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
                           'lig',
                           'P']);
  instance.SortTInstance();

  // deconnecte le port 'predimOfCurrentLeaf' de la feuille L(n-2) avec
  // l'attribut 'predimOfNewLeaf' et realise une connectique
  // port 'predimOfCurrentLeaf' de feuille L(n-1) <-> attribut 'predimOfNewLeaf'
  // TODO -u Model : ce qui a ci-dessous risque de crasher lorsque trop de destruction de feuille...
  if(n>=3) then
  begin
    if (instance.GetTInstance('L' + FloatToStr(n-2)) <> nil) then
    begin
      refPort := instance.GetTInstance('L' + FloatToStr(n-2)).GetTPort('predimOfCurrentLeaf');
      refPort.ExternalUnconnect(1);
    end;

    refAttribute := instance.GetTAttribute('predimOfNewLeaf');
    instance.GetTInstance('L' + FloatToStr(n-1)).GetTPort('predimOfCurrentLeaf').ExternalConnect(refAttribute);
  end;
end;

procedure MeristemManagerPhytomerPanicleActivation(var instance : TEntityInstance);
var
  entityPanicle : TEntityInstance;
begin
  entityPanicle := FindPanicle(instance);
  entityPanicle.SetCurrentState(1);
  SRwriteln('La panicule : ' + entityPanicle.GetName() + ' est activee');
end;

procedure MeristemManagerPhytomerPeduncleActivation(var instance : TEntityInstance; const date : TDateTime);
var
  entityPeduncle, entityInternode : TEntityInstance;
  internodeNumber, name : String;
  leafLength, leafWidth, MGR, plasto, ligulo, Tb, resp_LER, resp_INER, LIN1, IN_A : Double;
  IN_B, density_IN, MaximumReserveInInternode, stock_mainstem, leaf_width_to_IN_diameter : Double;
  leaf_length_to_IN_length, n, ratioINPed, peduncleDiam : Double;
  sample : TSample;
begin
  entityPeduncle := FindPeduncle(instance);

  internodeNumber := FindLastLigulatedLeafNumberOnCulm(instance);

  SRwriteln('Last ligulated leaf : ' + internodeNumber);

  name := 'IN' + internodeNumber;

  entityInternode := FindInternodeAtRank(instance, internodeNumber);

  leafLength := FindLeafOnSameRankLength(instance, internodeNumber);
  leafWidth := FindLeafOnSameRankWidth(instance, internodeNumber);
  MGR := instance.GetTAttribute('MGR').GetSample(date).value;
  plasto := instance.GetTAttribute('plasto').GetSample(date).value;
  ligulo := instance.GetTAttribute('ligulo').GetSample(date).value;
  Tb := instance.GetTAttribute('Tb').GetSample(date).value;
  resp_LER := instance.GetTAttribute('resp_LER').GetSample(date).value;
  resp_INER := resp_LER;
  LIN1 := instance.GetTAttribute('LIN1').GetSample(date).value;
  IN_A := instance.GetTAttribute('IN_A').GetSample(date).value;
  IN_B := instance.GetTAttribute('IN_B').GetSample(date).value;
  density_IN := instance.GetTAttribute('density_IN').GetSample(date).value;
  MaximumReserveInInternode := instance.GetTAttribute('maximumReserveInInternode').GetSample(date).value;
  stock_mainstem := instance.GetTAttribute('stock_mainstem').GetSample(date).value;
  leaf_width_to_IN_diameter := instance.GetTAttribute('leaf_width_to_IN_diameter').GetSample(date).value;
  leaf_length_to_IN_length := instance.GetTAttribute('leaf_length_to_IN_length').GetSample(date).value;
  n := instance.GetTAttribute('n').GetSample(date).value;
  ratioINPed := instance.GetTAttribute('ratio_INPed').GetSample(date).value;
  peduncleDiam := instance.GetTAttribute('peduncle_diam').GetSample(date).value;

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
  sample.value := stock_mainstem;
  entityPeduncle.GetTAttribute('stock_culm').SetSample(sample);

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

procedure MeristemManagerPhytomerLeafActivation(var instance : TEntityInstance; const date : TDateTime = 0; const n : Double = 0);
var
  entityLeaf : TEntityInstance;
  Lef1, MGR, plasto, ligulo, WLR, LL_BL, allo_area, G_L, Tb, resp_LER, coeffLifespan, mu : Double;
  sample : TSample;
begin
  entityLeaf := FindLeafAtRank(instance, FloatToStr(n));
  SRwriteln('La feuille : ' + entityLeaf.GetName() + ' est activée');

  Lef1 := instance.GetTAttribute('Lef1').GetSample(date).value;
  MGR := instance.GetTAttribute('MGR').GetSample(date).value;
  plasto := instance.GetTAttribute('plasto').GetSample(date).value;
  ligulo := instance.GetTAttribute('ligulo').GetSample(date).value;
  WLR := instance.GetTAttribute('WLR').GetSample(date).value;
  LL_BL := instance.GetTAttribute('LL_BL').GetSample(date).value;
  allo_area := instance.GetTAttribute('allo_area').GetSample(date).value;
  G_L := instance.GetTAttribute('G_L').GetSample(date).value;
  Tb := instance.GetTAttribute('Tb').GetSample(date).value;
  resp_LER := instance.GetTAttribute('resp_LER').GetSample(date).value;
  coeffLifespan := instance.GetTAttribute('coeff_lifespan').GetSample(date).value;
  mu := instance.GetTAttribute('mu').GetSample(date).value;

  sample := entityLeaf.GetTAttribute('Lef1').GetSample(date);
  sample.value := Lef1;
  entityLeaf.GetTAttribute('Lef1').SetSample(sample);
  sample := entityLeaf.GetTAttribute('rank').GetSample(date);
  sample.value := n;
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

  entityLeaf.SetCurrentState(1);

  entityLeaf.SetStartDate(date);
  entityLeaf.InitCreationDate(date);
  entityLeaf.InitNextDate();


end;

procedure MeristemManagerPhytomerLeafCreation(var instance : TEntityInstance; const date : TDateTime = 0; const n : Double = 0; const LL_BL_MODIFIED : Boolean = False);
var
  name : String;
  Lef1, MGR, plasto, ligulo, WLR, LL_BL, allo_area : Double;
  G_L, Tb, resp_LER, nbleaf_pi, LL_BL_New, slope_LL_BL_at_PI : Double;
  nb_leaf_max_after_PI : Double;
  exeOrder : Integer;
  newLeaf : TEntityInstance;
  entityLeaf : TEntityInstance;
  attributeTmp : TAttribute;
  refAttribute : TAttribute;
  sample : TSample;
  refPort : TPort;
  previousLeafPredimName, currentLeafPredimName : String;

begin

  MeristemManagerPhytomerLeafActivation(instance, date, n);

  nb_leaf_max_after_PI := instance.GetTAttribute('nb_leaf_max_after_PI').GetSample(date).value;
  name := 'L' + FloatToStr(n + nb_leaf_max_after_PI);
  SRwriteln('nb_leaf_max_after_PI : ' + floattostr(nb_leaf_max_after_PI));

  SRwriteln('****  creation de la feuille : ' + name + '  ****');
  newLeaf := ImportLeaf_LE(name, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1);

  // determination de l'ordre d'execution de newLeaf :
  exeOrder := Trunc(instance.GetTAttribute('exeOrderOfFirstPhytomer').GetSample(date).value + (2 * (n + nb_leaf_max_after_PI)) - 1);
  SRwriteln('exeOrder : ' + floattostr(exeorder));

  newLeaf.SetExeOrder(exeOrder);
  newLeaf.SetStartDate(MAX_DATE);
  newLeaf.InitCreationDate(MAX_DATE);
  newLeaf.InitNextDate();
  newLeaf.SetCurrentState(2000);
  instance.AddTInstance(newLeaf);

  // connection port <-> attribut pour newLeaf
  previousLeafPredimName := 'predim_L' + FloatToStr((n + nb_leaf_max_after_PI) - 1);
  currentLeafPredimName := 'predim_L' + FloatToStr(n + nb_leaf_max_after_PI);

  attributeTmp := TAttributeTmp.Create(currentLeafPredimName);
  instance.AddTAttribute(attributeTmp);

  newLeaf.ExternalConnect([previousLeafPredimName,
                           previousLeafPredimName,
                           currentLeafPredimName,
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
                           'lig',
                           'P']);
  instance.SortTInstance();

  // deconnecte le port 'predimOfCurrentLeaf' de la feuille L(n-2) avec
  // l'attribut 'predimOfNewLeaf' et realise une connectique
  // port 'predimOfCurrentLeaf' de feuille L(n-1) <-> attribut 'predimOfNewLeaf'
  // TODO -u Model : ce qui a ci-dessous risque de crasher lorsque trop de destruction de feuille...
  if(n>=3) then
  begin
    if (instance.GetTInstance('L' + FloatToStr(n-2)) <> nil) then
    begin
      refPort := instance.GetTInstance('L' + FloatToStr(n-2)).GetTPort('predimOfCurrentLeaf');
      refPort.ExternalUnconnect(1);
    end;

    refAttribute := instance.GetTAttribute('predimOfNewLeaf');
    instance.GetTInstance('L' + FloatToStr(n-1)).GetTPort('predimOfCurrentLeaf').ExternalConnect(refAttribute);
  end;
end;

procedure MeristemManagerInternodeCreation(var instance : TEntityInstance; const date : TDateTime = 0; isFirstInternode : Boolean = True; const n : Double = 0; const stock : Double = 0);
var
  name : String;
  previousInternodePredimName : String;
  currentInternodePredimName : String;
  internodeNumber : Integer;
  MGR, plasto, Tb, resp_LER, resp_INER, LIN1, IN_A, IN_B, density_IN : Double;
  MaximumReserveInInternode : Double;
  TT, coef_plasto_PI, SumOfBiomassLeafMainstem, SumOfPlantBiomass : Double;

  leaf_width_to_IN_diameter, leaf_length_to_IN_length : Double;
  leafLength, leafWidth : Double;

  TT_PI_Attribute : TAttribute;
  Plasto_Attribute : TAttribute;
  StockMainstem_Attribute : TAttribute;
  refAttribute : TAttribute;
  newInternode : TEntityInstance;
  Sample : TSample;
  exeOrder : Integer;
  stock_mainstem : Double;
  pos : Double;

  ligulo : Double;

  attributeTmp : TAttribute;
  sampleTmp : TSample;
  refPort : TPort;

begin
  if isFirstInternode then
  begin
    /////////////////////////////////////
    // On crée le 1er entrenoeud
    /////////////////////////////////////

    /////////////////////////////////////////////////////////
    // On récupère la valeur de TT et on la stocke dans TT_PI
    /////////////////////////////////////////////////////////

    TT := instance.GetTAttribute('TT').GetSample(date).value;
    SRwriteln('TT : ' + floattostr(TT));

    TT_PI_Attribute := instance.GetTAttribute('TT_PI');
    Sample := TT_PI_Attribute.GetSample(date);
    Sample.value := TT;

    TT_PI_Attribute.SetSample(Sample);
    SRwriteln('TT_PI : ' + floattostr(Sample.value));

    SumOfBiomassLeafMainstem := instance.GetTAttribute('sumOfMainstemLeafBiomass').GetSample(date).value;
    SumOfPlantBiomass := instance.GetTAttribute('sumOfLeafBiomass').GetSample(date).value;
    StockMainstem_Attribute := instance.GetTAttribute('stock_mainstem');

    SRwriteln('sumOfMainstemLeafBiomass --> ' + FloatToStr(SumOfBiomassLeafMainstem));
    SRwriteln('sumOfLeafBiomass         --> ' + FloatToStr(SumOfPlantBiomass));
    SRwriteln('stock                    --> ' + FloatToStr(stock));
    SRwriteln('stock_mainstem           --> ' + FloatToStr((SumOfBiomassLeafMainstem / SumOfPlantBiomass) * stock));

    Sample := StockMainstem_Attribute.GetSample(date);
    Sample.value := (SumOfBiomassLeafMainstem / SumOfPlantBiomass) * stock;

    StockMainstem_Attribute.SetSample(Sample);
    // on récupère la valeur de la position de la première entité entrenoeud
    exeOrder := Trunc(instance.GetTAttribute('exeOrderOfFirstInternode').GetSample(date).value);
    pos := 1;

  end
  else
  begin
    exeOrder := FindFirstEmptyPlaceAfterASpecifiedCategory(instance,'Internode');
    pos := 0;
  end;

  internodeNumber := StrToInt(FindLastLigulatedLeafNumberOnCulm(instance));
  name := 'IN' + IntToStr(internodeNumber);
  leafLength := FindLeafOnSameRankLength(instance, IntToStr(internodeNumber));
  leafWidth := FindLeafOnSameRankWidth(instance, IntToStr(internodeNumber));
  MGR := instance.GetTAttribute('MGR').GetSample(date).value;
  plasto := instance.GetTAttribute('plasto').GetSample(date).value;
  ligulo := instance.GetTAttribute('ligulo').GetSample(date).value;
  Tb := instance.GetTAttribute('Tb').GetSample(date).value;
  resp_LER := instance.GetTAttribute('resp_LER').GetSample(date).value;
  resp_INER := resp_LER;
  LIN1 := instance.GetTAttribute('LIN1').GetSample(date).value;
  IN_A := instance.GetTAttribute('IN_A').GetSample(date).value;
  IN_B := instance.GetTAttribute('IN_B').GetSample(date).value;
  density_IN := instance.GetTAttribute('density_IN').GetSample(date).value;
  MaximumReserveInInternode := instance.GetTAttribute('maximumReserveInInternode').GetSample(date).value;
  stock_mainstem := instance.GetTAttribute('stock_mainstem').GetSample(date).value;
  leaf_width_to_IN_diameter := instance.GetTAttribute('leaf_width_to_IN_diameter').GetSample(date).value;
  leaf_length_to_IN_length := instance.GetTAttribute('leaf_length_to_IN_length').GetSample(date).value;


  // on crée le premier entre noeud

  SRwriteln('****  creation de l''entrenoeud : ' + name + '  ****');

  newInternode := ImportInternode_LE(name, MGR, plasto, Tb, resp_INER, LIN1, IN_A, IN_B, density_IN, leaf_width_to_IN_diameter, leaf_length_to_IN_length, leafLength, leafWidth, MaximumReserveInInternode, pos, 1);

  //showmessage(inttostr(exeorder));

  newInterNode.SetExeOrder(exeOrder);
  newInterNode.SetStartDate(date);
  newInterNode.InitCreationDate(date);
  newInterNode.InitNextDate();

  instance.AddTInstance(newInternode);

  newInterNode.ExternalConnect(['DD',
                                'EDD',
                                'testIc',
                                'fcstr',
                                'n',
                                'stock_mainstem',
                                'Tair',
                                'plasto_delay',
                                'thresINER',
                                'slopeINER',
                                'FTSW',
                                'P']);
  instance.SortTInstance();
end;

procedure MeristemManagerPhytomerInternodeCreation(var instance : TEntityInstance; const date : TDateTime = 0; isFirstInternode : Boolean = True; const n : Double = 0; const stock : Double = 0);
var
  name : String;
  newInternode : TEntityInstance;
  nb_leaf_max_after_PI : Double;
  exeOrder : Integer;
  sample : TSample;
begin

  nb_leaf_max_after_PI := instance.GetTAttribute('nb_leaf_max_after_PI').GetSample(date).value;

  exeOrder := Trunc(instance.GetTAttribute('exeOrderOfFirstPhytomer').GetSample(date).value + (2 * (n + nb_leaf_max_after_PI - 1)));

  name := 'IN' + FloatToStr(n + nb_leaf_max_after_PI);

  SRwriteln('****  creation de l''entrenoeud : ' + name + '  ****');

  newInternode := ImportInternode_LE(name, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1);

  sample.date := date;
  sample.value := n + nb_leaf_max_after_PI;
  newInternode.GetTAttribute('rank').SetSample(sample);

  //showmessage(inttostr(exeorder));

  newInterNode.SetExeOrder(exeOrder);
  newInterNode.SetStartDate(date);
  newInterNode.InitCreationDate(date);
  newInternode.SetCurrentState(2000);
  newInterNode.InitNextDate();

  instance.AddTInstance(newInternode);

  newInterNode.ExternalConnect(['DD',
                                'EDD',
                                'testIc',
                                'fcstr',
                                'n',
                                'stock_mainstem',
                                'Tair',
                                'plasto_delay',
                                'thresINER',
                                'slopeINER',
                                'FTSW',
                                'P']);
  instance.SortTInstance();
end;

procedure MeristemManagerPhytomerPeduncleCreation(var instance : TEntityInstance; const date : TDateTime = 0; isFirstInternode : Boolean = True; const n : Double = 0; const stock : Double = 0);
var
  name : String;
  previousInternodePredimName : String;
  currentInternodePredimName : String;
  internodeNumber : Integer;
  MGR, plasto, Tb, resp_LER, resp_INER, LIN1, IN_A, IN_B, density_IN : Double;
  MaximumReserveInInternode : Double;
  TT, coef_plasto_PI, SumOfBiomassLeafMainstem, SumOfPlantBiomass : Double;

  leaf_width_to_IN_diameter, leaf_length_to_IN_length : Double;
  leafLength, leafWidth : Double;

  TT_PI_Attribute : TAttribute;
  Plasto_Attribute : TAttribute;
  StockMainstem_Attribute : TAttribute;
  refAttribute : TAttribute;
  newPeduncle : TEntityInstance;
  Sample : TSample;
  exeOrder : Integer;
  stock_mainstem : Double;
  pos : Double;

  ligulo : Double;

  attributeTmp : TAttribute;
  sampleTmp : TSample;
  refPort : TPort;

begin

  // on récupère la valeur de la position de la première entité entrenoeud
  exeOrder := Trunc(instance.GetTAttribute('exeOrderOfPeduncle').GetSample(date).value);
  name := 'Ped0';
  SRwriteln('exeOrderOfPeduncle' + FloatToStr(exeOrder));


  // on crée le premier entre noeud

  SRwriteln('****  creation du pedoncule : ' + name + '  ****');

  newPeduncle := ImportPeduncle_LE(name, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);

  newPeduncle.SetExeOrder(exeOrder);
  newPeduncle.SetStartDate(date);
  newPeduncle.InitCreationDate(date);
  newPeduncle.InitNextDate();
  newPeduncle.SetCurrentState(2000);

  instance.AddTInstance(newPeduncle);

  newPeduncle.ExternalConnect(['DD',
                                'EDD',
                                'testIc',
                                'fcstr',
                                'n',
                                'stock_mainstem',
                                'Tair',
                                'plasto_delay',
                                'thresINER',
                                'slopeINER',
                                'FTSW',
                                'P']);
  instance.SortTInstance();
end;


procedure MeristemManagerPeduncleCreation(var instance : TEntityInstance; const date : TDateTime = 0; isFirstInternode : Boolean = True; const n : Double = 0; const stock : Double = 0);
var
  name : String;
  previousInternodePredimName : String;
  currentInternodePredimName : String;
  internodeNumber : Integer;
  MGR, plasto, Tb, resp_LER, resp_INER, LIN1, IN_A, IN_B, density_IN : Double;
  MaximumReserveInInternode : Double;
  TT, coef_plasto_PI, SumOfBiomassLeafMainstem, SumOfPlantBiomass : Double;

  leaf_width_to_IN_diameter, leaf_length_to_IN_length : Double;
  leafLength, leafWidth : Double;

  TT_PI_Attribute : TAttribute;
  Plasto_Attribute : TAttribute;
  StockMainstem_Attribute : TAttribute;
  refAttribute : TAttribute;
  newPeduncle : TEntityInstance;
  Sample : TSample;
  exeOrder : Integer;
  stock_mainstem : Double;
  pos : Double;

  ligulo : Double;

  attributeTmp : TAttribute;
  sampleTmp : TSample;
  refPort : TPort;

begin

  // on récupère la valeur de la position de la première entité entrenoeud
  exeOrder := Trunc(instance.GetTAttribute('exeOrderOfPeduncle').GetSample(date).value);
  pos := 1;

  internodeNumber := StrToInt(FindLastLigulatedLeafNumberOnCulm(instance)) + 1;
  name := 'Ped0';
  leafLength := FindLeafOnSameRankLength(instance, IntToStr(internodeNumber - 1));
  leafWidth := FindLeafOnSameRankWidth(instance, IntToStr(internodeNumber - 1));
  MGR := instance.GetTAttribute('MGR').GetSample(date).value;
  plasto := instance.GetTAttribute('plasto').GetSample(date).value;
  ligulo := instance.GetTAttribute('ligulo').GetSample(date).value;
  Tb := instance.GetTAttribute('Tb').GetSample(date).value;
  resp_LER := instance.GetTAttribute('resp_LER').GetSample(date).value;
  resp_INER := resp_LER;
  LIN1 := instance.GetTAttribute('LIN1').GetSample(date).value;
  IN_A := instance.GetTAttribute('IN_A').GetSample(date).value;
  IN_B := instance.GetTAttribute('IN_B').GetSample(date).value;
  density_IN := instance.GetTAttribute('density_IN').GetSample(date).value;
  MaximumReserveInInternode := instance.GetTAttribute('maximumReserveInInternode').GetSample(date).value;
  stock_mainstem := instance.GetTAttribute('stock_mainstem').GetSample(date).value;
  leaf_width_to_IN_diameter := instance.GetTAttribute('leaf_width_to_IN_diameter').GetSample(date).value;
  leaf_length_to_IN_length := instance.GetTAttribute('leaf_length_to_IN_length').GetSample(date).value;

  SRwriteln('exeOrderOfPeduncle' + FloatToStr(exeOrder));


  // on crée le premier entre noeud

  SRwriteln('****  creation du pedoncule : ' + name + '  ****');

  newPeduncle := ImportPeduncle_LE(name, MGR, plasto, Tb, resp_INER, LIN1, IN_A, IN_B, density_IN, stock_mainstem, leaf_width_to_IN_diameter, leaf_length_to_IN_length, leafLength, MaximumReserveInInternode, 0, 0, pos, 1);

  //showmessage(inttostr(exeorder));

  newPeduncle.SetExeOrder(exeOrder);
  newPeduncle.SetStartDate(date);
  newPeduncle.InitCreationDate(date);
  newPeduncle.InitNextDate();

  instance.AddTInstance(newPeduncle);

  newPeduncle.ExternalConnect(['DD',
                                'EDD',
                                'testIc',
                                'fcstr',
                                'n',
                                'stock',
                                'Tair',
                                'plasto_delay',
                                'thresINER',
                                'slopeINER',
                                'FTSW',
                                'P']);
  instance.SortTInstance();
end;

procedure MeristemManagerPhytomerPanicleCreation(var instance : TEntityInstance; const date : TDateTime = 0);
var
  name : String;
  spike_creation_rate, grain_filling_rate, Tb : Double;
  gdw_empty, grain_per_cm_on_panicle, gdw, n : Double;
  exeOrder : Integer;
  newPanicle : TEntityInstance;
begin
  spike_creation_rate := instance.GetTAttribute('spike_creation_rate').GetSample(date).value;
  grain_filling_rate := instance.GetTAttribute('grain_filling_rate').GetSample(date).value;
  gdw_empty := instance.GetTAttribute('gdw_empty').GetSample(date).value;
  gdw := instance.GetTAttribute('gdw').GetSample(date).value;
  gdw_empty := gdw_empty * gdw;
  grain_per_cm_on_panicle := instance.GetTAttribute('grain_per_cm_on_panicle').GetSample(date).value;
  exeOrder := Trunc(instance.GetTAttribute('exeOrderOfPanicle').GetSample(date).value);
  n := Trunc(instance.GetTAttribute('n').GetSample(date).value);
  Tb := instance.GetTAttribute('Tb').GetSample(date).value;


  SRwriteln('exeOrderOfPanicle : ' + IntToStr(exeOrder));

  name := 'Pan0';

  SRwriteln('****  creation de la panicule : ' + name + '  ****');

  newPanicle := ImportPanicle_LE(name, spike_creation_rate, grain_filling_rate, grain_per_cm_on_panicle, gdw_empty, gdw, Tb, n, 1);

  newPanicle.SetExeOrder(exeOrder);
  newPanicle.SetStartDate(date);
  newPanicle.InitCreationDate(date);
  newPanicle.InitNextDate();
  newPanicle.SetCurrentState(2000);

  instance.AddTInstance(newPanicle);

  newPanicle.ExternalConnect(['DD',
                              'EDD',
                              'testIc',
                              'fcstr',
                              'n',
                              'Tair',
                              'plasto_delay',
                              'thresLER',
                              'slopeLER',
                              'FTSW',
                              'P']);


  instance.SortTInstance();
end;


procedure MeristemManagerPanicleCreation(var instance : TEntityInstance; const date : TDateTime = 0);
var
  name : String;
  spike_creation_rate, grain_filling_rate, Tb : Double;
  gdw_empty, grain_per_cm_on_panicle, gdw, n : Double;
  exeOrder : Integer;
  newPanicle : TEntityInstance;
begin
  spike_creation_rate := instance.GetTAttribute('spike_creation_rate').GetSample(date).value;
  grain_filling_rate := instance.GetTAttribute('grain_filling_rate').GetSample(date).value;
  gdw_empty := instance.GetTAttribute('gdw_empty').GetSample(date).value;
  gdw := instance.GetTAttribute('gdw').GetSample(date).value;
  gdw_empty := gdw_empty * gdw;
  grain_per_cm_on_panicle := instance.GetTAttribute('grain_per_cm_on_panicle').GetSample(date).value;
  exeOrder := Trunc(instance.GetTAttribute('exeOrderOfPanicle').GetSample(date).value);
  n := Trunc(instance.GetTAttribute('n').GetSample(date).value);
  Tb := instance.GetTAttribute('Tb').GetSample(date).value;


  SRwriteln('exeOrderOfPanicle : ' + IntToStr(exeOrder));

  name := 'Pan0';

  SRwriteln('****  creation de la panicule : ' + name + '  ****');

  newPanicle := ImportPanicle_LE(name, spike_creation_rate, grain_filling_rate, grain_per_cm_on_panicle, gdw_empty, gdw, Tb, n, 1);

  newPanicle.SetExeOrder(exeOrder);
  newPanicle.SetStartDate(date);
  newPanicle.InitCreationDate(date);
  newPanicle.InitNextDate();

  instance.AddTInstance(newPanicle);

  newPanicle.ExternalConnect(['DD',
                              'EDD',
                              'testIc',
                              'fcstr',
                              'n',
                              'Tair',
                              'plasto_delay',
                              'thresLER',
                              'slopeLER',
                              'FTSW',
                              'P']);


  instance.SortTInstance();
end;



procedure TillerManagerPanicleCreation(var instance : TEntityInstance; const date : TDateTime = 0);
var
  instanceName : String;
  name : String;
  spike_creation_rate, grain_filling_rate : Double;
  gdw_empty, gdw, grain_per_cm_on_panicle, Tb : Double;
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


  SRwriteln('****  creation de la panicule : ' + name + '  ****');

  newPanicle := ImportPanicle_LE(name, spike_creation_rate, grain_filling_rate, grain_per_cm_on_panicle, gdw_empty, gdw, Tb, phenoStage, 0);

  newPanicle.SetExeOrder(exeOrder);
  newPanicle.SetStartDate(date);
  newPanicle.InitCreationDate(date);
  newPanicle.InitNextDate();

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

procedure TillerManagerPhytomerPanicleActivation(var instance : TEntityInstance);
var
  entityPanicle : TEntityInstance;
begin
  entityPanicle := FindPanicle(instance);
  entityPanicle.SetCurrentState(1);
  SRwriteln('La panicule : ' + entityPanicle.GetName() + ' est activee');
end;

procedure TillerManagerPhytomerPeduncleActivation(var instance : TEntityInstance; const date : TDateTime);
var
  entityPeduncle, entityInternode, refMeristem : TEntityInstance;
  internodeNumber, name : string;
  leafLength, leafWidth, MGR, plasto, Tb, resp_LER, resp_INER, LIN1 : Double;
  IN_A, IN_B, density_IN, MaximumReserveInInternode, stock_mainstem : Double;
  leaf_width_to_IN_diameter, leaf_length_to_IN_length, ligulo, n : Double;
  ratioINPed, peduncleDiam : Double;
  sample : TSample;
begin
  entityPeduncle := FindPeduncle(instance);

  refMeristem := instance.GetFather() as TEntityInstance;

  internodeNumber := FindLastLigulatedLeafNumberOnCulm(instance);

  SRwriteln('Last ligulated leaf : ' + internodeNumber);

  name := 'IN' + internodeNumber;

  entityInternode := FindInternodeAtRank(instance, internodeNumber);


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
  stock_mainstem := refMeristem.GetTAttribute('stock_mainstem').GetSample(date).value;
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
  sample.value := stock_mainstem;
  entityPeduncle.GetTAttribute('stock_culm').SetSample(sample);

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


  SRwriteln('****  creation de la panicule : ' + name + '  ****');

  newPanicle := ImportPanicle_LE(name, spike_creation_rate, grain_filling_rate, grain_per_cm_on_panicle, gdw_empty, gdw, Tb, phenoStage, 0);

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


// -----------------------------------------------------------------------------
// procedure SetAllActiveStateToValue
// ----------------------------------
//
// permet de faire passer toutes les TProcInstance à une valeur donnée
// par exemple dans le cas où la plante meurt.
//
// -----------------------------------------------------------------------------

procedure SetAllActiveStateToValue(instance : TEntityInstance; value : Integer);
var
	tmp : Double;
  currentInstance : TInstance;
  manager : TManager;
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

// -----------------------------------------------------------------------------
//  fonction MeristemManagerUpdatePlasto
// -------------------------------------
//
// lorsque l'on passe à PI, on change plasto qui devient :
//    plasto = plasto * coef_plasto_PI
//
// cette valeur doit être changée pour toutes les entités, c'est pourquoi cette
// procedure est séparée de la création des feuilles et des entrenoeuds
//
// -----------------------------------------------------------------------------

procedure MeristemManagerUpdatePlasto(var instance : TEntityInstance);
var
  coef_plasto_PI : Double;
  Plasto_Attribute : TAttribute;
  Sample : TSample;
begin
  coef_plasto_PI := instance.GetTAttribute('coef_plasto_PI').GetSample(date).value;
  Plasto_Attribute := instance.GetTAttribute('plasto');
  Sample := Plasto_Attribute.GetSample(date);
  Sample.value := Sample.value * coef_plasto_PI;
  Plasto_Attribute.SetSample(Sample);
end;

// ----------------------------------------------------------------------------
//  fonction MeristemManager_LE
//  ----------------------------
//
/// gere le comportement du méristem
///
/// description :
/// - Au premier pas de simulation (état initial) :
///     - initialisation de certaine feuille
///     - TODO
///     - passage a l'etat 3 si stock>=0
///     - passage a l etat 4 si stock<0
///
/// - etat 2 = comportement lorsque stock>=0 :
///     - TODO
///
/// - etat 3 = comportement lorsque stock<0 :
///     - TODO
///
///
/// @param instance instance d'entité portant le manageur
/// @param date date actuelle de simulation  (par défaut, MIN_DATE)
/// @param state état actuel de l'instance portant le manageur (par défaut, 0)
/// @return nouvel etat
// ---------------------------------------------------------------------------

function MeristemManager_LE(var instance : TEntityInstance; const date : TDateTime = 0 ; const state : Integer = 0) : Integer;
const
  INITIAL = 1;
  LEAFMORPHOGENESIS = 2;
  NOGROWTH = 3;
  PI = 4;
  FLO = 5;
  PRE_FLO = 6;
  NOGROWTH_PI = 7;
  NOGROWTH_FLO = 8;
  DEAD = 1000;
var
   newState : Integer;
   stock : Double;
   boolCrossedPlasto,n : Double;
   nbleaf_pi : Double;
   nb_leaf_max_after_PI : Double;
   coeff_flo_lag : Double;
   TT_PI_To_Flo, TT_PI, TT : Double;
   FTSW : double;
   Ic : double;
   total : double;

begin

  stock := instance.GetTAttribute('stock').GetSample(date).value;
  nbleaf_pi := instance.GetTAttribute('nbleaf_pi').GetSample(date).value;
  n := instance.GetTAttribute('n').GetSample(date).value;
  boolCrossedPlasto := instance.GetTAttribute('boolCrossedPlasto').GetSample(date).value;
  nb_leaf_max_after_PI := instance.GetTAttribute('nb_leaf_max_after_PI').GetSample(date).value;
  coeff_flo_lag := instance.GetTAttribute('coeff_flo_lag').GetSample(date).value;
  FTSW := instance.GetTAttribute('FTSW').GetSample(date).value;
  Ic := instance.GetTAttribute('Ic').GetSample(date).value;
  TT_PI_To_Flo := instance.GetTAttribute('TT_PI_To_Flo').GetSample(date).value;
  TT_PI := instance.GetTAttribute('TT_PI').GetSample(date).value;
  TT := instance.GetTAttribute('TT').GetSample(date).value;

  case state of
    INITIAL :
    begin
      if (stock > 0) and (n < nbleaf_pi) then
        newState := LEAFMORPHOGENESIS
      else
        newState := NOGROWTH;
    end;

    LEAFMORPHOGENESIS :
    begin
    	if (FTSW <= 0) or (Ic = -1) then
      begin
      	newState := DEAD;
        SetAllActiveStateToValue(instance, DEAD);
      end
      else
      begin
	      if (stock <= 0) then
	        newState := NOGROWTH
	      else
	      begin
	        if (boolCrossedPlasto < 0) then
	          newState := LEAFMORPHOGENESIS
	        else
	        begin
            if (n = nbleaf_pi) then
            begin
              MeristemManagerUpdatePlasto(instance);
              MeristemManagerLeafCreation(instance, date, n, false);
              MeristemManagerInternodeCreation(instance, date, true, n , stock);
              MeristemManagerPanicleCreation(instance, date);
              TillersTransitionToPre_PI_LE(instance);
              RootTransitionToPI(instance);
              newState := PI;
            end
            else
            begin
              MeristemManagerLeafCreation(instance, date, n, false);
              newState := LEAFMORPHOGENESIS;
            end;
	        end;
	      end;
	    end;
    end;

    NOGROWTH :
    begin
    	if (FTSW <= 0) or (Ic = -1) then
      begin
      	newState := DEAD;
        SetAllActiveStateToValue(instance, DEAD);
      end
      else
      begin
	      if (stock > 0) then
	      begin
	        if (n < nbleaf_pi) then
	        begin
	          if (boolCrossedPlasto >= 0) then
	          begin
	            MeristemManagerLeafCreation(instance, date, n, false);
	          end;
	          newState := LEAFMORPHOGENESIS;
	        end
	        else
	        begin
	          if (boolCrossedPlasto >= 0) then
	          begin
              MeristemManagerUpdatePlasto(instance);
              MeristemManagerLeafCreation(instance, date, n, false);
              MeristemManagerInternodeCreation(instance, date, true, n , stock);
              MeristemManagerPanicleCreation(instance, date);
              TillersTransitionToPre_PI_LE(instance);
              RootTransitionToPI(instance);
              newState := PI;              
	          end;
	        end;
	      end
	      else
	      begin
	        newState := NOGROWTH;
	      end;
	    end;
    end;

    PI :
    begin
      if (stock <= 0) then
      begin
        newState := NOGROWTH_PI;
      end
      else
      begin
        if (boolCrossedPlasto >= 0) then
        begin
          if (n <= nbleaf_pi + nb_leaf_max_after_PI) then
          begin
            SRwriteln('n <= nbleaf_pi + nb_leaf_max_after_PI');
            MeristemManagerLeafCreation(instance, date, n, true);
            MeristemManagerInternodeCreation(instance, date, false, n , stock);
            newState := PI;
          end;
          if (n = (nbleaf_pi + nb_leaf_max_after_PI + 1)) then
          begin
            SRwriteln('n = (nbleaf_pi + nb_leaf_max_after_PI + 1)');
            MeristemManagerInternodeCreation(instance, date, false, n , stock);
            newState := PI;
          end;
          if (n = (nbleaf_pi + nb_leaf_max_after_PI + 2)) then
          begin
            SRwriteln('n = (nbleaf_pi + nb_leaf_max_after_PI + 2)');
            MeristemManagerPeduncleCreation(instance, date, false, n , stock);
            RootTransitionToFLO(instance);
            newState := PRE_FLO;
          end;
        end
        else
        begin
          newState := PI;
        end;
      end;
    end;

    NOGROWTH_PI:
    begin
      if (stock <= 0) then
      begin
        newState := NOGROWTH_PI;
      end
      else
      begin
        if (boolCrossedPlasto >= 0) then
        begin
          if (n <= nbleaf_pi + nb_leaf_max_after_PI) then
          begin
            MeristemManagerLeafCreation(instance, date, n, true);
            MeristemManagerInternodeCreation(instance, date, false, n , stock);
            newState := PI;
          end;
          if (n = (nbleaf_pi + nb_leaf_max_after_PI + 1)) then
          begin
            MeristemManagerInternodeCreation(instance, date, false, n , stock);
            newState := PI;
          end;
          if (n = (nbleaf_pi + nb_leaf_max_after_PI + 2)) then
          begin
            MeristemManagerPeduncleCreation(instance, date, false, n , stock);
            newState := PRE_FLO;
          end;
        end
      end;
    end;

    PRE_FLO :
    begin
      if ((TT - TT_PI) >= TT_PI_To_Flo) then
      begin
        PanicleTransitionToFLO(instance);
        PeduncleTransitionToFLO(instance);
        newState := FLO;
      end
      else
      begin
        newState := PRE_FLO;
      end;
    end;

    NOGROWTH_FLO:
    begin
      newState := NOGROWTH_FLO;
    end;

    FLO :
    begin
      if (stock <= 0) then
      begin
        newstate := NOGROWTH_FLO;
      end;
    end;
    DEAD:
    begin
    	newState := DEAD;
    end;

  end;

  SRwriteln('n        --> ' + FLoatToStr(n));
  SRwriteln('nbleafpi --> ' + FloatToStr(nbleaf_pi));
  SRwriteln('nbleafpi + nbleafmaxafterpi --> ' + FloatToStr(nbleaf_pi + nb_leaf_max_after_PI));
  SRwriteln('Meristem Manager, transition de : ' + inttostr(state) + ' --> ' + inttostr(newState));

  result := newState;
end;

procedure MeristemManagerStartInternodeElongation(var instance : TEntityInstance; const date : TDateTime = 0; const n : Integer = 0; const IsFirstInternode : Boolean = False);
var
  entityInternode : TEntityInstance;
  internodeNumber : String;
  name : String;
  leafLength, leafWidth, MGR, plasto, ligulo, Tb, resp_LER, resp_INER, LIN1, IN_A, IN_B : Double;
  density_IN, MaximumReserveInInternode, stock_mainstem, leaf_width_to_IN_diameter : Double;
  stock, SumOfBiomassLeafMainstem, SumOfPlantBiomass : Double;
  leaf_length_to_IN_length, slope_length_IN, IN_length_to_IN_diam, coef_lin_IN_diam : Double;
  sample : TSample;
  StockMainstem_Attribute : TAttribute;
begin
  if IsFirstInternode then
  begin
    stock := instance.GetTAttribute('stock').GetSample(date).value;
    SumOfBiomassLeafMainstem := instance.GetTAttribute('sumOfMainstemLeafBiomass').GetSample(date).value;
    SumOfPlantBiomass := instance.GetTAttribute('sumOfLeafBiomass').GetSample(date).value;
    StockMainstem_Attribute := instance.GetTAttribute('stock_mainstem');

    SRwriteln('sumOfMainstemLeafBiomass --> ' + FloatToStr(SumOfBiomassLeafMainstem));
    SRwriteln('sumOfLeafBiomass         --> ' + FloatToStr(SumOfPlantBiomass));
    SRwriteln('stock                    --> ' + FloatToStr(stock));
    SRwriteln('stock_mainstem           --> ' + FloatToStr((SumOfBiomassLeafMainstem / SumOfPlantBiomass) * stock));

    Sample := StockMainstem_Attribute.GetSample(date);
    Sample.value := (SumOfBiomassLeafMainstem / SumOfPlantBiomass) * stock;

    StockMainstem_Attribute.SetSample(Sample);
  end;
  internodeNumber := IntToStr(StrToInt(FindLastLigulatedLeafNumberOnCulm(instance)) + 1);
  name := 'IN' + internodeNumber;

  entityInternode := FindInternodeAtRank(instance, internodeNumber);

  SRwriteln('L''entrenoeud : ' + entityInternode.GetName() + ' commence de s''allonger');

  leafLength := FindLeafOnSameRankLength(instance, internodeNumber);
  leafWidth := FindLeafOnSameRankWidth(instance, internodeNumber);
  MGR := instance.GetTAttribute('MGR').GetSample(date).value;
  plasto := instance.GetTAttribute('plasto').GetSample(date).value;
  ligulo := instance.GetTAttribute('ligulo').GetSample(date).value;
  Tb := instance.GetTAttribute('Tb').GetSample(date).value;
  resp_LER := instance.GetTAttribute('resp_LER').GetSample(date).value;
  resp_INER := resp_LER;
  LIN1 := instance.GetTAttribute('LIN1').GetSample(date).value;
  IN_A := instance.GetTAttribute('IN_A').GetSample(date).value;
  IN_B := instance.GetTAttribute('IN_B').GetSample(date).value;
  density_IN := instance.GetTAttribute('density_IN').GetSample(date).value;
  MaximumReserveInInternode := instance.GetTAttribute('maximumReserveInInternode').GetSample(date).value;
  stock_mainstem := instance.GetTAttribute('stock_mainstem').GetSample(date).value;
  leaf_width_to_IN_diameter := instance.GetTAttribute('leaf_width_to_IN_diameter').GetSample(date).value;
  leaf_length_to_IN_length := instance.GetTAttribute('leaf_length_to_IN_length').GetSample(date).value;
  slope_length_IN := instance.GetTAttribute('slope_length_IN').GetSample(date).value;
  IN_length_to_IN_diam := instance.GetTAttribute('IN_length_to_IN_diam').GetSample(date).value;
  coef_lin_IN_diam := instance.GetTAttribute('coef_lin_IN_diam').GetSample(date).value;

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
  sample.value := stock_mainstem;
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

procedure TillerManagerStartInternodeElongation(var instance : TEntityInstance; const date : TDateTime = 0; const n : Integer = 0);
var
  entityInternode, refMeristem : TEntityInstance;
  internodeNumber : String;
  name : String;
  leafLength, leafWidth, MGR, plasto, ligulo, Tb, resp_LER, resp_INER, LIN1, IN_A, IN_B : Double;
  density_IN, MaximumReserveInInternode, stock_tiller, leaf_width_to_IN_diameter : Double;
  stock, SumOfBiomassLeafMainstem, SumOfPlantBiomass, activeLeavesNb : Double;
  leaf_length_to_IN_length, slope_length_IN : Double;
  IN_length_to_IN_diam, coef_lin_IN_diam : Double;
  sample : TSample;
  StockMainstem_Attribute : TAttribute;
begin
  refMeristem := (instance.GetFather() as TEntityInstance);
  activeLeavesNb := instance.GetTAttribute('activeLeavesNb').GetSample(date).value;
  internodeNumber := FindLastLigulatedLeafNumberOnCulm(instance);
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

function MeristemManagerPhytomers_LE(var instance : TEntityInstance; const date : TDateTime = 0 ; const state : Integer = 0) : Integer;
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
   stock : Double;
   boolCrossedPlasto,n : Double;
   nbleaf_pi : Double;
   nb_leaf_max_after_PI : Double;
   coeff_flo_lag : Double;
   TT_PI_To_Flo, TT_PI, TT, phenostageAtPre_Flo, phenostage_PRE_FLO_to_FLO : Double;
   FTSW : double;
   Ic : double;
   total : double;
   nb_leaf_stem_elong, nb_leaf_param2, phenostage_to_end_filling, phenostage_to_maturity : Double;
   newStateStr, oldStateStr : string;

begin
  stock := instance.GetTAttribute('stock').GetSample(date).value;
  nbleaf_pi := instance.GetTAttribute('nbleaf_pi').GetSample(date).value;
  n := instance.GetTAttribute('n').GetSample(date).value;
  boolCrossedPlasto := instance.GetTAttribute('boolCrossedPlasto').GetSample(date).value;
  nb_leaf_max_after_PI := instance.GetTAttribute('nb_leaf_max_after_PI').GetSample(date).value;
  coeff_flo_lag := instance.GetTAttribute('coeff_flo_lag').GetSample(date).value;
  FTSW := instance.GetTAttribute('FTSW').GetSample(date).value;
  Ic := instance.GetTAttribute('Ic').GetSample(date).value;
  TT_PI_To_Flo := instance.GetTAttribute('TT_PI_To_Flo').GetSample(date).value;
  TT_PI := instance.GetTAttribute('TT_PI').GetSample(date).value;
  TT := instance.GetTAttribute('TT').GetSample(date).value;
  nb_leaf_stem_elong := instance.GetTAttribute('nb_leaf_stem_elong').GetSample(date).value;
  nb_leaf_param2 := instance.GetTAttribute('nb_leaf_param2').GetSample(date).value;
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
              MeristemManagerPhytomerLeafCreation(instance, date, n, false);
              MeristemManagerPhytomerInternodeCreation(instance, date, true, n , stock);
              TillersStockIndividualization(instance, date);
              MeristemManagerStartInternodeElongation(instance, date, Trunc(n), true);
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
                MeristemManagerPhytomerLeafCreation(instance, date, n, false);
                MeristemManagerPhytomerInternodeCreation(instance, date, true, n , stock);
                TillersStockIndividualization(instance, date);
                MeristemManagerStartInternodeElongation(instance, date, Trunc(n), true);
                MeristemManagerPhytomerPanicleCreation(instance, date);
                MeristemManagerPhytomerPeduncleCreation(instance, date);
                MeristemManagerPhytomerPanicleActivation(instance);
                TillersTransitionToPre_PI_LE(instance);
                StoreThermalTimeAtPI(instance, date);
                RootTransitionToPI(instance);
                newState := PI;
                newStateStr := 'PI';
              end
              else
              begin
                MeristemManagerPhytomerLeafCreation(instance, date, n, false);
                MeristemManagerPhytomerInternodeCreation(instance, date, true, n , stock);
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
	          if (boolCrossedPlasto >= 0) then
	          begin
	            MeristemManagerPhytomerLeafCreation(instance, date, n, false);
              MeristemManagerPhytomerInternodeCreation(instance, date, true, n , stock);
	          end;
	          newState := LEAFMORPHOGENESIS;
            newStateStr := 'LEAFMORPHOGENESIS';
	        end
	        else
	        begin
            if ((n = Trunc(nb_leaf_stem_elong)) and (n < nbleaf_pi) and (Trunc(nb_leaf_stem_elong) < nbleaf_pi)) then
            begin
              if (boolCrossedPlasto >= 0) then
              begin
                MeristemManagerPhytomerLeafCreation(instance, date, n, false);
                MeristemManagerPhytomerInternodeCreation(instance, date, true, n , stock);
                TillersStockIndividualization(instance, date);
                MeristemManagerStartInternodeElongation(instance, date, Trunc(n), true);
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
                  SRwriteln('On passe de NO_GROWTH à PI');
                  MeristemManagerPhytomerLeafCreation(instance, date, n, false);
                  MeristemManagerPhytomerInternodeCreation(instance, date, true, n , stock);
                  TillersStockIndividualization(instance, date);
                  MeristemManagerStartInternodeElongation(instance, date, Trunc(n), false);
                  MeristemManagerPhytomerPanicleCreation(instance, date);
                  MeristemManagerPhytomerPeduncleCreation(instance, date);
                  MeristemManagerPhytomerPanicleActivation(instance);
                  TillersTransitionToPre_PI_LE(instance);
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
      if (stock = 0) then
      begin
        newState := NOGROWTH_PI;
        newStateStr := 'NOGROWTH_PI';
      end
      else if (stock  >0) then
      begin
        if (boolCrossedPlasto >= 0) then
        begin
          if (n <= nbleaf_pi + nb_leaf_max_after_PI) then
          begin
            SRwriteln('n <= nbleaf_pi + nb_leaf_max_after_PI');
            MeristemManagerPhytomerLeafActivation(instance, date, n);
            MeristemManagerStartInternodeElongation(instance, date, Trunc(n), false);
            SRwriteln('activation feuille et entrenoeud n° : ' + floattostr(n - 1));
            newState := PI;
            newStateStr := 'PI';
          end;
          if (n = (nbleaf_pi + nb_leaf_max_after_PI + 1)) then
          begin
            SRwriteln('n = (nbleaf_pi + nb_leaf_max_after_PI + 1)');
            MeristemManagerStartInternodeElongation(instance, date, Trunc(n), false);
            SRwriteln('activation entrenoeud n° : ' + floattostr(n - 1));
            MeristemManagerPhytomerPeduncleActivation(instance, date);
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
      if (stock = 0) then
      begin
        newState := NOGROWTH_PI;
        newStateStr := 'NOGROWTH_PI';
      end
      else if (stock > 0) then
      begin
        if (boolCrossedPlasto >= 0) then
        begin
          if (n <= nbleaf_pi + nb_leaf_max_after_PI) then
          begin
            MeristemManagerPhytomerLeafActivation(instance, date, n);
            MeristemManagerStartInternodeElongation(instance, date, Trunc(n), false);
            newState := PI;
            newStateStr := 'PI';
          end;
          if (n = (nbleaf_pi + nb_leaf_max_after_PI + 1)) then
          begin
            MeristemManagerStartInternodeElongation(instance, date, Trunc(n), false);
            SRwriteln('activation entrenoeud n° : ' + floattostr(n));
            MeristemManagerPhytomerPeduncleActivation(instance, date);
            isFirstDayOfPRE_FLO := True;
            newState := PRE_FLO;
            newStateStr := 'PRE_FLO';
            StorePhenostageAtPre_Flo(instance, date, n);
          end;
        end;
      end;
    end;

    PRE_FLO :
    begin
      oldStateStr := 'PRE_FLO';
      if (stock = 0) then
      begin
        newState := NOGROWTH_PRE_FLO;
        newStateStr := 'NOGROWTH_PRE_FLO';
      end
      else if (stock > 0) then
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
      if (stock > 0) then
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
      else if (stock = 0) then
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
      if (stock > 0) then
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
      else if (stock = 0)then
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
      if (stock > 0) then
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
      else if (stock = 0)then
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
          newState := NOGROWTH_ELONG;
          newStateStr := 'NOGROWTH_ELONG';
        end
        else if (stock > 0) then
        begin
          if (boolCrossedPlasto >= 0) then
          begin
            if ((n >= nb_leaf_stem_elong) and (n < nbleaf_pi)) then
            begin
              MeristemManagerPhytomerLeafCreation(instance, date, n, false);
              MeristemManagerPhytomerInternodeCreation(instance, date, true, n , stock);
              MeristemManagerStartInternodeElongation(instance, date, Trunc(n), false);
              newState := ELONG;
              newStateStr := 'ELONG';
            end
            else
            begin
              if (n = nbleaf_pi) then
              begin
                MeristemManagerUpdatePlasto(instance);
                MeristemManagerPhytomerLeafCreation(instance, date, n, false);
                MeristemManagerPhytomerInternodeCreation(instance, date, true, n , stock);
                MeristemManagerStartInternodeElongation(instance, date, Trunc(n), false);
                MeristemManagerPhytomerPanicleCreation(instance, date);
                MeristemManagerPhytomerPeduncleCreation(instance, date);
                TillersTransitionToPre_PI_LE(instance);
                RootTransitionToPI(instance);
                newState := PI;
                newStateStr := 'PI';
              end;
            end;
          end;
        end;
      end;
    end;

    NOGROWTH_ELONG :
    begin
      oldStateStr := 'NOGROWTH_ELONG';
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
          if ((n >= nb_leaf_stem_elong) and (n < nbleaf_pi)) then
          begin
            if (boolCrossedPlasto >= 0) then
            begin
              MeristemManagerPhytomerLeafCreation(instance, date, n, false);
              MeristemManagerPhytomerInternodeCreation(instance, date, true, n , stock);
              MeristemManagerStartInternodeElongation(instance, date, Trunc(n), true);
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
                MeristemManagerUpdatePlasto(instance);
                MeristemManagerPhytomerLeafCreation(instance, date, n, false);
                MeristemManagerPhytomerInternodeCreation(instance, date, true, n , stock);
                TillersStockIndividualization(instance, date);
                MeristemManagerStartInternodeElongation(instance, date, Trunc(n), false);
                MeristemManagerPhytomerPanicleCreation(instance, date);
                MeristemManagerPhytomerPanicleActivation(instance);
                MeristemManagerPhytomerPeduncleCreation(instance, date);
                TillersTransitionToPre_PI_LE(instance);
                RootTransitionToPI(instance);
                newState := PI;
                newStateStr := 'PI';
              end;
            end;
          end;
	      end
	      else if (stock = 0) then
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
      if (stock = 0) then
      begin
        newState := NOGROWTH_ENDFILLING;
        newStateStr := 'NOGROWTH_ENDFILLING';
      end
      else if (stock > 0) then
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
      if (stock > 0) then
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
      if (stock = 0) then
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
      if (stock > 0) then
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

  SRwriteln('n                           --> ' + FLoatToStr(n));
  SRwriteln('nb_leaf_stem_elong          --> ' + FloatToStr(nb_leaf_stem_elong));
  SRwriteln('nbleafpi                    --> ' + FloatToStr(nbleaf_pi));
  SRwriteln('nbleafpi + nbleafmaxafterpi --> ' + FloatToStr(nbleaf_pi + nb_leaf_max_after_PI));
  SRwriteln('-------------------------------------------------------');
  SRwriteln('Meristem Manager Phytomers, transition de : ' + oldStateStr + ' --> ' + newStateStr);

  result := newState;
end;


// ----------------------------------------------------------------------------
//  fonction ThermalTimeManager_LE
//  ------------------------
//
/// gere le comportement de l entité thermal time
///
/// description : lorsqu'il y a du stock (etat 1), realise les calculs. Sinon
/// (etat 2) ne rien faire
///
///
/// @param instance instance d'entité portant le manageur
/// @param date date actuelle de simulation  (par défaut, MIN_DATE)
/// @param state état actuel de l'instance portant le manageur (par défaut, 0)
/// @return nouvelle etat
// ---------------------------------------------------------------------------

function ThermalTimeManager_LE(var instance : TEntityInstance; const date : TDateTime = 0 ; const state : Integer = 0) : Integer;
const
  STOCK_AVAILABLE = 2;
  NO_STOCK = 3;
  DEAD = 1000;
var
   newState : Integer;
   stock : Double;
begin

  if (state <> DEAD) then
  begin
    stock := instance.GetTAttribute('stock').GetSample(date).value;
    SRwriteln('stock --> ' + floattostr(stock));

    if (stock = 0) and (state = 1) then
    begin
      // PREMIER JOUR
      // ------------
      newState := STOCK_AVAILABLE
    end
    else if (stock > 0) then
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

procedure TillersTransitionToState(var instance : TEntityInstance; const state : Integer);
var
  le, i : Integer;
  currentInstance : TInstance;
  currentTEntityInstance : TEntityInstance;
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
      end;
    end;
  end;

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
        if (nameOfLastLigulatedLeafOnTiller = '') then
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
        plantStock := instance.GetTAttribute('stock').GetSample(date).value;
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

procedure TillersTransitionToPre_PI_LE(var instance : TEntityInstance);
begin
  TillersTransitionToState(instance, 5);
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
    //SRwriteln('last ligulated leaf name : ' + minName);
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
  end;
  Result := minName;
end;

function FindLeafOnSameRankWidth(var instance : TEntityInstance; rank : String) : Double;
var
  le, i : Integer;
  currentInstance : TInstance;
  currentEntityInstance : TEntityInstance;
  leafPredim, LL_BL, WLR, leafWidthPredim : Double;
  leafName : String;
  leafRank : String;
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
  leafRank : String;
begin
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

function FindPeduncle(var instance : TEntityInstance) : TEntityInstance;
var
  le, i : Integer;
  currentInstance : TInstance;
  currentEntityInstance : TEntityInstance;
  entityPeduncle : TEntityInstance;
begin
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

function FindPanicle(var instance : TEntityInstance) : TEntityInstance;
var
  le, i : Integer;
  currentInstance : TInstance;
  currentEntityInstance : TEntityInstance;
  entityPanicle : TEntityInstance;
begin
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
function FindLeafAtRank(var instance : TEntityInstance; rank : String) : TEntityInstance;
var
  le, i : Integer;
  currentInstance : TInstance;
  currentEntityInstance : TEntityInstance;
  entityLeaf : TEntityInstance;
  leafName : String;
  leafRank : String;
begin
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

function FindInternodeAtRank(var instance : TEntityInstance; rank : String) : TEntityInstance;
var
  le, i : Integer;
  currentInstance : TInstance;
  currentEntityInstance : TEntityInstance;
  entityInternode : TEntityInstance;
  internodeName : String;
begin
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

function PanicleManager_LE(var instance : TEntityInstance; const date : TDateTime = 0; const state : Integer = 0) : Integer;
const
  PI = 1;
  TRANSITION_TO_FLO = 2;
  FLO = 3;
  ENDFILLING = 12;
  VEGETATIVE = 2000;
var
  newState : Integer;
  oldStateStr, newStateStr : string;
begin
  case state of
    PI :
      begin
        oldStateStr := 'PI';
        newState := PI;
        newStateStr := 'PI';
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
        newState := FLO;
        newStateStr := 'FLO';
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
  end;
  SRwriteln('Panicle Manager, transition de : ' + oldStateStr + ' --> ' + newStateStr);
  Result := newState;
end;

function PeduncleManager_LE(var instance : TEntityInstance; const date : TDateTime = 0; const state : Integer = 0) : Integer;
const
  PREDIM = 1;
  TRANSITION = 10;
  REALIZATION = 2;
  MATURITY = 4;
  ENDFILLING = 12;
  UNKNOWN = -1;
  DEAD = 1000;
  FLO = 500;
  VEGETATIVE = 2000;
var
   newState : Integer;
   stockPeduncle : Double;
   newStateStr, oldStateStr : string;
begin
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
        newState := REALIZATION;
        newStateStr := 'REALIZATION';
      end;

    // ETAT LIGULE
    // -----------
    MATURITY :
      begin
        oldStateStr := 'MATURITY';
        newState := MATURITY;
        newStateStr := 'MATURITY';
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
        newState := FLO;
        newStateStr := 'FLO';
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

function EcoMeristemManager_LE(var instance : TEntityInstance; const date : TDateTime = 0 ; const state : Integer = 0) : Integer;
const
  INIT = 1;
  INACTIVE = 2;
var
  newState : Integer;
begin
  SRwriteln('**** EcoMeristemManager_LE --> Initial State = ' + FloatToStr(state) + ' ***');
  case state of
    INIT :
    begin
      CreateInitialPhytomers_LE(instance, date);
      newState := INACTIVE;
    end;
    INACTIVE :
    begin
      newState := INACTIVE;
    end;
  end;
  SRwriteln('**** EcoMeristemManager_LE --> New State = ' + FloatToStr(newState) + ' ***');
  result := newState;
end;

procedure EcoMeristemFirstLeafCreation(var instance : TEntityInstance; const date : TDateTime = 0);
var
  name : String;
  Lef1, MGR, plasto, ligulo, WLR, LL_BL, allo_area, coef_ligulo1, coeffLifespan, mu : Double;
  G_L, Tb, resp_LER : Double;
  exeOrder : Integer;
  newLeaf : TEntityInstance;
  refFather : TModel;
  refInstance : TInstance;
  refMeristem : TEntityInstance;
  attributeTmp : TAttribute;
  refAttribute : TAttribute;
  refPort : TPort;
  sample : TSample;
  previousLeafPredimName, currentLeafPredimName : String;
  le, i : Integer;

begin
  // creation d'une nouvelle feuille
  // -------------------------------
  //

  refFather := (instance.GetFather() as TModel);
  refMeristem := nil;

  le := refFather.LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    refInstance := refFather.GetTInstance(i);
    if (refInstance.GetName() = 'EntityMeristem') then
    begin
      refMeristem := (refInstance as TEntityInstance);
    end;
  end;

  if (refMeristem <> nil) then
  begin
    name := 'L1';
    Lef1 := refMeristem.GetTAttribute('Lef1').GetSample(date).value;
    MGR := refMeristem.GetTAttribute('MGR_init').GetSample(date).value;
    plasto := refMeristem.GetTAttribute('plasto_init').GetSample(date).value;
    //ligulo := refMeristem.GetTAttribute('ligulo1').GetSample(date).value;
    coef_ligulo1 := refMeristem.GetTAttribute('coef_ligulo1').GetSample(date).value;
    ligulo := coef_ligulo1 * plasto;
    refAttribute := refMeristem.GetTAttribute('ligulo1');
    sample := refAttribute.GetSample(date);
    sample.date := date;
    sample.value := ligulo;
    refAttribute.SetSample(sample);
    WLR := refMeristem.GetTAttribute('WLR').GetSample(date).value;
    LL_BL := refMeristem.GetTAttribute('LL_BL_init').GetSample(date).value;
    allo_area := refMeristem.GetTAttribute('allo_area').GetSample(date).value;
    G_L := refMeristem.GetTAttribute('G_L').GetSample(date).value;
    Tb := refMeristem.GetTAttribute('Tb').GetSample(date).value;
    resp_LER := refMeristem.GetTAttribute('resp_LER').GetSample(date).value;
    coeffLifespan := refMeristem.GetTAttribute('coeff_lifespan').GetSample(date).value;
    mu := refMeristem.GetTAttribute('mu').GetSample(date).value;

    SRwriteln('****  creation de la feuille : ' + name + '  ****');
    newLeaf := ImportLeaf_LE(name, Lef1, MGR, plasto, ligulo, WLR, LL_BL, allo_area, G_L, Tb, resp_LER, coeffLifespan, mu, 1, 1);

    sample := newLeaf.GetTAttribute('rank').GetSample(date);
    sample.value := 1;
    newLeaf.GetTAttribute('rank').SetSample(sample);

    // determination de l'ordre d'execution de newLeaf :
    // recherche de la premiere place vide apres la premiere entité de type 'Leaf'
    exeOrder := Trunc(refMeristem.GetTAttribute('exeOrderOfFirstPhytomer').GetSample(date).value) + 1;
    SRwriteln('exeOrder : ' + IntToStr(exeOrder));

    newLeaf.SetExeOrder(exeOrder);
    newLeaf.SetStartDate(date);
    newLeaf.InitCreationDate(date);
    newLeaf.InitNextDate();
    refMeristem.AddTInstance(newLeaf);

    // connection port <-> attribut pour newLeaf
    previousLeafPredimName := 'zero';
    currentLeafPredimName := 'predim_L1';

    attributeTmp := TAttributeTmp.Create(currentLeafPredimName);
    refMeristem.AddTAttribute(attributeTmp);

    newLeaf.ExternalConnect([previousLeafPredimName,
                             previousLeafPredimName,
                             currentLeafPredimName,
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
                             'lig',
                             'P']);
    refMeristem.SortTInstance();
  end;
end;

procedure EcoMeristemFirstINCreation(var instance : TEntityInstance; const date : TDateTime = 0);
var
  name : String;
  refFather : TModel;
  refInstance : TInstance;
  refMeristem, newInternode : TEntityInstance;
  le, i, exeOrder : Integer;
  sample : TSample;
begin

  refFather := (instance.GetFather() as TModel);
  refMeristem := nil;

  le := refFather.LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    refInstance := refFather.GetTInstance(i);
    if (refInstance.GetName() = 'EntityMeristem') then
    begin
      refMeristem := (refInstance as TEntityInstance);
    end;
  end;

  if (refMeristem <> nil) then
  begin
    exeOrder := Trunc(refMeristem.GetTAttribute('exeOrderOfFirstPhytomer').GetSample(date).value);
    name := 'IN1';

    // on crée le premier entre noeud

    SRwriteln('****  creation de l''entrenoeud : ' + name + '  ****');

    newInternode := ImportInternode_LE(name, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);

    sample.date := date;
    sample.value := 1;
    newInternode.GetTAttribute('rank').SetSample(sample);

    newInterNode.SetExeOrder(exeOrder);
    newInterNode.SetStartDate(date);
    newInterNode.InitCreationDate(date);
    newInterNode.InitNextDate();
    newInternode.SetCurrentState(2000);

    refMeristem.AddTInstance(newInternode);

    newInterNode.ExternalConnect(['DD',
                                  'EDD',
                                  'testIc',
                                  'fcstr',
                                  'n',
                                  'stock_mainstem',
                                  'Tair',
                                  'plasto_delay',
                                  'thresINER',
                                  'slopeINER',
                                  'FTSW',
                                  'P']);
    refMeristem.SortTInstance();
  end;
end;

procedure EcoMeristemInitialOtherINCreation(var instance : TEntityInstance; const date : TDateTime = 0; const n : Integer = 0);
var
  name : String;
  exeOrder, pos : Integer;
  newInternode : TEntityInstance;
  sample : TSample;
begin

  exeOrder := Trunc(instance.GetTAttribute('exeOrderOfFirstPhytomer').GetSample(date).value) + (2 * n);
  pos := 1;
  name := 'IN' + IntToStr(n + 1);

  // on crée le premier entre noeud

  SRwriteln('****  creation de l''entrenoeud : ' + name + '  ****');

  newInternode := ImportInternode_LE(name, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1);

  sample.date := date;
  sample.value := n + 1;
  newInternode.GetTAttribute('rank').SetSample(sample);

  //showmessage(inttostr(exeorder));

  newInterNode.SetExeOrder(exeOrder);
  newInterNode.SetStartDate(date);
  newInterNode.InitCreationDate(date);
  newInterNode.InitNextDate();
  newInternode.SetCurrentState(2000);

  instance.AddTInstance(newInternode);

  newInterNode.ExternalConnect(['DD',
                                'EDD',
                                'testIc',
                                'fcstr',
                                'n',
                                'stock_mainstem',
                                'Tair',
                                'plasto_delay',
                                'thresINER',
                                'slopeINER',
                                'FTSW',
                                'P']);
  instance.SortTInstance();
end;

procedure EcoMeristemInitialOtherLeafCreation(var instance : TEntityInstance; const date : TDateTime = 0; const n : Integer = 0);
var
  name : String;
  exeOrder : Integer;
  newLeaf : TEntityInstance;
  attributeTmp : TAttribute;
  refAttribute : TAttribute;
  refPort : TPort;
  previousLeafPredimName, currentLeafPredimName : String;

begin
  // creation d'une nouvelle feuille
  // -------------------------------
  //
  name := 'L' + FloatToStr(n + 1);
  SRwriteln('****  creation de la feuille : ' + name + '  ****');
  newLeaf := ImportLeaf_LE(name, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1);

  // determination de l'ordre d'execution de newLeaf :
  // recherche de la premiere place vide apres la premiere entité de type 'Leaf'
  exeOrder := Trunc(instance.GetTAttribute('exeOrderOfFirstPhytomer').GetSample(date).value) + (2 * n) + 1;
  SRwriteln('exeOrder : ' + IntToStr(exeOrder));

  newLeaf.SetExeOrder(exeOrder);
  {newLeaf.SetStartDate(date);
  newLeaf.InitCreationDate(date);}
  newLeaf.SetStartDate(MAX_DATE);
  newLeaf.InitCreationDate(MAX_DATE);
  newLeaf.InitNextDate();
  newLeaf.SetCurrentState(2000);

  instance.AddTInstance(newLeaf);


  // connection port <-> attribut pour newLeaf
  previousLeafPredimName := 'predim_L' + FloatToStr(n);
  currentLeafPredimName := 'predim_L' + FloatToStr(n + 1);

  attributeTmp := TAttributeTmp.Create(currentLeafPredimName);
  instance.AddTAttribute(attributeTmp);

  newLeaf.ExternalConnect([previousLeafPredimName,
                           previousLeafPredimName,
                           currentLeafPredimName,
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
                           'lig',
                           'P']);
  instance.SortTInstance();

  // deconnecte le port 'predimOfCurrentLeaf' de la feuille L(n-2) avec
  // l'attribut 'predimOfNewLeaf' et realise une connectique
  // port 'predimOfCurrentLeaf' de feuille L(n-1) <-> attribut 'predimOfNewLeaf'
  // TODO -u Model : ce qui a ci-dessous risque de crasher lorsque trop de destruction de feuille...
  {if(n>=3) then
  begin
    if (instance.GetTInstance('L' + FloatToStr(n-2)) <> nil) then
    begin
      refPort := instance.GetTInstance('L' + FloatToStr(n-2)).GetTPort('predimOfCurrentLeaf');
      refPort.ExternalUnconnect(1);
    end;

    refAttribute := instance.GetTAttribute('predimOfNewLeaf');
    instance.GetTInstance('L' + FloatToStr(n-1)).GetTPort('predimOfCurrentLeaf').ExternalConnect(refAttribute);
  end;       }
end;

procedure CreateFirstPhytomer_LE(var instance : TEntityInstance; const date : TDateTime = 0);
begin
  EcoMeristemFirstINCreation(instance, date);
  EcoMeristemFirstLeafCreation(instance, date);
end;

procedure CreateOtherPhytomers_LE(var instance : TEntityInstance; const date : TDateTime = 0; const n : Integer = 0);
begin
  EcoMeristemInitialOtherINCreation(instance, date, n);
  EcoMeristemInitialOtherLeafCreation(instance, date, n);
end;

procedure CreateInitialPhytomers_LE(var instance : TEntityInstance; const date : TDateTime = 0);
var
  nb_leaf_max_after_PI : Double;
  i, le : Integer;
  refFather : TModel;
  refMeristem : TEntityInstance;
  refInstance : TInstance;
begin
  CreateFirstPhytomer_LE(instance, date);
  refFather := (instance.GetFather() as TModel);
  refMeristem := nil;

  le := refFather.LengthTInstanceList();
  for i := 0 to le - 1 do
  begin
    refInstance := refFather.GetTInstance(i);
    if (refInstance.GetName() = 'EntityMeristem') then
    begin
      refMeristem := (refInstance as TEntityInstance);
    end;
  end;

  if (refMeristem <> nil) then
  begin

    nb_leaf_max_after_PI := refMeristem.GetTAttribute('nb_leaf_max_after_PI').GetSample(date).value;
    for i := 1 to Trunc(nb_leaf_max_after_PI) do
    begin
      CreateOtherPhytomers_LE(refMeristem, date, i);
    end;
  end;
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

MANAGER_DECLARATION := TManagerInternal.Create('',LeafManager_LE);
MANAGER_DECLARATION.SetFunctName('LeafManager_LE');
MANAGER_LIBRARY.AddTManager(MANAGER_DECLARATION);

MANAGER_DECLARATION := TManagerInternal.Create('',RootManager_LE);
MANAGER_DECLARATION.SetFunctName('RootManager_LE');
MANAGER_LIBRARY.AddTManager(MANAGER_DECLARATION);

MANAGER_DECLARATION := TManagerInternal.Create('',InternodeManager_LE);
MANAGER_DECLARATION.SetFunctName('InternodeManager_LE');
MANAGER_LIBRARY.AddTManager(MANAGER_DECLARATION);

MANAGER_DECLARATION := TManagerInternal.Create('',TillerManager_LE);
MANAGER_DECLARATION.SetFunctName('TillerManager_LE');
MANAGER_LIBRARY.AddTManager(MANAGER_DECLARATION);

MANAGER_DECLARATION := TManagerInternal.Create('',TillerManagerPhytomer_LE);
MANAGER_DECLARATION.SetFunctName('TillerManagerPhytomer_LE');
MANAGER_LIBRARY.AddTManager(MANAGER_DECLARATION);

MANAGER_DECLARATION := TManagerInternal.Create('',MeristemManager_LE);
MANAGER_DECLARATION.SetFunctName('MeristemManager_LE');
MANAGER_LIBRARY.AddTManager(MANAGER_DECLARATION);

MANAGER_DECLARATION := TManagerInternal.Create('',MeristemManagerPhytomers_LE);
MANAGER_DECLARATION.SetFunctName('MeristemManagerPhytomers_LE');
MANAGER_LIBRARY.AddTManager(MANAGER_DECLARATION);

MANAGER_DECLARATION := TManagerInternal.Create('',ThermalTimeManager_LE);
MANAGER_DECLARATION.SetFunctName('ThermalTime_LE');
MANAGER_LIBRARY.AddTManager(MANAGER_DECLARATION);

MANAGER_DECLARATION := TManagerInternal.Create('',PanicleManager_LE);
MANAGER_DECLARATION.SetFunctName('PanicleManager_LE');
MANAGER_LIBRARY.AddTManager(MANAGER_DECLARATION);

MANAGER_DECLARATION := TManagerInternal.Create('',PanicleManager_LE);
MANAGER_DECLARATION.SetFunctName('PeduncleManager_LE');
MANAGER_LIBRARY.AddTManager(MANAGER_DECLARATION);

MANAGER_DECLARATION := TManagerInternal.Create('',EcoMeristemManager_LE);
MANAGER_DECLARATION.SetFunctName('EcoMeristemManager_LE');
MANAGER_LIBRARY.AddTManager(MANAGER_DECLARATION);

end.
