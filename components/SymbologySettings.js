export class SymbologySettings {

  constructor() {
    this.checksums = [];
    this.extensions = [];
  }

}

SymbologySettings.Checksum = {
    MOD_10: "mod10",
    MOD_11: "mod11",
    MOD_47: "mod47",
    MOD_43: "mod43",
    MOD_103: "mod103",
    MOD_1010: "mod1010",
    MOD_1110: "mod1110"
}

SymbologySettings.Extension = {
    TINY: "tiny",
    FULL_ASCII: "full_ascii",
    REMOVE_LEADING_ZERO: "remove_leading_zero"
}
