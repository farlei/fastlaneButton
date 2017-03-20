//
//  Config.m
//  FastlaneButton
//
//  Created by Farlei Heinen on 20/03/17.
//  Copyright © 2017 FH. All rights reserved.
//

#import "Config.h"

@implementation Config

- (instancetype)init {
    self = [super init];
    if(self) {
        self.commands = @[];
    }
    return self;
}

- (instancetype)initWithDictionary: (NSDictionary *) dictionary {
    self = [super init];
    if(self) {
        NSMutableArray *array = [NSMutableArray new];
        if(dictionary != nil) {
            id jsonObject = dictionary[@"commands"];
            if([jsonObject isKindOfClass:[NSArray class]]) {
                for (NSDictionary* command in (NSArray *)jsonObject) {
                    [array addObject:[[Command alloc] initWithDictionary:command]];
                }
            }
        }
        self.commands = [NSArray arrayWithArray:array];
    }
    return self;
}

@end
