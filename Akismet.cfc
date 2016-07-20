/**
********************************************************************************
Copyright 2009 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldboxframework.com | www.luismajano.com | www.ortussolutions.com
********************************************************************************
@author Luis Majano
Askismet interface www.akismet.com
Developer API http://akismet.com/development/api/
Based on CFAkismet by Brandon Harper

**/
component accessors="true" singleton{
	
	// The version of this CFC
	property name="version";
	// The version of the API to use
	property name="akismetVersion" type="numeric";
	property name="akismetHost";
	
	// Endpoints
	property name="verifyKeyPath" 		default="verify-key";
	property name="spamPath" 			default="submit-spam";
	property name="hamPath" 			default="submit-ham";
	property name="commentCheckPath" 	default="comment-check";
	
	property name="isKeyVerified" 		default="false" 			type="boolean";

	/***************** USER Properties ************************/	
	
	// The front page or home URL of the instance making the request. For a blog, site, or wiki this would be the front page. Note: Must be a full URI, including http://.
	property name="blogURL";
	// The Akismet API Key
	property name="apiKeY";
	// The application name used in the user agent as per the Akismet API
	property name="applicationName";
	// HTTP Timeout to use
	property name="HTTPTimeout" type="numeric";

	/**********************************************************/	

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
		numeric HTTPTimeout=10 ){

		// Properties
		version 		= "1.0";
		akismetVersion 	= "1.1";
		akismetHost 	= "rest.akismet.com";

		// Paths
		verifyKeyPath 		= "verify-key";
		spamPath			= "submit-spam";
		hamPath 			= "submit-ham";
		commentCheckPath	= "comment-check";
	
		// USER Properties
		variables.blogURL 			= arguments.blogURL;
		variables.apiKey 			= arguments.apiKey;
		variables.applicationName 	= arguments.applicationName;
		variables.HTTPTimeout		= arguments.HTTPTimeout;

		return this;
	}

	/**
	* Get the API URL using the data in this CFC
	* @endpoint.hint An endpoint to attach to the API URL
	* @apiKey.hint A passed APIKey
	*/
	function getAPIURL( endpoint="", apiKey=getAPIKey() ){
		var prefix = ( len( arguments.apiKey ) ? "http://#arguments.apiKey#." : "http://" );
		return prefix & akismetHost & "/" & akismetVersion & "/" & arguments.endPoint;
	}

	/**
	* Build API User Agent String
	*/
	function getAPIUserAgent(){
		return applicationName & " | " & "CFAkismet/" & version;	
	}

	/**
	* Key verification
	* @apiKey.hint It defaults to the construted API KEy, but can be overriden
	*/
	boolean function verifyKey( apiKey=getAPIKey() ){
		var results = sendAkismetRequest( endPoint=verifyKeyPath,
										  params={ "key" : arguments.apiKey } );
		
		// validate results
		return ( trim( results.fileContent ) == "invalid" ? false : true );
	}

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
	){
		var params = {
			"key" = arguments.apiKey,
			"permalink" = arguments.permalink,
			"comment_type" = arguments.commentType,
			"comment_author" = arguments.author,
			"comment_author_email" = arguments.authorEmail,
			"comment_author_url" = arguments.authorURL,
			"comment_content" = arguments.content
		};

		var results = sendAkismetRequest( endPoint=spamPath, params=params );
		
		// check for invalid
		if( trim( results.fileContent ) == "invalid" ){
			throw(message="Invalid Akismet Request", detail="#results.Responseheader.toString()#", type="InvalidRequest" );
		}

		// validate results
		return ( trim( results.fileContent) == 'true' ? true : false );
	}

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
	){
		var params = {
			"key" = arguments.apiKey,
			"permalink" = arguments.permalink,
			"comment_type" = arguments.commentType,
			"comment_author" = arguments.author,
			"comment_author_email" = arguments.authorEmail,
			"comment_author_url" = arguments.authorURL,
			"comment_content" = arguments.content
		};

		var results = sendAkismetRequest( endPoint=commentCheckPath, params=params );
		
		return this;
	}

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
	){
		var params = {
			"key" = arguments.apiKey,
			"permalink" = arguments.permalink,
			"comment_type" = arguments.commentType,
			"comment_author" = arguments.author,
			"comment_author_email" = arguments.authorEmail,
			"comment_author_url" = arguments.authorURL,
			"comment_content" = arguments.content
		};

		var results = sendAkismetRequest( endPoint=hamPath, params=params );
		
		return this;
	}

	/**
	*  Send an akismet request and returns the http result object.
	*/
	private function sendAkismetRequest(
		required endpoint,
		struct params={},
		boolean addCommonParams=true
	){
		// create http service
		var oHTTP = new http( url=getAPIURL( arguments.endPoint ), 
							  timeout=HTTPTimeout,
							  useragent=getAPIUserAgent(),
							  method="post" );

		// add params
		if( !structIsEmpty( arguments.params ) ){
			for( var thisParam in arguments.params ){
				oHTTP.addParam( name=thisParam,  type="formfield", value=arguments.params[ thisParam ] );
			}
		}

		// Add common params
		if( arguments.addCommonParams ){
			oHTTP.addParam( name="blog",  		type="formfield", value=getBlogURL() );
			oHTTP.addParam( name="user_ip",  	type="formfield", value=CGI.REMOTE_ADDR );
			oHTTP.addParam( name="user_agent",  type="formfield", value=CGI.HTTP_USER_AGENT );
			oHTTP.addParam( name="referrer",  	type="formfield", value=CGI.HTTP_REFERER );
		}

		return oHTTP.send().getPrefix();
	}
	
	
}