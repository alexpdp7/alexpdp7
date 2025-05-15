# My blog

The blog is available via [HTTP/HTML](https://alex.corcoles.net/) and [Gemini](gemini://alex.corcoles.net/).
Gemini is a lightweight protocol similar to Gopher, or HTML with no Javascript nor CSS.
I use [my own framework](https://github.com/alexpdp7/bicephalus) to have a single process serve HTTP and Gemini.

I deploy the blog to Kubernetes as a single container that uses `uv run --with git+https://...` to install and run on the fly, without building container images.
