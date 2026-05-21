# Homelab Refresh 001 - Where are we?

#### Benjamin Godfrey

## The problem

My homelab, in its current form, is a mess. That is not a surprise, as it has evolved over time; grew, adapted, changed, if you will. New machines have been added, new services have popped up, services have become duplicated. As well as this, and perhaps more seriously, since I jumped into my homelabbing experience early doors, it is probably fair to say that the foundations were not as solid as they should have been.

All of this is to say, I fancy a refresh. I am at a point just now where I could tear it down, start again, and spend less than a day getting things back into line. To me, that is worth it. This will give me the opportunity to start again, apply best practice, and **document**. Here we go.

## The goal

- Simplify infrastructure
- Simplify deployment of services
- Improve security practice
- Improve documentation

## The resources

| Machine name   | Machine type      | CPU                | Memory | Storage | OS                   |
| -------------- | ----------------- | ------------------ | ------ | ------- | -------------------- |
| `zorn`         | 2010s SFF desktop | Intel Core i5-4570 | 16gb   | 1tb+    | Ubuntu Server        |
| `lebesgue`     | Raspberry Pi 1 B+ | Broadcom BCM2835   | ~0.5gb | 32gb    | Raspberry Pi OS lite |
| `romulus`      | Raspberry Pi 2 B  | Broadcom BCM2836   | ~1gb   | 64gb    | Raspberry Pi OS lite |
| `remus`        | Raspberry Pi 2 B  | Broadcom BCM2836   | ~1gb   | 64gb    | Raspberry Pi OS lite |

There is a clear difference in power between my machines, with `zorn` being much more powerful than each of the Pis. As such, I will use `zorn` as the main source of compute, handing smaller tasks off to the other machines. I will use either `romulus` or `remus` as the host of my wireguard vpn, as these are a nice middle ground of power.

We can also see that there is a difference in storage available to each machine. As such, I will plan to keep the services on `romulus`, `remus`, and `lebesgue` fairly stateless. This is a general rule, which will probably be broken in future.

## The network

These machines are all on the same LAN, connected by ethernet through an unmanaged switch. This is fine, and provides a baseline for communication. In addition to this, I will require a VPN to enable connection to machines and services from other devices. To facilitate this, I will use piVPN with wireguard, as it is a tool which I know.

In the interest of security, I will impose some network rules. Specifically, I will have a single ssh entry point via wireguard, on `zorn`. All other ssh traffic will go through LAN. Similarly, I will allow network requests to `zorn` only to a single port, and use an nginx reverse proxy to route traffic.

### Risks

| Risk | Notes |
| --- | --- |
| Single point of failure introduced with ssh over wireguard | As this is a homelab, only my own access to machines and services is important. Since all machines are on my LAN (and in my house) I will be able to access these, even in failure |