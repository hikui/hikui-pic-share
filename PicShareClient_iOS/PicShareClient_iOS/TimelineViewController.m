//
//  TimelineViewController.m
//  PicShareClient_iOS
//
//  Created by 缪和光 on 12-3-28.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "TimelineViewController.h"
#import "PicShareEngine.h"
#import "TimelineCell.h"

@interface TimelineViewController ()

- (void)loadData;
- (void)loadDataDidFinish:(NSArray *)resultArray;
- (void)pageData;
- (void)pageDataDidFinish:(NSArray *)resultArray;

@end

@implementation TimelineViewController
@synthesize timeline,hasnext,currentPage;

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
    [self startLoading];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (timeline == nil) {
        return 0;
    }
    return self.timeline.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    if (indexPath.row == self.timeline.count) {
        //more button
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"moreButton"];
        if (cell==nil) {
            cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"moreButton"]autorelease];
        }
        if (hasnext) {
            cell.textLabel.text = @"更多...";
        }
        else {
            cell.textLabel.text=@"";
        }
        
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        return cell;
        
    }
    
    TimelineCell *cell = (TimelineCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = [[[TimelineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
    }
    PictureStatus *ps = [timeline objectAtIndex:indexPath.row];
    [cell setPictureStatusThenRefresh:ps];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.timeline.count) {
        return 40;
    }
    PictureStatus *ps = [self.timeline objectAtIndex:indexPath.row];
    return [TimelineCell calculateCellHeightWithPictureStatus:ps];
}

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

-(void)refresh
{
    [self performSelectorInBackground:@selector(loadData) withObject:nil];
}


#pragma mark - async methods
- (void)loadData
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    PicShareEngine *engine = [PicShareEngine sharedEngine];
    NSArray *resultArray = [engine getHomeTimeline];
    //NSLog(@"timeline:%@",resultArray);
    [self performSelectorOnMainThread:@selector(loadDataDidFinish:) withObject:resultArray waitUntilDone:NO];
    [pool release];
}
- (void)loadDataDidFinish:(NSArray *)resultArray
{
    NSMutableArray *mutableResults = [[NSMutableArray alloc]initWithArray:[resultArray subarrayWithRange:NSMakeRange(1, resultArray.count-1)]];
    self.timeline = mutableResults;
    [mutableResults release];
    //NSLog(@"timeline:%@",self.timeline);
    if ([[resultArray objectAtIndex:0]intValue]==1) {
        self.hasnext = YES;
    }
    else {
        self.hasnext = NO;
    }
    currentPage = 1;
    [self stopLoading];
    [self.tableView reloadData];
}
- (void)pageData
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    PicShareEngine *engine = [PicShareEngine sharedEngine];
    PictureStatus *theTopOne = [self.timeline objectAtIndex:0];
    NSArray *resultArray = [engine getHomeTimelineOfPage:++currentPage since:-1 max:theTopOne.psId];
    NSLog(@"timeline:%@",resultArray);
    [self performSelectorOnMainThread:@selector(pageDataDidFinish:) withObject:resultArray waitUntilDone:NO];
    [pool release];
}
- (void)pageDataDidFinish:(NSArray *)resultArray
{
    NSArray *psData = [resultArray subarrayWithRange:NSMakeRange(1, resultArray.count-1)];
    int originPSCount = timeline.count;
    for (PictureStatus *aPs in psData) {
        [self.timeline insertObject:aPs atIndex:originPSCount++];
    }
    if ([[resultArray objectAtIndex:0] intValue] == 1) {
        self.hasnext = YES;
    }
    else {
        self.hasnext = NO;
    }
    [self.tableView reloadData];
}
@end
