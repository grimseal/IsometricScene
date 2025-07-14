package;

#if macro
import haxe.macro.Context;
import haxe.macro.Type;
import haxe.macro.TypeTools;

using haxe.macro.Tools;
#end

class ClassList {
	static var NAME = 'ClassList'; // must be the fully qualified name of this class

	// macro static function build() {
	// 	Context.onGenerate(function(types) {
	// 		var names = [], self = TypeTools.getClass(Context.getType(NAME));
	// 		for (t in types)
	// 			switch t {
	// 				case TInst(_.get() => c, _):
	// 					if (!hasMeta(c.meta, ':system'))
	// 						continue;
	// 					var name:Array<String> = c.pack.copy();
	// 					name.push(c.name);
	// 					names.push(Context.makeExpr(name.join("."), c.pos));
	// 				default:
	// 			}
	// 		// self.meta.remove('systems');
	// 		// self.meta.add('systems', names, self.pos);
	// 	});
	// 	return macro cast haxe.rtti.Meta.getType($p{NAME.split('.')});
	// }

	static function hasMeta(meta:haxe.macro.Type.MetaAccess, name:String):Bool {
		for (m in meta.get()) {
			if (m.name == name)
				return true;
		}
		return false;
	}

	#if !macro
	static public var foo:Int = 42;
	// static public var systems:Array<String> = build();
	#end
}
