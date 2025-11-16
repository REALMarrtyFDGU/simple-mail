echo 'Installer Version: betainstaller1'
echo 'Installs: beta1'
sudo apt-get install zenity
cd ~
FETCH="https://raw.githubusercontent.com/REALMarrtyFDGU/simple-mail/refs/heads/main"
FNAME=".simmailservice"
cd ~
if [ ! -d "$FNAME" ]; then
    mkdir -p "$FNAME"
else
    echo "Directory $FNAME already exists. Ignored mkdir"
fi
cd $FNAME
if [ ! -f "icon.png" ]; then
    wget $FETCH'/mail-icon-placeholder-temp.png'
    mv "mail-icon-placeholder-temp.png" "icon.png"
else
    echo "File icon.png already exists. Ignored wget"
fi
if zenity --info --text='Welcome to the Simple Mail installer' --ok-label='Install' --extra-button='Abort'; then
    echo ""
else
    echo "Install Aborted"
    exit 1
fi
if [ ! -d "user" ]; then
    mkdir user
else
    echo "Directory user already exists. Ignored mkdir"
fi
cd user
EID=$(cat email.id)
if cat email.id; then
    echo "Initiating Factory Reset"
    if zenity --question --text='We have discovered an Email-ID ('$EID'), do you want to factory reset?'; then
          cd ~
          rm -rfv $FNAME
          zenity --info --text='Successfully deleted all data. Press OK and restart the installer'
          echo 'Please run ./installer.sh to reinstall'
          exit 1
     else
          echo "Setup closed, if you want to update. Please run the updated installer"
          exit 1
     fi
else
    echo "No user data detected, fowarding the installation process"
fi
NAME=$(zenity --entry --text='Please enter your username')
if [ -z "$NAME" ]; then
    echo "Username blank. Setup aborted"
    exit 1
fi
if echo "$NAME" > name.txt; then
    echo "Username set: $NAME"
else
    echo "Username is not able to set. Setup aborted"
    exit 1
fi
EID=$(zenity --entry --text="Enter Email-ID" --entry-text="$NAME")
if [ -z "$EID" ]; then
     echo "Email-ID blank. Setup aborted"
     exit 1
fi
if echo "$EID" > email.id; then
     echo "Email-ID set as: $EID"
else
     echo "Email-ID is not able to set. Setup aborted"
fi
cd ~/$FNAME
if wget $FETCH'/versions/beta1.sh'; then
     mv 'beta1.sh' 'simmail.sh'
     echo -e "[Desktop Entry]\nType=Application\nVersion=beta1\nName=Simple Mail\nComment=Simple Mail Linux\nPath=~/.simmailservice\nExec=./simmail.sh\nTerminal=false" > ~/.local/share/applications/SimpleMail.desktop
     chmod +x simmail.sh
     chmod +x ~/.local/share/applications/SimpleMail.desktop
else
     echo "An error occured, please check your installer or the servers"
     echo "Hotfix, install the newest version"
fi
