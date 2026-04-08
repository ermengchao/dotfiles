{ pkgs, ... }:

{
  users.users.chao = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    hashedPassword = "$6$Ll4BrtlvG9uVk1LG$8YaBUyhaVOejRTn6fqxYjybSV8NgAhtRFrjA/nQx30SZVmcDUwVp5f8cvAMDRIaeYdlY4QR0SvfHguvDCEOm0.";
    shell = pkgs.fish;
  };
}
