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
SchedulerTest >> testDailyTaskDoesntGetsAheadIfRunExplicitly [

	| task |

	task _ scheduler do: ['task ran'] at: DateAndTime now + 10 seconds.
	
	self should: [task nextRunTime asDate = Date today].
	
	task run. "run explicitly before scheduled time"
	
	self should: [task nextRunTime asDate = Date today].
]

{ #category : #'as yet unclassified' }
SchedulerTest >> testNewTaskScheduledToRunEarlierInDayGetsRescheduledLaterInDay [

	| message when task |

	when _ (DateAndTime now - 1 minute) asTime.
	
	task _ scheduler do: [message _ 'task ran'] at: when.
	
	1.1 seconds asDelay wait.

	self should: [message isNil].
	self should: [scheduler taskCount = 1].
	self should: [task nextRunTime = (DateAndTime date: (Date today addDays: 1) time: when)]
]

{ #category : #'as yet unclassified' }
SchedulerTest >> testRunAtSomeTimeInTheFuture [

	| task timeToRun |
	timeToRun _ DateAndTime now + 2 second.
	task _ scheduler do: [] at: timeToRun every: 1 hour.
	
	2.1 seconds asDelay wait.
	
	self should: [task nextRunTime = (timeToRun + 1 hour)].
	self should: [task schedule schedule first = 1 hour].
	self should: [scheduler taskCount = 1]
	
	

]

{ #category : #'as yet unclassified' }
SchedulerTest >> testRunDailyTask [

	| message when task |

	when _ (DateAndTime now + 1 second) asTime.
	
	task _ scheduler do: [message _ 'task ran'] at: when.
	
	1.1 seconds asDelay wait.

	self should: [message = 'task ran'].
	self should: [scheduler taskCount = 1].
	self should: [task nextRunTime = (DateAndTime date: (Date today addDays: 1) time: when)]
]

{ #category : #'as yet unclassified' }
SchedulerTest >> testRunDailyTaskNeverGetsBehind [

	| task |

	scheduler stop.
	task _ scheduler do: ['task ran'] at: DateAndTime now.
	
	task startDateAndTime: (task nextRunTime - 2 days) duration: 1 day.
	scheduler start.
	1 second asDelay wait.
	
	self should: [task nextRunTime asDate = Date tomorrow].
	
	task startDateAndTime: ((DateAndTime now + 180 seconds) - 1 day) duration: 1 day.
	1 second asDelay wait.
	
	self should: [task nextRunTime asDate = Date today]
]

{ #category : #'as yet unclassified' }
SchedulerTest >> testRunEveryOtherHourOnTheHour [

	| currentTime task |
	scheduler stop.
	currentTime _ DateAndTime now asTime.
	
	task _ scheduler do: [] at: currentTime hour asString every: 2 hours.
	task run.
		
	self should: [task nextRunTime asTime hour = ((currentTime addSeconds: 2 * 60 * 60) hour)].

	self should: [task nextRunTime > DateAndTime now]
]

{ #category : #'as yet unclassified' }
SchedulerTest >> testRunEverySecond [

	| runCount |
	runCount _ 0.

	scheduler do: [runCount _ runCount + 1] every: 1 second.
	
	3.1 seconds asDelay wait.
	
	self should: [runCount = 3].
	self should: [scheduler taskCount = 1]
]

{ #category : #'as yet unclassified' }
SchedulerTest >> testRunInASecond [

	| ranWhen now |
	now _ DateAndTime now.
	
	scheduler do: [ranWhen _ DateAndTime now] at: (now + 1 seconds).
	
	1.1 seconds asDelay wait.

	self should: [ranWhen = (now + 1 seconds)]
]

{ #category : #'as yet unclassified' }
SchedulerTest >> testRunOnceInPastRunsOnce [

	| message |
	scheduler doOnce: [message _ 'task ran'] at: (DateAndTime now - 1 second).
	
	1 second asDelay wait.
	
	self should: [message = 'task ran'].
	self should: [scheduler taskCount = 0]
]

{ #category : #'as yet unclassified' }
SchedulerTest >> testRunOnlyOnceWithFullyQualifiedDateAndTime [

	| runCount |
	runCount _ 0.
	scheduler doOnce: [runCount _ runCount + 1] at: (DateAndTime now + 1 seconds).
	
	1.1 seconds asDelay wait.
	
	self should: [runCount = 1].
	self should: [scheduler taskCount = 0]
]

{ #category : #'as yet unclassified' }
SchedulerTest >> testRunOnlyOnceWithOnlyTimeSpecified [

	| runCount |
	runCount _ 0.
	scheduler doOnce: [runCount _ runCount + 1] at: ((DateAndTime now + 1 seconds) asTime).
	
	1.1 seconds asDelay wait.
	
	self should: [runCount = 1].
	self should: [scheduler taskCount = 0]
]

{ #category : #'as yet unclassified' }
SchedulerTest >> testRunSeveralTasks [

	| task1 task2 now |
	now _ DateAndTime now.
	
	scheduler do: [task1 _ 'task 1'] at: (now + 1 second).
	scheduler do: [task2 _ 'task 2'] at: (now + 1 second).
	
	1.1 seconds asDelay wait.

	self should: [task1 = 'task 1'].
	self should: [task2 = 'task 2'].
]

{ #category : #'as yet unclassified' }
SchedulerTest >> testRunUsingCustomSchedule [

	| runCount schedule |
	runCount _ 0.
	
	schedule _ Schedule starting: DateAndTime now duration: 1 minute.
	schedule schedule: {1 second. 2 seconds. 20 seconds}.
	
	scheduler do: [runCount _ runCount + 1] following: schedule.
	3.1 seconds asDelay wait.
	
	self should: [runCount = 2].
	self should: [scheduler taskCount = 1]

]

{ #category : #'as yet unclassified' }
SchedulerTest >> testRunUsingCustomScheduleThatEnds [

	| runCount schedule |
	runCount _ 0.
	
	schedule _ Schedule starting: (DateAndTime now + 1 second) duration: 4 seconds.
	schedule schedule: {1 second. 2 seconds}.
	
	scheduler do: [runCount _ runCount + 1] following: schedule.
	5.1 seconds asDelay wait.
	
	self should: [runCount = 3].
	self should: [scheduler taskCount = 0]

]
