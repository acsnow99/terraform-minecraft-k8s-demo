Welcome to the Minecraft on K8S suite!

If you have a cluster set up already, make sure kubectl is configured to 
access its resources, then cd into resources and run "bash independent-setup.sh -h" 
to look at the options that can be passed into the script.

If you need a cluster specifically to deploy the server on, the Terraform resources provided can set up the whole
environment on GKE. Copy and edit states/default.tfvars to include your specific
GCP service key, the project and network that the cluster will deploy to, and
the configuration for the Minecraft server. 
Then run "terraform apply -var-file=states/{your file}" to set up the entire environment.

