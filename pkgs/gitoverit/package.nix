{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "gitoverit";
  version = "0-unstable-2026-04-19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mevanlc";
    repo = "gitoverit";
    rev = "6d28bcbd357882ea3cc08af3c6b4bfc7d46f2ee2";
    hash = "sha256-pC7qrsJLHFvHQQMV3w/cMLX4B/EBvhXWifVwLgvEpro=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  dependencies = with python3.pkgs; [
    gitpython
    rich
    simpleeval
    typer
  ];

  pythonImportsCheck = [
    "gitoverit"
  ];

  meta = {
    description = "Status all your repos at once, and more";
    homepage = "https://github.com/mevanlc/gitoverit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "gitoverit";
  };
})
