//
//  FloodItem.h
//  FloodIt
//
//  Created by Satansdeer satansdeer on 06.07.13.
//
//

#import "cocos2d.h"

@protocol FloodItemDelegate
-(void)floodItemTapped:(id)item;
@end

@interface FloodItem : CCSprite <CCTouchOneByOneDelegate>

@property (nonatomic, assign) CGPoint positionInGame;
@property (nonatomic, assign) NSString* filename;
@property (nonatomic, assign) id myDelegate;
@property (nonatomic, assign) BOOL isInWinGroup;

-(id)initWithFile:(NSString*)filename position:(CGPoint)position andDelegate:(id)delegate;
-(void)updateToFilename:(NSString*)file;

@end
