variable "region" {
    default = "us-west1"
}
variable "cluster-name" {
    default = "mc-cluster"
}
variable "project" {
    
}

variable "java" {
    default = "1"
}
variable "bedrock" {
    default = "0"
}

variable "gamemode" {
    description = "For a Java server: 0 for survival, 1 for creative. For Bedrock: survival or creative"
    default = "0"
}
variable "worldname" {
    description = "Name for the Minecraft world"
    default = "GKE"
}
variable "release" {
    description = "Version of minecraft to use"
    default = "1.12.2"
}
variable "server-type" {
    description = "VANILLA, FORGE, BUKKIT, SPIGOT, PAPER, FTB, CURSEFORGE, or SPONGEVANILLA"
    default = "VANILLA"
}

variable "ftb-modpack" {
    default = "https://www.feed-the-beast.com/projects/ftb-presents-direwolf20-1-12/files/2690320"
}

variable "exists" {
    default = "0"
}
variable "existing-world" {
    default = ""
}


variable "kube-file" {
    type = "map"
    default = {
        "0" = "./resources/mc-pod-bedrock.yaml"
        "1" = "./resources/mc-pod-java.yaml"
    }
}
variable "properties-file" {
    type = "map"
    default = {
        "0" = "./resources/bedrock.server.properties"
        "1" = "./resources/java.server.properties"
    }
}
variable "pod-names" {
    type = "map"
    default = {
        "0" = "mc-server-pod-bedrock"
        "1" = "mc-server-pod-java"
    }
}
variable "disk-names" {
    type = "map"
    default = {
        "0" = "bedrock-disk"
        "1" = "java-disk"
    }
}
variable "existing-setup-file" {
    type = "map"
    default = {
        "0" = "./resources/bedrock-world-setup.sh"
        "1" = "./resources/java-world-setup.sh"
    }
}