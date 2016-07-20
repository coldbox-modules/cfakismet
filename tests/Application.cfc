component{
	this.name = "Akismet Testing Suite";
	this.sessionManagement = true;

	// mappings
	this.mappings[ "/tests" ] = getDirectoryFromPath( getCurrentTemplatePath() );

	rootPath = REReplaceNoCase( this.mappings[ "/tests" ], "tests(\\|\/)$", "" );
	this.mappings[ "/root" ] = rootPath;
	
	// request start
	public boolean function onRequestStart(String targetPage){

		return true;
	}
}