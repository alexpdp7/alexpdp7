# ledger

[ledger](https://ledger-cli.org/) is a double-entry accounting system based on a text file format.
The [Plain text accounting](https://plaintextaccounting.org/) website lists more software based on the ideas.

This document contains notes about how I use ledger.

## Configuration

My `~/.ledgerrc` just contains:

```
--file ~/Nextcloud/finances.ledger
--date-format %Y-%m-%d
```

I store my ledger file in my Nextcloud instance, so Nextcloud synchronizes across my computers.

Other than that, I just configure the YYYY-MM-DD date format.

## Registering transactions

I try to register most transactions the first moment I'm at my keyboard.

I do so manually without automations.

In 2025, I registered over 800 transactions, and I didn't feel it was tedious.

My main text editor is Emacs, so I use [ledger-mode](https://github.com/ledger/ledger-mode/).
ledger-mode:

* Automatically adds indentation and alignment.
* Autocompletion of accounts and payees.

To register transactions, I run:

```
ledger reg bankname:accountname
```

Then, I correlate with the running total that my bank websites show to find the first missing transaction and go on from there.

I have a monthly calendar reminder to catch up on all accounts.
In this session, I also update my pension plan accounts with their current value.

## Tagging

### `who`

I use the `who` tag because I want to make reports based on specific beings.
For example, I want to query quickly costs associated to the cat.

In 2026, I think I will have some accounts like `Expenses:Supermarket:My Name` too, so I'm experimenting with the following snippet:

```
= My Name
    ; who: myname
```

This seems to automatically add the tag to related accounts.
