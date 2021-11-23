# Randall's Portage ⛵ Overlay

**This is my ([@ran-dall](https://randall.network)) Portage ⛵ overlay. Maybe you'll find what you're looking for here, or maybe you'll find something just plain fascinating. 🤯 Who knows? 🤙** ***Anywho, here's what you'll find 🧐 in this repo...***

### 💾 Installation

#### `eselect repository` (coming soon)

##### Install

```shell
# eselect repository enable randall
```

##### Uninstall

```shell
# eselect repository remove randall
```

#### Manual

Add the following to your `/etc/portage/repos.conf`:

```conf
[randall]
location = /var/db/repos/randall
sync-type = git
sync-uri = https://github.com/ran-dall/portage-overlay
auto-sync = yes
```
**🗒️ NOTE: You can also use my GitLab mirror which is kept bidirectionally in sync. Just replace `sync-uri = https://github.com/ran-dall/portage-overlay` with `sync-uri = https://gitlab.com/ran-dall/portage-overlay`**

***👉 FWIW GitHub is slightly faster than GitLab. However, it may greatly depend on your location.***

## Ebuilds
- **[1Password](https://1password.com/downloads/linux/) by [1Password](https://1password.com/)** [v8.4.0]
- [1Password Beta](https://support.1password.com/betas/) by [1Password](https://1password.com/) [v8.4.0-53]
- **[git-subrepo](https://github.com/ingydotnet/git-subrepo) by [Ingy döt Net](http://ingy.net/) [v0.4.3] [v0.4.4 +] [v0.4.5 +]**
- [Bash+](https://github.com/ingydotnet/bashplus) by [Ingy döt Net](http://ingy.net/) [v0.1.0]
- [Test::Tap](https://github.com/ingydotnet/test-tap-bash) by [Ingy döt Net](http://ingy.net/) [v0.0.6]
- [Test::More](https://github.com/ingydotnet/test-more-bash) by [Ingy döt Net](http://ingy.net/) [v0.0.5]
