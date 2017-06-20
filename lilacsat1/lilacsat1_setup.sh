# lilacsat1_setup.txt
# LilacSat-1 Rx Setup for AREG Club Project
# Mark Jessop and David Rowe
# June 2017

# Open a terminal and check you have Ubuntu 16.04

lsb_release -a

# List of packages suggested by gnuradio install instructions

sudo apt-get -y install git swig cmake doxygen build-essential libboost-all-dev libtool libusb-1.0-0 libusb-1.0-0-dev libudev-dev libncurses5-dev libfftw3-bin libfftw3-dev libfftw3-doc libcppunit-1.13-0v5 libcppunit-dev libcppunit-doc ncurses-bin cpufrequtils python-numpy python-numpy-doc python-numpy-dbg python-scipy python-docutils qt4-bin-dbg qt4-default qt4-doc libqt4-dev libqt4-dev-bin python-qt4 python-qt4-dbg python-qt4-dev python-qt4-doc python-qt4-doc libqwt6abi1 libfftw3-bin libfftw3-dev libfftw3-doc ncurses-bin libncurses5 libncurses5-dev libncurses5-dbg libfontconfig1-dev libxrender-dev libpulse-dev swig g++ automake autoconf libtool python-dev libfftw3-dev libcppunit-dev libboost-all-dev libusb-dev libusb-1.0-0-dev fort77 libsdl1.2-dev python-wxgtk3.0 git-core libqt4-dev python-numpy ccache python-opengl libgsl-dev python-cheetah python-mako python-lxml doxygen qt4-default qt4-dev-tools libusb-1.0-0-dev libqwt5-qt4-dev libqwtplot3d-qt4-dev pyqt4-dev-tools python-qwt5-qt4 cmake git-core wget libxi-dev gtk2-engines-pixbuf r-base-dev python-tk liborc-0.4-0 liborc-0.4-dev libasound2-dev python-gtk2 libzmq-dev libzmq1 python-requests python-sphinx libcomedi-dev python-zmq

# Setup pybombs, which handles the gnuradio installation

sudo easy_install -U pip
sudo pip install construct pybombs

# Building gnuradio - takes some time

cd ~
mkdir prefix
pybombs recipes add gr-recipes git+https://github.com/gnuradio/gr-recipes.git
pybombs recipes add gr-etcetera git+https://github.com/gnuradio/gr-etcetera.git
pybombs prefix init -a default prefix/default/ -R gnuradio-default

# Add gpredict-daily PPA and install (we want the latest version)

sudo add-apt-repository ppa:gpredict-team/daily
sudo apt-get update
sudo apt-get install gpredict

# Install gqrx

sudo pybombs install gqrx 

# Install libfec, which gr-satellites needs.  This is installed outside
# of pybombs ~/prefix/default environment

git clone https://github.com/daniestevez/libfec.git
cd libfec && ./configure && make && sudo make install && cd ..

# Hopefully by now we have everything needed to compile gr-satellites
# Note magic cmake command to set path that cost my 3 hours of my life
# that I want back

cd prefix/default/
source setup_env.sh
cd src
git clone https://github.com/daniestevez/gr-satellites.git
cd gr-satellites && mkdir build_linux && cd build_linux
cmake -DCMAKE_INSTALL_PREFIX=$PYBOMBS_PREFIX ..
cd ..
./compile_hierarchical.sh

# OK now ready to run everything, back to REAME.txt
