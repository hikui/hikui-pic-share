//
//  PictureInfoEditBoardsListViewController.m
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-25.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "BoardPickerViewController.h"
#import "BoardInfoEditorViewController.h"

@interface BoardPickerViewController ()

-(void)loadData;
-(void)loadDataDidFinish:(NSArray *)data;
-(void)cancelButtonOnTouch;
-(void)addButtonOnTouch;

@end

@implementation BoardPickerViewController
@synthesize delegate,boardsArray,engine,indexSelected;

- (void)dealloc
{
    [boardsArray release];
    [indexSelected release];
    [isSelectedBlock release];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonOnTouch)]autorelease];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonOnTouch)]autorelease];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    return boardsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
    }
    Board *b = [self.boardsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = b.name;
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Board *b = [boardsArray objectAtIndex:indexPath.row];
    if (isSelectedBlock) {
        isSelectedBlock(b);
    }else {
        [self.delegate boardDidSelect:b];
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void)refresh
{
    [self performSelectorInBackground:@selector(loadData) withObject:nil];
}

#pragma mark - async methods
-(void)loadData
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    engine = [PicShareEngine sharedEngine];
    NSArray *returnedArray = nil;
    returnedArray = [engine getBoardsOfUserId:engine.userId];
    [self performSelectorOnMainThread:@selector(loadDataDidFinish:) withObject:returnedArray waitUntilDone:NO];
    [pool drain];
}

-(void)loadDataDidFinish:(NSArray *)data
{
    NSMutableArray *mutableBoardsData = [[NSMutableArray alloc]initWithArray:[data subarrayWithRange:NSMakeRange(1, data.count-1)]];
    [self stopLoading];
    self.boardsArray = mutableBoardsData;
    [mutableBoardsData release];
    [self.tableView reloadData];
}

#pragma mark - event handle

- (void)cancelButtonOnTouch
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)addButtonOnTouch
{
    BoardInfoEditorViewController *bivec = [[BoardInfoEditorViewController alloc]initWithNibName:@"BoardInfoEditorViewController" bundle:nil];
    bivec.type = CREATE;
    [self.navigationController pushViewController:bivec animated:YES];
}

- (void)setBoardIsSelectedBlock:(BoardIsSelectedBlock)_isSelectedBlock
{
    [isSelectedBlock release];
    isSelectedBlock = [_isSelectedBlock copy];
}

@end
