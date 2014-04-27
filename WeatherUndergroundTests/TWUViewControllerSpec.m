//
//  TWUViewControllerSpec.m
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
    return mockPNGObject;
}

SPEC_BEGIN(TWUViewControllerSpec)

    describe(@"TWUViewController", ^{
        __block TWUViewController *viewController;
        beforeEach(^{
           viewController = [[TWUViewController alloc] init];
        });
    
        context(@"when the user opens the app", ^{

            it(@"sets the icon to the weather condition", ^{
                
                // create a mock version of the afnetworking operation manager
                AFHTTPRequestOperationManager *mockManager = [AFHTTPRequestOperationManager nullMock];
                [AFHTTPRequestOperationManager stub:@selector(manager) andReturn:mockManager];
                
                // make sure the real manager code isn't called
                [mockManager stub:@selector(GET:parameters:success:failure:)];
                
                // set up a spy to get the success block we pass to the manager
                KWCaptureSpy *spy = [mockManager captureArgument:@selector(GET:parameters:success:failure:) atIndex:2];
                
                // call the actual method so that we can use the spy to capture the success block argument
                [viewController viewWillAppear:YES];
                
                // we're going to force-call the success block, so we need to create some fake data to pass
                NSDictionary *fakeResponse = @{@"current_observation": @{@"icon_url":@"http://icons-ak.wxug.com/i/c/k/rain.gif"}};
                
                // get the success block from the spy (have to call the view controller's method first to get this to populate
                void (^successBlock)(AFHTTPRequestOperation *operation, id responseObject) = spy.argument;
                
                // expect that we'll create a URL given the fake response object data set above
                // takes care of this line:
                // NSURL *urlString = [NSURL URLWithString:responseObject[@"current_observation"][@"icon_url"]];
                NSURL *mockURL = [NSURL nullMock];
                [NSURL stub:@selector(URLWithString:) andReturn:mockURL withArguments:@"http://icons-ak.wxug.com/i/c/k/rain.gif"];
                
                // takes care of this line:
                // NSData *dataFromUrlString = [NSData dataWithContentsOfURL:urlString];
                NSData *mockData = [NSData nullMock];
                [NSData stub:@selector(dataWithContentsOfURL:) andReturn:mockData withArguments:mockURL];
                
                // takes care of this portion of the line:
                // [UIImage imageWithData:dataFromUrlString]
                UIImage *mockDataImage = [UIImage nullMock];
                [UIImage stub:@selector(imageWithData:) andReturn:mockDataImage withArguments:mockData];
                
                // takes care of this part of the line:
                // NSData *pngRep = UIImagePNGRepresentation(...)
                // and
                // NSData *imageData = [NSData dataWithData:pngRep];
                // by using our own UIImagePNGRepresentation method defined above to force it to return our own mock object
                NSData *mockImageData = [NSData nullMock];
                mockPNGObject = [NSData nullMock];
                [NSData stub:@selector(dataWithData:) andReturn:mockImageData withArguments:mockPNGObject];
                
                // takes care of this line:
                // UIImage *image = [UIImage imageWithData:imageData];
                UIImage *mockUIImage = [UIImage nullMock];
                [UIImage stub:@selector(imageWithData:) andReturn:mockUIImage withArguments:mockImageData];

                // create the expectation that we'll be setting the image for the icon
                // (needed to make the conditionsIcon a nullMock because view items aren't always instantiated in tests like
                // they are when running the app)
                [viewController stub:@selector(conditionsIcon) andReturn:[UIImageView nullMock]];
                [[viewController.conditionsIcon should] receive:@selector(setImage:) withArguments:mockUIImage];
                
                // call the success block directly, since that has the code we care about testing, which is setting the image.
                // all of the expectations and mocks we set up above will be evaluated at this point.
                successBlock(nil, fakeResponse);
            
                
            });
            
        });
    });
	
SPEC_END
