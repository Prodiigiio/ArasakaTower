# vega — gaming / video editing desktop

NixOS 25.11, COSMIC desktop, Radeon RX 6600.
Built from **channels**, not flakes. The config is version-controlled with **git**.

---

## 1. What is where

```
/etc/nixos/
├── configuration.nix          entry point. hostname + username live here
├── hardware-configuration.nix GENERATED. never edit, never copy from another PC
├── README.md                  this file
└── modules/
    ├── default.nix            the list of modules below. add new files here
    ├── boot.nix               bootloader, kernel
    ├── base.nix               timezone, locale, nix settings, auto cleanup
    ├── network.nix            hostname, wifi, firewall
    ├── users.nix              the user account and its groups
    ├── cosmic.nix             COSMIC desktop, login screen, fonts
    ├── graphics.nix           AMD RX 6600
    ├── audio.nix              PipeWire
    ├── storage.nix            USB drives, NTFS/exFAT, archives
    ├── gaming.nix             Steam, Proton, gamescope, gamemode
    ├── video.nix              Kdenlive, ffmpeg, OBS
    └── packages.nix        <- EDIT THIS ONE TO INSTALL PROGRAMS
```

One rule: **if you don't know where something goes, it goes in `packages.nix`.**
Moving it to a tidier file later costs nothing.

---

## 2. First-time setup

Run these once, in order.

```bash
# a) The unstable channel, needed for claude-code only (see packages.nix)
sudo nix-channel --add https://nixos.org/channels/nixos-unstable unstable
sudo nix-channel --update

# b) Put this config in place
sudo cp -r . /etc/nixos/
cd /etc/nixos

# c) Keep the generated hardware file, it is specific to this machine
#    (if you overwrote it:  sudo nixos-generate-config --no-filesystems)

# d) Set the hostname and username in configuration.nix to match the install
sudo vim configuration.nix

# e) Build it
sudo nixos-rebuild switch
```

Then reboot and pick COSMIC at the login screen.

---

## 3. Installing a program

1. Search for it: <https://search.nixos.org/packages>
2. Open `modules/packages.nix`, add the name on its own line.
3. `sudo nixos-rebuild switch`

**To try something without installing it at all:**

```bash
nix shell nixpkgs#cowsay     # cowsay exists until you close this terminal
```

Use that to test a package before committing it to the config.

**Never run `nix-env -i`.** It installs things outside this config, so
`packages.nix` stops describing what's actually on the machine. That is the
one habit that makes a NixOS system unmaintainable.

---

## 4. git — the part that saves you

The config is a git repo. This is your undo button for your own edits.

```bash
cd /etc/nixos

git status                       # what have I changed?
git diff                         # show me exactly what changed
git add -A && git commit -m "install obs"    # save a good state

git log --oneline                # history
git restore modules/packages.nix # throw away my edits to one file
git checkout HEAD~1 -- .         # go back to the previous commit's files
```

**Commit before every rebuild, with a message saying what you tried.**
Thirty seconds of habit turns "I broke it and I don't know what I touched"
into `git diff`.

### git vs generations — two different undos

These solve different problems; you have both.

| Problem | Fix |
|---|---|
| I edited the config and it won't build | `git diff`, then `git restore` |
| It built, but the desktop is now broken | `sudo nixos-rebuild switch --rollback` |
| It won't boot at all | Pick an older generation in the boot menu |

Generations are automatic — every `nixos-rebuild switch` makes one, and the
last 10 stay in the boot menu. **You cannot permanently break this machine
from a config edit.** Worst case you reboot and choose yesterday.

---

## 5. Updating

```bash
sudo nix-channel --update
sudo nixos-rebuild switch
```

That updates both channels at once: `nixos` (the whole system) and `unstable`
(which only supplies claude-code).

If an update goes badly, `sudo nixos-rebuild switch --rollback`.

Old generations are garbage-collected automatically after 30 days
(`modules/base.nix`). To clean up right now:

```bash
sudo nix-collect-garbage --delete-older-than 7d
```

---

## 6. Useful commands

```bash
sudo nixos-rebuild switch        # apply the config now
sudo nixos-rebuild test          # apply WITHOUT adding a boot entry
sudo nixos-rebuild boot          # apply on next reboot only
sudo nixos-rebuild switch --rollback

nixos-version
nix-store --gc --print-roots     # what's keeping disk space alive
man configuration.nix            # every option, offline
```

`sudo nixos-rebuild test` is the safe way to try a risky change: if it
breaks the desktop, reboot and you're back, with no bad boot entry.

---

## 7. Gaming notes

Steam launch options worth knowing (right-click a game → Properties):

```
mangohud %command%          FPS and temperature overlay
gamemoderun %command%       CPU governor tuning
gamescope -W 2560 -H 1440 -f -- %command%    fixes resolution/alt-tab bugs
```

Proton-GE is installed. Pick it per-game under
Properties → Compatibility → "Proton-GE". Use `protonup-qt` to update it.

Check what a game needs first: <https://protondb.com>

---

## 8. Video notes

**Kdenlive is here instead of DaVinci Resolve on purpose.** Free Resolve on
Linux cannot decode H.264, H.265 or AAC — that's a Studio-only feature on
Linux specifically. Footage from a phone or a consumer camera will not
import at all. Kdenlive handles those natively.

If a Resolve Studio license happens later, uncomment
`davinci-resolve-studio` in `modules/video.nix`.

Confirm GPU video decoding works:

```bash
vainfo                 # should list H264/HEVC decode entrypoints
radeontop              # live GPU load while exporting
```

---

## 9. Known gotchas for this machine

- **25.11 is end-of-life.** NixOS supports each release until a month after
  the next one, so 25.11 stopped getting security backports around June 2026
  when 26.05 shipped. Moving up is two commands:
  ```bash
  sudo nix-channel --add https://channels.nixos.org/nixos-26.05 nixos
  sudo nix-channel --update && sudo nixos-rebuild switch
  ```
  Leave `system.stateVersion = "25.11"` alone when you do.
- **No flake here on purpose.** `experimental-features` is enabled in
  `base.nix` so the `nix shell` command works, but the system is built from
  channels. Online guides that start with `flake.nix` don't apply; guides
  using `configuration.nix` do.
- **COSMIC is young.** If a session breaks, Ctrl+Alt+F2 gives a text login,
  and `sudo nixos-rebuild switch --rollback` from there gets you back.
- **32-bit graphics** (`graphics.nix`) is what makes Steam work on AMD.
  Don't remove it.
- **One package comes from the unstable channel: claude-code.** 25.11 is
  frozen at 2.1.140; unstable tracks 2.1.283 and climbing. This is only safe
  because claude-code is a self-contained Node program that shares no
  libraries with the rest of the system. **Don't** start pulling desktop,
  driver or toolchain packages from `unstable` — mixing those across branches
  is how you get library mismatches that are genuinely hard to debug.
  If the channel is missing, the build stops with instructions telling you
  the two commands to run, so this can't fail silently.
