Alexa skill and supporting infrastructure to report weather
data from Bureau of Meteorology (bom.gov.au).

Structure:

  - Lambda end-point for the skill in python
  - Redis storage for retrieved XML
  - Cloudformation to deploy

Using Gordon (https://github.com/jorgebastida/gordon) for build and deploy
of the lambda because I want to try it out.

Building the Dockerfile will deploy the lambda. The associated resources
are built from stack.json

Currently this is all built locally for AWS credentials - should move to
a build server.