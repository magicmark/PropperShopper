//
//  PaymentViewController.h
//  PropperShopper
//
//  Created by Bartlomiej Siemieniuk on 26/04/2015.
//  Copyright (c) 2015 Team Goat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Braintree/Braintree.h>

@interface PaymentViewController : UIViewController<BTDropInViewControllerDelegate>

@property (nonatomic, strong) Braintree *braintree;
@end
