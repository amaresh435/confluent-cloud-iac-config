## Automate Confluent Kafka Env & Cluster creation using Terraform & store secrets into GCP Secret Mgr

### Video : https://www.youtube.com/watch?v=FDcNijBAAO4

1. A Devops team will triggers a Terraform pipeline. Automate the Confluent Kafka resouce creation process.
2. Terraform provisions Confluent Kafka Environment on Confluent Cloud.
3. Inside that environment, it provisions a dedicated Confluent Kafka cluster — single-zone, GCP us-central1, sized to a fixed CKU count.
4. Thru Terraform we capture Kafka API key and secret scoped to that cluster and push it straight into GCP Secret Manager — alongside the cluster's bootstrap server endpoint.
5. Instead of leaving that key/secret in Terraform state.
6. Going Forward I use Kafka API key and secret to create Topics, Partiions and other resource elements.

