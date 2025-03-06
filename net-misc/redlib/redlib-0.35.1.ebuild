# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION=" Private front-end for Reddit "
HOMEPAGE="https://github.com/redlib-org/redlib"
SRC_URI="https://github.com/redlib-org/redlib/tarball/d9e768100460dabb8016288ca17f22bdbada3a53 -> redlib-0.35.1-d9e7681.tar.gz
https://regen.mordor/07/3c/f5/073cf520039ba0ec72e00fd1067462328e6fa819d5f3a5db12f2345c3c0455f988685d49b9afa1fce9b4d1ae84b61fe4a373d4d579e1fda844c9013cc0c68f80 -> redlib-0.35.1-funtoo-crates-bundle-a0220ca28de114ce617047a7c2ece23f8cefdb71eea8d86db203e640113acb6c1fcbbf4cf700d4ac11f8cf342029a9e7f1e15e194a386a25d5b11cd6b0a08431.tar.gz"

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