terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = file("../dp-215-devops-team-1-demo.json")
  project     = "dp-215-devops-team-1-demo-1"
  region      = var.region
  zone        = "${var.region}-a"
}

resource "google_compute_network" "what_network" {
  name                    = "what-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "what_subnetwork" {
  name                     = "what-subnetwork"
  ip_cidr_range            = var.network_cidr
  network                  = google_compute_network.what_network.self_link
  region                   = var.region
  private_ip_google_access = true
}


resource "google_compute_subnetwork" "teamcity_subnetwork" {
  name                     = "teamcity-subnetwork"
  ip_cidr_range            = var.network_teamcity
  network                  = google_compute_network.what_network.self_link
  region                   = var.region
  private_ip_google_access = true
}

resource "google_compute_firewall" "vpc_icmp" {
  name    = "terraform-icmp-allow"
  network = google_compute_network.what_network.name

  allow {
    protocol = "icmp"
  }

  target_tags = ["icmp-allow"]

}

resource "google_compute_firewall" "vpc_http" {
  name    = "terraform-http-allow"
  network = google_compute_network.what_network.name

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  target_tags = ["http-allow"]

}

resource "google_compute_firewall" "vpc_https" {
  name    = "terraform-https-allow"
  network = google_compute_network.what_network.name


  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  target_tags = ["https-allow"]

}

resource "google_compute_firewall" "vpc_ssh" {
  name    = "terraform-ssh-allow"
  network = google_compute_network.what_network.name


  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["ssh-allow"]

}

resource "google_compute_firewall" "vpc_internal" {
  name          = "internal-allow"
  network       = google_compute_network.what_network.name
  source_ranges = [google_compute_subnetwork.what_subnetwork.ip_cidr_range]
  allow {
    protocol = "tcp"
  }
  target_tags = ["internal-allow"]
}

resource "google_compute_address" "static" {
  name = "ipv4-address"
}


resource "google_compute_instance" "loadbalanser" {
  name         = "loadbalnser"
  machine_type = "e2-small"
  depends_on   = [google_compute_subnetwork.what_subnetwork]
  tags         = ["ssh-allow", "http-allow", "https-allow", "icmp-allow", "https-server", "http-server"]



  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20210720"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.what_subnetwork.name
    network_ip = var.loadbalancer_ip
    access_config {
      #nat_ip = google_compute_address.static.address
    }
  }
  metadata_startup_script = templatefile("loadbalanser.sh.tpl",
    {
      FRONTEND_1 = var.front1_ip,
      FRONTEND_2 = var.front2_ip,
      GOOGLE = "google.com"
  })

}


#resource "google_compute_instance" "mysql_master" {
#  name         = "mysqlmaster"
#  machine_type = "e2-small"
#  depends_on   = [google_compute_subnetwork.what_subnetwork]
#  tags         = ["ssh-allow", "icmp-allow", "internal-allow"]
#
#metadata_startup_script = templatefile("mysql.sh.tpl", 
#{
#  DATASOURCE_USERNAME = var.datasource_username,
#  DATASOURCE_PASSWORD = var.datasource_password,
#  MYSQL_ROOT_PASSWORD = var.mysql_root_password
#})
#
#  boot_disk {
#    initialize_params {
#      image = "ubuntu-2004-focal-v20210720"
#    }
#  }
#
#
# network_interface {
#    subnetwork = google_compute_subnetwork.what_subnetwork.name
#    network_ip = var.mysql_master_ip
#    access_config {
#    }
#  }
#
## metadata = {
##     ssh-keys = "${var.user}:${file(var.publickeypath)}"
## 
##   }
#}
#
#
#
#resource "google_compute_instance" "mysql_slave" {
#  name         = "mysqlslave"
#  machine_type = "e2-small"
#  depends_on   = [google_compute_instance.mysql_master]
#  tags         = ["ssh-allow", "icmp-allow", "internal-allow"]
#
#metadata_startup_script = templatefile("mysql.sh.tpl", 
#{
#  DATASOURCE_USERNAME = var.datasource_username,
#  DATASOURCE_PASSWORD = var.datasource_password,
#  MYSQL_ROOT_PASSWORD = var.mysql_root_password
#})
#
#  boot_disk {
#    initialize_params {
#      image = "ubuntu-2004-focal-v20210720"
#    }
#  }
#
#
# network_interface {
#    subnetwork = google_compute_subnetwork.what_subnetwork.name
#    network_ip = var.mysql_slave_ip
#    access_config {
#    }
#  }
#
##metadata = {
##    ssh-keys = "${var.user}:${file(var.publickeypath)}"
##
##  }
#
#}
#
#
#resource "google_compute_instance" "front1" {
#  name         = "front1"
#  machine_type = "e2-small"
#  depends_on   = [google_compute_instance.back]
#  tags         = ["ssh-allow","http-allow","https-allow","icmp-allow", "https-server", "http-server"]
#  metadata_startup_script = templatefile("front1.sh.tpl",
#    {
#      DATASOURCE_USERNAME = var.datasource_username,
#      DATASOURCE_PASSWORD = var.datasource_password,
#      MYSQL_ROOT_PASSWORD = var.mysql_root_password
#  })
#
#  boot_disk {
#    initialize_params {
#      image = "ubuntu-2004-focal-v20210720"
#    }
#  }
#
#  network_interface {
#    subnetwork = google_compute_subnetwork.what_subnetwork.name
#    network_ip = var.front1_ip
#    access_config {
#    }
#  }
#  # metadata = {
#  #     ssh-keys = "${var.user}:${file(var.publickeypath)}"
#  #   }
#
#}
#
#
#
#resource "google_compute_instance" "front2" {
#  name         = "front2"
#  machine_type = "e2-small"
#  depends_on   = [google_compute_instance.back]
#  tags         = ["ssh-allow", "http-allow", "https-allow", "icmp-allow"]
#  metadata_startup_script = templatefile("front2.sh.tpl",
#    {
#      DATASOURCE_USERNAME = var.datasource_username,
#      DATASOURCE_PASSWORD = var.datasource_password,
#      MYSQL_ROOT_PASSWORD = var.mysql_root_password
#  })
#
#  boot_disk {
#    initialize_params {
#      image = "ubuntu-2004-focal-v20210720"
#    }
#  }
#
#  network_interface {
#    subnetwork = google_compute_subnetwork.what_subnetwork.name
#    network_ip = var.front2_ip
#    access_config {
#    }
#  }
#  # metadata = {
#  #     ssh-keys = "${var.user}:${file(var.publickeypath)}"
#  #   }
#
#}
#
#
#resource "google_compute_instance" "back" {
#  name         = "back"
#  machine_type = "e2-small"
#  #depends_on   = [google_compute_instance.mysql_master]
#  tags = ["ssh-allow", "http-allow", "https-allow", "icmp-allow"]
#  metadata_startup_script = templatefile("back.sh.tpl",
#    {
#      DATASOURCE_USERNAME = var.datasource_username,
#      DATASOURCE_PASSWORD = var.datasource_password,
#      MYSQL_ROOT_PASSWORD = var.mysql_root_password
#  })
#
#  boot_disk {
#    initialize_params {
#      image = "ubuntu-2004-focal-v20210720"
#    }
#  }
#
#  network_interface {
#    subnetwork = google_compute_subnetwork.what_subnetwork.name
#    network_ip = var.back_ip
#    access_config {
#    }
#  }
#  # metadata = {
#  #     ssh-keys = "${var.user}:${file(var.publickeypath)}"
#  #   }
#
#}
#
#
#
#resource "google_compute_instance" "teamcity" {
#  name         = "teamcity"
#  machine_type = "e2-small"
#  depends_on   = [google_compute_subnetwork.teamcity_subnetwork]
#  tags         = ["ssh-allow","http-allow","https-allow","icmp-allow", "https-server", "http-server" ]
#
#
#
#  boot_disk {
#    initialize_params {
#      image = "ubuntu-2004-focal-v20210720"
#    }
#  }
#
#  network_interface {
#    subnetwork = google_compute_subnetwork.teamcity_subnetwork.name
#    network_ip = var.teamcity_ip
#    access_config {
#    }
#  }
#  metadata_startup_script = templatefile("loadbalanser.sh.tpl",
#    {
#      APACHE_LOG_DIR__ = "apache2"
#  })
#
#}
#
#
