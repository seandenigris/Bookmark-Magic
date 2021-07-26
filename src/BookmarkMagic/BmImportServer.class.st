"
self uniqueInstance start.
self uniqueInstance stop.
"
Class {
	#name : #BmImportServer,
	#superclass : #Object,
	#instVars : [
		'connectionSocket',
		'isRunning',
		'isRunningLock'
	],
	#classVars : [
		'UniqueInstance'
	],
	#category : #'BookmarkMagic-Core'
}

{ #category : #'class initialization' }
BmImportServer class >> initialize [

	Smalltalk
		addToStartUpList: self;
		addToShutDownList: self.
]

{ #category : #'system startup' }
BmImportServer class >> shutDown: quitting [

	quitting ifTrue: [ self uniqueInstance stop ].
]

{ #category : #'system startup' }
BmImportServer class >> startUp: resuming [

	"only handle when lauching a new image"
	"resuming ifTrue: [ self uniqueInstance start ]."
]

{ #category : #'instance creation' }
BmImportServer class >> uniqueInstance [

	^ UniqueInstance ifNil: [ UniqueInstance := self new ]
]

{ #category : #private }
BmImportServer >> importBookmarkFor: aUrl [

	| bookmark |
	bookmark := BmBookmark new url: aUrl.
	BmBookmark db add: bookmark.
]

{ #category : #'as yet unclassified' }
BmImportServer >> initialize [

	super initialize.
	isRunningLock := Mutex new.
	self isRunning: false
]

{ #category : #'as yet unclassified' }
BmImportServer >> interactOnConnection [

	| interactionSocket |
	interactionSocket := connectionSocket waitForAcceptFor: 1 ifTimedOut: [^self].
	[self interactUsing: interactionSocket] fork
]

{ #category : #private }
BmImportServer >> interactUsing: interactionSocket [

	| receivedData |
	[	receivedData := interactionSocket receiveDataTimeout: 5.
		receivedData crLog.
		"https://play.spotify.com/genre/focus in Safari included a trailing lf, so trimRight"
		self importBookmarkFor: receivedData trimRight asUrl.
	] ensure: [ interactionSocket closeAndDestroy ]
]

{ #category : #'as yet unclassified' }
BmImportServer >> isRunning [

	^ isRunningLock critical: [ isRunning ]
]

{ #category : #'as yet unclassified' }
BmImportServer >> isRunning: aBoolean [

	isRunningLock critical: [ isRunning := aBoolean ]
]

{ #category : #'as yet unclassified' }
BmImportServer >> serve [

	[ [ self isRunning ]
		whileTrue: [ self interactOnConnection ] ]
		ensure: [ connectionSocket closeAndDestroy ]
]

{ #category : #'as yet unclassified' }
BmImportServer >> start [

	isRunningLock critical: [
		self isRunning ifTrue: [ ^ self ].
		self isRunning: true ].
	connectionSocket := Socket newTCP.
	connectionSocket listenOn: 9999 backlogSize: 10.
	[ self serve ] fork
]

{ #category : #'as yet unclassified' }
BmImportServer >> stop [

	self isRunning: false
]
