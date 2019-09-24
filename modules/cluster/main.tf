resource "google_container_cluster" "mc-server" {
    name = "${var.cluster-name}"
    initial_node_count = 1
    remove_default_node_pool = true
    network = "${var.network}"
    subnetwork = "${var.subnet}"

    master_auth {
        username = ""
        password = ""
        client_certificate_config {
            issue_client_certificate = false
        }
    }
}

resource "google_container_node_pool" "mc-server-nodes" {
  name       = "${var.cluster-name}-pool"
  cluster    = "${google_container_cluster.mc-server.name}"
  node_count = "${var.cluster-size}"

  node_config {
    preemptible  = true
    machine_type = "${var.machine-type}"

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

  }
}
