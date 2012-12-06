

#import "AppController.h"
//#import "InterstitialSampleViewController.h"
//#import "AdMobInterstitialAd.h"
//#import "Mobclix.h"

#import "math.h"

/*
#import "Applytics.h"
#import "ApplyfireView.h"
#import "ApplyfireDelegateProtocol.h"
*/

#import "MyStoreObserver.h"

#import "Picker.h"
#import "Reachability.h"

#import "Poker3GView.h"

#import "HeadsupView.h"
#import "GameModeView.h"
#import "TrainingModeView.h"
#import "OmahaTrainingModeView.h"
#import "OmahaToolModeView.h"
#import "OmahaGameModeView.h"
#import "StudToolModeView.h"
#import "StudGameModeView.h"
#import "DrawToolModeView.h"
#import "DrawGameModeView.h"
#import "BlackjackGameModeView.h"
#import "BlackjackHeadsupModeView.h"

#import "SelectModeView.h"
#import "HelpHoldemView.h"
#import "PrefsView.h"
#import "GameCenterView.h"
#import "Constants.h"
#import "HandFSM.h"
#import "Deck.h"
#import "Card.h"
#import "MyViewController.h"
#import "MadeHand.h"
#import "Hand.h"
//#import "AES128.h"

#import "Appirater.h"

//CONSTANTS:


// The Bonjour application protocol, which must:
// 1) be no longer than 14 characters
// 2) contain only lower-case letters, digits, and hyphens
// 3) begin and end with lower-case letter or digit
// It should also be descriptive and human-readable
// See the following for more information:
// http://developer.apple.com/networking/bonjour/faq.html
#define kGameIdentifierHoldem		@"hu-holdemf-006"
#define kGameIdentifierHoldemFree	@"hu-holdemf-006"
#define kGameIdentifierOmaha		@"hu-omaha-001"
#define kGameIdentifierOmahaFree	@"hu-omahaf-001"
#define kGameIdentifierStud			@"hu-stud-001"
#define kGameIdentifierStudFree		@"hu-studf-001"
#define kGameIdentifierDraw			@"hu-draw-001"
#define kGameIdentifierDrawFree		@"hu-drawf-001"
#define kGameIdentifierMixed			@"hu-mixed-001"
#define kGameIdentifierMixedFree		@"hu-mixedf-001"

#define HOLDEM_BUY_IN 150
#define OMAHA_BUY_IN 200

#define GAME_CENTER_HOLDEM_SMALL_BLIND 1
#define GAME_CENTER_HOLDEM_BIG_BLIND 2
#define GAME_CENTER_HOLDEM_STACK 150

#define GAME_CENTER_OMAHA_SMALL_BLIND 1
#define GAME_CENTER_OMAHA_BIG_BLIND 2
#define GAME_CENTER_OMAHA_STACK 150


#define MODE_DATA_FILE_NAME @"hupoker_mode.dat"

#define kPlaceOrderTitle @"Place Order"
#define kTagPlaceOrder 1


//INTERFACES:

/*@interface AppController ()
- (void) setup;
- (void) presentPicker:(NSString*)name;
@end*/

//CLASS IMPLEMENTATIONS:

@implementation AppController

@synthesize viewController;
@synthesize errorOccurred;
@synthesize connectionType;

@synthesize gameSession;
@synthesize gamePeerId;

@synthesize gameMatch;
@synthesize localPlayerId;
@synthesize remotePlayerId;

@synthesize gameCenterManager;


/*
// Protocol
- (void) didSkip:(ApplyfireView*)v {
	UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Canceled" message:@"Canceled - Will not send messages" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[a show];
}

- (void) didInvite:(ApplyfireView*)v {
	UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Messages Sent" message:@"All Contacts were invited!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[a show];
}

- (void) didFail:(ApplyfireView*)v error:(NSError*)e {
	// the following code is commented out so that an error message won't be shown every time
	// an iPod touch can't hit Applytics server.
	//UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Error Occurred" message:@"A network error occurred. Try again soon." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	//[a show];
}

// Use if the phone or ipod has no contacts
-(void)noContacts:(ApplyfireView *)inviteView {
}

// Triggered if the Applytics has not been initialized
- (void) isDisabled:(ApplyfireView *)inviteView {
}
 */

- (void) _showAlert:(NSString*)title
{
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:@"Check network settings" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void) showAlertWithTitle: (NSString*) title message: (NSString*) message
{
	UIAlertView* alert = [[[UIAlertView alloc] initWithTitle: title 
													 message: message 
													delegate: NULL 
										   cancelButtonTitle: @"OK" otherButtonTitles: NULL] 
						  autorelease];
	[alert show];
}

- (void)testHandRanking
:(NSString*)card0
:(NSString*)card1
:(NSString*)card2
:(NSString*)card3
:(NSString*)card4
:(NSString*)card5
:(NSString*)card6
:(NSString*)card7
:(NSString*)card8 {
	
	MadeHand* hand0 = [[MadeHand alloc] init];
	MadeHand* hand1 = [[MadeHand alloc] init];
	
	/*NSComparisonResult result = 
	[Hand calcWinnerHoleCard0:[[Card alloc] initWithCode:card0]
					holeCard1:[[Card alloc] initWithCode:card1]
					holeCard2:[[Card alloc] initWithCode:card2]
					holeCard3:[[Card alloc] initWithCode:card3]
			   communityCard0:[[Card alloc] initWithCode:card4]
			   communityCard0:[[Card alloc] initWithCode:card5]
			   communityCard0:[[Card alloc] initWithCode:card6]
			   communityCard0:[[Card alloc] initWithCode:card7]
			   communityCard0:[[Card alloc] initWithCode:card8]
	   bestHandForFirstPlayer:hand0
	  bestHandForSecondPlayer:hand1
	 ];*/	
	
	[HeadsupView logMadeHand:hand0];
	[HeadsupView logMadeHand:hand1];
	
	[hand0 release];
	[hand1 release];
}

- (NSData *)readApplicationDataFromFile:(NSString *)fileName { 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
														 NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; 
    NSString *appFile = [documentsDirectory 
						 stringByAppendingPathComponent:fileName]; 
    NSData *myData = [[[NSData alloc] initWithContentsOfFile:appFile] 
					  autorelease]; 
    return myData; 
} 


- (BOOL)writeApplicationData:(NSData *)data toFile:(NSString *)fileName { 	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
														 NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; 
    if (!documentsDirectory) { 
		NSLog(@"Documents directory not found!"); 
        return NO; 
    } 
    NSString *appFile = [documentsDirectory 
						 stringByAppendingPathComponent:fileName]; 
    return ([data writeToFile:appFile atomically:YES]); 
}

- (void) setDefaultUserPreferences {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSInteger heroHeroStack = [defaults integerForKey:KEY_NLHOLDEM_HERO_STACK];
	NSInteger heroVillainStack = [defaults integerForKey:KEY_NLHOLDEM_VILLAIN_STACK];
	NSInteger heroSmallBlind = [defaults integerForKey:KEY_NLHOLDEM_SMALL_BLIND];
	NSInteger heroBigBlind = [defaults integerForKey:KEY_NLHOLDEM_BIG_BLIND];
	
	if (heroHeroStack == 0 ||
		heroVillainStack == 0 ||
		heroSmallBlind == 0 ||
		heroBigBlind == 0) {
		[defaults setInteger:DEFAULT_STACK forKey:KEY_NLHOLDEM_HERO_STACK];
		[defaults setInteger:DEFAULT_STACK forKey:KEY_NLHOLDEM_VILLAIN_STACK];
		[defaults setInteger:DEFAULT_SMALL_BLIND forKey:KEY_NLHOLDEM_SMALL_BLIND];
		[defaults setInteger:DEFAULT_BIG_BLIND forKey:KEY_NLHOLDEM_BIG_BLIND];
	}
	
	NSInteger heroOmahaHeroStack = [defaults integerForKey:KEY_PLOMAHA_HERO_STACK];
	NSInteger heroOmahaVillainStack = [defaults integerForKey:KEY_PLOMAHA_VILLAIN_STACK];
	NSInteger heroOmahaSmallBlind = [defaults integerForKey:KEY_PLOMAHA_SMALL_BLIND];
	NSInteger heroOmahaBigBlind = [defaults integerForKey:KEY_PLOMAHA_BIG_BLIND];
	
	if (heroOmahaHeroStack == 0 ||
		heroOmahaVillainStack == 0 ||
		heroOmahaSmallBlind == 0 ||
		heroOmahaBigBlind == 0) {
		[defaults setInteger:DEFAULT_STACK forKey:KEY_PLOMAHA_HERO_STACK];
		[defaults setInteger:DEFAULT_STACK forKey:KEY_PLOMAHA_VILLAIN_STACK];
		[defaults setInteger:DEFAULT_SMALL_BLIND forKey:KEY_PLOMAHA_SMALL_BLIND];
		[defaults setInteger:DEFAULT_BIG_BLIND forKey:KEY_PLOMAHA_BIG_BLIND];
	}	
}	

// set wins to -1 to indicate they are not valid.
// wins only become valid when they are loaded from the server.
- (void) clearWins {
	holdemWins = -1;
	omahaWins = -1;
	huBlackjackWins = -1;
	holdemInternetWins = -1;
	omahaInternetWins = -1;
	holdemBluetoothWins = -1;
	omahaBluetoothWins = -1;
}	

- (void) authenticationChanged 
{
	GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
	
	NSLog(@"authentication changed %d %@", localPlayer.authenticated, localPlayer.alias);
		  
	if (localPlayer.isAuthenticated && localPlayer.playerID) {
		[self clearWins];
		
		// check if there are persisted achievements to be submitted.
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		
		for (NSString *achievementID in 
			 [NSArray arrayWithObjects:kAchievementStraight,
						kAchievementFlush,
						kAchievementBoat,
						kAchievementQuad,
						kAchievementStraightFlush,
						nil]) {
			// the newly authenticated users gets achievements from the last 
			// unauthenticated user.
			if ([defaults integerForKey:[self keyForPlayerID:localPlayer.playerID 
											   achievementID:achievementID]] == 1 ||
				[defaults integerForKey:achievementID] == 1) {
				[self.gameCenterManager submitAchievement:achievementID percentComplete:100.0];
			}
		}
	} else 
		;// Insert code here to clean up any outstanding Game Center-related
}

- (void) reportAppOpenToMobclix {
	//[Mobclix logEventWithLevel:LOG_LEVEL_WARN processName:@"Headsup Poker" eventName:@"app open" description:@"" stop:NO];
}
	
- (void)finishApplicationInitialization
{
	// finish any other initialization code here.
	// set default user preferences
	[self setDefaultUserPreferences];
	
	// turn off screen dimming power saving
	[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
	
	//Create and advertise a new game and discover other availble games
	errorOccurred = NO;
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if ([defaults objectForKey:KEY_SOUND] == nil)
		[defaults setBool:YES forKey:KEY_SOUND];
	
	if ([defaults objectForKey:KEY_HERO_HOLE_CARDS_FACE_UP] == nil)
		[defaults setBool:YES forKey:KEY_HERO_HOLE_CARDS_FACE_UP];
}

- (void)greystripeAdReadyForSlotNamed:(NSString *)a_name 
{ 
    NSLog(@"Ad for slot named %@ is ready.", a_name);
    
    if ([a_name isEqual:@"fullscreenSlot"]) 
    {
    }
}

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// start Applytics
	/*NSString *appKey = @"yS1hOYqeDSnhzMX79"; 
	[[Applytics sharedService] setAppKey:appKey];
	[[Applytics sharedService] startService];
	
	CGRect theScreen  = CGRectMake(0, 0, 320, 480);
	
	inviteView = [[ApplyfireView alloc] initWithFrame:theScreen];
	[inviteView setAppKey:appKey];
	[inviteView setDelegate:self];*/
	
	/*
	// set default user preferences
	[self setDefaultUserPreferences];
	
	// turn off screen dimming power saving
	[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
	
	//Create and advertise a new game and discover other availble games
	errorOccurred = NO;
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if ([defaults objectForKey:KEY_SOUND] == nil)
		[defaults setBool:YES forKey:KEY_SOUND];*/
	
	// start AdMob video interstitial for iPhone OS 3.x
	/*Class aGameKitClass = (NSClassFromString(@"GKPeerPickerController"));
	if (aGameKitClass != nil) {*/
	
	if ([AppController isFreeVersion]) {
        /*GSAdSlotDescription * slot2 = [GSAdSlotDescription descriptionWithSize:kGSAdSizeIPhoneFullScreen name:@"fullscreenSlot"];
        
        // Greystripe 
        NSString *applicationID = @"95d0808a-28ec-4fe6-ba6d-e138914cd2f4";
        
        //Start the AdEngine with our three slots
        [GSAdEngine startupWithAppID:applicationID adSlotDescriptions:[NSArray arrayWithObjects:slot2, nil]];
        
        [GSAdEngine setFullScreenDelegate:self forSlotNamed:@"fullscreenSlot"];
        
        [GSAdEngine displayFullScreenAdForSlotNamed:@"fullscreenSlot"];*/
        
        /*
		interstitialViewController = [[InterstitialSampleViewController alloc] init];
		interstitialViewController.appController = self;

		// Request an interstitial at "Application Open" time.
		// optionally retain the returned AdMobInterstitialAd.
		interstitialAd = 
		[AdMobInterstitialAd requestInterstitialAt:AdMobInterstitialEventAppOpen 
										  delegate:interstitialViewController 
							  interstitialDelegate:interstitialViewController];
		
		interstitialViewController.interstitialAd = interstitialAd;*/
	}
		
	// Please note that while applicationDidFinishLaunching is still executing, 
	// the network calls for the AdMobInterstitialAd will will not start executing 
	// until the applicationDidFinishLaunching call returns.	
	[self finishApplicationInitialization];
	//[_window addSubview:interstitialViewController.view];
	
	if ([AppController isProUpgradePurchased]) {
		[self enableProUpgrade];
	}
	
	// In App Purchase
	transactionObserver = [[MyStoreObserver alloc] init]; 
	transactionObserver.appController = self;
	
	[[SKPaymentQueue defaultQueue] addTransactionObserver:transactionObserver];
	// I had to comment out the following line to get rid of a BAD ACCESS error 
	// when I call [[SKPaymentQueue defaultQueue] addPayement:...]
	//[observer release];
		
	[_window makeKeyAndVisible];

	// Headsup Poker
	//[Mobclix startWithApplicationId:@"2FF4BC95-34DB-4514-8928-DD4C0A89DA72"];
	// Headsup 3G
	//[Mobclix startWithApplicationId:@"D5B1DBFB-83A3-49C8-8A69-65DD41D13EB5"];

	[self reportAppOpenToMobclix];

	[self clearWins];

	if ([GameCenterManager isGameCenterAvailable]) {
		self.gameCenterManager= [[[GameCenterManager alloc] init] autorelease];
		[self.gameCenterManager setDelegate: self];
	}

	[self setup];
			
		// we split the initialization process between applicationDidFinishLaunching and another
		// method to allow the network calls for the interstitial ad to start.
		//[self performSelector:@selector(finishApplicationInitialization) withObject:nil afterDelay:0.1];
	/*} else {
		// no AdMob video interstitial for iPhone OS 2.x as it might break the app.
		[self finishApplicationInitialization];
		[_window makeKeyAndVisible];
		[self setup];		
	}*/
	
	// Depending on if there is an interstitial to show or not the next method
	// to be called will be one of:
	//   [viewController didReceiveInterstitial]
	//   [viewController didFailToReceiveInterstitial]
	
	// We have an internal timeout of approximately 5 seconds enforced
	// at the client level.  You should receive a callback before that
	// timeout, but if you do not, we will fail the request and continue
	// caching asset resources (less than 10k and not including a video)
	// if necessary in the background.  We recommend using the AdMob SDK's 
	// timeout mechanism.  If you choose to use an additional timeout mechanism, 
	// we have seen negative performance with timeout values below 5 seconds.	
    
    [Appirater appLaunched:YES];
}

- (NSString *)holdemHistoryFileName:(NSString *)villainDeviceId gameMode:(enum GameMode)gameMode {
	return [NSString stringWithFormat:@"%@holdemhistory", 
			gameMode == kSinglePhoneMode ? @"1phone" : (gameMode == kSinglePlayerMode ? @"1player" : villainDeviceId)];
}

- (NSString *) holdemFileName:(NSString *)villainDeviceId 
			 gameCenterIdPair:(NSString *)idPair
					 gameMode:(enum GameMode)gameMode{
	NSString *identifier = BUILD == HU_FREE ? kGameIdentifierHoldemFree : kGameIdentifierHoldem;
#ifdef HU_3G
	identifier = kHeadsupPoker3GSessionID;
#endif
	return gameMode == kGameCenterMode ?
		idPair:
		[NSString stringWithFormat:@"%@%@", 
			identifier,
			gameMode == kSinglePhoneMode ? @"1phone" : (gameMode == kSinglePlayerMode ? @"1player" : villainDeviceId)];
}

- (NSString *) omahaFileName:(NSString *)villainDeviceId gameMode:(enum GameMode)gameMode{
	NSString *identifier = BUILD == HU_FREE ? kGameIdentifierOmahaFree : kGameIdentifierOmaha;
#ifdef HU_3G
	identifier = kHeadsupPoker3GSessionID;
#endif
	return [NSString stringWithFormat:@"omaha%@%@", 
			identifier,
			gameMode == kSinglePhoneMode ? @"1phone" : (gameMode == kSinglePlayerMode ? @"1player" : villainDeviceId)];
}

- (NSString *) holdemTrainingModeFileName {
	NSString *identifier = BUILD == HU_FREE ? kGameIdentifierHoldemFree : kGameIdentifierHoldem;

	return [NSString stringWithFormat:@"%@training", identifier];
}

- (NSString *) omahaTrainingModeFileName {
	NSString *identifier = BUILD == HU_FREE ? kGameIdentifierOmahaFree : kGameIdentifierOmaha;
	
	return [NSString stringWithFormat:@"%@training", identifier];
}

- (NSString *) blackjackGameModeFileName {
	// blackjack has no networked version. thus game identifier is undefined
	NSString *identifier = BUILD == HU_FREE ? @"blackjackfree" : @"blackjack";
	
	return [NSString stringWithFormat:@"%@game", identifier];
}

- (NSString *) blackjackHeadsupModeFileName {
	// blackjack has no networked version. thus game identifier is undefined
	NSString *identifier = BUILD == HU_FREE ? @"blackjackhufree" : @"blackjackhu";
	
	return [NSString stringWithFormat:@"%@game", identifier];
}

- (void)writeHoldemApplicationData:(NSData *)applicationData 
				   villainDeviceId:(NSString*)villainDeviceId
				  gameCenterIdPair:(NSString*)idPair
						  gameMode:(enum GameMode)gameMode
{
	NSString *fileName = [self holdemFileName:villainDeviceId 
							 gameCenterIdPair:idPair
									 gameMode:gameMode];
	BOOL isWriteSuccessful = [self writeApplicationData:applicationData toFile:fileName];
	
	if (isWriteSuccessful)
		NSLog(@"app data saved");
	else
		NSLog(@"failed to save app data");
}

- (void)writeOmahaApplicationData:(NSData *)applicationData 
				  villainDeviceId:(NSString*)villainDeviceId 
						 gameMode:(enum GameMode)gameMode
{
	NSString *fileName = [self omahaFileName:villainDeviceId gameMode:gameMode];
	BOOL isWriteSuccessful = [self writeApplicationData:applicationData toFile:fileName];
	
	if (isWriteSuccessful)
		NSLog(@"app data saved");
	else
		NSLog(@"failed to save app data");
}

- (void)writeHoldemTrainingModeApplicationData:(NSData *)applicationData 
{
	NSString *fileName = [self holdemTrainingModeFileName];
	BOOL isWriteSuccessful = [self writeApplicationData:applicationData toFile:fileName];
	
	if (isWriteSuccessful)
		NSLog(@"training mode app data saved");
	else
		NSLog(@"failed to save training mode app data");
}

- (void)writeOmahaTrainingModeApplicationData:(NSData *)applicationData 
{
	NSString *fileName = [self omahaTrainingModeFileName];
	BOOL isWriteSuccessful = [self writeApplicationData:applicationData toFile:fileName];
	
	if (isWriteSuccessful)
		NSLog(@"omaha training mode app data saved");
	else
		NSLog(@"failed to save omaha training mode app data");
}

- (void)writeBlackjackGameModeApplicationData:(NSData *)applicationData 
{
	NSString *fileName = [self blackjackGameModeFileName];
	BOOL isWriteSuccessful = [self writeApplicationData:applicationData toFile:fileName];
	
	if (isWriteSuccessful)
		NSLog(@"blackjack game mode app data saved");
	else
		NSLog(@"failed to save blackjack game mode app data");
}

- (void)writeBlackjackHeadsupModeApplicationData:(NSData *)applicationData 
{
	NSString *fileName = [self blackjackHeadsupModeFileName];
	BOOL isWriteSuccessful = [self writeApplicationData:applicationData toFile:fileName];
	
	if (isWriteSuccessful)
		NSLog(@"blackjack headsup mode app data saved");
	else
		NSLog(@"failed to save blackjack headsup mode app data");
}

- (NSString*) keyForPlayerID:(NSString*)playerID categoryID:(NSString*)categoryID {
	return 
	playerID == nil ?
	categoryID :
	[NSString stringWithFormat:@"%@-%@", playerID, categoryID];
}

- (void) clearScoreIncrement:(NSString*)categoryID {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:0 forKey:categoryID];
	
	[defaults setInteger:0 
				  forKey:[self keyForPlayerID:localPlayerId categoryID:categoryID]];
}

- (void) scoreReported: (NSString*) categoryID error : (NSError*) error;
{
	if(error == NULL)
	{
		//[self.gameCenterManager reloadHighScoresForCategory: self.currentLeaderBoard];
		NSLog(@"score reporting succeeded!");
		[self clearScoreIncrement:categoryID];
	}
	else
	{
		NSLog(@"score reporting failed!");
	}
}

- (void) reloadHighScores {
	for (NSString *categoryID in [NSArray arrayWithObjects:
								  kBeatComputerHoldemLeaderboardID,
								  kBeatComputerOmahaLeaderboardID,
								  kBeatComputerHeadsupBlackjackLeaderboardID,
								  kBeatFriendsInternetHoldemLeaderboardID,
								  kBeatFriendsBluetoothHoldemLeaderboardID,
								  kBeatFriendsBluetoothOmahaLeaderboardID,
								  nil]) {
		[gameCenterManager reloadHighScoresForCategory:categoryID];
	}
}

- (void) reloadScoresComplete: (GKLeaderboard*) leaderBoard error: (NSError*) error;
{
	if(error == NULL)
	{
		int64_t personalBest= leaderBoard.localPlayerScore.value;
		NSLog(@"high score loaded %@ %lld", leaderBoard.category, personalBest);
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		
		if ([leaderBoard.category compare:kBeatComputerHoldemLeaderboardID] == NSOrderedSame) {
			holdemWins = personalBest + [defaults integerForKey:kBeatComputerHoldemLeaderboardID] +
			[defaults integerForKey:[self keyForPlayerID:localPlayerId categoryID:kBeatComputerHoldemLeaderboardID]];
			
			if (holdemWins > personalBest)
				[self.gameCenterManager reportScore:holdemWins forCategory:kBeatComputerHoldemLeaderboardID];
		} else if ([leaderBoard.category compare:kBeatComputerOmahaLeaderboardID] == NSOrderedSame) {
			omahaWins = personalBest + [defaults integerForKey:kBeatComputerOmahaLeaderboardID] +
			[defaults integerForKey:[self keyForPlayerID:localPlayerId categoryID:kBeatComputerOmahaLeaderboardID]];
			
			if (omahaWins > personalBest)
				[self.gameCenterManager reportScore:omahaWins forCategory:kBeatComputerOmahaLeaderboardID];
		} else if ([leaderBoard.category compare:kBeatComputerHeadsupBlackjackLeaderboardID] == NSOrderedSame) {
			huBlackjackWins = personalBest + [defaults integerForKey:kBeatComputerHeadsupBlackjackLeaderboardID] +
			[defaults integerForKey:[self keyForPlayerID:localPlayerId categoryID:kBeatComputerHeadsupBlackjackLeaderboardID]];
			
			if (huBlackjackWins > personalBest)
				[self.gameCenterManager reportScore:huBlackjackWins forCategory:kBeatComputerHeadsupBlackjackLeaderboardID];
		} else if ([leaderBoard.category compare:kBeatFriendsInternetHoldemLeaderboardID] == NSOrderedSame) {
			holdemInternetWins = personalBest + [defaults integerForKey:kBeatFriendsInternetHoldemLeaderboardID] +
			[defaults integerForKey:[self keyForPlayerID:localPlayerId categoryID:kBeatFriendsInternetHoldemLeaderboardID]];
			
			if (holdemInternetWins > personalBest)
				[self.gameCenterManager reportScore:holdemInternetWins forCategory:kBeatFriendsInternetHoldemLeaderboardID];
		} else if ([leaderBoard.category compare:kBeatFriendsInternetOmahaLeaderboardID] == NSOrderedSame) {
			omahaInternetWins = personalBest + [defaults integerForKey:kBeatFriendsInternetOmahaLeaderboardID] +
			[defaults integerForKey:[self keyForPlayerID:localPlayerId categoryID:kBeatFriendsInternetOmahaLeaderboardID]];
			
			if (omahaInternetWins > personalBest)
				[self.gameCenterManager reportScore:omahaInternetWins forCategory:kBeatFriendsInternetOmahaLeaderboardID];
		} else if ([leaderBoard.category compare:kBeatFriendsBluetoothHoldemLeaderboardID] == NSOrderedSame) {
			holdemBluetoothWins = personalBest + [defaults integerForKey:kBeatFriendsBluetoothHoldemLeaderboardID] +
			[defaults integerForKey:[self keyForPlayerID:localPlayerId categoryID:kBeatFriendsBluetoothHoldemLeaderboardID]];
			
			if (holdemBluetoothWins > personalBest)
				[self.gameCenterManager reportScore:holdemBluetoothWins forCategory:kBeatFriendsBluetoothHoldemLeaderboardID];
		} else if ([leaderBoard.category compare:kBeatFriendsBluetoothOmahaLeaderboardID] == NSOrderedSame) {
			omahaBluetoothWins = personalBest + [defaults integerForKey:kBeatFriendsBluetoothOmahaLeaderboardID] +
			[defaults integerForKey:[self keyForPlayerID:localPlayerId categoryID:kBeatFriendsBluetoothOmahaLeaderboardID]];
			
			if (omahaBluetoothWins > personalBest)
				[self.gameCenterManager reportScore:omahaBluetoothWins forCategory:kBeatFriendsBluetoothOmahaLeaderboardID];		
		} else if ([leaderBoard.category compare:kBlackjackLeaderboardID] == NSOrderedSame) {
			
			NSInteger storedHighScoreWithoutLocalPlayerId =
			[defaults integerForKey:kBlackjackLeaderboardID];

			NSInteger storedHighScoreWithLocalPlayerId =
			[defaults integerForKey:[self keyForPlayerID:localPlayerId categoryID:kBlackjackLeaderboardID]];
			
			NSInteger storedHighScore = storedHighScoreWithoutLocalPlayerId > storedHighScoreWithLocalPlayerId ?
			storedHighScoreWithoutLocalPlayerId : storedHighScoreWithLocalPlayerId;
			
			if (storedHighScore > personalBest)
				[self.gameCenterManager reportScore:storedHighScore forCategory:kBlackjackLeaderboardID];		
		}		
	}
	else
	{
		NSLog(@"failed to load high score");
	}
}

- (void) incrementPersistedScoreForCategory:(NSString*)categoryID {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *key = [self keyForPlayerID:localPlayerId categoryID:categoryID];
	NSInteger currentIncrement = [defaults integerForKey:key];
	[defaults setInteger:currentIncrement+1 forKey:key];	
}

// hero just won a match. report high score for No Limit Hold'em single player mode
- (void) incrementHighScoreHoldemSinglePlayer {
	[self incrementPersistedScoreForCategory:kBeatComputerHoldemLeaderboardID];
	
	if (holdemWins >= 0) {
		++holdemWins;
		[self.gameCenterManager reportScore:holdemWins forCategory:kBeatComputerHoldemLeaderboardID];
	}
}

- (void) incrementHighScoreOmahaSinglePlayer {
	[self incrementPersistedScoreForCategory:kBeatComputerOmahaLeaderboardID];
	
	if (omahaWins >= 0) {
		++omahaWins;
		[self.gameCenterManager reportScore:omahaWins forCategory:kBeatComputerOmahaLeaderboardID];
	}	
}

- (void) incrementHighScoreHeadsupBlackjackSinglePlayer {
	[self incrementPersistedScoreForCategory:kBeatComputerHeadsupBlackjackLeaderboardID];
	
	if (huBlackjackWins >= 0) {
		++huBlackjackWins;
		[self.gameCenterManager reportScore:huBlackjackWins forCategory:kBeatComputerHeadsupBlackjackLeaderboardID];
	}
}

- (void) incrementHighScoreHoldemInternet {
	[self incrementPersistedScoreForCategory:kBeatFriendsInternetHoldemLeaderboardID];
	
	if (holdemInternetWins >= 0) {
		++holdemInternetWins;
		[self.gameCenterManager reportScore:holdemInternetWins forCategory:kBeatFriendsInternetHoldemLeaderboardID];
	}
}

- (void) incrementHighScoreOmahaInternet {
	[self incrementPersistedScoreForCategory:kBeatFriendsInternetOmahaLeaderboardID];
	
	if (omahaInternetWins >= 0) {
		++omahaInternetWins;
		[self.gameCenterManager reportScore:omahaInternetWins forCategory:kBeatFriendsInternetOmahaLeaderboardID];
	}
}

- (void) incrementHighScoreHoldemBluetooth {
	[self incrementPersistedScoreForCategory:kBeatFriendsBluetoothHoldemLeaderboardID];
	
	if (holdemBluetoothWins >= 0) {
		++holdemBluetoothWins;
		[self.gameCenterManager reportScore:holdemBluetoothWins forCategory:kBeatFriendsBluetoothHoldemLeaderboardID];
	}
}

- (void) incrementHighScoreOmahaBluetooth {
	[self incrementPersistedScoreForCategory:kBeatFriendsBluetoothOmahaLeaderboardID];
	
	if (omahaBluetoothWins >= 0) {
		++omahaBluetoothWins;
		[self.gameCenterManager reportScore:omahaBluetoothWins forCategory:kBeatFriendsBluetoothOmahaLeaderboardID];
	}
}

- (NSString*) keyForPlayerID:(NSString*)playerID achievementID:(NSString*)achievementID {
	return 
	playerID == nil ?
	achievementID :
	[NSString stringWithFormat:@"%@-%@", playerID, achievementID];
}

- (void) persistAchievement:(NSString*)achievementID {
	NSString *key = [self keyForPlayerID:localPlayerId achievementID:achievementID];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:1 forKey:key];
}

- (void) clearAchievement:(NSString*)achievementID {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:0 forKey:achievementID];
	
	[defaults setInteger:0 
				  forKey:[self keyForPlayerID:localPlayerId achievementID:achievementID]];
}

// for instance, if achievementIdentifier is "com.qin.straight" it returns "straight"
- (NSString*) extractAchievementTitle:(NSString*)achievementIdentifier {
	return 
	[achievementIdentifier length] <= 8 ?
	achievementIdentifier :
	[achievementIdentifier substringWithRange:NSMakeRange(8,[achievementIdentifier length] - 8)];
}

- (void) achievementSubmitted: (GKAchievement*) ach error:(NSError*) error;
{
	if((error == NULL) && (ach != NULL))
	{
		[self clearAchievement:ach.identifier];
		
		if(ach.percentComplete == 100.0)
		{
			[self showAlertWithTitle: @"Achievement Earned!"
							 message: [NSString stringWithFormat: @"Great job!  You earned an achievement: \"%@\"", NSLocalizedString([self extractAchievementTitle:ach.identifier], NULL)]];
		}
		else
		{
			if(ach.percentComplete > 0)
			{
				[self showAlertWithTitle: @"Achievement Progress!"
								 message: [NSString stringWithFormat: @"Great job!  You're %.0f\%% of the way to: \"%@\"",ach.percentComplete, NSLocalizedString(ach.identifier, NULL)]];
			}
		}
	}
	else
	{
		[self showAlertWithTitle: @"Achievement Submission Failed!"
						 message: [NSString stringWithFormat: @"Reason: %@", [error localizedDescription]]];
	}
}

- (void) checkAchievementsForHand:(MadeHand*)hand {
	NSString *achievementID = nil;
	
	if (hand.handType == kHandStraight) {
		achievementID = kAchievementStraight;
	} else if (hand.handType == kHandFlush) {
		achievementID = kAchievementFlush;
	} else if (hand.handType == kHandBoat) {
		achievementID = kAchievementBoat;
	} else if (hand.handType == kHandQuads) {
		achievementID = kAchievementQuad;
	} else if (hand.handType == kHandStraightFlush) {
		achievementID = kAchievementStraightFlush;
		// royal flush
	}
	
	if (achievementID != nil) {
		[self persistAchievement:achievementID];
		[self.gameCenterManager submitAchievement:achievementID percentComplete:100.0];
	}
}

- (NSString*) getGameCenterIdPair {
	return [NSString stringWithFormat:@"%@-%@", localPlayerId, remotePlayerId];
}

- (void) saveApplicationData {
	// save mode
	enum Mode mode = kModeOther;
	
	if (viewController.topViewController == holdemGameModeViewController) {
		GameModeView *holdemGameModeView = (GameModeView*)[holdemGameModeViewController view];
		if (holdemGameModeView.gameMode == kSinglePlayerMode)
			mode = kModeHoldemSinglePlayer;
		else if (holdemGameModeView.gameMode == kSinglePhoneMode)
			mode = kModeHoldemSinglePhone;
	} else if (viewController.topViewController == omahaGameModeViewController) {
		OmahaGameModeView *omahaGameModeView = (OmahaGameModeView*)[omahaGameModeViewController view];
		if (omahaGameModeView.gameMode == kSinglePlayerMode)
			mode = kModeOmahaSinglePlayer;
		else if (omahaGameModeView.gameMode == kSinglePhoneMode)
			mode = kModeOmahaSinglePhone;
	} else if (viewController.topViewController == blackjackGameModeViewController) {
		mode = kModeBlackjack;
	} else if (viewController.topViewController == blackjackHeadsupModeViewController) {
		mode = kModeHeadsupBlackjack;
	}
	
	NSData *modeData = [[NSData alloc] initWithBytes:&mode length:1];
	[self writeApplicationData:modeData toFile:MODE_DATA_FILE_NAME];
	[modeData release];
	
	if (holdemGameModeViewController != nil &&
		viewType == kViewGameMode) {
		GameModeView *holdemGameModeView = (GameModeView*)[holdemGameModeViewController view];
		NSData *applicationData = [holdemGameModeView getApplicationData];
		NSString *villainDeviceId = [holdemGameModeView getVillainDeviceId];
		[self writeHoldemApplicationData:applicationData 
						 villainDeviceId:villainDeviceId
						gameCenterIdPair:[self getGameCenterIdPair]
								gameMode:holdemGameModeView.gameMode];
		
		[holdemGameModeView saveLastHand];
	}
	
	if (omahaGameModeViewController != nil &&
		viewType == kViewOmahaGameMode) {
		OmahaGameModeView *omahaGameModeView = (OmahaGameModeView*)[omahaGameModeViewController view];
		NSData *applicationData = [omahaGameModeView getApplicationData];
		NSString *villainDeviceId = [omahaGameModeView getVillainDeviceId];
		[self writeOmahaApplicationData:applicationData 
						villainDeviceId:villainDeviceId
							   gameMode:omahaGameModeView.gameMode];
	}
	
	if (holdemTrainingModeViewController != nil &&
		viewType == kViewHoldemTrainingMode) {
		TrainingModeView *holdemTrainingModeView = (TrainingModeView*)[holdemTrainingModeViewController view];
		NSData *applicationData = [holdemTrainingModeView getApplicationData];
		[self writeHoldemTrainingModeApplicationData:applicationData];
	}
	
	if (omahaTrainingModeViewController != nil &&
		viewType == kViewOmahaTrainingMode) {
		OmahaTrainingModeView *omahaTrainingModeView = (OmahaTrainingModeView*)[omahaTrainingModeViewController view];
		NSData *applicationData = [omahaTrainingModeView getApplicationData];
		[self writeOmahaTrainingModeApplicationData:applicationData];
	}	
	
	if (blackjackGameModeViewController != nil &&
		viewType == kViewBlackjackGameMode) {
		BlackjackGameModeView *blackjackGameModeView = (BlackjackGameModeView*)[blackjackGameModeViewController view];
		NSData *applicationData = [blackjackGameModeView getApplicationData];
		[self writeBlackjackGameModeApplicationData:applicationData];
		
		// report high score
		NSInteger heroStack = [blackjackGameModeView heroTotalChips];
		
		if (heroStack > 0) {
			// persist score locally in case reporting fails.
			NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
			NSString *key = [self keyForPlayerID:localPlayerId categoryID:kBlackjackLeaderboardID];
			[defaults setInteger:heroStack forKey:key];	
			
			[self.gameCenterManager reportScore:heroStack forCategory:kBlackjackLeaderboardID];
		}
	}		
	
	if (blackjackHeadsupModeViewController != nil &&
		viewType == kViewBlackjackHeadsupMode) {
		BlackjackHeadsupModeView *blackjackHeadsupModeView = (BlackjackHeadsupModeView*)[blackjackHeadsupModeViewController view];
		NSData *applicationData = [blackjackHeadsupModeView getApplicationData];
		[self writeBlackjackHeadsupModeApplicationData:applicationData];
	}			
}	

- (void) handleApplicationWillEnd {
	[self saveApplicationData];
	
	if (gameSession) {
		[gameSession disconnectFromAllPeers];
		[gameSession release];
		gameSession = nil;
	}
	
	if (gameMatch) {
		[gameMatch disconnect];
		gameMatch = nil;
	}
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[self handleApplicationWillEnd];
	
	// Stop the session when we close the app
	//[[Applytics sharedService] stopService];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	[self handleApplicationWillEnd];
}

- (void) showDisconnected {
	if (!ignoreOpponentDisconnect) {
		[self ignoreOpponentDisconnect];
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Warning" 
															message:@"Opponent disconnected"
														   delegate:self
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [Appirater appEnteredForeground:YES];
    
    if ([AppController isFreeVersion]) {
        if ([viewController.topViewController respondsToSelector:@selector(displayFullscreenAd)]) {
            [((MyViewController*)viewController.topViewController) displayFullscreenAd];
        }
    }
    
	if (viewController.topViewController == holdemGameModeViewController) {
		GameModeView* gameModeView = (GameModeView*)[holdemGameModeViewController view];

		if (gameModeView.gameMode == kGameCenterMode ||
			gameModeView.gameMode == kDualPhoneMode) {
			[self showDisconnected];
		}
	}
	
	if (viewController.topViewController == omahaGameModeViewController) {
		OmahaGameModeView* gameModeView = (OmahaGameModeView*)[omahaGameModeViewController view];
		
		if (gameModeView.gameMode == kGameCenterMode ||
			gameModeView.gameMode == kDualPhoneMode) {
			[self showDisconnected];
		}
	}	
	
	[self reportAppOpenToMobclix];
	
	if ([AppController isFreeVersion]) {
        //[GSAdEngine displayFullScreenAdForSlotNamed:@"fullscreenSlot"];
        
        /*
		// only request a video interstitial if one is not being played.
		if (interstitialViewController.interstitialAd == nil) {
			interstitialAd = 
			[AdMobInterstitialAd requestInterstitialAt:AdMobInterstitialEventAppOpen 
											  delegate:interstitialViewController 
								  interstitialDelegate:interstitialViewController];
			
			interstitialViewController.interstitialAd = interstitialAd;	
		}*/
	}
}

/*
- (void) applicationWillResignActive:(UIApplication *)application {
	// Stop the session when we pause the app
	[[Applytics sharedService] stopService];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Start the session when we resume again
	[[Applytics sharedService] startService];
}*/

- (void) dealloc
{	
	//[interstitialViewController release];
	
	//[inviteView release];
	
	[viewController release];
	
	[_inStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
	[_inStream release];

	[_outStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
	[_outStream release];

	[_server release];
	
	[_picker release];
	
	[_window release];
	
	[super dealloc];
}

- (NSString*)getGameIdentifier {
	NSString *gameIdentifier;
	
	if (BUILD == HU_HOLDEM)
		gameIdentifier = kGameIdentifierHoldem;
	else if (BUILD == HU_HOLDEM_FREE)
		gameIdentifier = kGameIdentifierHoldemFree;
	else if (BUILD == HU_OMAHA)
		gameIdentifier = kGameIdentifierOmaha;
	else if (BUILD == HU_OMAHA_FREE)
		gameIdentifier = kGameIdentifierOmahaFree;
	else if (BUILD == HU_STUD)
		gameIdentifier = kGameIdentifierStud;	
	else if (BUILD == HU_STUD_FREE)
		gameIdentifier = kGameIdentifierStudFree;	
	else if (BUILD == HU_DRAW)
		gameIdentifier = kGameIdentifierDraw;	
	else if (BUILD == HU_DRAW_FREE)
		gameIdentifier = kGameIdentifierDrawFree;	
	else if (BUILD == HU_MIXED)
		gameIdentifier = kGameIdentifierMixed;	
	else if (BUILD == HU_MIXED_FREE)
		gameIdentifier = kGameIdentifierMixedFree;	
	else
		gameIdentifier = @"";
	
	return gameIdentifier;
}	

#ifdef HU_3G
- (void) present3G {	
	ignoreOpponentDisconnect = NO;

	if (poker3GViewController == nil)
		poker3GViewController =
		[[MyViewController alloc] initWithNibName:@"Poker3GAdView"
										   bundle:[NSBundle mainBundle]];
	
	self.viewController = poker3GViewController;
		
	// Add the view controller's view as a subview of the window
	UIView *controllersView = [viewController view];
	//[self curlView:controllersView];
	[_window addSubview:controllersView];		
	
	Poker3GView *view = (Poker3GView*)controllersView;
	[view willDisplay];
}
#endif

- (void) setupServer {
#ifdef HU_3G
	// set mode
	// the mode must be set here. otherwise we could receive data and think we are still in 
	// game mode and misinterpret the data.
	viewType = kViewRestoreMode;
	
	Poker3GView *poker3GView = (Poker3GView*)[poker3GViewController view];
	[poker3GView endSession];
	
	BlackjackGameModeView *blackjackGameModeView = (BlackjackGameModeView*)[blackjackGameModeViewController view];
	[blackjackGameModeView killAllActiveTimers];
	[blackjackGameModeView resetStuff];		
	
	BlackjackHeadsupModeView *blackjackHeadsupModeView = (BlackjackHeadsupModeView*)[blackjackHeadsupModeViewController view];
	[blackjackHeadsupModeView killAllActiveTimers];
	[blackjackHeadsupModeView resetStuff];			

	GameModeView *holdemGameModeView = (GameModeView*)[holdemGameModeViewController view];
	[holdemGameModeView killAllActiveTimers];
	[holdemGameModeView resetStuff];	
	
	OmahaGameModeView *omahaGameModeView = (OmahaGameModeView*)[omahaGameModeViewController view];
	[omahaGameModeView killAllActiveTimers];
	[omahaGameModeView resetStuff];		
	
	TrainingModeView *holdemTrainingModeView = (TrainingModeView*)[holdemTrainingModeViewController view];
	[holdemTrainingModeView killAllActiveTimers];
	[holdemTrainingModeView resetStuff];	
	
	OmahaTrainingModeView *omahaTrainingModeView = (OmahaTrainingModeView*)[omahaTrainingModeViewController view];
	[omahaTrainingModeView killAllActiveTimers];
	[omahaTrainingModeView resetStuff];	
	
#else
	// set mode
	// the mode must be set here. otherwise we could receive data and think we are still in 
	// game mode and misinterpret the data.
	viewType = kViewRestoreMode;
	
	heroHoldemApplicationData = nil;
	villainHoldemApplicationData = nil;

	heroOmahaApplicationData = nil;
	villainOmahaApplicationData = nil;
	
	isViewPresented = NO;
	isHeroApplicationDataSent = NO;
	//errorOccurred = NO;
	
	[_server release];
	_server = nil;
	
	[_inStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[_inStream release];
	_inStream = nil;
	_inReady = NO;
	
	[_outStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[_outStream release];
	_outStream = nil;
	_outReady = NO;
	
	BlackjackGameModeView *blackjackGameModeView = (BlackjackGameModeView*)[blackjackGameModeViewController view];
	[blackjackGameModeView killAllActiveTimers];
	[blackjackGameModeView resetStuff];			
	
	BlackjackHeadsupModeView *blackjackHeadsupModeView = (BlackjackHeadsupModeView*)[blackjackHeadsupModeViewController view];
	[blackjackHeadsupModeView killAllActiveTimers];
	[blackjackHeadsupModeView resetStuff];				
	
	GameModeView *holdemGameModeView = (GameModeView*)[holdemGameModeViewController view];
	[holdemGameModeView killAllActiveTimers];
	[holdemGameModeView resetStuff];	
	
	OmahaGameModeView *omahaGameModeView = (OmahaGameModeView*)[omahaGameModeViewController view];
	[omahaGameModeView killAllActiveTimers];
	[omahaGameModeView resetStuff];	
	
	TrainingModeView *holdemTrainingModeView = (TrainingModeView*)[holdemTrainingModeViewController view];
	[holdemTrainingModeView killAllActiveTimers];
	[holdemTrainingModeView resetStuff];
	
	OmahaTrainingModeView *omahaTrainingModeView = (OmahaTrainingModeView*)[omahaTrainingModeViewController view];
	[omahaTrainingModeView killAllActiveTimers];
	[omahaTrainingModeView resetStuff];		
	
	_server = [TCPServer new];
	[_server setDelegate:self];
	NSError* error;
	if(_server == nil || ![_server start:&error]) {
		//NSLog(@"Failed creating server: %@", error);
		[self _showAlert:@"Server creation failed"];
		return;
	}
	
	//Start advertising to clients, passing nil for the name to tell Bonjour to pick use default name
	
	if(![_server enableBonjourWithDomain:@"local" applicationProtocol:[TCPServer bonjourTypeFromIdentifier:[self getGameIdentifier]] name:nil]) {
		[self _showAlert:@"Server advertising failed"];
		return;
	}
	
	[self presentPicker:nil];
	
#endif
}	

//??
- (void) setup {
#ifdef HU_3G
	/*
	// set mode
	// the mode must be set here. otherwise we could receive data and think we are still in 
	// game mode and misinterpret the data.
	viewType = kViewHoldemRestoreMode;
	
	ignoreOpponentDisconnect = NO;
	
	Poker3GView *poker3GView = (Poker3GView*)[poker3GViewController view];
	[poker3GView endSession];
	
	// set self as non-dealer so when user enters single player mode and there's no
	// saved game, hero will always be the dealer.
	dealer = NO;
	
	// save application data
	[self saveApplicationData];	
	
	GameModeView *holdemGameModeView = (GameModeView*)[holdemGameModeViewController view];
	[holdemGameModeView killAllActiveTimers];
	[holdemGameModeView resetStuff];	
	[self present3G];
	 */
	
	// set mode
	// the mode must be set here. otherwise we could receive data and think we are still in 
	// game mode and misinterpret the data.
	viewType = kViewRestoreMode;
	
	ignoreOpponentDisconnect = NO;
	
	Poker3GView *poker3GView = (Poker3GView*)[poker3GViewController view];
	[poker3GView endSession];
	
	// set self as non-dealer so when user enters single player mode and there's no
	// saved game, hero will always be the dealer.
	dealer = NO;
	
	// save application data
	[self saveApplicationData];	

	BlackjackGameModeView *blackjackGameModeView = (BlackjackGameModeView*)[blackjackGameModeViewController view];
	[blackjackGameModeView killAllActiveTimers];
	[blackjackGameModeView resetStuff];		
	
	BlackjackHeadsupModeView *blackjackHeadsupModeView = (BlackjackHeadsupModeView*)[blackjackHeadsupModeViewController view];
	[blackjackHeadsupModeView killAllActiveTimers];
	[blackjackHeadsupModeView resetStuff];			
	
	GameModeView *holdemGameModeView = (GameModeView*)[holdemGameModeViewController view];
	[holdemGameModeView killAllActiveTimers];
	[holdemGameModeView resetStuff];	
	
	OmahaGameModeView *omahaGameModeView = (OmahaGameModeView*)[omahaGameModeViewController view];
	[omahaGameModeView killAllActiveTimers];
	[omahaGameModeView resetStuff];	
	
	TrainingModeView *holdemTrainingModeView = (TrainingModeView*)[holdemTrainingModeViewController view];
	[holdemTrainingModeView killAllActiveTimers];
	[holdemTrainingModeView resetStuff];
	
	OmahaTrainingModeView *omahaTrainingModeView = (OmahaTrainingModeView*)[omahaTrainingModeViewController view];
	[omahaTrainingModeView killAllActiveTimers];
	[omahaTrainingModeView resetStuff];		
	
	[self present3G];
	
#else
	//holdemGameModeViewController = nil;
	
	// set mode
	// the mode must be set here. otherwise we could receive data and think we are still in 
	// game mode and misinterpret the data.
	viewType = kViewRestoreMode;

	heroHoldemApplicationData = nil;
	villainHoldemApplicationData = nil;
	
	heroOmahaApplicationData = nil;
	villainOmahaApplicationData = nil;
	
	isViewPresented = NO;
	isHeroApplicationDataSent = NO;
	//errorOccurred = NO;
	
	[_server release];
	_server = nil;
	
	[_inStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[_inStream release];
	_inStream = nil;
	_inReady = NO;

	[_outStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[_outStream release];
	_outStream = nil;
	_outReady = NO;
	
	_server = [TCPServer new];
	[_server setDelegate:self];
	NSError* error;
	if(_server == nil || ![_server start:&error]) {
		//NSLog(@"Failed creating server: %@", error);
		[self _showAlert:@"Server creation failed"];
		return;
	}
	
	//Start advertising to clients, passing nil for the name to tell Bonjour to pick use default name
	
	if(![_server enableBonjourWithDomain:@"local" applicationProtocol:[TCPServer bonjourTypeFromIdentifier:[self getGameIdentifier]] name:nil]) {
		[self _showAlert:@"Server advertising failed"];
		return;
	}

	[self presentPicker:nil];
	
	/*if ([[[UIDevice currentDevice] model] caseInsensitiveCompare:@"IPod Touch"] == NSOrderedSame &&
		[[Reachability sharedReachability] localWiFiConnectionStatus] != ReachableViaWiFiNetwork) {
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You must connect to Wi-Fi first. Please exit this application and check Settings -> Wi-Fi" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];		
	}*/
#endif
}

// shared util methods
+ (NSInteger) read2ByteIntegerFrom:(uint8_t*)buf {
	NSInteger twoByteInteger =
	((buf[0] << 8)  & 0xff00) |
	(buf[1]        & 0x00ff); 
	
	return twoByteInteger;
}	

+ (NSInteger) read4ByteIntegerFrom:(uint8_t*)buf {
	NSInteger fourByteInteger =
	((buf[0] << 24) & 0xff000000) |
	((buf[1] << 16) & 0x00ff0000) |
	((buf[2] << 8)  & 0x0000ff00) |
	(buf[3]        & 0x000000ff); 
	
	return fourByteInteger;
}	

+ (void) write2ByteInteger:(NSInteger)twoByteInteger To:(uint8_t*)buf {
	buf[0] = (uint8_t)((twoByteInteger >> 8) & 0xff);
	buf[1] = (uint8_t)( twoByteInteger       & 0xff);
}	

+ (void) write4ByteInteger:(NSInteger)fourByteInteger To:(uint8_t*)buf {
	buf[0] = (uint8_t)((fourByteInteger >> 24) & 0xff);
	buf[1] = (uint8_t)((fourByteInteger >> 16) & 0xff);
	buf[2] = (uint8_t)((fourByteInteger >> 8) & 0xff);
	buf[3] = (uint8_t)( fourByteInteger       & 0xff);
}	

+ (void) changeTitleOfButton:(UIButton*)button to:(NSString*)title {
	[button setTitle:title forState:UIControlStateNormal];
	[button setTitle:title forState:UIControlStateHighlighted];
	[button setTitle:title forState:UIControlStateDisabled];
	[button setTitle:title forState:UIControlStateSelected];
	[button setNeedsDisplay];	
}

+ (void) changeImageOfButton:(UIButton*)button to:(NSString*)imageName {
	[button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
	[button setNeedsDisplay];	
}

+ (NSString*) gameModeDescription:(enum GameMode)mode {
	NSString *retval = @"";
	
	if (mode == kSinglePhoneMode)
		retval = @"single phone";
	else if (mode == kSinglePlayerMode)
		retval = @"single player";
	else if (mode == kDualPhoneMode)
		retval = @"dual phone";
	else
		retval = @"unknown mode";
	
	return retval;
}

- (void) ignoreOpponentDisconnect {
	ignoreOpponentDisconnect = YES;
}

- (void)dontIgnoreOpponentDisconnect {
	ignoreOpponentDisconnect = NO;
}

- (BOOL)isOpponentDisconnectIgnored {
	return ignoreOpponentDisconnect;
}

// Make sure to let the user know what name is being used for Bonjour advertisement.
// This way, other players can browse for and connect to this game.
// Note that this may be called while the alert is already being displayed, as
// Bonjour may detect a name conflict and rename dynamically.
- (void) presentPicker:(NSString*)name {
	ignoreOpponentDisconnect = NO;
	
	if (!_picker) {
		_picker = [[Picker alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] type:[TCPServer bonjourTypeFromIdentifier:[self getGameIdentifier]]];
		_picker.delegate = self;
	}
	
	_picker.gameName = name;
	
	if (!lobbyViewController) {
		lobbyViewController = [[UIViewController alloc] init];
		lobbyViewController.view = _picker;
	}
	
	if (!self.viewController) {
        UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:lobbyViewController];
		self.viewController = controller;
        [controller release];
		self.viewController.navigationBarHidden = YES;
        
        _window.rootViewController = self.viewController;
		
		[_window addSubview:self.viewController.view];
	}
}

- (void) restoreGameCenterHoldem {	
	// only proceed if both application data files are available; otherwise
	// do nothing.
	GameModeView* gameModeView = (GameModeView*)[holdemGameModeViewController view];

	if (heroHoldemApplicationData && villainHoldemApplicationData) {
		viewType = kViewGameMode;
		
		if (heroHoldemApplicationData[0] == (uint8_t)0 &&
			villainHoldemApplicationData[0] == (uint8_t)0) {
			// no valid applicaiton data found on either device, start a
			// new game.

			// free hero/villain app data since they are not valid.
			free(heroHoldemApplicationData);
			free(villainHoldemApplicationData);
			heroHoldemApplicationData = nil;
			villainHoldemApplicationData = nil;

			// start a new game
			gameModeView.dealer = 
				([localPlayerId compare:remotePlayerId] == NSOrderedAscending);	

			if (gameModeView.dealer) {
				[gameModeView dealNewHandAsDealer];
			}			
		} else {
			// at least one of the application data files is valid. restore game.
			[gameModeView willRestoreFromHeroApplicationData:heroHoldemApplicationData 
									  villainApplicationData:villainHoldemApplicationData
											 villainDeviceId:nil
													gameMode:kGameCenterMode];
		}
	}	
}	

- (void) restoreHoldem {		
	if (heroHoldemApplicationData && villainHoldemApplicationData) {
		if (heroHoldemApplicationData[0] == (uint8_t)0 &&
			villainHoldemApplicationData[0] == (uint8_t)0) {
			// free hero/villain app data since they are not valid.
			free(heroHoldemApplicationData);
			free(villainHoldemApplicationData);
			heroHoldemApplicationData = nil;
			villainHoldemApplicationData = nil;
			
			// no valid applicaiton data found on either device, send prefs to the other device
			// to start a new game
			NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
			
			const NSInteger messageLength = PREFS_LENGTH + 1;
			uint8_t *message = malloc(messageLength);
			message[0] = (uint8_t)kMovePrefs;
			message[1] = (uint8_t)[defaults integerForKey:KEY_GAME_NAME];
			// tool mode or game mode
			message[2] = (uint8_t)[defaults boolForKey:KEY_TOOL_MODE];	
			[AppController write4ByteInteger:[defaults integerForKey:KEY_NLHOLDEM_HERO_STACK] To:message+3];
			[AppController write4ByteInteger:[defaults integerForKey:KEY_NLHOLDEM_VILLAIN_STACK] To:message+7];
			// sb and bb
			[AppController write2ByteInteger:[defaults integerForKey:KEY_NLHOLDEM_SMALL_BLIND] To:message+11];
			[AppController write2ByteInteger:[defaults integerForKey:KEY_NLHOLDEM_BIG_BLIND] To:message+13];
			[self sendArray:message size:messageLength];
			free(message);		
		} else {
			[self presentHoldemGameModeViewAtHand:0 
										heroStack:0 
									 villainStack:0 
									   smallBlind:0
										 bigBlind:0
							  heroApplicationData:heroHoldemApplicationData
						   villainApplicationData:villainHoldemApplicationData
										 gameMode:kDualPhoneMode];
		}
	}
}

- (void) sendHeroApplicationData {
	// set the flag so this method won't be called twice
	isHeroApplicationDataSent = YES;
	
	// send hero application data to villain
	uint8_t *message = malloc((HOLDEM_APPLICATION_DATA_LENGTH+1) * sizeof(uint8_t));
	message[0] = (uint8_t)kMoveHoldemApplicationData;
	memcpy(message+1, heroHoldemApplicationData, HOLDEM_APPLICATION_DATA_LENGTH);
	[self sendArray:message size:HOLDEM_APPLICATION_DATA_LENGTH+1];
	free(message);
	
	// restore
	[self restoreHoldem];
}

- (void) restoreOmaha {		
	if (heroOmahaApplicationData && villainOmahaApplicationData) {
		if (heroOmahaApplicationData[0] == (uint8_t)0 &&
			villainOmahaApplicationData[0] == (uint8_t)0) {
			// free hero/villain app data since they are not valid.
			free(heroOmahaApplicationData);
			free(villainOmahaApplicationData);
			heroOmahaApplicationData = nil;
			villainOmahaApplicationData = nil;
			
			// no valid applicaiton data found on either device, send prefs to the other device
			// to start a new game
			NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
			
			const NSInteger messageLength = PREFS_LENGTH + 1;
			uint8_t *message = malloc(messageLength);
			message[0] = (uint8_t)kMovePrefs;
			message[1] = (uint8_t)[defaults integerForKey:KEY_GAME_NAME];
			// tool mode or game mode
			message[2] = (uint8_t)[defaults boolForKey:KEY_TOOL_MODE];	
			[AppController write4ByteInteger:[defaults integerForKey:KEY_PLOMAHA_HERO_STACK] To:message+3];
			[AppController write4ByteInteger:[defaults integerForKey:KEY_PLOMAHA_VILLAIN_STACK] To:message+7];
			// sb and bb
			[AppController write2ByteInteger:[defaults integerForKey:KEY_PLOMAHA_SMALL_BLIND] To:message+11];
			[AppController write2ByteInteger:[defaults integerForKey:KEY_PLOMAHA_BIG_BLIND] To:message+13];
			[self sendArray:message size:messageLength];
			free(message);		
		} else {
			[self presentOmahaGameModeViewAtHand:0 
										heroStack:0 
									 villainStack:0 
									   smallBlind:0
										 bigBlind:0
							  heroApplicationData:heroOmahaApplicationData
						   villainApplicationData:villainOmahaApplicationData
										 gameMode:kDualPhoneMode];
		}
	}
}

- (void) sendHeroOmahaApplicationData {
	// set the flag so this method won't be called twice
	isHeroApplicationDataSent = YES;
	
	// send hero application data to villain
	uint8_t *message = malloc((OMAHA_APPLICATION_DATA_LENGTH+1) * sizeof(uint8_t));
	message[0] = (uint8_t)kMoveOmahaApplicationData;
	memcpy(message+1, heroOmahaApplicationData, OMAHA_APPLICATION_DATA_LENGTH);
	[self sendArray:message size:OMAHA_APPLICATION_DATA_LENGTH+1];
	free(message);
	
	// restore
	[self restoreOmaha];
}

- (void) sendHeroDeviceId {
	// this is the very first step of the handshake. because this method is only called from 
	// destroyPicker and destroyPicker is only called when NSStreamEventHasSpaceAvailable 
	// is received, we know we can send by now.
	//NSLog(@"send hero device id");
	// set mode
	viewType = kViewRestoreMode;
	
	//??
	// there might be a postponed sendHeroApplicationData queued up.
	if (!isHeroApplicationDataSent && heroHoldemApplicationData)
		[self sendHeroApplicationData];
	else if (!isHeroApplicationDataSent && heroOmahaApplicationData)
		[self sendHeroOmahaApplicationData];
	
	// send device id to the other phone
	NSString *deviceId = [AppController getDeviceId]; //[[UIDevice currentDevice] uniqueIdentifier];
	NSInteger deviceIdByteLength = [deviceId lengthOfBytesUsingEncoding:NSASCIIStringEncoding];
	const NSInteger messageLength = 2 + deviceIdByteLength + 1;
	uint8_t *message = malloc(messageLength);
	message[0] = (uint8_t)kMoveDeviceId;
	message[1] = (uint8_t)deviceIdByteLength;
	NSData *deviceIdData = [deviceId dataUsingEncoding:NSASCIIStringEncoding];
	[deviceIdData getBytes:message+2];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSInteger pos = 2 + deviceIdByteLength;
	message[pos] = (uint8_t)[defaults integerForKey:KEY_GAME_NAME];
	
	[self sendArray:message size:messageLength];
	free(message);
}

- (void) destroyPicker {
	connectionType = kConnectionWiFi;
	
	[[_picker superview] setBackgroundColor:[UIColor blackColor]];
	[_picker removeFromSuperview];
	[_picker release];
	_picker = nil;
	
	if (BUILD == HU_HOLDEM)
		[self sendHeroDeviceId];
	else if (BUILD == HU_HOLDEM_FREE)
		[self sendHeroDeviceId];		
	else if (BUILD == HU_OMAHA)
		[self sendHeroDeviceId];
	else if (BUILD == HU_OMAHA_FREE)
		[self sendHeroDeviceId];
	else if (BUILD == HU_STUD)
		[self presentSelectModeView];
	else if (BUILD == HU_STUD_FREE)
		[self presentStudGameModeView];
	else if (BUILD == HU_DRAW)
		[self presentSelectModeView];
	else if (BUILD == HU_DRAW_FREE)
		[self presentDrawGameModeView];	
	else if (BUILD == HU_MIXED)
		[self presentSelectModeView];
}

- (void) setVillainDeviceId:(NSString*)villainDeviceId {
	myVillainDeviceId = [NSString  stringWithString:villainDeviceId];
}

- (void) setGameModeViewController:(MyViewController*)gameModeViewController {
	holdemGameModeViewController = gameModeViewController;
}

- (void) setOmahaGameModeViewController:(MyViewController*)gameModeViewController {
	omahaGameModeViewController = gameModeViewController;
}

- (void) flipView:(UIView*)flipView {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:2.0];
	
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
						   forView:_window
							 cache:YES];
	
	//[mainView removeFromSuperview];
	[_window addSubview:flipView];
	
	[UIView commitAnimations];
}

- (void) curlView:(UIView*)curlView {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:2.0];
	
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp
						   forView:_window
							 cache:YES];
	
	[_window addSubview:curlView];
	
	[UIView commitAnimations];
}

/*
- (void) presentInviteView {
	[self flipView:inviteView];	
}*/


- (void) presentBlackjackGameModeView {
	// stop broadcasting on the network because we are now in single player mode.
	[_server release];
	_server = nil;
	
	viewType = kViewBlackjackGameMode;
	
	if (blackjackGameModeViewController == nil) {
		blackjackGameModeViewController = 
		[[MyViewController alloc] initWithNibName:
		 [AppController isFreeVersion] ? @"BlackjackGameModeAdView" : @"BlackjackGameModeView" 
										   bundle:[NSBundle mainBundle]];
		
		BlackjackGameModeView* blackjackGameModeView = (BlackjackGameModeView*)[blackjackGameModeViewController view];
		blackjackGameModeView.navController = self.viewController;
		blackjackGameModeView.appController = self;		
	}
	
	
	[self.viewController pushViewController:blackjackGameModeViewController animated:YES];
	
	// check if there are saved blackjack game mode data.
	NSString *fileName =[self blackjackGameModeFileName];
	NSData *data = [self readApplicationDataFromFile:fileName];
	uint8_t *applicationData = malloc(BLACKJACK_APPLICATION_DATA_LENGTH * sizeof(uint8_t));
	
	if (data == nil)
		applicationData[0] = (uint8_t)0;
	else
		[data getBytes:applicationData];
	
	BlackjackGameModeView* blackjackGameModeView = (BlackjackGameModeView*)[blackjackGameModeViewController view];

	if (applicationData[0] == (uint8_t)0) {
		free(applicationData);
		applicationData = nil;
		
		[blackjackGameModeView willDisplayAtHand:0 heroStack:1000];
		
	} else {
		[blackjackGameModeView willRestoreFromApplicationData:applicationData];
	}
}

- (void) presentBlackjackHeadsupModeView {
	// stop broadcasting on the network because we are now in single player mode.
	[_server release];
	_server = nil;
	
	viewType = kViewBlackjackHeadsupMode;
	
	if (blackjackHeadsupModeViewController == nil) {
		blackjackHeadsupModeViewController = 
		[[MyViewController alloc] initWithNibName:
		 [AppController isFreeVersion] ? @"BlackjackHeadsupModeAdView" : @"BlackjackHeadsupModeView" 
										   bundle:[NSBundle mainBundle]];
		
		BlackjackHeadsupModeView* blackjackHeadsupModeView = (BlackjackHeadsupModeView*)[blackjackHeadsupModeViewController view];
		blackjackHeadsupModeView.navController = self.viewController;
		blackjackHeadsupModeView.appController = self;		
	}
	
	[self.viewController pushViewController:blackjackHeadsupModeViewController animated:YES];
	
	// check if there are saved blackjack headsup mode data.
	NSString *fileName =[self blackjackHeadsupModeFileName];
	NSData *data = [self readApplicationDataFromFile:fileName];
	uint8_t *applicationData = malloc(HEADSUP_BLACKJACK_APPLICATION_DATA_LENGTH * sizeof(uint8_t));
	
	if (data == nil)
		applicationData[0] = (uint8_t)0;
	else
		[data getBytes:applicationData];
	
	BlackjackHeadsupModeView* blackjackHeadsupModeView = (BlackjackHeadsupModeView*)[blackjackHeadsupModeViewController view];
	
	if (applicationData[0] == (uint8_t)0) {
		free(applicationData);
		applicationData = nil;
		
		[blackjackHeadsupModeView willDisplayAtHand:0 heroStack:1000];
		
	} else {
		[blackjackHeadsupModeView willRestoreFromApplicationData:applicationData];
	}
}

- (void) presentHelpHoldemView {
	if (helpViewController == nil) {
		helpViewController =
		[[MyViewController alloc] initWithNibName:
		 [AppController isFreeVersion] ? @"HelpHoldemAdView" : @"HelpHoldemView" 
								bundle:[NSBundle mainBundle]];
		
		HelpHoldemView* helpHoldemView = (HelpHoldemView*)[helpViewController view];
		helpHoldemView.navController = self.viewController;
	}
	
	[self.viewController pushViewController:helpViewController animated:YES];
}

- (void) presentPrefsView {
	if (prefsViewController == nil) {
		prefsViewController =
		[[MyViewController alloc] initWithNibName:
		 [AppController isFreeVersion] ? @"PrefsAdView" : @"PrefsView" 
								bundle:[NSBundle mainBundle]];
		
		PrefsView* prefsView = (PrefsView*)[prefsViewController view];
		prefsView.navController = self.viewController;
	}
	
	[self.viewController pushViewController:prefsViewController animated:YES];	
	
	PrefsView* prefsView = (PrefsView*)[prefsViewController view];
	[prefsView willDisplay];
}

- (void) presentSelectModeView {
	// no longer needed
}

// if A joins B then B is the dealer for the first hand. for tool mode, B's dealer flag will
// be set to NO while A's dealer flag will be set to YES.
- (void) presentToolModeViewAtHand:(NSInteger)handCount {
	viewType = kViewToolMode;
	
	if (holdemToolModeViewController == nil) {
		holdemToolModeViewController = 
		[[MyViewController alloc] initWithNibName:
		 [AppController isFreeVersion] ? @"HeadsupAdView" : @"HeadsupView" 
								bundle:[NSBundle mainBundle]];
		
		HeadsupView* headsupView = (HeadsupView*)[holdemToolModeViewController view];
		headsupView.navController = self.viewController;
		headsupView.appController = self;		
	}
	
	[self.viewController pushViewController:holdemToolModeViewController animated:YES];	
	
	HeadsupView* headsupView = (HeadsupView*)[holdemToolModeViewController view];
	NSString *heroDeviceId = [AppController getDeviceId]; //[[UIDevice currentDevice] uniqueIdentifier];	
	headsupView.dealer = !([heroDeviceId compare:myVillainDeviceId] == NSOrderedAscending);
	[headsupView willDisplayAtHand:handCount];	
}

- (void) presentSinglePhoneModeHoldemGameModeView {
	// stop broadcasting on the network because we are now in single phone mode.
	[_server release];
	_server = nil;
	
	NSString *fileName =[self holdemFileName:nil gameCenterIdPair:nil gameMode:kSinglePhoneMode];
	NSData *data = [self readApplicationDataFromFile:fileName];
	uint8_t *applicationData = malloc(HOLDEM_APPLICATION_DATA_LENGTH * sizeof(uint8_t));
	
	if (data == nil)
		applicationData[0] = (uint8_t)0;
	else
		[data getBytes:applicationData];
	
	if (applicationData[0] == (uint8_t)0) {
		free(applicationData);
		applicationData = nil;
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSInteger heroStack = [defaults integerForKey:KEY_NLHOLDEM_HERO_STACK];
		NSInteger villainStack = [defaults integerForKey:KEY_NLHOLDEM_VILLAIN_STACK];
		NSInteger smallBlind = [defaults integerForKey:KEY_NLHOLDEM_SMALL_BLIND];
		NSInteger bigBlind = [defaults integerForKey:KEY_NLHOLDEM_BIG_BLIND];
		
		[self presentHoldemGameModeViewAtHand:0
									heroStack:heroStack
								 villainStack:villainStack 
								   smallBlind:smallBlind
									 bigBlind:bigBlind
						  heroApplicationData:nil
					   villainApplicationData:nil
									 gameMode:kSinglePhoneMode];	
	} else {
		[self presentHoldemGameModeViewAtHand:0
									heroStack:0 
								 villainStack:0
								   smallBlind:0
									 bigBlind:0
						  heroApplicationData:applicationData
					   villainApplicationData:nil
									 gameMode:kSinglePhoneMode];	
	}
}

- (void) presentSinglePlayerModeHoldemGameModeView {
	// stop broadcasting on the network because we are now in single player mode.
	[_server release];
	_server = nil;

	NSString *fileName =[self holdemFileName:nil gameCenterIdPair:nil gameMode:kSinglePlayerMode];
	NSData *data = [self readApplicationDataFromFile:fileName];
	uint8_t *applicationData = malloc(HOLDEM_APPLICATION_DATA_LENGTH * sizeof(uint8_t));
	
	if (data == nil)
		applicationData[0] = (uint8_t)0;
	else
		[data getBytes:applicationData];
	
	if (applicationData[0] == (uint8_t)0) {
		free(applicationData);
		applicationData = nil;
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSInteger heroStack = [defaults integerForKey:KEY_NLHOLDEM_HERO_STACK];
		NSInteger villainStack = [defaults integerForKey:KEY_NLHOLDEM_VILLAIN_STACK];
		NSInteger smallBlind = [defaults integerForKey:KEY_NLHOLDEM_SMALL_BLIND];
		NSInteger bigBlind = [defaults integerForKey:KEY_NLHOLDEM_BIG_BLIND];
		
		[self presentHoldemGameModeViewAtHand:0
									heroStack:heroStack
								 villainStack:villainStack 
								   smallBlind:smallBlind
									 bigBlind:bigBlind
						  heroApplicationData:nil
					   villainApplicationData:nil
									 gameMode:kSinglePlayerMode];	
	} else {
		[self presentHoldemGameModeViewAtHand:0
									heroStack:0 
								 villainStack:0
								   smallBlind:0
									 bigBlind:0
						  heroApplicationData:applicationData
					   villainApplicationData:nil
									 gameMode:kSinglePlayerMode];	
	}
}

- (void) presentTrainingModeHoldemGameModeView {
	// stop broadcasting on the network because we are now in single player mode.
	[_server release];
	_server = nil;
	
	viewType = kViewHoldemTrainingMode;
	
	if (holdemTrainingModeViewController == nil) {
		holdemTrainingModeViewController = 
		[[MyViewController alloc] initWithNibName:
		 [AppController isFreeVersion] ? @"TrainingModeAdView" : @"TrainingModeView" 
										   bundle:[NSBundle mainBundle]];
		
		TrainingModeView* trainingModeView = (TrainingModeView*)[holdemTrainingModeViewController view];
		trainingModeView.navController = self.viewController;
		trainingModeView.appController = self;				
	}
	
	[self.viewController pushViewController:holdemTrainingModeViewController animated:YES];

	// check if there are saved training mode data.
	NSString *fileName =[self holdemTrainingModeFileName];
	NSData *data = [self readApplicationDataFromFile:fileName];
	uint8_t *applicationData = malloc(HOLDEM_TRAINING_MODE_APPLICATION_DATA_LENGTH * sizeof(uint8_t));
	
	if (data == nil)
		applicationData[0] = (uint8_t)0;
	else
		[data getBytes:applicationData];
	
	TrainingModeView* trainingModeView = (TrainingModeView*)[holdemTrainingModeViewController view];
	
	if (applicationData[0] == (uint8_t)0) {
		free(applicationData);
		applicationData = nil;
		
		[trainingModeView willDisplay];
				
	} else {
		[trainingModeView willRestoreFromApplicationData:applicationData];
	}
	
}

// send saved application data to the other device to initiate restoring
// a saved game that was last played with the same villain.
- (void) startRestoringGame {
	if (gameName == kGameHoldem) {
		// now that we have the remote player id, we are able to
		// read the application data file if any and send it to
		// the other device.
		NSString *fileName =[self holdemFileName:nil
								gameCenterIdPair:[self getGameCenterIdPair]
										gameMode:kGameCenterMode];
		NSData *fileData = [self readApplicationDataFromFile:fileName];
		heroHoldemApplicationData = malloc(HOLDEM_APPLICATION_DATA_LENGTH * sizeof(uint8_t));
		
		if (fileData == nil)
			heroHoldemApplicationData[0] = (uint8_t)0;
		else
			[fileData getBytes:heroHoldemApplicationData];
		
		// send app data to the other device
		uint8_t *message = malloc((HOLDEM_APPLICATION_DATA_LENGTH+1) * sizeof(uint8_t));
		// the first byte is reserved for future use.
		//message[0] = (uint8_t)kMoveHoldemApplicationData;
		memcpy(message+1, heroHoldemApplicationData, HOLDEM_APPLICATION_DATA_LENGTH);
		[self sendArray:message size:HOLDEM_APPLICATION_DATA_LENGTH+1];
		free(message);
		
		// restore holdem game if both devices' app data are available;
		// otherwise do nothing.
		[self restoreGameCenterHoldem];								  
		
	} else {
		/*
		 OmahaGameModeView* gameModeView = (OmahaGameModeView*)[omahaGameModeViewController view];
		 
		 gameModeView.dealer = 
		 ([localPlayerId compare:remotePlayerId] == NSOrderedAscending);	
		 
		 if (gameModeView.dealer) {
		 [gameModeView dealNewHandAsDealer];
		 }*/
	}
}

- (void) presentHoldemGameCenterModeView:(GKMatch *)match {
	viewType = kViewRestoreMode;

	if (holdemGameModeViewController == nil) {
		holdemGameModeViewController =
		[[MyViewController alloc] initWithNibName:
		 [AppController isFreeVersion] ? 
		 @"GameModeAdView" : @"GameModeView"
										   bundle:[NSBundle mainBundle]];
		
		GameModeView* gameModeView = (GameModeView*)[holdemGameModeViewController view];
		gameModeView.navController = self.viewController;
		gameModeView.appController = self;				
	}
	
	[self.viewController pushViewController:holdemGameModeViewController animated:YES];
	
	GameModeView* gameModeView = (GameModeView*)[holdemGameModeViewController view];
		
	// at this point we don't know who is going to be the dealer.
	// the flag will be set when we receive the didFindMatch callback.
	gameModeView.dealer = NO;
	
	[[NSUserDefaults standardUserDefaults] 
	 setObject:@"villain" 
	 forKey:KEY_VILLAIN_NAME];	
	
	[gameModeView willDisplayAtHand:0 
						  heroStack:GAME_CENTER_HOLDEM_STACK
					   villainStack:GAME_CENTER_HOLDEM_STACK
						 smallBlind:GAME_CENTER_HOLDEM_SMALL_BLIND
						   bigBlind:GAME_CENTER_HOLDEM_BIG_BLIND
					villainDeviceId:nil
						   gameMode:kGameCenterMode];	
	
	
	if (match.expectedPlayerCount == 1) {
		[gameModeView showWaiting];
	} else { // match.expectedPlayerCount == 0
		for (NSString *playerID in match.playerIDs) {
			if ([localPlayerId compare:playerID] != NSOrderedSame) {
				remotePlayerId = playerID;
				break;
			}
		}
				
		[GKPlayer loadPlayersForIdentifiers:[NSArray arrayWithObject:remotePlayerId] 
					  withCompletionHandler:^(NSArray *players, NSError *error) {
					  if (error) {
						  NSLog(@"load player info error");
					  } else {
						  [[NSUserDefaults standardUserDefaults] 
						   setObject:((GKPlayer*)[players objectAtIndex:0]).alias 
						   forKey:KEY_VILLAIN_NAME];
						  
						  GameModeView* gameModeView = (GameModeView*)[holdemGameModeViewController view];
						  [gameModeView updateHeroAndVillainNames];
					  }
						  
					[self startRestoringGame];
				  }];
	}
}

- (void) presentOmahaGameCenterModeView {
	viewType = kViewOmahaGameMode;

	if (omahaGameModeViewController == nil) {
		omahaGameModeViewController =
		[[MyViewController alloc] initWithNibName:
		 [AppController isFreeVersion] ? 
		 @"OmahaGameModeAdView" : @"OmahaGameModeView"
										   bundle:[NSBundle mainBundle]];
		
		OmahaGameModeView* gameModeView = (OmahaGameModeView*)[omahaGameModeViewController view];
		gameModeView.navController = self.viewController;
		gameModeView.appController = self;				
	}
	
	[self.viewController pushViewController:omahaGameModeViewController animated:YES];
	
	OmahaGameModeView* gameModeView = (OmahaGameModeView*)[omahaGameModeViewController view];
	
	// at this point we don't know who is going to be the dealer.
	// the flag will be set when we receive the didFindMatch callback.
	gameModeView.dealer = NO;
	
	if (heroOmahaApplicationData != nil && villainOmahaApplicationData != nil) {
		[gameModeView willRestoreFromHeroApplicationData:heroOmahaApplicationData 
								  villainApplicationData:villainOmahaApplicationData
										 villainDeviceId:nil
												gameMode:kGameCenterMode];
	} else {
		[gameModeView willDisplayAtHand:0 
							  heroStack:GAME_CENTER_OMAHA_STACK
						   villainStack:GAME_CENTER_OMAHA_STACK
							 smallBlind:GAME_CENTER_OMAHA_SMALL_BLIND
							   bigBlind:GAME_CENTER_OMAHA_BIG_BLIND
						villainDeviceId:nil
							   gameMode:kGameCenterMode];	
	}	
}

// if A joins B then B is the dealer for the first hand. for game mode, B's dealer flag will
// be set to YES while A's dealer flag will be set to NO.
- (void) presentHoldemGameModeViewAtHand:(NSInteger)handCount 
							   heroStack:(NSInteger)heroStack 
							villainStack:(NSInteger)villainStack 
							  smallBlind:(NSInteger)smallBlind
								bigBlind:(NSInteger)bigBlind
					 heroApplicationData:(uint8_t*)heroApplicationData 
				  villainApplicationData:(uint8_t*)villainApplicationData
								gameMode:(enum GameMode)gameMode
{
	viewType = kViewGameMode;
	
	if (holdemGameModeViewController == nil) {
		holdemGameModeViewController = 
		[[MyViewController alloc] initWithNibName:
		 [AppController isFreeVersion] ? @"GameModeAdView" : @"GameModeView" 
								bundle:[NSBundle mainBundle]];
		
		GameModeView* gameModeView = (GameModeView*)[holdemGameModeViewController view];
		gameModeView.navController = self.viewController;
		gameModeView.appController = self;				
	}
	
	[self.viewController pushViewController:holdemGameModeViewController animated:YES];
		
	GameModeView* gameModeView = (GameModeView*)[holdemGameModeViewController view];
	NSString *heroDeviceId = [AppController getDeviceId]; //[[UIDevice currentDevice] uniqueIdentifier];	
	gameModeView.dealer = 
	gameMode == kDualPhoneMode ?
	([heroDeviceId compare:myVillainDeviceId] == NSOrderedAscending) :
	YES;
	
	if (gameMode == kSinglePhoneMode) {
		// force user to enter names for the two players that will be using the same phone.
		[[NSUserDefaults standardUserDefaults] setObject:@"hero" forKey:KEY_HERO_NAME];
		[[NSUserDefaults standardUserDefaults] setObject:@"villain" forKey:KEY_VILLAIN_NAME];
		
		if (heroApplicationData != nil) {
			[gameModeView willRestoreFromHeroApplicationData:heroApplicationData 
									  villainApplicationData:villainApplicationData
											 villainDeviceId:nil
													gameMode:kSinglePhoneMode];
		} else {			
			[gameModeView willDisplayAtHand:handCount 
								  heroStack:heroStack 
							   villainStack:villainStack 
								 smallBlind:smallBlind
								   bigBlind:bigBlind
							villainDeviceId:nil
								   gameMode:kSinglePhoneMode];		
		}
	} else if (gameMode == kSinglePlayerMode) {
		if (heroApplicationData != nil)
			[gameModeView willRestoreFromHeroApplicationData:heroApplicationData 
									  villainApplicationData:villainApplicationData
											 villainDeviceId:nil
													gameMode:kSinglePlayerMode];
		else
			[gameModeView willDisplayAtHand:handCount 
								  heroStack:heroStack 
							   villainStack:villainStack 
								 smallBlind:smallBlind
								   bigBlind:bigBlind
							villainDeviceId:nil
								   gameMode:kSinglePlayerMode];		
		
	} else {
		if (heroApplicationData != nil && villainApplicationData != nil)
			[gameModeView willRestoreFromHeroApplicationData:heroApplicationData 
									  villainApplicationData:villainApplicationData
											 villainDeviceId:myVillainDeviceId
													gameMode:kDualPhoneMode];
		else
			[gameModeView willDisplayAtHand:handCount 
								  heroStack:heroStack 
							   villainStack:villainStack 
								 smallBlind:smallBlind
								   bigBlind:bigBlind
							villainDeviceId:myVillainDeviceId
								   gameMode:kDualPhoneMode];		
	}
}

// if A joins B then B is the dealer for the first hand. for tool mode, B's dealer flag will
// be set to NO while A's dealer flag will be set to YES.
- (void) presentOmahaToolModeViewAtHand:(NSInteger)handCount {
	viewType = kViewOmahaToolMode;
	
	if (omahaToolModeViewController == nil) {
		omahaToolModeViewController = 
		[[MyViewController alloc] initWithNibName:
		 [AppController isFreeVersion] ? @"OmahaToolModeAdView" : @"OmahaToolModeView"
										   bundle:[NSBundle mainBundle]];
		
		OmahaToolModeView* omahaToolModeView = (OmahaToolModeView*)[omahaToolModeViewController view];
		omahaToolModeView.navController = self.viewController;
		omahaToolModeView.appController = self;				
	}
	
	[self.viewController pushViewController:omahaToolModeViewController animated:YES];	
	
	OmahaToolModeView* omahaToolModeView = (OmahaToolModeView*)[omahaToolModeViewController view];
	NSString *heroDeviceId = [AppController getDeviceId]; //[[UIDevice currentDevice] uniqueIdentifier];	
	omahaToolModeView.dealer = !([heroDeviceId compare:myVillainDeviceId] == NSOrderedAscending);
	[omahaToolModeView willDisplayAtHand:handCount];	
}

- (void) presentSinglePhoneModeOmahaGameModeView {	
	// stop broadcasting on the network because we are now in single phone mode.
	[_server release];
	_server = nil;
	
	NSString *fileName =[self omahaFileName:nil gameMode:kSinglePhoneMode];
	NSData *data = [self readApplicationDataFromFile:fileName];
	uint8_t *applicationData = malloc(OMAHA_APPLICATION_DATA_LENGTH * sizeof(uint8_t));
	
	if (data == nil)
		applicationData[0] = (uint8_t)0;
	else
		[data getBytes:applicationData];
	
	if (applicationData[0] == (uint8_t)0) {
		free(applicationData);
		applicationData = nil;
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSInteger heroStack = [defaults integerForKey:KEY_PLOMAHA_HERO_STACK];
		NSInteger villainStack = [defaults integerForKey:KEY_PLOMAHA_VILLAIN_STACK];
		NSInteger smallBlind = [defaults integerForKey:KEY_PLOMAHA_SMALL_BLIND];
		NSInteger bigBlind = [defaults integerForKey:KEY_PLOMAHA_BIG_BLIND];
		
		[self presentOmahaGameModeViewAtHand:0
								   heroStack:heroStack
								villainStack:villainStack 
								  smallBlind:smallBlind
									bigBlind:bigBlind
						 heroApplicationData:nil
					  villainApplicationData:nil
									gameMode:kSinglePhoneMode];	
	} else {
		[self presentOmahaGameModeViewAtHand:0
								   heroStack:0 
								villainStack:0
								  smallBlind:0
									bigBlind:0
						 heroApplicationData:applicationData
					  villainApplicationData:nil
									gameMode:kSinglePhoneMode];	
	}
}

- (void) presentSinglePlayerModeOmahaGameModeView {
	// stop broadcasting on the network because we are now in single player mode.
	[_server release];
	_server = nil;
	
	NSString *fileName =[self omahaFileName:nil gameMode:kSinglePlayerMode];
	NSData *data = [self readApplicationDataFromFile:fileName];
	uint8_t *applicationData = malloc(OMAHA_APPLICATION_DATA_LENGTH * sizeof(uint8_t));
	
	if (data == nil)
		applicationData[0] = (uint8_t)0;
	else
		[data getBytes:applicationData];
	
	if (applicationData[0] == (uint8_t)0) {
		free(applicationData);
		applicationData = nil;
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSInteger heroStack = [defaults integerForKey:KEY_PLOMAHA_HERO_STACK];
		NSInteger villainStack = [defaults integerForKey:KEY_PLOMAHA_VILLAIN_STACK];
		NSInteger smallBlind = [defaults integerForKey:KEY_PLOMAHA_SMALL_BLIND];
		NSInteger bigBlind = [defaults integerForKey:KEY_PLOMAHA_BIG_BLIND];
		
		[self presentOmahaGameModeViewAtHand:0
								   heroStack:heroStack
								villainStack:villainStack 
								  smallBlind:smallBlind
									bigBlind:bigBlind
						 heroApplicationData:nil
					  villainApplicationData:nil
									gameMode:kSinglePlayerMode];	
	} else {
		[self presentOmahaGameModeViewAtHand:0
								   heroStack:0 
								villainStack:0
								  smallBlind:0
									bigBlind:0
						 heroApplicationData:applicationData
					  villainApplicationData:nil
									gameMode:kSinglePlayerMode];	
	}
}

- (void) presentTrainingModeOmahaGameModeView {
	// stop broadcasting on the network because we are now in single player mode.
	[_server release];
	_server = nil;
	
	viewType = kViewOmahaTrainingMode;
	
	if (omahaTrainingModeViewController == nil) {
		omahaTrainingModeViewController = 
		[[MyViewController alloc] initWithNibName:
		 [AppController isFreeVersion] ? @"OmahaTrainingModeAdView" : @"OmahaTrainingModeView" 
										   bundle:[NSBundle mainBundle]];
		
		OmahaTrainingModeView* omahaTrainingModeView = (OmahaTrainingModeView*)[omahaTrainingModeViewController view];
		omahaTrainingModeView.navController = self.viewController;
		omahaTrainingModeView.appController = self;						
	}
	
	[self.viewController pushViewController:omahaTrainingModeViewController animated:YES];
	
	// check if there are saved training mode data.
	NSString *fileName =[self omahaTrainingModeFileName];
	NSData *data = [self readApplicationDataFromFile:fileName];
	uint8_t *applicationData = malloc(OMAHA_TRAINING_MODE_APPLICATION_DATA_LENGTH * sizeof(uint8_t));
	
	if (data == nil)
		applicationData[0] = (uint8_t)0;
	else
		[data getBytes:applicationData];
	
	OmahaTrainingModeView* omahaTrainingModeView = (OmahaTrainingModeView*)[omahaTrainingModeViewController view];

	if (applicationData[0] == (uint8_t)0) {
		free(applicationData);
		applicationData = nil;
		
		[omahaTrainingModeView willDisplay];
		
	} else {
		[omahaTrainingModeView willRestoreFromApplicationData:applicationData];
	}
}


// if A joins B then B is the dealer for the first hand. for game mode, B's dealer flag will
// be set to YES while A's dealer flag will be set to NO.
- (void) presentOmahaGameModeViewAtHand:(NSInteger)handCount 
							  heroStack:(NSInteger)heroStack 
						   villainStack:(NSInteger)villainStack 
							 smallBlind:(NSInteger)smallBlind
							   bigBlind:(NSInteger)bigBlind
					heroApplicationData:(uint8_t*)heroApplicationData 
				 villainApplicationData:(uint8_t*)villainApplicationData
							   gameMode:(enum GameMode)gameMode 
{
	viewType = kViewOmahaGameMode;
	
	if (omahaGameModeViewController == nil) {
		omahaGameModeViewController= 
		[[MyViewController alloc] initWithNibName:
		 [AppController isFreeVersion] ? @"OmahaGameModeAdView" : @"OmahaGameModeView" 
										   bundle:[NSBundle mainBundle]];
		
		OmahaGameModeView* omahaGameModeView = (OmahaGameModeView*)[omahaGameModeViewController view];
		omahaGameModeView.navController = self.viewController;
		omahaGameModeView.appController = self;						
	}
	
	[self.viewController pushViewController:omahaGameModeViewController animated:YES];
		
	OmahaGameModeView* gameModeView = (OmahaGameModeView*)[omahaGameModeViewController view];
	NSString *heroDeviceId = [AppController getDeviceId]; //[[UIDevice currentDevice] uniqueIdentifier];		
	gameModeView.dealer = 
	gameMode == kDualPhoneMode ?
	([heroDeviceId compare:myVillainDeviceId] == NSOrderedAscending) :
	YES;
	
	if (gameMode == kSinglePhoneMode) {
		// force user to enter names for the two players that will be using the same phone.
		[[NSUserDefaults standardUserDefaults] setObject:@"hero" forKey:KEY_HERO_NAME];
		[[NSUserDefaults standardUserDefaults] setObject:@"villain" forKey:KEY_VILLAIN_NAME];
		
		if (heroApplicationData != nil) {
			[gameModeView willRestoreFromHeroApplicationData:heroApplicationData 
									  villainApplicationData:villainApplicationData
											 villainDeviceId:nil
													gameMode:kSinglePhoneMode];
		} else {			
			[gameModeView willDisplayAtHand:handCount 
								  heroStack:heroStack 
							   villainStack:villainStack 
								 smallBlind:smallBlind
								   bigBlind:bigBlind
							villainDeviceId:nil
								   gameMode:kSinglePhoneMode];		
		}
	} else if (gameMode == kSinglePlayerMode) {
		if (heroApplicationData != nil)
			[gameModeView willRestoreFromHeroApplicationData:heroApplicationData 
									  villainApplicationData:villainApplicationData
											 villainDeviceId:nil
													gameMode:kSinglePlayerMode];
		else
			[gameModeView willDisplayAtHand:handCount 
								  heroStack:heroStack 
							   villainStack:villainStack 
								 smallBlind:smallBlind
								   bigBlind:bigBlind
							villainDeviceId:nil
								   gameMode:kSinglePlayerMode];		
		
	} else {
		if (heroApplicationData != nil && villainApplicationData != nil)
			[gameModeView willRestoreFromHeroApplicationData:heroApplicationData 
									  villainApplicationData:villainApplicationData
											 villainDeviceId:myVillainDeviceId
													gameMode:kDualPhoneMode];
		else
			[gameModeView willDisplayAtHand:handCount 
								  heroStack:heroStack 
							   villainStack:villainStack 
								 smallBlind:smallBlind
								   bigBlind:bigBlind
							villainDeviceId:myVillainDeviceId
								   gameMode:kDualPhoneMode];		
	}	
}

// if A joins B then B is the dealer for the first hand. for tool mode, B's dealer flag will
// be set to NO while A's dealer flag will be set to YES.
- (void) presentStudToolModeView {
}

// if A joins B then B is the dealer for the first hand. for game mode, B's dealer flag will
// be set to YES while A's dealer flag will be set to NO.
- (void) presentStudGameModeView {
}

// if A joins B then B is the dealer for the first hand. for tool mode, B's dealer flag will
// be set to NO while A's dealer flag will be set to YES.
- (void) presentDrawToolModeView {
}

// if A joins B then B is the dealer for the first hand. for game mode, B's dealer flag will
// be set to YES while A's dealer flag will be set to NO.
- (void) presentDrawGameModeView {
}

- (void) requestProductData {
	// the request object will be released in the productsRequest: didReceiveResponse: method.
	SKProductsRequest *request= [[SKProductsRequest alloc] 
								 initWithProductIdentifiers: 
								 [NSSet setWithObject: kHeadsupProVersionProductID]];
	request.delegate = self; 
	[request start];
} 

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
	NSArray *myProduct = response.products;
	
	if ([myProduct count] > 0) {
		SKProduct *product = [myProduct objectAtIndex:0];
		
		if (product) {
			NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
			[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
			[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
			[numberFormatter setLocale:product.priceLocale];
			NSString *formattedString = [numberFormatter stringFromNumber:product.price];
			[numberFormatter release];
			
			// UI for user to place an order or cancel. The actions will be handled in the delegate methods.
			UIAlertView* alert= [[[UIAlertView alloc] initWithTitle: [product localizedTitle] 
															message: [NSString stringWithFormat:@"%@ %@", formattedString, [product localizedDescription]]
														   delegate: self 
												  cancelButtonTitle: kPlaceOrderTitle 
												  otherButtonTitles: @"No, thanks", nil] autorelease];
			
			alert.tag = kTagPlaceOrder;
			[alert show];
		} else {
			[self showAlertWithTitle:@"Warning" message:@"No product info can be retrieved at this moment. Please try again later."];
		}
	} else {
		[self showAlertWithTitle:@"Warning" message:@"No product info can be retrieved at this moment. Please try again later."];
	}
	
	[request autorelease];
}

- (void) buyButtonPressed {
	if ([SKPaymentQueue canMakePayments]) {
		// Display a store to the user.
		[self requestProductData];
	} else {
		// Warn the user that purchases are disabled.
		[self showAlertWithTitle:@"Change your setting" message:@"You are not allowed to make payments on this device."];
	}	
}

- (void) enableProUpgrade {
	// remove ad view from all views
	UIView *adView = [poker3GViewController.view viewWithTag:AD_VIEW_TAG];
	[adView removeFromSuperview];
    
    adView = [helpViewController.view viewWithTag:AD_VIEW_TAG];
	[adView removeFromSuperview];
    
    adView = [prefsViewController.view viewWithTag:AD_VIEW_TAG];
	[adView removeFromSuperview];

    adView = [gameCenterViewController.view viewWithTag:AD_VIEW_TAG];
	[adView removeFromSuperview];

    adView = [selectModeViewController.view viewWithTag:AD_VIEW_TAG];
	[adView removeFromSuperview];

    adView = [holdemToolModeViewController.view viewWithTag:AD_VIEW_TAG];
	[adView removeFromSuperview];

    adView = [holdemGameModeViewController.view viewWithTag:AD_VIEW_TAG];
	[adView removeFromSuperview];

    adView = [holdemTrainingModeViewController.view viewWithTag:AD_VIEW_TAG];
	[adView removeFromSuperview];

    adView = [omahaToolModeViewController.view viewWithTag:AD_VIEW_TAG];
	[adView removeFromSuperview];

    adView = [omahaGameModeViewController.view viewWithTag:AD_VIEW_TAG];
	[adView removeFromSuperview];

    adView = [omahaTrainingModeViewController.view viewWithTag:AD_VIEW_TAG];
	[adView removeFromSuperview];

    adView = [blackjackGameModeViewController.view viewWithTag:AD_VIEW_TAG];
	[adView removeFromSuperview];

    adView = [blackjackHeadsupModeViewController.view viewWithTag:AD_VIEW_TAG];
	[adView removeFromSuperview];

	
	// hide the buy button
    UIView *buyButton = [_picker viewWithTag:BUY_BUTTON_TAG];
	[buyButton removeFromSuperview];
}	

+ (BOOL) isProUpgradePurchased {
	BOOL isPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:kHeadsupProVersionPurchasedKey];
	
	return isPurchased;
}

+ (BOOL)isFreeVersion {
	return ![AppController isProUpgradePurchased] && (BUILD == HU_HOLDEM_FREE);
}

+ (NSString *)uuid
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    NSString *uuid = [NSString stringWithString:(NSString *)
                      uuidStringRef];
    CFRelease(uuidStringRef);
    return uuid;
}

+ (NSString*)getDeviceId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if ([defaults objectForKey:KEY_DEVICE_ID] == nil) {
		[defaults setObject:[AppController uuid] forKey:KEY_DEVICE_ID];
        [defaults synchronize];
	}
    
    NSLog(@"device id: %@", [defaults stringForKey:KEY_DEVICE_ID]);
    
    return [defaults stringForKey:KEY_DEVICE_ID];
}

// If we display an error or an alert that the remote disconnected, handle dismissal and return to setup
- (void) alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView.tag == kTagPlaceOrder) {
		// in app purchase dialog
		if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:kPlaceOrderTitle]) {
			SKPayment *payment = [SKPayment paymentWithProductIdentifier:kHeadsupProVersionProductID]; 
			[[SKPaymentQueue defaultQueue] addPayment:payment];
		}
		
	} else {		
		[self saveApplicationData];
		[viewController popViewControllerAnimated:YES];
		[self setup];
	}
}

- (void) sendBluetooth:(uint8_t)message {
	uint8_t *array = malloc(1);
	array[0] = message;
	NSData *packet = [NSData dataWithBytes: array length: 1];
	free(array);
	
	[self.gameSession sendData:packet 
					   toPeers:[NSArray arrayWithObject:self.gamePeerId] 
				  withDataMode:GKSendDataReliable 
						 error:nil];	
}

- (void) sendArrayBluetooth:(uint8_t[])message size:(uint8_t)size {
	NSData *packet = [NSData dataWithBytes: message length: size];
	
	[self.gameSession sendData:packet 
					   toPeers:[NSArray arrayWithObject:self.gamePeerId] 
				  withDataMode:GKSendDataReliable 
						 error:nil];
}

- (void) sendGameCenter:(uint8_t)message {
	uint8_t *array = malloc(1);
	array[0] = message;
	NSData *packet = [NSData dataWithBytes: array length: 1];
	free(array);
	
	NSError *error;

	if (![gameMatch sendDataToAllPlayers:packet
							withDataMode:GKMatchSendDataReliable 
								   error:&error]) {
		if (error != nil) {
            NSLog(@"error=%@", [error localizedDescription]);
        }		
	}
}

- (void) sendArrayGameCenter:(uint8_t[])message size:(uint8_t)size {
	NSData *packet = [NSData dataWithBytes: message length: size];
	
	NSError *error;
	
	if (![gameMatch sendDataToAllPlayers:packet
							withDataMode:GKMatchSendDataReliable 
								   error:&error]) {
		if (error != nil) {
            NSLog(@"error=%@", [error localizedDescription]);
        }		
	}
}

- (void) send:(const uint8_t)message {
#ifdef HU_3G
	[(Poker3GView*)[poker3GViewController view] send:message];
#else
	if (connectionType == kConnectionBluetooth) {
		[self sendBluetooth:message];
	} else if (connectionType == kConnectionWiFi) {
		if (_outStream && [_outStream hasSpaceAvailable])
			if([_outStream write:(const uint8_t *)&message maxLength:sizeof(const uint8_t)] == -1)
				[self _showAlert:@"Data transmission failed"];		
	} else if (connectionType == kConnectionGameCenter) {
		[self sendGameCenter:message];
	}
#endif
}

- (void) sendArray:(uint8_t[])message size:(uint8_t)size {
#ifdef HU_3G
	[(Poker3GView*)[poker3GViewController view] sendArray:message size:size];
#else
	if (connectionType == kConnectionBluetooth) {
		[self sendArrayBluetooth:message size:size];
	} else if (connectionType == kConnectionWiFi) {
		if (_outStream && [_outStream hasSpaceAvailable])
			if([_outStream write:(const uint8_t *)message maxLength:sizeof(const uint8_t) * size] == -1)
				[self _showAlert:@"Data transmission failed"];
	} else if (connectionType == kConnectionGameCenter) {
		[self sendArrayGameCenter:message size:size];
	}
#endif
}

- (void) toolEndedAtHand:(NSInteger)handCount game:(enum GameName)game {
	if (game == kGameHoldem) {
		[self presentOmahaToolModeViewAtHand:handCount];
	} else if (game == kGameOmahaHi) {
		[self presentToolModeViewAtHand:handCount];
	}
}

- (void) gameEndedAtHand:(NSInteger)handCount 
					game:(enum GameName)game
			   heroStack:(NSInteger)heroStack 
			villainStack:(NSInteger)villainStack 
			  smallBlind:(NSInteger)smallBlind
				bigBlind:(NSInteger)bigBlind {
	if (game == kGameHoldem) {
		[self presentOmahaGameModeViewAtHand:handCount 
									heroStack:heroStack 
								 villainStack:villainStack
								   smallBlind:smallBlind
									 bigBlind:bigBlind
						  heroApplicationData:nil 
					   villainApplicationData:nil
									 gameMode:kDualPhoneMode];
	} else if (game == kGameOmahaHi) {
		[self presentHoldemGameModeViewAtHand:handCount 
									heroStack:heroStack 
								 villainStack:villainStack
								   smallBlind:smallBlind
									 bigBlind:bigBlind
						  heroApplicationData:nil 
					   villainApplicationData:nil
									 gameMode:kDualPhoneMode];
	}
}



/*
- (void) activateView:(TapView*)view
{
	[self send:[view tag] | 0x80];
}

- (void) deactivateView:(TapView*)view
{
	[self send:[view tag] & 0x7f];
}
*/

- (void) openStreams
{
	_inStream.delegate = self;
	[_inStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[_inStream open];
	_outStream.delegate = self;
	[_outStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[_outStream open];
}

- (void) setSelfAsDealer {	
	//((SelectModeView*)[self.viewController view]).dealer = YES;
	dealer = YES;
}

- (void) setSelfAsNonDealer {		
	//((SelectModeView*)[self.viewController view]).dealer = NO;
	dealer = NO;
}


- (void) browserViewController:(BrowserViewController*)bvc didResolveInstance:(NSNetService*)netService
{
	//NSLog(@"did resolve instance");
	
	[self setSelfAsDealer];
	
	if (!netService) {
		[self setup];
		return;
	}

	if (![netService getInputStream:&_inStream outputStream:&_outStream]) {
		[self _showAlert:@"Server connection failed"];
		return;
	}

	[self openStreams];
	
	//NSLog(@"after openStreams");
}

//@end

//@implementation AppController (NSStreamDelegate)

// b is of type enum kMoveType
// kMoveDeviceId -> kMoveHoldemApplicationData -> restore application data if at least one of
// them has an applicationData[0] that's not 0; if both applicationData[0] are 0 -> kMovePrefs
// to start a new game.
- (void) handleRestoreModeMessageWithFirstByte:(uint8_t) b {
	//NSLog(@"restore %d", b);
	if (b == kMoveDeviceId) {
		//isViewPresented = YES;

		uint8_t deviceIdByteLength;
		[_inStream read:&deviceIdByteLength maxLength:1];
		
		uint8_t *deviceIdBytes = malloc(deviceIdByteLength);
		NSInteger bytesToRead = deviceIdByteLength;
		NSInteger bytesRead = 0;
		do {
			NSInteger len = [_inStream read:deviceIdBytes+bytesRead maxLength:bytesToRead];
			bytesRead += len;
			bytesToRead -= len;
		} while (bytesToRead > 0);
		
		myVillainDeviceId = [[NSString alloc] initWithBytes:deviceIdBytes length:deviceIdByteLength encoding:NSASCIIStringEncoding];
		free(deviceIdBytes);
		
		// villain's game
		uint8_t oneByte;
		[_inStream read:&oneByte maxLength:1];
		enum GameName villainGame = oneByte;
		
		// hero's game
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		enum GameName heroGame = [defaults integerForKey:KEY_GAME_NAME];

		// both holde'm: restore hold'em or start a new hold'em game
		// both omaha: restore omaha or start a new omaha game
		// one hold'em one omaha: prompt the user
		if (heroGame != villainGame) {
			[self ignoreOpponentDisconnect];

			NSString* differences = 
			[NSString stringWithFormat:@"You: %@\nOpponent: %@", 
			 heroGame == kGameHoldem ? @"No Limit Texas Hold'em" : @"Pot Limit Omaha",
			 villainGame == kGameHoldem ? @"No Limit Texas Hold'em" : @"Pot Limit Omaha"];
			
			UIAlertView* alertView = 
			[[UIAlertView alloc] initWithTitle:@"Change your settings" 
									   message:differences
									  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alertView show];
			[alertView release];			
		} else {
			//heroGame == villainGame
			if (heroGame == kGameHoldem) {
				// read hero application data from file
				NSString *fileName =[self holdemFileName:myVillainDeviceId 
										gameCenterIdPair:nil 
												gameMode:kDualPhoneMode];
				NSData *data = [self readApplicationDataFromFile:fileName];
				heroHoldemApplicationData = malloc(HOLDEM_APPLICATION_DATA_LENGTH * sizeof(uint8_t));
				
				if (data == nil)
					heroHoldemApplicationData[0] = (uint8_t)0;
				else
					[data getBytes:heroHoldemApplicationData];
				
				// this is rather tricky. we may receive this message when we are not yet allowed to send.
				// if that's the case, we must postpone sending till we get the green light.
				if (isViewPresented && !isHeroApplicationDataSent)
					[self sendHeroApplicationData];				
			} else { // heroGame == kGameOmaha
				// read hero application data from file
				NSString *fileName =[self omahaFileName:myVillainDeviceId gameMode:kDualPhoneMode];
				NSData *data = [self readApplicationDataFromFile:fileName];
				heroOmahaApplicationData = malloc(OMAHA_APPLICATION_DATA_LENGTH * sizeof(uint8_t));
				
				if (data == nil)
					heroOmahaApplicationData[0] = (uint8_t)0;
				else
					[data getBytes:heroOmahaApplicationData];
				
				// this is rather tricky. we may receive this message when we are not yet allowed to send.
				// if that's the case, we must postpone sending till we get the green light.
				if (isViewPresented && !isHeroApplicationDataSent)
					[self sendHeroOmahaApplicationData];								
			}
		}
	} else if (b == kMoveHoldemApplicationData) {
		// read data into villainHoldemApplicationData
		NSInteger bytesToRead = HOLDEM_APPLICATION_DATA_LENGTH * sizeof(uint8_t);
		villainHoldemApplicationData = malloc(bytesToRead);
		
		NSInteger bytesRead = 0;
		do {
			NSInteger len = [_inStream read:villainHoldemApplicationData+bytesRead maxLength:bytesToRead];
			bytesRead += len;
			bytesToRead -= len;
		} while (bytesToRead > 0);
		
		// restore
		[self restoreHoldem];
	} else if (b == kMoveOmahaApplicationData) {
		// read data into villainOmahaApplicationData
		NSInteger bytesToRead = OMAHA_APPLICATION_DATA_LENGTH * sizeof(uint8_t);
		villainOmahaApplicationData = malloc(bytesToRead);
		
		NSInteger bytesRead = 0;
		do {
			NSInteger len = [_inStream read:villainOmahaApplicationData+bytesRead maxLength:bytesToRead];
			bytesRead += len;
			bytesToRead -= len;
		} while (bytesToRead > 0);
		
		// restore
		[self restoreOmaha];		
	} else if (b == kMovePrefs) {
		// read villain's user preferences
		NSInteger bytesToRead = PREFS_LENGTH * sizeof(uint8_t);
		uint8_t* villainPrefs = malloc(bytesToRead);
		
		NSInteger bytesRead = 0;
		do {
			NSInteger len = [_inStream read:villainPrefs+bytesRead maxLength:bytesToRead];
			bytesRead += len;
			bytesToRead -= len;
		} while (bytesToRead > 0);
		
		enum GameName villainGame = villainPrefs[0];
		BOOL villainMode = (BOOL)villainPrefs[1];
		
		NSInteger villainHeroStack = [AppController read4ByteIntegerFrom:villainPrefs+2];
		
		NSInteger villainVillainStack = [AppController read4ByteIntegerFrom:villainPrefs+6];
		
		NSInteger villainSmallBlind = [AppController read2ByteIntegerFrom:villainPrefs+10];
		NSInteger villainBigBlind = [AppController read2ByteIntegerFrom:villainPrefs+12];
		
		free(villainPrefs);
		
		// compare villain's prefs with hero's prefs
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		enum GameName heroGame = [defaults integerForKey:KEY_GAME_NAME];
		BOOL heroMode = [defaults boolForKey:KEY_TOOL_MODE];
		BOOL isOmaha = (heroGame == kGameOmahaHi);
		NSInteger heroHeroStack = [defaults integerForKey: isOmaha ? KEY_PLOMAHA_HERO_STACK : KEY_NLHOLDEM_HERO_STACK];
		NSInteger heroVillainStack = [defaults integerForKey: isOmaha ? KEY_PLOMAHA_VILLAIN_STACK : KEY_NLHOLDEM_VILLAIN_STACK];
		NSInteger heroSmallBlind = [defaults integerForKey: isOmaha ? KEY_PLOMAHA_SMALL_BLIND : KEY_NLHOLDEM_SMALL_BLIND];
		NSInteger heroBigBlind = [defaults integerForKey: isOmaha ? KEY_PLOMAHA_BIG_BLIND : KEY_NLHOLDEM_BIG_BLIND];
		
		if (villainGame == heroGame &&
			villainMode == heroMode &&
			(villainMode ||
			(!villainMode &&
			villainHeroStack == heroVillainStack &&
			villainVillainStack == heroHeroStack &&
			villainSmallBlind == heroSmallBlind &&
			villainBigBlind == heroBigBlind))) {
			if (heroGame == kGameHoldem) {
				if (villainMode) {
					// tool mode
					[self presentToolModeViewAtHand:0];
				} else {
					// game mode
					[self presentHoldemGameModeViewAtHand:0 
												heroStack:heroHeroStack 
											 villainStack:heroVillainStack
											   smallBlind:heroSmallBlind
												 bigBlind:heroBigBlind
									  heroApplicationData:nil 
								   villainApplicationData:nil
												 gameMode:kDualPhoneMode];
				}
			} else {
				if (villainMode) {
					// tool mode
					[self presentOmahaToolModeViewAtHand:0];
				} else {
					// game mode
					[self presentOmahaGameModeViewAtHand:0 
												heroStack:heroHeroStack 
											 villainStack:heroVillainStack
											   smallBlind:heroSmallBlind
												 bigBlind:heroBigBlind
									  heroApplicationData:nil 
								   villainApplicationData:nil
												 gameMode:kDualPhoneMode];
				}
			}
		} else {
			[self ignoreOpponentDisconnect];
			
			NSString *differences;
			if (villainMode != heroMode) {
				differences = [NSString stringWithFormat:
				@"You: Shuffler/Dealer Mode %@\nOpponent: Shuffler/Dealer Mode %@",
							   heroMode ? @"On" : @"Off",
							   villainMode ? @"On" : @"Off"];
			} else {
				differences = [NSString stringWithFormat:@"You: %d-%d-%d-%d\nOpponent: %d-%d-%d-%d",
				heroSmallBlind, heroBigBlind, heroHeroStack, heroVillainStack,
							   villainSmallBlind, villainBigBlind, villainVillainStack, villainHeroStack];
			}
			
			UIAlertView* alertView = 
			[[UIAlertView alloc] initWithTitle:@"Change your settings" 
									   message:differences
									delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alertView show];
			[alertView release];			
		}
	} 	
}	

- (void) handleSelectModeMessageWithFirstByte:(uint8_t) b {
	SelectModeView* selectModeView = (SelectModeView*)[self.viewController view];
	[selectModeView receiveMessage:b];
}

// b is of type enum Message
- (void) handleToolModeMessageWithFirstByte:(uint8_t) b {
	HeadsupView* headsupView = (HeadsupView*)[holdemToolModeViewController view];
	HandFSM* handFSM = headsupView.handFSM;
	if (b == kMessageNewReq) {
		[handFSM input:kEventReceiveNewReq];
		
		if (handFSM.state == kStateNewReqReceived)
			[headsupView startVillainsWaiting];
		else
			[headsupView stopVillainsWaiting];
	} else if (b == kMessageNextReq) {
		[handFSM input:kEventReceiveNextReq];
		
		if (handFSM.state == kStateNextReqReceived)
			[headsupView startVillainsWaiting];
		else
			[headsupView stopVillainsWaiting];
	}else if (b == kMessageAllInReq) {
		[handFSM input:kEventReceiveAllInReq];
		
		if (handFSM.state == kStateAllInReqReceived)
			[headsupView startVillainsWaiting];
		else
			[headsupView stopVillainsWaiting];
	} else if (b == kMessageCards) {
		[handFSM input:kEventReceiveCards];
	
		// read 9 more ints
		uint8_t *message = malloc(9 * sizeof(uint8_t));
		[_inStream read:message maxLength:9 * sizeof(uint8_t)];
		
		[headsupView.deck clearArrays];
		
		for (int i=0; i < 9; i++) {
			/*int cardIndex = 0;
			if (i == 0)
				cardIndex = 1;
			else if (i == 1)
				cardIndex = 0;
			else if (i == 2)
				cardIndex = 3;
			else if (i == 3)
				cardIndex = 2;
			else
				cardIndex = i;*/
			
			int cardIndex = i;
			
			uint8_t data = message[cardIndex];
			
			NSInteger rank = (data >> 2) & 0x0f;
			NSInteger suit = (data) & 0x03;
			Card* card = [[Card alloc] initWithSuit:suit Rank:rank];
			[headsupView.deck addCard:card];
			[card release];
		}
		
		free(message);
	} 
		
	[headsupView stateChanged];
}	

// b is of type enum kMoveType
- (void) handleGameModeMessageWithFirstByte:(uint8_t) b {
	//NSLog(@"game mode: %d", b);
	GameModeView* gameModeView = (GameModeView*)[holdemGameModeViewController view];
	
	if (b == kMoveFold ||
		b == kMoveCheck ||
		b == kMoveCall ||
		b == kMoveBet ||
		b == kMoveRaise) {
		
		// kMoveBet and kMoveRaise are followed by a 4-byte  integer 
		NSInteger amount = 0;
		
		if (b == kMoveBet || b == kMoveRaise) {
			// read 4 more bytes
			NSInteger bytesToRead = 4 * sizeof(uint8_t);
			uint8_t *message = malloc(bytesToRead);
			
			NSInteger bytesRead = 0;
			do {
				NSInteger len = [_inStream read:message+bytesRead maxLength:bytesToRead];
				bytesRead += len;
				bytesToRead -= len;
			} while (bytesToRead > 0);
			
			amount = ((message[0] << 24) & 0xff000000) |
					 ((message[1] << 16) & 0x00ff0000) |
					 ((message[2] << 8)  & 0x0000ff00) |
					  (message[3]        & 0x000000ff); 
			
			free(message);
		}
		
		[gameModeView villainMadeAMove:b amount:amount];
				
	} else if (b == kMoveCards) {
		// villain just dealt the cards and started a new hand.
		
		// read 9 more ints
		NSInteger bytesToRead = 9 * sizeof(uint8_t);
		uint8_t *message = malloc(bytesToRead);
		
		NSInteger bytesRead = 0;
		do {
			NSInteger len = [_inStream read:message+bytesRead maxLength:bytesToRead];
			bytesRead += len;
			bytesToRead -= len;
		} while (bytesToRead > 0);
		
		
		[gameModeView.deck clearArrays];
		
		for (int i=0; i < 9; i++) {			
			int cardIndex = i;
			
			uint8_t data = message[cardIndex];
			
			NSInteger rank = (data >> 2) & 0x0f;
			NSInteger suit = (data) & 0x03;
			Card* card = [[Card alloc] initWithSuit:suit Rank:rank];
			[gameModeView.deck addCard:card];
			[card release];
			
			// save received card to application data
			[gameModeView saveToApplicationDataAtIndex:i card:data];
		}
		
		free(message);
				
		[gameModeView dealNewHandAsNonDealer];		
	} else if (b == kMoveEndMatch) {
		[gameModeView villainRequestedToEndMatch];
	}
}	

// b is of type enum Message
- (void) handleOmahaToolModeMessageWithFirstByte:(uint8_t) b {
	OmahaToolModeView* headsupView = (OmahaToolModeView*)[omahaToolModeViewController view];
	HandFSM* handFSM = headsupView.handFSM;
	if (b == kMessageNewReq) {
		[handFSM input:kEventReceiveNewReq];
		
		if (handFSM.state == kStateNewReqReceived)
			[headsupView startVillainsWaiting];
		else
			[headsupView stopVillainsWaiting];
	} else if (b == kMessageNextReq) {
		[handFSM input:kEventReceiveNextReq];
		
		if (handFSM.state == kStateNextReqReceived)
			[headsupView startVillainsWaiting];
		else
			[headsupView stopVillainsWaiting];
	}else if (b == kMessageAllInReq) {
		[handFSM input:kEventReceiveAllInReq];
		
		if (handFSM.state == kStateAllInReqReceived)
			[headsupView startVillainsWaiting];
		else
			[headsupView stopVillainsWaiting];
	} else if (b == kMessageCards) {
		[handFSM input:kEventReceiveCards];
		
		// read 13 more ints
		uint8_t *message = malloc(13 * sizeof(uint8_t));
		[_inStream read:message maxLength:13 * sizeof(uint8_t)];
		
		[headsupView.deck clearArrays];
		
		for (int i=0; i < 13; i++) {			
			int cardIndex = i;
			
			uint8_t data = message[cardIndex];
			
			NSInteger rank = (data >> 2) & 0x0f;
			NSInteger suit = (data) & 0x03;
			Card* card = [[Card alloc] initWithSuit:suit Rank:rank];
			[headsupView.deck addCard:card];
			[card release];
		}
		
		free(message);
	} 
	
	[headsupView stateChanged];
}	

// b is of type enum kMoveType
- (void) handleOmahaGameModeMessageWithFirstByte:(uint8_t) b {
	OmahaGameModeView* gameModeView = (OmahaGameModeView*)[omahaGameModeViewController view];
	
	if (b == kMoveFold ||
		b == kMoveCheck ||
		b == kMoveCall ||
		b == kMoveBet ||
		b == kMoveRaise) {
		
		// kMoveBet and kMoveRaise are followed by a 4-byte  integer 
		NSInteger amount = 0;
		
		if (b == kMoveBet || b == kMoveRaise) {
			// read 4 more bytes
			NSInteger bytesToRead = 4 * sizeof(uint8_t);
			uint8_t *message = malloc(bytesToRead);
			
			NSInteger bytesRead = 0;
			do {
				NSInteger len = [_inStream read:message+bytesRead maxLength:bytesToRead];
				bytesRead += len;
				bytesToRead -= len;
			} while (bytesToRead > 0);
			
			amount = ((message[0] << 24) & 0xff000000) |
			((message[1] << 16) & 0x00ff0000) |
			((message[2] << 8)  & 0x0000ff00) |
			(message[3]        & 0x000000ff); 
			
			free(message);
		}
		
		[gameModeView villainMadeAMove:b amount:amount];
		
	} else if (b == kMoveCards) {
		// villain just dealt the cards and started a new hand.
		
		// read 13 more ints
		NSInteger bytesToRead = 13 * sizeof(uint8_t);
		uint8_t *message = malloc(bytesToRead);
		
		NSInteger bytesRead = 0;
		do {
			NSInteger len = [_inStream read:message+bytesRead maxLength:bytesToRead];
			bytesRead += len;
			bytesToRead -= len;
		} while (bytesToRead > 0);
		
		
		[gameModeView.deck clearArrays];
		
		for (int i=0; i < 13; i++) {			
			int cardIndex = i;
			
			uint8_t data = message[cardIndex];
			
			NSInteger rank = (data >> 2) & 0x0f;
			NSInteger suit = (data) & 0x03;
			Card* card = [[Card alloc] initWithSuit:suit Rank:rank];
			[gameModeView.deck addCard:card];
			[card release];
			
			// save received card to application data
			[gameModeView saveToApplicationDataAtIndex:i card:data];			
		}
		
		free(message);
		
		[gameModeView dealNewHandAsNonDealer];		
	} else if (b == kMoveEndMatch) {
		[gameModeView villainRequestedToEndMatch];
	} 	
}	

// b is of type enum Message
- (void) handleStudToolModeMessageWithFirstByte:(uint8_t) b {
	StudToolModeView* headsupView = (StudToolModeView*)[self.viewController view];
	HandFSM* handFSM = headsupView.handFSM;
	if (b == kMessageNewReq) {
		[handFSM input:kEventReceiveNewReq];
		
		if (handFSM.state == kStateNewReqReceived)
			[headsupView startVillainsWaiting];
		else
			[headsupView stopVillainsWaiting];
	} else if (b == kMessageNextReq) {
		[handFSM input:kEventReceiveNextReq];
		
		if (handFSM.state == kStateNextReqReceived)
			[headsupView startVillainsWaiting];
		else
			[headsupView stopVillainsWaiting];
	}else if (b == kMessageAllInReq) {
		[handFSM input:kEventReceiveAllInReq];
		
		if (handFSM.state == kStateAllInReqReceived)
			[headsupView startVillainsWaiting];
		else
			[headsupView stopVillainsWaiting];
	} else if (b == kMessageCards) {
		[handFSM input:kEventReceiveCards];
		
		// read 14 more ints
		uint8_t *message = malloc(14 * sizeof(uint8_t));
		[_inStream read:message maxLength:14 * sizeof(uint8_t)];
		
		[headsupView.deck clearArrays];
		
		for (int i=0; i < 14; i++) {			
			int cardIndex = i;
			
			uint8_t data = message[cardIndex];
			
			NSInteger rank = (data >> 2) & 0x0f;
			NSInteger suit = (data) & 0x03;
			Card* card = [[Card alloc] initWithSuit:suit Rank:rank];
			[headsupView.deck addCard:card];
			[card release];
		}
		
		free(message);
	} 
	
	[headsupView stateChanged];
}	

// b is of type enum kMoveType
- (void) handleStudGameModeMessageWithFirstByte:(uint8_t) b {
	StudGameModeView* gameModeView = (StudGameModeView*)[self.viewController view];
	
	if (b == kMoveFold ||
		b == kMoveCheck ||
		b == kMoveCall ||
		b == kMoveBet ||
		b == kMoveRaise) {
		
		// kMoveBet and kMoveRaise are followed by a 4-byte  integer 
		NSInteger amount = 0;
		
		if (b == kMoveBet || b == kMoveRaise) {
			// read 4 more bytes
			NSInteger bytesToRead = 4 * sizeof(uint8_t);
			uint8_t *message = malloc(bytesToRead);
			
			NSInteger bytesRead = 0;
			do {
				NSInteger len = [_inStream read:message+bytesRead maxLength:bytesToRead];
				bytesRead += len;
				bytesToRead -= len;
			} while (bytesToRead > 0);
			
			amount = ((message[0] << 24) & 0xff000000) |
			((message[1] << 16) & 0x00ff0000) |
			((message[2] << 8)  & 0x0000ff00) |
			(message[3]        & 0x000000ff); 
			
			free(message);
		}
		
		[gameModeView villainMadeAMove:b amount:amount];
		
	} else if (b == kMoveCards) {
		// villain just dealt the cards and started a new hand.
		
		// read 14 more ints
		NSInteger bytesToRead = 14 * sizeof(uint8_t);
		uint8_t *message = malloc(bytesToRead);
		
		NSInteger bytesRead = 0;
		do {
			NSInteger len = [_inStream read:message+bytesRead maxLength:bytesToRead];
			bytesRead += len;
			bytesToRead -= len;
		} while (bytesToRead > 0);
		
		
		[gameModeView.deck clearArrays];
		
		for (int i=0; i < 14; i++) {			
			int cardIndex = i;
			
			uint8_t data = message[cardIndex];
			
			NSInteger rank = (data >> 2) & 0x0f;
			NSInteger suit = (data) & 0x03;
			Card* card = [[Card alloc] initWithSuit:suit Rank:rank];
			[gameModeView.deck addCard:card];
			[card release];
		}
		
		free(message);
		
		[gameModeView dealNewHandAsNonDealer];		
	} 	
}	

// b is of type enum Message
- (void) handleDrawToolModeMessageWithFirstByte:(uint8_t) b {
	DrawToolModeView* headsupView = (DrawToolModeView*)[self.viewController view];
	HandFSM* handFSM = headsupView.handFSM;
	if (b == kMessageNewReq) {
		[handFSM input:kEventReceiveNewReq];
		
		if (handFSM.state == kStateNewReqReceived)
			[headsupView startVillainsWaiting];
		else
			[headsupView stopVillainsWaiting];
	} else if (b == kMessageNextReq) {
		[handFSM input:kEventReceiveNextReq];
		
		if (handFSM.state == kStateNextReqReceived)
			[headsupView startVillainsWaiting];
		else
			[headsupView stopVillainsWaiting];
	}else if (b == kMessageAllInReq) {
		[handFSM input:kEventReceiveAllInReq];
		
		if (handFSM.state == kStateAllInReqReceived)
			[headsupView startVillainsWaiting];
		else
			[headsupView stopVillainsWaiting];
	} else if (b == kMessageCards) {
		[handFSM input:kEventReceiveCards];
		
		// read 20 more ints
		uint8_t *message = malloc(20 * sizeof(uint8_t));
		[_inStream read:message maxLength:14 * sizeof(uint8_t)];
		
		[headsupView.deck clearArrays];
		
		for (int i=0; i < 20; i++) {			
			int cardIndex = i;
			
			uint8_t data = message[cardIndex];
			
			NSInteger rank = (data >> 2) & 0x0f;
			NSInteger suit = (data) & 0x03;
			Card* card = [[Card alloc] initWithSuit:suit Rank:rank];
			[headsupView.deck addCard:card];
			[card release];
		}
		
		free(message);
	} else if (b == kMovePat) {
		[headsupView villainStoodPat];	
	} else if (b == kMoveDiscard) {
		// read 1 more byte
		NSInteger bytesToRead = 1 * sizeof(uint8_t);
		uint8_t *message = malloc(bytesToRead);
		
		NSInteger bytesRead = 0;
		do {
			NSInteger len = [_inStream read:message+bytesRead maxLength:bytesToRead];
			bytesRead += len;
			bytesToRead -= len;
		} while (bytesToRead > 0);
		
		NSInteger numDiscardedCards = message[0];
		
		free(message);
		
		[headsupView villainDiscardedCards:numDiscardedCards];
	}
	
	[headsupView stateChanged];
}	

// b is of type enum kMoveType
- (void) handleDrawGameModeMessageWithFirstByte:(uint8_t) b {
	DrawGameModeView* gameModeView = (DrawGameModeView*)[self.viewController view];
	
	if (b == kMoveFold ||
		b == kMoveCheck ||
		b == kMoveCall ||
		b == kMoveBet ||
		b == kMoveRaise) {
		
		// kMoveBet and kMoveRaise are followed by a 4-byte  integer 
		NSInteger amount = 0;
		
		if (b == kMoveBet || b == kMoveRaise) {
			// read 4 more bytes
			NSInteger bytesToRead = 4 * sizeof(uint8_t);
			uint8_t *message = malloc(bytesToRead);
			
			NSInteger bytesRead = 0;
			do {
				NSInteger len = [_inStream read:message+bytesRead maxLength:bytesToRead];
				bytesRead += len;
				bytesToRead -= len;
			} while (bytesToRead > 0);
			
			amount = ((message[0] << 24) & 0xff000000) |
			((message[1] << 16) & 0x00ff0000) |
			((message[2] << 8)  & 0x0000ff00) |
			(message[3]        & 0x000000ff); 
			
			free(message);
		}
		
		[gameModeView villainMadeAMove:b amount:amount];
		
	} else if (b == kMoveCards) {
		// villain just dealt the cards and started a new hand.
		
		// read 14 more ints
		NSInteger bytesToRead = 20 * sizeof(uint8_t);
		uint8_t *message = malloc(bytesToRead);
		
		NSInteger bytesRead = 0;
		do {
			NSInteger len = [_inStream read:message+bytesRead maxLength:bytesToRead];
			bytesRead += len;
			bytesToRead -= len;
		} while (bytesToRead > 0);
		
		
		[gameModeView.deck clearArrays];
		
		for (int i=0; i < 20; i++) {			
			int cardIndex = i;
			
			uint8_t data = message[cardIndex];
			
			NSInteger rank = (data >> 2) & 0x0f;
			NSInteger suit = (data) & 0x03;
			Card* card = [[Card alloc] initWithSuit:suit Rank:rank];
			[gameModeView.deck addCard:card];
			[card release];
		}
		
		free(message);
		
		[gameModeView dealNewHandAsNonDealer];		
	} else if (b == kMovePat) {
		[gameModeView villainMadeAMove:b amount:0];		
	} else if (b == kMoveDiscard) {
		// read 1 more byte
		NSInteger bytesToRead = 1 * sizeof(uint8_t);
		uint8_t *message = malloc(bytesToRead);
		
		NSInteger bytesRead = 0;
		do {
			NSInteger len = [_inStream read:message+bytesRead maxLength:bytesToRead];
			bytesRead += len;
			bytesToRead -= len;
		} while (bytesToRead > 0);
		
		NSInteger amount = message[0];
		
		free(message);
		
		[gameModeView villainMadeAMove:b amount:amount];
	}
}	



/*- (void) presentModeView {
	if (TOOL_MODE) {
		HeadsupView* headsupView = (HeadsupView*)[self.viewController view];
		[headsupView willDisplay];

	} else {
		GameModeView* gameModeView = (GameModeView*)[self.viewController view];
		[gameModeView willDisplay];
	}
}*/

- (void) stream:(NSStream*)stream handleEvent:(NSStreamEvent)eventCode
{	
	//NSLog(@"event code: %d", eventCode);
	UIAlertView* alertView;
	switch(eventCode) {
		case NSStreamEventErrorOccurred:
		{
			//NSLog(@"OMG error occurred!!!!!!!!");
			
			if (viewType == kViewRestoreMode && !errorOccurred) {
				errorOccurred = YES;
				alertView = [[UIAlertView alloc] initWithTitle:@"Error occurred. Please retry." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continue", nil];
				[alertView show];
				[alertView release];
			}
			
			break;
		}
			
		case NSStreamEventOpenCompleted:
		{
			//NSLog(@"open completed");
			//[self destroyPicker];
			
			[_server release];
			_server = nil;

			if (stream == _inStream) {
				_inReady = YES;
			} else {
				_outReady = YES;
			}
			
			//if (_inReady && _outReady)
				//[self destroyPicker];
			
			//if (_inReady && _outReady)
				//[self presentModeView];
			
			/*if (_inReady && _outReady) {
				alertView = [[UIAlertView alloc] initWithTitle:@"Game started!" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Continue", nil];
				[alertView show];
				[alertView release];
			}*/
			break;
		}
			
		case NSStreamEventHasSpaceAvailable:
		{
			//NSLog(@"space available");
			// The stream can accept bytes for writing.
			// sendArray must NOT be called before this.
						
			if (!isViewPresented) {
				isViewPresented = YES;
				[self destroyPicker];
			}
			break;
		}

		case NSStreamEventHasBytesAvailable:
		{
			//NSLog(@"bytes available");
			if (stream == _inStream) {
				uint8_t b;
				unsigned int len = 0;
				len = [_inStream read:&b maxLength:sizeof(uint8_t)];
				if(!len) {
					if ([stream streamStatus] != NSStreamStatusAtEnd)
						[self _showAlert:@"Data transmission from opponent failed"];
				} else {
					//SelectModeView* selectModeView = (SelectModeView*)[self.viewController view];
					//NSLog(@"recv %x", selectModeView.dealer);
					//selectModeView.dealer = YES;
					
					// received a remote message.
					if (viewType == kViewRestoreMode)
						[self handleRestoreModeMessageWithFirstByte:b];
					else if (viewType == kViewSelectMode)
						[self handleSelectModeMessageWithFirstByte:b];
					else if (viewType == kViewToolMode)
						[self handleToolModeMessageWithFirstByte:b];
					else if (viewType == kViewGameMode)
						[self handleGameModeMessageWithFirstByte:b];
					else if (viewType == kViewOmahaToolMode)
						[self handleOmahaToolModeMessageWithFirstByte:b];
					else if (viewType == kViewOmahaGameMode)
						[self handleOmahaGameModeMessageWithFirstByte:b];
					else if (viewType == kViewStudToolMode)
						[self handleStudToolModeMessageWithFirstByte:b];
					else if (viewType == kViewStudGameMode)
						[self handleStudGameModeMessageWithFirstByte:b];					
					else if (viewType == kViewDrawToolMode)
						[self handleDrawToolModeMessageWithFirstByte:b];
					else if (viewType == kViewDrawGameMode)
						[self handleDrawGameModeMessageWithFirstByte:b];					
				}
			}
			break;
		}
		case NSStreamEventEndEncountered:
		{
				
			if (!ignoreOpponentDisconnect) {
				alertView = [[UIAlertView alloc] initWithTitle:@"Opponent Disconnected" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continue", nil];
				[alertView show];
				[alertView release];
			}

			break;
		}
	}
}

//@end

//@implementation AppController (TCPServerDelegate)

- (void) serverDidEnableBonjour:(TCPServer*)server withName:(NSString*)string
{
	// set self as non-dealer so when user enters single player mode and there's no
	// saved game, hero will always be the dealer.
	[self setSelfAsNonDealer];
	
	// save application data
	[self saveApplicationData];
	
	// kill all-in timer
	//if (BUILD == HU_HOLDEM || BUILD == HU_HOLDEM_FREE) {
		if (holdemGameModeViewController != nil) {
			GameModeView *holdemGameModeView = (GameModeView*)[holdemGameModeViewController view];
			[holdemGameModeView killAllActiveTimers];
			[holdemGameModeView resetStuff];
		}
	//}
	
	//if (BUILD == HU_OMAHA || BUILD == HU_OMAHA_FREE) {
		if (omahaGameModeViewController != nil) {
			OmahaGameModeView *omahaGameModeView = (OmahaGameModeView*)[omahaGameModeViewController view];
			[omahaGameModeView killAllActiveTimers];
			[omahaGameModeView resetStuff];
		}
	//}	
	
	[self presentPicker:string];
}

- (void)didAcceptConnectionForServer:(TCPServer*)server inputStream:(NSInputStream *)istr outputStream:(NSOutputStream *)ostr
{
	[self setSelfAsNonDealer];
	
	if (_inStream || _outStream || server != _server)
		return;
	
	[_server release];
	_server = nil;
	
	_inStream = istr;
	[_inStream retain];
	_outStream = ostr;
	[_outStream retain];
	
	[self openStreams];
}

#pragma mark GKPeerPickerControllerDelegate Methods
- (void)invalidateSession:(GKSession *)session {
	if(session != nil) {
		[session disconnectFromAllPeers]; 
		session.available = NO; 
		[session setDataReceiveHandler: nil withContext: NULL]; 
		session.delegate = nil; 
	}
}

- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker { 
	// Peer Picker automatically dismisses on user cancel. No need to programmatically dismiss.
    
	// autorelease the picker. 
	picker.delegate = nil;
    //[picker autorelease]; 
	
	// invalidate and release game session if one is around.
	if(self.gameSession != nil)	{
		[self invalidateSession:self.gameSession];
		self.gameSession = nil;
	}
	
} 

/*
 *	Note: No need to implement -peerPickerController:didSelectConnectionType: delegate method since this app does not support multiple connection types.
 *		- see reference documentation for this delegate method and the GKPeerPickerController's connectionTypesMask property.
 */

- (void)peerPickerController:(GKPeerPickerController *)picker 
	 didSelectConnectionType:(GKPeerPickerConnectionType)type { 
    if (type == GKPeerPickerConnectionTypeOnline) { 
        picker.delegate = nil; 
        [picker dismiss]; 
        //[picker autorelease]; 
		// Implement your own internet user interface here. 
    } 
} 


//
// Provide a custom session that has a custom session ID. This is also an opportunity to provide a session with a custom display name.
//
- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type { 
	GKSession *session = [[GKSession alloc] initWithSessionID:kHeadsupPoker3GSessionID displayName:nil sessionMode:GKSessionModePeer]; 
	return [session autorelease]; // peer picker retains a reference, so autorelease ours so we don't leak.
}

- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session { 
	// set connection type to bluetooth
	connectionType = kConnectionBluetooth;
	
	// Remember the current peer.
	self.gamePeerId = peerID;  // copy
	
	// Make sure we have a reference to the game session and it is set up
	self.gameSession = session; // retain
	self.gameSession.delegate = self; 
	[self.gameSession setDataReceiveHandler:self withContext:NULL];
	
	// Done with the Peer Picker so dismiss it.
	[picker dismiss];
	picker.delegate = nil;
	//[picker autorelease];
	
    // the following line has been moved to didChangeState:
    // when sendHeroDeviceId is called here, sometimes the match doesn't start, probably
    // because the receiver wasn't ready.
	//[self sendHeroDeviceId];
} 

// b is of type enum kMoveType
// kMoveDeviceId -> kMoveHoldemApplicationData -> restore application data if at least one of
// them has an applicationData[0] that's not 0; if both applicationData[0] are 0 -> kMovePrefs
// to start a new game.
- (void) handleRestoreModeMessage:(NSData*)data {
	uint8_t* messageBytes = (uint8_t*)[data bytes];
	uint8_t b = messageBytes[0];
	if (b == kMoveDeviceId) {
		isViewPresented = YES;
		
		uint8_t deviceIdByteLength = messageBytes[1];
		
		uint8_t *deviceIdBytes = malloc(deviceIdByteLength);
		memcpy(deviceIdBytes, &messageBytes[2], deviceIdByteLength);
		
		myVillainDeviceId = [[NSString alloc] initWithBytes:deviceIdBytes length:deviceIdByteLength encoding:NSASCIIStringEncoding];
		free(deviceIdBytes);
		
		// villain's game
		enum GameName villainGame = messageBytes[2+deviceIdByteLength];
		// hero's game
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		enum GameName heroGame = [defaults integerForKey:KEY_GAME_NAME];
		
		// both holde'm: restore hold'em or start a new hold'em game
		// both omaha: restore omaha or start a new omaha game
		// one hold'em one omaha: prompt the user
		if (heroGame != villainGame) {
			NSString* differences = 
			[NSString stringWithFormat:@"You: %@\nOpponent: %@", 
			 heroGame == kGameHoldem ? @"No Limit Texas Hold'em" : @"Pot Limit Omaha",
			 villainGame == kGameHoldem ? @"No Limit Texas Hold'em" : @"Pot Limit Omaha"];
			
			UIAlertView* alertView = 
			[[UIAlertView alloc] initWithTitle:@"Change your settings" 
									   message:differences
									  delegate:[[UIApplication sharedApplication] delegate] cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alertView show];
			[alertView release];			
		} else {
			//heroGame == villainGame
			if (heroGame == kGameHoldem) {
				// read hero application data from file
				NSString *fileName =[self holdemFileName:myVillainDeviceId 
										gameCenterIdPair:nil
												gameMode:kDualPhoneMode];
				NSData *fileData = [self readApplicationDataFromFile:fileName];
				heroHoldemApplicationData = malloc(HOLDEM_APPLICATION_DATA_LENGTH * sizeof(uint8_t));
				
				if (fileData == nil)
					heroHoldemApplicationData[0] = (uint8_t)0;
				else
					[fileData getBytes:heroHoldemApplicationData];
				
				// this is rather tricky. we may receive this message when we are not yet allowed to send.
				// if that's the case, we must postpone sending till we get the green light.
				if (isViewPresented && !isHeroApplicationDataSent)
					[self sendHeroApplicationData];							
			} else { // heroGame == kGameOmaha
				// read hero application data from file
				NSString *fileName =[self omahaFileName:myVillainDeviceId gameMode:kDualPhoneMode];
				NSData *data = [self readApplicationDataFromFile:fileName];
				heroOmahaApplicationData = malloc(OMAHA_APPLICATION_DATA_LENGTH * sizeof(uint8_t));
				
				if (data == nil)
					heroOmahaApplicationData[0] = (uint8_t)0;
				else
					[data getBytes:heroOmahaApplicationData];
				
				// this is rather tricky. we may receive this message when we are not yet allowed to send.
				// if that's the case, we must postpone sending till we get the green light.
				if (isViewPresented && !isHeroApplicationDataSent)
					[self sendHeroOmahaApplicationData];								
			}
		}
		
	} else if (b == kMoveHoldemApplicationData) {
		// read data into villainHoldemApplicationData
		NSInteger bytesToRead = HOLDEM_APPLICATION_DATA_LENGTH * sizeof(uint8_t);
		villainHoldemApplicationData = malloc(bytesToRead);
		memcpy(villainHoldemApplicationData, &messageBytes[1], bytesToRead);
		
		// restore
		[self restoreHoldem];
	} else if (b == kMoveOmahaApplicationData) {
		// read data into villainOmahaApplicationData
		NSInteger bytesToRead = OMAHA_APPLICATION_DATA_LENGTH * sizeof(uint8_t);
		villainOmahaApplicationData = malloc(bytesToRead);
		memcpy(villainOmahaApplicationData, &messageBytes[1], bytesToRead);
		
		// restore
		[self restoreOmaha];		
	} else if (b == kMovePrefs) {
		// read villain's user preferences
		NSInteger bytesToRead = PREFS_LENGTH * sizeof(uint8_t);
		uint8_t* villainPrefs = malloc(bytesToRead);
		
		memcpy(villainPrefs, &messageBytes[1], bytesToRead);
		
		enum GameName villainGame = villainPrefs[0];
		BOOL villainMode = (BOOL)villainPrefs[1];
		
		NSInteger villainHeroStack = [AppController read4ByteIntegerFrom:villainPrefs+2];
		
		NSInteger villainVillainStack = [AppController read4ByteIntegerFrom:villainPrefs+6];
		
		NSInteger villainSmallBlind = [AppController read2ByteIntegerFrom:villainPrefs+10];
		NSInteger villainBigBlind = [AppController read2ByteIntegerFrom:villainPrefs+12];
		
		free(villainPrefs);
		
		// compare villain's prefs with hero's prefs
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		enum GameName heroGame = [defaults integerForKey:KEY_GAME_NAME];
		BOOL heroMode = [defaults boolForKey:KEY_TOOL_MODE];
		BOOL isOmaha = (heroGame == kGameOmahaHi);
		NSInteger heroHeroStack = [defaults integerForKey: isOmaha ? KEY_PLOMAHA_HERO_STACK : KEY_NLHOLDEM_HERO_STACK];
		NSInteger heroVillainStack = [defaults integerForKey: isOmaha ? KEY_PLOMAHA_VILLAIN_STACK : KEY_NLHOLDEM_VILLAIN_STACK];
		NSInteger heroSmallBlind = [defaults integerForKey: isOmaha ? KEY_PLOMAHA_SMALL_BLIND : KEY_NLHOLDEM_SMALL_BLIND];
		NSInteger heroBigBlind = [defaults integerForKey: isOmaha ? KEY_PLOMAHA_BIG_BLIND : KEY_NLHOLDEM_BIG_BLIND];
		
		if (villainGame == heroGame &&
			villainMode == heroMode &&
			(villainMode ||
			 (!villainMode &&
			 villainHeroStack == heroVillainStack &&
			 villainVillainStack == heroHeroStack &&
			 villainSmallBlind == heroSmallBlind &&
			 villainBigBlind == heroBigBlind))) {
				if (heroGame == kGameHoldem) {
					if (villainMode) {
						// tool mode
						[self presentToolModeViewAtHand:0];
					} else {
						// game mode
						[self presentHoldemGameModeViewAtHand:0 
													heroStack:heroHeroStack 
												 villainStack:heroVillainStack
												   smallBlind:heroSmallBlind
													 bigBlind:heroBigBlind
										  heroApplicationData:nil 
									   villainApplicationData:nil
													 gameMode:kDualPhoneMode];
					}
				} else {
					if (villainMode) {
						// tool mode
						[self presentOmahaToolModeViewAtHand:0];
					} else {
						// game mode
						[self presentOmahaGameModeViewAtHand:0 
												   heroStack:heroHeroStack 
												villainStack:heroVillainStack
												  smallBlind:heroSmallBlind
													bigBlind:heroBigBlind
										 heroApplicationData:nil 
									  villainApplicationData:nil
													gameMode:kDualPhoneMode];	
					}
				}
				
			} else {
				[(AppController*)[[UIApplication sharedApplication] delegate] ignoreOpponentDisconnect];
				
				NSString *differences;
				if (villainMode != heroMode) {
					differences = [NSString stringWithFormat:
								   @"You: Shuffler/Dealer Mode %@\nOpponent: Shuffler/Dealer Mode %@",
								   heroMode ? @"On" : @"Off",
								   villainMode ? @"On" : @"Off"];
				} else {
					differences = [NSString stringWithFormat:@"You: %d-%d-%d-%d\nOpponent: %d-%d-%d-%d",
								   heroSmallBlind, heroBigBlind, heroHeroStack, heroVillainStack,
								   villainSmallBlind, villainBigBlind, villainVillainStack, villainHeroStack];
				}
				
				UIAlertView* alertView = 
				[[UIAlertView alloc] initWithTitle:@"Change your settings" 
										   message:differences
										  delegate:[[UIApplication sharedApplication] delegate] cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[alertView show];
				[alertView release];			
			}
	} 	
}	

// b is of type enum Message
- (void) handleToolModeMessage:(NSData*) data {
	uint8_t* messageBytes = (uint8_t*)[data bytes];
	uint8_t b = messageBytes[0];
	
	HeadsupView* headsupView = (HeadsupView*)[holdemToolModeViewController view];
	HandFSM* handFSM = headsupView.handFSM;
	if (b == kMessageNewReq) {
		[handFSM input:kEventReceiveNewReq];
		
		if (handFSM.state == kStateNewReqReceived)
			[headsupView startVillainsWaiting];
		else
			[headsupView stopVillainsWaiting];
	} else if (b == kMessageNextReq) {
		[handFSM input:kEventReceiveNextReq];
		
		if (handFSM.state == kStateNextReqReceived)
			[headsupView startVillainsWaiting];
		else
			[headsupView stopVillainsWaiting];
	}else if (b == kMessageAllInReq) {
		[handFSM input:kEventReceiveAllInReq];
		
		if (handFSM.state == kStateAllInReqReceived)
			[headsupView startVillainsWaiting];
		else
			[headsupView stopVillainsWaiting];
	} else if (b == kMessageCards) {
		[handFSM input:kEventReceiveCards];
		
		// read 9 more ints
		NSInteger bytesToRead = 9 * sizeof(uint8_t);
		uint8_t *message = malloc(bytesToRead);
		memcpy(message, &messageBytes[1], bytesToRead);		
		
		[headsupView.deck clearArrays];
		
		for (int i=0; i < 9; i++) {			
			int cardIndex = i;
			
			uint8_t data = message[cardIndex];
			
			NSInteger rank = (data >> 2) & 0x0f;
			NSInteger suit = (data) & 0x03;
			Card* card = [[Card alloc] initWithSuit:suit Rank:rank];
			[headsupView.deck addCard:card];
			[card release];
		}
		
		free(message);
	} 
	
	[headsupView stateChanged];
}	

// b is of type enum kMoveType
- (void) handleGameModeMessage:(NSData*)data {
	uint8_t* messageBytes = (uint8_t*)[data bytes];
	uint8_t b = messageBytes[0];
	
	GameModeView* gameModeView = (GameModeView*)[holdemGameModeViewController view];
	
	if (b == kMoveFold ||
		b == kMoveCheck ||
		b == kMoveCall ||
		b == kMoveBet ||
		b == kMoveRaise) {
		
		// kMoveBet and kMoveRaise are followed by a 4-byte  integer 
		NSInteger amount = 0;
		
		if (b == kMoveBet || b == kMoveRaise) {
			// read 4 more bytes
			NSInteger bytesToRead = 4 * sizeof(uint8_t);
			uint8_t *message = malloc(bytesToRead);
			
			memcpy(message, &messageBytes[1], bytesToRead);
			
			amount = ((message[0] << 24) & 0xff000000) |
			((message[1] << 16) & 0x00ff0000) |
			((message[2] << 8)  & 0x0000ff00) |
			(message[3]        & 0x000000ff); 
			
			free(message);
		}
		
		[gameModeView villainMadeAMove:b amount:amount];
		
	} else if (b == kMoveCards) {
		// villain just dealt the cards and started a new hand.
		
		// read 9 more ints
		NSInteger bytesToRead = 9 * sizeof(uint8_t);
		uint8_t *message = malloc(bytesToRead);
		
		memcpy(message, &messageBytes[1], bytesToRead);		
		
		[gameModeView.deck clearArrays];
		
		for (int i=0; i < 9; i++) {			
			int cardIndex = i;
			
			uint8_t data = message[cardIndex];
			
			NSInteger rank = (data >> 2) & 0x0f;
			NSInteger suit = (data) & 0x03;
			Card* card = [[Card alloc] initWithSuit:suit Rank:rank];
			[gameModeView.deck addCard:card];
			[card release];
			
			// save received card to application data
			[gameModeView saveToApplicationDataAtIndex:i card:data];
		}
		
		free(message);
		
		[gameModeView dealNewHandAsNonDealer];		
	} else if (b == kMoveEndMatch) {
		[gameModeView villainRequestedToEndMatch];
	}
}	

// b is of type enum Message
- (void) handleOmahaToolModeMessage:(NSData*) data {
	uint8_t* messageBytes = (uint8_t*)[data bytes];
	uint8_t b = messageBytes[0];
	
	OmahaToolModeView* headsupView = (OmahaToolModeView*)[omahaToolModeViewController view];
	HandFSM* handFSM = headsupView.handFSM;
	if (b == kMessageNewReq) {
		[handFSM input:kEventReceiveNewReq];
		
		if (handFSM.state == kStateNewReqReceived)
			[headsupView startVillainsWaiting];
		else
			[headsupView stopVillainsWaiting];
	} else if (b == kMessageNextReq) {
		[handFSM input:kEventReceiveNextReq];
		
		if (handFSM.state == kStateNextReqReceived)
			[headsupView startVillainsWaiting];
		else
			[headsupView stopVillainsWaiting];
	}else if (b == kMessageAllInReq) {
		[handFSM input:kEventReceiveAllInReq];
		
		if (handFSM.state == kStateAllInReqReceived)
			[headsupView startVillainsWaiting];
		else
			[headsupView stopVillainsWaiting];
	} else if (b == kMessageCards) {
		[handFSM input:kEventReceiveCards];
		
		// read 13 more ints
		NSInteger bytesToRead = 13 * sizeof(uint8_t);
		uint8_t *message = malloc(bytesToRead);
		memcpy(message, &messageBytes[1], bytesToRead);		
		
		[headsupView.deck clearArrays];
		
		for (int i=0; i < 13; i++) {			
			int cardIndex = i;
			
			uint8_t data = message[cardIndex];
			
			NSInteger rank = (data >> 2) & 0x0f;
			NSInteger suit = (data) & 0x03;
			Card* card = [[Card alloc] initWithSuit:suit Rank:rank];
			[headsupView.deck addCard:card];
			[card release];
		}
		
		free(message);
	} 
	
	[headsupView stateChanged];
}	

// b is of type enum kMoveType
- (void) handleOmahaGameModeMessage:(NSData*)data {
	uint8_t* messageBytes = (uint8_t*)[data bytes];
	uint8_t b = messageBytes[0];
	
	OmahaGameModeView* gameModeView = (OmahaGameModeView*)[omahaGameModeViewController view];
	
	if (b == kMoveFold ||
		b == kMoveCheck ||
		b == kMoveCall ||
		b == kMoveBet ||
		b == kMoveRaise) {
		
		// kMoveBet and kMoveRaise are followed by a 4-byte  integer 
		NSInteger amount = 0;
		
		if (b == kMoveBet || b == kMoveRaise) {
			// read 4 more bytes
			NSInteger bytesToRead = 4 * sizeof(uint8_t);
			uint8_t *message = malloc(bytesToRead);
			
			memcpy(message, &messageBytes[1], bytesToRead);
			
			amount = ((message[0] << 24) & 0xff000000) |
			((message[1] << 16) & 0x00ff0000) |
			((message[2] << 8)  & 0x0000ff00) |
			(message[3]        & 0x000000ff); 
			
			free(message);
		}
		
		[gameModeView villainMadeAMove:b amount:amount];
		
	} else if (b == kMoveCards) {
		// villain just dealt the cards and started a new hand.
		
		// read 13 more ints
		NSInteger bytesToRead = 13 * sizeof(uint8_t);
		uint8_t *message = malloc(bytesToRead);
		
		memcpy(message, &messageBytes[1], bytesToRead);		
		
		[gameModeView.deck clearArrays];
		
		for (int i=0; i < 13; i++) {			
			int cardIndex = i;
			
			uint8_t data = message[cardIndex];
			
			NSInteger rank = (data >> 2) & 0x0f;
			NSInteger suit = (data) & 0x03;
			Card* card = [[Card alloc] initWithSuit:suit Rank:rank];
			[gameModeView.deck addCard:card];
			[card release];
			
			// save received card to application data
			[gameModeView saveToApplicationDataAtIndex:i card:data];
		}
		
		free(message);
		
		[gameModeView dealNewHandAsNonDealer];		
	} else if (b == kMoveEndMatch) {
		[gameModeView villainRequestedToEndMatch];
	}
}	


/*
 * Getting a data packet. This is the data receive handler method expected by the GKSession. 
 * We set ourselves as the receive data handler in the -peerPickerController:didConnectPeer:toSession: method.
 */
- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context { 
	if (viewType == kViewRestoreMode)
		[self handleRestoreModeMessage:data];
	else if (viewType == kViewToolMode)
		[self handleToolModeMessage:data];
	else if (viewType == kViewGameMode)
		[self handleGameModeMessage:data];	
	else if (viewType == kViewOmahaToolMode)
		[self handleOmahaToolModeMessage:data];
	else if (viewType == kViewOmahaGameMode)
		[self handleOmahaGameModeMessage:data];		
}

#pragma mark GKSessionDelegate Methods

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state { 
    if (state == GKPeerStateConnected) {
        [self sendHeroDeviceId];
	} else if (state == GKPeerStateDisconnected) {
		// We've been disconnected from the other peer.
		
		if (viewType == kViewRestoreMode)
			return;
		
		[gameSession disconnectFromAllPeers];
		[gameSession release];
		gameSession = nil;
		
		// Update user alert or throw alert if it isn't already up
		if (![self isOpponentDisconnectIgnored]) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Opponent Disconnected" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
	}	
} 

//@end

//@implementation AppController (GKMatchDelegate)

#pragma mark GKMatchDelegate Methods

- (void)enableVoiceChat:(BOOL)enable {
    
	//??
	//BOOL aa = [GKVoiceChat isVoIPAllowed];
	
	NSLog(@"enable=%@", enable ? @"YES" : @"NO");
	
    if (enable) {
        if (voiceChat == nil) {
			//??
            voiceChat = [gameMatch voiceChatWithName:@"headsup"];
        }
        
        [voiceChat start];
    }
    else {
        [voiceChat stop];
    }
	voiceChat.active = enable;
	
	
	
	
	voiceChat.playerStateUpdateHandler = ^(NSString *playerID, GKVoiceChatPlayerState state)
	{
		switch(state)
		{
			case     GKVoiceChatPlayerConnected:
				NSLog(@"startVoiceChat: GKVoiceChatPlayerConnected");
				break;
				
			case     GKVoiceChatPlayerDisconnected:
				NSLog(@"startVoiceChat: GKVoiceChatPlayerDisconnected");
				break;
				
			case     GKVoiceChatPlayerSpeaking:
				NSLog(@"startVoiceChat: GKVoiceChatPlayerSpeaking");
				break;
				
			case     GKVoiceChatPlayerSilent:
				NSLog(@"startVoiceChat: GKVoiceChatPlayerSilent");
				break;
		}
	};
	
	
}

- (void) handleGameCenterRestoreModeMessage:(NSData*)data {
	uint8_t* messageBytes = (uint8_t*)[data bytes];
	// the first byte is reserved for future use.
	// in the current implementation, this message always contains
	// the villain's application data file.
	//uint8_t b = messageBytes[0];
	
	// read data into villainHoldemApplicationData
	NSInteger bytesToRead = HOLDEM_APPLICATION_DATA_LENGTH * sizeof(uint8_t);
	villainHoldemApplicationData = malloc(bytesToRead);
	memcpy(villainHoldemApplicationData, &messageBytes[1], bytesToRead);
	
	// restore
	[self restoreGameCenterHoldem];
}	

// Game Center delegate method. Notice that hand shake is handled separately from Bluetooth
// code while in-match messages are handled by the same methods as Bluetooth mode.
- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {		  
	if (viewType == kViewRestoreMode)
		[self handleGameCenterRestoreModeMessage:data];
	else if (viewType == kViewGameMode)
		[self handleGameModeMessage:data];
	else if (viewType == kViewOmahaGameMode)
		[self handleOmahaGameModeMessage:data];
}

- (void)match:(GKMatch *)match player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state {	
    switch (state) {
        case GKPlayerStateConnected:
			remotePlayerId = playerID;			
			[GKPlayer loadPlayersForIdentifiers:[NSArray arrayWithObject:playerID] 
						  withCompletionHandler:^(NSArray *players, NSError *error) {
							  if (error) {
								  NSLog(@"load player info error");
							  } else {
								  [[NSUserDefaults standardUserDefaults] 
								   setObject:((GKPlayer*)[players objectAtIndex:0]).alias 
								   forKey:KEY_VILLAIN_NAME];
								  
								  GameModeView* gameModeView = (GameModeView*)[holdemGameModeViewController view];
								  [gameModeView updateHeroAndVillainNames];
							  }
							  
							  //[self enableVoiceChat:YES];
							  
							  [self startRestoringGame];							  
						  }];
			
            break;
        case GKPlayerStateDisconnected:
            //[self showDisconnected:playerID];
			
			if (gameMatch) {
				[gameMatch disconnect];
				gameMatch = nil;
			}
			
			[self showDisconnected];
            break;
        default:
            break;
    }
}

- (void)match:(GKMatch *)match connectionWithPlayerFailed:(NSString *)playerID withError:(NSError *)error {
	NSLog(@"connection failed");
}

- (void)match:(GKMatch *)match didFailWithError:(NSError *)error {
	NSLog(@"did fail");
}

- (void) createGameCenterMatch:(GKMatch*)match gameName:(enum GameName)startGameName {
	connectionType = kConnectionGameCenter;
	
	gameName = startGameName;
	self.gameMatch = match;
	self.gameMatch.delegate = self;	
	
	if (gameName == kGameHoldem) {
		[self presentHoldemGameCenterModeView:match];
	} else {
		[self presentOmahaGameCenterModeView];
	}	
}

@end