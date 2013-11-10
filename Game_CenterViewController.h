//
//  Game_CenterViewController.h
//  Game Center
//
//  Created by Jeroen van Rijn on 04-04-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

#import "GameCenterManager.h"


@class GameCenterManager;

@interface Game_CenterViewController : UIViewController <UIActionSheetDelegate, GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate, GameCenterManagerDelegate> {
	
	
	GameCenterManager *gameCenterManager;
	
	int64_t  currentScore;
	
	NSString* currentLeaderBoard;
	
	IBOutlet UILabel *currentScoreLabel;
    
}

@property (nonatomic, retain) GameCenterManager *gameCenterManager;
@property (nonatomic, assign) int64_t currentScore;
@property (nonatomic, retain) NSString* currentLeaderBoard;
@property (nonatomic, retain) UILabel *currentScoreLabel;


- (IBAction) reset;
- (IBAction) showLeaderboard;
- (IBAction) showAchievements;
- (IBAction) submitScore;
- (IBAction) increaseScore;


- (void) checkAchievements;


@end
