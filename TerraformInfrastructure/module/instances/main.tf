# Define the AWS key pair
resource "aws_key_pair" "example_keypair" {
  key_name   = "my-keypair"  # Replace with your desired key pair name
  public_key = file("keyfiles/my-keypair.pub")
}

# Create EC2 instances associated with the key pair
resource "aws_instance" "example_instance" {
  count         = 2
  ami           = "ami-0fc5d935ebf8bc3bc"  # Replace with your desired Ubuntu AMI ID
  instance_type = "t2.micro"
  subnet_id     = element(var.public_subnet_ids, count.index)  # Dynamically select subnet IDs

  key_name      = aws_key_pair.example_keypair.key_name
  vpc_security_group_ids = [var.ec2_sg_id]  # Use the security group IDs from variables

  user_data = <<-EOF
              #!/bin/bash
              # Install CodeDeploy agent and Docker
              sudo apt-get update -y
              sudo apt-get install -y ruby wget

              # Install CodeDeploy agent
              cd /home/ubuntu
              wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
              chmod +x ./install
              sudo ./install auto

              # Install Docker
              sudo apt-get install -y docker.io
              sudo usermod -aG docker ubuntu
              sudo systemctl enable docker
              sudo systemctl start docker
              # Install AWS CLI
              sudo apt-get install -y awscli
              EOF

  tags = {
    Name = "ExampleInstance-${count.index + 1}"
  }
}