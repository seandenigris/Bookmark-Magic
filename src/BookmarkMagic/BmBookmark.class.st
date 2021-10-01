"
Example - Add bookmark:
	| bm |
	bm := MbBookmark new
		url: 'https://www.flickr.com/services/api/' asUrl;
		tags: #(#flickr #api);
		yourself.
	self db add: bm
"
Class {
	#name : #BmBookmark,
	#superclass : #Object,
	#instVars : [
		'url',
		'tags'
	],
	#category : #'BookmarkMagic-Core'
}

{ #category : #adding }
BmBookmark class >> add: aURL [
	self db add: (self new url: aURL; yourself)
]

{ #category : #accessing }
BmBookmark class >> db [
	^ db ifNil: [ db := OrderedCollection new ]
]

{ #category : #accessing }
BmBookmark class >> db: anObject [
	db := anObject
]

{ #category : #accessing }
BmBookmark >> <= rhs [
	^ self url host <= rhs url host
]

{ #category : #comparing }
BmBookmark >> = rhs [

	^ (self respondsTo: #url) and: [ url = rhs url ]
]

{ #category : #comparing }
BmBookmark >> hash [

	^ self url hash
]

{ #category : #'instance creation' }
BmBookmark >> open [

	Smalltalk tools webBrowser openOnUrl: self url
]

{ #category : #printing }
BmBookmark >> printOn: aStream [

	url ifNotNil: [ aStream print: url; space ].
	tags ifNotNil: [ 
		tags
			do: [ :tag | aStream print: tag ]
			separatedBy: [ aStream space ] ]
]

{ #category : #accessing }
BmBookmark >> tags [
	^ tags ifNil: [ tags := SortedCollection sortUsing:  #name ascending ]
]

{ #category : #accessing }
BmBookmark >> tags: aCollection [
	"aCollection - can be symbols or Tags"

	tags := aCollection collect: #asMbTag
]

{ #category : #accessing }
BmBookmark >> url [
	^ url
]

{ #category : #accessing }
BmBookmark >> url: anObject [
	url := anObject
]
