# Vagrant
Install vagrant http://vagrantup.com/

# Start virtual server
$ vagrant up

# SSH into server
$ vagrant ssh

# Here are the prerequisite dependancies that need to be installed. I listed them as separate lines to make it easier to add and comment out packages.  
$ sudo apt-get update
$ sudo apt-get install ruby build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config vim

# Install rbenv

# Check out rbenv into ~/.rbenv.
cd ~/
$ git clone git://github.com/sstephenson/rbenv.git .rbenv
$ git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

# Add ~/.rbenv/bin to your $PATH for access to the rbenv command-line utility.
$ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile

# Add rbenv init to your shell to enable shims and autocompletion.
$ echo 'eval "$(rbenv init -)"' >> ~/.bash_profile

# Restart your shell so the path changes take effect. You can now begin using rbenv.
$ source .bash_profile

# Install ruby 1.9.3
$ rbenv install 1.9.3-p327

# Rehash
$ rbenv rehash
$ rbenv global 1.9.3-p327

# Install bundler
$ gem install bundler
$ rbenv rehash

# Clone the SiriProxy repo
$ git clone git://github.com/plamoni/SiriProxy.git ~/SiriProxy
$ cd ~/SiriProxy
$ mkdir ~/.siriproxy
$ cp ./config.example.yml ~/.siriproxy/config.yml

# Install SiriProxy
$ rake install
$ bundle install

# Generate the certificates
$ bundle exec siriproxy gencerts

# Bundle SiriProxy (this installs the plugins and whatnot)
$ bundle exec siriproxy bundle

# Start the server
$ bundle exec siriproxy server

# On you host machine (Mac OS X)
sudo ipfw add 100 fwd 127.0.0.1,4000 tcp from any to any 443 in