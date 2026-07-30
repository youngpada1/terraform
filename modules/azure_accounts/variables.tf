variable "environment" {
  description = "Environment this module instance belongs to (dev or prod). Used to suffix resource names per business-rules.md naming conventions."
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "environment must be either \"dev\" or \"prod\"."
  }
}

variable "username" {
  description = "Username of the account being simulated (fake/placeholder data)."
  type        = string
}

variable "playlist_name" {
  description = "Name of the playlist being created (fake/placeholder data)."
  type        = string
}

variable "track_id" {
  description = "Track identifier played and added to the playlist, typically sourced from aws_ingest's track_id output. Used to simulate a 'play event' fed into gcp_analytics."
  type        = string
}
