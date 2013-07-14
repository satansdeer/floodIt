//
//  GameModel.h
//  FloodIt
//
//  Created by Satansdeer satansdeer on 10.07.13.
//
//

#import <Foundation/Foundation.h>

@interface GameModel : NSObject

@property (nonatomic,assign) int score;
@property (nonatomic,assign) int turns;
@property (nonatomic,assign) int level;
@property (nonatomic,assign) int money;
@property (nonatomic,assign) int energyPacks;
@property (nonatomic,assign) int highScore;

@property (nonatomic,retain) NSArray*levels;

+ (GameModel *)sharedModel;

@end
