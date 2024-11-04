# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION=" Private front-end for Reddit "
HOMEPAGE="https://github.com/redlib-org/redlib"
SRC_URI="https://github.com/redlib-org/redlib/tarball/d9e768100460dabb8016288ca17f22bdbada3a53 -> redlib-0.35.1-d9e7681.tar.gz
https://regen.mordor/5f/48/9f/5f489fb6281b61891f7ab0f72599f7d1a959a7013046a7ffa13ce1434c35acd8dce6c32c636bf802b62b7a83d6a71d4237bcc7ef013b5ae9f6bf9146ba396f34 -> redlib-0.35.1-funtoo-crates-bundle-a0220ca28de114ce617047a7c2ece23f8cefdb71eea8d86db203e640113acb6c1fcbbf4cf700d4ac11f8cf342029a9e7f1e15e194a386a25d5b11cd6b0a08431.tar.gz"

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