//
//  HelpHoldemView.m
//  Headsup
//
//  Created by Haolan Qin on 4/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HelpHoldemView.h"


@implementation HelpHoldemView

@synthesize navController;

@synthesize helpTextView;

- (void) setUpStuff {
}

- (id)initWithCoder:(NSCoder *)coder {	
	if (self = [super initWithCoder:coder]) {
		[self setUpStuff];
	}
	return self;
}


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpStuff];
    }
    return self;
}

//@"<p style=\"font-size: 300%;\"> </p>"


- (void)drawRect:(CGRect)rect {
	NSString *html;
	
	if (BUILD == HU_FREE) {
		html = @"<html><head><title>Help Page</title></head><body bgcolor=black text=white>"
		@"<p style=\"font-size: 350%;\">email: <a href=\"mailto:headsupftw@gmail.com\">headsupftw@gmail.com</a></p>"
		@"<p style=\"font-size: 350%;\">twitter: <a href=\"http://twitter.com/headsupftw\">@headsupftw</a></p>"
		
		@"<h1 style=\"font-size: 500%;\">Important Note</h1>"
		@"<p style=\"font-size: 300%; color: yellow \"> <b>To use this app on two iPhones via Bluetooth, tap the Bluetooth button on both iPhones, wait till you see \"Accept\" and \"Decline\" and tap the \"Accept\" button. Be patient. Sometimes it takes over a minute to get connected.</b></p>"
		@"<p style=\"font-size: 300%; color: yellow \"> <b>Bluetooth networking is NOT supported on the original iPhone or the first-generation iPod Touch. If you own these devices, you can download my other popular free app Headsup Hold'em Poker Free and play on Wi-Fi.</b></p>"
		
		@"<h1 style=\"font-size: 500%;\">Troubleshooting</h1>"
		@"<p style=\"font-size: 300%;\"> <b>1. I don't see the other iPhone on the startup screen.</b></p>"
		@"<p style=\"font-size: 300%; color:green\">Make sure your device is NOT the original iPhone or the first-generation iPod Touch, you are running the same version on both iPhones and you both have tapped the Bluetooth button.</p>"
		@"<p style=\"font-size: 300%;\"> <b>2. Sometimes my Bluetooth connection works but the other times I wait for 30 seconds and still can't see the other iPhone.</b></p>"
		@"<p style=\"font-size: 300%; color:green\">Be patient. Sometimes it takes over a minute to get connected. If it doesn't connect after extended period of time, you may cancel the request or even restart the app and try again.</p>"
		@"<p style=\"font-size: 300%;\"> <b>3. Bluetooth is turned on in my Settings, why does it prompt me to turn it on sometimes? Why does it say \"Communication Error\" sometimes?</b></p>"
		@"<p style=\"font-size: 300%; color:green\">It does that every once in a while. Just ignore the message and start over.</p>"
		
		@"<h1 style=\"font-size: 500%;\">Credits</h1>"
		@"<p style=\"font-size: 300%;\"> <b>Special thanks to Fan Yang for graphic design!</b></p>"
		
		@"</body></html>";  		
	} else if (BUILD == HU_HOLDEM) {
		html = @"<html><head><title>Help Page</title></head><body bgcolor=black text=white>"
		@"<p style=\"font-size: 350%;\">email: <a href=\"mailto:headsupftw@gmail.com\" style=\"text-decoration:none\"><font color=#\"FFFF00\">headsupftw@gmail.com</font></a></p>"
		@"<p style=\"font-size: 350%;\">twitter: <a href=\"http://twitter.com/headsupftw\" style=\"text-decoration:none\"><font color=#\"FFFF00\">@headsupftw</font></a></p>"
		
		@"<h1 style=\"font-size: 500%;\">Credits</h1>"
		@"<p style=\"font-size: 300%;\"> <b>Graphic Designers: Fan Yang & Jan Cihak</b></p>"

		@"<h1 style=\"font-size: 500%;\">New Features</h1>"
		@"<ul>"
		@"<li><p style=\"font-size: 300%; color:yellow;\"> Bluetooth connectivity with iPad! Now you can play poker against an iPad (Poker HD or Poker Free HD) via Bluetooth. </p>"
		@"<li><p style=\"font-size: 300%; color:yellow;\"> Mode indicator: 1p means single player mode. 2p means 2-player single phone mode. 2pBT means 2-player Bluetooth mode. 2pGC means 2-player Game Center mode. </p>"
		@"</ul>"
		
		@"<h1 style=\"font-size: 500%;\"> Coming Soon</h1>"
		@"<ul>"
		@"<li><p style=\"font-size: 300%;\"> Hand history. You will be able to review the hand you just played.</p>"
		@"<li><p style=\"font-size: 300%;\"> Odds calculator. You will be able to specify cards in Training Mode.</p>"
		@"<li><p style=\"font-size: 300%;\"> SNG mode. A digital clock will be added. You will be able to set how frequently the blinds go up.</p>"
		@"<li><p style=\"font-size: 300%;\"> More computer opponents with different poker playing styles.</p>"
		@"<li><p style=\"font-size: 300%;\"> Heads Up Blackjack dual phone mode. You will be able to play blackjack against your buddy on another iPhone over Wi-Fi</p>"
		//@"<li><p style=\"font-size: 300%; color: red\"> PLO8, 7Stud, Razz, 5Card Draw, 2to7... You name it and I will give it to you, all for free. </p>"		
		@"<li><p style=\"font-size: 300%;\"> Omaha Hi/Lo. Pot Limit and Limit Hold'em.</p>"
		@"<li><p style=\"font-size: 300%;\"> Cash game mode. You will be allowed to buy more chips in the middle of a game. Fractional number will be supported (e.g. bet $1.50 big blind $0.25)</p>"
		@"</ul>"
		
		/*@"<h1 style=\"font-size: 500%;\">Troubleshooting</h1>"
		@"<p style=\"font-size: 300%;\"> <b>1. I don't see the other iPhone on the startup screen.</b></p>"
		@"<p style=\"font-size: 300%; color:green\"> Go to Settings -> WiFi and make sure both iPhones are connected to the same WiFi network.</p>"
		@"<p style=\"font-size: 300%;\"> <b>2. Both iPhones are connected to the same WiFi but I still don't see the other iPhone.</b></p>"
		@"<p style=\"font-size: 300%; color:green\"> Depending on the WiFi hotspot, sometimes it takes up to 30 seconds to see the other iPhone. But once the game is started, there will be virtually no delay.</p>"
		@"<p style=\"font-size: 300%;\"> <b>3. Okay now I see the other iPhone. But when I tap its name, it turns blue and nothing happens.</b></p>"
		@"<p style=\"font-size: 300%; color:green\"> Again, depending on the WiFi hotspot, sometimes it takes a little while to start the game. When you \"get stuck\", tap anywhere to deselect the row and retry, or simply exit out of the app on both iPhones and restart it. It usually fixes the problem immediately.</p>"
		@"<p style=\"font-size: 300%;\"> <b>4. I played with my friend a couple days ago. But now with the same two iPhones and WiFi we can't see each other on the startup screen.</b></p>"
		@"<p style=\"font-size: 300%; color:green\"> Make sure the two iPhones have the same version of this app. Two different versions will not be able to see each other. You can find out the version number at the bottom of the startup screen.</p>"
		@"<p style=\"font-size: 300%;\"> <b>5. I don't have WiFi. Can I still use this app to play heads-up poker?</b></p>"
		@"<p style=\"font-size: 300%; color:green\"> Unfortunately at this point WiFi is mandatory. However, in the near future, this requirement will become obsolete. You will then be able to play Headsup Texas Hold'em even without a WiFi. Also keep in mind you can easily create a WiFi hotspot on your Mac computer and have both iPhones hooked up to the Mac wirelessly and start playing heads-up poker.</p>"
		 */
				
		@"</body></html>";  		
		
		/*html = @"<html><head><title>Help Page</title></head><body>"
		@"<h1 style=\"font-size: 500%;\">Troubleshooting</h1>"
		@"<p style=\"font-size: 300%;\"> <b>1. I don't see the other iPhone on the startup screen.</b></p>"
		@"<p style=\"font-size: 300%;\"> Go to Settings -> WiFi and make sure both iPhones are connected to the same WiFi network.</p>"
		@"<p style=\"font-size: 300%;\"> <b>2. Both iPhones are connected to the same WiFi but I still don't see the other iPhone.</b></p>"
		@"<p style=\"font-size: 300%;\"> Depending on the WiFi hotspot, sometimes it takes up to 30 seconds to see the other iPhone. But once the game is started, there will be virtually no delay.</p>"
		@"<p style=\"font-size: 300%;\"> <b>3. Okay now I see the other iPhone. But when I tap its name, it turns blue and nothing happens.</b></p>"
		@"<p style=\"font-size: 300%;\"> Again, depending on the WiFi hotspot, sometimes it takes a little while to start the game. When you \"get stuck\", tap anywhere to deselect the row and retry, or simply exit out of the app on both iPhones and restart it. It usually fixes the problem immediately.</p>"
		@"<p style=\"font-size: 300%;\"> <b>4. I played with my friend a couple days ago. But now with the same two iPhones and WiFi we can't see each other on the startup screen.</b></p>"
		@"<p style=\"font-size: 300%;\"> Make sure the two iPhones have the same version of this app. Two different versions will not be able to see each other. You can find out the version number at the bottom of the startup screen.</p>"
		@"<p style=\"font-size: 300%;\"> <b>5. I don't have WiFi. Can I still use this app to play heads-up poker?</b></p>"
		@"<p style=\"font-size: 300%;\"> Unfortunately at this point WiFi is mandatory. However, in the near future this requirement will become obsolete. You will then be able to play Headsup Texas Hold'em even without a WiFi. Also keep in mind you can easily create a WiFi hotspot on your Mac computer and have both iPhones hooked up to the Mac wirelessly and start playing heads-up poker.</p>"
		
		/*@"<p style=\"font-size: 300%;\"> Why play heads-up poker on iPhone/iPod touch? </p>"
		@"<p style=\"font-size: 300%;\"> If you have ever tried to play heads up poker with your friends, you probably had an unpleasant experience. You probably had to shuffle and deal cards ALL THE TIME. Inevitably, the game became unbearable at the end because you literally spent most of the time shuffling and dealing cards rather than playing poker! </p>"
		@"<p style=\"font-size: 300%;\"> What a pity. Heads up poker should have been one of your favorite games if you are a true poker aficionado because you don't ever sit around watching other people play. When you fold, the hand ends, period. So you are always playing, always having fun. Bad cards? No problem, fold 'em and move on to the next hand.</p>"
		@"<p style=\"font-size: 300%;\"> There used to be live poker and online poker. Now with the introduction of this iPhone app, a third exciting form -- iPhone live poker has arrived on the horizon. Enjoy the best of both worlds. Play hassle free poker with your friends face to face.</p>"
		@"<p style=\"font-size: 300%;\"> No more offshore gaming servers, no more shady strangers online, no more shuffling and dealing. Get this app today and play poker with your friends at the safe and comfortable setting of your home.</p>"
		@"<p style=\"font-size: 300%;\"> Now you can get a quick fix of poker action in the office, in a coffee shop and very soon even on an airplane!</p>"
		@"<p style=\"font-size: 300%;\"> There are two modes in this iPhone app.</p>"*/
		/*@"<h1 style=\"font-size: 500%;\"> Shuffler/Dealer Mode</h1>"
		@"<p style=\"font-size: 300%;\"> This is the mode I much prefer. It's a relatively slow-paced game and you need real chips to play. In addition, you need two iPhones or iPod touches and a WiFi. You and your friend control game rules, betting actions, posting blinds, buy-in, rebuy and almost all aspects of the game. The iPhone merely shuffles and deals cards for you. Shuffle your chips, needle your buddy, drink beer, play all action no fluff heads-up poker and have loads of fun! </p>"
		@"<p style=\"font-size: 300%;\"> Note that you don't have to play no limit hold'em in this mode. You can play no limit, pot limit, fixed limit or even mixed limit games. You can play a heads-up tournament. The blinds can stay the same throughout the match or it can go up every x minutes. Or you can just play cash game. It's all up to you.</p>"
		@"<h1 style=\"font-size: 500%;\"> Game Mode</h1>"
		@"<p style=\"font-size: 300%;\"> This is the mode most of my friends prefer. You don't need chips or cards. The iPhone will do everything for you: shuffling, dealing, keeping track of pot size, betting, raising, winning hand and everything else. Just sit back and play. </p>"
		@"<p style=\"font-size: 300%;\"> This mode is essentially computer poker. However, you can watch your friend's facial expression and mannerisms. More importantly, you host the game on your own iPhone at your own pad and you are not playing a total stranger somewhere in Nigeria so you don't ever have to worry about getting cheated.</p>"
		
		@"<h1 style=\"font-size: 500%;\"> Coming Soon</h1>"
		@"<p style=\"font-size: 300%; color: red\"> 1. No requirement for WiFi. All you need is two iPhones/iPod touches and you can play heads-up poker with your friend literally anywhere in the world, even on an airplane.</p>"
		@"<p style=\"font-size: 300%;\"> 2. Adjustable initial stack size for tournament mode.</p>"
		@"<p style=\"font-size: 300%;\"> 3. Cash game mode. Re-buy will be allowed.</p>"
		@"<p style=\"font-size: 300%;\"> 4. SNG mode. A digital clock will be added. You will be able to set how frequently the blinds go up.</p>"
		@"<p style=\"font-size: 300%;\"> 5. Hand history. You can review all the hands you just played on your iPhone and have them emailed to you.</p>"
		@"<p style=\"font-size: 300%;\"> 6. You will be able to pause the game, take a break or even come back a few days later to finish off the session with your friend.</p>"
		@"<p style=\"font-size: 300%;\"> 7. Pot limit Texas Hold'em</p>"		
		@"<p style=\"font-size: 300%;\"> 8. Limit Texas Hold'em</p>"
		@"<p style=\"font-size: 300%;\"> All future upgrades will be free. You only have to pay once. So why not get it today and start enjoying the action?</p>"
		@"<p style=\"font-size: 300%;\"> Should you have any questions or suggestions, email me at headsupftw@gmail.com</p>"
		
		@"</body></html>";  */
	} else if (BUILD == HU_HOLDEM_FREE) {
		html = @"<html><head><title>Help Page</title></head><body bgcolor=black text=white>"
		@"<p style=\"font-size: 350%;\">email: <a href=\"mailto:headsupftw@gmail.com\" style=\"text-decoration:none\"><font color=#\"FFFF00\">headsupftw@gmail.com</font></a></p>"
		@"<p style=\"font-size: 350%;\">twitter: <a href=\"http://twitter.com/headsupftw\" style=\"text-decoration:none\"><font color=#\"FFFF00\">@headsupftw</font></a></p>"

		//@"<p style=\"font-size: 500%;\">If you don't want to see any ads, click <a href=\"http://bit.ly/5Sdw2V\">here</a> to purchase the paid version.</p>"
		
		@"<h1 style=\"font-size: 500%;\">Credits</h1>"
		@"<p style=\"font-size: 300%;\"> <b>Graphic Designers: Fan Yang & Jan Cihak</b></p>"

		@"<h1 style=\"font-size: 500%;\">New Features</h1>"
		@"<ul>"
		@"<li><p style=\"font-size: 300%; color:yellow;\"> Bluetooth connectivity with iPad! Now you can play poker against an iPad (Poker HD or Poker Free HD) via Bluetooth. </p>"
		@"<li><p style=\"font-size: 300%; color:yellow;\"> Mode indicator: 1p means single player mode. 2p means 2-player single phone mode. 2pBT means 2-player Bluetooth mode. 2pGC means 2-player Game Center mode. </p>"
		@"</ul>"
		
		@"<h1 style=\"font-size: 500%;\"> Coming Soon</h1>"
		@"<ul>"
		@"<li><p style=\"font-size: 300%;\"> Hand history. You will be able to review the hand you just played.</p>"
		@"<li><p style=\"font-size: 300%;\"> Odds calculator. You will be able to specify cards in Training Mode.</p>"
		@"<li><p style=\"font-size: 300%;\"> SNG mode. A digital clock will be added. You will be able to set how frequently the blinds go up.</p>"
		@"<li><p style=\"font-size: 300%;\"> More computer opponents with different poker playing styles.</p>"
		@"<li><p style=\"font-size: 300%;\"> Heads Up Blackjack dual phone mode. You will be able to play blackjack against your buddy on another iPhone over Wi-Fi</p>"
		//@"<li><p style=\"font-size: 300%; color: red\"> PLO8, 7Stud, Razz, 5Card Draw, 2to7... You name it and I will give it to you, all for free. </p>"		
		@"<li><p style=\"font-size: 300%;\"> Omaha Hi/Lo. Pot Limit and Limit Hold'em.</p>"
		@"<li><p style=\"font-size: 300%;\"> Cash game mode. You will be allowed to buy more chips in the middle of a game. Fractional number will be supported (e.g. bet $1.50 big blind $0.25)</p>"
		@"</ul>"
		
/*		@"<h1 style=\"font-size: 500%;\">Troubleshooting</h1>"
		@"<p style=\"font-size: 300%;\"> <b>1. I don't see the other iPhone on the startup screen.</b></p>"
		@"<p style=\"font-size: 300%; color:green\"> Go to Settings -> WiFi and make sure both iPhones are connected to the same WiFi network.</p>"
		@"<p style=\"font-size: 300%;\"> <b>2. Both iPhones are connected to the same WiFi but I still don't see the other iPhone.</b></p>"
		@"<p style=\"font-size: 300%; color:green\"> Depending on the WiFi hotspot, sometimes it takes up to 30 seconds to see the other iPhone. But once the game is started, there will be virtually no delay.</p>"
		@"<p style=\"font-size: 300%;\"> <b>3. Okay now I see the other iPhone. But when I tap its name, it turns blue and nothing happens.</b></p>"
		@"<p style=\"font-size: 300%; color:green\"> Again, depending on the WiFi hotspot, sometimes it takes a little while to start the game. When you \"get stuck\", tap anywhere to deselect the row and retry, or simply exit out of the app on both iPhones and restart it. It usually fixes the problem immediately.</p>"
		@"<p style=\"font-size: 300%;\"> <b>4. I played with my friend a couple days ago. But now with the same two iPhones and WiFi we can't see each other on the startup screen.</b></p>"
		@"<p style=\"font-size: 300%; color:green\"> Make sure the two iPhones have the same version of this app. Two different versions will not be able to see each other. You can find out the version number at the bottom of the startup screen.</p>"
		@"<p style=\"font-size: 300%;\"> <b>5. I don't have WiFi. Can I still use this app to play heads-up poker?</b></p>"
		@"<p style=\"font-size: 300%; color:green\"> Unfortunately at this point WiFi is mandatory. However, in the near future, this requirement will become obsolete. You will then be able to play Headsup Texas Hold'em even without a WiFi. Also keep in mind you can easily create a WiFi hotspot on your Mac computer and have both iPhones hooked up to the Mac wirelessly and start playing heads-up poker.</p>"*/

/*		@"<h1 style=\"font-size: 500%;\">What's The Point?</h1>"
		@"<p style=\"font-size: 300%;\"> When you see this iPhone app, you might ask youself \"why would I want to play heads-up poker on iPhone/iPod touch\"? </p>"
		@"<p style=\"font-size: 300%;\"> If you have ever tried to play heads up poker with your friends, you probably had an unpleasant experience. You probably had to shuffle and deal cards ALL THE TIME. Inevitably, the game became unbearable at the end because you literally spent most of the time shuffling and dealing cards rather than playing poker! </p>"
		@"<p style=\"font-size: 300%;\"> What a pity. Heads up poker should have been one of your favorite games if you are a true poker aficionado because you don't ever sit around watching other people play. When you fold, the hand ends, period. So you are always playing, always having fun. Bad cards? No problem, fold 'em and move on to the next hand.</p>"
		@"<p style=\"font-size: 300%;\"> There used to be live poker and online poker. Now with the introduction of this iPhone app, a third exciting form -- iPhone live poker has arrived on the horizon. Enjoy the best of both worlds. Play hassle free poker with your friends face to face.</p>"
		@"<p style=\"font-size: 300%;\"> No more offshore gaming servers, no more suspicion of gaming sites juicing up pots for more rake, no more concern for collusion, no more shady strangers online, no more shuffling and dealing. Get this app today and play poker with your friends at the safe and comfortable setting of your home.</p>"
		@"<p style=\"font-size: 300%;\"> Now you can get a quick fix of poker action in the office, at a coffee shop and very soon even on an airplane!</p>"		*/
		
		@"</body></html>";  		
		
	} else if (BUILD == HU_OMAHA) {
		html = @"<html><head><title>Help Page</title></head><body>"
		@"<h1 style=\"font-size: 500%;\">Troubleshooting</h1>"
		@"<p style=\"font-size: 300%;\"> <b>1. I don't see the other iPhone on the startup screen.</b></p>"
		@"<p style=\"font-size: 300%;\"> Go to Settings -> WiFi and make sure both iPhones are connected to the same WiFi network.</p>"
		@"<p style=\"font-size: 300%;\"> <b>2. Both iPhones are connected to the same WiFi but I still don't see the other iPhone.</b></p>"
		@"<p style=\"font-size: 300%;\"> Depending on the WiFi hotspot, sometimes it takes up to 30 seconds to see the other iPhone. But once the game is started, there will be virtually no delay.</p>"
		@"<p style=\"font-size: 300%;\"> <b>3. Okay now I see the other iPhone. But when I tap its name, it turns blue and nothing happens.</b></p>"
		@"<p style=\"font-size: 300%;\"> Again, depending on the WiFi hotspot, sometimes it takes a little while to start the game. When you \"get stuck\", tap anywhere to deselect the row and retry, or simply exit out of the app on both iPhones and restart it. It usually fixes the problem immediately.</p>"
		@"<p style=\"font-size: 300%;\"> <b>4. I played with my friend a couple days ago. But now with the same two iPhones and WiFi we can't see each other on the startup screen.</b></p>"
		@"<p style=\"font-size: 300%;\"> Make sure the two iPhones have the same version of this app. Two different versions will not be able to see each other. You can find out the version number at the bottom of the startup screen.</p>"
		@"<p style=\"font-size: 300%;\"> <b>5. I don't have WiFi. Can I still use this app to play heads-up poker?</b></p>"
		@"<p style=\"font-size: 300%;\"> Unfortunately at this point WiFi is mandatory. However, in the near future, this requirement will become obsolete. You will then be able to play Headsup Omaha even without a WiFi. Also keep in mind you can easily create a WiFi hotspot on your Mac computer and have both iPhones hooked up to the Mac wirelessly and start playing heads-up poker.</p>"
		
		@"<h1 style=\"font-size: 500%;\"> Shuffler/Dealer Mode</h1>"
		@"<p style=\"font-size: 300%;\"> This is the mode I much prefer. It's a relatively slow-paced game and you need real chips to play. In addition, you need two iPhones or iPod touches and a WiFi. You and your friend control game rules, betting actions, posting blinds, buy-in, rebuy and almost all aspects of the game. The iPhone merely shuffles and deals cards for you. Shuffle your chips, needle your buddy, drink beer, play all action no fluff heads-up poker and have loads of fun! </p>"
		@"<p style=\"font-size: 300%;\"> Note that you don't have to pot limit Omaha Hi in this mode. You can play PLO, Omaha Hi/Lo or even mixed Omaha games. You can play a heads-up tournament. The blinds can stay the same throughout the match or it can go up every x minutes. Or you can just play cash game. It's all up to you.</p>"
		@"<h1 style=\"font-size: 500%;\"> Game Mode</h1>"
		@"<p style=\"font-size: 300%;\"> This is the mode most of my friends prefer. You don't need chips or cards. The iPhone will do everything for you: shuffling, dealing, keeping track of pot size, betting, raising, winning hand and everything else. Just sit back and play. </p>"
		@"<p style=\"font-size: 300%;\"> This mode is essentially computer poker. However, you can watch your friend's facial expression and mannerisms. More importantly, you host the game on your own iPhone at your own pad and you are not playing a total stranger somewhere in Nigeria so you don't ever have to worry about getting cheated.</p>"
		
		@"<h1 style=\"font-size: 500%;\"> Coming Soon</h1>"
		@"<p style=\"font-size: 300%; color: red\"> 1. No requirement for WiFi. All you need is two iPhones/iPod touches and you can play heads-up poker with your friend literally anywhere in the world, even on an airplane.</p>"
		@"<p style=\"font-size: 300%;\"> 2. Adjustable initial stack size for tournament mode.</p>"
		@"<p style=\"font-size: 300%;\"> 3. Cash game mode. Re-buy will be allowed.</p>"
		@"<p style=\"font-size: 300%;\"> 4. SNG mode. A digital clock will be added. You will be able to set how frequently the blinds go up.</p>"
		@"<p style=\"font-size: 300%;\"> 5. Hand history. You can review all the hands you just played on your iPhone and have them emailed to you.</p>"
		@"<p style=\"font-size: 300%;\"> 6. You will be able to pause the game, take a break or even come back a few days later to finish off the session with your friend.</p>"
		@"<p style=\"font-size: 300%;\"> 7. Pot Limit Omaha Hi/Lo</p>"
		@"<p style=\"font-size: 300%;\"> 8. Limit Omaha Hi/Lo</p>"		
		@"<p style=\"font-size: 300%;\"> All future upgrades will be free. You only have to pay once. So why not get it today and start enjoying the action?</p>"
		@"<p style=\"font-size: 300%;\"> Should you have any questions or suggestions, email me at headsupftw@gmail.com</p>"
		
		@"</body></html>";  		
	} else if (BUILD == HU_OMAHA_FREE) {
		html = @"<html><head><title>Help Page</title></head><body>"
		@"<h1 style=\"font-size: 500%;\">Troubleshooting</h1>"
		@"<p style=\"font-size: 300%;\"> <b>1. I don't see the other iPhone on the startup screen.</b></p>"
		@"<p style=\"font-size: 300%;\"> Go to Settings -> WiFi and make sure both iPhones are connected to the same WiFi network.</p>"
		@"<p style=\"font-size: 300%;\"> <b>2. Both iPhones are connected to the same WiFi but I still don't see the other iPhone.</b></p>"
		@"<p style=\"font-size: 300%;\"> Depending on the WiFi hotspot, sometimes it takes up to 30 seconds to see the other iPhone. But once the game is started, there will be virtually no delay.</p>"
		@"<p style=\"font-size: 300%;\"> <b>3. Okay now I see the other iPhone. But when I tap its name, it turns blue and nothing happens.</b></p>"
		@"<p style=\"font-size: 300%;\"> Again, depending on the WiFi hotspot, sometimes it takes a little while to start the game. When you \"get stuck\", tap anywhere to deselect the row and retry, or simply exit out of the app on both iPhones and restart it. It usually fixes the problem immediately.</p>"
		@"<p style=\"font-size: 300%;\"> <b>4. I played with my friend a couple days ago. But now with the same two iPhones and WiFi we can't see each other on the startup screen.</b></p>"
		@"<p style=\"font-size: 300%;\"> Make sure the two iPhones have the same version of this app. Two different versions will not be able to see each other. You can find out the version number at the bottom of the startup screen.</p>"
		@"<p style=\"font-size: 300%;\"> <b>5. I don't have WiFi. Can I still use this app to play heads-up poker?</b></p>"
		@"<p style=\"font-size: 300%;\"> Unfortunately at this point WiFi is mandatory. However, in the near future, this requirement will become obsolete. You will then be able to play Headsup Omaha even without a WiFi. Also keep in mind you can easily create a WiFi hotspot on your Mac computer and have both iPhones hooked up to the Mac wirelessly and start playing heads-up poker.</p>"
		
		@"<h1 style=\"font-size: 500%;\">What's The Point?</h1>"
		@"<p style=\"font-size: 300%;\"> When you see this iPhone app, you might ask youself \"why would I want to play heads-up poker on iPhone/iPod touch\"? </p>"
		@"<p style=\"font-size: 300%;\"> If you have ever tried to play heads up poker with your friends, you probably had an unpleasant experience. You probably had to shuffle and deal cards ALL THE TIME. Inevitably, the game became unbearable at the end because you literally spent most of the time shuffling and dealing cards rather than playing poker! </p>"
		@"<p style=\"font-size: 300%;\"> What a pity. Heads up poker should have been one of your favorite games if you are a true poker aficionado because you don't ever sit around watching other people play. When you fold, the hand ends, period. So you are always playing, always having fun. Bad cards? No problem, fold 'em and move on to the next hand.</p>"
		@"<p style=\"font-size: 300%;\"> There used to be live poker and online poker. Now with the introduction of this iPhone app, a third exciting form -- iPhone live poker has arrived on the horizon. Enjoy the best of both worlds. Play hassle free poker with your friends face to face.</p>"
		@"<p style=\"font-size: 300%;\"> No more offshore gaming servers, no more suspicion of gaming sites juicing up pots for more rake, no more concern for collusion, no more shady strangers online, no more shuffling and dealing. Get this app today and play poker with your friends at the safe and comfortable setting of your home.</p>"
		@"<p style=\"font-size: 300%;\"> Now you can get a quick fix of poker action in the office, at a coffee shop and very soon even on an airplane!</p>"
				
		@"<h1 style=\"font-size: 500%;\"> Coming Soon</h1>"
		@"<p style=\"font-size: 300%; color: red\"> 1. No requirement for WiFi. All you need is two iPhones/iPod touches and you can play heads-up poker with your friend literally anywhere in the world, even on an airplane.</p>"
		@"<p style=\"font-size: 300%;\"> 2. Adjustable initial stack size for tournament mode.</p>"
		@"<p style=\"font-size: 300%;\"> 3. Cash game mode. Re-buy will be allowed.</p>"
		@"<p style=\"font-size: 300%;\"> 4. SNG mode. A digital clock will be added. You will be able to set how frequently the blinds go up.</p>"
		@"<p style=\"font-size: 300%;\"> 5. Hand history. You can review all the hands you just played on your iPhone and have them emailed to you.</p>"
		@"<p style=\"font-size: 300%;\"> 6. You will be able to pause the game, take a break or even come back a few days later to finish off the session with your friend.</p>"
		@"<p style=\"font-size: 300%;\"> 7. Pot Limit Omaha Hi/Lo</p>"
		@"<p style=\"font-size: 300%;\"> 8. Limit Omaha Hi/Lo</p>"		
		@"<p style=\"font-size: 300%;\"> The free version does not have the shuffler/dealer mode and you can only play up to 10 hands every time. </p>"
		@"<p style=\"font-size: 300%;\"> Check out our Headsup Texas Hold'em, Headsup Omaha, Headsup Stud/Razz and more exciting games in the AppStore. Be sure to check the store often if you are interested in these other forms of poker. We will release more exciting products in the near future.</p>"
		
		@"</body></html>";  		
	} else if (BUILD == HU_STUD) {
		html = @"<html><head><title>Help Page</title></head><body>"
		@"<h1 style=\"font-size: 500%;\">Troubleshooting</h1>"
		@"<p style=\"font-size: 300%;\"> <b>1. I don't see the other iPhone on the startup screen.</b></p>"
		@"<p style=\"font-size: 300%;\"> Go to Settings -> WiFi and make sure both iPhones are connected to the same WiFi network.</p>"
		@"<p style=\"font-size: 300%;\"> <b>2. Both iPhones are connected to the same WiFi but I still don't see the other iPhone.</b></p>"
		@"<p style=\"font-size: 300%;\"> Depending on the WiFi hotspot, sometimes it takes up to 30 seconds to see the other iPhone. But once the game is started, there will be virtually no delay.</p>"
		@"<p style=\"font-size: 300%;\"> <b>3. Okay now I see the other iPhone. But when I tap its name, it turns blue and nothing happens.</b></p>"
		@"<p style=\"font-size: 300%;\"> Again, depending on the WiFi hotspot, sometimes it takes a little while to start the game. When you \"get stuck\", tap anywhere to deselect the row and retry, or simply exit out of the app on both iPhones and restart it. It usually fixes the problem immediately.</p>"
		@"<p style=\"font-size: 300%;\"> <b>4. I played with my friend a couple days ago. But now with the same two iPhones and WiFi we can't see each other on the startup screen.</b></p>"
		@"<p style=\"font-size: 300%;\"> Make sure the two iPhones have the same version of this app. Two different versions will not be able to see each other. You can find out the version number at the bottom of the startup screen.</p>"
		@"<p style=\"font-size: 300%;\"> <b>5. I don't have WiFi. Can I still use this app to play heads-up poker?</b></p>"
		@"<p style=\"font-size: 300%;\"> Unfortunately at this point WiFi is mandatory. However, in the near future, this requirement will become obsolete. You will then be able to play Headsup Stud even without a WiFi. Also keep in mind you can easily create a WiFi hotspot on your Mac computer and have both iPhones hooked up to the Mac wirelessly and start playing heads-up poker.</p>"
		
		@"<h1 style=\"font-size: 500%;\"> Shuffler/Dealer Mode</h1>"
		@"<p style=\"font-size: 300%;\"> This is the mode I much prefer. It's a relatively slow-paced game and you need real chips to play. In addition, you need two iPhones or iPod touches and a WiFi. You and your friend control game rules, betting actions, posting blinds, buy-in, rebuy and almost all aspects of the game. The iPhone merely shuffles and deals cards for you. Shuffle your chips, needle your buddy, drink beer, play all action no fluff heads-up poker and have loads of fun! </p>"
		@"<p style=\"font-size: 300%;\"> Note that you don't have to Stud Hi in this mode. You can play Stud Hi/Lo, Razz or even mixed Stud games. You can play a heads-up tournament. The blinds can stay the same throughout the match or it can go up every x minutes. Or you can just play cash game. It's all up to you.</p>"
		@"<h1 style=\"font-size: 500%;\"> Game Mode</h1>"
		@"<p style=\"font-size: 300%;\"> This is the mode most of my friends prefer. You don't need chips or cards. The iPhone will do everything for you: shuffling, dealing, keeping track of pot size, betting, raising, winning hand and everything else. Just sit back and play. </p>"
		@"<p style=\"font-size: 300%;\"> This mode is essentially computer poker. However, you can watch your friend's facial expression and mannerisms. More importantly, you host the game on your own iPhone at your own pad and you are not playing a total stranger somewhere in Nigeria so you don't ever have to worry about getting cheated.</p>"
		
		@"<h1 style=\"font-size: 500%;\"> Coming Soon</h1>"
		@"<p style=\"font-size: 300%; color: red\"> 1. No requirement for WiFi. All you need is two iPhones/iPod touches and you can play heads-up poker with your friend literally anywhere in the world, even on an airplane.</p>"
		@"<p style=\"font-size: 300%;\"> 2. Adjustable initial stack size for tournament mode.</p>"
		@"<p style=\"font-size: 300%;\"> 3. Cash game mode. Re-buy will be allowed.</p>"
		@"<p style=\"font-size: 300%;\"> 4. SNG mode. A digital clock will be added. You will be able to set how frequently the blinds go up.</p>"
		@"<p style=\"font-size: 300%;\"> 5. Hand history. You can review all the hands you just played on your iPhone and have them emailed to you.</p>"
		@"<p style=\"font-size: 300%;\"> 6. You will be able to pause the game, take a break or even come back a few days later to finish off the session with your friend.</p>"
		@"<p style=\"font-size: 300%;\"> 7. Stud Hi/Lo</p>"
		@"<p style=\"font-size: 300%;\"> 8. Razz</p>"		
		@"<p style=\"font-size: 300%;\"> All future upgrades will be free. You only have to pay once. So why not get it today and start enjoying the action?</p>"
		@"<p style=\"font-size: 300%;\"> Should you have any questions or suggestions, email me at headsupftw@gmail.com</p>"
		
		@"</body></html>";  		
	} else if (BUILD == HU_STUD_FREE) {
		html = @"<html><head><title>Help Page</title></head><body>"
		@"<h1 style=\"font-size: 500%;\">Troubleshooting</h1>"
		@"<p style=\"font-size: 300%;\"> <b>1. I don't see the other iPhone on the startup screen.</b></p>"
		@"<p style=\"font-size: 300%;\"> Go to Settings -> WiFi and make sure both iPhones are connected to the same WiFi network.</p>"
		@"<p style=\"font-size: 300%;\"> <b>2. Both iPhones are connected to the same WiFi but I still don't see the other iPhone.</b></p>"
		@"<p style=\"font-size: 300%;\"> Depending on the WiFi hotspot, sometimes it takes up to 30 seconds to see the other iPhone. But once the game is started, there will be virtually no delay.</p>"
		@"<p style=\"font-size: 300%;\"> <b>3. Okay now I see the other iPhone. But when I tap its name, it turns blue and nothing happens.</b></p>"
		@"<p style=\"font-size: 300%;\"> Again, depending on the WiFi hotspot, sometimes it takes a little while to start the game. When you \"get stuck\", tap anywhere to deselect the row and retry, or simply exit out of the app on both iPhones and restart it. It usually fixes the problem immediately.</p>"
		@"<p style=\"font-size: 300%;\"> <b>4. I played with my friend a couple days ago. But now with the same two iPhones and WiFi we can't see each other on the startup screen.</b></p>"
		@"<p style=\"font-size: 300%;\"> Make sure the two iPhones have the same version of this app. Two different versions will not be able to see each other. You can find out the version number at the bottom of the startup screen.</p>"
		@"<p style=\"font-size: 300%;\"> <b>5. I don't have WiFi. Can I still use this app to play heads-up poker?</b></p>"
		@"<p style=\"font-size: 300%;\"> Unfortunately at this point WiFi is mandatory. However, in the near future, this requirement will become obsolete. You will then be able to play Headsup Stud even without a WiFi. Also keep in mind you can easily create a WiFi hotspot on your Mac computer and have both iPhones hooked up to the Mac wirelessly and start playing heads-up poker.</p>"
		
		@"<h1 style=\"font-size: 500%;\"> Shuffler/Dealer Mode</h1>"
		@"<p style=\"font-size: 300%;\"> This is the mode I much prefer. It's a relatively slow-paced game and you need real chips to play. In addition, you need two iPhones or iPod touches and a WiFi. You and your friend control game rules, betting actions, posting blinds, buy-in, rebuy and almost all aspects of the game. The iPhone merely shuffles and deals cards for you. Shuffle your chips, needle your buddy, drink beer, play all action no fluff heads-up poker and have loads of fun! </p>"
		@"<p style=\"font-size: 300%;\"> Note that you don't have to Stud Hi in this mode. You can play Stud Hi/Lo, Razz or even mixed Stud games. You can play a heads-up tournament. The blinds can stay the same throughout the match or it can go up every x minutes. Or you can just play cash game. It's all up to you.</p>"
		@"<h1 style=\"font-size: 500%;\"> Game Mode</h1>"
		@"<p style=\"font-size: 300%;\"> This is the mode most of my friends prefer. You don't need chips or cards. The iPhone will do everything for you: shuffling, dealing, keeping track of pot size, betting, raising, winning hand and everything else. Just sit back and play. </p>"
		@"<p style=\"font-size: 300%;\"> This mode is essentially computer poker. However, you can watch your friend's facial expression and mannerisms. More importantly, you host the game on your own iPhone at your own pad and you are not playing a total stranger somewhere in Nigeria so you don't ever have to worry about getting cheated.</p>"
		
		@"<h1 style=\"font-size: 500%;\"> Coming Soon</h1>"
		@"<p style=\"font-size: 300%; color: red\"> 1. No requirement for WiFi. All you need is two iPhones/iPod touches and you can play heads-up poker with your friend literally anywhere in the world, even on an airplane.</p>"
		@"<p style=\"font-size: 300%;\"> 2. Adjustable initial stack size for tournament mode.</p>"
		@"<p style=\"font-size: 300%;\"> 3. Cash game mode. Re-buy will be allowed.</p>"
		@"<p style=\"font-size: 300%;\"> 4. SNG mode. A digital clock will be added. You will be able to set how frequently the blinds go up.</p>"
		@"<p style=\"font-size: 300%;\"> 5. Hand history. You can review all the hands you just played on your iPhone and have them emailed to you.</p>"
		@"<p style=\"font-size: 300%;\"> 6. You will be able to pause the game, take a break or even come back a few days later to finish off the session with your friend.</p>"
		@"<p style=\"font-size: 300%;\"> 7. Stud Hi/Lo</p>"
		@"<p style=\"font-size: 300%;\"> 8. Razz</p>"		
		@"<p style=\"font-size: 300%;\"> All future upgrades will be free. You only have to pay once. So why not get it today and start enjoying the action?</p>"
		@"<p style=\"font-size: 300%;\"> Should you have any questions or suggestions, email me at headsupftw@gmail.com</p>"
		
		@"</body></html>";  		
	} else if (BUILD == HU_DRAW) {
		html = @"<html><head><title>Help Page</title></head><body>"
		@"<h1 style=\"font-size: 500%;\">Troubleshooting</h1>"
		@"<p style=\"font-size: 300%;\"> <b>1. I don't see the other iPhone on the startup screen.</b></p>"
		@"<p style=\"font-size: 300%;\"> Go to Settings -> WiFi and make sure both iPhones are connected to the same WiFi network.</p>"
		@"<p style=\"font-size: 300%;\"> <b>2. Both iPhones are connected to the same WiFi but I still don't see the other iPhone.</b></p>"
		@"<p style=\"font-size: 300%;\"> Depending on the WiFi hotspot, sometimes it takes up to 30 seconds to see the other iPhone. But once the game is started, there will be virtually no delay.</p>"
		@"<p style=\"font-size: 300%;\"> <b>3. Okay now I see the other iPhone. But when I tap its name, it turns blue and nothing happens.</b></p>"
		@"<p style=\"font-size: 300%;\"> Again, depending on the WiFi hotspot, sometimes it takes a little while to start the game. When you \"get stuck\", tap anywhere to deselect the row and retry, or simply exit out of the app on both iPhones and restart it. It usually fixes the problem immediately.</p>"
		@"<p style=\"font-size: 300%;\"> <b>4. I played with my friend a couple days ago. But now with the same two iPhones and WiFi we can't see each other on the startup screen.</b></p>"
		@"<p style=\"font-size: 300%;\"> Make sure the two iPhones have the same version of this app. Two different versions will not be able to see each other. You can find out the version number at the bottom of the startup screen.</p>"
		@"<p style=\"font-size: 300%;\"> <b>5. I don't have WiFi. Can I still use this app to play heads-up poker?</b></p>"
		@"<p style=\"font-size: 300%;\"> Unfortunately at this point WiFi is mandatory. However, in the near future, this requirement will become obsolete. You will then be able to play Headsup Stud even without a WiFi. Also keep in mind you can easily create a WiFi hotspot on your Mac computer and have both iPhones hooked up to the Mac wirelessly and start playing heads-up poker.</p>"
		
		@"<h1 style=\"font-size: 500%;\"> Shuffler/Dealer Mode</h1>"
		@"<p style=\"font-size: 300%;\"> This is the mode I much prefer. It's a relatively slow-paced game and you need real chips to play. In addition, you need two iPhones or iPod touches and a WiFi. You and your friend control game rules, betting actions, posting blinds, buy-in, rebuy and almost all aspects of the game. The iPhone merely shuffles and deals cards for you. Shuffle your chips, needle your buddy, drink beer, play all action no fluff heads-up poker and have loads of fun! </p>"
		@"<p style=\"font-size: 300%;\"> Note that you don't have to Stud Hi in this mode. You can play Stud Hi/Lo, Razz or even mixed Stud games. You can play a heads-up tournament. The blinds can stay the same throughout the match or it can go up every x minutes. Or you can just play cash game. It's all up to you.</p>"
		@"<h1 style=\"font-size: 500%;\"> Game Mode</h1>"
		@"<p style=\"font-size: 300%;\"> This is the mode most of my friends prefer. You don't need chips or cards. The iPhone will do everything for you: shuffling, dealing, keeping track of pot size, betting, raising, winning hand and everything else. Just sit back and play. </p>"
		@"<p style=\"font-size: 300%;\"> This mode is essentially computer poker. However, you can watch your friend's facial expression and mannerisms. More importantly, you host the game on your own iPhone at your own pad and you are not playing a total stranger somewhere in Nigeria so you don't ever have to worry about getting cheated.</p>"
		
		@"<h1 style=\"font-size: 500%;\"> Coming Soon</h1>"
		@"<p style=\"font-size: 300%; color: red\"> 1. No requirement for WiFi. All you need is two iPhones/iPod touches and you can play heads-up poker with your friend literally anywhere in the world, even on an airplane.</p>"
		@"<p style=\"font-size: 300%;\"> 2. Adjustable initial stack size for tournament mode.</p>"
		@"<p style=\"font-size: 300%;\"> 3. Cash game mode. Re-buy will be allowed.</p>"
		@"<p style=\"font-size: 300%;\"> 4. SNG mode. A digital clock will be added. You will be able to set how frequently the blinds go up.</p>"
		@"<p style=\"font-size: 300%;\"> 5. Hand history. You can review all the hands you just played on your iPhone and have them emailed to you.</p>"
		@"<p style=\"font-size: 300%;\"> 6. You will be able to pause the game, take a break or even come back a few days later to finish off the session with your friend.</p>"
		@"<p style=\"font-size: 300%;\"> 7. Stud Hi/Lo</p>"
		@"<p style=\"font-size: 300%;\"> 8. Razz</p>"		
		@"<p style=\"font-size: 300%;\"> All future upgrades will be free. You only have to pay once. So why not get it today and start enjoying the action?</p>"
		@"<p style=\"font-size: 300%;\"> Should you have any questions or suggestions, email me at headsupftw@gmail.com</p>"
		
		@"</body></html>";  		
	} else if (BUILD == HU_DRAW_FREE) {
		html = @"<html><head><title>Help Page</title></head><body>"
		@"<h1 style=\"font-size: 500%;\">Troubleshooting</h1>"
		@"<p style=\"font-size: 300%;\"> <b>1. I don't see the other iPhone on the startup screen.</b></p>"
		@"<p style=\"font-size: 300%;\"> Go to Settings -> WiFi and make sure both iPhones are connected to the same WiFi network.</p>"
		@"<p style=\"font-size: 300%;\"> <b>2. Both iPhones are connected to the same WiFi but I still don't see the other iPhone.</b></p>"
		@"<p style=\"font-size: 300%;\"> Depending on the WiFi hotspot, sometimes it takes up to 30 seconds to see the other iPhone. But once the game is started, there will be virtually no delay.</p>"
		@"<p style=\"font-size: 300%;\"> <b>3. Okay now I see the other iPhone. But when I tap its name, it turns blue and nothing happens.</b></p>"
		@"<p style=\"font-size: 300%;\"> Again, depending on the WiFi hotspot, sometimes it takes a little while to start the game. When you \"get stuck\", tap anywhere to deselect the row and retry, or simply exit out of the app on both iPhones and restart it. It usually fixes the problem immediately.</p>"
		@"<p style=\"font-size: 300%;\"> <b>4. I played with my friend a couple days ago. But now with the same two iPhones and WiFi we can't see each other on the startup screen.</b></p>"
		@"<p style=\"font-size: 300%;\"> Make sure the two iPhones have the same version of this app. Two different versions will not be able to see each other. You can find out the version number at the bottom of the startup screen.</p>"
		@"<p style=\"font-size: 300%;\"> <b>5. I don't have WiFi. Can I still use this app to play heads-up poker?</b></p>"
		@"<p style=\"font-size: 300%;\"> Unfortunately at this point WiFi is mandatory. However, in the near future, this requirement will become obsolete. You will then be able to play Headsup Stud even without a WiFi. Also keep in mind you can easily create a WiFi hotspot on your Mac computer and have both iPhones hooked up to the Mac wirelessly and start playing heads-up poker.</p>"
		
		@"<h1 style=\"font-size: 500%;\"> Shuffler/Dealer Mode</h1>"
		@"<p style=\"font-size: 300%;\"> This is the mode I much prefer. It's a relatively slow-paced game and you need real chips to play. In addition, you need two iPhones or iPod touches and a WiFi. You and your friend control game rules, betting actions, posting blinds, buy-in, rebuy and almost all aspects of the game. The iPhone merely shuffles and deals cards for you. Shuffle your chips, needle your buddy, drink beer, play all action no fluff heads-up poker and have loads of fun! </p>"
		@"<p style=\"font-size: 300%;\"> Note that you don't have to Stud Hi in this mode. You can play Stud Hi/Lo, Razz or even mixed Stud games. You can play a heads-up tournament. The blinds can stay the same throughout the match or it can go up every x minutes. Or you can just play cash game. It's all up to you.</p>"
		@"<h1 style=\"font-size: 500%;\"> Game Mode</h1>"
		@"<p style=\"font-size: 300%;\"> This is the mode most of my friends prefer. You don't need chips or cards. The iPhone will do everything for you: shuffling, dealing, keeping track of pot size, betting, raising, winning hand and everything else. Just sit back and play. </p>"
		@"<p style=\"font-size: 300%;\"> This mode is essentially computer poker. However, you can watch your friend's facial expression and mannerisms. More importantly, you host the game on your own iPhone at your own pad and you are not playing a total stranger somewhere in Nigeria so you don't ever have to worry about getting cheated.</p>"
		
		@"<h1 style=\"font-size: 500%;\"> Coming Soon</h1>"
		@"<p style=\"font-size: 300%; color: red\"> 1. No requirement for WiFi. All you need is two iPhones/iPod touches and you can play heads-up poker with your friend literally anywhere in the world, even on an airplane.</p>"
		@"<p style=\"font-size: 300%;\"> 2. Adjustable initial stack size for tournament mode.</p>"
		@"<p style=\"font-size: 300%;\"> 3. Cash game mode. Re-buy will be allowed.</p>"
		@"<p style=\"font-size: 300%;\"> 4. SNG mode. A digital clock will be added. You will be able to set how frequently the blinds go up.</p>"
		@"<p style=\"font-size: 300%;\"> 5. Hand history. You can review all the hands you just played on your iPhone and have them emailed to you.</p>"
		@"<p style=\"font-size: 300%;\"> 6. You will be able to pause the game, take a break or even come back a few days later to finish off the session with your friend.</p>"
		@"<p style=\"font-size: 300%;\"> 7. Stud Hi/Lo</p>"
		@"<p style=\"font-size: 300%;\"> 8. Razz</p>"		
		@"<p style=\"font-size: 300%;\"> All future upgrades will be free. You only have to pay once. So why not get it today and start enjoying the action?</p>"
		@"<p style=\"font-size: 300%;\"> Should you have any questions or suggestions, email me at headsupftw@gmail.com</p>"
		
		@"</body></html>";  		
	} else if (BUILD == HU_MIXED) {
		html = @"<html><head><title>Help Page</title></head><body>"
		@"<h1 style=\"font-size: 500%;\">Troubleshooting</h1>"
		@"<p style=\"font-size: 300%;\"> <b>1. I don't see the other iPhone on the startup screen.</b></p>"
		@"<p style=\"font-size: 300%;\"> Go to Settings -> WiFi and make sure both iPhones are connected to the same WiFi network.</p>"
		@"<p style=\"font-size: 300%;\"> <b>2. Both iPhones are connected to the same WiFi but I still don't see the other iPhone.</b></p>"
		@"<p style=\"font-size: 300%;\"> Depending on the WiFi hotspot, sometimes it takes up to 30 seconds to see the other iPhone. But once the game is started, there will be virtually no delay.</p>"
		@"<p style=\"font-size: 300%;\"> <b>3. Okay now I see the other iPhone. But when I tap its name, it turns blue and nothing happens.</b></p>"
		@"<p style=\"font-size: 300%;\"> Again, depending on the WiFi hotspot, sometimes it takes a little while to start the game. When you \"get stuck\", tap anywhere to deselect the row and retry, or simply exit out of the app on both iPhones and restart it. It usually fixes the problem immediately.</p>"
		@"<p style=\"font-size: 300%;\"> <b>4. I played with my friend a couple days ago. But now with the same two iPhones and WiFi we can't see each other on the startup screen.</b></p>"
		@"<p style=\"font-size: 300%;\"> Make sure the two iPhones have the same version of this app. Two different versions will not be able to see each other. You can find out the version number at the bottom of the startup screen.</p>"
		@"<p style=\"font-size: 300%;\"> <b>5. I don't have WiFi. Can I still use this app to play heads-up poker?</b></p>"
		@"<p style=\"font-size: 300%;\"> Unfortunately at this point WiFi is mandatory. However, in the near future, this requirement will become obsolete. You will then be able to play Headsup Stud even without a WiFi. Also keep in mind you can easily create a WiFi hotspot on your Mac computer and have both iPhones hooked up to the Mac wirelessly and start playing heads-up poker.</p>"
		
		@"<h1 style=\"font-size: 500%;\"> Shuffler/Dealer Mode</h1>"
		@"<p style=\"font-size: 300%;\"> This is the mode I much prefer. It's a relatively slow-paced game and you need real chips to play. In addition, you need two iPhones or iPod touches and a WiFi. You and your friend control game rules, betting actions, posting blinds, buy-in, rebuy and almost all aspects of the game. The iPhone merely shuffles and deals cards for you. Shuffle your chips, needle your buddy, drink beer, play all action no fluff heads-up poker and have loads of fun! </p>"
		@"<p style=\"font-size: 300%;\"> Note that you don't have to Stud Hi in this mode. You can play Stud Hi/Lo, Razz or even mixed Stud games. You can play a heads-up tournament. The blinds can stay the same throughout the match or it can go up every x minutes. Or you can just play cash game. It's all up to you.</p>"
		@"<h1 style=\"font-size: 500%;\"> Game Mode</h1>"
		@"<p style=\"font-size: 300%;\"> This is the mode most of my friends prefer. You don't need chips or cards. The iPhone will do everything for you: shuffling, dealing, keeping track of pot size, betting, raising, winning hand and everything else. Just sit back and play. </p>"
		@"<p style=\"font-size: 300%;\"> This mode is essentially computer poker. However, you can watch your friend's facial expression and mannerisms. More importantly, you host the game on your own iPhone at your own pad and you are not playing a total stranger somewhere in Nigeria so you don't ever have to worry about getting cheated.</p>"
		
		@"<h1 style=\"font-size: 500%;\"> Coming Soon</h1>"
		@"<p style=\"font-size: 300%; color: red\"> 1. No requirement for WiFi. All you need is two iPhones/iPod touches and you can play heads-up poker with your friend literally anywhere in the world, even on an airplane.</p>"
		@"<p style=\"font-size: 300%;\"> 2. Adjustable initial stack size for tournament mode.</p>"
		@"<p style=\"font-size: 300%;\"> 3. Cash game mode. Re-buy will be allowed.</p>"
		@"<p style=\"font-size: 300%;\"> 4. SNG mode. A digital clock will be added. You will be able to set how frequently the blinds go up.</p>"
		@"<p style=\"font-size: 300%;\"> 5. Hand history. You can review all the hands you just played on your iPhone and have them emailed to you.</p>"
		@"<p style=\"font-size: 300%;\"> 6. You will be able to pause the game, take a break or even come back a few days later to finish off the session with your friend.</p>"
		@"<p style=\"font-size: 300%;\"> 7. Stud Hi/Lo</p>"
		@"<p style=\"font-size: 300%;\"> 8. Razz</p>"		
		@"<p style=\"font-size: 300%;\"> All future upgrades will be free. You only have to pay once. So why not get it today and start enjoying the action?</p>"
		@"<p style=\"font-size: 300%;\"> Should you have any questions or suggestions, email me at headsupftw@gmail.com</p>"
		
		@"</body></html>";  		
	} else if (BUILD == HU_MIXED_FREE) {
		html = @"<html><head><title>Help Page</title></head><body>"
		@"<h1 style=\"font-size: 500%;\">Troubleshooting</h1>"
		@"<p style=\"font-size: 300%;\"> <b>1. I don't see the other iPhone on the startup screen.</b></p>"
		@"<p style=\"font-size: 300%;\"> Go to Settings -> WiFi and make sure both iPhones are connected to the same WiFi network.</p>"
		@"<p style=\"font-size: 300%;\"> <b>2. Both iPhones are connected to the same WiFi but I still don't see the other iPhone.</b></p>"
		@"<p style=\"font-size: 300%;\"> Depending on the WiFi hotspot, sometimes it takes up to 30 seconds to see the other iPhone. But once the game is started, there will be virtually no delay.</p>"
		@"<p style=\"font-size: 300%;\"> <b>3. Okay now I see the other iPhone. But when I tap its name, it turns blue and nothing happens.</b></p>"
		@"<p style=\"font-size: 300%;\"> Again, depending on the WiFi hotspot, sometimes it takes a little while to start the game. When you \"get stuck\", tap anywhere to deselect the row and retry, or simply exit out of the app on both iPhones and restart it. It usually fixes the problem immediately.</p>"
		@"<p style=\"font-size: 300%;\"> <b>4. I played with my friend a couple days ago. But now with the same two iPhones and WiFi we can't see each other on the startup screen.</b></p>"
		@"<p style=\"font-size: 300%;\"> Make sure the two iPhones have the same version of this app. Two different versions will not be able to see each other. You can find out the version number at the bottom of the startup screen.</p>"
		@"<p style=\"font-size: 300%;\"> <b>5. I don't have WiFi. Can I still use this app to play heads-up poker?</b></p>"
		@"<p style=\"font-size: 300%;\"> Unfortunately at this point WiFi is mandatory. However, in the near future, this requirement will become obsolete. You will then be able to play Headsup Stud even without a WiFi. Also keep in mind you can easily create a WiFi hotspot on your Mac computer and have both iPhones hooked up to the Mac wirelessly and start playing heads-up poker.</p>"
		
		@"<h1 style=\"font-size: 500%;\"> Shuffler/Dealer Mode</h1>"
		@"<p style=\"font-size: 300%;\"> This is the mode I much prefer. It's a relatively slow-paced game and you need real chips to play. In addition, you need two iPhones or iPod touches and a WiFi. You and your friend control game rules, betting actions, posting blinds, buy-in, rebuy and almost all aspects of the game. The iPhone merely shuffles and deals cards for you. Shuffle your chips, needle your buddy, drink beer, play all action no fluff heads-up poker and have loads of fun! </p>"
		@"<p style=\"font-size: 300%;\"> Note that you don't have to Stud Hi in this mode. You can play Stud Hi/Lo, Razz or even mixed Stud games. You can play a heads-up tournament. The blinds can stay the same throughout the match or it can go up every x minutes. Or you can just play cash game. It's all up to you.</p>"
		@"<h1 style=\"font-size: 500%;\"> Game Mode</h1>"
		@"<p style=\"font-size: 300%;\"> This is the mode most of my friends prefer. You don't need chips or cards. The iPhone will do everything for you: shuffling, dealing, keeping track of pot size, betting, raising, winning hand and everything else. Just sit back and play. </p>"
		@"<p style=\"font-size: 300%;\"> This mode is essentially computer poker. However, you can watch your friend's facial expression and mannerisms. More importantly, you host the game on your own iPhone at your own pad and you are not playing a total stranger somewhere in Nigeria so you don't ever have to worry about getting cheated.</p>"
		
		@"<h1 style=\"font-size: 500%;\"> Coming Soon</h1>"
		@"<p style=\"font-size: 300%; color: red\"> 1. No requirement for WiFi. All you need is two iPhones/iPod touches and you can play heads-up poker with your friend literally anywhere in the world, even on an airplane.</p>"
		@"<p style=\"font-size: 300%;\"> 2. Adjustable initial stack size for tournament mode.</p>"
		@"<p style=\"font-size: 300%;\"> 3. Cash game mode. Re-buy will be allowed.</p>"
		@"<p style=\"font-size: 300%;\"> 4. SNG mode. A digital clock will be added. You will be able to set how frequently the blinds go up.</p>"
		@"<p style=\"font-size: 300%;\"> 5. Hand history. You can review all the hands you just played on your iPhone and have them emailed to you.</p>"
		@"<p style=\"font-size: 300%;\"> 6. You will be able to pause the game, take a break or even come back a few days later to finish off the session with your friend.</p>"
		@"<p style=\"font-size: 300%;\"> 7. Stud Hi/Lo</p>"
		@"<p style=\"font-size: 300%;\"> 8. Razz</p>"		
		@"<p style=\"font-size: 300%;\"> All future upgrades will be free. You only have to pay once. So why not get it today and start enjoying the action?</p>"
		@"<p style=\"font-size: 300%;\"> Should you have any questions or suggestions, email me at headsupftw@gmail.com</p>"
		
		@"</body></html>";  		
	}		




	
	
	[helpTextView loadHTMLString:html baseURL:[NSURL URLWithString:@"http://www.apple.com"]];  
}


- (void)dealloc {
    [super dealloc];
}

- (IBAction) doneButtonPressed:(id)sender {
	[navController popViewControllerAnimated:YES];
}

- (IBAction) shufflerTabSelected:(id)sender {
	NSLog(@"sfsdf");
}



@end
