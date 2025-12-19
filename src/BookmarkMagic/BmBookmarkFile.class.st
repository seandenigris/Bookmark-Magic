Class {
	#name : 'BmBookmarkFile',
	#superclass : 'Object',
	#instVars : [
		'bookmarks'
	],
	#classVars : [
		'UniqueInstance'
	],
	#category : 'BookmarkMagic-Core',
	#package : 'BookmarkMagic',
	#tag : 'Core'
}

{ #category : 'persistence' }
BmBookmarkFile class >> restoreFrom: anObject [

	UniqueInstance := anObject.
]

{ #category : 'persistence' }
BmBookmarkFile class >> spData [

	^ UniqueInstance
]

{ #category : 'accessing' }
BmBookmarkFile class >> uniqueInstance [
	^ UniqueInstance ifNil: [ UniqueInstance := self new ]
]

{ #category : 'accessing' }
BmBookmarkFile >> addBookmarkTo: aUrl [

	| bm |
	bm := BmBookmark new
		url: aUrl;
		yourself.
	^ self bookmarks add: bm
]

{ #category : 'GT Search' }
BmBookmarkFile >> bookmarkAddGtSearchFor: aSearch [
	<gtSearch>
	
	^ aSearch explicit
		title: 'New Bookmark';
		priority: 50;
		itemName: [ :result | '+ ', result gtDisplayText ];
		search: [ :context | 
			| isExisting input |
			input := context searchQuery trimBoth.
			isExisting := self bookmarks anySatisfy: [ :e | 
				e url asString = input ].
				(isExisting not and: [ context textTrimmed beginsWith: 'http' ]) 
					ifTrue: [ { input asUrl } ]
					ifFalse: [ {} ] ];
		send: [ :result | self addBookmarkTo: result asUrl ]
]

{ #category : 'accessing' }
BmBookmarkFile >> bookmarks [
	^ bookmarks ifNil: [ bookmarks := SortedCollection new ]
]

{ #category : 'GT Views' }
BmBookmarkFile >> bookmarksGtViewOn: aView [
	<gtView>
	^ aView columnedList
		title: 'Bookmarks' translated;
		priority: 5;
		items: [ self bookmarks ];
		column: 'URL' text: [ :bm | bm url ];
		column: 'Tags' text: [ :bm | String streamContents: [ :s | bm tags do: [ :t | s << t name ] separatedBy: [ s space ] ] ]
]

{ #category : 'accessing' }
BmBookmarkFile >> tags [
	^ (self bookmarks flatCollect: #tags) as: Set
]

{ #category : 'GT Views' }
BmBookmarkFile >> tagsGtViewOn: aView [
	<gtView>

	(self bookmarks isEmpty) ifTrue: [ ^ aView empty ].
	^ aView tree
		title: 'Tags' translated;
		priority: 25;
		items: [ self tags ];
		children: [ :each | 
			(each isKindOf: BmTag )
				ifTrue: [ self bookmarks select: [ :bm | bm tags includes: each ] ]
				ifFalse: [ #() ] ];
		itemText: #displayString;
		actionUpdateButton
]
