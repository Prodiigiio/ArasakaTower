{ pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        kdePackages.kdenlive

        frei0r
        mediainfo
        mediainfo-gui

        ffmpeg-full
        handbrake

        obs-studio

        vlc
        mpv
        audacity
        gimp
        krita
    ];
}
