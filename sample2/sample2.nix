with (import <nixpkgs> {});
derivation {
  name = "simple_hello";
  builder = "${bash}/bin/bash";
  args = [ ./hello_builder.sh ];
  inherit gnutar gzip gnumake gcc binutils coreutils gawk gnused gnugrep;
  src = ./hello-2.10.tar.gz;
  system = builtins.currentSystem;
}
