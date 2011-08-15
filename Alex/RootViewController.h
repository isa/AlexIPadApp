//
//  RootViewController.h
//  Alex
//
//  Created by Isa Goksu on 11-07-09.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropboxSDK.h"

@class DetailViewController;
@class DBRestClient;

@interface RootViewController : UITableViewController<DBRestClientDelegate,DBLoginControllerDelegate,UITableViewDelegate,UITableViewDataSource> {
    DBRestClient *restClient;
    NSMutableArray *books;
}

@property (nonatomic, retain) NSMutableArray *books;
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (nonatomic, readonly) DBRestClient *restClient;

@end
