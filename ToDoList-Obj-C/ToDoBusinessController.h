//
//  ToDoBusinessController.h
//  ToDoList-Obj-C
//
//  Created by Jorge Rebollo J on 04/02/16.
//  Copyright © 2016 Regall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToDoBusinessController : NSObject

@property (strong, nonatomic) NSMutableDictionary *existingPlaningItem;
@property (strong, nonatomic) NSMutableDictionary *existingCompletedItem;
@property (strong, nonatomic) NSString *originList;

- (void)storePendingModel:(NSMutableArray *)pendingModel;
- (void)storeCompletedModel:(NSMutableArray *)completedModel;
- (NSMutableArray *)requestPendingModel;
- (NSMutableArray *)requestCompletedModel;
- (NSString *)dateTimeConfiguration;
- (NSMutableArray *)setDate:(NSMutableArray *)pendingTasks;
- (void)storeNewItem:(NSMutableDictionary *)newItem;
- (void)completeToDo:(NSMutableDictionary *)newItem;
- (void)editExistingPlaningItem:(NSMutableDictionary *)updateExistingPlaningItem;
- (void)editExistingCompletedItem:(NSMutableDictionary *)updateExistingCompletedItem;
- (void)setExistingPendingItemToEditWithSelecteRow:(int)currentSelectedRow andOriginList:(NSString *)originList;
- (void)setExistingCompletedItemToEditWithSelecteRow:(int)currentSelectedRow andOriginList:(NSString *)originList;

+ (ToDoBusinessController *)sharedInstance;

@end
