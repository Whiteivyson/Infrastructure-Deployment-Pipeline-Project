resource "aws_instance" "jenkins_master" {
  ami                    = "ami-0f9de6e2d2f067fca"
  instance_type          = "t2.medium"
  key_name               = "ddpkey"
  security_groups = [var.jenkins_security_group_id]
  subnet_id = var.public_subnet_ids[1]
  user_data = base64encode(file("scripts/userdata.sh"))
  associate_public_ip_address = true
    
  tags = {
    Name = "${var.BeatStar}-jenkins-master"
  }

  # best practices as per checkov scanner
  monitoring    = true
  ebs_optimized = true
  root_block_device {
    encrypted = true
  }

}

resource "aws_s3_bucket" "beatstar-tf-backend-1999" {
  bucket = "beatstar-tf-backend-1999"
  tags = {
    Name = "beatstar-tf-backend-1999"
  }
}

resource "aws_s3_bucket_logging" "example" {
  bucket = aws_s3_bucket.beatstar-tf-backend-1999.id

  target_bucket = aws_s3_bucket.beatstar-tf-backend-1999.id
  target_prefix = "log/"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.beatstar-tf-backend-1999.id
  versioning_configuration {
    status = "Enabled"
    mfa_delete = "Enabled"
  }
}

resource "aws_dynamodb_table" "tf_locks" {
  name         = "BeatStar-tf-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  point_in_time_recovery {
  enabled = true
}

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.kms_key.arn
  }
  tags = {
    Name = "BeatStar-tf-locks"
  }
}




# Enable server-side encryption on the S3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.beatstar-tf-backend-1999.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_kms_key" "kms_key" {
  description             = "KMS key 1"
  deletion_window_in_days = 10
}
