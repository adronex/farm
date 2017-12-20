package com.company.interpreters;

import org.luaj.vm2.Globals;
import org.luaj.vm2.LuaValue;
import org.luaj.vm2.lib.jse.JsePlatform;

public class LuaInterpreterCaller implements InterpreterCaller {

	private final LuaValue functionContext;

	public LuaInterpreterCaller() {
		Globals globals = JsePlatform.standardGlobals();
		LuaValue[] scripts = {
				LuaValue.valueOf("lua/libs/json.lua"),
				LuaValue.valueOf("lua/api.lua"),
				LuaValue.valueOf("lua/item.lua"),
				LuaValue.valueOf("lua/shop.lua"),
				LuaValue.valueOf("lua/bag.lua"),
				LuaValue.valueOf("lua/farm.lua")
		};
		functionContext = globals.get("dofile").invoke(scripts).arg1();
	}

	@Override
	public void setState(String savedState) {
		if (savedState == null) {
			savedState = "{}";
		}
		functionContext.call(LuaValue.valueOf(savedState));
	}

	@Override
	public String executeCommand(String requestBody) {
		return functionContext.call(LuaValue.valueOf(requestBody)).tojstring();
	}
}
