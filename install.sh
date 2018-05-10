git submodule init
git submodule update --recursive

ROOTDIR=$(pwd)

cd pack/completion/start/LanguageClient
bash ./install.sh
cd "$ROOTDIR"

cd pack/misc/opt/codi
patch -p1 < "$ROOTDIR"/codi_readline.patch
cd "$ROOTDIR"
