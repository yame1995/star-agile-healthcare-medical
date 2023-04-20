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
  provisioner "local-exec" {
  command = "ansible-playbook /var/lib/jenkins/workspace/health-care-project/serverfiles/healthcareplaybook.yml"
  } 
}
