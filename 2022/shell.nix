{ pkgs ? import <nixpkgs> {}
}:
pkgs.mkShell {
	name="Advent of Code dev environment";
	buildInputs = [
		pkgs.nil # nix LSP
	];
}
