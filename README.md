Simple example of python container running in AWS Lambda

### Local development

$ docker build -t python-lambda:test .

$ docker run --rm -p 9000:8080 python-lambda:test

Other terminal

$ curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{"key1":123}'

