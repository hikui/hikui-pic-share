//
//  BoardInfoEditorViewController.m
//  PicShareClient_iOS
//
//  Created by 缪和光 on 12-4-5.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "BoardInfoEditorViewController.h"
#import "MBProgressHUD.h"
#import "PicShareEngine.h"

@interface BoardInfoEditorViewController ()

-(void) loadBoard;
-(void) loadCategories;
-(void) deleteBoard;
-(void) updateToServer;
-(void) createToServer;

@end

@implementation BoardInfoEditorViewController
@synthesize boardNameCell,categoryCell,boardId,board,categoryPicker,boardNameTF,categories,type; 

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [boardNameCell release];
    [categoryCell release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (board == nil && boardId>0 && type==UPDATE) {
        //load board info
        [self loadBoard];
    }else if(type==UPDATE){
        self.boardNameTF.text = self.board.name;
    }
    UIBarButtonItem *rightItem;
    if (type==CREATE) {
        rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(createToServer)];
        self.title = @"新建相册";
    }else if(type==UPDATE) {
        rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(updateToServer)];
        self.title = @"修改相册";
    }
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    [self loadCategories];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
        case 1:
            return 1;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                return boardNameCell;
            case 1:
                return categoryCell;
        }
    }else {
        UITableViewCell *cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil]autorelease];
        cell.textLabel.text = @"删除相册";
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        return cell;
    }
    return nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                return 46;
            case 1:
                return 286;
        }
    }
    return 44;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}


-(void) loadBoard
{
    if (boardId<=0) {
        return;
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        PicShareEngine *engine = [PicShareEngine sharedEngine];
        Board *_b = [engine getBoard:boardId];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.board = _b;
            self.boardNameTF.text = _b.name;
            [MBProgressHUD hideHUDForView:window animated:YES];
        });
    });
}

-(void) loadCategories
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        PicShareEngine *engine = [PicShareEngine sharedEngine];
        NSArray *_categories = [engine getAllCategories];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.categories = _categories;
            [self.categoryPicker reloadAllComponents];
            [MBProgressHUD hideHUDForView:window animated:YES];
        });
    });
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.categories.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    Category *c = [self.categories objectAtIndex:row];
    return c.name;
}

-(void) deleteBoard
{
    
}
-(void) updateToServer
{
    NSInteger selectedRow = [self.categoryPicker selectedRowInComponent:0];
    Category *c = [self.categories objectAtIndex:selectedRow];
    self.board.categoryId = c.categoryId;
    self.board.name = self.boardNameTF.text;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        PicShareEngine *engine = [PicShareEngine sharedEngine];
        ErrorMessage *eMsg = [engine updateBoard:self.board];
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSThread sleepForTimeInterval:2];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (eMsg.ret==0 && eMsg.errorcode==0) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"修改成功" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:eMsg.errorMsg delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
        });
    });
    
}

-(void) createToServer
{
    NSInteger selectedRow = [self.categoryPicker selectedRowInComponent:0];
    Category *c = [self.categories objectAtIndex:selectedRow];
    Board *newB = [[Board alloc]init];
    newB.categoryId = c.categoryId;
    newB.name = self.boardNameTF.text;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        PicShareEngine *engine = [PicShareEngine sharedEngine];
        Board *b = [engine createBoard:newB];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (b!=nil) {
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                // error alert view is already shown. see engine.
            }
        });
    });
}

@end
