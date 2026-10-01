{ pkgs, ... }:
{
    programs.steam = {
        enable = true;

        remotePlay.openFirewall = true;

        localNetworkGameTransfers.openFirewall = true;

        dedicatedServer.openFirewall = false;

        gamescopeSession.enable = true;

        extraCompatPackages = with pkgs; [ proton-ge-bin ];
    };

    programs.gamescope = {
        enable = true;
        capSysNice = true;
    };

    programs.gamemode.enable = true;

    environment.systemPackages = with pkgs; [
        mangohud
        protonup-qt
        lutris
        bottles
    ];
}
