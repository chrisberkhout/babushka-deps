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

- nginx vhosts to get scaffapp to run
    
    - check rails can actually run (extend scaffapp a bit).
    
    - initial deploy vs redeploy
      http://efreedom.com/Question/1-3258243/Git-Check-Pull-Needed

    - php via nginx

    - automate extra/wild global dns records.
      - https://github.com/rick/linode
        http://www.linode.com/api/autodoc.cfm
        
- deploy flow: site should get repo vhost from next not current

- git deploy keys
- git checkout branch/tag
- postgres as db for scaffapp

- do i need to change the user/group of the repo dir to www-data?


# Temp notes

- publish extra cname records via avahi mdns:
  http://airtonix.net/wiki/linux/avahi-aliases
  http://stackoverflow.com/questions/775233/how-to-route-all-subdomains-to-a-single-host-using-mdns
  http://serverfault.com/questions/44618/is-a-wildcard-cname-dns-record-valid
- `hostname -I` gives list of non-loopback non-ipv6-link-local ip addresses.

cd /usr/local/nginx/sites-available
sudo (cat > ubuntu.local)
sudo ln -sf ../sites-available/ubuntu.local
sudo /etc/init.d/nginx restart

- nothing in proj deps for now.
- user: scaffapp
  pass: password

- babushka runs with --defaults mean that previous vars are reused without prompting.