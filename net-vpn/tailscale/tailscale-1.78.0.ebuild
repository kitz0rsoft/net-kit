# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module tmpfiles

VERSION_SHORT="1.78.0"
VERSION_LONG="1.78.0-tb06ec2696"

DESCRIPTION="Tailscale vpn client"
HOMEPAGE="https://tailscale.com"
SRC_URI="https://github.com/tailscale/tailscale/tarball/b06ec2696b87e2a237ab4abbdec937a39ddadc73 -> tailscale-1.78.0-b06ec26.tar.gz
https://regen.mordor/bc/19/61/bc19611f3a610ac4af850d4bb48093654f7dc3ee4d4fe0cabc7a83f316adea032dd717bd4d558652176772b0207359b79f4b44dfb354b716641d00679175c279 -> tailscale-1.78.0-funtoo-go-bundle-218cc878f24dbd969df388050742abc1367c1b8610f0ab5c956cbd9c46a25c52d3950e1c88c7179d2c27ef73c68969134220e12867c357a308021c824673b9ea.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"

RDEPEND="net-firewall/iptables"
S="${WORKDIR}/tailscale-tailscale-b06ec26"

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