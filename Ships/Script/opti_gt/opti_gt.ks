//**********************************************************
//--- SCRIPT DE PHILIPPEDS - v 1.1.0 - 20 mai 2021
//--- https://github.com/PhilouDS
//--- Youtube : https://www.youtube.com/channel/UCgg7oLP24nMZgv4eCK6UjGQ

global scriptVersion is "1.1.0".
global readFileFolder is "opti_gt/".
global dir is "0:/".
global mainFolder is dir + readFileFolder.
global libFolder is mainFolder + "library/".
global locFolder is mainFolder + "localization/".
global nameTempFolder is "temp_opti_gt/".
global tempFolder is mainFolder + nameTempFolder.
global recapNameFile to " ".

//--- Sur une idée de DAKITESS
//--- Kerbal Space Challenge : https://kerbalspacechallenge.fr/
//__________________________________________________________

//--- Chargement des librairies
runOncePath(libFolder + "lib_language").
runOncePath(libFolder + "lib_variables").
runOncePath(libFolder + "lib_parameter_window").
runOncePath(libFolder + "lib_launch_opti_gt").
runOncePath(libFolder + "lib_do_flight").
runOncePath(libFolder + "lib_record_status").

selectLanguage().

//--- Initialisation du craft
wait until ship:unpacked.
if core:version:minor >= 3 {set Config:suppressAutoPilot to false.}
set terminal:width to 45.
set terminal:height to 60.
clearScreen.
core:part:getmodule("kosProcessor"):doEvent("open terminal").

for part in ship:parts {
  if part:hasModule("ModuleProceduralFairing") {
    set part:tag to DIC_fairing_TAG.
  }
}

// ~~~ compte le nombre de sépatrons
global numberOfSepatrons is ship:partsDubbed("sepMotor1"):length.
global solidInSepatrons is numberOfSepatrons * 8.

global doCirc is false. //-> pour savoir si une manoeuvre de circularisation est créée ou non.
global isCancelled is false. //-> pour savoir si le script est quitté ou non.
global doOptiGT is exists(tempFolder + "doing_opti_gt"). //-> pour savoir si un GT Opti est en cours.

if not isCancelled {
  defineGlobalVariables().

  if not doOptiGT {
    openParameter().

    if not isCancelled {    
      clearScreen.
      print DIC_normal_flight_suggested_amp_print_title + suggestedAmp + DIC_angle_unit.
      print DIC_normal_flight_selected_amp_print_title + finalAmp + DIC_angle_unit.
      print " ".
      print DIC_normal_flight_suggested_vPitch_print_title + round(initialSuggestedVpitch, 3) + DIC_velocity_unit.
      print DIC_normal_flight_selected_vPitch_print_title + round(finalVpitch, 3) + DIC_velocity_unit.
      print " ".
      print DIC_normal_flight_target_altitude_print_title + apoCible + DIC_length_unit.
      print " ".

      doFlight(finalAmp, finalVpitch).
    }
  }
  else {
    launchOptiGT().
  }
}

set ship:control:pilotMainThrottle to 0.