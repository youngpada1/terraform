variables {
  environment = "dev"
  track_title = "Bohemian Rhapsody"
  artist_name = "Queen"
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

run "track_id_is_computed_correctly" {
  command = plan

  assert {
    condition     = output.track_id == "queen-bohemian-rhapsody-dev"
    error_message = "track_id did not match the expected slug format of artist-title-environment"
  }
}

run "apply_creates_expected_outputs" {
  command = apply

  assert {
    condition     = output.raw_audio_object_key == "queen-bohemian-rhapsody-dev.wav"
    error_message = "raw_audio_object_key did not match expected object key"
  }

  assert {
    condition     = output.transcode_trigger_id != ""
    error_message = "transcode_trigger_id should be populated after apply"
  }

  assert {
    condition     = output.track_id == "queen-bohemian-rhapsody-dev"
    error_message = "track_id output did not match expected value after apply"
  }
}
