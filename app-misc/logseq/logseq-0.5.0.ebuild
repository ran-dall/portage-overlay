# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHROMIUM_LANGS="
	am ar bg bn ca cs da de el en-GB en-US es es-419 et fa fi fil fr gu he hi
	hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr sv
	sw ta te th tr uk vi zh-CN zh-TW
"

inherit chromium-2 desktop pax-utils unpacker

DESCRIPTION="A privacy-first, open-source platform for knowledge sharing and management"
HOMEPAGE="https://${PN}.com/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${PV}/${PN}-linux-x64-${PV}.zip"

LICENSE="AGPL-3.0"
IUSE=""
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"

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

S="${WORKDIR}/${PN^^[l]}-linux-x64"

DESTDIR="/opt/${PN}"

src_unpack() {
	unpack_zip ${PN}-linux-x64-${PV}.zip || die
}

src_prepare() {
	default

	rm LICENSE
	rm LICENSES.chromium.html

	pushd "locales/" || die
	chromium_remove_language_paks
	popd
}

src_install() {
	# Install desktop file
	domenu "${FILESDIR}/${PN}"-desktop.desktop
	insinto /usr/share/pixmaps/
	doins resources/app/icons/${PN}.png

	exeinto ${DESTDIR}
	doexe ${PN^^[l]} chrome-sandbox libEGL.so libffmpeg.so libGLESv2.so libvk_swiftshader.so libvulkan.so.1

	insinto ${DESTDIR}
	doins chrome_100_percent.pak chrome_200_percent.pak icudtl.dat resources.pak snapshot_blob.bin v8_context_snapshot.bin vk_swiftshader_icd.json
	insopts -m0755
	doins -r locales resources swiftshader
	doins version

	# chrome-sandbox requires the setuid bit to be specifically set.
	# See https://github.com/electron/electron/issues/17972
	fperms 4755 ${DESTDIR}/chrome-sandbox || die

	pax-mark m "${DESTDIR}/${PN^^[l]}"  || die "could not set proper PAX permissions"

	dosym "${DESTDIR}/${PN^^[l]}" /usr/bin/${PN} || die "could not set symlink to application"

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
