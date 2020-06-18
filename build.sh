#!/bin/bash

###
###
###
###

# SANITY CHECKS
if [[ -z $GitHubMail ]]; then echo -e "You haven't configured GitHub E-Mail Address." && exit 1; fi
if [[ -z $GitHubName ]]; then echo -e "You haven't configured GitHub Username." && exit 1; fi
if [[ -z $GITHUB_TOKEN ]]; then echo -e "You haven't configured GitHub Token.\nWithout it, recovery can't be published." && exit 1; fi
if [[ -z $MANIFEST_BRANCH ]]; then echo -e "You haven't configured PitchBlack Recovery Project Manifest Branch." && exit 1; fi
if [[ -z $VENDOR ]]; then echo -e "You haven't configured Vendor name." && exit 1; fi
if [[ -z $CODENAME ]]; then echo -e "You haven't configured Device Codename." && exit 1; fi
if [[ -z $BUILD_LUNCH ]] && [[ -z $FLAVOR ]]; then echo -e "Set at least one variable. BUILD_LUNCH or FLAVOR." && exit 1; fi

# Set GitAuth Infos"
git config --global user.email $GitHubMail
git config --global user.name $GitHubName
git config --global credential.helper store
git config --global color.ui true

echo -e "Starting the CI Build Process...\n"

DIR=$(pwd)
mkdir $(pwd)/work && cd work

echo -e "Initializing repo sync..."
git clone https://github.com/shovon668/android_kernel_realme_sm6150
mv android_kernel_realme_sm6150 x2
cd x2
git clone https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86
mv linux-x86 tc
export CROSS_COMPILE=$(pwd)/tc/bin/aarch64-linux-android-
export ARCH=arm64 && export SUBARCH=arm64
make x2-defconfig
make -j$(nproc --all)
echo -e "\n\nAll Done Gracefully\n\n"
