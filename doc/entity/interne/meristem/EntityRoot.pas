// ---------------------------------------------------------------------------
/// creation et importation d'une entité racine générique
///
/// Description :
//
// ----------------------------------------------------------------------------
(** @Author Ludovic TAMBOUR
    @Version 11/08/05 LT v0.0 version initiale; statut : en cours *)

unit EntityRoot;

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

function ImportRoot(name : string ; Fldw,RSinit,plasto,R_d : Double) : TEntityInstance;

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
//  fonction ImportRoot
//  -------------------
/// creation et importation d'une entité feuille générique
///
/// Description :
/// Une feuille est une entité générique. Ses paramètres sont :
///   - Fldw : grams first leaf dry weight
///   - RSinit : root shoot ratio at first leaf stage
///   - plasto : plastochron
///   - R_d : fraction of reserve on the previous day allocated to the roots
///
/// Une feuille contient des ports :
///   - DD (entrée) : duree du jour
///   - dayDemand (entree) : demande journaliere
///
/// Une feuille contient des attributs internes :
///   - predim : predimensionnement de la feuille
///   - demand : demande de la feuille
///   - biomass : biomasse de la feuille (valant 0 a la creation)
///
/// L'entité racine possède 2 états :
/// - l'état INITIALIZATION (état INITIAL_STATE)
/// - l'état REALIZATION (état 2)
/// Suivant l'état, des modules différents sont utilisés.
/// Pas de manageur, le changement d'état est réalisé par l'entité portant
/// l'entité racine
///
/// @param name nom de la nouvelle racine
/// @param Fldw grams first leaf dry weight
/// @param RSinit root shoot ratio at first leaf stage
/// @param plasto plastochron
/// @param R_d fraction of reserve on the previous day allocated to the roots
/// @return nouvelle entité racine de nom 'name' et de parametre Fldw,RSinit,plasto,R_d
// ---------------------------------------------------------------------------

function ImportRoot(name : string ; Fldw,RSinit,plasto,R_d : Double) : TEntityInstance;
var
  entityRoot : TEntityInstance;
  attributeTmp : TAttributeTmp;
  parameterTmp : TParameter;
  procTmp : TProcInstanceInternal;
  initSample : TSample;
  managerTmp : TManagerInternal;
begin
  // creation de 'EntityRoot'
  entityRoot := TEntityInstance.Create('',['DD','kIn','dayDemand','kIn']);
  entityRoot.SetName(name);
  entityRoot.SetCategory('Root');

  // creation des attributs dans 'EntityLeaf'
  attributeTmp := TAttributeTmp.Create('predim');
  entityRoot.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('demand');
  entityRoot.AddTAttribute(attributeTmp);

  initSample.date := 0; initSample.value := 0;
  attributeTmp := TAttributeTmp.Create('biomass',initSample);
  entityRoot.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('DD');
  entityRoot.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('dayDemand');
  entityRoot.AddTAttribute(attributeTmp);

  parameterTmp := TParameter.Create('Fldw',Fldw);
  entityRoot.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('RSinit',RSinit);
  entityRoot.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('plasto',plasto);
  entityRoot.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('R_d',R_d);
  entityRoot.AddTAttribute(parameterTmp);

  // connection port <-> attribut pour 'EntityRoot'
  entityRoot.InternalConnect(['DD','dayDemand']);

  //////////////////////////////////////////////////////
  // creation des modules pour l'état INITIATION
  //////////////////////////////////////////////////////

  // creation de 'ComputeRootPredimInitiation'
  procTmp := TProcInstanceInternal.Create('ComputeRootPredimInitiation',Mult2ValuesDyn,['inValue1','kIn','inValue2','kIn','outValue','kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(1);
  procTmp.SetActiveState(1);
  entityRoot.AddTInstance(procTmp);

  // connection port <-> attribut pour 'ComputeRootPredimInitiation'
  procTmp.ExternalConnect(['Fldw','RSinit','predim']);

  // creation de 'ComputeOrganDemandInitiation'
  procTmp := TProcInstanceInternal.Create('ComputeOrganDemandInitiation',ComputeOrganDemandDyn,['predim','kIn','DD','kIn','plasto','kIn','demand','kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(2);
  procTmp.SetActiveState(1);
  entityRoot.AddTInstance(procTmp);

  // connection port <-> attribut pour 'ComputeOrganDemandInitiation'
  procTmp.ExternalConnect(['predim','DD','plasto','demand']);

  // creation de 'UpdateOrganBiomassInitiation'
  procTmp := TProcInstanceInternal.Create('UpdateOrganBiomassInitiation',UpdateOrganBiomassDyn,['demand','kIn','biomass','kInOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(3);
  procTmp.SetActiveState(1);
  entityRoot.AddTInstance(procTmp);

  // connection port <-> attribut pour 'UpdateOrganBiomassInitiation'
  procTmp.ExternalConnect(['demand','biomass']);

  //////////////////////////////////////////////////////
  // creation des modules pour l'état REALISATION
  //////////////////////////////////////////////////////

  // creation de 'ComputeOrganDemandRealization'
  procTmp := TProcInstanceInternal.Create('ComputeOrganDemandRealization',Mult2ValuesDyn,['inValue1','kIn','inValue2','kIn','outValue','kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(4);
  procTmp.SetActiveState(2);
  entityRoot.AddTInstance(procTmp);

  // connection port <-> attribut pour 'ComputeOrganDemandRealization'
  procTmp.ExternalConnect(['dayDemand','R_d','demand']);

  // creation de 'UpdateOrganBiomassRealization'
  procTmp := TProcInstanceInternal.Create('UpdateOrganBiomassRealization',UpdateOrganBiomassDyn,['demand','kIn','biomass','kInOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(5);
  procTmp.SetActiveState(2);
  entityRoot.AddTInstance(procTmp);

  // connection port <-> attribut pour 'UpdateOrganBiomassInitiation'
  procTmp.ExternalConnect(['demand','biomass']);

  // ajout d'un manageur
  managerTmp := TManagerInternal.Create('RootManager',RootManager);
  managerTmp.SetExeMode(post);
  entityRoot.AddTManager(managerTmp);

  //////////////////////////////////////////////////////
  // retourne la racine créée
  //////////////////////////////////////////////////////
  result := entityRoot;

end;

end.
