region = "us-west1"

cluster-name = "mc-server"

# scale up if the server has difficulties
cluster-size = 1

network = "minecraft"

subnet = "minecraft-1"

# your GCP service key
credentials-file = "~/terraform/terraform_keys/terraform-gcp-harbor-2-3ca67fec4859.json"

project = "terraform-gcp-harbor-2"

# machine type for the K8S nodes
machine-type = "n1-standard-2"



#server variables

# set to 0 for Bedrock edition server
java = 1
# set to 1 for Bedrock edition server
bedrock = 0

# 0 or 1 for Java, 'survival' or 'creative' for Bedrock
gamemode = 0

worldname = "GKE"

# version of Minecraft to deploy(if using Bedrock, this must be changed to 1.12.0.28 or an earlier Bedrock release)
release = "1.14.4"

# do not change for now
server-type = "VANILLA"

# not supported currently
ftb-modpack = "https://www.feed-the-beast.com/projects/ftb-presents-direwolf20-1-12/files/2690320"
