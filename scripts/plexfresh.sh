#!/bin/bash

stop_plex() {
    echo "Stopping Plex"
    /usr/bin/app-plex stop
    echo "Plex Stopped"
    sleep 10
}

preserve_old_directory() {
    echo "Preserving the old Plex directory"
    if [ -d ~/.config/plex ]; then
        mv -v ~/.config/plex ~/.config/plex.bak
        if [ -d ~/.config/plex.bak ]; then
            echo "The plex directory has been moved to plex.bak"
        else
            echo "Error: The plex directory could not be moved"
        fi
    else
        echo "Error: The plex directory does not exist"
    fi
    sleep 5
}

uninstall_plex() {
    echo "Uninstalling the Plex container"
    /usr/bin/app-plex uninstall
    echo "Plex Uninstalled"
    sleep 10
}

install_plex() {
    echo "Installing Plex container. Get a valid Plex token from plex.tv/claim"
    sleep 10
    read -p "Please enter a valid claim code: " claim_data
    if /usr/bin/app-plex install -c "$claim_data" | grep -q false; then
        echo "Installation failed. Continue manually!"
        exit 1
    else
        echo "Installation successful"
    fi
    sleep 5
}

remove_new_preferences_and_database() {
    echo "Removing newly installed Preferences and Database"
    rm -f ~/.config/plex/Library/Application\ Support/Plex\ Media\ Server/Preferences.xml
    rm -rf ~/.config/plex/Library/Application\ Support/Plex\ Media\ Server/Plug-in Support/Databases
    echo "DONE"
}

copy_old_database_and_preferences() {
    echo "Copying over customers old Database and Preferences"
    cp -ar ~/.config/plex.bak/Library/Application\ Support/Plex\ Media\ Server/Plug-in\ Support/Databases ~/.config/plex/Library/Application\ Support/Plex\ Media\ Server/Plug-in\ Support/

    if [ $? -eq 0 ]; then
        echo "The Databases directory has been copied successfully"
    else
        echo "Error: The Databases directory could not be copied"
    fi

    cp -a ~/.config/plex.bak/Library/Application\ Support/Plex\ Media\ Server/Preferences.xml ~/.config/plex/Library/Application\ Support/Plex\ Media\ Server/
    echo "Preferences.xml copied successfully"
}

restart_plex() {
    echo "Restarting Plex"
    /usr/bin/app-plex restart
    echo "Plex Restarted! All done!"
}

# Main
stop_plex
preserve_old_directory
uninstall_plex
install_plex
stop_plex
remove_new_preferences_and_database
copy_old_database_and_preferences
restart_plex
