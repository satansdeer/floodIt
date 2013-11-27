//
//  HelloWorldLayer.m
//  DreamCatcher
//
//  Created by Satansdeer satansdeer on 14.03.13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// Import the interfaces
#import "MainMenuLayer.h"
#import "GameFieldLayer.h"
#import "GameModel.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation MainMenuLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene {
	CCScene *scene = [CCScene node];
	MainMenuLayer *layer = [MainMenuLayer node];
	[scene addChild: layer];
	return scene;
}

// on "init" you need to initialize your instance
-(id) init {
	if( (self=[super initWithColor:ccc4(155, 77, 39, 255)]) ) {
		CCMenuItemImage *playButton = [CCMenuItemImage itemWithNormalImage:@"Play.png"
                                                            selectedImage: @"Play.png"
                                                                   target:self
                                                                 selector:@selector(play:)];
        CCMenuItemImage *optionsButton = [CCMenuItemImage itemWithNormalImage:@"Options.png"
                                                            selectedImage: @"Options.png"
                                                                   target:self
                                                                 selector:@selector(doSomething:)];
        CCMenuItemImage *creditsButton = [CCMenuItemImage itemWithNormalImage:@"Credits.png"
                                                            selectedImage: @"Credits.png"
                                                                   target:self
                                                                 selector:@selector(doSomething:)];
        CCMenu * myMenu = [CCMenu menuWithItems:playButton, optionsButton, creditsButton, nil];
        [myMenu alignItemsVertically];
        playButton.scale = 0.6;
        optionsButton.scale = 0.6;
        creditsButton.scale = 0.6;
        [self addChild:myMenu];
        [self runAction:[CCSequence actions:
                         [CCCallFuncO actionWithTarget:self selector:@selector(tweenNode:) object:playButton],
                         [CCCallFuncO actionWithTarget:self selector:@selector(tweenNode:) object:optionsButton],
                         [CCCallFuncO actionWithTarget:self selector:@selector(tweenNode:) object:creditsButton],
                         nil]];
	}
	return self;
}

-(void) tweenNode: (CCNode  *) menuItem {
    [menuItem runAction:[CCEaseElasticOut actionWithAction:[CCScaleTo actionWithDuration:1.7 scale:1]]];
}

-(void) play: (CCMenuItem *) menuItem {
    [GameModel sharedModel].level = 1;
    [GameModel sharedModel].turns = 125;
    [GameModel sharedModel].score = 0;
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameFieldLayer scene] withColor:ccWHITE]];
}

-(void)doSomething: (CCMenuItem*)menuItem{

}

@end
