//
//  ToDoBusinessController.m
//  ToDoList-Obj-C
//
//  Created by Jorge Rebollo J on 04/02/16.
//  Copyright © 2016 Regall. All rights reserved.
//

#import "ToDoBusinessController.h"

id getMutableElement(id element)
{
    return (__bridge NSDictionary *) (CFPropertyListCreateDeepCopy(kCFAllocatorDefault,
                                                                   (__bridge CFPropertyListRef) (element),
                                                                   kCFPropertyListMutableContainersAndLeaves));
}

int currentItemRow = 0;

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

- (void)storePendingModel:(NSMutableArray *)pendingModel {
    [[NSUserDefaults standardUserDefaults] setObject:pendingModel forKey:@"toDoPendingList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableArray *)requestPendingModel {
    NSMutableArray *pendingModel = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"toDoPendingList"] mutableCopy];
    return pendingModel;
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
    pendingTasks = [[pendingTasks sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]]mutableCopy];
    NSMutableArray *pendingTasksM = [[NSMutableArray alloc]init];
    for (NSDictionary *item in pendingTasks)
            [pendingTasksM addObject:[item mutableCopy]];
    for (int i=0; i < [pendingTasksM count]; i++)
        [pendingTasksM[i] setObject:@(i) forKey:@"id"];
    NSMutableArray *pendingTasksSorted = pendingTasksM;
    return pendingTasksSorted;
}

- (void)storeNewItem:(NSMutableDictionary *)newItem {
    NSMutableArray *storedToDoPendingList = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"toDoPendingList"] mutableCopy];
    [storedToDoPendingList addObject:newItem];
    [[NSUserDefaults standardUserDefaults] setObject:storedToDoPendingList forKey:@"toDoPendingList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)editExistingItem:(NSMutableDictionary *)updateExistingItem {
    NSMutableArray *existingToDoPendingList = [self.pendingTasks mutableCopy];
    [existingToDoPendingList replaceObjectAtIndex:currentItemRow withObject:updateExistingItem];
    existingToDoPendingList = [self setDate:existingToDoPendingList];
    [[NSUserDefaults standardUserDefaults] setObject:existingToDoPendingList forKey:@"toDoPendingList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setExitingItemToEdit:(NSMutableArray *)pendingTasks withSelecteRow:(int)currentSelectedRow {
    self.pendingTasks = pendingTasks;
    currentItemRow = currentSelectedRow;
    self.existingItem = self.pendingTasks[currentItemRow];
}

@end
