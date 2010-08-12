Class {
	#name : #ScheduledTask,
	#superclass : #Object,
	#instVars : [
		'description',
		'scheduler',
		'task',
		'runHistory',
		'workerProcess',
		'schedule',
		'nextRunTime'
	],
	#category : 'Scheduler'
}

{ #category : #'as yet unclassified' }
ScheduledTask class >> new [

	^ super new initialize
]

{ #category : #private }
ScheduledTask >> convertToTimeParameter: parameter [

	^ [parameter asDateAndTime] on: Error do: [Time readFrom: parameter readStream]
]

{ #category : #executing }
ScheduledTask >> delete [

	scheduler removeTask: self
]

{ #category : #accessing }
ScheduledTask >> description [

	^ description
]

{ #category : #accessing }
ScheduledTask >> description: aString [

	description _ aString
]

{ #category : #initialization }
ScheduledTask >> initialize [

	runHistory _ OrderedCollection new
]

{ #category : #accessing }
ScheduledTask >> isRunning [

	workerProcess ifNil: [^ false].
	
	^ workerProcess isTerminated not
]

{ #category : #accessing }
ScheduledTask >> isSuspended [

	workerProcess ifNil: [^ false].
	
	^ workerProcess isTerminated not and: [workerProcess isSuspended]
]

{ #category : #accessing }
ScheduledTask >> nextRunTime [

	^ nextRunTime
]

{ #category : #printing }
ScheduledTask >> printOn: aStream [

	aStream nextPutAll: 'Scheduled Task'; cr.
	self description ifNotNil: [aStream nextPutAll: self description; cr].
	
	self isRunning ifTrue: [aStream nextPutAll: 'CURRENTLY RUNNING !!'].
	self isSuspended ifTrue: [aStream nextPutAll: ' (suspended)'].
	
	aStream
		cr;
		nextPutAll: 'Next Run Time : ', self nextRunTime asString;
		cr;
		nextPutAll: 'Last Run Time : ', (runHistory isEmpty 
			ifTrue: ['<never run>']
			ifFalse: [runHistory last asString]).
]

{ #category : #executing }
ScheduledTask >> resume [

	self isSuspended ifTrue: [workerProcess resume]
]

{ #category : #executing }
ScheduledTask >> run [

	workerProcess := [[task value] ensure: [runHistory add: DateAndTime now]] fork.

	self wasRun
]

{ #category : #accessing }
ScheduledTask >> runHistory [

	^ runHistory
]

{ #category : #executing }
ScheduledTask >> runIfNecessary [

	((DateAndTime now >= self nextRunTime) and: [self isRunning not]) ifTrue: [self run]
]

{ #category : #accessing }
ScheduledTask >> schedule [

	^ schedule
]

{ #category : #accessing }
ScheduledTask >> schedule: aSchedule [

	schedule _ aSchedule.
	nextRunTime _ schedule start.
	
	self setNextRunTime
	
]

{ #category : #private }
ScheduledTask >> scheduleHasOnlyZeroDuration [

	^ schedule schedule size = 1 and: [schedule schedule first = Duration zero]
]

{ #category : #accessing }
ScheduledTask >> scheduler [

	^ scheduler
]

{ #category : #accessing }
ScheduledTask >> scheduler: aTaskScheduler [

	scheduler _ aTaskScheduler
]

{ #category : #private }
ScheduledTask >> setNextRunTime [

	self scheduleHasOnlyZeroDuration ifTrue: [^ self].
	
	schedule scheduleDo:
		[:each | (each > DateAndTime now) ifTrue: [nextRunTime _ each. ^ self]].
	
	self delete "delete if no more scheduled tasks"
]

{ #category : #accessing }
ScheduledTask >> startDateAndTime: aDateAndTime duration: aDuration [

	| timeParameter |
	timeParameter _ self convertToTimeParameter: aDateAndTime.
	 
	nextRunTime _ ((timeParameter isKindOf: Time)
		ifTrue:
			[DateAndTime date: Date today time: timeParameter]
		ifFalse:
			[timeParameter]).
			
	schedule _ Schedule starting: self nextRunTime duration: 1000 weeks.
	schedule schedule: {aDuration}.	
		
	self setNextRunTime


]

{ #category : #executing }
ScheduledTask >> stop [

	self isRunning ifTrue: [workerProcess terminate]

	
]

{ #category : #executing }
ScheduledTask >> suspend [

	self isRunning ifTrue: [workerProcess suspend]

	
]

{ #category : #accessing }
ScheduledTask >> task [

	^ task
]

{ #category : #accessing }
ScheduledTask >> task: aBlock [

	task _ aBlock
]

{ #category : #executing }
ScheduledTask >> wasRun [

	self scheduleHasOnlyZeroDuration ifTrue: [self delete].
	
	self setNextRunTime
]
