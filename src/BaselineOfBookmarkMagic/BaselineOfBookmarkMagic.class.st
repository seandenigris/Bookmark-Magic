Class {
	#name : #BaselineOfBookmarkMagic,
	#superclass : #BaselineOf,
	#category : #BaselineOfBookmarkMagic
}

{ #category : #baseline }
BaselineOfBookmarkMagic >> baseline: spec [
	<baseline>
	spec for: #common do: [ 
		spec 
			baseline: 'ExternalWebBrowser' with: [
				spec repository: 'github://seandenigris/Pharo-Web-Browser' ];
			baseline: 'Mocketry' with: [
				spec repository: 'github://dionisiydk/Mocketry' ];
			baseline: 'PharoEnhancements' with: [
				spec repository: 'github://seandenigris/Pharo-Enhancements' ];
			baseline: 'SimplePersistence' with: [
				spec
					repository: 'github://seandenigris/Simple-Persistence' ].
			spec
				package: 'BookmarkMagic'
				with: [ spec requires: #('ExternalWebBrowser' 'Mocketry' 'PharoEnhancements' 'SimplePersistence') ] ]
]
