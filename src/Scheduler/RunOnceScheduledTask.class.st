Class {
	#name : #RunOnceScheduledTask,
	#superclass : #ScheduledTask,
	#instVars : [
		'when'
	],
	#category : 'Scheduler'
}

{ #category : #'as yet unclassified' }
RunOnceScheduledTask >> nextRunTime [

	^ when
]

{ #category : #'as yet unclassified' }
RunOnceScheduledTask >> printOn: aStream [

	aStream nextPutAll: 'Run Once Task'; cr.
	super printOn: aStream
]

{ #category : #'as yet unclassified' }
RunOnceScheduledTask >> wasRun [

	self delete
]

{ #category : #'as yet unclassified' }
RunOnceScheduledTask >> when: aTimeStamp [

	when _ aTimeStamp
]
