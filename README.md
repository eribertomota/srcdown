# srcdown

This script can be used to download all debian/ directories from all packages
maintained by a person. After the download, a big "changelog" file will be
generated to gather all individual chagelogs in one file.

To use, add a Debian maintainer name or email. An example:

$ ./srcdown.sh eriberto@debian.org

or

$ ./srcdown.sh eriberto
