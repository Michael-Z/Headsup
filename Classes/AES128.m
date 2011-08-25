//
//  AES128.m
//  Headsup
//
//  Created by Haolan Qin on 4/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AES128.h"


@implementation AES128

- (void)testSymmetricEncryption {
	NSLog(@"testing symmetric encrypt/decrypt ...");
	NSString *_key = @"this is my secret key ... change me!";
	NSString *_secret = @"this is some secret text";
	NSData *_secretData = [_secret dataUsingEncoding:NSASCIIStringEncoding];
	CCOptions padding = kCCOptionPKCS7Padding;
	NSData *encryptedData = [self encrypt:_secretData key:[self md5data:_key] padding:&padding];
	NSLog(@"encrypted data: %@", encryptedData);
	NSData *data = [self decrypt:encryptedData key:[self md5data:_key] padding:&padding];
	NSLog(@"decrypted data: %@", data);
	NSString *str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	NSLog(@"decrypted string: %@", str);
	NSLog(@"test finished.");
}

- (NSData *)encrypt:(NSData *)plainText key:(NSData *)aSymmetricKey padding:(CCOptions *)pkcs7 {
    return [self doCipher:plainText key:aSymmetricKey context:kCCEncrypt padding:pkcs7];
}

- (NSData *)decrypt:(NSData *)plainText key:(NSData *)aSymmetricKey padding:(CCOptions *)pkcs7 {
    return [self doCipher:plainText key:aSymmetricKey context:kCCDecrypt padding:pkcs7];
}

- (NSData *)doCipher:(NSData *)plainText key:(NSData *)aSymmetricKey
			 context:(CCOperation)encryptOrDecrypt padding:(CCOptions *)pkcs7 {
    CCCryptorStatus ccStatus = kCCSuccess;
    // Symmetric crypto reference.
    CCCryptorRef thisEncipher = NULL;
    // Cipher Text container.
    NSData * cipherOrPlainText = nil;
    // Pointer to output buffer.
    uint8_t * bufferPtr = NULL;
    // Total size of the buffer.
    size_t bufferPtrSize = 0;
    // Remaining bytes to be performed on.
    size_t remainingBytes = 0;
    // Number of bytes moved to buffer.
    size_t movedBytes = 0;
    // Length of plainText buffer.
    size_t plainTextBufferSize = 0;
    // Placeholder for total written.
    size_t totalBytesWritten = 0;
    // A friendly helper pointer.
    uint8_t * ptr;
	
    // Initialization vector; dummy in this case 0's.
	NSInteger kChosenCipherBlockSize = 64;
	NSInteger kChosenCipherKeySize = 64;
	
    uint8_t iv[kChosenCipherBlockSize];
    memset((void *) iv, 0x0, (size_t) sizeof(iv));
	
    NSLog(@"doCipher: plaintext: %@", plainText);
    NSLog(@"doCipher: key length: %d", [aSymmetricKey length]);
	
    LOGGING_FACILITY(plainText != nil, @"PlainText object cannot be nil." );
    LOGGING_FACILITY(aSymmetricKey != nil, @"Symmetric key object cannot be nil." );
    LOGGING_FACILITY(pkcs7 != NULL, @"CCOptions * pkcs7 cannot be NULL." );
    LOGGING_FACILITY([aSymmetricKey length] == kChosenCipherKeySize, @"Disjoint choices for key size." );
	
    plainTextBufferSize = [plainText length];
	
    LOGGING_FACILITY(plainTextBufferSize > 0, @"Empty plaintext passed in." );
	
    NSLog(@"pkcs7: %d", *pkcs7);
    // We don't want to toss padding on if we don't need to
    if(encryptOrDecrypt == kCCEncrypt) {
        if(*pkcs7 != kCCOptionECBMode) {
            if((plainTextBufferSize % kChosenCipherBlockSize) == 0) {
                *pkcs7 = 0x0000;
            } else {
                *pkcs7 = kCCOptionPKCS7Padding;
            }
        }
    } else if(encryptOrDecrypt != kCCDecrypt) {
        LOGGING_FACILITY1( 0, @"Invalid CCOperation parameter [%d] for cipher context.", *pkcs7 );
    } 
	
    // Create and Initialize the crypto reference.
    ccStatus = CCCryptorCreate(encryptOrDecrypt,
                               kCCAlgorithmAES128,
                               *pkcs7,
                               (const void *)[aSymmetricKey bytes],
                               kChosenCipherKeySize,
                               (const void *)iv,
                               &thisEncipher
                               );
	
    LOGGING_FACILITY1( ccStatus == kCCSuccess, @"Problem creating the context, ccStatus == %d.", ccStatus );
	
    // Calculate byte block alignment for all calls through to and including final.
    bufferPtrSize = CCCryptorGetOutputLength(thisEncipher, plainTextBufferSize, true);
	
    // Allocate buffer.
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t) );
	
    // Zero out buffer.
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
	
    // Initialize some necessary book keeping.
	
    ptr = bufferPtr;
	
    // Set up initial size.
    remainingBytes = bufferPtrSize;
	
    // Actually perform the encryption or decryption.
    ccStatus = CCCryptorUpdate(thisEncipher,
                               (const void *) [plainText bytes],
                               plainTextBufferSize,
                               ptr,
                               remainingBytes,
                               &movedBytes
                               );
	
    LOGGING_FACILITY1( ccStatus == kCCSuccess, @"Problem with CCCryptorUpdate, ccStatus == %d.", ccStatus );
	
    // Handle book keeping.
    ptr += movedBytes;
    remainingBytes -= movedBytes;
    totalBytesWritten += movedBytes;
	
    /* From CommonCryptor.h:
	 
     @enum      CCCryptorStatus
     @abstract  Return values from CommonCryptor operations.
	 
     @constant  kCCSuccess          Operation completed normally.
     @constant  kCCParamError       Illegal parameter value.
     @constant  kCCBufferTooSmall   Insufficent buffer provided for specified operation.
     @constant  kCCMemoryFailure    Memory allocation failure.
     @constant  kCCAlignmentError   Input size was not aligned properly.
     @constant  kCCDecodeError      Input data did not decode or decrypt properly.
     @constant  kCCUnimplemented    Function not implemented for the current algorithm.
	 
     enum {
	 kCCSuccess          = 0,
	 kCCParamError       = -4300,
	 kCCBufferTooSmall   = -4301,
	 kCCMemoryFailure    = -4302,
	 kCCAlignmentError   = -4303,
	 kCCDecodeError      = -4304,
	 kCCUnimplemented    = -4305
	 };
	 typedef int32_t CCCryptorStatus;
	 */
	
    // Finalize everything to the output buffer.
    ccStatus = CCCryptorFinal(thisEncipher,
                              ptr,
                              remainingBytes,
                              &movedBytes
                              );
	
    totalBytesWritten += movedBytes;
	
    if(thisEncipher) {
        (void) CCCryptorRelease(thisEncipher);
        thisEncipher = NULL;
    }
	
    LOGGING_FACILITY1( ccStatus == kCCSuccess, @"Problem with encipherment ccStatus == %d", ccStatus );
	
    if (ccStatus == kCCSuccess)
        cipherOrPlainText = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)totalBytesWritten];
    else
        cipherOrPlainText = nil;
	
    if(bufferPtr) free(bufferPtr);
	
    return cipherOrPlainText;
	
    /*
     Or the corresponding one-shot call:
	 
     ccStatus = CCCrypt(    encryptOrDecrypt,
     kCCAlgorithmAES128,
     typeOfSymmetricOpts,
     (const void *)[self getSymmetricKeyBytes],
     kChosenCipherKeySize,
     iv,
     (const void *) [plainText bytes],
     plainTextBufferSize,
     (void *)bufferPtr,
     bufferPtrSize,
     &movedBytes
     );
     */
}
@end
