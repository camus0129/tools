#!/usr/bin/python
import os
import commands

from_addr = "xxxx@xxxx.com"
password = "xxxx"
smtp_server = "xxxxxxx"
to_addr = "xxxx@xxxx.com"

#get ip
(status, output) = commands.getstatusoutput('/sbin/ifconfig')

from email.mime.text import MIMEText
msg = MIMEText(output, 'plain', 'utf-8')

import smtplib
server = smtplib.SMTP(smtp_server, 25)
server.set_debuglevel(1)
server.login(from_addr, password)
server.sendmail(from_addr, [to_addr], msg.as_string())
server.quit()
