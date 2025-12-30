resource "aws_kms_key" "notes_key" {
  description             = "KMS key for encrypting Notes API data"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_kms_alias" "notes_key_alias" {
  name          = "alias/secure-notes-key"
  target_key_id = aws_kms_key.notes_key.key_id
}