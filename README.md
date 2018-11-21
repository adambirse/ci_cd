## Google Cloud CI/CD with Kubernetes and Travis CI

This Project is a simple Hello World example for deploying automatically from 
a public github repo to a Kubernetes cluster hosted on Google Cloud.  It is deployed using Travis CI


###  Before getting started

- Create a Google Cloud account
- Follow this [codelab](https://codelabs.developers.google.com/codelabs/cloud-hello-kubernetes/index.html) to create your own Kubernetes cluster
- Create a service token
- Add service token to Travis and other environment variables
  
  
#### Create your service token


1. In your GCP Console project, open the Credentials page.
2. Click Create credentials > Service account key.
3. Under Service account select New service account.
4. Enter a Service account name such as continuous-integration-test.
5. Under Role, select Project > Editor.
6. Under Key type, select JSON.
7. Click Create. The GCP Console downloads a new JSON file to your computer. The name of this file starts with your project ID.
8.  Base64 encode this json for adding to Travis `base64 <json_secret.json>`
    
### Add Environment variables to Travis.

The following environment variables need to be added to Travis:

  - PROJECT_NAME_STG=<your_google_cloud_project>
  - CLUSTER_NAME_STG=<your_kubernetes_cluster>
  - CLOUDSDK_COMPUTE_ZONE=europe-west2-a
  - GCLOUD_SERVICE_KEY = <the_encoded_token_from_above>
  
  
    
### Deploy

- Any changes committed to master will be deployed to your cluster (assuming tests pass!)
- Once deployed the first time you will need to wait for the IP to become available.  You can watch for this with `kubectl get services --watch`



### Further Reading

The following links were used in the creation of this demo.

- https://medium.com/google-cloud/continuous-delivery-in-a-microservice-infrastructure-with-google-container-engine-docker-and-fb9772e81da7
- https://cloud.google.com/solutions/continuous-delivery-with-travis-ci

