//
//  ScoreLayer.m
//  FloodIt
//
//  Created by Satansdeer satansdeer on 13.07.13.
//
//

#import "ScoreLayer.h"

@implementation ScoreLayer

+(CCScene *) scene {
	CCScene *scene = [CCScene node];
	ScoreLayer *layer = [ScoreLayer node];
	[scene addChild: layer];
	return scene;
}

-(id) init {
	if(self=[super initWithColor:ccc4(155, 77, 39, 255)]) {
    
    }
    return self;
}

@end
