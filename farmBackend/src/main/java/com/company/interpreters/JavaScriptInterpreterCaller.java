package com.company.interpreters;

import javax.script.Invocable;
import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;
import javax.script.ScriptException;
import java.io.InputStreamReader;

public class JavaScriptInterpreterCaller implements InterpreterCaller {

	private final Invocable invocable;

	public JavaScriptInterpreterCaller() throws ScriptException {
		ScriptEngineManager manager = new ScriptEngineManager();
		ScriptEngine engine = manager.getEngineByName("js");
		engine.eval(new InputStreamReader(getClass().getClassLoader().getResourceAsStream("js/api.js")));
		engine.eval(new InputStreamReader(getClass().getClassLoader().getResourceAsStream("js/item.js")));
		engine.eval(new InputStreamReader(getClass().getClassLoader().getResourceAsStream("js/staticData.js")));
		engine.eval(new InputStreamReader(getClass().getClassLoader().getResourceAsStream("js/shop.js")));
		engine.eval(new InputStreamReader(getClass().getClassLoader().getResourceAsStream("js/bag.js")));
		engine.eval(new InputStreamReader(getClass().getClassLoader().getResourceAsStream("js/farm.js")));
		this.invocable = (Invocable) engine;
	}

	@Override
	public void setState(String savedState) throws ScriptException, NoSuchMethodException {
		if (savedState != null) {
			invocable.invokeFunction("setStateFromString", savedState);
		} else {
			invocable.invokeFunction("setStateFromString", "{}");
		}
	}

	@Override
	public String executeCommand(String requestBody) throws ScriptException, NoSuchMethodException {
		return (String)invocable.invokeFunction("commandHandler", requestBody);
	}
}
