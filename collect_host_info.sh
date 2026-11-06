echo "Collecting environment info ..."

echo '- `uname -a`:' > $HOME/$(hostname).host_info
uname -a >> $HOME/$(hostname).host_info

if command -v lsb_release &> /dev/null; then
    echo '- `lsb_release -a`:' >> $HOME/$(hostname).host_info
    lsb_release -a >> $HOME/$(hostname).host_info
fi

echo '' >> $HOME/$(hostname).host_info
echo '- `ls -la $(which sh)`:' >> $HOME/$(hostname).host_info
ls -la $(which sh) >> $HOME/$(hostname).host_info
echo '- `ls -la $(which $SHELL):`' >> $HOME/$(hostname).host_info
ls -la $(which $SHELL) >> $HOME/$(hostname).host_info

echo '' >> $HOME/$(hostname).host_info
echo '- C compiler version:' >> $HOME/$(hostname).host_info
cc --version >> $HOME/$(hostname).host_info
echo '- Linker compiler version:' >> $HOME/$(hostname).host_info
ld --version >> $HOME/$(hostname).host_info
echo '- Std dynamic linker/loader version:' >> $HOME/$(hostname).host_info
/usr/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2 --version >> $HOME/$(hostname).host_info
echo '- Stdlib version:' >> $HOME/$(hostname).host_info
ldd --version >> $HOME/$(hostname).host_info

echo '' >> $HOME/$(hostname).host_info
locale >> $HOME/$(hostname).host_info

echo '' >> $HOME/$(hostname).host_info
echo 'Edited environment (removed private entries before data sharing): ' >> $HOME/$(hostname).host_info
env >> $HOME/$(hostname).host_info >> $HOME/$(hostname).host_info

echo '' >> $HOME/$(hostname).host_info
echo 'Experiment conducted on Git commit (https://github.com/NetBSD/src.git):' >> $HOME/$(hostname).host_info
git -C /vagrant/netbsd-11-src log --pretty=format:"%H" >> $HOME/$(hostname).host_info
