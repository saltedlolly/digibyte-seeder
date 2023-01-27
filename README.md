DigiByte Seeder
===============

DigiByte-seeder is a crawler for the DigiByte network, which exposes a list of reliable nodes via a built-in DNS server.

Features:
* regularly revisits known nodes to check their availability
* bans nodes after enough failures, or bad behaviour
* accepts nodes down to v0.5.0 to request new IP addresses from, but only reports good post-v0.6.9 nodes.
* keeps statistics over (exponential) windows of 2 hours, 8 hours, 1 day and 1 week, to base decisions on.
* very low memory (a few tens of megabytes) and cpu requirements.
* crawlers run in parallel (by default 96 threads simultaneously).

JOIN DGBCIT
-----------

If you are intending to run a DigiByte Seeder, you are encouraged to join the [DigiByte Core Infrastructure Team Telegram group](https://t.me/DGBCIT). The group offers a detailed step-by-step tutorial for setting up your DigiByte Seeder, and community support if you need help.

SETUP DOMAIN NAME
-----------------

You need to use a domain name where you have access to the DNS settings. We will use digidomain.com for this example. Assuming you want to run a DNS seed on seed.digidomain.com, you will need an authorative NS record in digidomain.com's domain record, pointing to for example vps.digidomain.com. You will aslo need an A record for vps.digidomain.com pointing at the IP address of the VPS.

Create an NS record:

- Host:     ```seed.digidomain.com``` or ```testnetseed.digidomain.com```  [ The desired address of your DigiByte Seeder. ]
- Answer:   ```vps.digdomain.com```                                         [ A URL to identify your VPS. ] 

Create an A record:

- Host:     ```vps.digidomain.com```                                        [ Use the same name you set above. ]
- Answer:   ```123.123.123.123```                                           [ The IP address of your VPS. ] 

Test it:

$ ```dig -t NS seed.digidomain.com```

Expected response:

seed.digidomain.com.   86400    IN      NS     vps.digidomain.com.


COMPILE SOFTWARE
----------------

Compiling will require boost and ssl.  On debian systems, these are provided
by `libboost-dev` and `libssl-dev` respectively.

Perform a system update:

$ ```sudo apt-get update```

Install the software packages needed to compile the DigiByte Seeder:

$ ```sudo apt-get install gcc g++ build-essential libboost-all-dev libssl-dev```

Clone the DigiByte Seeder software into your home folder:

$ ```cd ~/```

$ ```git clone https://github.com/DigiByte-Core/digibyte-seeder```

If setting up a testnet node, you need to make a change to protocol.cpp:

$ ```nano ~/digibyte-seeder/protocol.cpp```

Change line 25 to: ```unsigned char pchMessageStart[4] = { 0xfd, 0xc8, 0xbd, 0xdd };```

Compile the software:

$ ```cd ~/digibyte-seeder```

$ ```make```

This will produce the `dnsseed` binary.


START DIGIBYTE SEEDER
---------------------

To view the software flag options, enter:

$ ```./dnsseed -h```

It will display:

```
Usage: ./dnsseed -h <host> -n <ns> [-m <mbox>] [-t <threads>] [-p <port>]

Options:
-h <host>       Hostname of the DNS seed
-n <ns>         Hostname of the nameserver
-m <mbox>       E-Mail address reported in SOA records
-t <threads>    Number of crawlers to run in parallel (default 96)
-d <threads>    Number of DNS server threads (default 4)
-a <address>    Address to listen on (default ::)
-p <port>       UDP port to listen on (default 53)
-o <ip:port>    Tor proxy IP/Port
-i <ip:port>    IPV4 SOCKS5 proxy IP/Port
-k <ip:port>    IPV6 SOCKS5 proxy IP/Port
-w f1,f2,...    Allow these flag combinations as filters
--testnet       Use testnet
--wipeban       Wipe list of banned nodes
--wipeignore    Wipe list of ignored nodes
-?, --help      Show this text
```

To make it easy to check on it, open a tmux session in which to run your DigiByte Seeder:

$ ```tmux new -s dgbseeder```

To run a mainnet seeder, enter:

$ ```./dnsseed -h seed.digidomain.com -n vps.digidomain.com -m email.digidomain.com -p 5353 -a 123.123.123.123```

To run a testnet seeder, enter:

$ ```./dnsseed -h seed.digidomain.com -n vps.digidomain.com -m email.digidomain.com -p 5353 -a 123.123.123.123 --testnet```

- Subsitute ```seed.digidomain.com``` with the NS Host record.
- Subsitute ```vps.digidomain.com``` with the A Host record.
- Subsitute ```email.digidomain.com``` with an email address that you can be reached at for the SOA records, substituting the @ for a period. So youremail@digidomain.com would be youremail.digidomain.com. [This can be omitted if desired - remove "```-m  email.digidomain.com```" from the command.]
- Subsitute 123.123.123.123 with IP address of your VPS from Step 1.
- If you are running testnet seeder, note that you must include the ```--testnet``` flag.

Disconnect from the tmux session by pressing ```Ctrl-B```, followed by ```D```

When you need to reconnect to the tmus session later, enter:

$ ```tmux a -t dgbseeder```


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