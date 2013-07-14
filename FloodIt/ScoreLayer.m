//
//  ScoreLayer.m
//  FloodIt
//
//  Created by Satansdeer satansdeer on 13.07.13.
//
//

#import "ScoreLayer.h"
#import "GameModel.h"
#import "cocos2d.h"
#import "MainMenuLayer.h"
#import "GameFieldLayer.h"

@implementation ScoreLayer

+(CCScene *) scene {
	CCScene *scene = [CCScene node];
	ScoreLayer *layer = [ScoreLayer node];
	[scene addChild: layer];
	return scene;
}

-(id) init {
	if(self=[super initWithColor:ccc4(155, 77, 39, 255)]) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        self.scoreLabel = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"Score: %d",[GameModel sharedModel].score] fontName:@"Marker Felt" fontSize:24];
        self.scoreLabel.anchorPoint = CGPointMake(0, 0);
        self.scoreLabel.position = CGPointMake(100, winSize.height - self.scoreLabel.boundingBox.size.height-50);
        [self addChild:self.scoreLabel];
        self.moneyLabel = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"Money: %d",[GameModel sharedModel].money] fontName:@"Marker Felt" fontSize:24];
        self.moneyLabel.anchorPoint = CGPointMake(0, 0);
        self.moneyLabel.position = CGPointMake(100, winSize.height - self.moneyLabel.boundingBox.size.height-80);
        [self addChild:self.moneyLabel];
        CCSprite*line = [CCSprite spriteWithFile:@"line.png"];
        line.scaleX = 0.6;
        line.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:line];
        CCSprite*slider = [CCSprite spriteWithFile:@"Slider-Button.png"];
        slider.position = ccp(line.position.x - line.boundingBox.size.width/2, line.position.y);
        //int highScore = [GameModel sharedModel].highScore;
        int highScore = 100;
        int score = [GameModel sharedModel].score;
        float desiredXposition = line.boundingBox.size.width/highScore*score;
        [slider runAction:[CCEaseBounceOut actionWithAction:[CCMoveBy actionWithDuration:1 position:ccp(desiredXposition,0)]]];
        [self addChild:slider];
        
        CCMenuItemImage *play = [CCMenuItemImage itemWithNormalImage:@"Play.png"
                                                             selectedImage: @"Play.png"
                                                                    target:self
                                                                  selector:@selector(play:)];
        CCMenuItemImage *menuButton = [CCMenuItemImage itemWithNormalImage:@"Menu.png"
                                                                selectedImage: @"Menu.png"
                                                                       target:self
                                                                     selector:@selector(exitToMenu:)];
        CCMenu * myMenu = [CCMenu menuWithItems:play,menuButton, nil];
        myMenu.position = ccp(winSize.width/2, winSize.height/2 - 90);
        [myMenu alignItemsVertically];
        [self addChild:myMenu];
    }
    return self;
}

-(void)exitToMenu: (CCMenuItem*)menuItem{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainMenuLayer scene] withColor:ccWHITE]];
}

-(void) play: (CCMenuItem *) menuItem {
    [GameModel sharedModel].level = 1;
    [GameModel sharedModel].turns = 25;
    [GameModel sharedModel].score = 0;
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameFieldLayer scene] withColor:ccWHITE]];
}

@end
