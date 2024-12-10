# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

DESCRIPTION="AmneziaWG VPN protocol"
HOMEPAGE="https://github.com/amnezia-vpn/amneziawg-go"
SRC_URI="https://github.com/amnezia-vpn/amneziawg-go/tarball/2e3f7d122ca8ef61e403fddc48a9db8fccd95dbf -> amneziawg-go-0.2.12-2e3f7d1.tar.gz
https://regen.mordor/e4/4c/ed/e44ced1dd451034a62e7006553b87425cc4d82d9c73b9ffa0ae1fc32604f9f8e849683604853a1cd6d69ae1183f3a16f6a4ef828b7c02ddda59b106afbf66cb2 -> amneziawg-go-0.2.12-funtoo-go-bundle-8339e4c2c3f03f5dd55137c8511c86d09d500cedd328fc17ec0984c3fc322d04272aebac6bcb19ab5b3da1a26c998a089dbeaea74733da0476e765bbee33d055.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"

post_src_unpack() {
    mv ${WORKDIR}/amnezia-vpn-amneziawg-go-* ${S} || die
}