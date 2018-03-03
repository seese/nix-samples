# Nix

## nix-env

```bash
nix-env -i nmap
nix-env --list-generations
nix-env -q
nix-env --rollback
nix-env -G 3
```

## nix-store

```bash
nix-store -q --references $(which nix-repl)
nix-store -q --referrers $(which nix-repl)
```

### closures

```bash
nix-store -qR $(which nix-repl)
nix-store -q --tree $(which nix-repl)
```

### realize

```bash
nix-store -r $(nix-instantiate ./test.nix)
```

### garbage collection

```bash
nix-store --gc
```

## nix-shell

```bash
nix-shell '\<nixpkgs\>' -A i3-gaps
```

* unpackPhase
* configurePhase
* buildPhase 

## nix-collect-garbage

```bash
nix-collect-garbage
nix-collect-garbage -d
```

## nix-instantiate

```bash
nix-instantiate --eval --expr '"Hello " + "world"'
nix-instantiate --eval --expr '2 + 3'
nix-instantiate --eval --expr '(400 + 2) * (5) + (5 * 5)'

nix-instantiate --eval ./sample.nix
```

## nix-language

* keine Division -> bultins.div
* 2/3 -> wird als Pfad geparst - relativ zum aktuellen Verzeichnis
* Bindestrich in Variablennamen erlaubt

### boolean 

```nix
! A     # if A then false else true
A || B  # if A then true else B
A && B  # if A then B else false
A -> B  # if A then B else true
```

### strings

```nix
"foo"
''foo''

# interpolation
"${val1}"
''${val1 + val2}''

# escaping
"\${val1}"
''''${val1}}
```

### listen

```nix
[ 1 "foo" true (2 + 3) ]

builtins.elemAt [ 1 2 3 ] 1
```

### attribute sets

```nix
{ foo = "bar"; a-b = ''foo''; "123" = "num"; }
```

```nix
# is a in s?
let
s = { a = 100; };
in
if s ? a then "yes" else "no"
```

### recursive Attribut-Sets

```nix
rec { a = 3; b = a + 3; }
```

### if-expressions

```nix
let
a = 1;
b = 2;
in
if a > b then "yes" else "no"
```

### let-expression

```nix
let a = 100; in a
```

```nix
let a = 100; b = 200; in a + b
```

```nix
let a = 100; in let b = 1000; in a + b
```

Variablen verdecken

```nix
let a = 100; in let a = 200; in a
```

Auf Variablen verweisen

```nix
let a = 100; b = (a + 100); in b
```

### with-expression

```nix
let a = { x = 1; y = 2; }; in with a; x + y
```

### funktionen

```nix
let 
mul = x: y: x * y;
in
mul 5 6
```

#### argument-Sets

```nix
let 
setMul = x: x.a * x.b;
in 
setMul { a = 5; b = 6; }
```

#### argumente mit standard-werten

```nix
let
mul = { a, b ? 2 }: a * b;
in
mul { a = 5; }
```

#### variadische argumente

```nix
let
mul = { a, b, ... }: a * b;
in
mul { a = 2; b = 3; c = 4; }
```

#### variadische argumente und @-pattern

```nix
let
mul = s@{ a, b, ... }: a * b * s.c;
in
mul { a = 2; b = 3; c = 4; }
```

### importe

a.nix:
```nix
2
```

b.nix:
```nix
3
```

mul.nix:
```nix
a: b: a * b
```

calc.nix:
```nix
let
a = import ./a.nix;
b = import ./b.nix;
mul = import ./mul.nix;
in
mul a b
```

### inherit

```nix
let
val1 = "val1";
s = {
  val2 = "val2";
  inherit val1;
};
in
s
```

Ergebnis: `{ val1 = "val1"; val2 = "val2"; }`

### derivation

* Erzeugen mti der built-in Funktion **derivation**
* Funktionsparameter ist ein Set mit folgenden **Muss-Werten**:
  * name
  * system
  * builder

```nix-repl
:l <nixpkgs>
"${coreutils}"
d = derivation { name = "myname"; builder = "${coreutils}/bin/true"; system = builtins.currentSystem; }
```

```nix-repl
:l <nixpkgs>
simple = derivation { name = "simple"; builder = "${bash}/bin/bash"; args = [ ./simple_builder.sh ]; gcc = gcc; coreutils = coreutils; src = ./simple.c; system = builtins.currentSystem; }
:b simple
```


