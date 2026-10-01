{ pkgs, username, ... }:
{
    users.users.${username} = {
        isNormalUser = true;
        description = "Main user";

        extraGroups = [
            "wheel"
            "networkmanager"
            "video"
            "render"
            "audio"
            "input"
        ];

        shell = pkgs.bash;
    };

    users.mutableUsers = true;

    security.sudo.wheelNeedsPassword = true;
}
