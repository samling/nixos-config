{
  flake.modules.homeManager.media = { pkgs, ... }: {
    home.packages = with pkgs; [
      chafa
      feh
      ffmpeg
      imagemagick
      mpv
      yt-dlp
    ];
  };
}
