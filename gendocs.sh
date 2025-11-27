#!/bin/bash

tag=v1.4.0

sed "s/\.\/\.\./github.com\/jason-johnson\/tf-azure-keyvault?ref=$tag/" examples/example.tf > examples/generated.txt
terraform-docs .