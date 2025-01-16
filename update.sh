#!/bin/bash
date=$(date '+%Y-%m-%d')

git --git-dir ~/CS/devops/ITI/.git --work-tree ~/CS/devops/ITI/ add .

git --git-dir ~/CS/devops/ITI/.git --work-tree ~/CS/devops/ITI/ commit -m "udpating log on the date of:${date}"

git --git-dir ~/CS/devops/ITI/.git --work-tree ~/CS/devops/ITI/ push
