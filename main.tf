// ...existing code...

module "domain" {
  source = "./modules/domain"
  # Remove or correct these lines if the module "ignition" is not declared
  # bootstrap_ignition_id = module.ignition.bootstrap_ignition.id
  # master_ignition_id    = module.ignition.master_ignition.id
  // ...existing code...
}

// ...existing code...
