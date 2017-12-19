using NiL.JS.BaseLibrary;
using NiL.JS.Core;
using NiL.JS.Extensions;

public class NilJsScriptHolder : AbstractJsScriptHolder, IScriptHolder
{
    private readonly Context _context = new Context();
    
    public string GetData()
    {
        var concatFunction = _context.GetVariable("getDataAsString").As<Function>();
        return concatFunction.call(new Arguments()).ToString();
    }

    public override void Eval(string script)
    {
        _context.Eval(script, true);
    }
}