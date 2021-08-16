#!/bin/bash

[[ -z "${BITBAKE_DISTRO}" ]] && export BITBAKE_DISTRO=poky
[[ -z "${BITBAKE_MACHINE}" ]] && export BITBAKE_MACHINE=qemux86-64
[[ -z "${BITBAKE_TARGET}" ]] && export BITBAKE_TARGET=core-image-full-cmdline

[[ -z "${CI_COMMIT_BRANCH}" ]] && export CI_COMMIT_BRANCH=master
[[ -z "${CI_COMMIT_REF_SLUG}" ]] && export CI_COMMIT_REF_SLUG=master
[[ -z "${CI_COMMIT_SHA}" ]] && export CI_COMMIT_SHA=0000000000000000000000000000000000000000

MACHINE=${BITBAKE_MACHINE} DISTRO=${BITBAKE_DISTRO} . $(pwd)/setup-environment ${CI_COMMIT_REF_SLUG}

bitbake ${BITBAKE_TARGET} | tee -a bitbake-build.log

exit 0
