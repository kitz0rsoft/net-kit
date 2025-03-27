# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module tmpfiles

VERSION_SHORT="1.82.0"
VERSION_LONG="1.82.0-t6676b1261"

DESCRIPTION="Tailscale vpn client"
HOMEPAGE="https://tailscale.com"
SRC_URI="https://github.com/tailscale/tailscale/tarball/6676b1261e51e0629553ca06b22e6631f8641100 -> tailscale-1.82.0-6676b12.tar.gz
https://regen.mordor/b1/62/a1/b162a11d4bf1d1f05dadabf3c660f0b4c51f5e80549b05fc17db2f51a8e15b28ee5d863c41b82dc02c6975ddf1717b4863331322558e8cc245947cb14651ce86 -> tailscale-1.82.0-funtoo-go-bundle-05605e1ad180eaa35a7867c50d0c84f636a5e220b5025d523c37df55d15c9fb1660e9e7f2f1c55d3fdb6a2f124a3b288ad777382c207f67b72f9d3dca01599d4.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"

RDEPEND="net-firewall/iptables"
S="${WORKDIR}/tailscale-tailscale-6676b12"

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