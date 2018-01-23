#!/bin/bash

# Start the freshclam daemon
/usr/bin/freshclam --daemon --config-file=/clamav/etc/freshclam.conf
status=$?
if [ ${status} -ne 0 ]; then
  echo "Failed to start freshclam: $status"
  exit ${status}
fi

# Start the clamd service
/usr/sbin/clamd -c /clamav/etc/scan.conf
status=$?
if [ ${status} -ne 0 ]; then
  echo "Failed to start clamd: $status"
  exit ${status}
fi

/usr/bin/python /app/run.py
status=$?
if [ ${status} -ne 0 ]; then
  echo "Failed to start demo app: $status"
  exit ${status}
fi

# Naive check runs checks once a minute to see if either of the processes exited.
# This illustrates part of the heavy lifting you need to do if you want to run
# more than one service in a container. The container will exit with an error
# if it detects that either of the processes has exited.
# Otherwise it will loop forever, waking up every 60 seconds

while sleep 60; do
  ps aux |grep freshclam |grep -q -v grep
  FRESHCLAM_STATUS=$?
  ps aux |grep clamd |grep -q -v grep
  CLAMD_STATUS=$?
  ps aux |grep '/usr/bin/python /app/run.py' |grep -q -v grep
  APP_STATUS=$?
  # If the greps above find anything, they will exit with 0 status
  # If they are not both 0, then something is wrong
  if [ ${FRESHCLAM_STATUS} -ne 0 -o ${CLAMD_STATUS} -ne 0 -o ${APP_STATUS} -ne 0 ]; then
    echo "One of the processes has already exited."
    exit -1
  fi
done