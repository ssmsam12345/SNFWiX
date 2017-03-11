SNF_Server V3.0 installation brief

This is a generalized guide. For specific platform guides see:
http://www.armresearch.com/support/articles/installation/index.jsp

Create a directory for SNF_Server. ( c:\SNF or /var/spool/snfilter )

Copy all of the files to that directory.

Make a copy of the SNFServer<version>.exe file and give it the name
SNFServer.exe. Later on if newer versions are provided you will
be able to keep track of them by name and swap newer versions into
place by copying them over your SNFServer.exe file. If you decide
you have to go back to a previous version then you will be able to
do that easily by deleting your SNFServer.exe file and copying the
version you wish to use into place.

Modify the identity.xml file to match your SNF license ID and your
authentication string.

Download your .snf file and place that in the SNF_Server working
directory.

RULEBASE UPDATES (NEW!): The latest version of the SNFServer engine
includes a mechanism that will run an a script when the rulebase file
on our server is newer than the active file in SNF. By default this
feature is configured to run the included getRulebase script. If
the script is not successful it will be launched again every 3 minutes
until the rulebase file is successfully updated.

Be sure to modify the top of the getRulebase script to include
your correct license ID, authentication string, and working directory.

Be sure to verify that the <update-script/> section of your snf_engine
file is correct (points to the correct location of getRulebase).

getRulebase uses wget and gzip (included for your convenience in 
the Win* distribution. See About-Wget-and-Gzip.txt.). These are open
source utilities for downloading files from web servers and unzipping
those files -- in this case, SNF rulebase files.  

If you have any gateways or other internal systems that will relay
mail to SNF then include their IPs in GBUdbIgnoreList.txt. The GBUdb
component of SNF uses the IPs in this list to determine the actual
source IP for a message by reviewing the Received headers. Each
Received header is evaluated in turn. If the source (connect) IP is
found in the Ignore list then that Received IP is considered to be
part of your infrastructure and is ignored. The first Received IP 
found that is NOT in the Ignore list is selected as the source IP.

The GBUdbIgnoreList is a "safety net" that ensures the listed IPs are
present in your GBUdb with their Ignore flag set. It is loaded every
time the configuration is changed, SNFServer is started, or a new
rulebase is loaded. This way if your GBUdb database is lost then your
critical infrastructure will be re-listed in the new .gbx file that
is created.

The ignore list allows only SINGLE IP ENTRIES. This can be a problem
in some cases - such as when you want to ignore large blocks of network
addresses.

SNF can learn to Ignore large blocks of IPs using the <drilldown/>
feature. For example if you want to ignore all of 12.34.56.0/24 then
you can make an entry in the <drilldown/> training section like this:

<training on-off='on'>
  ...
  <drilldown>
    <received ordinal='0' find='[12.34.56.'/>
  </drilldown>
  ...
</training>

GBUdb learns the behavior of source IPs so it is important that GBUdb
knows any friendly sources that might send spammy messages to your
server or else it will learn that those sources are not to be trusted.

Since not all friendly spam sources can be identified by IP ahead of
time, there are features in the <training/> section of snf_engine.xml
that allow you to adjust the training scenarios to compensate. The
most likely of these is that you may wish to bypass training for
messages that are to your support addresses or spam submission
addresses. For example:

<training on-off='on'>
  ...
  <bypass>
    <header name='To:' find='support@example.com'/>
    <header name='To:' find='spam@example.com'/>
  </bypass>
  ...
</training>

Evaluate the snf_engine.xml file carefully. In most cases the
default settings are appropriate, however you may want to alter
some of the settings to match your system policies or particular
installation.

IMPORTANT: Be sure that any file paths / directories referenced in
the configuration file exist on your system and that SNF has full
access rights to these - especially the SNF working directory.

** If you selected a working directory for SNF other than c:\SNF\
then be sure you have changed these paths in the top of your
snf_engine.xml file. Pay close attentiont to these 5 elements:

<node identity='c:/SNF/identity.xml'>
<log path='c:/SNF/'/>
<rulebase path='c:/SNF/'/>
<workspace path='c:/SNF/'/>
<update-script ... call='c:/SNF/getRulebase.cmd' ... />

Once you are happy with your configuration and you have all of your
files and directories in place (including your .snf file) then you
can start SNF_Server.

The command line (from inside the SNF workspace) is:

SNFServer.exe snf_engine.xml

That is: SNFServer <configuration>

If you want to lauch SNFServer from some other location it would be
best to use the entire path for both the SNFServer engine and the
configuration file:

c:\SNF\SNFServer.exe c:\SNF\snf_engine.xml

You should begin by testing SNFServer by running it in a command line
window where you can watch it's output.

Once you are happy with it then you will probably want to run it as
a service using a utility such as the srvany utility from the win2k 
toolkit, or detached as a daemon on *nix systems (snfctrl file example
included).

This section of our site might be helpful:

http://www.armresearch.com/support/articles/installation/serviceSetup/index.jsp

SNFServer is the server side of a client/server system. In order to
scan messages you will need to use the client utility (SNFClient.exe
or SNFIMailShim.exe) to scan messages.

SNFClient.exe is a drop-in replacement for the production (2-3.x)
SNF program when it is called from Declude or mxGuard or other similar
software. There is no need to "brand" the SNFClient.exe
program and it is not necessary to include the authentication string
on the command line -- however, if you do it will be accepted and
ignored without an error.

SNFServer MUST be running for SNFClient to work. If SNFClient cannot
reach SNFServer then it will wait for quite a while as it attempts to
make contact.

Here are a few ways to call SNFClient.exe:

SNFClient.exe -shutdown

	Sends the Shutdown command to the SNF_Server.

SNFClient.exe authenticationxx filetoscan

	Compatibility mode - ignores authenticationxx and scans filetoscan.

SNFClient.exe filetoscan

	Normal scan mode - scans filetoscan.

SNFClient.exe -xhdr filetoscan

	XHDR scan mode - scans filetoscan and returns X Headers.

See the SNFClient_Readme.txt file for details.

The SNF Client/Server pair communicate using short XML messages via a local
TCP connection (typically to port 9001). Examples of SNF_XCI messages are
included in snf_xci.xml (not a well formed xml file! - just some examples).

It is possible to communicate directly with the SNF_Server engine via TCP
from your software using the SNF_XCI (SNF XML Command Interface) protocol. The
server expects to see one connection per request. The client sends an SNF_XCI
request to the server. The server responds with an appropriate SNF_XCI
formatted response and terminates the connection.

Requests and responses are expected to terminate with a newline character.

You can see the XCI protocol at work by running the SNFClient in debug mode
(SNFdebugClient).

If you run into trouble check out our web site: www.armresearch.com and/or
contact us by email: support@armresearch.com

____________________
For More Information

See www.armresearch.com
Copyright (C) 2007-2008 Arm Research Labs, LLC.
