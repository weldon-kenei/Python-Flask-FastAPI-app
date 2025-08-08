# Insight Agent - GCP Serverless Deployment

## Architecture

[User] → [Cloud Run (Private)] → [Artifact Registry]
       ↑
[Terraform] → [IAM Policies]


### **Production Enhancements**
1. **Authentication**: Add Identity-Aware Proxy (IAP)
2. **Monitoring**: Cloud Logging + Error Reporting
3. **Secrets**: Use Secret Manager for credentials
4. **Terraform State**: GCS backend with locking

---

### **Verification Checklist**
1. **Application**:
   - [x] FastAPI endpoint with JSON analysis
   - [x] Secure Dockerfile (non-root user)

2. **Terraform**:
   - [x] Private Cloud Run + Artifact Registry
   - [x] Least-privilege service account

3. **CI/CD**:
   - [x] Auto-build on push
   - [x] Image tag propagation to Terraform



---
