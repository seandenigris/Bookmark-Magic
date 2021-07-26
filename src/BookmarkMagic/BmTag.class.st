Class {
	#name : #BmTag,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : 'BookmarkMagic-Core'
}

{ #category : #'instance creation' }
BmTag class >> named: aString [ 

	^ self new
		name: aString;
		yourself
]

{ #category : #comparing }
BmTag >> = rhs [

	^ self name = rhs name
]

{ #category : #'as yet unclassified' }
BmTag >> asMbTag [
	^ self
]

{ #category : #comparing }
BmTag >> hash [

	^ self name hash
]

{ #category : #accessing }
BmTag >> name [
	^ name
]

{ #category : #accessing }
BmTag >> name: anObject [
	name := anObject
]

{ #category : #printing }
BmTag >> printOn: aStream [

	name ifNotNil: [ aStream print: name ].
]
