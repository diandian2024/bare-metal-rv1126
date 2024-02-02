{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.cmake
    pkgs.ninja
    pkgs.qemu
    pkgs.llvmPackages_16.clangUseLLVM
    pkgs.llvmPackages_16.bintools-unwrapped
    pkgs.rkdeveloptool
  ];

  # shellHook = ''
  #   export SUITE_SPARSE_ROOT=${pkgs.suitesparse.dev}
  # '';
}
