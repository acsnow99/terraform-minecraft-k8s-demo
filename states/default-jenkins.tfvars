region = "us-west1"

cluster-name = "mc-server"

# scale up if the server has difficulties
cluster-size = 1

network = "minecraft"

subnet = "minecraft-1"

# your GCP service key
credentials-file = "/keys/terraform-gcp-harbor-2-72245571699e.json"

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

worldname = "Jenkins World"

# version of Minecraft to deploy(if using Bedrock, this must be changed to 1.12.1.1 or an earlier Bedrock release)
release = "1.14.4"

# supports FTB and VANILLA
server-type = "VANILLA"

# URL of the modpack on FTB website
ftb-modpack = "https://www.feed-the-beast.com/projects/ftb-presents-direwolf20-1-12/files/2690320"

# 1 if from an existing world on your local machine
exists = "0"
# path to the existing world files. If Bedrock, point to the 'db' directory inside the world directory.
existing-world = "~/Desktop/WvvpXPNgAAA=/db"


harbor = "2"