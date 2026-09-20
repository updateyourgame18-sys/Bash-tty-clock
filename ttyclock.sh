#!/bin/bash
echo "type 'y' to enable tty-clock press enter to quit and type 'd' to disable tty-clock"
read -r -p "y/n/d: " QUIT
if [ "$QUIT"  = "n" ]; then
     exit 0
elif [ "$QUIT" = "y" ]; then
      echo "press enter to apply changes"
      source ./ttyclock.sh
elif [ "$QUIT" = "d" ]; then
      pkill -f ttyclock
      clear

fi 
draw_clock() {
    local t_cols=$(tput cols)
    local time_str=$(date +"%H:%M:%S")
    local clock_len=$((${#time_str} + 2))

    tput sc
    tput cup 0 $((t_cols - clock_len))
    echo -ne "\033[1;32m[$time_str]\033[0m"
    tput rc
}
export -f draw_clock
PROMPT_COMMAND="draw_clock; $PROMPT_COMMAND"

(
      while true; do
          sleep 1
          if [ -t 1 ]; then
              draw_clock
          fi
      done
) >/dev/tty 2>&1 &

CLOCK_PID=$!
trap 'kill $CLOCK_PID 2>/dev/null' EXIT
