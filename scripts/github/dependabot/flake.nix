# /qompassai/Shell/scripts/dependabot/flake.nix
# ------------------------------------------------
# Copyright (C) 2025 Qompass AI, All rights reserved

# ~/nix-flakes/dependabot-cli/flake.nix
{
  description = "Self-hosted Dependabot CLI wrapper";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
      in {
        packages.default = pkgs.writeShellApplication {
          name = "dependabot-cli";

          runtimeInputs = with pkgs; [
            docker
            git
            gnupg
            jq
            curl
            ruby
            nodejs
            yq-go
            sops
            gh
            pass
          ];

          text = builtins.readFile ./scripts/dependabot.sh;
        };

        devShells.default = pkgs.mkShell {
          name = "dependabot-devshell";
          packages = with pkgs; [
            docker
            gh
            pass
            sops
            yq-go
            ruby
            nodejs
          ];

          shellHook = ''
            echo "Enter ./scripts/ to modify dependabot.sh"
            echo "Run via: nix run . -- --repo qompassai/current --token-source pass"
          '';
        };
      });
}
