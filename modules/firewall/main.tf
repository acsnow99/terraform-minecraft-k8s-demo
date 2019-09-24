resource "google_compute_firewall" "ssh" {
    name = "${var.cluster-name}-ssh"
    network = "${var.network}"
    
    allow {
        protocol = "tcp"
        ports    = ["22"]
    }

}

resource "google_compute_firewall" "java" {
    count = "${var.java}"

    name = "${var.cluster-name}-minecraft"
    network = "${var.network}"

    allow {
        protocol = "tcp"
        ports = ["25565"]
    }

}

resource "google_compute_firewall" "bedrock" {
    count = "${var.bedrock}"

    name = "${var.cluster-name}-minecraft"
    network = "${var.network}"

    allow {
        protocol = "udp"
        ports = ["19132"]
    }

}
