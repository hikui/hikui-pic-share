//
//  BoardsListViewController.m
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-5.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "BoardsListViewController.h"
#import "PicShareEngine.h"
#import "BoardsListCell.h"

@interface BoardsListViewController ()

-(void)loadData;

@end

@implementation BoardsListViewController

@synthesize boards = _boards;
@synthesize type = _type;
@synthesize contentId = _contentId;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithType:(TheType)aType AndId:(NSInteger)anId
{
    self = [super init];
    if(self){
        _type = aType;
        _contentId = anId;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _oprationq = [[NSOperationQueue alloc]init];
    NSInvocationOperation *downloadOperation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(loadData) object:nil];
    [_oprationq addOperation:downloadOperation];
    isLoadingData = YES;
    //show indicator
    _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGFloat tableWidth = self.tableView.bounds.size.width;
    _indicator.frame = CGRectMake((tableWidth-20)/2, 10, 20, 20);
    [_indicator setHidesWhenStopped:YES];
    [self.tableView addSubview:_indicator];
    [_indicator startAnimating];
    [downloadOperation release];
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

- (void)dealloc
{
    [_boards release];
    [_oprationq release];
    [_indicator release];
    [super dealloc];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _boards.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *normalCellIdentifier = @"normalCell";
    static NSString *moreCellIdentifier = @"moreCell";
    NSString *CellIdentifier;
    Board *b = [_boards objectAtIndex:indexPath.row];
    NSArray *pictureStatuses = b.pictureStatuses;
    int imagesCount = pictureStatuses.count;
    if (imagesCount>8) {
        CellIdentifier = moreCellIdentifier;
    }
    else {
        CellIdentifier = normalCellIdentifier;
    }
    
    BoardsListCell *cell = (BoardsListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = [[BoardsListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.boardNameLabel.text = b.name;
    [cell clearCurrentPictures];
    if (imagesCount>8) {
        for (int i=0; i<7; i++) {
            PictureStatus *ps = [pictureStatuses objectAtIndex:i];
            [cell addPictureWithUrlStr:ps.pictureUrl];
        }
        UIButton *moreButton = [[UIButton alloc]initWithFrame:CGRectMake(244, 125,60, 60)];
        [moreButton setTitle:@"更多..." forState:UIControlStateNormal];
        [moreButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [cell.contentView addSubview:moreButton];
        [moreButton release];
    }
    else {
        for (int i=0; i<imagesCount; i++) {
            PictureStatus *ps = [pictureStatuses objectAtIndex:i];
            [cell addPictureWithUrlStr:ps.pictureUrl];
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [BoardsListCell getBoardsListCellHeight:[_boards objectAtIndex:indexPath.row] withSpecifiedOrientation:nil];
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    
}

#pragma mark - async methods

-(void)loadData
{
    _engine = [PicShareEngine sharedEngine];
    if (_type == categoryDetail) {
        NSArray *returnedArray = [_engine getBoardsOfCategoryId:_contentId];
        self.boards = [returnedArray subarrayWithRange:NSMakeRange(1, returnedArray.count-1)];
    }else {
       self.boards = [_engine getBoardsOfUserId:_contentId];
    }
    isLoadingData = NO;
    [_indicator stopAnimating];
    [_indicator removeFromSuperview];
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO ];
}

@end
