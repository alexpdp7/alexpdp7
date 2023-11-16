# My blog

The blog is available via [HTTP/HTML](https://alex.corcoles.net/) and [Gemini](gemini://alex.corcoles.net/).
Gemini is a lightweight protocol similar to Gopher, or HTML with no Javascript nor CSS.
I use [my own framework](https://github.com/alexpdp7/bicephalus) to have a single process serve HTTP and Gemini.

I use [a Rust script](https://github.com/alexpdp7/alexpdp7/blob/master/blog/build.rs) to build a container image of my blog, using my [paars](https://github.com/alexpdp7/paars) project to automate some "Platform as a Service"-like tasks.
The container image is deployed to Kubernetes.
