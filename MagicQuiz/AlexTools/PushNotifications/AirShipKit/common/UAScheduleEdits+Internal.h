/* Copyright 2018 Urban Airship and Contributors */

#import "UAScheduleEdits.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Represents the possible error conditions when deserializing schedule edits from JSON.
 */
typedef NS_ENUM(NSInteger, UAScheduleEditsErrorCode) {
    /**
     * Indicates an error with the schedule edits JSON definition.
     */
    UAScheduleEditsErrorCodeInvalidJSON,
};

/**
 * The domain for NSErrors generated by `applyFromJSON:error:`.
 */
extern NSString * const UAScheduleEditsErrorDomain;


@interface UAScheduleEditsBuilder ()

/**
 * Applies fields from a JSON object.
 *
 * @param json The json object.
 * @param error The optional error.
 * @returns `YES` if the json was able to be applied, otherwise `NO`.
 */
- (BOOL)applyFromJson:(id)json error:(NSError * _Nullable *)error;

///---------------------------------------------------------------------------------------
/// @name Schedule Edits Builder Properties
///---------------------------------------------------------------------------------------

/**
 * Schedule's data.
 */
@property(nonatomic, copy, nullable) NSString *data;

@end

@interface UAScheduleEdits ()

/**
 * The schedule's priority. Schedules are executed by priority in ascending order.
 */
@property(nonatomic, strong, nullable) NSNumber *priority;

/**
 * Number of times the actions will be triggered until the schedule is
 * finished.
 */
@property(nonatomic, strong, nullable) NSNumber *limit;

/**
 * The schedule's start time.
 */
@property(nonatomic, strong, nullable) NSDate *start;

/**
 * The schedule's end time. After the end time the schedule will be finished.
 */
@property(nonatomic, strong, nullable) NSDate *end;

/**
 * The schedule's edit grace period. The amount of time the schedule will still be editable after it has expired
 * or finished executing.
 */
@property(nonatomic, strong, nullable) NSNumber *editGracePeriod;

/**
 * The schedule's interval. The amount of time to pause the schedule after executing.
 */
@property(nonatomic, strong, nullable) NSNumber *interval;

/**
 * Schedule's data.
 */
@property(nonatomic, copy, nullable) NSString *data;

/**
 * Default init method.
 *
 * @param builder The schedule edits builder.
 * @return The initialized instance.
 */
- (instancetype)initWithBuilder:(UAScheduleEditsBuilder *)builder;

@end

NS_ASSUME_NONNULL_END


