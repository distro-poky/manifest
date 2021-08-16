Distribution Manifests
===

Layer captures repo manifests for distro-poky,
Layer captures Yocto meta-data for distro-poky specialization

## Setup Host

Install prerequsite dependencies for host,
[Yocto Documentation](https://docs.yoctoproject.org/),
[Quick Build Documentation](https://docs.yoctoproject.org/brief-yoctoprojectqs/index.html)

### SSH Keys

Setup ssh keys,
Upload to [Gitlab Profile](https://gitlab.com/-/profile/keys),
Verify information specific to profile

```sh
$ mkdir -p ~/.ssh && chmod 700 ~/.ssh
$ ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/id_rsa-gitlab -C userid@users.noreply.gitlab.com
```

Setup ssh config at ~/.ssh/config,
Create file or append to existing config

```
Host gitlab.com
 User git
 IdentityFile ~/.ssh/id_rsa-gitlab
```

Test ssh connectivity

```sh
$ ssh gitlab.com
Welcome to GitLab, @userid!
Connection to gitlab.com closed.
```

### PGP Certificates

Setup pgp keys,
Upload to [Gitlab Profile](https://gitlab.com/-/profile/gpg_keys),
Verify information specific to profile

- Please select what kind of key you want: **1**
- What keysize do you want? (2048) **4096**
- Key is valid for? (0) **0**
- Is this correct? (y/N) **y**
- Real name: **FirstName LastName**
- Email address: **userid@users.noreply.gitlab.com**
- Comment: **Gitlab Signature**

```sh
$ gpg --full-gen-key
$ gpg --list-secret-keys --keyid-format LONG userid@users.noreply.gitlab.com
$ gpg --armor --export <key_id>
```

### GIT Settings

Download and setup git-repo tool

```sh
$ mkdir -p ~/bin
$ curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
$ chmod a+rx ~/bin/repo
```

Setup git username and email,
Verify information specific to profile

```sh
$ git config --global user.name "FirstName LastName"
$ git config --global user.email "userid@users.noreply.gitlab.com"
```

Setup git use of a proxy

```sh
git config --global http.proxy http://username:password@proxy_server.com:port
```

Setup git insteadOf for git:// access to specific domains, firewalls, etc.

```sh
$ git config --global url."https://github.com".insteadOf git://github.com
$ git config --global url."https://github.com".insteadOf gitsm://github.com
$ git config --global url."https://code.qt.io".insteadOf git://code.qt.io
$ git config --global url."https://git.ti.com/git".insteadOf git://git.ti.com
$ git config --global url."https://git.kernel.org/".insteadOf git://git.kernel.org/
$ git config --global url."https://git.code.sf.net/p/".insteadOf git://git.code.sf.net/p/
```

Enable signing git of commits

```sh
$ git config --global user.signingkey <key_id>
$ git config --global gpg.program gpg
```

## Yocto Build

Synchronize with a manifest,
The manifests are setup to use SSH credentials

```sh
$ PATH=~/bin:${PATH}
$ mkdir ~/gitlab/distro-poky && cd ~/gitlab/distro-poky
$ repo init -u ssh://gitlab.com/distro-poky/manifest -m MANIFEST.xml
$ repo sync --no-clone-bundle
```

<!-- development builds
repo init -u remote/branch
repo sync
-->

<!-- production builds
repo init -u remote/branch
cp static.xml .repo/manifests
repo sync -m static.xml
-->

Available manifests,
Download command example,
Build command example.

| MACHINE | Build Environment Commands |
| --- | --- |
| help | . ./setup-environment --help  |
| clean | bitbake -c cleanall package |
| __imx8qm-var-som__ | MACHINE=imx8qm-var-som DISTRO=poky . ./setup-environment build-1 |
| fetch | bitbake core-image-sato --runall=fetch |
| sdk | bitbake core-image-sato -c populate_sdk |
| build | bitbake core-image-sato |
| build | bitbake core-image-full-cmdline |
| __intel-corei7-64__ | MACHINE=intel-corei7-64 DISTRO=poky . ./setup-environment build-2 |
| fetch | bitbake core-image-sato --runall=fetch |
| sdk | bitbake core-image-sato -c populate_sdk |
| build | bitbake core-image-sato |
| build | bitbake core-image-full-cmdline |
| __imx8qm-var-som__ | MACHINE=imx8qm-var-som DISTRO=fslc-xwayland . ./setup-environment build-3 |
| fetch | bitbake fsl-image-gui --runall=fetch |
| build | bitbake fsl-image-gui |
| fetch | bitbake fsl-image-qt5 --runall=fetch |
| sdk | bitbake fsl-image-qt5 -c populate_sdk |
| build | bitbake fsl-image-qt5 |
| build | bitbake fsl-image-qt5 |
| __aaeon-bt06__ | MACHINE=aaeon-bt06 DISTRO=foss-base . ./setup-environment build-4 |
| fetch | bitbake core-image-sato --runall=fetch |
| sdk | bitbake core-image-sato -c populate_sdk |
| build | bitbake core-image-sato |
| build | bitbake core-image-full-cmdline |
| __adlink-cexpress-bl__ | MACHINE=adlink-cexpress-bl DISTRO=foss-base . ./setup-environment build-5 |
| fetch | bitbake core-image-sato --runall=fetch |
| sdk | bitbake core-image-sato -c populate_sdk |
| build | bitbake core-image-sato |
| build | bitbake core-image-full-cmdline |
| __varascite-var-som-mx8__ | MACHINE=varascite-var-som-mx8 DISTRO=foss-base . ./setup-environment build-6 |
| fetch | bitbake core-image-sato --runall=fetch |
| sdk | bitbake core-image-sato -c populate_sdk |
| build | bitbake core-image-sato |
| build | bitbake core-image-full-cmdline |

## Notes

### network-proxy

Utilization of a network proxy (squid) in a CI/CD build environment can
be used to cache and speed up large file fetchs that are repetitive.

```sh
export http_proxy="http://proxy:3128/"
export https_proxy="https://proxy:3128/"
export ftp_proxy="http://proxy:3128/"
export no_proxy="local.domain"
```

### TOOLCHAIN=gcc

Toolchain override is performed by dynamic-layers; a dynamic layer is created named
for the layer with the package that fails to build with clang. See base/meta/conf/layer.conf
for the existing pattern.
