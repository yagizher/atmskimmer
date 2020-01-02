Development:
	DevCritical
	Spindlestix

Name:
	esx_skimmer

Title:
	ATM/Player robbery script

Description:
	ATM robbery mod based off fake card readers, Player robbery mod based off pocket credit card 
	scanners.  Players may find Lester 'hidden'(at his house) in the city and with enough 
	cash(5000-15000) may purchase a skimmer, usable on all ATMs, or a scanner, usable 
	anytime(only affects Players).  The skimmer is desisgned to give the user a random amount of 
	bank money(100-2000), in a random amount of time(5-60 seconds) repeatedly until the user 
	recieves more than 1500 at one time.  The scanner is designed to scan for another 
	Player(who has to be less than 1.5 units from the user), and if a target is found the scanner
	will transfer a random amount of money(1/1000-1/50 of the targets bank), unless the target has 
	500 or less in their bank.  The skimmer is a one time use item that will only take action if 
	the user is standing next to an ATM.
	The scanner is a multi-use tool with a 'chance'(adjustable in server.lua) to break, can be used
	too far from a target.  This script uses the item.limit function from esx, which is 1 for each 
	item. All money related changes can be made in the server.lua, all Lester related changes in can
	be made in the client.lua.

Installation
	Download .rar package.
	Extract the files.
	Place esx_skimmer into your server resource folder.
	Add 'start esx_skimmer' to your 'server.cfg' file.
	Import the esx_skimmer.sql file into your database.
	You may adjust the location of L if you'd like in the client file.

Required resource
	es_extended