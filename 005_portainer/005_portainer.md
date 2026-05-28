# Homelab Refresh 005 - Portainer

#### Benjamin Godfrey

I want to add more services to my homelab. That shouldn't be a shock, my previous blogs show that I have some machines which talk to each other and not much else. I want to start making them useful. As I found while putting together my logging solution, Docker will be very helpful for this; it will keep my services nice and contained, and take some of the complexity away from me. Keep it simple stupid. I can make things even simpler though, I don't even want to pull and run my Docker containers by myself. I can use portainer for this.

## Installation

Installation for Portainer can be kept quite simple. We can use a Docker Compose file (with any luck, we shouldn't need many more Compose files after this!), as outlined [here](https://docs.portainer.io/start/install-ce/server/docker/linux#docker-compose). This page gives us the following config:

```yaml
services:
  portainer:
    container_name: portainer
    image: portainer/portainer-ce:lts
    restart: always
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer_data:/data
    ports:
      - 9443:9443
      - 8000:8000

volumes:
  portainer_data:
    name: portainer_data

networks:
  default:
    name: portainer_network
```

Soon enough, our container will be up and running. When this is done, we can access Portainer through a fairly simple web request: `https://<host IP>:9443`. We require an admin account, so we are prompted for a password. Once this is done, we have access to our Portainer instance.

## Setting up our environments

One more step we need to take before we can spin up all of our lovely Docker containers, we need to set up our environments. That is, we need to establish a connection between Portainer and each machine in our network. To me, the simplest way to do this is with the "Agent" option presented to us by Portainer. We can navigate to Environment-related > Environments > Add environment, and we are presented with a few options. It is worth saying here that Portainer has more functionality than I require. If any of these options seem of interest, have a look. For my requirements, I will select Docker Standalone as my environment. After starting the wizard I have a few options for connection. I will select "Agent". This option presents me with the following command:

```bash
docker run -d \
  -p 9001:9001 \
  --name portainer_agent \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /var/lib/docker/volumes:/var/lib/docker/volumes \
  -v /:/host \
  portainer/agent:2.39.2

```

This is to be run on whichever machine we are trying to set up an environment for. Once this container is up and running, we can go back to Portainer, enter a name and a url (most likely just port 9001 on the machine), and our environment can be created. We can go to Portainer's home page to see our brand new shiny environments. Assuming these are up and running ok, we can start spinning up containers!

## What was all of that about?

This step seems to come out of the blue in comparison to our previous set up tasks. This is not least because previous steps have been along the lines of "I want to do X, let's see what tools can help me", or "there are some options for Y, let's figure out which one is best". This step was much more "We are doing Z now". There are a couple of points around this:

- As I have mentioned, this series is a homelab refresh. I am redoing a lot of what I already had, but applying better practice. I have found in the past that Portainer is something that made things easier for me.
- We have a groundwork for our homelab in place, and we are now in a place where we are thinking less about what is needed and more about what we want. As such, I think it is justified to be more opinionated. If you have a better idea, do it!
