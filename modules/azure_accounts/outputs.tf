output "account_id" {
  description = "Fake unique identifier for the simulated user account."
  value       = local.account_id
}

output "playlist_id" {
  description = "Fake unique identifier for the simulated playlist."
  value       = local.playlist_id
}

output "play_event_id" {
  description = "Fake unique identifier for the simulated 'play event', to be consumed by gcp_analytics as a play-events signal."
  value       = terraform_data.play_event.output.event_id
}
