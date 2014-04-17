<cfsilent>
	<!---
		PURPOSE: Read in a WASL xml file, extra descriptive elements from it

		todo:
	--->
	<cfif StructKeyExists(application,'xmlDoc')>
		<cfset myDoc = application.xmlDoc />
	<cfelse>
		<cfdump var="XML Structure does not exist."><cfabort />
	</cfif>
</cfsilent><html>
<head>
	<link href='http://fonts.googleapis.com/css?family=Exo:400,900,300' rel='stylesheet' type='text/css'>
	<script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js" ></script>	
	<script src="jquery.tinysort.min.js" ></script>
	<style>
		* {
			padding:0;
			margin:0;
		}
		body { 
			font-size:16px;
			padding:1em;
			font-family: 'Exo', sans-serif;
			font-weight:300;
		}
		div {
			border-bottom:1px solid #aaa;
		}
		footer {
			margin-top:1em;
			font-size: 0.85em;
			text-align:right;
		}
		h1 {
			font-size: 3em;
			font-weight:900;
			font-family: 'Exo', sans-serif;
		}
		h2 {
			font-size: 1.5em;
			font-weight:400;
			font-family: 'Exo', sans-serif;
		}
		input {
			padding:0.5em;
		}
		li {
			font-size:0.8em;
			padding:0.25em;
			clear:both;
		}
		nav {
			padding-top:0.5em;
			padding-bottom:0.5em;
		}
		ul {
			list-style:none;
		}
		.authentication {
			width:5em;
			display:inline-block;
		}
		.resourcePath {
			width:25em;
			display:inline-block;
		}
		.methodType {
			width:5em;
			display:inline-block;
		}
		.navlink {
			padding:0.3em;
			border-radius:0.2em;
			background-color:#ccc;
			color:#333;
			font-size:0.8em;
		}
		.status {
			width:10em;
			display:inline-block;
		}
		.status_done {
			padding-top:0.1em;
			padding-bottom:0.1em;
			padding-left:0.5em;
			padding-right:0.5em;
			background-color:#009900;
			color:#ccc;
			border-radius: 0.4em;
		}
		.status_warning {
			padding-top:0.1em;
			padding-bottom:0.1em;
			padding-left:0.5em;
			padding-right:0.5em;
			background-color:#999900;
			color:#111;
			border-radius: 0.4em;
		}
		.status_alert {
			padding-top:0.1em;
			padding-bottom:0.1em;
			padding-left:0.5em;
			padding-right:0.5em;
			background-color:#990000;
			color:#ccc;
			border-radius: 0.4em;			
		}
		.status_delayed {
			padding-top:0.1em;
			padding-bottom:0.1em;
			padding-left:0.5em;
			padding-right:0.5em;
			background-color:#000000;
			color:#ccc;
			border-radius: 0.4em;			
		}
		.status_postponed {
			padding-top:0.1em;
			padding-bottom:0.1em;
			padding-left:0.5em;
			padding-right:0.5em;
			background-color:#666666;
			color:#aaa;
			border-radius: 0.4em;			
		}
		.userDescription {
			width:20em;
			display:inline-block;
		}
		#headerBar {
			font-size:0.8em;
			font-weight:bold;
		}
		#resourceList li {
			background: #fff; 
		}
		#resourceList li:nth-child(odd) { 
			background: #efefef; 
		}
	</style>
</head>
<body>
	<h1>Ginnungagap [gin-oong-gah-gahp]</h1>
	<h2>The yawning void between the spark of an idea and cold reality.</h2>
	<!--- resources have the path 'application.resources.resource' --->
	<nav>
		<input type="button" value="Sort by Resource" id="sortByResource" onclick="sortByResource()" />
		<input type="button" value="Sort by Method" id="sortByMethod" onclick="sortByMethod()" />
		<input type="button" value="Sort by Status" id="sortByStatus" onclick="sortByStatus()" />
		<input type="hidden" id="sortorder" value="asc" />
		 <a href="shoptopia_WADL.xml" target="new" class="navlink">Detailed API XML &#1769;</a>
		 <a href="https://apigee.com/mreinbold/embed/console/shoptopia" target="new" class="navlink">apigee Console &#1769;</a>
		 <a href="https://api.shoptopia.com/v1/" target="new" class="navlink">Interactive Browser &#1769;</a>
	</nav>

	<cfset aResources = mydoc.application.resources />
	<!--- <cfdump var="#arrayLen(aResources.xmlChildren)#" />--->
	<div id="headerBar">
		<span class="resourcePath">Resource Path</span>
		<span class="userDescription">User Description</span>
		<span class="methodType">Method</span>
		<span class="authentication">Auth</span>
		<span class="status">Status</span>
	</div>
	<cfoutput>
	<ul id="resourceList">
	<cfloop index="i" from="1" to="#ArrayLen(aResources.xmlChildren)#">
		<cfset myResource = aResources.xmlChildren[i] />
		<!--- loop over the methods within the resource --->
		<cfloop index="j" from="1" to="#ArrayLen(myResource.xmlChildren)#">
			<cfif myResource.xmlChildren[j].xmlName eq "method">
				<cfset myMethod = myResource.xmlChildren[j] />
				<li id="#myMethod.xmlAttributes['id']#" title="#trim(myMethod.doc.xmlText)#">
					<span class="resourcePath">#aResources.xmlChildren[i].xmlAttributes['path']#</span>
					<span class="userDescription">#myMethod.xmlAttributes['apigee:displayName']#</span>
					<span class="methodType">#myMethod.xmlAttributes['name']#</span>
					<cfif StructKeyExists(myMethod,"apigee:authentication")>
						<cfif myMethod["apigee:authentication"].xmlAttributes['required'] eq "true">
							<cfset authRequired = "Yes" />
						<cfelse>
							<cfset authRequired = "No" />
						</cfif>
					<cfelse>
						<cfset authRequired = "Unknown" />
					</cfif>
					<span class="authentication">#authRequired#</span>
					<cfsilent>
						<cfif StructKeyExists(myMethod.doc.xmlAttributes,"title")>
							<cfset myStatus = trim(myMethod.doc.xmlAttributes['title']) /> 
							<!--- remove any assignment names --->
							<cfset mySpan = trim(ListGetAt(myStatus,1,"-")) />
						<cfelse>
							<cfset myStatus = "Unaccounted For" />
							<cfset mySpan = "Unaccounted For" />							
						</cfif>
						<!--- color coding the status --->
						<cfswitch expression="#mySpan#">
							<cfcase value="Done,Wired">
								<cfset myStatus = "<span class='status_done'>" & myStatus & "</span>" />
							</cfcase>
							<cfcase value="In Progress">
								<cfset myStatus = "<span class='status_warning'>" & myStatus & "</span>" />
							</cfcase>
							<cfcase value="Not Ready">
								<cfset myStatus = "<span class='status_alert'>" & myStatus & "</span>" />
							</cfcase>
							<cfcase value="Post April 1st">
								<cfset myStatus = "<span class='status_delayed'>" & myStatus & "</span>" />
							</cfcase>
							<cfcase value="Post Launch">
								<cfset myStatus = "<span class='status_postponed'>" & myStatus & "</span>" />
							</cfcase>
						</cfswitch>
					</cfsilent>
					<span class="status">
						#myStatus#
					</span>
				</li>
			</cfif>
		</cfloop>
	</cfloop>
	</ul>
	</cfoutput>

	<footer>
	<p>The Ginnungagap code is available <a href="https://github.com/MatthewReinbold/Ginnungagap">on Github</a>.</p> 
	</footer>

	<script>
		var $Ul = $('ul#resourceList');
		$Ul.css({position:'relative',height:$Ul.height(),display:'block'});
		var iLnH;
		var $Li = $('ul#resourceList>li');
		$Li.each(function(i,el){
			var iY = $(el).position().top;
			$.data(el,'h',iY);
			if (i===1) iLnH = iY;
		});

		function sortByResource() {
			var mySort = $('#sortorder').val();
			$('#sortorder').val( mySort == 'asc' ? 'desc':'asc' );
			//$('ul#resourceList>li').tsort();
			$('ul#resourceList>li').tsort({order:mySort}).each(function(i,el){
				var $El = $(el);
				var iFr = $.data(el,'h');
				var iTo = i*iLnH;
				$El.css({position:'absolute',top:iFr}).animate({top:iTo},500);
			});
		}

		function sortByMethod() {
			var mySort = $('#sortorder').val();
			$('#sortorder').val( mySort == 'asc' ? 'desc':'asc' );			
			$('ul#resourceList>li').tsort('span:eq(2)',{order:mySort}).each(function(i,el){
				var $El = $(el);
				var iFr = $.data(el,'h');
				var iTo = i*iLnH;
				$El.css({position:'absolute',top:iFr}).animate({top:iTo},500);
			});
		}
		function sortByStatus() {
			var mySort = $('#sortorder').val();
			$('#sortorder').val( mySort == 'asc' ? 'desc':'asc' );
			$('ul#resourceList>li').tsort('span:eq(4)',{order:mySort}).each(function(i,el){
				var $El = $(el);
				var iFr = $.data(el,'h');
				var iTo = i*iLnH;
				$El.css({position:'absolute',top:iFr}).animate({top:iTo},500);
			});
		}
	</script>
</body>
</html>
