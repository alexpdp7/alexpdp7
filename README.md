# gemini_blog

This repo contains my personal blog, hosted on Gemini.
The blog is basically a static Gemini capsule.

This repo also contains scripts I used to migrate my Wordpress blog to Gemini.

## Running the blog

The `build.py` script renders a static blog using `.gmi` files in a `content` directory.
The static blog capsule goes to the `build/gmi` directory:

```
$ ./build.py
```

To preview the site locally, you can use https://github.com/michael-lazar/jetforce, that serves static `.gmi` files and can create automatic certificates.
Note that Jetforce does not fully support Python 3.6.
You can use `pipx` to install Jetforce:

```
$ pipx install jetforce
```

Serve your built blog:

```
$ jetforce --dir build/gmi/ --host 0.0.0.0
```

To preview, use a client like https://github.com/makeworld-the-better-one/amfora :

```
$ amfora localhost:1965
```

To run the blog in production, I am currently using https://github.com/mbrubeck/agate in a `screen` session:

```
$ ./agate --content build/gmi/
```

You will need `cert.pem` and `key.rsa` in the same directory for the proper host, as Gemini mandates the use of TLS.

I use `xinetd` from a host with a public IP to proxy to the host running `agate`:

```
service gemini
{
  disable = no
  type = UNLISTED
  socket_type = stream
  protocol = tcp
  wait = no
  redirect = $HOST_RUNNING_AGATE 1965
  bind = 0.0.0.0
  port = 1965
  user = nobody
}
```

To create an HTML proxy of the capsule:

```
$ docker build -t kineto -f Dockerfile.proxy .
$ docker run --rm -p 5000:5000 kineto
```

Or to preview the HTML rendering of a local running instance:

```
$ docker run --rm --network host kineto /app/kineto gemini://localhost
```

To generate an RSS feed:

```
$ ( cd gemini2rss/ ; poetry run python gemini2rss.py https://alex.corcoles.net 10 "El blog es mío" "https://alex.corcoles.net" Alex alex@corcoles.net ; ) >/tmp/feed.rss
```

## Migrating a Wordpress blog to Gemini

Note: only posts are migrated.
Notably, images, categories, tags, comments, and pages are not migrated.

First, create an export from the Wordpress admin interface.
This will generate an XML file containing all posts and comments.

Use https://github.com/lonekorean/wordpress-export-to-markdown to generate Markdown files out of the blog's posts.
This tool is the simplest tool I could find that can convert the Wordpress export into something simpler to convert to Gemini.

To run the tool, you need a most recent version of Node.js than what my current workstation has.
If you cannot run `npx wordpress-export-to-markdown`, then you can use https://github.com/alexpdp7/cmdocker to run a newer version of Node.js using Docker:

```
$ cmdocker add-wrapper node_15 /bin/bash node:15
$ node_15
```

Run `wordpress-export-to-markdown` to convert your Wordpress archive into Markdown files in a directory named `md`:

```
$ npx wordpress-export-to-markdown --input $YOUR_WORDPRESS_XML \
    --year-folders true \
    --month-folders true \
    --post-folders=false \
    --wizard false \
    --output md
```

Use `md2gemini` to convert the Markdown files into `.gmi` files.
I use https://github.com/pipxproject/pipx to install Python tools in isolated user virtualenvs:

```
$ pipx install md2gemini
```

Perform the conversion:

```
$ find md -name '*.md' -execdir md2gemini -l at-end -w '{}' ';' 
$ find md -name "*.md" -delete
```

The converted `.gmi` files need some fixing, as the title, posted date, categories are not in a easy-to-use format.
The `fix.py` script takes all `.gmi` files in the `md` directory, "fixes" them into a new `content` directory:

```
$ ./fix.py
```
