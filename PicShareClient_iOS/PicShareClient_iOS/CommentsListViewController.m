//
//  CommentsListViewController.m
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-4-22.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "CommentsListViewController.h"
#import "PicShareEngine.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "Common.h"
@interface CommentsListViewController ()

- (void)loadData;
- (void)addComment:(NSString *)text;
- (void)pageData;
- (void)toggleEdit;
- (void)deleteComment:(Comment *)comment;
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;

@end

@implementation CommentsListViewController
@synthesize tableView,commentTF,commentCell,comments,psId,hasNext,currentPage,ps,flagId,tfBarOriginY;

- (void)dealloc
{
    [tableView release];
    [commentTF release];
    [comments release];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithPsId:(NSInteger)thePsId
{
    self = [super initWithNibName:@"CommentsListViewController" bundle:nil];
    if (self) {
        self.psId = thePsId;
        self.hasNext = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleEdit)]autorelease];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    tfBarOriginY = self.commentTF.superview.frame.origin.y;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tableView = nil;
    self.comments = nil;
    self.commentTF = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)toggleEdit
{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}

#pragma mark - tableview delegate and datasource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.comments.count) {
        return 40;
    }
    Comment *theComment = [self.comments objectAtIndex:indexPath.row];
    CGSize textSize = [theComment.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(236, 9999) lineBreakMode:UILineBreakModeWordWrap];
    
    return MAX(72.0f, textSize.height+40);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.comments==nil) {
        return 0;
    }
    return self.comments.count+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == self.comments.count) {
        UITableViewCell *cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil]autorelease];
        cell.textLabel.text = @"更多";
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        if (!hasNext) {
            [cell.textLabel setHidden:YES];
        }
        return cell;
    }
    
    
    
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        [[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil];
        cell = self.commentCell;
        self.commentCell = nil;
    }
    Comment *theComment = [self.comments objectAtIndex:indexPath.row];
    UIButton *nameButton = (UIButton *)[cell viewWithTag:1];
    UILabel *commentText = (UILabel *)[cell viewWithTag:2];
    UIImageView *avatar = (UIImageView *)[cell viewWithTag:3];
    NSString *avatarStr;
    if (IS_RETINA) {
        avatarStr = [theComment.by.avatarUrl stringByAppendingString:@"?size=120"];
    }else {
        avatarStr = [theComment.by.avatarUrl stringByAppendingString:@"?size=60"];
    }
    [avatar setImageWithURL:[NSURL URLWithString:avatarStr] placeholderImage:[UIImage imageNamed:@"anonymous.png"]];
    [nameButton setTitle:theComment.by.username forState:UIControlStateNormal];
    CGSize textSize = [theComment.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(236, 9999) lineBreakMode:UILineBreakModeWordWrap];
    CGRect textFrame = commentText.frame;
    textFrame.size = textSize;
    commentText.frame = textFrame;
    commentText.text = theComment.text;
    
    return cell;
}

-(void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.commentTF resignFirstResponder];
    [theTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == self.comments.count && self.hasNext) {
        [self pageData];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.comments.count) {
        return NO;
    }
    PicShareEngine *engine = [PicShareEngine sharedEngine];
    if (self.ps.owner.userId == engine.userId) {
        return YES;
    }
    Comment *c = [self.comments objectAtIndex:indexPath.row];
    if (c.by.userId == engine.userId) {
        return YES;
    }
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Comment *commnetToDelete = [self.comments objectAtIndex:indexPath.row];
        [self deleteComment:commnetToDelete];
        NSArray *paths = [[NSArray alloc]initWithObjects:indexPath, nil];
        [self.comments removeObjectAtIndex:indexPath.row];
        self.flagId = ((Comment *)[self.comments objectAtIndex:0]).commentId;
        [self.tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationLeft];
        [paths release];
    }
}

#pragma mark - TF delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    NSTimeInterval animationDuration = 0.30f;      
//    CGRect frame = self.commentTF.superview.frame;  
//    frame.origin.y -=166;  
//    [UIView beginAnimations:@"ResizeView" context:nil];  
//    [UIView setAnimationDuration:animationDuration];  
//    self.commentTF.superview.frame = frame;                   
//    [UIView commitAnimations];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.commentTF resignFirstResponder];
    NSString *commentText = commentTF.text;
    [self addComment:commentText];
    return YES;
}

//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    NSTimeInterval animationDuration = 0.30f;      
//    CGRect frame = self.commentTF.superview.frame;  
//    frame.origin.y +=166;  
//    [UIView beginAnimations:@"ResizeView" context:nil];  
//    [UIView setAnimationDuration:animationDuration];  
//    self.commentTF.superview.frame = frame;                   
//    [UIView commitAnimations];
//}

#pragma mark - detect keyboard

- (void)keyboardWillShow:(NSNotification *)notification
{
    //NSLog(@"keyboard will show");
    NSDictionary* userInfo = [notification userInfo];
    // get the size of the keyboard
    NSValue* boundsValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [boundsValue CGRectValue].size;
    NSTimeInterval animationDuration = 0.30f;      
    CGRect frame = self.commentTF.superview.frame;  
    frame.origin.y = self.tfBarOriginY-keyboardSize.height+self.tabBarController.tabBar.frame.size.height;  
    [UIView beginAnimations:@"ResizeView" context:nil];  
    [UIView setAnimationDuration:animationDuration];  
    self.commentTF.superview.frame = frame;                   
    [UIView commitAnimations];
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    //NSLog(@"keyboard will hide");
    CGRect frame = self.commentTF.superview.frame;  
    frame.origin.y = self.tfBarOriginY;
    NSTimeInterval animationDuration = 0.30f;  
    [UIView beginAnimations:@"ResizeView" context:nil];  
    [UIView setAnimationDuration:animationDuration];  
    self.commentTF.superview.frame = frame;                   
    [UIView commitAnimations];
    
}

#pragma mark - network
- (void)loadData
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        PicShareEngine *engine = [PicShareEngine sharedEngine];
        NSArray *resultArray = [engine getCommentsOfPictureStatus:psId];
        NSArray *resultComments = [resultArray subarrayWithRange:NSMakeRange(1, resultArray.count-1)];
        BOOL _hasNext = [[resultArray objectAtIndex:0]boolValue];
        PictureStatus *thePs = [engine getPictureStatus:self.psId];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.comments = [[[NSMutableArray alloc]initWithArray:resultComments]autorelease];
            if (comments.count>0) {
                self.flagId = ((Comment *)[self.comments objectAtIndex:0]).commentId;
            }
            [self.tableView reloadData];
            self.hasNext = _hasNext;
            self.currentPage = 1;
            self.ps = thePs;
            [MBProgressHUD hideHUDForView:window animated:YES];
        });
    });
}

- (void)addComment:(NSString *)text
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        PicShareEngine *engine = [PicShareEngine sharedEngine];
        Comment *newComment = [engine createComment:text toPicture:self.psId];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (newComment!=nil) {
                [self.comments insertObject:newComment atIndex:0];
                //NSLog(@"addcomment: %@",self.comments);
                NSArray *indexPaths = [[NSArray alloc]initWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil];
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
                [self.tableView endUpdates];
                [indexPaths release];
            }
            [MBProgressHUD hideHUDForView:window animated:YES];
        });
    });
}
- (void)pageData
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        PicShareEngine *engine = [PicShareEngine sharedEngine];
        NSArray *resultArray = [engine getCommentsOfPictureStatus:psId page:currentPage+1 countPerPage:5 max:flagId since:-1];
        NSLog(@"flagId:%d",self.flagId);
        NSArray *resultComments = [resultArray subarrayWithRange:NSMakeRange(1, resultArray.count-1)];//第0个为hasnext
        BOOL _hasNext = [[resultArray objectAtIndex:0]boolValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSMutableArray *indexPaths = [[NSMutableArray alloc]init];
            NSInteger originCommentsCount = self.comments.count;
            for (Comment *c in resultComments) {
                NSIndexPath *path = [NSIndexPath indexPathForRow:originCommentsCount inSection:0];
                [indexPaths addObject:path];
                [self.comments insertObject:c atIndex:originCommentsCount];
                originCommentsCount++;
            }
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
            [self.tableView endUpdates];
            self.hasNext = _hasNext;
            self.currentPage = self.currentPage+1;
            [indexPaths release];
            [MBProgressHUD hideHUDForView:window animated:YES];
        });
    });
}

- (void)deleteComment:(Comment *)comment
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        PicShareEngine *engine = [PicShareEngine sharedEngine];
        [engine deleteCommentById:comment.commentId];
    });
}

@end
