output "vm_ssh_command" {
  description = "Команда для подключения к серверу по SSH"
  value       = "ssh -i ssh_keys/bookstore_key ipiris@${yandex_compute_instance.bookstore_vm.network_interface.0.nat_ip_address}"
}

output "app_url" {
  description = "URL для доступа к веб-приложению"
  value       = "http://${yandex_compute_instance.bookstore_vm.network_interface.0.nat_ip_address}:8080"
}
