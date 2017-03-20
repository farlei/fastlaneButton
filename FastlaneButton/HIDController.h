//
//  HIDController.h
//  FastlaneButton
//
//  Created by Farlei Heinen on 15/03/17.
//  Copyright © 2017 FH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"

@interface HIDController : NSObject

@property(nonatomic, strong) Config *config;
@property(nonatomic) int activeCommandIndex;

- (void) start;

@end
