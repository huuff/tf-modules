variable "db_identifier" {
    description = "Identifier of the RDS database"
    type = string
}

variable "target_emails" {
    description = "Emails that will be notified"
    type = list(string)
}