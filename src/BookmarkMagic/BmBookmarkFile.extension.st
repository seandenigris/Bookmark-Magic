Extension { #name : #BmBookmarkFile }

{ #category : #'*BookmarkMagic-GToolkit' }
BmBookmarkFile >> gtSpotterNewBookmarkFor: aSearch [
	<gtSearch>
	
	^ aSearch list
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
