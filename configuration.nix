{ ... }:
{
    imports = [
        ./hardware-configuration.nix
        ./modules
    ];

    _module.args = {
        hostname = "ArasakaTower";
        username = "cowboy";
    };
}
