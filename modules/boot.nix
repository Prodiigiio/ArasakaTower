{ ... }:
{
    boot.loader = {
        systemd-boot = {
            enable = true;

            configurationLimit = 10;
        };
        efi.canTouchEfiVariables = true;
    };

    boot.plymouth.enable = true;
    boot.kernelParams = [ "quiet" "splash" ];
}
