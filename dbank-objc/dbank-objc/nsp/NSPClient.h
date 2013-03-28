//
//  NSPClient.h
//  dbank-objc
//
//  Created by 江宇英 on 13-3-27.
//
//

#import <Foundation/Foundation.h>

extern NSString *NSPVFSUpAuth;;
extern NSString *NSPVFSMkFile;
extern NSString *NSPVFSGetAttr;
extern NSString *NSPVFSLsDir;
extern NSString *NSPVFSCopyFile;
extern NSString *NSPVFSMoveFile;
extern NSString *NSPVFSRmFile;

extern NSString *NSPNetDiskRoot;

@interface NSPClient : NSObject {
	BOOL sysLevel;
    
	NSString *sessionID_;
	NSString *sessionSecret_;
}

@property (nonatomic, copy) NSString *sessionID;
@property (nonatomic, copy) NSString *secret;

+ (NSString *)authURLForAppID:(NSString *)anAppID;

- (NSPClient *)initWithSessionID:(NSString *)aSessionId
                andSessionSecret:(NSString *)aSessionSecret;

- (id)uploadFile:(NSString *)aFilepath
          toPath:(NSString *)aPath;
- (id)uploadFiles:(NSArray *)files
           toPath:(NSString *)aPath;

- (BOOL)downloadFile:(NSString *)aFilepath
            intoPath:(NSString *)aLocalFilepath;

- (id)callService:(NSString *)aServiceName
   withParameters:(id)parameters;

- (id)vfsService;
- (id)userService;

@end
