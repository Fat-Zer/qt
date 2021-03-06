# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils eapi7-ver

DESCRIPTION="Common base library for the LXQt desktop environment"
HOMEPAGE="https://lxqt.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://downloads.lxqt.org/downloads/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="LGPL-2.1+ BSD"
SLOT="0/$(ver_cut 1-2)"
IUSE="+policykit"

RDEPEND="
	>=dev-libs/libqtxdg-3.3.0
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtxml:5
	kde-frameworks/kwindowsystem:5[X]
	x11-libs/libX11
	x11-libs/libXScrnSaver
"

DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	>=dev-util/lxqt-build-tools-0.6.0
	policykit? ( sys-auth/polkit-qt )
"

PATCHES=( "$FILESDIR/${PN}-make-polkit-optional.patch" )

src_configure() {
	local mycmakeargs=(
		-DPULL_TRANSLATIONS=OFF
		$(usex !policykit '-DBUILD_POLKIT=OFF')
	)
	cmake-utils_src_configure
}

pkg_postinst() {
	if ! use policykit; then
		ewarn "Please do not report issues caused by USE=\"-policykit\" to upstream,"
		ewarn "as they do not support such a build at this time."
	fi
}
