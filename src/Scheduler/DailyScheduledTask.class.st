Class {
	#name : #DailyScheduledTask,
	#superclass : #ScheduledTask,
	#instVars : [
		'when'
	],
	#category : 'Scheduler'
}

{ #category : #'as yet unclassified' }
DailyScheduledTask >> basicWhen: aTimeStamp [

	when _ aTimeStamp
]

{ #category : #'as yet unclassified' }
DailyScheduledTask >> initialize [

	super initialize.
	
	triggerTime _ Time midnight
]

{ #category : #'as yet unclassified' }
DailyScheduledTask >> nextRunTime [

	TimeStamp current > when ifTrue: 
		[TimeStamp current asTime > when asTime
			ifTrue: [when _ TimeStamp date: Date tomorrow time: when asTime]
			ifFalse: [when _ TimeStamp date: Date today time: when asTime]].
		
	^ when
]

{ #category : #'as yet unclassified' }
DailyScheduledTask >> printOn: aStream [

	aStream nextPutAll: 'Daily Task'; cr.
	super printOn: aStream
]

{ #category : #'as yet unclassified' }
DailyScheduledTask >> wasRun [

	self nextRunTime
]

{ #category : #'as yet unclassified' }
DailyScheduledTask >> when: aTime [

	when _ TimeStamp date: Date today time: aTime

]
