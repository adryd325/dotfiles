<pre>
█ .adryd (adryd-dotfiles)
█ version 6

$ bash -c "`curl -s adryd.co/install.sh`"
$ bash -c "`wget -Qo- adryd.co/install.sh`"

<b>DISCLAIMER</b>: These scripts are mostly public for teaching purposes, for
reference on how my system is configured, or for others to extend them for their
own use. These scripts are very opinionated and you may not like what they do.

<b>Components</b>
 - "/common" contains components that should compatible with 2 or more families
of operating systems / distros. Many of these assume operating systems with
systemd and GNU utilities.
 - "/hosts" contains configurations and scripts for individual hosts.
 - "/oses" contains configurations and scripts only intended to be compatible
with said operating system.
 - "/lib" contains functions

TODO: Find a way to differenciate between generic and opinionated modules. For
example: icon-theme and hide-internal-apps are opinionated, discord is
generic. Is it even worth it?)

<b>Installation folder</b>
On personal systems this should be installed to "~/.adryd".
On servers this should be installed to "/opt/adryd-dotfiles".

If the user is root, the install script will automatically install to
"/opt/adryd-dotfiles", otherwise it will install to "~/.adryd".

<b>Additional info</b>
the develop branch will have lots of force-pushes and should only be used on
machines when writing their configuration.
</pre>
