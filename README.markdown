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

- I am just using simple deps and not a lot of helpers because I want full awareness and control of what is being run. I also want the dep definition to easily read as a set of instructions for how to do the setup manually. Starting with this format, it should be easy enough to switch to custom or build-in meta-deps and other babushka functionality later where beneficial.                       

# ToDo

- automate extra/wild global dns records.
  - fog does linode DNS
  - https://github.com/rick/linode
    http://www.linode.com/api/autodoc.cfm

- finish postgres:
  - test with scaffapp to check got everything
  - does this mean all users connecting locally have full access to all DB's ? alternate auth schemes better ?

- review project (most except site should go as it's done by rag_deploy)
        
- dep for hostname

- upgrade to passenger 3.0.1
- do i need to change the user/group of the repo dir to www-data?


# Temp notes

- `hostname -I` - non-loopback, non-ipv6-link-local IPs (on linux).

- babushka runs with --defaults mean that previous vars are reused without prompting.

    cd /usr/local/nginx/sites-available
    sudo (cat > ubuntu.local)
    sudo ln -sf ../sites-available/ubuntu.local
    sudo /etc/init.d/nginx restart

- project setup:
  - no proj deps for now.
  - nginx vhost configs can be put in project repos, under names like this (the first (of sort order) will be used):
      config/deploy/nginx-site-hostnameofserver.conf
      config/deploy/nginx-site-hostnameofserver.conf.erb
      config/deploy/nginx-site.conf
      config/deploy/nginx-site.conf.erb
