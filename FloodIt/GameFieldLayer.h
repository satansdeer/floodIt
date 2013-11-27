//
//  HelloWorldLayer.h
//  FloodIt
//
//  Created by Satansdeer satansdeer on 06.07.13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


#import <GameKit/GameKit.h>
#import "FloodItem.h"
// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "GuiLayer.h"

// HelloWorldLayer
@interface GameFieldLayer : CCLayerColor <GuiLayerDelegate>
{
}

@property (nonatomic, retain) NSMutableArray* floodItems;
@property (nonatomic, retain) NSMutableArray* startingGroup;
@property (nonatomic, retain) NSMutableArray* sameColorGroup;
@property (nonatomic, retain) NSString * startingColor;
@property (nonatomic, retain) NSArray * availableColors;
@property (nonatomic, retain) GuiLayer*guiLayer;
@property (nonatomic,assign) int totalItems;

-(void)placeTiles:(int)tilesNumber;
-(void)chooseColor:(NSString *)color;
+(CCScene *) scene;

@end
