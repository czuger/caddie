#!/usr/bin/env bash

rsync -rl --exclude .git --exclude coverage --exclude .idea . hw:~/eve_business_server/caddie/