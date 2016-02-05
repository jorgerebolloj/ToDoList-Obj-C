//
//  ToDoBusinessController.h
//  ToDoList-Obj-C
//
//  Created by Jorge Rebollo J on 04/02/16.
//  Copyright © 2016 Regall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToDoBusinessController : NSObject

@property (strong, nonatomic) NSMutableArray *pendingTasks;
@property (strong, nonatomic) NSMutableDictionary *existingItem;

- (void)storePendingModel:(NSMutableArray *)pendingModel;
- (NSMutableArray *)requestPendingModel;
- (NSString *)dateTimeConfiguration;
- (NSMutableArray *)setDate:(NSMutableArray *)pendingTasks;
- (void)storeNewItem:(NSMutableDictionary *)newItem;
- (void)editExistingItem:(NSMutableDictionary *)updateExistingItem;
- (void)setExitingItemToEdit:(NSMutableArray *)pendingTasks withSelecteRow:(int)currentSelectedRow;

+ (ToDoBusinessController *)sharedInstance;

@end
