import Cocoa

extension ProjectDocument: EmulatorDelegate {
  // MARK: - EmulatorDelegate
  func willRun() {

  }

  func didRun() {

  }

  var isMuted: Bool {
    return false
  }

  var isRewinding: Bool {
    return false
  }

  // MARK: - CallbackBridgeDelegate

  func loadBootROM(_ type: GB_boot_rom_t) {
    let names: [UInt32: String] = [
      GB_BOOT_ROM_DMG0.rawValue: "dmg0_boot",
      GB_BOOT_ROM_DMG.rawValue: "dmg_boot",
      GB_BOOT_ROM_MGB.rawValue: "mgb_boot",
      GB_BOOT_ROM_SGB.rawValue: "sgb_boot",
      GB_BOOT_ROM_SGB2.rawValue: "sgb2_boot",
      GB_BOOT_ROM_CGB0.rawValue: "cgb0_boot",
      GB_BOOT_ROM_CGB.rawValue: "cgb_boot",
      GB_BOOT_ROM_AGB.rawValue: "agb_boot",
    ]
    sameboy.loadBootROM(Bundle.main.path(forResource: names[type.rawValue], ofType: "bin")!)
  }
}
