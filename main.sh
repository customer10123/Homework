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

. /usr/share/beakerlib/beakerlib.sh

rlJournalStart
        rlPhaseStartTest
            rlAssertRpm "setup"
            rlAssertExists "/etc/passwd"
            rlAssertGrep "root" "/etc/passwd"
        rlPhaseEnd
rlJournalEnd
