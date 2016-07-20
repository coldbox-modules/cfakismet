This SDK allows you to add Akismet capabilities to your ColdFusion (CFML) applications. You will need an Akismet API key in order to use this model. For more information visit: http://www.akismet.com

## Installation 
This SDK can be installed as standalone or as a ColdBox Module.  Either approach requires a simple CommandBox command:

```
box install cfakismet
```

Then follow either the standalone or module instructions below.

### Standalone

This SDK will be installed into a directory called `cfakismet` and then the SDK can be instantiated via ` new cfakismet.Akismet()` with the following constructor arguments:

```
/**
* Constructor
* @blogURL.hint The front page or home URL of the instance making the request. For a blog, site, or wiki this would be the front page. Note: Must be a full URI, including http://.
* @apiKey.hint The Akismet API Key
* @applicationName The application name used in the user agent as per the Akismet API
* @HTTPTimeout The http timeout in seconds.
*/
function init( 
	string blogURL="", 
	string apiKey="", 
	string applicationName="CFAkismet",
	numeric HTTPTimeout=10 )
```

### ColdBox Module

This package also is a ColdBox module as well.  The module can be configured by creating an `akismet` configuration structure in your application configuration file: `config/Coldbox.cfc` with the following settings:

```
akismet = {
	// The blog URL to connect
	blogURL = "",
	// The Akismet API Key
	apiKey = "",
	// Application name
	applicationName = "",
	// HTTP Timeout
	HTTPTimeout = 10
}
```

Then you can leverage the SDK CFC via the injection DSL: `akismet@akismet`

## Usage

Here are the functions you can use with this SDK

```
/**
* Comment Spam verification
* @author.hint The author making the comment
* @authorEmail.hint The author email
* @authorURL.hint the Author URL
* @commentType.hint May be blank, comment, trackback, pingback, or a made up value like "registration".
* @content.hint The content that was submitted.
* @permalink.hint The permanent location of the entry the comment was submitted to.
*/
boolean function isCommentSpam( 
	required author,
	required authorEmail,
	required authorURL,
	commentType="comment",
	required content,
	required permalink,
	apiKey=getAPIKey()
)

/**
* Submit Spam
* @author.hint The author making the comment
* @authorEmail.hint The author email
* @authorURL.hint the Author URL
* @commentType.hint May be blank, comment, trackback, pingback, or a made up value like "registration".
* @content.hint The content that was submitted.
* @permalink.hint The permanent location of the entry the comment was submitted to.
*/
Akismet function submitSpam( 
	required author,
	required authorEmail,
	required authorURL,
	commentType="comment",
	required content,
	required permalink,
	apiKey=getAPIKey()
)

/**
* Submit Ham a false positive
* @author.hint The author making the comment
* @authorEmail.hint The author email
* @authorURL.hint the Author URL
* @commentType.hint May be blank, comment, trackback, pingback, or a made up value like "registration".
* @content.hint The content that was submitted.
* @permalink.hint The permanent location of the entry the comment was submitted to.
*/
Akismet function submitHam( 
	required author,
	required authorEmail,
	required authorURL,
	commentType="comment",
	required content,
	required permalink,
	apiKey=getAPIKey()
)
```