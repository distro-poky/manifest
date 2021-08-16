#!/bin/bash

[[ -z "${BITBAKE_DISTRO}" ]] && export BITBAKE_DISTRO=poky
[[ -z "${BITBAKE_MACHINE}" ]] && export BITBAKE_MACHINE=qemux86-64
[[ -z "${BITBAKE_TARGET}" ]] && export BITBAKE_TARGET=core-image-full-cmdline

[[ -z "${CI_COMMIT_BRANCH}" ]] && export CI_COMMIT_BRANCH=master
[[ -z "${CI_COMMIT_REF_SLUG}" ]] && export CI_COMMIT_REF_SLUG=master
[[ -z "${CI_COMMIT_SHA}" ]] && export CI_COMMIT_SHA=0000000000000000000000000000000000000000

#repo init --depth=1 --manifest-url ... --manifest-name ...
#repo sync all --no-clone-bundle
#repo forall all -c 'git checkout -B $REPO_RREV $REPO_REMOTE/$REPO_RREV'
#repo manifest --revision-as-HEAD --output-file bitbake-manifest.xml

MACHINE=${BITBAKE_MACHINE} DISTRO=${BITBAKE_DISTRO} . $(pwd)/setup-environment build-${CI_COMMIT_REF_SLUG}

bitbake core-image-full-cmdline --runall=fetch | tee bitbake-build.log

exit 0
