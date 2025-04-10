#import <OneSignalExtension/OneSignalExtension.h>
#import "NotificationService.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNNotificationRequest *receivedRequest;
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

// Note, this extension only runs when mutable-content is set
// Setting an attachment or action buttons automatically adds this
- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.receivedRequest = request;
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];

    // DEBUGGING: Uncomment the 2 lines below and comment out the one above to ensure this extension is executing
//     NSLog(@"Running NotificationServiceExtension");
//     self.bestAttemptContent.body = [@"[Modified] " stringByAppendingString:self.bestAttemptContent.body];

    [OneSignalExtension didReceiveNotificationExtensionRequest:self.receivedRequest
                       withMutableNotificationContent:self.bestAttemptContent
                                   withContentHandler:self.contentHandler];
}

- (void)serviceExtensionTimeWillExpire {
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.

    [OneSignalExtension serviceExtensionTimeWillExpireRequest:self.receivedRequest withMutableNotificationContent:self.bestAttemptContent];

    self.contentHandler(self.bestAttemptContent);
}

@end
