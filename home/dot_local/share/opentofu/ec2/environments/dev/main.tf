module "nixos" {
  source = "../../modules"

  name             = var.name
  region           = var.region
  instance_type    = var.instance_type
  arch             = var.arch
  nixos_version    = var.nixos_version
  key_name         = var.key_name
  root_volume_size = var.root_volume_size
}
