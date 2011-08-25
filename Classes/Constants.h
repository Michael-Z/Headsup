#define KEY_GAME_NAME @"game_name"
#define KEY_TOOL_MODE @"tool_mode"
#define KEY_FOUR_COLOR_DECK @"four_color_deck"
#define KEY_HERO_HOLE_CARDS_FACE_UP @"hero_hole_cards_face_up"
#define KEY_SOUND @"sound"
#define KEY_ADVANCED_AI @"advanced_ai"
#define KEY_NLHOLDEM_HERO_STACK @"nlholdem_hero_stack"
#define KEY_NLHOLDEM_VILLAIN_STACK @"nlholdem_villain_stack"
#define KEY_NLHOLDEM_SMALL_BLIND @"nlholdem_small_blind"
#define KEY_NLHOLDEM_BIG_BLIND @"nlholdem_big_blind"
#define KEY_PLOMAHA_HERO_STACK @"plomaha_hero_stack"
#define KEY_PLOMAHA_VILLAIN_STACK @"plomaha_villain_stack"
#define KEY_PLOMAHA_SMALL_BLIND @"plomaha_small_blind"
#define KEY_PLOMAHA_BIG_BLIND @"plomaha_big_blind"

// these will not be accessible from the prefs page.
#define KEY_HERO_NAME @"hero_name"
#define KEY_VILLAIN_NAME @"villain_name"

#define DEFAULT_STACK 150
#define DEFAULT_SMALL_BLIND 1
#define DEFAULT_BIG_BLIND 2

#define HU_HOLDEM 0
#define HU_HOLDEM_FREE 1
#define HU_OMAHA 2
#define HU_OMAHA_FREE 3
#define HU_STUD 4
#define HU_STUD_FREE 5
#define HU_DRAW 6
#define HU_DRAW_FREE 7
#define HU_MIXED 8
#define HU_MIXED_FREE 9
#define HU_FREE 100

#define BUILD HU_HOLDEM_FREE


#if BUILD == HU_HOLDEM
//Leaderboard Category IDs
#define kBeatComputerHoldemLeaderboardID @"com.qin.huholdem.BeatComputerHoldem"
#define kBeatComputerOmahaLeaderboardID @"com.qin.huholdem.BeatComputerOmaha"
#define kBeatComputerHeadsupBlackjackLeaderboardID @"com.qin.huholdem.BeatComputerHeadsupBlackjack"
#define kBeatFriendsInternetHoldemLeaderboardID @"com.qin.huholdem.BeatFriendsInternetHoldemLeaderboard"
#define kBeatFriendsInternetOmahaLeaderboardID @"com.qin.huholdem.BeatFriendsInternetOmahaLeaderboard"
#define kBeatFriendsBluetoothHoldemLeaderboardID @"com.qin.huholdem.BeatFriendsBluetoothHoldemLeaderboard"
#define kBeatFriendsBluetoothOmahaLeaderboardID @"com.qin.huholdem.BeatFriendsBluetoothOmahaLeaderboard"
#define kBlackjackLeaderboardID @"com.qin.huholdem.Blackjack"


//Achievement IDs
#define kAchievementStraight @"com.qin.huholdem.straight"
#define kAchievementFlush @"com.qin.huholdem.flush"
#define kAchievementBoat @"com.qin.huholdem.boat"
#define kAchievementQuad @"com.qin.huholdem.quad"
#define kAchievementStraightFlush @"com.qin.huholdem.straightflush"

#else
//Leaderboard Category IDs
#define kBeatComputerHoldemLeaderboardID @"com.qin.BeatComputerHoldem"
#define kBeatComputerOmahaLeaderboardID @"com.qin.BeatComputerOmaha"
#define kBeatComputerHeadsupBlackjackLeaderboardID @"com.qin.BeatComputerHeadsupBlackjack"
#define kBeatFriendsInternetHoldemLeaderboardID @"com.qin.BeatFriendsInternetHoldemLeaderboard"
#define kBeatFriendsInternetOmahaLeaderboardID @"com.qin.BeatFriendsInternetOmahaLeaderboard"
#define kBeatFriendsBluetoothHoldemLeaderboardID @"com.qin.BeatFriendsBluetoothHoldemLeaderboard"
#define kBeatFriendsBluetoothOmahaLeaderboardID @"com.qin.BeatFriendsBluetoothOmahaLeaderboard"
#define kBlackjackLeaderboardID @"com.qin.Blackjack"


//Achievement IDs
#define kAchievementStraight @"com.qin.straight"
#define kAchievementFlush @"com.qin.flush"
#define kAchievementBoat @"com.qin.boat"
#define kAchievementQuad @"com.qin.quad"
#define kAchievementStraightFlush @"com.qin.straightflush"
#endif

// in app purchase
#define kHeadsupProVersionProductID @"com.qin.huholdemfree.proversion"
#define kHeadsupProVersionTransactionReceipt @"proUpgradeTransactionReceipt"
#define kHeadsupProVersionPurchasedKey @"isProUpgradePurchased"


//
enum Suit {
	kSuitSpade = 0,
	kSuitHeart = 1,
	kSuitDiamond = 2,
	kSuitClub = 3
};

enum Rank {
	kRankAce = 14,
	kRankKing = 13,
	kRankQueen = 12,
	kRankJack = 11,
	kRankTen = 10,
	kRankNine = 9,
	kRankEight = 8,
	kRankSeven = 7,
	kRankSix = 6,
	kRankFive = 5,
	kRankFour = 4,
	kRankThree = 3,
	kRankTwo = 2,
	// a temporary rank for ace when comparing lo hands. 
	// temporary means this is NOT a valid rank for an Ace. therefore,
	// a card object's rank must be reset to kRankAce afterwards if it's set to kRankAceLo
	// for comparing lo hands.
	kRankAceLo = 1
};

enum Party {
	kPartyDealer,
	kPartyHero,
	kPartyVillain
};

enum HandGame {
	kHandHoldem,
	kHandOmaha,
	kHand7Stud,
	kHand5CardSingleDraw,
	kHand5CardTrippleDraw,	
	kHandBadugi,
	kHandBlackjack
};

enum GameName {
	kGameHoldem,
	kGameOmahaHi
};

enum Street {
	// hold'em, omaha
	kStreetPreflop,
	kStreetFlop,
	kStreetTurn,
	kStreetRiver,
	
	// stud
	kStreetThird,
	kStreetFourth,
	kStreetFifth,
	kStreetSixth,
	kStreetSeventh,
	
	// draw
	kStreetRoundOne,
	kStreetRoundTwo,
	kStreetRoundThree,
	kStreetRoundFour
};

enum State {
	kStateReady,
	kStateCancelled,
	kStateNewReqSent,
	kStateNewReqReceived,
	kStateNewStarted,
	kStateNewHandReadyToBeDealt,
	kStateNextReqSent,
	kStateNextReqReceived,
	kStateNextStreetReadyToBeDealt,
	kStateAllInReqSent,
	kStateAllInReqReceived,
	kStateAllInReadyToBeDealt
};

enum HUBJState {
	kHUBJStateFirstBasesTurnToBet,
	kHUBJStateSecondBasesTurnToBet,
	kHUBJStateCardsToBeDealt,
	kHUBJStateFirstBasesTurnToAct,
	kHUBJStateSecondBasesTurnToAct,
	kHUBJStateDealersTurnToAct,
	kHUBJStateResultsProcessed
};

enum Event {
	kEventSendNewReq,
	kEventReceiveNewReq,
	kEventSendCards,
	kEventReceiveCards,
	kEventSendNextReq,
	kEventReceiveNextReq,
	kEventSendAllInReq,
	kEventReceiveAllInReq,
	kEventGetReady,
	kEventDealt
};

enum Message {
	kMessageNewReq,
	kMessageNextReq,
	kMessageAllInReq,
	kMessageCards
};


enum MoveType {
	kMoveBet,
	kMoveRaise,
	kMoveCheck,
	kMoveCall,
	kMoveFold,
	kMoveCards,
	kMovePat,
	kMoveDiscard,
	kMoveDeviceId,
	kMovePrefs,
	kMoveHoldemApplicationData,
	kMoveOmahaApplicationData,
	kMoveEndMatch
};	

enum ActionType {
	kActionBet,
	kActionRaise,
	kActionCheck,
	kActionCall,
	kActionFold,
	kActionFlop,
	kActionTurn,
	kActionRiver,
	kActionShowdown
};

enum LoHandType {
	kLoHandNuts,
	kLoHandSecondNuts,
	kLoHandOtherLo,
	kLoHandNoLo
};

enum HandType {
	kHandHighCard,
	kHandOnePair,	
	kHandTwoPair,
	kHandTrips,
	kHandStraight,	
	kHandFlush,
	kHandBoat,	
	kHandQuads,
	kHandStraightFlush
};

enum TrueHandType {
	kTypeHighCard,
	kTypeNonTopPair,
	kTypeTopPair,
	kTypeOverPair,
	kTypeTwoPair,
	kTypeTrips,
	kTypeStraight,
	kTypeFlush,
	kTypeBoat,
	kTypeQuads,
	kTypeStraightFlush
};

enum ModeState {
	kModeStateReady,
	kModeStateCancelled,
	kModeStateToolModeSent,
	kModeStateToolModeReceived,
	kModeStateToolModeStarted,

	kModeStateGameModeSent,
	kModeStateGameModeReceived,
	kModeStateGameModeStarted
};

enum ModeEvent {
	kModeEventSendToolMode,
	kModeEventReceiveToolMode,
	kModeEventSendGameMode,
	kModeEventReceiveGameMode,
	kModeEventGetReady
};

enum ViewType {
	kViewRestoreMode,
	kViewSelectMode,
	kViewHoldemTrainingMode,
	kViewOmahaTrainingMode,
	kViewBlackjackGameMode,
	kViewBlackjackHeadsupMode,
	kViewToolMode,
	kViewGameMode,
	kViewOmahaToolMode,
	kViewOmahaGameMode,
	kViewStudToolMode,
	kViewStudGameMode,
	kViewDrawToolMode,
	kViewDrawGameMode
};

enum GameMode {
	kSinglePlayerMode,
	kSinglePhoneMode,
	kDualPhoneMode,
	kGameCenterMode
};

enum ConnectionType {
	kConnectionBluetooth,
	kConnectionWiFi,
	kConnectionGameCenter
};

enum Mode {
	kModeOther, //lobby or dual phone mode
	kModeHoldemSinglePlayer,
	kModeHoldemSinglePhone,
	kModeOmahaSinglePlayer,
	kModeOmahaSinglePhone,
	kModeBlackjack,
	kModeHeadsupBlackjack
};