variable "CRResourceGroup" {
  description = "Cloud Resume Resource Group for everything associated"
  type        = string
  default     = "CloudResume"
}

variable "Location" {
  description = "The default location to spin your Azure infrastructure"
  type        = string
  default     = "westus2"
}
