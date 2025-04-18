# Containers might not be the right answer

Containers are everywhere, and I feel today they are the default answer to many problems for many people.

[Although the author of one of the handiest quotes does not want people to use it](https://www.jwz.org/blog/2014/05/so-this-happened/), I think that quote adequately describes the situation.

Containers are a good example of an “easy but not simple” technique (see [the "Simple Made Easy" - Rich Hickey (2011) talk](https://www.youtube.com/watch?v=SxdOUGdseq4)).

Containers are easy because they automate getting arbitrary "isolated" Linux environments and running processes on them.
Additionally, you can find container images for mostly everything on the Internet.
For this reason, it is very easy to run much software using containers, often with a single command.

However, containers are easy, but not simple.
Containers combine many different techniques to achieve their ease, and thus, frequently you hit problems derived from any of the techniques containers use.

However, Docker popularized many good ideas, both directly related to containerization and general ideas!
There are still places where containers are the right answer.

## Reasons not to use containers

### Containers are Linux

The fact that containers are a Linux technology is the most common point of complexity.

One result of this is that using containers on any operating system that is not Linux, such as Windows or macOS, requires a Linux virtual machine.

This has some accidental problems, like increased memory and CPU usage, and derived inconveniences like decreased battery life and fan noise.

But the main issue is that adding this VM makes things more complex, mostly because you are adding networking to the mix, and some container features are not available or work worse, like bind mounts.

Most issues can be worked around, but this requires more effort, or at least, more knowledge overhead of knowing how to avoid these issues.

(On top of that, people who develop processes using Linux are not exposed to these issues, so they are likely to introduce issues without realizing what works on their Linux workstation does not work on macOS or Windows workstations.)

### Container images are big and expensive

Optimizing the size of container images can require significant effort.
Popular public images are often optimized for size, but even with optimized images, storing and moving container images frequently requires much more bandwidth and storage than the alternatives.

There are free ways to host private container images, but they are frequently limited in size, bandwidth, or both.
You can easily run into Docker Hub limits, GitHub only provides 2gb of storage, etc.

Building container images also can require significant resources.

### Containers require specialized knowledge

Using containers frequently requires learning quite a few things specific about containers.

* `Containerfile` design is not obvious.
  Some questions, like `ADD` and `COPY`, or `CMD` and `ENTRYPOINT` are difficult and not well documented.

* Container design is not obvious.
  Docker popularized "application containers", a fuzzy concept that is related to "single process containers", 12 factor architecture, and a few other ideas.
  Solving your problem might require good knowledge of application container design and use.

* Container tools are complex, because containerization is difficult.
  Likely you need to know some intricate details of how Linux file permissions and users work, for example.

Not using containers can mean avoiding having to think about these things, and being able to use the time you save to actually solve your problem.

### Docker is not so good, targeting multiple container engines is not trivial

Docker was the first popular container engine.
Docker was a revolution and invented or popularized many great ideas.
However, knowledge about containers was not well established when Docker was invented, and since then, better ways of doing many things have been discovered.

Other tools such as Podman or Fedora Toolbx and adjacent tools such as Distrobox have introduced many improvements respect Docker, while still reusing and being compatible with many Docker concepts.

However, creating processes and tools across these different tools can be difficult, despite their apparent compatibility.

### In some scenarios, containers do not add much

Mainly after the rise of the Go programming language, distributing binaries has become easier.
Distributing binaries on Windows and macOS has always been simpler than distributing binaries on Linux.

However, nowadays many programming languages can create binaries that can be downloaded and executed on most Linux distributions.

One of the main benefits of Docker has been ease of distribution of software, but nowadays this is easy to achieve through binaries.

### Beware container images

Much software is distributed nowadays as container images.
The abundance of container images means that learning how to use containers helps you run a wide variety of software distributed as a container image.

However, many container images are not of great quality, nor are adequately updated.

In some cases, you can find software that has a container image, but where the container image is not of sufficiently good quality and can cause issues down the road.

## Reasons to use containers

### Containers still provide isolation easily

By default, running a container does not alter the system that runs the container significantly.

This is a huge advantage, and in many cases, more difficult to accomplish without containers.

### Making things work across different operating systems is not trivial either

Some decisions in software, like programming language or dependency choices, influence greatly how easy running the software on different operating systems is.

In many cases, making something run in a specific distribution and packaging as a container can be the most resource-efficient way to distribute software that works across Windows, macOS, and most Linux distributions.

Finding the right combination that makes software portable can require significant effort, or even be unviable.

### Some container-related software has good and unique ideas

For example, the controversial Kubernetes still provides a distributed standardized operating system that can be managed in a declarative way.
This is a powerful concept, and still the preferred way to package software for Kubernetes depends on container images.

## What to use instead of container images

* Binaries
* "Portable-friendly" development tools such as Go, `uv`, or Cargo.
