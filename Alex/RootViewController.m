//
//  RootViewController.m
//  Alex
//
//  Created by Isa Goksu on 11-07-09.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "RootViewController.h"
#import "DropboxSDK.h"

#import "DetailViewController.h"

@implementation RootViewController
		
@synthesize detailViewController;
@synthesize books;
@synthesize restClient;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    self.title = @"Available Books";
    
    if (![[DBSession sharedSession] isLinked]) {
        NSLog(@"not logged in");
        [self.restClient loginWithEmail:@"alexipadapp@gmail.com" password:@"kalemon3"];

//        DBLoginController* loginController = [[DBLoginController new] autorelease];
//        loginController.delegate = self;
//        [loginController presentFromController:self.detailViewController];
    }
    
}
		
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.restClient loadMetadata:@"/Books"];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.books count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    // Configure the cell.
    
    cell.textLabel.text = [self.books objectAtIndex:indexPath.row];
    		
    return cell;
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
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.detailViewController.startButton.hidden = NO;
    self.detailViewController.slidesView.hidden = NO;
    self.detailViewController.detailDescriptionLabel.textColor = [UIColor redColor];
    self.detailViewController.detailItem = [self.books objectAtIndex:indexPath.row];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

#pragma mark RestClient specific methods
- (DBRestClient *) restClient {
    if (restClient == nil) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    
    return restClient;
}

-(void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    [self.books release];
    
    self.books = [[NSMutableArray alloc] init];
    
    for (DBMetadata *folder in metadata.contents) {
        NSString *bookName = [[folder.path pathComponents] lastObject];
        [self.books addObject:bookName];
    }
    
    [self.tableView reloadData];
}

#pragma mark DBLoginControllerDelegate methods
-(void)loginControllerDidLogin:(DBLoginController *)controller {
}

-(void)loginControllerDidCancel:(DBLoginController *)controller {
}

- (void)dealloc
{
    [books release];
    [restClient release];
    [detailViewController release];
    [super dealloc];
}

@end
