#!/bin/bash

# commands run on the K8S cluster to get world files in the right place

rm -r /data/worlds/${worldname} || true
mkdir -p /data/worlds/${worldname}/db || true
chmod -R 755 /data/worlds/${worldname}/db || true
cp -r /tmp/db/* /data/worlds/${worldname}/db || true