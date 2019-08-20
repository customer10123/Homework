#!/bin/bash

#Check if beakerlib is installed
if [ -f /usr/share/beakerlib/beakerlib.sh ]; then
	echo "Beakerlib is installed."
else
	echo "Beakerlib is not installed, will continue with installation."
	#assuming you are on Fedora you can install using:
	sudo dnf -y copr enable mvadkert/beakerlib-libraries
	sudo dnf -y install beakerlib-libraries
fi

#including beakerlib
. /usr/share/beakerlib/beakerlib.sh

#small example using beakerlib
rlJournalStart
        rlPhaseStartTest
            rlAssertRpm "setup"
            rlAssertExists "/etc/passwd"
            rlAssertGrep "root" "/etc/passwd"
        rlPhaseEnd
rlJournalEnd

#check Fedora version from fedora-release file
FED30=`cat /etc/fedora-release | grep 30 | wc -l` 
if [ -f /etc/fedora-release ]; then
	if [ $FED30 -eq 1 ]; then 
		echo "You are running Fedora 30."
	else
		echo "You are not running Fedora 30."
	fi
else
	echo "You are not using Fedora"
fi	
