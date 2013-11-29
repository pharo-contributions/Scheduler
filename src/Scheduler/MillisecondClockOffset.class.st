Class {
	#name : #MillisecondClockOffset,
	#superclass : #Object,
	#classVars : [
		'MilliSecondOffset'
	],
	#category : #Scheduler
}

{ #category : #'as yet unclassified' }
MillisecondClockOffset class >> getMilliSecondOffset [

   | lastSecond |
   lastSecond := Time totalSeconds.
   [lastSecond = Time totalSeconds]
       whileTrue: [(Delay forMilliseconds: 1) wait].

   ^ Time millisecondClockValue \\ 1000.
]

{ #category : #'as yet unclassified' }
MillisecondClockOffset class >> initialize [

	super initialize.

	Smalltalk addToStartUpList: self.
]

{ #category : #'as yet unclassified' }
MillisecondClockOffset class >> milliSeconds [

	^ MilliSecondOffset
		ifNil: [0]
		ifNotNil: [(Time millisecondClockValue - MilliSecondOffset) \\ 1000]
]

{ #category : #'as yet unclassified' }
MillisecondClockOffset class >> startUp: resuming [

	resuming ifFalse: [^ self].
	
	MilliSecondOffset := nil.
	[MilliSecondOffset := self getMilliSecondOffset] fork
]
