How to support another server
==============================

Create a new directory: BigWigs/ServerProjects/<Project-Name>
Create a new file: BigWigs/ServerProjects/<Project-Name>/<Project-Name>.lua
	Have a look at "BigWigs/ServerProjects/Classic-WoW/Classic-WoW.lua" for an example. In this file you have to register all the servers for your project (e.g. server "Nefarian" for the project "Classic-WoW") and define which bosses you support. Otherwise the default implementation will be used.
Modify "BigWigs/BigWigs.toc"
	Under the section "Multi Server Support" and above the section "Default Implementations" you have to add all the lua files with the implementations for your server.
	
Now you can start implementing your server specific boss modules. Each boss module consists of four files. Example for the "Twin Emperors" module: 
	- BigWigs/Raids/AQ40/Twins/I18n.lua: Strings for all the messages, bars and combat log trigger for all supported locales. Do not change the names or you will break this addon for all other servers.
	- BigWigs/Raids/AQ40/Twins/Core.lua: Core functions of the boss module that are the same for all servers (e.g. a function to start the teleport bar). Do not change this file.
	- BigWigs/Raids/AQ40/Twins/Default.lua: Default implementation in case you did not yet add support for this boss module
	- BigWigs/ServerProjects/<Project-Name>/Raids/AQ40/Twins.lua: Overrides the default implementation. Here you define the server specific timers, triggers and more. Try to use the functions provided by the core boss module whenever possible. You can override all the variables if necessary. E.g. teleport timer: timer.teleport = 15