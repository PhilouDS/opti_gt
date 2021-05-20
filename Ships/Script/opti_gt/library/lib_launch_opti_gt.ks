runOncePath(libFolder + "lib_record_status").
runOncePath(libFolder + "lib_variables").

function launchOptiGT {
  core:part:getmodule("kosProcessor"):doEvent("close terminal").
  set doOptiGT to true.
  local changeAmp is false.
  global dataFileName is "data_gt.csv".
  global dataFile is tempFolder + dataFileName.
  global goodLine is list().
  local allVpitch is list().
  local L is 1.
  set dataList to list().
  dataList:add(kUniverse:realTime).
  local oldDelta is 0.
  local newDelta is deltaScale.
  global newVpitch is choose 0 if initialSuggestedVpitch < 0 else initialSuggestedVpitch.
  local minVpitch is 1_000.
  local maxVpitch is -1.
  global numFlight is 1.
  local lastResult is "".

  global dataFile_startTime_index is 0.
  global dataFile_Amp_Index is 1.
  global dataFile_OldDelta_Index is 2.
  global dataFile_NewDelta_Index is 3.
  global dataFile_NewVpitch_Index is 4.
  global dataFile_MinVpitch_Index is 5.
  global dataFile_MaxVpitch_Index is 6.
  global dataFile_Apoapsis_Index is 7.
  global dataFile_Result_Index is 8.
  global dataFile_NumFlight_Index is 9.
  global dataFile_NewAmp_Index is 10.

  local recapFile is mainFolder + "recap.csv".
  global rudFile is mainFolder + "rud.csv". // RUD = Rapid Unscheduled Disassembly

  global ship_name_file is "ship_name.txt".
  global endTimeFlightFileName is "end_time_flight.txt".
  global endTimeFlightFile is tempFolder + endTimeFlightFileName.

  if not exists(recapFile) {
    log DIC_recap_file_first_line to recapFile.
  }

  if not exists(rudFile) {
    log DIC_rud_file_title to rudFile.
    log DIC_rud_file_first_line to rudFile.
  }

  if not exists(mainFolder + "temp_opti_gt") {
    createDir(mainFolder + "temp_opti_gt").
    createDir(tempFolder + "doing_opti_gt").
    createDir(tempFolder + (ship:name):toLower).
    log ship:name to tempFolder + ship_name_file.
    log kUniverse:realTime to tempFolder + ship_name_file.
    log kUniverse:realtime to tempFolder + "time.txt".
    log kUniverse:realtime to endTimeFlightFile.
  }
  else{
    if not exists(tempFolder + (ship:name):toLower) {
      askNewSimulation().
    }
    else {
      if exists(endTimeFlightFile) {
        local readTimeFile is addons:file:readAllLines(readFileFolder + nameTempFolder + endTimeFlightFileName).
        local previousFlightTime is readTimeFile[readTimeFile:length - 1]:toNumber.
        if abs(previousFlightTime - kUniverse:realTime) > 60 {
          askResetSimulation().
        }
      }
    }
  }

  if not exists(dataFile) {
    log DIC_data_file_first_line to dataFile.
    dataList:add(suggestedAmp).
    dataList:add(oldDelta).
    dataList:add(newDelta).
    dataList:add(newVpitch).
    set minVpitch to newVpitch.
    dataList:add(minVpitch).
    set maxVpitch to newVpitch.
    dataList:add(maxVpitch).
    doingOptiPopup().
  }
  else {
    local readFile is addons:file:readAllLines(readFileFolder + nameTempFolder + dataFileName).
    set L to readFile:length - 1.
    if L = 0 {
      dataList:add(suggestedAmp).
      dataList:add(oldDelta).
      dataList:add(newDelta).
      dataList:add(newVpitch).
      set minVpitch to newVpitch.
      dataList:add(minVpitch).
      set maxVpitch to newVpitch.
      dataList:add(maxVpitch).
      doingOptiPopup().
    }
    else{
      global allLinesList is list().
      for line in readFile {
        local dataLine is line:split(";").
        allLinesList:add(dataLine).
      }
      set goodLine to allLinesList[L].
      
      for index in range(L + 1) {
        if index = 0 {
          allVpitch:add(allLinesList[index][dataFile_NewVpitch_Index]).
        }
        else {
          allVpitch:add(round(allLinesList[index][dataFile_NewVpitch_Index]:toNumber,1)).
        }
      }

      set suggestedAmp to goodLine[dataFile_Amp_Index]:toNumber.
      if goodLine[dataFile_NewAmp_Index] = "M" {
        decreasingAmp().
      }
      set oldDelta to goodLine[dataFile_NewDelta_Index]:toNumber.
      set testedVpitch to goodLine[dataFile_NewVpitch_Index]:toNumber.
      set lastResult to goodLine[dataFile_Result_Index].
      set numFlight to goodLine[dataFile_NumFlight_Index]:toNumber + 1.
      
      if oldDelta / 2 <= 0.5 or (testedVpitch = 0 and suggestedAmp = 65 and lastResult = "S") {
        finalFile().
      }
      else {
        set newDelta to choose deltaScale if changeAmp = true else computeNewDelta(oldDelta).
      }
      set newVpitch to choose equationLexicon[suggestedAmp](TWR) if changeAmp = true else computeVpitch(newDelta).
      
      set changeAmp to false.
      
      set minVpitch to goodLine[dataFile_MinVpitch_Index]:toNumber.
      set maxVpitch to goodLine[dataFile_MaxVpitch_Index]:toNumber.
      
      if newVpitch <= minVpitch {
        set minVpitch to newVpitch.
      }
      
      if newVpitch >= maxVpitch {
        set maxVpitch to newVpitch.
      }

      dataList:add(suggestedAmp).
      dataList:add(oldDelta).
      dataList:add(newDelta).
      dataList:add(newVpitch).
      dataList:add(minVpitch).
      dataList:add(maxVpitch).

      doingOptiPopup().

      function computeNewDelta {
        parameter oD.
        local nD is 0.
        if (lastResult = allLinesList[L-1][dataFile_Result_Index]) or (L = 1) {
          set nD to oD.
        }
        else {
          set nD to ceiling(oD / 2).
        }
        return nD.
      }

      function computeVpitch {
        parameter nD.
        local vp is 0.
        if lastResult = "F" {
          set vp to goodLine[dataFile_NewVpitch_Index]:toNumber + nD.
        }
        else {
          if goodLine[dataFile_oldDelta_Index] = 0 and goodLine[dataFile_newDelta_Index] = deltaScale and goodLine[dataFile_NewAmp_Index] = "Y" {
            set vp to goodLine[dataFile_NewVpitch_Index]:toNumber.
          }
          else {
            if goodLine[dataFile_NewVpitch_Index]:toNumber - nD < 0 {
              set vp to 0.
              set newDelta to ceiling(goodLine[dataFile_NewVpitch_Index]:toNumber / 2).
            }
            else {
              set vp to goodLine[dataFile_NewVpitch_Index]:toNumber - nD.
            }
          }
        }

        until (not allVpitch:contains(round(vp,1))) or (newDelta <= 0.5) {
          set newDelta to ceiling(nD / 2).
          set vp to computeVpitch(newDelta).
        }
        return vp.
      }
    }
  }

  doFlight(suggestedAmp, newVpitch).
  actualiseDataFile("S").
  declareStatus(DIC_flight_status_success).

  function finalFile {
    doingOptiWindow:hide().
    local revertVAB is false.
    local stopOpti is kUniverse:realtime.
    local startOpti is addons:file:readAllLines(readFileFolder + nameTempFolder + "time.txt")[0]:toNumber.
    local delay is round(stopOpti - startOpti,0).
    local realTime is findRealDate(stopOpti).
    local userDescription is "".
    local index is allLinesList:length - 1.
    until allLinesList[index][dataFile_Result_Index] = "S" {
      set index to index - 1.
    }
    global recapVpitch is allLinesList[index][dataFile_NewVpitch_Index]:toNumber.
    global recapApoapsis is allLinesList[index][dataFile_Apoapsis_Index].
    showRecapWindow().
    log realTime[0] + ";" + realTime[1] + ";" + ship:name + ";" + suggestedAmp + ";" + round(recapVpitch, 0) + ";" + recapApoapsis + ";" + goodLine[dataFile_NumFlight_Index]:toNumber + ";" + TIME(delay):clock + ";" + userDescription to (recapFile).
    deletePath(mainFolder + "temp_opti_gt").
    wait 0.2.
    if revertVAB {
      kUniverse:revertToEditor().
    }
    else {
      kUniverse:revertToLaunch().
    }    

    function showRecapWindow {
      local recapWidth is 600.
      local closeRecap is false.
      local saveRecap is false.
      set recapNameFile to (ship:name):toLower + "_" + findRealDate(floor(kUniverse:realTime), "-")[0] + ".csv".
      local imageWidth is (recapWidth-10) / 2.
      local imageHeight is (9/16) * imageWidth.
      local recapWindow is gui(recapWidth).
        set recapWindow:y to 150.
        set recapWindow:skin:font to "Consolas".
        set recapWindow:skin:label:fontsize to 15.
        set recapWindow:skin:label:hstretch to true.
        set recapWindow:skin:label:align to "center".

      local recapTitleShipName is recapWindow:addlabel("<b>" + ship:name + "</b>").
        set recapTitleShipName:style:fontsize to 20.
      recapWindow:addSpacing(20).
      
      local recapTitle is recapWindow:addlabel(DIC_recap_window_title).
        set recapTitle:style:fontsize to 20.
      recapWindow:addSpacing(15).
      

      local bravoRecap is recapWindow:addLabel(DIC_recap_window_congrats_title).

      recapWindow:addSpacing(25).

      local limitRecap is recapWindow:addLabel(DIC_recap_window_limit).
      if suggestedAmp = 65 and recapVpitch = 0 {
        limitRecap:show().
      } 
      else {
        limitRecap:hide().
      }

      recapWindow:addSpacing(25).

      local infoRecap is recapWindow:addlabel(DIC_recap_window_info_text).
        set infoRecap:style:fontsize to 12.
        set infoRecap:style:textcolor to white.

      recapWindow:addSpacing(25).
      
      local recapValueBox is recapWindow:addVbox().

      addRecapLabel(DIC_recap_window_amp_title, suggestedAmp, DIC_angle_unit).
      addRecapLabel(DIC_recap_window_vPitch_title, ceiling(recapVpitch), DIC_velocity_unit).

      recapWindow:addSpacing(10).

      addRecapLabel(DIC_recap_window_number_flights_title, goodLine[dataFile_NumFlight_Index]:toNumber).
      addRecapLabel(DIC_recap_window_simulation_time_title, TIME(delay):clock).

      recapWindow:addSpacing(15).

      local function addRecapLabel {
        parameter txt1, value.
        parameter txt2 is "".
        local horizontalBox is recapValueBox:addHLayout.
        set horizontalBox:style:width to recapWidth.
        local hLabelOne is horizontalBox:addLabel().
          set hLabelOne:text to txt1.
          set hLabelOne:style:width to recapWidth/2.
          set hLabelOne:style:hstretch to true.
          set hLabelOne:style:align to "right".
        local hLabelTwo is horizontalBox:addLabel().
          set hLabelTwo:text to value + txt2.
          set hLabelTwo:style:width to recapWidth/2.
          set hLabelTwo:style:hstretch to true.
          set hLabelTwo:style:align to "left".
        return horizontalBox.
      }
      
      local addDescription is recapWindow:addlabel(DIC_recap_window_add_description_text).
        set addDescription:style:fontsize to 12.

      recapWindow:addSpacing(15).

      local descriptionField is recapWindow:addTextField().
        set descriptionField:style:height to 30.
        set descriptionField:style:padding:h to 10.
        set descriptionField:style:padding:v to 10.
        set descriptionField:tooltip to DIC_recap_window_add_description_tooltip.
        set descriptionField:style:wordwrap to true.

      recapWindow:addSpacing(25).

      local saveRecapButton is recapWindow:addButton(DIC_recap_window_save_recap_button_text).
        set saveRecapButton:style:width to 0.98 * recapWidth.

      recapWindow:addSpacing(15).

      local finalDecision is recapWindow:addlabel(DIC_recap_window_final_decision_text).
        set finalDecision:style:fontsize to 12.

      recapWindow:addSpacing(15).

      local buttonBox is recapWindow:addHlayout.
      local buttonVABbox is buttonBox:addVlayout.
        set buttonVABbox:style:width to recapWidth / 2.
      local launchPadButtonBox is buttonBox:addVlayout.
        set launchPadButtonBox:style:width to recapWidth / 2.

      local VABbutton is buttonVABbox:addButton(DIC_recap_window_VAB_text).
      local VABimage is buttonVABbox:addLabel().
        set VABimage:style:hstretch to true.
        set VABimage:style:align to "center".
        set VABimage:style:width to imageWidth.
        set VABimage:style:height to imageHeight.
        set VABimage:image to "VAB".

      local launchPadButton is launchPadButtonBox:addButton(DIC_recap_window_launchPad_text).
      local launchPadImage is launchPadButtonBox:addLabel().
        set launchPadImage:style:hstretch to true.
        set launchPadImage:style:align to "center".
        set launchPadImage:style:width to imageWidth.
        set launchPadImage:style:height to imageHeight.
        set launchPadImage:image to "launchPad".

      recapWindow:show().

      until closeRecap {
        if saveRecap {
          set saveRecapButton:enabled to false.
          set saveRecapButton:text to DIC_recap_window_save_recap_button_text_already_saved + recapNameFile.
        }
        if saveRecapButton:takePress {
          set saveRecap to true.
          copyPath(dataFile, mainFolder + recapNameFile).
        }
        if launchPadButton:takePress {
          core:part:getmodule("kosProcessor"):doEvent("close terminal").
          set closeRecap to true.
          set userDescription to descriptionField:text.
        }
        if VABButton:takePress {
          core:part:getmodule("kosProcessor"):doEvent("close terminal").
          set closeRecap to true.
          set revertVAB to true.
          set userDescription to descriptionField:text.
        }
      }
      recapWindow:dispose().
    }
  }

  function doingOptiPopup {
    set doingOptiWindow:y to 50.
    set doingOptiWindow:x to 600.
    local LabelOne is doingOptiWindow:addLabel(DIC_flight_popup_title).
      set LabelOne:style:hstretch to true.
      set LabelOne:style:align to "center".
    local shipNameBox is doingOptiWindow:addHbox().
    local LabelShip is shipNameBox:addLabel(ship:name).
      set LabelShip:style:hstretch to true.
      set LabelShip:style:align to "center".
    doingOptiWindow:addSpacing(5).

    local LabelTwo is doingOptiWindow:addLabel(DIC_flight_popup_flight_number_text + numFlight).
      set LabelTwo:style:hstretch to true.
      set LabelTwo:style:align to "center".
    doingOptiWindow:addSpacing(5).

    local labelBox is doingOptiWindow:addVbox().
    
    local LabelThree is labelBox:addLabel(DIC_flight_popup_test_vPitch_text + round(newVpitch, 3) + DIC_velocity_unit).
      set LabelThree:style:hstretch to true.
      set LabelThree:style:align to "center".
      
    local LabelOneBis is labelBox:addLabel(DIC_flight_popup_amp_text + suggestedAmp + DIC_angle_unit).
      set LabelOneBis:style:hstretch to true.
      set LabelOneBis:style:align to "center".
    global relaunchBox is doingOptiWindow:addVlayout().
      relaunchBox:addSpacing(5).
      local relaunchText is relaunchBox:addLabel(DIC_flight_popup_relaunch_text).
        set relaunchText:style:hstretch to true.
        set relaunchText:style:align to "center".
      global countRelaunch is relaunchBox:addLabel().
        set countRelaunch:style:hstretch to true.
        set countRelaunch:style:align to "center".
    
    relaunchBox:hide().
    doingOptiWindow:show().
  }
}