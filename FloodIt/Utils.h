//
//  Utils.h
//  FloodIt
//
//  Created by Satansdeer satansdeer on 27/11/13.
//
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

@property (nonatomic, retain) NSArray* availableColors;

+ (Utils *)sharedUtils;
+(NSString*)randomArrayElementFromArray:(NSArray*)array canBeEmpty:(BOOL)canBeEmpty;

@end
