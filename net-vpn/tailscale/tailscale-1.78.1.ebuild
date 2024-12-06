# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module tmpfiles

VERSION_SHORT="1.78.1"
VERSION_LONG="1.78.1-t8903926f7"

DESCRIPTION="Tailscale vpn client"
HOMEPAGE="https://tailscale.com"
SRC_URI="https://github.com/tailscale/tailscale/tarball/8903926f7167f4c4a2e21a6e3c0dae855322f3d6 -> tailscale-1.78.1-8903926.tar.gz
https://regen.mordor/60/bf/4d/60bf4d9293739fc503bfe26df62545de8891d773ae1e15569dbb9f39013d1a69eb136eeb2dbc273ae6796f15fd16fe8cc5e79880768ac62957ecc2a776a15f80 -> tailscale-1.78.1-funtoo-go-bundle-218cc878f24dbd969df388050742abc1367c1b8610f0ab5c956cbd9c46a25c52d3950e1c88c7179d2c27ef73c68969134220e12867c357a308021c824673b9ea.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"

RDEPEND="net-firewall/iptables"
S="${WORKDIR}/tailscale-tailscale-8903926"

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