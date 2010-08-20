# Notes

* These deps are initially intended for setting up an Ubuntu-based VPS as a webserver. To build systems of other types or on other platforms I may define different sets of deps in branches of this repository.

* The deps in this repository are separated into 'system' and 'user' directories. 
  * The 'system' deps are to set up system-wide things (e.g. a web server).
  * The 'user' deps are to be run (or required) by individual projects to set things up at a user level (e.g. an individual vhost configuration).
  * Project specific deps will be stored in a `babushka_deps` directory in the project repository.

* I am using mostly standard dep definitions (not the other special dep types) because I want full awareness and control of what is being run. I also want the dep definition to easily read as a set of instructions for how to do the setup manually. Starting with this format, it should be easy enough to add in custom or build-in meta deps and other babushka functionality later where beneficial.
