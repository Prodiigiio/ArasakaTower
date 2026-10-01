{ pkgs, ... }:
{
    boot.initrd.kernelModules = [ "amdgpu" ];

    hardware.graphics = {
        enable = true;

        enable32Bit = true;
    };

    environment.systemPackages = with pkgs; [
        vulkan-tools
        libva-utils
        mesa-demos
        radeontop
    ];
}
