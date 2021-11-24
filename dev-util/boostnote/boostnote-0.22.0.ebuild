# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN^^[b,n]}"
MY_PN_SPACE="${MY_PN//tN/t N}"
MY_PN_NEXT="${PN}.next"

CHROMIUM_LANGS="
	am ar bg bn ca cs da de el en-GB en-US es es-419 et fa fi fil fr gu he hi
	hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr sv
	sw ta te th tr uk vi zh-CN zh-TW
"

inherit chromium-2 desktop pax-utils unpacker

DESCRIPTION="A powerful, lightspeed collaborative workspace for developer teams"
HOMEPAGE="https://${PN}.io/"
SRC_URI="https://github.com/BoostIO/${MY_PV}-App/releases/download/v${PV}/${PN//tn/t-n}-linux.deb"

LICENSE="Boost-Note"
IUSE="doc"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"

RESTRICT="bindist mirror strip test"

QA_PREBUILT="${DESTDIR}/${PN}
	${DESTDIR}/chrome-sandbox
	${DESTDIR}/libEGL.so
	${DESTDIR}/libffmpeg.so
	${DESTDIR}/libGLESv2.so
	${DESTDIR}/libvk_swiftshader.so
	${DESTDIR}libvulkan.so.1
"

S="${WORKDIR}"

DESTDIR="/opt/BoostNote"

src_unpack() {
	unpack_deb ${PN/tn/t-n}-linux.deb || die
}

src_prepare() {
	default

	pushd "opt/${MY_PN_SPACE}"
	rm LICENSE.electron.txt
	rm LICENSES.chromium.html
	popd

	pushd "opt/${MY_PN_SPACE}/locales/" || die
	chromium_remove_language_paks
	popd
}

src_install() {
	pushd "usr/share/"
	doicon -s 16 icons/hicolor/16x16/apps/${MY_PN_NEXT}.png
	doicon -s 32 icons/hicolor/32x32/apps/${MY_PN_NEXT}.png
	doicon -s 48 icons/hicolor/48x48/apps/${MY_PN_NEXT}.png
	doicon -s 64 icons/hicolor/64x64/apps/${MY_PN_NEXT}.png
	doicon -s 128 icons/hicolor/128x128/apps/${MY_PN_NEXT}.png
	doicon -s 256 icons/hicolor/256x256/apps/${MY_PN_NEXT}.png
	doicon -s 512 icons/hicolor/512x512/apps/${MY_PN_NEXT}.png
#	doicon -s 1024 icons/hicolor/1024x1024/apps/${MY_PN_NEXT}.png

	# Install desktop files
	domenu applications/${MY_PN_NEXT}.desktop

	if use doc; then
		dodir doc/${MY_PN_NEXT}
	fi
	popd

	pushd "opt/${MY_PN_SPACE}/"
	exeinto ${DESTDIR}
	doexe ${MY_PN_NEXT} chrome-sandbox libEGL.so libffmpeg.so libGLESv2.so  libvk_swiftshader.so libvulkan.so.1

	insinto ${DESTDIR}
	doins chrome_100_percent.pak chrome_200_percent.pak icudtl.dat resources.pak snapshot_blob.bin v8_context_snapshot.bin vk_swiftshader_icd.json
	insopts -m0755
	doins -r locales resources swiftshader
	popd

	# chrome-sandbox requires the setuid bit to be specifically set.
	# See https://github.com/electron/electron/issues/17972
	fperms 4755 "${DESTDIR}/chrome-sandbox" || die

	pax-mark m ${DESTDIR}/${MY_PN_NEXT} || die "could not set proper PAX permissions"

	dosym ${DESTDIR}/${MY_PN_NEXT} /usr/bin/${MY_PN_NEXT} || die

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
