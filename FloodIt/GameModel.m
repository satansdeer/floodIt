//
//  GameModel.m
//  FloodIt
//
//  Created by Satansdeer satansdeer on 10.07.13.
//
//

#import "GameModel.h"

@implementation GameModel

+ (GameModel *)sharedModel {
    static GameModel *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[GameModel alloc] init];
    });
    return _sharedClient;
}

-(id)init{
    if(self = [super init]){
        self.level = 1;
        self.turns = 125;
        self.levels = @[@{@"tilesNum":@6, @"colors":@[@"red.png",@"green.png",@"blue.png"]},
                        @{@"tilesNum":@6, @"colors":@[@"red.png",@"green.png",@"blue.png",@"yellow.png"]},
                        @{@"tilesNum":@6, @"colors":@[@"red.png",@"green.png",@"blue.png",@"yellow.png",@"purple.png"]},
                        @{@"tilesNum":@6, @"colors":@[@"red.png",@"green.png",@"blue.png",@"yellow.png",@"orange.png"]},
                        @{@"tilesNum":@7, @"colors":@[@"red.png",@"green.png",@"blue.png",@"yellow.png",@"orange.png",@"purple.png"]},
                        @{@"tilesNum":@8, @"colors":@[@"red.png",@"green.png",@"blue.png",@"yellow.png",@"orange.png",@"purple.png"]},
                        @{@"tilesNum":@9, @"colors":@[@"red.png",@"green.png",@"blue.png",@"yellow.png",@"orange.png",@"purple.png"]},
                        @{@"tilesNum":@10, @"colors":@[@"red.png",@"green.png",@"blue.png",@"yellow.png",@"orange.png",@"purple.png"]},
                        @{@"tilesNum":@11, @"colors":@[@"red.png",@"green.png",@"blue.png",@"yellow.png",@"orange.png",@"purple.png"]},
                        @{@"tilesNum":@12, @"colors":@[@"red.png",@"green.png",@"blue.png",@"yellow.png",@"orange.png",@"purple.png"]},
                        @{@"tilesNum":@13, @"colors":@[@"red.png",@"green.png",@"blue.png",@"yellow.png",@"orange.png",@"purple.png"]},
                        @{@"tilesNum":@14, @"colors":@[@"red.png",@"green.png",@"blue.png",@"yellow.png",@"orange.png",@"purple.png"]},
                        @{@"tilesNum":@15, @"colors":@[@"red.png",@"green.png",@"blue.png",@"yellow.png",@"orange.png",@"purple.png"]},
                        @{@"tilesNum":@16, @"colors":@[@"red.png",@"green.png",@"blue.png",@"yellow.png",@"orange.png",@"purple.png"]},
                        @{@"tilesNum":@17, @"colors":@[@"red.png",@"green.png",@"blue.png",@"yellow.png",@"orange.png",@"purple.png"]},
                        @{@"tilesNum":@18, @"colors":@[@"red.png",@"green.png",@"blue.png",@"yellow.png",@"orange.png",@"purple.png"]},
                        @{@"tilesNum":@19, @"colors":@[@"red.png",@"green.png",@"blue.png",@"yellow.png",@"orange.png",@"purple.png"]},
                        @{@"tilesNum":@19, @"colors":@[@"red.png",@"green.png",@"blue.png",@"yellow.png",@"orange.png",@"purple.png"]}
                        ];
    }
    return self;
}

@end
