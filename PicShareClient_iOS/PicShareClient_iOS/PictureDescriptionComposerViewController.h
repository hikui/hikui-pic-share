//
//  PictureDescriptionComposerViewController.h
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-25.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PictureDescriptionComposerDelegate <NSObject>

-(void)descriptionDidCompose:(NSString *)theDescription;

@end

@interface PictureDescriptionComposerViewController : UIViewController

@property (nonatomic,retain) IBOutlet UITextView *descriptionTextView;
@property (nonatomic,copy) NSString *descriptionTextFromParent;
@property (nonatomic,assign) id<PictureDescriptionComposerDelegate> delegate;

-(id)initWithText:(NSString *)text;
@end
