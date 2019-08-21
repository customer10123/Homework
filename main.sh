#!/bin/bash

#Check if script is run as superuser
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

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
# Test phase: Running required tasks
        rlPhaseStartTest
	    #First way to check if you're running Fedora 30 
	    rlIsFedora 30 
	    if [ $? -eq 0 ]; then
		    rlPass "You are running Fedora 30"
	    else
		    rlFail "You are not running Fedora 30"
	    fi
	    #Second way to check if you're running Fedora 30
	    FED30=`cat /etc/fedora-release | grep 30 | wc -l`
	    if [ $FED30 -eq 1 ]; then
		    rlPass "You are running Fedora 30"
            else
		    rlFail "You are not running Fedora 30"
	    fi
	    #Check for lorax-composer. Install if not found.
	    if rlCheckRpm lorax-composer; then
		    rlAssertRpm lorax-composer
	    else
		    yum -y install lorax-composer
		    rlAssertRpm lorax-composer
	    fi
	    #Check if /var/lib/lorax/composer exists
	    rlAssertExists "/var/lib/lorax/composer"
	    #Adding user jenkins
	    rlRun "useradd jenkins" "0,9" "User jenkins was added or already exists"
	    #Checking if user jenkins exists
	    rlRun 'compgen -u | grep jenkins' 0 "User Jenkins exists"
	    #Creating a file Hello.txt with "Hello World".
	    rlRun 'echo "Hello World" >> Hello.txt' 
        rlPhaseEnd

	# Cleanup phase: Remove test directory
        rlPhaseStartCleanup
            rlRun "popd"
            rlRun "rm -r $TmpDir" 0 "Removing tmp directory"
        rlPhaseEnd
rlJournalEnd

# Print the test report
rlJournalPrintText
