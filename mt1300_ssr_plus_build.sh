#!/bin/bash

export WORKDIR=/workspace
mkdir -p ${WORKDIR}
cd ${WORKDIR}

git clone https://github.com/gl-inet/sdk.git gl-inet
cd ${WORKDIR}/gl-inet
./download.sh ramips-1907
cd ${WORKDIR}/gl-inet/sdk/1907/ramips/package

git clone https://github.com/kenzok8/openwrt-packages.git kenzo
git clone https://github.com/kenzok8/small.git small

cd ${WORKDIR}/gl-inet/sdk/1907/ramips

echo "src-git kenzo https://github.com/kenzok8/openwrt-packages" >> ./feeds.conf.default
echo "src-git small https://github.com/kenzok8/small" >> ./feeds.conf.default
./scripts/feeds update -a -f
./scripts/feeds install -a -f

make defconfig
make -j8 download V=s
make -j1 V=s

cat > d.sh <<-EOF
#!/bin/bash
set -x
make \$1/download V=s
make \$1/compile V=s
exit 0
EOF

chmod +x d.sh


cd ${WORKDIR}/gl-inet
# ./builder.sh -t ramips-1907 -a
# ./builder.sh -t ramips-1907 -d sdk/1907/ramips/package/small/pdnsd-alt
# ./builder.sh -t ramips-1907 -d sdk/1907/ramips/package/small/dns2socks
# ./builder.sh -t ramips-1907 -d sdk/1907/ramips/package/small/openssl1.1
# ./builder.sh -t ramips-1907 -d sdk/1907/ramips/package/kenzo/microsocks
# ./builder.sh -t ramips-1907 -d sdk/1907/ramips/package/kenzo/tcping
./builder.sh -v -t ramips-1907 -d sdk/1907/ramips/package/kenzo/luci-app-ssr-plus

cd ${WORKDIR}/gl-inet/sdk/1907/ramips
tar -cjf bin.tar.bz2 bin

mv bin.tar.bz2 /tmp/gl_inet_mt1300_packages.tar.bz2
chmod 0666 /tmp/gl_inet_mt1300_packages.tar.bz2
