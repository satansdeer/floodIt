//
//  FloodItem.h
//  FloodIt
//
//  Created by Satansdeer satansdeer on 06.07.13.
//
//

#import "cocos2d.h"

@interface FloodItem : CCSprite <CCTouchOneByOneDelegate>

@property (nonatomic, retain) CCSprite*     image;
@property (nonatomic, retain) CCLabelTTF*   counterText;
@property (nonatomic, retain) NSString*     currentColor;
@property (nonatomic, assign) CGSize        tileSize;
@property (nonatomic, assign) CGPoint       positionInGame;
@property (nonatomic, assign) BOOL          isInWinGroup;
@property (nonatomic, assign) id            myDelegate;
@property (nonatomic, assign) int           counter;

-(id)initWithFile:(NSString*)filename position:(CGPoint)position andDelegate:(id)delegate;
-(void)setColor:(NSString*)color;
-(void)updateAsset:(NSString*)filename;
-(void)updateCounter;

@end
