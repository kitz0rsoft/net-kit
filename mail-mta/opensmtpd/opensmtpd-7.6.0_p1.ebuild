# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools eutils flag-o-matic pam toolchain-funcs user

DESCRIPTION="Lightweight but featured SMTP daemon from OpenBSD"
HOMEPAGE="https://www.opensmtpd.org"
SRC_URI="https://www.opensmtpd.org/archives/opensmtpd-7.6.0p1.tar.gz -> opensmtpd-7.6.0p1.tar.gz"

LICENSE="ISC BSD BSD-1 BSD-2 BSD-4"
SLOT="0"
KEYWORDS="*"
IUSE="libressl pam +mta berkdb"

DEPEND="
	!libressl? ( >=dev-libs/openssl-1.1:0= )
	libressl? ( dev-libs/libressl:0= )
	elibc_musl? ( sys-libs/fts-standalone )
	sys-libs/zlib
	pam? ( sys-libs/pam )
	berkdb? ( sys-libs/db:= )
	dev-libs/libevent
	app-misc/ca-certificates
	net-mail/mailbase
	!mail-mta/courier
	!mail-mta/esmtp
	!mail-mta/exim
	!mail-mta/mini-qmail
	!mail-mta/msmtp[mta]
	!mail-mta/netqmail
	!mail-mta/nullmailer
	!mail-mta/postfix
	!mail-mta/qmail-ldap
	!mail-mta/sendmail
	!mail-mta/ssmtp[mta]
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P/_}

src_configure() {
	econf \
		--sysconfdir=/etc/smtpd \
		--with-path-mbox=/var/spool/mail \
		--with-path-empty=/var/empty \
		--with-path-socket=/run \
		--with-path-CAfile=/etc/ssl/certs/ca-certificates.crt \
		--with-user-smtpd=smtpd \
		--with-user-queue=smtpq \
		--with-group-queue=smtpq \
		$(use_with pam auth-pam) \
		$(use_with berkdb table-db)
}

src_install() {
	default
	newinitd "${FILESDIR}"/smtpd.initd smtpd
	use pam && newpamd "${FILESDIR}"/smtpd.pam smtpd
	dosym smtpctl /usr/sbin/makemap
	dosym smtpctl /usr/sbin/newaliases
	if use mta ; then
		dodir /usr/sbin
		dosym smtpctl /usr/sbin/sendmail
		dosym ../sbin/smtpctl /usr/bin/sendmail
		mkdir -p "${ED}"/usr/$(get_libdir) || die
		ln -s --relative "${ED}"/usr/sbin/smtpctl "${ED}"/usr/$(get_libdir)/sendmail || die

		# FL-8648
		fowners smtpq:smtpq /usr/sbin/smtpctl
		fperms 2555 /usr/sbin/smtpctl
	fi
}

pkg_preinst() {
	enewgroup smtpd 25
	enewuser smtpd 25 -1 /var/empty smtpd
	enewgroup smtpq 252
	enewuser smtpq 252 -1 /var/empty smtpq
}