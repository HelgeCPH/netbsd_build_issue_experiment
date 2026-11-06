cd /vagrant/netbsd-11-src

echo "Start building release now..."

OUTFILE=./$(hostname)_$OSTYPE
NOPROC=$(lscpu | grep "^CPU(s):" | awk '{print $2}')

./build.sh -U -u -j$NOPROC -m amd64 -a x86_64 -O $HOME/obj release > ${OUTFILE}_release.log 2>&1
EXITCODE=$?

if [[ $EXITCODE -eq 0 ]] && grep -Fq -- "===> build.sh ended" /vagrant/$(hostname)_release.log; then
  echo "Release built successfully!"
  gzip ${OUTFILE}_release.log
  # Continue below
else
    echo "Building release failed!" >&2

    echo "Build the release again in sequential order for better error identification..."
    ./build.sh -U -u -j1 -m amd64 -a x86_64 -O $HOME/obj release > ${OUTFILE}_release_serial.log 2>&1
fi


echo "Start building release in minimal environment now..."
env -i HOME="$HOME" PATH=/usr/bin:/bin LC_ALL=C ./build.sh -U -u -j$NOPROC -m amd64 -a x86_64 -O $HOME/obj-small-env release > ${OUTFILE}_release_small_env.log 2>&1
EXITCODE=$?

if [[ $EXITCODE -eq 0 ]] && grep -Fq -- "===> build.sh ended" ${OUTFILE}_release_small_env.log; then
  echo "Release built successfully!"
  gzip ${OUTFILE}_release_small_env.log
else
    echo "Building release in minimal environment failed!" >&2

    echo "Build the release in minimal environment again in sequential order for better error identification..."
    env -i HOME="$HOME" PATH=/usr/bin:/bin LC_ALL=C ./build.sh -U -u -j1 -m amd64 -a x86_64 -O $HOME/obj-small-env release > ${OUTFILE}_release_serial.log 2>&1
fi

echo "Remember to clean obj directories in $HOME!"