//
//  Applytics.h
//  Copyright 2009 Applytics. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AddressBook/AddressBook.h>
#import "ApplyfireDelegateProtocol.h"

@interface ApplyfireView : UIView <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UISearchBarDelegate> {
	id<ApplyfireDelegateProtocol> delegate;
	
	// Configuration
	NSString *appKey;
	NSString *inviteMessage, *inviteUsername, *invitePhone;
	
	// Addressbook (private)
	ABAddressBookRef addressBook;
	NSMutableArray *contacts, *filteredContacts, *groupNames, *filteredGroupNames;
	NSMutableDictionary *groups, *filteredGroups;

	// UI Elements (private)
	UITableView *contactSelector, *filteredContactSelector;

	UIAlertView *inviteAlert, *infoAlert, *infoErrorAlert, *errorAlert;
	UITextField *nameTextField, *phoneTextField;
	
	UISearchBar *searchBar;
	UIButton *greyView;

	UIToolbar *toolbar;
	UIBarButtonItem *sendButton, *skipButton, *spacerButton, *countButton;
	
	UIView *loadingView;
	UIActivityIndicatorView *loadingIndicator;
	UILabel *loadingLabel;
	
	// XML
	NSMutableString *currentElement, *currentContents;
	
	int forces, selectCount;
}

// Setup
- (void) setAppKey:(NSString*)appKey;
- (void) setDelegate:(id<ApplyfireDelegateProtocol>)delegate;

// UI Elements
- (void) setPrompt:(NSString*)prompt; // The text above the search bar
- (void) setBarStyle:(UIBarStyle)barStyle;
- (void) setTintColor:(UIColor*)color;

// Invite
- (void) setInviteMessage:(NSString*)message;
- (void) setInvitePhone:(NSString*)phone;
- (void) setInviteUsername:(NSString*)name;
- (void) showInviteAlert;
- (void) noContacts;

@end
