Class {
	#name : #ScheduledTask,
	#superclass : #Object,
	#instVars : [
		'description',
		'scheduler',
		'task',
		'runHistory',
		'workerProcess'
	],
	#category : 'Scheduler'
}

{ #category : #'as yet unclassified' }
ScheduledTask class >> new [

	^ super new initialize
]

{ #category : #'as yet unclassified' }
ScheduledTask >> delete [

	scheduler removeTask: self
]

{ #category : #'as yet unclassified' }
ScheduledTask >> description [

	^ description
]

{ #category : #'as yet unclassified' }
ScheduledTask >> description: aString [

	description _ aString
]

{ #category : #'as yet unclassified' }
ScheduledTask >> initialize [

	runHistory _ OrderedCollection new
]

{ #category : #'as yet unclassified' }
ScheduledTask >> isRunning [

	workerProcess ifNil: [^ false].
	
	^ workerProcess isTerminated not
]

{ #category : #'as yet unclassified' }
ScheduledTask >> isSuspended [

	workerProcess ifNil: [^ false].
	
	^ workerProcess isTerminated not and: [workerProcess isSuspended]
]

{ #category : #'as yet unclassified' }
ScheduledTask >> nextRunTime [

	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
ScheduledTask >> printOn: aStream [

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

{ #category : #'as yet unclassified' }
ScheduledTask >> resume [

	self isSuspended ifTrue: [workerProcess resume]
]

{ #category : #'as yet unclassified' }
ScheduledTask >> run [

	workerProcess _ [[task value] ensure: [runHistory add: TimeStamp current]] fork.

	self wasRun
]

{ #category : #'as yet unclassified' }
ScheduledTask >> runHistory [

	^ runHistory
]

{ #category : #'as yet unclassified' }
ScheduledTask >> runIfNecessary [

	((TimeStamp current >= self nextRunTime) and: [self isRunning not]) ifTrue: [self run]
]

{ #category : #'as yet unclassified' }
ScheduledTask >> scheduler [

	^ scheduler
]

{ #category : #'as yet unclassified' }
ScheduledTask >> scheduler: aTaskScheduler [

	scheduler _ aTaskScheduler
]

{ #category : #'as yet unclassified' }
ScheduledTask >> stop [

	self isRunning ifTrue: [workerProcess terminate]

	
]

{ #category : #'as yet unclassified' }
ScheduledTask >> suspend [

	self isRunning ifTrue: [workerProcess suspend]

	
]

{ #category : #'as yet unclassified' }
ScheduledTask >> task [

	^ task
]

{ #category : #'as yet unclassified' }
ScheduledTask >> task: aBlock [

	task _ aBlock
]

{ #category : #'as yet unclassified' }
ScheduledTask >> wasRun [

	"Subclasses can use to do something after task was run"
]
