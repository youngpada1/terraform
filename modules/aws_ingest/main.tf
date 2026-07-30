locals {
  track_id = "${replace(lower(var.artist_name), " ", "-")}-${replace(lower(var.track_title), " ", "-")}-${var.environment}"
}

# Simulates an S3 object storing the raw uploaded audio file.
resource "terraform_data" "raw_audio" {
  input = {
    bucket      = "streaming-raw-audio-${var.environment}"
    object_key  = "${local.track_id}.wav"
    track_title = var.track_title
    artist_name = var.artist_name
  }
}

# Simulates a DynamoDB item storing track metadata.
resource "terraform_data" "track_metadata" {
  input = {
    table_name  = "streaming-track-metadata-${var.environment}"
    track_id    = local.track_id
    track_title = var.track_title
    artist_name = var.artist_name
  }

  depends_on = [terraform_data.raw_audio]
}

# Simulates a Lambda invocation triggered once raw audio + metadata exist.
resource "terraform_data" "transcode_trigger" {
  input = {
    function_name = "streaming-transcode-trigger-${var.environment}"
    track_id      = local.track_id
  }

  triggers_replace = [
    terraform_data.raw_audio.id,
    terraform_data.track_metadata.id,
  ]

  depends_on = [terraform_data.track_metadata]
}
