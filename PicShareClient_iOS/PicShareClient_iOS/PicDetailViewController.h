//
//  PicDetailViewController.h
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-12.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureStatus.h"

@interface PicDetailViewController : UIViewController
{
    UIView *loadingView;
    UIActivityIndicatorView *loadingIndicator;
}

@property (readwrite) NSInteger picId;
@property (nonatomic,retain) PictureStatus *pictureStatus;

- (id)initWithPicId:(NSInteger)aPicId;
- (void)usernameButtonOnClick:(id)sender;
- (void)boardNameButtonOnClick:(id)sender;
- (void)viaButtonOnClick:(id)sender;
- (void)repinButtonOnClick:(id)sender;

@end
