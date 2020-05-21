Extension { #name : #TaskScheduler }

{ #category : #'*Scheduler-Magritte' }
TaskScheduler >> descriptionTasks [
	<magritteDescription>
	
    ^ MAToManyRelationDescription new
		accessor: #tasks;
		label: 'Tasks';
		priority: 400;
		beReadonly;
		yourself.
]
