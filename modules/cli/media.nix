{
  flake.modules.homeManager.base = { pkgs, ... }: {
    home.packages = with pkgs; [
      chafa
      feh
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
  };
}
