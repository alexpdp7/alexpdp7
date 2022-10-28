# A brief explanation of Python dependency management

Most programs can use third-party libraries to implement parts of their functionality without implementing everything from scratch.

pip is the recommended package installer for Python.
Python installers include pip, although pip is a component that can be installed separately from Python.
Some Linux distributions separate pip from the main Python package (for example, Debian has a `python3` package and a `python3-pip` package), but a Python install without `pip` is not really fully functional for many purposes.

pip fetches Python packages from diverse sources and adds them to a Python installation.
Python packages can specify other packages as dependencies, so when pip installs a package, it also installs the required dependency chain.

The traditional mechanism for packages to specify dependencies is Setuptools and other closely related projects.

## About Setuptools

Setuptools is a build and distribution system based on the distutils module that was part of the base Python library.

Package metadata in Setuptools can be defined in many different ways, such as a `setup.py` file, a `setup.cfg` file, or a `pyproject.toml` file.
In these files, you list the dependencies for your package, specifying the name of the package and constraints.

Constraints define which version of a dependency you want to use.
The constraint does not be an exact version, it can also be a range of versions, or a constraint such as "lower than version n".

(Constraints additionally can specify other restrictions, such as requiring different versions for different Python versions, and other interesting possibilities.)

When using setuptools and dependencies using setuptools, you quickly can run into problems.

If packages specify exact dependency versions, then there are many changes of packages having conflicting requirements.

If packages do not specify exact dependency versions, then the actual versions that pip installs can vary as new versions of packages are released.
This can lead to bugs, because code might not work properly when using newer versions of dependencies.

## Version locking and `requirements.txt`

There is a dependency-management approach that can be very effective in many cases.

This approach involves differentiating between "applications" and "libraries".

Libraries are Python packages meant to be used as a dependency by other Python code.
Applications are Python code that may use other libraries as dependencies, but which no other Python code depends on.

### Specifying dependencies for libraries

Libraries specify coarse but safe dependency requirements.

Suppose that we are developing the foo library.
The foo library depends on the bar library.
The bar library uses a versioning scheme similar to semantic versioning.
When we develop the foo library, we use version 1.2.3 of the bar library.

Then, we specify that the foo library depends on the bar library, with a version constraint like `>=1.2.3, <1.3`.
This version constraint lets the library to be used with the 1.2.4 version, which is likely compatible with the code in the foo library, and even introduce valuable bug fixes.
However, the 1.3.0 version of the bar library would not be a valid dependency.
This is probably a good idea; the 1.3.0 may contain changes that the foo code is incompatible with.
(When we later create new versions of the foo library, we may want to consider depending on newer versions of the bar library, and possibly update the code so it continues working correctly.)

This helps reduce conflicts.
As libraries specify coarse dependencies, the chances of two libraries having incompatible requirements is lower.
However, specifying coarse dependencies probably requires more testing to ensure that if different dependency versions are installed, the library works correctly.

### Specifying dependencies for applications

Applications specify exact dependency requirements.

While libraries are not usually run on their own, applications are executed directly by end users.
If a library does not work well, then you can temporarily go back to an older version or apply other fixes.
But if an application does not work correctly, you have worse problems.

If you specify exact dependency versions for an application, users of the application will always use a single combination of dependencies, which makes making things robust easy.

A popular approach is for applications to specify Setuptools requirements with coarse versioning (just like libraries do), but to provide a list of the specific versions used for development and deployment.
To create this list of dependencies, you can install your application using pip or some other mechanism, then extract a list of the dependency versions that were installed and store it in a file.
For example, you can do this by executing:

```
$ pip install .  # executed from the root of the application source code
$ pip freeze >requirements.txt
```

Later on, if you install the application using the following command:

```
$ pip install -r requirements.txt
```

Then you will always install the same set of dependencies, preventing issues by updated dependencies.

Note: pip and other package installers do *not* use `requirements.txt` or any other similar file outside the `setup.cfg` file and the other files defined in Setuptools.
If you do not install your application explicitly using `pip install -r requirements.txt`, you will probably install a different set of dependencies.

## Beyond version locking

Following the approach above can be enough to use dependencies correctly.

However, maintaining the Setuptools version dependencies and `requirements.txt` is straightforward, but tedious.
Also, this approach of dependency management is not obvious, and may not be easy to get right completely.

For these reasons, several projects have appeared that implement approaches similar to the one described above, but more automatic and prescriptive.
These projects often manage automatically a file equivalent to `requirements.txt`, while the developer only specifies coarse dependencies for applications.

Thanks to some improvements in the Python ecosystem, pip can nowadays install dependencies using many different packaging tools correctly.

These projects can also offer some other improvements, so I would encourage Python developers to investigate them and try them out.
However, also note that following a correct approach, Setuptools and manual version locking are perfectly valid ways to manage Python code dependencies.
