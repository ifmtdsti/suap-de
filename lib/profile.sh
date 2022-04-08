#
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

#
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

#
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

#
if [ -f "$HOME/app/.env/bin/activate" ] ; then
    source $HOME/app/.env/bin/activate
    cd $HOME/app
fi

#
if [ -f "$HOME/app/.vscode/password.sh" ] ; then
    source $HOME/app/.vscode/password.sh
fi

#
export PGHOST=suap-sql
export PGUSER=postgres
export PGPASSWORD=postgres
