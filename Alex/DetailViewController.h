//
//  DetailViewController.h
//  Alex
//
//  Created by Isa Goksu on 11-07-09.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropboxSDK.h"
#import "SlideViewController.h"


@class DBRestClient;

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, DBRestClientDelegate, SlideViewControllerDelegate> {
    DBRestClient *restClient;
    NSMutableArray *chapters;
    SlideViewController *_slideViewController;
    UINavigationController *slidesNavigation;
}

@property (nonatomic, retain) IBOutlet SlideViewController *slideViewController;

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

@property (nonatomic, retain) id detailItem;

@property (nonatomic, retain) IBOutlet UILabel *detailDescriptionLabel;

@property (nonatomic, retain) IBOutlet UIButton *startButton;

@property (nonatomic, retain) IBOutlet UITableView *slidesView;

@property (nonatomic, retain) NSMutableArray *chapters;


@property (nonatomic, readonly) DBRestClient *restClient;

@property (nonatomic, retain) UINavigationController* slidesNavigation;

- (IBAction)showSlides:(id)sender;
@end
