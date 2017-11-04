# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="A fast floating WM written over the XCB library and derived from mcwm"
HOMEPAGE="https://github.com/venam/2bwm"
EGIT_REPO_URI="git://github.com/venam/2bwm"

LICENSE="ICS"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="savedconfig"

DEPEND="x11-libs/xcb-util
		x11-libs/xcb-util-wm
		x11-libs/xcb-util-keysyms"
RDEPEND="${DEPEND}"

src_prepare(){

	if use savedconfig ; then
		# Use user-defined config.h when compiling
		
src_install(){
	make
}


