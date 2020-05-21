"
Configuration for https://github.com/pharo-contributions/Schedulers
"
Class {
	#name : #ConfigurationOfScheduler,
	#superclass : #Object,
	#instVars : [
		'project'
	],
	#classVars : [
		'LastVersionLoad'
	],
	#category : #ConfigurationOfScheduler
}

{ #category : #'development support' }
ConfigurationOfScheduler class >> DevelopmentSupport [

"See the methods in the 'development support' category on the class-side of MetacelloBaseConfiguration. Decide what development support methods you would like to use and copy them the the class-side of your configuration."
	<apiDocumentation>

]

{ #category : #private }
ConfigurationOfScheduler class >> baseConfigurationClassIfAbsent: aBlock [

	^Smalltalk
		at: #MetacelloBaseConfiguration
		ifAbsent: [ 
			self ensureMetacelloBaseConfiguration.
			Smalltalk at: #MetacelloBaseConfiguration ifAbsent: aBlock ].

]

{ #category : #catalog }
ConfigurationOfScheduler class >> catalogContactInfo [
	^ 'astares@gmx.de'
]

{ #category : #catalog }
ConfigurationOfScheduler class >> catalogDescription [
	^ 'An easy-to-use task scheduler that can run arbitrary blocks:

- Every so often (e.g. every hour starting now)
- Daily at a given time
- Periodically starting at a given time (e.g. every other hour starting a noon)
- Per a provide schedule (e.g. using Schedule instance you can run tasks every Monday and Friday)
- A one time task at some point in the future'
]

{ #category : #catalog }
ConfigurationOfScheduler class >> catalogKeywords [
	^ #( scheduler cron 'repeated-tasks' )
]

{ #category : #private }
ConfigurationOfScheduler class >> ensureMetacello [

	(self baseConfigurationClassIfAbsent: []) ensureMetacello
]

{ #category : #private }
ConfigurationOfScheduler class >> ensureMetacelloBaseConfiguration [

	Smalltalk
		at: #MetacelloBaseConfiguration
		ifAbsent: [ 
			| repository version |
			repository := MCHttpRepository location: 'http://seaside.gemstone.com/ss/metacello' user: '' password: ''.
			repository
				versionReaderForFileNamed: 'Metacello-Base-DaleHenrichs.2.mcz'
				do: [ :reader | 
					version := reader version.
					version load.
					version workingCopy repositoryGroup addRepository: repository ] ]
]

{ #category : #'metacello tool support' }
ConfigurationOfScheduler class >> isMetacelloConfig [
	"Answer true and the Metacello tools will operate on you"
	
	^true
]

{ #category : #loading }
ConfigurationOfScheduler class >> load [
	"Load the #stable version defined for this platform. The #stable version is the version that is recommended to be used on this platform."

	"self load"

	<apiDocumentation>
	^(self project version: #stable) load
]

{ #category : #loading }
ConfigurationOfScheduler class >> loadBleedingEdge [
	"Load the latest versions of the mcz files defined for this project. It is not likely that the #bleedingEdge has been tested."

	"self loadBleedingEdge"

	<apiDocumentation>
	^(self project version: #bleedingEdge) load
]

{ #category : #loading }
ConfigurationOfScheduler class >> loadDevelopment [
	"Load the #development version defined for this platform. The #development version will change over time and is not expected to be stable."

	"self loadDevelopment"

	<apiDocumentation>
	^(self project version: #development) load
]

{ #category : #accessing }
ConfigurationOfScheduler class >> project [

	^self new project
]

{ #category : #'development support' }
ConfigurationOfScheduler class >> validate [
	"Check the configuration for Errors, Critical Warnings, and Warnings (see class comment for MetacelloMCVersionValidator for more information). 
	Errors identify specification issues that will result in unexpected behaviour when you load the configuration. 
	Critical Warnings identify specification issues that may result in unexpected behavior when you load the configuration.
	Warnings identify specification issues that are technically correct, but are worth take a look at."

	"self validate"

	<apiDocumentation>
	self ensureMetacello.
	^ ((Smalltalk at: #MetacelloToolBox) validateConfiguration: self debug: #() recurse: false) explore
]

{ #category : #baselines }
ConfigurationOfScheduler >> baseline10: spec [
	<version: '1.0-baseline'>

	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec repository: 'http://squeaksource.com/Scheduler'.
		spec package: 'Scheduler'.
		spec group: 'default' with: #('Scheduler' ). ].

]

{ #category : #baselines }
ConfigurationOfScheduler >> baseline20: spec [
	<version: '2.0-baseline'>

	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec repository: 'http://smalltalkhub.com/mc/TorstenBergmann/Scheduler/main'.
		spec package: 'Scheduler'.
		spec group: 'default' with: #('Scheduler' ). ].

]

{ #category : #'symbolic versions' }
ConfigurationOfScheduler >> dev: spec [
	<version: #'dev'>

	spec for: #'common' do: [ 
		spec
			baseline: 'Scheduler' with: [ 
				spec 
					className: 'BaselineOfScheduler';
					repository: 'github://pharo-contributions/Scheduler:master/src' ]]
]

{ #category : #'symbolic versions' }
ConfigurationOfScheduler >> development: spec [
	<symbolicVersion: #'development'>

	spec for: #'common' version: #'dev'.

]

{ #category : #accessing }
ConfigurationOfScheduler >> project [

	^ project ifNil: [ | constructor |
		"Bootstrap Metacello if it is not already loaded"
		(self class baseConfigurationClassIfAbsent: []) ensureMetacello.
		"Construct Metacello project"
		constructor := (Smalltalk at: #MetacelloVersionConstructor) on: self.
		project := constructor project.
		project loadType: #linear. "change to #atomic if desired"
		project ]
]

{ #category : #'symbolic versions' }
ConfigurationOfScheduler >> stable: spec [
	<symbolicVersion: #'stable'>

	spec for: #'common' version: '3.0.0'.
	spec for: #'pharo4.x' version: '2.2'.
	spec for: #'pharo5.x' version: '2.2'.

]

{ #category : #versions }
ConfigurationOfScheduler >> version10: spec [
	<version: '1.0' imports: #('1.0-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'release'.
		spec description: 'initial version'.
		spec author: 'SeanDeNigris'.
		spec timestamp: '6/7/2012 14:16'.
		spec package: 'Scheduler' with: 'Scheduler-DiegoKogan.20'. ].

]

{ #category : #versions }
ConfigurationOfScheduler >> version20: spec [
	<version: '2.0' imports: #('2.0-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'release'.
		spec description: 'migrated from SqS to STHub'.
		spec author: 'TorstenBergmann'.
		spec timestamp: '7/17/2013 14:16'.
		spec package: 'Scheduler' with: 'Scheduler-DiegoKogan.20'. ].

]

{ #category : #versions }
ConfigurationOfScheduler >> version22: spec [
	<version: '2.2' imports: #('2.0-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'release'.
		spec description: 'Pharo 4 Configuration'.
		spec author: 'TorstenBergmann'.
		spec timestamp: '7/12/2015 17:00'.
		spec package: 'Scheduler' with: 'Scheduler-SeanDeNigris.22'. ].

]

{ #category : #versions }
ConfigurationOfScheduler >> version300: spec [
	<version: '3.0.0'>

	spec for: #'common' do: [ 
		spec
			baseline: 'Scheduler' with: [ 
				spec 
					className: 'BaselineOfScheduler';
					repository: 'github://pharo-contributions/Scheduler:3.0.0/src' ]]
]
