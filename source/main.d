import vibe.core.core : runApplication;
import vibe.http.server;
import vibe.http.fileserver;
import vibe.http.router;
import vibe.core.log;
import vibe.core.file;
import vibe.core.args;
import vibe.data.json;
import vibe.core.path;
import std.conv: to;
import std.file;
import std.algorithm.searching;

import php_mod;

void main(string[] args){
	setLogFormat(FileLogger.Format.plain);
	ushort port = 8080;
	string bindAddress = "127.0.0.1";
	string server_path = "./";
	auto settings = new HTTPServerSettings;

	if(exists("config.json")){
		logInfo("Using config");
		try{
			Json config = parseJsonString(readText("config.json"),"config.json");
			if(config["port"].type==Json.Type.undefined){
				logInfo("Missing \"port\"");
				return;
			}
			port = config["port"].get!ushort;
			if(config["server_path"].type==Json.Type.undefined){
				logInfo("Missing \"server_path\"");
				return;
			}
			server_path = config["server_path"].get!string;
			if(config["address"].type!=Json.Type.undefined){
				bindAddress = config["address"].get!string;
			}
			if(config["gzip"].type!=Json.Type.undefined){
				settings.useCompressionIfPossible = config["gzip"].get!bool;
				logInfo("Using compression: "~config["gzip"].to!string);
			}
		}catch(std.json.JSONException ex){
			logInfo(ex.msg);
			return;
		}
	}else if(args.length<3){
			logInfo("Usage:\n\t"~args[0]~" [address] port folder");
			return;
	}else{
		if(args.length==4){
			port = args[2].to!ushort;
			bindAddress = args[1];
		}else{
			port = args[1].to!ushort;
		}
		server_path = args[$-1];
	}
	import std.path;
	auto p = NativePath(absolutePath(server_path));
	p.normalize();
	logInfo("Serving files from '"~p.toNativeString()~"'");
	setCommandLineArgs([]);
	auto router = new URLRouter;
	router.any("*", handleAll(server_path));

	settings.port = port;
	settings.bindAddresses = [bindAddress];
	settings.accessLogToConsole = true;
	auto l = listenHTTP(settings, router);
	scope (exit) l.stopListening();
	runApplication();
}
@system void delegate(HTTPServerRequest req, HTTPServerResponse res) handleAll(string server_path){
	void phpHandler(HTTPServerRequest req, HTTPServerResponse res){
		string path = req.path;
		string filePath=server_path~path;
		FileInfo dirent;
		try dirent = getFileInfo(filePath);
		catch(Exception){
			throw new HTTPStatusException(HTTPStatus.InternalServerError, "Failed to get information for the file due to a file system error.");
		}
		res.contentType("text/html");
		if (dirent.isDirectory) {
			if(exists(filePath~"/index.php")){
				runPHP(filePath~"/index.php", req, res);
				return;
			}
		}else if(path.endsWith(".php")){
			if(exists(filePath)){
				runPHP(filePath, req, res);
				return;
			}
		}
		sendFile(req, res, NativePath(filePath));
	}
	return &phpHandler;
}
