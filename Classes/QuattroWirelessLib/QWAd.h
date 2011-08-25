//
//  QWAd.h
//  QuattroWirelessLib
//
//	Copyright 2008, 2009 Quattro Wireless. (http://quattrowireless.com)
//	All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
	QWAdTypeBanner = 0,
	QWAdTypeBannerNoText=1, // deprecated
	QWAdTypeText=2,
	QWAdTypeInterstitial=3,
	QWAdTypeUnknown=4
} QWAdType;


typedef enum {
	QWPlacementTop = 0,
	QWPlacementMiddle,
	QWPlacementBottom,
	QWPlacementUnknown
} QWPlacement;

typedef enum {
    QWEthnicGroupAfrican_American=0,  
    QWEthnicGroupAsian=1, 
    QWEthnicGroupHispanic=2,  
    QWEthnicGroupWhite=3,
    QWEthnicGroupOther=4
} QWEthnicity;

typedef enum {
	QWDefaultW = 999,
    QWAlternative=216,
} QWMaxW;

@interface QWAd : NSObject {

	@private
    NSString *_dbid;
	NSString *_text;
	NSURL *_url;
	UIImage *_image;
	CGFloat _imageHeight;
	CGFloat _imageWidth;
	NSString *_adID;
	QWAdType _type;
	QWAdType _subtype;
	NSDate *_expireDate;
	NSUInteger _impressionsReserved;
	NSUInteger _impressionsServed;
	NSString *_batchID;
	NSString *_imageUUID;
	NSURL *_dataURL;
    NSArray *_tracking;
    NSUInteger _adPrivate;
	NSString *_richtext;
    NSString *_zipurl;
}

@property (copy) NSString *text;
@property (copy) NSURL *url;
@property (retain) UIImage *image;
@property QWAdType type;
@end
