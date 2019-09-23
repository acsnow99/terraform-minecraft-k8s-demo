data "template_file" "pod-setup" {
    template = "${file("./resources/pod-setup.sh")}"

    vars = {
        cluster-name = "${var.cluster-name}"
        region = "${var.region}"
        project = "${var.project}"
        disk-name = "${lookup("${var.disk-names}", "${var.java}")}"
        podname = "${lookup("${var.pod-names}", "${var.java}")}"
    }
}

data "template_file" "deploy" {
    template = "${file(lookup("${var.kube-file}", "${var.java}"))}"
    
    vars = {
        release = "${var.release}"
        server-type = "${var.server-type}"
        ftb-modpack = "${var.ftb-modpack}"
        docker-image = "${lookup("${var.docker-image}", "%{ if var.harbor != "0" }${var.harbor}%{ else }${var.java}%{ endif }!")}"
    }
}

data "template_file" "server-properties" {
    template = "${file("${lookup("${var.properties-file}", "${var.java}")}")}"
    
    vars = {
        worldname = "${var.worldname}"
        gamemode = "${var.gamemode}"
    }
}

data "template_file" "existing-world-setup-local" {
    template = "${file("./resources/world-setup-local.sh")}"

    vars = {
        podname = "${lookup("${var.pod-names}", "${var.java}")}"
        existing-world = "${var.existing-world}"
    }
}

data "template_file" "existing-world-setup" {
    template = "${file("${lookup("${var.existing-setup-file}", "${var.java}")}")}"

    vars = {
        worldname = "${var.worldname}"
    }
}



#resource "null_resource" "add-world" {

# copies over existing world files

#    count = "${var.exists}"

#    depends_on = [null_resource.deploy-with-server-properties]

#    provisioner "local-exec" {
#        command = "sleep 60 && kubectl cp ${var.existing-world} ${lookup("${var.pod-names}", "${var.java}")}:/tmp/db"
#    }

#}

resource "null_resource" "world-setup" {
    
# sets up directory for the Minecraft server so the world files are accepted correctly by the Docker container

    count = "${var.exists}"

    depends_on = [     "null_resource.deploy-with-server-properties"]
    #"null_resource.add-world",

    provisioner "local-exec" {
        command = "sleep 60 && echo '${data.template_file.existing-world-setup.rendered}' > ./resources/world-setup-provisioned.sh && echo '${data.template_file.existing-world-setup-local.rendered}' > ./resources/world-setup-local-provisioned.sh && echo '${data.template_file.deploy.rendered}' > ./resources/mc-pod-provisioned.yaml && bash ./resources/world-setup-local-provisioned.sh"
    }

}



resource "null_resource" "deploy-with-server-properties" {

    provisioner "local-exec" {
        command = "gcloud container clusters get-credentials ${var.cluster-name} --zone ${var.region}-a --project ${var.project}"
    }

    provisioner "local-exec" {
        command = "echo '${data.template_file.pod-setup.rendered}' > ./resources/pod-setup-provisioned.sh && echo '${data.template_file.deploy.rendered}' > resources/mc-pod-provisioned.yaml && echo '${data.template_file.server-properties.rendered}' > ./resources/server.properties.provisioned && bash ./resources/pod-setup-provisioned.sh"
    }

}

resource "null_resource" "restart-pod" {

    depends_on = [null_resource.deploy-with-server-properties]

    provisioner "local-exec" {
        command = "kubectl delete pod ${lookup("${var.pod-names}", "${var.java}")} && kubectl apply -f ./resources/mc-pod-provisioned.yaml && rm resources/mc-pod-provisioned.yaml"
    }
}