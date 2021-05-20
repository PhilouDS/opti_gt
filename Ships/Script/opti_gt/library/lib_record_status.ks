runOncePath(libFolder + "lib_variables").
//**********************************************************
//--- Fonction qui relance un vol après un échec ou un succès
//__________________________________________________________
global function declareStatus {
  parameter str.
  parameter deltaTime is 3.
  local chrono is time:seconds + deltaTime.
  if doOptiGT {
    relaunchBox:show().
  }
  until time:seconds > chrono {
    print str + DIC_flight_status_newLaunch_text + round(chrono - time:seconds,1) + " " + DIC_second_unit + "  " at (0, terminal:height - 1).
    if doOptiGT {
      set countRelaunch:text to round(chrono - time:seconds,1) + " " + DIC_second_unit.
    }
  }
  kUniverse:reverttolaunch().
}

//**********************************************************
//--- Fonction qui actualise le fichier temporaire entre chaque vol de la simulation GT OPIT
//__________________________________________________________
global function actualiseDataFile {
  parameter str.
  dataList:add(round(ship:orbit:apoapsis,2)).
  dataList:add(str).
  wait 0.1.
  dataList:add(numFlight).
  wait 0.1.
  if newVpitch = 0 and str = "S" {
    dataList:add("M").
  }
  else {
    dataList:add("N").
  }
  log dataList[dataFile_startTime_index] + ";" +
    dataList[dataFile_Amp_Index] + ";" +
    dataList[dataFile_OldDelta_Index] + ";" +
    dataList[dataFile_NewDelta_Index] + ";" +
    dataList[dataFile_NewVpitch_Index] + ";" +
    dataList[dataFile_MinVpitch_Index] + ";" +
    dataList[dataFile_MaxVpitch_Index] + ";" +
    dataList[dataFile_Apoapsis_Index] + ";" +
    dataList[dataFile_Result_Index] + ";" +
    dataList[dataFile_NumFlight_Index] + ";" +
    dataList[dataFile_NewAmp_Index] to dataFile.
  log kUniverse:realTime to endTimeFlightFile.
}

//**********************************************************
//--- Fonction pour diminuer l'amplitude lorsque 0 m/s est un succès
//__________________________________________________________
global function decreasingAmp {
  //deletePath(dataFile).
  //log DIC_data_file_first_line to dataFile.
  set suggestedAmp to suggestedAmp - 5.
  if suggestedAmp <= 60 {
    finalFile().
  }
  set oldDelta to 0.
  set newDelta to deltaScale.
  set equation to equationLexicon[suggestedAmp].
  set initialSuggestedVpitch to equation(TWR).
  set newVpitch to choose 0 if initialSuggestedVpitch < 0 else initialSuggestedVpitch.
  set minVpitch to goodLine[dataFile_MinVpitch_Index]:toNumber.
  set maxVpitch to goodLine[dataFile_MaxVpitch_Index]:toNumber.
  set lastResult to "F".
  set numFlight to goodLine[dataFile_NumFlight_Index].
  
  log kUniverse:realTime + ";" +
    suggestedAmp + ";" + oldDelta + ";" + newDelta + ";" +
    newVpitch + ";" + minVpitch + ";" + maxVpitch + ";" + ship:orbit:apoapsis + ";" +
    lastResult + ";" + numFlight + ";P" to dataFile.
  
  set readFile to addons:file:readAllLines(readFileFolder + nameTempFolder + dataFileName).
  set L to readFile:length - 1.

  set allLinesList to list().
  for line in readFile {
    local dataLine is line:split(";").
    allLinesList:add(dataLine).
  }
  set goodLine to allLinesList[L].
  set changeAmp to true.
}

//**********************************************************
//--- Fonction pour augmenter l'amplitude en cas d'échec rapide
//__________________________________________________________
global function increasingAmp {
  //core:part:getmodule("kosProcessor"):doEvent("open terminal").
  createDir(tempFolder + "amp_already_increased_once").
  local altitudeFailure is ship:altitude.
  local tempPitch is newVpitch + 1.7 * (20000*planetScale - altitudeFailure) / 1000.
  set newAmp to suggestedAmp + 5 * floor(tempPitch / 10).
  set suggestedAmp to choose 85 if newAmp > 85 else newAmp.
  until tempPitch < 1000 {
    set tempPitch to tempPitch - 1000.
  }
  until tempPitch < 100 {
    set tempPitch to tempPitch - 100.
  }
  until tempPitch < 10 {
    set tempPitch to tempPitch - 10.
  }
  set newVpitch to choose tempPitch if newAmp <= 85 else tempPitch + abs(85 - newAmp).
  set newVpitch to newVpitch - deltaScale.
  set oldDelta to 0.
  set newDelta to deltaScale.
  set minVpitch to choose goodLine[dataFile_MinVpitch_Index]:toNumber if goodLine:length <> 0 else 1000.
  set maxVpitch to choose goodLine[dataFile_MaxVpitch_Index]:toNumber if goodLine:length <> 0 else -1.
  set lastResult to "F".
  set numFlight to choose goodLine[dataFile_NumFlight_Index] if goodLine:length <> 0 else 1.

  log kUniverse:realTime + ";" +
    suggestedAmp + ";" + oldDelta + ";" + newDelta + ";" +
    newVpitch + ";" + minVpitch + ";" + maxVpitch + ";" + ship:orbit:apoapsis + ";" +
    lastResult + ";" + numFlight + ";P" to dataFile.
  log kUniverse:realtime to endTimeFlightFile.
  declareStatus(DIC_flight_status_failure).
}

//**********************************************************
//--- Fenêtre pour commencer une nouvelle simulation avec le même craft
//__________________________________________________________
global function askNewSimulation {
  local simWindowWidth is 350.
  local newSimWindowIsClosed is false.
  local newSimWindow is gui(simWindowWidth).
  set newSimWindow:y to 100.
  newSimWindow:addLabel(DIC_new_sim_window_info).

  newSimWindow:addSpacing(10).

  local shipFile is addons:file:readAllLines(readFileFolder + nameTempFolder + ship_name_file).
  local otherShipName is shipFile[0].
  local otherShipTime is findRealDate(shipFile[1]:toNumber).
  local otherShipAmp is suggestedAmp + DIC_angle_unit.
  local otherShipVpitch is round(newVpitch, 3) + DIC_velocity_unit.
  local otherShipReadFile is addons:file:readAllLines(readFileFolder + nameTempFolder + dataFileName).
  local otherShipL is otherShipReadFile:length - 1.
  if otherShipL > 0 {
    local otherShipLineList is list().
    for line in otherShipReadFile {
      local dataLine is line:split(";").
      otherShipLineList:add(dataLine).
    }
    local otherShipGoodLine is otherShipLineList[otherShipL].
    set otherShipTime to findRealDate(otherShipGoodLine[dataFile_startTime_index]:toNumber).
    set otherShipAmp to otherShipGoodLine[dataFile_Amp_Index] + DIC_angle_unit.
    set otherShipVpitch to round(otherShipGoodLine[dataFile_NewVpitch_Index]:toNumber, 3) + DIC_velocity_unit.
  }

  local lastSimInfoWindow is newSimWindow:addVbox().

  newSimWindow:addSpacing(10).

  newSimWindow:addLabel(DIC_new_sim_window_info_question).
  
  newSimWindow:addSpacing(10).

  local newSimWindowButtonBox is newSimWindow:addHlayout.
  local changeButton is newSimWindowButtonBox:addButton(DIC_new_sim_window_button_change_text).
    set changeButton:style:width to simWindowWidth/2.
    set changeButton:style:hstretch to true.
    set changeButton:style:align to "center".
  local keepButton is newSimWindowButtonBox:addButton(DIC_new_sim_window_button_keep_text).
    set keepButton:style:width to simWindowWidth/2.
    set keepButton:style:hstretch to true.
    set keepButton:style:align to "center".

  addInfoLine(DIC_new_sim_window_info_craft_name, otherShipName).
  addInfoLine(DIC_new_sim_window_info_date, otherShipTime[0]).
  addInfoLine(DIC_new_sim_window_info_time, otherShipTime[1]).
  addInfoLine(DIC_new_sim_window_info_Amp, otherShipAmp).
  addInfoLine(DIC_new_sim_window_info_vPitch, otherShipVpitch).

  newSimWindow:show().

  until newSimWindowIsClosed {
    if keepButton:takePress {
      deletePath(mainFolder + "temp_opti_gt").
      kUniverse:revertToLaunch().
    }
    if changeButton:takePress {
      kUniverse:revertToEditor().
    }
  }

  function addInfoLine {
    parameter txt, value.
    local horizontalBox is lastSimInfoWindow:addHLayout.
    set horizontalBox:style:width to simWindowWidth.
    local hLabelOne is horizontalBox:addLabel(txt).
      set hLabelOne:style:width to simWindowWidth/2.
      set hLabelOne:style:hstretch to true.
      set hLabelOne:style:align to "right".
    local hLabelTwo is horizontalBox:addLabel(value).
      set hLabelTwo:style:width to simWindowWidth/2.
      set hLabelTwo:style:hstretch to true.
      set hLabelTwo:style:align to "left".
    return horizontalBox.
  }
}

//**********************************************************
//--- Fenêtre pour choisir d'annuler ou de reprendre une simulation
//__________________________________________________________
global function askResetSimulation {
  local simWindowWidth is 300.
  local newSimWindowIsClosed is false.
  local newSimWindow is gui(simWindowWidth).
  set newSimWindow:y to 100.
  newSimWindow:addLabel(DIC_reset_sim_window_info).

  newSimWindow:addSpacing(10).

  local shipFile is addons:file:readAllLines(readFileFolder + nameTempFolder + ship_name_file).
  local thisShipTime is findRealDate(shipFile[1]:toNumber).
  local thisShipAmp is suggestedAmp + DIC_angle_unit.
  local thisShipVpitch is round(newVpitch, 3) + DIC_velocity_unit.
  local thisShipReadFile is addons:file:readAllLines(readFileFolder + nameTempFolder + dataFileName).
  local thisShipL is thisShipReadFile:length - 1.
  if thisShipL > 0 {
    local thisShipLineList is list().
    for line in thisShipReadFile {
      local dataLine is line:split(";").
      thisShipLineList:add(dataLine).
    }
    local thisShipGoodLine is thisShipLineList[thisShipL].
    set thisShipTime to findRealDate(thisShipGoodLine[dataFile_startTime_index]:toNumber).
    set thisShipAmp to thisShipGoodLine[dataFile_Amp_Index] + DIC_angle_unit.
    set thisShipVpitch to round(thisShipGoodLine[dataFile_NewVpitch_Index]:toNumber,3) + DIC_velocity_unit.
  }

  local lastSimInfoWindow is newSimWindow:addVbox().

  newSimWindow:addSpacing(10).

  newSimWindow:addLabel(DIC_reset_sim_window_info_question).
  
  newSimWindow:addSpacing(10).

  local newSimWindowButtonBox is newSimWindow:addHlayout.
  local continueButton is newSimWindowButtonBox:addButton(DIC_reset_sim_window_button_continue_text).
    set continueButton:style:width to simWindowWidth/2.
    set continueButton:style:hstretch to true.
    set continueButton:style:align to "center".
  local newButton is newSimWindowButtonBox:addButton(DIC_reset_sim_window_button_new_text).
    set newButton:style:width to simWindowWidth/2.
    set newButton:style:hstretch to true.
    set newButton:style:align to "center".

  addInfoLine(DIC_reset_sim_window_info_date, thisShipTime[0]).
  addInfoLine(DIC_reset_sim_window_info_time, thisShipTime[1]).
  addInfoLine(DIC_reset_sim_window_info_Amp, thisShipAmp).
  addInfoLine(DIC_reset_sim_window_info_vPitch, thisShipVpitch).

  newSimWindow:show().

  until newSimWindowIsClosed {
    if newButton:takePress {
      deletePath(mainFolder + "temp_opti_gt").
      kUniverse:revertToLaunch().
    }
    if continueButton:takePress {
      log kUniverse:realtime to mainFolder + nameTempFolder + endTimeFlightFileName.
      wait 0.1.
      kUniverse:revertToLaunch().
    }
  }

  function addInfoLine {
    parameter txt, value.
    local horizontalBox is lastSimInfoWindow:addHLayout.
    set horizontalBox:style:width to simWindowWidth.
    local hLabelOne is horizontalBox:addLabel(txt).
      set hLabelOne:style:width to simWindowWidth/2.
      set hLabelOne:style:hstretch to true.
      set hLabelOne:style:align to "right".
    local hLabelTwo is horizontalBox:addLabel(value).
      set hLabelTwo:style:width to simWindowWidth/2.
      set hLabelTwo:style:hstretch to true.
      set hLabelTwo:style:align to "left".
    return horizontalBox.
  }
}

//**********************************************************
//--- Fonction qui actualise le fichier RUD en cas d'explosion
//__________________________________________________________
global function actualiseRudFile {
  local stopMission is time(missionTime):clock.
  local realTime is findRealDate().
  local rudVelocity is choose ship:velocity:surface:mag if navMode = "surface" else ship:velocity:orbit:mag.
  log realTime[0] + ";" + realTime[1] + ";" + ship:name + ";" + suggestedAmp + ";" + round(newVpitch, 0) + ";" + round(ship:altitude, 0) + ";" + round(rudVelocity,1) + ";" + stopMission to (rudFile).
}

//**********************************************************
//--- Fonction qui calcule la date réelle actuelle à partir du temps UNIX
//__________________________________________________________
global function findRealDate {
  parameter T is floor(kUniverse:realTime).
  parameter separator is "/".
  local realTime is list().
  local daysPerMonth is list(31,28,31,30,31,30,31,31,30,31,30,31).
  local currentYear is 1970.
  local secondsPerDay is 24 * 60 * 60.
  local GMT is 2.
  set T to T + GMT * 60 * 60.
  local elapsedDays is floor(T / (secondsPerDay)).
  local remainingSeconds is floor(mod(T, secondsPerDay)).
  local index is 0.
  local date is 0.
  local month is 0.
  local hours is 0.
  local minutes is 0.
  local seconds is 0.
  local bissextile is 0.

  // Calculating current year
  until elapsedDays < 365 {
    if (mod(currentYear, 400) = 0) or (mod(currentYear, 4) = 0 and mod(currentYear, 100) <> 0) {
      set elapsedDays to elapsedDays - 366.
    }
    else {
      set elapsedDays to elapsedDays - 365.
    }
    set currentYear to currentYear + 1.
  }

  set elapsedDays to elapsedDays + 1.

  if (mod(currentYear, 400) = 0) or (mod(currentYear, 4) = 0 and mod(currentYear, 100) <> 0) {
    set bissextile to 1.
  }

  // Calculating MONTH and DATE
  if bissextile = 1 {
    until false {
      if index = 1 {
        if elapsedDays - 29 < 0 {
          break.
        }
        set elapsedDays to elapsedDays - 29.
      }
      else {
        if elapsedDays - daysPerMonth[index] < 0 {
          break.
        }
        set elapsedDays to elapsedDays - daysPerMonth[index].
      }
      set month to month + 1.
      set index to index + 1.
    }
  }
  else {
    until false {
      if elapsedDays - daysPerMonth[index] < 0 {
        break.
      }
      set month to month + 1.
      set elapsedDays to elapsedDays - daysPerMonth[index].
      set index to index + 1.
    }
  }

  // current month

  if elapsedDays > 0 {
    set month to month +  1.
    set date to elapsedDays.
  }
  else {
    if month = 2 and bissextile = 1 {
      set date to 29.
    }
    else {
      set date to daysPerMonth[month - 1].
    }
  }
  
  if date < 10 {set date to "0" + date.}
  if month < 10 {set month to "0" + month.}
  set realDate to date + separator + month + separator + currentYear.
  realTime:add(realDate).

  set hours to floor(remainingSeconds / 3600).
  if hours < 10 {set hours to "0" + hours.}
  set minutes to floor(mod(remainingSeconds, 3600) / 60).
  if minutes < 10 {set minutes to "0" + minutes.}
  set seconds to floor(mod(mod(remainingSeconds, 3600), 60)).
  if seconds < 10 {set seconds to "0" + seconds.}

  set realHour to hours + DIC_hour_unit + minutes + DIC_minute_unit + seconds + DIC_second_unit.
  realTime:add(realHour).
  return realTime.
}
