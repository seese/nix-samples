# Nix

## nix-env

* nix-env -i nmap
* nix-env --list-generations
* nix-env -q
* nix-env --rollback
* nix-env -G 3

## nix-store

* nix-store -q --references ``which nix-repl``
* nix-store -q --referrers ``which nix-repl``

### Closure

* nix-store -qR `which nix-repl`
* nix-store -q --tree `which nix-repl`

## Nix-language

* keine Division -> bultins.div
* 2/3 -> wird als Pfad geparst - relativ zum aktuellen Verzeichnis
* Bindestrich in Variablennamen erlaubt

### Strings

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

### Listen

```nix
[ 1 "foo" true (2 + 3) ]
```

### Attribute sets

```nix
{ foo = "bar"; a-b = ''foo''; "123" = "num"; }

```

### Recursive Attribut-Sets

```nix
rec { a = 3; b = a + 3; }
```

### If-Expressions

```nix
let
a = 1;
b = 2;
in
if a > b then "yes" else "no"
```

### Let-Expression

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

### With-Expression

```nix
let a = { x = 1; y = 2; }; in with a; x + y
```

### Funktionen

```nix
let 
mul = x: y: x * y;
in
mul 5 6
```

#### Argument-Sets

```nix
let 
setMul = x: x.a * x.b;
in 
setMul { a = 5; b = 6; }
```

#### Argumente mit Standard-Werten

```nix
let
mul = { a, b ? 2 }: a * b;
in
mul { a = 5; }
```

#### Variadische Argumente

```nix
let
mul = { a, b, ... }: a * b;
in
mul { a = 2; b = 3; c = 4; }
```

#### Variadische Argumente und @-Pattern

```nix
let
mul = s@{ a, b, ... }: a * b * s.c;
in
mul { a = 2; b = 3; c = 4; }
```

### Importe

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

### Derivation

Ein *derivation* wird mit der built-in Funktion derivation erzeugt. 

Die Funktion erwartet ein *Set* als argument. Folgende Attribute müssen im Set
übergeben werden:

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

