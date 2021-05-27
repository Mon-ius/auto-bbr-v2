# auto-bbr-v2

Actions for building Linux kernel with &lt;`https://github.com/google/bbr/tree/v2alpha`&gt;

## Usage

```bash
curl -s https://api.github.com/repos/Mon-ius/auto-bbr-v2/releases/latest \
| grep "browser_download_url.*deb" | grep -E '*linux-image*|*linux-headers*' \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -qi -

dpkg -i linux-headers-*.deb
dpkg -i linux-image-*.deb

# remove old
apt purge -y "linux-image-4.9.0-9-amd64"
update-grub
reboot

echo "net.core.default_qdisc = fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control = bbr2" >> /etc/sysctl.conf
echo "net.ipv4.tcp_ecn = 1" >> /etc/sysctl.conf
echo "net.ipv4.tcp_ecn_fallback = 1" >> /etc/sysctl.conf
# enable BBRv2 ECN response:
echo 1 > /sys/module/tcp_bbr2/parameters/ecn_enable
# enable BBRv2 ECN response at any RTT:
echo 0 > /sys/module/tcp_bbr2/parameters/ecn_max_rtt_us
sysctl -p
# check
sysctl net.ipv4.tcp_congestion_control

# fq -> cake (if needed) More on: https://www.bufferbloat.net/projects/codel/wiki/Cake
post-up tc qdisc replace dev eth0 root cake rtt 3600ms ethernet besteffort

tc qdisc replace dev eth0 root cake rtt 3600ms ethernet
# initcwnd -> /etc/network/interfaces
ip route change $(ip route show | grep -E "^default")  initcwnd 360
```

## Test

### 1. Build libbpf-dev

```bash
#For ubuntu 2004
mkdir -p /root/iproute2 && cd iproute2
wget https://github.com/libbpf/libbpf/archive/refs/tags/v0.1.0.tar.gz
tar -xf v0.1.0.tar.gz
cd libbpf-0.1.0/src && mkdir build root && BUILD_STATIC_ONLY=y OBJDIR=build DESTDIR=root make install
export LIBBPF_DIR=$(pwd)/root PKG_CONFIG_PATH=$(pwd)/build
```

### 2. Build iprouter2

```bash
sudo -E apt-get -qq update
sudo -E apt-get -qq install $(curl -fsSL git.io/bbrv2-test)
git clone git://git.kernel.org/pub/scm/network/iproute2/iproute2.git
cd iproute2/ && ./configure && make
```

### 3. Run bbrv2 test

```bash
#scp -r gtests/net/tcp/bbr/nsperf/ ${HOST}:/tmp/
sudo tar --no-same-owner -xzvf ${TEST_PKG} -C /root/nsperf > /tmp/tar.out.txt
cd /root/nsperf
./run_tests.sh
./graph_tests.sh

tests=random_loss ./run_tests.sh
tests=random_loss ./graph_tests.sh
```
