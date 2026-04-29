{
  flake.modules.homeManager.base = { pkgs, ... }: let
    # Wrap feh so xdg-open / file-manager launches size the window to 2/3 of
    # the focused monitor. wlr-randr is compositor-agnostic across niri/hyprland
    # (both implement wlr-output-management); falls back to 1920x1080.
    fehWindow = pkgs.writeShellApplication {
      name = "feh-window";
      runtimeInputs = with pkgs; [ feh jq wlr-randr ];
      text = ''
        mode=$(wlr-randr --json 2>/dev/null \
          | jq -r 'first(.[] | select(.enabled)).modes
                   | first(.[] | select(.current))
                   | "\(.width) \(.height)"' 2>/dev/null || true)
        read -r mw mh <<<"''${mode:-1920 1080}"
        w=$(( mw * 2 / 3 ))
        h=$(( mh * 2 / 3 ))
        # When launched on a single file (xdg-open / file manager click), load
        # the whole directory and start at the file so left/right walk siblings.
        if [ "$#" -eq 1 ] && [ -f "$1" ]; then
          exec feh --geometry "''${w}x''${h}" --auto-zoom \
            --start-at "$1" -- "$(dirname -- "$1")"
        fi
        exec feh --geometry "''${w}x''${h}" --auto-zoom -- "$@"
      '';
    };
  in {
    home.packages = with pkgs; [
      chafa
      feh
      fehWindow
      ffmpeg
      ffmpegthumbnailer
      grim
      grimblast
      imagemagick
      mpv
      satty
      slurp
      yt-dlp
    ];

    xdg.desktopEntries.feh = {
      name = "feh";
      genericName = "Image Viewer";
      exec = "${fehWindow}/bin/feh-window %F";
      icon = "feh";
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
