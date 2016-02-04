//
//  ToDoBusinessController.m
//  ToDoList-Obj-C
//
//  Created by Jorge Rebollo J on 04/02/16.
//  Copyright © 2016 Regall. All rights reserved.
//

#import "ToDoBusinessController.h"

@implementation ToDoBusinessController

+ (ToDoBusinessController *)sharedInstance {
    static dispatch_once_t onceToken;
    static ToDoBusinessController *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[ToDoBusinessController alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSString *)dateTimeConfiguration {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString *timeString = [formatter stringFromDate:date];
    return timeString;
}

- (NSMutableArray *)setDate:(NSMutableArray *)pendingTasks {
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"modifiedDate" ascending:YES];
    pendingTasks = [[pendingTasks sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]] mutableCopy];
    NSMutableArray *pendingTasksSorted = pendingTasks;
    return pendingTasksSorted;
}

- (void)storeNewItem:(NSMutableDictionary *)newItem {
    NSMutableArray *storedToDoPendingList = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"toDoPendingList"] mutableCopy];
    [storedToDoPendingList addObject:newItem];
    [[NSUserDefaults standardUserDefaults] setObject:storedToDoPendingList forKey:@"toDoPendingList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)editExistingItem:(NSMutableDictionary *)existingItem {
    NSMutableArray *existingToDoPendingList = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"toDoPendingList"] mutableCopy];
    [existingToDoPendingList replaceObjectAtIndex:self.currentItemRow withObject:existingItem];
    existingToDoPendingList = [self setDate:existingToDoPendingList];
    [[NSUserDefaults standardUserDefaults] setObject:existingToDoPendingList forKey:@"toDoPendingList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setExitingItem:(NSMutableDictionary *)existingItem withSelecteRow:(NSUInteger *)currentSelectedRow {
    self.existingItem = existingItem;
    self.currentItemRow = currentSelectedRow;
}

@end
