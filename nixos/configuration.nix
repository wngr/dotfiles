# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Setup keyfile
  boot.initrd.secrets = { "/crypto_keyfile.bin" = null; };

  boot.kernelModules = [
    # external optical drive support
    "sg"
  ];

  nix.settings.experimental-features = [ "flakes" "nix-command" ];

  virtualisation.docker.enable = true;
  # https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.services.wireless-driver-on-resume = {
    enable = false;
    description = "Reload the wireless driver on system resumt";
    serviceConfig = {
      ExecStartPre = "${pkgs.kmod}/bin/modprobe --remove ath11k_pci";
      ExecStart = "${pkgs.kmod}/bin/modprobe ath11k_pci";
      Type = "oneshot";
    };
    after = [ "systemd-suspend.service" "systemd-hibernate.service" ];
    requiredBy = [ "systemd-suspend.service" "systemd-hibernate.service" ];
  };
  systemd.services = {
    ath11k-suspend = {
      enable = false;
      description = "Remove ath11k_pci kernel module";
      wantedBy = [
        "sleep.target"
        "hibernate.target"
        "suspend.target"
        "suspend-then-hibernate.target"
      ];
      before = [
        "sleep.target"
        "hibernate.target"
        "suspend.target"
        "suspend-then-hibernate.target"
      ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.kmod}/bin/modprobe ath11k_pci --remove";
      };
    };
    ath11k-resume = {
      enable = false;
      description = "Load ath11k_pci kernel module";
      wantedBy = [
        "sleep.target"
        "hibernate.target"
        "suspend.target"
        "suspend-then-hibernate.target"
      ];
      after = [
        "sleep.target"
        "hibernate.target"
        "suspend.target"
        "suspend-then-hibernate.target"
      ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.kmod}/bin/modprobe ath11k_pci";
      };
    };
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-e5556ac1-76f9-4684-865d-d38e66a32541".device =
    "/dev/disk/by-uuid/e5556ac1-76f9-4684-865d-d38e66a32541";
  boot.initrd.luks.devices."luks-e5556ac1-76f9-4684-865d-d38e66a32541".keyFile =
    "/crypto_keyfile.bin";

  networking.hostName = "black-dove"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
  };
  services.resolved.enable = true;

  # mount iphone
  services.usbmuxd.enable = true;
  # iphone end

  networking.wireguard = {
    # FIXME
    enable = false;
    interfaces = {
      wg0 = {
        ips = [ "10.0.41.15/32" ];
        listenPort = 51820;

        privateKeyFile = "/home/ow/wg-pallas.key";

        peers = [{
          publicKey = "vVwi6MkTftEJEywZVGcIbeMTQLkaaWkqf4fyJOLtDnU=";
          allowedIPs = [ "0.0.0.0/8" "10.0.41.0/24" "10.0.13.0/24" ];
          endpoint = "wngr.ddns.net:51820";

          dynamicEndpointRefreshSeconds = 600;
          persistentKeepalive = 25;
        }];
        postSetup = ''
          resolvectl dns    wg0 10.0.13.251
          #resolvectl domain wg0 ~home.wngr.de
          #resolvectl dnssec wg0 false
        '';
      };
      fritzbox = {
        ips = [ "192.168.178.201/24" ];
        listenPort = 51821;

        privateKeyFile = "/home/ow/wg-fritzbox.key";

        peers = [{
          publicKey = "N4hHM8YP8B4nmzbM1uCWIOEaS+JOJLSrNVoMpj8/c3M=";
          presharedKeyFile = "/home/ow/wg-fritzbox-psk.key";
          allowedIPs = [ "192.168.178.0/24" ];

          #myfritz.net endpoint also resolves ipv6
          #endpoint = "09pat8pe4olim7iv.myfritz.net:53961";
          endpoint = "wngr.ddns.net:53961";

          dynamicEndpointRefreshSeconds = 600;
          persistentKeepalive = 25;
        }];
      };

    };
  };
  systemd.services."wireguard-wg0".wantedBy = lib.mkForce [ ];
  systemd.paths."wireguard-wg0".wantedBy = lib.mkForce [ ];
  programs.adb.enable = true;
  # run unpatched binaries that look for a link-loader in eg `/lib64/ld-linux-x86-64.so.2`
  programs.nix-ld.enable = true;
  programs.nm-applet.enable = true;
  programs.evince.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };
  services = {
    redshift = {
      executable = "/bin/redshift-gtk";
      enable = true;
      brightness = {
        day = "1";
        night = "1";
      };
      temperature = {
        day = 6500;
        night = 3000;
      };
    };
    printing = {
      enable = true;
      drivers = with pkgs; [
        hplipWithPlugin
        cups-filters
        samsung-unified-linux-driver
      ];
      #	extraConf = ''
      #          Option pdftops-renderer pdftops
      #        '';
    };

    # smb etc
    gvfs.enable = true;
  };

  services.autorandr = {
    enable = true;
    profiles = {
      "laptop" = {
        fingerprint = {
          eDP-1 =
            "00ffffffffffff0009e5640900000000161e0104a51d1278039696a7514c9d2610535600000001010101010101010101010101010101743c80a070b02840302036001eb31000001a5d3080a070b02840302036001eb31000001a000000fe00424f452048460a202020202020000000fe004e5631333357554d2d4e36310a002e";
        };
        config = {
          eDP-1 = {
            enable = true;
            mode = "1920x1200";
            position = "0x0";
            primary = true;
          };
          DP-10.enable = false;
        };
      };
      "büro" = {
        # `autorandr --fingerprint`
        fingerprint = {
          eDP-1 =
            "00ffffffffffff0009e5640900000000161e0104a51d1278039696a7514c9d2610535600000001010101010101010101010101010101743c80a070b02840302036001eb31000001a5d3080a070b02840302036001eb31000001a000000fe00424f452048460a202020202020000000fe004e5631333357554d2d4e36310a002e";
          DP-10 =
            "00ffffffffffff0010acf3a04c564430181c0104b55825783eee95a3544c99260f5054a54b00714f81008180a940d1c00101010101014c9a00a0f0402e6030203a00706f3100001a000000ff00354b4330333836453044564c0a000000fc0044454c4c20553338313844570a000000fd001855197328000a20202020202001b202031af14d9005040302071601141f12135a2309070783010000023a801871382d40582c4500706f3100001e565e00a0a0a0295030203500706f3100001acd4600a0a0381f4030203a00706f3100001a2d5080a070402e6030203a00706f3100001a134c00a0f040176030203a00706f3100001a000000000000000000000053";
        };
        config = {
          eDP-1 = {
            enable = true;
            mode = "1920x1200";
            position = "0x0";
            primary = true;
          };
          DP-10 = {
            enable = true;
            mode = "3840x1600";
            position = "1920x0";
          };
        };
      };
      "tv" = {
        # `autorandr --fingerprint`
        fingerprint = {
          eDP-1 =
            "00ffffffffffff0009e5640900000000161e0104a51d1278039696a7514c9d2610535600000001010101010101010101010101010101743c80a070b02840302036001eb31000001a5d3080a070b02840302036001eb31000001a000000fe00424f452048460a202020202020000000fe004e5631333357554d2d4e36310a002e";
          HDMI-1 =
            "00ffffffffffff0034a901c30101010100140103800000780adaffa3584aa22917494b00000001010101010101010101010101010101023a80d072382d40102c4580ba882100001e023a801871382d40582c4500ba882100001e000000fc0050616e61736f6e69632d54560a000000fd00173d0f440f000a202020202020015302032272509f9014052013041203110216071506012309070168030c001000b8260f011d80d0721c1620102c2580ba882100009e011d8018711c1620582c2500ba882100009e011d00bc52d01e20b8285540ba882100001e011d007251d01e206e285500ba882100001e8c0ad090204031200c405500ba88210000180000000a";
        };
        config = {
          eDP-1 = {
            enable = true;
            mode = "1920x1200";
            position = "0x0";
            primary = true;
          };
          HDMI-1 = {
            enable = true;
            mode = "1920x1080";
            position = "1920x0";
          };
        };
      };
    };
  };
  services.fwupd.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 80;
      STOP_CHARGE_THRESH_BAT0 = 95;
    };
  };
  # Configure keymap in X11
  services.displayManager.defaultSession = "none+i3";
  services.xserver = {
    enable = true;
    autorun = true;
    xkb = {
      layout = "us";
      variant = "";
      options = "compose:ralt";
    };
    desktopManager.xterm.enable = false;
    displayManager.lightdm.enable = true;
    displayManager.lightdm.greeters.gtk.theme.name = "Adwaita-dark";

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [ dmenu ];
    };
  };

  users.mutableUsers = false;
  users.users = {
    ow = {
      uid = 1000;
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "docker"
        "audio"
        "video"
        "input"
        "lp"
        "adbusers"
      ];
      description = "ow";
      shell = pkgs.zsh;
      hashedPassword =
        "$6$aPt0yEG6l8vWNq6x$M/wro68epL0uKTs0nyEeVXpCeTJWp1oKYhz4V4.4g9kFOLMmbAyOrDRsOVMBOM/xS9m6J.nsPOgykw0Cki95x1";
      packages = with pkgs; [ ];
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDTWEixQfURJSWbemWs0acolczYT8331DhTOG7orFAIDHylBx6s+3bDl/GZuzaRqyUHNSGy7SqvsGYSiX249MkbS3B+koaINmjXyBcDRVuKUiDdYz56UzsM7XSJieEe2IGxjUPsDS+Y25FIP0UwhKClYJh+77EgUHixMuwJHMf1BHbE1tefhkMBwAhZxTSgcNBKTRPPQVoWSN4JIGohg8Tj3zCSls1wYWwKASsHXa/9/JH5nEQM+XpUUwXL1ACsP6Ei3P/h6d5zCgYwG9pYRSIAN4MPokuM549Jnrsv9Gki/Bmk38ALLYp7c+d2/4HrtVh8+bXd9MdeK+eiRMUn3pZz3tsUWdH5qSIgV4ef0ujEba7GMvY+WCCaBb/kIdgHY1cgXyQjdn6r3nXk5ZHfLFcUt/xmzwgEVQqwn10paftA92Z0nbI5V6ERvWWWxLOfQBgQGGRIqGwpe3wUfr/vHYzgVmFQujK/7HTJ01K0MiH06mwdudj3ap1Oco3FHpcoIDglMIqWhcPo/vpHpejO4XXMedURia2Oq/v3hN67iWDqST29WlQohav1F8GFpYEHVD1LvnJ/CRgd84ET79VUaq+TtHsoOSxWhODrNERkCeov5amXsHSHgNJ6L118FRoGrqYG7Eb9Z87o2a7ObNmdctNe63npoj0ngoPqvArb1tjlzQ== ow@t440s"
      ];
    };
    root = {
      shell = pkgs.zsh;
      hashedPassword =
        "$6$aPt0yEG6l8vWNq6x$M/wro68epL0uKTs0nyEeVXpCeTJWp1oKYhz4V4.4g9kFOLMmbAyOrDRsOVMBOM/xS9m6J.nsPOgykw0Cki95x1";
    };
  };

  nixpkgs = {
    overlays = let
      rustOverlay = import (builtins.fetchTarball
        "https://github.com/oxalica/rust-overlay/archive/master.tar.gz");
    in [ rustOverlay ];

    config = {
      allowUnfree = true;
      permittedInsecurePackages = [

        "electron-25.9.0" # https://discourse.nixos.org/t/flake-still-using-old-packages/36859/8

      ];
    };
  };

  # ssh access
  services.openssh.enable = false;

  environment = {
    variables = { EDITOR = "nvim"; };
    sessionVariables = { GTK_THEME = "Adwaita:dark"; };

    etc = {
      "xdg/gtk-2.0/gtkrc".text = ''
        gtk-theme-name = "Adwaita-dark"
        gtk-icon-theme-name = "Adwaita"
      '';

      "xdg/gtk-3.0/settings.ini".text = ''
        [Settings]
        gtk-theme-name = Adwaita-dark
        gtk-application-prefer-dark-theme = true
        gtk-icon-theme-name = Adwaita
      '';

      # Qt4
      "xdg/Trolltech.conf".text = ''
        [Qt]
        style=GTK+
      '';
    };
  };
  location = {
    provider = "manual";
    latitude = 48.0485;
    longitude = 10.8385;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = let
    rust = pkgs.rust-bin.stable.latest.default.override {
      extensions = [ "rust-src" ];
    };
  in with pkgs; [
    calibre
    tor-browser
    wireguard-tools
    obsidian
    nix-index
    chromium
    sshfs
    arandr
    traceroute
    dig
    xss-lock
    i3lock-fancy-rapid
    sudo
    gawk
    nodejs_20
    vlc
    ffmpeg
    # printer
    ghostscript
    poppler
    poppler_utils
    # printer end
    ripgrep
    asunder # gui cd ripping tool
    lame # mp3 lib
    gping # ping replacement
    geeqie
    xxd # inspect binary files
    gparted
    jameica
    gimp
    xournalpp
    file
    xclip
    lm_sensors # hw temp sensors
    unzip
    # Rust packages
    cargo-cross
    cargo-outdated
    cargo-bloat
    cargo-edit
    cargo-watch
    watchexec
    rust
    rust-analyzer
    gcc
    libreoffice
    tree
    zenity
    encfs
    portfolio
    remmina
    gnome-screenshot
    bash
    pciutils
    easyeffects
    gnomeExtensions.easyeffects-preset-selector
    scrot
    imagemagick
    atuin
    eza
    pdfarranger
    fd
    bat
    fzf
    nautilus
    keepassxc
    mosh
    borgbackup
    seafile-client
    htop
    powertop
    pavucontrol
    mkpasswd
    rofi
    i3status-rust
    signal-desktop
    alacritty
    wezterm
    neovim
    wget
    curl
    firefox
    thunderbird
    yt-dlp

    libimobiledevice # iphone
    ifuse # optional, to mount using 'ifuse'
  ];
  fonts = {
    packages = with pkgs; [
      font-awesome_4
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      fira-code
      fira-code-symbols
      ubuntu_font_family
      lmodern
      #iosevka
      source-code-pro
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Ubuntu" ];
        sansSerif = [ "Ubuntu" ];
        monospace = [ "source-code-pro" ]; # "iosevka" ];
      };
    };
  };

  # to manipulate monitor background brightness

  programs.git = {
    enable = true;
    config = {
      user = {
        email = "oliver@wngr.de";
        name = "Oliver Wangler";
      };
    };
  };
  # lock done via xss-lock started in i3 config
  #  programs.xss-lock = {
  #    enable = true;
  #    extraOptions = [ "--transfer-sleep-lock" ];
  #    lockerCommand = "${pkgs.i3lock-fancy-rapid}/bin/i3lock-fancy-rapid 10 10";
  #  };
  programs.light.enable = true;
  #  programs.i3lock.enable = true;
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    histSize = 100000;
    shellAliases = {
      ll = "eza -lh";
      lb = "nvim ~/Seafile/logbook/`date +'%Y-%m'`.md";
      edit = "nvim /home/ow/src/dotfiles/nixos/configuration.nix";
      update = "sudo nixos-rebuild switch";
    };
    promptInit = ''
      eval "$(atuin init zsh)"
    '';
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "gpg-agent" "vi-mode" ];
      theme = "robbyrussell";
    };
  };

  # Storage backend for some gtk3 apps
  programs.dconf.enable = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  services.pipewire.enable = false;
  services.blueman.enable = true;

  # List services that you want to enable:
  # fprint
  # FIXME
  #services.fprintd.enable = true;
  ##services.fprintd.tod.enable = true;
  #security.pam.services.login.fprintAuth = true;
  #security.pam.services.xscreensaver.fprintAuth = true;

  services.clipmenu.enable = true;
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  services.upower.enable = true;

  security.pam.services.lightdm.enableGnomeKeyring = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  networking.firewall.allowedUDPPorts = [
    51820 # wireguard pallas
    51821 # wireguard fritzbox
  ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  nix.gc = {
    automatic = false; # true;
    dates = "weekly";
    options = "--delete-older-than 31d";
  };

  # Sound
  #sound = {
  #  enable = true;
  #  mediaKeys.enable = true;
  #};
  hardware.pulseaudio.enable = true;
  hardware.bluetooth.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
