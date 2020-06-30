locals {
  env = {
    default = {
      instance_type = "t2.micro"
    }
    dev = {
      instance_type = "t2.micro"
    }
    stage = {
      instance_type = "t3.micro"
    }
    prod = {
      instance_type = "t3a.micro"
    }
  }
  environmentvars = "${contains(keys(local.env), terraform.workspace) ? terraform.workspace : "default"}"
  workspace       = "${merge(local.env["default"], local.env[local.environmentvars])}"
}
