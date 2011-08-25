//
//  HelpHoldemView.m
//  Headsup
//
//  Created by Haolan Qin on 6/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"

#ifdef HU_3G

#import "Poker3GView.h"
#import "HeadsupView.h"
#import "GameModeView.h"
#import "OmahaToolModeView.h"
#import "OmahaGameModeView.h"
#import "HandFSM.h"
#import "Card.h"
#import "Deck.h"


@implementation Poker3GView

@synthesize settingsLabel;
@synthesize gameSession;
@synthesize gamePeerId;

+ (UIButton *)buttonWithTitle:	(NSString *)title
					   target:(id)target
					 selector:(SEL)selector
						frame:(CGRect)frame
						image:(UIImage *)image
				 imagePressed:(UIImage *)imagePressed
				darkTextColor:(BOOL)darkTextColor
{	
	UIButton *button = [[UIButton alloc] initWithFrame:frame];
	// or you can do this:
	//		UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	//		button.frame = frame;
	
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	[button setTitle:title forState:UIControlStateNormal];	
	if (darkTextColor)
	{
		[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	}
	else
	{
		[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	}
	
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newImage forState:UIControlStateNormal];
	
	UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
	
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	
    // in case the parent view draws with a custom color or gradient, use a transparent color
	button.backgroundColor = [UIColor clearColor];
	
	return button;
}

- (void)createGrayButton
{	
	// create the UIButtons with various background images
	// white button:
	UIImage *buttonBackground = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *buttonBackgroundPressed = [UIImage imageNamed:@"blueButton.png"];
	
	CGRect frame = CGRectMake(20.0, 60.0, 134, 37);
	
	UIButton* grayButton = [Poker3GView buttonWithTitle:@"Gray"
												 target:self
											   selector:@selector(action:)
												  frame:frame
												  image:buttonBackground
										   imagePressed:buttonBackgroundPressed
										  darkTextColor:YES];
	
	[self addSubview:grayButton];
}

- (void) setUpStuff {
	//[self createGrayButton];	
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


- (void)dealloc {
    [super dealloc];
}

-(void)startPicker {
	GKPeerPickerController*		picker;
		
	picker = [[GKPeerPickerController alloc] init]; // note: picker is released in various picker delegate methods when picker use is done.
	picker.delegate = self;
	//picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby | 
	//GKPeerPickerConnectionTypeOnline; 
	[picker show]; // show the Peer Picker
}

- (NSInteger) read2ByteIntegerFrom:(uint8_t*)buf {
	NSInteger twoByteInteger =
	((buf[0] << 8)  & 0xff00) |
	(buf[1]        & 0x00ff); 
	
	return twoByteInteger;
}	

- (NSInteger) read4ByteIntegerFrom:(uint8_t*)buf {
	NSInteger fourByteInteger =
	((buf[0] << 24) & 0xff000000) |
	((buf[1] << 16) & 0x00ff0000) |
	((buf[2] << 8)  & 0x0000ff00) |
	(buf[3]        & 0x000000ff); 
	
	return fourByteInteger;
}	

- (void) write2ByteInteger:(NSInteger)twoByteInteger To:(uint8_t*)buf {
	buf[0] = (uint8_t)((twoByteInteger >> 8) & 0xff);
	buf[1] = (uint8_t)( twoByteInteger       & 0xff);
}	

- (void) write4ByteInteger:(NSInteger)fourByteInteger To:(uint8_t*)buf {
	buf[0] = (uint8_t)((fourByteInteger >> 24) & 0xff);
	buf[1] = (uint8_t)((fourByteInteger >> 16) & 0xff);
	buf[2] = (uint8_t)((fourByteInteger >> 8) & 0xff);
	buf[3] = (uint8_t)( fourByteInteger       & 0xff);
}	

- (void) send:(uint8_t)message {
	uint8_t *array = malloc(1);
	array[0] = message;
	NSData *packet = [NSData dataWithBytes: array length: 1];
	free(array);
	
	[self.gameSession sendData:packet 
	 toPeers:[NSArray arrayWithObject:self.gamePeerId] 
	 withDataMode:GKSendDataReliable 
	 error:nil];	
}

- (void) sendArray:(uint8_t[])message size:(uint8_t)size {
	NSData *packet = [NSData dataWithBytes: message length: size];

	[self.gameSession sendData:packet 
						toPeers:[NSArray arrayWithObject:self.gamePeerId] 
					withDataMode:GKSendDataReliable 
							error:nil];
}

// if A joins B then B is the dealer for the first hand. for tool mode, B's dealer flag will
// be set to NO while A's dealer flag will be set to YES.
- (void) presentToolModeViewAtHand:(NSInteger)handCount {
	viewType = kViewToolMode;
	
	if (holdemToolModeViewController == nil)
		holdemToolModeViewController = 
		[[MyViewController alloc] initWithNibName:
		 BUILD == HU_FREE ? @"HeadsupAdView" : @"HeadsupView" 
										   bundle:[NSBundle mainBundle]];
	
	viewController = holdemToolModeViewController;
		
	// Add the view controller's view as a subview of the window
	UIView *controllersView = [viewController view];
	[(AppController*)[[UIApplication sharedApplication] delegate] flipView:controllersView];

	
	HeadsupView* headsupView = (HeadsupView*)[viewController view];
	NSString *heroDeviceId = [[UIDevice currentDevice] uniqueIdentifier];	
	headsupView.dealer = !([heroDeviceId compare:myVillainDeviceId] == NSOrderedAscending);
	
	[headsupView willDisplayAtHand:handCount];	
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
		 BUILD == HU_FREE ? @"GameModeAdView" : @"GameModeView" 
										   bundle:[NSBundle mainBundle]];
		
		[(AppController*)[[UIApplication sharedApplication] delegate] 
		 setGameModeViewController:holdemGameModeViewController];
	}
	
	viewController = holdemGameModeViewController;
		
	UIView *controllersView = [viewController view];	
	[(AppController*)[[UIApplication sharedApplication] delegate] flipView:controllersView];
	
	GameModeView* gameModeView = (GameModeView*)[viewController view];
	NSString *heroDeviceId = [[UIDevice currentDevice] uniqueIdentifier];

	gameModeView.dealer = ([heroDeviceId compare:myVillainDeviceId] == NSOrderedAscending);
	
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
			[self write4ByteInteger:[defaults integerForKey:KEY_NLHOLDEM_HERO_STACK] To:message+3];
			[self write4ByteInteger:[defaults integerForKey:KEY_NLHOLDEM_VILLAIN_STACK] To:message+7];
			// sb and bb
			[self write2ByteInteger:[defaults integerForKey:KEY_NLHOLDEM_SMALL_BLIND] To:message+11];
			[self write2ByteInteger:[defaults integerForKey:KEY_NLHOLDEM_BIG_BLIND] To:message+13];
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


// if A joins B then B is the dealer for the first hand. for tool mode, B's dealer flag will
// be set to NO while A's dealer flag will be set to YES.
- (void) presentOmahaToolModeViewAtHand:(NSInteger)handCount {
	viewType = kViewOmahaToolMode;
	
	if (omahaToolModeViewController == nil)
		omahaToolModeViewController = 
		[[MyViewController alloc] initWithNibName:
		 BUILD == HU_FREE ? @"OmahaToolModeAdView" : @"OmahaToolModeView" 
										   bundle:[NSBundle mainBundle]];
	
	viewController = omahaToolModeViewController;
	
	// Add the view controller's view as a subview of the window
	UIView *controllersView = [viewController view];
	[(AppController*)[[UIApplication sharedApplication] delegate] flipView:controllersView];
	
	
	OmahaToolModeView* headsupView = (OmahaToolModeView*)[viewController view];
	NSString *heroDeviceId = [[UIDevice currentDevice] uniqueIdentifier];	
	headsupView.dealer = !([heroDeviceId compare:myVillainDeviceId] == NSOrderedAscending);
	
	[headsupView willDisplayAtHand:handCount];	
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
		omahaGameModeViewController = 
		[[MyViewController alloc] initWithNibName:
		 BUILD == HU_FREE ? @"OmahaGameModeAdView" : @"OmahaGameModeView" 
										   bundle:[NSBundle mainBundle]];
		
		[(AppController*)[[UIApplication sharedApplication] delegate] 
		 setOmahaGameModeViewController:omahaGameModeViewController];
	}
	
	viewController = omahaGameModeViewController;
	
	UIView *controllersView = [viewController view];	
	[(AppController*)[[UIApplication sharedApplication] delegate] flipView:controllersView];
	
	OmahaGameModeView* gameModeView = (OmahaGameModeView*)[viewController view];
	NSString *heroDeviceId = [[UIDevice currentDevice] uniqueIdentifier];
	
	gameModeView.dealer = ([heroDeviceId compare:myVillainDeviceId] == NSOrderedAscending);
	
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
			[self write4ByteInteger:[defaults integerForKey:KEY_PLOMAHA_HERO_STACK] To:message+3];
			[self write4ByteInteger:[defaults integerForKey:KEY_PLOMAHA_VILLAIN_STACK] To:message+7];
			// sb and bb
			[self write2ByteInteger:[defaults integerForKey:KEY_PLOMAHA_SMALL_BLIND] To:message+11];
			[self write2ByteInteger:[defaults integerForKey:KEY_PLOMAHA_BIG_BLIND] To:message+13];
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
	
	// set mode
	viewType = kViewRestoreMode;
	
	//??
	// there might be a postponed sendHeroApplicationData queued up.
	if (!isHeroApplicationDataSent && heroHoldemApplicationData)
		[self sendHeroApplicationData];
	else if (!isHeroApplicationDataSent && heroOmahaApplicationData)
		[self sendHeroOmahaApplicationData];
	
	// send device id to the other phone
	NSString *deviceId = [[UIDevice currentDevice] uniqueIdentifier];
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

#pragma mark GKPeerPickerControllerDelegate Methods

- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker { 
	// Peer Picker automatically dismisses on user cancel. No need to programmatically dismiss.
    
	// autorelease the picker. 
	picker.delegate = nil;
    [picker autorelease]; 
	
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
        [picker autorelease]; 
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
	// Remember the current peer.
	self.gamePeerId = peerID;  // copy
	
	// Make sure we have a reference to the game session and it is set up
	self.gameSession = session; // retain
	self.gameSession.delegate = self; 
	[self.gameSession setDataReceiveHandler:self withContext:NULL];
	
	// Done with the Peer Picker so dismiss it.
	[picker dismiss];
	picker.delegate = nil;
	[picker autorelease];
	
	[self sendHeroDeviceId];
} 

#pragma mark -
#pragma mark Session Related Methods

//
// invalidate session
//
- (void)invalidateSession:(GKSession *)session {
	if(session != nil) {
		[session disconnectFromAllPeers]; 
		session.available = NO; 
		[session setDataReceiveHandler: nil withContext: NULL]; 
		session.delegate = nil; 
	}
}

#pragma mark Data Send/Receive Methods

- (NSString *) holdemFileName:(NSString *)villainDeviceId {
	return [NSString stringWithFormat:@"%@%@", kHeadsupPoker3GSessionID, villainDeviceId];
}

- (NSString *) omahaFileName:(NSString *)villainDeviceId {
	return [NSString stringWithFormat:@"omaha%@%@", kHeadsupPoker3GSessionID, villainDeviceId];
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
		[(AppController*)[[UIApplication sharedApplication] delegate] setVillainDeviceId:myVillainDeviceId];
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
				NSString *fileName =[self holdemFileName:myVillainDeviceId];
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
				NSString *fileName =[self omahaFileName:myVillainDeviceId];
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
		
		NSInteger villainHeroStack = [self read4ByteIntegerFrom:villainPrefs+2];
		
		NSInteger villainVillainStack = [self read4ByteIntegerFrom:villainPrefs+6];
		
		NSInteger villainSmallBlind = [self read2ByteIntegerFrom:villainPrefs+10];
		NSInteger villainBigBlind = [self read2ByteIntegerFrom:villainPrefs+12];
		
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
			 !villainMode &&
			 villainHeroStack == heroVillainStack &&
			 villainVillainStack == heroHeroStack &&
			 villainSmallBlind == heroSmallBlind &&
			 villainBigBlind == heroBigBlind)) {
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

	HeadsupView* headsupView = (HeadsupView*)[viewController view];
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

	GameModeView* gameModeView = (GameModeView*)[viewController view];
	
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
	
	OmahaToolModeView* headsupView = (OmahaToolModeView*)[viewController view];
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
	
	OmahaGameModeView* gameModeView = (OmahaGameModeView*)[viewController view];
	
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

//- (void)sendNetworkPacket:(GKSession *)session packetID:(int)packetID withData:(void *)data ofLength:(int)length reliable:(BOOL)howtosend {
//}

#pragma mark GKSessionDelegate Methods

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state { 
	if(state == GKPeerStateDisconnected) {
		// We've been disconnected from the other peer.
		
		if (viewType == kViewRestoreMode)
			return;
		
		[gameSession disconnectFromAllPeers];
		[gameSession release];
		gameSession = nil;
		
		// Update user alert or throw alert if it isn't already up
		if (![(AppController*)[[UIApplication sharedApplication] delegate] isOpponentDisconnectIgnored]) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Opponent Disconnected" message:nil delegate:[[UIApplication sharedApplication] delegate] cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
	}	
} 

- (void) endSession {
	heroHoldemApplicationData = nil;
	villainHoldemApplicationData = nil;
	
	heroOmahaApplicationData = nil;
	villainOmahaApplicationData = nil;

	isViewPresented = NO;
	isHeroApplicationDataSent = NO;

	[gameSession disconnectFromAllPeers]; 
	gameSession.available = NO; 
	[gameSession setDataReceiveHandler: nil withContext: nil]; 
	gameSession.delegate = nil; 
	[gameSession release]; 
	gameSession = nil;
	
	[gamePeerId release];
	gamePeerId = nil;
}

- (IBAction) bluetoothButtonPressed:(id)sender {
	[self startPicker];
}

- (IBAction) trainingModeButtonPressed:(id)sender {
	BOOL isOmaha = ([[NSUserDefaults standardUserDefaults] integerForKey:KEY_GAME_NAME] == kGameOmahaHi);
	
	if (isOmaha)
		[(AppController*)[[UIApplication sharedApplication] delegate] presentTrainingModeOmahaGameModeView];
	else
		[(AppController*)[[UIApplication sharedApplication] delegate] presentTrainingModeHoldemGameModeView];
}

- (IBAction) singlePhoneModeButtonPressed:(id)sender {
	BOOL isOmaha = ([[NSUserDefaults standardUserDefaults] integerForKey:KEY_GAME_NAME] == kGameOmahaHi);
	
	if (isOmaha)
		[(AppController*)[[UIApplication sharedApplication] delegate] presentSinglePhoneModeOmahaGameModeView];
	else
		[(AppController*)[[UIApplication sharedApplication] delegate] presentSinglePhoneModeHoldemGameModeView];
}

- (IBAction) singlePlayerModeButtonPressed:(id)sender {
	BOOL isOmaha = ([[NSUserDefaults standardUserDefaults] integerForKey:KEY_GAME_NAME] == kGameOmahaHi);
	
	if (isOmaha)
		[(AppController*)[[UIApplication sharedApplication] delegate] presentSinglePlayerModeOmahaGameModeView];
	else
		[(AppController*)[[UIApplication sharedApplication] delegate] presentSinglePlayerModeHoldemGameModeView];
}

- (IBAction) settingsButtonPressed:(id)sender {
	[(AppController*)[[UIApplication sharedApplication] delegate] presentPrefsView];
}

- (IBAction) helpButtonPressed:(id)sender {
	[(AppController*)[[UIApplication sharedApplication] delegate] presentHelpHoldemView];
}	

- (void) willDisplay {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	enum GameName heroGame = [defaults integerForKey:KEY_GAME_NAME];
	BOOL heroMode = [defaults boolForKey:KEY_TOOL_MODE];
	BOOL isOmaha = (heroGame == kGameOmahaHi);
	NSInteger heroStack = [defaults integerForKey: isOmaha ? KEY_PLOMAHA_HERO_STACK : KEY_NLHOLDEM_HERO_STACK];
	NSInteger villainStack = [defaults integerForKey: isOmaha ? KEY_PLOMAHA_VILLAIN_STACK : KEY_NLHOLDEM_VILLAIN_STACK];
	NSInteger smallBlind = [defaults integerForKey: isOmaha ? KEY_PLOMAHA_SMALL_BLIND : KEY_NLHOLDEM_SMALL_BLIND];
	NSInteger bigBlind = [defaults integerForKey: isOmaha ? KEY_PLOMAHA_BIG_BLIND : KEY_NLHOLDEM_BIG_BLIND];	
	
	[settingsLabel setText:[NSString stringWithFormat:@"%@%@ %d-%d-%d-%d", 
							isOmaha ? @"Pot Limit Omaha" : @"No Limit Hold'em", 
							heroMode ? @" S" : @"",
							smallBlind, bigBlind, heroStack, villainStack]];
	[settingsLabel setNeedsDisplay];
}

@end

#endif