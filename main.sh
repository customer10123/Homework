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
	    rlIsFedora 30 
	    if [ $? -eq 0 ]; then
		    rlPass "You are running Fedora 30"
	    else
		    rlFail "You are not running Fedora 30"
	    fi
        rlPhaseEnd
rlJournalEnd

