//
//  Game_CenterViewController.m
//  Game Center
//
//  Created by Jeroen van Rijn on 04-04-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Game_CenterViewController.h"
#import "AppSpecificValues.h"
#import "GameCenterManager.h"

@implementation Game_CenterViewController

@synthesize gameCenterManager;
@synthesize currentScore;
@synthesize currentLeaderBoard;
@synthesize currentScoreLabel;

- (void)dealloc
{
    [gameCenterManager release];
	[currentLeaderBoard release];
	[currentScoreLabel release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currentLeaderBoard = kLeaderboardID;
	self.currentScore = 0;
	
	if ([GameCenterManager isGameCenterAvailable]) {
		
		self.gameCenterManager = [[[GameCenterManager alloc] init] autorelease];
		[self.gameCenterManager setDelegate:self];
		[self.gameCenterManager authenticateLocalUser];
		
		
	} else {
		
		// The current device does not support Game Center.
        
	}
}


- (IBAction) showLeaderboard
{
	GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
	if (leaderboardController != NULL) 
	{
		leaderboardController.category = self.currentLeaderBoard;
		leaderboardController.timeScope = GKLeaderboardTimeScopeWeek;
		leaderboardController.leaderboardDelegate = self; 
		[self presentModalViewController: leaderboardController animated: YES];
	}
}



- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	[self dismissModalViewControllerAnimated: YES];
	[viewController release];
}



- (IBAction) showAchievements
{
	GKAchievementViewController *achievements = [[GKAchievementViewController alloc] init];
	if (achievements != NULL)
	{
		achievements.achievementDelegate = self;
		[self presentModalViewController: achievements animated: YES];
	}
}



- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController;
{
	[self dismissModalViewControllerAnimated: YES];
	[viewController release];
}

- (IBAction) reset
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to reset your score and achievements?"
															 delegate:self
													cancelButtonTitle:@"Cancel" 
											   destructiveButtonTitle:@"Reset" 
													otherButtonTitles:nil];
	[actionSheet showInView:[self view]];
	[actionSheet release];
	
}

- (IBAction) increaseScore
{
	self.currentScore = self.currentScore + 1;
	currentScoreLabel.text = [NSString stringWithFormat: @"%ld", self.currentScore];
	
	[self checkAchievements];
}

- (void) checkAchievements
{
	NSString* identifier = NULL;
	double percentComplete = 0;
	switch(self.currentScore)
	{
		case 1:
		{
			identifier= kAchievementOneTap;
			percentComplete= 100.0;
			break;
		}
		case 5:
		{
			identifier= kAchievement20Taps;
			percentComplete= 25.0;
			break;
		}
		case 10:
		{
			identifier= kAchievement20Taps;
			percentComplete= 50.0;
			break;
		}
		case 15:
		{
			identifier= kAchievement20Taps;
			percentComplete= 75.0;
			break;
		}
		case 20:
		{
			identifier= kAchievement20Taps;
			percentComplete= 100.0;
			break;
		}
            
	}
	if(identifier!= NULL)
	{
		[self.gameCenterManager submitAchievement: identifier percentComplete: percentComplete];
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {
		
		[gameCenterManager resetAchievements];
		
		self.currentScore = 0;
		currentScoreLabel.text = [NSString stringWithFormat: @"%ld", self.currentScore];
        
	}
}

- (IBAction) submitScore
{
	if(self.currentScore > 0)
	{
		[self.gameCenterManager reportScore: self.currentScore forCategory: self.currentLeaderBoard];
	}
}
- (void) achievementSubmitted: (GKAchievement*) ach error:(NSError*) error;
{
    
	if((error == NULL) && (ach != NULL))
	{
		if (ach.percentComplete == 100.0) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Achievement Earned!" 
                                                            message:(@"%@",ach.identifier)
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		
	}
	else
	{
		// Achievement Submission Failed.
        
	}
    
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.gameCenterManager = nil;
	self.currentLeaderBoard = nil;
	self.currentScoreLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
