# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=${PN%-beta}
MY_PV=${MY_PN}-$(ver_rs 3-4 -).BETA

CHROMIUM_LANGS="
	am ar bg bn ca cs da de el en-GB en-US es es-419 et fa fi fil fr gu he hi
	hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr sv
	sw ta te th tr uk vi zh-CN zh-TW
"

inherit chromium-2 desktop pax-utils

DESCRIPTION="${MY_PN^^[p]} password manager and secure wallet - BETA"
HOMEPAGE="https://support.${MY_PN}.com/betas/"
SRC_URI="https://downloads.${MY_PN}.com/linux/tar/beta/x86_64/${MY_PV}.x64.tar.gz"

SLOT="0"
LICENSE="1Password-TOS"
IUSE="policykit"
RESTRICT="bindist mirror strip test"
KEYWORDS="~amd64"

DEPEND="!!app-admin/1password
	>=sys-libs/glibc-2.28
	x11-themes/hicolor-icon-theme
	x11-libs/gtk+:*
	dev-libs/nss
"
RDEPEND="policykit? ( sys-auth/polkit )
	acct-group/onepassword
	${DEPEND}
"

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

S="${WORKDIR}/${MY_PV}.x64"

DESTDIR="/opt/${MY_PN^^[p]}"

src_unpack() {
	unpack "${MY_PV}.x64.tar.gz" || die
}

src_prepare() {
	default

	rm after-install.sh
	rm after-remove.sh
	rm install_biometrics_policy.sh

	pushd "locales/" || die
	chromium_remove_language_paks
	popd
}

src_install() {
	doicon -s 32 resources/icons/hicolor/32x32/apps/${MY_PN}.png
	doicon -s 64 resources/icons/hicolor/64x64/apps/${MY_PN}.png
	doicon -s 256 resources/icons/hicolor/256x256/apps/${MY_PN}.png
	doicon -s 512 resources/icons/hicolor/512x512/apps/${MY_PN}.png

	# Install desktop file
	domenu resources/${MY_PN}.desktop

	if use policykit; then
	# Install system unlock policykit file
	insinto /usr/share/polkit-1/actions/
	doins com.${MY_PN}.${MY_PN^^[p]}.policy || die
	fi

	# Install custom browser integration sample
	insinto /usr/share/${MY_PN^^[p]}/examples/
	doins resources/custom_allowed_browsers || die

	exeinto ${DESTDIR}
	doexe ${MY_PN} ${MY_PN^^[p]}-BrowserSupport ${MY_PN^^[p]}-KeyringHelper chrome-sandbox chrome_crashpad_handler libEGL.so libffmpeg.so libGLESv2.so libvk_swiftshader.so libvulkan.so.1

	insinto ${DESTDIR}
	doins chrome_100_percent.pak chrome_200_percent.pak icudtl.dat resources.pak snapshot_blob.bin v8_context_snapshot.bin vk_swiftshader_icd.json
	insopts -m0755
	doins -r locales resources swiftshader

	# chrome-sandbox requires the setuid bit to be specifically set.
	# See https://github.com/electron/electron/issues/17972
	fperms 4755 ${DESTDIR}/chrome-sandbox || die

	# Setup the Core App Integration helper binary with the correct permissions and group
	fowners :onepassword ${DESTDIR}/${MY_PN^^[p]}-KeyringHelper || die
	fperms u+s ${DESTDIR}/${MY_PN^^[p]}-KeyringHelper || die
	fperms g+s ${DESTDIR}/${MY_PN^^[p]}-KeyringHelper || die
	fowners :onepassword ${DESTDIR}/${MY_PN^^[p]}-BrowserSupport || die
	fperms g+s ${DESTDIR}/${MY_PN^^[p]}-BrowserSupport || die

	pax-mark m ${DESTDIR}/${MY_PN} || die

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
