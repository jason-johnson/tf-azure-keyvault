#!/bin/bash

tag=v1.0.1

sed "s/.\/../github.com\/jason-johnson\/tf-azure-keyvault?ref=$tag/" examples/example.tf > examples/generated.txt
terraform-docs .