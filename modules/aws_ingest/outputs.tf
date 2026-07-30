output "track_id" {
  description = "Fake unique identifier for the ingested track, to be consumed by gcp_analytics as a simulated 'new track' event."
  value       = local.track_id
}

output "raw_audio_object_key" {
  description = "Simulated S3 object key for the raw audio file."
  value       = terraform_data.raw_audio.output.object_key
}

output "transcode_trigger_id" {
  description = "Simulated Lambda transcode trigger identifier."
  value       = terraform_data.transcode_trigger.id
}
