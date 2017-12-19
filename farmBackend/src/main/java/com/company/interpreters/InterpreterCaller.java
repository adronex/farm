package com.company.interpreters;

import javax.script.ScriptException;

public interface InterpreterCaller {
	void setState(String savedState) throws ScriptException, NoSuchMethodException;

	String executeCommand(String requestBody) throws ScriptException, NoSuchMethodException;
}
