variable "prefix" {
    description = <<-EOT
      A prefix that will be prepended to the names of all created resources.

      This will create a s3 bucket called $prefix-terraform-state and a dynamodb table called $prefix-terraform-state-locks
    EOT
    type = string
}

variable "protect" {
    description = "Whether to prevent the destruction of the state bucket"
    type = bool
    default = true
}