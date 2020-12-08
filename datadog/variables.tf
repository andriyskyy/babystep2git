variable "application_name" {
  type        = string
  description = "Application Name"
  default     = "beacon"
}
variable "datadog_api_key" {
  type = string
  default = "68429a07162f5a65b87bd69ec0117540"
  description = "Datadog API Key"
}

variable "datadog_app_key" {
  type = string
  default = "ad191a5bfc73ddd48226bb170a9a83f433ae6252"
  description = "Datadog Application Key"
}

