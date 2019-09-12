#! /bin/bash

cmus-remote -Q | sed -nE 's/^stream (.+)/\1/p'
