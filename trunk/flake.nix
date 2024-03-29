{
  description = ''Transport Services Interface'';

  inputs.flakeNimbleLib.owner = "riinr";
  inputs.flakeNimbleLib.ref   = "master";
  inputs.flakeNimbleLib.repo  = "nim-flakes-lib";
  inputs.flakeNimbleLib.type  = "github";
  inputs.flakeNimbleLib.inputs.nixpkgs.follows = "nixpkgs";
  
  inputs.src-taps-trunk.flake = false;
  inputs.src-taps-trunk.ref   = "trunk";
  inputs.src-taps-trunk.owner = "~ehmry";
  inputs.src-taps-trunk.repo  = "nim_taps";
  inputs.src-taps-trunk.type  = "sourcehut";
  
  inputs."getdns".owner = "nim-nix-pkgs";
  inputs."getdns".ref   = "master";
  inputs."getdns".repo  = "getdns";
  inputs."getdns".dir   = "20220928";
  inputs."getdns".type  = "github";
  inputs."getdns".inputs.nixpkgs.follows = "nixpkgs";
  inputs."getdns".inputs.flakeNimbleLib.follows = "flakeNimbleLib";
  
  outputs = { self, nixpkgs, flakeNimbleLib, ...}@deps:
  let 
    lib  = flakeNimbleLib.lib;
    args = ["self" "nixpkgs" "flakeNimbleLib" "src-taps-trunk"];
    over = if builtins.pathExists ./override.nix 
           then { override = import ./override.nix; }
           else { };
  in lib.mkRefOutput (over // {
    inherit self nixpkgs ;
    src  = deps."src-taps-trunk";
    deps = builtins.removeAttrs deps args;
    meta = builtins.fromJSON (builtins.readFile ./meta.json);
  } );
}