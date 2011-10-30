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
@synthesize book;

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
    [delegate release];
    [chapters release];
    [restClient release];
    [book dealloc];
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(NSString *) getCurrentPagePath:(NSString *) currentPage{
    NSLog(@"Current Page = %@", currentPage);
    return [@"/Books/" stringByAppendingFormat:@"%@/%@", self.book, currentPage];
}

- (void) downloadFile {
    
    if(currentIndex >= 0 && currentIndex < [self.chapters count]){        
        NSString *currentPage = [self.chapters objectAtIndex:currentIndex];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:currentPage];        
        [self.restClient loadFile:[self getCurrentPagePath:currentPage] intoPath:filePath];
    }

}

-(void) showSlide{        
    [self downloadFile];
}


-(void) showNextSlide{
    currentIndex++;
    if(currentIndex == [self.chapters count]){
        currentIndex = 0;
    }
    [self showSlide];    
}

-(void) showPreviousSlide{
    currentIndex --;
    if(currentIndex < 0){
        currentIndex = [self.chapters count]-1;
    }
    [self showSlide];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showSlide];
    
    
    UISwipeGestureRecognizer *recognizer = [[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(showNextSlide)]autorelease];
    recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:recognizer];

    UISwipeGestureRecognizer *swipeRight = [[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(showPreviousSlide)]autorelease];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];

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

-(void) setImageHidden:(BOOL)isHidden {
    double imageAlpha = 0.0;
    if(!isHidden){
        imageAlpha = 1.0;
    }
    [UIView animateWithDuration:1.0 
                          delay:0.0
                        options:UIViewAnimationCurveEaseIn
                     animations:^{
                            self.slideImage.alpha = imageAlpha;
                            self.slideText.alpha = 1.0 - imageAlpha;
                     }
                     completion:NULL
     ];
}

- (void) showText: (NSString *) text  {
    [slideText setText:text];
    [self setImageHidden:YES];

}

-(void) showFileNameAsText:(NSString *) fileName{
    [self showText:[[fileName lastPathComponent]stringByDeletingPathExtension]];
}

- (void) showTextSlide: (NSString *) destPath  {
    NSError *error;
    NSString * text = [NSString stringWithContentsOfFile:destPath encoding:NSASCIIStringEncoding error:&error];
    if(text == NULL){
        [self showFileNameAsText:destPath];
    }
    else{
        [self showText: text];
    }
}

- (void) showImageSlide: (NSString *) destPath  {
    @try{  
        [slideImage setImage:[UIImage imageWithContentsOfFile:destPath]];       
        [self setImageHidden:NO];
    }
    @catch (id exception) {
        NSLog(@"%@", exception);
        [self showFileNameAsText:destPath];
    }
}

- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)destPath{

    BOOL isTextFile = [[destPath pathExtension] isEqualToString: @"txt"];    
    
    if(isTextFile){
        [self showTextSlide: destPath];
    }    
    else{
        [self showImageSlide: destPath];
    }
}

- (IBAction)closeSlide:(id)sender {
    if(delegate != NULL){
        [delegate slideClosed];
    }
}

@end
