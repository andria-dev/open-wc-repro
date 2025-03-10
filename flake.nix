{
  description = "Development environment for testing open-wc templates.";

  # Flake inputs
  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.2405.*.tar.gz";
  };

  # Flake outputs
  outputs = { self, nixpkgs }:
    let
      # Systems supported
      allSystems = [
        "x86_64-linux" # 64-bit Intel/AMD Linux
        "aarch64-linux" # 64-bit ARM Linux
        "x86_64-darwin" # 64-bit Intel macOS
        "aarch64-darwin" # 64-bit ARM macOS
      ];

			lib = nixpkgs.lib;

      # Helper to provide system-specific attributes
      forAllSystems = f: lib.genAttrs allSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      # Development environment output
      devShells = forAllSystems ({ pkgs }: {
        default = pkgs.mkShell {
          # The Nix packages provided in the environment
          packages = with pkgs; [
            nodejs_20 # Node@20 plus npm, npx, and corepack
            yarn-berry
						nushell
          ];

					shellHook = ''
						exec nu -e "$(cat ./setup.nu)"
					'';
        };
      });
    };
}
