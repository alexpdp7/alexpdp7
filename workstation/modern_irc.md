With the [IRCv3](https://ircv3.net/) advances and modern software, IRC is a surprisingly nice chat/IM medium, although a bit complex to set up nicely.

See also [Internet communication channels](../misc/internet-communication-channels.md).

I am not writing a step-by-step guide in setting this up, mostly providing links to my setup scripts.
If you have issues reproducing this kind of setup, you can try contacting me (e.g. open a GitHub issue) and I can try to expand.

I use:

* [Soju](https://soju.im/) as a bouncer.
IRC basically only supports "synchronous" communication.
If your IRC client disconnects from a chat (because you turn off your computer, for example), then you lose the messages in your chats.
A bouncer is a persistent IRC client that you run on a 24/7 computer that connects to your IRC chats for you, then you connect a client to the bouncer.
This way, the bouncer captures all messages and you can view them right after connecting a client.
This achieves the "scrollback" that conventional chat clients provide.
Soju also uses modern extensions to make the IRC experience simpler.

* [Bitlbee](https://www.bitlbee.org) as a bridge to Telegram.
Bitlbee connects traditional IM networks, such as XMPP to IRC.
There are plugins for many IM systems, including WhatsApp.
However, WhatsApp does not have a "supported API", so I am wary to use anything else than official clients.
But with Telegram, I can integrate IRC with it.

* [Senpai](https://git.sr.ht/~taiite/senpai) is a modern terminal IRC client that is "Soju-aware".

* [Goguma](https://sr.ht/~emersion/goguma/) is a Flutter/Android IRC client that is also "Soju-aware".

With this setup, I can:

* Connect to IRC chats in a friendly manner with modern comforts.
* Use Telegram from a terminal, avoiding many things I don't like about the Telegram clients (everything is janky, esp. scroll and search. Also information density is terribly low).
* Access this setup via SSH, so I can use it on "foreign" computers.

# Set up

My [workstation container image](build_workstation) includes Soju, Bitlbee, and the Telegram/Bitlbee adapter.
I have Python scripts that configure [soju](../scripts/p7s/soju.py) and [Bitlbee](../scripts/p7s/bitlbee.py) as persistent systemd services running as containers.

I use [Senpai](https://git.sr.ht/~delthas/senpai/) through [nix-portable](https://github.com/DavHau/nix-portable).

I install Goguma on my phone using [F-Droid](https://f-droid.org/).

After connecting Senpai to Soju, you talk to a bot called `BouncerServ` to connect to your IRC networks, including the "virtual" IRC network that Bitlbee uses.
When you join/part channels in any client, Soju takes care of making those actions permanent.

You message a special channel in Bitlbee to create "accounts" that connect to IM networks such as Telegram.

* Take care of following [the Telegram Bitlbee documentation on configuring it for proper nicknames](https://github.com/BenWiederhake/tdlib-purple/#proper-user-names-in-bitlbee).
* Set the `read-receipts` account property to `false`?
* Set the `auto_join` channel property to `true`?
* `chat list telegram-tdlib` lists channels, but only shows topic, not title. Maybe <https://github.com/ars3niy/tdlib-purple/issues/138>?

# Possible improvements

[Gamja](https://sr.ht/~emersion/gamja/) is another "Soju-aware" IRC client that provides a web interface.
Gamja and Goguma even support OAuth for authentication.

Right now I run Soju on a private network, so I cannot access it outside my VPN.
For this reason, I use trivial passwords and plain-text protocols.
For convenience (using Goguma on random networks without connecting to the VPN), I should set up TLS and proper authentication.
