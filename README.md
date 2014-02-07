# RubyRouting

A ruby wrapper for some useful pgRouting functions

## Installation

Add this line to your application's Gemfile:

    gem 'rubyrouting'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rubyrouting

## Usage

To get started:
    $ git clone https://github.com/jordanderson/vagrant-postgis2
    $ cd vagrant-postgis2
    $ git submodule init
    $ git submodule update
    $ vagrant up
    $ psql -h localhost -U postgres -p 5432 -W 
    (You'll be prompted for the postgres password. It's 'postgres')

    psql> CREATE DATABASE routing;
    psql> \c routing
    psql> CREATE EXTENSION postgis;
    psql> CREATE EXTENSION pgrouting; 
