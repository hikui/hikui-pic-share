//
//  BoardsListCell.m
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-5.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "BoardsListCell.h"

@implementation BoardsListCell

@synthesize boardNameLabel = _boardNameLabel;
@synthesize moreLabel = _moreLabel;
@synthesize boardPictures = _boardPictures;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _boardNameLabel = [[UILabel alloc]init];
        _moreLabel = [[UILabel alloc]init];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateFrame
{
}

- (void)dealloc
{
    [_boardNameLabel release];
    [_moreLabel release];
    [super dealloc];
}

@end
