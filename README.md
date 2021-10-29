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
