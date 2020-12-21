import Foundation
import LR35902
import DisassemblyRequest

func populateRequestWithGameDatatypes(_ request: DisassemblyRequest<LR35902.Address, Gameboy.Cartridge.Location, LR35902.Instruction>) {
  request.createDatatype(named: "GAMEMODE", enumeration: [
    0x00: "GAMEMODE_INTRO",
    0x01: "GAMEMODE_CREDITS",
    0x02: "GAMEMODE_FILE_SELECT",
    0x03: "GAMEMODE_FILE_NEW",
    0x04: "GAMEMODE_FILE_DELETE",
    0x05: "GAMEMODE_FILE_COPY",
    0x06: "GAMEMODE_FILE_SAVE",
    0x07: "GAMEMODE_MINI_MAP",
    0x08: "GAMEMODE_PEACH_PIC",
    0x09: "GAMEMODE_MARIN_BEACH",
    0x0a: "GAMEMODE_WF_MURAL",
    0x0b: "GAMEMODE_WORLD",
    0x0c: "GAMEMODE_INVENTORY",
    0x0d: "GAMEMODE_PHOTO_ALBUM",
    0x0e: "GAMEMODE_PHOTO_DIZZY_LINK",
    0x0f: "GAMEMODE_PHOTO_NICE_LINK",
    0x10: "GAMEMODE_PHOTO_MARIN_CLIFF",
    0x11: "GAMEMODE_PHOTO_MARIN_WELL",
    0x12: "GAMEMODE_PHOTO_MABE",
    0x13: "GAMEMODE_PHOTO_ULRIRA",
    0x14: "GAMEMODE_PHOTO_BOW_WOW",
    0x15: "GAMEMODE_PHOTO_THIEF",
    0x16: "GAMEMODE_PHOTO_FISHERMAN",
    0x17: "GAMEMODE_PHOTO_ZORA",
    0x18: "GAMEMODE_PHOTO_KANALET",
    0x19: "GAMEMODE_PHOTO_GHOST",
    0x20: "GAMEMODE_PHOTO_BRIDGE",
  ])
  request.createDatatype(named: "ENTITY", enumeration: [
    0x00: "ENTITY_ARROW",
    0x01: "ENTITY_BOOMERANG",
    0x02: "ENTITY_BOMB",
    0x03: "ENTITY_HOOKSHOT_CHAIN",
    0x04: "ENTITY_HOOKSHOT_HIT",
    0x05: "ENTITY_ENTITY_LIFTABLE_ROCK",
    0x06: "ENTITY_PUSHED_BLOCK",
    0x07: "ENTITY_CHEST_WITH_ITEM",
    0x08: "ENTITY_MAGIC_POWDER_SPRINKLE",
    0x09: "ENTITY_OCTOROCK",
    0x0A: "ENTITY_OCTOROCK_ROCK",
    0x0B: "ENTITY_MOBLIN",
    0x0C: "ENTITY_MOBLIN_ARROW",
    0x0D: "ENTITY_TEKTITE",
    0x0E: "ENTITY_LEEVER",
    0x0F: "ENTITY_ARMOS_STATUE",
    0x10: "ENTITY_HIDING_GHINI",
    0x11: "ENTITY_GIANT_GHINI",
    0x12: "ENTITY_GHINI",
    0x13: "ENTITY_BROKEN_HEART_CONTAINER",
    0x14: "ENTITY_MOBLIN_SWORD",
    0x15: "ENTITY_ANTI_FAIRY",
    0x16: "ENTITY_SPARK_COUNTER_CLOCKWISE",
    0x17: "ENTITY_SPARK_CLOCKWISE",
    0x18: "ENTITY_POLS_VOICE",
    0x19: "ENTITY_KEESE",
    0x1A: "ENTITY_STALFOS_AGGRESSIVE",
    0x1B: "ENTITY_GEL",
    0x1C: "ENTITY_MINI_GEL",
    0x1D: "ENTITY_1D",
    0x1E: "ENTITY_STALFOS_EVASIVE",
    0x1F: "ENTITY_GIBDO",
    0x20: "ENTITY_HARDHAT_BEETLE",
    0x21: "ENTITY_WIZROBE",
    0x22: "ENTITY_WIZROBE_PROJECTILE",
    0x23: "ENTITY_LIKE_LIKE",
    0x24: "ENTITY_IRON_MASK",
    0x25: "ENTITY_SMALL_EXPLOSION_ENEMY",
    0x26: "ENTITY_SMALL_EXPLOSION_ENEMY_2",
    0x27: "ENTITY_SPIKE_TRAP",
    0x28: "ENTITY_MIMIC",
    0x29: "ENTITY_MINI_MOLDORM",
    0x2A: "ENTITY_LASER",
    0x2B: "ENTITY_LASER_BEAM",
    0x2C: "ENTITY_SPIKED_BEETLE",
    0x2D: "ENTITY_DROPPABLE_HEART",
    0x2E: "ENTITY_DROPPABLE_RUPEE",
    0x2F: "ENTITY_DROPPABLE_FAIRY",
    0x30: "ENTITY_KEY_DROP_POINT",
    0x31: "ENTITY_SWORD",
    0x32: "ENTITY_32",
    0x33: "ENTITY_PIECE_OF_POWER",
    0x34: "ENTITY_GUARDIAN_ACORN",
    0x35: "ENTITY_HEART_PIECE",
    0x36: "ENTITY_HEART_CONTAINER",
    0x37: "ENTITY_DROPPABLE_ARROWS",
    0x38: "ENTITY_DROPPABLE_BOMBS",
    0x39: "ENTITY_INSTRUMENT_OF_THE_SIRENS",
    0x3A: "ENTITY_SLEEPY_TOADSTOOL",
    0x3B: "ENTITY_DROPPABLE_MAGIC_POWDER",
    0x3C: "ENTITY_HIDING_SLIME_KEY",
    0x3D: "ENTITY_DROPPABLE_SECRET_SEASHELL",
    0x3E: "ENTITY_MARIN",
    0x3F: "ENTITY_RACOON",
    0x40: "ENTITY_WITCH",
    0x41: "ENTITY_OWL_EVENT",
    0x42: "ENTITY_OWL_STATUE",
    0x43: "ENTITY_SEASHELL_MANSION_TREES",
    0x44: "ENTITY_YARNA_TALKING_BONES",
    0x45: "ENTITY_BOULDERS",
    0x46: "ENTITY_MOVING_BLOCK_LEFT_TOP",
    0x47: "ENTITY_MOVING_BLOCK_LEFT_BOTTOM",
    0x48: "ENTITY_MOVING_BLOCK_BOTTOM_LEFT",
    0x49: "ENTITY_MOVING_BLOCK_BOTTOM_RIGHT",
    0x4A: "ENTITY_COLOR_DUNGEON_BOOK",
    0x4B: "ENTITY_POT",
    0x4C: "ENTITY_4C",
    0x4D: "ENTITY_SHOP_OWNER",
    0x4E: "ENTITY_4E",
    0x4F: "ENTITY_TRENDY_GAME_OWNER",
    0x50: "ENTITY_BOO_BUDDY",
    0x51: "ENTITY_KNIGHT",
    0x52: "ENTITY_TRACTOR_DEVICE",
    0x53: "ENTITY_TRACTOR_DEVICE_REVERSE",
    0x54: "ENTITY_FISHERMAN_FISHING_GAME",
    0x55: "ENTITY_BOUNCING_BOMBITE",
    0x56: "ENTITY_TIMER_BOMBITE",
    0x57: "ENTITY_PAIRODD",
    0x58: "ENTITY_58",
    0x59: "ENTITY_MOLDORM",
    0x5A: "ENTITY_FACADE",
    0x5B: "ENTITY_SLIME_EYE",
    0x5C: "ENTITY_GENIE",
    0x5D: "ENTITY_SLIME_EEL",
    0x5E: "ENTITY_GHOMA",
    0x5F: "ENTITY_MASTER_STALFOS",
    0x60: "ENTITY_DODONGO_SNAKE",
    0x61: "ENTITY_WARP",
    0x62: "ENTITY_HOT_HEAD",
    0x63: "ENTITY_EVIL_EAGLE",
    0x64: "ENTITY_64",
    0x65: "ENTITY_ANGLER_FISH",
    0x66: "ENTITY_CRYSTAL_SWITCH",
    0x67: "ENTITY_67",
    0x68: "ENTITY_68",
    0x69: "ENTITY_MOVING_BLOCK_MOVER",
    0x6A: "ENTITY_RAFT_OWNER",
    0x6B: "ENTITY_TEXT_DEBUGGER",
    0x6C: "ENTITY_CUCCO",
    0x6D: "ENTITY_BOW_WOW",
    0x6E: "ENTITY_BUTTERFLY",
    0x6F: "ENTITY_DOG",
    0x70: "ENTITY_KID_70",
    0x71: "ENTITY_KID_71",
    0x72: "ENTITY_KID_72",
    0x73: "ENTITY_KID_73",
    0x74: "ENTITY_PAPAHLS_WIFE",
    0x75: "ENTITY_GRANDMA_ULRIRA",
    0x76: "ENTITY_MR_WRITE",
    0x77: "ENTITY_GRANDPA_ULRIRA",
    0x78: "ENTITY_YIP_YIP",
    0x79: "ENTITY_MADAM_MEOWMEOW",
    0x7A: "ENTITY_CROW",
    0x7B: "ENTITY_CRAZY_TRACY",
    0x7C: "ENTITY_GIANT_GOPONGA_FLOWER",
    0x7D: "ENTITY_GOPONGA_FLOWER_PROJECTILE",
    0x7E: "ENTITY_GOPONGA_FLOWER",
    0x7F: "ENTITY_TURTLE_ROCK_HEAD",
    0x80: "ENTITY_TELEPHONE",
    0x81: "ENTITY_ROLLING_BONES",
    0x82: "ENTITY_ROLLING_BONES_BAR",
    0x83: "ENTITY_DREAM_SHRINE_BED",
    0x84: "ENTITY_BIG_FAIRY",
    0x85: "ENTITY_MR_WRITES_BIRD",
    0x86: "ENTITY_FLOATING_ITEM",
    0x87: "ENTITY_DESERT_LANMOLA",
    0x88: "ENTITY_ARMOS_KNIGHT",
    0x89: "ENTITY_HINOX",
    0x8A: "ENTITY_TILE_GLINT_SHOWN",
    0x8B: "ENTITY_TILE_GLINT_HIDDEN",
    0x8C: "ENTITY_8C",
    0x8D: "ENTITY_8D",
    0x8E: "ENTITY_CUE_BALL",
    0x8F: "ENTITY_MASKED_MIMIC_GORIYA",
    0x90: "ENTITY_THREE_OF_A_KIND",
    0x91: "ENTITY_ANTI_KIRBY",
    0x92: "ENTITY_SMASHER",
    0x93: "ENTITY_MAD_BOMBER",
    0x94: "ENTITY_KANALET_BOMBABLE_WALL",
    0x95: "ENTITY_RICHARD",
    0x96: "ENTITY_RICHARD_FROG",
    0x97: "ENTITY_97",
    0x98: "ENTITY_HORSE_PIECE",
    0x99: "ENTITY_WATER_TEKTITE",
    0x9A: "ENTITY_FLYING_TILES",
    0x9B: "ENTITY_HIDING_GEL",
    0x9C: "ENTITY_STAR",
    0x9D: "ENTITY_LIFTABLE_STATUE",
    0x9E: "ENTITY_FIREBALL_SHOOTER",
    0x9F: "ENTITY_GOOMBA",
    0xA0: "ENTITY_PEAHAT",
    0xA1: "ENTITY_SNAKE",
    0xA2: "ENTITY_PIRANHA_PLANT",
    0xA3: "ENTITY_SIDE_VIEW_PLATFORM_HORIZONTAL",
    0xA4: "ENTITY_SIDE_VIEW_PLATFORM_VERTICAL",
    0xA5: "ENTITY_SIDE_VIEW_PLATFORM",
    0xA6: "ENTITY_SIDE_VIEW_WEIGHTS",
    0xA7: "ENTITY_SMASHABLE_PILLAR",
    0xA8: "ENTITY_A8",
    0xA9: "ENTITY_BLOOPER",
    0xAA: "ENTITY_CHEEP_CHEEP_HORIZONTAL",
    0xAB: "ENTITY_CHEEP_CHEEP_VERTICAL",
    0xAC: "ENTITY_CHEEP_CHEEP_JUMPING",
    0xAD: "ENTITY_KIKI_THE_MONKEY",
    0xAE: "ENTITY_WINGED_OCTOROK",
    0xAF: "ENTITY_TRADING_ITEM",
    0xB0: "ENTITY_PINCER",
    0xB1: "ENTITY_HOLE_FILLER",
    0xB2: "ENTITY_BEETLE_SPAWNER",
    0xB3: "ENTITY_HONEYCOMB",
    0xB4: "ENTITY_TARIN",
    0xB5: "ENTITY_BEAR",
    0xB6: "ENTITY_PAPAHL",
    0xB7: "ENTITY_MERMAID",
    0xB8: "ENTITY_FISHERMAN_UNDER_BRIDGE",
    0xB9: "ENTITY_BUZZ_BLOB",
    0xBA: "ENTITY_BOMBER",
    0xBB: "ENTITY_BUSH_CRAWLER",
    0xBC: "ENTITY_GRIM_CREEPER",
    0xBD: "ENTITY_VIRE",
    0xBE: "ENTITY_BLAINO",
    0xBF: "ENTITY_ZOMBIES",
    0xC0: "ENTITY_MAZE_SIGNPOST",
    0xC1: "ENTITY_MARIN_AT_THE_SHORE",
    0xC2: "ENTITY_MARIN_AT_TAL_TAL_HEIGHTS",
    0xC3: "ENTITY_MAMU_AND_FROGS",
    0xC4: "ENTITY_WALRUS",
    0xC5: "ENTITY_URCHIN",
    0xC6: "ENTITY_SAND_CRAB",
    0xC7: "ENTITY_MANBO_AND_FISHES",
    0xC8: "ENTITY_BUNNY_CALLS_MARIN",
    0xC9: "ENTITY_MUSICAL_NOTE",
    0xCA: "ENTITY_MAD_BATTER",
    0xCB: "ENTITY_ZORA",
    0xCC: "ENTITY_FISH",
    0xCD: "ENTITY_BANANAS_SCHULE_SALE",
    0xCE: "ENTITY_MERMAID_STATUE",
    0xCF: "ENTITY_SEASHELL_MANSION",
    0xD0: "ENTITY_ANIMAL_D0",
    0xD1: "ENTITY_ANIMAL_D1",
    0xD2: "ENTITY_ANIMAL_D2",
    0xD3: "ENTITY_BUNNY_D3",
    0xD4: "ENTITY_D4",
    0xD5: "ENTITY_D5",
    0xD6: "ENTITY_SIDE_VIEW_POT",
    0xD7: "ENTITY_THWIMP",
    0xD8: "ENTITY_THWOMP",
    0xD9: "ENTITY_THWOMP_RAMMABLE",
    0xDA: "ENTITY_PODOBOO",
    0xDB: "ENTITY_GIANT_BUBBLE",
    0xDC: "ENTITY_FLYING_ROOSTER_EVENTS",
    0xDD: "ENTITY_BOOK",
    0xDE: "ENTITY_EGG_SONG_EVENT",
    0xDF: "ENTITY_SWORD_BEAM",
    0xE0: "ENTITY_MONKEY",
    0xE1: "ENTITY_WITCH_RAT",
    0xE2: "ENTITY_FLAME_SHOOTER",
    0xE3: "ENTITY_POKEY",
    0xE4: "ENTITY_MOBLIN_KING",
    0xE5: "ENTITY_FLOATING_ITEM_2",
    0xE6: "ENTITY_FINAL_NIGHTMARE",
    0xE7: "ENTITY_KANLET_CASTLE_GATE_SWITCH",
    0xE8: "ENTITY_ENDING_OWL_STAIR_CLIMBING",
    0xE9: "ENTITY_COLOR_SHELL_RED",
    0xEA: "ENTITY_COLOR_SHELL_GREEN",
    0xEB: "ENTITY_COLOR_SHELL_BLUE",
    0xEC: "ENTITY_COLOR_GHOUL_RED",
    0xED: "ENTITY_COLOR_GHOUL_GREEN",
    0xEE: "ENTITY_COLOR_GHOUL_BLUE",
    0xEF: "ENTITY_ROTOSWITCH_RED",
    0xF0: "ENTITY_ROTOSWITCH_YELLOW",
    0xF1: "ENTITY_ROTOSWITCH_BLUE",
    0xF2: "ENTITY_FLYING_HOPPER_BOMBS",
    0xF3: "ENTITY_HOPPER",
    0xF4: "ENTITY_GOLEM_BOSS",
    0xF5: "ENTITY_BOUNCING_BOULDER",
    0xF6: "ENTITY_COLOR_GUARDIAN_BLUE",
    0xF7: "ENTITY_COLOR_GUARDIAN_RED",
    0xF8: "ENTITY_GIANT_BUZZ_BLOB",
    0xF9: "ENTITY_COLOR_DUNGEON_BOSS",
    0xFA: "ENTITY_PHOTOGRAPHER_RELATED",
    0xFB: "ENTITY_FB",
    0xFC: "ENTITY_FC",
    0xFD: "ENTITY_FD",
    0xFE: "ENTITY_FE",
    0xFF: "ENTITY_FF",
  ])
  request.createDatatype(named: "DIRECTION", enumeration: [
    0: "DIRECTION_RIGHT",
    1: "DIRECTION_LEFT",
    2: "DIRECTION_UP",
    3: "DIRECTION_DOWN",
  ])
  request.createDatatype(named: "ROOM_STATUS", bitmask: [
    0x00: "ROOM_STATUS_NOT_VISITED",
    0x80: "ROOM_STATUS_VISITED",
  ])
  request.createDatatype(named: "SCROLL_VIEW", enumeration: [
    0: "SCROLL_VIEW_TOP",
    2: "SCROLL_VIEW_SIDE",
  ])
  request.createDatatype(named: "ANIMATED_TILES", enumeration: [
    0x00: "ANIMATED_TILES_NONE",
    0x01: "ANIMATED_TILES_COUNTER",
    0x02: "ANIMATED_TILES_TIDE",
    0x03: "ANIMATED_TILES_VILLAGE",
    0x04: "ANIMATED_TILES_DUNGEON_1",
    0x05: "ANIMATED_TILES_UNDERGROUND",
    0x06: "ANIMATED_TILES_LAVA",
    0x07: "ANIMATED_TILES_DUNGEON_2",
    0x08: "ANIMATED_TILES_WARP_TILE",
    0x09: "ANIMATED_TILES_CURRENTS",
    0x0A: "ANIMATED_TILES_WATERFALL",
    0x0B: "ANIMATED_TILES_WATERFALL_SLOW",
    0x0C: "ANIMATED_TILES_WATER_DUNGEON",
    0x0D: "ANIMATED_TILES_LIGHT_BEAM",
    0x0E: "ANIMATED_TILES_CRYSTAL_BLOCK",
    0x0F: "ANIMATED_TILES_BUBBLES",
    0x10: "ANIMATED_TILES_WEATHER_VANE",
    0x11: "ANIMATED_TILES_PHOTO",
  ])
  request.createDatatype(named: "JINGLE", enumeration: [
    0x01: "JINGLE_TREASURE_FOUND",
    0x02: "JINGLE_PUZZLE_SOLVED",
    0x03: "JINGLE_BOW_WOW_CHOMP",
    0x04: "JINGLE_CHARGING_SWORD",
    0x05: "JINGLE_POWDER",
    0x06: "JINGlE_ENNEMY_MORPH_IN",
    0x07: "JINGLE_SWORD_POKING",
    0x08: "JINGLE_JUMP_DOWN",
    0x09: "JINGLE_BUMP",
    0x0A: "JINGLE_MOVE_SELECTION",
    0x0B: "JINGLE_HUGE_BUMP",
    0x0C: "JINGLE_REVOLVING_DOOR",
    0x0D: "JINGLE_FEATHER_JUMP",
    0x0E: "JINGLE_WATER_DIVE",
    0x11: "JINGLE_OPEN_INVENTORY",
    0x12: "JINGLE_CLOSE_INVENTORY",
    0x13: "JINGLE_VALIDATE",
    0x14: "JINGLE_GOT_HEART",
    0x15: "JINGLE_DIALOG_BREAK",
    0x17: "JINGLE_GOT_POWER_UP",
    0x18: "JINGLE_ITEM_FALLING",
    0x19: "JINGLE_NEW_HEART",
    0x1D: "JINGLE_WRONG_ANSWER",
    0x1E: "JINGLE_FOREST_LOST",
    0x1F: "JINGLE_ENNEMY_MORPH_OUT",
    0x20: "JINGLE_BIG_BUMP",
    0x21: "JINGLE_SEAGULL",
    0x23: "JINGLE_DUNGEON_OPENED",
    0x24: "JINGLE_JUMP",
    0x2B: "JINGLE_INSTRUMENT_WARP",
    0x2C: "JINGLE_MANBO_WARP",
    0x3C: "JINGLE_ENNEMY_SHRIEK",
  ])
  request.createDatatype(named: "WAVE", enumeration: [
    0x01: "WAVE_SFX_SEASHELL",
    0x02: "WAVE_SFX_ZIP",
    0x03: "WAVE_SFX_LINK_HURT",
    0x04: "WAVE_SFX_LOW_HEARTS",
    0x05: "WAVE_SFX_RUPEE",
    0x06: "WAVE_SFX_HEART_PICKED_UP",
    0x07: "WAVE_SFX_BOSS_GRAWL",
    0x08: "WAVE_SFX_LINK_DIES",
    0x09: "WAVE_SFX_OCARINA_BALLAD",
    0x0A: "WAVE_SFX_OCARINA_FROG",
    0x0B: "WAVE_SFX_OCARINA_MAMBO",
    0x0C: "WAVE_SFX_LINK_FALLS",
    0x0F: "WAVE_SFX_TYPEWRITER",
    0x10: "WAVE_SFX_BOSS_AGONY",
    0x13: "WAVE_SFX_CUCOO_HURT",
    0x15: "WAVE_SFX_OCARINA_UNUSED",
    0x16: "WAVE_SFX_BOSS_HIT",
    0x18: "WAVE_SFX_CHAIN_CHOMP",
    0x19: "WAVE_SFX_HOOT",
    0x1B: "WAVE_SFX_COMPASS",
  ])
  request.createDatatype(named: "NOISE", enumeration: [
    0x02: "NOISE_SFX_SWORD_A",
    0x03: "NOISE_SFX_SPIN_ATTACK",
    0x04: "NOISE_SFX_DOOR_UNLOCKED",
    0x05: "NOISE_SFX_RUPEE",
    0x06: "NOISE_SFX_STAIRS",
    0x07: "NOISE_SFX_FOOTSTEP",
    0x09: "NOISE_SFX_POT_SMASHED",
    0x0A: "NOISE_SFX_SHOOT_ARROW",
    0x0C: "NOISE_SFX_BOMB_EXPLOSION",
    0x0D: "NOISE_SFX_MAGIC_ROD",
    0x0E: "NOISE_SFX_SHOWEL_DIG",
    0x0F: "NOISE_SFX_SEA_WAVES",
    0x10: "NOISE_SFX_DOOR_CLOSED",
    0x11: "NOISE_SFX_BLOCK_RUMBLE",
    0x13: "NOISE_SFX_ENEMY_DESTROYED",
    0x14: "NOISE_SFX_SWORD_B",
    0x15: "NOISE_SFX_SWORD_C",
    0x16: "NOISE_SFX_DRAW_SHIELD",
    0x18: "NOISE_SFX_SWORD_D",
    0x19: "NOISE_SFX_TITLE_APPEARS",
    0x2A: "NOISE_SFX_DOOR_RUMBLE",
    0x2B: "NOISE_SFX_ROCK_RUMBLE",
    0x30: "NOISE_SFX_EAGLE_TOUCHDOWN",
    0x31: "NOISE_SFX_EAGLE_LIFT_UP",
  ])
  request.createDatatype(named: "TRACK", enumeration: [
    0x00: "TRACK_NONE",
    0x01: "TRACK_TITLE_SCREEN",
    0x02: "TRACK_TRENDY_GAME",
    0x03: "TRACK_GAME_OVER",
    0x04: "TRACK_MABE_VILLAGE",
    0x05: "TRACK_OVERWORLD",
    0x06: "TRACK_TAL_TAL_HEIGHTS",
    0x07: "TRACK_VILLAGE_SHOP",
    0x08: "TRACK_RAFT_RIDE_RAPIDS",
    0x09: "TRACK_MYSTERIOUS_FOREST",
    0x0A: "TRACK_HOME_TRADER_HOUSE",
    0x0B: "TRACK_ANIMAL_VILLAGE",
    0x0C: "TRACK_FAIRY_HOUSE",
    0x0D: "TRACK_TITLE",
    0x0E: "TRACK_BOWWOW_KIDNAPPED",
    0x0F: "TRACK_FOUND_LEVEL_2_SWORD",
    0x10: "TRACK_FOUND_NEW_WEAPON",
    0x11: "TRACK_2D_UNDERGROUND_DUNGEON",
    0x12: "TRACK_OWL",
    0x13: "TRACK_FINAL_NIGHTMARE_IN_EGG",
    0x14: "TRACK_DREAM_SHRINE_ENTRANCE",
    0x15: "TRACK_FOUND_INSTRUMENT",
    0x16: "TRACK_OVERWORLD_CAVE",
    0x17: "TRACK_PIECE_OF_POWER",
    0x18: "TRACK_RECEIVED_HORN_INSTRUMENT",
    0x19: "TRACK_RECEIVED_BELL_INSTRUMENT",
    0x1A: "TRACK_RECEIVED_HARP_INSTRUMENT",
    0x1B: "TRACK_RECEIVED_XYLOPHONE_INSTRUMENT",
    0x1C: "TRACK_1C",
    0x1D: "TRACK_1D",
    0x1E: "TRACK_RECEIVED_THUNDER_DRUM_INSTRUMENT",
    0x1F: "TRACK_MARIN_SINGING",
    0x20: "TRACK_MANBO_SONG",
    0x21: "TRACK_21",
    0x22: "TRACK_22",
    0x23: "TRACK_23",
    0x24: "TRACK_24",
    0x25: "TRACK_COMPLETE_INSTRUMENTS_SONG_PART_1",
    0x26: "TRACK_COMPLETE_INSTRUMENTS_SONG_PART_2",
    0x27: "TRACK_27",
    0x28: "TRACK_LONELY_HOUSE",
    0x29: "TRACK_PIECE_OF_POWER_PART_2",
    0x2A: "TRACK_MARIN_SINGING_LINKS_OCARINA",
    0x2B: "TRACK_LEVEL_5",
    0x2C: "TRACK_DUNGEON_ENTRANCE_UNLOCKING",
    0x2D: "TRACK_DREAM_SEQUENCE_SOUND",
    0x2E: "TRACK_AT_BEACH_WITH_MARIN",
    0x2F: "TRACK_UNKNOWN",
    0x30: "TRACK_DUNGEON_SUB_BOSS",
    0x31: "TRACK_RECEIVED_LEVEL_1_SWORD",
    0x32: "TRACK_MR_WRITE_HOUSE",
    0x33: "TRACK_ULRIRA_HOUSE",
    0x34: "TRACK_TARIN_ATTACKED_BY_BEES",
    0x35: "TRACK_MAMU_SONG",
    0x36: "TRACK_MONKEYS_BUILDING_BRIDGE",
    0x37: "TRACK_MR_WRITE_HOUSE_VERSION_2",
    0x38: "TRACK_RICHARD_HOUSE_SECRET_SONG",
    0x39: "TRACK_TURTLE_ROCK_ENTRANCE_BOSS",
    0x3A: "TRACK_FISHING_GAME",
    0x3B: "TRACK_RECEIVED_ITEM",
    0x3C: "TRACK_HIDDEN_UNUSED_SONG",
    0x3D: "TRACK_NOTHING",
    0x3E: "TRACK_BOWWOW_STOLEN",
    0x3F: "TRACK_ENDING",
    0x40: "TRACK_RICHARD_HOUSE",
    0x41: "TRACK_41",
    0x42: "TRACK_42",
    0x43: "TRACK_43",
    0x44: "TRACK_44",
    0x45: "TRACK_45",
    0x46: "TRACK_46",
    0x47: "TRACK_47",
    0x48: "TRACK_48",
    0x49: "TRACK_ACTIVE_POWER_UP",
    0x4A: "TRACK_4A",
    0x4B: "TRACK_4B",
    0x4C: "TRACK_4C",
    0x4D: "TRACK_4D",
    0x50: "TRACK_50",
    0x58: "TRACK_58",
    0x59: "TRACK_59",
    0x5A: "TRACK_5A",
    0x5B: "TRACK_5B",
    0x5C: "TRACK_5C",
    0x5D: "TRACK_5D",
    0x5E: "TRACK_5E",
    0x5F: "TRACK_5F",
    0x60: "TRACK_60",
    0x61: "TRACK_COLOR_DUNGEON",
    0x6A: "TRACK_6A",
    0xF0: "TRACK_F0",
    0xFF: "TRACK_FF",
  ])
  request.createDatatype(named: "MUSIC_TIMING", representation: .decimal, enumeration: [
    0: "MUSIC_TIMING_NORMAL",
    1: "MUSIC_TIMING_DOUBLE",
    2: "MUSIC_TIMING_HALF",
  ])
  request.createDatatype(named: "ENTITY_STATE", representation: .decimal, enumeration: [
    0: "ENTITY_STATE_DISABLED",
    1: "ENTITY_STATE_DYING",
    2: "ENTITY_STATE_FALLING",
    3: "ENTITY_STATE_DESTROYING",
    4: "ENTITY_STATE_INIT",
    5: "ENTITY_STATE_ACTIVE",
    6: "ENTITY_STATE_STUNNED",
    7: "ENTITY_STATE_LIFTED",
    8: "ENTITY_STATE_THROWN",
  ])
  request.createDatatype(named: "LINK_MOTION", enumeration: [
    0x00: "LINK_MOTION_INTERACTIVE",
    0x01: "LINK_MOTION_FALLING_UP",
    0x02: "LINK_MOTION_JUMPING",
    0x03: "LINK_MOTION_MAP_FADE_OUT",
    0x04: "LINK_MOTION_MAP_FADE_IN",
    0x05: "LINK_MOTION_REVOLVING_DOOR",
    0x06: "LINK_MOTION_FALLING_DOWN",
    0x07: "LINK_MOTION_PASS_OUT",
    0x08: "LINK_MOTION_RECOVER",
    0x09: "LINK_MOTION_TELEPORT",
    0x0F: "LINK_MOTION_UNKNOWN",
  ])
  request.createDatatype(named: "LINK_GROUND_STATUS", representation: .decimal, enumeration: [
    0: "LINK_GROUND_DRY",
    1: "LINK_GROUND_STEPS",
    3: "LINK_GROUND_WET_OR_GRASSY",
    7: "LINK_GROUND_PIT",
  ])
  request.createDatatype(named: "ROOM_TRANSITION", representation: .decimal, enumeration: [
    0: "ROOM_TRANSITION_NONE",
    1: "ROOM_TRANSITION_LOAD_ROOM",
    2: "ROOM_TRANSITION_LOAD_SPRITES",
    3: "ROOM_TRANSITION_CONFIGURE_SCROLL",
    4: "ROOM_TRANSITION_FIRST_HALF",
    5: "ROOM_TRANSITION_SECOND_HALF",
  ])
  request.createDatatype(named: "ROOM_TRANSITION_DIRECTION", representation: .decimal, enumeration: [
    0: "ROOM_TRANSITION_DIR_RIGHT",
    1: "ROOM_TRANSITION_DIR_LEFT",
    2: "ROOM_TRANSITION_DIR_TOP",
    3: "ROOM_TRANSITION_DIR_BOTTOM",
  ])
  request.createDatatype(named: "SWORD_DIRECTION", representation: .decimal, enumeration: [
    0: "SWORD_DIRECTION_RIGHT",
    1: "SWORD_DIRECTION_RIGHT_BOTTOM",
    2: "SWORD_DIRECTION_BOTTOM",
    3: "SWORD_DIRECTION_LEFT_BOTTOM",
    4: "SWORD_DIRECTION_LEFT",
    5: "SWORD_DIRECTION_LEFT_TOP",
    6: "SWORD_DIRECTION_TOP",
    7: "SWORD_DIRECTION_RIGHT_TOP",
  ])
  request.createDatatype(named: "SWORD_ANIMATION_STATE", representation: .decimal, enumeration: [
    0: "SWORD_ANIMATION_NONE",
    1: "SWORD_ANIMATION_START",
    2: "SWORD_ANIMATION_MIDDLE",
    3: "SWORD_ANIMATION_FRONT",
    4: "SWORD_ANIMATION_END",
  ])

}
