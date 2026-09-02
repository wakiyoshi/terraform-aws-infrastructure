variable "permission_set_name" {
  type = string
}

variable "group_name" {
  type = string
}

variable "target_account_id" {
  type = string

  validation {
    condition     = can(regex("^\\d{12}$", var.target_account_id))
    error_message = "target_account_id は12桁のAWSアカウントIDを指定してください。"
  }
}

variable "account_assignments" {
  type = map(object({
    account_id = string
    group_name = string
  }))
}