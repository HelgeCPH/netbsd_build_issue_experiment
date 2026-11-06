echo "Collecting environment info ..."

OUTFILE=./$(hostname)_$OSTYPE.host_info

echo '- `uname -a`:' > $OUTFILE
uname -a >> $OUTFILE

if command -v lsb_release &> /dev/null; then
    echo '- `lsb_release -a`:' >> $OUTFILE
    lsb_release -a >> $OUTFILE
fi
if [[ "$OSTYPE" == 'darwin'* ]] &> /dev/null; then
    echo '- `sysctl kern...`:' >> $OUTFILE
    sysctl kern.version kern.ostype kern.osrelease kern.osrevision >> $OUTFILE
fi

echo '' >> $OUTFILE
echo '- `ls -la $(which sh)`:' >> $OUTFILE
ls -la $(which sh) >> $OUTFILE
echo '- `ls -la $(which $SHELL):`' >> $OUTFILE
ls -la $(which $SHELL) >> $OUTFILE

echo '' >> $OUTFILE
echo '- C compiler version:' >> $OUTFILE
cc --version >> $OUTFILE
echo '- Linker compiler version:' >> $OUTFILE
ld --version >> $OUTFILE
echo '- Std dynamic linker/loader version:' >> $OUTFILE
/usr/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2 --version >> $OUTFILE
echo '- Stdlib version:' >> $OUTFILE
ldd --version >> $OUTFILE

echo '' >> $OUTFILE
locale >> $OUTFILE

echo '' >> $OUTFILE
echo 'Edited environment (removed private entries before data sharing): ' >> $OUTFILE
env >> $OUTFILE >> $OUTFILE

echo '' >> $OUTFILE
echo 'Experiment conducted on Git commit (https://github.com/NetBSD/src.git):' >> $OUTFILE
git -C ../netbsd-11-src log --pretty=format:"%H" >> $OUTFILE
