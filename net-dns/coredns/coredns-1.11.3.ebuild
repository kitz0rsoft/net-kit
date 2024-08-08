# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

go-module_set_globals

DESCRIPTION="CoreDNS is a DNS server that chains plugins"
HOMEPAGE="https://coredns.io/ https://github.com/coredns/coredns"
SRC_URI="https://github.com/coredns/coredns/tarball/a7ed346585e30b99317d36e4d007b7b19a228ea5 -> coredns-1.11.3-a7ed346.tar.gz
https://regen.mordor/34/f7/1a/34f71a73c1f31d423951b5ead1691cb93161a78c6eca84a73b13badc413d28f3bb17537d7a55853d3b61eebea7ba5f2ae94b8feb72b48e327e031e1fee3c50c1 -> coredns-1.11.3-funtoo-go-bundle-c176a278c92fedd12ca468562681e8e4067232fccde751ea62b548f59af5b39799140233e9dc7c15c95f3848eb8ae66b566dc002e2aeef20f6689ec2d9f66000.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=">=dev-lang/go-1.21"
S="${WORKDIR}/coredns-coredns-a7ed346"

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