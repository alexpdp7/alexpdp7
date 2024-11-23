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

## Creating a Spring Boot application

In the command palette (ctrl+shift+p), search for and execute "Java: Create Java Project...", select "Spring Boot".
Install the Initializr plugin if prompted, you might need to restart the Java project creation wizard.
Select "Maven Project", select the highest Spring version that is not a snapshot, the Java language.

Enter a group id. A group should be a domain in reverse order. The default of "com.example" is OK.

Enter an artifact id. This should be a single keyword. The default of "demo" is OK.

Select the jar packaging type.

Select the matching Java 21 version.

Add only the Spring Web dependency.

When choosing the folder for the project, Visual Studio Code creates a further folder named like the artifact id you enter in a previous step.
(So do not create a directory with your application name.)

Choose File, Open Folder in the Visual Studio Code menu, then select the directory that the previous step created named like the artifact id, and "trust the authors".

Navigate to the `src/main/java/com/example/demo/DemoApplication.java" file (the path varies depending on the group id and artifact id).
Right click on the file and select "Run Java".
Visual Studio Code displays a terminal.
After a few moments, a message reads that the application started.

Open a browser and navigate to <http://localhost:8080>.
The browser displays an error because the application wizard creates an empty application.

## Advice for people involved in developing the software used in this tutorial

### The Eddy Pop_OS! tool should allow interacting with debconf

The Visual Studio Code .deb has a debconf prompt to add Microsoft package repositories.
This locks Eddy.

### The Pop!_Shop should not recommend the Visual Studio Code Flatpak

Flatpaks are great most for applications, except for development tools.
Using the Visual Studio Code Flatpak makes configuring development tools harder.

### Visual Studio should not prompt users to download a .tar.gz archive of Java without further instructions

On Linux distributions where the distribution package manager provides a reasonably recent version of Java, users can install Java through the package manager more easily.
