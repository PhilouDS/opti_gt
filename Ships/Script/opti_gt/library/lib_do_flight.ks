runOncePath(libFolder + "lib_maneuvers").
runOncePath(libFolder + "lib_record_status").

function doFlight {
  parameter amp. // amplitude
  parameter vp. // vPitch
  

  // ~~~ on décolle à la verticale ~~~
  lock steering to heading(90,90) + R(0,0,myRoll()).
  lock throttle to 1.
  sas off.

  // ~~~ décollage ~~~
  until ship:partsDubbed("launchClamp1"):length = 0 {
    stage.
    wait until stage:ready.
    wait 0.1.
  }

  local atmoEngine is list().
  list ENGINES in myEngineList.
  for eng in myEngineList {
    if eng:multimode and eng:stage = ship:stageNum {
      atmoEngine:add(eng).
    }
  }

  abortPopup().

  local sepatronsFuelAmount is searchSepatronsFuelAmount().

  if doOptiGT {
    proPopup().
    when proButtonFailure:takePress then {
      actualiseDataFile("F").
      declareStatus(DIC_flight_status_failure).
    }
    when proButtonSuccess:takePress then {
      actualiseDataFile("S").
      declareStatus(DIC_flight_status_success).
    }
    when proButtonStage:takePress then {
      lock throttle to 0.
      wait 0.1.
      wait until stage:ready.
      stage.
      wait 0.1.
      lock throttle to 1.
      wait 0.1.
      set hasStaged to true.
      set oldThrust to ship:availableThrust. 
    }
  }

  local numberOfParts is ship:parts:length.
  local hasStaged is false.

  // ~~~ condition pour le découplage ~~~
  set oldThrust to ship:availableThrust.
  when ship:availablethrust < oldThrust - 10 or
     (stage:resourcesLex["LiquidFuel"]:amount <= 0 and
         (stage:resourcesLex["SolidFuel"]:amount - sepatronsFuelAmount) <= 0 and
         stage:resourcesLex["oxidizer"]:amount <= 0)
  then {
    local atmo is false.
    wait 0.1.
    if atmoEngine:length > 0 {
      set atmo to true.
      set oldThrust to ship:availableThrust.
      if oldThrust <= 5 {
        set atmo to false.
      }      
    }
    if not atmo {
      until false {
        wait until stage:ready.
        stage.
        wait 0.1.
        if ship:availableThrust > 0 { 
          set hasStaged to true.
          list ENGINES in myEngineList.
          atmoEngine:clear().
          for eng in myEngineList {
            if eng:multimode and eng:stage = ship:stageNum {
              atmoEngine:add(eng).
            }
          }
          break.
        }
      }
    }
    
    set oldThrust to ship:availablethrust.
    set sepatronsFuelAmount to searchSepatronsFuelAmount().
    return (stage:nextDecoupler <> "None").// and stage:nextDecoupler:stage <> 0).
  }

  if doOptiGT {
    when ship:altitude > 10_000 then {
      if vANg(up:vector, srfPrograde:vector) < 20 {
        actualiseDataFile("S").
        declareStatus(DIC_flight_status_failure).
      } 
    }
  }

  // ~~~ condition d'échec du vol (le prograde passe sous l'horizon (0.5° de tolérance) avant d'atteindre l'espace) ~~~
  when vANg(up:vector, prograde:vector) > 90.5 then {
    if ship:altitude > 500 and ship:altitude <= 70_000 and ship:status <> "preLaunch" {
      if doOptiGT {
        if not exists(tempFolder + "amp_already_increased_once") and ship:altitude < 20_000 {
          increasingAmp().
        }
        actualiseDataFile("F").
      }
      declareStatus(DIC_flight_status_failure).
    }
  }

  // ~~~ condition de surchauffe : le vaisseau perd des composants en dehors d'un staging ~~~
  when ship:parts:length < numberOfParts then {
    if ship:altitude < 70_000 {
      if (hasStaged = false or ship:deltaV = 0) and ship:status <> "preLaunch" {
        if doOptiGT {
          actualiseDataFile("F").
          actualiseRudFile().
        }
        declareStatus(DIC_flight_status_failure, -0.1).
      }
      else {
        set numberOfParts to ship:parts:length.
        set actualStage to ship:stageNum.
        set hasStaged to false.
      }
      preserve.
    }
  }

  when abortButton:takePress then {
    if doOptiGT {
      actualiseDataFile("F").
      actualiseRudFile().
    }
    declareStatus(DIC_flight_status_failure, -0.1).
  }

  // ~~~ condition de déploiement de la coiffe ~~~
  when ship:altitude >= 70_000 then {
    rcs on.
    for part in ship:partsTagged(DIC_fairing_TAG) {
      if part:hasModule("ModuleProceduralFairing") {
        if part:getModule("ModuleProceduralFairing"):hasEvent(DIC_fairing_EVENT) {
          part:getModule("ModuleProceduralFairing"):doEvent(DIC_fairing_EVENT).
        }
      }
    }
  }

  // ~~~ Le gravity turn débute en fonction de la vPitch finalement choisie ~~~
  wait until ship:velocity:surface:mag >= vp.
  gravityTurn(apoCible, amp). //-> cf fonction gravityTurn dans lib_maneuvers.ks

  // ~~~ Une fois le gravity Turn terminé, on attend d'atteindre l'espace ~~~
  wait until ship:altitude > 70_000.
  wait 0.1.
  set kUniverse:timeWarp:mode to "RAILS".
  wait 0.1.

  if doCirc = true { //-> L'utilisateur utilise le script pour circulariser
    // ~~~ Ajout du noeud de manoeuvre pour circulariser l'orbite ~~~
    wait 1.
    for prt in ship:parts {
      if prt:hasModule("ModuleDeployableAntenna") {
        prt:getModule("ModuleDeployableAntenna"):doEvent(DIC_antenna_EVENT).
      }
    }
    panels on.
    wait 1.
    circularisation("Ap"). //-> cf fonction circularisation ci-après
    // ~~~ Exécution du noeud de manoeuvre (le script attend évidemment le bon moment) ~~~
    wait 1.
    executerManoeuvre(). //-> cf fonction exeMnv ci-après
    wait 1.
    // ~~~ Procédures finales et affichage des caractéristiques de l'orbite ~~~
    lock steering to prograde.
    clearScreen.
    printOrbit().
    unlock steering.
    sas on.
    rcs off.
    wait 0.1.
    set SASmode to "prograde".
    wait 0.5.
    set ship:control:pilotmainthrottle to 0.
    // ~~~ Fermeture du terminal ~~~
    core:part:getmodule("kosProcessor"):doEvent("close terminal").

    //**********************************************************
    //--- FIN DU VOL -> le vaisseau devrait être en orbite
    //__________________________________________________________
  }
  else { //-> L'utilisateur utilise son propre script pour circulariser ou le fait à la main.
    if not doOptiGT {
      clearScreen.
      wait 1.
      for prt in ship:parts {
        if prt:hasModule("ModuleDeployableAntenna") {
          prt:getModule("ModuleDeployableAntenna"):doEvent(DIC_antenna_EVENT).
        }
      }
      panels on.
      printSpace().
      // ~~~ Procédures finales et affichage des caractéristiques de l'orbite ~~~
      unlock steering.
      sas on.
      rcs off.
      wait 0.1.
      set SASmode to "prograde".
      wait 0.5.
      set ship:control:pilotmainthrottle to 0.
      // ~~~ Fermeture du terminal ~~~
      core:part:getmodule("kosProcessor"):doEvent("close terminal").
    }
  }
}

//**********************************************************
//--- Fonction qui calcul le montant d'ergol solide dans les
//--- prochains Sépatrons qui seront utilisés.
//__________________________________________________________
function searchSepatronsFuelAmount {
  local result is 0.
  if ship:partsDubbed("sepMotor1"):length = 0 {
    return result.
  }
  else {
    local stageMax is 0.
    for sep in ship:partsDubbed("sepMotor1") {
      if sep:stage > stageMax {
        set stageMax to sep:stage.
      }
    }
    for sep in ship:partsDubbed("sepMotor1") {
      if sep:stage = stageMax {
        set result to result + 8.
      }
    }
    return result.
  }
}

//**********************************************************
//--- Fonction qui affiche les caractéristiques finales de l'orbite
//__________________________________________________________
function printOrbit {
  local orbitDone is false.
  // ~~~ configuration de la fenêtre initiale ~~~
  local orbitWindowWidth is 450.
  local orbitWindow is GUI(orbitWindowWidth).
  set orbitWindow:y to 100.
  set orbitWindow:skin:font to "Consolas".
  set orbitWindow:skin:label:fontsize to 12.
  set orbitWindow:skin:label:hstretch to true.
  set orbitWindow:skin:label:align to "center".

  // ~~~ titre ~~~
  local orbitTitle is orbitWindow:addLabel().
    set orbitTitle:text to DIC_orbit_window_title.
    set orbitTitle:style:fontSize to 20.

  orbitWindow:addSpacing(15).

  local orbitInfo is orbitWindow:addVbox().

  addOrbit(DIC_orbit_window_amp_title, finalAmp, DIC_angle_unit).
  addOrbit(DIC_orbit_window_vPitch_title, round(finalVpitch, 3), DIC_velocity_unit).

  orbitInfo:addSpacing(15).

  // ~~~ caractéristiques de l'orbite
  addOrbit(DIC_orbit_window_APO_name, round(ship:orbit:apoapsis, 2), DIC_length_unit).
  addOrbit(DIC_orbit_window_PE_name, round(ship:orbit:periapsis, 2), DIC_length_unit).
  addOrbit(DIC_orbit_window_ARG_PE_name, round(ship:orbit:argumentofperiapsis, 2), DIC_angle_unit).
  addOrbit(DIC_orbit_window_ECC_name, round(10^4 * ship:orbit:eccentricity, 2), " x 10^(-4)").
  addOrbit(DIC_orbit_window_PERIOD_name, TIME(ship:orbit:period):clock, " ").
  addOrbit(DIC_orbit_window_INC_name, round(ship:orbit:inclination, 3), DIC_angle_unit).
  addOrbit(DIC_orbit_window_LAN_name, round(ship:orbit:longitudeofascendingnode, 2), DIC_angle_unit).

  local function addOrbit {
    parameter txt1, value, txt2.
    parameter motherBox is orbitInfo.
    local horizontalBox is motherBox:addHLayout.
    set horizontalBox:style:width to orbitWindowWidth.
    local hLabelOne is horizontalBox:addLabel().
      set hLabelOne:text to txt1.
      set hLabelOne:style:width to orbitWindowWidth/2.
      set hLabelOne:style:hstretch to true.
      set hLabelOne:style:align to "right".
    local hLabelTwo is horizontalBox:addLabel().
      set hLabelTwo:text to value + txt2.
      set hLabelTwo:style:width to orbitWindowWidth/2.
      set hLabelTwo:style:hstretch to true.
      set hLabelTwo:style:align to "left".
    return horizontalBox.
  }

  orbitWindow:addSpacing(15).

  local orbitButton is orbitWindow:addHlayout().
  orbitButton:addSpacing(orbitWindowWidth/9).
  local continueFlightButton is orbitButton:addButton(DIC_orbit_window_button_continue_name).
  set continueFlightButton:style:width to orbitWindowWidth/3.
  orbitButton:addSpacing(orbitWindowWidth/9).
  local revertLaunchButton is orbitButton:addButton(DIC_orbit_window_button_revert_launch_name).
  set revertLaunchButton:style:width to orbitWindowWidth/3.
  orbitButton:addSpacing(orbitWindowWidth/9).

  orbitWindow:addSpacing(3).

  local infoLabel is orbitWindow:addLabel(DIC_orbit_window_revert_launch_info).
  set infoLabel:style:fontsize to 10.

  // ~~~ Configuration du bouton CONTINUER VOL ~~~
  set continueFlightButton:style:hstretch to true.
  set continueFlightButton:style:align to "center".

  // ~~~ Configuration du bouton RELANCER VOL ~~~
  set revertLaunchButton:style:hstretch to true.
  set revertLaunchButton:style:align to "center".

  orbitWindow:show().
  until orbitDone {
    if continueFlightButton:takePress {
      abortWindow:hide().
      set orbitDone to true.
    }
    if revertLaunchButton:takePress {
      kUniverse:reverttolaunch().
    }
  }
  orbitWindow:dispose().
}

//**********************************************************
//--- Fonction qui affiche que l'espace est atteint (pour le choix GT sans circu)
//__________________________________________________________
function printSpace {
  local spaceDone is false.
  // ~~~ configuration de la fenêtre initiale ~~~
  local spaceWindowWidth is 350.
  local spaceWindow is GUI(spaceWindowWidth).
  set spaceWindow:y to 100.
  set spaceWindow:skin:font to "Consolas".
  set spaceWindow:skin:label:fontsize to 12.
  set spaceWindow:skin:label:hstretch to true.
  set spaceWindow:skin:label:align to "center".

  // ~~~ titre ~~~
  local spaceTitle is spaceWindow:addLabel().
    set spaceTitle:text to DIC_space_window_title.
    set spaceTitle:style:fontSize to 20.

  spaceWindow:addSpacing(15).

  local spaceInfo is spaceWindow:addVbox().

  addSpace(DIC_space_window_amp_title, finalAmp, DIC_angle_unit).
  addSpace(DIC_space_window_vPitch_title, round(finalVpitch, 3), DIC_velocity_unit).

  spaceWindow:addSpacing(15).

  local function addSpace {
    parameter txt1, value, txt2.
    parameter motherBox is spaceInfo.
    local horizontalBox is motherBox:addHLayout.
    set horizontalBox:style:width to spaceWindowWidth.
    local hLabelOne is horizontalBox:addLabel().
      set hLabelOne:text to txt1.
      set hLabelOne:style:width to spaceWindowWidth/2.
      set hLabelOne:style:hstretch to true.
      set hLabelOne:style:align to "right".
    local hLabelTwo is horizontalBox:addLabel().
      set hLabelTwo:text to value + txt2.
      set hLabelTwo:style:width to spaceWindowWidth/2.
      set hLabelTwo:style:hstretch to true.
      set hLabelTwo:style:align to "left".
    return horizontalBox.
  }

  spaceWindow:addSpacing(15).

  local spaceButton is spaceWindow:addHlayout().
  spaceButton:addSpacing(spaceWindowWidth/9).
  local continueFlightButton is spaceButton:addButton(DIC_space_window_button_continue_name).
  set continueFlightButton:style:width to spaceWindowWidth/3.
  spaceButton:addSpacing(spaceWindowWidth/9).
  local revertLaunchButton is spaceButton:addButton(DIC_space_window_button_revert_launch_name).
  set revertLaunchButton:style:width to spaceWindowWidth/3.
  spaceButton:addSpacing(spaceWindowWidth/9).

  spaceWindow:addSpacing(3).

  local spaceInfoLabel is spaceWindow:addLabel(DIC_space_window_revert_launch_info).
  set spaceInfoLabel:style:fontsize to 10.

  // ~~~ Configuration du bouton CONTINUER VOL ~~~
  set continueFlightButton:style:hstretch to true.
  set continueFlightButton:style:align to "center".

  // ~~~ Configuration du bouton RELANCER VOL ~~~
  set revertLaunchButton:style:hstretch to true.
  set revertLaunchButton:style:align to "center".

  spaceWindow:show().
  until spaceDone {
    if continueFlightButton:takePress {
      abortWindow:hide().
      set spaceDone to true.
    }
    if revertLaunchButton:takePress {
      kUniverse:reverttolaunch().
    }
  }
  spaceWindow:dispose().
}

