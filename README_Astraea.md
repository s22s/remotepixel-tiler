# Deployment instructions

Prerequisites:
- Docker installed locally
- npm/node installed locally
- Serverless installed locally (on mac - `brew install serverless`)

### Build the deployment package:
```bash
export AWS_ACCESS_KEY_ID=<serverless-deploy-key-id>
export AWS_SECRET_ACCESS_KEY=<serverless-deploy-access-key>
docker login
make package && make test
npm install
```

## Landsat Lambda Tiler
Prerequisites:
- The deployment package has been built
- An s3 bucket named `astraea-eod-lambda-tiler-l8` has been created in the `us-west-2` region

### Deploy the service
```bash
export AWS_ACCESS_KEY_ID=<serverless-deploy-key-id>
export AWS_SECRET_ACCESS_KEY=<serverless-deploy-access-key>
export SECRET_TOKEN=<random-string>
cd services/landsat
sls deploy --stage <dev|test|prod> --bucket astraea-eod-lambda-tiler-l8 --region us-west-2
```

Notes:
- `serverless-deploy-key-id` and `serverless-deploy-access-key` are attached to the `serverless-deploy` IAM role for Astraea
- `random-string` is any random string (be sure to remember its value in order to configure client-side access)
- `stage` value is one of `dev`,`test`, or `prod`, depending desired deploy environment.
- Upon successful deployment, service information will be displayed on the shell:
```
Service Information
service: landsat
stage: dev
region: us-west-2
stack: landsat-dev
resources: 10
api keys:
    None
endpoints:
    GET - https://alg7ykmlg5.execute-api.us-west-2.amazonaws.com/dev/{proxy+}
functions:
    tiler: landsat-dev-tiler
layers:
    None
```
- Note, in particular, the `endpoint: - GET` uri

### Testing
Hit the following url to get metadata about a particular landsat id:
```bash
curl <endpoint url>/<landsat-id>.json?access_token=<random-string>
```
using the `random-string` value from the `SECRET_TOKEN` in deployment.
For example:
```bash
curl https://alg7ykmlg5.execute-api.us-west-2.amazonaws.com/dev/LC08_L1TP_060247_20180905_20180912_01_T1.json?access_token=SDDLBVEB8a
```
Should return:
```json
{
  "bounds": [-102.33378708350155, 80.62944411834522, -86.86013141067224, 82.67617220308239],
  "center": [-94.59695924708689, 81.6528081607138, 4],
  "minzoom": 4,
  "maxzoom": 9,
  "name": "LC08_L1TP_060247_20180905_20180912_01_T1",
  "tilejson": "2.1.0",
  "tiles": ["https://alg7ykmlg5.execute-api.us-west-2.amazonaws.com/dev/tiles/LC08_L1TP_060247_20180905_20180912_01_T1/{z}/{x}/{y}@1x.png?access_token=SDDLBVEB8a"]
}
```

For a full list of service functions, you can get the openapi.json from the service:
```bash
curl https://alg7ykmlg5.execute-api.us-west-2.amazonaws.com/dev/openapi.json
```

### Undeploy the service
```bash
sls remove --stage <dev|test|prod> --bucket astraea-eod-lambda-tiler-l8
```
