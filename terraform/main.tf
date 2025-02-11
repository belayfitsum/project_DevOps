# Provider block , the profile is the onely one key in my aws credentials folder
provider "aws" {
  region = "eu-central-1"
  profile = "default"
}
