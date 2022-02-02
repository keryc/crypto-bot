#!/bin/bash

LINE="2-59/5 * * * * /bin/bash -c ${PWD}/update-crypto-bot.sh" &&
(crontab -l; echo "$LINE" ) | crontab -
