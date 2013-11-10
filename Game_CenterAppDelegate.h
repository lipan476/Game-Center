//
//  Game_CenterAppDelegate.h
//  Game Center
//
//  Created by Jeroen van Rijn on 04-04-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Game_CenterViewController;

@interface Game_CenterAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet Game_CenterViewController *viewController;

@end
