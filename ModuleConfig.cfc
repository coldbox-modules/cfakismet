/**
* Copyright Ortus Solutions, Corp
* www.ortussolutions.com
* ---
* This module connects your application to Akismet
**/
component {

	// Module Properties
	this.title 				= "Akismet SDK";
	this.author 			= "Ortus Solutions, Corp";
	this.webURL 			= "https://www.ortussolutions.com";
	this.description 		= "Helps sanitize your comments against Akismet";
	this.version			= "2.0.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "akismet";
	this.autoMapModels 		= false;

	function configure(){

		// Settings
		settings = {
			// The blog URL to connect
			blogURL = "",
			// The Akismet API Key
			apiKey = "",
			// Application name
			applicationName = "",
			// HTTP Timeout
			HTTPTimeout = 10
		};
	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		parseParentSettings();
		var akismetSettings = controller.getConfigSettings().akismet;
		
		// Map Akismet Library
		binder.map( "Akismet@Akismet" )
			.to( "#moduleMapping#.Akismet" )
			.initArg( name="blogURL", 			value=akismetSettings.blogURL )
			.initArg( name="apiKey", 			value=akismetSettings.apiKey )
			.initArg( name="applicationName", 	value=akismetSettings.applicationName )
			.initArg( name="HTTPTimeout", 		value=akismetSettings.HTTPTimeout );
	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){
	}

	/**
	* parse parent settings
	*/
	private function parseParentSettings(){
		var oConfig 		= controller.getSetting( "ColdBoxConfig" );
		var configStruct 	= controller.getConfigSettings();
		var akismetDSL 		= oConfig.getPropertyMixin( "akismet", "variables", structnew() );

		//defaults
		configStruct.akismet = variables.settings;

		// incorporate settings
		structAppend( configStruct.akismet, akismetDSL, true );
	}

}