//
//  PictureDescriptionComposerViewController.h
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-25.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _presentType{
    MODAL = 0,
    NAVIGATION
} PresentType;

@class SingleTextInputViewController;
@protocol SingleTextInputDelegate <NSObject>

-(void)SingleTextInputViewController:(SingleTextInputViewController *)controller textDidCompose:(NSString *)text;

@end

/**
 单个TextView，用于输入PictureInfo的详细信息
 */
@interface SingleTextInputViewController : UIViewController

@property (nonatomic,retain) IBOutlet UITextView *descriptionTextView;
@property (nonatomic,copy) NSString *descriptionTextFromParent;
@property (nonatomic,assign) id<SingleTextInputDelegate> delegate;
@property (nonatomic) PresentType presentType;
@property (nonatomic) NSInteger tag;

-(id)initWithText:(NSString *)text;
@end
