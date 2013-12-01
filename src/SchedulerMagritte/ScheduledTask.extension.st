Extension { #name : #ScheduledTask }

{ #category : #'*SchedulerMagritte-actions' }
ScheduledTask >> descriptionDelete [
	<magritteActionDescription>
	
    ^ MAActionDescription new
        selector: #delete;
        yourself
]

{ #category : #'*SchedulerMagritte' }
ScheduledTask >> descriptionDescription [
	<magritteDescription>
	
    ^ MAStringDescription new
        accessor: #description;
        label: 'Description';
        priority: 100;
        yourself.
]

{ #category : #'*SchedulerMagritte' }
ScheduledTask >> descriptionIsActive [
	<magritteDescription>
	
    ^ MABooleanDescription new
        accessor: #isActive;
        label: 'Active';
        priority: 200;
		beReadonly;
        yourself.
]

{ #category : #'*SchedulerMagritte' }
ScheduledTask >> descriptionNextRunTime [
	<magritteDescription>
	
	"Not sure how this should work. For now, just show the printString"
    ^ MADateAndTimeDescription new
        accessor: #nextRunTime;
        label: 'Next Run Time';
        priority: 600;
		beReadonly;
		display: [ :e | e asDate mmddyyyy, ' @ ', e asTime hhmm24 ];
        yourself.
]

{ #category : #'*SchedulerMagritte-actions' }
ScheduledTask >> descriptionResume [
	<magritteActionDescription>
	
    ^ MAActionDescription new
        selector: #resume;
		enableBlock: [ :e | e isSuspended ];
        yourself
]

{ #category : #'*SchedulerMagritte-actions' }
ScheduledTask >> descriptionRun [
	<magritteActionDescription>
	
    ^ MAActionDescription new
        selector: #run;
		enableBlock: [ :e | e isRunning not ];
        yourself
]

{ #category : #'*SchedulerMagritte' }
ScheduledTask >> descriptionRunHistory [
	<magritteDescription>
	
    ^ MAToManyRelationDescription new
		accessor: #runHistory;
		label: 'History';
		priority: 400;
		display: [ :e | e asDate mmddyyyy, ' @ ', e asTime hhmm24 ];
		beReadonly;
		yourself.
]

{ #category : #'*SchedulerMagritte' }
ScheduledTask >> descriptionSchedule [
	<magritteDescription>
	
	"Not sure how this should work. For now, just show the printString"
    ^ MAStringDescription new
        accessor: #schedule;
        label: 'Schedule';
        priority: 500;
		beReadonly;
        yourself.
]

{ #category : #'*SchedulerMagritte' }
ScheduledTask >> descriptionStatus [
	<magritteDescription>
	
    ^ MAStringDescription new
        accessor: #statusDescription;
        label: 'Status';
        priority: 200;
		beReadonly;
        yourself.
]

{ #category : #'*SchedulerMagritte-actions' }
ScheduledTask >> descriptionStop [
	<magritteActionDescription>
	
    ^ MAActionDescription new
        selector: #stop;
		enableBlock: [ :e | e isRunning ];
        yourself
]

{ #category : #'*SchedulerMagritte-actions' }
ScheduledTask >> descriptionSuspend [
	<magritteActionDescription>
	
    ^ MAActionDescription new
        selector: #suspend;
		enableBlock: [ :e | e isRunning ];
        yourself.
]

{ #category : #'*SchedulerMagritte' }
ScheduledTask >> descriptionTask [
	<magritteDescription>
	
    ^ MAStringDescription new
        accessor: #task;
        label: 'Task';
        priority: 200;
		beReadonly;
		display: [ :e | e asString allButFirst allButLast ];
        yourself.
]
