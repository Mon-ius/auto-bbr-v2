export CONFIG_FILE_SOURCE=https://downloads.openwrt.org/releases/21.02.0-rc2/targets/bcm27xx/bcm2711/config.buildinfo
export REPO_URL=https://github.com/MonCoeus/lede
export REPO_BRANCH=master
export REPO_NAME=lede
export WORK_DIR=/lede

sudo rm -rf /etc/apt/sources.list.d/* /usr/share/dotnet /usr/local/lib/android /opt/ghc
sudo -E apt-get -qq update
sudo -E apt-get -qq install $(curl -fsSL git.io/bbrv2-ubuntu-2004)
sudo -E apt-get -qq autoremove --purge
sudo -E apt-get -qq clean
sudo mkdir -p /release/upload
sudo chown -R $USER:$GROUPS /release

git clone --depth 1 -b $REPO_BRANCH $REPO_URL $REPO_NAME
sudo ln -sf $(pwd)/$REPO_NAME $WORK_DIR

cd $WORK_DIR
curl -L $CONFIG_FILE_SOURCE -o .config
./scripts/feeds update -a && ./scripts/feeds install -a

make defconfig
make download -j8
find dl -size -1024c -exec ls -l {} \;
find dl -size -1024c -exec rm -f {} \;
make -j1 V=s





