# iac_config

This repository has been my place to pretty much dump a lot of my files. Most of the files here
are unorganized, and useless for anyone but myself. If you happen to have stumbled upon this page,
then here are the only files that may be of use to you:


recursive-yum-downloader: if you work in an offline environment, and need to pull down all dependencies for a package, then this is great. ex - recursive-yum-downloader ansible

kickstarts/: Good if you want an example of a kickstart with working syntax. I built these when I was first learning Linux, so you definitely shouldn't be building individual kick starts per server, but the files should be generated pragmatically

bash/Export-Satellite-Repos.sh: If you use RedHat Satellite 6 (I'm so sorry) this will export
all the repositories to the directory that you specify within the script

python/DirectoryBuilder.py: Read the documentation in the script. Came in clutch a few times

notes/server_configurations: While studying for the RHCSA I created a document that specified all the
requirements for configuring a service. Well it turns out this was a pretty good overview. I recommend reading this if you configure services on RedHat
