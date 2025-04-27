# GitHub-Terraform CI/CD Template

- **Terraform** v1.11.4  
- **Backend**: AWS S3  
- **CI**: GitHub Actions  
  - Runs on `push` to `main`  
  - Runs on every PR targeting `main`  
  - Uses `environment`:  
    - `main` for the main branch  
    - `PR-<number>` for PR builds  
- **Modules**:  
  - `terraform/modules/infrastructure/confluent-cloud`  
