//
//  QWAdView.h
//  QuattroWirelessLib
//
//	Copyright 2008, 2009 Quattro Wireless. (http://quattrowireless.com)
//	All rights reserved.
//
//
// Please see the wiki for details http://wiki.quattrowireless.com/index.php/IPhone_SDK


#import <UIKit/UIKit.h>
#import "QWAd.h"


typedef enum {
	QWEducationNoCollege = 0,
	QWEducationCollegeGraduate,
	QWEducationGraduateSchool,
	QWEducationUnknown
} QWEducationLevel;

typedef enum {
	QWGenderFemale = 0,
	QWGenderMale,
	QWGenderUnknown
} QWGender;


typedef enum {
	QWDisplayModeStatic = 0,
	QWDisplayModeAged,
	QWDisplayModeRotation
} QWDisplayMode;


#pragma mark -
#pragma mark QWAdRequest

@interface QWAdRequest : NSObject
{
    QWAdType _adType;
    NSUInteger _batchSize;
    QWMaxW _size;
}

@property (assign) QWAdType adType;
@property (assign) NSUInteger batchSize;
@property (assign) QWMaxW size;

+ (QWAdRequest *)adRequestsForType:(QWAdType)type batchSize:(NSUInteger)size;
+ (QWAdRequest *)adRequestsForType:(QWAdType)type batchSize:(NSUInteger)size msize:(QWMaxW)msize;

@end



#pragma mark -
#pragma mark QWADView

@class CATransition;
@protocol QWAdViewDelegate;

@interface QWAdView : UIView {
	@private
	QWAd *_currentAd;
	id<QWAdViewDelegate> _delegate;
	UIFont *_font;
	UIColor *_textColor;
	CATransition *_adTransition;
	NSTimeInterval _adTransitionInterval;
	NSString *_publisherID;
	NSString *_siteID;
	BOOL _openInSafari;
	QWPlacement _placement;
    QWMaxW _msize;
	NSString *_section;
	QWDisplayMode _displayMode;
	UIBarStyle _webToolbarStyle;
    UIColor *_webToolbarTintColor;

    QWAdType _realType;
    BOOL _closeButton;          // interstitial
    BOOL _hideActionText;       // suppress action text display
}
@property (assign) QWAdType realType;
@property (assign) BOOL hideActionText;
@property (assign) BOOL closeButton;
@property (readwrite) QWMaxW msize;

/*
 *	Delegate implementing the QWAdViewDelegate protocol
 */
@property (assign) id<QWAdViewDelegate> delegate;

/*
 *	Quattro Supplied ad request attributes
 */
@property (copy) NSString *publisherID;
@property (copy) NSString *siteID;
@property (copy) NSString *section;

/*
 * Placement of the Ad
 */
@property (assign) QWPlacement placement; 

/*
 *	The currently displayed ad
 */
@property (retain) QWAd *ad;

/*
 *	Ad transitions
 */
@property (assign) QWDisplayMode displayMode;		// static, aged, auto rotated.
@property (assign) NSTimeInterval adInterval;		// default is zero, or never.
@property (retain) CATransition *adTransition;		// default is nil, no transition

/*
 *	Set the action text attributes.
 */
@property (retain) UIFont *font;
@property (retain) UIColor *textColor;


/*
 *	Set to YES to open ads in Mobile Safar
 */
@property (assign) BOOL openInSafari;

/*
 *	Set the web view's toolbar style and tint
 */
@property (assign) UIBarStyle webToolbarStyle;
@property (assign) UIColor *webToolbarTintColor;


// calculates size based on content and flags
- (CGRect)desiredFrame;


/*
 *	Set test mode on/off.
 */
+ (void)setTestMode:(BOOL)on;		// default is NO (off)

/** Return library build info
 */
+ (NSString *)libBuildInfo;

/*
 *	Error Report
 */
+ (NSString *)errorReport;
+ (void)clearErrorLog;


/*
 *	Cache Report
 */
+ (NSString *)cacheReport;


/*
 *	Cached Ads Count
 */
+ (NSUInteger)cachedAdsCount:(QWAdType)type
				 publisherID:(NSString *)publisherID
					  siteID:(NSString *)siteID
				   placement:(QWPlacement)placement
					 section:(NSString *)section;

+ (NSUInteger)cachedAdsCount:(QWAdType)type
				 publisherID:(NSString *)publisherID
					  siteID:(NSString *)siteID
				   placement:(QWPlacement)placement
					 section:(NSString *)section
                     size:(QWMaxW)size; // max size

/** runtime helpers
*/
+ (BOOL)isPhoneOS3;
+ (BOOL)isPhoneOS2;


/*
 *	Returns a new ad view with specified type and orientation, 
 *	ready to be added to the view hierarchy. Ads are requested 
 *	one at a time in real-time.  Impressions are counted by 
 *	the server.
 */
+ (QWAdView *)adViewWithType:(QWAdType)adType 
				 publisherID:(NSString *)publisherID
					  siteID:(NSString *)siteID
				 orientation:(UIInterfaceOrientation)orientation 
					delegate:(id<QWAdViewDelegate>)delegate;



+ (QWAdView *)adViewWithType:(QWAdType)adType 
				 publisherID:(NSString *)publisherID
					  siteID:(NSString *)siteID
				   placement:(QWPlacement)placement
					 section:(NSString*)section
				 orientation:(UIInterfaceOrientation)orientation 
					delegate:(id<QWAdViewDelegate>)delegate;


/*
 *	Returns a new ad view in batch mode with specified type and 
 *	orientation, ready to be added to the view hierarchy. Batch 
 *	mode forces the ad view to retrieve multiple ads at a time 
 *	instead of one ad at a time.  Impressions are counted locally 
 *	on the device and need to be reported back to the ad server 
 *	using the -(void)submitReport method.
 */
+ (QWAdView *)batchAdViewWithType:(QWAdType)adType 
					  publisherID:(NSString *)publisherID
						   siteID:(NSString *)siteID
						batchSize:(NSUInteger)batchSize 
					  orientation:(UIInterfaceOrientation)orientation 
						 delegate:(id<QWAdViewDelegate>)delegate;

+ (QWAdView *)batchAdViewWithType:(QWAdType)adType 
					  publisherID:(NSString *)publisherID
						   siteID:(NSString *)siteID
						placement:(QWPlacement)placement
						  section:(NSString *)section
						batchSize:(NSUInteger)batchSize 
					  orientation:(UIInterfaceOrientation)orientation 
						 delegate:(id<QWAdViewDelegate>)delegate;


/*
 *	Prefetch a batch of ads from the Quattro server and store them in the central cache
 *	for later use by any QWAdView instance.  Later batch requests will use the prefetched 
 *	ads first, before making another network request.
 *
 *		adTypes is an array of QWAdRequest
 */
- (void)prefetchAds:(NSArray *)adRequests; 


/*
 *	Forces ad view to display a new ad.  If no ads are cached locally, a new one
 *	will be requested from the ad server. 
 *
 *	Returns immediately, operation performed on a background thread.
 */
- (void)displayNewAd;

/*
 * Submits impressions data back to the ad server.  
 *
 * Returns immediately, operation performed on a background thread.
 *
 * DEPRECATED no longer required
 */
- (void)submitReport;


/*
 * Submits impressions data back to the ad server.  Blocks until report returns.
 *
 * DEPRECATED no longer required
 */
- (void)submitSynchronousReport;


@end




#pragma mark -
#pragma mark QWAdViewDelegate

/* 
 *	IMPORTANT:  There are three things to keep in mind when implementing
 *	your QWAdViewDelegate methods:
 *
 *	1. Before releasing an instance of QWAdView for which you have set a 
 *	delegate, you must first set the QWAdView delegate property to nil before 
 *	disposing of the QWAdView instance. This can be done, for example, in the 
 *	dealloc method where you dispose of the QWAdView.
 *
 *	2. Make sure that any code you execute inside your method implementations
 *	are relatively quick.  Many of these methods block further execution
 *	of ad requests until they return.
 *
 *	3. Some of these methods are called from background threads. Therefore your
 *	method implmentations will need to be thread-safe.  These methods are listed 
 *	at the bottom of this protocol definition.
 *
 */
@protocol QWAdViewDelegate<NSObject>

#pragma mark Required
@required

/*
 *	The following required delegate methods provide a view controller
 *	containing the web view displaying the ad's landing page.  You will
 *	need to add and remove this controller's view to and from your application's view hierarchy.
 *
 *	This is normally done using UIViewController's method:
 *		
 *		- (void)presentModalViewController:(UIViewController *)modalViewController 
 *                                animated:(BOOL)animated
 *		- (void)dismissModalViewControllerAnimated:(BOOL)animated
 */

- (void)adView:(QWAdView *)adView displayLandingPage:(UIViewController *)controller;
- (void)adView:(QWAdView *)adView dismiss:(UIViewController *)controller;


#pragma mark Optional
@optional


/*
 *	Allows you to provide a default ad or placeholder ad to be displayed when ads have not yet been 
 *	downloaded from the server or when no ads are available.
 */
- (QWAd *)defaultAd:(QWAdView *)adView;


/*
 *	Called when the device orientation changes.  This lets the QWAdView's web view know if it is allowed
 *	to change orientation.  This is similar to UIViewController's method:
 *
 *	- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
 *
 */
- (BOOL)adView:(QWAdView *)adView webViewShouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;


/*
 *	The following methods are used to communicate ad targeting
 *	data to the QWAdView when it requests ads from the server.
 *
 */
- (double)longitude:(QWAdView *)adView;
- (double)latitude:(QWAdView *)adView;

// geo param
- (NSString *)zipcode:(QWAdView *)adView;
- (NSString *)dma:(QWAdView *)adView;
- (NSString *)area:(QWAdView *)adView;
- (NSString *)mdn:(QWAdView *)adView;

- (NSUInteger)age:(QWAdView *)adView;
- (QWGender)gender:(QWAdView *)adView;
- (NSUInteger)income:(QWAdView *)adView;
- (QWEducationLevel)education:(QWAdView *)adView;
- (NSDate *)birthdate:(QWAdView *)adView;
- (QWEthnicity)ethnicity:(QWAdView *)adView;

/*
 *	The following methods notify the delegate of important events that
 *	may occur over the lifetime of a QWAdView.
 *
 */
- (void)adView:(QWAdView *)adView willDisplayAd:(QWAd *)ad;
- (void)adView:(QWAdView *)adView didDisplayAd:(QWAd *)ad;

- (void)adView:(QWAdView *)adView willFollowClick:(QWAd *)ad;
- (void)adView:(QWAdView *)adView didFollowClick:(QWAd *)ad;

- (void)adView:(QWAdView *)adView willCloseAd:(QWAd *)ad;
- (void)adView:(QWAdView *)adView didCloseAd:(QWAd *)ad;

/*
 *	IMPORTANT:  The following methods will be called from background threads.  Therefore
 *	it is important that any code executed inside these methods must be thread-safe
 *	and not directly interact with classes that are required to run on the main thread
 *	(i.e. UIKit user interface classes)
 *
 *	If you need to interact with main thread only code, make sure to use one of NSObject's 
 *		
 *		- performSelectorOnMainThread... method variants or similar mechanism.
 *
 */
- (void)adView:(QWAdView *)adView failedWithError:(NSError *)error;

- (void)adViewPrefetchCompleted:(QWAdView *)adView;

- (void)willRefreshCache:(QWAdView *)adView;

- (void)willRequestAd:(QWAdView *)adView;

/** Called by the ad view when laying out subviews - interstitial only. 
 * The delegate may perform operations which reset the adView.frame origin and/or 
 * size to effect rendering of the ad. 
 */
- (void)adView:(QWAdView *)adView processingLayout:(CGRect)desiredSize;

@end

// Indicate to the Quattro SDK  whether it can use location services for
// ads; default is YES.  Map-based ad landing pages will degrade if this is
// NO. This setting is application-wide and can be enabled at any time; note 
// once enabled, location services can not be stopped within the SDK until the 
// application terminates.
void QWEnableLocationServicesForAds(BOOL on);


