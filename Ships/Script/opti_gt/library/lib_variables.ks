function defineGlobalVariables {
  global dataList is list().
  global windowIsClosed is false.
  global doingOptiWindow is GUI(200).
  global abortWindow is GUI(200).
  global proPopupWindow is GUI(200).
  global totalMass is ship:mass.
  global liquidFuelAmount is 0.
  global solidFuelAmount is 0.
  global ratio is 0.
  global TWR is calculTWR(). //-> cf fonction calculTWR ci-après 

  // /!\ l'apoCible est un indicateur pour terminer le Gravity Turn, 
  // il ne s'agit pas de l'apoapsis de l'orbite après circularisation
  global apoCible is 100_000.

  // ~ variables pour AMP
  global suggestedAmp is 0.
  global ampLexicon is lexicon().
  global listAmpButton is list().

  // ~ variables pour les équations de régressions dépendant de AMP
  global equationLexicon is lexicon().
    equationLexicon:add(85, equation85@).
    equationLexicon:add(80, equation80@).
    equationLexicon:add(75, equation75@).
    equationLexicon:add(70, equation70@).
    equationLexicon:add(65, equation65@).
  set equation to equation85@. //-> les différentes équations sont définies à la fin du script

  // ~ variables pour vPitch
  global initialSuggestedVpitch is 0.
  global suggestedVpitch is 0.
  global pitchLexicon is lexicon().
  global listPitchButton is list().

  // ~~~ On suggère une amplitude en fonction du TWR initial
  // ~~~ puis on détermine l'équation en fonction de l'amplitude initiale
  if TWR < 1.7 {
    set suggestedAmp to 85.
  }
  else {
    if TWR < 1.8 {
      set suggestedAmp to 80.
    }
    else {
      if TWR < 1.9 {
        set suggestedAmp to 75.
      }
      else {
        set suggestedAmp to 65.
      }
    }
  }
  set equation to equationLexicon[suggestedAmp].
  // ~~~ L'amplitude finale à utiliser pour le vol est initialisée sur l'amplitude suggérée
  global finalAmp is suggestedAmp.

  // ~~~ Calcul de la vitesse initial en fonction de l'amplitude et du TWR
  set initialSuggestedVpitch to equation(TWR).

  for res in ship:resources {
    if res:name = "liquidFuel" {set liquidFuelAmount to res:amount.}
    if res:name = "solidFuel" {set solidFuelAmount to res:amount - numberOfSepatrons * 8.}
  }
  set ratio to solidFuelAmount / liquidFuelAmount.
  if ratio > 1 {set ratio to 1.}

  set initialSuggestedVpitch to initialSuggestedVpitch + (1 - ratio) * 10.
  set suggestedVpitch to initialSuggestedVpitch.
  
  global finalVpitch is suggestedVpitch + 8.
}


//**********************************************************
//--- Fonction pour calculer le TWR au niveau du pas de tir
//__________________________________________________________
function calculTWR {
  //--- masse totale :
  set totalMass to ship:mass.
  local stageClamp is 1.
  //--- on retire la masse des rampes de lancement :
  for prt in ship:partsDubbed("launchClamp1") {
    set totalMass to totalMass - prt:mass.
  }

  if ship:partsDubbed("launchClamp1"):length > 0 {
    set stageClamp to ship:stagenum - ship:partsDubbed("launchClamp1")[0]:stage.
  }

  //--- on récupère de tous les moteurs déclenchés avant les rampes de lancement
  list ENGINES in engineList.
  local firstStageEngine is list().
  for en in engineList {
    if en:stage >= ship:stagenum - stageClamp {firstStageEngine:add(en).}
  }

  set wantedThrust to 0.
  for en in firstStageEngine {
    set wantedThrust to wantedThrust + en:possibleThrust.
  }

  //--- on calcule la gravité (le ship:altitude n'est pas utile au niveau du pas de tir)
  set g_here to body:mu / ((body:radius + ship:altitude)^2).
  //--- on renvoit le TWR
  return wantedThrust / (totalMass*g_here).
}


//**********************************************************
//--- Les différentes équations de régression polynomiale
//--- déterminer à partir de centaines de tests.
//__________________________________________________________
// ~~~ pour une amplitude de 85° ~~~
function equation85 {
  parameter x.
  set finalAmp to 85.
  return 42.857 * x^2 - 210 * x + 232.34.
}
// ~~~ pour une amplitude de 80° ~~~
function equation80 {
  parameter x.
  set finalAmp to 80.
  return 50 * x^2 - 249.57 * x + 287.63.
}
// ~~~ pour une amplitude de 75° ~~~
function equation75 {
  parameter x.
  set finalAmp to 75.
  return 35.714 * x^2 - 223.57 * x + 292.71.
}
// ~~~ pour une amplitude de 70° ~~~
function equation70 {
  parameter x.
  set finalAmp to 70.
  return 40.476 * x^2 - 255 * x + 340.1.
}
// ~~~ pour une amplitude de 65° ~~~
function equation65 {
  parameter x.
  set finalAmp to 65.
  return 32.143 * x^2 - 249.4 * x + 364.42.
}

//**********************************************************
//--- Fonction pour la fenêtre d'annulation d'un vol
//__________________________________________________________
function abortPopup {
  set abortWindow:y to 50.
  set abortWindow:x to -600.
  set abortWindow:skin:font to "Consolas".
  set abortWindow:skin:label:align to "center".
  local LabelOne is abortWindow:addLabel(DIC_abort_popup_title).
    set LabelOne:style:hstretch to true.
    set LabelOne:style:align to "center".
    set LabelOne:style:fontSize to 12.
    set LabelOne:style:textcolor to red.
  abortWindow:addSpacing(10).
  local LabelTwo is abortWindow:addLabel(DIC_abort_popup_info).
    set LabelTwo:style:hstretch to true.
    set LabelTwo:style:align to "left".
    set LabelTwo:style:fontSize to 10.
  abortWindow:addSpacing(15).
  global abortButton is abortWindow:addButton(DIC_abort_popup_button_text).
    set abortButton:style:hstretch to true.
    set abortButton:style:align to "center".
    set abortButton:style:fontSize to 15.
    
  abortWindow:show().
}

//**********************************************************
//--- Fenêtre pour les pro du GT (permet de raccourcir la simulation)
//__________________________________________________________
function proPopup {
  set proPopupWindow:y to 50.
  set proPopupWindow:x to -350.
  set proPopupWindow:skin:font to "Consolas".
  set abortWindow:skin:label:align to "center".
  local title is proPopupWindow:addLabel(DIC_pro_popup_title).
    set title:style:hstretch to true.
    set title:style:align to "center".
    set title:style:fontSize to 12.
    set title:style:textcolor to red.
  proPopupWindow:addSpacing(15).
  local labelButtonSuccess is proPopupWindow:addLabel(DIC_pro_popup_success_text).
    set labelButtonSuccess:style:hstretch to true.
    set labelButtonSuccess:style:align to "left".
    set labelButtonSuccess:style:fontSize to 10.
  proPopupWindow:addSpacing(5).
  global proButtonSuccess is proPopupWindow:addButton(DIC_pro_popup_success_button).
    set proButtonSuccess:style:hstretch to true.
    set proButtonSuccess:style:align to "center".
    set proButtonSuccess:style:fontSize to 12.
  proPopupWindow:addSpacing(15).
  local labelButtonFailure is proPopupWindow:addLabel(DIC_pro_popup_failure_text).
    set labelButtonFailure:style:hstretch to true.
    set labelButtonFailure:style:align to "left".
    set labelButtonFailure:style:fontSize to 10.
  proPopupWindow:addSpacing(5).
  global proButtonFailure is proPopupWindow:addButton(DIC_pro_popup_failure_button).
    set proButtonFailure:style:hstretch to true.
    set proButtonFailure:style:align to "center".
    set proButtonFailure:style:fontSize to 12.
  
  proPopupWindow:addSpacing(15).
  local labelButtonStage is proPopupWindow:addLabel(DIC_pro_popup_staging_text).
    set labelButtonStage:style:hstretch to true.
    set labelButtonStage:style:align to "left".
    set labelButtonStage:style:fontSize to 10.
  proPopupWindow:addSpacing(5).
  global proButtonStage is proPopupWindow:addButton(DIC_pro_popup_staging_button).
    set proButtonStage:style:hstretch to true.
    set proButtonStage:style:align to "center".
    set proButtonStage:style:fontSize to 12.
    
  proPopupWindow:show().
}