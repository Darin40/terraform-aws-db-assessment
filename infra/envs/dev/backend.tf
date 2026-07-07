terraform {
  backend "local" {
    path = "../../../.terraform-state/dev.tfstate"
  }
}
