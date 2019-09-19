#!/bin/bash

rm -r /data/${worldname} || true
mkdir -p /data/${worldname} || true
cp -r /tmp/db/* /data/${worldname} || true
chmod -R 777 /data/${worldname} || true

rm -r /data/FeedTheBeast/${worldname} || true
mkdir -p /data/FeedTheBeast/${worldname} || true
chmod -R 777 /data/FeedTheBeast || true
cp -r /tmp/db/* /data/FeedTheBeast/${worldname} || true
chmod -R 777 /data/FeedTheBeast/${worldname} || true
