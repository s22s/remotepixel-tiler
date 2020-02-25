# Deployment instructions

## Landsat Lambda Tiler
Prerequisites:
- An s3 bucket named `astraea-eod-lambda-tiler-l8` has been created in the `us-west-2` region
- Docker installed locally
- npm/node installed locally
- Serverless installed locally (on mac - `brew install serverless`)

### Build the deployment package:
```bash
docker login
make package && make test
npm install
```

### Deploy the service
```bash
export SECRET_TOKEN=<random-string>; cd services/landsat && sls deploy --stage <dev|test|prod> --bucket astraea-eod-lambda-tiler-l8 --region us-west-2
```

Notes:
- `random-string` is any random string (be sure to remember its value in order to configure client-side access)
- `stage` value is one of `dev`,`test`, or `prod`, depending desired deploy environment.
