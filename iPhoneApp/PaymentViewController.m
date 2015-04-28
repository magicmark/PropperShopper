//
//  PaymentViewController.m
//  PropperShopper
//
//  Created by Bartlomiej Siemieniuk on 26/04/2015.
//  Copyright (c) 2015 Team Goat. All rights reserved.
//

#import "PaymentViewController.h"


@interface PaymentViewController () <BTDropInViewControllerDelegate>

@property(nonatomic,strong) NSString * clientToken;
@property (nonatomic, strong) NSString *nonce;

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSURL *clientTokenURL = [NSURL URLWithString:@"http://46.101.1.221:5000/client_token"];
    NSMutableURLRequest *clientTokenRequest = [NSMutableURLRequest requestWithURL:clientTokenURL];
    [clientTokenRequest setValue:@"text/plain" forHTTPHeaderField:@"Accept"];
    
    [NSURLConnection
     sendAsynchronousRequest:clientTokenRequest
     queue:[NSOperationQueue mainQueue]
     completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         // TODO: Handle errors in [(NSHTTPURLResponse *)response statusCode] and connectionError
         NSString *clientToken = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         
         // Initialize `Braintree` once per checkout session
         [Braintree
          setupWithClientToken:clientToken
          completion:^(Braintree *braintree, NSError *error) {
              UIViewController *dropin = [braintree dropInViewControllerWithDelegate:self];
              [self presentViewController:[[UINavigationController alloc] initWithRootViewController:dropin]
                                 animated:YES
                               completion:nil];
          }];
     }];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}


- (void)dropInViewController:(__unused BTDropInViewController *)viewController didSucceedWithPaymentMethod:(BTPaymentMethod *)paymentMethod {
    self.nonce = paymentMethod.nonce;
    [self postNonceToServer:self.nonce]; // Send payment method nonce to your server
    [self dismissViewControllerAnimated:YES completion:^ {
        [self performSegueWithIdentifier:@"Finish" sender:self];
    }];
    
}

- (void)dropInViewControllerDidCancel:(__unused BTDropInViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidCancelPayment {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)postNonceToServer:(NSString *)paymentMethodNonce {
    NSURL *paymentURL = [NSURL URLWithString:@"http://46.101.1.221:5000/purchases"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:paymentURL];
    request.HTTPBody = [[NSString stringWithFormat:@"payment-method-nonce=%@", paymentMethodNonce] dataUsingEncoding:NSUTF8StringEncoding];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               // TODO: Handle success and failure
                           }];
}


#pragma mark - Navigation

//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    
//}


@end
