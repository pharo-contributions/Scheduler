"
Baseline for https://github.com/pharo-contributions/Scheduler
"
Class {
	#name : #BaselineOfScheduler,
	#superclass : #BaselineOf,
	#category : #BaselineOfScheduler
}

{ #category : #baseline }
BaselineOfScheduler >> baseline: spec [
	<baseline>
	spec
		for: #common do: [
			"Packages"
			spec 
				package: 'Scheduler-Core';
				package: 'Scheduler-Core-Tests' with: [ spec requires: #('Scheduler-Core') ];
				package: 'SchedulerMagritte' with: [ spec requires: #('Scheduler-Core') ].
			
			"Groups"	
			spec	
				group: 'Core' with: #('Scheduler-Core');
				group: 'Tests' with: #('Scheduler-Core-Tests');
				group: 'all' with: #('Core' 'Tests');
				group: 'default' with: #('Core' 'Tests') ]
]
