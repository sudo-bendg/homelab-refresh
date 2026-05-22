# Homelab Refresh 003 - Network 101 - Execution

#### Benjamin Godfrey

Ok, so we have our machines. We know how to use them. They can talk to each other. We have a homelab!

## What now?

Where do we want to go from here? For me, I want to be able to talk to my machines from the outside world. In days to come when I have apps up and running, I should be able to pull out my phone and load these up, even when I am not in my house. This is my new goal.

There are a few ways to do this. Each of them will have pros and cons. Our job, as architects, is to weigh these up and decide what is best for us.

## Network Access Options

| | Description | Pros | Cons |
| --- | --- | --- | --- |
| 1 | Wireguard vpn with IP for each machine | <ul><li>Familiar technology</li><li>This will give me the access to all services I require</li><li>Easily expandable down the line</li><li>Ability to ssh into any machine</li></ul> | <ul><li>Each machine will have multiple IP addresses, opening scope for inconsistency</li><li>As above, opening scope for security issues</li><li>Routing traffic through Raspberry Pi 2 may impact performance</li></ul> |
| 2 | Wireguard vpn with IP for one machine, with reverse proxy routing | <ul><li>Familiar technology</li><li>Only one machine with multiple addresses, reducing inconsistency and complexity</li><li>Ability to ssh into any machine, via machine with wireguard IP</li></ul> | <ul><li>Possibility for incompatibility with reverse proxy routing</li><li>Underutilisation of wireguard</li><li>Longer routes</li><li>Routing traffic through Raspberry Pi 2 may impact performance</li></ul> |
| 3 | Forward port through router | <ul><li>Traffic does not require routing through Raspberry Pi 2</li></ul> | <ul><li>Opening ports is famously a way to introduce attacks</li></ul> |
| 4 | Cloudflare tunnel or similar | <ul><li>Traffic does not require routing through Raspberry Pi 2</li><li>No opening my entire home network to the public internet</li></ul> | <ul><li>Unfamiliar technology</li></ul> |

### My verdict

I am sure that this list is not exhaustive, it is just what I know (or think I know). Straight away I am happy to rule out option 3. I am not comfortable enough with this approach to trust myself. I am sure my wife would be less than happy if I ended up racking up a massive energy bill because someone started mining bitcoin on our laptops. I know with a bit of thought and effort I could do this securely, but I don't need to introduce any risk at this layer, so I won't.

I am also going to rule out option 4. I am more comfortable with the idea behind this approach, and might be what I go for if I was hosting a site which I wanted others to get to, but I think it would be overkill for my needs. Added to this, my whole aim in creating a homelab is to *do it myself*. Putting a dependency on some external provider goes against this ethos.

These two are quite easy to rule out. This makes sense - a self hosted vpn is the canonical tool to achieve my goal. This leaves me with the question, how do I want to interact with my machines once I have my vpn is in place? Having reviewed these options, I think option 2 is a bit daft. Why should I set up some infrastructure just to ignore it? I will proceed to create a wireguard vpn on one of my Raspberry Pi 2s (`romulus` or `remus`), and assign each machine on my network an IP on this interface. To mitigate the risks, I will add some caveats:

- Allow ssh traffic only:
	- Via lan IP and wireguard IP for `zorn`
	- Via lan IP for all other machines
- Enforce use of lan IP for any development I take on
- Keep an eye on performance going forwards

This approach gives me the best of both worlds. I will keep my ssh traffic local for the most part, but give myself a way to get into the network from the outside.

With all of this planning in place, let's get started.