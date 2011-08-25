//
//	QWTestMode.h
//  QuattroWirelessLib
//
//	Copyright 2008, 2009 Quattro Wireless. All rights reserved.
//



#import <Foundation/Foundation.h>



typedef enum {
	QWProductionMode = 0,
	QWTestMode=1,
	QWQualityAssuranceMode=2,
	QWStagingMode=3
} QWRunModeType;


void QWSetRunMode(QWRunModeType mode);
QWRunModeType QWRunMode();

void QWSetTestMode(BOOL on);
BOOL QWIsTestModeOn();


void QWSetLogging(BOOL on);
BOOL QWIsLoggingOn();
