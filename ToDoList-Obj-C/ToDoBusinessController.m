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
    [[NSUserDefaults standardUserDefaults] setObject:completedModel forKey:@"toDoCompletedList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableArray *)requestPendingModel {
    NSMutableArray *pendingModel = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"toDoPendingList"] mutableCopy];
    return pendingModel;
}

- (NSMutableArray *)requestCompletedModel {
    NSMutableArray *completedModel = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"toDoCompletedList"] mutableCopy];
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
    NSMutableArray *storedToDoPendingList = [[self requestPendingModel] mutableCopy];
    [storedToDoPendingList addObject:newItem];
    storedToDoPendingList = [self setDate:storedToDoPendingList];
    [self storePendingModel:storedToDoPendingList];
}

- (void)completeToDo:(NSMutableDictionary *)newItem {
    NSMutableArray *storedToDoCompleteList = [[self requestCompletedModel] mutableCopy];
    [storedToDoCompleteList addObject:newItem];
    storedToDoCompleteList = [self setDate:storedToDoCompleteList];
    [self storeCompletedModel:storedToDoCompleteList];
}

- (void)editExistingPlaningItem:(NSMutableDictionary *)updateExistingPlaningItem {
    NSMutableArray *existingToDoPendingList = [[self requestPendingModel] mutableCopy];
    [existingToDoPendingList replaceObjectAtIndex:currentPlaningItemRow withObject:updateExistingPlaningItem];
    existingToDoPendingList = [self setDate:existingToDoPendingList];
    [self storePendingModel:existingToDoPendingList];
}

- (void)editExistingCompletedItem:(NSMutableDictionary *)updateExistingCompletedItem {
    NSMutableArray *existingToDoCompletedList = [[self requestCompletedModel] mutableCopy];
    [existingToDoCompletedList replaceObjectAtIndex:currentCompletedItemRow withObject:updateExistingCompletedItem];
    existingToDoCompletedList = [self setDate:existingToDoCompletedList];
    [self storeCompletedModel:existingToDoCompletedList];
}

- (void)setExistingPendingItemToEditWithSelecteRow:(int)currentSelectedRow andOriginList:(NSString *)originList {
    NSMutableArray *existingToDoPendingList = [[self requestPendingModel] mutableCopy];
    currentPlaningItemRow = currentSelectedRow;
    self.existingPlaningItem = [existingToDoPendingList[currentPlaningItemRow] mutableCopy];
    self.originList = originList;
}

- (void)setExistingCompletedItemToEditWithSelecteRow:(int)currentSelectedRow andOriginList:(NSString *)originList {
    NSMutableArray *existingToDoCompletedList = [[self requestCompletedModel] mutableCopy];
    currentCompletedItemRow = currentSelectedRow;
    self.existingCompletedItem = [existingToDoCompletedList[currentCompletedItemRow] mutableCopy];
    self.originList = originList;
}

@end
