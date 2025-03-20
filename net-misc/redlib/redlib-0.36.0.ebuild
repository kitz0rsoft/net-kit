# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION=" Private front-end for Reddit "
HOMEPAGE="https://github.com/redlib-org/redlib"
SRC_URI="https://github.com/redlib-org/redlib/tarball/15147cea8e42f6569a11603d661d71122f6a02dc -> redlib-0.36.0-15147ce.tar.gz
https://regen.mordor/84/84/d4/8484d441fa1cc595acc004879f388b2f46b1f6245d6e6aa09d43112e654d4f7bec817f4a053f94c90f2ef6b7d74eb882401b4a0de9c5ba5c0b45a58d95ef64e5 -> redlib-0.36.0-funtoo-crates-bundle-f21431ffcb2ea2828869cfa4f5621e477edec9c2a417aaba5f202ccc04f0c7ef0b37bd8bb85ba84dfb12652687eece33609d43b0159774e9ec5277b49557a737.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="*"

DOCS=( README.md )

QA_FLAGS_IGNORED="/usr/bin/redlib"

src_unpack() {
	cargo_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/redlib-org-redlib-* ${S} || die
}