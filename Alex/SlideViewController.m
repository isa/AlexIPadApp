//
//  SlideViewController.m
//  Alex
//
//  Created by smsohan on 10/16/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "SlideViewController.h"
#import "DBRestClient.h"

@implementation SlideViewController

@synthesize slideImage;
@synthesize delegate;
@synthesize chapters;
@synthesize restClient;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [slideImage release];
    [super dealloc];
    [delegate release];
    [chapters release];
    [restClient release];
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
    NSLog(@"Chapters = %@", [self.chapters objectAtIndex:0]);
    // Do any additional setup after loading the view from its nib.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"slide.jpg"];
    
    [self.restClient loadFile:@"/Books/Numbers/1 - Number 1/one.jpg" intoPath:filePath];
}

- (void)viewDidUnload
{
    [self setSlideImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (DBRestClient *) restClient {
    if (restClient == nil) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    
    return restClient;
}

- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)destPath{
    NSLog(@"Got the file callback %@", destPath);
    
    [slideImage setImage:[UIImage imageWithContentsOfFile:destPath]];
    
}

- (IBAction)closeSlide:(id)sender {
    if(delegate != NULL){
        [delegate slideClosed];
    }
}
@end
