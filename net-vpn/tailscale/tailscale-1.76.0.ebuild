# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module tmpfiles

VERSION_SHORT="1.76.0"
VERSION_LONG="1.76.0-t6d996464a"

DESCRIPTION="Tailscale vpn client"
HOMEPAGE="https://tailscale.com"
SRC_URI="https://github.com/tailscale/tailscale/tarball/6d996464ad4ce520b165c0fd3a1213876e55df5a -> tailscale-1.76.0-6d99646.tar.gz
https://regen.mordor/90/12/0f/90120f2032bf93c9b615354000833d6d9196cafd57131141c7a96511e97a7028794e37579319b9e39cdfdc92f3b09ee09f1b4131a763d7f4f429b77b3d85b518 -> tailscale-1.76.0-funtoo-go-bundle-9db89d219a3d7150d5bf7fac651c8bb1c1bf27b7bbc3ec87864f4e9114eb98f304e6529b5c0522db728492a571bd647aa4519b7144cfb6f57dea652d8ef05d69.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"

RDEPEND="net-firewall/iptables"
S="${WORKDIR}/tailscale-tailscale-6d99646"

# This translates the build command from upstream's build_dist.sh to an
# ebuild equivalent.
build_dist() {
	go build -tags xversion -ldflags "
		-X tailscale.com/version.longStamp=${VERSION_LONG}
		-X tailscale.com/version.shortStamp=${VERSION_SHORT}" "$@"
}

src_compile() {
	build_dist ./cmd/tailscale
	build_dist ./cmd/tailscaled
}

src_install() {
	dosbin tailscaled
	dobin tailscale

	insinto /etc/default
	newins cmd/tailscaled/tailscaled.defaults tailscaled
	keepdir /var/lib/${PN}
	fperms 0750 /var/lib/${PN}

	newtmpfiles "${FILESDIR}/${PN}.tmpfiles" ${PN}.conf

	newinitd "${FILESDIR}/${PN}d.initd" ${PN}
	newconfd "${FILESDIR}/${PN}d.confd" ${PN}
}

pkg_postinst() {
	tmpfiles_process ${PN}.conf
}