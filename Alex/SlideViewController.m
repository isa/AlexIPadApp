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
@synthesize currentIndex;
@synthesize slideText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.currentIndex = 0;
    }
    return self;
}

- (void)dealloc
{
    [slideImage release];
    [slideText release];
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
    [self showSlide];
}

-(void) showSlide{
    NSString *currentPage = [self.chapters objectAtIndex:currentIndex];
    NSLog(@"Current Page = %@", currentPage);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:currentPage];        
    [self.restClient loadFile:[@"/Books/Numbers/" stringByAppendingString:currentPage] intoPath:filePath];
}

- (void)viewDidUnload
{
    [self setSlideImage:nil];
    [self setSlideText:nil];
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
    
    NSLog(@"File extension %@", [destPath pathExtension]);
    
    
    if([[destPath pathExtension] isEqualToString: @"txt"]){
        NSError *error;
        NSString * text = [NSString stringWithContentsOfFile:destPath encoding:NSASCIIStringEncoding error:&error];
        NSLog(@"The text is %@", text);
        [slideText setText:text];
        [slideText setHidden:NO];
        [slideImage setHidden:YES];
    }
    else{
        [slideImage setImage:[UIImage imageWithContentsOfFile:destPath]];        
        [slideText setHidden:YES];
        [slideImage setHidden:NO];
    }
}

- (IBAction)closeSlide:(id)sender {
    if(delegate != NULL){
        [delegate slideClosed];
    }
}

- (IBAction)showNextSlide:(id)sender {
    if(currentIndex == [self.chapters count]){
        currentIndex = 0;
    }
    [self showSlide];    
    ++currentIndex;        
}
@end
