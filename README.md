# CPUPerProcess


# When would I use this script?
In cases when a customer complains that there are CPU spikes but they can't be reproduced on the spot.

# How to use it?

You may configure the location where the log will be saved (line 2) and the CPU threshold (line 5).

Then run the file or script. Make sure to run as Administrator as it is necessary in order to receive the Command line arguments for the listed processes.

# What's the result of running the script?
The script will create a text file that will have a table with the following columns: InstanceName (which is the process name), CPU%, PID, ProcessPath (like the Command line in Task Manager > Details tab)
