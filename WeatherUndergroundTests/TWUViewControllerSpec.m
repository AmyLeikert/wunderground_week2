//
//  UITextField_Mine.m
//  WeatherUnderground
//
//  Created by Christopher Trevarthen on 4/25/14.
//  Copyright (c) 2014 Chris Trevarthen. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TWUViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface TWUViewController ()

@property (nonatomic, strong) IBOutlet UIImageView *conditionsIcon;

@end

NSData *mockPNGObject;

NSData *UIImagePNGRepresentation(UIImage *image) {
    mockPNGObject = [NSData nullMock];
    return mockPNGObject;
}

SPEC_BEGIN(UITextField_Mine)

    describe(@"TWUViewController", ^{
        __block TWUViewController *viewController;
        beforeEach(^{
           viewController = [[TWUViewController alloc] init];
        });
		context(@"when the user opens the app", ^{
            
            xit(@"sets the icon to an image", ^{
                [viewController stub:@selector(conditionsIcon) andReturn:[UIImageView nullMock]];
                [[viewController.conditionsIcon should] receive:@selector(setImage:)];
                [viewController viewWillAppear:YES];
            });
            


            it(@"sets the icon to the weather condition", ^{
                
//              Setting up the test for AFNetworking
                AFHTTPRequestOperationManager *mockManager = [AFHTTPRequestOperationManager nullMock];
                [AFHTTPRequestOperationManager stub:@selector(manager) andReturn:mockManager];
                [mockManager stub:@selector(GET:parameters:success:failure:)];
                KWCaptureSpy *spy = [mockManager captureArgument:@selector(GET:parameters:success:failure:) atIndex:2];
                
                [viewController viewWillAppear:YES];
                
                NSDictionary *fakeResponse = @{@"current_observation": @{@"icon_url":@"http://icons-ak.wxug.com/i/c/k/rain.gif"}};
                NSURL *mockURL = [NSURL nullMock];
                [NSURL stub:@selector(URLWithString:) andReturn:mockURL withArguments:@"http://icons-ak.wxug.com/i/c/k/rain.gif"];
                
                NSData *mockData = [NSData nullMock];
                [NSData stub:@selector(dataWithContentsOfURL:) andReturn:mockData withArguments:mockURL];
                
                UIImage *mockDataImage = [UIImage nullMock];
                [UIImage stub:@selector(imageWithData:) andReturn:mockDataImage withArguments:mockData];
                NSData *mockImageData = [NSData nullMock];
                [NSData stub:@selector(dataWithData:) andReturn:mockImageData withArguments:mockPNGObject];
                 UIImage *mockUIImage = [UIImage nullMock];
                [UIImage stub:@selector(imageWithData:) andReturn:mockUIImage withArguments:mockImageData];
                void (^successBlock)(AFHTTPRequestOperation *operation, id responseObject) = spy.argument;
                [[viewController.conditionsIcon should] receive:@selector(setImage:) withArguments:mockUIImage];
                successBlock(nil, fakeResponse);
            
                
            });
            
        });
    });
	
SPEC_END
