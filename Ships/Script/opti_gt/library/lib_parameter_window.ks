runOncePath(libFolder + "lib_launch_opti_gt.ks").

function openParameter {
  // ~~~ configuration de la fenêtre initiale ~~~
  local windowWidth is 650.
  global globalWindow is GUI(windowWidth).
  set globalWindow:y to 100.
  set globalWindow:skin:font to "Consolas".
  set globalWindow:skin:label:fontsize to 15.
  set globalWindow:skin:label:hstretch to true.
  set globalWindow:skin:label:align to "center".

  // ~~~ numéro de version ~~~
  local printVersion is globalWindow:addlabel(DIC_warning_page_version + scriptVersion).
    set printVersion:style:fontsize to 8.
    set printVersion:style:align to "left".
  globalWindow:addSpacing(8).

  // ~~~ titre qui correspond au nom du vaisseau ~~~
  local title is globalWindow:addLabel().
    set title:text to "<b>" + ship:name + "</b>".
    set title:style:fontSize to 20.

  globalWindow:addSpacing(15).

  // ~~~ Ajout un texte pour afficher le TWR ~~~
  local TWRbox is globalWindow:addHbox().
  local TWRtext is TWRbox:addLabel().
    set TWRtext:text to "<b>" + DIC_parameter_window_print_TWR + round(TWR,3) + "</b>".
    set TWRtext:style:fontSize to 17.

  globalWindow:addSpacing(10).

  globalWindow:addLabel(DIC_parameter_window_title).

  globalWindow:addSpacing(10).

  // ~~~ Création de la boîte de choix du mode
  local autoOrManualBox is globalWindow:addHlayout().
  autoOrManualBox:addSpacing(10).
  local autoButton is autoOrManualBox:addRadioButton(DIC_parameter_window_auto_mode_button_name, true).
  local presentationAuto is (DIC_parameter_window_auto_mode_presentation).

  autoOrManualBox:addSpacing(15).

  local manualButton is autoOrManualBox:addRadioButton(DIC_parameter_window_manual_mode_button_name, false).
  local presentationManuel is (DIC_parameter_window_manual_mode_presentation).

  autoOrManualBox:addSpacing(15).
  
  local optiGTAutoButton is autoOrManualBox:addRadioButton(DIC_parameter_window_gtopti_mode_button_name, false).
  local presentationOpti is (DIC_parameter_window_gtopti_mode_presentation).
  
  set autoOrManualBox:onradiochange to autoManualChoice@. //-> cf fonction autoManualChoice ci-après

  globalWindow:addSpacing(5).

  // ~~~ Création d'une boîte qui indique si le vaisseau a déjà été testé ~~~
  local recapExistBox is globalWindow:addVbox().
  recapExistBox:hide().
    local recapExistText is recapExistBox:addLabel(DIC_parameter_window_already_tested_text).
      set recapExistText:style:textcolor to white. //RGB(254/255, 80/255, 0). 
    local recapExistDate is recapExistBox:addLabel("").
      set recapExistDate:style:textcolor to white. //RGB(254/255, 80/255, 0). 
    local recapExistValue is recapExistBox:addLabel("").
      set recapExistValue:style:textcolor to white. //RGB(254/255, 80/255, 0). 
  
  if exists(mainFolder + "recap.csv") {
    local recapTemp is addons:file:readAllLines(readFileFolder + "recap.csv").
    local recapLines is list().
    for line in recapTemp {
      local dataLine is line:split(";").
      recapLines:add(dataLine).
    }
    local recapL is recapLines:length.
    local index is recapL - 1.
    until index = 0 {
      if recapLines[index][2] = ship:name {
        set recapExistDate:text to "<b>" + DIC_parameter_window_already_tested_date + recapLines[index][0] + DIC_parameter_window_already_tested_hour + recapLines[index][1] + "</b>".
        set recapExistValue:text to "<b>" + DIC_parameter_window_already_tested_amp_text + recapLines[index][3] + DIC_angle_unit + " et " + DIC_parameter_window_already_tested_vPitch_text + recapLines[index][4] + DIC_velocity_unit + "</b>".
        recapExistBox:show().
        break.
      }
      set index to index - 1.
    }
  }

  globalWindow:addSpacing(5).
  local presentationBox is globalWindow:addVbox().
    set presentationBox:style:padding:v to 25.
  local presentationText is presentationBox:addLabel().
    set presentationText:text to presentationAuto.
    set presentationText:style:textcolor to white.
  globalWindow:addSpacing(5).

  // ~~~ Création du contenant pour les paramètres AUTO ~~~
  local autoBox is globalWindow:addHlayout().
    set autoBox:style:width to windowWidth.
    autoBox:show().

  // ~~~ Création du contenant pour les paramètres MANUEL ~~~
  local manualBox is globalWindow:addVlayout().
    set manualBox:style:width to windowWidth.
    manualBox:addLabel(DIC_parameter_window_manual_mode_box_title).
    manualBox:addSpacing(15).
    manualBox:hide().

  // ~~~ Création du contenant pour la recherche du GT Opti ~~~
  local optiBox is globalWindow:addVlayout(). //-> choix des paramètres initiaux pour une recherche de GT opti.
    optiBox:addLabel(DIC_parameter_window_gtopti_mode_box_title).
    optiBox:addSpacing(5).
    local infoOptiBox is optiBox:addVbox().
    local infoOptiGT is infoOptiBox:addLabel().
      set infoOptiGT:text to DIC_parameter_window_gtopti_mode_box_warning.
      set infoOptiGT:style:textcolor to RGB(254/255, 80/255, 0). // couleur orange
      set infoOptiGT:style:fontsize to 14.
      set infoOptiGT:style:padding:v to 15.
    local smiley is infoOptiBox:addLabel("☺").
      set smiley:style:fontsize to 32.
      set smiley:style:textcolor to RGB(0, 200/255, 0). // green

    optiBox:addSpacing(15).
    optiBox:hide().

  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  // -- CONFIGURATION DES BOUTONS RADIO POUR LES CHOIX AUTO, MANUEL, OPTI
  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  function autoManualChoice {
    parameter B.
    if B:text = DIC_parameter_window_auto_mode_button_name {
      set presentationText:text to presentationAuto.
      autoBox:show().
      manualBox:hide().
      optiBox:hide().
    }
    if B:text = DIC_parameter_window_manual_mode_button_name {
      set presentationText:text to presentationManuel.
      autoBox:hide().
      manualBox:show().
      optiBox:hide().
    }
    if B:text = DIC_parameter_window_gtopti_mode_button_name {
      set presentationText:text to presentationOpti.
      autoBox:hide().
      manualBox:hide().
      optiBox:show().
    }
  }

  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  // -- CRÉATION DE LA BOÎTE POUR LE CHOIX AUTO
  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  // ~~~ Création de la boite qui contiendra les paramètres d'amplitude ~~~
  local ampSuggestedBox is autoBox:addVlayout().
  set ampSuggestedBox:style:width to windowWidth / 2.
    // ~~~ Affichage de l'amplitude suggérée ~~~
    local ampSuggestedText is ampSuggestedBox:addlabel().
      set ampSuggestedText:text to "<b>" + DIC_parameter_window_auto_mode_box_suggested_amp + suggestedAMP + DIC_angle_unit + "</b>".
    ampSuggestedBox:addSpacing(10).
    // ~~~ Boîte qui contiendra les modifications d'amplitude ~~~
    local ampBox is ampSuggestedBox:addVlayout().
  
  // ~~~ Création de la boite qui contiendra les paramètres de vPitch ~~~
  local vPitchSuggestedBox is autoBox:addVlayout().
  set vPitchSuggestedBox:style:width to windowWidth / 2.
    // ~~~ Affichage de la vPitch calculée en fonction de l'amplitude ~~~
    global vPitchSuggestedText is vPitchSuggestedBox:addlabel().
      set vPitchSuggestedText:text to "<b>" + DIC_parameter_window_auto_mode_box_suggested_vPitch + round(suggestedVpitch,2) + DIC_velocity_unit + "</b>".
    vPitchSuggestedBox:addSpacing(10).
    // ~~~ Boîte qui contiendra les modifications de vPitch ~~~
    local vPitchBox is vPitchSuggestedBox:addVlayout().

  // ~~~ Création des boutons pour choisir l'amplitude ~~~
  local ampModification is ampBox:addVbox().
  set ampModification:onradiochange to ampButtonChoice@. //-> cf fonction ampButtonChoice ci-après
  local ampModificationText is ampModification:addLabel(DIC_parameter_window_auto_mode_box_amp_choice_title).
    addAmpButton(DIC_parameter_window_auto_mode_box_amp_choice_button_suggested, 0, true).
    addAmpButton(DIC_parameter_window_auto_mode_box_amp_choice_button_85, 85).
    addAmpButton(DIC_parameter_window_auto_mode_box_amp_choice_button_80, 80).
    addAmpButton(DIC_parameter_window_auto_mode_box_amp_choice_button_75, 75).
    addAmpButton(DIC_parameter_window_auto_mode_box_amp_choice_button_70, 70).
    addAmpButton(DIC_parameter_window_auto_mode_box_amp_choice_button_65, 65).

    function addAmpButton {
      parameter text, value.
      parameter bool is false.
      local but is ampModification:addRadioButton(text, bool).
      AmpLexicon:add(text, value).
      listAmpButton:add(but).
      return but.
    }

  // ~~~ Création des boutons pour modifier la vitesse ~~~
  local vPitchModification is vPitchBox:addVbox().
  set vPitchModification:onradiochange to vPitchButtonChoice@. //-> cf fonction vPitchButtonChoice ci-après
  local vPitchModificationText is vPitchModification:addLabel(DIC_parameter_window_auto_mode_box_vPitch_choice_title).
  vPitchModification:addSpacing(16).
    addPitchButton(DIC_parameter_window_auto_mode_box_vPitch_choice_button_15, 15).
    addPitchButton(DIC_parameter_window_auto_mode_box_vPitch_choice_button_8, 8, true).
    addPitchButton(DIC_parameter_window_auto_mode_box_vPitch_choice_button_4, 4).
    addPitchButton(DIC_parameter_window_auto_mode_box_vPitch_choice_button_0, 0).
    addPitchButton(DIC_parameter_window_auto_mode_box_vPitch_choice_button_0_forced, 0).
    vPitchModification:addSpacing(17).

    function addPitchButton {
      parameter text, value.
      parameter bool is false.
      local but is vPitchModification:addRadioButton(text, bool).
      pitchLexicon:add(text, value).
      listPitchButton:add(but).
      return but.
    }

  // ~~~ Action à réaliser lorsqu'un bouton est sélectionné pour l'amplitude
  function ampButtonChoice {
    parameter B.
    if B:text = DIC_parameter_window_auto_mode_box_amp_choice_button_suggested {
      set equation to equationLexicon[suggestedAmp].
    }
    else {
      set equation to equationLexicon[ampLexicon[B:text]].
    }
    set suggestedVpitch to equation(TWR).
    set vPitchSuggestedText:text to "<b>" + DIC_parameter_window_auto_mode_box_suggested_vPitch + round(suggestedVpitch,2) + DIC_velocity_unit + "</b>".
    set finalVpitch to updateVpitch(suggestedVpitch).
  }

  // ~~~ Action à réaliser lorsqu'un bouton est sélectionné pour la vPitch
  function vPitchButtonChoice {
    parameter B.
    if B:text = DIC_parameter_window_auto_mode_box_vPitch_choice_button_0_forced {
      set finalVpitch to 0.
    }
    else {
      set finalVpitch to suggestedVpitch + pitchLexicon[B:text].
    }
  }

  function updateVpitch {
    parameter vp.
    local result is 0.
    for but in listPitchButton {
      if but:pressed {
        set result to vp + pitchLexicon[but:text].
        break.
      }
    }
    return result.
  }

  // ~~~ Création des boutons GT seulement, GT + CIRCU ~~~
  ampBox:addSpacing(10).
  local GTAutoButton is ampBox:addButton(DIC_parameter_window_auto_mode_box_GTonly_button_name).
  vPitchBox:addSpacing(10).
  local GTcircAutoButton is vPitchBox:addButton(DIC_parameter_window_auto_mode_box_GTCirc_button_name).

  // ~~~ Configuration du bouton GT seulement ~~~
  set GTAutoButton:style:hstretch to true.
  set GTAutoButton:style:align to "center".

  // ~~~ Configuration du bouton GT + Circularisation ~~~
  set GTcircAutoButton:style:hstretch to true.
  set GTcircAutoButton:style:align to "center".


  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  // -- CRÉATION DE LA BOÎTE POUR LE CHOIX MANUEL
  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  local ampManualBox is manualBox:addHlayout.
  local ampText is ampManualBox:addLabel(DIC_parameter_window_manual_mode_box_amp_title).
    set ampText:style:fontSize to 15.
    set ampText:style:align to "right".
    set ampText:style:width to 0.5 * windowWidth. 
  ampManualBox:addSpacing(5).

  local ampField is ampManualBox:addTextField().
    set ampField:style:width to 0.5 * windowWidth - 15.
    set ampField:toolTip to DIC_parameter_window_manual_mode_box_amp_tooltip.
    set ampField:style:padding:h to 5.
  
  manualBox:addSpacing(15).

  local vPitchManualBox is manualBox:addHlayout.
  local vPitchText is vPitchManualBox:addLabel(DIC_parameter_window_manual_mode_box_vPitch_title).
    set vPitchText:style:fontSize to 15.
    set vPitchText:style:align to "right".
    set vPitchText:style:width to 0.5 * windowWidth. 
  vPitchManualBox:addSpacing(5).

  local vPitchField is vPitchManualBox:addTextField().
    set vPitchField:style:width to 0.5 * windowWidth - 15.
    set vPitchField:toolTip to DIC_parameter_window_manual_mode_box_vPitch_tooltip.
    set vPitchField:style:padding:h to 5.

  manualBox:addSpacing(15).

  local apoapsisManualBox is manualBox:addHlayout.
  local apoapsisText is apoapsisManualBox:addLabel(DIC_parameter_window_manual_mode_box_apoapsis_title).
    set apoapsisText:style:fontSize to 15.
    set apoapsisText:style:align to "right".
    set apoapsisText:style:width to 0.5 * windowWidth. 
  apoapsisManualBox:addSpacing(5).

  local apoapsisField is apoapsisManualBox:addTextField().
    set apoapsisField:style:width to 0.5 * windowWidth - 15.
    set apoapsisField:toolTip to DIC_parameter_window_manual_mode_box_apoapsis_tooltip.
    set apoapsisField:style:padding:h to 5.

  manualBox:addSpacing(15).

  local manualButtonBox is manualBox:addHlayout.
  local GTManualButton is manualButtonBox:addButton(DIC_parameter_window_manual_mode_box_GTonly_button_name).
  local GTCircManualButton is manualButtonBox:addButton(DIC_parameter_window_manual_mode_box_GTCirc_button_name).

  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  // -- CRÉATION DE LA BOÎTE POUR LE GT OPTI
  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  local dakiButton is optiBox:addButton().
    set dakiButton:text to (DIC_parameter_window_gtopti_mode_box_button_name).
    set dakiButton:style:hstretch to true.
    set dakiButton:style:align to "center".
    set dakiButton:style:padding:v to 15.
  optiBox:addSPacing(15).

  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  // -- BOUTONS CHANGEMENT DE LANGUE ET ANNULATION
  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  local changeLanguageButton is globalWindow:addButton(DIC_change_language_button_name).
  local cancelButton is globalWindow:addButton(DIC_parameter_window_cancel_button_name).
  // ~~~ Configuration du bouton CHANGER LANGUE ~~~
  set changeLanguageButton:style:hstretch to true.
  set changeLanguageButton:style:align to "center".
  // ~~~ Configuration du bouton ANNULER ~~~
  set cancelButton:style:hstretch to true.
  set cancelButton:style:align to "center".

  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  // -- AFFICHAGE D'UNE FENÊTRE DE WARNING EN CAS D'UN HAUT TWR
  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  if suggestedVpitch + 15 < 0 {
    warningTWR().
  }

  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  // -- AFFICHAGE DE LA FENÊTRE JUSQU'À OBTENIR UN DÉCLENCHEUR DE FERMETURE
  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  globalWindow:show().

  until windowIsClosed {
    if changeLanguageButton:takePress {
      selectLanguage(true).
    }
    if (finalVpitch < 0) {
      set GTcircAutoButton:enabled to false.
      set GTAutoButton:enabled to false.
    }
    else {
      set GTcircAutoButton:enabled to true.
      set GTAutoButton:enabled to true.
    }
    if (vPitchField:text = "") or (ampField:text = "") or (apoapsisField:text = "") {
      set GTCircManualButton:enabled to false.
      set GTManualButton:enabled to false.
    }
    else {
      set GTCircManualButton:enabled to true.
      set GTManualButton:enabled to true.
    }

    if cancelButton:takePress {
      set isCancelled to true.
      set windowIsClosed to true.
    }

    if GTcircAutoButton:takePress {
      set doCirc to true.
      set windowIsClosed to true.
    }

    if GTAutoButton:takePress {
      set doCirc to false.
      set windowIsClosed to true.
    }

    if GTManualButton:takePress {
      set finalAmp to ampField:text:toNumber(-1).
        if finalAmp < 0 {set finalAmp to 0.}
        if finalAmp > 90 {set finalAmp to 90.}
      set finalVpitch to vPitchField:text:toNumber(-1).
        if finalVpitch < 0 {set finalVpitch to 0.}
      set apoCible to apoapsisField:text:toNumber(-1).
        if apoCible < 75_000 {set apoCible to 75_000.}
      set doCirc to false.
      set windowIsClosed to true.
    }

    if GTCircManualButton:takePress {
      set finalAmp to ampField:text:toNumber(-1).
        if finalAmp < 0 {set finalAmp to 0.}
        if finalAmp > 90 {set finalAmp to 90.}
      set finalVpitch to vPitchField:text:toNumber(-1).
        if finalVpitch < 0 {set finalVpitch to 0.}
      set apoCible to apoapsisField:text:toNumber(-1).
        if apoCible < 75_000 {set apoCible to 75_000.}
      set doCirc to true.
      set windowIsClosed to true.
    }

    if dakiButton:takePress {
      globalWindow:dispose().
      launchOptiGT().
    }
  }

  // ~~~ La fenêtre est supprimée dès que l'utilisateur a fait un choix
  globalWindow:dispose().
}

//**********************************************************
//--- Fonction de Warning pour les TWR trop elevés
//__________________________________________________________
function warningTWR {
  local warningTWRWindow is GUI(350).
  local warningIsUnderstood to false.
  set warningTWRWindow:y to 250.
  set warningTWRWindow:skin:font to "Consolas".
  set warningTWRWindow:skin:label:align to "center".
  local LabelOne is warningTWRWindow:addLabel(DIC_warningTWR_popup_title).
    set LabelOne:style:hstretch to true.
    set LabelOne:style:align to "center".
    set LabelOne:style:fontSize to 20.
    set LabelOne:style:textcolor to red.
  warningTWRWindow:addSpacing(25).
  local LabelTwo is warningTWRWindow:addLabel(DIC_warningTWR_popup_info_one).
    set LabelTwo:style:hstretch to true.
    set LabelTwo:style:align to "left".
    set LabelTwo:style:fontSize to 14.
  warningTWRWindow:addSpacing(25).
  local LabelThree is warningTWRWindow:addLabel(DIC_warningTWR_popup_info_two).
    set LabelThree:style:hstretch to true.
    set LabelThree:style:align to "left".
    set LabelThree:style:fontSize to 14.
  warningTWRWindow:addSpacing(25).
  local understoodWarningTWRButton is warningTWRWindow:addButton(DIC_warningTWR_popup_button_text).
    set understoodWarningTWRButton:style:hstretch to true.
    set understoodWarningTWRButton:style:align to "center".
    set understoodWarningTWRButton:style:fontSize to 15.
    
  warningTWRWindow:show().
  until warningIsUnderstood {
    if understoodWarningTWRButton:takePress {
      set warningIsUnderstood to true.
    }
  }
  warningTWRWindow:dispose().
}

