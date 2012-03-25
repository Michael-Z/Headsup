//#define HU_3G
//#ifdef HU_3G
#import <GameKit/GameKit.h>
#import <StoreKit/StoreKit.h>
//#endif

/*
#import "Applytics.h"
#import "ApplyfireView.h"
#import "ApplyfireDelegateProtocol.h"*/

#import "GSAdEngine.h"

#import "BrowserViewController.h"
#import "Picker.h"
#import "GameCenterManager.h"
#import "TCPServer.h"
#import "Constants.h"
#import "MyViewController.h"
//#import "AdMobInterstitialAd.h"

#define HOLDEM_APPLICATION_DATA_LENGTH 41
#define OMAHA_APPLICATION_DATA_LENGTH 45
#define HOLDEM_TRAINING_MODE_APPLICATION_DATA_LENGTH 18
#define OMAHA_TRAINING_MODE_APPLICATION_DATA_LENGTH 22
#define BLACKJACK_APPLICATION_DATA_LENGTH 47
#define HEADSUP_BLACKJACK_APPLICATION_DATA_LENGTH 68

#define PREFS_LENGTH 14

// set a bit in a byte num to 1 if bool, or 0 if not bool
// bit == 0 means the lowest bit
#define SET_BOOLEAN_FLAG(num, bit, bool) num = (uint8_t)((bool) ? ((num) | (1<<(bit))) : ((num) & ~(1<<(bit))))

// return YES if a given bit in a byte num is 1, or NO if it's 0
#define GET_BOOLEAN_FLAG(num, bit) ((((num) >> (bit)) & 0x01) == 1)



//CLASS INTERFACES:

@class InterstitialSampleViewController;
@class MadeHand;
@class MyStoreObserver;

@interface AppController : NSObject 
<UIApplicationDelegate, 
UIActionSheetDelegate, 
BrowserViewControllerDelegate, 
TCPServerDelegate,
NSStreamDelegate,
//ApplyfireDelegateProtocol,
SKProductsRequestDelegate,
GKPeerPickerControllerDelegate, 
GKSessionDelegate,
GKMatchDelegate,
GameCenterManagerDelegate,
GreystripeDelegate>
{
	//AdMobInterstitialAd *interstitialAd;
	
	//InterstitialSampleViewController *interstitialViewController;
	
	IBOutlet UIWindow*			_window;
	Picker*				_picker;
	TCPServer*			_server;
	NSInputStream*		_inStream;
	NSOutputStream*		_outStream;
	BOOL				_inReady;
	BOOL				_outReady;
	
	UINavigationController *viewController;
	
	UIViewController *lobbyViewController;

	MyViewController *poker3GViewController;
	MyViewController *helpViewController;
	MyViewController *prefsViewController;
	MyViewController *gameCenterViewController;
	MyViewController *selectModeViewController;
	MyViewController *holdemToolModeViewController;
	MyViewController *holdemGameModeViewController;
	MyViewController *holdemTrainingModeViewController;	
	MyViewController *omahaToolModeViewController;	
	MyViewController *omahaGameModeViewController;
	MyViewController *omahaTrainingModeViewController;
	MyViewController *blackjackGameModeViewController;
	MyViewController *blackjackHeadsupModeViewController;
	
	//MyViewController *holdemGameCenterModeViewController;
	//MyViewController *omahaGameCenterModeViewController;
	
	uint8_t *heroHoldemApplicationData;
	uint8_t *villainHoldemApplicationData;

	uint8_t *heroOmahaApplicationData;
	uint8_t *villainOmahaApplicationData;

	NSString *myVillainDeviceId;
	
	NSString *localPlayerId, *remotePlayerId;
	
	enum ViewType viewType;
	BOOL dealer;
	
	BOOL isViewPresented;
	BOOL isHeroApplicationDataSent;
	
	BOOL ignoreOpponentDisconnect;
	BOOL errorOccurred;
	
	//ApplyfireView *inviteView;
	
	MyStoreObserver *transactionObserver;
	
	GKSession		*gameSession;
	NSString		*gamePeerId;
	
	enum GameName gameName;
	GKMatch	*gameMatch;
	GKVoiceChat *voiceChat;

	enum ConnectionType connectionType;
	
	GameCenterManager *gameCenterManager;
	
	NSInteger holdemWins, omahaWins, huBlackjackWins;
	NSInteger holdemInternetWins, omahaInternetWins;
	NSInteger holdemBluetoothWins, omahaBluetoothWins;
}

@property (nonatomic, retain) UINavigationController *viewController;
@property (nonatomic) BOOL errorOccurred;
@property (nonatomic) enum ConnectionType connectionType;

@property(nonatomic, retain) GKSession	 *gameSession;
@property(nonatomic, copy)	 NSString	 *gamePeerId;

@property(nonatomic, retain) GKMatch	 *gameMatch;
@property(nonatomic, retain) NSString	 *localPlayerId;
@property(nonatomic, retain) NSString	 *remotePlayerId;

@property(nonatomic, retain) GameCenterManager	 *gameCenterManager;


+ (NSInteger) read2ByteIntegerFrom:(uint8_t*)buf;
+ (NSInteger) read4ByteIntegerFrom:(uint8_t*)buf;	
+ (void) write2ByteInteger:(NSInteger)twoByteInteger To:(uint8_t*)buf;
+ (void) write4ByteInteger:(NSInteger)fourByteInteger To:(uint8_t*)buf;
	
+ (void) changeTitleOfButton:(UIButton*)button to:(NSString*)title;
+ (void) changeImageOfButton:(UIButton*)button to:(NSString*)imageName;
	
+ (NSString*) gameModeDescription:(enum GameMode)mode;

- (void) send:(const uint8_t)message;

- (void) sendArray:(uint8_t[])message size:(uint8_t)size;

- (void) toolEndedAtHand:(NSInteger)handCount game:(enum GameName)game;

- (void) gameEndedAtHand:(NSInteger)handCount 
					game:(enum GameName)game
			   heroStack:(NSInteger)heroStack 
			villainStack:(NSInteger)villainStack
			  smallBlind:(NSInteger)smallBlind
				bigBlind:(NSInteger)bigBlind;

- (void) presentHelpHoldemView;
- (void) presentPrefsView;
- (void) presentSelectModeView;

- (void) presentToolModeViewAtHand:(NSInteger)handCount;
- (void) presentHoldemGameModeViewAtHand:(NSInteger)handCount 
							   heroStack:(NSInteger)heroStack 
							villainStack:(NSInteger)villainStack
							  smallBlind:(NSInteger)smallBlind
								bigBlind:(NSInteger)bigBlind
					 heroApplicationData:(uint8_t*)heroApplicationData 
				  villainApplicationData:(uint8_t*)villainApplicationData
								gameMode:(enum GameMode)gameMode;

- (void) presentOmahaToolModeViewAtHand:(NSInteger)handCount;
- (void) presentOmahaGameModeViewAtHand:(NSInteger)handCount 
							   heroStack:(NSInteger)heroStack 
							villainStack:(NSInteger)villainStack
							  smallBlind:(NSInteger)smallBlind
								bigBlind:(NSInteger)bigBlind
					 heroApplicationData:(uint8_t*)heroApplicationData 
				  villainApplicationData:(uint8_t*)villainApplicationData
								gameMode:(enum GameMode)gameMode;

- (void) presentStudToolModeView;
- (void) presentStudGameModeView;
- (void) presentDrawToolModeView;
- (void) presentDrawGameModeView;

- (void)writeHoldemApplicationData:(NSData *)applicationData 
				   villainDeviceId:(NSString*)villainDeviceId
				  gameCenterIdPair:(NSString*)idPair
						  gameMode:(enum GameMode)gameMode;

- (void)writeOmahaApplicationData:(NSData *)applicationData 
				  villainDeviceId:(NSString*)villainDeviceId
						 gameMode:(enum GameMode)gameMode;


- (void)writeHoldemTrainingModeApplicationData:(NSData *)applicationData;
- (void)writeOmahaTrainingModeApplicationData:(NSData *)applicationData;
- (void)writeBlackjackGameModeApplicationData:(NSData *)applicationData;
- (void)writeBlackjackHeadsupModeApplicationData:(NSData *)applicationData;

- (void)ignoreOpponentDisconnect;
- (void)dontIgnoreOpponentDisconnect;
- (BOOL)isOpponentDisconnectIgnored;

- (void) createGameCenterMatch:(GKMatch*)match gameName:(enum GameName)startGameName;

- (void) presentSinglePhoneModeHoldemGameModeView;
- (void) presentSinglePlayerModeHoldemGameModeView;
- (void) presentTrainingModeHoldemGameModeView;

- (void) presentSinglePhoneModeOmahaGameModeView;
- (void) presentSinglePlayerModeOmahaGameModeView;
- (void) presentTrainingModeOmahaGameModeView;

- (void) presentBlackjackGameModeView;
- (void) presentBlackjackHeadsupModeView;

- (void) buyButtonPressed;

//- (void) presentInviteView;

- (void) setupServer;
- (void) setup;
- (void) presentPicker:(NSString*)name;


- (void) flipView:(UIView*)flipView;
- (void) setVillainDeviceId:(NSString*)villainDeviceId;
- (void) setGameModeViewController:(MyViewController*)gameModeViewController;
- (void) setOmahaGameModeViewController:(MyViewController*)gameModeViewController;

- (void) setup;
//- (void) finishApplicationInitialization;

- (NSData *)readApplicationDataFromFile:(NSString *)fileName;
- (BOOL)writeApplicationData:(NSData *)data toFile:(NSString *)fileName;
- (NSString *)holdemHistoryFileName:(NSString *)villainDeviceId gameMode:(enum GameMode)gameMode;

- (void) incrementHighScoreHoldemSinglePlayer;
- (void) incrementHighScoreOmahaSinglePlayer;
- (void) incrementHighScoreHeadsupBlackjackSinglePlayer;
- (void) incrementHighScoreHoldemBluetooth;
- (void) incrementHighScoreOmahaBluetooth;
- (void) incrementHighScoreHoldemInternet;
- (void) incrementHighScoreOmahaInternet;

- (void) checkAchievementsForHand:(MadeHand*)hand;
- (void) reloadHighScores;
- (NSString*) keyForPlayerID:(NSString*)playerID achievementID:(NSString*)achievementID;
- (NSString*) keyForPlayerID:(NSString*)playerID categoryID:(NSString*)categoryID;
- (NSString*) getGameCenterIdPair;

- (void) enableProUpgrade;

+ (BOOL) isProUpgradePurchased;

@end
