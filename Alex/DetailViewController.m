//
//  DetailViewController.m
//  Alex
//
//  Created by Isa Goksu on 11-07-09.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "DetailViewController.h"
#import "RootViewController.h"

@interface DetailViewController ()
    @property (nonatomic, retain) UIPopoverController *popoverController;
    - (void)configureView;
@end

@implementation DetailViewController

@synthesize slideViewController = _slideViewController;
@synthesize toolbar=_toolbar;

@synthesize detailItem=_detailItem;

@synthesize detailDescriptionLabel=_detailDescriptionLabel;

@synthesize popoverController=_myPopoverController;

@synthesize startButton=_startButton;

@synthesize slidesView=_slidesView;

@synthesize chapters;

@synthesize restClient;

@synthesize slidesNavigation = _slidesNavigation;

#pragma mark - Managing the detail item

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        [_detailItem release];
        _detailItem = [newDetailItem retain];
        
        // Update the view.
        [self configureView];
    }

    if (self.popoverController != nil) {
        [self.popoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    self.detailDescriptionLabel.text = [self.detailItem description];
    self.slidesView.dataSource = self;
    self.slidesView.delegate = self;
    
    [self.restClient loadMetadata:[@"/Books/" stringByAppendingString:[self.detailItem description]]];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - Split view support

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController: (UIPopoverController *)pc
{
    barButtonItem.title = @"Events";
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;
}

// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;
}

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
 */

- (void)viewDidUnload
{
    [_slideViewController release];
    _slideViewController = nil;
    [self setSlideViewController:nil];
	[super viewDidUnload];

	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.popoverController = nil;
}

#pragma mark - Table View methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chapters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell.
    
    cell.textLabel.text = [self.chapters objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark RestClient specific methods
- (IBAction)showSlides:(id)sender {
        
    self.slideViewController.delegate = self;
    self.slideViewController.chapters = self.chapters;
    
    slidesNavigation = [[UINavigationController alloc]
                                                    initWithRootViewController:self.slideViewController];
    [self presentModalViewController:slidesNavigation animated:YES];
    
    // The navigation controller is now owned by the current view controller
    // and the root view controller is owned by the navigation controller,
    // so both objects should be released to prevent over-retention.
    [slidesNavigation release];
}

-(void) slideClosed {
    [self dismissModalViewControllerAnimated:YES];
}



- (DBRestClient *) restClient {
    if (restClient == nil) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    
    return restClient;
}

-(void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    [self.chapters release];
    
    self.chapters = [[NSMutableArray alloc] init];
    
    for (DBMetadata *folder in metadata.contents) {
        NSString *bookName = [[folder.path pathComponents] lastObject];
        [self.chapters addObject:bookName];
    }
    
    [self.slidesView reloadData];
}

#pragma mark - Memory management

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [_myPopoverController release];
    [_toolbar release];
    [_detailItem release];
    [_detailDescriptionLabel release];
    [_slidesView release];
    [_startButton release];
    [_slideViewController release];
    [_slidesNavigation release];
    [super dealloc];
}

@end
