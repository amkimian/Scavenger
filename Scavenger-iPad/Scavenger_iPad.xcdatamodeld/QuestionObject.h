//
//  QuestionObject.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class AnswerObject;
@class LocationObject;

@interface QuestionObject :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * questionText;
@property (nonatomic, retain) NSSet* answers;
@property (nonatomic, retain) LocationObject * location;

@end


@interface QuestionObject (CoreDataGeneratedAccessors)
- (void)addAnswersObject:(AnswerObject *)value;
- (void)removeAnswersObject:(AnswerObject *)value;
- (void)addAnswers:(NSSet *)value;
- (void)removeAnswers:(NSSet *)value;

@end

