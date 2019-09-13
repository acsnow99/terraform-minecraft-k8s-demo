data "template_file" "deploy" {
    template = "${file(lookup("${var.kube-file}", "${var.java}"))}"
    
    vars = {
        release = "${var.release}"
        server-type = "${var.server-type}"
    }
}

data "template_file" "server-properties" {
    template = "${file("${lookup("${var.properties-file}", "${var.java}")}")}"
    
    vars = {
        worldname = "${var.worldname}"
        gamemode = "${var.gamemode}"
    }
}


resource "null_resource" "deploy-with-server-properties" {
    provisioner "local-exec" {
        command = "echo '${data.template_file.deploy.rendered}' > resources/mc-pod-provisioned.yaml && gcloud container clusters get-credentials ${var.cluster-name} --zone ${var.region}-a --project ${var.project} && gcloud compute disks create ${lookup("${var.disk-names}", "${var.java}")} --zone us-west1-a && kubectl apply -f resources/mc-pod-provisioned.yaml && rm resources/mc-pod-provisioned.yaml"
    }


    provisioner "local-exec" {
        command = "echo '${data.template_file.server-properties.rendered}' > ./resources/server.properties.provisioned && gcloud container clusters get-credentials ${var.cluster-name} --zone ${var.region}-a --project ${var.project} && sleep 60 && kubectl cp ./resources/server.properties.provisioned ${lookup("${var.pod-names}", "${var.java}")}:/data/server.properties && kubectl exec -it ${lookup("${var.pod-names}", "${var.java}")} chmod 777 /data/server.properties && rm ./resources/server.properties.provisioned"
    }
}

resource "null_resource" "restart-java" {
    count = "${var.java}"

    depends_on = [null_resource.deploy-with-server-properties]

    provisioner "local-exec" {
        command = "kubectl exec -it ${lookup("${var.pod-names}", "${var.java}")} rcon-cli stop"
    }
}

resource "null_resource" "restart-bedrock" {
    count = "${var.bedrock}"

    depends_on = [null_resource.deploy-with-server-properties]

    provisioner "local-exec" {
        command = "kubectl exec ${lookup("${var.pod-names}", "${var.java}")} -- /bin/sh -c 'kill 1'"
    }
}