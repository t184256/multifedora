#!/bin/bash
set -uexo pipefail

command -v git || dnf install -y git-core
command -v wget || dnf install -y wget

git config --global --add safe.directory $(realpath .)
git_commit=$(git rev-parse HEAD)
version=$(git describe --tags --abbrev=0 | tail -c +2)
release=$(git describe --tags --long | tail -c +2 | sed s/^$version-// | sed s/-/./)

tarball=t184256-multifedora-${git_commit:0:7}.tar.gz
mkdir -p ~/rpmbuild/SOURCES
[ -r ~/rpmbuild/SOURCES/$tarball ] || (
    wget https://github.com/t184256/multifedora/archive/$git_commit/$tarball -O tmp
    mv tmp ~/rpmbuild/SOURCES/$tarball
)

cp .copr/multifedora.template.spec multifedora.spec
sed -i "s|{{ver}}|$version|g" multifedora.spec
sed -i "s|{{rel}}|$release|g" multifedora.spec
sed -i "s|{{tarball}}|$tarball|g" multifedora.spec
sed -i "s|{{git_commit}}|$git_commit|g" multifedora.spec
git log "--format=* %cd %aN <%ae> - %h %n- %s%n" "--date=format:%a %b %d %Y" >> multifedora.spec

rpmbuild -bs multifedora.spec \
    --define "_srcrpmdir $outdir" \
    --define "_sourcedir $HOME/rpmbuild/SOURCES"

rm -f multifedora.spec
