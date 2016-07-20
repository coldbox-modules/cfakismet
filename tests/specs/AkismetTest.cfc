component extends="testbox.system.BaseSpec"{
/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
	}

	function afterAll(){
	}

/*********************************** BDD SUITES ***********************************/

	function run(){

		// Akismet model
		describe( "Akismet Model", function(){

			beforeEach(function(){
				apiKey = fileRead( getDirectoryFromPath( getMetadata( this ).path ) & "apikey.txt" );
				akismet = new root.Akismet(
					blogURL = "http://www.coldbox.org",
					apiKey  = apiKey,
					applicationName = "AkismetTest"
				);
			});

			it("has an Akismet API version", function(){
				expect( akismet.getAKismetVersion() ).toBe( 1.1 );		
			});

			it("builds correct API User agent", function(){
				expect( akismet.getAPIUserAgent() )
					.toInclude( "AkismetTest" );
			});

			it("builds correct API URLs", function(){
				expect( akismet.getAPIURL() )
					.toBe( "http://#apiKey#.rest.akismet.com/1.1/");
				
				expect( akismet.getAPIURL( akismet.getVerifyKeyPath() ) )
					.toBe( "http://#apiKey#.rest.akismet.com/1.1/verify-key");
				
				expect( akismet.getAPIURL( akismet.getVerifyKeyPath(), "" ) )
					.toBe( "http://rest.akismet.com/1.1/verify-key");
			});

			it("can verify a bad key", function(){
				expect( akismet.verifyKey( 1238747474 ) ).toBeFalse();
			});

			it("can verify a good key", function(){
				expect( akismet.verifyKey() ).toBeTrue();
			});

			it( "can test a bad comment", function(){
				expect(	akismet.isCommentSpam( 
					author = "viagra-test-123",
					authorEmail = "viagra-test-123",
					authorURL = "viagra-test-123",
					content="I sell viagra",
					permalink = "http://www.luismajano.com/blog/cfml-coding-guidelines-formatter"
				) );
			});

			it( "can test a good comment", function(){
				expect(	akismet.isCommentSpam( 
					author = "Luis Majano",
					authorEmail = "lmajano@coldbox.org",
					authorURL = "http://www.luismajano.com",
					content="Not Sure if sublime supports custom formatters. But my application does.",
					permalink = "http://www.luismajano.com/blog/cfml-coding-guidelines-formatter"
				) );
			});

		});

	}

}