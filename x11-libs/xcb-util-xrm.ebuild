# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="XCB utility functions for the X resource manager"
HOMEPAGE="https://github.com/Airblader/xcb-util-xrm"
EGIT_REPO_URI="git://github.com/Airblader/xcb-util-xrm"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="x11-libs/xcb-util"
RDEPEND="${DEPEND}"

src_configure() {
	cd "util-xrm"
	git submodule update --init
	./autogen.sh --prefix=/usr
}

src_compile()

src_install() {
	cd "util-xrm"
	emake DESTDIR="${D}"
	dodoc COPYING
}
