Class {
	#name : #SchedulerTest,
	#superclass : #TestCase,
	#instVars : [
		'scheduler'
	],
	#category : 'Scheduler'
}

{ #category : #'as yet unclassified' }
SchedulerTest >> setUp [

	scheduler _ TaskScheduler new.
	scheduler start.
]

{ #category : #'as yet unclassified' }
SchedulerTest >> tearDown [

	scheduler stop.
]

{ #category : #'as yet unclassified' }
SchedulerTest >> testRunDailyTask [

	| message when task |

	when _ (TimeStamp current plusSeconds: 1) asTime.
	
	task _ scheduler do: [message _ 'task ran'] at: when.
	
	(Delay forMilliseconds: 1100) wait.
	
	self should: [message = 'task ran'].
	self should: [scheduler taskCount = 1].
	self should: [task nextRunTime = (TimeStamp date: (Date today addDays: 1) time: when)]
]

{ #category : #'as yet unclassified' }
SchedulerTest >> testRunEverySecond [

	| runCount |
	runCount _ 0.

	scheduler do: [runCount _ runCount + 1] everySecond: 1.
	
	(Delay forMilliseconds: 3100) wait.
	
	self should: [runCount = 3].
	self should: [scheduler taskCount = 1]
]

{ #category : #'as yet unclassified' }
SchedulerTest >> testRunInASecond [

	| ranWhen now |
	now _ TimeStamp current.
	
	scheduler do: [ranWhen _ TimeStamp current] at: (now plusSeconds: 1).
	
	(Delay forMilliseconds: 1100) wait.

	self should: [ranWhen = (now plusSeconds: 1)]
]

{ #category : #'as yet unclassified' }
SchedulerTest >> testRunNow [

	| message |
	scheduler do: [message _ 'task ran'] at: #now.
	
	self should: [message = 'task ran']
]

{ #category : #'as yet unclassified' }
SchedulerTest >> testRunOnlyOnceWhenCalendarEvent [

	| runCount |
	runCount _ 0.
	scheduler do: [runCount _ runCount + 1] at: TimeStamp current.
	
	(Delay forSeconds: 1) wait.
	
	self should: [runCount = 1].
	self should: [scheduler taskCount = 0]
]

{ #category : #'as yet unclassified' }
SchedulerTest >> testRunSeveralTasks [

	| task1 task2 now |
	now _ TimeStamp current.
	
	scheduler do: [task1 _ 'task 1'] at: (now plusSeconds: 1).
	scheduler do: [task2 _ 'task 2'] at: (now plusSeconds: 1).
	
	(Delay forMilliseconds: 1100) wait.

	self should: [task1 = 'task 1'].
	self should: [task2 = 'task 2'].
]
