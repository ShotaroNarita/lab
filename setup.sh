# if the terminal container already running, exit
if [ "$(docker ps -q -f name=terminal)" ]; then
    echo "The terminal container is already running"
    echo "if you wish to erase the all of related containers, images, network, volumes, and run the terminal container again, please run the following command:"
    echo "docker-compose down --rmi all --volumes --remove-orphans"
    exit 0
fi

# if public key already exists on current directory, exit
if [ -f terminal.pub ]; then
    echo "The public key already exists"
    exit 0
fi

# prepare the key pair for the terminal container

# if ~/.ssh/terminal.pub does not exist
if [ ! -f ~/.ssh/terminal.pub ]; then
    echo "Generating SSH key pair for terminal container"
    ssh-keygen -t ed25519 -C "" -f ~/.ssh/terminal -N "" 
fi

cp ~/.ssh/terminal.pub .

# clear all containers, images, network, volumes related to the terminal
docker-compose down --rmi all --volumes --remove-orphans

# build and run the terminal container
docker compose up -d --build

# remove public key
rm terminal.pub

echo "To connect to the terminal container, run the following command:"
echo "ssh localhost -p 2222 -i ~/.ssh/terminal"