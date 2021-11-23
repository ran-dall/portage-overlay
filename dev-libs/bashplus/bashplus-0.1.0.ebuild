# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=${PN/plus/'+'}

inherit git-r3

DESCRIPTION="${MY_PN}(1) - Modern Bash Programming"
HOMEPAGE="https://github.com/ingydotnet/${PN}/"
EGIT_REPO_URI="https://github.com/ingydotnet/${PN}.git"
EGIT_COMMIT="${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="strip test"

DEPEND="app-shells/bash:*"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	# docker-based testing is not supported
	rm -r test
	# remove Travis CI configuration file
	rm .travis.yml
	# remove License
	rm License
	# remove unneeded package metadata
	rm Meta
	# remove unused Makefile
	rm Makefile
}

src_install() {
	exeinto /usr/bin
	doexe bin/${MY_PN}
	insinto /lib
	insopts -m0755
	doins lib/${MY_PN}.bash

	doman man/man1/${MY_PN}.1
	doman man/man3/${MY_PN}.3

	insinto /usr/share/${PN}
	doins ReadMe.pod Changes
}
