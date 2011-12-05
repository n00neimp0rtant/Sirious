static NSDictionary* prefs;

%hook ADAceConnection
-(void)_startConnectionWithAceHost:(id)aceHost
{
	%orig([prefs objectForKey:@"aceHost"]);
}
-(void)startWithAceHost:(id)aceHost timeout:(double)timeout
{
	%orig([prefs objectForKey:@"aceHost"], timeout);
}
%end

%hook ADAccount
-(NSString*)aceHost
{
	return [prefs objectForKey:@"aceHost"];
}
-(void)setAceHost:(NSString*)aceHost
{
	%orig([prefs objectForKey:@"aceHost"]);
}
-(NSString*)speechIdentifier
{
	return [prefs objectForKey:@"speechId"];
}
-(void)setSpeechIdentifier:(NSString*)speechIdentifier
{
	%orig([prefs objectForKey:@"speechId"]);
}
-(NSString*)assistantIdentifier
{
	return [prefs objectForKey:@"assistantId"];
}
-(void)setAssistantIdentifier:(NSString*)assistantIdentifier
{
	%orig([prefs objectForKey:@"assistantId"]);
}
-(BOOL)setValidationData:(id)data
{
	if([[prefs objectForKey:@"shouldUseCachedValidationData"] isEqual:[NSNumber numberWithBool:YES]])
	{
		NSLog(@"Using cached validation data");
		return %orig([prefs objectForKey:@"sessionValidationData"]);
	}
	else
	{
		NSLog(@"NOT using cached validation data");
		return %orig();
	}
}
-(id)validationData
{
	if([[prefs objectForKey:@"shouldUseCachedValidationData"] isEqual:[NSNumber numberWithBool:YES]])
	{
		NSLog(@"Using cached validation data");
		return [prefs objectForKey:@"sessionValidationData"];
	}
	else
	{
		NSLog(@"NOT using cached validation data");
		return %orig();
	}
}
%end

%ctor {
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
																[NSNumber numberWithBool:YES],	@"shouldUseCachedValidationData",
																nil];
		[prefs writeToFile:@"/var/mobile/Library/Preferences/com.n00neimp0rtant.sirious.plist" atomically:YES];
	}
	%init;
}