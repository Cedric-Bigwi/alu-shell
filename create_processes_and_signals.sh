#!/usr/bin/env bash
# This script will auto-generate all required Bash files for the "processes_and_signals" project

mkdir -p processes_and_signals
cd processes_and_signals || exit 1

# 0. What is my PID
cat << 'EOF' > 0-what-is-my-pid
#!/usr/bin/env bash
# Display its own PID
echo "$$"
EOF
chmod +x 0-what-is-my-pid

# 1. List your processes
cat << 'EOF' > 1-list_your_processes
#!/usr/bin/env bash
# Display a list of currently running processes in user-oriented format
ps -eo user,pid,%cpu,%mem,vsz,rss,tty,stat,start,time,command --forest
EOF
chmod +x 1-list_your_processes

# 2. Show your Bash PID
cat << 'EOF' > 2-show_your_bash_pid
#!/usr/bin/env bash
# Display lines containing the word "bash" from running processes
# shellcheck disable=SC2009
ps aux | grep bash
EOF
chmod +x 2-show_your_bash_pid

# 3. Show your Bash PID made easy
cat << 'EOF' > 3-show_your_bash_pid_made_easy
#!/usr/bin/env bash
# Display PID and process name for all bash processes
pgrep -fl bash
EOF
chmod +x 3-show_your_bash_pid_made_easy

# 4. To infinity and beyond
cat << 'EOF' > 4-to_infinity_and_beyond
#!/usr/bin/env bash
# Display "To infinity and beyond" indefinitely with sleep 2
while true
do
  echo "To infinity and beyond"
  sleep 2
done
EOF
chmod +x 4-to_infinity_and_beyond

# 5. Don't stop me now!
cat << 'EOF' > 5-dont_stop_me_now
#!/usr/bin/env bash
# Kill the 4-to_infinity_and_beyond process
pkill -f 4-to_infinity_and_beyond
EOF
chmod +x 5-dont_stop_me_now

# 6. Stop me if you can
cat << 'EOF' > 6-stop_me_if_you_can
#!/usr/bin/env bash
# Kill the 4-to_infinity_and_beyond process without using kill or killall
pkill -f 4-to_infinity_and_beyond
EOF
chmod +x 6-stop_me_if_you_can

# 7. Highlander
cat << 'EOF' > 7-highlander
#!/usr/bin/env bash
# Print message indefinitely and trap SIGTERM signal
trap 'echo "I am invincible!!!"' SIGTERM
while true
do
  echo "To infinity and beyond"
  sleep 2
done
EOF
chmod +x 7-highlander

# 67-stop_me_if_you_can (copy of 6 for Highlander)
cat << 'EOF' > 67-stop_me_if_you_can
#!/usr/bin/env bash
# Kill the 7-highlander process
pkill -f 7-highlander
EOF
chmod +x 67-stop_me_if_you_can

# 8. Beheaded process
cat << 'EOF' > 8-beheaded_process
#!/usr/bin/env bash
# Kill 7-highlander process using SIGKILL
pkill -9 -f 7-highlander
EOF
chmod +x 8-beheaded_process

# 10. Process and PID file
cat << 'EOF' > 10-process_and_pid_file
#!/usr/bin/env bash
# Create pid file, run indefinitely, handle signals

echo "$$" > /var/run/myscript.pid

trap 'echo "I hate the kill command"' SIGTERM
trap 'echo "Y U no love me?!"' SIGINT
trap 'rm -f /var/run/myscript.pid; exit 0' SIGQUIT SIGTERM

while true
do
  echo "To infinity and beyond"
  sleep 2
done
EOF
chmod +x 10-process_and_pid_file

# manage_my_process (helper for 11-manage_my_process)
cat << 'EOF' > manage_my_process
#!/usr/bin/env bash
# Write "I am alive!" to /tmp/my_process indefinitely

while true
do
  echo "I am alive!" >> /tmp/my_process
  sleep 2
done
EOF
chmod +x manage_my_process

# 11-manage_my_process (init script)
cat << 'EOF' > 11-manage_my_process
#!/usr/bin/env bash
# Manage manage_my_process start|stop|restart

case "$1" in
  start)
    ./manage_my_process &
    echo $! > /var/run/my_process.pid
    echo "manage_my_process started"
    ;;
  stop)
    if [ -f /var/run/my_process.pid ]; then
      kill "$(cat /var/run/my_process.pid)"
      rm -f /var/run/my_process.pid
      echo "manage_my_process stopped"
    fi
    ;;
  restart)
    if [ -f /var/run/my_process.pid ]; then
      kill "$(cat /var/run/my_process.pid)"
      rm -f /var/run/my_process.pid
    fi
    ./manage_my_process &
    echo $! > /var/run/my_process.pid
    echo "manage_my_process restarted"
    ;;
  *)
    echo "Usage: manage_my_process {start|stop|restart}"
    exit 1
    ;;
esac
EOF
chmod +x 11-manage_my_process

echo "✅ All files have been generated successfully!"
