# Terraform Security Test Repository

This repository contains intentionally insecure Terraform configurations for testing security analysis tools.

## Security Issues Included

- Storage accounts with HTTP traffic allowed
- Public network access on databases
- Key Vaults without network restrictions
- Web apps with outdated TLS versions
- Missing network security groups
- Disabled security features

## Usage

This repository is for testing purposes only. Do not deploy these configurations to production.

## Structure

- `environments/` - Environment-specific configurations
  - `dev/` - Development environment with security issues
  - `prod/` - Production environment (can be more secure)
- `modules/` - Reusable Terraform modules
