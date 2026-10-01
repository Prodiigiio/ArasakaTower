{ pkgs, ... }:
{
    services.desktopManager.cosmic.enable = true;
    services.displayManager.cosmic-greeter.enable = true;

    services.desktopManager.cosmic.xwayland.enable = true;

    services.getty.autologinUser = null;

    fonts = {
        enableDefaultPackages = true;
        packages = with pkgs; [
            noto-fonts
            noto-fonts-color-emoji
            liberation_ttf
            nerd-fonts.jetbrains-mono
        ];
    };

    xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
}
