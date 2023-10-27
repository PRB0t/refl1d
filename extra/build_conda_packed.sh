#!/bin/bash

ENV_NAME="isolated-base"
PYTHON_VERSION="3.10"
DIRNAME="refl1d"

eval "$(conda shell.bash hook)"
conda activate base || { echo 'failed: conda not installed'; exit 1; }

conda install -y conda-pack
conda create -n "$ENV_NAME" -q --force -y "python=$PYTHON_VERSION"
conda-pack -n "$ENV_NAME" -f -o "$ENV_NAME.tar.gz"

# unpack the new environment, that contains only python + pip
tmpdir=$(mktemp -d)
destdir="$tmpdir/$DIRNAME"
mkdir "$destdir"
tar -xzf "$ENV_NAME.tar.gz" -C "$destdir"

# activate the unpacked environment and install pip packages
conda deactivate
WORKING_DIRECTORY=$(pwd)
# cd "$tmpdir"
$destdir/bin/python -m pip install --no-input numba
$destdir/bin/python -m pip install --no-input git+https://github.com/bumps/bumps@webview
$destdir/bin/python -m pip install --no-input git+https://github.com/reflectometry/refl1d@webview
$destdir/bin/python -m pip install -r https://raw.githubusercontent.com/bumps/bumps/webview/webview-requirements

version=$($destdir/bin/python -c "import refl1d; print(refl1d.__version__)")
mv "$tmpdir/$DIRNAME" "$tmpdir/$DIRNAME-$version"

cd $tmpdir && tar -czf "$WORKING_DIRECTORY/refl1d-webview-$version-$(uname -s)-$(uname -m).tar.gz" "$DIRNAME-$version"
