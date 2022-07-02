#
if [ -n "$BASH_VERSION" ]; then

    if [ -f "$HOME/.bashrc" ]; then

	source "$HOME/.bashrc"

    fi

fi

#
if [ -d "$HOME/suap/.local/bin" ] ; then

    PATH="$HOME/suap/.local/bin:$PATH"

fi

#
if [ -f "$HOME/suap/.vscode/password.sh" ] ; then

    source $HOME/suap/.vscode/password.sh

fi

#
if [ -f "$HOME/suap/.env/bin/activate" ] ; then

    source $HOME/suap/.env/bin/activate

    cd $HOME/suap

fi

#
export PGHOST=suap-sql
export PGUSER=postgres
export PGPASSWORD=postgres
