# needed to identify for which cluster the automation should be created
variable "cluster_name" {
  type        = string
  description = "The name of the ECS cluster on which the automation will be bound."
}

variable "tags" {
  type        = map(any)
  default     = null
  description = "Tags to put into all taggable resources created by this module."
}
