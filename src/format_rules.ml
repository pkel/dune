open Import

let flag_of_kind : Ml_kind.t -> _ =
  function
  | Impl -> "--impl"
  | Intf -> "--intf"

let config_includes (config : Dune_file.Auto_format.t) s =
  match config.enabled_for with
  | Default -> true
  | Only set -> List.mem s ~set

let add_diff sctx loc ~dir input output =
  let module SC = Super_context in
  let open Build.O in
  let action = Action.diff input output in
  let alias_conf_name = "fmt" in
  let stamp = ("format-alias", action) in
  let alias = Build_system.Alias.make alias_conf_name ~dir in
  SC.add_alias_action sctx alias ~loc:(Some loc) ~locks:[] ~stamp
    (Build.paths [input; output]
     >>>
     Build.action
       ~dir
       ~targets:[]
       action)

let gen_rules sctx (config : Dune_file.Auto_format.t) ~dir =
  let loc = config.loc in
  let files =
    File_tree.files_of
      (Super_context.file_tree sctx)
      (Path.drop_build_context_exn dir)
  in
  let programs = Hashtbl.create 3 in
  let resolve_program program_name =
    Hashtbl.find_or_add
      programs
      ~f:(Super_context.resolve_program sctx ~loc:(Some loc))
      program_name
  in
  Path.Set.iter files ~f:(fun file ->
    let input_basename = Path.basename file in
    let target_s = input_basename ^ ".formatted" in
    let input = Path.relative dir input_basename in
    let output = Path.relative ~error_loc:loc dir target_s in
    let context = Super_context.context sctx in

    let ocaml kind =
      if config_includes config Ocaml then
        let exe = resolve_program "ocamlformat" in
        let args =
          let open Arg_spec in
          [ A (flag_of_kind kind)
          ; Dep input
          ; A "--name"
          ; Path file
          ; A "-o"
          ; Target output
          ]
        in
        Some (Build.run ~context ~dir exe args)
      else
        None
    in

    let formatter =
      match Path.extension file with
      | ".ml" -> ocaml Impl
      | ".mli" -> ocaml Intf
      | ".re"
      | ".rei" when config_includes config Reason ->
        let exe = resolve_program "refmt" in
        let args = [Arg_spec.Dep input] in
        Some (Build.run ~context ~dir ~stdout_to:output exe args)
      | _ -> None
    in

    Option.iter formatter ~f:(fun arr ->
      Super_context.add_rule sctx ~mode:Standard ~loc arr;
      add_diff sctx loc ~dir input output))
