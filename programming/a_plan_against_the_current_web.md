# A plan against the current web

Browsers are controlled by Google, and to a lesser extent, Apple.
We have arrived to this because browsers have become excessively complex, so that even Microsoft has decided that it's better to be subject to the whims of Google, than to maintain one.
This complexity is derived from using the web for delivering applications, where its initial purpose was browsing content.

## Part I: Make content websites simple again

See [the content web manifesto](the-content-web-manifesto).

## Part II: Application distribution sucks

We use so many web applications nowadays because there are no alternative platforms to distribute applications with the same reach and convenience.

As a way to start this discussion, let's propose making Flatpak applications work on Windows and macOS, and make them installable and executable from a web link (like Java Web Start or ClickOnce from Microsoft).
And additionally, let's produce "starter packs" for as many programming languages as possible, so creating these applications is "easy".

Besides all the implementation work, what would be the downsides to this?
I believe that this would offer better performance than webapps (Flatpak applications on Linux are consistently faster than web apps and Electron apps), and Flatpak apps can already be implemented using many programming languages (webapps are halfway there through WASM, but not there yet).
