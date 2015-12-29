$vm_box = "minimal/jessie64"  #Debian 8
#$vm_box = "minimal/trusty64" #Ubuntu 14.04

$vm_memory = 2048
$vm_cpus = 4

$hostname = "domain.local"
$vm_name = "Project name"

$vm_ips = ["192.168.56.100"]
$vm_ssh_port = 2200

$shared_folders = {'D:/projects/project/www' => '/var/www'}

# Set = true for debugging
#$gui = true


