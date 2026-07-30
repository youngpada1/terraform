variables {
  environment   = "dev"
  username      = "Freddie Mercury"
  playlist_name = "Road Trip Anthems"
  track_id      = "queen-bohemian-rhapsody-dev"
}

run "environment_validation_rejects_invalid_value" {
  command = plan

  variables {
    environment = "staging"
  }

  expect_failures = [
    var.environment,
  ]
}

run "ids_are_computed_correctly" {
  command = plan

  assert {
    condition     = output.account_id == "freddie-mercury-dev"
    error_message = "account_id did not match the expected slug format of username-environment"
  }

  assert {
    condition     = output.playlist_id == "freddie-mercury-dev-road-trip-anthems"
    error_message = "playlist_id did not match the expected slug format of account_id-playlist_name"
  }
}

run "apply_creates_expected_outputs" {
  command = apply

  assert {
    condition     = output.account_id == "freddie-mercury-dev"
    error_message = "account_id output did not match expected value after apply"
  }

  assert {
    condition     = output.playlist_id == "freddie-mercury-dev-road-trip-anthems"
    error_message = "playlist_id output did not match expected value after apply"
  }

  assert {
    condition     = output.play_event_id == "freddie-mercury-dev-road-trip-anthems-play-queen-bohemian-rhapsody-dev"
    error_message = "play_event_id output did not match expected value after apply"
  }
}
