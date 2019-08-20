#!/bin/bash

#Check if beakerlib is installed
if [ -f /usr/share/beakerlib/beakerlib.sh ]; then
	echo "Beakerlib is installed."
else
	echo "Beakerlib is not installed, will continue with installation."
	#assuming you are on Fedora you can install using:
	dnf -y copr enable mvadkert/beakerlib-libraries
	dnf -y install beakerlib-libraries
fi

#including beakerlib
. /usr/share/beakerlib/beakerlib.sh

rlJournalStart
# Setup phase: Prepare test directory
        rlPhaseStartSetup
            rlRun 'TmpDir=$(mktemp -d)' 0 'Creating tmp directory'
            rlRun "pushd $TmpDir"
        rlPhaseEnd

        rlPhaseStartTest
	    rlIsFedora 30 
	    if [ $? -eq 0 ]; then
		    rlPass "You are running Fedora 30"
	    else
		    rlFail "You are not running Fedora 30"
	    fi
	    if [ rlCheckRpm lorax-composer ]; then
		    rlAssertRpm lorax-composer
	    else
		    yum install lorax-composer
		    rlAssertRpm lorax-composer
	    fi
	    rlAssertExists "/var/lib/lorax/composer"
        rlPhaseEnd

	# Cleanup phase: Remove test directory
        rlPhaseStartCleanup
            rlRun "popd"
            rlRun "rm -r $TmpDir" 0 "Removing tmp directory"
        rlPhaseEnd
rlJournalEnd

# Print the test report
rlJournalPrintText
