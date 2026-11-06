OUTFILE=$(pwd)/$(hostname)_$OSTYPE
if [[ "$OSTYPE" == 'darwin'* ]] &> /dev/null; then
    NOPROC=$(sysctl -n hw.ncpu)
else
    NOPROC=$(lscpu | grep "^CPU(s):" | awk '{print $2}')
fi

echo "Start building tools now..."
cd ../netbsd-11-src

./build.sh -U -u -j$NOPROC -m amd64 -a x86_64 -O $HOME/obj tools > ${OUTFILE}_tools.log 2>&1
EXITCODE=$?

if [[ $EXITCODE -eq 0 ]] && grep -Fq -- "===> build.sh ended" ${OUTFILE}_tools.log; then
  echo "Tools built successfully!"
  gzip ${OUTFILE}_tools.log
  # Continue below
else
  echo "Building tools failed!" >&2
fi

echo "Start building tools in minimal environment now..."
env -i HOME="$HOME" PATH=/usr/bin:/bin LC_ALL=C ./build.sh -U -u -j$NOPROC -m amd64 -a x86_64 -O $HOME/obj-small-env tools > ${OUTFILE}_tools_small_env.log 2>&1
EXITCODE=$?

if [[ $EXITCODE -eq 0 ]] && grep -Fq -- "===> build.sh ended" ${OUTFILE}_tools_small_env.log; then
  echo "Tools built successfully!"
else
  echo "Building tools in minimal environment failed!" >&2
fi
gzip ${OUTFILE}_tools_small_env.log
