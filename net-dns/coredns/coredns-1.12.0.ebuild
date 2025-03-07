# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

go-module_set_globals

DESCRIPTION="CoreDNS is a DNS server that chains plugins"
HOMEPAGE="https://coredns.io/ https://github.com/coredns/coredns"
SRC_URI="https://github.com/coredns/coredns/tarball/51e11f166ef6c247a78e9e15468647c593b79b9f -> coredns-1.12.0-51e11f1.tar.gz
https://regen.mordor/ca/04/27/ca0427790134d09b23a3396736e489f179f4cd1f54adcec2927fab8020c5c1864907e59c0e0ddee73cdf1c0ef7ffeb4156cfd077999ae6c970c72fd80b2f8a91 -> coredns-1.12.0-funtoo-go-bundle-22a5c9bf6b1fa7fdf6ba493fa57174e1e403ca921d22ab958cd55e8512c5b609c4240c7d98163372f56de57d52c133f43d0f7e2a79022b5f9a3a161e20405776.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=">=dev-lang/go-1.21"
S="${WORKDIR}/coredns-coredns-51e11f1"

src_compile() {
	FORCE_HOST_GO=yes
	echo "$(go env GOVERSION | sed 's/go//g')" > .go-version
	emake
}

src_install() {
	dobin ${PN}
	insinto /etc/"${PN}"
	doins "${FILESDIR}"/Corefile
	dodoc README.md
	doman man/*

	newinitd "${FILESDIR}"/"${PN}".initd ${PN}
	newconfd "${FILESDIR}"/"${PN}".confd ${PN}
	keepdir /var/log/"${PN}"
}