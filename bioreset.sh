# rebuild, restart, and reload

# handy: (echo "scm"; echo "(load \"$f\")") | nc localhost 17001 &> /dev/null

# shut down the cogserver
echo "shutdown" | nc localhost 17001 &> /dev/null

# remake and restart
# doh! can't use aliases in shell script
# makerun
cd ~/opencog/atomspace/build
sudo make install -j3
cd ~/opencog/opencog/build
make -j3

# fire er up
./opencog/server/cogserver &    # < cout &
sleep 4 

# load the bio module
(echo "loadpy bio" ) | nc localhost 17001 &> /dev/null

# load the biospace
(echo "scm"; echo "(clear)") | nc localhost 17001 &> /dev/null
~/opencog/bio-data/scheme-representations/load-scheme-representation.sh

# load the bio ure config file
(echo "(load \"../bio-ure-config.scm\")" ) | nc localhost 17001 &> /dev/null

# play a nice sound
paplay /usr/share/sounds/ubuntu/stereo/service-login.ogg







