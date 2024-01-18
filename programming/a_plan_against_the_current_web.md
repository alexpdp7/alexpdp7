# A plan against the current web

Browsers are controlled by Google, and to a lesser extent, Apple.
We have arrived to this because browsers have become excessively complex, so that even Microsoft has decided that it's better to be subject to the whims of Google, than to maintain one.
This complexity is derived from using the web for delivering applications, where its initial purpose was browsing content.

## Part I: Make content websites simple again

Nowadays you cannot use "simple" browsers like Lynx, Dillo, etc. conveniently to browse content.
You will run into pages which are not usable without a fast and sophisticated Javascript engine, or without a fully-featured web renderer.
The most common example are websites that are just a blank page when viewed with a browser with Javascript disabled.

If users could browse content using simple browsers, then the power of Chrome would decrease.
Also, content sites which are usable with simple browsers in my opinion have a nicer user experience: faster, lighter, more accessible, and more flexible.

This is in part impossible nowadays due to the popularity of Javascript-first websites developed as SPAs, and the fall from popularity of progressive enhancement.
But you can do your part: ensure that you test your content website using a low-powered browser.
Not Chrome, not Firefox, not Safari; use Dillo, Lynx, etc. to verify that your website works.

This will not move the needle, but your normal users (those who use Chrome) will benefit too.

### Diversion: Gemini

Yes, I cannot avoid talking about Gemini.
Gemini is this idea driven to the extreme.
It's an alternative to web browsers and HTML which is so simple that you can implement a Gemini browser in a weekend.
Of course, it is so extreme that it cannot be a mainstream success.
But it is an insightful study about these ideas that can be analyzed to learn.

## Part II: Application distribution sucks

We use so many web applications nowadays because there are no alternative platforms to distribute applications with the same reach and convenience.

As a way to start this discussion, let's propose making Flatpak applications work on Windows and macOS, and make them installable and executable from a web link (like Java Web Start or ClickOnce from Microsoft).
And additionally, let's produce "starter packs" for as many programming languages as possible, so creating these applications is "easy".

Besides all the implementation work, what would be the downsides to this?
I believe that this would offer better performance than webapps (Flatpak applications on Linux are consistently faster than web apps and Electron apps), and Flatpak apps can already be implemented using many programming languages (webapps are halfway there through WASM, but not there yet).
