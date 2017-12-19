package com.company;

import javax.script.Invocable;
import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;
import javax.script.ScriptException;
import java.io.InputStreamReader;

public class ScriptCaller {

	private final Invocable invocable;

	public ScriptCaller() throws ScriptException {
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

	public void setState(String savedState) throws ScriptException, NoSuchMethodException {
		if (savedState != null) {
			invocable.invokeFunction("setStateFromString", savedState);
		} else {
			invocable.invokeFunction("setStateFromString", "{}");
		}
	}

	public String executeCommand(String requestBody) throws ScriptException, NoSuchMethodException {
		return (String)invocable.invokeFunction("commandHandler", requestBody);
	}

//	public void callLua() {
//		Globals globals = JsePlatform.standardGlobals();
//		LuaValue chunk = globals.loadfile("lua/api.lua");
//		chunk.call();
//	}
}
