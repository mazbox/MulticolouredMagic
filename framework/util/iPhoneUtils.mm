/**
 * == Simplified BSD *** MODIFIED FOR NON-COMMERCIAL USE ONLY!!! *** ==
 * Copyright (c) 2011, Cariad Interactive LTD
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted 
 * provided that the following conditions are met:
 * 
 *   * Redistributions of source code must retain the above copyright notice, this list of 
 *     conditions and the following disclaimer.
 * 
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of 
 *     conditions and the following disclaimer in the documentation and/or other materials provided 
 *     with the distribution.
 * 
 *   * Any redistribution, use, or modification is done solely for personal benefit and not for any 
 *     commercial purpose or for monetary gain
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR 
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND 
 * FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR 
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
 * WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include "iPhoneUtils.h"
#include <Foundation/Foundation.h>

#ifdef HAS_MAIL_FEATURES
// from apple's reachability example 
#include "Reachability.h"

#include "iPhoneMailView.h"
#endif
#import <mach/mach.h>
#import <mach/mach_host.h>



// -------------------------------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark String functions
//
//NSString *cStringToNSString(char *s) {
//	return [NSString stringWithFormat:@"%s", s];
//}
//
//void NSStringToString(NSString *s, char *outStr) {
//	[s getCString:outStr];
//	[s UTF8String];
//}


// -------------------------------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Email stuff
#ifdef HAS_MAIL_FEATURES
bool canSendEmail() {
	return [MFMailComposeViewController canSendMail]?true:false;
}

MailListener *mailListener = NULL;

void mailSent() {
	printf("mailSent\n");
	if(mailListener!=NULL) {
		mailListener->mailSent();
		mailListener = NULL;
		printf("Listener::mailSent\n");
	}
#ifdef __DEBUG__
	Dprintf("Mail sent!\n");
#endif
}

void mailFailed() {
	printf("mailFailed\n");
	if(mailListener!=NULL) {
		mailListener->mailFailed();
		mailListener = NULL;
		printf("Listener::mailFailed\n");
	}
#ifdef __DEBUG__
	Dprintf("Mail failed to send\n");
#endif
}

void mailCancelled() {
	printf("mailCancelled\n");
	if(mailListener!=NULL) {
		mailListener->mailCancelled();
		mailListener = NULL;
		printf("Listener::mailCancelled\n");
	}
}

void mailSaved() {
	printf("mailSaved\n");
	if(mailListener!=NULL) {
		mailListener->mailSaved();
		mailListener = NULL;
		printf("Listener::mailSaved\n");
	}
}

iPhoneMailView *mailView = nil;

void getMimeType(char *path, char *outMimeType) {
	sprintf(outMimeType, "application/refract");
	
}
char *getFileNameFromPath(char *path) {
	char *slashptr = strrchr(path, '/');
	return (slashptr==NULL ?  path: slashptr+1);
	
}

void iPhoneSendEmail(char *to, char *subject, char *body, char *attachmentPath, MailListener *listener) {
	
	char mimeTypeStr[128];
	char filenameStr[128];
	NSData *data = nil;
	NSString *filename = nil;
	NSString *mimeType = nil;
	
	if(mailView==nil) {
		
		
		
		
		
		mailView = [[iPhoneMailView alloc] init];
		
		[mailView setSuccessCallback:&mailSent 
				   andFailedCallback:&mailFailed 
					andSavedCallback:&mailSaved
				andCancelledCallback:&mailCancelled];
		
	}
	// only do attachments if we're not null
	if(attachmentPath!=NULL) {
		// convert attachment to NSData
		data = [NSData dataWithContentsOfFile:cStringToNSString(attachmentPath)];
		
		// decide the mime type based on the filename extension
		getMimeType(attachmentPath, mimeTypeStr);
		mimeType = cStringToNSString(mimeTypeStr);
		
		// get just the filename from the path
		char *f = getFileNameFromPath(attachmentPath);
		printf("the file name is:%s\n", f);
		filename = cStringToNSString(f);
	}
	mailListener = listener;
	
	[mailView showMessage:cStringToNSString(to) 
			  withSubject:cStringToNSString(subject)
				 withBody:cStringToNSString(body)
		   withAttachment: data 
			 withFilename:filename 
			 withMimeType:mimeType];
}
#endif

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark finding iphone paths







string getTmpPath() {

 #if defined(__APPLE__) // && TARGET_OS_IOS
	 std::string _p;
	 if (@available(macOS 10.12, *)) {
		 NSURL *url = [[NSFileManager defaultManager] temporaryDirectory];
		 _p		   = [[url path] UTF8String];
	 } else {
		 // Fallback on earlier versions
		 _p = [NSTemporaryDirectory() UTF8String];
	 }

 #elif defined(__ANDROID__)
	 std::string _p = getAndroidTempDir();
 #else
	 std::string _p = fs::temp_directory_path().string();
 #endif
	 return _p;
 

}

string getBundlePath() {
	NSString *bundle_path_ns = [[NSBundle mainBundle] resourcePath];
	string input = [bundle_path_ns UTF8String];
	return input + "/";
}


#ifdef HAS_MAIL_FEATURES

bool hasInternetConnection() {
	return [[Reachability reachabilityForInternetConnection] currentReachabilityStatus]!=NotReachable;
	
}
#endif

int getFreeMemory() {
	mach_port_t host_port;
	mach_msg_type_number_t host_size;
	vm_size_t pagesize;
	host_port = mach_host_self();
	host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
	host_page_size(host_port, &pagesize);
	vm_statistics_data_t vm_stat;
	if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
		printf("Failed to fetch vm statistics\n");
		return 0;
	}
	/* Stats in bytes */
	natural_t mem_free = vm_stat.free_count * pagesize;
	return mem_free;
}



#pragma mark -
#pragma mark native alerts and warnings
void warnWithAlert(string title, string message) {
	// open an alert with just an OK button
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:cStringToNSString((char*)title.c_str()) message:cStringToNSString((char*)message.c_str())  delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
//	[alert show];
//	[alert release];
	NSLog(@"NOT IMPLEMENTED");
	assert(0);
}


void launchUrl(string url) {
//	NSString *urlStr = cStringToNSString((char*)url.c_str());
//	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
	NSLog(@"NOT IMPLEMENTED");
	assert(0);
}

string iPhoneGetDocsDir() {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return string([[paths objectAtIndex:0] UTF8String]) + "/";
}


std::string downloadFile(std::string url) {
#ifdef __APPLE__
	// the URL to save
	NSURL *urlNS = [NSURL URLWithString:[NSString stringWithUTF8String:url.c_str()]];

	NSError *error = nil;
	// turn it into a request and use NSData to load its content
	//	NSURLRequest *request = [NSURLRequest requestWithURL:urlNS];
	//	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSData *data = [NSData dataWithContentsOfURL:urlNS options:NSDataReadingUncached error:&error];

	if (error != nil) {
		NSLog(@"Error downloading data: %@", error);
		std::string errorMessage = [NSString stringWithFormat:@"Error downloading data: %@", error].UTF8String;
		throw std::runtime_error(std::string("Error downloading ") + url + " - " + errorMessage);
	}

	NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	if (str == nil) {
		throw std::runtime_error(std::string("Error downloading ") + url + " - Couldn't convert NSData to string in downloadUrl");
	}
	return [str UTF8String];
#else
	Log::e() << "No implementation of downloadUrl yet";
	return "";
#endif
}
