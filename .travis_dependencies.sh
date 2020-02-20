#!/bin/sh

ENV_NAME="test-environment"
set -e

conda_create ()
{

    hash -r
    conda config --set always_yes yes --set changeps1 no
    conda update -q conda
    conda config --add channels pypi
    conda info -a
    deps='pip pytest numpy scipy coverage'

    conda create -q -n $ENV_NAME "python=$TRAVIS_PYTHON_VERSION" $deps
    conda update --all
}

src="$HOME/env/miniconda$TRAVIS_PYTHON_VERSION"
if [ ! -d "$src" ]; then
    mkdir -p $HOME/env
    pushd $HOME/env

        # Download miniconda packages
        wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh;

        # Install both environments
        bash miniconda.sh -b -p $src

        export PATH="$src/bin:$PATH"
        conda_create

        source activate $ENV_NAME

        conda install -c conda-forge ffmpeg==4.1
        pip install cffi
        pip install python-coveralls pytest-cov mock
        pip install coverage>=4.4

        source deactivate
    popd
else
    echo "Using cached dependencies"
fi