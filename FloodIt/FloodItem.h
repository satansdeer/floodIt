//
//  FloodItem.h
//  FloodIt
//
//  Created by Satansdeer satansdeer on 06.07.13.
//
//

#import "cocos2d.h"

@interface FloodItem : CCSprite <CCTouchOneByOneDelegate>

@property (nonatomic, assign) CGPoint positionInGame;
@property (nonatomic, assign) NSString* filename;
@property (nonatomic, assign) id myDelegate;
@property (nonatomic, assign) BOOL isInWinGroup;
@property (nonatomic, retain) CCSprite*image;
@property (nonatomic, assign) CGSize tileSize;
@property (nonatomic, retain) NSString*currentColor;

-(id)initWithFile:(NSString*)filename position:(CGPoint)position andDelegate:(id)delegate;
-(void)updateToFilename:(NSString*)file;
-(void)setColor:(NSString*)color;
-(void)updateAsset:(NSString*)filename;
@end
