DigiByte Seeder
===============

DigiByte Seeder is a crawler for the DigiByte network, which exposes a list of reliable nodes via a built-in DNS server.

Features:
* regularly revisits known nodes to check their availability
* bans nodes after enough failures, or bad behaviour
* accepts nodes down to v0.5.0 to request new IP addresses from, but only reports good post-v0.6.9 nodes.
* keeps statistics over (exponential) windows of 2 hours, 8 hours, 1 day and 1 week, to base decisions on.
* very low memory (a few tens of megabytes) and cpu requirements.
* crawlers run in parallel (by default 96 threads simultaneously).

JOIN DIGIBYTE CRITICAL INFRASTRUCTURE TEAM (DGBCIT)
---------------------------------------------------

If you are intending to run a DigiByte Seeder, you are encouraged to join the [DGBCIT Telegram group](https://t.me/DGBCIT). The DigiByte Critical Infrastructure Team helps coordinate the seeders on the network. The team provides a detailed step-by-step tutorial for setting up your DigiByte Seeder and community support if you need help. Participation is optional but encouraged. Find the detailed tutorial [here](https://www.evernote.com/shard/s20/client/snv?noteGuid=46de28c1-9066-4ca5-8048-6f29f9e3bf52&noteKey=66077e0b3f969350ebefe4228d731425&sn=https%3A%2F%2Fwww.evernote.com%2Fshard%2Fs20%2Fsh%2F46de28c1-9066-4ca5-8048-6f29f9e3bf52%2F66077e0b3f969350ebefe4228d731425&title=Setting%2Bup%2Ba%2BDigiByte%2BSeeder). 

SETUP DNS RECORDS
-----------------

You need to use a domain name where you have access to the DNS settings. Assuming you want to run a DNS seed on seed.example.com, you will need an authorative NS record in example.com's domain record, pointing to for example vps.example.com. You will aslo need an A record for vps.example.com pointing at the IP address of the VPS.

Create an NS record:

- Host:     ```seed.example.com``` or ```testnetseed.example.com```  [ The desired address of your DigiByte Seeder. ]
- Answer:   ```vps.example.com```                                         [ A URL to identify your VPS. ] 

Create an A record:

- Host:     ```vps.example.com```                                        [ Use the same name you set above. ]
- Answer:   ```123.123.123.123```                                           [ The IP address of your VPS. ] 

Test the NS record:

$ ```dig -t NS seed.example.com```

Expected response: ```seed.example.com.   21600    IN      NS     vps.example.com.```

(It should return the URL you chose to identify your VPS.)

Test the A record:

$ ```dig -t A vps.example.com```

Expected response: ```vps.example.com.   161    IN      A     123.123.123.123```

(It should return the IP address of your VPS.)

COMPILE SOFTWARE
----------------

These instructions are or Ubuntu or Debian. 

Compiling will require boost and ssl.  On debian systems, these are provided by `libboost-dev` and `libssl-dev` respectively. 

If running Debian, switch to root:

$ ```su```

Perform a system update:

Ubuntu: $ ```sudo apt-get update```
Debian: $ ```apt-get update```

Install required software packages for DigiByte Seeder on Ubuntu or Debian:

Ubuntu: $ ```sudo apt-get install gcc g++ build-essential libboost-all-dev libssl-dev git tmux iptables```
Debian: $ ```apt-get install gcc g++ build-essential libboost-all-dev libssl-dev git tmux iptables```

If running Debian, switch back to user account ('linuxuser' in this example):

$ ```su linuxuser```

Clone the DigiByte Seeder software into your home folder:

$ ```cd ~/```

$ ```git clone https://github.com/DigiByte-Core/digibyte-seeder```

If setting up a testnet node, you need to make a change to protocol.cpp:

$ ```nano ~/digibyte-seeder/protocol.cpp```

Change line 25 to: ```unsigned char pchMessageStart[4] = { 0xfd, 0xc8, 0xbd, 0xdd };``` 

If you are also running a DigiByte full node on the same server, you need to make a change to main.cpp to add the loopback IP address:

$ ```nano ~/digibyte-seeder/main.cpp```

Change line 424 and 425 to add the loopback IP address: ```"127.0.0.1", ```. This will make it possible for the Seeder to connect directly to your local DigiByte full node.

To compile the software:

$ ```cd ~/digibyte-seeder```

$ ```make```

This will produce the `dnsseed` binary.

START DIGIBYTE SEEDER
---------------------

To view the software flag options, enter:

$ ```./dnsseed --help```

These are the flags supported by the dnsseed binary:

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

To make it easy to check on it in future, open a tmux session in which to run your DigiByte Seeder:

$ ```tmux new -s dgbseeder```

To run a mainnet seeder, enter:

$ ```./dnsseed -h seed.example.com -n vps.example.com -m email.example.com -p 5353 -a 123.123.123.123```

To run a testnet seeder, enter:

$ ```./dnsseed -h seed.example.com -n vps.example.com -m email.example.com -p 5353 -a 123.123.123.123 --testnet```

- Subsitute ```seed.example.com``` with the NS Host record.
- Subsitute ```vps.example.com``` with the A Host record.
- Subsitute ```email.example.com``` with an email address that you can be reached at for the SOA records, substituting the @ for a period. So youremail@example.com would be youremail.example.com.
- Subsitute ```123.123.123.123``` with IP address of your VPS from Step 1.
- If you are running testnet seeder, note that you must include the ```--testnet``` flag.

The software will begin crawling the DigiByte network. You may need to wait or minute or two to see results coming in. Check that the available count is climbing. This is a good sign that it is working correctly.

Disconnect from the tmux session by pressing ```Ctrl-B```, followed by ```D```

### Check on your Seeder

When you need to reconnect to the tmux session later, enter:

$ ```tmux a -t dgbseeder```


OPEN PORTS WHEN RUNNING AS NON-ROOT
-----------------------------------

Typically, you'll need root privileges to listen to port 53 (name service).

One solution is using an iptables rule (Linux only) to redirect it to
a non-privileged port.

Ubuntu:
$ ```iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-port 5353```

On Debian:
$ ```su```  (switch to root)
$ ```/sbin/iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-port 5353```
$ ```su linuxuser``` (switch back to user account)

If properly configured, this will allow you to run dnsseed in userspace, using
the ```-p 5353``` option.

You can make this change persistent with:

$ ```sudo apt-get install iptables-persistent -Y```

Another solution is allowing a binary to bind to ports < 1024 with setcap (IPv6 access-safe)

$ ```setcap 'cap_net_bind_service=+ep' /path/to/dnsseed```


TEST DIGIBYTE SEEDER
--------------------

To verify that your DigiByte Seeder is setup correctly, open a web browser and visit:

[https://www.whatsmydns.net/#A/](https://www.whatsmydns.net/#A/)

Enter the domain you chose for your seeder. You should see a list of IP addresses returned for each location.

For an example of what you should be seeing, look at the results for seed.digibyte.org here:

[https://www.whatsmydns.net/#A/seed.digibyte.org](https://www.whatsmydns.net/#A/seed.digibyte.org)

TROUBLESHOOTING
--------------

### Running under Ubuntu

All Ubuntu releases from 16.10 onwards come installed with systemd-resolved, which prevents the seeder from running effectively.

The recommended solution is to bind the seeder to a specific IP address

$ ```./dnsseed -h seed.example.com -n vps.example.com -a 123.123.123.123```

### Firewall

Be sure to check that port 53 is open on any external firewall.

If your system firewall is enabled, make sure you have opened port 53:

$ ```sudo ufw allow 53```

You can check the status of your system firewall with:

$ ```sudo ufw status```