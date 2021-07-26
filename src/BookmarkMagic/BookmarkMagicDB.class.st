Class {
	#name : #BookmarkMagicDB,
	#superclass : #SpFileDatabase,
	#category : 'BookmarkMagic-Persistence'
}

{ #category : #'override in subclasses' }
BookmarkMagicDB class >> backupDirectoryParent [

	^ FileLocator dynabookData
]

{ #category : #'override in subclasses' }
BookmarkMagicDB class >> schema [

	^ { BmBookmark }.
]
