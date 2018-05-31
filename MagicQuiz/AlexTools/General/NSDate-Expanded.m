//
//  NSDate-Expanded.m
//  YES
//
//

#import "NSDate-Expanded.h"

#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

@implementation NSDate (Expanded)

static NSDate *currentZeroDate = nil;
static NSDateFormatter *gDateFormatter = NULL;

+ (NSDate *)currentZeroDate
{
	if (currentZeroDate == nil)
	{
		currentZeroDate = [[NSDate combineDateAndTime:[NSDate date] time:[NSDate dateWithStringFormat:@"HH:mm" dateAsString:@"00:00"]] retain];
	}
	return currentZeroDate;
}

+ (NSInteger)dayOfWeekOfDate:(NSDate *)date
{
	// get current day number
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];	
	NSDateComponents *weekdayComponents =[gregorian components:NSWeekdayCalendarUnit fromDate:date];
	NSInteger weekday = [weekdayComponents weekday];
	// weekday 1 = Sunday for Gregorian calendar
	[gregorian release];
	return weekday;
}

+ (NSDate *)combineDateAndTime:(NSDate *)date time:(NSDate *)time
{
	//NSAssert(date != nil,@"Date can't be nil");
	if (date == nil)
	{
		return nil;
	}
	NSDate *zeroDate = [date dateAtStartOfDay];
	NSUInteger seconds = [time totalSecondsFromTime];
	return [NSDate addSecondsToDate:zeroDate seconds:seconds];
	
	NSString *dateStr = [date getDateAsString];
	NSString *timeStr = [time getTimeAsStringWithSeconds];
	
	return [NSDate dateWithStringFormat:@"dd-MM-yyyy HH:mm:ss" dateAsString:[dateStr stringByAppendingFormat:@" %@", timeStr]];
}

+ (NSDate *)dateWithStringFormat:(NSString *)format dateAsString:(NSString *)dateAsString
{
	if (!dateAsString) return nil;
	
	@synchronized(gDateFormatter)
	{
		if (!gDateFormatter)
		{
			gDateFormatter = [[NSDateFormatter alloc] init];		
			[gDateFormatter setDateFormat:format];
		}
		else
			if (![gDateFormatter.dateFormat isEqual:format])
			{
				[gDateFormatter setDateFormat:format];
			}
		
		// format can be @"yyyy-MM-dd 'at' HH:mm"
		NSDate *date = [gDateFormatter dateFromString:dateAsString];
		return date;
	}
}


- (BOOL)isBefore:(NSDate*)other 
{
	BOOL retVal = [self timeIntervalSinceDate:other] < 0;
	return retVal;
}

- (BOOL)isAfter:(NSDate*)other 
{
	return [self timeIntervalSinceDate:other] > 0;
}

- (BOOL)isSameDay:(NSDate*)other 
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
	
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:self];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:other];
	
    return [comp1 day]   == [comp2 day] &&
	[comp1 month] == [comp2 month] &&
	[comp1 year]  == [comp2 year];
}


- (int)daysFromDate:(NSDate *)date
{
	NSTimeInterval since = [self timeIntervalSinceDate:date];
	return since/(60*60*24);
}



- (BOOL)is7DaysFromNow
{
	NSDate *seven = [[NSDate date] dateByAddingTimeInterval:86400*7];
	return [seven isSameDay:self];
}

- (BOOL)isTomorrow
{
	NSDate *tomorrow = [[NSDate date] dateByAddingTimeInterval:86400];
	return [tomorrow isSameDay:self];
}

- (BOOL)isYesterday
{
    NSDate *yesterday = [[NSDate date] dateByAddingTimeInterval:-86400];
	return [yesterday isSameDay:self];
}

+ (NSDate *)addMinutesToDate:(NSDate *)date minutes:(NSInteger)minutes
{
	// set up date components
	NSDateComponents *components = [[NSDateComponents alloc] init];
	[components setMinute:minutes];
	// create a calendar
	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	NSDate *newDate = [gregorian dateByAddingComponents:components toDate:date options:0];
	[components release];
	
	return newDate;
}

+ (NSDate *)addSecondsToDate:(NSDate *)date seconds:(NSInteger)seconds
{
	// set up date components
	NSDateComponents *components = [[NSDateComponents alloc] init];
	[components setSecond:seconds];
	// create a calendar
	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	NSDate *newDate = [gregorian dateByAddingComponents:components toDate:date options:0];
	[components release];
	
	return newDate;
}

+ (NSDate *)addHoursToDate:(NSDate *)date hours:(NSInteger)hours
{
	// set up date components
	NSDateComponents *components = [[NSDateComponents alloc] init];
	[components setHour:hours];
	// create a calendar
	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	NSDate *newDate = [gregorian dateByAddingComponents:components toDate:date options:0];
	[components release];
	
	return newDate;
}

+ (NSDate *)addDaysToDate:(NSDate *)date days:(NSInteger)days
{
	// set up date components
	NSDateComponents *components = [[NSDateComponents alloc] init];
	[components setDay:days];
	// create a calendar
	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	NSDate *newDate = [gregorian dateByAddingComponents:components toDate:date options:0];
	[components release];
	
	return newDate;
}

- (NSDate *)dateAtStartOfDay
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
	return [CURRENT_CALENDAR dateFromComponents:components];
}

- (BOOL)isDateBetween:(NSDate *)firstDate secondDate:(NSDate *)secondDate
{
	if ([self compare:firstDate] >= NSOrderedSame && [self compare:secondDate] < NSOrderedSame)
		return YES;
	return NO;
}

- (NSString *)stringWithFormat:(NSString *)format
{
	if (![format length]) return nil;
	
	NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
	[inputFormatter setDateFormat:format];
	NSString *dateString = [inputFormatter stringFromDate:self];
	[inputFormatter release];
	return dateString;
}

- (NSString *)getTimeAsString
{
	return [self stringWithFormat:@"HH:mm"];
}

- (NSString *)getTimeAsStringWithSeconds
{
	return [self stringWithFormat:@"HH:mm:ss"];
}

- (NSString *)getDateAsString
{
	return [self getDateAsStringWithFormat:@"dd-MM-yyyy"];
}

- (NSString *)getDateAsStringWithFormat:(NSString *)format
{
	return [self stringWithFormat:format];
}

- (NSString *)getDateAsPhpString
{
	return [self stringWithFormat:@"yyyy-MM-dd"];
}

- (int)totalMinutesFromTime
{
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSCalendarUnit unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
	NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:self];
	[calendar release];
	return ([dateComponents hour] * 60) + ([dateComponents minute]);
}

- (int)totalSecondsFromTime
{
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSCalendarUnit unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
	NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:self];
	[calendar release];
	return ([dateComponents hour] * 60 * 60) + ([dateComponents minute] * 60) + ([dateComponents second]);
}

- (NSDate *)getFirstDayOfWeek
{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];	
	NSDateComponents *weekdayComponents =[gregorian components:NSWeekdayCalendarUnit fromDate:self];
	NSInteger weekday = [weekdayComponents weekday];
	// weekday 1 = Sunday for Gregorian calendar
	[gregorian release];
	
	return [NSDate addDaysToDate:self days:1-weekday];
}

- (NSInteger)dayOfWeek
{
	return [NSDate dayOfWeekOfDate:self];
}

#pragma mark Retrieving Intervals

- (NSTimeInterval)secondsAfterDate:(NSDate *)aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (ti);
}

- (NSTimeInterval)secondsBeforeDate:(NSDate *)aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (ti);
}

- (NSInteger)minutesAfterDate:(NSDate *)aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger)minutesBeforeDate:(NSDate *)aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger)hoursAfterDate:(NSDate *)aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / D_HOUR);
}

- (NSInteger)hoursBeforeDate:(NSDate *)aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_HOUR);
}

- (NSInteger)daysAfterDate:(NSDate *)aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / D_DAY);
}

- (NSInteger)daysBeforeDate:(NSDate *)aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_DAY);
}

+(NSUInteger) getCurrentDay
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger day = [components day]; 
    
    return day;
}

+ (NSString*)getCurrentMonthName
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    
    NSInteger monthNumber = [components month];
    
    NSString * dateString = [NSString stringWithFormat: @"%d", monthNumber];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    NSDate* myDate = [dateFormatter dateFromString:dateString];
    [dateFormatter release];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM"];
    NSString *stringFromDate = [formatter stringFromDate:myDate];
    [formatter release];
    
    return stringFromDate;
}

+ (NSString*)getDayOfWeekName:(NSInteger) dayFromMonthStart
{
    NSDateFormatter* theDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [theDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [theDateFormatter setDateFormat:@"EEEE"];
    
    NSInteger dayOffset = [NSDate getCurrentDay] - dayFromMonthStart;
    NSDate *dateForCalculations = [[NSDate date] addTimeInterval: -86400.0*dayOffset];
    
    NSString *weekDay =  [theDateFormatter stringFromDate:dateForCalculations];
    
    return weekDay;
}

+ (NSUInteger) getNumberOfDaysInCurrentMonth
{
    NSDate *today = [NSDate date]; //Get a date object for today's date
    NSCalendar *c = [NSCalendar currentCalendar];
    NSRange days = [c rangeOfUnit:NSDayCalendarUnit 
                           inUnit:NSMonthCalendarUnit 
                          forDate:today];
    return days.length;
}

@end
