# Homelab Refresh 003 - Network 101 - Execution

#### Benjamin Godfrey

One of the best things about Raspberry Pis is not only can you do a lot with them, but you can usually do it easily. In the case of setting up a wireguard vpn, we can use PiVPN.

For install, simply run this script from [their website](https://www.pivpn.io), `curl -L https://install.pivpn.io | bash `. After a quick download, this will kick off the PiVPN Automated Installer. This installer is fairly simple, and it will call out some of the less intuative things, like setting static IPs. At some point the installer asks if we want to use Wireguard or OpenVPN. I will pick Wireguard.

After this, we can mostly go back to accepting defaults. Pay attention to what is being asked though, as some details may be important. For example, I know that my ISP router cannot provide a static public IP to my machines. As such, I will need to use a public DNS name to point to my vpn's gateway, rather than a static IP. Fear not, this is an option for us in the PiVPN installer. I use [duckDNS](https://www.duckdns.org) to create by DNS name, it is free and I have had no issues so far. To keep this DuckDNS name up to date, I use the following script:

```bash
#!/bin/bash

SUBDOMAIN="<my subdomain>"
TOKEN="<my token>"

curl -s "https://www.duckdns.org/update?domains=$SUBDOMAIN&token=$TOKEN&ip="

echo "DuckDNS update request sent."
```

We will want to make sure that this script is executable with `chmod +x /path/to/script`, and then we are set. We can run this script (`/path/to/script`), and it will make a request to DuckDNS to point that subdomain to the public IP of our machine. Very nice. If we wanted to be really on the ball, we might want to set this to run on a schedule using `cron`.

Back to the task at hand. We should be able to run through the rest of the installation accepting the defaults. At the end, we will want to restart our machine, and then there we have it. A VPN hosted on our Raspberry Pi! We can create a client for this with `pivpn add`. If the client is another Linux machine, we install `wireguard-tools`, pop our new `.conf` file in `/etc/wireguard`, and start up the interface with `wg-quick up <wg network name>`. If the client is a phone, even easier, we can use the Wireguard app and create a new connection with a qr code, generated with `pivpn -qr`. And just like that, we have our connection! We can go, load up our [favourite website](https://metoffice.gov.uk/), and....

Nothing.

At this point we have a bit of a panic, because things should be working. We have our machines, they can all talk to each other, they can all talk to the internet, we have our Wireguard VPN up and running, we are connected to it. Double check everything, reboot everything. Still we have no connection. Now we start googling. We find some troubleshooting tips:

- checing the health of pivpn (`pivpn -d`)
- checking the hosts which are connected (`pivpn -c`)
- logging all network traffic (`tcpdump`). 

Even still, no sign of life.

Just as we are about to throw in the towel and cut our losses, we find one more piece of advice. We need to make sure our router is forwarding port 51820 to our host. Without doing this, when we try to connect to our VPN, our requests get as far as our router, but then the router does not know what to do with them. We need to go in to our router's admin settings, and add a rule to forward port 51820 (or whatever port you changed this to during installation) to our host machine's LAN IP address using the UDP protocol. The specifics on this change from router to router, but some googling and reading will keep you right. Once we have set this, with a bit of luck, we are golden. Our connection works.

(I should say here, I had set up PiVPN before, and so I skipped this port forwarding step earlier. It would be best to set this right away. The problem that I had here was from an oversight I made - I was setting up my PiVPN instance on a new machine. My router was still forwarding port 51820, but to the wrong place. The devil is in the details.)

#### Appendix - AI Assistance

As an aside at this early stage of setting up my homelab, I think it is worth talking about tools like ChatGPT and Claude. These guys can help a lot with this sort of stuff. Things like Raspberry Pis, Wireguard, networks; these are things which have been about for years, and are all well documented across the internet. As are the common problems people face when they try to set them up. This means that AI tools have been trained quite well on this stuff, and they will be able to guide you through most problems you have. Ironically as well, if you are decently well acquianted with these tools, you will have a rough idea of what your problem will be, so you can provide enough detail to get good advice on fixing issues, rather than the vague "this is not working" messages which a novice might give.

With all of this said, we need to make a decision. How much help do we want? In my case, I am building my homelab mainly because I want to learn, and I think it is fun. That is, I am doing this exactly because I will get a benefit from going through the process. As such, it would not make sense to go to ChatGPT for troubleshooting. That is a rough rule which I will set myself, and at times I will go against it. For anyone else going through the same process with the same reasoning, I would recommend doing the same. Try to avoid treating these AI tools as crutches. Use them to do the jobs for which there is no benefit of going through the process.