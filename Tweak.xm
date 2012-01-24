#import "UIDevice-Hardware.h"
#import "ADAccount.h"

static NSDictionary* prefs;
static BOOL is4S;

%hook ADAceConnection
-(void)_startConnectionWithAceHost:(id)aceHost
{
	if(!is4S)
		%orig([prefs objectForKey:@"aceHost"]);
	else
		%orig;
}
-(void)startWithAceHost:(id)aceHost timeout:(double)timeout
{
	if(!is4S)
		%orig([prefs objectForKey:@"aceHost"], timeout);
	else
		%orig;
}
%end

%hook ADAccount
-(NSString*)aceHost
{
	if(!is4S)
		return [prefs objectForKey:@"aceHost"];
	else
		return %orig;
}
-(void)setAceHost:(NSString*)aceHost
{
	if(!is4S)
		%orig([prefs objectForKey:@"aceHost"]);
	else
		%orig;
}
-(NSString*)speechIdentifier
{
	if(!is4S)
		return [prefs objectForKey:@"speechId"];
	else
		return %orig;
}
-(void)setSpeechIdentifier:(NSString*)speechIdentifier
{
	if(!is4S)
		%orig([prefs objectForKey:@"speechId"]);
	else
		%orig;
}
-(NSString*)assistantIdentifier
{
	if(!is4S)
		return [prefs objectForKey:@"assistantId"];
	else
		return %orig;
}
-(void)setAssistantIdentifier:(NSString*)assistantIdentifier
{
	if(!is4S)
		%orig([prefs objectForKey:@"assistantId"]);
	else
		%orig;
}
-(BOOL)setValidationData:(id)data
{
	if(!is4S)
		return %orig([prefs objectForKey:@"sessionValidationData"]);
	else
		return %orig;
}
-(id)validationData
{
	if(!is4S)
		return [prefs objectForKey:@"sessionValidationData"];
	else
		return %orig;
}
+(id)accountForIdentifier:(id)identifier
{
	id obj = %orig;
	NSDictionary* keys = [NSDictionary dictionaryWithObjectsAndKeys:	[obj assistantIdentifier],	@"assistantId",
																		[obj speechIdentifier],		@"speechId",
																		[obj aceHost],				@"aceHost",
																		[obj validationData],		@"sessionValidationData",
																		nil];
	[keys writeToFile: @"/var/mobile/Library/Preferences/com.n00neimp0rtant.sirious.plist" atomically: YES];
	return %orig;
}
-(void)save
{
	%orig;
	NSDictionary* keys = [NSDictionary dictionaryWithObjectsAndKeys:	[self assistantIdentifier],	@"assistantId",
																		[self speechIdentifier],	@"speechId",
																		[self aceHost],				@"aceHost",
																		[self validationData],		@"sessionValidationData",
																		nil];
	[keys writeToFile: @"/var/mobile/Library/Preferences/com.n00neimp0rtant.sirious.plist" atomically: YES];
}
%end

%ctor {
	if([[UIDevice currentDevice] platformType] == UIDevice5iPhone)
		is4S = YES;
	else
		is4S = NO;
	
	if(!is4S)
	{
		if([[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/Preferences/com.n00neimp0rtant.sirious.plist"])
		{
			prefs = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.n00neimp0rtant.sirious.plist"];
		}
		else
		{
			prefs = [[NSDictionary alloc] initWithObjectsAndKeys:	@"paste X-Ace-Host here",	@"aceHost",
																	@"paste speechId here",		@"speechId",
																	@"paste assistantId here",	@"assistantId",
																	[NSData data],				@"sessionValidationData",
																	nil];
			[prefs writeToFile:@"/var/mobile/Library/Preferences/com.n00neimp0rtant.sirious.plist" atomically:YES];
		}
	}
	%init;
}