## Deploying SRS Collector to Heroku

This process requires a fair bit of technical knowledge, and the details
change from time to time as features are added to SRS Collector.  If you
get stuck, Kidd Software LLC can provide commercial support for running
your own SRS Collector installation.

For deployments elsewhere than Heroku, I strongly recommend you use Heroku
buildpacks and that you deploy the app using the same 12factor interface
that Heroku uses.  If you don't know what this means, you should probably
just use Heroku.

### Heroku addons

The production site currently uses the following addons:

    heroku-postgresql:dev
    newrelic:wayne
    pgbackups:auto-month

### Values needed for `heroku config:set`

You will need to set up accounts for the following API keys, and supply
them to Heroku.  The AWS keys should ideally be configured using IAM:

    AWS_ACCESS_KEY_ID=
    AWS_SECRET_ACCESS_KEY=
    GOOGLE_API_KEY=

Set up the `GOOGLE_API_KEY` with access to the Google Translate APIs.

You will also need a dedicated S3 bucket, writable by your AWS credentials
and world readable:

    S3_BUCKET_NAME=

Note that this should not be the same as your development bucket!

You will also need to generate a long, random key using `SecureRandom.hex(64)`:

    SECRET_KEY=

The following parameters should provide reasonable performance on a single
dyno with the dev-level database:

    DB_POOL=8
    PUMA_MAX_THREADS=5
    PUMA_MIN_THREADS=2

### Setting up S3

Set up the following bucket policy on your S3 bucket, replacing
`my-bucket-name` with an appropriate value:

    {
      "Version": "2008-10-17",
      "Statement": [
        {
          "Sid": "AllowPublicRead",
          "Effect": "Allow",
          "Principal": {
            "AWS": "*"
          },
          "Action": "s3:GetObject",
          "Resource": "arn:aws:s3:::my-bucket-name/*"
        }
      ]
    }

If you're using IAM (and you should!), you'll need to set up a dedicated
user with a policy similar to the following:

    {
      "Statement": [
        {
          "Action": [
            "s3:ListAllMyBuckets"
          ],
          "Effect": "Allow",
          "Resource": "arn:aws:s3:::*"
        },
        {
          "Action": "s3:*",
          "Effect": "Allow",
          "Resource": ["arn:aws:s3:::my-bucket-name", "arn:aws:s3:::my-bucket-name/*"]
        }
      ]
    }
