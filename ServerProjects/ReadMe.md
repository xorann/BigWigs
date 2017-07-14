How to support another server
==============================

Create a new directory: BigWigs/ServerProjects/<Project-Name>
Create a new file: BigWigs/ServerProjects/<Project-Name>/<Project-Name>.lua
	Have a look at "BigWigs/ServerProjects/Classic-WoW/Classic-WoW.lua" for an example. In this file you have to register all the servers for your project (e.g. server "Nefarian" for the project "Classic-WoW") and define which bosses you support. Otherwise the default implementation will be used.
Create a new file: BigWigs/ServerProjects/<Project-Name>/<Project-Name>.xml
	Have a look at "BigWigs/ServerProjects/Classic-WoW/Classic-WoW.lua" for an example. In this file you have to include all the lua files of all the server specific scripts you have added.
Modify "BigWigs/BigWigs.toc"
	Add the bottom of the file add the following line: "ServerProjects\<Project-Name>.xml"
	
Now you can start implementing your server specific boss modules. Each boss module consists of four files. Example for the "Twin Emperors" module: 
	- BigWigs/Raids/AQ40/Twins/I18n.lua: Strings for all the messages, bars and combat log trigger for all supported locales. Do not change the names or you will break this addon for all other servers.
	- BigWigs/Raids/AQ40/Twins/Core.lua: Core functions of the boss module that are the same for all servers (e.g. a function to start the teleport bar). Do not change this file.
	- BigWigs/Raids/AQ40/Twins/Default.lua: Default implementation in case you did not yet add support for this boss module
	- BigWigs/ServerProjects/<Project-Name>/Raids/AQ40/Twins.lua: Overrides the default implementation. Here you define the server specific timers, triggers and more. Try to use the functions provided by the core boss module whenever possible