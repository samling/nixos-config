{
  flake.modules.homeManager.common = { pkgs, ... }: let
    # Wrap imv so xdg-open / file-manager launches load the whole directory
    # and start at the clicked file, so left/right walk siblings.
    imvOpen = pkgs.writeShellApplication {
      name = "imv-open";
      runtimeInputs = [ pkgs.imv ];
      text = ''
        if [ "$#" -eq 1 ] && [ -f "$1" ]; then
          exec imv -n "$1" "$(dirname -- "$1")"
        fi
        exec imv -- "$@"
      '';
    };
  in {
    home.packages = with pkgs; [
      chafa
      feh
      ffmpeg
      ffmpegthumbnailer
      grim
      grimblast
      imagemagick
      imv
      imvOpen
      mpv
      satty
      slurp
      yt-dlp
    ];

    xdg.desktopEntries.imv = {
      name = "imv";
      genericName = "Image Viewer";
      exec = "${imvOpen}/bin/imv-open %F";
      icon = "imv";
      mimeType = [
        "image/jpeg"
        "image/png"
        "image/gif"
        "image/bmp"
        "image/webp"
        "image/tiff"
      ];
      categories = [ "Graphics" "Viewer" ];
    };
  };
}
