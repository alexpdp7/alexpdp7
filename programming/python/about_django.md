# About Django

Without more context, one of the technologies I recommend to everyone is Django.

Django is a Python web framework with "batteries included".

Web frameworks can provide more or less tools to write applications.
Typically, frameworks that provide fewer tools are more flexible and give developers more freedom to develop their applications in the best possible way.
Similarly, frameworks that provide more tools tend to guide you towards a specific way to writing applications, and typically, require more work if you want to deviate.

In my opinion, many applications you might need to develop are very similar and have similar issues, and solving them ad-hoc for each project is a waste.
Therefore, I lean towards using frameworks that provide more batteries in most cases.

(Certainly, there are projects that clearly need special approaches, or which deviate enough from any generic web framework.)

In fact, most of the complaints described in this document are caused by Django having too few batteries, not too many!

## The Django admin

Besides including more batteries than most other frameworks, and being in general a well-engineered framework in my opinion, Django includes the admin.

The admin is a declarative way to build administrative sites where some users edit data stored in the application database.

Many similar tools exist, but I have not found any other tool that can do so much.

* The Django admin handles multi-table relationships very well, including picking foreign key targets and editing related table data.
  For example, if a person entity has a "parent" related foreign key relationship, the Django admin provides a search functionality to pick a person's parent.
  If the person entity has a list of children, the Django admin provides a way to add and edit children from the person form.

* The Django admin has a simple, but useful for many scenarios permissions functionality, where editing certain entities is restricted to groups of users.

The Django admin is frequently a big boost during the early development of database-backed applications, and sometimes I can provide value during a big part of the life of an application.

Additionally, traditionally when working with frameworks without an equivalent facility, the friction of adding an interface to edit a piece of data can be large.
Developers pressed for time might opt to hardcode the data in the source code of the application, requiring code changes to modify certain behaviors of the application.
When the friction to add a user interface to edit such data is low, developers can configure the admin to let those users edit the data directly without going through the developers.

## Django problems

However, there are still many common issues for which batteries could exist, but that Django does not provide.

### Django has no support or documentation about packaging Django projects

Most Django projects have dependencies besides Django.
In order to develop and deploy Django applications, you likely must install other dependencies.
Django does not include documentation nor support to do this.

Many different approaches and tools exist to manage Python project dependencies.
Understandably, endorsing one particular approach in Django could be controversial.
So Django leaves the choice of approach up to users.
Additionally, Django adds a few difficulties in Python project management, and users must figure out how to handle Django projects in their chosen approach.

Several initiatives have tried to tackle this problem, notably:

* https://github.com/radiac/nanodjango

### Django settings are a partial solution

Django provides settings to manage the configuration for a Django project.
You implement Django settings by writing a Python module.

For example, the default Django template includes the following snippet to configure the database connection:

```
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}
```

Besides assigning a setting directly like in the preceding snippet, you can use Python code to assign settings.

This allows you to tackle many common issues, such as setting up a different database connection for development and production, while keeping the production database credentials away from the source code repository.
There are many similar issues that you must tackle in nearly all projects.

Several initiatives tackle some of those issues:

* https://github.com/jazzband/dj-database-url provides a way to configure the database connection through an environment variable.

### Django does not explain a development database workflow

Django provides migrations to handle schema changes.
Migrations work well and are a valid solution to handle schema changes in production.

However, while developing a Django application, you frequently need to make many temporary changes to the data definition until you find the right data definition.

In my opinion, if you follow the Django documentation, then you might end up using migrations for those development schema changes.
This is awkward and problematic, and there are procedures to develop database changes that work better.

I would like a command that recreates your database, applying unmigrated model changes.
This command could also have hooks to load sample data.
(Likely, Python code and not fixtures.)

### Django only tackles database-based, server-side-rendered, non highly interactive web applications

While certainly a huge amount of applications:

* Revolve around data stored in a relational database
* Are better implemented as server-side rendering applications
* Do not require very complex or real-time interactions

There are certainly many applications that do not fit this mold.

In my opinion, focusing on database-based applications is a good decision.
Many Django features (like the admin) revolve around the database, and a framework oriented to other applications likely should be very different.

However, more and more applications break the limits of server-side rendering, and while you can build such applications with Django, you need a lot of effort or finding additional libraries to use.

For example:

* [Django REST framework](https://www.django-rest-framework.org/) provides a layer to provide REST APIs on top of the Django ORM.
* Projects exist to add support for Django for front end frameworks such as [htmx](https://htmx.org/) or [Hotwire](https://hotwired.dev/).
  These frameworks are an intermediate step between traditional server-side-rendered applications and JavaScript front ends, enabling most of the benefits of JavaScript front ends within the traditional server-side rendering approach.

Additionally, providing an API is also useful beyond JavaScript front ends.
APIs are necessary for other purposes, such as implementing mobile apps to interact with your application, or just providing an API for programmatic access to your application.

### Some common tasks should have more tutorial content

The Django documentation is mostly for reference, covering all Django features, but with little content on how to use Django.
The items I list below likely are documented on books, websites, forums, etc.
If you know a good source for many of those, even if it is paid, feel free to let me know to add references.

* Admin
  * Restricting users to a subset of the instances of a model.
    For example, users belong to organizations and users should only see instances of some model related to their organization.
    The FAQ contains [How do I limit admin access so that objects can only be edited by the users who created them?](https://docs.djangoproject.com/en/5.1/faq/admin/#how-do-i-limit-admin-access-so-that-objects-can-only-be-edited-by-the-users-who-created-them), which is a very similar question and points to the features you need to use to achieve these goals.
    (These requirements are often related to requiring [extending the existing User model](https://docs.djangoproject.com/en/5.1/topics/auth/customizing/#extending-the-existing-user-model).)
  * Having a search UI for reference fields instead of dropdowns.
    Many projects similar to the admin only offer dropdowns for reference fields.
    This does not work when the referenced objects are more than a couple.
    Django calls this [`raw_id_fields`](https://docs.djangoproject.com/en/5.1/ref/contrib/admin/#django.contrib.admin.ModelAdmin.raw_id_fields), and it is difficult to learn that this feature exists.
