output "buckets" {
  description = "Created S3 buckets keyed by purpose"

  value = {
    for key, bucket in aws_s3_bucket.this : key => {
      id                          = bucket.id
      arn                         = bucket.arn
      bucket_regional_domain_name = bucket.bucket_regional_domain_name
    }
  }
}
