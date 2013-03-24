#!/bin/bash

set +o verbose

# cd "(dirname $0)"

# A bit crude but good for getting started
killall node mongod
rm -rf cordovaapp meteorapp

# First create the Meteor app 
meteor create --example leaderboard meteorapp
cd meteorapp && meteor && cd .. & 

# Without args it will check local machine
./meteor2cordova.sh 