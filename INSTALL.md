# How I Installed It

#### Author: Samuel K. Grush

## 1. Install Ruby

You should probably use either [rbenv][rbenv-install] or [rvm][rvm-install].

### ...with rbenv

**Make sure you don't have any remnants of rvm installed**, they don't play
nicely, trust me.

I used rbenv, and it's Rails' recommended method. If you go that route, I
recommend just following the README section for
[Basic GitHub Checkout][rbenv-install#bgc] (for Linux), or
[Homebrew on Mac OS X][rbenv-install#hom] since I needed to install a
dependency or two and Homebrew makes that easier. Either way, make sure you
install [ruby-build][ruby-build-install].

Now you can install Ruby! Just run `rbenv install -v 2.3.3` (or whichever
version you want); the `-v` is for verbose. It should let you know if anything
goes wrong, and suggest how to fix it. Once successful, you've got Ruby
built but not accessible, so run `rbenv global 2.3.3` (or your version) to make
it the global default; alternatively you can use 'local' instead of 'global'
to only use the given version for the project in the current directory.

## 2. NodeJS

You need some kind of Javascript runtime, and Rails recommends NodeJS. Rails
also recommends installing the official NodeJS repository, but I just installed
my distro's version with `sudo apt install nodejs` or `sudo yum install nodejs`.
*The Rails guide is oddly silent about OS X and JS runtimes, but I'm assuming
you can install it from source or with homebrew.*

## 3. DBMS

### 3.1 Postgresql

To set up postgrayskull, install it and its related bits with either
`sudo apt install postgresql libpq-dev`,
`sudo yum install postgresql-server postgresql-devel`, or
`brew install postgresql`.

You'll now need to configure a user for the database server. *If on OS X, brew
might have done this for you already.* It's generally recommended to create a
DB user with your username, but for this project you
just need to create one based on the credentials in
[config/database.yml][db-config].

Run `sudo -u postgres createuser $USER -s` to create a user; replace `$USER`
with the desired username to add to the DB.

### 3.2 sqlite

If you're using sqlite, you might need to install its headers, but that's it,
 so just run `sudo apt install libsqlite3-dev`, `brew install sqlite3`, or
`sudo yum install sqlite-devel`.

## 4. bundler

Once Ruby's installed, install bundler using `gem install bundler`. *If using
rbenv, you might have to run `rbenv rehash` to make bundler work.*

You should now be able to run the bundler! Inside the ruby application
directory run `bundler` to build the application!

## Done!

You're all done! You should now be able to run `bin/rails s` from inside
the application directory to start the rails server!


[db-config]: /jje/config/database.yml
[rbenv-install]: https://github.com/rbenv/rbenv#install
[rbenv-install#bgc]: https://github.com/rbenv/rbenv#basic-github-checkout
[rbenv-install#hom]: https://github.com/rbenv/rbenv#homebrew-on-mac-os-x
[rvm-install]: https://rvm.io
[ruby-build-install]: https://github.com/rbenv/ruby-build#readme
