//
//  Utils.m
//  FloodIt
//
//  Created by Satansdeer satansdeer on 27/11/13.
//
//

#import "Utils.h"

@implementation Utils

+ (Utils *)sharedUtils {
    static Utils *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[Utils alloc] init];
    });
    return _sharedClient;
}

+(NSString*)randomArrayElementFromArray:(NSArray*)array canBeEmpty:(BOOL)canBeEmpty{
    int r;
    if(canBeEmpty){
        r = arc4random() % array.count+1;
    }else{
        r = arc4random() % array.count;
    }
    if(r<array.count){
        return array[r];
    }else{
        return nil;
    }
}

@end
