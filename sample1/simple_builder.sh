set -e 

declare -xp

echo "----------------"
echo $buildInputs
echo "----------------"

${coreutils}/bin/mkdir -p $out/bin
${gcc}/bin/cc -o $out/bin/simple $src
