# auto-bbr-v2

Actions for building Linux kernel with &lt;`https://github.com/google/bbr/tree/v2alpha`&gt;

## Usage

For example:

```bash
wget https://github.com/Mon-ius/auto-bbr-v2/releases/download/Ubuntu_2004_kernel_202105171751/linux-headers-5.10.0-custom_5.10.0-custom-1_amd64.deb -O linux-headers-5.10.0-custom.deb
wget https://github.com/Mon-ius/auto-bbr-v2/releases/download/Ubuntu_2004_kernel_202105171751/linux-image-5.10.0-custom_5.10.0-custom-1_amd64.deb -O linux-image-5.10.0-custom.deb
dpkg -i linux-headers-5.10.0-custom.deb
dpkg -i linux-image-5.10.0-custom.deb

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
```

## Test

```bash
sudo -E apt-get -qq update
sudo -E apt-get -qq install $(curl -fsSL git.io/bbrv2-test)
#scp -r gtests/net/tcp/bbr/nsperf/ ${HOST}:/tmp/
sudo tar --no-same-owner -xzvf ${TEST_PKG} -C /root/nsperf > /tmp/tar.out.txt

mkdir -p /root/iproute2/
cd /root/iproute2
git clone git://git.kernel.org/pub/scm/network/iproute2/iproute2.git
cd iproute2/
./configure
make

cd /root/nsperf
./run_tests.sh
./graph_tests.sh

cd /root/nsperf
tests=random_loss ./run_tests.sh
tests=random_loss ./graph_tests.sh
```
