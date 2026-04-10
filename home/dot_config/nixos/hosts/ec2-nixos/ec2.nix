{ modulesPath, lib, ... }:

{
  imports = [ "${modulesPath}/virtualisation/amazon-image.nix" ];

  ec2.efi = true;

  ec2.hvm = true;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
    autoResize = true;
  };
}
