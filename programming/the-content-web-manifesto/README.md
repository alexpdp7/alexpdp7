# The content web manifesto

These are my recommendations for creating "content" websites.
In a content website visitors mostly read content.
Some example content websites are Wikipedia, news websites, and blogs.

Also see [further notes](NOTES.org).

## General guidelines

### Test your website with a terminal browser without JavaScript like w3m, lynx, or elinks

If your website is usable with one of those browsers, then:

* Your website does not require JavaScript to load.
  This automatically addresses most annoyances with content websites.
  Websites that do not require JavaScript tend to require less resources, making them faster and lighter.

* Your website does not rely on non-text content.
  Text content is uniquely flexible, it is frequently the most amenable media to being processed by the following systems and processes:

  * Text-to-speech systems
  * Translation (both human and automatic)
  * Edition (making changes to text content)
  * Quoting/embedding (readers can copy parts of your text to cite or promote your content)

  Images, audio, video or other interactive media might be required to convey the message of your content.
  Therefore, the content web manifesto does not forbid their use.
  However, non-text content should always be accompanied by at least a text description of the content, and ideally, an alternate text version of the content.

* Your website will work with user styling.
  Providing a visual style via CSS and others is fine, but users should be able to read your content with *their* choice of font, text size, color, and others.
  This is important for accessibility, but also for everyone's comfort.

And more importantly, this weakens browser monopolies controlling the web.
Not even massive companies like Microsoft dare to maintain a browser engine, leaving the web subject to the power of the very few browser vendors in existence.
But if your web content can be read under a terminal browser without Javascript, then your content is automatically accessible by a massive amount of browsers, including very simple ones.

(Alternatively, use [the Gemini protocol](https://geminiprotocol.net/).)

### Provide granular URLs

When providing a significant amount of content, make sure readers can link to specific content of interest.

This can be achieved by:

* Splitting your content in different pages
* Providing HTML headers with anchors

### Date content

Always make initial publication and edition dates available.
