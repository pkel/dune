  $ [ -e dune-project ] || echo File does not exist
  File does not exist
  $ mkdir src
  $ echo '(alias (name runtest) (action (progn)))' >  src/dune
  $ dune build
  Info: creating file dune-project with this contents: (lang dune 1.3)
  $ cat dune-project
  (lang dune 1.3)

Test that using menhir automatically update the dune-project file

  $ echo '(library (name x)) (menhir (modules x))' >> src/dune
  $ dune build
  Info: appending this line to dune-project: (using menhir 1.0)
  $ cat dune-project
  (lang dune 1.3)
  (using menhir 1.0)
