# A Java tutorial

This tutorial walks through creating a blank Spring Boot application on Pop!_OS 22.04

## Set up

Open a terminal and run:

```
$ sudo apt install openjdk-21-jdk code
```

and follow the prompts.

(You can install both packages from the Pop!_Shop application.
However, when installing Visual Studio Code, Pop!_Shop defaults to the Flatpak version of the program that is more troublesome than the .deb package.
Choosing the correct software is easier from the terminal.)

Open Visual Studio Code from "Show Applications".

Follow the "Walkthrough: Setup VS Code", but in the "Rich support for all your languages" step, click "Browse Language Extensions" and install "Extension Pack for Java".
Do not install a new JDK; you installed one in a previous step.

## Creating a Spring Boot application

In the command palette (ctrl+shift+p), search for and execute "Java: Create Java Project...".

Select "Spring Boot".

Install the Initializr plugin if prompted, you might need to restart the Java project creation wizard.

Select "Maven Project", select the highest Spring version that is not a snapshot.

Select the Java language.

Enter a group id. A group should be a domain in reverse order. The default of "com.example" is OK.

Enter an artifact id. This should be a single keyword. The default of "demo" is OK.

Select the jar packaging type.

Select the Java 21 version matching the JDK you installed in a previous step.

Add only the Spring Web dependency.

When choosing the folder for the project, Visual Studio Code creates a further folder named like the artifact id you enter in a previous step.
(So do not create a directory with your application name.)

Choose File, Open Folder in the Visual Studio Code menu, then select the directory that the previous step created named like the artifact id.

"Trust the authors".

Navigate to the `src/main/java/com/example/demo/DemoApplication.java" file (the path varies depending on the group id and artifact id).

Right click on the file and select "Run Java".
If the "Run Java" option is not present, then you might not have "trusted the authors"; in this case, Open Folder again.

Visual Studio Code displays a terminal.
After a few moments, the terminal displays a message about the application having started.

Open a browser and navigate to <http://localhost:8080>.
The browser displays an error because the application wizard creates an empty application.

## Advice for people involved in developing the software used in this tutorial

### The Eddy Pop_OS! tool should allow interacting with debconf

When using the Visual Studio Code .deb from Microsoft and not the .deb from Pop!_OS, installing the package from the browser fails.
The Visual Studio Code .deb has a debconf prompt to add Microsoft package repositories.
This locks Eddy.

This is likely covered by these issues:

* https://github.com/donadigo/eddy/issues/105
* https://github.com/donadigo/eddy/issues/107

### The Pop!_Shop should not default to the Visual Studio Code Flatpak

Flatpaks are great most for applications, except for development tools.
Using the Visual Studio Code Flatpak makes configuring development tools harder.

### Visual Studio Code should not prompt users to download a .tar.gz archive of Java without further instructions

On Linux distributions where the distribution package manager provides a reasonably recent version of Java, users can install Java through the package manager more easily.
