Class {
	#name : #BmBookmarkFile,
	#superclass : #Object,
	#instVars : [
		'bookmarks'
	],
	#classVars : [
		'UniqueInstance'
	],
	#category : #'BookmarkMagic-Core'
}

{ #category : #persistence }
BmBookmarkFile class >> restoreFrom: anObject [

	UniqueInstance := anObject.
]

{ #category : #persistence }
BmBookmarkFile class >> spData [

	^ UniqueInstance
]

{ #category : #accessing }
BmBookmarkFile class >> uniqueInstance [
	^ UniqueInstance ifNil: [ UniqueInstance := self new ]
]

{ #category : #accessing }
BmBookmarkFile >> addBookmarkTo: aUrl [

	| bm |
	bm := BmBookmark new
		url: aUrl;
		yourself.
	^ self bookmarks add: bm
]

{ #category : #accessing }
BmBookmarkFile >> bookmarks [
	^ bookmarks ifNil: [ bookmarks := SortedCollection new ]
]

{ #category : #'*BookmarkMagic-GToolkit' }
BmBookmarkFile >> gtSpotterNewBookmarkFor: aStep [
	<gtSearch>
	
	aStep listProcessor
		title: 'New Bookmark';
		priority: 50;
		itemName: [ :input | 'Add bookmark: ', input ];
		previewObject: [ :input | Object new "BmBookmark new url: input asUrl; yourself" ];
		wantsToDisplayOnEmptyQuery: false;
		filter: GtNullFilter 
			item: [ :filter :context | 
				| isExisting |
				isExisting := self bookmarks anySatisfy: [ :e | 
					e url asString = context textTrimmed ].
				(isExisting not and: [ context textTrimmed beginsWith: 'http' ]) ifTrue: [ 
					filter value: context textTrimmed ] ];
		send: [ :input :spotterStep | self addBookmarkTo: input asUrl ]
]

{ #category : #'*BookmarkMagic-GToolkit' }
BmBookmarkFile >> gtViewBookmarksOn: aView [
	<gtView>
	^ aView columnedList
		title: 'Bookmarks' translated;
		priority: 5;
		items: [ self bookmarks ];
		column: 'URL' text: [ :bm | bm url ];
		column: 'Tags' text: [ :bm | String streamContents: [ :s | bm tags do: [ :t | s << t name ] separatedBy: [ s space ] ] ]
]

{ #category : #'*BookmarkMagic-GToolkit' }
BmBookmarkFile >> gtViewTagsOn: aView [
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
		actionUpdateButtonTooltip: 'Update'.
]

{ #category : #accessing }
BmBookmarkFile >> tags [
	^ (self bookmarks flatCollect: #tags) as: Set
]
