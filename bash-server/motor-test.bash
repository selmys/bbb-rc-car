#!/bin/bash

# GPIO assignments
DRIVE_1=4
DRIVE_2=18
DRIVE_3=8
DRIVE_4=7

# Check user ID (run as sudo if not root)
if test "$UID" -ne 0 ; then
    # We are not root, re-run as root
    echo "Not root, re-running as root"
    sudo $0
    exit 0
fi

# Set up GPIO pins as outputs
echo "$DRIVE_1" > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio${DRIVE_1}/direction
echo "$DRIVE_2" > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio${DRIVE_2}/direction
echo "$DRIVE_3" > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio${DRIVE_3}/direction
echo "$DRIVE_4" > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio${DRIVE_4}/direction

# Display the options to the user as a menu
echo "+-------------------------------+"
echo "|           PicoBorg            |"
echo "+-------------------------------+"
echo "|                               |"
echo "|    1      Toggle drive 1      |"
echo "|    2      Toggle drive 2      |"
echo "|    3      Toggle drive 3      |"
echo "|    4      Toggle drive 4      |"
echo "|    0      All drives off      |"
echo "|                               |"
echo "|    Q      Quit                |"
echo "|                               |"
echo "+-------------------------------+"
echo

# Loop indefinitely
while [ 1 ]; do
    # Get the next user command
    read -sn 1 command                                      # Read the next command from the user (silent mode, 1 character)

    # Process the users command
    case "$command" in
        1)                                                  # If the user pressed 1...
            enabled=`cat /sys/class/gpio/gpio${DRIVE_1}/value`  # Read the current state of drive 1
            if test "$enabled" -eq 0 ; then                     # If it is off...
                echo "1" > /sys/class/gpio/gpio${DRIVE_1}/value     # Turn it on
            else                                                # Otherwise...
                echo "0" > /sys/class/gpio/gpio${DRIVE_1}/value     # Turn it off
            fi            
            ;;
        2)                                                  # If the user pressed 2...
            enabled=`cat /sys/class/gpio/gpio${DRIVE_2}/value`  # Read the current state of drive 2
            if test "$enabled" -eq 0 ; then                     # If it is off...
                echo "1" > /sys/class/gpio/gpio${DRIVE_2}/value     # Turn it on
            else                                                # Otherwise...
                echo "0" > /sys/class/gpio/gpio${DRIVE_2}/value     # Turn it off
            fi            
            ;;
        3)                                                  # If the user pressed 3...
            enabled=`cat /sys/class/gpio/gpio${DRIVE_3}/value`  # Read the current state of drive 3
            if test "$enabled" -eq 0 ; then                     # If it is off...
                echo "1" > /sys/class/gpio/gpio${DRIVE_3}/value     # Turn it on
            else                                                # Otherwise...
                echo "0" > /sys/class/gpio/gpio${DRIVE_3}/value     # Turn it off
            fi            
            ;;
        4)                                                  # If the user pressed 4...
            enabled=`cat /sys/class/gpio/gpio${DRIVE_4}/value`  # Read the current state of drive 4
            if test "$enabled" -eq 0 ; then                     # If it is off...
                echo "1" > /sys/class/gpio/gpio${DRIVE_4}/value     # Turn it on
            else                                                # Otherwise...
                echo "0" > /sys/class/gpio/gpio${DRIVE_4}/value     # Turn it off
            fi            
            ;;
        0)                                                  # If the user pressed 0...
            # Set all drives off
            echo "0" > /sys/class/gpio/gpio${DRIVE_1}/value
            echo "0" > /sys/class/gpio/gpio${DRIVE_2}/value
            echo "0" > /sys/class/gpio/gpio${DRIVE_3}/value
            echo "0" > /sys/class/gpio/gpio${DRIVE_4}/value
            ;;
        q|Q)                                                # If the user pressed Q...
            # Release GPIO pins
            echo "$DRIVE_1" > /sys/class/gpio/unexport
            echo "$DRIVE_2" > /sys/class/gpio/unexport
            echo "$DRIVE_3" > /sys/class/gpio/unexport
            echo "$DRIVE_4" > /sys/class/gpio/unexport
            # Exit script
            exit 0                                  
            ;;
        *)                                                  # If the user pressed anything else
            echo "Unknown option '${command}'"                  # Print an error message
            ;;
    esac    
done

