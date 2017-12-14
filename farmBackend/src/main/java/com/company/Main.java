package com.company;

import javax.script.ScriptException;

import static spark.Spark.*;

public class Main {

	public static void main(String[] args) throws ScriptException {
		RequestHandler requestHandler = new RequestHandler();
		initSpark(requestHandler);
	}

	private static void initSpark(RequestHandler requestHandler) {
		staticFileLocation("/");
		options("/*", (request, response) -> {
			String accessControlRequestHeaders = request.headers("Access-Control-Request-Headers");

			if (accessControlRequestHeaders != null) {
				response.header("Access-Control-Allow-Headers", accessControlRequestHeaders);
			}
			String accessControlRequestMethod = request.headers("Access-Control-Request-Method");

			if (accessControlRequestMethod != null) {
				response.header("Access-Control-Allow-Methods", accessControlRequestMethod);
			}
			return "OK";
		});
		before((request, response) -> response.header("Access-Control-Allow-Origin", "*"));
		post("/game/execute", requestHandler::handleRequest);
	}
}