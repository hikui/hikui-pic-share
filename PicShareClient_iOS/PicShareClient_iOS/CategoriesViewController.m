//
//  CategoriesViewController.m
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-5.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "CategoriesViewController.h"
#import "BoardsListViewController.h"

@interface CategoriesViewController (Private)

- (void)prepareLoad;
- (void)loadCategories;

@end

@implementation CategoriesViewController

@synthesize categories = _categories;

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
    oprationq = [[NSOperationQueue alloc]init];
    [self prepareLoad];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(prepareLoad)]autorelease];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.categories = nil;//release and set nil
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isLoadingData) {
        return 1;
    }
    return _categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isLoadingData) {
        static NSString *phIdentifier = @"loadingPlaceHolder";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:phIdentifier];
        if (cell==nil) {
            cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:phIdentifier]autorelease];
        }
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGFloat tableWidth = self.tableView.bounds.size.width;
        indicator.frame = CGRectMake((tableWidth-20)/2, 10, 20, 20);
        [cell addSubview:indicator];
        [indicator startAnimating];
        [indicator release];
        return cell;
    }
    static NSString *CellIdentifier = @"CategoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
    }
    Category *c = [_categories objectAtIndex:indexPath.row];
    cell.textLabel.text = c.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)dealloc{
    [_categories release];
    [oprationq release];
    [super dealloc];
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
    Category *c = [_categories objectAtIndex:indexPath.row ];
    NSInteger categoryId = c.categoryId;
    BoardsListViewController *blvc = [[BoardsListViewController alloc]initWithType:categoryDetail AndId:categoryId];
    [self.navigationController pushViewController:blvc animated:YES];
    [blvc release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Async methods

- (void)prepareLoad
{
    NSInvocationOperation *downloadOperation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(loadCategories) object:nil];
    [oprationq addOperation:downloadOperation];
    isLoadingData = YES;
    [downloadOperation release];
}

-(void)loadCategories
{
    _engine = [PicShareEngine sharedEngine];
    NSArray *loadedCategories = [_engine getAllCategories];
    [self performSelectorInBackground:@selector(setCategories:) withObject:loadedCategories];
    isLoadingData = NO;
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:false];
   
}

@end
