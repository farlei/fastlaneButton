//
//  Config.h
//  FastlaneButton
//
//  Created by Farlei Heinen on 20/03/17.
//  Copyright © 2017 FH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Command.h"

@interface Config : NSObject

@property(nonatomic, strong) NSArray *commands;

- (instancetype)initWithDictionary: (NSDictionary *) dictionary;

@end
