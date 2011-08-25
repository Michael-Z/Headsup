//
//  HelpHoldemView.m
//  Headsup
//
//  Created by Haolan Qin on 08/29/10.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "GameCenterView.h"

#import "Constants.h"
#import "Poker3GView.h"

@interface GameCenterView ()
- (void)startUserAuthentication;
//- (void)showLeaderboard:(GKLeaderboardViewController *)leaderboardViewController;
- (void)showMatchmaker:(GKMatchmakerViewController *)matchmakerViewController;
- (void)showError:(NSError *)error;
@end

@implementation GameCenterView

@synthesize navController;

- (void)dealloc {
	AudioSessionSetActive(false);
	
    [super dealloc];
}

- (IBAction) lobbyButtonPressed {
	[navController popViewControllerAnimated:YES];
}

- (IBAction) signInButtonPressed {
	[self startUserAuthentication];
}

- (IBAction) holdemButtonPressed {
	gameName = kGameHoldem;
	GKMatchRequest *request = [[[GKMatchRequest alloc] init] autorelease];
	request.playerGroup = kGameHoldem;
    request.minPlayers = 2;
    request.maxPlayers = 2;
	[self showMatchmaker:[[GKMatchmakerViewController alloc] initWithMatchRequest:request]];	
}

- (IBAction) omahaButtonPressed {
	gameName = kGameOmahaHi;
	GKMatchRequest *request = [[[GKMatchRequest alloc] init] autorelease];
	request.playerGroup = kGameOmahaHi;
    request.minPlayers = 2;
    request.maxPlayers = 2;
	[self showMatchmaker:[[GKMatchmakerViewController alloc] initWithMatchRequest:request]];	
}

- (void)setupAudioSession {    
    OSStatus osRes = 0;
    osRes = AudioSessionInitialize(NULL, NULL, NULL, NULL);
    if (osRes) {
        NSLog(@"Initializing Audio Session Failed: %ld", (long)osRes);
    }
    
    osRes = AudioSessionSetActive(true);
    if (osRes) {
        NSLog(@"AudioSessionSetActive Failed: %ld", (long)osRes);
    }
    
    UInt32 category = kAudioSessionCategory_PlayAndRecord;
    osRes = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
    if (osRes) {
        NSLog(@"AudioSessionSetProperty kAudioSessionCategory_PlayAndRecord Failed: %ld", (long)osRes);
    }
    UInt32 allowMixing = true;
    osRes = AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(allowMixing), &allowMixing);
    if (osRes) {
        NSLog(@"AudioSessionSetProperty kAudioSessionProperty_OverrideCategoryMixWithOthers Failed: %ld", (long)osRes);
    }
    UInt32 route = kAudioSessionOverrideAudioRoute_Speaker;
    osRes = AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(route), &route);
    if (osRes) {
        NSLog(@"AudioSessionSetProperty kAudioSessionOverrideAudioRoute_Speaker Failed: %ld", (long)osRes);
    }
}

- (void)setupInviteHandler {
    [[GKMatchmaker sharedMatchmaker] setInviteHandler:^(GKInvite *invite, NSArray *tmp) {
		NSLog(@"invite handler");
		[self showMatchmaker:[[GKMatchmakerViewController alloc] initWithInvite:invite]];
    }];
}

- (void) setupActivityLabels {
	[[GKMatchmaker sharedMatchmaker] 
	 queryPlayerGroupActivity:kGameHoldem
	 withCompletionHandler: ^(NSInteger activity, NSError *error) {
		 [holdemActivityLabel setText:[NSString stringWithFormat:@"%d", activity]];
	 }];
	
	[[GKMatchmaker sharedMatchmaker] 
	 queryPlayerGroupActivity:kGameOmahaHi
	 withCompletionHandler: ^(NSInteger activity, NSError *error) {
		 [omahaActivityLabel setText:[NSString stringWithFormat:@"%d", activity]];
	 }];	
}	  

- (void)localPlayerDidAuthenticateWithPlayerId:(NSString*)localPlayerId
								   playerAlias:(NSString*)localPlayerAlias {
    //signInButton.hidden = YES;
    //startGameButton.hidden = NO;
	
	((AppController*)[[UIApplication sharedApplication] delegate]).localPlayerId = localPlayerId;
	[[NSUserDefaults standardUserDefaults] setObject:localPlayerAlias forKey:KEY_HERO_NAME];

    [self setupInviteHandler];
									   
	[self setupActivityLabels];
}

- (void)localPlayerDidFailToAuthenticateWithError:(NSError *)error {
    //signInButton.hidden = NO;
	
    [self showError:error];
}

- (void)startUserAuthentication {
    [activityIndicatorView startAnimating];
    
    GKLocalPlayer *player = [GKLocalPlayer localPlayer];
    [player authenticateWithCompletionHandler:^(NSError *error) {
        [activityIndicatorView stopAnimating];
		
        if (error) {
            [self localPlayerDidFailToAuthenticateWithError:error];
        }
        else {
            [self localPlayerDidAuthenticateWithPlayerId:player.playerID
											 playerAlias:player.alias];
        }
    }];
}

/*
- (void) showLeaderboard:(GKLeaderboardViewController *)leaderboardViewController {
	//leaderboardViewController.leaderboardDelegate = self;
	
	UIViewController *gameCenterViewController = ((AppController *)[[UIApplication sharedApplication] delegate]).viewController;
    [gameCenterViewController presentModalViewController:leaderboardViewController animated:YES];
	
}*/

#pragma mark -
#pragma mark score

- (void)addScore
{
	GKScore* myPlayerScore = [[[GKScore alloc] init] autorelease];
	myPlayerScore.value = 13000;
	[myPlayerScore reportScoreWithCompletionHandler:^(NSError *error)
	 {
		 if (error) {
			 //NSData* archivedScore = [NSKeyedArchiver
			//						  archivedDataWithRootObject:myPlayerScore];
			 //[self saveScoreToSendLater:archivedScore];
		 } else {
			 //int i=0;
			 // the score was submitted successfully
		 }
	 }];
	
}

- (void)queryLeaderboard
{
	/*GKLeaderboard* myLeaderboard = [[[GKLeaderboard alloc] init] autorelease];
	 // interested in friends scores over the past week
	 myLeaderboard.timeScope = GKLeaderboardTimeScopeWeek;
	 myleaderboard.playerScope = GKLeaderboardPlayerScopeFriendsOnly;
	 myLeaderboard.range = NSMakeRange(1,25);*/
	
	GKLocalPlayer *player = [GKLocalPlayer localPlayer];
	GKLeaderboard* myLeaderboard = [[[GKLeaderboard alloc] initWithPlayerIDs:[NSArray arrayWithObject:player.playerID]] autorelease];
	
	[myLeaderboard
	 loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
		 
		 if (scores) {
			 //scores now contains all the scores received per the query
			 for (GKScore *score in scores) {
				 // looping through all the scores in the array
				 // display in custom UI
				 NSLog(@"score: %d",score.value);
			 }
		 }
		 if (error) {
			 // handle error
		 }
	 }
	 ];
}

- (void)updateAchievements
{
	GKAchievement* myAchievement = [[[GKAchievement alloc]
									 initWithIdentifier:@"it.fraboni.testgc.a1"] autorelease];
	myAchievement.percentComplete = 100.0;
	[myAchievement reportAchievementWithCompletionHandler:^(NSError *error) {
		if (error) {
			//NSData* archivedAchievement = [NSKeyedArchiver
			//							   archivedDataWithRootObject:myAchievement];
			//[self saveAchievementToSendLater:archivedAchievement];
		} else {
			// the achievement was submitted successfully
			// Note: reporting an achievement will unhide it
		}
	}];
	
}

- (void)queryAchievements
{
	[GKAchievementDescription loadAchievementDescriptionsWithCompletionHandler:
	 ^(NSArray *descriptions, NSError *error) {
		 if (descriptions) {
			 for (GKAchievementDescription *description in descriptions) {
				 //int i=0;
				 /*[self.achievementDescriptionTable
				  setObject:description
				  forKey:description.identifier];*/
			 }
		 }
		 if (error) {
			 // handle error
		 }
		 
	 }];
}

- (IBAction) leaderboardButtonPressed {	
	GKLeaderboardViewController* leaderBoardViewController = [[GKLeaderboardViewController alloc] init];
    leaderBoardViewController.timeScope = GKLeaderboardTimeScopeWeek;
	//leaderBoardViewController.category 
	leaderBoardViewController.leaderboardDelegate = self;   
	
	UIViewController *gameCenterViewController = ((AppController *)[[UIApplication sharedApplication] delegate]).viewController;	

    [gameCenterViewController presentModalViewController:[leaderBoardViewController autorelease] animated:YES];
	
	GKLeaderboardViewController *myLeaderboardViewController = [[[GKLeaderboardViewController alloc] initWithNibName:nil bundle:nil] autorelease];
	
	[gameCenterViewController presentModalViewController: myLeaderboardViewController animated:YES];	
}


- (IBAction)achievementButtonPressed
{
	GKAchievementViewController* myAchievementsViewController =
	[[[GKAchievementViewController alloc] init] autorelease];
	[myAchievementsViewController setAchievementDelegate: self];
	UIViewController *gameCenterViewController = ((AppController *)[[UIApplication sharedApplication] delegate]).viewController;
	[gameCenterViewController presentModalViewController:myAchievementsViewController animated:YES];
}



- (void)showMatchmaker:(GKMatchmakerViewController *)matchmakerViewController {
    matchmakerViewController.matchmakerDelegate = self;
    matchmakerViewController.hosted = NO;
	
	UIViewController *gameCenterViewController = ((AppController *)[[UIApplication sharedApplication] delegate]).viewController;
    [gameCenterViewController presentModalViewController:matchmakerViewController animated:YES];
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

- (void) willDisplay {
	[self setupAudioSession];
		
	[self startUserAuthentication];
}

@end
