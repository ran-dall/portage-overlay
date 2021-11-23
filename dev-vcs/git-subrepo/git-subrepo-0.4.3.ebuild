# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Git Submodule Alternative"
HOMEPAGE="https://github.com/ingydotnet/${PN}/"
EGIT_REPO_URI="https://github.com/ingydotnet/${PN}.git"
EGIT_BRANCH="release/${PV}"

LICENSE="MIT"
SLOT="0"
IUSE="doc"
KEYWORDS="~amd64"
RESTRICT="strip test"

DEPEND="app-shells/bash:*
	dev-vcs/git
	dev-libs/bashplus
	dev-libs/test-more-bash
"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	# remove packaged external dependencies
	rm -r ext
	# docker-based testing is not supported
	rm -r test
	# remove License
	rm License
	# remove unneeded package metadata
	rm Meta
	# remove unused Makefile
	rm Makefile
	# remove incorrect symlink
	unlink lib/${PN}.d/bash+.bash || die
}

src_install() {
	exeinto /usr/libexec/git-core
	doexe lib/${PN} || die
	insinto /usr/libexec/git-core
	doins -r lib/${PN}.d

	dosym /"${ED}/lib/bash+.bash" /usr/libexec/git-core/${PN}.d/bash+.bash || die

	insinto /usr/share
	doins share/completion.bash share/enable-completion.sh share/git-completion.bash
	insinto /usr/share/zsh-completion
	doins share/zsh-completion/_${PN}
	insinto /usr/share/${PN}
	doins .rc .fish.rc

	doman man/man1/${PN}.1

	insinto /usr/share/${PN}
	doins ReadMe.pod Intro.pod Changes
	insinto /usr/share/${PN}/doc
	doins doc/comparison.swim doc/${PN}.swim doc/intro-to-subrepo.swim

	if use doc; then
		insinto /usr/share/${PN}/note
		dodoc -r note
	fi
}
