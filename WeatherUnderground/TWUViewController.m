//
//  TWUViewController.m
//  WeatherUnderground
//
//  Created by Christopher Trevarthen on 4/25/14.
//  Copyright (c) 2014 Chris Trevarthen. All rights reserved.
//

#import "TWUViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface TWUViewController ()

@property (nonatomic) IBOutlet UILabel *conditionsLabel;
@property (nonatomic) IBOutlet UILabel *temperatureLabel;
@property (nonatomic) IBOutlet UILabel *cityLabel;
@property (nonatomic, strong) IBOutlet UIImageView *conditionsIcon;

@end

@implementation TWUViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://api.wunderground.com/api/9ceac7e6eae5cd1e/conditions/q/MI/Detroit.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
     NSURL *urlString = [NSURL URLWithString:responseObject[@"current_observation"][@"icon_url"]];
     NSData *dataFromUrlString = [NSData dataWithContentsOfURL:urlString];
     NSData *pngRep = UIImagePNGRepresentation([UIImage imageWithData:dataFromUrlString]);
     NSData *imageData = [NSData dataWithData:pngRep];
     UIImage *image = [UIImage imageWithData:imageData];
     
     self.conditionsIcon.image = image;
     
     self.conditionsLabel.text = responseObject[@"current_observation"][@"weather"];
     self.temperatureLabel.text = responseObject[@"current_observation"][@"temperature_string"];
     self.cityLabel.text = responseObject[@"current_observation"][@"display_location"][@"full"];
     
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
     }];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
