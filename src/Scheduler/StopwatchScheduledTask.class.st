Class {
	#name : #StopwatchScheduledTask,
	#superclass : #ScheduledTask,
	#instVars : [
		'secondsBetween',
		'lastRun'
	],
	#category : 'Scheduler'
}

{ #category : #'as yet unclassified' }
StopwatchScheduledTask class >> new [

	^ super new initialize
]

{ #category : #'as yet unclassified' }
StopwatchScheduledTask >> initialize [

	super initialize.
	
	secondsBetween _ 1
]

{ #category : #'as yet unclassified' }
StopwatchScheduledTask >> nextRunTime [

	^ lastRun plusSeconds: secondsBetween
]

{ #category : #'as yet unclassified' }
StopwatchScheduledTask >> printOn: aStream [

	| minutes |
	aStream nextPutAll: 'Stopwatch Task running every '.
	secondsBetween > 60
		ifTrue: 
			[minutes _ secondsBetween / 60.
			minutes isFraction
				ifTrue: [aStream nextPutAll: (minutes roundTo: 0.01) asString]
				ifFalse: [aStream nextPutAll: minutes asString].

			aStream nextPutAll: ' minutes']
		ifFalse:
			[aStream nextPutAll: secondsBetween asString, ' seconds'].
		
	aStream cr.
	super printOn: aStream
]

{ #category : #'as yet unclassified' }
StopwatchScheduledTask >> secondsBetween: anInteger [

	secondsBetween _ anInteger.
	lastRun _ TimeStamp current.
]

{ #category : #'as yet unclassified' }
StopwatchScheduledTask >> wasRun [

	lastRun _ TimeStamp current
]
