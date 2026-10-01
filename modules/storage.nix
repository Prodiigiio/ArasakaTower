{ pkgs, ... }:
{
    services.udisks2.enable = true;

    services.gvfs.enable = true;

    services.tumbler.enable = true;

    boot.supportedFilesystems = [ "ntfs" "exfat" ];

    environment.systemPackages = with pkgs; [
        ntfs3g
        exfatprogs
        dosfstools
        gparted
        baobab

        file-roller
        p7zip
        unzip
        zip

        nemo-with-extensions
    ];
}
