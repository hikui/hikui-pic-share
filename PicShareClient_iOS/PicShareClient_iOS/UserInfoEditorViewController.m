//
//  UserInfoEditorViewController.m
//  PicShareClient_iOS
//
//  Created by hikui on 12-4-17.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "UserInfoEditorViewController.h"
#import "UIImageView+WebCache.h"

@interface UserInfoEditorViewController()

- (void)uploadButtonOnTouch;

@end

@implementation UserInfoEditorViewController
@synthesize user,stivc,picker;

- (void)dealloc {
    [user release];
    stivc.delegate = nil;
    picker.delegate = nil;
    [stivc release];
    [picker release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *uploadButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(uploadButtonOnTouch)];
    self.navigationItem.rightBarButtonItem = uploadButton;
    [uploadButton release];
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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (user) {
        return 3;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        
    }
    
    switch (indexPath.row) {
        case 0:
            if (self.user.avatar!=nil) {
                cell.imageView.image = self.user.avatar;
            }else{
                [cell.imageView setImageWithURL:[NSURL URLWithString:user.avatarUrl] placeholderImage:[UIImage imageNamed:@"anonymous.png"]];
            }
            
            
            cell.textLabel.text = @"上传用户头像";
            break;
        case 1:
            cell.textLabel.text = @"简介";
            cell.detailTextLabel.text = user.introduction;
            break;
        case 2:
            cell.textLabel.text = @"地理位置";
            if ([user.location isEqualToString:@""] || user.location==nil) {
                cell.detailTextLabel.text = @"未知";
            }else{
                cell.detailTextLabel.text = user.location;
            }
            break;
        default:
            break;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // Configure the cell...
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIActionSheet *action;
    switch (indexPath.row) {
        case 0:
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"从相册选取",@"拍摄照片", nil];
            }else{
                action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"从相册选取", nil];
            }
            
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [action showInView:window];
            [action release];
            break;
        case 1:
            self.stivc = [[[SingleTextInputViewController alloc]initWithText:user.introduction]autorelease];
            self.stivc.delegate = self;
            self.stivc.presentType = NAVIGATION;
            self.stivc.tag = 0;
            [self.navigationController pushViewController:self.stivc animated:YES];
            break;
        case 2:
            self.stivc = [[[SingleTextInputViewController alloc]initWithText:user.location]autorelease];
            self.stivc.delegate = self;
            self.stivc.presentType = NAVIGATION;
            self.stivc.tag = 1;
            [self.navigationController pushViewController:self.stivc animated:YES];
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - ActionSheetDelegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (picker == nil) {
        self.picker = [[[UIImagePickerController alloc]init]autorelease];
    }
    picker.allowsEditing = YES;
    if (buttonIndex == 0) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else{
        assert([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]);
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    picker.delegate = self;
    [self presentModalViewController:picker animated:YES];
}

#pragma mark - pickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)_picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [_picker dismissModalViewControllerAnimated:YES];
    if ([UIApplication sharedApplication].statusBarHidden) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
    user.avatar = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.tableView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)_picker
{
    [_picker dismissModalViewControllerAnimated:YES];
    if ([UIApplication sharedApplication].statusBarHidden) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
}

#pragma mark - singletextinputdelegate
- (void)SingleTextInputViewController:(SingleTextInputViewController *)controller textDidCompose:(NSString *)text
{   
    if (controller.tag==0) {
        self.user.introduction = text;
    }else if(controller.tag==1){
        self.user.location = text;
    }
    
    [self.tableView reloadData];
}

#pragma mark - actions
- (void)uploadButtonOnTouch
{
    // to be continued
}
@end
