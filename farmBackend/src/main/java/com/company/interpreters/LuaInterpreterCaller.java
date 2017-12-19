package com.company.interpreters;

import javax.script.Invocable;
import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;
import javax.script.ScriptException;
import java.io.InputStreamReader;

public class LuaInterpreterCaller implements InterpreterCaller {

	private final Invocable invocable;

	public LuaInterpreterCaller() throws ScriptException {
		ScriptEngineManager manager = new ScriptEngineManager();
		ScriptEngine engine = manager.getEngineByName("luaj");
		engine.eval(new InputStreamReader(getClass().getClassLoader().getResourceAsStream("lua/libs/json.lua")));
		engine.eval(new InputStreamReader(getClass().getClassLoader().getResourceAsStream("lua/api.lua")));
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
