CURR_USER=$1
CURR_HOME=/home/$CURR_USER
useradd -ms /bin/bash $CURR_USER
mkdir -p $CURR_HOME
chown -R $CURR_USER:$CURR_USER $CURR_HOME
cd $CURR_HOME
if [ -f ${CURR_HOME}/.vscode/extensions ];then
    rm -f ${CURR_HOME}/.vscode/extensions
    su $CURR_USER -c "ln -s /usr/share/extensions ${CURR_HOME}/.vscode/"
fi
if [ -d ${CURR_HOME}/.vscode/extensions ];then
    rm -rf ${CURR_HOME}/.vscode/extensions
    su $CURR_USER -c "ln -s /usr/share/extensions ${CURR_HOME}/.vscode/"
fi
su $CURR_USER