cd /vagrant/netbsd-11-src

echo "Start building tools now..."

NOPROC=$(lscpu | grep "^CPU(s):" | awk '{print $2}')

./build.sh -U -u -j$NOPROC -m amd64 -a x86_64 -O $HOME/obj tools > $HOME/$(hostname)_tools.log 2>&1
EXITCODE=$?

if [[ $EXITCODE -eq 0 ]] && grep -Fq -- "===> build.sh ended" $HOME/$(hostname)_tools.log; then
  echo "Tools built successfully!"
  gzip $HOME/$(hostname)_tools.log
  mv $HOME/$(hostname)_tools.log.gz /vagrant
  # Continue below
else
    echo "Building tools failed!" >&2
fi

echo "Start building tools in minimal environment now..."
env -i HOME="$HOME" PATH=/usr/bin:/bin LC_ALL=C ./build.sh -U -u -j$NOPROC -m amd64 -a x86_64 -O $HOME/obj-small-env tools > $HOME/$(hostname)_tools_small_env.log 2>&1
EXITCODE=$?

if [[ $EXITCODE -eq 0 ]] && grep -Fq -- "===> build.sh ended" $HOME/$(hostname)_tools_small_env.log; then
  echo "Tools built successfully!"
  gzip $HOME/$(hostname)_tools_small_env.log
  mv $HOME/$(hostname)_tools_small_env.log.gz /vagrant
  # Continue below
else
    echo "Building tools in minimal environment failed!" >&2
fi
