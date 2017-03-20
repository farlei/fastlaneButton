//
//  Command.h
//  FastlaneButton
//
//  Created by Farlei Heinen on 20/03/17.
//  Copyright © 2017 FH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Command : NSObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *appleScriptSource;

- (instancetype)initWithDictionary: (NSDictionary *) dictionary;

@end
