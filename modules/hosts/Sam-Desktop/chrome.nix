{ config, ... }:
let
  owner = config.flake.meta.owner.username;
in
{
  configurations.nixos."Sam-Desktop".module = { pkgs, ... }: let
    # Hand URLs to the host's Chrome via WSL interop instead of running a
    # Linux Chrome under WSLg. chrome.exe accepts http(s) URLs directly.
    winChrome = "/mnt/c/Program Files/Google/Chrome/Application/chrome.exe";

    chromeWrapper = pkgs.writeShellScriptBin "google-chrome" ''
      exec "${winChrome}" "$@"
    '';
  in {
    home-manager.users.${owner} = {
      # xdg-utils gives us a real xdg-open so CLIs like tsh (which shell out
      # to xdg-open and ignore $BROWSER) resolve via mimeApps → the desktop
      # entry below → the Windows Chrome wrapper.
      home.packages = [ chromeWrapper pkgs.xdg-utils ];

      xdg = {
        desktopEntries.google-chrome = {
          name = "Google Chrome";
          genericName = "Web Browser";
          exec = "${chromeWrapper}/bin/google-chrome %U";
          icon = "google-chrome";
          categories = [ "Network" "WebBrowser" ];
          mimeType = [
            "text/html"
            "x-scheme-handler/http"
            "x-scheme-handler/https"
            "x-scheme-handler/about"
            "x-scheme-handler/unknown"
          ];
        };

        mime.enable = true;
        mimeApps = {
          enable = true;
          defaultApplications = {
            "text/html" = [ "google-chrome.desktop" ];
            "x-scheme-handler/http" = [ "google-chrome.desktop" ];
            "x-scheme-handler/https" = [ "google-chrome.desktop" ];
            "x-scheme-handler/about" = [ "google-chrome.desktop" ];
            "x-scheme-handler/unknown" = [ "google-chrome.desktop" ];
          };
        };
      };

      home.sessionVariables.BROWSER = "${chromeWrapper}/bin/google-chrome";
    };
  };
}
