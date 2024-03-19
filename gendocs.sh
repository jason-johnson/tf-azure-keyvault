#!/bin/bash

sed 's/.\/../github.com\/jason-johnson\/tf-azure-keyvault?ref=v1.0.0/' examples/example.tf > examples/generated.txt
terraform-docs .