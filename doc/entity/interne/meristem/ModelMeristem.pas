// ---------------------------------------------------------------------------
/// creation et importation du modele meristem
///
/// Description : temporaire (pour tester l'interface)
//
// ----------------------------------------------------------------------------
(** @Author Ludovic TAMBOUR
    @Version 21/10/05 LT v0.0 version initiale; statut : en cours *)

unit ModelMeristem;

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
  ModuleMeristem,
  ClassTManagerDLL,
  ClassTManagerInternal,
  managerMeristem,
  EntityLeaf,
  EntityRoot,
  EntityTiller,
  ClassTExtraProcInstanceInternal,
  UsefullFunctionsForMeristemModel,
  DefinitionConstant;

function ImportModelMeristem() : TModel;

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
//  fonction ImportModelMeristem
//  ----------------------------
//
/// creation et importation du modele meristem v11.1
///
/// Description : temporaire (pour tester l'interface)
///
/// @return modèle meristem V11.1
// ---------------------------------------------------------------------------

function ImportModelMeristem() : TModel;
var
   err : Integer;
   pFile : Text;
   simulationStartDate, simulationEndDate : TDateTime;
   ModelMeristem : TModel;
   entityTmp : TEntityInstance;
   firstLeaf,firstRoot : TEntityInstance;
   procTmp : TProcInstanceInternal;
   XprocTmp : TExtraProcInstanceInternal;
   refEntity : TEntityInstance;
   refInstance : TInstance;
   portTmp : TPort;
   refPort : TPort;
   attributeOutTmp : TAttributeTableOut;
   attributeInTmp : TAttributeTableIn;
   attributeTmp : TAttributeTmp;
   refAttribute : TAttribute;
   airTemperatureFileName, radiationFileName : string;
   parameterTmp : TParameter;
   procedureTmp : TProcInstance;
   initSample : Tsample;
   managerTmp : TManagerInternal;
   Fldw, RSinit, FSLA, Epsib, Tb, plasto : Double; // valeurs des parametres
   MGR, R_d, SLAp, G_L, w1, w2, surfaceCoeff : Double; // valeurs des parametres
   lengthRatio, reallocationRate, Kpar : Double; // valeurs des parametres
   density, Kdf, Kresp, Tresp, gdw, Ict : Double; //valeurs des parametres
begin
  /////////////////////////////////////////////////////////////////
  // Parametres du modele
  /////////////////////////////////////////////////////////////////
  // Initial parameters
  // -----------------
  gdw := 0.018;      // in grams grain dry weight
  Fldw   := 0.0042; // grams first leaf dry weight
  RSinit := 0.9 ;   // root shoot ratio at first leaf stage
  FSLA   := 465 ;   //First leaf SLA (cm².g-1)
  density := 60;

  // ressources acqusition parameters
  // --------------------------------
  Epsib := 3.2;   // conversion efficiency (g.MJ.M-².j-1)
  Kdf := 0.65;     // extinction coefficient for beer lambert law
  Kresp := 0.015;  // percentage of maintenance respiration
  Tresp := 25;     // Optimal temperature
  Tb := 13;       // base temperature
  Kpar := 0.48;

  // organogenetic parameters
  // ------------------------
  plasto := 53;  // time separating the initiation of two consecutive leaves
  MGR    := 1.6; // meristem growth rate param to estimate potential demand (in grams)
                 // of consecutive leaves (leaf (n)_biomss = MRG * leaf (n-1)_biom
  Ict    := 2;   // threshold Ic value for tillering

  plasto := 30; // TODO -u Model : pour avoir de la senescence

  // morphogenetic parameters
  // ------------------------
  R_d  := 0.09; // fraction of reserve on the previous day allocated to the roots
  SLAp := 30;   // param to compute SLA according to leaf rank on the main stem
  G_L  := 1;    // sheath_blade dry weight ratio

  // parametre a changer le nom et le commentaire et a reclasser
  // -----------------------------------------------------------
  w1 := 0.08; // ???????????????
  w2 := 0.08; // ???????????????
  surfaceCoeff := 0.725; // coefficient allometrique de surface foliaire
  lengthRatio  := 1.7;   // facteur de ratio empirique (longueur/G_L)
  reallocationRate := 0.4; // taux de reallocation lors de la destruction d'un organe

  /////////////////////////////////////////////////////////////////
  // fichiers d'entree
  /////////////////////////////////////////////////////////////////
  airTemperatureFileName := 'tab_meteo_E1_air_temperature.txt';
  radiationFileName := 'tab_meteo_E1_radiation.txt';

  /////////////////////////////////////////////////////////////////
  // fichiers de sortie
  /////////////////////////////////////////////////////////////////

  /////////////////////////////////////////////////////////////////
  // constante de simulation
  /////////////////////////////////////////////////////////////////
  simulationStartDate := EncodeDateTime(2005,01,01,00,00,00,00); // 01/01/2005
  simulationEndDate   := EncodeDateTime(2005,01,30,00,00,00,00); // 30/01/2005
  //simulationEndDate   := EncodeDateTime(2005,01,30,00,00,00,00); // TODO -u Model : pour debug. A Retablir

  ///////////////////////////////////////////////////
  // construction du model 'ModelMeristem'
  ///////////////////////////////////////////////////

  // creation de 'ModelMeristem'
  ModelMeristem := TModel.Create('ModelMeristem',simulationStartDate,simulationEndDate);

  // creation des attributs de 'ModelMeristem'
  attributeTmp := TAttributeTmp.Create('Ta');
  ModelMeristem.AddTAttribute(attributeTmp);

  attributeTmp := TAttributeTmp.Create('radiation');
  ModelMeristem.AddTAttribute(attributeTmp);

  // creation de 'EntityMeteo'
  entityTmp := TEntityInstance.Create('EntityMeteo',['airTemperature','kOut','radiation','kOut']);
  entityTmp.SetExeOrder(1);
  ModelMeristem.AddTInstance(entityTmp);

  // connection port <-> attribut pour 'EntityMeteo'
  entityTmp.ExternalConnect(['Ta','radiation']);

  // creation de 'EntityMeristem'
  entityTmp := TEntityInstance.Create('EntityMeristem',['airTemperature','kIn','radiation','kIn']);
  entityTmp.SetExeOrder(2);
  ModelMeristem.AddTInstance(entityTmp);

  // connection port <-> attribut pour 'EntityMeteo'
  entityTmp.ExternalConnect(['Ta','radiation']);

      // -----------------------------------------------------------------------
      // creation du contenu de 'EntityMeteo'
      // -----------------------------------------------------------------------
      refEntity := (ModelMeristem.GetTInstance('EntityMeteo')) as TEntityInstance;

      // creation des attributs dans 'EntityMeteo'
      attributeInTmp := TAttributeTableIn.Create('airTemperature',airTemperatureFileName); // en lecture
      refEntity.AddTAttribute(attributeInTmp);

      attributeTmp := TAttributeTmp.Create('airTemperatureTmp');
      refEntity.AddTAttribute(attributeTmp);

      attributeInTmp := TAttributeTableIn.Create('radiation',radiationFileName); // en lecture
      refEntity.AddTAttribute(attributeInTmp);

      attributeTmp := TAttributeTmp.Create('radiationTmp');
      refEntity.AddTAttribute(attributeTmp);

      // connection port <-> attribut interne pour 'EntityMeteo'
      refEntity.InternalConnect(['airTemperatureTmp','radiationTmp']);

      // creation de 'ReadAirTemperature' (transfert TAttributeTableIn vers port)
      procTmp := TProcInstanceInternal.Create('ReadAirTemperature',IdentityDyn,['inValue','kIn','outValue','kOut']);
      procTmp.SetExeStep(1); // pas journalier
      procTmp.SetExeOrder(1);
      refEntity.AddTInstance(procTmp);

      // connection port <-> attribut pour 'ReadAirTemperature'
      procTmp.ExternalConnect(['airTemperature','airTemperatureTmp']);

      // creation de 'ReadRadiation' (transfert TAttributeTableIn vers port)
      procTmp := TProcInstanceInternal.Create('ReadRadiation',IdentityDyn,['inValue','kIn','outValue','kOut']);
      procTmp.SetExeStep(1); // pas journalier
      procTmp.SetExeOrder(2);
      refEntity.AddTInstance(procTmp);

      // connection port <-> attribut pour 'ReadRadiation'
      procTmp.ExternalConnect(['radiation','radiationTmp']);

      // -----------------------------------------------------------------------
      // creation du contenu de 'EntityMeristem'
      // -----------------------------------------------------------------------
      refEntity := (ModelMeristem.GetTInstance('EntityMeristem')) as TEntityInstance;

      // creation des attributs dans 'EntityMeristem'
      attributeTmp := TAttributeTmp.Create('Ta');
      refEntity.AddTAttribute(attributeTmp);

      attributeOutTmp := TAttributeTableOut.Create('radiation','radiation_out.txt'); // en ecriture
      refEntity.AddTAttribute(attributeOutTmp);

      attributeOutTmp := TAttributeTableOut.Create('TT','TT_out.txt'); // en ecriture
      refEntity.AddTAttribute(attributeOutTmp);

      attributeOutTmp := TAttributeTableOut.Create('DD','DD_out.txt'); // en ecriture
      refEntity.AddTAttribute(attributeOutTmp);

      attributeOutTmp := TAttributeTableOut.Create('EDD','EDD_out.txt'); // en ecriture
      refEntity.AddTAttribute(attributeOutTmp);

      attributeOutTmp := TAttributeTableOut.Create('boolCrossedPlasto','boolCrossedPlasto_out.txt'); // en ecriture
      refEntity.AddTAttribute(attributeOutTmp);

      attributeOutTmp := TAttributeTableOut.Create('n','n_out.txt'); // en ecriture
      refEntity.AddTAttribute(attributeOutTmp);

      parameterTmp := TParameter.Create('FSLA',FSLA);
      refEntity.AddTAttribute(parameterTmp);

      parameterTmp := TParameter.Create('SLAp',SLAp);
      refEntity.AddTAttribute(parameterTmp);

      parameterTmp := TParameter.Create('w1',w1);
      refEntity.AddTAttribute(parameterTmp);

      parameterTmp := TParameter.Create('w2',w2);
      refEntity.AddTAttribute(parameterTmp);

      attributeOutTmp := TAttributeTableOut.Create('SLA','SLA_out.txt'); // en ecriture
      refEntity.AddTAttribute(attributeOutTmp);

      attributeOutTmp := TAttributeTableOut.Create('W','W_out.txt'); // en ecriture
      refEntity.AddTAttribute(attributeOutTmp);

      parameterTmp := TParameter.Create('Fldw',Fldw);
      refEntity.AddTAttribute(parameterTmp);

      parameterTmp := TParameter.Create('plasto',plasto);
      refEntity.AddTAttribute(parameterTmp);

      parameterTmp := TParameter.Create('G_L',G_L);
      refEntity.AddTAttribute(parameterTmp);

      parameterTmp := TParameter.Create('MGR',MGR);
      refEntity.AddTAttribute(parameterTmp);

      parameterTmp := TParameter.Create('RSinit',RSinit);
      refEntity.AddTAttribute(parameterTmp);

      parameterTmp := TParameter.Create('R_d',R_d);
      refEntity.AddTAttribute(parameterTmp);

      parameterTmp := TParameter.Create('surfaceCoeff',surfaceCoeff);
      refEntity.AddTAttribute(parameterTmp);

      parameterTmp := TParameter.Create('lengthRatio',lengthRatio);
      refEntity.AddTAttribute(parameterTmp);

      parameterTmp := TParameter.Create('Ict',Ict);
      refEntity.AddTAttribute(parameterTmp);

      attributeOutTmp := TAttributeTableOut.Create('supply','supply_out.txt'); // en ecriture
      initSample.date := 0; initSample.value := gdw;
      attributeOutTmp.SetSample(initSample);
      refEntity.AddTAttribute(attributeOutTmp);

      attributeOutTmp := TAttributeTableOut.Create('dayDemand','dayDemand_out.txt'); // en ecriture
      initSample.date := 0; initSample.value := 0;
      attributeOutTmp.SetSample(initSample);
      refEntity.AddTAttribute(attributeOutTmp);

      attributeOutTmp := TAttributeTableOut.Create('rest','rest_out.txt'); // en ecriture
      refEntity.AddTAttribute(attributeOutTmp);

      attributeOutTmp := TAttributeTableOut.Create('stock','stock_out.txt'); // en ecriture
      initSample.date := 0; initSample.value := 0;
      attributeOutTmp.SetSample(initSample);
      refEntity.AddTAttribute(attributeOutTmp);

      attributeOutTmp := TAttributeTableOut.Create('assim','assim_out.txt'); // en ecriture
      initSample.date := 0; initSample.value := 0;
      attributeOutTmp.SetSample(initSample);
      refEntity.AddTAttribute(attributeOutTmp);

      attributeTmp := TAttributeTmp.Create('PAI');
      refEntity.AddTAttribute(attributeTmp);

      attributeTmp := TAttributeTmp.Create('biomTot');
      refEntity.AddTAttribute(attributeTmp);

      attributeOutTmp := TAttributeTableOut.Create('Ic','Ic_out.txt'); // en ecriture
      refEntity.AddTAttribute(attributeOutTmp);

      attributeOutTmp := TAttributeTableOut.Create('testIc','testIc_out.txt'); // en ecriture
      refEntity.AddTAttribute(attributeOutTmp);

      attributeOutTmp := TAttributeTableOut.Create('predim_L1','predim_L1_out.txt'); // en ecriture
      refEntity.AddTAttribute(attributeOutTmp);

      attributeOutTmp := TAttributeTableOut.Create('nbTiller','nbTiller_out.txt'); // en ecriture
      initSample.date := 0; initSample.value := 0;
      attributeOutTmp.SetSample(initSample);
      refEntity.AddTAttribute(attributeOutTmp);

      attributeOutTmp := TAttributeTableOut.Create('predimOfNewLeaf','predimOfNewLeaf_out.txt'); // en ecriture
      refEntity.AddTAttribute(attributeOutTmp);

      attributeOutTmp := TAttributeTableOut.Create('TAE','TAE_out.txt'); // en ecriture
      refEntity.AddTAttribute(attributeOutTmp);

      // connection port <-> attribut interne pour 'EntityMeristem'
      refEntity.InternalConnect(['Ta','radiation']);

      // creation de 'EntityThermalTime'
      entityTmp := TEntityInstance.Create('EntityThermalTime',['airTemperature','kIn','thermalTime','kOut','degreeDay','kOut','efficientDegreeDay','kOut','boolCrossedPlasto','kOut','phenoStage','kOut']);
      entityTmp.SetExeOrder(1);
      refEntity.AddTInstance(entityTmp);

      // connection port <-> attribut pour 'EntityThermalTime'
      entityTmp.ExternalConnect(['Ta','TT','DD','EDD','boolCrossedPlasto','n']);

      // creation de 'ComputeSLA'
      procTmp := TProcInstanceInternal.Create('ComputeSLA',ComputeSLADyn,['FSLA','kIn','SLAp','kIn','phenoStage','kIn','SLA','kOut']);
      procTmp.SetExeStep(1); // pas journalier
      procTmp.SetExeOrder(2);
      refEntity.AddTInstance(procTmp);

      // connection port <-> attribut pour 'ComputeSLA'
      procTmp.ExternalConnect(['FSLA','SLAp','n','SLA']);

      // creation de 'ComputeW'
      procTmp := TProcInstanceInternal.Create('ComputeW',ComputeWDyn,['phenoStage','kIn','w1','kIn','w2','kIn','W','kOut']);
      procTmp.SetExeStep(1); // pas journalier
      procTmp.SetExeOrder(3);
      refEntity.AddTInstance(procTmp);

      // connection port <-> attribut pour 'ComputeW'
      procTmp.ExternalConnect(['n','w1','w2','W']);

      // ajout d'un manageur
      managerTmp := TManagerInternal.Create('MeristemManager',MeristemManager);
      managerTmp.SetExeMode(intra);
      managerTmp.SetExeOrder(50);
      refEntity.AddTManager(managerTmp);

      // ajout de la premiere entité feuille 'L1'
      firstLeaf := ImportLeaf('L1',plasto,G_L,surfaceCoeff,lengthRatio,MGR,1);
      firstLeaf.SetExeOrder(55);
      refEntity.AddTInstance(firstLeaf);

      // connection port <-> attribut pour 'L1'
      firstLeaf.ExternalConnect(['Fldw','Fldw','predim_L1','DD','EDD','SLA','W','boolCrossedPlasto','testIc']);
      refAttribute := refEntity.GetTAttribute('predimOfNewLeaf');
      firstLeaf.GetTPort('predimOfCurrentLeaf').ExternalConnect(refAttribute); // TODO -u Model : a l essai pour l instant

      // ajout des entité racines 'roots'
      firstRoot := ImportRoot('roots',Fldw,RSinit,plasto,R_d);
      firstRoot.SetExeOrder(90);
      refEntity.AddTInstance(firstRoot);

      // connection port <-> attribut pour 'roots'
      firstRoot.ExternalConnect(['EDD','dayDemand']); // TODO -u Ludo : pourquoi EDD et pas DD ????????????????????????????????????

      // creation de 'ComputeRest'
      procTmp := TProcInstanceInternal.Create('ComputeRest',ComputeRestDyn,['previousSupply','kIn','previousDayDemand','kIn','rest','kOut']);
      procTmp.SetExeStep(1); // pas journalier
      procTmp.SetExeOrder(15);
      refEntity.AddTInstance(procTmp);

      // connection port <-> attribut pour 'ComputeRest'
      procTmp.ExternalConnect(['supply','dayDemand','rest']);

      // creation de 'ComputeStock'
      procTmp := TProcInstanceInternal.Create('ComputeStock',UpdateAddDyn,['quantity','kIn','attributeValue','kInOut']);
      procTmp.SetExeStep(1); // pas journalier
      procTmp.SetExeOrder(16);
      refEntity.AddTInstance(procTmp);

      // connection port <-> attribut pour 'ComputeStock'
      procTmp.ExternalConnect(['rest','stock']);

      // creation de 'Senescence'
      XprocTmp := TExtraProcInstanceInternal.Create('Senescence',KillOldestLeafDyn,['stock','kInOut']);
      XprocTmp.SetExeStep(1); // pas journalier
      XprocTmp.SetExeOrder(17);
      refEntity.AddTInstance(XprocTmp);

      // connection port <-> attribut pour 'Senescence'
      XprocTmp.ExternalConnect(['stock']);

      // creation de 'ComputeIC'
      procTmp := TProcInstanceInternal.Create('ComputeIC',ComputeICDyn,['supply','kIn','dayDemand','kIn','Ic','kOut','testIc','kOut']);
      procTmp.SetExeStep(1); // pas journalier
      procTmp.SetExeOrder(18);
      refEntity.AddTInstance(procTmp);

      // connection port <-> attribut pour 'ComputeIc'
      procTmp.ExternalConnect(['supply','dayDemand','Ic','testIc']);

      // creation de 'UpdateSupply'
      procTmp := TProcInstanceInternal.Create('UpdateSupply',UpdateSupplyDyn,['previousAssim','kIn','previousDayDemand','kIn','rest','kIn','supply','kInOut']);
      procTmp.SetExeStep(1); // pas journalier
      procTmp.SetExeOrder(19);
      refEntity.AddTInstance(procTmp);

      // connection port <-> attribut pour 'ComputeSupply'
      procTmp.ExternalConnect(['assim','dayDemand','rest','supply']);

      // creation de 'EnableNbTillerCount'
      XprocTmp := TExtraProcInstanceInternal.Create('EnableNbTillerCount',EnableNbTillerCountDyn,['plasto','kIn']);
      XprocTmp.SetExeStep(1); // pas journalier
      XprocTmp.SetExeOrder(24);
      refEntity.AddTInstance(XprocTmp);

      // connection port <-> attribut pour 'UpdateNbTiller'
      XprocTmp.ExternalConnect(['n']);

      // creation de 'UpdateNbTiller'
      procTmp := TProcInstanceInternal.Create('UpdateNbTiller',UpdateNbTillerCountDyn,['Ic','kIn','IcThreshold','kIn','nbTiller','kInOut']);
      procTmp.SetExeStep(1); // pas journalier
      procTmp.SetExeOrder(25);
      procTmp.SetActiveState(10); // jamais actif sauf si manageur change sa valeur
      refEntity.AddTInstance(procTmp);

      // connection port <-> attribut pour 'UpdateNbTiller'
      procTmp.ExternalConnect(['Ic','Ict','nbTiller']);

      // creation de 'CountOfNbTillerWithMore4Leaves'
      XprocTmp := TExtraProcInstanceInternal.Create('CountOfNbTillerWithMore4Leaves',CountOfNbTillerWithMore4LeavesDyn,['nbTillerWithMore4Leaves','kOut']);
      XprocTmp.SetExeStep(1); // pas journalier
      XprocTmp.SetExeOrder(26);
      XprocTmp.SetActiveState(10); // jamais actif sauf si manageur change sa valeur
      refEntity.AddTInstance(XprocTmp);

      // connection port <-> attribut pour 'UpdateNbTiller'
      XprocTmp.ExternalConnect(['TAE']);

      // creation de 'minNbTillerAndTAE'
      procTmp := TProcInstanceInternal.Create('minNbTillerAndTAE',ThresholdDyn,['inValue','kIn','thresholdValue','kIn','outValue','kOut']);
      procTmp.SetExeStep(1); // pas journalier
      procTmp.SetExeOrder(27);
      procTmp.SetActiveState(10); // jamais actif sauf si manageur change sa valeur
      refEntity.AddTInstance(procTmp);

      // connection port <-> attribut pour 'minNbTillerAndTAE'
      procTmp.ExternalConnect(['nbTiller','TAE','nbTiller']);

      // creation de 'ComputeDayDemand'
      XprocTmp := TExtraProcInstanceInternal.Create('ComputeDayDemand',SumOfDemandRecDyn,['total','kOut']);
      XprocTmp.SetExeStep(1); // pas journalier
      XprocTmp.SetExeOrder(3000);
      refEntity.AddTInstance(XprocTmp);

      // connection port <-> attribut pour 'ComputeDayDemand'
      XprocTmp.ExternalConnect(['dayDemand']);

      // creation de 'ComputePAI'
      XprocTmp := TExtraProcInstanceInternal.Create('ComputePAI',SumOfBladeAreaInLeafRecDyn,['total','kOut']);
      XprocTmp.SetExeStep(1); // pas journalier
      XprocTmp.SetExeOrder(3001);
      refEntity.AddTInstance(XprocTmp);

      // connection port <-> attribut pour 'ComputePAI'
      XprocTmp.ExternalConnect(['PAI']);

      // creation de 'ComputeBiomTot'
      XprocTmp := TExtraProcInstanceInternal.Create('ComputeBiomTot',SumOfBiomassRecDyn,['total','kOut']);
      XprocTmp.SetExeStep(1); // pas journalier
      XprocTmp.SetExeOrder(3002);
      refEntity.AddTInstance(XprocTmp);

      // connection port <-> attribut pour 'ComputeBiomTot'
      XprocTmp.ExternalConnect(['biomTot']);

      // creation de 'EntityAssimilation'
      entityTmp := TEntityInstance.Create('EntityAssimilation',['PAI','kIn','radiation','kIn','biomassTotal','kIn','airTemperature','kIn','assimilationNet','kOut']);
      entityTmp.SetExeOrder(3003);
      refEntity.AddTInstance(entityTmp);

      // connection port <-> attribut pour 'EntityAssimilation'
      entityTmp.ExternalConnect(['PAI','radiation','biomTot','Ta','assim']);

      // creation de 'SwitchOfPredimOfNewLeaf'
      // = recupere le predimensionnement de la derniere feuille initiée
      // jamais directement exécuté, mais exécuté par le manageur
      //procTmp := TProcInstanceInternal.Create('SwitchOfPredimOfNewLeaf',IdentityDyn,['inValue','kIn','outValue','kOut']);
      //procTmp.SetExeStep(1); // pas journalier
      //procTmp.SetExeOrder(2000);
      //procTmp.SetActiveState(10); // jamais actif
      //refEntity.AddTInstance(procTmp);

      // connection port <-> attribut pour 'SwitchOfPredimOfNewLeaf'
      //procTmp.ExternalConnect(['predim_L1','predimOfNewLeaf']);

      
          // -----------------------------------------------------------------------
          // creation du contenu de 'EntityThermalTime'
          // -----------------------------------------------------------------------
          refEntity := (ModelMeristem.GetTInstance('EntityMeristem')) as TEntityInstance;
          refEntity := (refEntity.GetTInstance('EntityThermalTime')) as TEntityInstance;

          // creation des attributs dans 'EntityThermalTime'
          attributeTmp := TAttributeTmp.Create('Ta');
          refEntity.AddTAttribute(attributeTmp);

          parameterTmp := TParameter.Create('Tb',Tb);
          refEntity.AddTAttribute(parameterTmp);

          attributeTmp := TAttributeTmp.Create('deltaT');
          refEntity.AddTAttribute(attributeTmp);

          initSample.date := 0; initSample.value := 0;
          attributeTmp := TAttributeTmp.Create('TT',initSample);
          refEntity.AddTAttribute(attributeTmp);

          initSample.date := 0; initSample.value := 0;
          attributeTmp := TAttributeTmp.Create('DD',initSample);
          refEntity.AddTAttribute(attributeTmp);

          parameterTmp := TParameter.Create('plasto',plasto);
          refEntity.AddTAttribute(parameterTmp);

          attributeTmp := TAttributeTmp.Create('EDD');
          refEntity.AddTAttribute(attributeTmp);

          attributeTmp := TAttributeTmp.Create('boolCrossedPlasto');
          refEntity.AddTAttribute(attributeTmp);

          initSample.date := 0; initSample.value := 1;
          attributeTmp := TAttributeTmp.Create('phenoStage',initSample);
          refEntity.AddTAttribute(attributeTmp);

          // connection port <-> attribut interne pour 'EntityThermalTime'
          refEntity.InternalConnect(['Ta','TT','DD','EDD','boolCrossedPlasto','phenoStage']);

          // creation de 'ComputeDeltaT' (calcul de la temperature utile)
          procTmp := TProcInstanceInternal.Create('ComputeDeltaT',DiffDyn,['inValue1','kIn','inValue2','kIn','outValue','kOut']);
          procTmp.SetExeStep(1); // pas journalier
          procTmp.SetExeOrder(1);
          refEntity.AddTInstance(procTmp);

          // connection port <-> attribut pour 'ComputeDeltaT'
          procTmp.ExternalConnect(['Ta','Tb','deltaT']);

          // creation de 'UpdateTT'
          procTmp := TProcInstanceInternal.Create('UpdateTT',UpdateAddDyn,['quantity','kIn','attributeValue','kInOut']);
          procTmp.SetExeStep(1); // pas journalier
          procTmp.SetExeOrder(2);
          refEntity.AddTInstance(procTmp);

          // connection port <-> attribut pour 'UpdateTT'
          procTmp.ExternalConnect(['deltaT','TT']);

          // creation de 'UpdateDegreeDay'
          procTmp := TProcInstanceInternal.Create('UpdateDegreeDay',UpdateDegreeDayDyn,['deltaT','kIn','plasto','kIn','DD','kInOut','EDD','kOut','boolCrossedPlasto','kOut']);
          procTmp.SetExeStep(1); // pas journalier
          procTmp.SetExeOrder(3);
          refEntity.AddTInstance(procTmp);

          // connection port <-> attribut pour 'UpdateDegreeDay'
          procTmp.ExternalConnect(['deltaT','plasto','DD','EDD','boolCrossedPlasto']);

          // creation de 'UpdatePhenoStage'
          procTmp := TProcInstanceInternal.Create('UpdatePhenoStage',UpdatePhenoStageDyn,['boolCrossedPlasto','kIn','phenoStage','kInOut']);
          procTmp.SetExeStep(1); // pas journalier
          procTmp.SetExeOrder(4);
          refEntity.AddTInstance(procTmp);

          // connection port <-> attribut pour 'UpdatePhenoStage'
          procTmp.ExternalConnect(['boolCrossedPlasto','phenoStage']);

          // -----------------------------------------------------------------------
          // creation du contenu de 'EntityAssimilation'
          // -----------------------------------------------------------------------
          refEntity := (ModelMeristem.GetTInstance('EntityMeristem')) as TEntityInstance;
          refEntity := (refEntity.GetTInstance('EntityAssimilation')) as TEntityInstance;

          // creation des attributs dans 'EntityAssimilation'
          parameterTmp := TParameter.Create('density',density);
          refEntity.AddTAttribute(parameterTmp);

          parameterTmp := TParameter.Create('Kdf',Kdf);
          refEntity.AddTAttribute(parameterTmp);

          parameterTmp := TParameter.Create('Epsib',Epsib);
          refEntity.AddTAttribute(parameterTmp);

          parameterTmp := TParameter.Create('Kpar',Kpar);
          refEntity.AddTAttribute(parameterTmp);

          parameterTmp := TParameter.Create('Kresp',Kresp);
          refEntity.AddTAttribute(parameterTmp);

          parameterTmp := TParameter.Create('Tresp',Tresp);
          refEntity.AddTAttribute(parameterTmp);

          attributeTmp := TAttributeTmp.Create('PAI');
          refEntity.AddTAttribute(attributeTmp);

          attributeTmp := TAttributeTmp.Create('LAI');
          refEntity.AddTAttribute(attributeTmp);

          attributeTmp := TAttributeTmp.Create('intercept');
          refEntity.AddTAttribute(attributeTmp);

          attributeTmp := TAttributeTmp.Create('radiation');
          refEntity.AddTAttribute(attributeTmp);

          attributeTmp := TAttributeTmp.Create('assimPot');
          refEntity.AddTAttribute(attributeTmp);

          attributeTmp := TAttributeTmp.Create('biomTot');
          refEntity.AddTAttribute(attributeTmp);

          attributeTmp := TAttributeTmp.Create('Ta');
          refEntity.AddTAttribute(attributeTmp);

          attributeTmp := TAttributeTmp.Create('respMaint');
          refEntity.AddTAttribute(attributeTmp);

          attributeTmp := TAttributeTmp.Create('assim');
          refEntity.AddTAttribute(attributeTmp);

          // connection port <-> attribut interne pour 'EntityThermalTime'
          refEntity.InternalConnect(['PAI','radiation','biomTot','Ta','assim']);

          // creation de 'ComputeLAI'
          procTmp := TProcInstanceInternal.Create('ComputeLAI',ComputeLAIDyn,['PAI','kIn','density','kIn','LAI','kOut']);
          procTmp.SetExeStep(1); // pas journalier
          procTmp.SetExeOrder(1);
          refEntity.AddTInstance(procTmp);

          // connection port <-> attribut pour 'ComputeLAI'
          procTmp.ExternalConnect(['PAI','density','LAI']);

          // creation de 'ComputeRadiationInterception'
          procTmp := TProcInstanceInternal.Create('ComputeRadiationInterception',ComputeRadiationInterceptionDyn,['Kdf','kIn','LAI','kIn','radiationInterception','kOut']);
          procTmp.SetExeStep(1); // pas journalier
          procTmp.SetExeOrder(2);
          refEntity.AddTInstance(procTmp);

          // connection port <-> attribut pour 'ComputeRadiationInterception'
          procTmp.ExternalConnect(['Kdf','LAI','intercept']);

          // creation de 'ComputePotentialAssimilation'
          procTmp := TProcInstanceInternal.Create('ComputePotentialAssimilation',ComputePotentialAssimilationDyn,['radiationInterception','kIn','Epsib','kIn','radiation','kIn','Kpar','kIn','potentialAssimilation','kOut']);
          procTmp.SetExeStep(1); // pas journalier
          procTmp.SetExeOrder(3);
          refEntity.AddTInstance(procTmp);

          // connection port <-> attribut pour 'ComputePotentialAssimilation'
          procTmp.ExternalConnect(['intercept','Epsib','radiation','Kpar','assimPot']);

          // creation de 'ComputeRespirationMaintenance'
          procTmp := TProcInstanceInternal.Create('ComputeRespirationMaintenance',ComputeRespirationMaintenanceDyn,['Kresp','kIn','biomassTotal','kIn','airTemperature','kIn','Tresp','kIn','respirationMaintenance','kOut']);
          procTmp.SetExeStep(1); // pas journalier
          procTmp.SetExeOrder(4);
          refEntity.AddTInstance(procTmp);

          // connection port <-> attribut pour 'ComputeRespirationMaintenance'
          procTmp.ExternalConnect(['Kresp','biomTot','Ta','Tresp','respMaint']);

          // creation de 'ComputeAssimilationNet'
          procTmp := TProcInstanceInternal.Create('ComputeAssimilationNet',ComputeAssimilationNetDyn,['PotentialAssimilation','kIn','respirationMaintenance','kIn','density','kIn','assimilationNet','kOut']);
          procTmp.SetExeStep(1); // pas journalier
          procTmp.SetExeOrder(5);
          refEntity.AddTInstance(procTmp);

          // connection port <-> attribut pour 'ComputeAssimilationNet'
          procTmp.ExternalConnect(['assimPot','respMaint','density','assim']);

  //////////////////////////////////////////////////
  // Execution du modele 'ModelMeristem'
  //////////////////////////////////////////////////
  err := ModelMeristem.ExecuteSimulation();

  //////////////////////////////////////////////////////////
  // affichage de l'entité modele aprés simulation
  //////////////////////////////////////////////////////////
  AssignFile(pFile,'ModelMeristem_apres_simulation.txt');
  ReWrite(pFile);
  ModelMeristem.Print(pFile);
  CloseFile(pFile);


// retourne le modèle
result := ModelMeristem;

end;

end.
