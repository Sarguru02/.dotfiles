#!/usr/bin/env zsh
set -euo pipefail

volume_step=2
POSITION=0

run(){
    if ! pgrep $1 ;
  then
    $@&
  fi
}

add(){
    TYPE="all\nalbum\nany\nartist\ncomment\ncomposer\ndate\ndisc\nfilename\ngenre\nname\nperformer\ntitle\ntrack"
    TYPE=$(echo "$TYPE" | rofi -dmenu -i -p "Search by")
    if [ "$TYPE" =  "all" ];
    then
	mpc add /
    else
	CHOICE=$(mpc list $TYPE | rofi -dmenu -i -p "Search")
	mpc findadd $TYPE $CHOICE
    fi
    mpc toggle;
    add;
}

delete(){
    SONG=$(mpc playlist -f "%position% %artist%-%title%" | rofi -dmenu -p "Songs")
	INDEX=$(echo $SONG | cut -d " " -f1)
    mpc del $INDEX;
    delete;
}


getVolume(){
    VOLUME="$(mpc volume | grep -Po 'volume: *\K[0-9]*')";
}

volumeUp(){
    getVolume;
    if [ "$((VOLUME + volume_step))" -ge "100" ];
    then
	mpc volume 100;
    else
	mpc volume $((VOLUME + volume_step));
    fi
}


volumeDown(){
    getVolume;
    if [ "$((VOLUME - volume_step))" -le "0" ];
    then
	mpc volume 0;
    else
	mpc volume $((VOLUME - volume_step));
    fi
}

volume(){
    OPTION=$(mpc status | grep -Po "volume: *[0-9]*%")
    OPTION=$(echo "$OPTION\nincrease\ndecrease" | rofi -dmenu -format 'i' -i -p "Volume" -selected-row $POSITION)
    if [ "$OPTION" = "0" ];
    then
       VALUE=$(rofi -dmenu -i -p "Set to")
       while [ $VALUE -gt 100 && $VALUE -lt 0]
       do
	   VALUE=$(rofi -dmenu -i -p "Invalid: 0 - 100 only")
       done
       mpc volume $VALUE
    elif [ "$OPTION" = "1" ];
    then
	 volumeUp;
	 POSITION=1
	 volume;
    elif [ "$OPTION" = "2" ];
    then
	 volumeDown;
	 POSITION=2
	 volume;
    fi
}
mainMenu(){
    CURRENT="$(mpc current)"
    ACTIONS="add\ndelete\nclear"
    OPTIONS="$(mpc status | grep -Po "volume: *[0-9]*%")\n$(mpc status | grep -Po "repeat: [a-z]*")\n$(mpc status | grep -Po "random: [a-z]*")\n$(mpc status | grep -Po "single: [a-z]*")\n$(mpc status | grep -Po "consume: [a-z]*")"
    CHOICE="$(echo "$CURRENT\n--------------------------\n$OPTIONS\n--------------------------\n$ACTIONS" | rofi -dmenu -p "mpc")"
    if [ "$CHOICE" = "$CURRENT" ];
    then
	mpc toggle;
    elif echo "$CHOICE" | grep -Po "volume: *[0-9]*%";
    then
	volume;
    elif echo "$CHOICE" | grep "repeat: ";
    then
	mpc repeat;
	mainMenu;
    elif echo "$CHOICE" | grep "random: ";
    then
	mpc random;
	mainMenu;
    elif echo "$CHOICE" | grep "single: ";
    then
	mpc single;
	mainMenu;
    elif echo "$CHOICE" | grep "consume: ";
    then
	mpc consume;
	mainMenu;
    elif echo "$CHOICE" | grep "^add$";
    then
	add;
    elif echo "$CHOICE" | grep "^delete$";
    then
	delete;
    elif echo "$CHOICE" | grep "^clear$";
    then
	mpc clear;
    fi
}
mainMenu
