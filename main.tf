provider "google" {
    credentials = "${file("${var.credentials-file}")}"
    project = "${var.project}"
    region = "${var.region}"
    zone = "${var.region}-a"
}



module "cluster" {
  source = "./modules/cluster"

  cluster-name = "${var.cluster-name}"
  cluster-size = "${var.cluster-size}"
  network = "${var.network}"
  subnet = "${var.subnet}"
  machine-type = "${var.machine-type}"

}

module "firewall" {
  source = "./modules/firewall"

  cluster-name = "${var.cluster-name}"
  network = "${var.network}"

  java = "${var.java}"
  bedrock = "${var.bedrock}"

}

module "provisioner" {
  source = "./modules/provisioner"

  region = "${var.region}"
  cluster-name = "${module.cluster.cluster-name}"
  project = "${var.project}"

  java = "${var.java}"
  bedrock = "${var.bedrock}"
  gamemode = "${var.gamemode}"
  worldname = "${var.worldname}"
  release = "${var.release}"
  server-type = "${var.server-type}"
  ftb-modpack = "${var.ftb-modpack}"
  exists = "${var.exists}"
  existing-world = "${var.existing-world}"

  harbor = "${var.harbor}"
}