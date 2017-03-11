XYSystem Components Help 
[Copyright] 
[Table of Contents] 

XYNTService 

XYNTService is an NT service program that can be used to start and stop other programs.  If you are using Windows NT 4.0 or later, it is recommended that you start XYRoot, XYDataManager, XYDispatcher, and other server processes using XYNTService.  When started by XYNTService, the processes will be able to run without user login to the operating system.  Only authorized persons are allowed to start and stop the processes. 

Here is how to use XYNTService. 

Using XYNTService To Start And Stop Other Processes 

First, the environment variable XYSYSTEMSERVICE_INIFILE represents the full path of the configuration file.  If this environment variable is not defined, the default configuration file will be XYNTService.ini in the same directory as the executable.  The ProcCount value in the Settings section of the configuration file is the total number of processes that XYNTService needs to start.  For each of these processes, the CommandLine value in the ProcessX section of the configuration file is the command used to start the process, here X is the index (between 0 and ProcCount-1 ) of the process.  When XYNTService is started, it will start all the processes defined in the configuration file.  When XYNTService is stopped, the processes started by it will also be stopped in the reverse order with an exception noted later. 

To install the XYNTService, run the following at the command prompt: 

XYNTService -i 

Note that some programs may need to access a user's registry settings.  If these programs are started by XYNTService, then XYNTService needs to be run under the corresponding user's account.  This can be configured using the Services icon in the control panel. 

To uninstall the XYNTService, run the following at the command prompt: 

XYNTService -u 

By default, the installed NT service will be started automatically whenever the machine is rebooted.  It can also be started and stopped using the Services icon in the control panel. 

Here is a sample configuration file for XYNTService: 

[Settings] 
ProcCount=3 
LogFile=XYNTService.log 
[Process0] 
CommandLine=XYRoot 
UserInterface=No 
PauseStart=1000 
PauseEnd=1000 
[Process1] 
CommandLine=XYDataManager 
UserInterface=No 
PauseStart=1000 
PauseEnd=1000 
[Process2] 
CommandLine=java  XYRoot.XYRoot  XYRootJava.ini 
UserInterface=No 
PauseStart=1000 
PauseEnd=1000 

The parameter UserInterface indicates whether the process has a visible user interface.  The parameter PauseStart indicates the number of  milliseconds to wait after starting the current process.  The parameter PauseEnd indicates the number milliseconds to wait before terminating the current process by force, this will give the current process a chance to shutdown itself. 

Note that a process started by XYNTService is visible only when the UserInterface parameter is Yes and XYNTService is running under the default system account. 

While XYNTService is running, it also possible to bounce a process it had started.  The following command, for example, will shutdown and restart Process2 defined in the .ini file: 

XYNTService -b 2 

To shutdown and restart XYNTService itself (which will bounce all processes defined in the .ini file), use this command: 

XYNTService -b 

Using XYNTService To Start And Stop Other Services 

In addition, XYNTService has the capability to start and stop other services.  To start the IIS server (theMicrostoft Web Server), for example, you need only to execute the following command line: 

XYNTService -r IISADMIN 

The following command line will kill the IIS server: 

XYNTService -k IISADMIN 

The general syntax of using XYNTService to start another service is: 

XYNTService  -r  NameOfServiceToStart  [other parameters for the given service] 

The general syntax of using XYNTService to stop another service is: 

XYNTService  -k  NameOfServiceToStop 

In particular, you can use the above commands to start and stop XYNTService itself. 

[Table of Contents] 
