TEMPLATE ?= dist/aws-ecr-public.template.json
STACK_NAME ?= aws-ecr-public
VALIDATION_DOMAIN ?= ""
DOMAIN_NAME ?= ""
VALIDATION_METHOD ?= "EMAIL"


build:
	mkdir -p dist
	cfn-include -t -m serverless.template.yml > $(TEMPLATE)

test: build
	aws cloudformation deploy \
		--template-file $(TEMPLATE) \
		--stack-name $(STACK_NAME) \
		--capabilities CAPABILITY_IAM \
		--parameter-overrides \
			ValidationDomain=$(VALIDATION_DOMAIN) \
			DomainName=$(DOMAIN_NAME) \
			ValidationMethod=$(VALIDATION_METHOD)

publish: build
	aws s3 cp --acl public-read dist/aws-ecr-public.template.json s3://dorkforces-dfl/aws-ecr-public/v0.1/template.json

clean:
	rm -rf dist
	aws cloudformation delete-stack --stack-name aws-ecr-public
