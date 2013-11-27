//
//  Utils.m
//  FloodIt
//
//  Created by Satansdeer satansdeer on 27/11/13.
//
//

#import "Utils.h"

@implementation Utils

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
