//
//  NSDate-Expanded.h
//  YES
//
//

#import <Foundation/Foundation.h>

#define D_MINUTE 60
#define D_HOUR 3600
#define D_DAY 86400
#define D_WEEK 604800
#define D_YEAR 31556926

@interface NSDate (Expanded)

+ (NSDate *)currentZeroDate;
+ (NSInteger)dayOfWeekOfDate:(NSDate *)date;
+ (NSDate *)combineDateAndTime:(NSDate *)date time:(NSDate *)time;
+ (NSDate *)dateWithStringFormat:(NSString *)format dateAsString:(NSString *)dateAsString;
+ (NSDate *)addMinutesToDate:(NSDate *)date minutes:(NSInteger)minutes;
+ (NSDate *)addSecondsToDate:(NSDate *)date seconds:(NSInteger)seconds;
+ (NSDate *)addHoursToDate:(NSDate *)date hours:(NSInteger)hours;
+ (NSDate *)addDaysToDate:(NSDate *)date days:(NSInteger)days;

- (BOOL)isDateBetween:(NSDate *)firstDate secondDate:(NSDate *)secondDate;
- (NSString *)getDateAsPhpString;
- (BOOL)isSameDay:(NSDate*)other;
- (NSString *)getDateAsStringWithFormat:(NSString *)format;
- (NSString *)getDateAsString;
- (NSString *)getTimeAsStringWithSeconds;
- (NSString *)getTimeAsString;
- (NSString *)stringWithFormat:(NSString *)format;
- (NSInteger)dayOfWeek;
- (NSDate *)dateAtStartOfDay;

- (NSDate *)getFirstDayOfWeek;
- (BOOL)is7DaysFromNow;
- (BOOL)isYesterday;
- (BOOL)isTomorrow;
- (int)totalMinutesFromTime;
- (int)totalSecondsFromTime;

- (NSTimeInterval)secondsBeforeDate:(NSDate *)aDate;
- (NSTimeInterval)secondsAfterDate:(NSDate *)aDate;
- (NSInteger)minutesBeforeDate:(NSDate *)aDate;
- (NSInteger)minutesAfterDate:(NSDate *)aDate;
- (NSInteger)hoursBeforeDate:(NSDate *)aDate;
- (NSInteger)hoursAfterDate:(NSDate *)aDate;
- (NSInteger)daysBeforeDate:(NSDate *)aDate;
- (NSInteger)daysAfterDate:(NSDate *)aDate;

+ (NSUInteger)getCurrentDay;
+ (NSString*)getCurrentMonthName;
+ (NSString*)getDayOfWeekName:(NSInteger) dayFromMonthStart;
+ (NSUInteger)getNumberOfDaysInCurrentMonth;

@end
