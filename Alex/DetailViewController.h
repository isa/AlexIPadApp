//
//  DetailViewController.h
//  Alex
//
//  Created by Isa Goksu on 11-07-09.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropboxSDK.h"

@class DBRestClient;

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, DBRestClientDelegate> {
    DBRestClient *restClient;
    NSMutableArray *chapters;
}


@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

@property (nonatomic, retain) id detailItem;

@property (nonatomic, retain) IBOutlet UILabel *detailDescriptionLabel;

@property (nonatomic, retain) IBOutlet UIButton *startButton;

@property (nonatomic, retain) IBOutlet UITableView *slidesView;

@property (nonatomic, retain) NSMutableArray *chapters;

@property (nonatomic, readonly) DBRestClient *restClient;


@end
