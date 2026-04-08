{ pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "ec2-nixos";

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };

  users.users.chao.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJVHXrNokh6IByZC0FxTkRY18chyBtRsS0Gb1NQj60R/ zhangchao050530@gmail.com"
  ];

  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    fish
    sing-box
  ];

  system.stateVersion = "25.11";
}
