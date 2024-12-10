# Internet communication channels

If you want to provide a communication channel for a community over the Internet and you are considering options such as:

* Slack
* Discord
* Reddit
* Telegram
* WhatsApp
* Facebook
* Or any other communication channel controlled by a single big company

, then please read this article and consider an alternative.

Because such channels are often convenient, cheap, and easy, they are natural choices.

However, companies are about maximizing their benefits first.
Certainly, providing convenient, cheap, and easy services often help companies make money.
But I believe we have seen enough examples of companies putting their benefits first in detriment of their users.

Using these alternatives will always require more effort.
This text is long, and just reading and processing it might take more time than setting up a channel on the services mentioned above.
The alternatives I describe certainly have drawbacks compared to the services I am asking you to avoid.
However, in the long run I think making an extra effort to make an informed choice pays off.

## Alternatives

### Instant messaging

#### IRC

IRC is a real-time chat protocol created in 1988 that is still in use.
Many perceive flaws in IRC that seem to make it a bad choice.
However, many IRC flaws have been addressed in recent times and I believe it is a good choice in many (but not all) scenarios.

The biggest traditional issue with IRC is channels without history, where you cannot see messages posted while you were offline.
(If you suspend or turn off your laptop, you will be offline in IRC.
Even if you run your IRC client continuously on your client, if your phone goes out of coverage or your phone suspends your IRC client, you will be offline.)
However, nowadays you can create channels with history.

(Note that many IRC channels still do not have history.
Channels without history are frequently confusing for new users, because most chat systems have history.
Heavy IRC users are either used to having no history [this might seem surprising, but for some this is even a benefit] or have means to be permanently connected to IRC.
However, users new to IRC might join a channel, post a question and go offline without anyone having a chance to see their message and reply.
Then, unless people remember to answer when they are back, or other means are used, answers will not be visible to the person who asked.)

Some advantages of IRC are:

* You can use IRC without creating an account.
  This can be especially useful for providing a general contact mechanism.
  You can create links that will ask for a nickname, and place you into a channel without any additional steps.

* IRC is a very simple protocol with more than 30 years of history.
  This means that many developers have invested significant efforts in creating powerful IRC clients and tools (such as bots).
  And lately, many easy IRC clients are available.
  This means that IRC can scale from simple setups that require little effort to use, to powerful setups that can provide interesting features.
  (If you are used to plain communication clients, you might be surprised at how valuable some features can be.)

Some drawbacks of IRC are:

* IRC does not have end-to-end encryption, and thus IRC administrators can read every conversation.
  This is not a huge problem for public or semi-public channels, but it limits IRC for many scenarios.

* IRC requires more effort from administrators to provide a good experience to entry-level users, control spam, and others.
  (An important point is that although integration with audio/video conferencing is possible, it requires more effort and provides a lesser experience.)

* IRC is mostly text-based.
  Although many IRC clients can display images and GIFs, communicating with images and GIFs is harder on IRC.
  (And IRC also does not have integrated audio/video conferencing.)

* IRC does not have reactions yet.

* Push notifications are not common yet.
  Although it is possible to receive instant notifications when you are mentioned or receive a private message, this is frequently difficult.
  In general, IRC on mobile phones is not as evolved as on desktop computers.

#### Matrix

Matrix is a more modern chat protocol that addresses some of the drawbacks of IRC:

* Matrix has end-to-end encryption, so conversations between users are private to Matrix administrators.

* Matrix requires less effort from *channel* administrators.
  (But running a Matrix server requires significant resources.
  However, there are public Matrix servers and managed services.
  Thanks to end-to-end encryption, using a public Matrix server is an interesting option.)

* Matrix has good support for audio/video conferencing, images and GIFs, reactions, push notifications, and phone usage.

But also some disadvantages compared to IRC:

* Users need to create accounts.

* Using end-to-end encryption makes some usage harder.
  (Although end-to-end encryption is optional.)

* There are fewer clients and tools, and generally they are more complex, more resource intensive, and less featureful.
  (And not all clients support all features.)

#### XMPP

XMPP is younger than IRC, but older than Matrix.
Compared to Matrix:

* End-to-end encryption and audio/video conferencing is possible with XMPP, but in practice it can be difficult to access these features.

* There's more XMPP clients than Matrix clients, but it is also hard to find clients that support all the features you need on different platforms.

For some scenarios, if you find the right combination of XMPP server and clients, XMPP can be a great option.

Historically, XMPP was not well-suited to mobile usage.
Nowadays, mobile usage is better, but finding the right clients to use is still a challenge.

#### Other instant messaging alternatives to consider

* Zulip: Zulip offers instant messaging, but has some characteristics from forums.
  (For example, Zulip uses threads with subjects.)

* Mattermost, Rocketchat are designed for communication within organizations.

And lastly, because all the technologies mentioned in this text allow integrations, there are bridges to join different technologies.

For example, IRC channels can be bridged to Matrix rooms.

Although bridges are not ideal, in some cases you can use them to make one channel available over different technologies, which might address the limitations of specific technologies.

### Asynchronous messaging

Although my perception is that most communities nowadays communicate over instant messaging, many communities use successfully more asynchronous communication channels.
In some cases, providing both instant messaging and an asynchronous channel can also work well.

#### Mailing lists

Mailing lists (and their sibling, newsgroups) are older than IRC.
Although mailing lists are far less popular than in the past, many communities still use mailing lists.

Mailing lists have several advantages:

* Having an email address is nearly a necessity for all Internet users.
  Mailing lists often require no user account other than an existing email address.

* In a way, email and mailing lists share many similarities with IRC.
  Although most people are users of just a few mail services and clients, there is a wide variety of services and clients.
  Email power features are somewhat forgotten, but they still exist and mail clients can have very convenient features.

* Most mailing list have good ways to browse and search past messages.
  Email discussions are more naturally searchable, thanks to their slower pace and thread organization.

However, they also have many advantages:

* As people no longer use email to communicate, going back to email can cause significant friction.

* Finding a good mailing list service is difficult.
  (And hosting your own is also more difficult than hosting other services.)

In my opinion, mailing lists are good, but they have become foreign to most people.

#### Web forums

Forums used to be very popular.

Compared to mailing lists:

* Forums require creating an account.

* Forums do not have multiple clients, although forum software has also evolved for a long time, and many forums have great features.

* Forums are also a bit out of style, but they are more popular and familiar to most than mailing lists.

* Finding a forum service or hosting one is simpler than email.

### Other possibilities

Social networks tend to be slightly different communication channels than instant messaging or asynchronous messaging.
Alternatives to social networks also exist.
However, in my opinion, social network-style communication is not optimal for "communities" in most cases.
Still, you might want to explore alternatives.
The Fediverse (or ActivityPub) has many different varieties of communication channels that might suit your needs.
