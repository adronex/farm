package com.company;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import spark.Request;
import spark.Response;

import javax.script.ScriptException;
import java.util.HashMap;
import java.util.Map;

public class RequestHandler {
	private static final Logger LOG = LoggerFactory.getLogger(RequestHandler.class);
	private ScriptCaller scriptCaller = new ScriptCaller();
	private Map<String, String> usersSessions = new HashMap<>();

	public RequestHandler() throws ScriptException {
	}

	public synchronized String handleRequest(Request request, Response response) {
		try {
			scriptCaller.setState(usersSessions.get(request.ip()));
			String gameState = scriptCaller.executeCommand(request.body());
			usersSessions.put(request.ip(), gameState);
			response.body(gameState);
			return gameState;
		} catch (NoSuchMethodException | ScriptException e) {
			LOG.error(e.getMessage(), e);
			response.status(400);
			response.body(e.getMessage());
			return response.body();
		}
	}
}
