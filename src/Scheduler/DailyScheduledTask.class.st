Class {
	#name : #DailyScheduledTask,
	#superclass : #ScheduledTask,
	#instVars : [
		'when'
	],
	#category : 'Scheduler'
}

{ #category : #'as yet unclassified' }
DailyScheduledTask >> initialize [

	super initialize.
	
	triggerTime _ Time midnight
]

{ #category : #'as yet unclassified' }
DailyScheduledTask >> nextRunTime [

	^ when
]

{ #category : #'as yet unclassified' }
DailyScheduledTask >> printOn: aStream [

	aStream nextPutAll: 'Daily Task'; cr.
	super printOn: aStream
]

{ #category : #'as yet unclassified' }
DailyScheduledTask >> wasRun [

	when _ when plusDays: 1
]

{ #category : #'as yet unclassified' }
DailyScheduledTask >> when: aTime [

	| now |
	now _ TimeStamp current.
	now asTime > aTime
		ifTrue: [when _ TimeStamp date: (Date today addDays: 1) time: aTime]
		ifFalse: [when _ TimeStamp date: Date today time: aTime]
]
