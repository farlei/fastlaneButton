//
//  main.m
//  FastlaneButton
//
//  Created by Farlei Heinen on 15/03/17.
//  Copyright © 2017 FH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HIDController.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        HIDController *hidController = [HIDController new];
        [hidController start];
        
    }
    return 0;
}
