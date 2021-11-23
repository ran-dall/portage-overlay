# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Test::More - TAP Testing for Bash"
HOMEPAGE="https://github.com/ingydotnet/${PN}/"
EGIT_REPO_URI="https://github.com/ingydotnet/${PN}.git"
EGIT_COMMIT="${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="strip test"

DEPEND="app-shells/bash:*
	dev-libs/bashplus
	dev-libs/test-tap-bash
"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	# remove packaged external dependencies
	rm -r ext
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
	insinto /lib/test
	doins -r lib/test/more.bash

	doman man/man3/${PN%-bash}.3

	insinto /usr/share/${PN}
	dodoc ReadMe.pod Changes
	insinto /usr/share/${PN}/doc
	dodoc doc/test-more.swim
}
