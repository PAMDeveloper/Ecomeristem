//---------------------------------------------------------------------------
/// Manageurs utilises pour le modele meristem
///
///Description :
///
//----------------------------------------------------------------------------
(** @Author Ludovic TAMBOUR
    @Version 11/08/05 LT v0.0 version initiale; statut : en cours *)

unit managerMeristem;

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
  UsefullFunctionsForMeristemModel,
  ModuleMeristem,
  ClassTManagerLibrary,
  DefinitionConstant;

function LeafManager(var instance : TEntityInstance; const date : TDateTime = 0 ; const state : Integer = 0) : Integer;
function RootManager(var instance : TEntityInstance; const date : TDateTime = 0 ; const state : Integer = 0) : Integer;
function TillerManager(var instance : TEntityInstance; const date : TDateTime = 0 ; const state : Integer = 0) : Integer;
function MeristemManager(var instance : TEntityInstance; const date : TDateTime = 0 ; const state : Integer = 0) : Integer;

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

uses EntityLeaf,EntityRoot,EntityTiller;

// ----------------------------------------------------------------------------
//  fonction LeafManager
//  ---------------------
//
/// gere le comportement d'une feuille
///
/// description :
///
/// mode 'post'
///
/// liste des états :
/// 1 (initial) -> predimensionnment et premiere realisation
/// 2 -> realisation
/// 3 -> finalisation
///
/// Etat 1 (initiation) :
/// - passage a etat 2 (realisation)
///
/// Etat 2 (realisation) :
/// - Si nouveau plastochon :
///       - l'attribut 'demand' passe a 0
///       - La date de prochaine execution est repoussé à MAX_DATE (pour dire que
///         l'entité n'est plus active pendant la simulation)
///       - on passe a l'état 3 (finalisation)
/// - Sinon (pas nouveau plastochron) :
///       - on reste a l'etat 2
///
/// Etat 3 (finalisation) :
/// - nothing to do
/// - on reste a l'état 3 (finalisation)
///
/// @param instance instance d'entité portant le manageur
/// @param date date actuelle de simulation  (par défaut, MIN_DATE)
/// @param state état actuel de l'instance portant le manageur (par défaut, 0)
/// @return nouvelle etat
// ---------------------------------------------------------------------------

function LeafManager(var instance : TEntityInstance; const date : TDateTime = 0 ; const state : Integer = 0) : Integer;
var
   refAttribute : TAttribute;
   sample : TSample;
   newState : Integer;
   boolCrossedPlasto : Double;
begin
  case state of
    // ETAT PREDIMENSIONNEMENT :
    // -----------------------
    1 :
      begin
        newState := 2;
      end;

    // ETAT REALISATION :
    // ----------------
    2 :
      begin
        boolCrossedPlasto := instance.GetTAttribute('boolCrossedPlasto').GetSample(date).value;
        if (boolCrossedPlasto>=0) then // new plasto = finalisation de la feuille
        begin
          // finalisation de la feuille (mise a zero de sa demande)
          refAttribute := instance.GetTAttribute('demand');
          sample.date := date;
          sample.value := 0;
          refAttribute.SetSample(sample);

          // arret du comportement de la feuille
          instance.SetNextDate(MAX_DATE);

          // changement d'état
          newState := 3;
        end
        else
        begin // pas de changement de plasto
          newState := 2;
        end;
      end;

    // ETAT FINALISATION :
    // -----------------
    3 :
      begin
        // on reste sur le meme etat
        newState := 3;
      end;

    // ETAT NON DEFINIT :
    // ----------------
    else
      begin
        result := -1;
        exit;
      end;
    end;

  // retourne l'état (pas de modification d'état)
  result := newState;
end;

// ----------------------------------------------------------------------------
//  fonction RootManager
//  ---------------------
//
/// gere le comportement des racines
///
/// description :
///
/// mode 'post'
///
/// liste des états :
/// 1 (initial) -> predimensionnment
/// 2 -> realisation
///
/// Etat 1 (predimensionnement) :
/// - execution des modules actifs sur l'état 1
/// - passage a etat 2 (realisation)
/// - premiere realisation dans le meme pas d'execution : forcer par le manageur
///
/// Etat 2 (realisation) :
/// - execution des modules actifs sur l'état 2
/// - on reste sur l'état 2
///
/// @param instance instance d'entité portant le manageur
/// @param date date actuelle de simulation  (par défaut, MIN_DATE)
/// @param state état actuel de l'instance portant le manageur (par défaut, 0)
/// @return nouvelle etat
// ---------------------------------------------------------------------------

function RootManager(var instance : TEntityInstance; const date : TDateTime = 0 ; const state : Integer = 0) : Integer;
var
   newState : Integer;
begin
  case state of
    // ETAT PREDIMENSIONNEMENT :
    // -----------------------
    1 :
      begin
        // changement d'état
        newState := 2;
      end;

    // ETAT REALISATION :
    // ----------------
    2 :
      begin
        // Pas de changement d'état
        newState := 2;
      end;

    // ETAT NON DEFINIT :
    // ----------------
    else
      begin
        result := -1;
        exit;
      end;
    end;

  // retourne l'état (pas de modification d'état)
  result := newState;
end;

// ----------------------------------------------------------------------------
//  fonction TillerManager
//  ---------------------
//
/// gere le comportement d'une talle
///
/// description :
///
/// @param instance instance d'entité portant le manageur
/// @param date date actuelle de simulation  (par défaut, MIN_DATE)
/// @param state état actuel de l'instance portant le manageur (par défaut, 0)
/// @return meme etat que etat actuel (pas de gestion des etats)
// ---------------------------------------------------------------------------
function TillerManager(var instance : TEntityInstance; const date : TDateTime = 0 ; const state : Integer = 0) : Integer;
var
  newState : Integer;
  sample : Tsample;
  name : String;
  plasto,G_L,surfaceCoeff,lengthRatio,MGR,boolCrossedPlasto : Double;
  refMeristem : TEntityInstance;
  newLeaf : TEntityInstance;
  exeOrder : Integer;
  attributeTmp : TAttributeTmp;
  rank : Double;
  previousLeafPredimName,currentLeafPredimName : String;
begin
  case state of
    // ETAT INITIATION :
    // -----------------
    1 :
      begin
        // creation d'une premiere feuille
        sample.date := date; sample.value := 1;
        instance.GetTAttribute('leafNb').SetSample(sample);

        name := 'L1_' + instance.GetName();

        refMeristem := instance.GetFather() as TEntityInstance;
        plasto := refMeristem.GetTAttribute('plasto').GetSample(date).value;
        G_L := refMeristem.GetTAttribute('G_L').GetSample(date).value;
        surfaceCoeff := refMeristem.GetTAttribute('surfaceCoeff').GetSample(date).value;
        lengthRatio := refMeristem.GetTAttribute('lengthRatio').GetSample(date).value;
        MGR := refMeristem.GetTAttribute('MGR').GetSample(date).value;

        SRwriteln('****  creation de la feuille : ' + name + '  ****');
        newLeaf := ImportLeaf(name,plasto,G_L,surfaceCoeff,lengthRatio,MGR,1);

        // determination de l'ordre d'execution de newLeaf :
        // recherche de la premiere place vide apres la premiere entité de type 'Leaf'
        exeOrder := FindFirstEmptyPlaceAfterASpecifiedCategory(instance,'Leaf');
        newLeaf.SetExeOrder(3);
        newLeaf.SetStartDate(date);
        newLeaf.InitCreationDate(date);
        newLeaf.InitNextDate();
        instance.AddTInstance(newLeaf);

        // connection port <-> attribut pour newLeaf
        attributeTmp := TAttributeTmp.Create('predim_L1');
        instance.AddTAttribute(attributeTmp);

        newLeaf.ExternalConnect(['Fldw','predimLeafOnMainstem','predim_L1','degreeDayForLeafInitiation','degreeDayLeafForRealization','SLA','W','boolCrossedPlasto','testIc']);
        instance.SortTInstance();

        // nouvelle état
        newState := 2;
      end;

    // ETAT REALISATION :
    // ----------------
    2 :
      begin

        // initiation d'une nouvelle feuille a chaque nouveau plasto
        boolCrossedPlasto := instance.GetTAttribute('boolCrossedPlasto').GetSample(date).value;
        if (boolCrossedPlasto>=0) then // New plastochron
        begin
          // creation d'une nouvelle feuille
          // -------------------------------
          rank := FindGreatestSuffixforASpecifiedCategory(instance,'Leaf') + 1;
          name := 'L' + FloatToStr(rank) + '_' + instance.GetName();

          refMeristem := instance.GetFather() as TEntityInstance;
          plasto := refMeristem.GetTAttribute('plasto').GetSample(date).value;
          G_L := refMeristem.GetTAttribute('G_L').GetSample(date).value;
          surfaceCoeff := refMeristem.GetTAttribute('surfaceCoeff').GetSample(date).value;
          lengthRatio := refMeristem.GetTAttribute('lengthRatio').GetSample(date).value;
          MGR := refMeristem.GetTAttribute('MGR').GetSample(date).value;

          SRwriteln('****  creation de la feuille : ' + name + '  ****');
          newLeaf := ImportLeaf(name,plasto,G_L,surfaceCoeff,lengthRatio,MGR,0);

          // determination de l'ordre d'execution de newLeaf :
          // recherche de la premiere place vide apres la premiere entité de type 'Leaf'
          exeOrder := FindFirstEmptyPlaceAfterASpecifiedCategory(instance,'Leaf');
          newLeaf.SetExeOrder(exeOrder);
          newLeaf.SetStartDate(date);
          newLeaf.InitCreationDate(date);
          newLeaf.InitNextDate();
          instance.AddTInstance(newLeaf);

          // connection port <-> attribut pour newLeaf
          previousLeafPredimName := 'predim_L' + FloatToStr(rank-1);
          currentLeafPredimName := 'predim_L' + FloatToStr(rank);

          attributeTmp := TAttributeTmp.Create(currentLeafPredimName);
          instance.AddTAttribute(attributeTmp);

          newLeaf.ExternalConnect([previousLeafPredimName,'predimLeafOnMainstem',currentLeafPredimName,'degreeDayForLeafInitiation','degreeDayLeafForRealization','SLA','W','boolCrossedPlasto','testIc']); // TODO - u Model : pourquoi ici 'DD' et pas 'EDD'
          instance.SortTInstance();

          // remise a jour du compteur de feuille de la talle 'leafNb'
          sample := instance.GetTAttribute('leafNb').GetCurrentSample();
          sample.value := sample.value+1; sample.date := date;
          instance.GetTAttribute('leafNb').SetSample(sample);
      end;

      // pas de changement d etat
      newState := state;
    end;

    // ETAT NON DEFINIT :
    // ----------------
    else
      begin
        result := -1;
        exit;
      end;
    end;

  // retourne le nouvel état
  result := newState;
end;

// ----------------------------------------------------------------------------
//  fonction MeristemManager
//  ------------------------
//
/// gere le comportement du méristem
///
/// description :
/// - Au premier pas de simulation (état initial) :
///     - initiation de la premiere feuille
///     - initiation des racines
///     - passage a l'état courant (état2)
///
/// - Pour les autres pas de simualtion (etat2) :
///     - TODO
///
/// @param instance instance d'entité portant le manageur
/// @param date date actuelle de simulation  (par défaut, MIN_DATE)
/// @param state état actuel de l'instance portant le manageur (par défaut, 0)
/// @return nouvel etat
// ---------------------------------------------------------------------------

function MeristemManager(var instance : TEntityInstance; const date : TDateTime = 0 ; const state : Integer = 0) : Integer;
var
  newState : Integer;
  boolCrossedPlasto,n,nbTiller : Double;
  name : String;
  newLeaf, newTiller : TEntityInstance;
  plasto,G_L,surfaceCoeff,lengthRatio,MGR : Double;
  exeOrder : Integer;
  previousLeafPredimName,currentLeafPredimName : String;
  i : Integer;
  refProc : TProcInstanceInternal;
  refPort : TPort;
  attributeTmp : TAttribute;
  refAttribute : TAttribute;
  sample : TSample;
begin
  //////////////////////////////////////////////////////////////////
  // Realisation des taches a chaque franchissement de plasto
  //////////////////////////////////////////////////////////////////
  boolCrossedPlasto := instance.GetTAttribute('boolCrossedPlasto').GetSample(date).value;
  if (boolCrossedPlasto>=0) then // New plastochron
  begin
    // creation d'une nouvelle feuille
    // -------------------------------
    n := instance.GetTAttribute('n').GetSample(date).value;
    name := 'L' + FloatToStr(n);

    plasto := instance.GetTAttribute('plasto').GetSample(date).value;
    G_L := instance.GetTAttribute('G_L').GetSample(date).value;
    surfaceCoeff := instance.GetTAttribute('surfaceCoeff').GetSample(date).value;
    lengthRatio := instance.GetTAttribute('lengthRatio').GetSample(date).value;
    MGR := instance.GetTAttribute('MGR').GetSample(date).value;

    SRwriteln('****  creation de la feuille : ' + name + '  ****');
    newLeaf := ImportLeaf(name,plasto,G_L,surfaceCoeff,lengthRatio,MGR,0);

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

    newLeaf.ExternalConnect([previousLeafPredimName,previousLeafPredimName,currentLeafPredimName,'DD','EDD','SLA','W','boolCrossedPlasto','testIc']); // TODO - u Model : pourquoi ici 'DD' et pas 'EDD'
    instance.SortTInstance();

    // deconnecte le port 'predimOfCurrentLeaf' de la feuille L(n-2) avec
    // l'attribut 'predimOfNewLeaf' et realise une connectique
    // port 'predimOfCurrentLeaf' de feuille L(n-1) <-> attribut 'predimOfNewLeaf'
    // TODO -u Model : ce qui a ci-dessous risque de crasher lorsque trop de destruction de feuille...
    if(n>=3) then
    begin
      refPort := instance.GetTInstance('L' + FloatToStr(n-2)).GetTPort('predimOfCurrentLeaf');
      refPort.ExternalUnconnect(1);

      refAttribute := instance.GetTAttribute('predimOfNewLeaf');
      instance.GetTInstance('L' + FloatToStr(n-1)).GetTPort('predimOfCurrentLeaf').ExternalConnect(refAttribute);
    end;
  end;


  //////////////////////////////////////////////////////////////////
  // Creation de talles
  //////////////////////////////////////////////////////////////////
  n := instance.GetTAttribute('n').GetSample(date).value;
  boolCrossedPlasto := instance.GetTAttribute('boolCrossedPlasto').GetSample(date).value;
  nbTiller := instance.GetTAttribute('nbTiller').GetSample(date).value;

  // TODO - u model : la creation de talle peut etre a priori mise
  // en dehors de l'état 3 dans la zone prelminaire boolCrossedPlasto>=0
  // moyennant une entité judicieuse englobant tout ce qui concerne
  // le calcul de 'nbTiller'

  if ((n>6) and(boolCrossedPlasto>=0) and (nbTiller >= 1)) then
  begin
    for i:=1 to Trunc(nbTiller) do
    begin
      name := 'T_' + IntToStr(FindGreatestSuffixforASpecifiedCategory(instance,'Tiller')+1);
      SRwriteln('****  creation de la talle : ' + name + '  ****');
      newTiller := ImportTiller(name);

      // determination de l'ordre d'execution de newTiller :
      if (HasAnEntityWithASpecifiedCategory(instance,'Tiller')=False) then
      begin // cas particulier ou c'est la premiere talle a creer
        newTiller.SetExeOrder(1001);
      end
      else
      begin
        exeOrder := FindFirstEmptyPlaceAfterASpecifiedCategory(instance,'Tiller');
        newTiller.SetExeOrder(exeOrder);
      end;

      newTiller.SetStartDate(date);
      newTiller.InitCreationDate(date);
      newTiller.InitNextDate();
      instance.AddTInstance(newTiller);

      newTiller.ExternalConnect(['Fldw','predimOfNewLeaf','DD','EDD','SLA','W','boolCrossedPlasto','testIc']);
      instance.SortTInstance();
    end;

    // re-initialisation nbTiller
    sample.value := 0; sample.date := date; 
    instance.GetTAttribute('nbTiller').SetSample(sample);
  end;

  // on reste sur le meme etat
  result := state;
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

MANAGER_DECLARATION := TManagerInternal.Create('',LeafManager);
MANAGER_DECLARATION.SetFunctName('LeafManager');
MANAGER_LIBRARY.AddTManager(MANAGER_DECLARATION);

MANAGER_DECLARATION := TManagerInternal.Create('',RootManager);
MANAGER_DECLARATION.SetFunctName('RootManager');
MANAGER_LIBRARY.AddTManager(MANAGER_DECLARATION);

MANAGER_DECLARATION := TManagerInternal.Create('',TillerManager);
MANAGER_DECLARATION.SetFunctName('TillerManager');
MANAGER_LIBRARY.AddTManager(MANAGER_DECLARATION);

MANAGER_DECLARATION := TManagerInternal.Create('',MeristemManager);
MANAGER_DECLARATION.SetFunctName('MeristemManager');
MANAGER_LIBRARY.AddTManager(MANAGER_DECLARATION);

end.
