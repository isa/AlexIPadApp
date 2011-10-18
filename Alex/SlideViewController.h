//
//  SlideViewController.h
//  Alex
//
//  Created by smsohan on 10/16/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropboxSDK.h"

@class DBRestClient;


@protocol SlideViewControllerDelegate <NSObject>
    - (void)slideClosed;
@end

@interface SlideViewController : UIViewController<DBRestClientDelegate> {
    DBRestClient *restClient;
    UIImageView *slideImage;
}
- (IBAction)closeSlide:(id)sender;
@property (nonatomic, retain) IBOutlet UIImageView *slideImage;
@property (nonatomic, readonly) DBRestClient *restClient;
@property (nonatomic, retain) id<SlideViewControllerDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *chapters;

@end
