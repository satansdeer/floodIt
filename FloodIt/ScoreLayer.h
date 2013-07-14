//
//  ScoreLayer.h
//  FloodIt
//
//  Created by Satansdeer satansdeer on 13.07.13.
//
//

#import "cocos2d.h"

@interface ScoreLayer : CCLayerColor

@property (nonatomic, retain) CCLabelTTF*scoreLabel;
@property (nonatomic, retain) CCLabelTTF*moneyLabel;

+(CCScene *) scene;

@end
