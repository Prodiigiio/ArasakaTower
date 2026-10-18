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

    powerManagement.cpuFreqGovernor = "performance";

    boot.kernel.sysctl = {
        "vm.swappiness" = 10;
        "vm.dirty_ratio" = 15;
        "vm.dirty_background_ratio" = 5;
    };

    environment.systemPackages = with pkgs; [
        vim
        wget
        curl
    ];

    system.stateVersion = "25.11";
}
