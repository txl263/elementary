# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit gnome2-utils cmake-utils bzr

DESCRIPTION="Elementary's nautilus-free wallpaper solution"
HOMEPAGE="https://launchpad.net/pantheon-wallpaper"
EBZR_REPO_URI="lp:pantheon-wallpaper"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="nls"

CDEPEND="
	dev-libs/glib:2
	dev-libs/libgee:0
	x11-libs/granite
	x11-libs/gtk+:3"
RDEPEND="${CDEPEND}
	x11-themes/elementary-wallpapers"
DEPEND="${CDEPEND}
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )
	|| (
		dev-lang/vala:0.14
		dev-lang/vala:0.12
		dev-lang/vala:0.10
	)"

pkg_setup() {
	DOCS="AUTHORS COPYING COPYRIGHT"
}

src_prepare() {
	# Set a default background
	sed -f "${FILESDIR}/${PN}-default.sed" -i desktop.Wallpaper.gschema.xml
}

src_configure() {
	local mycmakeargs=(
		-DGSETTINGS_COMPILE=OFF
		-DVALA_EXECUTABLE="$(type -p valac-0.14 valac-0.12 valac-0.10 | head -n1)"
	)

	cmake-utils_src_configure
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update --uninstall
}
