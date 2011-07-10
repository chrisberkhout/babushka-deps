# Babushka Deps

My [Babushka](http://babushka.me) deps for setting up a Linux VPS.

## Status and scope

In development. Some cleanup to do but should work.

These deps are for setting up a system and its accounts. They don't (or don't currently) handle:

* DNS setup
* Backups
* Passwordless authentication from a dev machine
* Deployment/redeployment of individual apps

## To get going and set up a new site...

As a sudoer, run:

    bash -c "`wget -O - babushka.me/up`"
    babushka sources -a cb git://github.com/chrisberkhout/babushka-deps.git
    babushka cb:'system chrisberkhout.com'
    babushka cb:account

A different `cb:'system *'` setup may be required. See `system.rb` for alternatives. After that, in the account you created, run:

    babushka sources -a cb git://github.com/chrisberkhout/babushka-deps.git
    babushka cb:site

## Special setup

Setup:

    git update-server-info
    gem install asdf
    echo -e "On the target machine, run:\nbabushka sources -a ns http://`/usr/libexec/PlistBuddy -c 'Print System:Network:HostNames:LocalHostName' /Library/Preferences/SystemConfiguration/preferences.plist`.local:9292/.git"
    asdf

Recommit:

    ga .; gc -m "."; git update-server-info


## Notes

I am intentionally using only simple deps and few helpers because I want full awareness and control of what is being run. I also want the dep definition to read as a set of instructions for how to do the setup manually. Starting with this format, it should be easy enough to switch to custom or build-in meta-deps and other babushka functionality later where beneficial.                       

## Copyright

The MIT License

Copyright (C) 2011 by Chris Berkhout (http://chrisberkhout.com)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
