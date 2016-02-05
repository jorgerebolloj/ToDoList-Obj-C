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

int currentPlaningItemRow = 0;
int currentCompletedItemRow = 0;

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

- (void)storeCompletedModel:(NSMutableArray *)completedModel {
    [[NSUserDefaults standardUserDefaults] setObject:completedModel forKey:@"toDoCompleteList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableArray *)requestPendingModel {
    NSMutableArray *pendingModel = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"toDoPendingList"] mutableCopy];
    return pendingModel;
}

- (NSMutableArray *)requestCompletedModel {
    NSMutableArray *completedModel = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"toDoCompleteList"] mutableCopy];
    return completedModel;
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
    storedToDoPendingList = [self setDate:storedToDoPendingList];
    [[NSUserDefaults standardUserDefaults] setObject:storedToDoPendingList forKey:@"toDoPendingList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)completeToDo:(NSMutableDictionary *)newItem {
    NSMutableArray *storedToDoCompleteList = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"toDoCompleteList"] mutableCopy];
    [storedToDoCompleteList addObject:newItem];
    storedToDoCompleteList = [self setDate:storedToDoCompleteList];
    [[NSUserDefaults standardUserDefaults] setObject:storedToDoCompleteList forKey:@"toDoCompleteList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)editExistingPlaningItem:(NSMutableDictionary *)updateExistingPlaningItem {
    NSMutableArray *existingToDoPendingList = [self.pendingTasks mutableCopy];
    [existingToDoPendingList replaceObjectAtIndex:currentPlaningItemRow withObject:updateExistingPlaningItem];
    existingToDoPendingList = [self setDate:existingToDoPendingList];
    [[NSUserDefaults standardUserDefaults] setObject:existingToDoPendingList forKey:@"toDoPendingList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)editExistingCompletedItem:(NSMutableDictionary *)updateExistingCompletedItem {
    NSMutableArray *existingToDoCompletedList = [self.completedTasks mutableCopy];
    [existingToDoCompletedList replaceObjectAtIndex:currentCompletedItemRow withObject:updateExistingCompletedItem];
    existingToDoCompletedList = [self setDate:existingToDoCompletedList];
    [[NSUserDefaults standardUserDefaults] setObject:existingToDoCompletedList forKey:@"toDoCompleteList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setExistingPendingItemToEdit:(NSMutableArray *)pendingTasks withSelecteRow:(int)currentSelectedRow andOriginList:(NSString *)originList {
    self.pendingTasks = pendingTasks;
    currentPlaningItemRow = currentSelectedRow;
    self.existingPlaningItem = [self.pendingTasks[currentPlaningItemRow] mutableCopy];
    self.originList = originList;
}

- (void)setExistingCompletedItemToEdit:(NSMutableArray *)completedTasks withSelecteRow:(int)currentSelectedRow andOriginList:(NSString *)originList {
    self.completedTasks = completedTasks;
    currentCompletedItemRow = currentSelectedRow;
    self.existingCompletedItem = [self.completedTasks[currentCompletedItemRow] mutableCopy];
    self.originList = originList;
}

@end
