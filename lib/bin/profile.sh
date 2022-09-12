#
if [ -n "$BASH_VERSION" ]; then

    if [ -f "$HOME/.bashrc" ]; then

	source "$HOME/.bashrc"

    fi

fi

#
export PGHOST=$USER-sql
export PGUSER=postgres
export PGPASSWORD=postgres
export PASSWORD=123147

#
if [ -d "$HOME/$USER/.local/bin" ] ; then

    PATH="$HOME/$USER/.local/bin:$PATH"

fi

#
if [ -f "$HOME/$USER/.vscode/password.sh" ] ; then

    source $HOME/$USER/.vscode/password.sh

fi

#
if [ -f "$HOME/$USER/.env/bin/activate" ] ; then

    source $HOME/$USER/.env/bin/activate

    cd $HOME/$USER

fi
