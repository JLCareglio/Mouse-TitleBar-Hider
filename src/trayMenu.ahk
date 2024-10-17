config := {
  isWinActive: {
    key: "isWinActive",
    value: RegRead("HKCU\Software\Mouse-TitleBar-Hider", "isWinActive", 1),
    label: "Win + Click Izquierdo"
  },
  isMButtonActive: {
    key: "isMButtonActive",
    value: RegRead("HKCU\Software\Mouse-TitleBar-Hider", "isMButtonActive", 1),
    label: "Botón 3 del ratón (rueda)"
  },
  isXButton1Active: {
    key: "isXButton1Active",
    value: RegRead("HKCU\Software\Mouse-TitleBar-Hider", "isXButton1Active", 1),
    label: "Botón 4 del ratón (lateral)"
  },
  isXButton2Active: {
    key: "isXButton2Active",
    value: RegRead("HKCU\Software\Mouse-TitleBar-Hider", "isXButton2Active", 1),
    label: "Botón 5 del ratón (lateral)"
  }
}

submenuAtajos := Menu()
submenuAtajos.Add(config.isWinActive.label, (*) => ToggleAndSave(config.isWinActive))
submenuAtajos.Add(config.isMButtonActive.label, (*) => ToggleAndSave(config.isMButtonActive))
submenuAtajos.Add(config.isXButton1Active.label, (*) => ToggleAndSave(config.isXButton1Active))
submenuAtajos.Add(config.isXButton2Active.label, (*) => ToggleAndSave(config.isXButton2Active))

A_TrayMenu.Delete()
A_TrayMenu.Add("Atajos activos", submenuAtajos)
A_TrayMenu.Add()
A_TrayMenu.Add("Ayuda", (*) => Run("https://www.github.com/JLCareglio/Mouse-TitleBar-Hider"))
A_TrayMenu.Add("Salir", (*) => ExitApp())

ToggleAndSave(&configRef*) {
  configRef[1].value := !configRef[1].value
  RegWrite(configRef[1].value, "REG_DWORD", "HKCU\Software\Mouse-TitleBar-Hider", configRef[1].key)
  submenuAtajos.ToggleCheck(configRef[1].label)
}

for , setting in config.OwnProps()
  if (setting.value)
    submenuAtajos.Check(setting.label)