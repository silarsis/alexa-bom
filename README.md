Alexa skill and supporting infrastructure to report weather
data from Bureau of Meteorology (bom.gov.au).

Structure:

  - Lambda end-point for the skill in python
  - Redis storage for retrieved XML
  - Cloudformation to deploy

Using apex for deploy of lambda.

Building the Dockerfile will deploy the lambda. The associated resources
are built from stack.json

Currently this is all built locally for AWS credentials - should move to
a build server.