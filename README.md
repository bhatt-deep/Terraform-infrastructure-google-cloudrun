# CSBC1040 Infrastructure
This Project enables implementation of google cloud run and cloud sql in terraform.

There are few requirements to setup this project.
1) APIs which need to be enabled:
- Cloud Run API
- Cloud SQL Admin API
- Container Registry API

2) Credentials folder needs the JSON key for a service account. or you can set it as environment variable.

3) environment variables needs to be setup:
- db_user
- db_pass
- SERVICEACCOUNT

4) Manually Build a docker image and push it to Google Container Registry and note that URL.

5) Change Project ID and gcr.io URL accordingly.

Now Project is ready to deploy.
you can run the project Manually by the below commands.

`terraform init`

`terraform validate`

`terraform plan`

`terraform apply`

Or you can use the gitlab CI to deploy the Infrastructure.
