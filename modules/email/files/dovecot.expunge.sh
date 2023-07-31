#!/bin/bash
# Delete old email older than 30days from Trash and Junk
/usr/bin/doveadm expunge -A mailbox Trash savedbefore 30d
/usr/bin/doveadm expunge -A mailbox Junk savedbefore 30d
