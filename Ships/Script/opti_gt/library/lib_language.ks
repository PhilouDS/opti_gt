function selectLanguage {
  parameter iWantToChangeTheLanguage is false.
  local languageFile is "".
  local languageList is list().
  local languageLex is lexicon().

  addLanguage("english", "en").
  addLanguage("français", "fr").

  if (not exists(locFolder + "selected_language.txt")) or (iWantToChangeTheLanguage) {
    if exists(locFolder + "selected_language.txt") {deletePath(locFolder + "selected_language.txt").}
    local languageWindowIsClosed to false.
    local languageWindow is GUI(250).
      set languageWindow:y to 100.
      set languageWindow:skin:font to "Consolas".
      set languageWindow:skin:label:fontsize to 15.
      set languageWindow:skin:label:hstretch to true.
      set languageWindow:skin:label:align to "center".
    languageWindow:addLabel("Choisir une langue").
    languageWindow:addLabel("Choose a language").
    languageWindow:addSpacing(15).
    local languageChooseList is languageWindow:addPopupMenu().
      for lang in languageList {languageChooseList:addoption(lang).}
    languageWindow:addSpacing(15).
    local confirmButton is languageWindow:addButton("OK").

    languageWindow:show().

    until languageWindowIsClosed {
      if confirmButton:takePress {
        set languageWindowIsClosed to true.
        set languageFile to languageLex[languageChooseList:value].
        log languageChooseList:value to locFolder + "selected_language.txt".
      }
    }
    languageWindow:dispose().
  }
  else {
    local tempFile is addons:file:readAllLines(readFileFolder + "localization/selected_language.txt").
    local myLanguage is tempFile[0].
    set languageFile to languageLex[myLanguage].
  }

  runOncePath(languageFile).
  print DIC_print_loading_text.
  print languageFile.
  print " ".
  if iWantToChangeTheLanguage {
    wait 0.5.
    globalWindow:dispose().
    reboot.
  }


  function addLanguage {
    parameter language.
    parameter shortLanguage.
    languageList:add(language).
    local tempFile is locFolder + "opti_gt_" + shortLanguage + ".ks".
    languageLex:add(language, tempFile).
  }
}