"
A task scheduler is scheduling tasks
"
Class {
	#name : #TaskScheduler,
	#superclass : #Object,
	#instVars : [
		'running',
		'tasks',
		'accessProtect'
	],
	#category : #'Scheduler-Core-Base'
}

{ #category : #'as yet unclassified' }
TaskScheduler class >> new [

	^ super new initialize
]

{ #category : #scheduling }
TaskScheduler >> addTask: aScheduledTask [

	^ accessProtect critical: [tasks add: aScheduledTask]
]

{ #category : #scheduling }
TaskScheduler >> do: aBlock at: when [

	^ self do: aBlock at: when every: 1 day
]

{ #category : #scheduling }
TaskScheduler >> do: aBlock at: when every: aDuration [

	| task |
	task := ScheduledTask new
		scheduler: self;
		task: aBlock;
		startDateAndTime: when
		duration: aDuration;
		yourself.
	^ self addTask: task.
]

{ #category : #scheduling }
TaskScheduler >> do: aBlock every: aDuration [

	| task |
	task := self do: aBlock at: Time now every: aDuration.
	^ task
		run;
		yourself.
]

{ #category : #scheduling }
TaskScheduler >> do: aBlock following: aSchedule [

	| task |
	task := ScheduledTask new
		scheduler: self;
		task: aBlock;
		schedule: aSchedule;
		yourself.
	^ self addTask: task
]

{ #category : #scheduling }
TaskScheduler >> doOnce: aBlock at: when [

	^ self do: aBlock at: when every: Duration zero
]

{ #category : #initialization }
TaskScheduler >> initialize [

	running := false.
	tasks := OrderedCollection new.
	accessProtect := Semaphore forMutualExclusion
]

{ #category : #testing }
TaskScheduler >> isRunning [

	^ running.
]

{ #category : #printing }
TaskScheduler >> printOn: aStream [

	aStream
		nextPutAll: 'Task scheduler is ', (running ifTrue: ['running'] ifFalse: ['stopped']);
		nextPutAll: ' with ', self taskCount asWords, ' tasks'
]

{ #category : #scheduling }
TaskScheduler >> removeTask: aScheduledTask [

	accessProtect critical: [tasks remove: aScheduledTask]
]

{ #category : #executing }
TaskScheduler >> start [

	| process |
	running ifTrue: [^ self].
	
	running := true.
	
	process := [
		[running] whileTrue: 
			[0.25 seconds asDelay wait.
			self tasksDo: [:each | each runIfNecessary]]] newProcess.
	
	(process respondsTo: #name:) ifTrue: [process name: 'taskScheduler'].
	
	process priority: Processor systemBackgroundPriority.
	
	process resume.

]

{ #category : #executing }
TaskScheduler >> stop [

	running := false
]

{ #category : #accessing }
TaskScheduler >> taskAt: aNumber [

	^ accessProtect critical: [tasks at: aNumber]
]

{ #category : #accessing }
TaskScheduler >> taskCount [

	^ accessProtect critical: [tasks size]
]

{ #category : #private }
TaskScheduler >> tasks [

	accessProtect critical: [ ^ tasks copy ].
]

{ #category : #accessing }
TaskScheduler >> tasksDo: aOneArgBlock [
	
	^ self tasks do: aOneArgBlock
]
