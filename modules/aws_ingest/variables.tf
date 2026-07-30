variable "environment" {
  description = "Environment this module instance belongs to (dev or prod). Used to suffix resource names per business-rules.md naming conventions."
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "environment must be either \"dev\" or \"prod\"."
  }
}

variable "track_title" {
  description = "Title of the track being ingested (fake/placeholder data)."
  type        = string
}

variable "artist_name" {
  description = "Artist name for the track being ingested (fake/placeholder data)."
  type        = string
}
