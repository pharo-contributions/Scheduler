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

	^ self addTask: (ScheduledTask new
		scheduler: self;
		task: aBlock;
		startDateAndTime: when
		duration: aDuration)
]

{ #category : #scheduling }
TaskScheduler >> do: aBlock every: aDuration [

	^ self do: aBlock at: Time now every: aDuration
]

{ #category : #scheduling }
TaskScheduler >> do: aBlock following: aSchedule [

	^ self addTask: (ScheduledTask new
		scheduler: self;
		task: aBlock;
		schedule: aSchedule)
]

{ #category : #scheduling }
TaskScheduler >> doOnce: aBlock at: when [

	^ self do: aBlock at: when every: Duration zero
]

{ #category : #initialization }
TaskScheduler >> initialize [

	running _ false.
	tasks _ OrderedCollection new.
	accessProtect _ Semaphore forMutualExclusion
]

{ #category : #printing }
TaskScheduler >> printOn: aStream [

	aStream nextPutAll: 'Task scheduler is ', (running ifTrue: ['running'] ifFalse: ['stopped'])
]

{ #category : #scheduling }
TaskScheduler >> removeTask: aScheduledTask [

	accessProtect critical: [tasks remove: aScheduledTask]
]

{ #category : #executing }
TaskScheduler >> start [

	| process |
	running ifTrue: [^ self].
	
	running _ true.
	
	process _ [
		[running] whileTrue: 
			[0.25 seconds asDelay wait.
			self tasksDo: [:each | each runIfNecessary]]] newProcess.
	
	(process respondsTo: #name:) ifTrue: [process name: 'taskScheduler'].
	
	process priority: Processor systemBackgroundPriority.
	
	process resume.

]

{ #category : #executing }
TaskScheduler >> stop [

	running _ false
]

{ #category : #accessing }
TaskScheduler >> taskAt: aNumber [

	^ accessProtect critical: [tasks at: aNumber]
]

{ #category : #accessing }
TaskScheduler >> taskCount [

	^ accessProtect critical: [tasks size]
]

{ #category : #accessing }
TaskScheduler >> tasksDo: aOneArgBlock [
	
	| copiedTasks |
	accessProtect critical: [copiedTasks _ tasks copy].
	
	copiedTasks do: aOneArgBlock
]
