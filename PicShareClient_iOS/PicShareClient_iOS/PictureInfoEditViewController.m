//
//  PictureInfoEditViewController.m
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-24.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "PictureInfoEditViewController.h"
#import "PicShareEngine.h"

@interface PictureInfoEditViewController ()

-(void)uploadButtonOnTouch;

@end

@implementation PictureInfoEditViewController
@synthesize board,descriptionText,locationPoint,uploadImage;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:@"上传" style:UIBarButtonItemStyleDone target:self action:@selector(uploadButtonOnTouch)]autorelease];
    locationPoint = CGPointMake(-1, -1);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier]autorelease];
    }
    int row = indexPath.row;
    switch (row) {
        case 0:
            cell.textLabel.text = @"描述您的照片...";
            cell.textLabel.textColor = [UIColor grayColor];
            break;
        case 1:
            cell.textLabel.text = @"相册";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 2:
            cell.textLabel.text = @"地点";
            UISwitch *swither = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
            cell.accessoryView = swither;
            [swither release];
        default:
            break;
    }
    // Configure the cell...
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        PictureDescriptionComposerViewController *pdcvc = [[PictureDescriptionComposerViewController alloc]initWithText:self.descriptionText];
        [pdcvc setDelegate:self];
        UINavigationController *nPdcvc = [[UINavigationController alloc]initWithRootViewController:pdcvc];
        [self presentModalViewController:nPdcvc animated:YES];
        [pdcvc release];
        [nPdcvc release];
    } else if (indexPath.row == 1) {
        BoardPickerViewController *bpvc = [[BoardPickerViewController alloc]init];
        [bpvc setDelegate:self];
        UINavigationController *nbpvc = [[UINavigationController alloc]initWithRootViewController:bpvc];
        [self presentModalViewController:nbpvc animated:YES];
        [bpvc release];
        [nbpvc release];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - delegate methods

- (void)descriptionDidCompose:(NSString *)theDescription
{
    if (theDescription == nil || [theDescription isEqualToString:@""]) {
        return;
    }
    self.descriptionText = theDescription;
    NSIndexPath *descriptionCellPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:descriptionCellPath];
    cell.textLabel.text = self.descriptionText;
}

- (void)boardDidSelect:(Board *)aBoard
{
    self.board = aBoard;
    NSIndexPath *boardCellPath = [NSIndexPath indexPathForRow:1 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:boardCellPath];
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    cell.detailTextLabel.text = aBoard.name;
    NSLog(@"selected:%@",aBoard.name);
}

-(void)uploadButtonOnTouch
{
    NSLog(@"upload start");
    if (uploadImage == nil) {
        NSLog(@"you should specify one uploadImage!");
        return;
    }
    if (board == nil) {
        UIAlertView *alertView = [[[UIAlertView alloc]initWithTitle:@"错误！" message:@"必须指定相册！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil]autorelease];
        [alertView show];
        return;
    }
    PicShareEngine *engine = [PicShareEngine sharedEngine];
    [engine uploadPicture:uploadImage toBoard:self.board.boardId withLatitude:locationPoint.x  longitude:locationPoint.y description:descriptionText];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self dismissModalViewControllerAnimated:YES];
}
@end
