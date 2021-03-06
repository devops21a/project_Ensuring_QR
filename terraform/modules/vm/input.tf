variable "location" {
  type = string
  default = "northeurope"
}
variable "resource_group" {}
variable "subnet_id" {}
variable "public_ip_address_id" {}
variable "size" {
  type = string
  default = "Standard_B1s"
}
variable "usr" {
	type = string
	default = "adminuser"
}
variable "pub_key" {
  type = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDTWSZpXKSrja9mACA0+j+0fp0VQHgNQvEq4Ta0DTJLV+XYyrcPjWS3gr5a2I2eYn2FFKZg/x+yOk0BshcB+jRqYEqMviq+yyvKa6vcwNR8E1T0nbaPRGV3SvuMI6c5pom5z1T1Ol1qACvM7V5ngrjUpGD2eEAgmTJ+TRdzkLZoHCwxRHm6uj7/0UdfEithiLcGWlmtJq1igsnmFgoCwYkdM+dQDaiAS8amoVMWL0sQxYKxtjwFmShdsnnhvWEAs1MjmMecat74yxNBEmPS91k5O0trPuS4rRmuMbYCr/q5qvpcwT15fTJO08JQRZy1lvE3U7oHpBAI8tHJwthD+yk8YdP1EmOl85oXnPutmrhGm4OPUAwRsl5CUarc3rNXPjYGNnRwgvjjb0Ujc5uMWeqsZIdXPgzSlGxZQgcwqLpYvTopPcmen7qx6I5k/M1J7BXdGwWJ+dtE//OnwHoMSnY8Qt2pP1I0wMAdCximNZ/gXxIniU1NmU3qM9vccDz8+uPZKiKSuwLAbHeeyXPu8xUEQ/2ry5CtzV7TnBgj8wBDZjT7rPUrWHJTnIIGatJE2proXNja48fVwGcrhp3D6aV8iW+BWyz5cE63RNhcMJ+LRLs2gHUaaCQAnhyPKwLWRXGDPxtvCloTb/+XHOAH6AuPEGMB3LpwiOqbXlnokeirDw== devops21a@outlook.com"
}