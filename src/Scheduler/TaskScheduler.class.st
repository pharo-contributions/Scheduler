Class {
	#name : #TaskScheduler,
	#superclass : #Object,
	#instVars : [
		'running',
		'tasks',
		'accessProtect'
	],
	#category : 'Scheduler'
}

{ #category : #'as yet unclassified' }
TaskScheduler class >> new [

	^ super new initialize
]

{ #category : #'as yet unclassified' }
TaskScheduler >> addTask: aScheduledTask [

	accessProtect critical: [tasks add: aScheduledTask]
]

{ #category : #'as yet unclassified' }
TaskScheduler >> classForTimeParameter: aTimeStampOrTime [

	^ (aTimeStampOrTime isKindOf: Time)
		ifTrue: [DailyScheduledTask]
		ifFalse: [RunOnceScheduledTask]
]

{ #category : #'as yet unclassified' }
TaskScheduler >> convertToTimeParameter: when [

	[^ TimeStamp fromString: when] on: Error do: [^ Time readFrom: when readStream]
]

{ #category : #'as yet unclassified' }
TaskScheduler >> do: aBlock at: when [

	when = #now
		ifTrue: [aBlock value]
		ifFalse:
			[ | task aTimeParameter |
			aTimeParameter _ when isString 
				ifTrue: [self convertToTimeParameter: when]
				ifFalse: [when].
				
			task _ (self classForTimeParameter: aTimeParameter) new
				scheduler: self;
				task: aBlock;
				when: aTimeParameter.
				
			self addTask: task.
			^ task]
]

{ #category : #'as yet unclassified' }
TaskScheduler >> do: aBlock everyHour: anInteger [

	^ self do: aBlock everyMinute: anInteger * 60
]

{ #category : #'as yet unclassified' }
TaskScheduler >> do: aBlock everyMinute: anInteger [

	^ self do: aBlock everySecond: anInteger * 60
]

{ #category : #'as yet unclassified' }
TaskScheduler >> do: aBlock everySecond: anInteger [

	| task |
	task _ StopwatchScheduledTask new 
		scheduler: self;
		task: aBlock;
		secondsBetween: anInteger.
	
	self addTask: task.
	^ task
]

{ #category : #'as yet unclassified' }
TaskScheduler >> initialize [

	running _ false.
	tasks _ OrderedCollection new.
	accessProtect _ Semaphore forMutualExclusion
]

{ #category : #'as yet unclassified' }
TaskScheduler >> printOn: aStream [

	aStream nextPutAll: 'Task scheduler is ', (running ifTrue: ['running'] ifFalse: ['stopped'])
]

{ #category : #'as yet unclassified' }
TaskScheduler >> removeTask: aScheduledTask [

	accessProtect critical: [tasks remove: aScheduledTask]
]

{ #category : #'as yet unclassified' }
TaskScheduler >> start [

	| process |
	running ifTrue: [^ self].
	
	running _ true.
	
	process _ [
		[running] whileTrue: 
			[(Delay forMilliseconds: 250) wait.
			self tasksDo: [:each | each runIfNecessary]]] newProcess.
	
	(process respondsTo: #name:) ifTrue: [process name: 'taskScheduler'].
	
	process priority: Processor systemBackgroundPriority.
	
	process resume.

]

{ #category : #'as yet unclassified' }
TaskScheduler >> stop [

	running _ false
]

{ #category : #'as yet unclassified' }
TaskScheduler >> taskAt: aNumber [

	^ accessProtect critical: [tasks at: aNumber]
]

{ #category : #'as yet unclassified' }
TaskScheduler >> taskCount [

	^ accessProtect critical: [tasks size]
]

{ #category : #'as yet unclassified' }
TaskScheduler >> tasksDo: aOneArgBlock [
	
	| copiedTasks |
	accessProtect critical: [copiedTasks _ tasks copy].
	
	copiedTasks do: aOneArgBlock
]
