@class ApplyfireView;

@protocol ApplyfireDelegateProtocol <NSObject>

@required

- (void) didInvite:(ApplyfireView *)inviteView;
- (void) didSkip:(ApplyfireView *)inviteView;
- (void) didFail:(ApplyfireView *)inviteView error:(NSError*)error;
- (void) isDisabled:(ApplyfireView *)inviteView;
- (void) noContacts:(ApplyfireView *)inviteView;

@end
