//
//  HIDController.m
//  FastlaneButton
//
//  Created by Farlei Heinen on 15/03/17.
//  Copyright © 2017 FH. All rights reserved.
//

#import "HIDController.h"
#import "hid.h"

static int const dataBufferSize = 64;
static int const receiveTimeout = 220;
static int const vendorID = 0x16C0;
static int const productID = 0x0486;
static int const pageAddr = 0xFFAB;
static int const usageRange = 0x0200;
static int const sleepTime = 5000000; // 5 secs
static int const maxCommands = 6; // maximum number of commands (phisicly limited by the hardware)

typedef enum : NSUInteger {
    HIDDataIndexSwitch0 = 2,
    HIDDataIndexSwitch1,
    HIDDataIndexSwitch2,
    HIDDataIndexSwitch3,
    HIDDataIndexSwitch4,
    HIDDataIndexSwitch5,
    HIDDataIndexSafeSwitch,
    HIDDataIndexMainButton
} HIDDataIndex;

typedef struct _HIDData {
    BOOL selectorSwitch[maxCommands];
    BOOL safeSwitch;
    BOOL mainButton;
} HIDData;

@implementation HIDController

- (void) mapData: (HIDData *) data fromBuffer: (unsigned char *)buffer
{
    for(int i = 0; i < maxCommands; i++) {
        data->selectorSwitch[i] = !(BOOL)buffer[HIDDataIndexSwitch0 + i];
    }
    data->safeSwitch = (BOOL)buffer[HIDDataIndexSafeSwitch];
    data->mainButton = (BOOL)buffer[HIDDataIndexMainButton];
}

- (void) processData: (HIDData) data {
    
    // Check if some command is selected
    BOOL noSelection = true;
    int newCommandIndex = maxCommands;
    for(int i = 0; i < maxCommands; i++) {
        if(data.selectorSwitch[i]) {
            noSelection = false;
            newCommandIndex = i;
        }
    }
    if(noSelection) return;
    
    // Check if the selected command is configured
    if(newCommandIndex >= self.config.commands.count) return;
    
    if(self.activeCommandIndex != newCommandIndex) {
        self.activeCommandIndex = newCommandIndex;
        Command *command = self.config.commands[self.activeCommandIndex];
        [self showNotificationWithTitle:@"Command selected" andMessage:command.name];
    }
    
    if(data.mainButton) {
        NSLog(@"button pressed");
        Command *command = self.config.commands[self.activeCommandIndex];
        NSLog(@"%@", command.name);
        NSLog(@"%@", command.appleScriptSource);
        [self runScript:command.appleScriptSource];
    }
}

- (void) showNotificationWithTitle: (NSString*) title andMessage: (NSString *) message
{
    NSString *scriptSource = [NSString stringWithFormat:@"display notification \"%@\" with title \"%@\"", message, title];
    [self runScript:scriptSource];
}

- (void) runScript: (NSString *) scriptSource
{
    NSAppleScript *script = [[NSAppleScript alloc] initWithSource:scriptSource];
    NSDictionary *errorDict = nil;
    [script executeAndReturnError:&errorDict];
}

- (BOOL) loadConfig
{
    NSURL *homePath = [[NSFileManager defaultManager] homeDirectoryForCurrentUser];
    NSString *configFilePath = @".fbutton/fbutton.json";
    
    NSURL *path = [homePath URLByAppendingPathComponent:configFilePath];
    
    NSString *pathString = [[NSString alloc] initWithUTF8String:[path fileSystemRepresentation]];
    NSLog(@"%@",pathString);
    
    NSData *jsonData = [NSData dataWithContentsOfFile:pathString];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    if([jsonObject isKindOfClass:[NSDictionary class]]) {
        self.config = [[Config alloc] initWithDictionary:(NSDictionary *)jsonObject];
    } else {
        self.config = [Config new];
    }
    
    return YES;
}

- (void) start
{
    [self loadConfig];
    
    self.activeCommandIndex = 0;
    
    while(true) {
        int response = rawhid_open(1, vendorID, productID, pageAddr, usageRange);
        if(response <= 0) {
            NSLog(@"error connecting to HID device");
            usleep(sleepTime);
        }
        
        while(true) {
            HIDData status;
            unsigned char dataBuffer[dataBufferSize];
            
            int bytesReceived = rawhid_recv(0, dataBuffer, dataBufferSize, receiveTimeout);
            if (bytesReceived < 0) {
                NSLog(@"error reading from HID device");
                rawhid_close(0);
                usleep(sleepTime);
                break;
            }
            if (bytesReceived > 0) {
                
                [self mapData:&status fromBuffer:dataBuffer];
                [self processData:status];
            }
        }
    }
}

@end
