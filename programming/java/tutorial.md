# A Java tutorial

This tutorial walks through creating a blank Spring Boot application on Pop!_OS 22.04

## Set up

### Java

Open a terminal and run:

```
$ sudo apt install openjdk-21-jdk
```

and follow the prompts.

### Visual Studio Code

Open a web browser and navigate to <https://code.visualstudio.com>.

Click on the .deb download, but do not open the downloaded file in your browser.

Open a terminal and type:

```
sudo dpkg -i Downloads/
```

, then press the tab key to complete the file name of the downloaded .deb package.
Run the command and accept the default options.

Open Visual Studio Code from "Show Applications".

Follow the "Walkthrough: Setup VS Code", but in the "Rich support for all your languages" step, click "Browse Language Extensions" and install "Extension Pack for Java".
Do not install a new JDK; you installed one in a previous step.

## Advice for people involved in developing the software used in this tutorial

### The Eddy Pop_OS! tool should allow interacting with debconf

The Visual Studio Code .deb has a debconf prompt to add Microsoft package repositories.
This locks Eddy.

### The Pop!_Shop should not recommend the Visual Studio Code Flatpak

Flatpaks are great most for applications, except for development tools.
Using the Visual Studio Code Flatpak makes configuring development tools harder.
