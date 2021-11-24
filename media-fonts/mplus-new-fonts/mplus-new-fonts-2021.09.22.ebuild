# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV=${PV//./-}

inherit font git-r3

DESCRIPTION="A font family for everyday use, with over 5,700 Kanjis for Japanese and GP Latin"
HOMEPAGE="https://${PN/-}.github.io/"
EGIT_REPO_URI="https://github.com/coz-m/MPLUS_FONTS.git"
EGIT_COMMIT_DATE="${MY_PV}"
EGIT_CLONE_TYPE="shallow"

LICENSE="OFL"
SLOT="0"
IUSE="doc +otf source ttf"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

REQUIRED_USE="^^ ( otf ttf )"

DEPEND="dev-vcs/git"
RDEPEND="${DEPEND}"

RESTRICT="binchecks fetch mirror strip test"

DOCS=( README.md )
HTML_DOCS=( Mplus2_DESCRIPTION.en_us.html Mplus1_DESCRIPTION.en_us.html Mplus1Code_DESCRIPTION.en_us.html MPlusCodeLatin_DESCRIPTION.en_us.html )

S="${WORKDIR}/${P}"

src_install() {
	use ttf  && { FONT_S="fonts/ttf/"; FONT_SUFFIX="ttf"; }
	use otf  && { FONT_S="fonts/otf/"; FONT_SUFFIX="otf"; }

	font_src_install

	if use source ; then
		insinto /usr/share/doc/${PF}/sources
		doins sources/*
	fi

	if use doc ; then
		einstalldocs
	fi
}
