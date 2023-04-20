resource "aws_instance" "test-server" {
  ami           = "ami-02eb7a4783e7e9317" 
  instance_type = "t2.medium" 
  key_name = "manu"
  vpc_security_group_ids= ["sg-0e5fd0e80c68fc9cb"]
  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("./manu.pem")
    host     = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [ "echo 'wait to start instance' "]
  }
  tags = {
    Name = "test-server"
  }
  provisioner "local-exec" {
        command = " echo ${aws_instance.test-server.public_ip} > inventory "
		}
  provisioner "remote-exec" {
	inline = [
        "sudo apt update -y",
              "sudo apt install docker.io -y",
              "sudo snap install microk8s --classic",
              "sudo sleep 30",
              #"sudo usermod -aG microk8s $USER",
             #"sudo chown -f -R $USER ~/.kube",
             # "sudo microk8s status --wait-ready",
             # "sudo microk8s enable dns ingress",
              "sudo microk8s status",
              "sudo microk8s kubectl create deployment health-deploy --image=mouni1arjun/health-care:latest",
              "sudo microk8s kubectl expose deployment health-deploy --port=8082 --type=NodePort",
              "sudo microk8s kubectl get svc",
              "sudo echo Public IP Address of the Instance",
              "sudo curl http://checkip.amazonaws.com",
  ]
  } 
}
