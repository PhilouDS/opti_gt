function printWarning {
  local warningSize is 500.
  local closeWarning is false.
  local warningWindow is gui(warningSize).
    set warningWindow:y to 150.
    set warningWindow:skin:font to "Consolas".
    set warningWindow:skin:label:fontsize to 12.
    set warningWindow:skin:label:hstretch to true.
    set warningWindow:skin:label:align to "left".

  local warningVersion is warningWindow:addlabel(DIC_warning_page_version + scriptVersion).
    set warningVersion:style:fontsize to 8.
  warningWindow:addSpacing(8).
  local warningTitle is warningWindow:addlabel(DIC_warning_page_title).
    set warningTitle:style:fontsize to 20.
    set warningTitle:style:textcolor to red.
    set warningTitle:style:hstretch to true.
    set warningTitle:style:align to "center".
  warningWindow:addSpacing(15).

  warningWindow:addLabel(DIC_warning_page_thanks).

  warningWindow:addSpacing(25).

  warningWindow:addlabel(DIC_warning_page_utils).

  warningWindow:addSpacing(25).

  warningWindow:addlabel(DIC_warning_page_tag).

  warningWindow:addSpacing(25).

  warningWindow:addlabel(DIC_warning_page_overheat).

  warningWindow:addSpacing(25).

  local buttonBox is warningWindow:addHlayout.

  local exeButton is buttonBox:addButton(DIC_warning_page_execute_button).
    set exeButton:style:width to warningSize / 2.
    set exeButton:style:hstretch to true.
    set exeButton:style:align to "center".
    set exeButton:enabled to false.

  local quitButton is buttonBox:addButton(DIC_warning_page_quit_button).
    set quitButton:style:width to warningSize / 2.
    set quitButton:style:hstretch to true.
    set quitButton:style:align to "center".

  warningWindow:addSpacing(15).
  local changeLanguageButton is warningWindow:addButton(DIC_change_language_button_name).

  warningWindow:show().

  until closeWarning {
    if ship:partsTagged(DIC_fairing_TAG):length <> 0 {
      set exeButton:enabled to true.
    }
    if exeButton:takePress {
      set closeWarning to true.
    }
    if quitButton:takePress {
      set closeWarning to true.
      set isCancelled to true.
    }
    if changeLanguageButton:takePress {
      selectLanguage(true).
    }
  }
  warningWindow:dispose().
}