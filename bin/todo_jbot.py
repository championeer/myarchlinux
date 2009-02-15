#!/usr/bin/python

import os,xmpp,time

# Todo Jabber Bot
# Author: Shiva KM (kmshiva@gmail.com) 
# Release date:  6/28/2006
# Last updated:  7/22/2006
# License:  GPL, http://www.gnu.org/copyleft/gpl.html
# Version: 0.3
# More info:  http://todotxt.com, http://edge.nfshost.com/blog


# NOTE:
# Information about using a Commander who is on a different network (such as Yahoo or MSN),
# through Jabber's Yahoo/MSN transports is 
# available at http://edge.nfshost.com/blog/2006/07/16/how-to-connect-to-the-yahoo-transport-through-the-todo-bot/

# =========BEGIN CONFIGURATION============
SCREENNAME = 'yourbotnick@jabber.org'	# Your bot's Jabber ID (eg.kmshiva@gabfest.net)
PASSWORD   = 'yourbotpassword'		# Your bot Jabber pasword
COMMANDER  = 'commanderNick@jabber.org'	# Your Jabber ID
TODOSCRIPT = '/home/shiva/bin/todo.sh'	# Path to your todo script
GTALK_SERVER = 'talk.google.com'        # google talk server - you shouldn't need to change this
# =========END CONFIGURATION==============

print "TodoBot v0.3 is starting...";
print "Visit todotxt.com, http://edge.nfshost.com/blog for help and the latest version.";

colorCodes = [
"\x1b[0;30m",
"\x1b[0;31m",
"\x1b[0;32m",
"\x1b[0;33m",
"\x1b[0;34m",
"\x1b[0;35m",
"\x1b[0;36m",
"\x1b[0;37m",
"\x1b[1;30m",
"\x1b[1;31m",
"\x1b[1;32m",
"\x1b[1;33m",
"\x1b[1;34m",
"\x1b[1;35m",
"\x1b[1;36m",
"\x1b[1;37m",
"\x1b[0m"]

def remove_colors(input):
    for code in colorCodes:
        input = input.replace(code, "")
        
    return input

def messageCB(cl, msg):
    print "%s says: %s" % (msg.getFrom(), msg.getBody())

    response = ''
    
    sender = msg.getFrom().__str__()
    message = msg.getBody()
    
    # remove the 'resource' part of the nick, e.g. kmshiva@jabber.org/Gaim
    if (sender.rfind('/') != -1):
        sender = sender[:sender.rindex('/')]

    if (sender == COMMANDER):
	if (message):
                # Add options before calling TODOSCRIPT
                # -v    Verbose mode
                # -f    Forces actions without confirmation or interactive input
                # -p    Plain mode turns off colors
                
                print "%s -v -p -f %s" % (TODOSCRIPT, message)
                
                fd = os.popen("%s -v -p -f %s" % (TODOSCRIPT, message))
                output = fd.read().strip()

                if (len(output) == 0):
                    if (fd.close() != None):
                        response = "The Todo bot go BOOM!  Please check the path to your todo script is correct.\n"
                    else:
                        response = "Nothing to display for command todo %s." % message
                else:
                    for line in output.split('\n'):
                        line = line.strip()
                        response = response + line + "\n"

                    fd.close()

                    # remove any color codes if present, it confuses the xml parser!
                    response = remove_colors(response)

                    if (response == "\n" or response == ""):
                        response = "Nothing to display for command todo %s." % message
    else:
           response = "You are not the boss of me." 

    print "%s: %s" % (SCREENNAME, response)
    # Set type to "chat" - needed for yahoo transport
    cl.send(xmpp.protocol.Message(sender, response ,typ="chat"))


jid=xmpp.protocol.JID(SCREENNAME)
cl=xmpp.Client(jid.getDomain(),debug=[])

# For Google Talk connect to the google talk servers, for all others figure 
# out the server from the screenname itself.
if (SCREENNAME.strip().lower()[-10:] == '@gmail.com'):
    cl.connect((GTALK_SERVER, 5222))
else:
    cl.connect()

cl.auth(jid.getNode(), PASSWORD)

# register callback for message
cl.RegisterHandler('message', messageCB)

cl.sendInitPresence(requestRoster=0)

print 'connected...\n'

while(1):
    cl.Process(1)
    time.sleep(1)

cl.disconnect()
