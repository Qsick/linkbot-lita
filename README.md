# Linkbot using Lita
This repository contains information for development and production for Linkbot using Lita for Slack.  It builds two Docker containers: redis and lita

# Development
To develop for Linkbot the docker images will need to be started on your laptop.  You're going to need a slack API token in order to run it from your laptop and interface with Slack.  You can get it from slack or ask someone else who already has one.

# Starting Lita on your local system
You will need docker installed on your laptop.  After you clone this repository you should be able to do the following to get the bot started:

```
Clone the github repo into ~/code/linkbot-lita
cd ~/code/linkbot-lita
cp app/lita_config.example app/lita_config.rb
Modify app/lita_config.rb and enter the config.adapters.slack.token
docker-compose build
docker-compose up
```

Now you're ready to develop. The code is all located in the app directory.

# Plug-ins
You can download community plug-ins or create your own. Public plug-ins can be added to the Gemfile located at
```
docker/lita/app/Gemfile
```
and in-house created plug-ins can be added to the same Gemfile and put them in the app/local_plugins directory
```
app/local_plugins/<plug-in name>
```

# Production Server Setup
In AWS bring up a t2.micro system running Ubuntu and connect
## Install Docker
```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce
```
## Lita Initial Install
Below was brought together using https://docs.lita.io/getting-started/deployment/#docker

Clone repository into /var/lita.  You will have to set up all the proper keys.
```
git clone git@github.com:Qsick/linkbot-lita.git /var/lita
```
Create your lita_config.rb file
```
cp /var/lita/app/lita_config.example /var/lita/app/lita_config.rb
Edit /var/lita/app/lita_config.rb for production bot
```
Prepare initial version of Lita
```
cd /var/lita
git pull
docker build -t lita .
```
Copy startup files into place
```
sudo cp /var/lita/prod/redis.service /etc/systemd/system/redis.service
sudo cp /var/lita/prod/lita.service  /etc/systemd/system/lita.service
```
Start and enable Redis
```
systemctl start redis
systemctl enable redis
```
Start and enable Lita
```
systemctl start lita
systemctl enable lita
```
### Deploy a new version
```
cd /var/lita
git pull
docker build -t lita .
systemctl restart lita
```
### Remove old docker images
```
docker rmi -f dangling=true
```

# Additional Docker Notes
If you're not familiar with Docker like when I started this repository some of the following commands will prove to be helpful

List running containers
```
docker ps
```

List containers from docker-compose (I don't understand completely but it's different)
```
docker-compose ps
```

List Docker Images
```
docker image list
```

Delete Docker Image
```
docker rmi <IMAGE ID>
```

Force Delete Docker Image
```
docker rmi -f <IMAGE ID>
```

Stop docker container
```
docker stop <Container ID>
```

Clean up all docker stuff (I don't believe it deletes images)
```
docker system prune
```


