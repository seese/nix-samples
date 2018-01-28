set -e
declare -xp

export PATH=${gnutar}/bin:${gzip}/bin:${gcc}/bin:${gnumake}/bin:${binutils}/bin:${coreutils}/bin:${gawk}/bin:${gnused}/bin:${gnugrep}/bin

echo $PATH

tar xzf $src

cd hello-2.10

./configure --prefix=$out
make
make install
