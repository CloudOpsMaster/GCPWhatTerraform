variable "region" {
    type = string
    default = "europe-west3"
}

variable "teamcityregion" {
    type = string
    default = "us-central1"
}



variable "network_cidr" {
    type = string
    default = "10.127.0.0/24"
}

variable "network_teamcity" {
    type = string
    default = "10.127.1.0/24"
}

# Teamcity ip
variable "teamcity_ip" {
    type = string
    default = "10.127.1.100"
}

# ip for loadbalancer
variable "loadbalancer_ip" {
    type = string
    default = "10.127.0.100"
}

# ip for back
variable "back_ip" {
    type = string
    default = "10.127.0.110"
}


# ip for front 1
variable "front1_ip" {
    type = string
    default = "10.127.0.120"
}

# ip for front 2
variable "front2_ip" {
    type = string
    default = "10.127.0.121"
}

# ip for master mysql
variable "mysql_master_ip" {
    type = string
    default = "10.127.0.130"
}

# ip for slave mysql
variable "mysql_slave_ip" {
    type = string
    default = "10.127.0.131"
}




variable "datasource_username" {
    type = string
    default = "eschool"
}

variable "datasource_password" {
    type = string
    default = "b1dnijpesvseshesre"
}

variable "mysql_root_password" {
    type = string
    default = "legme876FCTFEfg1"
}

variable "user" {
    type = string
    default = "rsa-key-20210903"
}

variable "publickeypath" {
    type = string
    default = "public.pub"
}