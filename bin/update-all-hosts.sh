LXCs=(10.2 10.100 10.102 10.110 10.111 10.113)

for i in "${LXCs[@]}"; do
    ssh -t $i "sudo apt-get update -y && sudo apt-get upgrade -y" -J adryd.com
done