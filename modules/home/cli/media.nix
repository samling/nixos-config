{
  flake.modules.homeManager.media = { pkgs, ... }: {
    home.packages = with pkgs; [
      chafa
      feh
      ffmpeg
      ffmpegthumbnailer
      imagemagick
      mpv
      yt-dlp
    ];
  };
}
