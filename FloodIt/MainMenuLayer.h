//
//  HelloWorldLayer.h
//  DreamCatcher
//
//  Created by Satansdeer satansdeer on 14.03.13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


#import <GameKit/GameKit.h>
#import "Player.h" 
// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface MainMenuLayer : CCLayerColor
{
}

@property (nonatomic, retain) Player * player;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
