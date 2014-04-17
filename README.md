Ginnungagap [gin-oong-gah-gahp]
===========

A simple CFML application to create an API status dashboard from a WADL API description XML doc.

## Introduction
Considering how unfashionable *CFML*, *WADL*, and *XML* are these days I'm not sure how many people will be interested in a tool like this. However, I recently had to  coordinate a number of internal and remote developers under extreme time table duress. In that situation I found being able to direct people to a clear, concise page demonstrating what **was** and what **was not** ready to be extremely beneficial.

![Sample screenshot from said recent project.](https://github.com/MatthewReinbold/Ginnungagap/raw/master/ginnungagapSampleImage.png "Sample Image")

## Compatibility
Ginnungagap should be backwards compatible with *ColdFusion 8*, *Railo 3.2* (free!), and *OpenBD
1.1* (free!). It may even work with previous versions but I have not tested on those. Your mileage may vary.

## How To Use
If you use a tool like [Apigee's Console ToGo](http://apigee.com/docs/apigee/consoletogo) to help manage a RESTful API's life cycle then you've probably already created your WADL document. To use:

###Initial Setup
* Put the Ginnungagap code in a web accessible directory capable of parsing CFML code
* Open the **application.cfc** file
* After locating the **OnApplicationStart** function, change the **url.file** cfparam statement to default to the name of your WADL document. Or leave the sample.XML there if you don't yet have your own WADL.
* Place your WADL document in the same directory as the application.cfc and index.cfm files.
* Navigate to the address of the **index.cfm** file in your directory and, **VIOLA**, there's your newly parsed XML in a much more human-readible (ie, C-Level grokable) format!

###Extension to the WADL Lexicon
The only addition to the WADL specification is the inclusion of a '**title**' attribute in the **doc** tag. This is used to communicate the readiness of a function to third parties or managing, non-technical entities. 
```

	<method id="postAffinity" name="POST" apigee:displayName="Post Affinity" >
	
		<doc apigee:url="http://example.com/apis/anExample.html" title="Not Ready">
		
			Use the POST method to create an affinity between a user and a thingee.
		
		</doc>
	...
	</method>
```

Currently Ginnungagap colorizes the following title values:

* Done
* Wired
* In Progress
* Not Ready
* Post April 1st *[I dunno either]*
* Post Launch 


###Reloading WADL changes
For performance reasons, after the initial parse the resulting CFML object is persisted in memory via the application scope. After making changes to the WADL a refresh of the display can be accomplished by appending a "resetApp" as a key in the query string. Something similar to:
> //[yourHostNameAndPath]/index.cfm?resetApp

## Ginnungagap?
**TL;DR**: Ginnungagap = "mighty gap"

I needed a name and all the legends from Greek and Roman mythology have pretty well been picked over. So I turned to Norse. There, Ginnungagap was the "vast, primordial void that existed prior to the creation of the manifest universe". Kinda like how the WADL is all that exists before you begin fulfilling endpoints.

## License
This is released under the 'life is too short for IP squabbling, go nuts and make awesome stuff' license. If you do use it, I would love it if you would drop me a line and let me know what you're up to. But otherwise, we're cool.


## Contact
The usual Github interface works. You can also find me at my website: [http://voxpopdesign.com](http://voxpopdesign.com). My twitter is [@libel_vox](http://twitter.com/libel_vox). Congrats! You've read all the way to the end! An air five for you!