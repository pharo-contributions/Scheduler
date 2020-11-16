"
Utility class to handle clock offset in millisecond
"
Class {
	#name : #MillisecondClockOffset,
	#superclass : #Object,
	#classVars : [
		'MilliSecondOffset'
	],
	#category : #'Scheduler-Core-Utilities'
}

{ #category : #accessing }
MillisecondClockOffset class >> getMilliSecondOffset [

	| lastSecond |
	lastSecond := Time totalSeconds.
	[ lastSecond = Time totalSeconds ] whileTrue: [ 
		(Delay forMilliseconds: 1) wait ].

	^ Time millisecondClockValue \\ 1000
]

{ #category : #'class initialization' }
MillisecondClockOffset class >> initialize [

	Smalltalk addToStartUpList: self
]

{ #category : #accessing }
MillisecondClockOffset class >> milliSeconds [

	^ MilliSecondOffset
		  ifNil: [ 0 ]
		  ifNotNil: [ Time millisecondClockValue - MilliSecondOffset \\ 1000 ]
]

{ #category : #'system startup' }
MillisecondClockOffset class >> startUp: resuming [

	resuming ifFalse: [ ^ self ].

	MilliSecondOffset := nil.
	[ MilliSecondOffset := self getMilliSecondOffset ] fork
]
