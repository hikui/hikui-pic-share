//
//  PictureEditViewController.m
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-21.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "PictureEditViewController.h"
#import "UIImageView+Resize.h"
#import "DraggableImageView.h"
#import "PictureInfoEditViewController.h"

@interface PictureEditViewController ()

- (void)clearOnBoardDraggableImages;

@end

@implementation PictureEditViewController

@synthesize imageView,decoratorImages,onBoardDecoratorImages,scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    decoratorImages = [[NSArray alloc]initWithObjects:[UIImage imageNamed:@"rc-1.png"],[UIImage imageNamed:@"rc-2.png"],[UIImage imageNamed:@"rc-3.png"],[UIImage imageNamed:@"rc-4.png"], nil];
    onBoardDecoratorImages = [[NSMutableArray alloc]init];
    self.imageView.backgroundColor = [UIColor blackColor];
    self.scrollView.contentSize = CGSizeMake(320, self.scrollView.frame.size.height);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.imageView = nil;
    self.scrollView = nil;
    self.onBoardDecoratorImages = nil;
    self.decoratorImages = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self clearOnBoardDraggableImages];
}

- (void)dealloc
{
    [imageView release];
    [decoratorImages release];
    [scrollView release];
    [onBoardDecoratorImages release];
    [super dealloc];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)finishButtonOnTouch
{
    PictureInfoEditViewController *pievc = [[PictureInfoEditViewController alloc]initWithNibName:@"PictureInfoEditViewController" bundle:nil];
    [self.navigationController pushViewController:pievc animated:YES];
    [pievc release];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker pushViewController:self animated:YES];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finishButtonOnTouch)]autorelease];
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *editedImage = nil;
    if (originalImage.size.width>originalImage.size.height) {
        editedImage = [UIImageView imageWithImage:originalImage scaledToSizeWithTargetWidth:self.imageView.frame.size.width ];
    }
    else {
        editedImage  = [UIImageView imageWithImage:originalImage scaledToSizeWithTargetHeight:self.imageView.frame.size.height];
    }
   
    self.imageView.image = editedImage;
}

-(IBAction)decorateImageOnTouch:(id)sender
{
    UIButton *button = (UIButton *)sender;
    int tag = button.tag;
    DraggableImageView *draggableImageView = [[DraggableImageView alloc]initWithImage:[decoratorImages objectAtIndex:tag]];
    draggableImageView.userInteractionEnabled = YES;
    self.imageView.userInteractionEnabled =YES;
    [self.imageView addSubview: draggableImageView];
    [self.onBoardDecoratorImages addObject:draggableImageView];
    [draggableImageView release];
}

- (void)clearOnBoardDraggableImages
{
    for (DraggableImageView *div in self.onBoardDecoratorImages) {
        [div removeFromSuperview];
    }
    [onBoardDecoratorImages removeAllObjects];
}

-(IBAction)clearButtonOnTouch:(id)sender
{
    [self clearOnBoardDraggableImages];
}
@end
