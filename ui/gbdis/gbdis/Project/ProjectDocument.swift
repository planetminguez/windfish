//
//  Document.swift
//  gbdis
//
//  Created by Jeff Verkoeyen on 11/30/20.
//

import Cocoa

import LR35902

final class Region: NSObject, Codable {
  struct Kind {
    static let region = "Region"
    static let label = "Label"
    static let function = "Function"
  }
  @objc dynamic var regionType: String {
    didSet {
      if regionType == Kind.label || regionType == Kind.function {
        length = 0
      }
    }
  }
  @objc dynamic var name: String
  @objc dynamic var bank: LR35902.Bank
  @objc dynamic var address: LR35902.Address
  @objc dynamic var length: LR35902.Address

  init(regionType: String, name: String, bank: LR35902.Bank, address: LR35902.Address, length: LR35902.Address) {
    self.regionType = regionType
    self.name = name
    self.bank = bank
    self.address = address
    self.length = length
  }
}

final class DataType: NSObject, Codable {
  init(name: String, representation: String, interpretation: String, mappings: [Mapping]) {
    self.name = name
    self.representation = representation
    self.interpretation = interpretation
    self.mappings = mappings
  }

  struct Interpretation {
    static let any = "Any"
    static let enumerated = "Enumerated"
    static let bitmask = "Bitmask"
  }
  struct Representation {
    static let decimal = "Decimal"
    static let hexadecimal = "Hex"
    static let binary = "Binary"
  }

  final class Mapping: NSObject, Codable {
    internal init(name: String, value: UInt8) {
      self.name = name
      self.value = value
    }
    
    @objc dynamic var name: String
    @objc dynamic var value: UInt8
  }

  @objc dynamic var name: String
  @objc dynamic var representation: String
  @objc dynamic var interpretation: String
  @objc dynamic var mappings: [Mapping]
}

final class Global: NSObject, Codable {
  internal init(name: String, address: LR35902.Address, dataType: String) {
    self.name = name
    self.address = address
    self.dataType = dataType
  }

  @objc dynamic var name: String
  @objc dynamic var address: LR35902.Address
  @objc dynamic var dataType: String
}

class ProjectConfiguration: NSObject, Codable {
  @objc dynamic var regions: [Region] = []
  @objc dynamic var dataTypes: [DataType] = []
  @objc dynamic var globals: [Global] = []
}

final class DisassemblyResults: NSObject {
  internal init(files: [String : Data], bankLines: [LR35902.Bank : [LR35902.Disassembly.Line]]? = nil, regions: [Region]? = nil, statistics: LR35902.Disassembly.Statistics? = nil) {
    self.files = files
    self.bankLines = bankLines
    self.regions = regions
    self.statistics = statistics
  }

  var files: [String: Data]
  var bankLines: [LR35902.Bank: [LR35902.Disassembly.Line]]?
  @objc dynamic var regions: [Region]?
  var statistics: LR35902.Disassembly.Statistics?
}

struct ProjectMetadata: Codable {
  var romUrl: URL
  var numberOfBanks: LR35902.Bank
  var bankMap: [String: LR35902.Bank]
}

private struct Filenames {
  static let metadata = "metadata.plist"
  static let rom = "rom.gb"
  static let disassembly = "disassembly"
  static let configuration = "configuration.plist"
}

@objc(ProjectDocument)
class ProjectDocument: NSDocument {
  weak var contentViewController: ProjectViewController?

  var isDisassembling = false
  var romData: Data?
  @objc dynamic var disassemblyResults: DisassemblyResults?
  var metadata: ProjectMetadata?
  var configuration = ProjectConfiguration()

  override init() {
    super.init()

    let numberOfRestartAddresses: LR35902.Address = 8
    let restartSize: LR35902.Address = 8
    let rstAddresses = (0..<numberOfRestartAddresses).map { ($0 * restartSize)..<($0 * restartSize + restartSize) }
    rstAddresses.forEach {
      configuration.regions.append(Region(regionType: Region.Kind.region, name: "RST_\($0.lowerBound.hexString)", bank: 0, address: $0.lowerBound, length: LR35902.Address($0.count)))
    }

    configuration.regions.append(Region(regionType: Region.Kind.region, name: "VBlankInterrupt", bank: 0, address: 0x0040, length: 8))
    configuration.regions.append(Region(regionType: Region.Kind.region, name: "LCDCInterrupt", bank: 0, address: 0x0048, length: 8))
    configuration.regions.append(Region(regionType: Region.Kind.region, name: "TimerOverflowInterrupt", bank: 0, address: 0x0050, length: 8))
    configuration.regions.append(Region(regionType: Region.Kind.region, name: "SerialTransferCompleteInterrupt", bank: 0, address: 0x0058, length: 8))
    configuration.regions.append(Region(regionType: Region.Kind.region, name: "JoypadTransitionInterrupt", bank: 0, address: 0x0060, length: 8))
    configuration.regions.append(Region(regionType: Region.Kind.region, name: "Boot", bank: 0, address: 0x0100, length: 4))

    configuration.dataTypes.append(DataType(name: "hex",
                                            representation: DataType.Representation.hexadecimal,
                                            interpretation: DataType.Interpretation.any,
                                            mappings: []))
    configuration.dataTypes.append(DataType(name: "decimal",
                                            representation: DataType.Representation.decimal,
                                            interpretation: DataType.Interpretation.any,
                                            mappings: []))
    configuration.dataTypes.append(DataType(name: "binary",
                                            representation: DataType.Representation.binary,
                                            interpretation: DataType.Interpretation.any,
                                            mappings: []))
    configuration.dataTypes.append(DataType(name: "bool",
                                            representation: DataType.Representation.decimal,
                                            interpretation: DataType.Interpretation.enumerated,
                                            mappings: [
                                              DataType.Mapping(name: "false", value: 0),
                                              DataType.Mapping(name: "true", value: 1)
                                            ]))

    configuration.dataTypes.append(DataType(name: "HW_COLORGAMEBOY",
                                            representation: DataType.Representation.hexadecimal,
                                            interpretation: DataType.Interpretation.enumerated,
                                            mappings: [
                                              DataType.Mapping(name: "not_color_gameboy", value: 0x00),
                                              DataType.Mapping(name: "is_color_gameboy", value: 0x80),
                                            ]))
    configuration.dataTypes.append(DataType(name: "HW_SUPERGAMEBOY",
                                            representation: DataType.Representation.hexadecimal,
                                            interpretation: DataType.Interpretation.enumerated,
                                            mappings: [
                                              DataType.Mapping(name: "not_super_gameboy", value: 0x00),
                                              DataType.Mapping(name: "is_super_gameboy", value: 0x80),
                                            ]))
    configuration.dataTypes.append(DataType(name: "HW_ROMSIZE",
                                            representation: DataType.Representation.hexadecimal,
                                            interpretation: DataType.Interpretation.enumerated,
                                            mappings: [
                                              DataType.Mapping(name: "romsize_2banks", value: 0),
                                              DataType.Mapping(name: "romsize_4banks", value: 1),
                                              DataType.Mapping(name: "romsize_8banks", value: 2),
                                              DataType.Mapping(name: "romsize_16banks", value: 3),
                                              DataType.Mapping(name: "romsize_32banks", value: 4),
                                              DataType.Mapping(name: "romsize_64banks", value: 5),
                                              DataType.Mapping(name: "romsize_128banks", value: 6),
                                              DataType.Mapping(name: "romsize_72banks", value: 0x52),
                                              DataType.Mapping(name: "romsize_80banks", value: 0x53),
                                              DataType.Mapping(name: "romsize_96banks", value: 0x54),
                                            ]))
    configuration.dataTypes.append(DataType(name: "HW_RAMSIZE",
                                            representation: DataType.Representation.hexadecimal,
                                            interpretation: DataType.Interpretation.enumerated,
                                            mappings: [
                                              DataType.Mapping(name: "ramsize_none", value: 0),
                                              DataType.Mapping(name: "ramsize_1bank", value: 1),
                                              DataType.Mapping(name: "ramsize_1bank_", value: 2),
                                              DataType.Mapping(name: "ramsize_4banks", value: 3),
                                              DataType.Mapping(name: "ramsize_16banks", value: 4),
                                            ]))
    configuration.dataTypes.append(DataType(name: "HW_DESTINATIONCODE",
                                            representation: DataType.Representation.hexadecimal,
                                            interpretation: DataType.Interpretation.enumerated,
                                            mappings: [
                                              DataType.Mapping(name: "destination_japanese", value: 0),
                                              DataType.Mapping(name: "destination_nonjapanese", value: 1),
                                            ]))
    configuration.dataTypes.append(DataType(name: "HW_IE",
                                            representation: DataType.Representation.binary,
                                            interpretation: DataType.Interpretation.bitmask,
                                            mappings: [
                                              DataType.Mapping(name: "IE_VBLANK", value: 0b0000_0001),
                                              DataType.Mapping(name: "IE_LCDC", value: 0b0000_0010),
                                              DataType.Mapping(name: "IE_TIMEROVERFLOW", value: 0b0000_0100),
                                              DataType.Mapping(name: "IE_SERIALIO", value: 0b0000_1000),
                                              DataType.Mapping(name: "IE_PIN1013TRANSITION", value: 0b0001_0000),
                                            ]))
    configuration.dataTypes.append(DataType(name: "LCDCF",
                                            representation: DataType.Representation.binary,
                                            interpretation: DataType.Interpretation.bitmask,
                                            mappings: [
                                              DataType.Mapping(name: "LCDCF_OFF", value: 0b0000_0000),
                                              DataType.Mapping(name: "LCDCF_ON", value: 0b1000_0000),
                                              DataType.Mapping(name: "LCDCF_TILEMAP_9C00", value: 0b0100_0000),
                                              DataType.Mapping(name: "LCDCF_WINDOW_ON", value: 0b0010_0000),
                                              DataType.Mapping(name: "LCDCF_BG_CHAR_8000", value: 0b0001_0000),
                                              DataType.Mapping(name: "LCDCF_BG_TILE_9C00", value: 0b0000_1000),
                                              DataType.Mapping(name: "LCDCF_OBJ_16_16", value: 0b0000_0100),
                                              DataType.Mapping(name: "LCDCF_OBJ_DISPLAY", value: 0b0000_0010),
                                              DataType.Mapping(name: "LCDCF_BG_DISPLAY", value: 0b0000_0001),
                                            ]))
    configuration.dataTypes.append(DataType(name: "STATF",
                                            representation: DataType.Representation.binary,
                                            interpretation: DataType.Interpretation.bitmask,
                                            mappings: [
                                              DataType.Mapping(name: "STATF_LYC", value: 0b0100_0000),
                                              DataType.Mapping(name: "STATF_MODE10", value: 0b0010_0000),
                                              DataType.Mapping(name: "STATF_MODE01", value: 0b0001_0000),
                                              DataType.Mapping(name: "STATF_MODE00", value: 0b0000_1000),
                                              DataType.Mapping(name: "STATF_LYCF", value: 0b0000_0100),
                                              DataType.Mapping(name: "STATF_OAM", value: 0b0000_0010),
                                              DataType.Mapping(name: "STATF_VB", value: 0b0000_0001),
                                              DataType.Mapping(name: "STATF_HB", value: 0b0000_0000),
                                            ]))
    configuration.dataTypes.append(DataType(name: "BUTTON",
                                            representation: DataType.Representation.binary,
                                            interpretation: DataType.Interpretation.bitmask,
                                            mappings: [
                                              DataType.Mapping(name: "J_RIGHT", value: 0b0000_0001),
                                              DataType.Mapping(name: "J_LEFT", value: 0b0000_0010),
                                              DataType.Mapping(name: "J_UP", value: 0b0000_0100),
                                              DataType.Mapping(name: "J_DOWN", value: 0b0000_1000),
                                              DataType.Mapping(name: "J_A", value: 0b0001_0000),
                                              DataType.Mapping(name: "J_B", value: 0b0010_0000),
                                              DataType.Mapping(name: "J_SELECT", value: 0b0100_0000),
                                              DataType.Mapping(name: "J_START", value: 0b1000_0000),
                                            ]))
    configuration.dataTypes.append(DataType(name: "JOYPAD",
                                            representation: DataType.Representation.binary,
                                            interpretation: DataType.Interpretation.bitmask,
                                            mappings: [
                                              DataType.Mapping(name: "JOYPAD_DIRECTIONS", value: 0b0001_0000),
                                              DataType.Mapping(name: "JOYPAD_BUTTONS", value: 0b0010_0000),
                                            ]))
  }

  private var documentFileWrapper: FileWrapper?

  override func makeWindowControllers() {
    let contentViewController = ProjectViewController(document: self)
    self.contentViewController = contentViewController
    let window = NSWindow(contentViewController: contentViewController)
    window.setContentSize(NSSize(width: 1280, height: 768))
    window.toolbarStyle = .unifiedCompact
    window.tabbingMode = .disallowed
    let wc = NSWindowController(window: window)
    wc.window?.styleMask.insert(.fullSizeContentView)
    wc.contentViewController = contentViewController
    addWindowController(wc)
    window.setFrameAutosaveName("windowFrame")

    let toolbar = NSToolbar()
    toolbar.delegate = self
    wc.window?.toolbar = toolbar

    window.makeKeyAndOrderFront(nil)
  }
}

// MARK: - Toolbar

private extension NSToolbarItem.Identifier {
  static let leadingSidebarTrackingSeparator = NSToolbarItem.Identifier(rawValue: "leadingSidebarTrackingSeperator")
  static let trailingSidebarTrackingSeparator = NSToolbarItem.Identifier(rawValue: "trailingSidebarTrackingSeperator")
  static let disassemble = NSToolbarItem.Identifier(rawValue: "disassemble")
}

extension ProjectDocument: NSToolbarDelegate {
  func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
    return [
      .leadingSidebarTrackingSeparator,
      .disassemble,
      .trailingSidebarTrackingSeparator,
    ]
  }

  func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
    return [
      .leadingSidebarTrackingSeparator,
      .trailingSidebarTrackingSeparator,
      .disassemble,
    ]
  }

  func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
    switch itemIdentifier {
    case .leadingSidebarTrackingSeparator:
      return NSTrackingSeparatorToolbarItem(
        identifier: itemIdentifier,
        splitView: contentViewController!.splitViewController.splitView,
        dividerIndex: 0
      )
    case .trailingSidebarTrackingSeparator:
      return NSTrackingSeparatorToolbarItem(
        identifier: itemIdentifier,
        splitView: contentViewController!.splitViewController.splitView,
        dividerIndex: 1
      )
    case .disassemble:
      let item = NSToolbarItem(itemIdentifier: itemIdentifier)
      item.target = self
      item.action = #selector(disassemble(_:))
      item.image = NSImage(systemSymbolName: "chevron.left.slash.chevron.right", accessibilityDescription: "Disassemble the rom")
      return item
    default:
      return NSToolbarItem(itemIdentifier: itemIdentifier)
    }
  }
}

// MARK: - Document modifications

extension ProjectDocument {
  @objc func disassemble(_ sender: Any?) {
    guard let romData = romData else {
      return
    }
    isDisassembling = true
    self.contentViewController?.startProgressIndicator()

    DispatchQueue.global(qos: .userInitiated).async {
      let disassembly = LR35902.Disassembly(rom: romData)

      for region in self.configuration.regions {
        switch region.regionType {
        case Region.Kind.region:
          disassembly.setLabel(at: region.address, in: region.bank, named: region.name)
          if region.length > 0 {
            disassembly.disassemble(range: region.address..<(region.address + region.length), inBank: region.bank)
          }
        case Region.Kind.label:
          disassembly.setLabel(at: region.address, in: region.bank, named: region.name)
        case Region.Kind.function:
          disassembly.defineFunction(startingAt: region.address, in: region.bank, named: region.name)
        default:
          preconditionFailure()
        }
      }

      for dataType in self.configuration.dataTypes {
        let mappingDict = dataType.mappings.reduce(into: [:]) { accumulator, mapping in
          accumulator[mapping.value] = mapping.name
        }
        let representation: LR35902.Disassembly.Datatype.Representation
        switch dataType.representation {
        case DataType.Representation.binary:
          representation = .binary
        case DataType.Representation.decimal:
          representation = .decimal
        case DataType.Representation.hexadecimal:
          representation = .hexadecimal
        default:
          preconditionFailure()
        }
        switch dataType.interpretation {
        case DataType.Interpretation.any:
          disassembly.createDatatype(named: dataType.name, representation: representation)
        case DataType.Interpretation.bitmask:
          disassembly.createDatatype(named: dataType.name, bitmask: mappingDict, representation: representation)
        case DataType.Interpretation.enumerated:
          disassembly.createDatatype(named: dataType.name, enumeration: mappingDict, representation: representation)
        default:
          preconditionFailure()
        }
      }

      for global in self.configuration.globals {
        disassembly.createGlobal(at: global.address, named: global.name, dataType: global.dataType)
      }

      //            disassembly.disassembleAsGameboyCartridge()
      let (disassembledSource, statistics) = try! disassembly.generateSource()

      let bankMap: [String: LR35902.Bank] = disassembledSource.sources.reduce(into: [:], { accumulator, element in
        if case .bank(let number, _, _) = element.value {
          accumulator[element.key] = number
        }
      })
      let bankLines: [LR35902.Bank: [LR35902.Disassembly.Line]] = disassembledSource.sources.compactMapValues {
        switch $0 {
        case .bank(_, _, let lines):
          return lines
        default:
          return nil
        }
      }.reduce(into: [:]) { accumulator, entry in
        accumulator[bankMap[entry.0]!] = entry.1
      }
      let disassemblyFiles: [String: Data] = disassembledSource.sources.mapValues {
        switch $0 {
        case .bank(_, let content, _): fallthrough
        case .charmap(content: let content): fallthrough
        case .datatypes(content: let content): fallthrough
        case .game(content: let content): fallthrough
        case .macros(content: let content): fallthrough
        case .makefile(content: let content): fallthrough
        case .variables(content: let content):
          return content.data(using: .utf8)!
        }
      }

      let regions: [Region] = bankLines.reduce(into: []) { accumulator, element in
        let bank = element.key
        accumulator.append(contentsOf: element.value.reduce(into: []) { accumulator, line in
          switch line.semantic {
          case let .label(name): fallthrough
          case let .transferOfControl(_, name):
            accumulator.append(
              Region(
                regionType: Region.Kind.label,
                name: name,
                bank: bank,
                address: line.address!,
                length: 0
              )
            )
            break
          default:
            break
          }
        })
      }

      DispatchQueue.main.async {
        self.metadata?.numberOfBanks = disassembly.cpu.numberOfBanks
        self.metadata?.bankMap = bankMap
        self.disassemblyResults = DisassemblyResults(
          files: disassemblyFiles,
          bankLines: bankLines,
          regions: regions,
          statistics: statistics
        )

        self.isDisassembling = false
        NotificationCenter.default.post(name: .disassembled, object: self)

        self.contentViewController?.stopProgressIndicator()
      }
    }
  }

  @objc func loadRom(_ sender: Any?) {
    let openPanel = NSOpenPanel()
    openPanel.allowedFileTypes = ["gb"]
    openPanel.canChooseFiles = true
    openPanel.canChooseDirectories = false
    if let window = contentViewController?.view.window {
      openPanel.beginSheetModal(for: window) { response in
        if response == .OK, let url = openPanel.url {
          let data = try! Data(contentsOf: url)
          self.romData = data

          self.metadata = ProjectMetadata(
            romUrl: url,
            numberOfBanks: 0,
            bankMap: [:]
          )
          self.disassemble(nil)
        }
      }
    }
  }
}

// MARK: - Document loading and saving

extension ProjectDocument {
  override func read(from fileWrapper: FileWrapper, ofType typeName: String) throws {
    guard let fileWrappers = fileWrapper.fileWrappers else {
      preconditionFailure()
    }

    if let metadataFileWrapper = fileWrappers[Filenames.metadata],
       let encodedMetadata = metadataFileWrapper.regularFileContents {
      let decoder = PropertyListDecoder()
      let metadata = try decoder.decode(ProjectMetadata.self, from: encodedMetadata)
      self.metadata = metadata
    }

    if let fileWrapper = fileWrappers[Filenames.configuration],
       let regularFileContents = fileWrapper.regularFileContents {
      let decoder = PropertyListDecoder()
      self.configuration = try decoder.decode(ProjectConfiguration.self, from: regularFileContents)
    }

    if let fileWrapper = fileWrappers[Filenames.rom],
       let data = fileWrapper.regularFileContents {
      self.romData = data
    }

    if let fileWrapper = fileWrappers[Filenames.disassembly] {
      if let files = fileWrapper.fileWrappers?.mapValues({ $0.regularFileContents! }) {
        self.disassemblyResults = DisassemblyResults(files: files, bankLines: nil)
      }
    }

    self.disassemble(nil)
  }

  override func fileWrapper(ofType typeName: String) throws -> FileWrapper {
    if documentFileWrapper == nil {
      documentFileWrapper = FileWrapper(directoryWithFileWrappers: [:])
    }
    guard let documentFileWrapper = documentFileWrapper else {
      preconditionFailure()
    }
    guard let fileWrappers = documentFileWrapper.fileWrappers else {
      preconditionFailure()
    }

    if let metadataFileWrapper = fileWrappers[Filenames.metadata] {
      documentFileWrapper.removeFileWrapper(metadataFileWrapper)
    }
    let encoder = PropertyListEncoder()
    let encodedMetadata = try encoder.encode(metadata)
    let metadataFileWrapper = FileWrapper(regularFileWithContents: encodedMetadata)
    metadataFileWrapper.preferredFilename = Filenames.metadata
    documentFileWrapper.addFileWrapper(metadataFileWrapper)

    if let fileWrapper = fileWrappers[Filenames.configuration] {
      documentFileWrapper.removeFileWrapper(fileWrapper)
    }
    let encodedConfiguration = try encoder.encode(configuration)
    let configurationFileWrapper = FileWrapper(regularFileWithContents: encodedConfiguration)
    configurationFileWrapper.preferredFilename = Filenames.configuration
    documentFileWrapper.addFileWrapper(configurationFileWrapper)

    if let romData = romData {
      if let fileWrapper = fileWrappers[Filenames.rom] {
        documentFileWrapper.removeFileWrapper(fileWrapper)
      }
      let fileWrapper = FileWrapper(regularFileWithContents: romData)
      fileWrapper.preferredFilename = Filenames.rom
      documentFileWrapper.addFileWrapper(fileWrapper)
    }

    // TODO: Wait until the assembly has finished?
    if let disassemblyResults = disassemblyResults {
      let wrappers = disassemblyResults.files.mapValues { content in
        FileWrapper(regularFileWithContents: content)
      }
      if let fileWrapper = fileWrappers[Filenames.disassembly] {
        documentFileWrapper.removeFileWrapper(fileWrapper)
      }
      let fileWrapper = FileWrapper(directoryWithFileWrappers: wrappers)
      fileWrapper.preferredFilename = Filenames.disassembly
      documentFileWrapper.addFileWrapper(fileWrapper)
    }
    return documentFileWrapper
  }
}