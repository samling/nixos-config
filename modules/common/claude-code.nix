{ inputs, ... }:
{
  flake.modules.homeManager.common = { pkgs, ... }: let
    llm-agents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    home.packages = (with pkgs; [
      bubblewrap
      libseccomp
      sandbox-runtime
      socat
    ]) ++ (with llm-agents; [
      claude-code
    ]);

    # Claude Code's sandbox expects a prebuilt BPF blob and apply-seccomp helper
    # at stable user paths (referenced by sandbox.seccomp.{bpfPath,applyPath} in
    # ~/.claude/settings.json). nixpkgs' sandbox-runtime ships sources only, so
    # pkgs.claude-seccomp builds them and we symlink them into XDG_DATA_HOME.
    xdg.dataFile."claude-code/seccomp/x64/apply-seccomp".source =
      "${pkgs.claude-seccomp}/share/claude-code/seccomp/x64/apply-seccomp";
    xdg.dataFile."claude-code/seccomp/x64/seccomp-unix-block.bpf".source =
      "${pkgs.claude-seccomp}/share/claude-code/seccomp/x64/seccomp-unix-block.bpf";
  };
}
