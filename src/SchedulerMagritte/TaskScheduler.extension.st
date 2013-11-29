Extension { #name : #TaskScheduler }

{ #category : #'*SchedulerMagritte' }
TaskScheduler >> descriptionTasks [
	<magritteDescription>
	
    ^ MAToManyRelationDescription new
        accessor: #tasks;
        label: 'Tasks';
        priority: 400;
		beReadonly;
        yourself.
]
