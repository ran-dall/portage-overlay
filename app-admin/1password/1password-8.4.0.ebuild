# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHROMIUM_LANGS="
	am ar bg bn ca cs da de el en-GB en-US es es-419 et fa fi fil fr gu he hi
	hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr sv
	sw ta te th tr uk vi zh-CN zh-TW
"

inherit chromium-2 desktop pax-utils

DESCRIPTION="${PN^^[p]} password manager and secure wallet"
HOMEPAGE="https://${PN}.com/"
SRC_URI="https://downloads.${PN}.com/linux/tar/stable/x86_64/${P}.x64.tar.gz"

LICENSE="1Password-TOS"
IUSE="policykit"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="!!app-admin/1password-beta
	>=sys-libs/glibc-2.28
	x11-themes/hicolor-icon-theme
	x11-libs/gtk+:*
	dev-libs/nss
"
RDEPEND="policykit? ( sys-auth/polkit )
	acct-group/onepassword
	${DEPEND}
"

RESTRICT="bindist mirror strip test"

QA_PREBUILT="${DESTDIR}/${PN}
	${DESTDIR}/${PN^^[p]}-BrowserSupport
	${DESTDIR}/${PN^^[p]}-KeyringHelper
	${DESTDIR}/chrome-sandbox
	${DESTDIR}/chrome_crashpad_handler
	${DESTDIR}/libEGL.so
	${DESTDIR}/libffmpeg.so
	${DESTDIR}/libGLESv2.so
	${DESTDIR}/libvk_swiftshader.so
	${DESTDIR}libvulkan.so.1
"

S="${WORKDIR}/${P}.x64"

DESTDIR="/opt/${PN^^[p]}"

src_unpack() {
	unpack ${P}.x64.tar.gz || die
}

src_prepare() {
	default

	rm after-install.sh
	rm after-remove.sh
	rm install_biometrics_policy.sh
	rm LICENSE
	rm LICENSES.chromium.html

	pushd "locales/" || die
	chromium_remove_language_paks
	popd
}

src_install() {
	doicon -s 32 resources/icons/hicolor/32x32/apps/${PN}.png
	doicon -s 64 resources/icons/hicolor/64x64/apps/${PN}.png
	doicon -s 256 resources/icons/hicolor/256x256/apps/${PN}.png
	doicon -s 512 resources/icons/hicolor/512x512/apps/${PN}.png

	# Install desktop file
	domenu resources/${PN}.desktop

	if use policykit; then
		# Install system unlock policykit file
		insinto /usr/share/polkit-1/actions/
		doins "com.${PN}.${PN^^[p]}.policy" || die
	fi

	# Install custom browser integration sample
	insinto /usr/share/${PN^^[p]}/examples/
	doins resources/custom_allowed_browsers || die

	exeinto ${DESTDIR}
	doexe ${PN} ${PN^^[p]}-BrowserSupport ${PN^^[p]}-KeyringHelper chrome-sandbox chrome_crashpad_handler libEGL.so libffmpeg.so libGLESv2.so libvk_swiftshader.so libvulkan.so.1

	insinto ${DESTDIR}
	doins chrome_100_percent.pak chrome_200_percent.pak icudtl.dat resources.pak snapshot_blob.bin v8_context_snapshot.bin vk_swiftshader_icd.json
	insopts -m0755
	doins -r locales resources swiftshader

	# chrome-sandbox requires the setuid bit to be specifically set.
	# See https://github.com/electron/electron/issues/17972
	fperms 4755 ${DESTDIR}/chrome-sandbox || die

	# Setup the Core App Integration helper binary with the correct permissions and group
	fowners :onepassword ${DESTDIR}/${PN^^[p]}-KeyringHelper || die
	fperms u+s ${DESTDIR}/${PN^^[p]}-KeyringHelper || die
	fperms g+s ${DESTDIR}/${PN^^[p]}-KeyringHelper || die
	fowners :onepassword ${DESTDIR}/${PN^^[p]}-BrowserSupport || die
	fperms g+s ${DESTDIR}/${PN^^[p]}-BrowserSupport || die

	pax-mark m ${DESTDIR}/${PN} || die "could not set proper PAX permissions"

	dosym ${DESTDIR}/${PN} /usr/bin/${PN} || die

	dodir ${DESTDIR}
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
