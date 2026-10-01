{ pkgs, ... }:
let
    channel = builtins.tryEval <unstable>;

    unstable =
        if channel.success then
            import channel.value { config.allowUnfree = true; }
        else
            throw ''

                ----------------------------------------------------------------
                The 'unstable' channel is missing, and packages.nix needs it
                for claude-code.

                Fix it with these two commands, then rebuild:

                  sudo nix-channel --add https://nixos.org/channels/nixos-unstable unstable
                  sudo nix-channel --update

                Or, to stop using unstable entirely: in modules/packages.nix
                change `unstable.claude-code` to plain `claude-code` and
                delete this block. You then get 2.1.140 instead of 2.1.283.
                ----------------------------------------------------------------
            '';
in
{
    environment.systemPackages = with pkgs; [
        brave

        git
        gh
        claude-code

        btop
        fastfetch
        tree
        ripgrep
        fd
        bat

        keepassxc
        libreoffice-fresh
        qbittorrent

	jetbrains.idea-ultimate

	rPackages.RobLox

	discord
    ];

    programs.git = {
        enable = true;
        config = {
            init.defaultBranch = "main";
            pull.rebase = false;
            safe.directory = "/etc/nixos";
        };
    };
}
