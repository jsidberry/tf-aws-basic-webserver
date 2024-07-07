To create a web server on the latest Ubuntu image in AWS using Terraform, you'll want to configure several AWS resources. The setup will include an **EC2 instance** using the latest **Ubuntu AMI**, along with networking components like a **VPC**, **subnet**, **internet gateway**, and a **security group** to enable internet access. 

**Explanation**
1. **AMI Data Source**: This data source fetches the latest Ubuntu 20.04 AMI from Canonical's official AWS account.
2. **VPC and Subnet**: A VPC and a subnet are created to house the instance. `map_public_ip_on_launch` is set to true in the subnet configuration to assign a public IP, which is needed for internet access.
3. **Internet Gateway**: This enables connectivity between the instances in the VPC and the internet.
4. **Security Group**: Allows inbound HTTP (port 80) and SSH (port 22) traffic and allows all outbound traffic.
5. **EC2 Instance**: Launches an EC2 instance using the Ubuntu AMI within the created VPC and subnet, with the specified security group.
6. **Output**: The private IP address of the EC2 instance is outputted.

Make sure to have your AWS provider and credentials setup before running this Terraform configuration. Adjust the **region**, **instance type**, and **AMI** as needed for your specific requirements.