#!/bin/bash

TG_CHAT_ID=""
TG_TOKEN=""

CRYPTO_BOT_PATH="/home/admin/crypto-bot" && cd $CRYPTO_BOT_PATH

GITRESPONSE=`git pull` && UPDATED='Already up to date.'

if [[ $GITRESPONSE != $UPDATED ]]; then
        GITCOMMITTER=`git show -s --format='%cn'`
        GITVERSION=`git show -s --format='%h'`
        GITCOMMENT=`git show -s --format='%s'`
        
        curl -s --data "text=🆕 <b>Update <i>Crypto Bot</i></b> by <code>${GITCOMMITTER}</code>!%0ACommit: <code>$GITVERSION</code>%0AComment: <code>${GITCOMMENT}</code>%0A⏳ Please wait for reload..." \
                --data "parse_mode=HTML" \
                --data "chat_id=$TG_CHAT_ID" \
                "https://api.telegram.org/bot${TG_TOKEN}/sendMessage"

        /usr/local/bin/docker-compose restart > /dev/null &&

        curl -s --data "text=🆗 CB reload has been completed!" \
                --data "parse_mode=HTML" \
                --data "chat_id=$TG_CHAT_ID" \
                "https://api.telegram.org/bot${TG_TOKEN}/sendMessage"
fi

# Add TG_TOKEN and TG_CHAT_ID
# crontab -e ; 1; 2-59/5 * * * * /bin/bash -c "/home/admin/crypto-bot/update.sh"
