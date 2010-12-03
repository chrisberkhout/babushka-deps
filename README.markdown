# Notes

- To get up and running:
  - As a sudoer, run:
      bash -c "`wget -O - babushka.me/up`"
      babushka sources -a cb git://github.com/chrisberkhout/babushka-deps.git
      babushka cb:system
      babushka cb:account
  - In the account you created, run:
      babushka sources -a cb git://github.com/chrisberkhout/babushka-deps.git
      babushka cb:project

- I am using mostly standard dep definitions (not the other special dep types) because I want full awareness and control of what is being run. I also want the dep definition to easily read as a set of instructions for how to do the setup manually. Starting with this format, it should be easy enough to add in custom or build-in dep templates and other babushka functionality later where beneficial.

# ToDo

- make scaffapp a rails 3 app
- create account scaffapp
- have cb:project check for gemfile and do bundle install --deployment if necessary (according to bundle check)
  bundle install --deployment --without development test
- cb:project for scaffapp

^^ done

- nginx vhosts to get scaffapp to run
    - manually create vhost file, with host as ubuntu.local, with logs locations etc correct.
    - formalise vhost

    - think about adding .local domain names (ghost?, something else?)
    - think about wildcard domains.
    - dns api.

- git deploy keys
- git checkout branch/tag
- postgres as db for scaffapp

- php via nginx


# Temp notes

- nothing in proj deps for now.
- user: scaffapp
  pass: password

