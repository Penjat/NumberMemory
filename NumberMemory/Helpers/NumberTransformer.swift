import Foundation
import UIKit


class NumberTransformer {
	let personAttributes: [NSAttributedString.Key : Any] = {
		let outputFont = UIFont.systemFont(ofSize: 16)
		return [NSAttributedString.Key.font: outputFont, NSAttributedString.Key.foregroundColor : UIColor.darkGray]
	}()

	let actionAttributes: [NSAttributedString.Key : Any] = {
		let outputFont = UIFont.systemFont(ofSize: 15)
		return [NSAttributedString.Key.font: outputFont, NSAttributedString.Key.foregroundColor: UIColor.gray]
	}()

	let objectAttributes: [NSAttributedString.Key : Any] = {
		let outputFont = UIFont.systemFont(ofSize: 15)
		return [NSAttributedString.Key.font: outputFont, NSAttributedString.Key.foregroundColor: UIColor.orange]
	}()

	func transform(numberText: String) -> NSAttributedString {
		switch numberText.count {
		case 1:
			let index = Int(numberText) ?? 0
			return NSAttributedString(string: objects[index], attributes: objectAttributes)
		case 2:
			let index = Int(numberText) ?? 0

			return NSAttributedString(string: people[index], attributes: personAttributes)
		case 3:
			let personIndex = Int(numberText.prefix(2)) ?? 0
			let objectIndex = Int(numberText.suffix(1)) ?? 0
			let output = NSMutableAttributedString()
			output.append(NSAttributedString(string: people[personIndex], attributes: personAttributes))
			output.append(NSAttributedString(string:" "))
			output.append(NSAttributedString(string: objects[objectIndex], attributes: objectAttributes))
			return output
		case 4:
			let personIndex = Int(numberText.prefix(2)) ?? 0
			let actionIndex = Int(numberText.dropFirst(2)) ?? 0
			let output = NSMutableAttributedString()
			output.append(NSAttributedString(string: people[personIndex], attributes: personAttributes))
			output.append(NSAttributedString(string:"\n"))
			output.append(NSAttributedString(string: actions[actionIndex], attributes: actionAttributes))
			output.append(NSAttributedString(string:"\n"))
			return output
		default:
			let output = NSMutableAttributedString()
			output.append(transform(numberText: String(numberText.prefix(4))))
			output.append(transform(numberText: String(numberText.dropFirst(4))))
			output.append(NSAttributedString(string:"\n"))
			return  output
		}
	}
	func toPerson(from number: Int ) -> String {
		guard number < 100, number >= 0 else {
			fatalError()
		}
		return people[number];
	}

	func toAction(from number: Int) -> String {
		guard number < 100, number >= 0 else {
			fatalError()
		}
		return actions[number];
	}

	public let objects = [
		"SUN",
		"DILDO",
		"SNAKE",
		"HAND CUFFS",
		"SAIL BOAT",
		"FIRE",
		"TUMBLE WEED",
		"SWORD CUT",
		"VAGINA",
		"ELEPHANT"
	]

	public let people = ["OLIVE OIL",
						 "PROFFESOR OAK",
						 "OBIWAN KENOBI",
						 "DR OCTOPUS",
						 "ODIN",
						 "OEDIPUS",
						 "OSCAR THE GROTCH",
						 "OL DIRTY BASTARD",
						 "OLIVER TWIST",
						 "OWEN WILSON",
						 "ARISTOLE ONASIS",
						 "ALAN ALDA",
						 "ALI BABA",
						 "ALEXANDRIA CORTES",
						 "JUDAS",
						 "ALBERT EINSTIEN",
						 "PIGGY",
						 "ALLADIN",
						 "ALLAN TURNING",
						 "ANN",
						 "BO JACKSON",
						 "BEN ARSCOT",
						 "BB KING",
						 "JESUS",
						 "BLACK DRACULA",
						 "BABARA EBBESON",
						 "BEN SHAPIRO",
						 "MICHEAL BLOOTH",
						 "BARTMAN",
						 "BARNY GUMBLE",
						 "COLLOSUS",
						 "CAPTAIN AMERICA",
						 "MICHELLANGELO",
						 "CHARLIE CHAPLIN",
						 "CAPTAIN DEADPOOL",
						 "CLINT EASTWOON",
						 "CS LEWIS",
						 "CHUNG LEE",
						 "CAT WOMAN",
						 "CHUCK NORRIS",
						 "HOMER SIMPSON",
						 "DAVID ATTENBOUROGH",
						 "DAVID BOWIE",
						 "SUPERMAN",
						 "DOLLY PARTON",
						 "DOC ELLIS",
						 "DR SEUSS",
						 "DAVID LYNCH",
						 "DONALD TRUMP",
						 "DUKE NUKEM",
						 "ELIZABETH OLSON",
						 "ERIC ANDRE",
						 "EVA BRAUN",
						 "EMILY CARR",
						 "EL DIABLO",
						 "EEK THE CAT",
						 "ED SHEREN",
						 "L (DEATH NOTE)",
						 "E.T.",
						 "EDWARD NORTON",
						 "SHACKELL O'NEEL",
						 "STONE COLD STEVE AUSTIN",
						 "SUSAN B. ANTHONY",
						 "SEAN CONERY",
						 "SAMMY DAVIS JR",
						 "HARRISON FORD",
						 "SABRINA SYMINGTON",
						 "SHIA LE BEUFF",
						 "SHIRLY TEMPLE",
						 "ST. NICK",
						 "LEE HARVEY OSWALD",
						 "LANCE ARMSTRONG",
						 "LIZZY BORDEN",
						 "LOUIS C.K.",
						 "LARRY DAVID",
						 "LIEAF ERRIKSON",
						 "LISA SIMPSON",
						 "LL COOL J",
						 "LOUIS THOREUX",
						 "LIAM NEELSON",
						 "TOM HOLLAND",
						 "TIM ALLAN",
						 "TIM BAILY",
						 "TERRY CRUZ",
						 "TED DANZEN",
						 "THOMAS EDDISON",
						 "TS ELLIOT",
						 "TOMMY LEE JONES",
						 "TINY TIM",
						 "TED NUGET",
						 "NICK OFFERMAN",
						 "NEIL ARMSTRONG",
						 "DENISS RODMAN",
						 "NICHOLAS CAGE",
						 "NED FLANDERS",
						 "NELSON",
						 "NINA SIMONE",
						 "MIKE",
						 "NICKOLA TESLA",
						 "NAUGHTY BY NATURE"]

	let actions = ["eating spinach",
				   "throwing a pokeball",
				   "with a lightsaber",
				   "with metal octopus arms",
				   "sporting an eye patch",
				   "holding a bloody knife",
				   "in a garbage can",
				   "wearing low pants",
				   "holding a bowl o porage",
				   "...wow...",
				   "carrying an oil can",
				   "performing surgery",
				   "cave opening",
				   "speaking at podium",
				   "recieving pieces of silver",
				   "writting on chalk board",
				   "taking inhaler",
				   "on a magic carpet",
				   "a computer prints off from their chest",
				   "is making coffee",
				   "is hitting hitting baseball",
				   "is playing bass",
				   "is playing blues guitar",
				   "in robes and sandles",
				   "dancing funk",
				   "making pie",
				   "teeth flying",
				   "peeling banana",
				   "skate boarding",
				   "drinking burping",
				   "collosus skin",
				   "throwing shield",
				   "twirling nun chucks",
				   "dancing with cane",
				   "coke under mask",
				   "getting shot with revolver",
				   "getting pulled into narnia",
				   "kicking furriously",
				   "michelle fiffer moves",
				   "high kick jeans",
				   "saying do'h",
				   "observing from bushes",
				   "face paint",
				   "lifting car",
				   "looking great",
				   "taking lsd",
				   "crazy instrument",
				   "breath of oxygen",
				   "cut in half by chain saw",
				   "gernade launcher",
				   "hands on hips",
				   "smashing set",
				   "shooting self in head",
				   "painting",
				   "fire",
				   "falling",
				   "playing guitar",
				   "intense look",
				   "finger glowing",
				   "gang tat",
				   "genie head nod",
				   "choke slam",
				   "sitting in a rocking chair with a shotgun",
				   "drinking martini",
				   "adjusts cufflinks",
				   "shoots blaster",
				   "drawing at easal",
				   "just do it",
				   "tap dancing",
				   "giving gifts",
				   "grassy knoll",
				   "riding speed bike",
				   "axe and pigtails",
				   "being gross",
				   "overreacting",
				   "helmet",
				   "pearls and dress",
				   "mic",
				   "interviewing",
				   "talking on phone",
				   "spider web",
				   "tools grunting",
				   "on knees",
				   "lifting wieghts",
				   "dancing in suit",
				   "holding up light bulb",
				   "reading book",
				   "gun on waterfall",
				   "crutch, god bless us",
				   "dog poop in face",
				   "cooking bacon",
				   "space walking",
				   "dunking",
				   "not the bees",
				   "flanders mustach",
				   "laughing 'hA, Ha'",
				   "singin at piano",
				   "ia a yello rain jacket",
				   "telsa coil sparking",
				   "is posing for their rap album"]
}
