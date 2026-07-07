terraform {
  backend "local" {
    path = "../../../.terraform-state/prod.tfstate"
  }
}
