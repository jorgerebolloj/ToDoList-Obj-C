//
//  ToDoPendingListTableViewCell.h
//  ToDoList-Obj-C
//
//  Created by Jorge Rebollo J on 03/02/16.
//  Copyright © 2016 Regall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWTableViewCell.h>

@interface ToDoPendingListTableViewCell : SWTableViewCell

- (void)setToDoPendingListModel:(NSMutableDictionary *)toDoPendingListInfo;

@property (weak, nonatomic) IBOutlet UIButton *statusItemButton;
@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateItemLabel;
@property (weak, nonatomic) IBOutlet UIButton *fullImageBtn;

@end
