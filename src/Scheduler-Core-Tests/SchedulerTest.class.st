Class {
	#name : #SchedulerTest,
	#superclass : #TestCase,
	#instVars : [
		'scheduler'
	],
	#category : #'Scheduler-Core-Tests-Base'
}

{ #category : #running }
SchedulerTest >> setUp [

	super setUp.
	scheduler := TaskScheduler new.
	scheduler start
]

{ #category : #running }
SchedulerTest >> tearDown [

	scheduler stop.
	super tearDown 
]

{ #category : #tests }
SchedulerTest >> testDailyTaskDoesntGetsAheadIfRunExplicitly [

	| task |

	task := scheduler do: ['task ran'] at: DateAndTime now + 10 seconds.
	
	self assert: task nextRunTime asDate equals: Date today.
	
	task run. "run explicitly before scheduled time"
	
	self assert: task nextRunTime asDate equals: Date today
]

{ #category : #tests }
SchedulerTest >> testNewTaskScheduledToRunEarlierInDayGetsRescheduledLaterInDay [

	| message when task |

	when := (DateAndTime now - 1 minute) asTime.
	
	task := scheduler do: [message := 'task ran'] at: when.
	
	1.1 seconds asDelay wait.

	self assert: message isNil.
	self assert: scheduler taskCount equals: 1.
	self assert: task nextRunTime equals: (DateAndTime date: (Date today addDays: 1) time: when)
]

{ #category : #tests }
SchedulerTest >> testRunAtSomeTimeInTheFuture [

	| task timeToRun |
	timeToRun := DateAndTime now + 2 second.
	task := scheduler do: [] at: timeToRun every: 1 hour.
	
	"set enough time that even on slow computers like CI the test can pass"
	3 seconds asDelay wait.
	
	self assert: task nextRunTime equals: (timeToRun + 1 hour).
	self assert: task schedule schedule first equals: 1 hour.
	self assert: scheduler taskCount equals: 1
	
	

]

{ #category : #tests }
SchedulerTest >> testRunDailyTask [

	| message when task |

	when := (DateAndTime now + 1 second) asTime.
	
	task := scheduler do: [message := 'task ran'] at: when.
	
	1.1 seconds asDelay wait.

	self assert: message equals: 'task ran'.
	self assert: scheduler taskCount equals: 1.
	self assert: task nextRunTime equals: (DateAndTime date: (Date today addDays: 1) time: when)
]

{ #category : #tests }
SchedulerTest >> testRunDailyTaskNeverGetsBehind [

	| task |

	scheduler stop.
	task := scheduler do: ['task ran'] at: DateAndTime now.
	
	task startDateAndTime: (task nextRunTime - 2 days) duration: 1 day.
	scheduler start.
	1 second asDelay wait.
	
	self assert: task nextRunTime asDate equals: Date tomorrow.
	
	task startDateAndTime: ((DateAndTime now + 180 seconds) - 1 day) duration: 1 day.
	1 second asDelay wait.
	
	self assert: task nextRunTime asDate equals: Date today
]

{ #category : #tests }
SchedulerTest >> testRunEveryOtherHourOnTheHour [

	| currentTime task |
	scheduler stop.
	currentTime := DateAndTime now asTime.
	
	task := scheduler do: [] at: currentTime hour asString every: 2 hours.
	task run.
		
	self assert: task nextRunTime asTime hour equals: (currentTime addSeconds: 2 * 60 * 60) hour.

	self assert: task nextRunTime > DateAndTime now
]

{ #category : #tests }
SchedulerTest >> testRunEveryQuarterSecond [

	| runCount |
	runCount := 0.

	scheduler do: [runCount := runCount + 1] every: 250 milliSeconds.
	
	900 milliSeconds asDelay wait.
	
	self assert: runCount equals: 4.
	self assert: scheduler taskCount equals: 1
]

{ #category : #tests }
SchedulerTest >> testRunEverySecond [

	| runCount |
	runCount := 0.

	scheduler do: [runCount := runCount + 1] every: 1 second.
	
	3.1 seconds asDelay wait.
	
	self assert: runCount equals: 4.
	self assert: scheduler taskCount equals: 1
]

{ #category : #tests }
SchedulerTest >> testRunInASecond [

	| ranWhen now |
	now := DateAndTime now.
	
	scheduler do: [ranWhen := DateAndTime now] at: (now + 1 seconds).
	
	1.1 seconds asDelay wait.

	"Time's nanosecond precision is too fine to do an exact comparision"
	self assert: ranWhen > (now + 1 second).
	self assert: ranWhen < (now + 1.5 seconds)
]

{ #category : #tests }
SchedulerTest >> testRunOnceInPastRunsOnce [

	| message |
	scheduler doOnce: [message := 'task ran'] at: (DateAndTime now - 1 second).
	
	1 second asDelay wait.
	
	self assert: message equals: 'task ran'.
	self assert: scheduler taskCount equals: 0
]

{ #category : #tests }
SchedulerTest >> testRunOnlyOnceWithFullyQualifiedDateAndTime [

	| runCount |
	runCount := 0.
	scheduler doOnce: [runCount := runCount + 1] at: (DateAndTime now + 1 seconds).
	
	1.1 seconds asDelay wait.
	
	self assert: runCount equals: 1.
	self assert: scheduler taskCount equals: 0
]

{ #category : #tests }
SchedulerTest >> testRunOnlyOnceWithOnlyTimeSpecified [

	| runCount |
	runCount := 0.
	scheduler doOnce: [runCount := runCount + 1] at: ((DateAndTime now + 1 seconds) asTime).
	
	1.1 seconds asDelay wait.
	
	self assert: runCount equals: 1.
	self assert: scheduler taskCount equals: 0
]

{ #category : #tests }
SchedulerTest >> testRunSeveralTasks [

	| task1 task2 now |
	now := DateAndTime now.
	
	scheduler do: [task1 := 'task 1'] at: (now + 1 second).
	scheduler do: [task2 := 'task 2'] at: (now + 1 second).
	
	1.1 seconds asDelay wait.

	self assert: task1 equals: 'task 1'.
	self assert: task2 equals: 'task 2'.
]

{ #category : #tests }
SchedulerTest >> testRunUsingCustomSchedule [

	| runCount schedule |
	runCount := 0.
	
	schedule := Schedule starting: DateAndTime now duration: 1 minute.
	schedule schedule: {1 second. 2 seconds. 20 seconds}.
	
	scheduler do: [runCount := runCount + 1] following: schedule.
	"set enough time that even on slow computers like CI the test can pass"
	4 seconds asDelay wait.
	
	self assert: runCount equals: 2.
	self assert: scheduler taskCount equals: 1

]

{ #category : #tests }
SchedulerTest >> testRunUsingCustomScheduleThatEnds [

	| runCount schedule |
	runCount := 0.
	
	schedule := Schedule starting: (DateAndTime now + 1 second) duration: 4 seconds.
	schedule schedule: {1 second. 2 seconds}.
	
	scheduler do: [runCount := runCount + 1] following: schedule.
	5.1 seconds asDelay wait.
	
	self assert: runCount equals: 3.
	self assert: scheduler taskCount equals: 0

]
