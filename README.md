# cbc-autoaim

Auto-aim for create big cannons using computercraft

Showcase: https://imgur.com/a/nosqd-auto-loader-4-2-9ixViIt

Showcase 2: https://youtu.be/YkPPC6reTsI

This project started as just an autoloader (and get its name ANAL4, A Nosqd AutoLoader 4 cannons) but recently I've added autoaiming to player using playerdetector from AdvancedPeripherals.

To use just get scripts from my github project (https://github.com/nosqd/cbc-autoaim) and you can also get autoloader from schematics folder, it works by using vs addition cheatcannonmount and you MUST enable cheat cannon mount in config of vs addition, and you MUST use custom VS Addition version that I've forked (from mods folder in repo or build it by yourself from https://github.com/nosqd/VS-Addition.

Notice: the playeraim scripts features auto setting up cannons you can make your own autoloader and add any amount of cannons.

# In-depth explanation.

Firstly I'm using modified version of VS-Addition becuase I found out that you can't get position of cannon pivot point but I wanted to easily add more cannons by just connecting them to the computer. And I forked VS-Addition (here), to add getX, getY, getZ functions to cannon mount.

Secondly I'm using cheat cannon mount to easily change yaw and pitch of cannon, please enable it in VS-Addition config.

Thirdly pitch calculation was taken from here and here.

Fourthly project is CC0-1.0, contribute to it, star it please.

meow

