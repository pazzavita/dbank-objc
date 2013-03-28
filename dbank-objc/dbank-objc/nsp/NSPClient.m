//
//  NSPClient.m
//  dbank-objc
//
//  Created by 江宇英 on 13-3-27.
//
//

#import "NSPClient.h"
#import "JSONKit.h"
#import "Encoder.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "MD5.h"
#import "NSPVFS.h"
#import "NSPUser.h"

NSString *NSP_APP = @"nsp_app";
NSString *NSP_SID = @"nsp_sid";
NSString *NSP_KEY = @"nsp_key";
NSString *NSP_SVC = @"nsp_svc";
NSString *NSP_TS  = @"nsp_ts";
NSString *NSP_parameters = @"nsp_parameters";
NSString *NSP_FMT = @"nsp_fmt";
NSString *NSP_TSTR = @"nsp_tstr";

NSString *NSP_URL = @"http://api.dbank.com/rest.php";

NSString *NSPVFSUpAuth = @"nsp.vfs.upauth";
NSString *NSPVFSMkFile = @"nsp.vfs.mkfile";
NSString *NSPVFSGetAttr = @"nsp.vfs.getattr";
NSString *NSPVFSLsDir = @"nsp.vfs.lsdir";
NSString *NSPVFSCopyFile = @"nsp.vfs.copyfile";
NSString *NSPVFSMoveFile = @"nsp.vfs.movefile";
NSString *NSPVFSRmFile = @"nsp.vfs.rmfile";

NSString *NSPNetDiskRoot = @"/Netdisk/";

@implementation NSPClient
//鉴权账号与密钥
@synthesize sessionID=sessionID_;
@synthesize secret=secret_;

+ (NSString *)authURLForAppID:(NSString *)anAppID
{
    return [@"http://login.dbank.com/loginauth.php?nsp_app=" stringByAppendingString:anAppID];
}

- (void)setId:(NSString *)anId andSecret:(NSString *)anSecret
{
    self.sessionID = anId;
    self.secret = anSecret;
}

- (NSPClient *)initWithSessionID:(NSString *)aSessionId
                andSessionSecret:(NSString *)aSessionSecret
{
    self = [super init];
    if (self) {
        if ([sessionID_ isEqualToString: [NSString stringWithFormat:@"%ld",[aSessionId integerValue]]]) {
            sysLevel = YES;
        } else {
            sysLevel = NO;
        }
        [self setId:aSessionId andSecret:aSessionSecret];
    }
    
    return self;
}

- (id)uploadFile:(NSString *)aFilepath
          toPath:(NSString *)aPath
{
    return [self uploadFiles:[NSArray arrayWithObject:aFilepath]
                      toPath:aPath];
}

- (id)uploadFiles:(NSArray *)files
           toPath:(NSString *)aPath
{
        //获取上传地址以及临时密钥等信息
    id upauth = [self callService:NSPVFSUpAuth withParameters:nil];
    
        //上传文件
    NSUInteger i;
    NSUInteger count = [files count];
    id file;
    JSONDecoder *jsonDecoder = [[JSONDecoder alloc] init];
    NSMutableArray *upResult = [[NSMutableArray alloc] init];
    
    for (i = 0;i < count;i ++) {
        file = [files objectAtIndex:i];
        
        NSString *up = [NSString stringWithFormat:@"http://%@/upload/up.php",[upauth valueForKey:@"nsp_host"]];
        NSURL *url = [NSURL URLWithString:up];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[upauth valueForKey:@"nsp_tapp"] forKey:NSP_APP];
        [dict setObject:@"JSON" forKey:NSP_FMT];
        [dict setObject:[NSString stringWithFormat:@"%ld",time(NULL)] forKey:NSP_TS];
        [dict setObject:[upauth valueForKey:@"nsp_tstr"] forKey:NSP_TSTR];
        [dict setObject:[self getNSPKey:[upauth valueForKey:@"secret"] With:dict] forKey:NSP_KEY];
        
        NSArray *keys = [dict allKeys];
        NSUInteger j;
        NSUInteger c = [dict count];
        id key;
        id val;
        
        for (j = 0;j < c;j ++) {
            key = [keys objectAtIndex:j];
            val = [dict objectForKey:key];
            
            [request setPostValue:val forKey:key];
        }
        [request setFile:file forKey:@"Filedata"];
        [request startSynchronous];
        
        NSError *err = [request error];
        if (!err) {
            NSString *res = [request responseString];
            id upret = [jsonDecoder objectWithUTF8String:(const unsigned char *) [res UTF8String]
                                                  length:(unsigned int) [res length]];
            id fileData = [upret objectForKey:@"Filedata"];
            
            NSDictionary *mkfile = [[[NSDictionary alloc] initWithObjectsAndKeys:
                                     [fileData objectForKey:@"path"], @"url",
                                     [fileData objectForKey:@"sig"], @"sig",
                                     [fileData objectForKey:@"nsp_fid"], @"md5",
                                     [fileData objectForKey:@"name"], @"name",
                                     [fileData objectForKey:@"size"], @"size",
                                     [fileData objectForKey:@"ts"], @"ts",
                                     @"File" ,@"type", nil] autorelease];
            
            
            [upResult addObject:mkfile];
        }
        
        [dict release];
    }
    
    //更新网盘文件信息
    NSDictionary *parameters = [[NSDictionary alloc]
                                    initWithObjectsAndKeys:
                                    aPath, @"path",
                                    [upResult JSONString], @"files",
                                    nil];
    
    id mkres = [self callService:NSPVFSMkFile withParameters:parameters];
    
    [parameters release];
    
    [upResult release];
    [jsonDecoder release];
    
    return mkres;
}

- (BOOL)downloadFile:(NSString *)aFilepath
            intoPath:(NSString *)aLocalFilepath
{
    /* 获取网盘文件下载地址 */
    NSArray *files = [NSArray arrayWithObject:aFilepath];
    NSArray *fields = [NSArray arrayWithObject:@"url"];
    NSDictionary *send = [[NSDictionary alloc]
                            initWithObjectsAndKeys:
                            files, @"files",
                            fields, @"fields",
                            nil];
    
    id res = [self callService:NSPVFSGetAttr withParameters:send];
    
    /* 下载文件 */
    @try {
        NSString *downurl = [[[res objectForKey:@"successList"] objectAtIndex:0] objectForKey: @"url"];
        
        NSURL *url = [NSURL URLWithString:downurl];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setDownloadDestinationPath:aLocalFilepath];
        [request startSynchronous];
    }
    @catch (NSException *e) {
        NSLog(@"%@", [e name]);
        return NO;
    }
    
	return YES;
}

- (id)callService:(NSString *)aServiceName
   withParameters:(id)parameters
{
	NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
	if (sysLevel) {
		[dict setObject:self.sessionID forKey:NSP_APP];
	}
	else {
		[dict setObject:self.sessionID forKey:NSP_SID];
	}
	
	@try {
		NSString *series = [parameters JSONString];
		if (series == nil) {
			series = @"null";
		} else {
            NSArray *keys = [parameters allKeys];
            NSUInteger j;
            NSUInteger c = [parameters count];
            id key;
            id value;
            
            for (j = 0; j < c; ++j) {
                key = [keys objectAtIndex:j];
                value = [parameters objectForKey:key];
                
                if ([value isKindOfClass:[NSString class]]) {
                }
                else {
                    value = [value JSONString];
                }
                [dict setObject:value forKey:key];
            }
        }
        
        [dict setObject:series forKey:NSP_parameters];
        
		[dict setObject:aServiceName forKey:NSP_SVC];
		[dict setObject:[NSString stringWithFormat:@"%ld", time(NULL)] forKey:NSP_TS];
		[dict setObject:@"JSON" forKey:NSP_FMT];
		
		NSString *data = [self encodeData:dict];
		NSString *urlstr = [NSString stringWithFormat:@"%@?%@",NSP_URL,data];
        
		NSURL *url = [NSURL URLWithString:urlstr];
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
		[request startSynchronous];
        
		NSError *error = [request error];
		if (!error) {
			NSData *response = [request responseData];
			return [response objectFromJSONData];
		}
	}
	@catch (NSException * e) {
		NSLog(@"%@ %@",[e name],[e reason]);
        return nil;
	}
	
	return nil;
}

- (id)vfsService
{
    NSPVFS *service = [[NSPVFS alloc] initWithSessionID:self.sessionID andSessionSecret:self.secret];
    
    return [service autorelease];
}

- (id)userService
{
    NSPUser *service = [[NSPUser alloc] initWithSessionID:self.sessionID andSessionSecret:self.secret];
    
    return [service autorelease];
}

/**
 * 获取验证密钥
 */
-(NSString *)getNSPKey:(NSString *)sec With:(NSDictionary *)mdic
{
    NSString *md5str = [NSString stringWithString:sec];
    
    NSUInteger count = [mdic count];
    
    NSArray *keys = [[mdic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    id key,val;
    for(int i=0;i<count;i++)
        {
        key = [keys objectAtIndex:i];
        val = [mdic objectForKey:key];
        
        NSString *k = [NSString stringWithFormat:@"%@",key];
        NSString *v = [NSString stringWithFormat:@"%@",val];
        
        md5str = [md5str stringByAppendingString:k];
        md5str = [md5str stringByAppendingString:v];
        }
    
    return [[md5str md5] uppercaseString];
}

/**
 * 拼装get参数
 */
-(NSString *)encodeData:(NSDictionary *)parameters
{
    NSString *data = @"";
    NSString *md5str = self.secret;
    
    NSUInteger count = [parameters count];
    
    NSArray *keys = [[parameters allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    id key,val;
    for (int i = 0; i < count; ++i) {
        key = [keys objectAtIndex:i];
        val = [parameters objectForKey:key];
        
        md5str = [md5str stringByAppendingString:key];
        md5str = [md5str stringByAppendingString:val];
        
        data = [data stringByAppendingFormat:@"%@=%@&", key, [val urlencode]];
    }
    
    data = [data stringByAppendingString:NSP_KEY];
    data = [data stringByAppendingString:@"="];
    data = [data stringByAppendingString:[[md5str md5] uppercaseString]];
    
    return data;
}

@end
