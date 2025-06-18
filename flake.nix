{
  description = "uxn calendar";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      flake-utils,
      nixpkgs,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = {
          default =
            with pkgs;
            stdenv.mkDerivation {
              name = "calendar";

              nativeBuildInputs = with pkgs; [
                uxn
              ];

              src = pkgs.fetchurl {
                url = "https://wiki.xxiivv.com/etc/calendar.tal.txt";
                sha256 = "sha256-voPl8ZEYuii6ZkoBpfEujvJMMtgy7U1N4PTSwpzmErU="; # pkgs.lib.fakeSha256;
              };

              unpackPhase = ''
                cp $src calendar.tal
              '';

              patchPhase = ''
                substituteInPlace calendar.tal \
                --replace ".theme" "/home/a/.config/uxn/theme"
              '';

              buildPhase = ''
                uxnasm calendar.tal calendar.rom
              '';

              installPhase = ''
                mkdir -p $out/bin
                cp calendar.rom $out/bin
              '';
            };
        };
      }
    );
}
