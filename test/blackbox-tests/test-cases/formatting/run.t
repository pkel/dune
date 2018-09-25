Formatting can be checked using the @fmt target:

  $ cp enabled/ocaml_file.ml.orig enabled/ocaml_file.ml
  $ cp enabled/reason_file.re.orig enabled/reason_file.re
  $ dune build @fmt
  File "enabled/reason_file.rei", line 1, characters 0-0:
  Files _build/default/enabled/reason_file.rei and _build/default/enabled/reason_file.rei.formatted differ.
  File "enabled/ocaml_file.mli", line 1, characters 0-0:
  Files _build/default/enabled/ocaml_file.mli and _build/default/enabled/ocaml_file.mli.formatted differ.
  File "enabled/reason_file.re", line 1, characters 0-0:
  Files _build/default/enabled/reason_file.re and _build/default/enabled/reason_file.re.formatted differ.
  File "enabled/ocaml_file.ml", line 1, characters 0-0:
  Files _build/default/enabled/ocaml_file.ml and _build/default/enabled/ocaml_file.ml.formatted differ.
  File "enabled/subdir/lib.ml", line 1, characters 0-0:
  Files _build/default/enabled/subdir/lib.ml and _build/default/enabled/subdir/lib.ml.formatted differ.
  File "partial/a.ml", line 1, characters 0-0:
  Files _build/default/partial/a.ml and _build/default/partial/a.ml.formatted differ.
  [1]

And fixable files can be promoted:

  $ dune promote enabled/ocaml_file.ml enabled/reason_file.re
  Promoting _build/default/enabled/ocaml_file.ml.formatted to enabled/ocaml_file.ml.
  Promoting _build/default/enabled/reason_file.re.formatted to enabled/reason_file.re.
  $ cat enabled/ocaml_file.ml
  Sys.argv: ../../install/default/bin/ocamlformat --impl ocaml_file.ml --name ../../../enabled/ocaml_file.ml -o ocaml_file.ml.formatted
  ocamlformat was called on: let  y=()
  $ cat enabled/reason_file.re
  Sys.argv: ../../install/default/bin/refmt reason_file.re
  refmt was called on: let  y = ();
