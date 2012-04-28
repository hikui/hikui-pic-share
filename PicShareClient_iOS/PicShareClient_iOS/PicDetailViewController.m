//
//  PicDetailViewController.m
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-12.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "PicDetailViewController.h"
#import "PicDetailView.h"
#import "PicShareEngine.h"
#import "UserDetailViewController.h"
#import "Common.h"
#import "BoardDetailViewController.h"
#import "PictureInfoEditViewController.h"
#import "CommentsListViewController.h"
#import "MBProgressHUD.h"

//TODO: implement methods

@interface PicDetailViewController ()

- (void)loadData;
- (void)loadDataDidFinish:(PictureStatus *)returnedStatus;
- (void)report;
- (void)deletePicture;

@end

@implementation PicDetailViewController
@synthesize picId, pictureStatus;

- (void)dealloc
{
    [loadingIndicator release];
    [loadingView release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (id)initWithPicId:(NSInteger)aPicId
{
    self = [super init];
    if (self) {
        picId = aPicId;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)loadView
{
    if (self.pictureStatus == nil) {
        loadingView = [[UIView alloc]init];
        CGRect screenBounds = [UIScreen mainScreen].bounds;
        CGFloat x = screenBounds.size.width/2 - 10;
        CGFloat y = screenBounds.size.height/2 - 10-50;
        loadingIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadingIndicator.frame = CGRectMake(x, y, 20, 20);
        loadingIndicator.hidesWhenStopped = YES;
        [loadingView addSubview:loadingIndicator];
        self.view = loadingView;
    }else {
        PicDetailView *detailView = [[PicDetailView alloc]initWithPictureStatus:self.pictureStatus];
        self.view = detailView;
        //set target-actions
        [detailView.usernameButton addTarget:self action:@selector(usernameButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [detailView.boardNameButton addTarget:self action:@selector(boardNameButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [detailView.viaButton addTarget:self action:@selector(viaButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [detailView.repinButton addTarget:self action:@selector(repinButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [detailView.showAllCommentsButton addTarget:self action:@selector(allCommentsButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [detailView release];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.pictureStatus == nil) {
        [loadingIndicator startAnimating];
        [self performSelectorInBackground:@selector(loadData) withObject:nil];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;s
    [loadingView release];
    loadingView = nil;
    [loadingIndicator release];
    loadingIndicator = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - async load data methods

- (void)loadData
{
    //调用方法时直接使用了performSelectorInBackground，所以需要手动开一个autoreleasepool
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    PicShareEngine *engine = [PicShareEngine sharedEngine];
    PictureStatus * returnedStatus = [engine getPictureStatus:picId];
    [self performSelectorOnMainThread:@selector(loadDataDidFinish:) withObject:returnedStatus waitUntilDone:YES];
    [pool release];
}

- (void)loadDataDidFinish:(PictureStatus *)returnedStatus
{
    self.pictureStatus = returnedStatus;
    [loadingIndicator stopAnimating];
    PicDetailView *detailView = [[PicDetailView alloc]initWithPictureStatus:self.pictureStatus];
    self.view = detailView;
    //set target-actions
    [detailView.usernameButton addTarget:self action:@selector(usernameButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [detailView.boardNameButton addTarget:self action:@selector(boardNameButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [detailView.viaButton addTarget:self action:@selector(viaButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [detailView.repinButton addTarget:self action:@selector(repinButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [detailView.showAllCommentsButton addTarget:self action:@selector(allCommentsButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [detailView.moreButton addTarget:self action:@selector(moreButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [detailView release];
    
}

- (void)report
{
    
}
- (void)deletePicture
{

//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//        PicShareEngine *engine = [PicShareEngine sharedEngine];
//        ErrorMessage *em = [engine deletePictureStatus:self.pictureStatus.psId];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (em!=nil && em.ret==0 && em.errorcode == 0) {
//                //send notification
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"DeletedPic" object:[NSNumber numberWithInt:self.pictureStatus.psId]];
//                [self.navigationController popViewControllerAnimated:YES];
//            }else{
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:em.errorMsg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
//                [alert show];
//                [alert release];
//            }
//        });
//    });
}

#pragma mark - IBActions
- (void)usernameButtonOnClick:(id)sender
{
    UserDetailViewController *userDetailViewController = [[UserDetailViewController alloc]initWithUser:pictureStatus.owner];
    [self.navigationController pushViewController:userDetailViewController animated:YES];
    [userDetailViewController release];
}
- (void)boardNameButtonOnClick:(id)sender
{
    BoardDetailViewController *bdvc = [[BoardDetailViewController alloc]initWithNibName:@"BoardDetailViewController" bundle:nil];
    bdvc.boardId = self.pictureStatus.boardId;
    [self.navigationController pushViewController:bdvc animated:YES];
    [bdvc release];
}
- (void)viaButtonOnClick:(id)sender
{
    UserDetailViewController *userDetailViewController = [[UserDetailViewController alloc]initWithUser:pictureStatus.via];
    [self.navigationController pushViewController:userDetailViewController animated:YES];
    [userDetailViewController release];
}
- (void)repinButtonOnClick:(id)sender
{
    PictureInfoEditViewController *pievc = [[PictureInfoEditViewController alloc]initWithNibName:@"PictureInfoEditViewController" bundle:nil];
    pievc.repinPs = self.pictureStatus;
    pievc.type = REPIN;
    [self.navigationController pushViewController:pievc animated:YES];
    [pievc release];
}

- (void)allCommentsButtonOnClick:(id)sender
{
    NSLog(@"allCommentsButtonOnClick");
    CommentsListViewController *clvc = [[CommentsListViewController alloc]initWithPsId:self.pictureStatus.psId];
    [self.navigationController pushViewController:clvc animated:YES];
    [clvc release];
}

- (void)moreButtonOnClick:(id)sender
{
    UIActionSheet *sheet;
    NSInteger userId = [[NSUserDefaults standardUserDefaults]integerForKey:@"userid"];
    if (self.pictureStatus.owner.userId == userId) {
        sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:@"举报", nil];
    }else{
        sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"举报" otherButtonTitles:nil];
    }
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    [sheet showInView:window];
    [sheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d",buttonIndex);
    NSInteger userId = [[NSUserDefaults standardUserDefaults]integerForKey:@"userid"];
    if (self.pictureStatus.owner.userId == userId) {
        //0：删除 1：举报 2：取消
        switch (buttonIndex) {
            case 0:
                [self deletePicture];
                break;
            case 1:
                break; 
            case 2:
                break; 
            default:
                break;
        }
    }else{
        //0：举报 1：取消
        switch (buttonIndex) {
            case 0:
                break;
            case 1:
                break; 
            default:
                break;
        }
    }
}

@end
