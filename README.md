digibyte-seeder
===============

DigiByte-seeder is a crawler for the DigiByte network, which exposes a list
of reliable nodes via a built-in DNS server.

Features:
* regularly revisits known nodes to check their availability
* bans nodes after enough failures, or bad behaviour
* accepts nodes down to v0.5.0 to request new IP addresses from,
  but only reports good post-v0.6.9 nodes.
* keeps statistics over (exponential) windows of 2 hours, 8 hours,
  1 day and 1 week, to base decisions on.
* very low memory (a few tens of megabytes) and cpu requirements.
* crawlers run in parallel (by default 96 threads simultaneously).

DOMAIN NAME SETUP
-----------------

You need to use a domain name where you have access to the DNS settings. We will use digidomain.com for this example:

Create an NS record:-

- Host:     **seed.digidomain.com** or **testnetseed.digidomain.com**  [ The desired address of your DigiByte Seeder. ]
- Answer:   **vps.digdomain.com** [ A URL to identify your VPS. ] 

Create an A record:-

- Host:     **vps.digidomain.com**                                      [ Use the same name you set above. ]
- Answer:   **123.123.123.123**                                         [ The IP address of your VPS. ] 


COMPILING
---------

Compiling will require boost and ssl.  On debian systems, these are provided
by `libboost-dev` and `libssl-dev` respectively.

Install software requirements using:

$ ```sudo apt-get install build-essential libboost-all-dev libssl-dev```

Clone repo to home folder:

$

USAGE
-----

Assuming you want to run a dns seed on dnsseed.example.com, you will
need an authorative NS record in example.com's domain record, pointing
to for example vps.example.com:

$ dig -t NS dnsseed.example.com

;; ANSWER SECTION
dnsseed.example.com.   86400    IN      NS     vps.example.com.

On the system vps.example.com, you can now run dnsseed:

./dnsseed -h dnsseed.example.com -n vps.example.com

If you want the DNS server to report SOA records, please provide an
e-mail address (with the @ part replaced by .) using -m.

SOFTWARE FLAGS
--------------


COMPILING
---------
Compiling will require boost and ssl.  On debian systems, these are provided
by `libboost-dev` and `libssl-dev` respectively.

$ make

This will produce the `dnsseed` binary.


RUNNING AS NON-ROOT
-------------------

Typically, you'll need root privileges to listen to port 53 (name service).

One solution is using an iptables rule (Linux only) to redirect it to
a non-privileged port:

$ iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-port 5353

If properly configured, this will allow you to run dnsseed in userspace, using
the -p 5353 option.

Another solution is allowing a binary to bind to ports < 1024 with setcap (IPv6 access-safe)

$ setcap 'cap_net_bind_service=+ep' /path/to/dnsseed

RUNNING UNDER UBUNTU
-------------------

All Ubuntu releases from 16.10 onwards come installed with systemd-resolved, which prevents the seeder from running effectively.

The recommended solution is to bind the seeder to a specific IP address

./dnsseed -h dnsseed.example.com -n vps.example.com -a 123.123.123.123


DGBCIT
------

If you are intending to run a DigiByte Seeder, you are encouraged to join the DigiByte Core Infrastructure Team. Please join the Telegram group here.