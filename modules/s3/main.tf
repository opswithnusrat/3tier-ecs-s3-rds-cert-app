
#creating s3 bucket
resource "aws_s3_bucket" "site_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = "ecs-site-bucket"
    Environment = "dev"
  }
}


#allowing public access
resource "aws_s3_bucket_ownership_controls" "site_bucket_ownership" {
  bucket = aws_s3_bucket.site_bucket.bucket
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "site_bucket_block" {
  bucket = aws_s3_bucket.site_bucket.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "site_bucket_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.site_bucket_ownership,
    aws_s3_bucket_public_access_block.site_bucket_block,
  ]

  bucket = aws_s3_bucket.site_bucket.bucket
  acl    = "private"
}



#attaching policy 

# #calling my onw account
# data "aws_caller_identity" "current" {}


# Although this is a bucket policy rather than an IAM policy, 
# the aws_iam_policy_document data source may be used, so long as it specifies a principal. 
data "aws_iam_policy_document" "allow_access" {
  version = "2012-10-17"
  statement {
    sid = "Allow bucket access from cloudfront to static website"
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"] 
    }

    effect = "Allow"

    actions = [
      "s3:GetObject"
      # "s3:PutObject",
    ]

    resources = [
      # aws_s3_bucket.site_bucket.arn,
      "${aws_s3_bucket.site_bucket.arn}/*",
    ]

    condition {
      test= "StringEquals"
      variable= "AWS:SourceArn"

      values = [var.cloudfront_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "allow_access" {
  bucket = aws_s3_bucket.site_bucket.bucket
  policy = data.aws_iam_policy_document.allow_access.json
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.site_bucket.bucket

  versioning_configuration {
    status = "Enabled"
  }
}




