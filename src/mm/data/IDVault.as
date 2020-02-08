package mm.data {
	
	public class IDVault extends Object {
		
		// consts
		
		private static const MIN_CHARS:uint = 6;
		private static const CHAR_MAP_DEFAULT:Array = ("0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz").split("");
		private static const CHAR_MAP_NUMERALS:Array = ("0123456789").split("");
		private static const CHAR_MAP_LOWERCASE:Array = ("abcdefghiklmnopqrstuvwxyz").split("");
		private static const CHAR_MAP_UPERCASE:Array = ("ABCDEFGHIJKLMNOPQRSTUVWXTZ").split("");
		
		// vars
		
		private var _idList:Vector.<String> = new <String>[];
		
		// utils
		
		private static function copyData(data:*):* {
			return JSON.parse(JSON.stringify(data));
		}
		
		public static function generateID(uniqueChars:Boolean = false, idLength:uint = 0, prefix:String = "", suffix:String = "", map:Array = null):String {
			var id:String = "";
			var charMap:Array = map ? copyData(map) : copyData(CHAR_MAP_DEFAULT);
			
			if (idLength < MIN_CHARS) idLength = MIN_CHARS;
			if (idLength > charMap.length) idLength = charMap.length;
			
			while (id.length < idLength) {
				var rn:uint = Math.floor(Math.random() * charMap.length);
				id += charMap[rn];
				if (uniqueChars) charMap.splice(rn, 1);
			}
			
			return (prefix + id + suffix);
		}
		
		// singleton
		
		private static var _instance:IDVault;
		
		public static function instance():IDVault {
			if (!_instance) _instance = new IDVault();
			return _instance;
		}
		
		// constructor
		
		public function IDVault():void {
			if (!_instance) _instance = this;
		}
		
		// list stuff
		
		public function traceIDList():void {
			trace(_idList);
		}
		
		public function getIDList():Vector.<String> {
			var vec:Vector.<String> = new <String>[];
			for (var i:uint = 0; i < _idList.length; i++) {
				vec.push(_idList[i]);
			}
			return vec;
		}
		
		public function purgeIDList():void {
			_idList = new <String>[];	
		}
		
		// create unique id
		
		public function newID(uniqueChars:Boolean = false, idLength:uint = 0, prefix:String = "", suffix:String = "", map:Array = null, updateVault:Boolean = true):String {
			var id:String = generateID(uniqueChars, idLength, prefix, suffix, map);
			while (findID(id) != -1) id = newID(uniqueChars, idLength);
			if (updateVault) addID(id);
			return id;
		}
		
		// add (custom) id
		
		public function addID(str:String):void {
			if (findID(str) != -1) null; // trace("ID \"" + str + "\" already exists!");
			else _idList.push(str);
			//trace("ID \"" + str + "\" added!");
		}
		
		// find id
		
		public function findID(str:String):int {
			if (_idList) return _idList.indexOf(str);
			//trace("ID \"" + str + "\" not found!");
			return -1;
		}
		
		// remove id
		
		public function removeID(str:String):void {
			var index:int = findID(str);
			if (index >= 0) _idList.splice(index, 1);
			else null; // trace("ID \"" + str + "\" not found!");
		}
		
	}
}