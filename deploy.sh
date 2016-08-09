#!/usr/bin/env bash

# ssh hw 'rm -rf ~/eve_business_server/caddie/*'
rsync -rl --exclude .git --exclude coverage --exclude .idea . hw:~/eve_business_server/caddie/