
## public ip fot mysql master
# output "mysql_master_public_ip" {
#   value = google_compute_instance.mysql_master.network_interface.0.access_config.0.nat_ip
# }
# 
## public ip fot mysql slave
# output "mysql_slave_public_ip" {
#   value = google_compute_instance.mysql_slave.network_interface.0.access_config.0.nat_ip
# }
# public ip for loadbalancer
 output "loadbalanser_public_ip" {
   value = google_compute_instance.loadbalanser.network_interface.0.access_config.0.nat_ip
 }

