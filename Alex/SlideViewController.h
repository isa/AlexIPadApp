//
//  SlideViewController.h
//  Alex
//
//  Created by smsohan on 10/16/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SlideViewControllerDelegate <NSObject>
    - (void)slideClosed;
@end

@interface SlideViewController : UIViewController {

    
}
- (IBAction)closeSlide:(id)sender;

@property (nonatomic, retain) id<SlideViewControllerDelegate> delegate;

@end
