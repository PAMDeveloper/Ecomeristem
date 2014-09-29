// ---------------------------------------------------------------------------
/// creation et importation d'une entité talle générique
///
/// Description :
//
// ----------------------------------------------------------------------------
(** @Author Ludovic TAMBOUR
    @Version 12/08/05 LT v0.0 version initiale; statut : en cours *)

unit EntityTiller;

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
  DefinitionConstant;

  function ImportTiller(name : string) : TEntityInstance;


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
/// creation et importation d'une entité talle générique
///
/// Description :
/// Une talle est une entité générique. Ses paramètres sont :
///   - :
///
/// Une talle contient des ports :
///   - (entrée) :
///
/// Une talle contient des attributs internes :
///   - leafNb : nombre de feuilles contenues par la talle
///
/// @param name nom de la nouvelle talle
/// @param
/// @return nouvelle entité talle de nom 'name' et de parametre
// ---------------------------------------------------------------------------

function ImportTiller(name : string) : TEntityInstance;
var
  entityTiller : TEntityInstance;
  attributeTmp : TAttributeTmp;
  parameterTmp : TParameter;
  procTmp : TProcInstanceInternal;
  managerTmp : TManagerInternal;
  initSample : TSample;
begin
  // creation de 'EntityTiller'
  entityTiller := TEntityInstance.Create('',['Fldw','kIn','predimLeafOnMainstem','kIn','degreeDayForLeafInitiation','kIn','degreeDayLeafForRealization','kIn','SLA','kIn','W','kIn','boolCrossedPlasto','kIn','testIc','kIn']);
  entityTiller.SetName(name);
  entityTiller.SetCategory('Tiller');

  // creation des attributs dans 'EntityTiller'
  attributeTmp := TAttributeTmp.Create('leafNb');
  initSample.date := 0; initSample.value := 0;
  attributeTmp.SetSample(initSample);
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('Fldw');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('predimLeafOnMainstem');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('degreeDayForLeafInitiation');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('degreeDayLeafForRealization');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('SLA');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('W');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('boolCrossedPlasto');
  entityTiller.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('testIc');
  entityTiller.AddTAttribute(attributeTmp);

  // connection port <-> attribut pour 'EntityTiller'
  entityTiller.InternalConnect(['Fldw','predimLeafOnMainstem','degreeDayForLeafInitiation','degreeDayLeafForRealization','SLA','W','boolCrossedPlasto','testIc']);

  // ajout d'un manageur
  managerTmp := TManagerInternal.Create('TillerManager',TillerManager);
  managerTmp.SetExeMode(intra);
  managerTmp.SetExeOrder(1);
  //managerTmp.SetExeMode(pre);
  entityTiller.AddTManager(managerTmp);

  // TODO -u Model : pour debug, besoin d au moins un processus pour que ca marche
  // creation de 'ReadAirTemperature' (transfert TAttributeTableIn vers port)
  procTmp := TProcInstanceInternal.Create('toto',IdentityDyn,['inValue','kIn','outValue','kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(2);
  entityTiller.AddTInstance(procTmp);
  procTmp.ExternalConnect(['leafNb','leafNb']);

  // retourne la feuille créée
  result := entityTiller;
end;

end.
