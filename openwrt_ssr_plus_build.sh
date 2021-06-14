#!/bin/bash

set -x

OPENWRT_CFG=$PWD/openwrt_config

export WORKDIR=/workspace
mkdir -p ${WORKDIR}
cd ${WORKDIR}

SDK_VERSION=19.07.4
OPENWRT_SDK=openwrt-sdk-${SDK_VERSION}-ramips-mt7621_gcc-7.5.0_musl.Linux-x86_64

wget https://archive.openwrt.org/releases/${SDK_VERSION}/targets/ramips/mt7621/${OPENWRT_SDK}.tar.xz
tar -xf ${OPENWRT_SDK}.tar.xz
cd ${WORKDIR}/${OPENWRT_SDK}/package

git clone https://github.com/kenzok8/openwrt-packages.git kenzo
git clone https://github.com/kenzok8/small.git small

cd ${WORKDIR}/${OPENWRT_SDK}/

echo "src-git kenzo https://github.com/kenzok8/openwrt-packages" >> ./feeds.conf.default
echo "src-git small https://github.com/kenzok8/small" >> ./feeds.conf.default
./scripts/feeds update -a
./scripts/feeds install -a

/bin/cp -rf OPENWRT_CFG .config
make defconfig
# make -j8 download V=s

cat > d.sh <<-EOF
#!/bin/bash
set -x
make \$1/download V=s
make \$1/compile V=s
exit 0
EOF

chmod +x d.sh

./d.sh package/small/pdnsd-alt
./d.sh package/small/dns2socks
./d.sh package/small/openssl1.1
./d.sh package/kenzo/microsocks
./d.sh package/kenzo/tcping
./d.sh package/kenzo/luci-app-ssr-plus
./d.sh package/kenzo/luci-app-openclash
./d.sh package/kenzo/luci-app-passwall
./d.sh package/kenzo/luci-theme-argon_new
./d.sh package/kenzo/luci-app-argon-config

tar -cjf bin.tar.bz2 bin

mv bin.tar.bz2 /tmp/gl_inet_mt1300_packages.tar.bz2
chmod 0666 /tmp/gl_inet_mt1300_packages.tar.bz2
