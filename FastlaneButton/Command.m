//
//  Command.m
//  FastlaneButton
//
//  Created by Farlei Heinen on 20/03/17.
//  Copyright © 2017 FH. All rights reserved.
//

#import "Command.h"

@implementation Command

- (instancetype)initWithDictionary: (NSDictionary *) dictionary {
    self = [super init];
    if(self) {
        if(dictionary != nil) {
            self.name = dictionary[@"name"];
            self.appleScriptSource = dictionary[@"ascript"];
        }
    }
    return self;
}

@end
