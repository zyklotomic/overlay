# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="XCB utility functions for the X resource manager"
HOMEPAGE="https://github.com/Airblader/xcb-util-xrm"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="xcb-util"
RDEPEND="${DEPEND}"

src_compile() {
	cd xcb-util-xrm-$pkgver
	./configure --prefix=/usr
	make
}

src_install() {

}
