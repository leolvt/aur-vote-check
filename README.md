aur-vote-check
==============

Simple wrapper to the `aurvote` tool that checks the votes of all locally 
installed packages and allows you to change their votes in a more 
interactive way.

Dependencies
------------

The needed dependencies are:

* The `aurvote` program, from the [French Arch Linux Community][1]. They 
provide a repository with their code. You can also find it on AUR.
* The perl `Term::ANSIColor` and `Term::ReadLine` modules, usually installed
by default. You can install a proper implementation of Term::ReadLine from 
CPAN to get better input handling.

[1]: http://archlinux.fr "The French Arch Linux Community"
