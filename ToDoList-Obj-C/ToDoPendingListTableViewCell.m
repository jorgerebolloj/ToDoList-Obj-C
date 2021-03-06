//
//  ToDoPendingListTableViewCell.m
//  ToDoList-Obj-C
//
//  Created by Jorge Rebollo J on 03/02/16.
//  Copyright © 2016 Regall. All rights reserved.
//

#import "ToDoPendingListTableViewCell.h"

@interface ToDoPendingListTableViewCell ()

@property (nonatomic, strong) NSMutableDictionary *toDoPendingModel;

@end

@implementation ToDoPendingListTableViewCell


- (void)setToDoPendingListModel:(NSMutableDictionary *)toDoPendingListInfo {
    self.toDoPendingModel = toDoPendingListInfo;
    [self reloadData];
}

- (void)reloadData {
    UIImage *pendingBtnImage = [UIImage imageNamed:@"taskCompleted512x512.png"];
    if ([[self.toDoPendingModel valueForKeyPath:@"status"] integerValue] == 1)
        [self.statusItemButton setBackgroundImage:pendingBtnImage forState:UIControlStateNormal];
    [self.itemTitleLabel setText:[[self.toDoPendingModel valueForKeyPath:@"title"] description]];
    [self.dateItemLabel setText:[NSString stringWithFormat:@"Modified: %@",[[self.toDoPendingModel valueForKeyPath:@"modifiedDate"] description]]];
    NSData* imageData = [self.toDoPendingModel valueForKeyPath:@"image"];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    [self.fullImageBtn setBackgroundImage:image forState:UIControlStateNormal];
}

@end
