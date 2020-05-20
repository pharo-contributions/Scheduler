"
A schedules task
"
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
	#category : #'Scheduler-Core-Base'
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

	description := aString
]

{ #category : #initialization }
ScheduledTask >> initialize [

	runHistory := OrderedCollection new
]

{ #category : #testing }
ScheduledTask >> isActive [

	^ scheduler isRunning.
]

{ #category : #testing }
ScheduledTask >> isRunning [

	workerProcess ifNil: [^ false].
	
	^ workerProcess isTerminated not
]

{ #category : #testing }
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

{ #category : #private }
ScheduledTask >> runIfNecessary [
	"For TaskScheduler only. To run manually, send #run"

	((DateAndTime now >= self nextRunTime) and: [self isRunning not]) ifTrue: [self run]
]

{ #category : #accessing }
ScheduledTask >> schedule [

	^ schedule
]

{ #category : #accessing }
ScheduledTask >> schedule: aSchedule [

	schedule := aSchedule.
	nextRunTime := schedule start.
	
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

	scheduler := aTaskScheduler
]

{ #category : #private }
ScheduledTask >> setNextRunTime [

	self scheduleHasOnlyZeroDuration ifTrue: [^ self].
	
	schedule scheduleDo:
		[:each | (each > DateAndTime now) ifTrue: [nextRunTime := each. ^ self]].
	
	self delete "delete if no more scheduled tasks"
]

{ #category : #accessing }
ScheduledTask >> startDateAndTime: aDateAndTime duration: aDuration [

	| timeParameter |
	timeParameter := self convertToTimeParameter: aDateAndTime.
	 
	nextRunTime := ((timeParameter isKindOf: Time)
		ifTrue:
			[DateAndTime date: Date today time: timeParameter]
		ifFalse:
			[timeParameter]).
			
	schedule := Schedule starting: self nextRunTime duration: 1000 weeks.
	schedule schedule: {aDuration}.	
		
	self setNextRunTime


]

{ #category : #accessing }
ScheduledTask >> statusDescription [

	self isActive ifFalse: [ ^ 'Scheduler stopped' ].
	self isRunning ifTrue: [ ^ 'Running' ].
	self isSuspended ifTrue: [ ^ 'Suspended' ].
	^ 'Waiting for next run'.
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

	task := aBlock
]

{ #category : #private }
ScheduledTask >> wasRun [

	self scheduleHasOnlyZeroDuration ifTrue: [self delete].
	
	self setNextRunTime
]
