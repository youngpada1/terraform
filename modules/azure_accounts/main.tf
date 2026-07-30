locals {
  account_id  = "${replace(lower(var.username), " ", "-")}-${var.environment}"
  playlist_id = "${local.account_id}-${replace(lower(var.playlist_name), " ", "-")}"
}

# Simulates a Cosmos DB item storing the user account record.
resource "terraform_data" "user_account" {
  input = {
    container_name = "streaming-accounts-${var.environment}"
    account_id     = local.account_id
    username       = var.username
  }
}

# Simulates a Cosmos DB item storing the playlist and its tracks.
resource "terraform_data" "playlist" {
  input = {
    container_name = "streaming-playlists-${var.environment}"
    playlist_id     = local.playlist_id
    playlist_name   = var.playlist_name
    account_id      = local.account_id
    track_id        = var.track_id
  }

  depends_on = [terraform_data.user_account]
}

# Simulates an Azure Function firing a "playlist shared" notification.
resource "terraform_data" "playlist_shared_notification" {
  input = {
    function_name = "streaming-playlist-shared-${var.environment}"
    playlist_id   = local.playlist_id
  }

  triggers_replace = [
    terraform_data.playlist.id,
  ]

  depends_on = [terraform_data.playlist]
}

# Simulates a "play event" record, the loose-coupling hook consumed by gcp_analytics.
resource "terraform_data" "play_event" {
  input = {
    event_id  = "${local.playlist_id}-play-${var.track_id}"
    account_id = local.account_id
    track_id   = var.track_id
  }

  depends_on = [terraform_data.playlist]
}
