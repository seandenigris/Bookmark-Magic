Class {
	#name : #BmBookmarkSpecification,
	#superclass : #TestCase,
	#category : #'BookmarkMagic-Core'
}

{ #category : #tests }
BmBookmarkSpecification >> testCreateBookmark [

	| bm |
	bm := BmBookmark new
		url: 'https://www.flickr.com/services/api/' asUrl;
		tags: #(#flickr #api);
		yourself.
		
	(bm tags includes: (BmTag named: #api)) should beTrue
]
