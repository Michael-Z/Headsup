/*

File: Picker.m
Abstract: 
 A view that displays both the currently advertised game name and a list of
other games
 available on the local network (discovered & displayed by
BrowserViewController).
 

Version: 1.5
*/

#import <GameKit/GameKit.h>

#import <sys/utsname.h>

#import "Picker.h"
#import "AppController.h"
#import "GameCenterManager.h"
#import "Reachability.h"
//#import "AdMobView.h"

#define kOffset 5.0

@interface Picker () {
enum GameName gameName;
UIButton *authenticateGameCenter;
UIButton *holdemGameCenter, *leaderboards, *achievements;
UILabel *connectingToGameCenterLabel;
}

@property (nonatomic, retain, readwrite) BrowserViewController* bvc;
@property (nonatomic, retain, readwrite) UILabel* gameNameLabel;

- (void)startUserAuthentication;
- (void)showMatchmaker:(GKMatchmakerViewController *)matchmakerViewController;
- (void)showError:(NSError *)error;
@end

@implementation Picker

@synthesize bvc = _bvc;
@synthesize gameNameLabel = _gameNameLabel;

/*- (NSString *)publisherId {
	return @"a14a1468ba504e3"; // this should be prefilled; if not, get it from www.admob.com
}

- (UIColor *)adBackgroundColor {
	return [UIColor colorWithRed:0 green:0 blue:0 alpha:1]; // this should be prefilled; if not, provide an RGB-based UIColor
}

- (UIColor *)primaryTextColor {
	return [UIColor colorWithRed:1 green:1 blue:1 alpha:1]; // this should be prefilled; if not, provide a UIColor
}

- (UIColor *)secondaryTextColor {
	return [UIColor colorWithRed:1 green:1 blue:1 alpha:1]; // this should be prefilled; if not, provide a UIColor
}

- (BOOL)mayAskForLocation {
	return NO;
}*/

- (void) addRollerView {
	/*if (BUILD == HU_HOLDEM_FREE) {
		[rollerView removeFromSuperview];
		rollerView = [AdMobView requestAdWithDelegate:self]; // start a new ad request
		rollerView.frame = CGRectMake(0, 0, 320, 48); // set the frame, in this case at the bottom of the screen
		[self addSubview:rollerView];
	}*/
	
	
	 if (BUILD == HU_HOLDEM_FREE) {
		 //ARRollerView* rollerView = [ARRollerView requestRollerViewWithDelegate:self.bvc];
		 //[self addSubview:rollerView];
		 adView = [AdWhirlView requestAdWhirlViewWithDelegate:self.bvc]; 
		 [self addSubview:adView];
	 }
}	

- (void) registerForAuthenticationNotification
{
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; 
	[nc addObserver:(AppController*)[[UIApplication sharedApplication] delegate]
		   selector:@selector(authenticationChanged) 
			   name:GKPlayerAuthenticationDidChangeNotificationName
			 object:nil];
}

- (id)initWithFrame:(CGRect)frame type:(NSString*)type {
	if ((self = [super initWithFrame:frame])) {
		self.bvc = [[BrowserViewController alloc] initWithTitle:nil showDisclosureIndicators:NO showCancelButton:NO];
		[self.bvc searchForServicesOfType:type inDomain:@"local"];
		
		self.opaque = YES;
		self.backgroundColor = [UIColor blackColor];
		
		UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
		backgroundImage.frame = CGRectMake(0, 0, 320, 480);
		[self addSubview:backgroundImage];
		[backgroundImage release];
		
		
		[self addRollerView];		
				
		CGFloat runningY = BUILD == HU_HOLDEM_FREE ? 52 : kOffset;
		CGFloat width = self.bounds.size.width - 2 * kOffset;
		
		// commented out for Headsup 3G
		
		//UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
		UILabel* label;
		// headsup 3g
		runningY += 35;
		/*[label setTextAlignment:UITextAlignmentCenter];
		[label setFont:[UIFont boldSystemFontOfSize:15.0]];
		[label setTextColor:[UIColor whiteColor]];
		[label setShadowColor:[UIColor colorWithWhite:0.0 alpha:0.75]];
		[label setShadowOffset:CGSizeMake(1,1)];
		[label setBackgroundColor:[UIColor clearColor]];
		//label.text = @"Waiting for another player to join game:";
		label.text = @"";
		label.numberOfLines = 1;
		[label sizeToFit];
		label.frame = CGRectMake(kOffset, runningY, width, label.frame.size.height);
		[self addSubview:label];
		
		runningY += label.bounds.size.height;
		[label release];
		
		self.gameNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[self.gameNameLabel setTextAlignment:UITextAlignmentCenter];
		[self.gameNameLabel setFont:[UIFont boldSystemFontOfSize:24.0]];
		[self.gameNameLabel setLineBreakMode:UILineBreakModeTailTruncation];
		[self.gameNameLabel setTextColor:[UIColor whiteColor]];
		[self.gameNameLabel setShadowColor:[UIColor colorWithWhite:0.0 alpha:0.75]];
		[self.gameNameLabel setShadowOffset:CGSizeMake(1,1)];
		[self.gameNameLabel setBackgroundColor:[UIColor clearColor]];
		[self.gameNameLabel setText:@"Default Name"];
		[self.gameNameLabel sizeToFit];
		[self.gameNameLabel setFrame:CGRectMake(kOffset, runningY, width, self.gameNameLabel.frame.size.height)];
		[self.gameNameLabel setText:@""];
		[self addSubview:self.gameNameLabel];
		
		runningY += self.gameNameLabel.bounds.size.height + kOffset * 2;
		
		//if ([[Reachability sharedReachability] localWiFiConnectionStatus] == ReachableViaWiFiNetwork) {
		label = [[UILabel alloc] initWithFrame:CGRectZero];
		[label setTextAlignment:UITextAlignmentCenter];
		[label setFont:[UIFont boldSystemFontOfSize:15.0]];
		[label setTextColor:[UIColor yellowColor]];
		[label setShadowColor:[UIColor colorWithWhite:0.0 alpha:0.75]];
		[label setShadowOffset:CGSizeMake(1,1)];
		[label setBackgroundColor:[UIColor clearColor]];
		label.text = @"To play on two iPhones/iPod touches";
		label.numberOfLines = 1;
		[label sizeToFit];
		label.frame = CGRectMake(kOffset, runningY, width, label.frame.size.height);
		[self addSubview:label];
		
		runningY += label.bounds.size.height + 2;
		
		label = [[UILabel alloc] initWithFrame:CGRectZero];
		[label setTextAlignment:UITextAlignmentCenter];
		[label setFont:[UIFont boldSystemFontOfSize:15.0]];
		[label setTextColor:[UIColor yellowColor]];
		[label setShadowColor:[UIColor colorWithWhite:0.0 alpha:0.75]];
		[label setShadowOffset:CGSizeMake(1,1)];
		[label setBackgroundColor:[UIColor clearColor]];
		label.text = @"over Bluetooth or Wi-Fi, ";
		label.numberOfLines = 1;
		[label sizeToFit];
		label.frame = CGRectMake(kOffset, runningY, width, label.frame.size.height);
		[self addSubview:label];
		
		runningY += label.bounds.size.height + 2;
		
		label = [[UILabel alloc] initWithFrame:CGRectZero];
		[label setTextAlignment:UITextAlignmentCenter];
		[label setFont:[UIFont boldSystemFontOfSize:15.0]];
		[label setTextColor:[UIColor yellowColor]];
		[label setShadowColor:[UIColor colorWithWhite:0.0 alpha:0.75]];
		[label setShadowOffset:CGSizeMake(1,1)];
		[label setBackgroundColor:[UIColor clearColor]];
		label.text = @"tap Bluetooth or a name below.";
		label.numberOfLines = 1;
		[label sizeToFit];
		label.frame = CGRectMake(kOffset, runningY, width, label.frame.size.height);
		[self addSubview:label];
		
		if ([[Reachability sharedReachability] localWiFiConnectionStatus] != ReachableViaWiFiNetwork) {
			runningY += label.bounds.size.height + 2;
			
			label = [[UILabel alloc] initWithFrame:CGRectZero];
			[label setTextAlignment:UITextAlignmentCenter];
			[label setFont:[UIFont boldSystemFontOfSize:24.0]];
			[label setTextColor:[UIColor redColor]];
			[label setHighlightedTextColor:[UIColor redColor]];
			[label setHighlighted:YES];
			[label setShadowColor:[UIColor colorWithWhite:0.0 alpha:0.75]];
			[label setShadowOffset:CGSizeMake(1,1)];
			[label setBackgroundColor:[UIColor blueColor]];
			label.text = @"Warning: No Wi-Fi!";
			label.numberOfLines = 1;
			[label sizeToFit];
			label.frame = CGRectMake(kOffset, runningY, width, label.frame.size.height);
			[self addSubview:label];			
		}
		
		runningY += label.bounds.size.height + 2;		
		
		NSInteger tableViewHeight = self.bounds.size.height - runningY - 147;
		[self.bvc.view setFrame:CGRectMake(0, runningY, self.bounds.size.width, tableViewHeight)];
		[self addSubview:self.bvc.view];
				
		// buttons for single phone and single player mode
		runningY += tableViewHeight + 12;
		*/
		
		activityIndicatorView = 
			[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		activityIndicatorView.frame = CGRectMake(142, runningY, 37, 37);
		[self addSubview:activityIndicatorView];
		
		runningY += 40;
		connectingToGameCenterLabel =
			[[UILabel alloc] initWithFrame:CGRectZero];
		 [connectingToGameCenterLabel setTextAlignment:UITextAlignmentCenter];
		 [connectingToGameCenterLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
		 [connectingToGameCenterLabel setTextColor:[UIColor greenColor]];
		 [connectingToGameCenterLabel setShadowColor:[UIColor colorWithWhite:0.0 alpha:0.75]];
		 [connectingToGameCenterLabel setShadowOffset:CGSizeMake(1,1)];
		 [connectingToGameCenterLabel setBackgroundColor:[UIColor clearColor]];			 
		 connectingToGameCenterLabel.text = @"Connecting to Game Center...";
		 connectingToGameCenterLabel.numberOfLines = 1;
		 [connectingToGameCenterLabel sizeToFit];
		 connectingToGameCenterLabel.frame = CGRectMake(30, runningY, 250, connectingToGameCenterLabel.frame.size.height);			 
		
		[connectingToGameCenterLabel setHidden:YES];
		
		[self addSubview:connectingToGameCenterLabel];
		
		runningY += activityIndicatorView.bounds.size.height + 8;
		
		if (BUILD == HU_HOLDEM_FREE) {
			// paid version
			UIButton *infoBuy = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
			infoBuy.frame = CGRectMake(5, runningY, 100, 30);
			[infoBuy setImage:[UIImage imageNamed:@"wifi_buy.png"] forState:UIControlStateNormal];
			[infoBuy setTitle:@"Share" forState:UIControlStateNormal];
			[infoBuy addTarget:self action:@selector(buyButtonPressed) forControlEvents:UIControlEventTouchUpInside];
			//infoBuy.backgroundColor = [UIColor blackColor];	
			[infoBuy setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
			
			[self addSubview:infoBuy];			
		}
		
		// headsup blackjack
		UIButton *infoHeadsupBlackjack = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		infoHeadsupBlackjack.frame = CGRectMake(110, runningY, 100, 30);
		[infoHeadsupBlackjack setImage:[UIImage imageNamed:@"wifi_hublackjack.png"] forState:UIControlStateNormal];
		[infoHeadsupBlackjack setTitle:@"HU Blackjack" forState:UIControlStateNormal];
		[infoHeadsupBlackjack addTarget:self action:@selector(headsupBlackjackButtonPressed) forControlEvents:UIControlEventTouchUpInside];
		//infoHeadsupBlackjack.backgroundColor = [UIColor blackColor];	
		[infoHeadsupBlackjack setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
		
		[self addSubview:infoHeadsupBlackjack];	
		
		// device code string
		//iPhone Simulator == i386
		//iPhone == iPhone1,1
		//3G iPhone == iPhone1,2
		//3GS iPhone == iPhone2,1
		//iPhone 4 == iPhone3,1
		//1st Gen iPod == iPod1,1
		//2nd Gen iPod == iPod2,1
		struct utsname u;
		uname(&u);
		NSString *nameString = [NSString stringWithFormat:@"%s", u.machine];
		NSLog(@"device type: %@", nameString);
		
		// bluetooth connectivity: only available on iPhone OS 3.x; not supported 
		// on the original iPhone or first-gen iPod touch.
		// This code can run on devices running iPhone OS 2.0 or later  
		// The GKPeerPickerController class is only available in iPhone OS 3.0 or later. 
		// So, we must verify the existence of the above class and only show the Bluetooth
		// button if it exists.
		Class aGameKitClass = (NSClassFromString(@"GKPeerPickerController"));
		if (aGameKitClass != nil && 
			![nameString isEqualToString:@"iPhone1,1"] &&
			![nameString isEqualToString:@"iPod1,1"]) {
			UIButton *infoBluetooth = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
			infoBluetooth.frame = CGRectMake(215, runningY, 100, 30);
			[infoBluetooth setImage:[UIImage imageNamed:@"wifi_bluetooth.png"] forState:UIControlStateNormal];
			[infoBluetooth setTitle:@"Bluetooth" forState:UIControlStateNormal];
			[infoBluetooth addTarget:self action:@selector(bluetoothButtonPressed) forControlEvents:UIControlEventTouchUpInside];
			//infoBluetooth.backgroundColor = [UIColor blackColor];	
			[infoBluetooth setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
			
			[self addSubview:infoBluetooth];			
		}
		
	
		/*
		if (BUILD == HU_HOLDEM_FREE) {
			// Applitics share
			UIButton *infoShare = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
			infoShare.frame = CGRectMake(215, runningY, 100, 30);
			[infoShare setImage:[UIImage imageNamed:@"wifi_invite.png"] forState:UIControlStateNormal];
			[infoShare setTitle:@"Share" forState:UIControlStateNormal];
			[infoShare addTarget:self action:@selector(shareButtonPressed) forControlEvents:UIControlEventTouchUpInside];
			infoShare.backgroundColor = [UIColor blackColor];	
			[infoShare setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
			
			[self addSubview:infoShare];			
		}*/
		
		runningY += infoHeadsupBlackjack.bounds.size.height + 8;
				
		// single player
		UIButton *infoSinglePlayer = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		infoSinglePlayer.frame = CGRectMake(5, runningY, 100, 30);
		[infoSinglePlayer setImage:[UIImage imageNamed:@"wifi_singleplayer.png"] forState:UIControlStateNormal];
		[infoSinglePlayer setTitle:@"Single Player" forState:UIControlStateNormal];
		[infoSinglePlayer addTarget:self action:@selector(singlePlayerButtonPressed) forControlEvents:UIControlEventTouchUpInside];
		//infoSinglePlayer.backgroundColor = [UIColor blackColor];
		
		// blackjack
		UIButton *infoBlackjack = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		infoBlackjack.frame = CGRectMake(110, runningY, 100, 30);
		[infoBlackjack setImage:[UIImage imageNamed:@"wifi_blackjack.png"] forState:UIControlStateNormal];
		[infoBlackjack setTitle:@"Blackjack" forState:UIControlStateNormal];
		[infoBlackjack addTarget:self action:@selector(blackjackButtonPressed) forControlEvents:UIControlEventTouchUpInside];
		//infoBlackjack.backgroundColor = [UIColor blackColor];	
		[infoBlackjack setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
		
		// single phone
		UIButton *infoSinglePhone = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		infoSinglePhone.frame = CGRectMake(215, runningY, 100, 30);
		[infoSinglePhone setImage:[UIImage imageNamed:@"wifi_singlephone.png"] forState:UIControlStateNormal];
		[infoSinglePhone setTitle:@"Single Phone" forState:UIControlStateNormal];
		[infoSinglePhone addTarget:self action:@selector(singlePhoneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
		//infoSinglePhone.backgroundColor = [UIColor blackColor];		

		[self addSubview:infoSinglePlayer];	
		[self addSubview:infoBlackjack];			
		[self addSubview:infoSinglePhone];
		
		// button for preferences page
		runningY += infoSinglePhone.bounds.size.height + 8;
		UIButton *infoSettings = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		infoSettings.frame = CGRectMake(5, runningY, 100, 30);
		[infoSettings setImage:[UIImage imageNamed:@"wifi_settings.png"] forState:UIControlStateNormal];
		[infoSettings setTitle:@"Settings" forState:UIControlStateNormal];
		[infoSettings addTarget:self action:@selector(prefsButtonPressed) forControlEvents:UIControlEventTouchUpInside];
		//infoSettings.backgroundColor = [UIColor blackColor];
		
		// training mode
		UIButton *infoTraining = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		infoTraining.frame = CGRectMake(110, runningY, 100, 30);
		[infoTraining setImage:[UIImage imageNamed:@"wifi_training.png"] forState:UIControlStateNormal];
		[infoTraining setTitle:@"Training" forState:UIControlStateNormal];
		[infoTraining addTarget:self action:@selector(trainingButtonPressed) forControlEvents:UIControlEventTouchUpInside];
		//infoTraining.backgroundColor = [UIColor blackColor];
		[infoTraining setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
		
		// button for help page
		UIButton *infoHelp = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		infoHelp.frame = CGRectMake(215, runningY, 100, 30);
		[infoHelp setImage:[UIImage imageNamed:@"wifi_help.png"] forState:UIControlStateNormal];
		[infoHelp setTitle:@"Help" forState:UIControlStateNormal];
		[infoHelp addTarget:self action:@selector(helpButtonPressed) forControlEvents:UIControlEventTouchUpInside];
		//infoHelp.backgroundColor = [UIColor blackColor];
		
		[self addSubview:infoSettings];
		[self addSubview:infoTraining];
		[self addSubview:infoHelp];		

		if ([GameCenterManager isGameCenterAvailable]) {
			runningY += infoSinglePhone.bounds.size.height + 8;
			authenticateGameCenter = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
			authenticateGameCenter.frame = CGRectMake(110, runningY, 100, 30);
			[authenticateGameCenter setImage:[UIImage imageNamed:@"wifi_sign_in.png"] forState:UIControlStateNormal];
			[authenticateGameCenter setTitle:@"Authenticate" forState:UIControlStateNormal];
			[authenticateGameCenter addTarget:self action:@selector(startUserAuthentication) forControlEvents:UIControlEventTouchUpInside];
			
			[authenticateGameCenter setHidden:YES];
			[self addSubview:authenticateGameCenter];
			
			runningY += infoSinglePhone.bounds.size.height + 8;
			holdemGameCenter = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
			holdemGameCenter.frame = CGRectMake(5, runningY, 100, 30);
			[holdemGameCenter setImage:[UIImage imageNamed:@"wifi_internet_play.png"] forState:UIControlStateNormal];
			[holdemGameCenter setTitle:@"Net Holdem" forState:UIControlStateNormal];
			[holdemGameCenter addTarget:self action:@selector(gameCenterButtonPressed) forControlEvents:UIControlEventTouchUpInside];
			
			leaderboards = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
			leaderboards.frame = CGRectMake(110, runningY, 100, 30);
			[leaderboards setImage:[UIImage imageNamed:@"wifi_leaderboards.png"] forState:UIControlStateNormal];
			[leaderboards setTitle:@"Leaderboards" forState:UIControlStateNormal];
			[leaderboards addTarget:self action:@selector(leaderboardsButtonPressed) forControlEvents:UIControlEventTouchUpInside];
			
			achievements = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
			achievements.frame = CGRectMake(215, runningY, 100, 30);
			[achievements setImage:[UIImage imageNamed:@"wifi_achievements.png"] forState:UIControlStateNormal];
			[achievements setTitle:@"Achievements" forState:UIControlStateNormal];
			[achievements addTarget:self action:@selector(achievementsButtonPressed) forControlEvents:UIControlEventTouchUpInside];			
			
			[holdemGameCenter setHidden:YES];
			[leaderboards setHidden:YES];
			[achievements setHidden:YES];
			
			[self addSubview:holdemGameCenter];
			[self addSubview:leaderboards];
			[self addSubview:achievements];
		}
		
		runningY += infoSettings.bounds.size.height + 30;
		
		label = [[UILabel alloc] initWithFrame:CGRectZero];
		[label setTextAlignment:UITextAlignmentCenter];
		[label setFont:[UIFont boldSystemFontOfSize:15.0]];
		[label setTextColor:[UIColor greenColor]];
		[label setShadowColor:[UIColor colorWithWhite:0.0 alpha:0.75]];
		[label setShadowOffset:CGSizeMake(1,1)];
		[label setBackgroundColor:[UIColor clearColor]];
		NSString *versionString;
		
		if (BUILD == HU_HOLDEM)
			versionString = @"Headsup Poker 1.9.2";
		else if (BUILD == HU_HOLDEM_FREE)
			versionString = @"Headsup Poker 1.9.2";
		else if (BUILD == HU_OMAHA)
			versionString = @"Headsup Omaha Version 1.0.1";
		else if (BUILD == HU_OMAHA_FREE)
			versionString = @"Headsup Omaha Free Version 1.0";
		else if (BUILD == HU_STUD)
			versionString = @"Headsup Stud Version 1.0";
		else if (BUILD == HU_STUD_FREE)
			versionString = @"Headsup Stud Free Version 1.0";
		else if (BUILD == HU_DRAW)
			versionString = @"Headsup Draw Poker Version 1.0";
		else if (BUILD == HU_DRAW_FREE)
			versionString = @"Headsup Draw Poker Free Version 1.0";
		else if (BUILD == HU_MIXED)
			versionString = @"Headsup Mixed Poker Version 1.0";
		else if (BUILD == HU_MIXED_FREE)
			versionString = @"Headsup Mixed Poker Free Version 1.0";		
		else
			versionString = @"Version 1.0";
		
		label.text = versionString;
		label.numberOfLines = 1;
		[label sizeToFit];
		label.frame = CGRectMake(kOffset, 425, width, label.frame.size.height);
		[self addSubview:label];
		
		/*
		runningY += label.bounds.size.height + 2;
		label = [[UILabel alloc] initWithFrame:CGRectZero];
		[label setTextAlignment:UITextAlignmentCenter];
		[label setFont:[UIFont boldSystemFontOfSize:15.0]];
		[label setTextColor:[UIColor whiteColor]];
		[label setShadowColor:[UIColor colorWithWhite:0.0 alpha:0.75]];
		[label setShadowOffset:CGSizeMake(1,1)];
		[label setBackgroundColor:[UIColor clearColor]];
		label.text = @" You will only see iPhones/iPod touches";
		label.numberOfLines = 1;
		[label sizeToFit];
		label.frame = CGRectMake(kOffset, runningY, width, label.frame.size.height);
		[self addSubview:label];
		
		runningY += label.bounds.size.height + 2;
		label = [[UILabel alloc] initWithFrame:CGRectZero];
		[label setTextAlignment:UITextAlignmentCenter];
		[label setFont:[UIFont boldSystemFontOfSize:15.0]];
		[label setTextColor:[UIColor whiteColor]];
		[label setShadowColor:[UIColor colorWithWhite:0.0 alpha:0.75]];
		[label setShadowOffset:CGSizeMake(1,1)];
		[label setBackgroundColor:[UIColor clearColor]];
		label.text = @"running the same version";
		label.numberOfLines = 1;
		[label sizeToFit];
		label.frame = CGRectMake(kOffset, runningY, width, label.frame.size.height);
		[self addSubview:label];	

		// button for preferences page
		UIButton *infoPrefs = [[UIButton buttonWithType:UIButtonTypeDetailDisclosure] retain];
		infoPrefs.frame = CGRectMake(8, 452, 18, 19);
		[infoPrefs setTitle:@"User Preferences" forState:UIControlStateNormal];
		//infoPrefs.backgroundColor = [UIColor clearColor];
		[infoPrefs addTarget:self action:@selector(prefsButtonPressed) forControlEvents:UIControlEventTouchUpInside];
		infoPrefs.backgroundColor = [UIColor blackColor];
		
		[self addSubview:infoPrefs];
				
		// button for help page
		UIButton *infoLightButtonType = [[UIButton buttonWithType:UIButtonTypeInfoLight] retain];
		infoLightButtonType.frame = CGRectMake(294, 452, 18, 19);
		[infoLightButtonType setTitle:@"Detail Disclosure" forState:UIControlStateNormal];
		infoLightButtonType.backgroundColor = [UIColor clearColor];
		[infoLightButtonType addTarget:self action:@selector(helpButtonPressed) forControlEvents:UIControlEventTouchUpInside];
		infoLightButtonType.backgroundColor = [UIColor blackColor];
		
		[self addSubview:infoLightButtonType];
		 */
	}
	
	if ([GameCenterManager isGameCenterAvailable]) {
		[self registerForAuthenticationNotification];		 
		[self startUserAuthentication];
	}

	return self;
}

- (void) buyButtonPressed {
	// old code that simply leads user to the iTunes page of the paid version.
	NSString *iTunesLink = @"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=311899644&mt=8";
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
	
	//[(AppController*)[[UIApplication sharedApplication] delegate] buyButtonPressed];
}

- (void) helpButtonPressed {
	[(AppController*)[[UIApplication sharedApplication] delegate] presentHelpHoldemView];
}

- (void) prefsButtonPressed {
	[(AppController*)[[UIApplication sharedApplication] delegate] presentPrefsView];
}

- (void) singlePhoneButtonPressed {
	BOOL isOmaha = ([[NSUserDefaults standardUserDefaults] integerForKey:KEY_GAME_NAME] == kGameOmahaHi);
	
	if (isOmaha)
		[(AppController*)[[UIApplication sharedApplication] delegate] presentSinglePhoneModeOmahaGameModeView];
	else
		[(AppController*)[[UIApplication sharedApplication] delegate] presentSinglePhoneModeHoldemGameModeView];
}

- (void) trainingButtonPressed {
	BOOL isOmaha = ([[NSUserDefaults standardUserDefaults] integerForKey:KEY_GAME_NAME] == kGameOmahaHi);
	
	if (isOmaha)
		[(AppController*)[[UIApplication sharedApplication] delegate] presentTrainingModeOmahaGameModeView];
	else
		[(AppController*)[[UIApplication sharedApplication] delegate] presentTrainingModeHoldemGameModeView];
}

- (void) singlePlayerButtonPressed {
	BOOL isOmaha = ([[NSUserDefaults standardUserDefaults] integerForKey:KEY_GAME_NAME] == kGameOmahaHi);
	
	if (isOmaha)
		[(AppController*)[[UIApplication sharedApplication] delegate] presentSinglePlayerModeOmahaGameModeView];
	else
		[(AppController*)[[UIApplication sharedApplication] delegate] presentSinglePlayerModeHoldemGameModeView];
}

- (void) blackjackButtonPressed {
	[(AppController*)[[UIApplication sharedApplication] delegate] presentBlackjackGameModeView];
}

- (void) headsupBlackjackButtonPressed {
	[(AppController*)[[UIApplication sharedApplication] delegate] presentBlackjackHeadsupModeView];
}

/*- (void) shareButtonPressed {
	[(AppController*)[[UIApplication sharedApplication] delegate] presentInviteView];
}*/



// Hold'em Game Center play
- (void) gameCenterButtonPressed {
	//[(AppController*)[[UIApplication sharedApplication] delegate] presentGameCenterView];	
	
	gameName = kGameHoldem;
	GKMatchRequest *request = [[[GKMatchRequest alloc] init] autorelease];
	request.playerGroup = kGameHoldem;
    request.minPlayers = 2;
    request.maxPlayers = 2;
	[self showMatchmaker:[[GKMatchmakerViewController alloc] initWithMatchRequest:request]];		
}

- (void) leaderboardsButtonPressed {	
	GKLeaderboardViewController* leaderBoardViewController = [[GKLeaderboardViewController alloc] init];
    leaderBoardViewController.timeScope = GKLeaderboardTimeScopeWeek;
	//leaderBoardViewController.category 
	leaderBoardViewController.leaderboardDelegate = self;   
	
	UIViewController *gameCenterViewController = ((AppController *)[[UIApplication sharedApplication] delegate]).viewController;	
	
    [gameCenterViewController presentModalViewController:[leaderBoardViewController autorelease] animated:YES];
	
	GKLeaderboardViewController *myLeaderboardViewController = [[[GKLeaderboardViewController alloc] initWithNibName:nil bundle:nil] autorelease];
	
	[gameCenterViewController presentModalViewController: myLeaderboardViewController animated:YES];	
}


- (void)achievementsButtonPressed
{
	GKAchievementViewController* myAchievementsViewController =
	[[[GKAchievementViewController alloc] init] autorelease];
	[myAchievementsViewController setAchievementDelegate: self];
	UIViewController *gameCenterViewController = ((AppController *)[[UIApplication sharedApplication] delegate]).viewController;
	[gameCenterViewController presentModalViewController:myAchievementsViewController animated:YES];
}

- (void)setupInviteHandler {
    [[GKMatchmaker sharedMatchmaker] setInviteHandler:^(GKInvite *invite, NSArray *tmp) {
		NSLog(@"invite handler");
		[self showMatchmaker:[[GKMatchmakerViewController alloc] initWithInvite:invite]];
    }];
}

- (void)localPlayerDidAuthenticateWithPlayerId:(NSString*)localPlayerId
								   playerAlias:(NSString*)localPlayerAlias {

	[holdemGameCenter setHidden:NO];
	[leaderboards setHidden:NO];
	[achievements setHidden:NO];
	
	((AppController*)[[UIApplication sharedApplication] delegate]).localPlayerId = localPlayerId;
	[[NSUserDefaults standardUserDefaults] setObject:localPlayerAlias forKey:KEY_HERO_NAME];
	
    [self setupInviteHandler];
	
	[(AppController*)[[UIApplication sharedApplication] delegate] reloadHighScores];
	
	//[self setupActivityLabels];
}

- (void)localPlayerDidFailToAuthenticateWithError:(NSError *)error {
	[authenticateGameCenter setHidden:NO];
	
    [self showError:error];
}

- (void)startUserAuthentication {
	[authenticateGameCenter setHidden:YES];
	[activityIndicatorView setHidden:NO];
	[connectingToGameCenterLabel setHidden:NO];
	
    [activityIndicatorView startAnimating];
    
    GKLocalPlayer *player = [GKLocalPlayer localPlayer];
	NSLog(@"%d", player.authenticated);
	
    [player authenticateWithCompletionHandler:^(NSError *error) {
        [activityIndicatorView stopAnimating];
		[connectingToGameCenterLabel setHidden:YES];
		
        if (error) {
            [self localPlayerDidFailToAuthenticateWithError:error];
        }
        else {
            [self localPlayerDidAuthenticateWithPlayerId:player.playerID
											 playerAlias:player.alias];
        }
    }];
}

#pragma mark -
#pragma mark GKMatchmakerViewControllerDelegate methods

- (void)showError:(NSError *)error {
    [[[[UIAlertView alloc] initWithTitle:@"Error" 
                                 message:[error localizedDescription] 
                                delegate:nil 
                       cancelButtonTitle:@"Dismiss" 
                       otherButtonTitles:nil] autorelease] 
     show];
}

- (void)createGameSessionWithMatch:(GKMatch *)match {
	// show Texas Hold'em interface
    //GameSessionViewController *gsvc = [[[GameSessionViewController alloc] initWithDelegate:self withMatch:match] autorelease];
    //[self presentModalViewController:gsvc animated:YES];
	
	//match.delegate = self;
	[(AppController*)[[UIApplication sharedApplication] delegate] 
	 createGameCenterMatch:match
	 gameName:gameName];
}

- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)matchmakerViewController {	
	NSLog(@"matchmaker cancelled");
    [matchmakerViewController dismissModalViewControllerAnimated:YES];
}

- (void)matchmakerViewController:(GKMatchmakerViewController *)matchmakerViewController didFindMatch:(GKMatch *)match {
	NSLog(@"matchmaker did find match %d", [match expectedPlayerCount]);
    [matchmakerViewController dismissModalViewControllerAnimated:YES];
	
	//match.delegate = self;
    [self createGameSessionWithMatch:match];
}

- (void)matchmakerViewController:(GKMatchmakerViewController *)matchmakerViewController didFailWithError:(NSError *)error {
    [matchmakerViewController dismissModalViewControllerAnimated:YES];
    
    [self showError:error];
}

- (void)matchmakerViewController:(GKMatchmakerViewController *)matchmakerViewController didFindPlayers:(NSArray *)players {
}

#pragma mark -
#pragma mark GKLeaderboardViewControllerDelegate methods

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController {
	UIViewController *gameCenterViewController = ((AppController *)[[UIApplication sharedApplication] delegate]).viewController;
	[gameCenterViewController dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark GKAchievementViewControllerDelegate methods

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController {
	[viewController dismissModalViewControllerAnimated:YES];
}

- (void)showMatchmaker:(GKMatchmakerViewController *)matchmakerViewController {
    matchmakerViewController.matchmakerDelegate = self;
    matchmakerViewController.hosted = NO;
	
	UIViewController *gameCenterViewController = ((AppController *)[[UIApplication sharedApplication] delegate]).viewController;
    [gameCenterViewController presentModalViewController:matchmakerViewController animated:YES];
}

-(void)startPicker {
	GKPeerPickerController*		picker;
	
	picker = [[[GKPeerPickerController alloc] init] autorelease]; // note: picker is released in various picker delegate methods when picker use is done.
	picker.delegate = (AppController*)[[UIApplication sharedApplication] delegate];
	[picker show];
}

- (void) bluetoothButtonPressed {
	[self startPicker];
}


- (void)dealloc {
	// Cleanup any running resolve and free memory
	[self.bvc release];
	[self.gameNameLabel release];
	
	[super dealloc];
}


- (id<BrowserViewControllerDelegate>)delegate {
	return self.bvc.delegate;
}


- (void)setDelegate:(id<BrowserViewControllerDelegate>)delegate {
	[self.bvc setDelegate:delegate];
}

- (NSString *)gameName {
	return self.gameNameLabel.text;
}

- (void)setGameName:(NSString *)string {
	[self.gameNameLabel setText:string];
	[self.bvc setOwnName:string];
}

/*
- (void)didMoveToWindow {
	if (self.window != nil) {
		[self addRollerView];
	}	
}*/

- (void)willMoveToWindow:(UIWindow *)newWindow {
	[super willMoveToWindow:newWindow];
	
	if (BUILD == HU_FREE || BUILD == HU_HOLDEM_FREE) {
		if (newWindow == nil) {
			// will disappear
			[adView ignoreAutoRefreshTimer];
		} else {
			// will appear
			[adView doNotIgnoreAutoRefreshTimer];
		}
	}
}

@end
