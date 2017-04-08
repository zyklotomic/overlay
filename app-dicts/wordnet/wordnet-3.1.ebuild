# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils flag-o-matic

DESCRIPTION="A lexical database for the English language"
HOMEPAGE="http://wordnet.princeton.edu/"
SRC_URI="
	http://wordnetcode.princeton.edu/3.0/WordNet-3.0.tar.gz
	http://wordnetcode.princeton.edu/wn${PV}.dict.tar.gz
	mirror://gentoo/wordnet-3.0-patchset-1.tar.bz2"
LICENSE="Princeton"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE="doc"

# In contrast to what the configure script seems to imply, Tcl/Tk is NOT
# optional. cf. bug 163478 for details. (Yes, it's about 2.1 but it's
# still the same here.)
DEPEND="
	dev-lang/tcl:0=
	dev-lang/tk:0="
RDEPEND="${DEPEND}"

S="${WORKDIR}/WordNet-${PV}"

PATCHES=(
	# Don't install into PREFIX/dict but PREFIX/share/wordnet/dict
	"${WORKDIR}/${P}-dict-location.patch"
	# Fixes bug 130024, make an additional shared lib
	"${WORKDIR}/${P}-shared-lib.patch"
	# Don't install the docs directly into PREFIX/doc but PREFIX/doc/PN
	"${WORKDIR}/${P}-docs-path.patch"
	"${WORKDIR}"/${P}-CVE-2008-3908.patch #211491
	"${WORKDIR}"/${P}-CVE-2008-2149.patch #211491

	"${FILESDIR}"/${P}-tcl8.6.patch
	"${FILESDIR}"/${P}-format-security.patch
	"${FILESDIR}"/${P}-src_stubs_c.patch
	"${FILESDIR}"/${P}-fix-indexing-bug-314799.patch
)

src_prepare() {
	epatch "${PATCHES[@]}"
	eapply_user

	# Replace default 3.0 libs with 3.1 libs
	rm -r ${S}/dict
	mv ${WORKDIR}/dict ${S}

	# Don't install all the extra docs (html, pdf, ps) without doc USE flag.
	if ! use doc; then
		sed -i -e "s:SUBDIRS =.*:SUBDIRS = man:" doc/Makefile.am || die
	fi

	# Drop installation of OLD tk.h headers #255590
	sed '/^SUBDIRS/d' -i include/Makefile.am || die
	sed 's: include/tk/Makefile::' -i configure.ac || die
	rm -rf include/tk/ || die

	rm -f configure || die
	eautoreconf
	MAKEOPTS+=" -e"
}

src_configure() {
	append-cppflags -DUNIX -I"${T}"/usr/include

	PLATFORM=linux WN_ROOT="${T}/usr" \
	WN_DICTDIR="${T}/usr/share/wordnet/dict" \
	WN_MANDIR="${T}/usr/share/man" \
	WN_DOCDIR="${T}/usr/share/doc/wordnet-${PV}" \
	WNHOME="${EPREFIX}/usr/share/wordnet" \
	econf \
		--with-tcl="${EPREFIX}"/usr/$(get_libdir) \
		--with-tk="${EPREFIX}"/usr/$(get_libdir)
}
