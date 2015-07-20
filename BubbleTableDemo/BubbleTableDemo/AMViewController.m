//
//  AMViewController.m
//  BubbleTableDemo
//
//  Created by Andrea on 21/01/14.
//  Copyright (c) 2014 Fancy Pixel. All rights reserved.
//

#import "AMViewController.h"
#import <Pubnub/PNConfiguration.h>
#import <PubNub/PubNub.h>
#import "AMAppDelegate.h"

@interface AMViewController () <AMBubbleTableDataSource, AMBubbleTableDelegate, PNObjectEventListener>

@property (nonatomic, strong) NSMutableArray* data;
@property(nonatomic, strong) PNConfiguration *myConfig;
@property (nonatomic) PubNub *client;
@property(nonatomic, strong) NSString *subKey;
@property(nonatomic, strong) NSString *pubKey;
@property(nonatomic, strong) NSString *authKey;

@property (nonatomic, strong) NSString *channelID;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSNumber *nubmer;

@end

@implementation AMViewController

@synthesize subKey, pubKey, authKey, client, channelID, name, nubmer;

- (void)viewDidLoad
{
	// Bubble Table setup
    
//    channelID = @"DemoChannelForRestaurantApp";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerN) name:@"register" object:nil];
    
     channelID = @"DemoChannelForRestaurant";
    
    name = @"Vic";
	
    [self myPubnubConnect];
    
	[self setDataSource:self]; // Weird, uh?
	[self setDelegate:self];
	
	[self setTitle:@"Chat"];
	
	// Dummy data
    self.data  = [[NSMutableArray alloc]init];
	/*self.data = [[NSMutableArray alloc] initWithArray:@[
														@{
															@"text": @"He felt that his whole life was some kind of dream and he sometimes wondered whose it was and whether they were enjoying it.",
															@"date": [NSDate date],
															@"type": @(AMBubbleCellReceived),
															@"username": @"Stevie",
															@"color": [UIColor redColor]
															},
														@{
															@"text": @"My dad isn’t famous. My dad plays jazz. You can’t get famous playing jazz",
															@"date": [NSDate date],
															@"type": @(AMBubbleCellSent)
															},
														@{
															@"date": [NSDate date],
															@"type": @(AMBubbleCellTimestamp)
															},
														@{
															@"text": @"I'd far rather be happy than right any day.",
															@"date": [NSDate date],
															@"type": @(AMBubbleCellReceived),
															@"username": @"John",
															@"color": [UIColor orangeColor]
															},
														@{
															@"text": @"The only reason for walking into the jaws of Death is so's you can steal His gold teeth.",
															@"date": [NSDate date],
															@"type": @(AMBubbleCellSent)
															},
														@{
															@"text": @"The gods had a habit of going round to atheists' houses and smashing their windows.",
															@"date": [NSDate date],
															@"type": @(AMBubbleCellReceived),
															@"username": @"Jimi",
															@"color": [UIColor blueColor]
															},
														@{
															@"text": @"you are lucky. Your friend is going to meet Bel-Shamharoth. You will only die.",
															@"date": [NSDate date],
															@"type": @(AMBubbleCellSent)
															},
														@{
															@"text": @"Guess the quotes!",
															@"date": [NSDate date],
															@"type": @(AMBubbleCellSent)
															},
														]
				 ]; */
	
	// Set a style
	[self setTableStyle:AMBubbleTableStyleFlat];
	
	[self setBubbleTableOptions:@{AMOptionsBubbleDetectionType: @(UIDataDetectorTypeAll),
								  AMOptionsBubblePressEnabled: @NO,
								  AMOptionsBubbleSwipeEnabled: @NO,
                                  AMOptionsButtonTextColor: [UIColor colorWithRed:1.0f green:1.0f blue:184.0f/256 alpha:1.0f]}];
	
	// Call super after setting up the options
	[super viewDidLoad];
 
    [self.tableView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
    
//    [self fakeMessages];
}

- (void)registerN
{
    AMAppDelegate *app = (AMAppDelegate *)[UIApplication sharedApplication].delegate;
    
    [client addPushNotificationsOnChannels:@[channelID] withDevicePushToken:app.finalDeviceToken andCompletion:^(PNAcknowledgmentStatus *status)
    {
        
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self getPreviousMessages];
}

- (void)getPreviousMessages
{
//48b68531dc6fcda2c0cc51bd4cc7bdf837c3ccacf154f956773662820f015ed1 iphone5
    //14371195972162811
    //14371196895115179
    
/*
    
    [client timeWithCompletion:^(PNTimeResult *result, PNErrorStatus *status) {
        

        [client historyForChannel:channelID start:@(0) end:result.data.timetoken limit:10 reverse:NO withCompletion:^(PNHistoryResult *result, PNErrorStatus *status)
         {
             
             [client historyForChannel:channelID start:result.data.start end:result.data.end limit:10 reverse:YES withCompletion:^(PNHistoryResult *result, PNErrorStatus *status)
              {
                  
                  
                  
              }];
             
             NSArray *previousMessages = result.data.messages;
             
             if (![result.data.end  isEqual: @(0)] && ![result.data.start  isEqual: @(0)])
             {
                 for (NSDictionary *messages in previousMessages)
                 {
                     AMBubbleCellType cellType;
                     
                     if ([messages[@"name"] isEqualToString:name])
                     {
                         cellType = AMBubbleCellSent;
                     }
                     else if(messages[@"name"])
                     {
                         cellType = AMBubbleCellReceived;
                     }
                     else
                     {
                         cellType = AMBubbleCellTimestamp;
                     }
                     
                     [self.data addObject:@{ @"text": messages[@"message"],
                                             @"date": [NSDate date],
                                             @"type": @(cellType)
                                             }];
                 }
                
                 [self.tableView reloadData];
                 // Either do this:
                 [self scrollToBottomAnimated:YES];
             }
         }];
    }];
    */
   
    /*
     start : 14371195972162811 end : 14371260186602827
     */
   
    [client historyForChannel:channelID withCompletion:^(PNHistoryResult *result, PNErrorStatus *status)
    {
        NSArray *previousMessages = result.data.messages;
        NSLog(@"start : %@ end : %@",result.data.start,result.data.end);
        nubmer = result.data.start;
        if (![result.data.end  isEqual: @(0)] && ![result.data.start  isEqual: @(0)])
        {
            for (NSDictionary *messages in previousMessages)
            {
                AMBubbleCellType cellType;
                
                if ([messages[@"name"] isEqualToString:name])
                {
                    cellType = AMBubbleCellSent;
                }
                else if(messages[@"name"])
                {
                    cellType = AMBubbleCellReceived;
                }
                else
                {
                    cellType = AMBubbleCellTimestamp;
                }
                if (messages[@"message"])
                {
                    [self.data addObject:@{ @"text": messages[@"message"],
                                            @"date": [NSDate date],
                                            @"type": @(cellType)
                                            }];
                }
                
            }
          
            [self.tableView reloadData];
            // Either do this:
            [self scrollToBottomAnimated:YES];
        }

    }]; 
}

-(void)myPubnubConnect
{
    pubKey = @"pub-c-4940fbcb-8224-4d8c-b6d1-3f687dc42593";
    subKey = @"sub-c-6d557374-2c83-11e5-8bfc-02ee2ddab7fe";
    authKey = @"abcx";
    
    self.myConfig = [PNConfiguration configurationWithPublishKey:pubKey subscribeKey:subKey];
    
    [self updateClientConfiguration];
    
    client = [PubNub clientWithConfiguration:self.myConfig];

    [client addListener:self];
    
    [client subscribeToChannels:@[channelID] withPresence:YES];
    


    
}

- (void)updateClientConfiguration
{
    
    // Set PubNub Configuration
    self.myConfig.TLSEnabled = NO;
    self.myConfig.uuid = name;
    self.myConfig.origin = @"pubsub.pubnub.com";
    self.myConfig.authKey = authKey;
    
    // Presence Settings
    self.myConfig.presenceHeartbeatValue = 20;
    self.myConfig.presenceHeartbeatInterval = 10;
    
    // Cipher Key Settings
    //self.client.cipherKey = @"enigma";
    
    // Time Token Handling Settings
    self.myConfig.keepTimeTokenOnListChange = YES;
    self.myConfig.restoreSubscription = YES;
    self.myConfig.catchUpOnSubscriptionRestore = YES;
    
    
    
    
    
}

- (IBAction)btnNextTap:(id)sender
{
    
//    NSInteger intNumber = [nubmer integerValue];
//
//    intNumber = intNumber;
    
    [client historyForChannel:channelID start:nubmer end:nil limit:10 reverse:YES includeTimeToken:YES withCompletion:^(PNHistoryResult *result, PNErrorStatus *status)
    {
     
    }];
}

- (void)client:(PubNub *)client didReceivePresenceEvent:(PNPresenceEventResult *)event
{
    
    NSLog(@"^^^^^ Did receive presence event: %@", event.data.presenceEvent);
}

#pragma mark - Subscribe Method

- (void)client:(PubNub *)client didReceiveMessage:(PNMessageResult *)message
{
    NSLog(@"Received message: %@ on channel %@ at %@", message.data.message,
          message.data.subscribedChannel, message.data.timetoken);
    
    if (message.data.actualChannel)
    {
        
    }
    else
    {
        
    }
    
    NSString *s = [NSString stringWithFormat:@"%@",[message.data.message valueForKey:@"message"]];
    
    AMBubbleCellType cellType;
    
    if ([message.data.message[@"name"] isEqualToString:name])
    {
        cellType = AMBubbleCellSent;
    }
    else if(message.data.message[@"name"])
    {
        cellType = AMBubbleCellReceived;
    }
    else
    {
        cellType = AMBubbleCellTimestamp;
    }
    
    [self.data addObject:@{ @"text": s,
                            @"date": [NSDate date],
                            @"type": @(cellType)
                            }];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.data.count - 1) inSection:0];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    [self.tableView endUpdates];
    // Either do this:
    [self scrollToBottomAnimated:YES];
    //Or
    //[super reloadTableScrollingToBottom:YES];
    
}

- (void)client:(PubNub *)client didReceiveStatus:(PNSubscribeStatus *)status {
    
    if (status.category == PNUnexpectedDisconnectCategory) {
    }
    
    else if (status.category == PNConnectedCategory) {
        
    }
    else if (status.category == PNReconnectedCategory)
    {
        
    }
    else if (status.category == PNDecryptionErrorCategory)
    {
        
    }
}

- (void)fakeMessages
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self didSendText:@"Fake message here!"];
        [self fakeMessages];
    });
}

- (void)swipedCellAtIndexPath:(NSIndexPath *)indexPath withFrame:(CGRect)frame andDirection:(UISwipeGestureRecognizerDirection)direction
{
	NSLog(@"swiped");
}

#pragma mark - AMBubbleTableDataSource

- (NSInteger)numberOfRows
{
	return self.data.count;
}

- (AMBubbleCellType)cellTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [self.data[indexPath.row][@"type"] intValue];
}

- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return self.data[indexPath.row][@"text"];
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [NSDate date];
}

- (UIImage*)avatarForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [UIImage imageNamed:@"avatar"];
}

#pragma mark - AMBubbleTableDelegate

- (void)didSendText:(NSString*)text
{
//    [client publish:@{@"name":name, @"message":text} toChannel:channelID  withCompletion:^(PNPublishStatus *status)
//     {
//         if (!status.isError)
//         {
//             
//         }
//         else
//         {
//             
//         }
//     }];
    
    
    
    
  

    NSDictionary *f = @{
                        @"alert": @"This is a push notification",
                        @"badge": @2,
                        @"sound": @"bingbong.aiff"
                        };
    
    NSDictionary *dic = @{@"aps":f
                          };
    
    NSDictionary *fic = @{@"apns" :dic
                          };
    
    [client publish:@{@"name":name, @"message":text} toChannel:channelID mobilePushPayload:fic
     storeInHistory:YES withCompletion:^(PNPublishStatus *status)
     {
        
    }];
    
    
	
	
    // or this:
	// [super reloadTableScrollingToBottom:YES];
}

- (NSString*)usernameForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return self.data[indexPath.row][@"username"];
}

- (UIColor*)usernameColorForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return self.data[indexPath.row][@"color"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
