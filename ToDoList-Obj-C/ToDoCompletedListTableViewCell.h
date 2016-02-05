//
//  ToDoCompletedListTableViewCell.h
//  ToDoList-Obj-C
//
//  Created by Jorge Rebollo J on 04/02/16.
//  Copyright © 2016 Regall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWTableViewCell.h>

@interface ToDoCompletedListTableViewCell : SWTableViewCell

- (void)setToDoCompletedListModel:(NSMutableDictionary *)toDoCompletedListInfo;

@property (weak, nonatomic) IBOutlet UIButton *statusItemButton;
@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateItemLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageItemImage;
@property (weak, nonatomic) IBOutlet UIButton *pendingToDoBtn;

@end
