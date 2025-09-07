# Migadu

<https://migadu.com/>

## A strategy to handle email addresses

Email addresses can be "vanity" or "non-vanity".
Vanity email addresses are meant to be public and memorable, for example `firstname@lastname.tld`.

Set up any vanity domains that you want, and a non-vanity domain.

### Non-vanity email addresses

In the non-vanity domain, you create the `{me}{code}@nonvanity.tld` mailbox.

`{me}` identifies you, you can have multiple users with different `{me}` identifiers in a single non-vanity domain.

This strategy uses `{code}` to obfuscate email addresses.
When you use `{code}` in an email address, you should be able to identify if the `{code}` is valid or not.

For example, you could use a four-digit `{code}` and store what code you have used for each address.
If you use `x3452` and store this code, when you receive an email that does not match, such as `x3453`, you know the code is incorrect.

Alternatively, you can use hashing so that you do not have to store all codes.

No one except you should know about `{me}{code}@nonvanity.tld`.

Then you create a pattern rewrite from `{me}.*@nonvanity.tld` to `{me}{code}@nonvanity.tld`.

When you need a non-vanity email address, you create a new `{me}.{entity}{code}@nonvanity.tld`, where `{entity}` is the entity that communicates with this email address and `{code}` is a **new** code.

Mails received at `{me}@nonvanity.tld` are incorrect.
Mails received without the correct code are incorrect.

### Vanity email addresses

Create any needed `{id}@vanity.tld` addresses.

Different from non-vanity email addresses, vanity email addresses can be guessed and you cannot identify invalid email.

See [email forwarding via IMAP](../linux/misc.md#email-forwarding-via-imap) for notes about forwarding between different email servers.

### TODO Filing

Because each vanity email address and entity has a different email address, you can file emails automatically into folders if wanted.

## Migrating email from Gmail

```
imapsync --user1 xxx@gmail.com -passfile1 gmailpass --user2 a@a.com --host2 imap.a.com --passfile2 pass --gmail1
```

### Preventing issues with multiple tags

An email message can have multiple "tags" in Gmail that correspond to IMAP folders.
If you have messages with multiple tags, then the migration will duplicate messages in multiple folders or file mails to one folder at "random".

imapsync has features to control this, and avoid problems with the "all mail" and "sent mail" Gmail folders, but for further control, you can refile emails to have a single tag.

I have an mbsync replica of my Gmail account for backup purposes.
This replica can be used to find messages with multiple tags:

```
find . -path './\[Gmail\]/All Mail' -prune -o -not -name index -type f -exec grep -H ^Message-ID: {} \; >index
```

Produces one file with lines:

```
/.../cur/f:Message-ID:...
```

```
#!/usr/bin/env python3

import pathlib
ms = pathlib.Path("index").read_text().splitlines()

import collections
idx = collections.defaultdict(set)

for m in ms:
    path, _, id = m.rsplit(":", 2)
    f = "/".join(pathlib.Path(path).parts[:-2])
    idx[id].add((path, f))

for id, vs in idx.items():
    fs = sorted(set([f for (_path, f) in vs]))
    if len(fs) > 1:
        print(fs)
```

```
./idx.py | sort | uniq
```

Clear up multiple tags in Gmail to prevent duplicates.


## Notes

* Aliases do *not* have plus addressing, use a "pattern rewrite" instead.
* New domains come with 'junk messages with word "SPAM" in subject (case insensitive)' on by default; go to domain, spam filtering, aggresiveness to disable.
