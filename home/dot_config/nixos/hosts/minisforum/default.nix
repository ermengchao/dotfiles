{ pkgs, ... }:

{
  imports = [
    ./programs
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };

  services.tailscale = {
    enable = true;
    extraSetFlags = [
      "--operator=chao"
    ];
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "minisforum";
  networking.networkmanager.enable = true;
  networking.proxy.default = "http://10.10.20.128:8080/";
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.chao.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOpVXUWpsguLh/CiexrMSfRs5QNfRyrx1ifuJUUB0PfB zhangchao050530@gmail.com"
  ];

  environment.systemPackages = with pkgs; [
    git
    vim
    sing-box
    tailscale
    wget
  ];

  system.stateVersion = "25.11";
}
