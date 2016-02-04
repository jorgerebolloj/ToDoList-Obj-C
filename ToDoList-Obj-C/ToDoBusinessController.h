//
//  ToDoBusinessController.h
//  ToDoList-Obj-C
//
//  Created by Jorge Rebollo J on 04/02/16.
//  Copyright © 2016 Regall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToDoBusinessController : NSObject

@property (strong, nonatomic) NSMutableDictionary *existingItem;
@property (nonatomic) NSUInteger *currentItemRow;

- (NSString *)dateTimeConfiguration;
- (NSMutableArray *)setDate:(NSMutableArray *)pendingTasks;
- (void)storeNewItem:(NSMutableDictionary *)newItem;
- (void)editExistingItem:(NSMutableDictionary *)existingItem;
- (void)setExitingItem:(NSMutableDictionary *)existingItem withSelecteRow:(NSUInteger *)currentSelectedRow;

+ (ToDoBusinessController *)sharedInstance;

@end
