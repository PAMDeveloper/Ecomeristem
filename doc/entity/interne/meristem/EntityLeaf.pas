// ---------------------------------------------------------------------------
/// creation et importation d'une entité feuille générique
///
/// Description :
//
// ----------------------------------------------------------------------------
(** @Author Ludovic TAMBOUR
    @Version 11/08/05 LT v0.0 version initiale; statut : en cours *)

unit EntityLeaf;

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

function ImportLeaf(name : string ; plasto,G_L,surfaceCoeff,lengthRatio,MGR : Double ; boolFirstLeaf : Double = 0) : TEntityInstance;


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
///   - plasto : plastochron
///   - G_L : sheath blade dry weight ratio
///   - surfaceCoeff : coefficient allometrique foliaire
///   - lengthRatio : facteur de ratio empirique (longueur/G_L)
///   - boolFirstLeaf : indique si la feuille est la premiere feuille du
///    brin maitre ou de la talle (=1 si premiere feuille sinon =0 ;
///    par defaut, =0)
///
/// Une feuille contient des ports :
/// - predimOfPreviousLeaf (entrée) : predimensionnement de la feuille precedente
/// - predimLeafOnMainstem (entrée) : prédimensionnement de la feuille qui vient de se finaliser sur le brin maître
/// - predimOfCurrentLeaf (sortie) : predimensionnement de cette entité
/// - degreeDayForInitiation (entrée) : degré jour lors de la premiere realisation
/// - degreeDayForRealization (entrée) : degré jour pour la realisation autre que la premiere realisation
/// - SLA (entree) : surface leaf area (pourquoi pas attribut de la feuille ?????)
/// - W (entree) : ??????????????????????????? (pourquoi pas dans la feuille ????)
/// - boolCrossedPlasto (entrée) : indique s'il y a eut franchissement de plasto ou non
/// - testIc (entree) : ???????????????
///
/// Une feuille contient des attributs internes :
///   - predim : predimensionnement de la feuille
///   - demand : demande de la feuille
///   - biomass : biomasse de la feuille (valant 0 a la creation)
///   - bladeArea : traduction ????
///   - length : longueur de la feuille
///
/// Les modules calculent les valeurs des attributs jour apres jour
/// (etat INITIAL_STATE). Lorsque l'état devient l'état de FINALISATION (état2),
/// plus d'évolution des attributs et la demande passe a '0'.
///
/// @param name nom de la nouvelle feuille
/// @param plasto quantite a ajouter a attributeValue
/// @param G_L quantite a ajouter a attributeValue
/// @param surfaceCoeff quantite a ajouter a attributeValue
/// @param lengthRatio facteur de ratio empirique (longueur/G_L)
/// @return nouvelle entité feuille de nom 'name' et de parametre 'plasto','G_L','surfaceCoeff',lengthRatio
// ---------------------------------------------------------------------------

function ImportLeaf(name : string ; plasto,G_L,surfaceCoeff,lengthRatio,MGR : Double ; boolFirstLeaf : Double = 0) : TEntityInstance;
var
  entityLeaf : TEntityInstance;
  attributeTmp : TAttributeTmp;
  parameterTmp : TParameter;
  initSample : TSample;
  procTmp : TProcInstanceInternal;
  managerTmp : TManagerInternal;
  attributeOutTmp : TAttributeTableOut;
begin
  // creation de 'EntityLeaf'
  entityLeaf := TEntityInstance.Create('',['predimOfPreviousLeaf','kIn','predimLeafOnMainstem','kIn','predimOfCurrentLeaf','kOut','degreeDayForInitiation','kIn','degreeDayForRealization','kIn','SLA','kIn','W','kIn','boolCrossedPlasto','kIn','testIc','kIn']);
  entityLeaf.SetName(name);
  entityLeaf.SetCategory('Leaf');

  // creation des attributs dans 'EntityLeaf'
  attributeTmp := TAttributeTmp.Create('predimOfPreviousLeaf');
  entityLeaf.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('predimLeafOnMainstem');
  entityLeaf.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('predim');
  entityLeaf.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('SLA');
  entityLeaf.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('W');
  entityLeaf.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('demand');
  entityLeaf.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('boolCrossedPlasto');
  entityLeaf.AddTAttribute(attributeTmp);

  initSample.date := 0; initSample.value := 0;
  attributeTmp := TAttributeTmp.Create('biomass',initSample);
  entityLeaf.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('bladeArea');
  entityLeaf.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('length');
  entityLeaf.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('DDInitiation');
  entityLeaf.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('DDRealization');
  entityLeaf.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('testIc');
  entityLeaf.AddTAttribute(attributeTmp);

  parameterTmp := TParameter.Create('plasto',plasto);
  entityLeaf.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('G_L',G_L);
  entityLeaf.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('surfaceCoeff',surfaceCoeff);
  entityLeaf.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('lengthRatio',lengthRatio);
  entityLeaf.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('MGR',MGR);
  entityLeaf.AddTAttribute(parameterTmp);

  parameterTmp := TParameter.Create('boolFirstLeaf',boolFirstLeaf);
  entityLeaf.AddTAttribute(parameterTmp);

  /////////////////////////////////////////////////////////////////////////////
  // Modules pour l'état initiation
  /////////////////////////////////////////////////////////////////////////////

  // connection port <-> attribut pour 'EntityLeaf'
  entityLeaf.InternalConnect(['predimOfPreviousLeaf','predimLeafOnMainstem','predim','DDInitiation','DDRealization','SLA','W','boolCrossedPlasto','testIc']);

  // creation de 'ComputeLeafPredimensionnementInitiation'
  procTmp := TProcInstanceInternal.Create('ComputeLeafPredimensionnementInitiation',ComputeLeafPredimensionnementDyn,['boolFirstLeaf','kIn','predimOfPreviousLeaf','kIn','predimLeafOnMainstem','kIn','MGR','kIn','testIc','kIn','predimOfCurrentLeaf','kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(1);
  procTmp.SetActiveState(1);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'ComputeLeafPredimensionnementInitiation' de 'EntityLeaf'
  procTmp.ExternalConnect(['boolFirstLeaf','predimOfPreviousLeaf','predimLeafOnMainstem','MGR','testIc','predim']);

  // creation de 'ComputeOrganDemandInitiation'
  procTmp := TProcInstanceInternal.Create('ComputeOrganDemandInitiation',ComputeOrganDemandDyn,['predim','kIn','DD','kIn','plasto','kIn','demand','kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(2);
  procTmp.SetActiveState(1);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'ComputeOrganDemandInitiation' de 'EntityLeaf'
  procTmp.ExternalConnect(['predim','DDInitiation','plasto','demand']);

  // creation de 'UpdateOrganBiomassInitiation'
  procTmp := TProcInstanceInternal.Create('UpdateOrganBiomassInitiation',UpdateOrganBiomassDyn,['demand','kIn','biomass','kInOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(3);
  procTmp.SetActiveState(1);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'UpdateOrganBiomassInitiation' de 'EntityLeaf'
  procTmp.ExternalConnect(['demand','biomass']);

  // creation de 'ComputeLeafBladeAreaInitiation'
  procTmp := TProcInstanceInternal.Create('ComputeLeafBladeAreaInitiation',ComputeLeafBladeAreaDyn,['biomass','kIn','G_L','kIn','SLA','kIn','bladeArea','kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(4);
  procTmp.SetActiveState(1);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'UpdateOrganBiomassInitiation' de 'EntityLeaf'
  procTmp.ExternalConnect(['biomass','G_L','SLA','bladeArea']);

  // creation de 'ComputeLeafLengthInitiation'
  procTmp := TProcInstanceInternal.Create('ComputeLeafLengthInitiation',ComputeLeafLengthDyn,['bladeArea','kIn','W','kIn','surfaceCoeff','kIn','ratio','kIn','le','kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(5);
  procTmp.SetActiveState(1);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'ComputeLeafLengthInitiation' de 'EntityLeaf'
  procTmp.ExternalConnect(['bladeArea','W','surfaceCoeff','lengthRatio','length']);

  /////////////////////////////////////////////////////////////////////////////
  // Modules pour l'état réalisation
  /////////////////////////////////////////////////////////////////////////////

  // creation de 'ComputeOrganDemandRealization'
  procTmp := TProcInstanceInternal.Create('ComputeOrganDemandRealization',ComputeOrganDemandDyn,['predim','kIn','DD','kIn','plasto','kIn','demand','kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(21);
  procTmp.SetActiveState(2);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'ComputeOrganDemandRealization' de 'EntityLeaf'
  procTmp.ExternalConnect(['predim','DDRealization','plasto','demand']);

  // creation de 'UpdateOrganBiomassRealization'
  procTmp := TProcInstanceInternal.Create('UpdateOrganBiomassRealization',UpdateOrganBiomassDyn,['demand','kIn','biomass','kInOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(22);
  procTmp.SetActiveState(2);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'UpdateOrganBiomassRealization' de 'EntityLeaf'
  procTmp.ExternalConnect(['demand','biomass']);

  // creation de 'ComputeLeafBladeAreaRealization'
  procTmp := TProcInstanceInternal.Create('ComputeLeafBladeAreaRealization',ComputeLeafBladeAreaDyn,['biomass','kIn','G_L','kIn','SLA','kIn','bladeArea','kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(23);
  procTmp.SetActiveState(2);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'UpdateOrganBiomassRealization' de 'EntityLeaf'
  procTmp.ExternalConnect(['biomass','G_L','SLA','bladeArea']);

  // creation de 'ComputeLeafLengthRealization'
  procTmp := TProcInstanceInternal.Create('ComputeLeafLengthRealization',ComputeLeafLengthDyn,['bladeArea','kIn','W','kIn','surfaceCoeff','kIn','ratio','kIn','le','kOut']);
  procTmp.SetExeStep(1); // pas journalier
  procTmp.SetExeOrder(24);
  procTmp.SetActiveState(2);
  entityLeaf.AddTInstance(procTmp);

  // connection port <-> attribut pour 'ComputeLeafLengthRealization' de 'EntityLeaf'
  procTmp.ExternalConnect(['bladeArea','W','surfaceCoeff','lengthRatio','length']);

  ////////////////////////////////////////////////////////
  // ajout d'un manageur
  ////////////////////////////////////////////////////////
  managerTmp := TManagerInternal.Create('LeafManager',LeafManager);
  managerTmp.SetExeMode(post);
  entityLeaf.AddTManager(managerTmp);

  // retourne la feuille créée
  result := entityLeaf;
end;

end.
