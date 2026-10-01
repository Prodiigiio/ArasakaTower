{ pkgs, ... }:
{
    time.timeZone = "America/New_York";

    i18n.defaultLocale = "en_US.UTF-8";
    console.keyMap = "us";

    nixpkgs.config.allowUnfree = true;

    nix.settings = {
        experimental-features = [ "nix-command" "flakes" ];

        max-jobs = "auto";

        trusted-users = [ "root" "@wheel" ];
    };

    nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
    };
    nix.optimise.automatic = true;

    environment.systemPackages = with pkgs; [
        vim
        wget
        curl
    ];

    system.stateVersion = "25.11";
}
