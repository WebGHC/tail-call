with import <nixpkgs> {};
let
 inherit (nixpkgs) pkgs;
  myTexLive = texlive.combine {
    inherit (texlive)
    framed
    import
    scheme-small
    wrapfig
    
    # required for other
    varwidth
    needspace
    latexmk

    # required for sphinx
    capt-of
    collection-fontsrecommended
    environ
    eqparbox
    fncychap
    multirow
    tabulary
    threeparttable
    titlesec
    trimspaces
    ;
  };
  py = python35.withPackages (ps: with ps; [ sphinx ]);
  oc = with ocamlPackages_latest; [ocaml ocamlbuild findlib];
in
  stdenv.mkDerivation {
    name = "ocaml-env";
    buildInputs = [gnumake myTexLive py oc];
  }
