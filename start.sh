#!/bin/bash

pm2 start pm2config.json --env production

pm2 logs all
