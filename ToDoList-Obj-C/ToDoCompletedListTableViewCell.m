//
//  ToDoCompletedListTableViewCell.m
//  ToDoList-Obj-C
//
//  Created by Jorge Rebollo J on 04/02/16.
//  Copyright © 2016 Regall. All rights reserved.
//

#import "ToDoCompletedListTableViewCell.h"

@interface ToDoCompletedListTableViewCell ()

@property (nonatomic, strong) NSMutableDictionary *toDoCompletedModel;

@end

@implementation ToDoCompletedListTableViewCell

- (void)setToDoCompletedListModel:(NSMutableDictionary *)toDoCompletedListInfo {
    self.toDoCompletedModel = toDoCompletedListInfo;
    [self reloadData];
}

- (void)reloadData {
    UIImage *completedBtnImage = [UIImage imageNamed:@"taskCompleted512x512.png"];
    if ([[self.toDoCompletedModel valueForKeyPath:@"status"] integerValue] == 1)
        [self.statusItemButton setBackgroundImage:completedBtnImage forState:UIControlStateNormal];
    [self.itemTitleLabel setText:[[self.toDoCompletedModel valueForKeyPath:@"title"] description]];
    [self.dateItemLabel setText:[NSString stringWithFormat:@"Modified: %@",[[self.toDoCompletedModel valueForKeyPath:@"modifiedDate"] description]]];
    NSData* imageData = [self.toDoCompletedModel valueForKeyPath:@"image"];
    UIImage *image = [UIImage imageWithData:imageData];
    [self.fullImageBtn setBackgroundImage:image forState:UIControlStateNormal];
}

@end
