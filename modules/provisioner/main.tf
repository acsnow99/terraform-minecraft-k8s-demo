data "template_file" "deploy" {
    template = "${file(lookup("${var.kube-file}", "${var.java}"))}"
    
    vars = {
        release = "${var.release}"
        server-type = "${var.server-type}"
    }
}

data "template_file" "server-properties" {
    count = "${var.java}"
    template = "${file("./resources/java.server.properties")}"
    
    vars = {
        worldname = "${var.worldname}"
        gamemode = "${var.gamemode}"
    }
}


resource "null_resource" "deploy" {
    provisioner "local-exec" {
        command = "echo '${data.template_file.deploy.rendered}' > resources/mc-pod-provisioned.yaml && gcloud container clusters get-credentials ${var.cluster-name} --zone ${var.region}-a --project ${var.project} && kubectl apply -f resources/mc-pod-provisioned.yaml && kubectl apply -f resources/pvc.yaml && rm resources/mc-pod-provisioned.yaml"
    }
}

resource "null_resource" "server-properties" {
    provisioner "local-exec" {
        command = "gcloud container clusters get-credentials ${var.cluster-name} --zone ${var.region}-a --project ${var.project} && kubectl cp ${lookup("${var.properties-file}", "${var.java}")} ${lookup("${var.pod-names}", "${var.java}")}:/data/server.properties"
    }
}