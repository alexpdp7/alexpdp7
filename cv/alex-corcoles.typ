#import "@preview/resumania:1.0.0": *

#let author = "Álex Córcoles"

#let contacts = contact-section(
  phone: phone("+34 627 294 033"),
  email: email("alex@corcoles.net"),
  linkedin: url-link(name: "LinkedIn", "alexcorcoles", "https://www.linkedin.com/in/alexcorcoles/"),
  github: url-link(name: "GitHub", "alexpdp7", "https://github.com/alexpdp7"),
  location: location[Spain],
)

#let education = education-section(
  undergrad: education(
    institution: "Universitat Autònoma de Barcelona",
    study: "Computer Science, Computer vision, Security",
    timeframe: "1997-2003",
  ),
)

#let work = work-section(
  work(
    company: "Veecle",
    location: "Remote",
    position: "Software Engineer",
    timeframe: (
      start: "April 2024",
      end: "Present",
    )
  )[
    Veecle provides a Rust-based stack for software-defined vehicles.

    As a member of a startup, I deal with varied stuff- from supporting our carmaker customers, to working on our product, to improving developer experience through automation and systems administration.

    Lately I have implemented the systems backend for Veecle Studio, an online IDE.
    We deploy a custom application with Vercel and Supabase, with the IDE running on AWS EKS Auto.
    The IDE is deployed using Terraform, on multiple environments, including per-PR preview environments.
    The entire AWS account structure and Vercel are also managed using Terraform.
  ],
  work(
    company: "Red Hat",
    location: "Remote",
    position: "Services Content Architect, Red Hat Training and Certification",
    timeframe: (
      start: "March 2020",
      end: "March 2024",
    )
  )[
    I have participated in the development of courses such as DO180, DO280, DO380, DO480, DO326 (about OpenShift administration), TL112, and TL250 (DevOps/SRE).
    I have written lectures, and also hands-on labs (including scripts for lab setup and automated grading), following our language style guides with the help of our editors.

    I also collaborate developing our tools, esp. our lab scripting environment (helping out a transition from Bash scripts to Python), and command-line tools.

    To write the courses, I have learned Kubernetes/OpenShift administration, especially from the infrastructure as code angle.
  ],
  work(
    company: "NTT COM Managed Services",
    location: "Barcelona and remote",
    position: "Senior developer",
    timeframe: (
      start: "January 2012",
      end: "August 2019",
    )
  )[
    I have oscillated between management and development work.
    Our objective is to automate as much as possible the work of the systems administrators, so we develop from fully-fledged web applications (mostly using Django and Django Rest Framework) to command-line tools, as well as integrations among many different applications.

    In my years there, we have adopted automated testing, code review and continuous delivery practices with extensive automation of complex test environments (involving real systems testing on a significant amount of different operating systems).
    We have worked mostly on the AWS platform, using a combination of tools like Salt, Ansible and Puppet.

    We also have adopted Agile values and practices, implementing Scrum.
  ],
  work(
    company: "Cink Shaking Business S.L.",
    location: "Barcelona",
    position: "Chief Technical Officer",
    timeframe: (
      start: "February 2011",
      end: "October 2011",
    )
  )[
    As a CTO, I led a 9-person team comprised of software developers and graphics designers, delivering projects revolving around social networks (such as analytics and e-commerce platforms and integrations).

    I was also responsible for IT for the company, acted as technical advisor and general business planning.
  ],
  work(
    company: "Blanco y Negro Music",
    location: "Barcelona",
    position: "Technical Department",
    timeframe: (
      start: "February 2009",
      end: "January 2011",
    )
  )[
    Responsible for the technical aspects of Spain's largest independent records company

    - Technical guidance and analysis
    - Maintenance of the company's computing infrastructure, including 25 workstations, Windows and Linux servers, externally hosted servers and services and networking equipment
    - Technical liaison with providers and customers for services and custom projects
-    Digitalization of the company's digital catalogue, including the development of a custom management web application and a public facing website, using Java/J2EE, PostgreSQL, JSP, JSTL, custom tag libraries, XHTML, Javascript, jQuery, CSS, Spring
     - Technical lead for in-house development projects, including analysis, design, coding, building, testing, deployment, version control and issue tracking
  ],
)

#let skills = skills-section(
  skillset(
    "Software development",
    "Python",
    "Java",
    "Rust",
    "Git",
    "CI/CD",
    "SQL",
    "Spring Framework",
    "Django",
  ),
  skillset(
    "Systems administration",
    "Terraform",
    "Ansible",
    "Puppet",
    "AWS",
    "Kubernetes",
    "Containers",
  ),
  skillset(
    "Others",
    "Technical leadership",
    "Agile",
    "Lean",
    "Technical writing",
  )
)

#show: resume.with(
  author,
  sections: (contacts, work, skills, education),
)
