//
//  GuiLayer.m
//  FloodIt
//
//  Created by Satansdeer satansdeer on 09.07.13.
//
//

#import "GuiLayer.h"
#import "cocos2d.h"
#import "MainMenuLayer.h"
#import "GameModel.h"
#import "LayerManager.h"

@implementation GuiLayer

-(id) initWithDelegate:(id)delegate
{
	if( (self=[super init]) ) {
        self.myDelegate = delegate;
        CCMenuItemImage *playButton = [CCMenuItemImage itemWithNormalImage:@"pause.png"
                                                             selectedImage:@"pause.png"
                                                                    target:self
                                                                  selector:@selector(menuTapped)];
        
        CCMenu * myMenu = [CCMenu menuWithItems:playButton, nil];
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        myMenu.position = CGPointMake(8 + playButton.boundingBox.size.width/2, winSize.height - playButton.boundingBox.size.height/2-8);
        myMenu.anchorPoint = CGPointMake(0, 0);
        playButton.scale = 0.6;
        
        [self addChild:myMenu];
        [self runAction:[CCCallFuncO actionWithTarget:self selector:@selector(tweenNode:) object:playButton]];
        self.scoreLabel = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"Score: %d",[GameModel sharedModel].score] fontName:@"Marker Felt" fontSize:24];
        self.scoreLabel.anchorPoint = CGPointMake(0, 0);
        self.scoreLabel.position = CGPointMake(100, winSize.height - self.scoreLabel.boundingBox.size.height-8);
        [self addChild:self.scoreLabel];
        self.levelLabel = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"Level: %d",[GameModel sharedModel].level] fontName:@"Marker Felt" fontSize:24];
        self.levelLabel.anchorPoint = CGPointMake(0, 0);
        self.levelLabel.position = CGPointMake(100, winSize.height - self.levelLabel.boundingBox.size.height-8- self.scoreLabel.boundingBox.size.height);
        [self addChild:self.levelLabel];
        self.turnsLabel = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"Turns: %d",[GameModel sharedModel].turns] fontName:@"Marker Felt" fontSize:24];
        self.turnsLabel.anchorPoint = CGPointMake(0, 0);
        self.turnsLabel.position = CGPointMake(200, winSize.height - self.levelLabel.boundingBox.size.height-8- self.scoreLabel.boundingBox.size.height);
        [self addChild:self.turnsLabel];
	}
	return self;
}

-(void)update{
    [self.scoreLabel setString:[NSString stringWithFormat:@"Score: %d",[GameModel sharedModel].score]];
    [self.levelLabel setString:[NSString stringWithFormat:@"Level: %d",[GameModel sharedModel].level]];
    [self.turnsLabel setString:[NSString stringWithFormat:@"Turns: %d",[GameModel sharedModel].turns]];
}

-(void) tweenNode: (CCNode  *) item {
    [item runAction:[CCEaseElasticOut actionWithAction:[CCScaleTo actionWithDuration:1.7 scale:1]]];
}
                         
-(void)menuTapped{
    [self exitToMenu];
}

-(void)exitToMenu{
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    [[LayerManager sharedManager] clear:self];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainMenuLayer scene] withColor:ccWHITE]];
}

@end
