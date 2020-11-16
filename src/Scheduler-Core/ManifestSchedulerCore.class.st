"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestSchedulerCore,
	#superclass : #PackageManifest,
	#category : #'Scheduler-Core-Manifest'
}

{ #category : #'code-critics' }
ManifestSchedulerCore class >> ruleBadMessageRule2V1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#TaskScheduler #start #false)) #'2020-11-16T01:31:29.237471+01:00') #(#(#RGMethodDefinition #(#ScheduledTask #startDateAndTime:duration: #false)) #'2020-11-16T01:32:22.69332+01:00') )
]
