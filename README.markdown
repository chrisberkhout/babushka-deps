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

- add site hostname thingo to repo config naming conventions
- upgrade to passenger 3.0.1

- postgres as db for scaffapp
  - env vars:
    PATH=/usr/local/pgsql/bin:$PATH
    export PATH
    MANPATH=/usr/local/pgsql/man:$MANPATH
    export MANPATH
  - start server?
  - also: production db and log config (should go out to shared directory)

- deploy flow: site should get repo vhost from next not current
  - initial deploy vs redeploy
    http://efreedom.com/Question/1-3258243/Git-Check-Pull-Needed
  - git deploy keys
  - git checkout branch/tag
  - RAILS_ENV=production rake db:create db:migrate

- automate extra/wild global dns records.
  - https://github.com/rick/linode
    http://www.linode.com/api/autodoc.cfm
  - publish extra cname records via avahi mdns:
    http://airtonix.net/wiki/linux/avahi-aliases
    http://stackoverflow.com/questions/775233/how-to-route-all-subdomains-to-a-single-host-using-mdns
    http://serverfault.com/questions/44618/is-a-wildcard-cname-dns-record-valid
        
? do i need to change the user/group of the repo dir to www-data?
? read http://benhoskin.gs/2010/08/01/design-and-dsl-changes-in-babushka-v0.6/

# Temp notes

- `hostname -I` gives list of non-loopback non-ipv6-link-local ip addresses.
- babushka runs with --defaults mean that previous vars are reused without prompting.

cd /usr/local/nginx/sites-available
sudo (cat > ubuntu.local)
sudo ln -sf ../sites-available/ubuntu.local
sudo /etc/init.d/nginx restart

- nothing in proj deps for now.
- user: scaffapp
  pass: password

