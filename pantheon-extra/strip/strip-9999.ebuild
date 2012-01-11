# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit fdo-mime gnome2-utils cmake-utils bzr

DESCRIPTION="an elementary comic reader"
HOMEPAGE="https://launchpad.net/strip"
EBZR_REPO_URI="lp:strip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-libs/glib:2
	x11-libs/granite
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	dev-lang/vala:0.14"

pkg_setup() {
	DOCS=( AUTHORS README )
}

src_prepare() {
	# Disable compilation of GSettings schemas, this is handled by this ebuild
	epatch "${FILESDIR}/${PN}-0.4-cmake-gsettings-module.patch"
}

src_configure() {
	local mycmakeargs=(
		-DGSETTINGS_COMPILE=OFF
		-DVALA_EXECUTABLE=$(type -p valac-0.14)
	)

	cmake-utils_src_configure
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_schemas_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_schemas_update --uninstall
}
