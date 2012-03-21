//
//  PictureEditViewController.h
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-21.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureEditViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic,retain) IBOutlet UIImageView *imageView;
@property (nonatomic,retain) NSArray *decoratorImages;
@property (nonatomic,retain) NSMutableArray *onBoardDecoratorImages;
@property (nonatomic,retain) IBOutlet UIScrollView *scrollView;

-(void)finishButtonOnTouch;
-(IBAction)decorateImageOnTouch:(id)sender;
-(IBAction)clearButtonOnTouch:(id)sender;
@end
