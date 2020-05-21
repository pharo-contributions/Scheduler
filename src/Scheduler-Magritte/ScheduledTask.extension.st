Extension { #name : #ScheduledTask }

{ #category : #'*Scheduler-Magritte-actions' }
ScheduledTask >> descriptionDelete [
	<magritteActionDescription>
	
    ^ MAActionDescription new
        selector: #delete;
        yourself
]

{ #category : #'*Scheduler-Magritte' }
ScheduledTask >> descriptionDescription [
	<magritteDescription>
	
    ^ MAStringDescription new
        accessor: #description;
        label: 'Description';
        priority: 100;
        yourself.
]

{ #category : #'*Scheduler-Magritte' }
ScheduledTask >> descriptionIsActive [
	<magritteDescription>
	
    ^ MABooleanDescription new
        accessor: #isActive;
        label: 'Active';
        priority: 200;
		beReadonly;
        yourself.
]

{ #category : #'*Scheduler-Magritte' }
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

{ #category : #'*Scheduler-Magritte-actions' }
ScheduledTask >> descriptionResume [
	<magritteActionDescription>
	
    ^ MAActionDescription new
        selector: #resume;
		enableBlock: [ :e | e isSuspended ];
        yourself
]

{ #category : #'*Scheduler-Magritte-actions' }
ScheduledTask >> descriptionRun [
	<magritteActionDescription>
	
    ^ MAActionDescription new
        selector: #run;
		enableBlock: [ :e | e isRunning not ];
        yourself
]

{ #category : #'*Scheduler-Magritte' }
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

{ #category : #'*Scheduler-Magritte' }
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

{ #category : #'*Scheduler-Magritte' }
ScheduledTask >> descriptionStatus [
	<magritteDescription>
	
    ^ MAStringDescription new
        accessor: #statusDescription;
        label: 'Status';
        priority: 200;
		beReadonly;
        yourself.
]

{ #category : #'*Scheduler-Magritte-actions' }
ScheduledTask >> descriptionStop [
	<magritteActionDescription>
	
    ^ MAActionDescription new
        selector: #stop;
		enableBlock: [ :e | e isRunning ];
        yourself
]

{ #category : #'*Scheduler-Magritte-actions' }
ScheduledTask >> descriptionSuspend [
	<magritteActionDescription>
	
    ^ MAActionDescription new
        selector: #suspend;
		enableBlock: [ :e | e isRunning ];
        yourself.
]

{ #category : #'*Scheduler-Magritte' }
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
