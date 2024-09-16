{
  description = "wkhtmltopdf 0.12.5 with patched qt";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
  };

  outputs = { self, nixpkgs, }:
  let
    supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  in {
    packages = forAllSystems (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.stdenv.mkDerivation {
        name = "wkhtmltopdf";
        src = pkgs.fetchurl {
          url = "https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.bionic_amd64.deb";
          sha256 = "503a8a97fcf8fd397ed52c1789471e0f2513f5752f3e214d3a5eda30caa0354b";
        };
        unpackCmd = "${pkgs.dpkg}/bin/dpkg-deb -x $curSrc .";
        nativeBuildInputs = [ pkgs.autoPatchelfHook ];
        buildInputs = [
          pkgs.libjpeg_original
          pkgs.freetype
          pkgs.xorg.libX11
          pkgs.xorg.libXrender
          pkgs.openssl
          pkgs.fontconfig
          pkgs.stdenv.cc.cc.lib
        ];
        installPhase = ''
          mkdir -p $out
          cp -rv . $out/
        '';
      };
    }
    );
  };
}
