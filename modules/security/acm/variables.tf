variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "domain_name" {
  description = "FQDN used by the ALB, for example app.example.com"
  type        = string

  validation {
    condition     = length(trimspace(var.domain_name)) > 0
    error_message = "domain_name must not be empty."
  }
}

variable "subject_alternative_names" {
  description = "Additional FQDNs covered by the certificate"
  type        = list(string)
  default     = []
}

variable "route53_zone_id" {
  description = "ID of the public Route 53 hosted zone used for DNS validation"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to the certificate"
  type        = map(string)
  default     = {}
}

variable "create_validation_records" {
  description = "Whether this certificate owns the DNS validation records"
  type        = bool
  default     = true
}

variable "validation_record_fqdns" {
  description = "Validation records managed by another certificate in the same account"
  type        = list(string)
  default     = []
}
